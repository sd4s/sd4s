CREATE OR REPLACE PACKAGE BODY iapiSpecificationFreeText
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

   
   
   
   FUNCTION MANIPULATETEXT(
      ALTEXT                     IN       IAPITYPE.CLOB_TYPE )
      RETURN IAPITYPE.CLOB_TYPE
   IS
       
       
       
      
       
       
       
       
       
       
      LLSTRINGOLD                   SPECIFICATION_TEXT.TEXT%TYPE := NULL;
      LLSTRINGNEW                   SPECIFICATION_TEXT.TEXT%TYPE := NULL;
      LNPOSITION                    NUMBER( 10 );
   BEGIN
      LLSTRINGOLD := ALTEXT;

      IF LENGTH( LLSTRINGOLD ) > 0
      THEN
         LOOP
            EXIT WHEN LENGTH( LLSTRINGOLD ) = 0;
            LNPOSITION := INSTR( LLSTRINGOLD,
                                 CHR( 10 ) );

            IF LNPOSITION = 0
            THEN
               LLSTRINGNEW :=    LLSTRINGNEW
                              || LLSTRINGOLD;
               EXIT;
            ELSIF     INSTR( LLSTRINGOLD,
                                CHR( 13 )
                             || CHR( 10 ),
                             1 ) > 0
                  AND INSTR( LLSTRINGOLD,
                                CHR( 13 )
                             || CHR( 10 ),
                             1 ) =   LNPOSITION
                                   - 1
            THEN
               LLSTRINGNEW :=    LLSTRINGNEW
                              || SUBSTR( LLSTRINGOLD,
                                         1,
                                         LNPOSITION );
               LLSTRINGOLD := SUBSTR( LLSTRINGOLD,
                                        LNPOSITION
                                      + 1 );
            ELSE
               LLSTRINGNEW :=    LLSTRINGNEW
                              || REPLACE( SUBSTR( LLSTRINGOLD,
                                                  1,
                                                  LNPOSITION ),
                                          CHR( 10 ),
                                             CHR( 13 )
                                          || CHR( 10 ) );
               LLSTRINGOLD := SUBSTR( LLSTRINGOLD,
                                        LNPOSITION
                                      + 1 );
            END IF;
         END LOOP;
      END IF;

      RETURN LLSTRINGNEW;
   END MANIPULATETEXT;

   
   
   
   
   PROCEDURE CHECKBASICFREETEXTPARAMS(
      ARFREETEXT                 IN       IAPITYPE.SPFREETEXTREC_TYPE )
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckBasicFreeTextParams';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESSLEVEL                 IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ARFREETEXT.PARTNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PartNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartNo',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARFREETEXT.REVISION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Revision' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRevision',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARFREETEXT.SECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SectionId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSectionId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARFREETEXT.SUBSECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SubSectionId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSubSectionId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARFREETEXT.ITEMID IS NULL )
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

      IF F_CHECK_ITEM_ACCESS( ARFREETEXT.PARTNO,
                              ARFREETEXT.REVISION,
                              ARFREETEXT.SECTIONID,
                              ARFREETEXT.SUBSECTIONID,
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
                                                ARFREETEXT.PARTNO,
                                                ARFREETEXT.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARFREETEXT.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARFREETEXT.SUBSECTIONID,
                                                             0 ),
                                                'FREETEXT' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No Edit Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 0;

      IF F_CHECK_ITEM_ACCESS( ARFREETEXT.PARTNO,
                              ARFREETEXT.REVISION,
                              ARFREETEXT.SECTIONID,
                              ARFREETEXT.SUBSECTIONID,
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
                                                ARFREETEXT.PARTNO,
                                                ARFREETEXT.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARFREETEXT.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARFREETEXT.SUBSECTIONID,
                                                             0 ),
                                                'FREETEXT' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No View Section Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 2;

      IF F_CHECK_ITEM_ACCESS( ARFREETEXT.PARTNO,
                              ARFREETEXT.REVISION,
                              ARFREETEXT.SECTIONID,
                              ARFREETEXT.SUBSECTIONID,
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
                                                ARFREETEXT.PARTNO,
                                                ARFREETEXT.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARFREETEXT.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARFREETEXT.SUBSECTIONID,
                                                             0 ),
                                                'FREETEXT' );
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
   END CHECKBASICFREETEXTPARAMS;

   
   
   
   
   FUNCTION ADDFREETEXT(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANLANGUAGEID               IN       IAPITYPE.LANGUAGEID_TYPE DEFAULT 1,
      ALTEXT                     IN       IAPITYPE.CLOB_TYPE DEFAULT NULL,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddFreeText';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRFREETEXT                    IAPITYPE.SPFREETEXTREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LRFRAME                       IAPITYPE.FRAMEREC_TYPE;
      LBDOINSERT                    BOOLEAN;
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
      GTFREETEXTS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRFREETEXT.PARTNO := ASPARTNO;
      LRFREETEXT.REVISION := ANREVISION;
      LRFREETEXT.SECTIONID := ANSECTIONID;
      LRFREETEXT.SUBSECTIONID := ANSUBSECTIONID;
      LRFREETEXT.ITEMID := ANITEMID;
      LRFREETEXT.LANGUAGEID := ANLANGUAGEID;
      LRFREETEXT.TEXT := MANIPULATETEXT( ALTEXT );
      GTFREETEXTS( 0 ) := LRFREETEXT;

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

      
      LRFREETEXT.TEXT := MANIPULATETEXT( GTFREETEXTS( 0 ).TEXT );
      LRINFO := GTINFO( 0 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      
      
      
      
      CHECKBASICFREETEXTPARAMS( LRFREETEXT );

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
         IAPISPECIFICATIONSECTION.ADDSECTIONITEM( LRFREETEXT.PARTNO,
                                                  LRFREETEXT.REVISION,
                                                  LRFREETEXT.SECTIONID,
                                                  LRFREETEXT.SUBSECTIONID,
                                                  IAPICONSTANT.SECTIONTYPE_FREETEXT,
                                                  LRFREETEXT.ITEMID,
                                                  AFHANDLE => AFHANDLE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.ISACTIONALLOWED( LRFREETEXT.PARTNO,
                                                   LRFREETEXT.REVISION,
                                                   LRFREETEXT.SECTIONID,
                                                   LRFREETEXT.SUBSECTIONID,
                                                   IAPICONSTANT.SECTIONTYPE_FREETEXT,
                                                   LRFREETEXT.ITEMID,
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
                                                     LRFREETEXT.ITEMID,
                                                     IAPICONSTANT.SECTIONTYPE_FREETEXT,
                                                     LRFREETEXT.PARTNO,
                                                     LRFREETEXT.REVISION,
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRFREETEXT.SECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRFREETEXT.SUBSECTIONID, 0) ));
                                                     
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.GETFRAME( LRFREETEXT.PARTNO,
                                              LRFREETEXT.REVISION,
                                              LRFRAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      IF ( LRFREETEXT.TEXT IS NULL )
      THEN
         SELECT TEXT
           INTO LRFREETEXT.TEXT
           FROM FRAME_TEXT
          WHERE FRAME_NO = LRFRAME.FRAMENO
            AND REVISION = LRFRAME.REVISION
            AND OWNER = LRFRAME.OWNER
            AND SECTION_ID = LRFREETEXT.SECTIONID
            AND SUB_SECTION_ID = LRFREETEXT.SUBSECTIONID
            AND TEXT_TYPE = LRFREETEXT.ITEMID;

         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Got default text out of the frame',
                              IAPICONSTANT.INFOLEVEL_3 );
      END IF;

      LBDOINSERT := TRUE;

      
      
      IF ( ANLANGUAGEID <> 1 )
      THEN
         BEGIN
            IF ( LRFREETEXT.TEXT IS NULL )
            THEN
               
               LBDOINSERT := FALSE;
            END IF;

            INSERT INTO SPECIFICATION_TEXT
                        ( PART_NO,
                          REVISION,
                          TEXT_TYPE,
                          TEXT,
                          SECTION_ID,
                          SECTION_REV,
                          SUB_SECTION_ID,
                          SUB_SECTION_REV,
                          TEXT_TYPE_REV,
                          LANG_ID )
               SELECT PART_NO,
                      REVISION,
                      REF_ID,
                      LRFREETEXT.TEXT,
                      SECTION_ID,
                      SECTION_REV,
                      SUB_SECTION_ID,
                      SUB_SECTION_REV,
                      REF_VER,
                      1
                 FROM SPECIFICATION_SECTION
                WHERE PART_NO = LRFREETEXT.PARTNO
                  AND REVISION = LRFREETEXT.REVISION
                  AND SECTION_ID = LRFREETEXT.SECTIONID
                  AND SUB_SECTION_ID = LRFREETEXT.SUBSECTIONID
                  AND TYPE = IAPICONSTANT.SECTIONTYPE_FREETEXT
                  AND REF_ID = LRFREETEXT.ITEMID;
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
               NULL;   
         END;
      END IF;

      IF ( LBDOINSERT = TRUE )
      THEN
         INSERT INTO SPECIFICATION_TEXT
                     ( PART_NO,
                       REVISION,
                       TEXT_TYPE,
                       TEXT,
                       SECTION_ID,
                       SECTION_REV,
                       SUB_SECTION_ID,
                       SUB_SECTION_REV,
                       TEXT_TYPE_REV,
                       LANG_ID )
            SELECT PART_NO,
                   REVISION,
                   REF_ID,
                   LRFREETEXT.TEXT,
                   SECTION_ID,
                   SECTION_REV,
                   SUB_SECTION_ID,
                   SUB_SECTION_REV,
                   REF_VER,
                   LRFREETEXT.LANGUAGEID
              FROM SPECIFICATION_SECTION
             WHERE PART_NO = LRFREETEXT.PARTNO
               AND REVISION = LRFREETEXT.REVISION
               AND SECTION_ID = LRFREETEXT.SECTIONID
               AND SUB_SECTION_ID = LRFREETEXT.SUBSECTIONID
               AND TYPE = IAPICONSTANT.SECTIONTYPE_FREETEXT
               AND REF_ID = LRFREETEXT.ITEMID;
      END IF;

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRFREETEXT.PARTNO,
                                                       LRFREETEXT.REVISION,
                                                       LRFREETEXT.SECTIONID,
                                                       LRFREETEXT.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRFREETEXT.PARTNO,
                                                LRFREETEXT.REVISION );

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
   END ADDFREETEXT;

   
   FUNCTION SAVEFREETEXT(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANLANGUAGEID               IN       IAPITYPE.LANGUAGEID_TYPE,
      ALTEXT                     IN       IAPITYPE.CLOB_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveFreeText';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRFREETEXT                    IAPITYPE.SPFREETEXTREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNMARKEDFOREDITING            IAPITYPE.BOOLEAN_TYPE;
      LNALLOWED                     IAPITYPE.BOOLEAN_TYPE;
      LSSECTION                     IAPITYPE.STRING_TYPE;
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
      GTFREETEXTS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRFREETEXT.PARTNO := ASPARTNO;
      LRFREETEXT.REVISION := ANREVISION;
      LRFREETEXT.ITEMID := ANITEMID;
      LRFREETEXT.TEXT := MANIPULATETEXT( ALTEXT );
      LRFREETEXT.SECTIONID := ANSECTIONID;
      LRFREETEXT.SUBSECTIONID := ANSUBSECTIONID;
      LRFREETEXT.LANGUAGEID := ANLANGUAGEID;
      GTFREETEXTS( 0 ) := LRFREETEXT;

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

      
      LRFREETEXT.TEXT := MANIPULATETEXT( GTFREETEXTS( 0 ).TEXT );
      LRINFO := GTINFO( 0 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      
      
      
      
      
      CHECKBASICFREETEXTPARAMS( LRFREETEXT );

      
      IF ( LRFREETEXT.LANGUAGEID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'LanguageId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anLanguageId',
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

      
      IF ( AFHANDLE IS NOT NULL )
      THEN
         LNRETVAL :=
            IAPISPECIFICATIONSECTION.ISMARKEDFOREDITING( LRFREETEXT.PARTNO,
                                                         LRFREETEXT.REVISION,
                                                         LRFREETEXT.SECTIONID,
                                                         LRFREETEXT.SUBSECTIONID,
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
                                                           LRFREETEXT.PARTNO,
                                                           LRFREETEXT.REVISION ) );
            WHEN -2
            THEN
               SELECT    F_SCH_DESCR( IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,
                                      LRFREETEXT.SECTIONID,
                                      0 )
                      || DECODE( LRFREETEXT.SUBSECTIONID,
                                 0, NULL,
                                    ' - '
                                 || F_SCH_DESCR( IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,
                                                 LRFREETEXT.SUBSECTIONID,
                                                 0 ) )
                 INTO LSSECTION
                 FROM DUAL;

               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_SAVEAFTERMOD,
                                                           LRFREETEXT.PARTNO,
                                                           LRFREETEXT.REVISION,
                                                           LSSECTION ) );
            ELSE   
               NULL;
         END CASE;
      END IF;

      
      LNRETVAL := IAPISPECIFICATIONACCESS.GETMODIFIABLEACCESS( LRFREETEXT.PARTNO,
                                                               LRFREETEXT.REVISION,
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
                                                     LRFREETEXT.PARTNO,
                                                     LRFREETEXT.REVISION ) );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( LRFREETEXT.PARTNO,
                                                      LRFREETEXT.REVISION,
                                                      LRFREETEXT.SECTIONID,
                                                      LRFREETEXT.SUBSECTIONID,
                                                      IAPICONSTANT.SECTIONTYPE_FREETEXT,
                                                      LRFREETEXT.ITEMID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         LNRETVAL :=
            ADDFREETEXT( LRFREETEXT.PARTNO,
                         LRFREETEXT.REVISION,
                         LRFREETEXT.SECTIONID,
                         LRFREETEXT.SUBSECTIONID,
                         LRFREETEXT.ITEMID,
                         LRFREETEXT.LANGUAGEID,
                         LRFREETEXT.TEXT,
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

      
       
      IF ( AFHANDLE IS NOT NULL )
      THEN
         LNRETVAL :=
            IAPISPECIFICATIONSECTION.MARKFOREDITING( LRFREETEXT.PARTNO,
                                                     LRFREETEXT.REVISION,
                                                     LRFREETEXT.SECTIONID,
                                                     LRFREETEXT.SUBSECTIONID,
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
         IAPISPECIFICATIONSECTION.ISACTIONALLOWED( LRFREETEXT.PARTNO,
                                                   LRFREETEXT.REVISION,
                                                   LRFREETEXT.SECTIONID,
                                                   LRFREETEXT.SUBSECTIONID,
                                                   IAPICONSTANT.SECTIONTYPE_FREETEXT,
                                                   LRFREETEXT.ITEMID,
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
                                                     LRFREETEXT.ITEMID,
                                                     IAPICONSTANT.SECTIONTYPE_FREETEXT,
                                                     LRFREETEXT.PARTNO,
                                                     LRFREETEXT.REVISION,
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRFREETEXT.SECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRFREETEXT.SUBSECTIONID, 0) ));
                                                     
      END IF;

      IF (     ( LRFREETEXT.LANGUAGEID = 1 )
           OR (      ( LRFREETEXT.LANGUAGEID <> 1 )
                AND ( LRFREETEXT.TEXT IS NOT NULL ) ) )
      THEN
         BEGIN
            UPDATE SPECIFICATION_TEXT
               SET TEXT = LRFREETEXT.TEXT
             WHERE PART_NO = LRFREETEXT.PARTNO
               AND REVISION = LRFREETEXT.REVISION
               AND TEXT_TYPE = LRFREETEXT.ITEMID
               AND LANG_ID = LRFREETEXT.LANGUAGEID
               AND SECTION_ID = LRFREETEXT.SECTIONID
               AND SUB_SECTION_ID = LRFREETEXT.SUBSECTIONID;

            IF ( SQL%ROWCOUNT = 0 )
            THEN
               
               INSERT INTO SPECIFICATION_TEXT
                           ( PART_NO,
                             REVISION,
                             TEXT_TYPE,
                             TEXT,
                             SECTION_ID,
                             SECTION_REV,
                             SUB_SECTION_ID,
                             SUB_SECTION_REV,
                             TEXT_TYPE_REV,
                             LANG_ID )
                  SELECT PART_NO,
                         REVISION,
                         REF_ID,
                         LRFREETEXT.TEXT,
                         SECTION_ID,
                         SECTION_REV,
                         SUB_SECTION_ID,
                         SUB_SECTION_REV,
                         REF_VER,
                         LRFREETEXT.LANGUAGEID
                    FROM SPECIFICATION_SECTION
                   WHERE PART_NO = LRFREETEXT.PARTNO
                     AND REVISION = LRFREETEXT.REVISION
                     AND SECTION_ID = LRFREETEXT.SECTIONID
                     AND SUB_SECTION_ID = LRFREETEXT.SUBSECTIONID
                     AND TYPE = IAPICONSTANT.SECTIONTYPE_FREETEXT
                     AND REF_ID = LRFREETEXT.ITEMID;
            END IF;
         END;
      ELSE
         
         DELETE FROM SPECIFICATION_TEXT
               WHERE PART_NO = LRFREETEXT.PARTNO
                 AND REVISION = LRFREETEXT.REVISION
                 AND SECTION_ID = LRFREETEXT.SECTIONID
                 AND SUB_SECTION_ID = LRFREETEXT.SUBSECTIONID
                 AND TEXT_TYPE = LRFREETEXT.ITEMID
                 AND LANG_ID = LRFREETEXT.LANGUAGEID;
      END IF;

      IF (  LRFREETEXT.LANGUAGEID = 1 AND (LRFREETEXT.TEXT IS NULL) ) 
      THEN
         
         DELETE FROM SPECIFICATION_TEXT
               WHERE PART_NO = LRFREETEXT.PARTNO
                 AND REVISION = LRFREETEXT.REVISION
                 AND SECTION_ID = LRFREETEXT.SECTIONID
                 AND SUB_SECTION_ID = LRFREETEXT.SUBSECTIONID
                 AND TEXT_TYPE = LRFREETEXT.ITEMID
                 AND LANG_ID <> 1;
      END IF;


      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRFREETEXT.PARTNO,
                                                       LRFREETEXT.REVISION,
                                                       LRFREETEXT.SECTIONID,
                                                       LRFREETEXT.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRFREETEXT.PARTNO,
                                                LRFREETEXT.REVISION );

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
   END SAVEFREETEXT;

   
   FUNCTION EXTENDFREETEXT(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANLANGUAGEID               IN       IAPITYPE.LANGUAGEID_TYPE DEFAULT 1,
      ALTEXT                     IN       IAPITYPE.CLOB_TYPE DEFAULT NULL,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      ANSECTIONSEQUENCENUMBER    OUT      IAPITYPE.SPSECTIONSEQUENCENUMBER_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExtendFreeText';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRFREETEXT                    IAPITYPE.SPFREETEXTREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
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
      GTFREETEXTS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRFREETEXT.PARTNO := ASPARTNO;
      LRFREETEXT.REVISION := ANREVISION;
      LRFREETEXT.SECTIONID := ANSECTIONID;
      LRFREETEXT.SUBSECTIONID := ANSUBSECTIONID;
      LRFREETEXT.ITEMID := ANITEMID;
      LRFREETEXT.LANGUAGEID := ANLANGUAGEID;
      LRFREETEXT.TEXT := ALTEXT;
      GTFREETEXTS( 0 ) := LRFREETEXT;

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

      
      LRFREETEXT.TEXT := MANIPULATETEXT( GTFREETEXTS( 0 ).TEXT );
      LRINFO := GTINFO( 0 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      
      
      
      
      
      CHECKBASICFREETEXTPARAMS( LRFREETEXT );

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

      
      BEGIN
         SELECT DISTINCT REVISION
                    INTO LRFREETEXT.ITEMREVISION
                    FROM TEXT_TYPE_H
                   WHERE TEXT_TYPE = LRFREETEXT.ITEMID
                     AND MAX_REV = 1;
      EXCEPTION
         WHEN OTHERS
         THEN
            LRFREETEXT.ITEMREVISION := 0;
      END;

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.EXTENDSECTION( LRFREETEXT.PARTNO,
                                                 LRFREETEXT.REVISION,
                                                 LRFREETEXT.SECTIONID,
                                                 LRFREETEXT.SUBSECTIONID,
                                                 IAPICONSTANT.SECTIONTYPE_FREETEXT,
                                                 LRFREETEXT.ITEMID,
                                                 LRFREETEXT.ITEMREVISION,
                                                 AFHANDLE => AFHANDLE,
                                                 ANSECTIONSEQUENCENUMBER => ANSECTIONSEQUENCENUMBER );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      BEGIN
         INSERT INTO SPECIFICATION_TEXT
                     ( PART_NO,
                       REVISION,
                       TEXT_TYPE,
                       TEXT,
                       SECTION_ID,
                       SECTION_REV,
                       SUB_SECTION_ID,
                       SUB_SECTION_REV,
                       TEXT_TYPE_REV,
                       LANG_ID )
            SELECT PART_NO,
                   REVISION,
                   REF_ID,
                   LRFREETEXT.TEXT,
                   SECTION_ID,
                   SECTION_REV,
                   SUB_SECTION_ID,
                   SUB_SECTION_REV,
                   REF_VER,
                   1
              FROM SPECIFICATION_SECTION
             WHERE PART_NO = LRFREETEXT.PARTNO
               AND REVISION = LRFREETEXT.REVISION
               AND SECTION_ID = LRFREETEXT.SECTIONID
               AND SUB_SECTION_ID = LRFREETEXT.SUBSECTIONID
               AND TYPE = IAPICONSTANT.SECTIONTYPE_FREETEXT
               AND REF_ID = LRFREETEXT.ITEMID;
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            NULL;   
      END;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRFREETEXT.PARTNO,
                                                LRFREETEXT.REVISION );

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
   END EXTENDFREETEXT;

   
   FUNCTION REMOVEFREETEXT(
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
      
      
      
      
      
      
      
      
         
         
         
         
         
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveFreeText';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRFREETEXT                    IAPITYPE.SPFREETEXTREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
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

      
      
      
      GTFREETEXTS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRFREETEXT.PARTNO := ASPARTNO;
      LRFREETEXT.REVISION := ANREVISION;
      LRFREETEXT.SECTIONID := ANSECTIONID;
      LRFREETEXT.SUBSECTIONID := ANSUBSECTIONID;
      LRFREETEXT.ITEMID := ANITEMID;
      GTFREETEXTS( 0 ) := LRFREETEXT;

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

      
      LRFREETEXT.TEXT := MANIPULATETEXT( GTFREETEXTS( 0 ).TEXT );
      LRINFO := GTINFO( 0 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      
      
      
      
      
      CHECKBASICFREETEXTPARAMS( LRFREETEXT );

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
         IAPISPECIFICATIONSECTION.ISACTIONALLOWED( LRFREETEXT.PARTNO,
                                                   LRFREETEXT.REVISION,
                                                   LRFREETEXT.SECTIONID,
                                                   LRFREETEXT.SUBSECTIONID,
                                                   IAPICONSTANT.SECTIONTYPE_FREETEXT,
                                                   LRFREETEXT.ITEMID,
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
                                                     LRFREETEXT.ITEMID,
                                                     IAPICONSTANT.SECTIONTYPE_FREETEXT,
                                                     LRFREETEXT.PARTNO,
                                                     LRFREETEXT.REVISION,
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRFREETEXT.SECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRFREETEXT.SUBSECTIONID, 0) ));
                                                     
      END IF;

      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Remove of the section item',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.REMOVESECTIONITEM( LRFREETEXT.PARTNO,
                                                     LRFREETEXT.REVISION,
                                                     LRFREETEXT.SECTIONID,
                                                     LRFREETEXT.SUBSECTIONID,
                                                     IAPICONSTANT.SECTIONTYPE_FREETEXT,
                                                     LRFREETEXT.ITEMID,
                                                     AFHANDLE => AFHANDLE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;
      

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Delete of the related data in specification_text',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      DELETE FROM SPECIFICATION_TEXT
            WHERE PART_NO = LRFREETEXT.PARTNO
              AND REVISION = LRFREETEXT.REVISION
              AND SECTION_ID = LRFREETEXT.SECTIONID
              AND SUB_SECTION_ID = LRFREETEXT.SUBSECTIONID
              AND TEXT_TYPE = LRFREETEXT.ITEMID
              AND LANG_ID IS NOT NULL;

      
      BEGIN
         DELETE FROM ITSHEXT
               WHERE PART_NO = LRFREETEXT.PARTNO
                 AND REVISION = LRFREETEXT.REVISION
                 AND SECTION_ID = LRFREETEXT.SECTIONID
                 AND SUB_SECTION_ID = LRFREETEXT.SUBSECTIONID
                 AND TYPE = IAPICONSTANT.SECTIONTYPE_FREETEXT
                 AND REF_ID = LRFREETEXT.ITEMID;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;   
      END;

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRFREETEXT.PARTNO,
                                                       LRFREETEXT.REVISION,
                                                       LRFREETEXT.SECTIONID,
                                                       LRFREETEXT.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRFREETEXT.PARTNO,
                                                LRFREETEXT.REVISION );

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
   END REMOVEFREETEXT;

   
   FUNCTION GETFREETEXT(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANITEMID                   IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANLANGUAGEID               IN       IAPITYPE.LANGUAGEID_TYPE DEFAULT 1,
      ANALTERNATIVELANGUAGEID    IN       IAPITYPE.LANGUAGEID_TYPE DEFAULT 1,
      ANINCLUDEDONLY             IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1,
      AQFREETEXT                 OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetFreeText';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRFREETEXT                    IAPITYPE.SPFREETEXTREC_TYPE;
      LRGETFREETEXTS                SPFREETEXTRECORD_TYPE
                                                         := SPFREETEXTRECORD_TYPE( NULL,
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
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
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
            || ', text_type '
            || IAPICONSTANTCOLUMN.ITEMIDCOL
            || ', text_type_rev '
            || IAPICONSTANTCOLUMN.ITEMREVISIONCOL
            || ', f_rfh_descr( -1, :SectionType, text_type, text_type_rev, -1 )'
            
            
            || IAPICONSTANTCOLUMN.ITEMDESCRIPTIONCOL
            || ', text '
            || IAPICONSTANTCOLUMN.TEXTCOL
            || ', lang_id '
            || IAPICONSTANTCOLUMN.LANGUAGEIDCOL
            || ', 1 '
            || IAPICONSTANTCOLUMN.INCLUDEDCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'specification_text';
      LSSELECTFRAME                 IAPITYPE.SQLSTRING_TYPE
         :=    ' SELECT :asPartNo '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', :anRevision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', section_id '
            || IAPICONSTANTCOLUMN.SECTIONIDCOL
            || ', section_rev '
            || IAPICONSTANTCOLUMN.SECTIONREVISIONCOL
            || ', sub_section_id '
            || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
            || ', sub_section_rev '
            || IAPICONSTANTCOLUMN.SUBSECTIONREVISIONCOL
            || ', text_type '
            || IAPICONSTANTCOLUMN.ITEMIDCOL
            || ', text_type_rev '
            || IAPICONSTANTCOLUMN.ITEMREVISIONCOL
            || ', f_rfh_descr( -1, :SectionType, text_type, text_type_rev, -1 )'
            
            
            || IAPICONSTANTCOLUMN.ITEMDESCRIPTIONCOL
            || ', null '
            || IAPICONSTANTCOLUMN.TEXTCOL
            || ', -1 '
            || IAPICONSTANTCOLUMN.LANGUAGEIDCOL
            || ', 0 '
            || IAPICONSTANTCOLUMN.INCLUDEDCOL;
      LSFROMFRAME                   IAPITYPE.STRING_TYPE := 'frame_text';
      LRFRAME                       IAPITYPE.FRAMEREC_TYPE;
      LSCLOB                        IAPITYPE.CLOB_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQFREETEXT%ISOPEN )
      THEN
         CLOSE AQFREETEXT;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE part_no = NULL';

      OPEN AQFREETEXT FOR LSSQLNULL USING IAPICONSTANT.SECTIONTYPE_FREETEXT;

      GTFREETEXTS.DELETE;
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRFREETEXT.PARTNO := ASPARTNO;
      LRFREETEXT.REVISION := ANREVISION;
      LRFREETEXT.SECTIONID := ANSECTIONID;
      LRFREETEXT.SUBSECTIONID := ANSUBSECTIONID;
      LRFREETEXT.ITEMID := ANITEMID;
      LRFREETEXT.LANGUAGEID := ANLANGUAGEID;
      LRFREETEXT.INCLUDED := ANINCLUDEDONLY;
      GTFREETEXTS( 0 ) := LRFREETEXT;
      
      
      
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
      
      LNRETVAL := IAPISPECIFICATION.GETFRAME( ASPARTNO,
                                              ANREVISION,
                                              LRFRAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      
      IF     ANSECTIONID IS NOT NULL
         AND ANITEMID IS NOT NULL
      THEN
         LNRETVAL :=
            IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( ASPARTNO,
                                                         ANREVISION,
                                                         ANSECTIONID,
                                                         ANSUBSECTIONID,
                                                         IAPICONSTANT.SECTIONTYPE_FREETEXT,
                                                         ANITEMID );

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
         || '  FROM '
         || LSFROM
         || ' WHERE part_no = :asPartNo'
         || '   AND revision = :anRevision'
         || '   AND text_type = NVL(:ItemId, text_type)'
         || '   AND lang_id IN (NVL(:LanguageId,1), NVL(:AlternativeLanguageId,1))'
         || '   AND section_id = NVL(:SectionId, section_id)'
         || '   AND sub_section_id = NVL(:SubSectionId, sub_section_id)'
         || '   AND f_check_item_access(part_no, revision, section_id, sub_section_id, :SectionType, text_type) = 1 ';

      IF ANINCLUDEDONLY = 0
      THEN
         LSSQL :=
               LSSQL
            || ' UNION ALL '
            || LSSELECTFRAME
            || ' FROM '
            || LSFROMFRAME
            || ' WHERE frame_no = :FrameNo '
            || ' AND revision = :FrameRevision '
            || ' AND owner = :FrameOwner '
            || ' AND text_type = NVL(:ItemId, text_type)'
            || ' AND section_id = NVL(:SectionId, section_id)'
            || ' AND sub_section_id = NVL(:SubSectionId, sub_section_id)'
            || ' AND ( :asPartNo, :anRevision, text_type, '
            || ' NVL( :LanguageId, 1 ), section_id, sub_section_id ) NOT IN( '
            || ' SELECT '
            || ' part_no, '
            || ' revision, '
            || ' text_type, '
            || ' lang_id, '
            || ' section_id, '
            || ' sub_section_id '
            || '  FROM '
            || LSFROM
            || ' WHERE part_no = :asPartNo'
            || '   AND revision = :anRevision'
            || '   AND text_type = NVL(:ItemId, text_type)'
            || '   AND lang_id IN (NVL(:LanguageId,1), NVL(:AlternativeLanguageId,1))'
            || '   AND section_id = NVL(:SectionId, section_id)'
            || '   AND sub_section_id = NVL(:SubSectionId, sub_section_id)'
            || '   AND f_check_item_access(part_no, revision, section_id, sub_section_id, :SectionType, text_type) = 1 )';
      
      END IF;

      LSSQL :=    'SELECT a.* '
               || ' FROM ('
               || LSSQL
               || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQFREETEXT%ISOPEN )
      THEN
         CLOSE AQFREETEXT;
      END IF;

      
      IF ANINCLUDEDONLY = 1
      THEN
         OPEN AQFREETEXT FOR LSSQL
         USING IAPICONSTANT.SECTIONTYPE_FREETEXT,
               ASPARTNO,
               ANREVISION,
               ANITEMID,
               ANLANGUAGEID,
               ANALTERNATIVELANGUAGEID,
               ANSECTIONID,
               ANSUBSECTIONID,
               IAPICONSTANT.SECTIONTYPE_FREETEXT;
      ELSE
         OPEN AQFREETEXT FOR LSSQL
         USING IAPICONSTANT.SECTIONTYPE_FREETEXT,
               ASPARTNO,
               ANREVISION,
               ANITEMID,
               ANLANGUAGEID,
               ANALTERNATIVELANGUAGEID,
               ANSECTIONID,
               ANSUBSECTIONID,
               IAPICONSTANT.SECTIONTYPE_FREETEXT,
               ASPARTNO,
               ANREVISION,
               IAPICONSTANT.SECTIONTYPE_FREETEXT,
               
               LRFRAME.FRAMENO,
               LRFRAME.REVISION,
               LRFRAME.OWNER,
               ANITEMID,
               ANSECTIONID,
               ANSUBSECTIONID,
               ASPARTNO,
               ANREVISION,
               ANLANGUAGEID,
               ASPARTNO,
               ANREVISION,
               ANITEMID,
               ANLANGUAGEID,
               ANALTERNATIVELANGUAGEID,
               ANSECTIONID,
               ANSUBSECTIONID,
               IAPICONSTANT.SECTIONTYPE_FREETEXT;
      END IF;

      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Post-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTGETFREETEXTS.DELETE;

      LOOP
         LRFREETEXT := NULL;

         FETCH AQFREETEXT
          INTO LRFREETEXT;

         EXIT WHEN AQFREETEXT%NOTFOUND;
         LRGETFREETEXTS.PARTNO := LRFREETEXT.PARTNO;
         LRGETFREETEXTS.REVISION := LRFREETEXT.REVISION;
         LRGETFREETEXTS.SECTIONID := LRFREETEXT.SECTIONID;
         LRGETFREETEXTS.SECTIONREVISION := LRFREETEXT.SECTIONREVISION;
         LRGETFREETEXTS.SUBSECTIONID := LRFREETEXT.SUBSECTIONID;
         LRGETFREETEXTS.SUBSECTIONREVISION := LRFREETEXT.SUBSECTIONREVISION;
         LRGETFREETEXTS.ITEMID := LRFREETEXT.ITEMID;
         LRGETFREETEXTS.ITEMREVISION := LRFREETEXT.ITEMREVISION;
         LRGETFREETEXTS.ITEMDESCRIPTION := LRFREETEXT.ITEMDESCRIPTION;
         LRGETFREETEXTS.TEXT := LRFREETEXT.TEXT;
         LRGETFREETEXTS.LANGUAGEID := LRFREETEXT.LANGUAGEID;
         LRGETFREETEXTS.INCLUDED := LRFREETEXT.INCLUDED;
         GTGETFREETEXTS.EXTEND;
         GTGETFREETEXTS( GTGETFREETEXTS.COUNT ) := LRGETFREETEXTS;
      END LOOP;

      CLOSE AQFREETEXT;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE part_no = NULL';

      OPEN AQFREETEXT FOR LSSQLNULL USING IAPICONSTANT.SECTIONTYPE_FREETEXT;

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
         || ', ITEMDESCRIPTION '
         
         
         || IAPICONSTANTCOLUMN.ITEMDESCRIPTIONCOL
         || ', TEXT '
         || IAPICONSTANTCOLUMN.TEXTCOL
         || ', LANGUAGEID '
         || IAPICONSTANTCOLUMN.LANGUAGEIDCOL
         || ', INCLUDED '
         || IAPICONSTANTCOLUMN.INCLUDEDCOL;

      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM TABLE( CAST( :gtGetFreeTexts AS SpFreeTextTable_Type ) ) ';

      
      IF ( AQFREETEXT%ISOPEN )
      THEN
         CLOSE AQFREETEXT;
      END IF;

      OPEN AQFREETEXT FOR LSSQL USING GTGETFREETEXTS;

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
   END GETFREETEXT;

   
   FUNCTION EXTENDFREETEXTPB(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANLANGUAGEID               IN       IAPITYPE.LANGUAGEID_TYPE DEFAULT 1,
      ALTEXT                     IN       IAPITYPE.CLOB_TYPE DEFAULT NULL,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQSECTIONSEQUENCENUMBER    OUT      IAPITYPE.REF_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExtendFreeTextPb';
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
         IAPISPECIFICATIONFREETEXT.EXTENDFREETEXT( ASPARTNO,
                                                   ANREVISION,
                                                   ANSECTIONID,
                                                   ANSUBSECTIONID,
                                                   ANITEMID,
                                                   ANLANGUAGEID,
                                                   ALTEXT,
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
   END EXTENDFREETEXTPB;

   
   FUNCTION GETFREETEXTS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      AQFREETEXTS                OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetFreeTexts';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', section_id '
            || IAPICONSTANTCOLUMN.SECTIONIDCOL
            || ', sub_section_id '
            || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
            || ', text_type '
            || IAPICONSTANTCOLUMN.ITEMIDCOL
            || ', text_type_rev '
            || IAPICONSTANTCOLUMN.ITEMREVISIONCOL
            || ', f_rfh_descr( -1, :SectionType, text_type, text_type_rev, -1 ) '
            || IAPICONSTANTCOLUMN.ITEMDESCRIPTIONCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'specification_text';
   BEGIN
      
      
      
      
      
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=
            'SELECT '
         || LSSELECT
         || '  FROM '
         || LSFROM
         || ' WHERE part_no = :PartNo'
         || '   AND revision = :Revision'
         || '   AND lang_id = :LanguageId'
         || '   AND section_id = NVL(:SectionId, section_id)'
         || '   AND sub_section_id = NVL(:SubSectionId, sub_section_id)'
         || '   AND f_check_item_access(part_no, revision, section_id, sub_section_id, :SectionType, text_type) = 1 ';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQFREETEXTS%ISOPEN )
      THEN
         CLOSE AQFREETEXTS;
      END IF;

      
      OPEN AQFREETEXTS FOR LSSQL
      USING IAPICONSTANT.SECTIONTYPE_FREETEXT,
            ASPARTNO,
            ANREVISION,
            NVL( IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,
                 1 ),
            ANSECTIONID,
            ANSUBSECTIONID,
            IAPICONSTANT.SECTIONTYPE_FREETEXT;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETFREETEXTS;
END IAPISPECIFICATIONFREETEXT;
CREATE OR REPLACE PACKAGE BODY iapiSpecificationSection
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

   
   
   
   
   
   
   
   FUNCTION ISEXTENDABLE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANEXTENDABLE               OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsExtendable';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRFRAME                       IAPITYPE.FRAMEREC_TYPE;
   BEGIN
      
      
      
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

      
      
      LNRETVAL := IAPIFRAMESECTION.EXISTID( LRFRAME.FRAMENO,
                                            LRFRAME.REVISION,
                                            LRFRAME.OWNER,
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

      SELECT DISTINCT DECODE( SC_EXT,
                              IAPICONSTANT.FLAG_YES, 1,
                              0 )
                 INTO ANEXTENDABLE
                 FROM FRAME_SECTION
                WHERE FRAME_NO = LRFRAME.FRAMENO
                  AND REVISION = LRFRAME.REVISION
                  AND OWNER = LRFRAME.OWNER
                  AND SECTION_ID = ANSECTIONID
                  AND SUB_SECTION_ID = ANSUBSECTIONID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ISEXTENDABLE;

   
   
   
   
   FUNCTION EXISTID(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
       
       
       
       
       
       
       
       
       
      
       
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistId';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNRETVAL := IAPISPECIFICATION.EXISTID( ASPARTNO,
                                             ANREVISION );

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
                 FROM SPECIFICATION_SECTION
                WHERE PART_NO = ASPARTNO
                  AND REVISION = ANREVISION
                  AND SECTION_ID = ANSECTIONID
                  AND SUB_SECTION_ID = ANSUBSECTIONID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SPSECTIONNOTFOUND,
                                                     ASPARTNO,
                                                     ANREVISION,
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSUBSECTIONID, 0) ));
                                                     
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTID;

   
   FUNCTION ADDSECTIONITEM(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANITEMREVISION             IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      ANITEMOWNER                IN       IAPITYPE.OWNER_TYPE DEFAULT NULL,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
       
       
       
       
       
       
       
       
       
       
      
      
      
       
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddSectionItem';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRFRAME                       IAPITYPE.FRAMEREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNLOCALIZED                   IAPITYPE.BOOLEAN_TYPE;
      LNLOCALLYMODIFIABLE           IAPITYPE.BOOLEAN_TYPE;
      LNITEMID                      IAPITYPE.ID_TYPE;
      LNCHECKFRAME                  IAPITYPE.BOOLEAN_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
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

      
      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( ASPARTNO,
                                                      ANREVISION,
                                                      ANSECTIONID,
                                                      ANSUBSECTIONID,
                                                      ANTYPE,
                                                      ANITEMID,
                                                      ANITEMREVISION,
                                                      ANITEMOWNER );

      IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_ITEMALREADYINSECTION,
                                                     ASPARTNO,
                                                     ANREVISION,
                                                     F_SCH_DESCR( NULL,
                                                                  ANSECTIONID,
                                                                  0 ),
                                                     F_SBH_DESCR( NULL,
                                                                  ANSUBSECTIONID,
                                                                  0 ),
                                                     
                                                     
                                                     
                                                     F_RFH_DESCR(NULL, ANTYPE, ANITEMID)));
                                                     
      ELSIF( LNRETVAL IN( IAPICONSTANTDBERROR.DBERR_SPITEMNOTFOUND, IAPICONSTANTDBERROR.DBERR_SPSECTIONNOTFOUND ) )
      THEN
         LNCHECKFRAME := 1;
      ELSIF( LNRETVAL NOT IN( IAPICONSTANTDBERROR.DBERR_SPITEMNOTFOUND, IAPICONSTANTDBERROR.DBERR_SPSECTIONNOTFOUND ) )
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

      
      IF ( ANTYPE = IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC )
      THEN
         LNITEMID := 0;   
      ELSE
         LNITEMID := ANITEMID;
      END IF;

      LNRETVAL :=
         IAPIFRAMESECTION.EXISTITEMINSECTION( LRFRAME.FRAMENO,
                                              LRFRAME.REVISION,
                                              LRFRAME.OWNER,
                                              ANSECTIONID,
                                              ANSUBSECTIONID,
                                              ANTYPE,
                                              LNITEMID,
                                              ANITEMREVISION,
                                              ANITEMOWNER );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.ISLOCALIZED( ASPARTNO,
                                                 ANREVISION,
                                                 LNLOCALIZED );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF ( LNLOCALIZED = 1 )
      THEN
         
         IF LNCHECKFRAME = 1
         THEN
            LNRETVAL :=
               IAPIFRAMESECTION.ISITEMLOCALLYMODIFIABLE( LRFRAME.FRAMENO,
                                                         LRFRAME.REVISION,
                                                         LRFRAME.OWNER,
                                                         ANSECTIONID,
                                                         ANSUBSECTIONID,
                                                         ANTYPE,
                                                         LNITEMID,
                                                         ANITEMREVISION,
                                                         ANITEMOWNER,
                                                         LNLOCALLYMODIFIABLE );
         ELSE
            LNRETVAL :=
               ISITEMLOCALLYMODIFIABLE( ASPARTNO,
                                        ANREVISION,
                                        ANSECTIONID,
                                        ANSUBSECTIONID,
                                        ANTYPE,
                                        LNITEMID,
                                        ANITEMREVISION,
                                        ANITEMOWNER,
                                        LNLOCALLYMODIFIABLE );
         END IF;

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         IF ( LNLOCALLYMODIFIABLE = 0 )
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_NOTLOCALLYMODIFIABLE,
                                                        ASPARTNO,
                                                        ANREVISION,
                                                        
                                                        
                                                        
                                                        F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSECTIONID, 0),
                                                        F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSUBSECTIONID, 0),
                                                        
                                                        ANTYPE,
                                                        LNITEMID ) );
         END IF;
      END IF;

      
      
      IF (      ( ANTYPE IN( IAPICONSTANT.SECTIONTYPE_REFERENCETEXT, IAPICONSTANT.SECTIONTYPE_OBJECT ) )
           AND ( -LNITEMID = ANTYPE ) )
      THEN
         LNITEMID := 0;
      END IF;

      
      INSERT INTO SPECIFICATION_SECTION
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID,
                    TYPE,
                    REF_ID,
                    REF_VER,
                    REF_INFO,
                    SEQUENCE_NO,
                    HEADER,
                    MANDATORY,
                    SECTION_SEQUENCE_NO,
                    DISPLAY_FORMAT,
                    ASSOCIATION,
                    INTL,
                    SECTION_REV,
                    SUB_SECTION_REV,
                    DISPLAY_FORMAT_REV,
                    REF_OWNER )
         SELECT ASPARTNO,
                ANREVISION,
                SECTION_ID,
                SUB_SECTION_ID,
                TYPE,
                REF_ID,
                REF_VER,
                REF_INFO,
                SEQUENCE_NO,
                HEADER,
                MANDATORY,
                SECTION_SEQUENCE_NO,
                DISPLAY_FORMAT,
                ASSOCIATION,
                INTL,
                F_GET_SUB_REV( SECTION_ID,
                               SECTION_REV,
                               NULL,
                               NULL,
                               'SC' ),
                F_GET_SUB_REV( SUB_SECTION_ID,
                               SUB_SECTION_REV,
                               NULL,
                               NULL,
                               'SB' ),
                DISPLAY_FORMAT_REV,
                REF_OWNER
           FROM FRAME_SECTION
          WHERE FRAME_NO = LRFRAME.FRAMENO
            AND REVISION = LRFRAME.REVISION
            AND OWNER = LRFRAME.OWNER
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND TYPE = ANTYPE
            AND REF_ID = LNITEMID;

      
      IF ( AFHANDLE IS NOT NULL )
      THEN
         LNRETVAL := IAPISPECIFICATIONSECTION.MARKFOREDITING( ASPARTNO,
                                                              ANREVISION,
                                                              ANSECTIONID,
                                                              ANSUBSECTIONID,
                                                              AFHANDLE );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
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
   END ADDSECTIONITEM;

   
   FUNCTION REMOVESECTIONITEM(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANITEMREVISION             IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      ANITEMOWNER                IN       IAPITYPE.OWNER_TYPE DEFAULT NULL,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
       
       
       
       
       
       
       
       
       
      
       
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveSectionItem';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNITEMID                      IAPITYPE.ID_TYPE := ANITEMID;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
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
                           'Check if the item exist in the section',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      IF (      ( ANTYPE IN( IAPICONSTANT.SECTIONTYPE_REFERENCETEXT, IAPICONSTANT.SECTIONTYPE_OBJECT ) )
           AND ( -LNITEMID = ANTYPE ) )
      THEN
         LNITEMID := 0;
      END IF;

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( ASPARTNO,
                                                      ANREVISION,
                                                      ANSECTIONID,
                                                      ANSUBSECTIONID,
                                                      ANTYPE,
                                                      LNITEMID,
                                                      ANITEMREVISION,
                                                      ANITEMOWNER );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      IF ( AFHANDLE IS NOT NULL )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Mark the item for editing',
                              IAPICONSTANT.INFOLEVEL_3 );
         LNRETVAL := IAPISPECIFICATIONSECTION.MARKFOREDITING( ASPARTNO,
                                                              ANREVISION,
                                                              ANSECTIONID,
                                                              ANSUBSECTIONID,
                                                              AFHANDLE );

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
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Delete the item from specification section',
                           IAPICONSTANT.INFOLEVEL_3 );

       
      
      IF (     ANTYPE IN( IAPICONSTANT.SECTIONTYPE_OBJECT, IAPICONSTANT.SECTIONTYPE_REFERENCETEXT )
           AND ( LNITEMID <> 0 ) )
      THEN
         DELETE FROM SPECIFICATION_SECTION
               WHERE PART_NO = ASPARTNO
                 AND REVISION = ANREVISION
                 AND SECTION_ID = ANSECTIONID
                 AND SUB_SECTION_ID = ANSUBSECTIONID
                 AND TYPE = ANTYPE
                 AND REF_ID = LNITEMID
                 AND REF_VER = ANITEMREVISION
                 AND REF_OWNER = ANITEMOWNER;
      ELSE
         DELETE FROM SPECIFICATION_SECTION
               WHERE PART_NO = ASPARTNO
                 AND REVISION = ANREVISION
                 AND SECTION_ID = ANSECTIONID
                 AND SUB_SECTION_ID = ANSUBSECTIONID
                 AND TYPE = ANTYPE
                 AND REF_ID = LNITEMID;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVESECTIONITEM;

   
   FUNCTION EXTENDSECTION(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANITEMREVISION             IN       IAPITYPE.REVISION_TYPE,
      ANDISPLAYFORMATID          IN       IAPITYPE.ID_TYPE DEFAULT 0,
      ANDISPLAYFORMATREVISION    IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE DEFAULT 0,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      ANSECTIONSEQUENCENUMBER    OUT      IAPITYPE.SPSECTIONSEQUENCENUMBER_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
       
       
       
       
       
       
       
       
       
      
      
      
      
       
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExtendSection';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LRFRAME                       IAPITYPE.FRAMEREC_TYPE;
      LNSECTIONREVISION             IAPITYPE.REVISION_TYPE;
      LNSUBSECTIONREVISION          IAPITYPE.REVISION_TYPE;
      LNSPECIFICATIONMODE           IAPITYPE.BOOLEAN_TYPE;
      LNEXTENDABLE                  IAPITYPE.BOOLEAN_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
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

      
      
      LNRETVAL :=
         IAPIFRAMESECTION.EXISTITEMINSECTION( LRFRAME.FRAMENO,
                                              LRFRAME.REVISION,
                                              LRFRAME.OWNER,
                                              ANSECTIONID,
                                              ANSUBSECTIONID,
                                              ANTYPE,
                                              ANITEMID,
                                              ANMASKID => LRFRAME.MASKID );

      IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_ITEMINFRAMESECTION,
                                                     LRFRAME.FRAMENO,
                                                     LRFRAME.REVISION,
                                                     F_OWNER_DESCR( LRFRAME.OWNER ),
                                                     F_SCH_DESCR( NULL,
                                                                  ANSECTIONID,
                                                                  0 ),
                                                     F_SBH_DESCR( NULL,
                                                                  ANSUBSECTIONID,
                                                                  0 ) ) );
      END IF;

      
      LNRETVAL := ISEXTENDABLE( ASPARTNO,
                                ANREVISION,
                                ANSECTIONID,
                                ANSUBSECTIONID,
                                LNEXTENDABLE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF ( LNEXTENDABLE = 0 )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SPSECTIONNOTEXTENDABLE,
                                                     ASPARTNO,
                                                     ANREVISION,
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSUBSECTIONID, 0) ));
                                                     
      END IF;

      
      LNRETVAL := IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( ASPARTNO,
                                                               ANREVISION,
                                                               ANSECTIONID,
                                                               ANSUBSECTIONID,
                                                               ANTYPE,
                                                               ANITEMID );

      IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_ITEMALREADYINSECTION,
                                                     ASPARTNO,
                                                     ANREVISION,
                                                     F_SCH_DESCR( NULL,
                                                                  ANSECTIONID,
                                                                  0 ),
                                                     F_SBH_DESCR( NULL,
                                                                  ANSUBSECTIONID,
                                                                  0 ),
                                                     
                                                     
                                                     F_RFH_DESCR(NULL, ANTYPE, ANITEMID)));
                                                     
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      SELECT MAX( SECTION_SEQUENCE_NO )
        INTO ANSECTIONSEQUENCENUMBER
        FROM SPECIFICATION_SECTION
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND SECTION_ID = ANSECTIONID
         AND SUB_SECTION_ID = ANSUBSECTIONID
         AND MOD( SECTION_SEQUENCE_NO,
                  10 ) = 0;

      IF ANSECTIONSEQUENCENUMBER IS NULL
      THEN
         
         SELECT NVL( MAX( SECTION_SEQUENCE_NO ),
                     0 )
           INTO ANSECTIONSEQUENCENUMBER
           FROM FRAME_SECTION
          WHERE FRAME_NO = LRFRAME.FRAMENO
            AND REVISION = LRFRAME.REVISION
            AND OWNER = LRFRAME.OWNER
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND MOD( SECTION_SEQUENCE_NO,
                     10 ) = 0;
      END IF;

      
      BEGIN
         SELECT DISTINCT SECTION_REV,
                         SUB_SECTION_REV
                    INTO LNSECTIONREVISION,
                         LNSUBSECTIONREVISION
                    FROM SPECIFICATION_SECTION
                   WHERE PART_NO = ASPARTNO
                     AND REVISION = ANREVISION
                     AND SECTION_ID = ANSECTIONID
                     AND SUB_SECTION_ID = ANSUBSECTIONID
                     AND SECTION_SEQUENCE_NO = ANSECTIONSEQUENCENUMBER;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            LNSECTIONREVISION := 0;
            LNSUBSECTIONREVISION := 0;
      END;

      
      SELECT INTL
        INTO LNSPECIFICATIONMODE
        FROM SPECIFICATION_HEADER
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION;

      
      ANSECTIONSEQUENCENUMBER :=   ANSECTIONSEQUENCENUMBER
                                 + 10;

      INSERT INTO SPECIFICATION_SECTION
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID,
                    TYPE,
                    REF_ID,
                    REF_VER,
                    REF_INFO,
                    SEQUENCE_NO,
                    HEADER,
                    MANDATORY,
                    SECTION_SEQUENCE_NO,
                    DISPLAY_FORMAT,
                    ASSOCIATION,
                    INTL,
                    SECTION_REV,
                    SUB_SECTION_REV,
                    DISPLAY_FORMAT_REV,
                    REF_OWNER )
           VALUES ( ASPARTNO,
                    ANREVISION,
                    ANSECTIONID,
                    ANSUBSECTIONID,
                    ANTYPE,
                    ANITEMID,
                    ANITEMREVISION,
                    DECODE( ANTYPE,
                            IAPICONSTANT.SECTIONTYPE_REFERENCETEXT, 5,
                            IAPICONSTANT.SECTIONTYPE_FREETEXT, 10,
                            0 ),
                    NULL,
                    1,
                    IAPICONSTANT.FLAG_YES,
                    ANSECTIONSEQUENCENUMBER,
                    ANDISPLAYFORMATID,
                    0,
                    LNSPECIFICATIONMODE,
                    LNSECTIONREVISION,
                    LNSUBSECTIONREVISION,
                    ANDISPLAYFORMATREVISION,
                    0 );

      
      INSERT INTO ITSHEXT
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID,
                    TYPE,
                    REF_ID,
                    REF_VER,
                    REF_OWNER,
                    PROPERTY_GROUP,
                    PROPERTY,
                    ATTRIBUTE )
           VALUES ( ASPARTNO,
                    ANREVISION,
                    ANSECTIONID,
                    ANSUBSECTIONID,
                    ANTYPE,
                    ANITEMID,
                    ANITEMREVISION,
                    0,
                    DECODE( ANTYPE,
                            IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP, ANITEMID,
                            0 ),
                    DECODE( ANTYPE,
                            IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY, ANITEMID,
                            0 ),
                    ANATTRIBUTEID );

      
      IF ( AFHANDLE IS NOT NULL )
      THEN
         LNRETVAL := IAPISPECIFICATIONSECTION.MARKFOREDITING( ASPARTNO,
                                                              ANREVISION,
                                                              ANSECTIONID,
                                                              ANSUBSECTIONID,
                                                              AFHANDLE );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END IF;

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( ASPARTNO,
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

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXTENDSECTION;

   
   FUNCTION LOGHISTORY(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'LogHistory';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( IAPISPECIFICATION.GBLOGINTOITSCHS = TRUE )
      THEN
          BEGIN
      
      INSERT INTO ITSCHS
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID,
                    USER_ID,
                    FORENAME,
                    LAST_NAME )
           VALUES ( ASPARTNO,
                    ANREVISION,
                    ANSECTIONID,
                    ANSUBSECTIONID,
                    IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                    IAPIGENERAL.SESSION.APPLICATIONUSER.FORENAME,
                    IAPIGENERAL.SESSION.APPLICATIONUSER.LASTNAME );

      
           EXCEPTION
              WHEN DUP_VAL_ON_INDEX
              THEN
                 NULL;
           END;
      END IF;
      

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      
      
      
      
      
      
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END LOGHISTORY;

   
   FUNCTION ISITEMLOCALLYMODIFIABLE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANITEMREVISION             IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      ANITEMOWNER                IN       IAPITYPE.OWNER_TYPE DEFAULT NULL,
      ANLOCALLYMODIFIABLE        OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsItemLocallyModifiable';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNRETVAL := EXISTITEMINSECTION( ASPARTNO,
                                      ANREVISION,
                                      ANSECTIONID,
                                      ANSUBSECTIONID,
                                      ANTYPE,
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

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT DECODE( INTL,
                     2, 1,
                     0 )
        INTO ANLOCALLYMODIFIABLE
        FROM SPECIFICATION_SECTION
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND SECTION_ID = ANSECTIONID
         AND SUB_SECTION_ID = ANSUBSECTIONID
         AND TYPE = ANTYPE
         AND REF_ID = ANITEMID
         AND DECODE( ANITEMREVISION,
                     NULL, 1,
                     REF_VER ) = NVL( ANITEMREVISION,
                                      1 )
         AND DECODE( ANITEMOWNER,
                     NULL, 1,
                     REF_OWNER ) = NVL( ANITEMOWNER,
                                        1 );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ISITEMLOCALLYMODIFIABLE;

   
   FUNCTION EXISTITEMINSECTION(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANITEMREVISION             IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      ANITEMOWNER                IN       IAPITYPE.OWNER_TYPE DEFAULT NULL )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
       
       
       
       
       
       
       
       
       
       
      
       
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistItemInSection';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LNCOUNT                       NUMBER;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNRETVAL := EXISTID( ASPARTNO,
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

       
      
       
      IF (     ANTYPE IN( IAPICONSTANT.SECTIONTYPE_OBJECT, IAPICONSTANT.SECTIONTYPE_REFERENCETEXT )
           AND ( ANITEMID <> 0 ) )
      THEN
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM SPECIFICATION_SECTION
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND TYPE = ANTYPE
            AND REF_ID = ANITEMID
            AND REF_VER = ANITEMREVISION
            AND REF_OWNER = ANITEMOWNER;
      ELSE
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM SPECIFICATION_SECTION
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND TYPE = ANTYPE
            AND REF_ID = ANITEMID;
      END IF;

      IF ( LNCOUNT = 0 )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SPITEMNOTFOUND,
                                                     ASPARTNO,
                                                     ANREVISION,
                                                     
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSUBSECTIONID, 0),
                                                     F_RFH_DESCR(NULL, ANTYPE, ANITEMID)));
                                                     
      END IF;

      IF F_CHECK_ITEM_ACCESS( ASPARTNO,
                              ANREVISION,
                              ANSECTIONID,
                              ANSUBSECTIONID,
                              ANTYPE,
                              ANITEMID,
                              ANITEMOWNER ) = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_NOVIEWSECTIONACCESS,
                                                     ASPARTNO,
                                                     ANREVISION,
                                                     F_SCH_DESCR( NULL,
                                                                  ANSECTIONID,
                                                                  0 ),
                                                     F_SBH_DESCR( NULL,
                                                                  ANSUBSECTIONID,
                                                                  0 ),
                                                     ANTYPE ) );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTITEMINSECTION;

   
   FUNCTION MARKFOREDITING(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
       
       
       
       
       
       
       
       
       
       
      
       
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'MarkForEditing';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSSESSION                     ITSCUSRLOG.SESSION_ID%TYPE := DBMS_SESSION.UNIQUE_SESSION_ID;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
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
                           'Check if the item exist',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := EXISTID( ASPARTNO,
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
      LNRETVAL := IAPISPECIFICATIONSECTION.UPDATESECTIONLOGGING( ASPARTNO,
                                                                 ANREVISION,
                                                                 ANSECTIONID,
                                                                 ANSUBSECTIONID,
                                                                 AFHANDLE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
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
   END MARKFOREDITING;

   
   FUNCTION ISMARKEDFOREDITING(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE,
      ANMARKEDFOREDITING         OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsMarkedForEditing';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
      LBDOCHECK                     BOOLEAN := FALSE;
      LSSESSION                     ITSCUSRLOG.SESSION_ID%TYPE := DBMS_SESSION.UNIQUE_SESSION_ID;
      LNSECTIONTYPE                 IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE;
      LNMRPUPDATE                   IAPITYPE.NUMVAL_TYPE := 0;
      LNPRODACCESS                  IAPITYPE.NUMVAL_TYPE := 0;
      LNTIMEDIFFERENCE              IAPITYPE.NUMVAL_TYPE := 0;
      LSUSER                        IAPITYPE.USERID_TYPE := IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
      LDLOGINDATE                   IAPITYPE.DATE_TYPE;
      LDLASTUPDATEDATE              IAPITYPE.DATE_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNRETVAL := EXISTID( ASPARTNO,
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
      
      LNRETVAL := IAPISPECIFICATION.GETSTATUSTYPE( ASPARTNO,
                                                   ANREVISION,
                                                   LSSTATUSTYPE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF ( LSSTATUSTYPE = IAPICONSTANT.STATUSTYPE_DEVELOPMENT )
      THEN
         LBDOCHECK := TRUE;
      ELSE
         
         SELECT MAX( TYPE )
           INTO LNSECTIONTYPE
           FROM SPECIFICATION_SECTION
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID;

         IF ( LNSECTIONTYPE = IAPICONSTANT.SECTIONTYPE_BOM )
         THEN
            SELECT MAX( DECODE( A.MRP_UPDATE,
                                'Y', 1,
                                0 ) )
              INTO LNMRPUPDATE
              FROM USER_ACCESS_GROUP A,
                   USER_GROUP_LIST B
             WHERE A.USER_GROUP_ID = B.USER_GROUP_ID
               AND B.USER_ID = LSUSER;

            SELECT MAX( DECODE( PROD_ACCESS,
                                'Y', 1,
                                0 ) )
              INTO LNPRODACCESS
              FROM APPLICATION_USER
             WHERE USER_ID = LSUSER;

            IF (      ( LNMRPUPDATE = 1 )
                 AND ( LNPRODACCESS = 1 ) )
            THEN
               LBDOCHECK := TRUE;
            END IF;
         ELSE
            ANMARKEDFOREDITING := -1;
         END IF;
      END IF;

      IF ( LBDOCHECK = TRUE )
      THEN
         SELECT TIMESTAMP
           INTO LDLOGINDATE
           FROM ITSCUSRLOG LG
          WHERE LG.SESSION_ID = LSSESSION
            AND LG.USER_ID = LSUSER
            AND LG.PART_NO = ASPARTNO
            AND LG.REVISION = ANREVISION
            AND LG.VW_HANDLE = AFHANDLE
            AND LG.SECTION_ID = ANSECTIONID
            AND LG.SUB_SECTION_ID = ANSUBSECTIONID;

         SELECT MAX( UPD_TIMESTAMP )
           INTO LDLASTUPDATEDATE
           FROM ITSCUSRLOG LG
          WHERE LG.PART_NO = ASPARTNO
            AND LG.REVISION = ANREVISION
            AND LG.SECTION_ID = ANSECTIONID
            AND LG.SUB_SECTION_ID = ANSUBSECTIONID
            AND LG.VW_HANDLE <> AFHANDLE;

         SELECT   LDLOGINDATE
                - LDLASTUPDATEDATE
           INTO LNTIMEDIFFERENCE
           FROM DUAL;

         IF ( LNTIMEDIFFERENCE < 0 )
         THEN
            ANMARKEDFOREDITING := -2;
         ELSE
            ANMARKEDFOREDITING := 1;
         END IF;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ISMARKEDFOREDITING;

   
   FUNCTION ADDSECTIONITEMVIAANYHOOK(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANITEMREVISION             IN       IAPITYPE.REVISION_TYPE,
      ANITEMOWNER                IN       IAPITYPE.OWNER_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddSectionItemViaAnyHook';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNITEMINFO                    IAPITYPE.ITEMINFO_TYPE;
      LBHEADER                      IAPITYPE.BOOLEAN_TYPE;
      LNSECTIONREVISION             IAPITYPE.REVISION_TYPE;
      LNSUBSECTIONREVISION          IAPITYPE.REVISION_TYPE;
      LNSECTIONSEQUENCENUMBER       IAPITYPE.SPSECTIONSEQUENCENUMBER_TYPE;
      LNNEXTSECTIONSEQUENCENUMBER   IAPITYPE.SPSECTIONSEQUENCENUMBER_TYPE;
      LNSPECIFICATIONMODE           IAPITYPE.BOOLEAN_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
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

      
      LNRETVAL := EXISTID( ASPARTNO,
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

      
      IF ( ANTYPE NOT IN( IAPICONSTANT.SECTIONTYPE_REFERENCETEXT, IAPICONSTANT.SECTIONTYPE_OBJECT ) )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_INVALIDANYHOOKTYPE,
                                                     ANTYPE ) );
      END IF;

      
      LNRETVAL := IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( ASPARTNO,
                                                               ANREVISION,
                                                               ANSECTIONID,
                                                               ANSUBSECTIONID,
                                                               ANTYPE,
                                                               0 );

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
                                                      ANSECTIONID,
                                                      ANSUBSECTIONID,
                                                      ANTYPE,
                                                      ANITEMID,
                                                      ANITEMREVISION,
                                                      ANITEMOWNER );

      IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_ITEMALREADYINSECTION,
                                                     ASPARTNO,
                                                     ANREVISION,
                                                     F_SCH_DESCR( NULL,
                                                                  ANSECTIONID,
                                                                  0 ),
                                                     F_SBH_DESCR( NULL,
                                                                  ANSUBSECTIONID,
                                                                  0 ),
                                                     
                                                     
                                                     
                                                     F_RFH_DESCR(NULL, ANTYPE, ANITEMID)));
                                                     
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

      SELECT REF_INFO,
             HEADER,
             SECTION_REV,
             SUB_SECTION_REV,
             SECTION_SEQUENCE_NO
        INTO LNITEMINFO,
             LBHEADER,
             LNSECTIONREVISION,
             LNSUBSECTIONREVISION,
             LNSECTIONSEQUENCENUMBER
        FROM SPECIFICATION_SECTION
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND SECTION_ID = ANSECTIONID
         AND SUB_SECTION_ID = ANSUBSECTIONID
         AND TYPE = ANTYPE
         AND REF_ID = 0;

      SELECT   MAX( SECTION_SEQUENCE_NO )
             + 1
        INTO LNNEXTSECTIONSEQUENCENUMBER
        FROM SPECIFICATION_SECTION
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND SECTION_ID = ANSECTIONID
         AND SUB_SECTION_ID = ANSUBSECTIONID
         AND TYPE = ANTYPE
         AND ROUND(   SECTION_SEQUENCE_NO
                    / 100 ) = ROUND(   LNSECTIONSEQUENCENUMBER
                                     / 100 );

      
      IF ( ANTYPE = IAPICONSTANT.SECTIONTYPE_OBJECT )
      THEN
         SELECT DECODE( OLE_OBJECT,
                        'Y', 0,
                        'N', 1,
                        'P', 2,
                        0 )
           INTO LNITEMINFO
           FROM ITOID
          WHERE OBJECT_ID = ANITEMID
            AND REVISION =
                   DECODE( ANITEMREVISION,
                           0, F_GET_HIGH_VERSION( IAPICONSTANT.SECTIONTYPE_OBJECT,
                                                  ANITEMID,
                                                  ANITEMOWNER ),
                           ANITEMREVISION )   
            AND OWNER = ANITEMOWNER;
      END IF;

      SELECT DECODE( ANITEMREVISION,
                     0, NULL,
                     LNITEMINFO )
        INTO LNITEMINFO
        FROM DUAL;

      
      SELECT INTL
        INTO LNSPECIFICATIONMODE
        FROM SPECIFICATION_HEADER
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION;

      INSERT INTO SPECIFICATION_SECTION
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SECTION_REV,
                    SUB_SECTION_ID,
                    SUB_SECTION_REV,
                    REF_ID,
                    REF_VER,
                    REF_INFO,
                    REF_OWNER,
                    SEQUENCE_NO,
                    HEADER,
                    MANDATORY,
                    SECTION_SEQUENCE_NO,
                    INTL,
                    TYPE )
           VALUES ( ASPARTNO,
                    ANREVISION,
                    ANSECTIONID,
                    LNSECTIONREVISION,
                    ANSUBSECTIONID,
                    LNSUBSECTIONREVISION,
                    ANITEMID,
                    ANITEMREVISION,
                    LNITEMINFO,
                    ANITEMOWNER,
                    0,
                    LBHEADER,
                    'N',
                    LNNEXTSECTIONSEQUENCENUMBER,
                    LNSPECIFICATIONMODE,
                    ANTYPE );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDSECTIONITEMVIAANYHOOK;

   
   FUNCTION GETSECTIONITEMS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANINCLUDEDONLY             IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1,
      AQSECTIONITEMS             OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetSectionItems';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRSECTIONITEMS                IAPITYPE.SPSECTIONITEMREC_TYPE;
      LRGETSECTIONITEMS             SPSECTIONITEMRECORD_TYPE
         := SPSECTIONITEMRECORD_TYPE( NULL,
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
      LNCHUNKCOUNT                  IAPITYPE.NUMVAL_TYPE := 0;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' :PartNo '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', :Revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', section_id '
            || IAPICONSTANTCOLUMN.SECTIONIDCOL
            || ', section_rev '
            || IAPICONSTANTCOLUMN.SECTIONREVISIONCOL
            || ', sub_section_id '
            || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
            || ', sub_section_rev '
            || IAPICONSTANTCOLUMN.SUBSECTIONREVISIONCOL
            || ', type '
            || IAPICONSTANTCOLUMN.ITEMTYPECOL
               
            
            || ', DECODE(type, '
            || IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC
            || ', DECODE(ref_id,0,-'
            || IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC
            || ',ref_id), '
            || IAPICONSTANT.SECTIONTYPE_BASENAME
            || ', DECODE(ref_id,0,-'
            || IAPICONSTANT.SECTIONTYPE_BASENAME
            || ',ref_id), '
            || IAPICONSTANT.SECTIONTYPE_REFERENCETEXT
            || ', DECODE(ref_id,0,-'
            || IAPICONSTANT.SECTIONTYPE_REFERENCETEXT
            || ',ref_id), '
            || IAPICONSTANT.SECTIONTYPE_OBJECT
            || ', DECODE(ref_id,0,-'
            || IAPICONSTANT.SECTIONTYPE_OBJECT
            || ',ref_id),ref_id) '
            || IAPICONSTANTCOLUMN.ITEMIDCOL
            || ', ref_ver '
            || IAPICONSTANTCOLUMN.ITEMREVISIONCOL
            || ', ref_owner '
            || IAPICONSTANTCOLUMN.ITEMOWNERCOL
            || ', DECODE(ref_ver, 0, DECODE(type, 6,DECODE(ref_info, NULL, F_INFO_OBJECT_PHANTOM(ref_id, ref_ver, ref_owner), ref_info),ref_info),ref_info) '   
            || IAPICONSTANTCOLUMN.ITEMINFOCOL
            || ', sequence_no '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ', section_sequence_no '
            || IAPICONSTANTCOLUMN.SECTIONSEQUENCENUMBERCOL
            || ', display_format '
            || IAPICONSTANTCOLUMN.DISPLAYFORMATIDCOL
            || ', display_format_rev '
            || IAPICONSTANTCOLUMN.DISPLAYFORMATREVISIONCOL
            || ', association '
            || IAPICONSTANTCOLUMN.ASSOCIATIONIDCOL
            || ', intl '
            || IAPICONSTANTCOLUMN.INTERNATIONALCOL
            || ', header '
            || IAPICONSTANTCOLUMN.HEADERCOL
            || ', decode(mandatory,''N'',1,0) '
            || IAPICONSTANTCOLUMN.OPTIONALCOL
            || ', DECODE(:EditOnSpec, 0, 0, f_check_item_access(:PartNo, :Revision, section_id, sub_section_id, type, decode(type, 4, 0 ,ref_id), NVL(ref_owner,0),  decode(type, 4,ref_id, 0), 0, 1)) '
            || IAPICONSTANTCOLUMN.EDITABLECOL;
      LSFROMSPEC                    IAPITYPE.STRING_TYPE := 'specification_section';
      LSFROMFRAME                   IAPITYPE.STRING_TYPE := 'frame_section';
      LRFRAME                       IAPITYPE.FRAMEREC_TYPE;
      LNEDIT                        IAPITYPE.BOOLEAN_TYPE;
      LNVIEW                        IAPITYPE.BOOLEAN_TYPE;
   BEGIN

      
      IAPISPECIFICATIONACCESS.ENABLEARCACHE;

      
      
      
      
      
      IF ( AQSECTIONITEMS%ISOPEN )
      THEN
         CLOSE AQSECTIONITEMS;
      END IF;

      LSSQLNULL :=
            'SELECT '
         || LSSELECT
         || ', -1 '
         || IAPICONSTANTCOLUMN.INCLUDEDCOL   
         || ', -1 '
         || IAPICONSTANTCOLUMN.EXTENDEDCOL   
         || ', -1 '
         || IAPICONSTANTCOLUMN.ISEXTENDABLECOL   
         || ' FROM '
         || LSFROMSPEC
         || ' WHERE part_no = NULL';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQSECTIONITEMS FOR LSSQLNULL USING ASPARTNO,
      ANREVISION,
      0,
      ASPARTNO,
      ANREVISION;

      GTSECTIONITEMS.DELETE;
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRSECTIONITEMS.PARTNO := ASPARTNO;
      LRSECTIONITEMS.REVISION := ANREVISION;
      LRSECTIONITEMS.SECTIONID := ANSECTIONID;
      LRSECTIONITEMS.SUBSECTIONID := ANSUBSECTIONID;
      LRSECTIONITEMS.INCLUDED := ANINCLUDEDONLY;
      GTSECTIONITEMS( 0 ) := LRSECTIONITEMS;
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      
      
      
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

               
               IAPISPECIFICATIONACCESS.DISABLEARCACHE;

               RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
            END IF;
         ELSE
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );

          
            IAPISPECIFICATIONACCESS.DISABLEARCACHE;

            RETURN( LNRETVAL );
         END IF;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNVIEW := F_CHECK_ITEM_ACCESS( ASPARTNO,
                                     ANREVISION,
                                     ANACCESSLEVEL => 0 );
      
      LNEDIT := F_CHECK_ITEM_ACCESS( ASPARTNO,
                                     ANREVISION,
                                     ANACCESSLEVEL => 1 );
      

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Edit access on specification <'
                           || LNEDIT
                           || '>'
                           || 'View access on specification <'
                           || LNVIEW
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPISPECIFICATION.GETFRAME( ASPARTNO,
                                              ANREVISION,
                                              LRFRAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );


         
         IAPISPECIFICATIONACCESS.DISABLEARCACHE;

         RETURN( LNRETVAL );
      END IF;

        
        
        DELETE FROM SPECIFICATION_SECTION
        WHERE (PART_NO, REVISION, SECTION_ID, SUB_SECTION_ID, TYPE, REF_ID, SECTION_SEQUENCE_NO) IN (
            SELECT SS.PART_NO, SS.REVISION, SS.SECTION_ID, SS.SUB_SECTION_ID, SS.TYPE, SS.REF_ID, SS.SECTION_SEQUENCE_NO
            FROM SPECIFICATION_SECTION SS
            WHERE SS.PART_NO = ASPARTNO
            AND SS.REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND TYPE = IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC
            AND REF_ID <> (SELECT MIN(REF_ID)
                FROM SPECIFICATION_SECTION
                WHERE PART_NO = SS.PART_NO
                AND REVISION = SS.REVISION
                AND TYPE = SS.TYPE
                AND SECTION_SEQUENCE_NO = SS.SECTION_SEQUENCE_NO));

        COMMIT;
        

      
      
      LSSQL :=
            'SELECT '
         || LSSELECT
         || ', 1 '
         || IAPICONSTANTCOLUMN.INCLUDEDCOL   
         || ', iapiSpecificationSection.IsItemExtended(part_no, revision, section_id, sub_section_id, type, ref_id) '
         || IAPICONSTANTCOLUMN.EXTENDEDCOL   
         || ', NVL( iapiSpecificationPropertyGroup.IsExtendable( part_no, revision, section_id, sub_section_id, ref_id, type ), 0 ) '
         || IAPICONSTANTCOLUMN.ISEXTENDABLECOL   
         || ' FROM '
         || LSFROMSPEC
         || ' WHERE part_no = :PartNo '
         || ' AND revision = :Revision '
         || ' AND section_id = NVL(:SectionId, section_id) '
         || ' AND sub_section_id = NVL(:SubsectionId, sub_section_id) '
         || ' AND DECODE(:ViewOnSpec, 0, 0, f_check_item_access(part_no, revision, section_id, sub_section_id, type, decode(type, 4, 0 ,ref_id), NVL(ref_owner,0),  decode(type, 4,ref_id, 0))) = 1 '
         || ' and (type not in ('
         || IAPICONSTANT.OBJECTTYPE
         || ','
         || IAPICONSTANT.REFTEXTTYPE
         || ') or ((type in ('
         || IAPICONSTANT.OBJECTTYPE
         || ','
         || IAPICONSTANT.REFTEXTTYPE
   

         || ') and ((NVL(ref_id,0) = 0) or ( ref_id <> 0 and F_CHECK_OBJ_REFTEXT_ACCESS( type, NVL( ref_id,0 ), NVL( ref_ver,0 ),NVL( ref_owner, 0 ) ) in (0, 1) ) ) )))' ;
    



      IF IAPIGENERAL.SESSION.APPLICATIONUSER.VIEWBOMALLOWED = 0
      THEN
         LSSQL :=    LSSQL
                  || ' AND type NOT IN (3,7)';
      END IF;

      
      IF ANINCLUDEDONLY = 0
      THEN
				
         LSSQL :=
               LSSQL
            || ' UNION '
            || 'SELECT '
            || LSSELECT
            || ', 0 '
            || IAPICONSTANTCOLUMN.INCLUDEDCOL   
            || ', -1 '
            || IAPICONSTANTCOLUMN.EXTENDEDCOL   
            
						
            || ', NVL(iapiSpecificationSection.F_IS_EXTENDABLE( :PartNo, :Revision, :SectionId, :SubsectionId, ref_id),0) ' 
						
						|| IAPICONSTANTCOLUMN.ISEXTENDABLECOL   
            || ' FROM '
            || LSFROMFRAME
            || ' WHERE frame_no = :FrameNo '
            || ' AND revision = :FrameRevision '
            || ' AND owner = :FrameOwner '
   
            || ' and (type not in ('
            || IAPICONSTANT.OBJECTTYPE
            || ','
            || IAPICONSTANT.REFTEXTTYPE
            || ') or ((type in ('
            || IAPICONSTANT.OBJECTTYPE
            || ','
            || IAPICONSTANT.REFTEXTTYPE
            || ') and ((NVL(ref_id,0) = 0) or ( ref_id <> 0 and F_CHECK_OBJ_REFTEXT_ACCESS( type, NVL( ref_id,0 ), NVL( ref_ver,0 ),NVL( ref_owner, 0 ) ) in (0, 1) ) ) )))'
    
            || ' AND section_id = NVL(:SectionId, section_id) '
            || ' AND sub_section_id = NVL(:SubsectionId, sub_section_id) '
            || ' AND DECODE(:ViewOnSpec, 0, 0, f_check_item_access(:PartNo, :Revision, section_id, sub_section_id, type, decode(type, 4, 0 ,ref_id), NVL(ref_owner,0), decode(type, 4, ref_id, 0))) = 1 '
            || ' AND (section_id, sub_section_id, type, ref_id) '
            || ' NOT IN (SELECT section_id, sub_section_id, TYPE, DECODE( TYPE, '
            || IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC
            || ', 0, '
            || IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST
            || ', 0, ref_id ) FROM specification_section '
            || ' WHERE part_no = :PartNo '
            || ' AND revision = :Revision '
            || ' AND section_id = NVL(:SectionId, section_id) '
            || ' AND sub_section_id = NVL(:SubSectionId, sub_section_id) '
            || ' UNION '
            || ' SELECT section_id, sub_section_id, TYPE, DECODE( TYPE, '
            || IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC
            || ', 0, '
            || IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST
            || ', 0, ref_id ) FROM itfrmvsc '
            || ' WHERE frame_no = :FrameNo '
            || ' AND revision = :FrameRevision '
            || ' AND owner = :FrameOwner '
            || ' AND view_id = :FrameMaskId '   
            || ' AND section_id = NVL(:SectionId, section_id) '
            || ' AND sub_section_id = NVL(:SubSectionId, sub_section_id) '
            || ' AND mandatory = ''H'' ) ';

         IF IAPIGENERAL.SESSION.APPLICATIONUSER.VIEWBOMALLOWED = 0
         THEN
            LSSQL :=    LSSQL
                     || ' AND type NOT IN (3,7)';
         END IF;
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY '
               || IAPICONSTANTCOLUMN.SECTIONSEQUENCENUMBERCOL;
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQSECTIONITEMS%ISOPEN )
      THEN
         CLOSE AQSECTIONITEMS;
      END IF;

      IF ANINCLUDEDONLY = 0
      THEN
         
         OPEN AQSECTIONITEMS FOR LSSQL
         USING ASPARTNO,
               ANREVISION,
               LNEDIT,
               ASPARTNO,
               ANREVISION,
               ASPARTNO,
               ANREVISION,
               ANSECTIONID,
               ANSUBSECTIONID,
               LNVIEW,
               ASPARTNO,
               ANREVISION,
               LNEDIT,
               ASPARTNO,
               ANREVISION,
							 
							 ASPARTNO,
               ANREVISION,
               ANSECTIONID,
               ANSUBSECTIONID,
							 
               LRFRAME.FRAMENO,
               LRFRAME.REVISION,
               LRFRAME.OWNER,
               ANSECTIONID,
               ANSUBSECTIONID,
               LNVIEW,
               ASPARTNO,
               ANREVISION,
               ASPARTNO,
               ANREVISION,
               ANSECTIONID,
               ANSUBSECTIONID,
               LRFRAME.FRAMENO,
               LRFRAME.REVISION,
               LRFRAME.OWNER,
               NVL( LRFRAME.MASKID,
                    -1 ),
               ANSECTIONID,
               ANSUBSECTIONID;

      ELSE
         OPEN AQSECTIONITEMS FOR LSSQL USING ASPARTNO,
         ANREVISION,
         LNEDIT,
         ASPARTNO,
         ANREVISION,
         ASPARTNO,
         ANREVISION,
         ANSECTIONID,
         ANSUBSECTIONID,
         LNVIEW;
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'asPartNo '
                           || ASPARTNO,
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'anRevision '
                           || ANREVISION,
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'lnEdit '
                           || LNEDIT,
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'anSectionId '
                           || ANSECTIONID,
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'anSubSectionId '
                           || ANSUBSECTIONID,
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'lnView '
                           || LNVIEW,
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'lrFrame.FrameNo '
                           || LRFRAME.FRAMENO,
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'lrFrame.Revision '
                           || LRFRAME.REVISION,
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'MaskId '
                           || NVL( LRFRAME.MASKID,
                                   -1 ),
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Post-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTGETSECTIONITEMS.DELETE;

      LOOP
         LRSECTIONITEMS := NULL;

         FETCH AQSECTIONITEMS
          INTO LRSECTIONITEMS;

         EXIT WHEN AQSECTIONITEMS%NOTFOUND;
         LRGETSECTIONITEMS.PARTNO := LRSECTIONITEMS.PARTNO;
         LRGETSECTIONITEMS.REVISION := LRSECTIONITEMS.REVISION;
         LRGETSECTIONITEMS.SECTIONID := LRSECTIONITEMS.SECTIONID;
         LRGETSECTIONITEMS.SECTIONREVISION := LRSECTIONITEMS.SECTIONREVISION;
         LRGETSECTIONITEMS.SUBSECTIONID := LRSECTIONITEMS.SUBSECTIONID;
         LRGETSECTIONITEMS.SUBSECTIONREVISION := LRSECTIONITEMS.SUBSECTIONREVISION;
         LRGETSECTIONITEMS.ITEMTYPE := LRSECTIONITEMS.ITEMTYPE;
         LRGETSECTIONITEMS.ITEMID := LRSECTIONITEMS.ITEMID;
         LRGETSECTIONITEMS.ITEMREVISION := LRSECTIONITEMS.ITEMREVISION;
         LRGETSECTIONITEMS.ITEMOWNER := LRSECTIONITEMS.ITEMOWNER;
         LRGETSECTIONITEMS.ITEMINFO := LRSECTIONITEMS.ITEMINFO;
         LRGETSECTIONITEMS.SEQUENCE := LRSECTIONITEMS.SEQUENCE;
         LRGETSECTIONITEMS.SECTIONSEQUENCENUMBER := LRSECTIONITEMS.SECTIONSEQUENCENUMBER;
         LRGETSECTIONITEMS.DISPLAYFORMATID := LRSECTIONITEMS.DISPLAYFORMATID;
         LRGETSECTIONITEMS.DISPLAYFORMATREVISION := LRSECTIONITEMS.DISPLAYFORMATREVISION;
         LRGETSECTIONITEMS.ASSOCIATIONID := LRSECTIONITEMS.ASSOCIATIONID;
         LRGETSECTIONITEMS.INTERNATIONAL := LRSECTIONITEMS.INTERNATIONAL;
         LRGETSECTIONITEMS.HEADER := LRSECTIONITEMS.HEADER;
         LRGETSECTIONITEMS.OPTIONAL := LRSECTIONITEMS.OPTIONAL;
         LRGETSECTIONITEMS.INCLUDED := LRSECTIONITEMS.INCLUDED;
         LRGETSECTIONITEMS.EXTENDED := LRSECTIONITEMS.EXTENDED;
         LRGETSECTIONITEMS.ISEXTENDABLE := LRSECTIONITEMS.ISEXTENDABLE;
         LRGETSECTIONITEMS.ROWINDEX := LRSECTIONITEMS.ROWINDEX;
         LRGETSECTIONITEMS.EDITABLE := LRSECTIONITEMS.EDITABLE;
         GTGETSECTIONITEMS.EXTEND;
         GTGETSECTIONITEMS( GTGETSECTIONITEMS.COUNT ) := LRGETSECTIONITEMS;
      END LOOP;

      CLOSE AQSECTIONITEMS;

      LSSQLNULL :=
            'SELECT '
         || LSSELECT
         || ', -1 '
         || IAPICONSTANTCOLUMN.INCLUDEDCOL   
         || ', -1 '
         || IAPICONSTANTCOLUMN.EXTENDEDCOL   
         || ', -1 '
         || IAPICONSTANTCOLUMN.ISEXTENDABLECOL   
         || ' FROM '
         || LSFROMSPEC
         || ' WHERE part_no = NULL';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';

      OPEN AQSECTIONITEMS FOR LSSQLNULL USING ASPARTNO,
      ANREVISION,
      0,
      ASPARTNO,
      ANREVISION;

      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     LSMETHOD,
                                                     'POST',
                                                     GTERRORS );
      LSSELECT :=
            ' PARTNO '
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
         || ', ITEMTYPE '
         || IAPICONSTANTCOLUMN.ITEMTYPECOL
         || ', ITEMID '
         || IAPICONSTANTCOLUMN.ITEMIDCOL
         || ', ITEMREVISION '
         || IAPICONSTANTCOLUMN.ITEMREVISIONCOL
         || ', ITEMOWNER '
         || IAPICONSTANTCOLUMN.ITEMOWNERCOL
         || ', ITEMINFO '
         || IAPICONSTANTCOLUMN.ITEMINFOCOL
         || ', SEQUENCE '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ', SECTIONSEQUENCENUMBER '
         || IAPICONSTANTCOLUMN.SECTIONSEQUENCENUMBERCOL
         || ', DISPLAYFORMATID '
         || IAPICONSTANTCOLUMN.DISPLAYFORMATIDCOL
         || ', DISPLAYFORMATREVISION '
         || IAPICONSTANTCOLUMN.DISPLAYFORMATREVISIONCOL
         || ', ASSOCIATIONID '
         || IAPICONSTANTCOLUMN.ASSOCIATIONIDCOL
         || ', INTERNATIONAL '
         || IAPICONSTANTCOLUMN.INTERNATIONALCOL
         || ', HEADER '
         || IAPICONSTANTCOLUMN.HEADERCOL
         || ', OPTIONAL '
         || IAPICONSTANTCOLUMN.OPTIONALCOL
         || ', EDITABLE '
         || IAPICONSTANTCOLUMN.EDITABLECOL
         || ', INCLUDED '
         || IAPICONSTANTCOLUMN.INCLUDEDCOL
         || ', EXTENDED '
         || IAPICONSTANTCOLUMN.EXTENDEDCOL
         || ', ISEXTENDABLE '
         || IAPICONSTANTCOLUMN.ISEXTENDABLECOL
         || ', ROWINDEX '
         || IAPICONSTANTCOLUMN.ROWINDEXCOL;
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM TABLE( CAST( :gtGetSectionItems AS SpSectionItemTable_Type ) ) ';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQSECTIONITEMS%ISOPEN )
      THEN
         CLOSE AQSECTIONITEMS;
      END IF;

      OPEN AQSECTIONITEMS FOR LSSQL USING GTGETSECTIONITEMS;

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
         THEN
            LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                   AQERRORS );

            
            IAPISPECIFICATIONACCESS.DISABLEARCACHE;

            RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
         ELSE
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );

            
            IAPISPECIFICATIONACCESS.DISABLEARCACHE;

            RETURN( LNRETVAL );
         END IF;
      END IF;

      
      IAPISPECIFICATIONACCESS.DISABLEARCACHE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETSECTIONITEMS;

   
   FUNCTION GETSECTIONS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANINCLUDEDONLY             IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1,
      AQSECTIONS                 OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetSections';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRSECTIONS                    IAPITYPE.SPSECTIONREC_TYPE;
      LRGETSECTIONS                 SPSECTIONRECORD_TYPE
                := SPSECTIONRECORD_TYPE( NULL,
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
                                         NULL,
                                         NULL );
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LNCHUNKCOUNT                  NUMBER := 0;
      LSSELECT                      VARCHAR2( 4096 )
         :=    ' :PartNo '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', :Revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', ss.section_id '
            || IAPICONSTANTCOLUMN.SECTIONIDCOL
            || ', ss.section_rev '
            || IAPICONSTANTCOLUMN.SECTIONREVISIONCOL
            || ', ss.sub_section_id '
            || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
            || ', ss.sub_section_rev '
            || IAPICONSTANTCOLUMN.SUBSECTIONREVISIONCOL
            || ', ss.section_sequence_no '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ', DECODE(ss.type,3,1,0) '
            || IAPICONSTANTCOLUMN.ISBOMSECTIONCOL
            || ', DECODE(ss.type,7,1,0) '
            || IAPICONSTANTCOLUMN.ISPROCESSSECTIONCOL
            || ', iapiFrameSection.IsExtendable(sh.frame_id, sh.frame_rev, sh.frame_owner, ss.section_id, ss.sub_section_id) '
            || IAPICONSTANTCOLUMN.ISEXTENDABLECOL
            || ', DECODE(:EditOnSpec, 0, 0, f_check_item_access(:PartNo, :Revision, ss.section_id, ss.sub_section_id, decode(ss.type, 3, ss.type, 7, ss.type, 0), 0, 0, 0, 0, 1)) '
            || IAPICONSTANTCOLUMN.EDITABLECOL
            || ', DECODE(:ViewOnSpec, 0, 0, f_check_item_access(:PartNo, :Revision, ss.section_id, ss.sub_section_id, decode(ss.type, 3, ss.type, 7, ss.type, 0), 0, 0, 0, 0, 2)) '
            || IAPICONSTANTCOLUMN.VISIBLECOL
            || ', f_get_locked(:PartNo, :Revision, ss.section_id, ss.sub_section_id) '
            || IAPICONSTANTCOLUMN.LOCKEDCOL;
      LSSELECTFRAME                 VARCHAR2( 4096 )
         :=    ' :PartNo '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', :Revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', fs.section_id '
            || IAPICONSTANTCOLUMN.SECTIONIDCOL
            || ', fs.section_rev '
            || IAPICONSTANTCOLUMN.SECTIONREVISIONCOL
            || ', fs.sub_section_id '
            || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
            || ', fs.sub_section_rev '
            || IAPICONSTANTCOLUMN.SUBSECTIONREVISIONCOL
            || ', fs.section_sequence_no '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ', DECODE(fs.type,3,1,0) '
            || IAPICONSTANTCOLUMN.ISBOMSECTIONCOL
            || ', DECODE(fs.type,7,1,0) '
            || IAPICONSTANTCOLUMN.ISPROCESSSECTIONCOL
            || ', DECODE( fs.sc_ext, ''Y'', 1, 0 ) '
            || IAPICONSTANTCOLUMN.ISEXTENDABLECOL
            || ', DECODE(:EditOnSpec, 0, 0, f_check_item_access(:PartNo, :Revision, fs.section_id, fs.sub_section_id, decode(fs.type, 3, fs.type, 7, fs.type, 0), 0, 0, 0, 0, 1)) '
            || IAPICONSTANTCOLUMN.EDITABLECOL
            || ', DECODE(:ViewOnSpec, 0, 0, f_check_item_access(:PartNo, :Revision, fs.section_id, fs.sub_section_id, decode(fs.type, 3, fs.type, 7, fs.type, 0), 0, 0, 0, 0, 2)) '
            || IAPICONSTANTCOLUMN.VISIBLECOL
            || ', f_get_locked(:PartNo, :Revision, fs.section_id, fs.sub_section_id) '
            || IAPICONSTANTCOLUMN.LOCKEDCOL;
      LSNOFRAMESELECT               VARCHAR2( 4096 )
         :=    ' :PartNo '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', :Revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', ss.section_id '
            || IAPICONSTANTCOLUMN.SECTIONIDCOL
            || ', ss.section_rev '
            || IAPICONSTANTCOLUMN.SECTIONREVISIONCOL
            || ', ss.sub_section_id '
            || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
            || ', ss.sub_section_rev '
            || IAPICONSTANTCOLUMN.SUBSECTIONREVISIONCOL
            || ', ss.section_sequence_no '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ', DECODE(ss.type,3,1,0) '
            || IAPICONSTANTCOLUMN.ISBOMSECTIONCOL
            || ', DECODE(ss.type,7,1,0) '
            || IAPICONSTANTCOLUMN.ISPROCESSSECTIONCOL
            || ', 0 '
            || IAPICONSTANTCOLUMN.ISEXTENDABLECOL
            || ', DECODE(:EditOnSpec, 0, 0, f_check_item_access(:PartNo, :Revision, ss.section_id, ss.sub_section_id, decode(ss.type, 3, ss.type, 7, ss.type, 0), 0, 0, 0, 0, 1)) '
            || IAPICONSTANTCOLUMN.EDITABLECOL
            || ', DECODE(:ViewOnSpec, 0, 0, f_check_item_access(:PartNo, :Revision, ss.section_id, ss.sub_section_id, decode(ss.type, 3, ss.type, 7, ss.type, 0), 0, 0, 0, 0, 2)) '
            || IAPICONSTANTCOLUMN.VISIBLECOL
            || ', f_get_locked(:PartNo, :Revision, ss.section_id, ss.sub_section_id) '
            || IAPICONSTANTCOLUMN.LOCKEDCOL;
      LSFROMSPECANDFRAME            IAPITYPE.STRING_TYPE :=    ' specification_section ss,'
                                                            || 'SPECIFICATION_HEADER sh,'
                                                            || 'frame_section fs ';
      LSFROMSPECANDHEADER           IAPITYPE.STRING_TYPE :=    ' specification_section ss,'
                                                            || 'SPECIFICATION_HEADER sh ';
      LSFROMSPEC                    IAPITYPE.STRING_TYPE := ' specification_section ss ';
      LSFROMFRAME                   IAPITYPE.STRING_TYPE := ' frame_section fs ';
      LRFRAME                       IAPITYPE.FRAMEREC_TYPE;
      LRSPSECTION                   IAPITYPE.SPSECTIONREC_TYPE;
      LOSPSECTION                   SPSECTIONRECORD_TYPE;
      LNSECTIONS                    NUMBER := 0;
      LNCURSOR                      INTEGER;
      LBFETCHING                    BOOLEAN := TRUE;
      LNROWINDEX                    NUMBER;
      LBFRAMEEXIST                  BOOLEAN := TRUE;
      LSNAME                        VARCHAR2( 60 );
      LNEDIT                        IAPITYPE.BOOLEAN_TYPE;
      LNVIEW                        IAPITYPE.BOOLEAN_TYPE;
   BEGIN
      
      
      

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'asPartNo <'
                           || ASPARTNO
                           || '> anRevision <'
                           || ANREVISION
                           || '> anIncludedOnly <'
                           || ANINCLUDEDONLY
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IAPISPECIFICATIONACCESS.ENABLEARCACHE;

      
      
      
      
      
      IF ( AQSECTIONS%ISOPEN )
      THEN
         CLOSE AQSECTIONS;
      END IF;

      LSSQLNULL :=
            'SELECT '
         || LSSELECT
         || ', -1 '
         || IAPICONSTANTCOLUMN.INCLUDEDCOL   
         || ', NULL '
         || IAPICONSTANTCOLUMN.SECTIONNAMECOL   
         || ', NULL '
         || IAPICONSTANTCOLUMN.NAMECOL   
         || ' FROM '
         || LSFROMSPECANDHEADER
         || ' WHERE ss.part_no = NULL '
         || ' AND ss.revision = NULL '
         || ' AND ss.part_no = sh.part_no '
         || ' and ss.revision = sh.revision ';
      LSSQLNULL :=
             'SELECT a.*, RowNum '
          || IAPICONSTANTCOLUMN.ROWINDEXCOL
          || ', 0 '
          || IAPICONSTANTCOLUMN.PARENTROWINDEXCOL
          || ' FROM ('
          || LSSQLNULL
          || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'SQL Null: '
                           || LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQSECTIONS FOR LSSQLNULL USING ASPARTNO,
      ANREVISION,
      0,
      ASPARTNO,
      ANREVISION,
      0,
      ASPARTNO,
      ANREVISION,
      ASPARTNO,
      ANREVISION;

      GTSECTIONS.DELETE;
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRSECTIONS.PARTNO := ASPARTNO;
      LRSECTIONS.REVISION := ANREVISION;
      LRSECTIONS.INCLUDED := ANINCLUDEDONLY;
      GTSECTIONS( 0 ) := LRSECTIONS;
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      
      
      
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
               
               IAPISPECIFICATIONACCESS.DISABLEARCACHE;

               RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
            END IF;
         ELSE
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );

            
            IAPISPECIFICATIONACCESS.DISABLEARCACHE;

            RETURN( LNRETVAL );
         END IF;
      END IF;

      
      
      LNEDIT := F_CHECK_ITEM_ACCESS( ASPARTNO,
                                     ANREVISION,
                                     ANACCESSLEVEL => 1 );
      LNVIEW := F_CHECK_ITEM_ACCESS( ASPARTNO,
                                     ANREVISION,
                                     ANACCESSLEVEL => 0 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Edit access on specification <'
                           || LNEDIT
                           || '>'
                           || 'View access on specification <'
                           || LNVIEW
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPISPECIFICATION.GETFRAME( ASPARTNO,
                                              ANREVISION,
                                              LRFRAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );

         
         IAPISPECIFICATIONACCESS.DISABLEARCACHE;

         RETURN( LNRETVAL );
      END IF;

      LNRETVAL := IAPIFRAME.EXISTID( LRFRAME.FRAMENO,
                                     LRFRAME.REVISION,
                                     LRFRAME.OWNER );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         LBFRAMEEXIST := FALSE;
            
         
         LSSQL :=
               'SELECT DISTINCT '
            || LSNOFRAMESELECT
            || ', 1 '
            || IAPICONSTANTCOLUMN.INCLUDEDCOL   
            || ' FROM '
            || LSFROMSPEC
            || ' WHERE ss.part_no = :PartNo '
            || ' AND ss.revision = :Revision '
            || ' AND DECODE(:ViewOnSpec, 0, 0, f_check_item_access(ss.part_no, ss.revision, ss.section_id, ss.sub_section_id, decode(ss.type, 3, ss.type, 7, ss.type, 0))) = 1 ';
      ELSE
         
         
         LSSQL :=
               'SELECT DISTINCT '
            || LSSELECT
            || ', 1 '
            || IAPICONSTANTCOLUMN.INCLUDEDCOL   
            || ' FROM '
            || LSFROMSPECANDHEADER
            || ' WHERE ss.part_no = :PartNo '
            || ' AND ss.revision = :Revision '
            || ' AND ss.part_no = sh.part_no '
            || ' and ss.revision = sh.revision '
            || ' AND DECODE(:ViewOnSpec, 0, 0, f_check_item_access(ss.part_no, ss.revision, ss.section_id, ss.sub_section_id, decode(ss.type, 3, ss.type, 7, ss.type, 0))) = 1 ';
      END IF;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.VIEWBOMALLOWED = 0
      THEN
         LSSQL :=    LSSQL
                  || ' AND ss.type NOT IN (3,7)';
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Exclude BoM and Process Data',
                              IAPICONSTANT.INFOLEVEL_3 );
      END IF;

      
      IF ANINCLUDEDONLY = 0
      THEN
         LSSQL :=
               LSSQL
            || ' UNION '
            || ' SELECT  DISTINCT '
            || LSSELECTFRAME
            || ', 0 '
            || IAPICONSTANTCOLUMN.INCLUDEDCOL   
            || ' FROM '
            || LSFROMFRAME
            || ' WHERE frame_no = :FrameNo '
            || ' AND revision = :FrameRevision '
            || ' AND owner = :FrameOwner '
            || ' AND DECODE(:ViewOnSpec, 0, 0, f_check_item_access(:PartNo, :Revision, fs.section_id, fs.sub_section_id, decode(fs.type, 3, fs.type, 7, fs.type, 0))) = 1 '
            || ' AND (section_id, sub_section_id, ref_id) '
            || ' NOT IN (SELECT section_id, sub_section_id, ref_id FROM '
            || LSFROMSPEC
            || ' WHERE ss.part_no = :PartNo '
            || ' AND ss.revision = :Revision '
            || ' UNION '
            || ' SELECT section_id, sub_section_id, ref_id FROM itfrmvsc '
            || ' WHERE frame_no = :FrameNo '
            || ' AND revision = :FrameRevision '
            || ' AND owner = :FrameOwner '
            || ' AND view_id = :FrameMaskId '   
            || ' AND mandatory = ''H'' )';

         IF IAPIGENERAL.SESSION.APPLICATIONUSER.VIEWBOMALLOWED = 0
         THEN
            LSSQL :=    LSSQL
                     || ' AND fs.type NOT IN (3,7)';
         END IF;
      END IF;

      LSSQL :=
            LSSQL
         || ' UNION'
         || ' SELECT DISTINCT'
         || ' :PartNo PARTNO,'
         || ' :Revision REVISION,'
         || ' sc.section_id SECTIONID,'
         || ' sc.section_rev SECTIONREVISION,'
         || ' sc.sub_section_id SUBSECTIONID,'
         || ' sc.sub_section_rev SUBSECTIONREVISION,'
         || ' sc.section_sequence_no SEQUENCE,'
         || ' DECODE(sc.type,'
         || ' 3,'
         || ' 1,'
         || ' 0) ISBOMSECTION,'
         || ' DECODE(sc.type,'
         || ' 7,'
         || ' 1,'
         || ' 0) ISPROCESSSECTION,'
         || ' 1 ISEXTENDABLE,'
         || ' DECODE(:EditOnSpec, 0, 0, f_check_item_access(:PartNo, :Revision, sc.section_id, sc.sub_section_id, decode(sc.type, 3, sc.type, 7, sc.type, 0), 0, 0, 0, 0, 1)) '
         || IAPICONSTANTCOLUMN.EDITABLECOL
         || ' ,DECODE(:ViewOnSpec, 0, 0, f_check_item_access(:PartNo, :Revision, sc.section_id, sc.sub_section_id, decode(sc.type, 3, sc.type, 7, sc.type, 0), 0, 0, 0, 0, 2)) '
         || IAPICONSTANTCOLUMN.VISIBLECOL
         || ', f_get_locked(:PartNo, :Revision, sc.section_id, sc.sub_section_id) '
         || IAPICONSTANTCOLUMN.LOCKEDCOL
         || ' ,1 INCLUDED'
         || ' FROM specification_section sc, '
         || ' itshext'
         || ' WHERE'
         || ' sc.part_no = :PartNo AND'
         || ' sc.revision = :Revision AND'
         || ' sc.part_no = itshext.part_no AND'
         || ' sc.revision = itshext.revision AND'
         || ' sc.section_id = itshext.section_id AND'
         || ' sc.sub_section_id = itshext.sub_section_id AND'
         || ' sc.type = itshext.type '
         || ' AND DECODE(:ViewOnSpec, 0, 0, f_check_item_access(sc.part_no, sc.revision, sc.section_id, sc.sub_section_id, decode(sc.type, 3, sc.type, 7, sc.type, 0))) = 1 ';
      LSSQL :=
            'SELECT a.* '
         || ', f_sch_descr(1, '
         || IAPICONSTANTCOLUMN.SECTIONIDCOL
         || ', '
         || IAPICONSTANTCOLUMN.SECTIONREVISIONCOL
         || ') '
         || IAPICONSTANTCOLUMN.SECTIONNAMECOL
         || ', f_sbh_descr(1, '
         || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
         || ', '
         || IAPICONSTANTCOLUMN.SUBSECTIONREVISIONCOL
         || ') '
         || IAPICONSTANTCOLUMN.SUBSECTIONNAMECOL
         || ', RowNum '
         || IAPICONSTANTCOLUMN.ROWINDEXCOL
         || ', 0 '
         || IAPICONSTANTCOLUMN.PARENTROWINDEXCOL
         || ' FROM ('
         || ' SELECT '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', '
         || IAPICONSTANTCOLUMN.SECTIONIDCOL
         || ', MAX('
         || IAPICONSTANTCOLUMN.SECTIONREVISIONCOL
         || ') '
         || IAPICONSTANTCOLUMN.SECTIONREVISIONCOL
         || ', '
         || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
         || ', MAX('
         || IAPICONSTANTCOLUMN.SUBSECTIONREVISIONCOL
         || ') '
         || IAPICONSTANTCOLUMN.SUBSECTIONREVISIONCOL




         || ', MAX('
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ') '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ', MAX('
         || IAPICONSTANTCOLUMN.ISBOMSECTIONCOL
         || ') '
         || IAPICONSTANTCOLUMN.ISBOMSECTIONCOL
         || ', MAX('
         || IAPICONSTANTCOLUMN.ISPROCESSSECTIONCOL
         || ') '
         || IAPICONSTANTCOLUMN.ISPROCESSSECTIONCOL
         || ', MAX('
         || IAPICONSTANTCOLUMN.ISEXTENDABLECOL
         || ') '
         || IAPICONSTANTCOLUMN.ISEXTENDABLECOL
         || ', MAX('
         || IAPICONSTANTCOLUMN.EDITABLECOL
         || ') '
         || IAPICONSTANTCOLUMN.EDITABLECOL
         || ', MAX('
         || IAPICONSTANTCOLUMN.VISIBLECOL
         || ') '
         || IAPICONSTANTCOLUMN.VISIBLECOL
         || ', MAX('
         || IAPICONSTANTCOLUMN.LOCKEDCOL
         || ') '
         || IAPICONSTANTCOLUMN.LOCKEDCOL
         || ', TO_NUMBER(MAX('
         || IAPICONSTANTCOLUMN.INCLUDEDCOL
         || '), ''9'') '
         || IAPICONSTANTCOLUMN.INCLUDEDCOL
         || ' FROM ( '
         || LSSQL
         || ') GROUP BY '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', '
         || IAPICONSTANTCOLUMN.SECTIONIDCOL
         || ', '
         || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
         || ' ORDER BY '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ') a';
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'SQL for Get Sections: ',
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'End SQL for Get Sections: ',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQSECTIONS%ISOPEN )
      THEN
         CLOSE AQSECTIONS;
      END IF;

      
      LNCURSOR := DBMS_SQL.OPEN_CURSOR;
      DBMS_SQL.PARSE( LNCURSOR,
                      LSSQL,
                      DBMS_SQL.NATIVE );
      DBMS_SQL.BIND_VARIABLE( LNCURSOR,
                              ':PartNo',
                              ASPARTNO );
      DBMS_SQL.BIND_VARIABLE( LNCURSOR,
                              ':Revision',
                              ANREVISION );
      DBMS_SQL.BIND_VARIABLE( LNCURSOR,
                              ':EditOnSpec',
                              LNEDIT );
      DBMS_SQL.BIND_VARIABLE( LNCURSOR,
                              ':ViewOnSpec',
                              LNVIEW );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Argumens for Get Sections - PartNo <'
                           || ASPARTNO
                           || '> Revision <'
                           || ANREVISION
                           || '> EditOnSpec <'
                           || LNEDIT
                           || '> ViewOnSpec <'
                           || LNVIEW
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ANINCLUDEDONLY = 0
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Argumens for Get Sections - FrameNo <'
                              || LRFRAME.FRAMENO
                              || '> FrameRevision <'
                              || LRFRAME.REVISION
                              || '> FrameOwner <'
                              || LRFRAME.OWNER
                              || '> FrameMaskId <'
                              || NVL( LRFRAME.MASKID,
                                      -1 )
                              || '>',
                              IAPICONSTANT.INFOLEVEL_3 );
         DBMS_SQL.BIND_VARIABLE( LNCURSOR,
                                 ':FrameNo',
                                 LRFRAME.FRAMENO );
         DBMS_SQL.BIND_VARIABLE( LNCURSOR,
                                 ':FrameRevision',
                                 LRFRAME.REVISION );
         DBMS_SQL.BIND_VARIABLE( LNCURSOR,
                                 ':FrameOwner',
                                 LRFRAME.OWNER );
         DBMS_SQL.BIND_VARIABLE( LNCURSOR,
                                 ':FrameMaskId',
                                 NVL( LRFRAME.MASKID,
                                      -1 ) );
      END IF;

      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              1,
                              LRSPSECTION.PARTNO,
                              18 );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              2,
                              LRSPSECTION.REVISION );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              3,
                              LRSPSECTION.SECTIONID );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              4,
                              LRSPSECTION.SECTIONREVISION );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              5,
                              LRSPSECTION.SUBSECTIONID );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              6,
                              LRSPSECTION.SUBSECTIONREVISION );


























      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              7,
                              LRSPSECTION.SEQUENCE );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              8,
                              LRSPSECTION.ISBOMSECTION );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              9,
                              LRSPSECTION.ISPROCESSSECTION );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              10,
                              LRSPSECTION.ISEXTENDABLE );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              11,
                              LRSPSECTION.EDITABLE );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              12,
                              LRSPSECTION.VISIBLE );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              13,
                              LRSPSECTION.LOCKED,
                              8 );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              14,
                              LRSPSECTION.INCLUDED );

      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              15,
                              LRSPSECTION.SECTIONNAME,
                              60 );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              16,
                              LRSPSECTION.SUBSECTIONNAME,
                              60 );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              17,
                              LRSPSECTION.ROWINDEX );
      DBMS_SQL.DEFINE_COLUMN( LNCURSOR,
                              18,
                              LRSPSECTION.PARENTROWINDEX );
      LNRETVAL := DBMS_SQL.EXECUTE( LNCURSOR );
      GTGETSECTIONS.DELETE;

      WHILE( LBFETCHING )
      LOOP
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Filling in GTSections:',
                              IAPICONSTANT.INFOLEVEL_3 );
         LNRETVAL := DBMS_SQL.FETCH_ROWS( LNCURSOR );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Rows fetched',
                              IAPICONSTANT.INFOLEVEL_3 );

         IF ( LNRETVAL = 0 )
         THEN
            LBFETCHING := FALSE;
         ELSE
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 'Set column values',
                                 IAPICONSTANT.INFOLEVEL_3 );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   1,
                                   LRSPSECTION.PARTNO );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   2,
                                   LRSPSECTION.REVISION );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   3,
                                   LRSPSECTION.SECTIONID );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   4,
                                   LRSPSECTION.SECTIONREVISION );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   5,
                                   LRSPSECTION.SUBSECTIONID );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   6,
                                   LRSPSECTION.SUBSECTIONREVISION );

























            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   7,
                                   LRSPSECTION.SEQUENCE );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   8,
                                   LRSPSECTION.ISBOMSECTION );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   9,
                                   LRSPSECTION.ISPROCESSSECTION );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   10,
                                   LRSPSECTION.ISEXTENDABLE );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   11,
                                   LRSPSECTION.EDITABLE );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   12,
                                   LRSPSECTION.VISIBLE );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   13,
                                   LRSPSECTION.LOCKED );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   14,
                                   LRSPSECTION.INCLUDED );

            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   15,
                                   LRSPSECTION.SECTIONNAME );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   16,
                                   LRSPSECTION.SUBSECTIONNAME );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   17,
                                   LRSPSECTION.ROWINDEX );
            DBMS_SQL.COLUMN_VALUE( LNCURSOR,
                                   18,
                                   LRSPSECTION.PARENTROWINDEX );
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    'extend gtSections, current count:'
                                 || GTGETSECTIONS.COUNT,
                                 IAPICONSTANT.INFOLEVEL_3 );
            LNSECTIONS :=   LNSECTIONS
                          + 1;
            GTGETSECTIONS.EXTEND;
            LOSPSECTION :=
               SPSECTIONRECORD_TYPE( LRSPSECTION.PARTNO,
                                     LRSPSECTION.REVISION,
                                     LRSPSECTION.SECTIONID,
                                     LRSPSECTION.SECTIONREVISION,
                                     LRSPSECTION.SUBSECTIONID,
                                     LRSPSECTION.SUBSECTIONREVISION,
                                     LRSPSECTION.SEQUENCE,
                                     LRSPSECTION.ISBOMSECTION,
                                     LRSPSECTION.ISPROCESSSECTION,
                                     LRSPSECTION.ISEXTENDABLE,
                                     LRSPSECTION.EDITABLE,
                                     LRSPSECTION.VISIBLE,
                                     LRSPSECTION.LOCKED,
                                     LRSPSECTION.INCLUDED,
                                     LRSPSECTION.SECTIONNAME,
                                     LRSPSECTION.SUBSECTIONNAME,
                                     LRSPSECTION.ROWINDEX,
                                     LRSPSECTION.PARENTROWINDEX );
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 'About to add record to gtSections',
                                 IAPICONSTANT.INFOLEVEL_3 );
            GTGETSECTIONS( LNSECTIONS ) := LOSPSECTION;
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 'Record added to gtSections',
                                 IAPICONSTANT.INFOLEVEL_3 );
         END IF;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Number of entries in gtSections:'
                           || GTGETSECTIONS.COUNT,
                           IAPICONSTANT.INFOLEVEL_3 );
      DBMS_SQL.CLOSE_CURSOR( LNCURSOR );
      
      
      
      LNROWINDEX := 0;

      IF ( GTGETSECTIONS.COUNT > 0 )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'gtGetSections is not empty',
                              IAPICONSTANT.INFOLEVEL_3 );

         FOR LNCOUNT IN GTGETSECTIONS.FIRST .. GTGETSECTIONS.LAST
         LOOP
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    'New entry - Section Id:'
                                 || GTGETSECTIONS( LNCOUNT ).SECTIONID
                                 || ' Sub Section Id: '
                                 || GTGETSECTIONS( LNCOUNT ).SUBSECTIONID,
                                 IAPICONSTANT.INFOLEVEL_3 );

            IF GTGETSECTIONS( LNCOUNT ).SUBSECTIONID <> 0
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                       'Evaluate Sub Section :'
                                    || GTGETSECTIONS( LNCOUNT ).SUBSECTIONID,
                                    IAPICONSTANT.INFOLEVEL_3 );

               SELECT COUNT( * )
                 INTO LNRETVAL
                 FROM TABLE( GTGETSECTIONS ) T
                WHERE T.SECTIONID = GTGETSECTIONS( LNCOUNT ).SECTIONID
                  AND T.SUBSECTIONID = 0;

               IF LNRETVAL = 0
               THEN
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                          'Add new section :'
                                       || GTGETSECTIONS( LNCOUNT ).SUBSECTIONID,
                                       IAPICONSTANT.INFOLEVEL_3 );
                  GTGETSECTIONS.EXTEND;
                  LNROWINDEX :=   LNROWINDEX
                                + 1;
                  LOSPSECTION :=
                     SPSECTIONRECORD_TYPE( GTGETSECTIONS( LNCOUNT ).PARTNO,
                                           GTGETSECTIONS( LNCOUNT ).REVISION,
                                           GTGETSECTIONS( LNCOUNT ).SECTIONID,
                                           GTGETSECTIONS( LNCOUNT ).SECTIONREVISION,

                                           0,
                                           100,
                                           0,
                                           0,   
                                           0,   
                                           GTGETSECTIONS( LNCOUNT ).ISEXTENDABLE,
                                           GTGETSECTIONS( LNCOUNT ).EDITABLE,
                                           GTGETSECTIONS( LNCOUNT ).VISIBLE,
                                           GTGETSECTIONS( LNCOUNT ).LOCKED,
                                           GTGETSECTIONS( LNCOUNT ).INCLUDED,
                                           GTGETSECTIONS( LNCOUNT ).SECTIONNAME,
                                           '(none)',
                                           LNROWINDEX,
                                           0 )
                                              

                  ;
                  LNSECTIONS :=   LNSECTIONS
                                + 1;
                  GTGETSECTIONS( LNSECTIONS ) := LOSPSECTION;
               END IF;
            END IF;

            LNROWINDEX :=   LNROWINDEX
                          + 1;
            GTGETSECTIONS( LNCOUNT ).ROWINDEX := LNROWINDEX;
         END LOOP;

         
         FOR LNCOUNT IN GTGETSECTIONS.FIRST .. GTGETSECTIONS.LAST
         LOOP
            IF GTGETSECTIONS( LNCOUNT ).SUBSECTIONID <> 0
            THEN
               SELECT ROWINDEX
                 INTO LNROWINDEX
                 FROM TABLE( GTGETSECTIONS ) T
                WHERE T.SECTIONID = GTGETSECTIONS( LNCOUNT ).SECTIONID
                  AND T.SUBSECTIONID = 0;
            ELSE
               LNROWINDEX := 0;
            END IF;

            GTGETSECTIONS( LNCOUNT ).PARENTROWINDEX := LNROWINDEX;
         END LOOP;
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'RowIndex: '
                           || LNROWINDEX,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      

      
      IF ( AQSECTIONS%ISOPEN )
      THEN
         CLOSE AQSECTIONS;
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'SQL Null: '
                           || LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQSECTIONS FOR LSSQLNULL USING ASPARTNO,
      ANREVISION,
      0,
      ASPARTNO,
      ANREVISION,
      0,
      ASPARTNO,
      ANREVISION,
      ASPARTNO,
      ANREVISION;

      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     LSMETHOD,
                                                     'POST',
                                                     GTERRORS );
      LSSELECT :=
            ' PARTNO '
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
         || ', SEQUENCE '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ', ISBOMSECTION '
         || IAPICONSTANTCOLUMN.ISBOMSECTIONCOL
         || ', ISPROCESSSECTION '
         || IAPICONSTANTCOLUMN.ISPROCESSSECTIONCOL
         || ', ISEXTENDABLE '
         || IAPICONSTANTCOLUMN.ISEXTENDABLECOL
         || ', EDITABLE '
         || IAPICONSTANTCOLUMN.EDITABLECOL
         || ', VISIBLE '
         || IAPICONSTANTCOLUMN.VISIBLECOL
         || ', LOCKED '
         || IAPICONSTANTCOLUMN.LOCKEDCOL
         || ', INCLUDED '
         || IAPICONSTANTCOLUMN.INCLUDEDCOL
         || ', SECTIONNAME '
         || IAPICONSTANTCOLUMN.SECTIONNAMECOL
         || ', DECODE( SUBSECTIONID,0, SECTIONNAME, SUBSECTIONNAME ) '
         || IAPICONSTANTCOLUMN.NAMECOL
         || ', ROWINDEX '
         || IAPICONSTANTCOLUMN.ROWINDEXCOL
         || ', PARENTROWINDEX '
         || IAPICONSTANTCOLUMN.PARENTROWINDEXCOL;
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM TABLE( CAST( :gtGetSections AS SpSectionDataTable_Type) ) '
               || ' ORDER BY  RowIndex ';

      
      IF ( AQSECTIONS%ISOPEN )
      THEN
         CLOSE AQSECTIONS;
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'SQL Post Action: '
                           || LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQSECTIONS FOR LSSQL USING GTGETSECTIONS;

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
         THEN
            LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                   AQERRORS );

            
            IAPISPECIFICATIONACCESS.DISABLEARCACHE;

            RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
         ELSE
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );

           
           IAPISPECIFICATIONACCESS.DISABLEARCACHE;

           RETURN( LNRETVAL );
         END IF;
      END IF;

     
     IAPISPECIFICATIONACCESS.DISABLEARCACHE;

     RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   
   
   
   
   
   
    
   END GETSECTIONS;

   
   FUNCTION ISITEMEXTENDED(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANEXTENDED                 OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsItemExtended';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNITEMID                      IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( ANTYPE = IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC )
      THEN
         LNITEMID := 0;   
      ELSE
         LNITEMID := ANITEMID;
      END IF;

      SELECT DECODE( COUNT( * ),
                     0, 0,
                     1 )
        INTO ANEXTENDED
        FROM ITSHEXT
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND SECTION_ID = ANSECTIONID
         AND SUB_SECTION_ID = ANSUBSECTIONID
         AND TYPE = ANTYPE
         AND REF_ID = LNITEMID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ISITEMEXTENDED;

   
   FUNCTION ISITEMEXTENDED(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.BOOLEAN_TYPE
   IS
       
       
       
       
       
       
       
       
      
       
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsItemExtended';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNEXTENDED                    IAPITYPE.BOOLEAN_TYPE := 0;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPISPECIFICATIONSECTION.ISITEMEXTENDED( ASPARTNO,
                                                           ANREVISION,
                                                           ANSECTIONID,
                                                           ANSUBSECTIONID,
                                                           ANTYPE,
                                                           ANITEMID,
                                                           LNEXTENDED );
      
      RETURN( LNEXTENDED );
   END ISITEMEXTENDED;

   
   FUNCTION ISACTIONALLOWED(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANITEMREVISION             IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      ANITEMOWNER                IN       IAPITYPE.OWNER_TYPE DEFAULT NULL,
      ASACTION                   IN       IAPITYPE.STRING_TYPE,
      ANALLOWED                  OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsActionAllowed';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRFRAME                       IAPITYPE.FRAMEREC_TYPE;
      LSMANDATORY                   IAPITYPE.MANDATORY_TYPE;
      LNCOUNT                       NUMBER;
      LNITEMID                      IAPITYPE.ID_TYPE;
      LNSECTIONSEQUENCENUMBER       IAPITYPE.SPSECTIONSEQUENCENUMBER_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPISPECIFICATION.GETFRAME( ASPARTNO,
                                              ANREVISION,
                                              LRFRAME );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'lrFrame.FrameNo: '
                           || LRFRAME.FRAMENO,
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'lrFrame.Revision: '
                           || LRFRAME.REVISION,
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'lrFrame.Owner: '
                           || LRFRAME.OWNER,
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'anSectionId: '
                           || ANSECTIONID,
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'anSubSectionId: '
                           || ANSUBSECTIONID,
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'anSubSectionId: '
                           || ANSUBSECTIONID,
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'anType: '
                           || ANTYPE,
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'anItemId: '
                           || ANITEMID,
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'anItemRevision: '
                           || ANITEMREVISION,
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF ( ANTYPE = IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC )
      THEN
         LNITEMID := 0;   
      ELSE
         LNITEMID := ANITEMID;
      END IF;

      IF ( LRFRAME.MASKID IS NULL )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'No mask specified; check mandatory flag in frame_section.',
                              IAPICONSTANT.INFOLEVEL_3 );

         
         BEGIN
            SELECT MANDATORY
              INTO LSMANDATORY
              FROM FRAME_SECTION
             WHERE FRAME_NO = LRFRAME.FRAMENO
               AND REVISION = LRFRAME.REVISION
               AND OWNER = LRFRAME.OWNER
               AND SECTION_ID = ANSECTIONID
               AND SUB_SECTION_ID = ANSUBSECTIONID
               AND TYPE = ANTYPE
               AND REF_ID = LNITEMID
               AND DECODE( ANITEMREVISION,
                           NULL, 1,
                           REF_VER ) = NVL( ANITEMREVISION,
                                            1 )
               AND DECODE( ANITEMOWNER,
                           NULL, 1,
                           REF_OWNER ) = NVL( ANITEMOWNER,
                                              1 );
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;   
         END;
      ELSE
         
         BEGIN
            SELECT DISTINCT SECTION_SEQUENCE_NO
                       INTO LNSECTIONSEQUENCENUMBER
                       FROM FRAME_SECTION
                      WHERE FRAME_NO = LRFRAME.FRAMENO
                        AND REVISION = LRFRAME.REVISION
                        AND OWNER = LRFRAME.OWNER
                        AND SECTION_ID = ANSECTIONID
                        AND SUB_SECTION_ID = ANSUBSECTIONID
                        AND TYPE = ANTYPE
                        AND REF_ID = LNITEMID
                        AND DECODE( ANITEMREVISION,
                                    NULL, 1,
                                    REF_VER ) = NVL( ANITEMREVISION,
                                                     1 )
                        AND DECODE( ANITEMOWNER,
                                    NULL, 1,
                                    REF_OWNER ) = NVL( ANITEMOWNER,
                                                       1 );

            SELECT MANDATORY
              INTO LSMANDATORY
              FROM ITFRMVSC
             WHERE VIEW_ID = LRFRAME.MASKID
               AND FRAME_NO = LRFRAME.FRAMENO
               AND REVISION = LRFRAME.REVISION
               AND OWNER = LRFRAME.OWNER
               AND SECTION_ID = ANSECTIONID
               AND SUB_SECTION_ID = ANSUBSECTIONID
               AND TYPE = ANTYPE
               AND REF_ID = LNITEMID
               AND SECTION_SEQUENCE_NO = LNSECTIONSEQUENCENUMBER;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;   
         END;
      END IF;





      IF ( LSMANDATORY = IAPICONSTANT.FLAG_YES )
      THEN
         IF ( ASACTION IN( 'SAVE', 'ADD' ) )
         THEN
            ANALLOWED := 1;
         ELSE
            ANALLOWED := 0;
         END IF;
      ELSE
         ANALLOWED := 1;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ISACTIONALLOWED;

   
   FUNCTION ISITEMEXTENDABLE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANEXTENDABLE               OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsItemExtendable';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRFRAME                       IAPITYPE.FRAMEREC_TYPE;
      LNEXTENDED                    IAPITYPE.BOOLEAN_TYPE := 0;
      LNITEMID                      IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
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

      
      
      LNRETVAL := IAPIFRAMESECTION.EXISTID( LRFRAME.FRAMENO,
                                            LRFRAME.REVISION,
                                            LRFRAME.OWNER,
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
      LNRETVAL := IAPISPECIFICATIONSECTION.ISITEMEXTENDED( ASPARTNO,
                                                           ANREVISION,
                                                           ANSECTIONID,
                                                           ANSUBSECTIONID,
                                                           ANTYPE,
                                                           ANITEMID,
                                                           LNEXTENDED );

      IF ( ANTYPE = IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC )
      THEN
         LNITEMID := 0;   
      ELSE
         LNITEMID := ANITEMID;
      END IF;

      IF LNEXTENDED = 1
      THEN
         ANEXTENDABLE := LNEXTENDED;
      ELSE
         SELECT DISTINCT DECODE( REF_EXT,
                                 IAPICONSTANT.FLAG_YES, 1,
                                 0 )
                    INTO ANEXTENDABLE
                    FROM FRAME_SECTION
                   WHERE FRAME_NO = LRFRAME.FRAMENO
                     AND REVISION = LRFRAME.REVISION
                     AND OWNER = LRFRAME.OWNER
                     AND SECTION_ID = ANSECTIONID
                     AND SUB_SECTION_ID = ANSUBSECTIONID
                     AND TYPE = ANTYPE
                     AND REF_ID = LNITEMID;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ISITEMEXTENDABLE;

   
   FUNCTION CHECKSECTIONLOGGING(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSSESSION                     IAPITYPE.STRING_TYPE;
      LNTIME                        IAPITYPE.NUMVAL_TYPE;
      LNACCESSGROUP                 IAPITYPE.ID_TYPE;
      LNWORKFLOWGROUP               IAPITYPE.ID_TYPE;
      LNTYPE                        IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE;
      LBMRP                         IAPITYPE.BOOLEAN_TYPE;
      LBPRODACCESS                  IAPITYPE.BOOLEAN_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckSectionLogging';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
      LDLOGINDATE                   IAPITYPE.DATE_TYPE;
      LDLASTUPDATEDATE              IAPITYPE.DATE_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPISPECIFICATION.GETSTATUSTYPE( ASPARTNO,
                                                   ANREVISION,
                                                   LSSTATUSTYPE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF LSSTATUSTYPE = IAPICONSTANT.STATUSTYPE_DEVELOPMENT
      THEN
         LSSESSION := DBMS_SESSION.UNIQUE_SESSION_ID;

         SELECT TIMESTAMP
           INTO LDLOGINDATE
           FROM ITSCUSRLOG LG
          WHERE LG.SESSION_ID = LSSESSION
            AND LG.USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
            AND LG.PART_NO = ASPARTNO
            AND LG.REVISION = ANREVISION
            AND LG.VW_HANDLE = AFHANDLE
            AND LG.SECTION_ID = ANSECTIONID
            AND LG.SUB_SECTION_ID = ANSUBSECTIONID;

         SELECT MAX( UPD_TIMESTAMP )
           INTO LDLASTUPDATEDATE
           FROM ITSCUSRLOG LG
          WHERE LG.PART_NO = ASPARTNO
            AND LG.REVISION = ANREVISION
            AND LG.SECTION_ID = ANSECTIONID
            AND LG.SUB_SECTION_ID = ANSUBSECTIONID
            AND LG.VW_HANDLE <> AFHANDLE;

         LNTIME :=(   LDLOGINDATE
                    - LDLASTUPDATEDATE );

         IF LNTIME < 0
         THEN
        
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                IAPICONSTANTDBERROR.DBERR_SAVEAFTERMOD2,
                                                ASPARTNO,
                                                ANREVISION,
                                                
                                                
                                                F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSECTIONID, 0) );
                                                

            RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
         ELSE
            RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
         END IF;
      ELSE
         SELECT MAX( TYPE )
           INTO LNTYPE
           FROM SPECIFICATION_SECTION
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID;

         IF LNTYPE = IAPICONSTANT.SECTIONTYPE_BOM
         THEN
            SELECT MAX( DECODE( A.MRP_UPDATE,
                                'Y', 1,
                                0 ) )
              INTO LBMRP
              FROM USER_ACCESS_GROUP A,
                   USER_GROUP_LIST B
             WHERE A.USER_GROUP_ID = B.USER_GROUP_ID
               AND B.USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

            SELECT MAX( DECODE( PROD_ACCESS,
                                'Y', 1,
                                0 ) )
              INTO LBPRODACCESS
              FROM APPLICATION_USER
             WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

            IF   LBMRP
               * LBPRODACCESS = 1
            THEN
               LSSESSION := DBMS_SESSION.UNIQUE_SESSION_ID;

               SELECT TIMESTAMP
                 INTO LDLOGINDATE
                 FROM ITSCUSRLOG LG
                WHERE LG.SESSION_ID = LSSESSION
                  AND LG.USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
                  AND LG.PART_NO = ASPARTNO
                  AND LG.REVISION = ANREVISION
                  AND LG.VW_HANDLE = AFHANDLE
                  AND LG.SECTION_ID = ANSECTIONID
                  AND LG.SUB_SECTION_ID = ANSUBSECTIONID;

               SELECT MAX( UPD_TIMESTAMP )
                 INTO LDLASTUPDATEDATE
                 FROM ITSCUSRLOG LG
                WHERE LG.PART_NO = ASPARTNO
                  AND LG.REVISION = ANREVISION
                  AND LG.SECTION_ID = ANSECTIONID
                  AND LG.SUB_SECTION_ID = ANSUBSECTIONID
                  AND LG.VW_HANDLE <> AFHANDLE;

               LNTIME :=(   LDLOGINDATE
                          - LDLASTUPDATEDATE );

               IF LNTIME < 0
               THEN
          
                  LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                  LSMETHOD,
                                                                  IAPICONSTANTDBERROR.DBERR_SAVEAFTERMOD2,
                                                                  ASPARTNO,
                                                                  ANREVISION,
                                                                  
                                                                  
                                                                  F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSECTIONID, 0) );
                                                                  
                  RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
               ELSE
                  RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
               END IF;
            END IF;
         END IF;

         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CHECKSECTIONLOGGING;

   
   FUNCTION CREATESECTIONHISTORY(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CreateSectionHistory';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( IAPISPECIFICATION.GBLOGINTOITSCHS = TRUE )
      THEN
      
      BEGIN
         INSERT INTO ITSCHS
                     ( PART_NO,
                       REVISION,
                       SECTION_ID,
                       SUB_SECTION_ID,
                       USER_ID,
                       FORENAME,
                       LAST_NAME )
              VALUES ( ASPARTNO,
                       ANREVISION,
                       ANSECTIONID,
                       ANSUBSECTIONID,
                       IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                       IAPIGENERAL.SESSION.APPLICATIONUSER.FORENAME,
                       IAPIGENERAL.SESSION.APPLICATIONUSER.LASTNAME );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            NULL;
      END;
      
       END IF;
      

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CREATESECTIONHISTORY;

   
   FUNCTION CREATESECTIONLOGGING(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSSESSION                     IAPITYPE.STRING_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CreateSectionLogging';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LSSESSION := DBMS_SESSION.UNIQUE_SESSION_ID;
      LSUSERID := IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

      BEGIN
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM ITSCUSRLOG
          WHERE SESSION_ID = LSSESSION
            AND USER_ID = LSUSERID
            AND VW_HANDLE = AFHANDLE;

         IF LNCOUNT = 1
         THEN
            UPDATE ITSCUSRLOG
               SET TIMESTAMP = SYSDATE,
                   SECTION_ID = ANSECTIONID,
                   SUB_SECTION_ID = ANSUBSECTIONID,
                   PART_NO = ASPARTNO,
                   REVISION = ANREVISION
             WHERE SESSION_ID = LSSESSION
               AND USER_ID = LSUSERID
               AND VW_HANDLE = AFHANDLE;
         END IF;

         INSERT INTO ITSCUSRLOG
                     ( SESSION_ID,
                       USER_ID,
                       PART_NO,
                       REVISION,
                       VW_HANDLE,
                       SECTION_ID,
                       SUB_SECTION_ID )
              VALUES ( LSSESSION,
                       LSUSERID,
                       ASPARTNO,
                       ANREVISION,
                       AFHANDLE,
                       ANSECTIONID,
                       ANSUBSECTIONID );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            UPDATE ITSCUSRLOG
               SET TIMESTAMP = SYSDATE
             WHERE SESSION_ID = LSSESSION
               AND USER_ID = LSUSERID
               AND PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND VW_HANDLE = AFHANDLE
               AND SECTION_ID = ANSECTIONID
               AND SUB_SECTION_ID = ANSUBSECTIONID;
      END;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CREATESECTIONLOGGING;

   
   FUNCTION UPDATESECTIONLOGGING(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSSESSION                     IAPITYPE.STRING_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'UpdateSectionLogging';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LSSESSION := DBMS_SESSION.UNIQUE_SESSION_ID;
      LSUSERID := IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

      UPDATE ITSCUSRLOG
         SET UPD_TIMESTAMP = SYSDATE
       WHERE SESSION_ID = LSSESSION
         AND USER_ID = LSUSERID
         AND PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND VW_HANDLE = AFHANDLE
         AND SECTION_ID = ANSECTIONID
         AND SUB_SECTION_ID = ANSUBSECTIONID;

      IF SQL%NOTFOUND
      THEN
         INSERT INTO ITSCUSRLOG
                     ( SESSION_ID,
                       USER_ID,
                       PART_NO,
                       REVISION,
                       VW_HANDLE,
                       SECTION_ID,
                       SUB_SECTION_ID,
                       UPD_TIMESTAMP )
              VALUES ( LSSESSION,
                       LSUSERID,
                       ASPARTNO,
                       ANREVISION,
                       AFHANDLE,
                       ANSECTIONID,
                       ANSUBSECTIONID,
                       SYSDATE );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END UPDATESECTIONLOGGING;

   
   FUNCTION EDITSECTION(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANFRAMEREVISION            IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANFRAMEOWNER               IN       IAPITYPE.OWNER_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ASACTION                   IN       IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LS_UPD_FT
      IS
         SELECT TEXT
           FROM FRAME_TEXT
          WHERE FRAME_NO = ASFRAMENO
            AND REVISION = ANFRAMEREVISION
            AND OWNER = ANFRAMEOWNER
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND TEXT_TYPE = ANITEMID;

      LNATTACHEDSPEC                IAPITYPE.SEQUENCENR_TYPE;
      LNMASKID                      IAPITYPE.ID_TYPE;
      LESPECNOTINDEV                EXCEPTION;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'EditSection';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := CHECKACCESSTOSAVE( ASPARTNO,
                                     ANREVISION,
                                     ANSECTIONID,
                                     ANSUBSECTIONID,
                                     ANITEMID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RAISE LESPECNOTINDEV;
      END IF;

      SELECT MASK_ID
        INTO LNMASKID
        FROM SPECIFICATION_HEADER
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION;

      IF ASACTION = 'add'
      THEN
         
         INSERT INTO SPECIFICATION_SECTION
                     ( PART_NO,
                       REVISION,
                       SECTION_ID,
                       SUB_SECTION_ID,
                       TYPE,
                       REF_ID,
                       REF_VER,
                       REF_INFO,
                       SEQUENCE_NO,
                       HEADER,
                       MANDATORY,
                       SECTION_SEQUENCE_NO,
                       DISPLAY_FORMAT,
                       ASSOCIATION,
                       INTL,
                       SECTION_REV,
                       SUB_SECTION_REV,
                       DISPLAY_FORMAT_REV,
                       REF_OWNER )
            SELECT ASPARTNO,
                   ANREVISION,
                   SECTION_ID,
                   SUB_SECTION_ID,
                   TYPE,
                   REF_ID,
                   REF_VER,
                   REF_INFO,
                   SEQUENCE_NO,
                   HEADER,
                   MANDATORY,
                   SECTION_SEQUENCE_NO,
                   DISPLAY_FORMAT,
                   ASSOCIATION,
                   INTL,
                   F_GET_SUB_REV( SECTION_ID,
                                  SECTION_REV,
                                  NULL,
                                  NULL,
                                  'SC' ),
                   F_GET_SUB_REV( SUB_SECTION_ID,
                                  SUB_SECTION_REV,
                                  NULL,
                                  NULL,
                                  'SB' ),
                   DISPLAY_FORMAT_REV,
                   REF_OWNER
              FROM FRAME_SECTION
             WHERE FRAME_NO = ASFRAMENO
               AND REVISION = ANFRAMEREVISION
               AND OWNER = ANFRAMEOWNER
               AND SECTION_ID = ANSECTIONID
               AND SUB_SECTION_ID = ANSUBSECTIONID
               AND TYPE = ANTYPE
               AND REF_ID = ANITEMID;

         IF ANTYPE = IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC
         THEN
            SELECT ATTACHED_SPEC_SEQ.NEXTVAL
              INTO LNATTACHEDSPEC
              FROM DUAL;

            UPDATE SPECIFICATION_SECTION
               SET REF_ID = LNATTACHEDSPEC
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND SECTION_ID = ANSECTIONID
               AND SUB_SECTION_ID = ANSUBSECTIONID
               AND REF_ID = 0
               AND TYPE = ANTYPE;
         ELSIF ANTYPE = IAPICONSTANT.SECTIONTYPE_FREETEXT
         THEN
            
            INSERT INTO SPECIFICATION_TEXT
                        ( PART_NO,
                          REVISION,
                          SECTION_ID,
                          SUB_SECTION_ID,
                          SECTION_REV,
                          SUB_SECTION_REV,
                          TEXT_TYPE,
                          TEXT_TYPE_REV )
               SELECT PART_NO,
                      REVISION,
                      SECTION_ID,
                      SUB_SECTION_ID,
                      SECTION_REV,
                      SUB_SECTION_REV,
                      REF_ID,
                      REF_VER
                 FROM SPECIFICATION_SECTION
                WHERE PART_NO = ASPARTNO
                  AND REVISION = ANREVISION
                  AND SECTION_ID = ANSECTIONID
                  AND SUB_SECTION_ID = ANSUBSECTIONID
                  AND TYPE = IAPICONSTANT.SECTIONTYPE_FREETEXT
                  AND REF_ID = ANITEMID;

            FOR REC_UPD_FT IN LS_UPD_FT
            LOOP
               UPDATE SPECIFICATION_TEXT
                  SET TEXT = REC_UPD_FT.TEXT
                WHERE PART_NO = ASPARTNO
                  AND REVISION = ANREVISION
                  AND SECTION_ID = ANSECTIONID
                  AND SUB_SECTION_ID = ANSUBSECTIONID
                  AND TEXT_TYPE = ANITEMID;
            END LOOP;
         ELSIF ANTYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP
         THEN
            INSERT INTO SPECIFICATION_PROP
                        ( PART_NO,
                          REVISION,
                          SECTION_ID,
                          SUB_SECTION_ID,
                          SECTION_REV,
                          SUB_SECTION_REV,
                          PROPERTY_GROUP,
                          PROPERTY,
                          ATTRIBUTE,
                          UOM_ID,
                          PROPERTY_GROUP_REV,
                          PROPERTY_REV,
                          ATTRIBUTE_REV,
                          UOM_REV,
                          TEST_METHOD,
                          TEST_METHOD_REV,
                          SEQUENCE_NO,
                          CHARACTERISTIC,
                          CHARACTERISTIC_REV,
                          ASSOCIATION,
                          ASSOCIATION_REV,
                          INTL,
                          NUM_1,
                          NUM_2,
                          NUM_3,
                          NUM_4,
                          NUM_5,
                          NUM_6,
                          NUM_7,
                          NUM_8,
                          NUM_9,
                          NUM_10,
                          CHAR_1,
                          CHAR_2,
                          CHAR_3,
                          CHAR_4,
                          CHAR_5,
                          CHAR_6,
                          BOOLEAN_1,
                          BOOLEAN_2,
                          BOOLEAN_3,
                          BOOLEAN_4,
                          DATE_1,
                          DATE_2,
                          CH_2,
                          CH_REV_2,
                          CH_3,
                          CH_REV_3,
                          AS_2,
                          AS_REV_2,
                          AS_3,
                          AS_REV_3,
                          UOM_ALT_ID,
                          UOM_ALT_REV )
               SELECT ASPARTNO,
                      ANREVISION,
                      SECTION_ID,
                      SUB_SECTION_ID,
                      F_GET_SUB_REV( SECTION_ID,
                                     SECTION_REV,
                                     NULL,
                                     NULL,
                                     'SC' ),
                      F_GET_SUB_REV( SUB_SECTION_ID,
                                     SUB_SECTION_REV,
                                     NULL,
                                     NULL,
                                     'SB' ),
                      PROPERTY_GROUP,
                      PROPERTY,
                      ATTRIBUTE,
                      UOM_ID,
                      F_GET_SUB_REV( PROPERTY_GROUP,
                                     PROPERTY_GROUP_REV,
                                     NULL,
                                     NULL,
                                     'PG' ),
                      F_GET_SUB_REV( PROPERTY,
                                     PROPERTY_REV,
                                     NULL,
                                     NULL,
                                     'SP' ),
                      F_GET_SUB_REV( ATTRIBUTE,
                                     ATTRIBUTE_REV,
                                     NULL,
                                     NULL,
                                     'AT' ),
                      F_GET_SUB_REV( UOM_ID,
                                     UOM_REV,
                                     NULL,
                                     NULL,
                                     'UO' ),
                      TEST_METHOD,
                      F_GET_SUB_REV( TEST_METHOD,
                                     TEST_METHOD_REV,
                                     NULL,
                                     NULL,
                                     'TM' ),
                      SEQUENCE_NO,
                      CHARACTERISTIC,
                      NVL( F_GET_SUB_REV( CHARACTERISTIC,
                                          CHARACTERISTIC_REV,
                                          NULL,
                                          NULL,
                                          'CH' ),
                           0 ),
                      ASSOCIATION,
                      F_GET_SUB_REV( ASSOCIATION,
                                     ASSOCIATION_REV,
                                     NULL,
                                     NULL,
                                     'AS' ),
                      INTL,
                      NUM_1,
                      NUM_2,
                      NUM_3,
                      NUM_4,
                      NUM_5,
                      NUM_6,
                      NUM_7,
                      NUM_8,
                      NUM_9,
                      NUM_10,
                      CHAR_1,
                      CHAR_2,
                      CHAR_3,
                      CHAR_4,
                      CHAR_5,
                      CHAR_6,
                      BOOLEAN_1,
                      BOOLEAN_2,
                      BOOLEAN_3,
                      BOOLEAN_4,
                      DATE_1,
                      DATE_2,
                      CH_2,
                      NVL( F_GET_SUB_REV( CH_2,
                                          CH_REV_2,
                                          NULL,
                                          NULL,
                                          'CH' ),
                           0 ),
                      CH_3,
                      NVL( F_GET_SUB_REV( CH_3,
                                          CH_REV_3,
                                          NULL,
                                          NULL,
                                          'CH' ),
                           0 ),
                      AS_2,
                      F_GET_SUB_REV( AS_2,
                                     AS_REV_2,
                                     NULL,
                                     NULL,
                                     'AS' ),
                      AS_3,
                      F_GET_SUB_REV( AS_3,
                                     AS_REV_3,
                                     NULL,
                                     NULL,
                                     'AS' ),
                      UOM_ALT_ID,
                      F_GET_SUB_REV( UOM_ALT_ID,
                                     UOM_ALT_REV,
                                     NULL,
                                     NULL,
                                     'UO' )
                 FROM FRAME_PROP
                WHERE FRAME_NO = ASFRAMENO
                  AND REVISION = ANFRAMEREVISION
                  AND OWNER = ANFRAMEOWNER
                  AND SECTION_ID = ANSECTIONID
                  AND SUB_SECTION_ID = ANSUBSECTIONID
                  AND PROPERTY_GROUP = ANITEMID
                  AND MANDATORY = 'Y';

            INSERT INTO SPECIFICATION_PROP
                        ( PART_NO,
                          REVISION,
                          SECTION_ID,
                          SUB_SECTION_ID,
                          SECTION_REV,
                          SUB_SECTION_REV,
                          PROPERTY_GROUP,
                          PROPERTY,
                          ATTRIBUTE,
                          UOM_ID,
                          PROPERTY_GROUP_REV,
                          PROPERTY_REV,
                          ATTRIBUTE_REV,
                          UOM_REV,
                          TEST_METHOD,
                          TEST_METHOD_REV,
                          SEQUENCE_NO,
                          CHARACTERISTIC,
                          CHARACTERISTIC_REV,
                          ASSOCIATION,
                          ASSOCIATION_REV,
                          INTL,
                          NUM_1,
                          NUM_2,
                          NUM_3,
                          NUM_4,
                          NUM_5,
                          NUM_6,
                          NUM_7,
                          NUM_8,
                          NUM_9,
                          NUM_10,
                          CHAR_1,
                          CHAR_2,
                          CHAR_3,
                          CHAR_4,
                          CHAR_5,
                          CHAR_6,
                          BOOLEAN_1,
                          BOOLEAN_2,
                          BOOLEAN_3,
                          BOOLEAN_4,
                          DATE_1,
                          DATE_2,
                          CH_2,
                          CH_REV_2,
                          CH_3,
                          CH_REV_3,
                          AS_2,
                          AS_REV_2,
                          AS_3,
                          AS_REV_3,
                          UOM_ALT_ID,
                          UOM_ALT_REV )
               SELECT ASPARTNO,
                      ANREVISION,
                      A.SECTION_ID,
                      A.SUB_SECTION_ID,
                      F_GET_SUB_REV( A.SECTION_ID,
                                     A.SECTION_REV,
                                     NULL,
                                     NULL,
                                     'SC' ),
                      F_GET_SUB_REV( A.SUB_SECTION_ID,
                                     A.SUB_SECTION_REV,
                                     NULL,
                                     NULL,
                                     'SB' ),
                      A.PROPERTY_GROUP,
                      A.PROPERTY,
                      A.ATTRIBUTE,
                      A.UOM_ID,
                      F_GET_SUB_REV( A.PROPERTY_GROUP,
                                     A.PROPERTY_GROUP_REV,
                                     NULL,
                                     NULL,
                                     'PG' ),
                      F_GET_SUB_REV( A.PROPERTY,
                                     A.PROPERTY_REV,
                                     NULL,
                                     NULL,
                                     'SP' ),
                      F_GET_SUB_REV( A.ATTRIBUTE,
                                     A.ATTRIBUTE_REV,
                                     NULL,
                                     NULL,
                                     'AT' ),
                      F_GET_SUB_REV( A.UOM_ID,
                                     A.UOM_REV,
                                     NULL,
                                     NULL,
                                     'UO' ),
                      A.TEST_METHOD,
                      F_GET_SUB_REV( A.TEST_METHOD,
                                     A.TEST_METHOD_REV,
                                     NULL,
                                     NULL,
                                     'TM' ),
                      A.SEQUENCE_NO,
                      A.CHARACTERISTIC,
                      NVL( F_GET_SUB_REV( A.CHARACTERISTIC,
                                          A.CHARACTERISTIC_REV,
                                          NULL,
                                          NULL,
                                          'CH' ),
                           0 ),
                      A.ASSOCIATION,
                      F_GET_SUB_REV( A.ASSOCIATION,
                                     A.ASSOCIATION_REV,
                                     NULL,
                                     NULL,
                                     'AS' ),
                      A.INTL,
                      NUM_1,
                      NUM_2,
                      NUM_3,
                      NUM_4,
                      NUM_5,
                      NUM_6,
                      NUM_7,
                      NUM_8,
                      NUM_9,
                      NUM_10,
                      CHAR_1,
                      CHAR_2,
                      CHAR_3,
                      CHAR_4,
                      CHAR_5,
                      CHAR_6,
                      BOOLEAN_1,
                      BOOLEAN_2,
                      BOOLEAN_3,
                      BOOLEAN_4,
                      DATE_1,
                      DATE_2,
                      CH_2,
                      NVL( F_GET_SUB_REV( CH_2,
                                          CH_REV_2,
                                          NULL,
                                          NULL,
                                          'CH' ),
                           0 ),
                      CH_3,
                      NVL( F_GET_SUB_REV( CH_3,
                                          CH_REV_3,
                                          NULL,
                                          NULL,
                                          'CH' ),
                           0 ),
                      AS_2,
                      F_GET_SUB_REV( AS_2,
                                     AS_REV_2,
                                     NULL,
                                     NULL,
                                     'AS' ),
                      AS_3,
                      F_GET_SUB_REV( AS_3,
                                     AS_REV_3,
                                     NULL,
                                     NULL,
                                     'AS' ),
                      UOM_ALT_ID,
                      F_GET_SUB_REV( UOM_ALT_ID,
                                     UOM_ALT_REV,
                                     NULL,
                                     NULL,
                                     'UO' )
                 FROM FRAME_PROP A,
                      ITFRMVPG B
                WHERE A.FRAME_NO = B.FRAME_NO
                  AND A.REVISION = B.REVISION
                  AND A.OWNER = B.OWNER
                  AND A.SECTION_ID = B.SECTION_ID
                  AND A.SUB_SECTION_ID = B.SUB_SECTION_ID
                  AND A.PROPERTY_GROUP = B.PROPERTY_GROUP
                  AND A.PROPERTY = B.PROPERTY
                  AND A.ATTRIBUTE = B.ATTRIBUTE
                  AND A.FRAME_NO = ASFRAMENO
                  AND A.REVISION = ANFRAMEREVISION
                  AND A.OWNER = ANFRAMEOWNER
                  AND A.SECTION_ID = ANSECTIONID
                  AND A.SUB_SECTION_ID = ANSUBSECTIONID
                  AND A.PROPERTY_GROUP = ANITEMID
                  AND B.MANDATORY = 'Y'
                  AND B.VIEW_ID = LNMASKID
                  AND ( A.PROPERTY, A.ATTRIBUTE ) NOT IN(
                         SELECT C.PROPERTY,
                                C.ATTRIBUTE
                           FROM SPECIFICATION_PROP C
                          WHERE C.PART_NO = ASPARTNO
                            AND C.REVISION = ANREVISION
                            AND C.SECTION_ID = ANSECTIONID
                            AND C.SUB_SECTION_ID = ANSUBSECTIONID
                            AND C.PROPERTY_GROUP = ANITEMID );

            INSERT INTO SPECDATA_SERVER
                        ( PART_NO,
                          REVISION,
                          SECTION_ID,
                          SUB_SECTION_ID )
                 VALUES ( ASPARTNO,
                          ANREVISION,
                          ANSECTIONID,
                          ANSUBSECTIONID );
         ELSIF ANTYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY
         THEN
            INSERT INTO SPECIFICATION_PROP
                        ( PART_NO,
                          REVISION,
                          SECTION_ID,
                          SUB_SECTION_ID,
                          SECTION_REV,
                          SUB_SECTION_REV,
                          PROPERTY_GROUP,
                          PROPERTY,
                          ATTRIBUTE,
                          UOM_ID,
                          PROPERTY_GROUP_REV,
                          PROPERTY_REV,
                          ATTRIBUTE_REV,
                          UOM_REV,
                          TEST_METHOD,
                          TEST_METHOD_REV,
                          SEQUENCE_NO,
                          CHARACTERISTIC,
                          CHARACTERISTIC_REV,
                          ASSOCIATION,
                          ASSOCIATION_REV,
                          INTL,
                          NUM_1,
                          NUM_2,
                          NUM_3,
                          NUM_4,
                          NUM_5,
                          NUM_6,
                          NUM_7,
                          NUM_8,
                          NUM_9,
                          NUM_10,
                          CHAR_1,
                          CHAR_2,
                          CHAR_3,
                          CHAR_4,
                          CHAR_5,
                          CHAR_6,
                          BOOLEAN_1,
                          BOOLEAN_2,
                          BOOLEAN_3,
                          BOOLEAN_4,
                          DATE_1,
                          DATE_2,
                          CH_2,
                          CH_REV_2,
                          CH_3,
                          CH_REV_3,
                          AS_2,
                          AS_REV_2,
                          AS_3,
                          AS_REV_3,
                          UOM_ALT_ID,
                          UOM_ALT_REV )
               SELECT ASPARTNO,
                      ANREVISION,
                      SECTION_ID,
                      SUB_SECTION_ID,
                      F_GET_SUB_REV( SECTION_ID,
                                     SECTION_REV,
                                     NULL,
                                     NULL,
                                     'SC' ),
                      F_GET_SUB_REV( SUB_SECTION_ID,
                                     SUB_SECTION_REV,
                                     NULL,
                                     NULL,
                                     'SB' ),
                      PROPERTY_GROUP,
                      PROPERTY,
                      ATTRIBUTE,
                      UOM_ID,
                      F_GET_SUB_REV( PROPERTY_GROUP,
                                     PROPERTY_GROUP_REV,
                                     NULL,
                                     NULL,
                                     'PG' ),
                      F_GET_SUB_REV( PROPERTY,
                                     PROPERTY_REV,
                                     NULL,
                                     NULL,
                                     'SP' ),
                      F_GET_SUB_REV( ATTRIBUTE,
                                     ATTRIBUTE_REV,
                                     NULL,
                                     NULL,
                                     'AT' ),
                      F_GET_SUB_REV( UOM_ID,
                                     UOM_REV,
                                     NULL,
                                     NULL,
                                     'UO' ),
                      TEST_METHOD,
                      F_GET_SUB_REV( TEST_METHOD,
                                     TEST_METHOD_REV,
                                     NULL,
                                     NULL,
                                     'TM' ),
                      SEQUENCE_NO,
                      CHARACTERISTIC,
                      NVL( F_GET_SUB_REV( CHARACTERISTIC,
                                          CHARACTERISTIC_REV,
                                          NULL,
                                          NULL,
                                          'CH' ),
                           0 ),
                      ASSOCIATION,
                      F_GET_SUB_REV( ASSOCIATION,
                                     ASSOCIATION_REV,
                                     NULL,
                                     NULL,
                                     'AS' ),
                      INTL,
                      NUM_1,
                      NUM_2,
                      NUM_3,
                      NUM_4,
                      NUM_5,
                      NUM_6,
                      NUM_7,
                      NUM_8,
                      NUM_9,
                      NUM_10,
                      CHAR_1,
                      CHAR_2,
                      CHAR_3,
                      CHAR_4,
                      CHAR_5,
                      CHAR_6,
                      BOOLEAN_1,
                      BOOLEAN_2,
                      BOOLEAN_3,
                      BOOLEAN_4,
                      DATE_1,
                      DATE_2,
                      CH_2,
                      NVL( F_GET_SUB_REV( CH_2,
                                          CH_REV_2,
                                          NULL,
                                          NULL,
                                          'CH' ),
                           0 ),
                      CH_3,
                      NVL( F_GET_SUB_REV( CH_3,
                                          CH_REV_3,
                                          NULL,
                                          NULL,
                                          'CH' ),
                           0 ),
                      AS_2,
                      F_GET_SUB_REV( AS_2,
                                     AS_REV_2,
                                     NULL,
                                     NULL,
                                     'AS' ),
                      AS_3,
                      F_GET_SUB_REV( AS_3,
                                     AS_REV_3,
                                     NULL,
                                     NULL,
                                     'AS' ),
                      UOM_ALT_ID,
                      F_GET_SUB_REV( UOM_ALT_ID,
                                     UOM_ALT_REV,
                                     NULL,
                                     NULL,
                                     'UO' )
                 FROM FRAME_PROP
                WHERE FRAME_NO = ASFRAMENO
                  AND REVISION = ANFRAMEREVISION
                  AND OWNER = ANFRAMEOWNER
                  AND SECTION_ID = ANSECTIONID
                  AND SUB_SECTION_ID = ANSUBSECTIONID
                  AND PROPERTY_GROUP = 0
                  AND PROPERTY = ANITEMID
                  AND MANDATORY = 'Y';

            INSERT INTO SPECIFICATION_PROP
                        ( PART_NO,
                          REVISION,
                          SECTION_ID,
                          SUB_SECTION_ID,
                          SECTION_REV,
                          SUB_SECTION_REV,
                          PROPERTY_GROUP,
                          PROPERTY,
                          ATTRIBUTE,
                          UOM_ID,
                          PROPERTY_GROUP_REV,
                          PROPERTY_REV,
                          ATTRIBUTE_REV,
                          UOM_REV,
                          TEST_METHOD,
                          TEST_METHOD_REV,
                          SEQUENCE_NO,
                          CHARACTERISTIC,
                          CHARACTERISTIC_REV,
                          ASSOCIATION,
                          ASSOCIATION_REV,
                          INTL,
                          NUM_1,
                          NUM_2,
                          NUM_3,
                          NUM_4,
                          NUM_5,
                          NUM_6,
                          NUM_7,
                          NUM_8,
                          NUM_9,
                          NUM_10,
                          CHAR_1,
                          CHAR_2,
                          CHAR_3,
                          CHAR_4,
                          CHAR_5,
                          CHAR_6,
                          BOOLEAN_1,
                          BOOLEAN_2,
                          BOOLEAN_3,
                          BOOLEAN_4,
                          DATE_1,
                          DATE_2,
                          CH_2,
                          CH_REV_2,
                          CH_3,
                          CH_REV_3,
                          AS_2,
                          AS_REV_2,
                          AS_3,
                          AS_REV_3,
                          UOM_ALT_ID,
                          UOM_ALT_REV )
               SELECT ASPARTNO,
                      ANREVISION,
                      A.SECTION_ID,
                      A.SUB_SECTION_ID,
                      F_GET_SUB_REV( A.SECTION_ID,
                                     A.SECTION_REV,
                                     NULL,
                                     NULL,
                                     'SC' ),
                      F_GET_SUB_REV( A.SUB_SECTION_ID,
                                     A.SUB_SECTION_REV,
                                     NULL,
                                     NULL,
                                     'SB' ),
                      A.PROPERTY_GROUP,
                      A.PROPERTY,
                      A.ATTRIBUTE,
                      A.UOM_ID,
                      F_GET_SUB_REV( A.PROPERTY_GROUP,
                                     A.PROPERTY_GROUP_REV,
                                     NULL,
                                     NULL,
                                     'PG' ),
                      F_GET_SUB_REV( A.PROPERTY,
                                     A.PROPERTY_REV,
                                     NULL,
                                     NULL,
                                     'SP' ),
                      F_GET_SUB_REV( A.ATTRIBUTE,
                                     A.ATTRIBUTE_REV,
                                     NULL,
                                     NULL,
                                     'AT' ),
                      F_GET_SUB_REV( A.UOM_ID,
                                     A.UOM_REV,
                                     NULL,
                                     NULL,
                                     'UO' ),
                      A.TEST_METHOD,
                      F_GET_SUB_REV( A.TEST_METHOD,
                                     A.TEST_METHOD_REV,
                                     NULL,
                                     NULL,
                                     'TM' ),
                      A.SEQUENCE_NO,
                      A.CHARACTERISTIC,
                      NVL( F_GET_SUB_REV( A.CHARACTERISTIC,
                                          A.CHARACTERISTIC_REV,
                                          NULL,
                                          NULL,
                                          'CH' ),
                           0 ),
                      A.ASSOCIATION,
                      F_GET_SUB_REV( A.ASSOCIATION,
                                     A.ASSOCIATION_REV,
                                     NULL,
                                     NULL,
                                     'AS' ),
                      A.INTL,
                      NUM_1,
                      NUM_2,
                      NUM_3,
                      NUM_4,
                      NUM_5,
                      NUM_6,
                      NUM_7,
                      NUM_8,
                      NUM_9,
                      NUM_10,
                      CHAR_1,
                      CHAR_2,
                      CHAR_3,
                      CHAR_4,
                      CHAR_5,
                      CHAR_6,
                      BOOLEAN_1,
                      BOOLEAN_2,
                      BOOLEAN_3,
                      BOOLEAN_4,
                      DATE_1,
                      DATE_2,
                      CH_2,
                      NVL( F_GET_SUB_REV( CH_2,
                                          CH_REV_2,
                                          NULL,
                                          NULL,
                                          'CH' ),
                           0 ),
                      CH_3,
                      NVL( F_GET_SUB_REV( CH_3,
                                          CH_REV_3,
                                          NULL,
                                          NULL,
                                          'CH' ),
                           0 ),
                      AS_2,
                      F_GET_SUB_REV( AS_2,
                                     AS_REV_2,
                                     NULL,
                                     NULL,
                                     'AS' ),
                      AS_3,
                      F_GET_SUB_REV( AS_3,
                                     AS_REV_3,
                                     NULL,
                                     NULL,
                                     'AS' ),
                      UOM_ALT_ID,
                      F_GET_SUB_REV( UOM_ALT_ID,
                                     UOM_ALT_REV,
                                     NULL,
                                     NULL,
                                     'UO' )
                 FROM FRAME_PROP A,
                      ITFRMVPG B
                WHERE A.FRAME_NO = B.FRAME_NO
                  AND A.REVISION = B.REVISION
                  AND A.OWNER = B.OWNER
                  AND A.SECTION_ID = B.SECTION_ID
                  AND A.SUB_SECTION_ID = B.SUB_SECTION_ID
                  AND A.PROPERTY_GROUP = B.PROPERTY_GROUP
                  AND A.PROPERTY = B.PROPERTY
                  AND A.ATTRIBUTE = B.ATTRIBUTE
                  AND A.FRAME_NO = ASFRAMENO
                  AND A.REVISION = ANFRAMEREVISION
                  AND A.OWNER = ANFRAMEOWNER
                  AND A.SECTION_ID = ANSECTIONID
                  AND A.SUB_SECTION_ID = ANSUBSECTIONID
                  AND A.PROPERTY_GROUP = 0
                  AND A.PROPERTY = ANITEMID
                  AND B.MANDATORY = 'Y'
                  AND B.VIEW_ID = LNMASKID
                  AND ( A.ATTRIBUTE ) NOT IN(
                         SELECT C.ATTRIBUTE
                           FROM SPECIFICATION_PROP C
                          WHERE C.PART_NO = ASPARTNO
                            AND C.REVISION = ANREVISION
                            AND C.SECTION_ID = ANSECTIONID
                            AND C.SUB_SECTION_ID = ANSUBSECTIONID
                            AND C.PROPERTY_GROUP = 0
                            AND C.PROPERTY = ANITEMID );

            INSERT INTO SPECDATA_SERVER
                        ( PART_NO,
                          REVISION,
                          SECTION_ID,
                          SUB_SECTION_ID )
                 VALUES ( ASPARTNO,
                          ANREVISION,
                          ANSECTIONID,
                          ANSUBSECTIONID );
         END IF;

         LNRETVAL := CREATESECTIONHISTORY( ASPARTNO,
                                           ANREVISION,
                                           ANSECTIONID,
                                           ANSUBSECTIONID );
      ELSIF ASACTION = 'rem'
      THEN
         IF ANTYPE = IAPICONSTANT.SECTIONTYPE_FREETEXT
         THEN
            DELETE FROM SPECIFICATION_TEXT
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION
                    AND SECTION_ID = ANSECTIONID
                    AND SUB_SECTION_ID = ANSUBSECTIONID
                    AND TEXT_TYPE = ANITEMID;

            DELETE FROM ITSHEXT
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION
                    AND SECTION_ID = ANSECTIONID
                    AND SUB_SECTION_ID = ANSUBSECTIONID
                    AND TYPE = ANTYPE
                    AND REF_ID = ANITEMID;
         ELSIF ANTYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP
         THEN
            DELETE FROM SPECIFICATION_PROP
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION
                    AND SECTION_ID = ANSECTIONID
                    AND SUB_SECTION_ID = ANSUBSECTIONID
                    AND PROPERTY_GROUP = ANITEMID;

            DELETE FROM SPECIFICATION_TM
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION
                    AND SECTION_ID = ANSECTIONID
                    AND SUB_SECTION_ID = ANSUBSECTIONID
                    AND PROPERTY_GROUP = ANITEMID;

            DELETE FROM SPECIFICATION_PROP_LANG
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION
                    AND SECTION_ID = ANSECTIONID
                    AND SUB_SECTION_ID = ANSUBSECTIONID
                    AND PROPERTY_GROUP = ANITEMID;

            INSERT INTO SPECDATA_SERVER
                        ( PART_NO,
                          REVISION,
                          SECTION_ID,
                          SUB_SECTION_ID )
                 VALUES ( ASPARTNO,
                          ANREVISION,
                          ANSECTIONID,
                          ANSUBSECTIONID );

            DELETE FROM ITSHEXT
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION
                    AND SECTION_ID = ANSECTIONID
                    AND SUB_SECTION_ID = ANSUBSECTIONID
                    AND PROPERTY_GROUP = ANITEMID;
         ELSIF ANTYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY
         THEN
            DELETE FROM SPECIFICATION_PROP
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION
                    AND SECTION_ID = ANSECTIONID
                    AND SUB_SECTION_ID = ANSUBSECTIONID
                    AND PROPERTY_GROUP = 0
                    AND PROPERTY = ANITEMID;

            DELETE FROM SPECIFICATION_TM
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION
                    AND SECTION_ID = ANSECTIONID
                    AND SUB_SECTION_ID = ANSUBSECTIONID
                    AND PROPERTY_GROUP = 0
                    AND PROPERTY = ANITEMID;

            DELETE FROM SPECIFICATION_PROP_LANG
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION
                    AND SECTION_ID = ANSECTIONID
                    AND SUB_SECTION_ID = ANSUBSECTIONID
                    AND PROPERTY_GROUP = 0
                    AND PROPERTY = ANITEMID;

            INSERT INTO SPECDATA_SERVER
                        ( PART_NO,
                          REVISION,
                          SECTION_ID,
                          SUB_SECTION_ID )
                 VALUES ( ASPARTNO,
                          ANREVISION,
                          ANSECTIONID,
                          ANSUBSECTIONID );

            DELETE FROM ITSHEXT
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION
                    AND SECTION_ID = ANSECTIONID
                    AND SUB_SECTION_ID = ANSUBSECTIONID
                    AND PROPERTY = ANITEMID;
         ELSIF ANTYPE = IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC
         THEN
            DELETE FROM ATTACHED_SPECIFICATION
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION
                    AND SECTION_ID = ANSECTIONID
                    AND SUB_SECTION_ID = ANSUBSECTIONID
                    AND REF_ID = ANITEMID;

            DELETE FROM ITSHEXT
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION
                    AND SECTION_ID = ANSECTIONID
                    AND SUB_SECTION_ID = ANSUBSECTIONID
                    AND TYPE = ANTYPE
                    AND REF_ID = ANITEMID;

            DELETE FROM ITSHEXT
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION
                    AND SECTION_ID = ANSECTIONID
                    AND SUB_SECTION_ID = ANSUBSECTIONID
                    AND TYPE = ANTYPE;
         ELSIF ANTYPE = IAPICONSTANT.SECTIONTYPE_REFERENCETEXT
         THEN
            DELETE FROM ITSHEXT
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION
                    AND SECTION_ID = ANSECTIONID
                    AND SUB_SECTION_ID = ANSUBSECTIONID
                    AND TYPE = ANTYPE
                    AND REF_ID = ANITEMID;
         ELSIF ANTYPE = IAPICONSTANT.SECTIONTYPE_OBJECT
         THEN
            DELETE FROM ITSHEXT
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION
                    AND SECTION_ID = ANSECTIONID
                    AND SUB_SECTION_ID = ANSUBSECTIONID
                    AND TYPE = ANTYPE
                    AND REF_ID = ANITEMID;
         ELSIF ANTYPE = IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST
         THEN
            DELETE FROM SPECIFICATION_ING
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM SPECIFICATION_ING_LANG
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;
         END IF;

         DELETE FROM SPECIFICATION_SECTION
               WHERE PART_NO = ASPARTNO
                 AND REVISION = ANREVISION
                 AND SECTION_ID = ANSECTIONID
                 AND SUB_SECTION_ID = ANSUBSECTIONID
                 AND TYPE = ANTYPE
                 AND REF_ID = ANITEMID;

         LNRETVAL := CREATESECTIONHISTORY( ASPARTNO,
                                           ANREVISION,
                                           ANSECTIONID,
                                           ANSUBSECTIONID );
      END IF;

      
      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( ASPARTNO,
                                                ANREVISION );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN LESPECNOTINDEV
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_SPECNOTINDEV,
                                               ASPARTNO,
                                               ANREVISION );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EDITSECTION;

   
   FUNCTION CHECKACCESSTOSAVE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LBENABLE                      IAPITYPE.BOOLEAN_TYPE := 1;
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
      LNSTATUS                      IAPITYPE.STATUSID_TYPE;
      LNACCESSGROUP                 IAPITYPE.ID_TYPE;
      LNWORKFLOWGROUP               IAPITYPE.ID_TYPE;
      LNTYPE                        IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE;
      LBMRP                         IAPITYPE.BOOLEAN_TYPE;
      LBPRODACCESS                  IAPITYPE.BOOLEAN_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckAccessToSave';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT S.STATUS_TYPE,
             SH.STATUS,
             SH.ACCESS_GROUP,
             SH.WORKFLOW_GROUP_ID
        INTO LSSTATUSTYPE,
             LNSTATUS,
             LNACCESSGROUP,
             LNWORKFLOWGROUP
        FROM SPECIFICATION_HEADER SH,
             STATUS S
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND S.STATUS = SH.STATUS;

      IF LSSTATUSTYPE = IAPICONSTANT.STATUSTYPE_DEVELOPMENT
      THEN
         LBENABLE := 1;
      ELSE
         SELECT MAX( TYPE )
           INTO LNTYPE
           FROM SPECIFICATION_SECTION
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID;

         IF LNTYPE = IAPICONSTANT.SECTIONTYPE_BOM
         THEN
            SELECT MAX( DECODE( A.MRP_UPDATE,
                                'Y', 1,
                                0 ) )
              INTO LBMRP
              FROM USER_ACCESS_GROUP A,
                   USER_GROUP_LIST B
             WHERE A.USER_GROUP_ID = B.USER_GROUP_ID
               AND B.USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

            SELECT MAX( DECODE( PROD_ACCESS,
                                'Y', 1,
                                0 ) )
              INTO LBPRODACCESS
              FROM APPLICATION_USER
             WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

            LBENABLE :=(   LBMRP
                         * LBPRODACCESS );
         ELSE
            LBENABLE := 0;
         END IF;
      END IF;

      IF LBENABLE = 1
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      ELSE
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      WHEN OTHERS
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
   END CHECKACCESSTOSAVE;

   
   FUNCTION EDITEXTENDABLESECTION(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANDISPLAYFORMAT            IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTE                IN       IAPITYPE.ID_TYPE,
      ANUOMID                    IN       IAPITYPE.ID_TYPE,
      ANASS1                     IN       IAPITYPE.ID_TYPE,
      ANASS2                     IN       IAPITYPE.ID_TYPE,
      ANASS3                     IN       IAPITYPE.ID_TYPE,
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANFRAMEREVISION            IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANFRAMEOWNER               IN       IAPITYPE.OWNER_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LNREFVER                      IAPITYPE.REVISION_TYPE;
      LNREFINFO                     IAPITYPE.ITEMINFO_TYPE;
      LNSECTIONSEQNO                IAPITYPE.SEQUENCE_TYPE;
      LSINTL                        IAPITYPE.INTL_TYPE;
      LNSECTIONREV                  IAPITYPE.REVISION_TYPE;
      LNSUBSECTIONREV               IAPITYPE.REVISION_TYPE;
      LNDISPLAYFORMATREV            IAPITYPE.REVISION_TYPE;
      LNUOMREV                      IAPITYPE.REVISION_TYPE;
      LNASSREV1                     IAPITYPE.REVISION_TYPE;
      LNASSREV2                     IAPITYPE.REVISION_TYPE;
      LNASSREV3                     IAPITYPE.REVISION_TYPE;
      LNATTRIBUTEREV                IAPITYPE.REVISION_TYPE;
      LNPROPERTYGROUP               IAPITYPE.ID_TYPE;
      LNPROPERTY                    IAPITYPE.ID_TYPE;
      LNATTACHEDSPEC                NUMBER;
      LBINSERT                      BOOLEAN;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'EditExtendableSection';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      SELECT MAX( SECTION_SEQUENCE_NO )
        INTO LNSECTIONSEQNO
        FROM SPECIFICATION_SECTION
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND SECTION_ID = ANSECTIONID
         AND SUB_SECTION_ID = ANSUBSECTIONID
         AND MOD( SECTION_SEQUENCE_NO,
                  10 ) = 0;

      IF LNSECTIONSEQNO IS NULL
      THEN
         
         SELECT NVL( MAX( SECTION_SEQUENCE_NO ),
                     0 )
           INTO LNSECTIONSEQNO
           FROM FRAME_SECTION
          WHERE FRAME_NO = ASFRAMENO
            AND REVISION = ANFRAMEREVISION
            AND OWNER = ANFRAMEOWNER
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND MOD( SECTION_SEQUENCE_NO,
                     10 ) = 0;
      END IF;

      BEGIN
         SELECT DISTINCT SECTION_REV,
                         SUB_SECTION_REV
                    INTO LNSECTIONREV,
                         LNSUBSECTIONREV
                    FROM SPECIFICATION_SECTION
                   WHERE PART_NO = ASPARTNO
                     AND REVISION = ANREVISION
                     AND SECTION_ID = ANSECTIONID
                     AND SUB_SECTION_ID = ANSUBSECTIONID
                     AND SECTION_SEQUENCE_NO = LNSECTIONSEQNO;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            LNSECTIONREV := 0;
            LNSUBSECTIONREV := 0;
      END;

      BEGIN
         SELECT INTL
           INTO LSINTL
           FROM SPECIFICATION_HEADER
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            LSINTL := 0;
      END;

      LNSECTIONSEQNO :=   LNSECTIONSEQNO
                        + 10;
      LNREFINFO := 0;
      LNPROPERTYGROUP := 0;
      LNPROPERTY := 0;

      IF ANTYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP
      THEN
         
         BEGIN
            SELECT REVISION
              INTO LNREFVER
              FROM PROPERTY_GROUP_H
             WHERE PROPERTY_GROUP = ANITEMID
               AND MAX_REV = 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               LNREFVER := 0;
         END;

         LNPROPERTYGROUP := ANITEMID;
      ELSIF ANTYPE = IAPICONSTANT.SECTIONTYPE_REFERENCETEXT
      THEN
         
         LNREFVER := 0;
         LNREFINFO := 5;
      ELSIF ANTYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY
      THEN
         
         BEGIN
            SELECT REVISION
              INTO LNREFVER
              FROM PROPERTY_H
             WHERE PROPERTY = ANITEMID
               AND MAX_REV = 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               LNREFVER := 0;
         END;

         LNPROPERTY := ANITEMID;
      ELSIF ANTYPE = IAPICONSTANT.SECTIONTYPE_FREETEXT
      THEN
         
         BEGIN
            SELECT DISTINCT REVISION
                       INTO LNREFVER
                       FROM TEXT_TYPE_H
                      WHERE TEXT_TYPE = ANITEMID
                        AND MAX_REV = 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               LNREFVER := 0;
         END;

         LNREFINFO := 10;
      ELSIF ANTYPE = IAPICONSTANT.SECTIONTYPE_OBJECT
      THEN
         
         BEGIN
            SELECT REVISION
              INTO LNREFVER
              FROM ITOID
             WHERE OBJECT_ID = ANITEMID
               AND STATUS = 2;
         EXCEPTION
            WHEN OTHERS
            THEN
               LNREFVER := 0;
         END;
      ELSIF ANTYPE = IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC
      THEN
         
         LNREFVER := 0;
      END IF;

      
      IF ANDISPLAYFORMAT > 0
      THEN
         BEGIN
            SELECT REVISION
              INTO LNDISPLAYFORMATREV
              FROM LAYOUT
             WHERE LAYOUT_ID = ANDISPLAYFORMAT
               AND STATUS = 2;
         EXCEPTION
            WHEN OTHERS
            THEN
               LNDISPLAYFORMATREV := 0;
         END;
      ELSE
         LNDISPLAYFORMATREV := 0;
      END IF;

      IF ANTYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY
      THEN
         
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM SPECIFICATION_SECTION
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND TYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY
            AND REF_ID = ANITEMID;

         IF LNCOUNT = 0
         THEN
            LBINSERT := TRUE;
         ELSE
            LBINSERT := FALSE;
         END IF;
      ELSIF ANTYPE = IAPICONSTANT.SECTIONTYPE_REFERENCETEXT
      THEN
         
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM SPECIFICATION_SECTION
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND TYPE = IAPICONSTANT.SECTIONTYPE_REFERENCETEXT
            AND REF_ID = 0;

         IF LNCOUNT = 0
         THEN
            LBINSERT := TRUE;
         ELSE
            LBINSERT := FALSE;
         END IF;
      ELSIF ANTYPE = IAPICONSTANT.SECTIONTYPE_OBJECT
      THEN
         
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM SPECIFICATION_SECTION
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND TYPE = IAPICONSTANT.SECTIONTYPE_OBJECT
            AND REF_ID = 0;

         IF LNCOUNT = 0
         THEN
            LBINSERT := TRUE;
         ELSE
            LBINSERT := FALSE;
         END IF;
      ELSIF ANTYPE = IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC
      THEN
         
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM SPECIFICATION_SECTION
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND TYPE = IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC
            AND REF_ID = 0;

         IF LNCOUNT = 0
         THEN
            LBINSERT := TRUE;
         ELSE
            LBINSERT := FALSE;
         END IF;
      ELSE
         LBINSERT := TRUE;
      END IF;

      IF LBINSERT
      THEN
         INSERT INTO SPECIFICATION_SECTION
                     ( PART_NO,
                       REVISION,
                       SECTION_ID,
                       SUB_SECTION_ID,
                       TYPE,
                       REF_ID,
                       REF_VER,
                       REF_INFO,
                       SEQUENCE_NO,
                       HEADER,
                       MANDATORY,
                       SECTION_SEQUENCE_NO,
                       DISPLAY_FORMAT,
                       ASSOCIATION,
                       INTL,
                       SECTION_REV,
                       SUB_SECTION_REV,
                       DISPLAY_FORMAT_REV,
                       REF_OWNER )
              VALUES ( ASPARTNO,
                       ANREVISION,
                       ANSECTIONID,
                       ANSUBSECTIONID,
                       ANTYPE,
                       ANITEMID,
                       LNREFVER,
                       LNREFINFO,
                       NULL,
                       1,
                       'Y',
                       LNSECTIONSEQNO,
                       ANDISPLAYFORMAT,
                       0,
                       LSINTL,
                       LNSECTIONREV,
                       LNSUBSECTIONREV,
                       LNDISPLAYFORMATREV,
                       0 );
      END IF;

      IF ANTYPE = IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC
      THEN
         SELECT ATTACHED_SPEC_SEQ.NEXTVAL
           INTO LNATTACHEDSPEC
           FROM DUAL;

         UPDATE SPECIFICATION_SECTION
            SET REF_ID = LNATTACHEDSPEC
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND REF_ID = 0
            AND TYPE = ANTYPE;
      ELSIF ANTYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY
      THEN
         IF ANATTRIBUTE > 0
         THEN
            
            BEGIN
               SELECT DISTINCT REVISION
                          INTO LNATTRIBUTEREV
                          FROM ATTRIBUTE_H
                         WHERE ATTRIBUTE = ANATTRIBUTE
                           AND MAX_REV = 1;
            EXCEPTION
               WHEN OTHERS
               THEN
                  LNATTRIBUTEREV := 0;
            END;
         ELSE
            LNATTRIBUTEREV := 0;
         END IF;

         IF ANUOMID > 0
         THEN
            
            BEGIN
               SELECT DISTINCT REVISION
                          INTO LNUOMREV
                          FROM UOM_H
                         WHERE UOM_ID = ANUOMID
                           AND MAX_REV = 1;
            EXCEPTION
               WHEN OTHERS
               THEN
                  LNUOMREV := 0;
            END;
         END IF;

         IF ANASS1 > 0
         THEN
            
            BEGIN
               SELECT DISTINCT REVISION
                          INTO LNASSREV1
                          FROM ASSOCIATION_H
                         WHERE ASSOCIATION = ANASS1
                           AND MAX_REV = 1;
            EXCEPTION
               WHEN OTHERS
               THEN
                  LNASSREV1 := 0;
            END;
         END IF;

         
         IF ANASS2 > 0
         THEN
            BEGIN
               SELECT DISTINCT REVISION
                          INTO LNASSREV2
                          FROM ASSOCIATION_H
                         WHERE ASSOCIATION = ANASS2
                           AND MAX_REV = 1;
            EXCEPTION
               WHEN OTHERS
               THEN
                  LNASSREV2 := 0;
            END;
         END IF;

         
         IF ANASS3 > 0
         THEN
            BEGIN
               SELECT DISTINCT REVISION
                          INTO LNASSREV3
                          FROM ASSOCIATION_H
                         WHERE ASSOCIATION = ANASS3
                           AND MAX_REV = 1;
            EXCEPTION
               WHEN OTHERS
               THEN
                  LNASSREV3 := 0;
            END;
         END IF;

         
         INSERT INTO SPECIFICATION_PROP
                     ( PART_NO,
                       REVISION,
                       SECTION_ID,
                       SECTION_REV,
                       SUB_SECTION_ID,
                       SUB_SECTION_REV,
                       PROPERTY_GROUP,
                       PROPERTY_GROUP_REV,
                       PROPERTY,
                       PROPERTY_REV,
                       ATTRIBUTE,
                       ATTRIBUTE_REV,
                       UOM_ID,
                       UOM_REV,
                       TEST_METHOD,
                       TEST_METHOD_REV,
                       SEQUENCE_NO,
                       ASSOCIATION,
                       ASSOCIATION_REV,
                       AS_2,
                       AS_REV_2,
                       AS_3,
                       AS_REV_3,
                       INTL )
              VALUES ( ASPARTNO,
                       ANREVISION,
                       ANSECTIONID,
                       LNSECTIONREV,
                       ANSUBSECTIONID,
                       LNSUBSECTIONREV,
                       0,
                       0,
                       ANITEMID,
                       LNREFVER,
                       ANATTRIBUTE,
                       LNATTRIBUTEREV,
                       ANUOMID,
                       LNUOMREV,
                       0,
                       0,
                       100,
                       ANASS1,
                       LNASSREV1,
                       ANASS2,
                       LNASSREV2,
                       ANASS3,
                       LNASSREV3,
                       LSINTL );
      ELSIF ANTYPE = IAPICONSTANT.SECTIONTYPE_FREETEXT
      THEN
         
         INSERT INTO SPECIFICATION_TEXT
                     ( PART_NO,
                       REVISION,
                       SECTION_ID,
                       SUB_SECTION_ID,
                       SECTION_REV,
                       SUB_SECTION_REV,
                       TEXT_TYPE,
                       TEXT_TYPE_REV )
            SELECT PART_NO,
                   REVISION,
                   SECTION_ID,
                   SUB_SECTION_ID,
                   SECTION_REV,
                   SUB_SECTION_REV,
                   REF_ID,
                   REF_VER
              FROM SPECIFICATION_SECTION
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND SECTION_ID = ANSECTIONID
               AND SUB_SECTION_ID = ANSUBSECTIONID
               AND TYPE = IAPICONSTANT.SECTIONTYPE_FREETEXT
               AND REF_ID = ANITEMID;
      END IF;

      
      INSERT INTO ITSHEXT
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID,
                    TYPE,
                    REF_ID,
                    REF_VER,
                    REF_OWNER,
                    PROPERTY_GROUP,
                    PROPERTY,
                    ATTRIBUTE )
           VALUES ( ASPARTNO,
                    ANREVISION,
                    ANSECTIONID,
                    ANSUBSECTIONID,
                    ANTYPE,
                    ANITEMID,
                    LNREFVER,
                    0,
                    LNPROPERTYGROUP,
                    LNPROPERTY,
                    ANATTRIBUTE );

      INSERT INTO SPECDATA_SERVER
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID )
           VALUES ( ASPARTNO,
                    ANREVISION,
                    ANSECTIONID,
                    ANSUBSECTIONID );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EDITEXTENDABLESECTION;

   
   FUNCTION EDITSECTIONPROPERTY(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANPROPERTYGROUP            IN       IAPITYPE.ID_TYPE,
      ANPROPERTY                 IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTE                IN       IAPITYPE.ID_TYPE,
      ANUOMID                    IN       IAPITYPE.ID_TYPE,
      ANASS1                     IN       IAPITYPE.ID_TYPE,
      ANASS2                     IN       IAPITYPE.ID_TYPE,
      ANASS3                     IN       IAPITYPE.ID_TYPE,
      ASACTION                   IN       IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LNSEQUENCE                    IAPITYPE.SEQUENCE_TYPE;
      LNSECTIONREV                  IAPITYPE.REVISION_TYPE;
      LNSUBSECTIONREV               IAPITYPE.REVISION_TYPE;
      LNUOMREV                      IAPITYPE.REVISION_TYPE;
      LNASSREV1                     IAPITYPE.REVISION_TYPE;
      LNASSREV2                     IAPITYPE.REVISION_TYPE;
      LNASSREV3                     IAPITYPE.REVISION_TYPE;
      LNATTRIBUTEREV                IAPITYPE.REVISION_TYPE;
      LNPROPERTYREV                 IAPITYPE.REVISION_TYPE;
      LNPROPERTYGROUP_REV           IAPITYPE.REVISION_TYPE;
      LSINTL                        IAPITYPE.INTL_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'EditSectionProperty';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      
      LNUOMID                       IAPITYPE.ID_TYPE;

   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Action <'
                           || ASACTION
                           || '> SC <'
                           || ANSECTIONID
                           || '> SB <'
                           || ANSUBSECTIONID
                           || '> PG <'
                           || ANPROPERTYGROUP
                           || '> SP <'
                           || ANPROPERTY
                           || '> AT <'
                           || ANATTRIBUTE
                           || '>' );

      IF ASACTION = 'rem'
      THEN
         
         DELETE FROM SPECIFICATION_PROP
               WHERE PART_NO = ASPARTNO
                 AND REVISION = ANREVISION
                 AND SECTION_ID = ANSECTIONID
                 AND SUB_SECTION_ID = ANSUBSECTIONID
                 AND PROPERTY_GROUP = ANPROPERTYGROUP
                 AND PROPERTY = ANPROPERTY
                 AND ATTRIBUTE = ANATTRIBUTE;

         DELETE FROM ITSHEXT
               WHERE PART_NO = ASPARTNO
                 AND REVISION = ANREVISION
                 AND SECTION_ID = ANSECTIONID
                 AND SUB_SECTION_ID = ANSUBSECTIONID
                 AND TYPE = 4
                 AND PROPERTY_GROUP = ANPROPERTYGROUP
                 AND PROPERTY = ANPROPERTY
                 AND ATTRIBUTE = ANATTRIBUTE;
      ELSE
         

         
         SELECT MAX( SEQUENCE_NO )
           INTO LNSEQUENCE
           FROM SPECIFICATION_PROP
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND PROPERTY_GROUP = ANPROPERTYGROUP;

         IF LNSEQUENCE IS NULL
         THEN
            LNSEQUENCE := 0;
         END IF;

         LNSEQUENCE :=   LNSEQUENCE
                       + 10;

         
         SELECT DISTINCT SECTION_REV,
                         SUB_SECTION_REV,
                         REF_VER
                    INTO LNSECTIONREV,
                         LNSUBSECTIONREV,
                         LNPROPERTYGROUP_REV
                    FROM SPECIFICATION_SECTION
                   WHERE PART_NO = ASPARTNO
                     AND REVISION = ANREVISION
                     AND SECTION_ID = ANSECTIONID
                     AND SUB_SECTION_ID = ANSUBSECTIONID
                     AND TYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP
                     AND REF_ID = ANPROPERTYGROUP;

         IF ANPROPERTY > 0
         THEN
            
            BEGIN
               SELECT DISTINCT REVISION
                          INTO LNPROPERTYREV
                          FROM PROPERTY_H
                         WHERE PROPERTY = ANPROPERTY
                           AND MAX_REV = 1;
            EXCEPTION
               WHEN OTHERS
               THEN
                  LNPROPERTYREV := 0;
            END;
         ELSE
            LNPROPERTYREV := 0;
         END IF;

         IF ANATTRIBUTE > 0
         THEN
            
            BEGIN
               SELECT DISTINCT REVISION
                          INTO LNATTRIBUTEREV
                          FROM ATTRIBUTE_H
                         WHERE ATTRIBUTE = ANATTRIBUTE
                           AND MAX_REV = 1;
            EXCEPTION
               WHEN OTHERS
               THEN
                  LNATTRIBUTEREV := 0;
            END;
         ELSE
            LNATTRIBUTEREV := 0;
         END IF;

        
        IF ANUOMID = 0
        THEN
            LNUOMID := NULL;
        ELSE
            LNUOMID := ANUOMID;
        END IF;
        

         
         
         IF LNUOMID > 0
         
         THEN
            
            BEGIN
               SELECT DISTINCT REVISION
                          INTO LNUOMREV
                          FROM UOM_H
                         
                         
                         WHERE UOM_ID = LNUOMID
                         
                           AND MAX_REV = 1;
            EXCEPTION
               WHEN OTHERS
               THEN
                  LNUOMREV := 0;
            END;
         ELSE
            LNUOMREV := 0;
         END IF;

         IF ANASS1 > 0
         THEN
            
            BEGIN
               SELECT DISTINCT REVISION
                          INTO LNASSREV1
                          FROM ASSOCIATION_H
                         WHERE ASSOCIATION = ANASS1
                           AND MAX_REV = 1;
            EXCEPTION
               WHEN OTHERS
               THEN
                  LNASSREV1 := 0;
            END;
         ELSE
            LNASSREV1 := 0;
         END IF;

         
         IF ANASS2 > 0
         THEN
            BEGIN
               SELECT DISTINCT REVISION
                          INTO LNASSREV2
                          FROM ASSOCIATION_H
                         WHERE ASSOCIATION = ANASS2
                           AND MAX_REV = 1;
            EXCEPTION
               WHEN OTHERS
               THEN
                  LNASSREV2 := 0;
            END;
         ELSE
            LNASSREV2 := 0;
         END IF;

         
         IF ANASS3 > 0
         THEN
            BEGIN
               SELECT DISTINCT REVISION
                          INTO LNASSREV3
                          FROM ASSOCIATION_H
                         WHERE ASSOCIATION = ANASS3
                           AND MAX_REV = 1;
            EXCEPTION
               WHEN OTHERS
               THEN
                  LNASSREV3 := 0;
            END;
         ELSE
            LNASSREV3 := 0;
         END IF;

         BEGIN
            SELECT INTL
              INTO LSINTL
              FROM SPECIFICATION_HEADER
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LSINTL := 0;
         END;

         INSERT INTO SPECIFICATION_PROP
                     ( PART_NO,
                       REVISION,
                       SECTION_ID,
                       SUB_SECTION_ID,
                       PROPERTY_GROUP,
                       PROPERTY,
                       ATTRIBUTE,
                       UOM_ID,
                       ASSOCIATION,
                       AS_2,
                       AS_3,
                       SEQUENCE_NO,
                       SECTION_REV,
                       SUB_SECTION_REV,
                       PROPERTY_GROUP_REV,
                       PROPERTY_REV,
                       ATTRIBUTE_REV,
                       UOM_REV,
                       ASSOCIATION_REV,
                       AS_REV_2,
                       AS_REV_3,
                       INTL )
              VALUES ( ASPARTNO,
                       ANREVISION,
                       ANSECTIONID,
                       ANSUBSECTIONID,
                       ANPROPERTYGROUP,
                       ANPROPERTY,
                       ANATTRIBUTE,
               
                       
                       LNUOMID,
               
                       ANASS1,
                       ANASS2,
                       ANASS3,
                       LNSEQUENCE,
                       LNSECTIONREV,
                       LNSUBSECTIONREV,
                       LNPROPERTYGROUP_REV,
                       LNPROPERTYREV,
                       LNATTRIBUTEREV,
                       LNUOMREV,
                       LNASSREV1,
                       LNASSREV2,
                       LNASSREV3,
                       LSINTL );

         INSERT INTO ITSHEXT
                     ( PART_NO,
                       REVISION,
                       SECTION_ID,
                       SUB_SECTION_ID,
                       TYPE,
                       REF_ID,
                       REF_VER,
                       REF_OWNER,
                       PROPERTY_GROUP,
                       PROPERTY,
                       ATTRIBUTE )
              VALUES ( ASPARTNO,
                       ANREVISION,
                       ANSECTIONID,
                       ANSUBSECTIONID,
                       4,
                       0,
                       0,
                       0,
                       ANPROPERTYGROUP,
                       ANPROPERTY,
                       ANATTRIBUTE );
      END IF;

      INSERT INTO SPECDATA_SERVER
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID )
           VALUES ( ASPARTNO,
                    ANREVISION,
                    ANSECTIONID,
                    ANSUBSECTIONID );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EDITSECTIONPROPERTY;

   
   FUNCTION EDITSECTIONLAYOUT(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANLAYOUT                   IN       IAPITYPE.ID_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LNLAYOUTREVISION              IAPITYPE.REVISION_TYPE := 0;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'EditSectionLayout';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
      LNITEMID                      IAPITYPE.ID_TYPE;
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
      LNOLDLAYOUT                   IAPITYPE.ID_TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LSSQLINFO                     IAPITYPE.SQLSTRING_TYPE;
      LQERRORS                      IAPITYPE.REF_TYPE;
   BEGIN
      
      
      
      
      
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
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'asPartNo = '
                           || ASPARTNO,
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'anRevision = '
                           || ANREVISION,
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'anSectionId = '
                           || ANSECTIONID,
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'anSubSectionId = '
                           || ANSUBSECTIONID,
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'anType = '
                           || ANTYPE,
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'anItemId = '
                           || ANITEMID,
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'anLayout = '
                           || ANLAYOUT,
                           IAPICONSTANT.INFOLEVEL_3 );
      LNSECTIONID := ANSECTIONID;
      LNSUBSECTIONID := ANSUBSECTIONID;
      LNITEMID := ANITEMID;

      IF    LNSECTIONID IS NULL
         OR LNSUBSECTIONID IS NULL
         OR LNITEMID IS NULL
      THEN
         SELECT SECTION_ID,
                SUB_SECTION_ID,
                REF_ID
           INTO LNSECTIONID,
                LNSUBSECTIONID,
                LNITEMID
           FROM SPECIFICATION_SECTION
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND TYPE = ANTYPE;
      END IF;

      IF ANTYPE = IAPICONSTANT.SECTIONTYPE_BOM
      THEN
         SELECT ST.STATUS_TYPE
           INTO LSSTATUSTYPE
           FROM STATUS ST,
                SPECIFICATION_HEADER SH
          WHERE SH.PART_NO = ASPARTNO
            AND SH.REVISION = ANREVISION
            AND ST.STATUS = SH.STATUS;
      END IF;

      IF     (     ANTYPE = IAPICONSTANT.SECTIONTYPE_BOM
               AND LSSTATUSTYPE = IAPICONSTANT.STATUSTYPE_DEVELOPMENT )
         AND (     ANLAYOUT NOT IN( 2, 3 )
               AND ANLAYOUT IS NOT NULL )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_DISPLAYFORMATINVALID,
                                                     ANLAYOUT,
                                                     'Bom' ) );
      END IF;

      IF     ANTYPE = IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST
         AND ANLAYOUT NOT IN( 1, 2 )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_DISPLAYFORMATINVALID,
                                                     ANLAYOUT,
                                                     'Ingredient list' ) );
      END IF;

      IF     ANTYPE = IAPICONSTANT.SECTIONTYPE_BASENAME
         AND ANLAYOUT NOT IN( 1, 2 )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_DISPLAYFORMATINVALID,
                                                     ANLAYOUT,
                                                     'Basename' ) );
      END IF;

      IF    (     ANTYPE = IAPICONSTANT.SECTIONTYPE_BOM
              AND LSSTATUSTYPE = IAPICONSTANT.STATUSTYPE_DEVELOPMENT )
         OR ANTYPE = IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST
         OR ANTYPE = IAPICONSTANT.SECTIONTYPE_BASENAME
      THEN
         LNLAYOUTREVISION := 0;
      ELSE
         
         SELECT REVISION
           INTO LNLAYOUTREVISION
           FROM LAYOUT
          WHERE LAYOUT_ID = ANLAYOUT
            AND STATUS = 2;
      END IF;

      IF ANTYPE = IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST
      THEN
         SELECT DISPLAY_FORMAT
           INTO LNOLDLAYOUT
           FROM SPECIFICATION_SECTION
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = LNSECTIONID
            AND SUB_SECTION_ID = LNSUBSECTIONID
            AND TYPE = ANTYPE
            AND REF_ID = LNITEMID;
      END IF;

      
      UPDATE SPECIFICATION_SECTION
         SET DISPLAY_FORMAT = ANLAYOUT,
             DISPLAY_FORMAT_REV = LNLAYOUTREVISION
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND SECTION_ID = LNSECTIONID
         AND SUB_SECTION_ID = LNSUBSECTIONID
         AND TYPE = ANTYPE
         AND REF_ID = LNITEMID;

      UPDATE SPECIFICATION_HEADER
         SET LAST_MODIFIED_BY = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
             LAST_MODIFIED_ON = SYSDATE
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION;

      
      BEGIN
         LNRETVAL := IAPISPECIFICATION.CLEANLAYOUT( ASPARTNO,
                                                    ANREVISION,
                                                    ANLAYOUT,
                                                    LNLAYOUTREVISION,
                                                    LNSECTIONID,
                                                    LNSUBSECTIONID,
                                                    LNITEMID,
                                                    ANTYPE );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END;

      
      IF    ANTYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP
         OR ANTYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY
         OR ANTYPE = IAPICONSTANT.SECTIONTYPE_PROCESSDATA
      THEN
         BEGIN
            INSERT INTO ITSHLY
                        ( LY_ID,
                          LY_TYPE,
                          DISPLAY_FORMAT )
                 VALUES ( LNITEMID,
                          ANTYPE,
                          ANLAYOUT );
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
               NULL;
         END;
      END IF;

      IF ANTYPE = IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST
      THEN
         IF    ANLAYOUT <> LNOLDLAYOUT
            OR LNOLDLAYOUT IS NULL
         THEN
            LNRETVAL := IAPISPECIFICATIONINGRDIENTLIST.REMOVELISTDATA( ASPARTNO,
                                                                       ANREVISION,
                                                                       AQINFO,
                                                                       LQERRORS );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    IAPIGENERAL.GETLASTERRORTEXT( ) );
               RETURN( LNRETVAL );
            END IF;
         END IF;
      END IF;

      
      INSERT INTO SPECDATA_SERVER
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID )
           VALUES ( ASPARTNO,
                    ANREVISION,
                    LNSECTIONID,
                    LNSUBSECTIONID );

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

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EDITSECTIONLAYOUT;

   
   FUNCTION CHECKEXTENDABLESECTION(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANFRAMEREVISION            IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANFRAMEOWNER               IN       IAPITYPE.OWNER_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTE                IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckExtendableSection';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ANTYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY
      THEN
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM FRAME_PROP
          WHERE FRAME_NO = ASFRAMENO
            AND REVISION = ANFRAMEREVISION
            AND OWNER = ANFRAMEOWNER
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND PROPERTY_GROUP = 0
            AND PROPERTY = ANITEMID;

         IF LNCOUNT != 0
         THEN
            LNRETVAL :=
               IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_SPPROPERTYALREADYINGROUP,
                                         ASPARTNO,
                                         ANREVISION,
                                         
                                         
                                         
                                         F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSECTIONID, 0),
                                         F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSUBSECTIONID, 0),
                                         
                                         0,
                                         
                                         
                                         
                                         F_RFH_DESCR(NULL, ANTYPE, ANITEMID),
                                         F_ATH_DESCR(NULL, ANATTRIBUTE, 0));
                                         
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         SELECT COUNT( * )
           INTO LNCOUNT
           FROM ITSHEXT
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND TYPE = ANTYPE
            AND REF_ID = ANITEMID;

         IF LNCOUNT != 0
         THEN
            LNRETVAL :=
               IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_ITEMALREADYINSECTION,
                                         ASPARTNO,
                                         ANREVISION,
                                         F_SCH_DESCR( NULL,
                                                      ANSECTIONID,
                                                      0 ),
                                         F_SBH_DESCR( NULL,
                                                      ANSUBSECTIONID,
                                                      0 ),
                                         
                                         
                                         
                                         F_RFH_DESCR(NULL, ANTYPE, ANITEMID));
                                         
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      ELSE
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM FRAME_SECTION
          WHERE FRAME_NO = ASFRAMENO
            AND REVISION = ANFRAMEREVISION
            AND OWNER = ANFRAMEOWNER
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND TYPE = ANTYPE
            AND REF_ID = ANITEMID;

         IF LNCOUNT != 0
         THEN
            LNRETVAL :=
               IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_ITEMALREADYINSECTION,
                                         ASPARTNO,
                                         ANREVISION,
                                         F_SCH_DESCR( NULL,
                                                      ANSECTIONID,
                                                      0 ),
                                         F_SBH_DESCR( NULL,
                                                      ANSUBSECTIONID,
                                                      0 ),
                                         
                                         
                                         
                                         F_RFH_DESCR(NULL, ANTYPE, ANITEMID));
                                         
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         SELECT COUNT( * )
           INTO LNCOUNT
           FROM ITSHEXT
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND TYPE = ANTYPE
            AND REF_ID = ANITEMID;

         IF LNCOUNT != 0
         THEN
            LNRETVAL :=
               IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_ITEMALREADYINSECTION,
                                         ASPARTNO,
                                         ANREVISION,
                                         F_SCH_DESCR( NULL,
                                                      ANSECTIONID,
                                                      0 ),
                                         F_SBH_DESCR( NULL,
                                                      ANSUBSECTIONID,
                                                      0 ),
                                         
                                         
                                         
                                         F_RFH_DESCR(NULL, ANTYPE, ANITEMID));
                                         
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
   END CHECKEXTENDABLESECTION;

   
   FUNCTION ADDANYHOOK(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANITEMREVISION             IN       IAPITYPE.REVISION_TYPE,
      ANITEMOWNER                IN       IAPITYPE.OWNER_TYPE,
      ANTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LNHEADER                      IAPITYPE.NUMVAL_TYPE;
      LNSECTIONREV                  IAPITYPE.REVISION_TYPE;
      LNSUBSECTIONREV               IAPITYPE.REVISION_TYPE;
      LNSECTIONSEQNO                IAPITYPE.SEQUENCE_TYPE;
      LSOLEOBJECT                   IAPITYPE.STRING_TYPE;
      LNREFINFO                     IAPITYPE.ITEMINFO_TYPE;
      LNREFSECTIONSEQUENCENO        IAPITYPE.SEQUENCE_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddAnyHook';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ANTYPE NOT IN( IAPICONSTANT.SECTIONTYPE_REFERENCETEXT, IAPICONSTANT.SECTIONTYPE_OBJECT )
      THEN
         RAISE_APPLICATION_ERROR( -20000,
                                  'Type not supported' );
      END IF;

      SELECT REF_INFO,
             HEADER,
             SECTION_REV,
             SUB_SECTION_REV,
             SECTION_SEQUENCE_NO
        INTO LNREFINFO,
             LNHEADER,
             LNSECTIONREV,
             LNSUBSECTIONREV,
             LNREFSECTIONSEQUENCENO
        FROM SPECIFICATION_SECTION
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND SECTION_ID = ANSECTIONID
         AND SUB_SECTION_ID = ANSUBSECTIONID
         AND TYPE = ANTYPE
         AND REF_ID = 0;

      SELECT   MAX( SECTION_SEQUENCE_NO )
             + 1
        INTO LNSECTIONSEQNO
        FROM SPECIFICATION_SECTION
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND SECTION_ID = ANSECTIONID
         AND SUB_SECTION_ID = ANSUBSECTIONID
         AND TYPE = ANTYPE
         AND ROUND(   SECTION_SEQUENCE_NO
                    / 100 ) = ROUND(   LNREFSECTIONSEQUENCENO
                                     / 100 );

      IF ANTYPE = IAPICONSTANT.SECTIONTYPE_OBJECT
      THEN
         SELECT OLE_OBJECT
           INTO LSOLEOBJECT
           FROM ITOID
          WHERE OBJECT_ID = ANITEMID
            AND REVISION = ANITEMREVISION
            AND OWNER = ANITEMOWNER;

         IF LSOLEOBJECT = 'Y'
         THEN
            LNREFINFO := 0;
         ELSIF LSOLEOBJECT = 'N'
         THEN
            LNREFINFO := 1;
         ELSIF LSOLEOBJECT = 'P'
         THEN
            LNREFINFO := 2;
         ELSE
            LNREFINFO := 0;
         END IF;
      END IF;

      INSERT INTO SPECIFICATION_SECTION
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SECTION_REV,
                    SUB_SECTION_ID,
                    SUB_SECTION_REV,
                    REF_ID,
                    REF_VER,
                    REF_INFO,
                    REF_OWNER,
                    SEQUENCE_NO,
                    HEADER,
                    MANDATORY,
                    SECTION_SEQUENCE_NO,
                    INTL,
                    TYPE )
           VALUES ( ASPARTNO,
                    ANREVISION,
                    ANSECTIONID,
                    LNSECTIONREV,
                    ANSUBSECTIONID,
                    LNSUBSECTIONREV,
                    ANITEMID,
                    ANITEMREVISION,
                    LNREFINFO,
                    ANITEMOWNER,
                    0,
                    LNHEADER,
                    'N',
                    LNSECTIONSEQNO,
                    1,
                    ANTYPE );

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( ASPARTNO,
                                                ANREVISION );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDANYHOOK;


   FUNCTION GETLOCKED(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ASUSERID                   OUT      IAPITYPE.USERID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetLocked';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
          
          

      
      LNRETVAL := IAPISPECIFICATION.GETLOCKED( ASPARTNO,
                                               ANREVISION,
                                               ASUSERID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      IF (    ASUSERID IS NULL
           OR ASUSERID = '' )
      THEN
         NULL;
      ELSE
         IF ASUSERID <> IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
         THEN
            RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
         END IF;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ANSUBSECTIONID <> 0 )
      THEN
         
         SELECT LOCKED
           INTO ASUSERID
           FROM SPECIFICATION_SECTION
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND ROWNUM < 2;
      ELSE
         
         SELECT LOCKED
           INTO ASUSERID
           FROM SPECIFICATION_SECTION
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND LOCKED IS NOT NULL
            AND ROWNUM < 2;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      
      WHEN NO_DATA_FOUND
      THEN
         ASUSERID := NULL;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
   END GETLOCKED;

   FUNCTION GETLOCKED(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASUSERID                   OUT      IAPITYPE.USERID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
       
       
      
       
       
       
       
       
       
       
       
       
       
      
       
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetLocked';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
       
       
       
      
      LNRETVAL := IAPISPECIFICATION.EXISTID( ASPARTNO,
                                             ANREVISION );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      SELECT LOCKED
        INTO ASUSERID
        FROM SPECIFICATION_SECTION
       WHERE (     PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND LOCKED IS NOT NULL
               AND LOCKED <> IAPIGENERAL.SESSION.APPLICATIONUSER.USERID )
         AND ROWNUM < 2;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      
      WHEN NO_DATA_FOUND
      THEN
         ASUSERID := NULL;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
   END GETLOCKED;

   
   
   
   FUNCTION CHECKLOCK(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ABISSET                    OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckLock';
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LBLOCKED                      IAPITYPE.BOOLEAN_TYPE;
   BEGIN
      
      
      
      

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := GETLOCKED( ASPARTNO,
                             ANREVISION,
                             ANSECTIONID,
                             ANSUBSECTIONID,
                             LSUSERID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      
      IF (    LSUSERID IS NULL
           OR LSUSERID = '' )
      THEN
         ABISSET := NULL;
      ELSIF( LSUSERID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID )
      THEN
         ABISSET := 1;
      ELSE
         ABISSET := 0;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
   END CHECKLOCK;

   
   
   
   FUNCTION SETLOCK(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SetLock';
   BEGIN
      
      
      
      

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( ANSUBSECTIONID <> 0 )
      THEN
         UPDATE SPECIFICATION_SECTION
            SET LOCKED = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID;
      ELSE
         UPDATE SPECIFICATION_SECTION
            SET LOCKED = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
   END SETLOCK;

   FUNCTION LOCKSPEC(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'LockSpec';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LBLOCKED                      IAPITYPE.BOOLEAN_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LNACCESSLEVEL                 IAPITYPE.ID_TYPE;
      LSPARAMETERDATA               IAPITYPE.PARAMETERDATA_TYPE;
   BEGIN
      
      
      
      
      LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( 'locking_enabled',
                                                       'interspec',
                                                       LSPARAMETERDATA );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      
      IF NOT( LSPARAMETERDATA <> 0 )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SPECIFICATIONUNLOCKABLE ) );
      END IF;

      
      
      
      LNACCESSLEVEL := 1;
      
      LNRETVAL := CHECKLOCK( ASPARTNO,
                             ANREVISION,
                             ANSECTIONID,
                             ANSUBSECTIONID,
                             LBLOCKED );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      
      IF (    LBLOCKED = 1
           OR LBLOCKED = 0 )
      THEN
         
         LNRETVAL := GETLOCKED( ASPARTNO,
                                ANREVISION,
                                ANSECTIONID,
                                ANSUBSECTIONID,
                                LSUSERID );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( LNRETVAL );
         END IF;

         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SECTIONALREADYLOCKED,
                                                     ASPARTNO,
                                                     ANREVISION,
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSECTIONID, 0),
                                                     
                                                     LSUSERID ) );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.CHECKLOCK( ASPARTNO,
                                               ANREVISION,
                                               LBLOCKED );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      
      IF (    LBLOCKED = 1
           OR LBLOCKED = 0 )
      THEN
         
         LNRETVAL := IAPISPECIFICATION.GETLOCKED( ASPARTNO,
                                                  ANREVISION,
                                                  LSUSERID );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( LNRETVAL );
         END IF;

         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SPECALREADYLOCKED,
                                                     ASPARTNO,
                                                     ANREVISION,
                                                     LSUSERID ) );
      END IF;

      
      IF ( ANSUBSECTIONID <> 0 )
      THEN
         IF F_CHECK_ITEM_ACCESS( ASPARTNO,
                                 ANREVISION,
                                 ANSECTIONID,
                                 ANSUBSECTIONID,
                                 0,
                                 0,
                                 0,
                                 0,
                                 0,
                                 LNACCESSLEVEL ) = 0
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_NOEDITSECTIONACCESS,
                                                       ASPARTNO,
                                                       ANREVISION,
                                                       
                                                       
                                                       
                                                       F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSECTIONID, 0),
                                                       F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSUBSECTIONID, 0) );
                                                      
         END IF;
      ELSE
         IF F_CHECK_ALL_ITEMS_ACCESS( ASPARTNO,
                                      ANREVISION,
                                      ANSECTIONID,
                                      0,
                                      0,
                                      0,
                                      0,
                                      0,
                                      LNACCESSLEVEL ) = 0
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_NOEDITSECTIONACCESS,
                                                       ASPARTNO,
                                                       ANREVISION,
                                                       
                                                       
                                                       F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSECTIONID, 0),
                                                       
                                                       '(All)' );
         END IF;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := SETLOCK( ASPARTNO,
                           ANREVISION,
                           ANSECTIONID,
                           ANSUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
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
   END LOCKSPEC;

   
   
   
   FUNCTION RESETLOCK(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ResetLock';
   BEGIN
      
      
      
      

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( ANSUBSECTIONID <> 0 )
      THEN
         UPDATE SPECIFICATION_SECTION
            SET LOCKED = NULL
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID;
      ELSE
         UPDATE SPECIFICATION_SECTION
            SET LOCKED = NULL
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
   END RESETLOCK;

   FUNCTION UNLOCKSPEC(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
       
       
       
       
       
       
       
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'UnlockSpec';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LBLOCKED                      IAPITYPE.BOOLEAN_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
   BEGIN
      
      
      
      
      IF ( ANSUBSECTIONID <> 0 )
      THEN
         LNRETVAL := EXISTID( ASPARTNO,
                              ANREVISION,
                              ANSECTIONID,
                              ANSUBSECTIONID );
      ELSE
         LNRETVAL := IAPISPECIFICATION.EXISTID( ASPARTNO,
                                                ANREVISION );
      END IF;

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := CHECKLOCK( ASPARTNO,
                             ANREVISION,
                             ANSECTIONID,
                             ANSUBSECTIONID,
                             LBLOCKED );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      
      IF ( LBLOCKED = 0 )
      THEN
         
         LNRETVAL := GETLOCKED( ASPARTNO,
                                ANREVISION,
                                ANSECTIONID,
                                ANSUBSECTIONID,
                                LSUSERID );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( LNRETVAL );
         END IF;

         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SECTIONALREADYLOCKED,
                                                     ASPARTNO,
                                                     ANREVISION,
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSECTIONID, 0),
                                                     
                                                     LSUSERID ) );
      END IF;

      
      IF ( LBLOCKED IS NULL )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SECTIONNOTLOCKED,
                                                     ASPARTNO,
                                                     ANREVISION ) );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      

      
      LNRETVAL := RESETLOCK( ASPARTNO,
                             ANREVISION,
                             ANSECTIONID,
                             ANSUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
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
   END UNLOCKSPEC;
	 
	FUNCTION F_IS_EXTENDABLE(
		ASPARTNO     IN IAPITYPE.FRAMENO_TYPE,
		ANREVISION   IN IAPITYPE.FRAMEREVISION_TYPE,
		ANSECTION    IN FRAME_SECTION.SECTION_ID%TYPE,
		ANSUBSECTION IN FRAME_SECTION.SUB_SECTION_ID%TYPE,
		ANREF_ID     IN FRAME_SECTION.REF_ID%TYPE)
		RETURN NUMBER IS
		
		 
		 
		 
		 
	
		LNFRAMENO  IAPITYPE.FRAMENO_TYPE;
		LNFRAME_REV IAPITYPE.FRAMEREVISION_TYPE;
		EXTENDABLE NVARCHAR2(1);
	BEGIN

		SELECT FRAME_ID, FRAME_REV
			INTO LNFRAMENO, LNFRAME_REV
			FROM SPECIFICATION_HEADER
		 WHERE PART_NO = ASPARTNO
			 AND REVISION = ANREVISION;
			 
		SELECT REF_EXT
			INTO EXTENDABLE
			FROM FRAME_SECTION
		 WHERE FRAME_NO = LNFRAMENO
			 AND REVISION = LNFRAME_REV
			 AND SECTION_ID = ANSECTION
			 AND SUB_SECTION_ID = ANSUBSECTION
			 AND MANDATORY <> 'Y'
			 AND REF_ID = ANREF_ID;

		IF EXTENDABLE = 'Y'
		THEN
			RETURN 1;
		ELSE
			RETURN 0;
		END IF;
		EXCEPTION WHEN OTHERS THEN RETURN -1;
	END F_IS_EXTENDABLE;	 
	 
END IAPISPECIFICATIONSECTION;
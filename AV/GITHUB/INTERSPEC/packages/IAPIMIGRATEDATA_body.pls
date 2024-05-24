CREATE OR REPLACE PACKAGE BODY iapiMigrateData
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

   
   
   

   
   
   
   FUNCTION VALIDATEFIELD(
      ASFIELDNAME                IN       IAPITYPE.STRINGVAL_TYPE,
      ASVALUE                    IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateField';
      LSNOTFOUND                    IAPITYPE.STRING_TYPE := '#N/A';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ASVALUE = LSNOTFOUND
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     
                                                     IAPICONSTANTDBERROR.DBERR_VALUEFIELDEQNA,
                                                     ASFIELDNAME ) );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END VALIDATEFIELD;

   
   FUNCTION STRIPQUOTES(
      ASVALUE                    IN OUT   IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'StripQuotes';
      LSVALUE                       IAPITYPE.INFO_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSVALUE := ASVALUE;

      IF INSTR( LSVALUE,
                '""' ) > 0
      THEN
         
         LSVALUE := REPLACE( LSVALUE,
                             '""',
                             '"' );
         
         LSVALUE := TRIM( LSVALUE );
         LSVALUE := SUBSTR( TRIM( LSVALUE ),
                            2,
                              LENGTH( LSVALUE )
                            - 2 );
      END IF;

      ASVALUE := LSVALUE;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END STRIPQUOTES;

   
   FUNCTION MANIPULATELINE(
      ASDATA                     IN OUT   IAPITYPE.STRINGVAL_TYPE,
      ATPOSTAB                   IN       IAPITYPE.NUMBERTAB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE := 1;
      LNLENGTH                      IAPITYPE.NUMVAL_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSDATA                        IAPITYPE.INFO_TYPE := NULL;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ManipulateLine';
      LSVALUE                       IAPITYPE.INFO_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNLENGTH := ATPOSTAB.COUNT;

      FOR LNCOUNT IN 1 .. LNLENGTH
      LOOP
         IF LSDATA IS NULL
         THEN
            LSVALUE := SUBSTR( ASDATA,
                               1,
                                 ATPOSTAB( LNCOUNT )
                               - 1 );
         ELSE
            LSVALUE := SUBSTR( ASDATA,
                                 ATPOSTAB(   LNCOUNT
                                           - 1 )
                               + 1,
                                 ATPOSTAB( LNCOUNT )
                               - ATPOSTAB(   LNCOUNT
                                           - 1 )
                               - 1 );
         END IF;

         LNRETVAL := STRIPQUOTES( LSVALUE );

         IF LSDATA IS NULL
         THEN
            LSDATA := LSVALUE;
         ELSE
            LSDATA :=    LSDATA
                      || CHR( 9 )
                      || LSVALUE;
         END IF;
      END LOOP;

      LSVALUE := SUBSTR( ASDATA,
                           ATPOSTAB( LNLENGTH )
                         + 1 );
      LNRETVAL := STRIPQUOTES( LSVALUE );

      IF LSDATA IS NULL
      THEN
         LSDATA := LSVALUE;
      ELSE
         LSDATA :=    LSDATA
                   || CHR( 9 )
                   || LSVALUE;
      END IF;

      ASDATA := LSDATA;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END MANIPULATELINE;

   
   FUNCTION ADDKEYWORD(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANKEYWORDID                IN       IAPITYPE.KEYWORDID_TYPE,
      ASKEYWORDVALUE             IN       IAPITYPE.KEYWORDVALUE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddKeyWord';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNKEYWORDTYPE                 IAPITYPE.KEYWORD_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LSDESCRIPTION                 IAPITYPE.DESCRIPTION_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPIPART.EXISTID( ASPARTNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
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

      
      
      SELECT KW_TYPE,
             DESCRIPTION
        INTO LNKEYWORDTYPE,
             LSDESCRIPTION
        FROM ITKW
       WHERE KW_ID = ANKEYWORDID;

      IF LNKEYWORDTYPE = 1
      THEN
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM ITKWAS,
                ITKWCH
          WHERE ITKWAS.CH_ID = ITKWCH.CH_ID
            AND ITKWAS.KW_ID = ANKEYWORDID
            AND F_KWCH_DESCR( 1,
                              ITKWAS.CH_ID ) = ASKEYWORDVALUE;

         IF LNCOUNT = 0
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_KEYWORDVALUENOTFOUND,
                                              ASKEYWORDVALUE,
                                              LSDESCRIPTION ) );
         END IF;
      END IF;

      
      BEGIN
         INSERT INTO SPECIFICATION_KW
                     ( PART_NO,
                       KW_ID,
                       KW_VALUE,
                       INTL )
              VALUES ( ASPARTNO,
                       ANKEYWORDID,
                       ASKEYWORDVALUE,
                       0 );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            NULL;
      END;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDKEYWORD;

   
   FUNCTION ADDNOTE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ALNOTE                     IN       IAPITYPE.CLOB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddNote';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPIPART.EXISTID( ASPARTNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      BEGIN
         
         INSERT INTO ITPRNOTE
                     ( PART_NO,
                       TEXT )
              VALUES ( ASPARTNO,
                       ALNOTE );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            UPDATE ITPRNOTE
               SET TEXT = ALNOTE
             WHERE PART_NO = ASPARTNO;
      END;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDNOTE;

   
   FUNCTION ADDMANUFACTURER(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANMANUFACTURERID           IN       IAPITYPE.ID_TYPE,
      ANMANUFACTURERPLANTNO      IN       IAPITYPE.MANUFACTURERPLANTNO_TYPE,
      ASCLEARANCENUMBER          IN       IAPITYPE.CLEARANCENUMBER_TYPE,
      ASTRADENAME                IN       IAPITYPE.TRADENAME_TYPE,
      ADAUDITDATE                IN       IAPITYPE.DATE_TYPE,
      ANAUDITFREQUENCE           IN       IAPITYPE.AUDITFREQUENCE_TYPE,
      ASPRODUCTCODE              IN       IAPITYPE.PRODUCTCODE_TYPE,
      ADAPPROVALDATE             IN       IAPITYPE.DATE_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddManufacturer';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPIPART.EXISTID( ASPARTNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPIMANUFACTURER.EXISTID( ANMANUFACTURERID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPIMANUFACTURERPLANT.EXISTID( ANMANUFACTURERPLANTNO,
                                                 ANMANUFACTURERID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      BEGIN
         INSERT INTO ITPRMFC
                     ( PART_NO,
                       MFC_ID,
                       MPL_ID,
                       CLEARANCE_NO,
                       TRADE_NAME,
                       AUDIT_DATE,
                       AUDIT_FREQ,
                       INTL,
                       PRODUCT_CODE,
                       APPROVAL_DATE,
                       REVISION )
              VALUES ( ASPARTNO,
                       ANMANUFACTURERID,
                       ANMANUFACTURERPLANTNO,
                       ASCLEARANCENUMBER,
                       ASTRADENAME,
                       ADAUDITDATE,
                       ANAUDITFREQUENCE,
                       0,
                       ASPRODUCTCODE,
                       ADAPPROVALDATE,
                       ANREVISION );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            BEGIN
               UPDATE ITPRMFC
                  SET CLEARANCE_NO = ASCLEARANCENUMBER,
                      TRADE_NAME = ASTRADENAME,
                      AUDIT_DATE = ADAUDITDATE,
                      AUDIT_FREQ = ANAUDITFREQUENCE,
                      PRODUCT_CODE = ASPRODUCTCODE,
                      APPROVAL_DATE = ADAPPROVALDATE,
                      REVISION = ANREVISION
                WHERE PART_NO = ASPARTNO
                  AND MFC_ID = ANMANUFACTURERID
                  AND MPL_ID = ANMANUFACTURERPLANTNO;
            EXCEPTION
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
      END;

      IF ANMANUFACTURERPLANTNO = -1
      THEN
         LNCOUNT := NULL;

         SELECT COUNT( * )
           INTO LNCOUNT
           FROM ITMPL
          WHERE MPL_ID = ANMANUFACTURERPLANTNO;

         IF LNCOUNT = 0
         THEN
            INSERT INTO ITMPL
                        ( MPL_ID,
                          DESCRIPTION,
                          STATUS,
                          INTL )
                 VALUES ( -1,
                          'ANY',
                          0,
                          '0' );
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
   END ADDMANUFACTURER;

   
   FUNCTION ADDREASONFORISSUE(
      ASPARTNO                            IAPITYPE.PARTNO_TYPE,
      ANREVISION                          IAPITYPE.REVISION_TYPE,
      ASTEXT                              IAPITYPE.TEXT_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddReasonForIssue';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNNEXTSEQUENCE                IAPITYPE.SEQUENCENR_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
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

      SELECT MAX( ID )
        INTO LNNEXTSEQUENCE
        FROM REASON
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION;

      IF LNNEXTSEQUENCE IS NULL
      THEN
         
         SELECT REASON_SEQ.NEXTVAL
           INTO LNNEXTSEQUENCE
           FROM DUAL;

         INSERT INTO REASON
                     ( ID,
                       PART_NO,
                       REVISION,
                       STATUS_TYPE,
                       TEXT )
              VALUES ( LNNEXTSEQUENCE,
                       ASPARTNO,
                       ANREVISION,
                       IAPICONSTANT.STATUSTYPE_REASONFORISSUE,
                       '' );
      END IF;

      UPDATE REASON
         SET TEXT = ASTEXT
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND ID = LNNEXTSEQUENCE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDREASONFORISSUE;

   
   FUNCTION ADDFREETEXT(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANID                       IN       IAPITYPE.ID_TYPE,
      ASTEXT                     IN       IAPITYPE.TEXT_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSFRAMENO                     IAPITYPE.FRAMENO_TYPE;
      LNFRAMEREVISION               IAPITYPE.FRAMEREVISION_TYPE;
      LNFRAMEOWNER                  IAPITYPE.OWNER_TYPE;
      LSUPDATEALLOWED               IAPITYPE.STRING_TYPE;
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddFreeText';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( 'upd_in_dev',
                                                       'data_migration',
                                                       LSUPDATEALLOWED );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         LSUPDATEALLOWED := '1';
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.EXISTID( ASPARTNO,
                                             ANREVISION );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

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

      IF     LSSTATUSTYPE <> IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         AND NVL( LSUPDATEALLOWED,
                  '0' ) = '0'
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_SPECIFICATIONNOTINDEV,
                                               ASPARTNO,
                                               ANREVISION );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM SPECIFICATION_SECTION
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND SECTION_ID = ANSECTIONID
         AND SUB_SECTION_ID = ANSUBSECTIONID
         AND REF_ID = ANID
         AND TYPE = 5;

      IF LNCOUNT = 0
      THEN
         
         SELECT FRAME_ID,
                FRAME_REV,
                FRAME_OWNER
           INTO LSFRAMENO,
                LNFRAMEREVISION,
                LNFRAMEOWNER
           FROM SPECIFICATION_HEADER
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION;

         
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM FRAME_SECTION
          WHERE FRAME_NO = LSFRAMENO
            AND REVISION = LNFRAMEREVISION
            AND OWNER = LNFRAMEOWNER
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND REF_ID = ANID
            AND TYPE = IAPICONSTANT.SECTIONTYPE_FREETEXT;

         IF LNCOUNT = 0
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_FRAMEIDNOTFOUND,
                                                  ASPARTNO,
                                                  ANREVISION );
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         BEGIN
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
                      SECTION_REV,
                      SUB_SECTION_REV,
                      DISPLAY_FORMAT_REV,
                      REF_OWNER
                 FROM FRAME_SECTION
                WHERE FRAME_NO = LSFRAMENO
                  AND REVISION = LNFRAMEREVISION
                  AND OWNER = LNFRAMEOWNER
                  AND SECTION_ID = ANSECTIONID
                  AND SUB_SECTION_ID = ANSUBSECTIONID
                  AND REF_ID = ANID
                  AND TYPE = IAPICONSTANT.SECTIONTYPE_FREETEXT;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;

         BEGIN
            INSERT INTO SPECIFICATION_TEXT
                        ( PART_NO,
                          REVISION,
                          TEXT_TYPE,
                          SECTION_ID,
                          SECTION_REV,
                          SUB_SECTION_ID,
                          SUB_SECTION_REV,
                          TEXT_TYPE_REV,
                          LANG_ID )
               SELECT ASPARTNO,
                      ANREVISION,
                      TEXT_TYPE,
                      SECTION_ID,
                      SECTION_REV,
                      SUB_SECTION_ID,
                      SUB_SECTION_REV,
                      TEXT_TYPE_REV,
                      1
                 FROM FRAME_TEXT
                WHERE FRAME_NO = LSFRAMENO
                  AND REVISION = LNFRAMEREVISION
                  AND OWNER = LNFRAMEOWNER
                  AND SECTION_ID = ANSECTIONID
                  AND SUB_SECTION_ID = ANSUBSECTIONID
                  AND TEXT_TYPE = ANID;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      END IF;

      BEGIN
         UPDATE SPECIFICATION_TEXT
            SET TEXT = ASTEXT
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND TEXT_TYPE = ANID;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDFREETEXT;

   
   FUNCTION ADDINGREDIENT(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANINGREDIENTID             IN       IAPITYPE.ID_TYPE,
      ANSYNONYMID                IN       IAPITYPE.ID_TYPE,
      ANQUANTITY                 IN       IAPITYPE.INGREDIENTQUANTITY_TYPE,
      ANRECONSTITUTIONFACTOR     IN       IAPITYPE.RECONSTITUTIONFACTOR_TYPE,
      ASLEVEL                    IN       IAPITYPE.INGREDIENTLEVEL_TYPE,
      ASCOMMENT                  IN       IAPITYPE.INGREDIENTCOMMENT_TYPE,
      ASACTIVIND                 IN       IAPITYPE.STRING_TYPE,
      ASCHEMICALS                IN       IAPITYPE.STRING_TYPE,
      ANHIERARCHICALLEVEL        IN       IAPITYPE.INGREDIENTHIERARCHICLEVEL_TYPE,
      ANPARENTID                 IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddIngredient';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNRECONSTITUTIONFACTOR        IAPITYPE.RECONSTITUTIONFACTOR_TYPE;
      LNINGREDIENTREVISION          IAPITYPE.REVISION_TYPE;
      LNSYNONYMREVISION             IAPITYPE.REVISION_TYPE;
      LSUPDATEALLOWED               IAPITYPE.STRING_TYPE;
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LNHIERARCHICALLEVEL           IAPITYPE.INGREDIENTHIERARCHICLEVEL_TYPE;
      LNNEXTSEQUENCE                IAPITYPE.SEQUENCENR_TYPE;
      LNDUPLICATE                   IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( 'upd_in_dev',
                                                       'data_migration',
                                                       LSUPDATEALLOWED );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         LSUPDATEALLOWED := '1';
      END IF;

      
      LNRETVAL :=
          IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( ASPARTNO,
                                                       ANREVISION,
                                                       ANSECTIONID,
                                                       ANSUBSECTIONID,
                                                       IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST,
                                                       0 );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
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

      IF     LSSTATUSTYPE <> IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         AND NVL( LSUPDATEALLOWED,
                  '0' ) = '0'
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_SPECIFICATIONNOTINDEV,
                                               ASPARTNO,
                                               ANREVISION );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM ITING
       WHERE INGREDIENT = ANINGREDIENTID;

      IF LNCOUNT = 0
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_INGREDIENTNOTEXIST,
                                               ANINGREDIENTID );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      IF     ANPARENTID IS NOT NULL
         AND ANPARENTID <> 0
      THEN
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM ITING
          WHERE INGREDIENT = ANPARENTID;

         IF LNCOUNT = 0
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_PARENTINGREDIENTNOTEXIST,
                                                  ANPARENTID );
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END IF;

      
      IF LSSTATUSTYPE <> IAPICONSTANT.STATUSTYPE_DEVELOPMENT
      THEN   
         BEGIN
            SELECT MAX( REVISION )
              INTO LNINGREDIENTREVISION
              FROM ITING_H
             WHERE INGREDIENT = ANINGREDIENTID
               AND MAX_REV = 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               LNINGREDIENTREVISION := 100;
         END;
      ELSE
         LNINGREDIENTREVISION := 0;
      END IF;

      IF     ANSYNONYMID IS NOT NULL
         AND ANSYNONYMID <> 0
      THEN
         
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM ITINGD
          WHERE CID = ANSYNONYMID
            AND PID = 4
            AND INGREDIENT = ANINGREDIENTID;

         IF LNCOUNT = 0
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_SYNONYMNOTEXIST,
                                                  ANSYNONYMID );
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         BEGIN
            SELECT MAX( REVISION )
              INTO LNSYNONYMREVISION
              FROM ITINGCFG_H
             WHERE CID = ANSYNONYMID
               AND PID = 4
               AND MAX_REV = 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               LNSYNONYMREVISION := 100;
         END;
      END IF;

      IF    ANRECONSTITUTIONFACTOR = 0
         OR ANRECONSTITUTIONFACTOR IS NULL
      THEN
         SELECT RECFAC
           INTO LNRECONSTITUTIONFACTOR
           FROM ITING
          WHERE INGREDIENT = ANINGREDIENTID;
      ELSE
         LNRECONSTITUTIONFACTOR := ANRECONSTITUTIONFACTOR;
      END IF;

      
      
      
      
      
      IF ASCHEMICALS = 'Y'
      THEN
         BEGIN
            UPDATE SPECIFICATION_SECTION
               SET DISPLAY_FORMAT = 2
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND SECTION_ID = ANSECTIONID
               AND SUB_SECTION_ID = ANSUBSECTIONID
               AND TYPE = IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    IAPIGENERAL.GETLASTERRORTEXT( ) );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      END IF;

      IF    ANHIERARCHICALLEVEL IS NULL
         OR ANHIERARCHICALLEVEL = 0
      THEN
         LNHIERARCHICALLEVEL := 1;
      ELSE
         LNHIERARCHICALLEVEL := ANHIERARCHICALLEVEL;
      END IF;

      
      SELECT   MAX( SEQ_NO )
             + 10
        INTO LNNEXTSEQUENCE
        FROM SPECIFICATION_ING
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND SECTION_ID = ANSECTIONID
         AND SUB_SECTION_ID = ANSUBSECTIONID;

      IF LNNEXTSEQUENCE IS NULL
      THEN
         LNNEXTSEQUENCE := 10;
      END IF;

      
      SELECT COUNT( * )
        INTO LNDUPLICATE
        FROM SPECIFICATION_ING
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND SECTION_ID = ANSECTIONID
         AND SUB_SECTION_ID = ANSUBSECTIONID
         AND INGREDIENT = ANINGREDIENTID
         AND NVL( PID,
                  0 ) = NVL( ANPARENTID,
                             0 )
         AND NVL( HIER_LEVEL,
                  1 ) = NVL( LNHIERARCHICALLEVEL,
                             1 );

      IF NVL( LNDUPLICATE,
              0 ) > 0
      THEN
         BEGIN
            UPDATE SPECIFICATION_ING
               SET QUANTITY = ANQUANTITY,
                   RECFAC = LNRECONSTITUTIONFACTOR,
                   ING_LEVEL = ASLEVEL,
                   ING_COMMENT = ASCOMMENT,
                   ING_SYNONYM = DECODE( ANSYNONYMID,
                                         0, NULL,
                                         ANSYNONYMID ),
                   ING_SYNONYM_REV = DECODE( ANSYNONYMID,
                                             0, NULL,
                                             LNSYNONYMREVISION )
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND SECTION_ID = ANSECTIONID
               AND SUB_SECTION_ID = ANSUBSECTIONID
               AND INGREDIENT = ANINGREDIENTID;

         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      ELSE
         BEGIN
            INSERT INTO SPECIFICATION_ING
                        ( PART_NO,
                          REVISION,
                          SECTION_ID,
                          SUB_SECTION_ID,
                          INGREDIENT,
                          INGREDIENT_REV,
                          ING_SYNONYM,
                          ING_SYNONYM_REV,
                          QUANTITY,
                          RECFAC,
                          ING_LEVEL,
                          ING_COMMENT,
                          ACTIV_IND,
                          PID,
                          HIER_LEVEL,
                          SEQ_NO )
                 VALUES ( ASPARTNO,
                          ANREVISION,
                          ANSECTIONID,
                          ANSUBSECTIONID,
                          ANINGREDIENTID,
                          LNINGREDIENTREVISION,
                          DECODE( ANSYNONYMID,
                                  0, NULL,
                                  ANSYNONYMID ),
                          DECODE( ANSYNONYMID,
                                  0, NULL,
                                  LNSYNONYMREVISION ),
                          ANQUANTITY,
                          LNRECONSTITUTIONFACTOR,
                          ASLEVEL,
                          ASCOMMENT,
                          ASACTIVIND,
                          ANPARENTID,
                          LNHIERARCHICALLEVEL,
                          LNNEXTSEQUENCE );
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
               BEGIN
                  UPDATE SPECIFICATION_ING
                     SET QUANTITY = ANQUANTITY,
                         RECFAC = LNRECONSTITUTIONFACTOR,
                         ING_LEVEL = ASLEVEL,
                         ING_COMMENT = ASCOMMENT,
                         ACTIV_IND = ASACTIVIND,
                         PID = ANPARENTID,
                         HIER_LEVEL = LNHIERARCHICALLEVEL,
                         ING_SYNONYM = DECODE( ANSYNONYMID,
                                               0, NULL,
                                               ANSYNONYMID ),
                         ING_SYNONYM_REV = DECODE( ANSYNONYMID,
                                                   0, NULL,
                                                   LNSYNONYMREVISION )
                   WHERE PART_NO = ASPARTNO
                     AND REVISION = ANREVISION
                     AND SECTION_ID = ANSECTIONID
                     AND SUB_SECTION_ID = ANSUBSECTIONID
                     AND INGREDIENT = ANINGREDIENTID;
               EXCEPTION
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
         END;
      END IF;

      
      
                      SELECT COUNT( * )
                       INTO LNDUPLICATE
                       FROM SPECIFICATION_ING
                       WHERE PART_NO = ASPARTNO
                         AND REVISION = ANREVISION
                         AND SECTION_ID = ANSECTIONID
                         AND SUB_SECTION_ID = ANSUBSECTIONID
                         AND INGREDIENT = ANINGREDIENTID
                         AND NVL( PID,0 ) = NVL( ANPARENTID,0 )
                         AND NVL( HIER_LEVEL,1 ) = NVL( LNHIERARCHICALLEVEL,1)
                         AND SEQ_NO = (SELECT   MAX( SEQ_NO )
                                                    FROM SPECIFICATION_ING
                                                        WHERE PART_NO = ASPARTNO
                                                         AND REVISION = ANREVISION
                                                         AND SECTION_ID = ANSECTIONID
                                                         AND SUB_SECTION_ID = ANSUBSECTIONID);
                      IF NVL( LNDUPLICATE,
                              0 ) > 0
                      THEN
                         BEGIN
                            UPDATE SPECIFICATION_ING
                               SET QUANTITY = ANQUANTITY,
                                   RECFAC = LNRECONSTITUTIONFACTOR,
                                   ING_LEVEL = ASLEVEL,
                                   ING_COMMENT = ASCOMMENT,
                                   ING_SYNONYM = DECODE( ANSYNONYMID,
                                                         0, NULL,
                                                         ANSYNONYMID ),
                                   ING_SYNONYM_REV = DECODE( ANSYNONYMID,
                                                             0, NULL,
                                                             LNSYNONYMREVISION )
                             WHERE PART_NO = ASPARTNO
                               AND REVISION = ANREVISION
                               AND SECTION_ID = ANSECTIONID
                               AND SUB_SECTION_ID = ANSUBSECTIONID
                               AND INGREDIENT = ANINGREDIENTID;

                         EXCEPTION
                            WHEN OTHERS
                            THEN
                               IAPIGENERAL.LOGERROR( GSSOURCE,
                                                     LSMETHOD,
                                                     SQLERRM );
                               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
                         END;
                      ELSE                                                
                         BEGIN
                            INSERT INTO SPECIFICATION_ING
                                        ( PART_NO,
                                          REVISION,
                                          SECTION_ID,
                                          SUB_SECTION_ID,
                                          INGREDIENT,
                                          INGREDIENT_REV,
                                          ING_SYNONYM,
                                          ING_SYNONYM_REV,
                                          QUANTITY,
                                          RECFAC,
                                          ING_LEVEL,
                                          ING_COMMENT,
                                          ACTIV_IND,
                                          PID,
                                          HIER_LEVEL,
                                          SEQ_NO )
                                 VALUES ( ASPARTNO,
                                          ANREVISION,
                                          ANSECTIONID,
                                          ANSUBSECTIONID,
                                          ANINGREDIENTID,
                                          LNINGREDIENTREVISION,
                                          DECODE( ANSYNONYMID,
                                                  0, NULL,
                                                  ANSYNONYMID ),
                                          DECODE( ANSYNONYMID,
                                                  0, NULL,
                                                  LNSYNONYMREVISION ),
                                          ANQUANTITY,
                                          LNRECONSTITUTIONFACTOR,
                                          ASLEVEL,
                                          ASCOMMENT,
                                          ASACTIVIND,
                                          ANPARENTID,
                                          LNHIERARCHICALLEVEL,
                                          LNNEXTSEQUENCE );
                         EXCEPTION
                            WHEN DUP_VAL_ON_INDEX
                            THEN
                               BEGIN
                                  UPDATE SPECIFICATION_ING
                                     SET QUANTITY = ANQUANTITY,
                                         RECFAC = LNRECONSTITUTIONFACTOR,
                                         ING_LEVEL = ASLEVEL,
                                         ING_COMMENT = ASCOMMENT,
                                         ACTIV_IND = ASACTIVIND,
                                         PID = ANPARENTID,
                                         HIER_LEVEL = LNHIERARCHICALLEVEL,
                                         ING_SYNONYM = DECODE( ANSYNONYMID,
                                                               0, NULL,
                                                               ANSYNONYMID ),
                                         ING_SYNONYM_REV = DECODE( ANSYNONYMID,
                                                                   0, NULL,
                                                                   LNSYNONYMREVISION )
                                   WHERE PART_NO = ASPARTNO
                                     AND REVISION = ANREVISION
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND INGREDIENT = ANINGREDIENTID;
                               EXCEPTION
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
   END ADDINGREDIENT;

   
   FUNCTION ADDATTACHEDSPEC(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ASATTACHEDPARTNO           IN       IAPITYPE.PARTNO_TYPE,
      ANATTACHEDREVISION         IN       IAPITYPE.REVISION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSFRAMENO                     IAPITYPE.FRAMENO_TYPE;
      LNFRAMEREVISION               IAPITYPE.FRAMEREVISION_TYPE;
      LNFRAMEOWNER                  IAPITYPE.OWNER_TYPE;
      LNREFID                       IAPITYPE.ID_TYPE;
      LNATTACHEDREVISION            IAPITYPE.REVISION_TYPE;
      LSUPDATEALLOWED               IAPITYPE.STRING_TYPE;
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddAttachedSpec';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( 'upd_in_dev',
                                                       'data_migration',
                                                       LSUPDATEALLOWED );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         LSUPDATEALLOWED := '1';
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.EXISTID( ASPARTNO,
                                             ANREVISION );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      
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

      IF     LSSTATUSTYPE <> IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         AND NVL( LSUPDATEALLOWED,
                  '0' ) = '0'
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SPECIFICATIONNOTINDEV,
                                                     ASPARTNO,
                                                     ANREVISION ) );
      END IF;

      
      IF ANATTACHEDREVISION IS NULL
      THEN
         LNATTACHEDREVISION := 0;
      ELSE
         LNATTACHEDREVISION := ANATTACHEDREVISION;
      END IF;

      
      LNRETVAL := IAPIPART.EXISTID( ASATTACHEDPARTNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM SPECIFICATION_HEADER
       WHERE PART_NO = ASATTACHEDPARTNO
         AND (    REVISION = LNATTACHEDREVISION
               OR LNATTACHEDREVISION = 0 );

      IF LNCOUNT = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_ATTACHEDPARTNODATA,
                                                     ASATTACHEDPARTNO,
                                                     ASPARTNO,
                                                     ANREVISION ) );
      END IF;

      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM SPECIFICATION_SECTION
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND SECTION_ID = ANSECTIONID
         AND SUB_SECTION_ID = ANSUBSECTIONID
         AND TYPE = IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC;

      IF LNCOUNT = 0
      THEN
         
         
         SELECT FRAME_ID,
                FRAME_REV,
                FRAME_OWNER
           INTO LSFRAMENO,
                LNFRAMEREVISION,
                LNFRAMEOWNER
           FROM SPECIFICATION_HEADER
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION;

         
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM FRAME_SECTION
          WHERE FRAME_NO = LSFRAMENO
            AND REVISION = LNFRAMEREVISION
            AND OWNER = LNFRAMEOWNER
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND TYPE = IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC;

         IF LNCOUNT = 0
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_FRAMESECTIONNOTFOUND,
                                                        LSFRAMENO,
                                                        LNFRAMEREVISION,
                                                        LNFRAMEOWNER,
                                                        
                                                        
                                                        
                                                        F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSECTIONID, 0),
                                                        F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSUBSECTIONID, 0) ));
                                                        
         END IF;

         BEGIN
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
                          SECTION_SEQUENCE_NO,
                          DISPLAY_FORMAT,
                          SECTION_REV,
                          SUB_SECTION_REV,
                          DISPLAY_FORMAT_REV,
                          REF_OWNER,
                          INTL,
                          MANDATORY )
               SELECT ASPARTNO,
                      ANREVISION,
                      ANSECTIONID,
                      ANSUBSECTIONID,
                      IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC,
                      REF_ID,
                      REF_VER,
                      REF_INFO,
                      SEQUENCE_NO,
                      HEADER,
                      SECTION_SEQUENCE_NO,
                      DISPLAY_FORMAT,
                      SECTION_REV,
                      SUB_SECTION_REV,
                      DISPLAY_FORMAT_REV,
                      REF_OWNER,
                      INTL,
                      MANDATORY
                 FROM FRAME_SECTION
                WHERE FRAME_NO = LSFRAMENO
                  AND REVISION = LNFRAMEREVISION
                  AND OWNER = LNFRAMEOWNER
                  AND SECTION_ID = ANSECTIONID
                  AND SUB_SECTION_ID = ANSUBSECTIONID
                  AND TYPE = IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      END IF;

      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM ATTACHED_SPECIFICATION
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND SECTION_ID = ANSECTIONID
         AND SUB_SECTION_ID = ANSUBSECTIONID
         AND ATTACHED_PART_NO = ASATTACHEDPARTNO;

      IF LNCOUNT > 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_ATTACHEDPARTTOOMANY,
                                                     ASATTACHEDPARTNO,
                                                     ASPARTNO,
                                                     ANREVISION ) );
      END IF;

      
      
      BEGIN
         SELECT REF_ID
           INTO LNREFID
           FROM SPECIFICATION_SECTION
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND TYPE = IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC;
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      
      BEGIN
         INSERT INTO ATTACHED_SPECIFICATION
                     ( PART_NO,
                       REVISION,
                       REF_ID,
                       ATTACHED_PART_NO,
                       ATTACHED_REVISION,
                       SECTION_ID,
                       SUB_SECTION_ID,
                       INTL )
              VALUES ( ASPARTNO,
                       ANREVISION,
                       NVL( LNREFID,
                            0 ),
                       ASATTACHEDPARTNO,
                       LNATTACHEDREVISION,
                       ANSECTIONID,
                       ANSUBSECTIONID,
                       0 );
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDATTACHEDSPEC;

   
   FUNCTION ADDBOMHEADER(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANBOMUSAGE                 IN       IAPITYPE.BOMUSAGE_TYPE,
      ANQUANTITY                 IN       IAPITYPE.BOMQUANTITY_TYPE,
      ASCALCFLAG                 IN       IAPITYPE.BOMHEADERCALCFLAG_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSFRAMENO                     IAPITYPE.FRAMENO_TYPE;
      LNFRAMEREVISION               IAPITYPE.FRAMEREVISION_TYPE;
      LNFRAMEOWNER                  IAPITYPE.OWNER_TYPE;
      LSUPDATEALLOWED               IAPITYPE.STRING_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
      LDPLANNEDEFFECTIVEDATE        IAPITYPE.DATE_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddBomHeader';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNPREFERRED                   IAPITYPE.BOOLEAN_TYPE := 0;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( 'upd_in_dev',
                                                       'data_migration',
                                                       LSUPDATEALLOWED );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         LSUPDATEALLOWED := '1';
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.EXISTID( ASPARTNO,
                                             ANREVISION );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN LNRETVAL;
      END IF;

      
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

      IF     LSSTATUSTYPE <> IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         AND NVL( LSUPDATEALLOWED,
                  '0' ) = '0'
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SPECIFICATIONNOTINDEV,
                                                     ASPARTNO,
                                                     ANREVISION ) );
      END IF;

      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM PART_PLANT
       WHERE PART_NO = ASPARTNO
         AND PLANT = ASPLANT;

      IF LNCOUNT = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_PLANTNOTASSIGNEDTOPART,
                                                     ASPLANT,
                                                     ASPARTNO ) );
      END IF;

      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM ITBU
       WHERE BOM_USAGE = ANBOMUSAGE;

      IF LNCOUNT = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_BOMUSAGENOTFOUND,
                                                     ANBOMUSAGE ) );
      END IF;

      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM BOM_HEADER
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANT
         AND ALTERNATIVE = ANALTERNATIVE
         AND BOM_USAGE = ANBOMUSAGE;

      IF LNCOUNT > 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_BOMHEADERALREADYEXIST,
                                                     ASPARTNO,
                                                     ANREVISION,
                                                     ASPLANT,
                                                     ANALTERNATIVE ) );
      END IF;

      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM SPECIFICATION_SECTION
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND TYPE = IAPICONSTANT.SECTIONTYPE_BOM;

      IF LNCOUNT = 0
      THEN
         
         SELECT FRAME_ID,
                FRAME_REV,
                FRAME_OWNER
           INTO LSFRAMENO,
                LNFRAMEREVISION,
                LNFRAMEOWNER
           FROM SPECIFICATION_HEADER
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION;

         
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM FRAME_SECTION
          WHERE FRAME_NO = LSFRAMENO
            AND REVISION = LNFRAMEREVISION
            AND OWNER = LNFRAMEOWNER
            AND TYPE = IAPICONSTANT.SECTIONTYPE_BOM;

         IF LNCOUNT = 0
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_NOBOMINFRAME,
                                                        LSFRAMENO ) );
         END IF;

         
         BEGIN
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
                          SECTION_SEQUENCE_NO,
                          DISPLAY_FORMAT,
                          SECTION_REV,
                          SUB_SECTION_REV,
                          DISPLAY_FORMAT_REV,
                          REF_OWNER,
                          INTL )
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
                      SECTION_SEQUENCE_NO,
                      DISPLAY_FORMAT,
                      SECTION_REV,
                      SUB_SECTION_REV,
                      DISPLAY_FORMAT_REV,
                      REF_OWNER,
                      INTL
                 FROM FRAME_SECTION
                WHERE FRAME_NO = LSFRAMENO
                  AND REVISION = LNFRAMEREVISION
                  AND OWNER = LNFRAMEOWNER
                  AND TYPE = IAPICONSTANT.SECTIONTYPE_BOM;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      END IF;

      
      BEGIN
         SELECT PLANNED_EFFECTIVE_DATE
           INTO LDPLANNEDEFFECTIVEDATE
           FROM SPECIFICATION_HEADER
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      BEGIN
         
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM BOM_HEADER
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PLANT = ASPLANT
            AND BOM_USAGE = ANBOMUSAGE
            AND PREFERRED = 1;

         IF LNCOUNT = 0
         THEN
            LNPREFERRED := 1;
         ELSE
            LNPREFERRED := 0;
         END IF;

         INSERT INTO BOM_HEADER
                     ( PART_NO,
                       REVISION,
                       BOM_USAGE,
                       PLANT,
                       ALTERNATIVE,
                       BASE_QUANTITY,
                       CALC_FLAG,
                       PLANT_EFFECTIVE_DATE,
                       DESCRIPTION,
                       PREFERRED )
              VALUES ( ASPARTNO,
                       ANREVISION,
                       ANBOMUSAGE,
                       ASPLANT,
                       ANALTERNATIVE,
                       ANQUANTITY,
                       ASCALCFLAG,
                       LDPLANNEDEFFECTIVEDATE,
                       ASDESCRIPTION,
                       LNPREFERRED );
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDBOMHEADER;

   
   FUNCTION ADDBOMITEM(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANBOMUSAGE                 IN       IAPITYPE.BOMUSAGE_TYPE,
      ANITEMNUMBER               IN       IAPITYPE.BOMITEMNUMBER_TYPE,
      ASCOMPONENT                IN       IAPITYPE.PARTNO_TYPE,
      ANCOMPONENTREVISION        IN       IAPITYPE.REVISION_TYPE,
      ASCOMPONENTPLANT           IN       IAPITYPE.PLANT_TYPE,
      ANQUANTITY                 IN       IAPITYPE.QUANTITY_TYPE,
      ASITEMCATEGORY             IN       IAPITYPE.BOMITEMCATEGORY_TYPE,
      ANCOMPONENTSCRAP           IN       IAPITYPE.SCRAP_TYPE,
      ASUOM                      IN       IAPITYPE.DESCRIPTION_TYPE,
      ASCALCULATIONMODE          IN       IAPITYPE.BOMITEMCALCFLAG_TYPE,
      ANCONVERSIONFACTOR         IN       IAPITYPE.BOMCONVFACTOR_TYPE,
      ASTOUNIT                   IN       IAPITYPE.DESCRIPTION_TYPE,
      ANYIELD                    IN       IAPITYPE.BOMYIELD_TYPE,
      ANLEADTIMEOFFSET           IN       IAPITYPE.BOMLEADTIMEOFFSET_TYPE,
      ASCOST                     IN       IAPITYPE.STRING_TYPE,
      ASBULK                     IN       IAPITYPE.STRING_TYPE,
      ASISSUELOCATION            IN       IAPITYPE.BOMISSUELOCATION_TYPE,
      ASBOMITEMTYPE              IN       IAPITYPE.BOMITEMTYPE_TYPE,
      ANOPERATIONALSTEP          IN       IAPITYPE.BOMOPERATIONALSTEP_TYPE,
      ANMINIMUMQUANTITY          IN       IAPITYPE.BOMQUANTITY_TYPE,
      ANMAXIMUMQUANTITY          IN       IAPITYPE.BOMQUANTITY_TYPE,
      ASFIXEDQUANTITY            IN       IAPITYPE.STRING_TYPE,
      ASCODE                     IN       IAPITYPE.BOMITEMCODE_TYPE,
      ASALTERNATIVEGROUP         IN       IAPITYPE.BOMITEMALTGROUP_TYPE,
      ANALTERNATIVEPRIORITY      IN       IAPITYPE.BOMITEMALTPRIORITY_TYPE,
      ANHEADER                   IN       IAPITYPE.ID_TYPE,
      ASVALUE                    IN       IAPITYPE.STRING_TYPE,
      ANMAKEUP                   IN       IAPITYPE.BOOLEAN_TYPE,
      ASINTERNATIONALEQUIVALENT  IN       IAPITYPE.PARTNO_TYPE,
      ASACTION                   IN       IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      CURSOR LQDISPLAYFORMAT
      IS
         SELECT LAYOUT_ID,
                LAYOUT_REV
           FROM ITBOMLYSOURCE
          WHERE LAYOUT_TYPE = 2
            AND PREFERRED = 1
            AND SOURCE = ( SELECT PART_SOURCE
                            FROM PART
                           WHERE PART_NO = ASPARTNO );

      LNSEQUENCE                    IAPITYPE.BOMITEMNUMBER_TYPE;
      LSUOM                         IAPITYPE.DESCRIPTION_TYPE;
      LSRELEVANCYTOCOSTING          IAPITYPE.STRING_TYPE;
      LSBULKMATERIAL                IAPITYPE.STRING_TYPE;
      LSITEMCATEGORY                IAPITYPE.BOMITEMCATEGORY_TYPE;
      LNCOMPONENTREVISION           IAPITYPE.REVISION_TYPE;
      LNCOMPONENTSCRAP              IAPITYPE.SCRAP_TYPE;
      LNYIELD                       IAPITYPE.BOMYIELD_TYPE;
      LSFIXEDQUANTITY               IAPITYPE.STRING_TYPE;
      LSREMOVEITEM                  IAPITYPE.STRING_TYPE;
      LSUPDATEALLOWED               IAPITYPE.STRING_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
      LSBASEUOM                     IAPITYPE.DESCRIPTION_TYPE;
      LSTOUNIT                      IAPITYPE.DESCRIPTION_TYPE;
      LSCALCFLAG                    IAPITYPE.BOMHEADERCALCFLAG_TYPE;
      LNDISPLAYFORMATID             IAPITYPE.ID_TYPE;
      LNDISPLAYFORMATREVISION       IAPITYPE.REVISION_TYPE;
      LNFIELD                       IAPITYPE.NUMVAL_TYPE;
      LNNUMERIC1                    IAPITYPE.BOMITEMNUMERIC_TYPE;
      LNNUMERIC2                    IAPITYPE.BOMITEMNUMERIC_TYPE;
      LNNUMERIC3                    IAPITYPE.BOMITEMNUMERIC_TYPE;
      LNNUMERIC4                    IAPITYPE.BOMITEMNUMERIC_TYPE;
      LNNUMERIC5                    IAPITYPE.BOMITEMNUMERIC_TYPE;
      LSTEXT1                       IAPITYPE.BOMITEMLONGCHARACTER_TYPE;
      LSTEXT2                       IAPITYPE.BOMITEMLONGCHARACTER_TYPE;
      LSTEXT3                       IAPITYPE.BOMITEMCHARACTER_TYPE;
      LSTEXT4                       IAPITYPE.BOMITEMCHARACTER_TYPE;
      LSTEXT5                       IAPITYPE.BOMITEMCHARACTER_TYPE;
      LDDATE1                       IAPITYPE.DATE_TYPE;
      LDDATE2                       IAPITYPE.DATE_TYPE;
      LNCHARACTERISTIC1             IAPITYPE.ID_TYPE;
      LNCHARACTERISTICREVISION1     IAPITYPE.REVISION_TYPE;
      LNCHARACTERISTIC2             IAPITYPE.ID_TYPE;
      LNCHARACTERISTICREVISION2     IAPITYPE.REVISION_TYPE;
      LNCHARACTERISTIC3             IAPITYPE.ID_TYPE;
      LNCHARACTERISTICREVISION3     IAPITYPE.REVISION_TYPE;
      LNBOOLEAN1                    IAPITYPE.BOOLEAN_TYPE := 0;
      LNBOOLEAN2                    IAPITYPE.BOOLEAN_TYPE := 0;
      LNBOOLEAN3                    IAPITYPE.BOOLEAN_TYPE := 0;
      LNBOOLEAN4                    IAPITYPE.BOOLEAN_TYPE := 0;
      LNFIXEDQUANTITY               IAPITYPE.BOOLEAN_TYPE;
      LNBULKMATERIAL                IAPITYPE.BOOLEAN_TYPE;
      LNRELEVANCYTOCOSTING          IAPITYPE.BOOLEAN_TYPE;
      LSFIELD                       VARCHAR2( 200 );
      LSVALUE                       VARCHAR2( 500 );
      LSSQL                         VARCHAR2( 2000 );
      LSFIELDREVISION               VARCHAR2( 100 );
      LDDATE                        IAPITYPE.DATE_TYPE;
      LNCHARACTERISTIC              IAPITYPE.ID_TYPE;
      LNCHARACTERISTICREVISION      IAPITYPE.REVISION_TYPE;
      LNASSOCIATION                 IAPITYPE.ID_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddBomItem';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( 'upd_in_dev',
                                                       'data_migration',
                                                       LSUPDATEALLOWED );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         LSUPDATEALLOWED := '1';
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.EXISTID( ASPARTNO,
                                             ANREVISION );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
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

      IF     LSSTATUSTYPE <> IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         AND NVL( LSUPDATEALLOWED,
                  '0' ) = '0'
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SPECIFICATIONNOTINDEV,
                                                     ASPARTNO,
                                                     ANREVISION ) );
      END IF;

      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM BOM_HEADER
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANT
         AND ALTERNATIVE = ANALTERNATIVE;

      IF LNCOUNT = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_BOMHEADERNOTEXIST,
                                                     ASPARTNO,
                                                     ANREVISION,
                                                     ASPLANT,
                                                     ANALTERNATIVE ) );
      END IF;

      IF NVL( ASACTION,
              '@' ) <> 'U'
      THEN
         
         IF    ANCOMPONENTREVISION = 0
            OR ANCOMPONENTREVISION IS NULL
         THEN
            LNCOMPONENTREVISION := NULL;
            
            LNRETVAL := IAPIPART.EXISTID( ASCOMPONENT );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    IAPIGENERAL.GETLASTERRORTEXT( ) );
               RETURN( LNRETVAL );
            END IF;
         ELSE
            LNCOMPONENTREVISION := ANCOMPONENTREVISION;
            
            LNRETVAL := IAPISPECIFICATION.EXISTID( ASCOMPONENT,
                                                   ANCOMPONENTREVISION );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    IAPIGENERAL.GETLASTERRORTEXT( ) );
               RETURN( LNRETVAL );
            END IF;
         END IF;

         
         IF ASCOMPONENT <> 'DEV'
         THEN
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM PART_PLANT
             WHERE PART_NO = ASCOMPONENT
               AND PLANT = ASCOMPONENTPLANT;

            IF LNCOUNT = 0
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PLANTNOTASSIGNEDTOPART,
                                                           ASCOMPONENTPLANT,
                                                           ASCOMPONENT ) );
            END IF;
         END IF;

         
         IF    ANITEMNUMBER = 0
            OR ANITEMNUMBER IS NULL
         THEN
            SELECT MAX( ITEM_NUMBER )
              INTO LNSEQUENCE
              FROM BOM_ITEM
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND PLANT = ASPLANT
               AND ALTERNATIVE = ANALTERNATIVE;

            IF LNSEQUENCE IS NULL
            THEN
               LNSEQUENCE := 0;
            END IF;

            LNSEQUENCE :=   LNSEQUENCE
                          + 10;
         ELSE
            LNSEQUENCE := ANITEMNUMBER;
         END IF;

         
         IF ASUOM IS NULL
         THEN
            SELECT BASE_UOM
              INTO LSUOM
              FROM PART
             WHERE PART_NO = ASCOMPONENT;
         ELSE
            LSUOM := ASUOM;
         END IF;

         
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM ( SELECT BASE_UOM
                   FROM PART
                  WHERE BASE_UOM = LSUOM
                    AND PART_NO = ASCOMPONENT
                 UNION
                 SELECT ISSUE_UOM
                   FROM PART_PLANT
                  WHERE ISSUE_UOM = LSUOM
                    AND PART_NO = ASCOMPONENT
                    AND PLANT = ASCOMPONENTPLANT );

         IF LNCOUNT = 0
         THEN
            
            SELECT BASE_UOM
            INTO LSBASEUOM
            FROM PART
            WHERE PART_NO = ASCOMPONENT;

            IF (IAPIUOMGROUPS.ISUOMSSAMEGROUP( LSUOM,
                                               LSBASEUOM ) = 0 )
            THEN
            
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_INVALIDUOMCOMPONENT,
                                                        LSUOM,
                                                        ASCOMPONENT ) );
            
            END IF;
            
         END IF;

         IF UPPER( ASCALCULATIONMODE ) <> 'N'
         THEN
            
            
            SELECT BASE_UOM,
                   TO_UNIT,
                   CALC_FLAG
              INTO LSBASEUOM,
                   LSTOUNIT,
                   LSCALCFLAG
              FROM BOM_HEADER,
                   PART
             WHERE PART.PART_NO = ASPARTNO
               AND BOM_HEADER.PART_NO = PART.PART_NO
               AND REVISION = ANREVISION
               AND PLANT = ASPLANT
               AND ALTERNATIVE = ANALTERNATIVE;

            IF LSCALCFLAG = 'N'
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           
                                                           
                                                           
                                                           
                                                           
                                                           IAPICONSTANTDBERROR.DBERR_INVALIDCALCMODE,
                                                           ASCOMPONENT,
                                                           ASCALCULATIONMODE ));
                                                           
            END IF;


            
            











            
            IF    (      ( UPPER( ASCALCULATIONMODE ) = 'Q' )
            
                    AND (     (     ASTOUNIT IS NOT NULL                               
                                AND LSBASEUOM <> ASTOUNIT )
                          AND ( LSBASEUOM <> LSUOM ) ))                                              
               OR (      ( UPPER( ASCALCULATIONMODE ) = 'C' )
              
                    AND ( (    ASTOUNIT IS NOT NULL
                                  AND LSTOUNIT IS NOT NULL
                                  AND LSTOUNIT <> ASTOUNIT )
                          AND ( LSTOUNIT IS NOT NULL
                                 AND LSTOUNIT <> LSUOM )))                                                        
               OR (      ( UPPER( ASCALCULATIONMODE ) = 'B' )  
                
               
                    AND (     (     ASTOUNIT IS NOT NULL
                                    AND LSTOUNIT IS NOT NULL
                                    AND LSTOUNIT <> ASTOUNIT )
                          AND  (     LSBASEUOM <> LSUOM )
                          AND (   ASTOUNIT IS NOT NULL
                                    AND LSBASEUOM <> ASTOUNIT)
                          AND (   LSTOUNIT IS NOT NULL
                                  AND LSUOM <> LSTOUNIT) ))
            
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           
                                                           
                                                           
                                                           
                                                           
                                                           IAPICONSTANTDBERROR.DBERR_INVALIDCALCMODE,
                                                           ASCOMPONENT,
                                                           ASCALCULATIONMODE ));
                                                           
            END IF;
         END IF;

         LSRELEVANCYTOCOSTING := ASCOST;
         LSBULKMATERIAL := ASBULK;
         LSITEMCATEGORY := ASITEMCATEGORY;

         IF ASCOMPONENTPLANT <> 'DEV'
         THEN
            IF LSRELEVANCYTOCOSTING IS NULL
            THEN
               BEGIN
                  SELECT NVL( RELEVENCY_TO_COSTING,
                              'N' )
                    INTO LSRELEVANCYTOCOSTING
                    FROM PART_PLANT
                   WHERE PART_NO = ASCOMPONENT
                     AND PLANT = ASCOMPONENTPLANT;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                 LSMETHOD,
                                                                 IAPICONSTANTDBERROR.DBERR_PLANTNOTASSIGNEDTOPART,
                                                                 ASCOMPONENTPLANT,
                                                                 ASCOMPONENT ) );
               END;
            END IF;

            IF LSBULKMATERIAL IS NULL
            THEN
               BEGIN
                  SELECT NVL( BULK_MATERIAL,
                              'N' )
                    INTO LSBULKMATERIAL
                    FROM PART_PLANT
                   WHERE PART_NO = ASCOMPONENT
                     AND PLANT = ASCOMPONENTPLANT;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                 LSMETHOD,
                                                                 IAPICONSTANTDBERROR.DBERR_PLANTNOTASSIGNEDTOPART,
                                                                 ASCOMPONENTPLANT,
                                                                 ASCOMPONENT ) );
               END;
            END IF;

            IF LSITEMCATEGORY IS NULL
            THEN
               BEGIN
                  SELECT ITEM_CATEGORY
                    INTO LSITEMCATEGORY
                    FROM PART_PLANT
                   WHERE PART_NO = ASCOMPONENT
                     AND PLANT = ASCOMPONENTPLANT;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                 LSMETHOD,
                                                                 IAPICONSTANTDBERROR.DBERR_PLANTNOTASSIGNEDTOPART,
                                                                 ASCOMPONENTPLANT,
                                                                 ASCOMPONENT ) );
               END;
            END IF;
         ELSE
            LSRELEVANCYTOCOSTING := 'N';
            LSBULKMATERIAL := 'N';
            LSITEMCATEGORY := 'L';
         END IF;

         IF ASITEMCATEGORY IS NOT NULL
         THEN
            LSITEMCATEGORY := ASITEMCATEGORY;
         END IF;

         IF ANCOMPONENTSCRAP IS NULL
         THEN
            LNCOMPONENTSCRAP := 0;
         ELSE
            LNCOMPONENTSCRAP := ANCOMPONENTSCRAP;
         END IF;

         IF ASFIXEDQUANTITY IS NULL
         THEN
            LSFIXEDQUANTITY := 'N';
         ELSE
            LSFIXEDQUANTITY := ASFIXEDQUANTITY;

            IF LSFIXEDQUANTITY NOT IN( 'Y', 'N' )
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_INVALIDFIXEDQUANTITY,
                                                           LSFIXEDQUANTITY ) );
            END IF;
         END IF;

         IF ASFIXEDQUANTITY = 'Y'
         THEN
            LNFIXEDQUANTITY := 1;
         ELSE
            LNFIXEDQUANTITY := 0;
         END IF;

         
         
         BEGIN
            SELECT PARAMETER_DATA
              INTO LSREMOVEITEM
              FROM INTERSPC_CFG
             WHERE PARAMETER = 'remove_item'
               AND SECTION = 'data_migration';
         EXCEPTION
            WHEN OTHERS
            THEN
               LSREMOVEITEM := 0;
         END;
      END IF;

      
      OPEN LQDISPLAYFORMAT;

      FETCH LQDISPLAYFORMAT
       INTO LNDISPLAYFORMATID,
            LNDISPLAYFORMATREVISION;

      IF LQDISPLAYFORMAT%NOTFOUND
      THEN
         CLOSE LQDISPLAYFORMAT;

         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_NODISPLAYFRMTFOUNDPART,
                                                     ASPARTNO ) );
      ELSE
         CLOSE LQDISPLAYFORMAT;
      END IF;

      IF ANHEADER IS NOT NULL
      THEN
         BEGIN
            SELECT FIELD_ID,
                   ASSOCIATION
              INTO LNFIELD,
                   LNASSOCIATION
              FROM ITBOMLYITEM
             WHERE LAYOUT_ID = LNDISPLAYFORMATID
               AND REVISION = LNDISPLAYFORMATREVISION
               AND HEADER_ID = ANHEADER;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( IAPICONSTANTDBERROR.DBERR_NOBOMITEMDISPLAYFORMAT,
                                                           LNDISPLAYFORMATID,
                                                           LNDISPLAYFORMATREVISION,
                                                           ANHEADER ) );
            WHEN TOO_MANY_ROWS
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_MANYBOMITEMDISPLAYFORMAT,
                                                           LNDISPLAYFORMATID,
                                                           LNDISPLAYFORMATREVISION,
                                                           ANHEADER ) );
         END;
      END IF;

      IF LNFIELD IN( 30, 31, 32, 33, 34, 50, 51, 52, 53 )
      THEN
         LNRETVAL := IAPIGENERAL.ISNUMERIC( ASVALUE );

         IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    IAPIGENERAL.GETLASTERRORTEXT( )
                                 || ' PartNo -> '
                                 || ASPARTNO );
            RETURN( LNRETVAL );
         END IF;
      ELSIF LNFIELD IN( 25, 26, 40, 41, 42, 70, 71, 72 )
      THEN
         IF ASVALUE IS NOT NULL
         THEN
            IF LNFIELD IN( 25, 26 )
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( ASVALUE,
                                                      255 );
            ELSE
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( ASVALUE,
                                                      40 );
            END IF;

            IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                       IAPIGENERAL.GETLASTERRORTEXT( )
                                    || ' PartNo -> '
                                    || ASPARTNO );
               RETURN( LNRETVAL );
            END IF;
         END IF;
      ELSIF LNFIELD IN( 60, 61 )
      THEN
         IF ASVALUE IS NOT NULL
         THEN
            LNRETVAL := IAPIGENERAL.ISDATE( ASVALUE,
                                            'dd/mon/yyyy hh24:mi:ss' );

            IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                       IAPIGENERAL.GETLASTERRORTEXT( )
                                    || ' PartNo -> '
                                    || ASPARTNO );
               RETURN( LNRETVAL );
            END IF;
         END IF;
      END IF;

      IF LNFIELD = 30
      THEN
         LNNUMERIC1 := TO_NUMBER( ASVALUE );
         LSFIELD := 'num_1';
      ELSIF LNFIELD = 31
      THEN
         LNNUMERIC2 := TO_NUMBER( ASVALUE );
         LSFIELD := 'num_2';
      ELSIF LNFIELD = 32
      THEN
         LNNUMERIC3 := TO_NUMBER( ASVALUE );
         LSFIELD := 'num_3';
      ELSIF LNFIELD = 33
      THEN
         LNNUMERIC4 := TO_NUMBER( ASVALUE );
         LSFIELD := 'num_4';
      ELSIF LNFIELD = 34
      THEN
         LNNUMERIC5 := TO_NUMBER( ASVALUE );
         LSFIELD := 'num_5';
      ELSIF LNFIELD = 25
      THEN
         LSTEXT1 := ASVALUE;
         LSFIELD := 'char_1';
      ELSIF LNFIELD = 26
      THEN
         LSTEXT2 := ASVALUE;
         LSFIELD := 'char_2';
      ELSIF LNFIELD = 40
      THEN
         LSTEXT3 := ASVALUE;
         LSFIELD := 'char_3';
      ELSIF LNFIELD = 41
      THEN
         LSTEXT4 := ASVALUE;
         LSFIELD := 'char_4';
      ELSIF LNFIELD = 42
      THEN
         LSTEXT5 := ASVALUE;
         LSFIELD := 'char_5';
      ELSIF LNFIELD = 60
      THEN
         LDDATE1 := TO_DATE( ASVALUE,
                             'dd/mon/yyyy hh24:mi:ss' );
         LSFIELD := 'date_1';
      ELSIF LNFIELD = 61
      THEN
         LDDATE2 := TO_DATE( ASVALUE,
                             'dd/mon/yyyy hh24:mi:ss' );
         LSFIELD := 'date_2';
      ELSIF LNFIELD = 50
      THEN
         LNBOOLEAN1 := TO_NUMBER( ASVALUE );
         LSFIELD := 'boolean_1';
      ELSIF LNFIELD = 51
      THEN
         LNBOOLEAN2 := TO_NUMBER( ASVALUE );
         LSFIELD := 'boolean_2';
      ELSIF LNFIELD = 52
      THEN
         LNBOOLEAN3 := TO_NUMBER( ASVALUE );
         LSFIELD := 'boolean_3';
      ELSIF LNFIELD = 53
      THEN
         LNBOOLEAN4 := TO_NUMBER( ASVALUE );
         LSFIELD := 'boolean_4';
      ELSIF LNFIELD = 70
      THEN
         LSFIELD := 'ch_1';
      ELSIF LNFIELD = 71
      THEN
         LSFIELD := 'ch_2';
      ELSIF LNFIELD = 72
      THEN
         LSFIELD := 'ch_3';
      END IF;

      IF NVL( ASACTION,
              '@' ) <> 'U'
      THEN
         BEGIN
            IF LSREMOVEITEM = 1
            THEN
               DELETE FROM BOM_ITEM
                     WHERE PART_NO = ASPARTNO
                       AND REVISION = ANREVISION
                       AND BOM_USAGE = ANBOMUSAGE
                       AND PLANT = ASPLANT
                       AND ALTERNATIVE = ANALTERNATIVE
                       AND ITEM_NUMBER = LNSEQUENCE;
            END IF;

            IF SUBSTR( LSFIELD,
                       1,
                       3 ) = 'ch_'
            THEN
               IF LSFIELD = 'ch_1'
               THEN
                  LSFIELDREVISION := 'ch_rev_1';
               ELSIF LSFIELD = 'ch_2'
               THEN
                  LSFIELDREVISION := 'ch_rev_2';
               ELSIF LSFIELD = 'ch_3'
               THEN
                  LSFIELDREVISION := 'ch_rev_3';
               END IF;

               
               
               IF ASVALUE IS NOT NULL
               THEN
                  LNRETVAL := GETCHARACTERISTICID( ASVALUE,
                                                   LNCHARACTERISTIC );

                  IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                  THEN
                     IAPIGENERAL.LOGERROR( GSSOURCE,
                                           LSMETHOD,
                                           IAPIGENERAL.GETLASTERRORTEXT( ) );
                     RETURN( LNRETVAL );
                  END IF;

                  
                  IF LNASSOCIATION IS NOT NULL
                  THEN
                     BEGIN
                        SELECT COUNT( * )
                          INTO LNCOUNT
                          FROM CHARACTERISTIC_ASSOCIATION
                         WHERE ASSOCIATION = LNASSOCIATION
                           AND CHARACTERISTIC = LNCHARACTERISTIC;
                     END;

                     IF LNCOUNT = 0
                     THEN
                        RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                    LSMETHOD,
                                                                    IAPICONSTANTDBERROR.DBERR_CHARNOTASSIGNEDTOASS,
                                                                    ASVALUE ) );
                     END IF;
                  END IF;

                  BEGIN
                     SELECT REVISION
                       INTO LNCHARACTERISTICREVISION
                       FROM CHARACTERISTIC_H
                      WHERE CHARACTERISTIC_ID = LNCHARACTERISTIC
                        AND MAX_REV = 1;
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        SELECT MAX( REVISION )
                          INTO LNCHARACTERISTICREVISION
                          FROM CHARACTERISTIC_H
                         WHERE CHARACTERISTIC_ID = LNCHARACTERISTIC;
                  END;

                  LNCHARACTERISTICREVISION := F_GET_SUB_REV( LNCHARACTERISTIC,
                                                             LNCHARACTERISTICREVISION,
                                                             NULL,
                                                             NULL,
                                                             'CH' );
               ELSE
                  LNCHARACTERISTIC := NULL;
                  LNCHARACTERISTICREVISION := 0;
               END IF;

               IF LNFIELD = 70
               THEN
                  LNCHARACTERISTIC1 := LNCHARACTERISTIC;
                  LNCHARACTERISTICREVISION1 := LNCHARACTERISTICREVISION;
               ELSIF LNFIELD = 71
               THEN
                  LNCHARACTERISTIC2 := LNCHARACTERISTIC;
                  LNCHARACTERISTICREVISION2 := LNCHARACTERISTICREVISION;
               ELSIF LNFIELD = 72
               THEN
                  LNCHARACTERISTIC3 := LNCHARACTERISTIC;
                  LNCHARACTERISTICREVISION3 := LNCHARACTERISTICREVISION;
               END IF;
            END IF;

            IF LSRELEVANCYTOCOSTING = 'Y'
            THEN
               LNRELEVANCYTOCOSTING := 1;
            ELSE
               LNRELEVANCYTOCOSTING := 0;
            END IF;

            IF LSBULKMATERIAL = 'Y'
            THEN
               LNBULKMATERIAL := 1;
            ELSE
               LNBULKMATERIAL := 0;
            END IF;

            INSERT INTO BOM_ITEM
                        ( PART_NO,
                          REVISION,
                          BOM_USAGE,
                          PLANT,
                          ALTERNATIVE,
                          ITEM_NUMBER,
                          COMPONENT_PART,
                          COMPONENT_REVISION,
                          COMPONENT_PLANT,
                          QUANTITY,
                          YIELD,
                          UOM,
                          COMPONENT_SCRAP,
                          ITEM_CATEGORY,
                          CALC_FLAG,
                          CONV_FACTOR,
                          TO_UNIT,
                          LEAD_TIME_OFFSET,
                          RELEVENCY_TO_COSTING,
                          BULK_MATERIAL,
                          ISSUE_LOCATION,
                          BOM_ITEM_TYPE,
                          OPERATIONAL_STEP,
                          MIN_QTY,
                          MAX_QTY,
                          CODE,
                          ALT_GROUP,
                          ALT_PRIORITY,
                          NUM_1,
                          NUM_2,
                          NUM_3,
                          NUM_4,
                          NUM_5,
                          CHAR_1,
                          CHAR_2,
                          CHAR_3,
                          CHAR_4,
                          CHAR_5,
                          DATE_1,
                          DATE_2,
                          CH_1,
                          CH_REV_1,
                          CH_2,
                          CH_REV_2,
                          CH_3,
                          CH_REV_3,
                          BOOLEAN_1,
                          BOOLEAN_2,
                          BOOLEAN_3,
                          BOOLEAN_4,
                          MAKE_UP,
                          INTL_EQUIVALENT,
                          FIXED_QTY )
                 VALUES ( ASPARTNO,
                          ANREVISION,
                          ANBOMUSAGE,
                          ASPLANT,
                          ANALTERNATIVE,
                          LNSEQUENCE,
                          ASCOMPONENT,
                          LNCOMPONENTREVISION,
                          ASCOMPONENTPLANT,
                          ANQUANTITY,
                          NVL( ANYIELD,
                               100 ),
                          LSUOM,
                          LNCOMPONENTSCRAP,
                          LSITEMCATEGORY,
                          ASCALCULATIONMODE,
                          ANCONVERSIONFACTOR,
                          ASTOUNIT,
                          NVL( ANLEADTIMEOFFSET,
                               0 ),
                          LNRELEVANCYTOCOSTING,
                          LNBULKMATERIAL,
                          ASISSUELOCATION,
                          ASBOMITEMTYPE,
                          ANOPERATIONALSTEP,
                          ANMINIMUMQUANTITY,
                          ANMAXIMUMQUANTITY,
                          ASCODE,
                          ASALTERNATIVEGROUP,
                          ANALTERNATIVEPRIORITY,
                          LNNUMERIC1,
                          LNNUMERIC2,
                          LNNUMERIC3,
                          LNNUMERIC4,
                          LNNUMERIC5,
                          LSTEXT1,
                          LSTEXT2,
                          LSTEXT3,
                          LSTEXT4,
                          LSTEXT5,
                          LDDATE1,
                          LDDATE2,
                          LNCHARACTERISTIC1,
                          LNCHARACTERISTICREVISION1,
                          LNCHARACTERISTIC2,
                          LNCHARACTERISTICREVISION2,
                          LNCHARACTERISTIC3,
                          LNCHARACTERISTICREVISION3,
                          NVL( LNBOOLEAN1,
                               0 ),
                          NVL( LNBOOLEAN2,
                               0 ),
                          NVL( LNBOOLEAN3,
                               0 ),
                          NVL( LNBOOLEAN4,
                               0 ),
                          NVL( ANMAKEUP,
                               0 ),
                          ASINTERNATIONALEQUIVALENT,
                          LNFIXEDQUANTITY );
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_DUPLICATEBOMITEM,
                                                           ASPARTNO,
                                                           ANREVISION,
                                                           ASPLANT,
                                                           ANALTERNATIVE,
                                                           ANBOMUSAGE,
                                                           TO_CHAR( LNSEQUENCE ),
                                                           ASCOMPONENT ) );
            WHEN OTHERS
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_NOINSERTBOMITEM,
                                                           ASPARTNO,
                                                           ANREVISION,
                                                           ASPLANT,
                                                           ANALTERNATIVE,
                                                           ANBOMUSAGE,
                                                           ASCOMPONENT,
                                                           SQLERRM ) );
         END;
      ELSE
         
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM BOM_ITEM
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND BOM_USAGE = ANBOMUSAGE
            AND PLANT = ASPLANT
            AND ALTERNATIVE = ANALTERNATIVE
            AND ITEM_NUMBER = ANITEMNUMBER;

         IF LNCOUNT = 0
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_NOBOMITEM,
                                                        ASPARTNO,
                                                        ANREVISION,
                                                        ASPLANT,
                                                        ANALTERNATIVE,
                                                        ANBOMUSAGE,
                                                        TO_CHAR( ANITEMNUMBER ) ) );
         END IF;

         BEGIN
            IF SUBSTR( LSFIELD,
                       1,
                       4 ) = 'char'
            THEN
               LSVALUE := REPLACE( ASVALUE,
                                   '''',
                                   '''''' );

               IF LSVALUE IS NULL
               THEN
                  LSSQL :=    'UPDATE bom_item SET '
                           || LSFIELD
                           || ' = NULL';
               ELSE
                  LSSQL :=    'UPDATE bom_item SET '
                           || LSFIELD
                           || '='''
                           || LSVALUE
                           || '''';
               END IF;
            ELSIF SUBSTR( LSFIELD,
                          1,
                          4 ) = 'bool'
            THEN
               
               LSSQL :=    'UPDATE bom_item SET '
                        || LSFIELD
                        || ' = '
                        || NVL( LSVALUE,
                                0 );
            ELSIF SUBSTR( LSFIELD,
                          1,
                          4 ) = 'num_'
            THEN
               LSSQL :=    'UPDATE bom_item SET '
                        || LSFIELD
                        || ' = '
                        || NVL( ASVALUE,
                                'NULL' );
            ELSIF SUBSTR( LSFIELD,
                          1,
                          3 ) = 'ch_'
            THEN
               IF LSFIELD = 'ch_1'
               THEN
                  LSFIELDREVISION := 'ch_rev_1';
               ELSIF LSFIELD = 'ch_2'
               THEN
                  LSFIELDREVISION := 'ch_rev_2';
               ELSIF LSFIELD = 'ch_3'
               THEN
                  LSFIELDREVISION := 'ch_rev_3';
               END IF;

               
               
               IF ASVALUE IS NOT NULL
               THEN
                  LNRETVAL := GETCHARACTERISTICID( ASVALUE,
                                                   LNCHARACTERISTIC );

                  IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                  THEN
                     IAPIGENERAL.LOGINFO( GSSOURCE,
                                          LSMETHOD,
                                          IAPIGENERAL.GETLASTERRORTEXT( ) );
                     RETURN( LNRETVAL );
                  END IF;

                  
                  IF LNASSOCIATION IS NOT NULL
                  THEN
                     BEGIN
                        SELECT COUNT( * )
                          INTO LNCOUNT
                          FROM CHARACTERISTIC_ASSOCIATION
                         WHERE ASSOCIATION = LNASSOCIATION
                           AND CHARACTERISTIC = LNCHARACTERISTIC;
                     END;

                     IF LNCOUNT = 0
                     THEN
                        RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                    LSMETHOD,
                                                                    IAPICONSTANTDBERROR.DBERR_CHARNOTASSIGNEDTOASS,
                                                                    ASVALUE ) );
                     END IF;
                  END IF;

                  BEGIN
                     SELECT REVISION
                       INTO LNCHARACTERISTICREVISION
                       FROM CHARACTERISTIC_H
                      WHERE CHARACTERISTIC_ID = LNCHARACTERISTIC
                        AND MAX_REV = 1;
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        SELECT MAX( REVISION )
                          INTO LNCHARACTERISTICREVISION
                          FROM CHARACTERISTIC_H
                         WHERE CHARACTERISTIC_ID = LNCHARACTERISTIC;
                  END;

                  LNCHARACTERISTICREVISION := F_GET_SUB_REV( LNCHARACTERISTIC,
                                                             LNCHARACTERISTICREVISION,
                                                             NULL,
                                                             NULL,
                                                             'CH' );
                  LSSQL :=    'UPDATE bom_item SET '
                           || LSFIELD
                           || '='
                           || LNCHARACTERISTIC;
               ELSE
                  LNCHARACTERISTIC := NULL;
                  LNCHARACTERISTICREVISION := 0;
                  LSSQL :=    'UPDATE bom_item SET '
                           || LSFIELD
                           || '= NULL';
               END IF;

               LSSQL :=    LSSQL
                        || ', '
                        || LSFIELDREVISION
                        || '='
                        || LNCHARACTERISTICREVISION;
            ELSIF SUBSTR( LSFIELD,
                          1,
                          5 ) = 'date_'
            THEN
               LDDATE := TO_DATE( ASVALUE,
                                  'dd/mon/yyyy hh24:mi:ss' );

               IF LDDATE IS NULL
               THEN
                  LSSQL :=    'UPDATE bom_item SET '
                           || LSFIELD
                           || ' = NULL';
               ELSE
                  LSSQL :=    'UPDATE bom_item SET '
                           || LSFIELD
                           || ' = '''
                           || LDDATE
                           || '''';
               END IF;
            END IF;

            LSSQL :=
                  LSSQL
               || ' WHERE part_no = :asPartNo'
               || ' AND revision = :anRevision '
               || ' AND plant = :plant '
               || ' AND alternative = :alternative '
               || ' AND bom_usage = :bom_usage '
               || ' AND item_number = :item_number ';
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 LSSQL,
                                 IAPICONSTANT.INFOLEVEL_3 );

            EXECUTE IMMEDIATE LSSQL
                        USING ASPARTNO,
                              ANREVISION,
                              ASPLANT,
                              ANALTERNATIVE,
                              ANBOMUSAGE,
                              ANITEMNUMBER;

            IF ( SQL%ROWCOUNT < 1 )
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_NOUPDATEBOMITEM,
                                                           ASPARTNO,
                                                           ANREVISION,
                                                           ASPLANT,
                                                           ANALTERNATIVE,
                                                           ANBOMUSAGE,
                                                           ANITEMNUMBER,
                                                           SQLERRM ) );
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_NOUPDATEBOMITEM,
                                                           ASPARTNO,
                                                           ANREVISION,
                                                           ASPLANT,
                                                           ANALTERNATIVE,
                                                           ANBOMUSAGE,
                                                           ANITEMNUMBER,
                                                           SQLERRM ) );
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
   END ADDBOMITEM;

   
   FUNCTION ADDPART(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ASBASEUOM                  IN       IAPITYPE.BASEUOM_TYPE,
      ASPARTSOURCE               IN       IAPITYPE.PARTSOURCE_TYPE,
      ANPARTTYPEID               IN       IAPITYPE.ID_TYPE,
      ANBASECONVFACTOR           IN       IAPITYPE.NUMVAL_TYPE,
      ASBASETOUNIT               IN       IAPITYPE.BASETOUNIT_TYPE,
      ASALTPARTNO                IN       IAPITYPE.PARTNO_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddPart';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIPART.EXISTID( ASPARTNO );

      IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_PARTNOTFOUND )
      THEN
         IF ASBASEUOM IS NULL
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                        'UOM' ) );
         END IF;

         INSERT INTO PART
                     ( PART_NO,
                       DESCRIPTION,
                       BASE_UOM,
                       PART_SOURCE,
                       PART_TYPE,
                       BASE_CONV_FACTOR,
                       BASE_TO_UNIT,
                       ALT_PART_NO )
              VALUES ( ASPARTNO,
                       ASDESCRIPTION,
                       ASBASEUOM,
                       ASPARTSOURCE,
                       ANPARTTYPEID,
                       ANBASECONVFACTOR,
                       ASBASETOUNIT,
                       ASALTPARTNO );
      ELSIF( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         UPDATE PART
            SET DESCRIPTION = ASDESCRIPTION,
                BASE_UOM = ASBASEUOM,
                PART_SOURCE = ASPARTSOURCE,
                PART_TYPE = ANPARTTYPEID,
                BASE_CONV_FACTOR = ANBASECONVFACTOR,
                BASE_TO_UNIT = ASBASETOUNIT,
                ALT_PART_NO = ASALTPARTNO
          WHERE PART_NO = ASPARTNO;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDPART;

   
   FUNCTION ADDSPECIFICATION(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASFRAMEID                  IN       IAPITYPE.FRAMENO_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ASBASEUOM                  IN       IAPITYPE.BASEUOM_TYPE,
      ASPARTSOURCE               IN       IAPITYPE.PARTSOURCE_TYPE,
      ANSPECTYPEID               IN       IAPITYPE.ID_TYPE,
      ANWORKFLOWGROUPID          IN       IAPITYPE.ID_TYPE,
      ANACCESSGROUPID            IN       IAPITYPE.ID_TYPE,
      ASCREATEDBY                IN       IAPITYPE.USERID_TYPE,
      ANMULTILANGUAGE            IN       IAPITYPE.BOOLEAN_TYPE,
      ANMETRIC                   IN       IAPITYPE.NUMVAL_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      ADOBSOLESCENCE             IN       IAPITYPE.DATE_TYPE,
      ADSTATUSCHANGE             IN       IAPITYPE.DATE_TYPE,
      ANPHASEIN                  IN       IAPITYPE.PHASEINTOLERANCE_TYPE,
      ADPLANNEDEFFECTIVEDATE     IN       IAPITYPE.DATE_TYPE,
      ADCREATEDON                IN       IAPITYPE.DATE_TYPE,
      ASLASTMODIFIEDBY           IN       IAPITYPE.USERID_TYPE,
      ADLASTMODIFIEDON           IN       IAPITYPE.DATE_TYPE,
      ANMASKID                   IN       IAPITYPE.ID_TYPE,
      ANBASECONVFACTOR           IN       IAPITYPE.NUMVAL_TYPE,
      ASBASETOUNIT               IN       IAPITYPE.BASETOUNIT_TYPE,
      ASALTPARTNO                IN       IAPITYPE.PARTNO_TYPE,
      ASINTERNATIONAL            IN       IAPITYPE.INTL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddSpecification';
      LNFRAMEREVISION               IAPITYPE.FRAMEREVISION_TYPE;
      LNFRAMEOWNER                  IAPITYPE.OWNER_TYPE;
      LNMASKID                      IAPITYPE.ID_TYPE;
      LSPREFIX                      IAPITYPE.PREFIX_TYPE;
      LS3TIERDB                     IAPITYPE.PARAMETERDATA_TYPE;
      LSUPDATEALLOWED               IAPITYPE.STRING_TYPE;
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LQERRORS                      IAPITYPE.REF_TYPE;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( 'upd_in_dev',
                                                       'data_migration',
                                                       LSUPDATEALLOWED );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         LSUPDATEALLOWED := 1;
      END IF;

      BEGIN
         SELECT STATUS_TYPE
           INTO LSSTATUSTYPE
           FROM STATUS
          WHERE STATUS = ANSTATUS;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_INVALIDSPECSTATUS,
                                              ASPARTNO,
                                              ANREVISION ) );
      END;

      IF NVL( LSUPDATEALLOWED,
              0 ) = 0
      THEN
         IF LSSTATUSTYPE <> IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_INVALIDSPECSTATUS,
                                              ASPARTNO,
                                              ANREVISION ) );
         END IF;
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.EXISTID( ASPARTNO,
                                             ANREVISION );

      IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_SPECALREADYEXIST,
                                               ASPARTNO,
                                               ANREVISION );
         RETURN( LNRETVAL );
      END IF;

      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM CLASS3
       WHERE CLASS = ANSPECTYPEID;

      IF LNCOUNT = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_SPECTYPENOTEXIST,
                                           ANSPECTYPEID ) );
      END IF;

      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM ACCESS_GROUP
       WHERE ACCESS_GROUP = ANACCESSGROUPID;

      IF LNCOUNT = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_ACCESSGROUPNOTEXIST,
                                           ANACCESSGROUPID ) );
      END IF;

      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM WORKFLOW_GROUP
       WHERE WORKFLOW_GROUP_ID = ANWORKFLOWGROUPID;

      IF LNCOUNT = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_WORKFLOWGROUPNOTEXIST,
                                           ANWORKFLOWGROUPID ) );
      END IF;

      LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( '3 tier db',
                                                       IAPICONSTANT.CFG_SECTION_STANDARD,
                                                       LS3TIERDB );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         RETURN( LNRETVAL );
      END IF;

      IF LS3TIERDB = '1'
      THEN
         
         IF ASINTERNATIONAL = '1'
         THEN
            LSPREFIX := SUBSTR( ASPARTNO,
                                1,
                                3 );

            SELECT COUNT( * )
              INTO LNCOUNT
              FROM SPEC_PREFIX_DESCR
             WHERE PREFIX = LSPREFIX;

            IF    LNCOUNT = 0
               OR SUBSTR( ASPARTNO,
                          4,
                          1 ) <> '-'
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_WORKFLOWGROUPNOTEXIST,
                                                 ASPARTNO,
                                                 LSPREFIX ) );
            END IF;
         ELSE
            IF SUBSTR( ASPARTNO,
                       4,
                       1 ) = '-'
            THEN
               LSPREFIX := SUBSTR( ASPARTNO,
                                   1,
                                   3 );

               SELECT COUNT( * )
                 INTO LNCOUNT
                 FROM SPEC_PREFIX_DESCR
                WHERE PREFIX = LSPREFIX;

               IF LNCOUNT <> 0
               THEN
                  RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_SPECINTLPREFIX,
                                                    ASPARTNO ) );
               END IF;
            END IF;
         END IF;
      END IF;

      
      BEGIN
         SELECT REVISION,
                OWNER
           INTO LNFRAMEREVISION,
                LNFRAMEOWNER
           FROM FRAME_HEADER
          WHERE FRAME_NO = ASFRAMEID
            AND STATUS = 2;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_FRAMENOTCURRENT,
                                              ASFRAMEID,
                                              LNFRAMEREVISION ) );
      END;

      
      LNRETVAL := ADDPART( ASPARTNO,
                           ASDESCRIPTION,
                           ASBASEUOM,
                           ASPARTSOURCE,
                           ANSPECTYPEID,
                           ANBASECONVFACTOR,
                           ASBASETOUNIT,
                           ASALTPARTNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      IF ANMASKID IS NULL
      THEN
         
         BEGIN
            SELECT MAX( VIEW_ID )
              INTO LNMASKID
              FROM ITFRMV
             WHERE FRAME_NO = ASFRAMEID
               AND REVISION = LNFRAMEREVISION
               AND OWNER = LNFRAMEOWNER;
         EXCEPTION
            WHEN OTHERS
            THEN
               LNMASKID := -1;
         END;

         IF LNMASKID IS NULL
         THEN
            LNMASKID := -1;
         END IF;
      ELSE
         LNMASKID := ANMASKID;

         IF LNMASKID IS NULL
         THEN
            LNMASKID := -1;
         END IF;
      END IF;

      BEGIN
         LSPARTNO := ASPARTNO;
         
         
















        

      
      IAPISPECIFICATION.GBLOGINTOITSCHS := FALSE;

         LNRETVAL :=
            IAPISPECIFICATION.CREATESPECIFICATIONDM( LSPARTNO,
                                                   ANREVISION,
                                                   ASDESCRIPTION,
                                                   ASCREATEDBY,
                                                   ADPLANNEDEFFECTIVEDATE,
                                                   ASFRAMEID,
                                                   LNFRAMEREVISION,
                                                   LNFRAMEOWNER,
                                                   ANSPECTYPEID,
                                                   ANWORKFLOWGROUPID,
                                                   ANACCESSGROUPID,
                                                   ANMULTILANGUAGE,
                                                   ANMETRIC,
                                                   LNMASKID,
                                                   ASINTERNATIONAL,
                                                   LQERRORS );
         

         
         IAPISPECIFICATION.GBLOGINTOITSCHS := TRUE;


         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         UPDATE SPECIFICATION_HEADER
            SET STATUS = ANSTATUS,
                
                
                OBSOLESCENCE_DATE = DECODE(OBSOLESCENCE_DATE, NULL, ADOBSOLESCENCE, OBSOLESCENCE_DATE),
                
                STATUS_CHANGE_DATE = ADSTATUSCHANGE,
                PHASE_IN_TOLERANCE = ANPHASEIN,
                CREATED_ON = ADCREATEDON,
                LAST_MODIFIED_BY = ASLASTMODIFIEDBY,
                LAST_MODIFIED_ON = ADLASTMODIFIEDON
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDSPECIFICATION;

   
   
   
   
   FUNCTION GETCHARACTERISTICID(
      ASCHARACTERISTIC           IN       IAPITYPE.DESCRIPTION_TYPE,
      ANCHARACTERISTICID         OUT      IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetCharacteristicId';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      SELECT CHARACTERISTIC_ID
        INTO ANCHARACTERISTICID
        FROM CHARACTERISTIC
       WHERE DESCRIPTION = ASCHARACTERISTIC;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN


         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,

                                           LSMETHOD,
                                           IAPICONSTANTDBERROR.DBERR_CHARACTERISTICNOTFOUND,
                                           ASCHARACTERISTIC ) );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETCHARACTERISTICID;

   
   FUNCTION IMPORTSPECIFICATIONHEADER(
      ASDIRECTORY                IN       IAPITYPE.STRINGVAL_TYPE,
      ASFILE                     IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LBENDOFFILE                   IAPITYPE.LOGICAL_TYPE;
      LDCREATEDON                   IAPITYPE.DATE_TYPE;
      LDISSUED                      IAPITYPE.DATE_TYPE;
      LDLASTMODIFIEDON              IAPITYPE.DATE_TYPE;
      LDOBSOLESCENCE                IAPITYPE.DATE_TYPE;
      LDPHASEIN                     IAPITYPE.DATE_TYPE;
      LDPLANNEDEFFECTIVE            IAPITYPE.DATE_TYPE;
      LDSTATUSCHANGE                IAPITYPE.DATE_TYPE;
      LNCNT                         IAPITYPE.NUMVAL_TYPE := 1;
      LNCONVFACTOR                  IAPITYPE.NUMVAL_TYPE;
      LNFIELDID                     IAPITYPE.NUMVAL_TYPE;
      LNFRAMEOWNER                  IAPITYPE.OWNER_TYPE;
      LNFRAMEREV                    IAPITYPE.FRAMEREVISION_TYPE;
      LNINDEX                       IAPITYPE.NUMVAL_TYPE;
      LNLENGTH                      IAPITYPE.NUMVAL_TYPE;
      LNMASK                        IAPITYPE.ID_TYPE;
      LNMETRIC                      IAPITYPE.NUMVAL_TYPE;
      LNMULTILANG                   IAPITYPE.NUMVAL_TYPE;
      LNPHASEIN                     IAPITYPE.NUMVAL_TYPE;
      LNRET                         IAPITYPE.NUMVAL_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LRFILEHANDLE                  IAPITYPE.FILE_TYPE;
      LSACCESSGROUP                 VARCHAR2( 8 );
      LSALTPART                     IAPITYPE.PARTNO_TYPE;
      LSCONVFACTOR                  VARCHAR2( 14 );
      LSCONVUOM                     VARCHAR2( 3 );
      LSCREATEDBY                   IAPITYPE.USERID_TYPE;
      LSCRITICALEFFECTIVE           IAPITYPE.STRING_TYPE;
      LSDATA                        IAPITYPE.INFO_TYPE;
      LSDATAUNICODE                 IAPITYPE.UNICODEINFO_TYPE;
      LSDESCRIPTION                 IAPITYPE.DESCRIPTION_TYPE;
      LSFRAME                       IAPITYPE.FRAMENO_TYPE;
      LSINTL                        IAPITYPE.STRING_TYPE;
      LSISSUED                      VARCHAR2( 20 );
      LSLASTMODIFIEDBY              SPECIFICATION_HEADER.LAST_MODIFIED_BY%TYPE;
      LSLASTMODIFIEDON              VARCHAR2( 20 );
      LSMASK                        VARCHAR2( 40 );
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ImportSpecificationHeader';
      LSOBSOLESCENCE                VARCHAR2( 20 );
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LSPARTSOURCE                  IAPITYPE.PARTSOURCE_TYPE;
      LSPHASEIN                     VARCHAR2( 20 );
      LSSTATUS                      IAPITYPE.STATUSID_TYPE;
      LSSTATUSCHANGE                VARCHAR2( 20 );
      LSTYPE                        VARCHAR2( 8 );
      LSUOM                         VARCHAR2( 3 );
      LSWORKFLOWGROUP               VARCHAR2( 8 );
      LTPOSTAB                      IAPITYPE.NUMBERTAB_TYPE;
      LNISJOBID                     IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPIJOBLOGGING.STARTJOB(    GSSOURCE
                                           || '.'
                                           || LSMETHOD,
                                           LNISJOBID );

      
      BEGIN
         LRFILEHANDLE := UTL_FILE.FOPEN_NCHAR( ASDIRECTORY,
                                               ASFILE,
                                               'r' );
      EXCEPTION
         WHEN OTHERS
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_UNABLETOOPENFILE,
                                                           ASDIRECTORY
                                                        || '\'
                                                        || ASFILE,
                                                        SQLERRM ) );
      END;

      LBENDOFFILE := FALSE;

      WHILE NOT LBENDOFFILE
      LOOP
         BEGIN
            


            UTL_FILE.GET_LINE_NCHAR( LRFILEHANDLE,
                                     LSDATAUNICODE );

            IF LNCNT = 1
            THEN
               LSDATA := SUBSTR( LSDATAUNICODE,
                                 2 );
            ELSE
               LSDATA := LSDATAUNICODE;
            END IF;

            LNCNT :=   LNCNT
                     + 1;

            
            FOR LNINDEX IN 1 .. 24
            LOOP
               LTPOSTAB( LNINDEX ) := INSTR( LSDATA,
                                             CHR( 9 ),
                                             1,
                                             LNINDEX );
            END LOOP;

            IF LTPOSTAB( 1 ) = 0
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_FILEERRORNOTAB ) );
            END IF;

            LNRETVAL := MANIPULATELINE( LSDATA,
                                        LTPOSTAB );

            FOR LNINDEX IN 1 .. 24
            LOOP
               LTPOSTAB( LNINDEX ) := INSTR( LSDATA,
                                             CHR( 9 ),
                                             1,
                                             LNINDEX );
            END LOOP;

            
            LNFIELDID := 1;
            LSPARTNO := NULL;
            LSPARTNO := SUBSTR( LSDATA,
                                1,
                                  LTPOSTAB( 1 )
                                - 1 );
            LNRETVAL := VALIDATEFIELD( 'Part No',
                                       LSPARTNO );

            
            BEGIN
               SELECT PART_SOURCE
                 INTO LSPARTSOURCE
                 FROM PART
                WHERE PART_NO = LSPARTNO;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  LSPARTSOURCE := 'I-S';
            END;

            
            LNFIELDID := 2;
            LNREVISION := TO_NUMBER( SUBSTR( LSDATA,
                                               LTPOSTAB( 1 )
                                             + 1,
                                               LTPOSTAB( 2 )
                                             - LTPOSTAB( 1 )
                                             - 1 ) );
            
            LNFIELDID := 3;
            LSSTATUS := SUBSTR( LSDATA,
                                  LTPOSTAB( 2 )
                                + 1,
                                  LTPOSTAB( 3 )
                                - LTPOSTAB( 2 )
                                - 1 );
            LNRETVAL := VALIDATEFIELD( 'Status',
                                       LSSTATUS );
            
            LNFIELDID := 4;
            LSDESCRIPTION := SUBSTR( LSDATA,
                                       LTPOSTAB( 3 )
                                     + 1,
                                       LTPOSTAB( 4 )
                                     - LTPOSTAB( 3 )
                                     - 1 );
            LNFIELDID := 5;
            LDPLANNEDEFFECTIVE := TO_DATE( SUBSTR( LSDATA,
                                                     LTPOSTAB( 4 )
                                                   + 1,
                                                     LTPOSTAB( 5 )
                                                   - LTPOSTAB( 4 )
                                                   - 1 ),
                                           'dd/mon/yyyy hh24:mi:ss' );
            LNFIELDID := 6;
            LSOBSOLESCENCE := SUBSTR( LSDATA,
                                        LTPOSTAB( 5 )
                                      + 1,
                                        LTPOSTAB( 6 )
                                      - LTPOSTAB( 5 )
                                      - 1 );

            IF LSOBSOLESCENCE = '0'
            THEN
               LDOBSOLESCENCE := NULL;
            ELSE
               LDOBSOLESCENCE := TO_DATE( LSOBSOLESCENCE,
                                          'dd/mon/yyyy hh24:mi:ss' );
            END IF;

            LNFIELDID := 7;
            LSSTATUSCHANGE := SUBSTR( LSDATA,
                                        LTPOSTAB( 6 )
                                      + 1,
                                        LTPOSTAB( 7 )
                                      - LTPOSTAB( 6 )
                                      - 1 );

            IF LSSTATUSCHANGE = '0'
            THEN
               LDSTATUSCHANGE := NULL;
            ELSE
               LDSTATUSCHANGE := TO_DATE( SUBSTR( LSDATA,
                                                    LTPOSTAB( 6 )
                                                  + 1,
                                                    LTPOSTAB( 7 )
                                                  - LTPOSTAB( 6 )
                                                  - 1 ),
                                          'dd/mon/yyyy hh24:mi:ss' );
            END IF;

            LNFIELDID := 8;
            LSCREATEDBY := SUBSTR( LSDATA,
                                     LTPOSTAB( 7 )
                                   + 1,
                                     LTPOSTAB( 8 )
                                   - LTPOSTAB( 7 )
                                   - 1 );

            IF LSCREATEDBY = '#N/A'
            THEN
               LSCREATEDBY := IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
            END IF;

            LNFIELDID := 9;
            LDCREATEDON := TO_DATE( SUBSTR( LSDATA,
                                              LTPOSTAB( 8 )
                                            + 1,
                                              LTPOSTAB( 9 )
                                            - LTPOSTAB( 8 )
                                            - 1 ),
                                    'dd/mon/yyyy hh24:mi:ss' );
            LNFIELDID := 10;
            LNPHASEIN := NVL( TO_NUMBER( SUBSTR( LSDATA,
                                                   LTPOSTAB( 9 )
                                                 + 1,
                                                   LTPOSTAB( 10 )
                                                 - LTPOSTAB( 9 )
                                                 - 1 ) ),
                              0 );
            LNFIELDID := 11;
            LSLASTMODIFIEDBY := SUBSTR( LSDATA,
                                          LTPOSTAB( 10 )
                                        + 1,
                                          LTPOSTAB( 11 )
                                        - LTPOSTAB( 10 )
                                        - 1 );

            IF LSLASTMODIFIEDBY = '#N/A'
            THEN
               LSLASTMODIFIEDBY := IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
            END IF;

            LNFIELDID := 12;
            LSLASTMODIFIEDON := SUBSTR( LSDATA,
                                          LTPOSTAB( 11 )
                                        + 1,
                                          LTPOSTAB( 12 )
                                        - LTPOSTAB( 11 )
                                        - 1 );

            IF LSLASTMODIFIEDON = '0'
            THEN
               LDLASTMODIFIEDON := LDCREATEDON;
            ELSE
               LDLASTMODIFIEDON := TO_DATE( LSLASTMODIFIEDON,
                                            'dd/mon/yyyy hh24:mi:ss' );
            END IF;

            LNFIELDID := 13;
            LSFRAME := SUBSTR( LSDATA,
                                 LTPOSTAB( 12 )
                               + 1,
                                 LTPOSTAB( 13 )
                               - LTPOSTAB( 12 )
                               - 1 );

            IF LENGTH( LSFRAME ) > 18
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_FRAMEIDTOOLONG ) );
            END IF;

            LNFIELDID := 14;
            LSACCESSGROUP := SUBSTR( LSDATA,
                                       LTPOSTAB( 13 )
                                     + 1,
                                       LTPOSTAB( 14 )
                                     - LTPOSTAB( 13 )
                                     - 1 );
            LNFIELDID := 15;
            LSWORKFLOWGROUP := SUBSTR( LSDATA,
                                         LTPOSTAB( 14 )
                                       + 1,
                                         LTPOSTAB( 15 )
                                       - LTPOSTAB( 14 )
                                       - 1 );
            LNFIELDID := 16;
            LSTYPE := SUBSTR( LSDATA,
                                LTPOSTAB( 15 )
                              + 1,
                                LTPOSTAB( 16 )
                              - LTPOSTAB( 15 )
                              - 1 );
            LNFIELDID := 17;
            LNMULTILANG := TO_NUMBER( SUBSTR( LSDATA,
                                                LTPOSTAB( 16 )
                                              + 1,
                                                LTPOSTAB( 17 )
                                              - LTPOSTAB( 16 )
                                              - 1 ) );
            LNFIELDID := 18;
            LNMETRIC := TO_NUMBER( SUBSTR( LSDATA,
                                             LTPOSTAB( 17 )
                                           + 1,
                                             LTPOSTAB( 18 )
                                           - LTPOSTAB( 17 )
                                           - 1 ) );

            IF LNMETRIC IS NULL
            THEN
               LNMETRIC := 0;
            END IF;

            LNFIELDID := 19;
            LSUOM := SUBSTR( LSDATA,
                               LTPOSTAB( 18 )
                             + 1,
                               LTPOSTAB( 19 )
                             - LTPOSTAB( 18 )
                             - 1 );
            LNFIELDID := 20;
            LSMASK := SUBSTR( LSDATA,
                                LTPOSTAB( 19 )
                              + 1,
                                LTPOSTAB( 20 )
                              - LTPOSTAB( 19 )
                              - 1 );

            IF LSMASK IS NOT NULL
            THEN
               
               BEGIN
                  SELECT REVISION,
                         OWNER
                    INTO LNFRAMEREV,
                         LNFRAMEOWNER
                    FROM FRAME_HEADER
                   WHERE FRAME_NO = LSFRAME
                     AND STATUS = 2;

                  SELECT VIEW_ID
                    INTO LNMASK
                    FROM ITFRMV
                   WHERE FRAME_NO = LSFRAME
                     AND REVISION = LNFRAMEREV
                     AND OWNER = LNFRAMEOWNER
                     AND STATUS = 0
                     AND DESCRIPTION = LSMASK;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                 LSMETHOD,
                                                                 IAPICONSTANTDBERROR.DBERR_PARTNOTCREATEDMASK,
                                                                 LSPARTNO,
                                                                 LNREVISION,
                                                                 LSMASK,
                                                                 LSFRAME ) );
               END;
            END IF;

            LNFIELDID := 21;
            LSINTL := SUBSTR( LSDATA,
                                LTPOSTAB( 20 )
                              + 1,
                                LTPOSTAB( 21 )
                              - LTPOSTAB( 20 )
                              - 1 );

            IF LSINTL IS NULL
            THEN
               LSINTL := '0';
            END IF;

            LNFIELDID := 22;
            LSCONVFACTOR := SUBSTR( LSDATA,
                                      LTPOSTAB( 21 )
                                    + 1,
                                      LTPOSTAB( 22 )
                                    - LTPOSTAB( 21 )
                                    - 1 );

            IF LSCONVFACTOR IS NULL
            THEN
               LNCONVFACTOR := NULL;
            ELSE
               LNCONVFACTOR := TO_NUMBER( LSCONVFACTOR );
            END IF;

            LNFIELDID := 23;
            LSCONVUOM := SUBSTR( LSDATA,
                                   LTPOSTAB( 22 )
                                 + 1,
                                   LTPOSTAB( 23 )
                                 - LTPOSTAB( 22 )
                                 - 1 );
            LNFIELDID := 24;
            LSALTPART := TRIM( SUBSTR( LSDATA,
                                         LTPOSTAB( 23 )
                                       + 1,
                                         LTPOSTAB( 24 )
                                       - LTPOSTAB( 23 )
                                       - 1 ) );
            LNRETVAL :=
               ADDSPECIFICATION( LSPARTNO,
                                 LNREVISION,
                                 LSFRAME,
                                 LSDESCRIPTION,
                                 LSUOM,
                                 LSPARTSOURCE,
                                 TO_NUMBER( LSTYPE ),
                                 TO_NUMBER( LSWORKFLOWGROUP ),
                                 TO_NUMBER( LSACCESSGROUP ),
                                 LSCREATEDBY,
                                 LNMULTILANG,
                                 LNMETRIC,
                                 TO_NUMBER( LSSTATUS ),
                                 LDOBSOLESCENCE,
                                 LDSTATUSCHANGE,
                                 LNPHASEIN,
                                 LDPLANNEDEFFECTIVE,
                                 LDCREATEDON,
                                 LSLASTMODIFIEDBY,
                                 LDLASTMODIFIEDON,
                                 LNMASK,
                                 LNCONVFACTOR,
                                 LSCONVUOM,
                                 LSALTPART,
                                 LSINTL );

            
            
            
            
            
            
            

            
            
            IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               COMMIT;
            ELSE
               ROLLBACK;
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
            END IF;
            
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LBENDOFFILE := TRUE;
            WHEN OTHERS
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTNOTCREATEDCONV,
                                                           LSPARTNO,
                                                           LNFIELDID,
                                                           SQLERRM ) );
         END;
      END LOOP;

      
      UTL_FILE.FCLOSE( LRFILEHANDLE );
      
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNISJOBID );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END IMPORTSPECIFICATIONHEADER;

   
   FUNCTION IMPORTPLANT(
      ASDIRECTORY                IN       IAPITYPE.STRINGVAL_TYPE,
      ASFILE                     IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LBENDOFFILE                   IAPITYPE.LOGICAL_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE := 1;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRFILEHANDLE                  UTL_FILE.FILE_TYPE;
      LSDATA                        IAPITYPE.INFO_TYPE;
      LSDATAUNICODE                 IAPITYPE.UNICODEINFO_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ImportPlant';
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LSPLANT                       IAPITYPE.PLANT_TYPE;
      LTPOSTAB                      IAPITYPE.NUMBERTAB_TYPE;
      LQERRORS                      IAPITYPE.REF_TYPE;
      LNISJOBID                     IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPIJOBLOGGING.STARTJOB(    GSSOURCE
                                           || '.'
                                           || LSMETHOD,
                                           LNISJOBID );

      
      BEGIN
         LRFILEHANDLE := UTL_FILE.FOPEN_NCHAR( ASDIRECTORY,
                                               ASFILE,
                                               'r' );
      EXCEPTION
         WHEN OTHERS
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_UNABLETOOPENFILE,
                                                           ASDIRECTORY
                                                        || '\'
                                                        || ASFILE,
                                                        SQLERRM ) );
      END;

      LBENDOFFILE := FALSE;

      WHILE NOT LBENDOFFILE
      LOOP
         BEGIN
            
            UTL_FILE.GET_LINE_NCHAR( LRFILEHANDLE,
                                     LSDATAUNICODE );

            IF LNCOUNT = 1
            THEN
               LSDATA := SUBSTR( LSDATAUNICODE,
                                 2 );
            ELSE
               LSDATA := LSDATAUNICODE;
            END IF;

            LNCOUNT :=   LNCOUNT
                       + 1;

            
            FOR LL_I IN 1 .. 1
            LOOP
               LTPOSTAB( LL_I ) := INSTR( LSDATA,
                                          CHR( 9 ),
                                          1,
                                          LL_I );
            END LOOP;

            IF LTPOSTAB( 1 ) = 0
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_FILEERRORNOTAB ) );
            END IF;

            LNRETVAL := MANIPULATELINE( LSDATA,
                                        LTPOSTAB );

            FOR LL_I IN 1 .. 1
            LOOP
               LTPOSTAB( LL_I ) := INSTR( LSDATA,
                                          CHR( 9 ),
                                          1,
                                          LL_I );
            END LOOP;

            LSPARTNO := NULL;
            LSPARTNO := SUBSTR( LSDATA,
                                1,
                                  LTPOSTAB( 1 )
                                - 1 );
            LSPLANT := SUBSTR( LSDATA,
                                 LTPOSTAB( 1 )
                               + 1 );
            
            
            
            LNRETVAL := IAPIPARTPLANT.ADDPLANT( LSPARTNO,
                                                LSPLANT,
                                                0,
                                                0,
                                                0,
                                                0,
                                                'L',
                                                0,
                                                NULL,
                                                NULL,
                                                NULL,
                                                0,
                                                
                                                
                                                
                                                
                                                LQERRORS );

            
            
            
            
            
            
            
            
            
            

            
            
            IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               COMMIT;
            ELSE
               ROLLBACK;
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
            END IF;
            
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LBENDOFFILE := TRUE;
            WHEN OTHERS
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTNOTCREATEDRET,
                                                           LSPARTNO,
                                                           SQLERRM ) );
         END;
      END LOOP;

      
      UTL_FILE.FCLOSE( LRFILEHANDLE );
      
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNISJOBID );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END IMPORTPLANT;

   
   FUNCTION IMPORTKEYWORD(
      ASDIRECTORY                IN       IAPITYPE.STRINGVAL_TYPE,
      ASFILE                     IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LBENDOFFILE                   IAPITYPE.LOGICAL_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE := 1;
      LNFIELDID                     IAPITYPE.NUMVAL_TYPE;
      LNKEYWORD                     IAPITYPE.KEYWORDID_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRFILEHANDLE                  IAPITYPE.FILE_TYPE;
      LSDATA                        IAPITYPE.INFO_TYPE;
      LSDATAUNICODE                 IAPITYPE.UNICODEINFO_TYPE;
      LSKEYWORD                     IAPITYPE.KEYWORDVALUE_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ImportKeyword';
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LSVALUE                       IAPITYPE.KEYWORDVALUE_TYPE;
      LTPOSTAB                      IAPITYPE.NUMBERTAB_TYPE;
      LNISJOBID                     IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPIJOBLOGGING.STARTJOB(    GSSOURCE
                                           || '.'
                                           || LSMETHOD,
                                           LNISJOBID );

      
      BEGIN
         LRFILEHANDLE := UTL_FILE.FOPEN_NCHAR( ASDIRECTORY,
                                               ASFILE,
                                               'r' );
      EXCEPTION
         WHEN OTHERS
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_UNABLETOOPENFILE,
                                                           ASDIRECTORY
                                                        || '\'
                                                        || ASFILE,
                                                        SQLERRM ) );
      END;

      LBENDOFFILE := FALSE;

      WHILE NOT LBENDOFFILE
      LOOP
         BEGIN




            
            UTL_FILE.GET_LINE_NCHAR( LRFILEHANDLE,
                                     LSDATAUNICODE );

            IF LNCOUNT = 1
            THEN
               LSDATA := SUBSTR( LSDATAUNICODE,
                                 2 );
            ELSE
               LSDATA := LSDATAUNICODE;
            END IF;

            LNCOUNT :=   LNCOUNT
                       + 1;

            
            FOR LL_I IN 1 .. 2
            LOOP
               LTPOSTAB( LL_I ) := INSTR( LSDATA,
                                          CHR( 9 ),
                                          1,
                                          LL_I );
            END LOOP;

            IF LTPOSTAB( 1 ) = 0
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_FILEERRORNOTAB ) );
            END IF;

            LNRETVAL := MANIPULATELINE( LSDATA,
                                        LTPOSTAB );

            FOR LL_I IN 1 .. 2
            LOOP
               LTPOSTAB( LL_I ) := INSTR( LSDATA,
                                          CHR( 9 ),
                                          1,
                                          LL_I );
            END LOOP;

            LNFIELDID := 1;
            LSPARTNO := NULL;
            LSPARTNO := SUBSTR( LSDATA,
                                1,
                                  LTPOSTAB( 1 )
                                - 1 );
            LNFIELDID := 2;
            LSKEYWORD := SUBSTR( LSDATA,
                                   LTPOSTAB( 1 )
                                 + 1,
                                   LTPOSTAB( 2 )
                                 - LTPOSTAB( 1 )
                                 - 1 );

            IF LSKEYWORD = '#N/A'
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTNOTINSERTEDISNA,
                                                           LSPARTNO,
                                                           'keyword' ) );
            END IF;

            LNKEYWORD := TO_NUMBER( LSKEYWORD );
            LNFIELDID := 3;
            LSVALUE := SUBSTR( SUBSTR( LSDATA,
                                         LTPOSTAB( 2 )
                                       + 1,
                                         LENGTH( LSDATA )
                                       - LTPOSTAB( 2 ) ),
                               1,
                               40 );

            IF LSVALUE = '0'
            THEN
               LSVALUE := '<Any>';
            END IF;




            LNRETVAL := ADDKEYWORD( LSPARTNO,
                                    LNKEYWORD,
                                    LSVALUE );

            
            
            
            
            
            
            

            
            
            IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               COMMIT;
            ELSE
               ROLLBACK;
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
            END IF;
            
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LBENDOFFILE := TRUE;
            WHEN OTHERS
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTNOTCREATEDGEN,
                                                           LSPARTNO,
                                                           LNFIELDID,
                                                           SQLERRM ) );
         END;
      END LOOP;

      
      UTL_FILE.FCLOSE( LRFILEHANDLE );
      
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNISJOBID );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END IMPORTKEYWORD;

   
   FUNCTION IMPORTMANUFACTURER(
      ASDIRECTORY                IN       IAPITYPE.STRINGVAL_TYPE,
      ASFILE                     IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LBENDOFFILE                   IAPITYPE.LOGICAL_TYPE;
      LDAPPROVALDATE                IAPITYPE.DATE_TYPE;
      LDAUDITDATE                   IAPITYPE.DATE_TYPE;
      LNAUDITFREQ                   IAPITYPE.AUDITFREQUENCE_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE := 1;
      LNFIELDID                     IAPITYPE.NUMVAL_TYPE;
      LNMANUFACTURER                IAPITYPE.MANUFACTURERID_TYPE;
      LNMANUFACTURERPLANT           IAPITYPE.NUMVAL_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LRFILEHANDLE                  IAPITYPE.FILE_TYPE;
      LSAPPROVALDATE                VARCHAR2( 20 );
      LSAUDITDATE                   VARCHAR2( 20 );
      LSCLEARANCE                   IAPITYPE.CLEARANCENUMBER_TYPE;
      LSDATA                        IAPITYPE.INFO_TYPE;
      LSDATAUNICODE                 IAPITYPE.UNICODEINFO_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ImportManufacturer';
      LSMANUFACTURER                VARCHAR2( 60 );
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LSPLANT                       IAPITYPE.PLANTDESCRIPTION_TYPE;
      LSPRODUCTCODE                 IAPITYPE.PRODUCTCODE_TYPE;
      LSTRADENAME                   IAPITYPE.TRADENAME_TYPE;
      LTPOSTAB                      IAPITYPE.NUMBERTAB_TYPE;
      LNISJOBID                     IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPIJOBLOGGING.STARTJOB(    GSSOURCE
                                           || '.'
                                           || LSMETHOD,
                                           LNISJOBID );

      
      BEGIN
         LRFILEHANDLE := UTL_FILE.FOPEN_NCHAR( ASDIRECTORY,
                                               ASFILE,
                                               'r' );
      EXCEPTION
         WHEN OTHERS
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_UNABLETOOPENFILE,
                                                           ASDIRECTORY
                                                        || '\'
                                                        || ASFILE,
                                                        SQLERRM ) );
      END;

      LBENDOFFILE := FALSE;

      WHILE NOT LBENDOFFILE
      LOOP
         BEGIN




            
            UTL_FILE.GET_LINE_NCHAR( LRFILEHANDLE,
                                     LSDATAUNICODE );

            IF LNCOUNT = 1
            THEN
               LSDATA := SUBSTR( LSDATAUNICODE,
                                 2 );
            ELSE
               LSDATA := LSDATAUNICODE;
            END IF;

            LNCOUNT :=   LNCOUNT
                       + 1;

            
            FOR LL_I IN 1 .. 9
            LOOP
               LTPOSTAB( LL_I ) := INSTR( LSDATA,
                                          CHR( 9 ),
                                          1,
                                          LL_I );
            END LOOP;

            IF LTPOSTAB( 1 ) = 0
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_FILEERRORNOTAB ) );
            END IF;

            LNRETVAL := MANIPULATELINE( LSDATA,
                                        LTPOSTAB );

            FOR LL_I IN 1 .. 9
            LOOP
               LTPOSTAB( LL_I ) := INSTR( LSDATA,
                                          CHR( 9 ),
                                          1,
                                          LL_I );
            END LOOP;

            LNFIELDID := 1;
            LSPARTNO := NULL;
            LSPARTNO := SUBSTR( LSDATA,
                                1,
                                  LTPOSTAB( 1 )
                                - 1 );
            LNFIELDID := 2;
            LSMANUFACTURER := SUBSTR( LSDATA,
                                        LTPOSTAB( 1 )
                                      + 1,
                                        LTPOSTAB( 2 )
                                      - LTPOSTAB( 1 )
                                      - 1 );

            IF LSMANUFACTURER = '#N/A'
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTNOTINSERTEDISNA,
                                                           LSPARTNO,
                                                           'Manufacturer' ) );
            END IF;

            LNMANUFACTURER := TO_NUMBER( LSMANUFACTURER );
            LNFIELDID := 3;
            LSPLANT := SUBSTR( LSDATA,
                                 LTPOSTAB( 2 )
                               + 1,
                                 LTPOSTAB( 3 )
                               - LTPOSTAB( 2 )
                               - 1 );

            IF    LSPLANT IS NULL
               OR LSPLANT = ' '
            THEN
               LNMANUFACTURERPLANT := -1;
            ELSE
               LNMANUFACTURERPLANT := TO_NUMBER( LSPLANT );
            END IF;

            LNFIELDID := 4;
            LSCLEARANCE := SUBSTR( LSDATA,
                                     LTPOSTAB( 3 )
                                   + 1,
                                     LTPOSTAB( 4 )
                                   - LTPOSTAB( 3 )
                                   - 1 );
            LNFIELDID := 5;
            LSTRADENAME := SUBSTR( LSDATA,
                                     LTPOSTAB( 4 )
                                   + 1,
                                     LTPOSTAB( 5 )
                                   - LTPOSTAB( 4 )
                                   - 1 );
            LNFIELDID := 6;
            LSAUDITDATE := SUBSTR( LSDATA,
                                     LTPOSTAB( 5 )
                                   + 1,
                                     LTPOSTAB( 6 )
                                   - LTPOSTAB( 5 )
                                   - 1 );

            IF LSAUDITDATE = '0'
            THEN
               LDAUDITDATE := NULL;
            ELSE
               LDAUDITDATE := TO_DATE( LSAUDITDATE,
                                       'dd/mon/yyyy hh24:mi:ss' );
            END IF;

            LNFIELDID := 7;
            LNAUDITFREQ := TO_NUMBER( SUBSTR( LSDATA,
                                                LTPOSTAB( 6 )
                                              + 1,
                                                LTPOSTAB( 7 )
                                              - LTPOSTAB( 6 )
                                              - 1 ) );
            LNFIELDID := 8;
            LSPRODUCTCODE := SUBSTR( LSDATA,
                                       LTPOSTAB( 7 )
                                     + 1,
                                       LTPOSTAB( 8 )
                                     - LTPOSTAB( 7 )
                                     - 1 );
            LNFIELDID := 9;
            LSAPPROVALDATE := SUBSTR( LSDATA,
                                        LTPOSTAB( 8 )
                                      + 1,
                                        LTPOSTAB( 9 )
                                      - LTPOSTAB( 8 )
                                      - 1 );

            IF LSAPPROVALDATE = '0'
            THEN
               LDAPPROVALDATE := NULL;
            ELSE
               LDAPPROVALDATE := TO_DATE( LSAPPROVALDATE,
                                          'dd/mon/yyyy hh24:mi:ss' );
            END IF;

            LNFIELDID := 10;
            LNREVISION := TO_NUMBER( SUBSTR( LSDATA,
                                               LTPOSTAB( 9 )
                                             + 1,
                                               LENGTH( LSDATA )
                                             - LTPOSTAB( 9 ) ) );
            LNRETVAL :=
               ADDMANUFACTURER( LSPARTNO,
                                LNMANUFACTURER,
                                LNMANUFACTURERPLANT,
                                LSCLEARANCE,
                                LSTRADENAME,
                                LDAUDITDATE,
                                LNAUDITFREQ,
                                LSPRODUCTCODE,
                                LDAPPROVALDATE,
                                LNREVISION );

            
            
            
            
            
            
            

            
            
            IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               COMMIT;
            ELSE
               ROLLBACK;
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
            END IF;
            
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LBENDOFFILE := TRUE;
            WHEN OTHERS
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTNOTCREATEDGEN,
                                                           LSPARTNO,
                                                           LNFIELDID,
                                                           SQLERRM ) );
         END;
      END LOOP;

      
      UTL_FILE.FCLOSE( LRFILEHANDLE );
      
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNISJOBID );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END IMPORTMANUFACTURER;

   
   FUNCTION IMPORTINGREDIENTLIST(
      ASDIRECTORY                IN       IAPITYPE.STRINGVAL_TYPE,
      ASFILE                     IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LBENDOFFILE                   IAPITYPE.LOGICAL_TYPE;
      LNQUANTITY                    IAPITYPE.INGREDIENTQUANTITY_TYPE;
      LFRECFAC                      IAPITYPE.INGREDIENTRECFAC_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE := 1;
      LNFIELDID                     IAPITYPE.NUMVAL_TYPE;
      LNHIERLEVEL                   IAPITYPE.INGREDIENTHIERARCHICLEVEL_TYPE;
      LNINGREDIENT                  IAPITYPE.INGREDIENT_TYPE;
      LNPID                         IAPITYPE.INGREDIENT_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LNSECTION                     IAPITYPE.INGREDIENTSECTION_TYPE;
      LNSUBSECTION                  IAPITYPE.INGREDIENTSUBSECTION_TYPE;
      LNSYNONYM                     IAPITYPE.INGREDIENTSYNONYM_TYPE;
      LRFILEHANDLE                  IAPITYPE.FILE_TYPE;
      LSACTIVIND                    IAPITYPE.STRING_TYPE;
      LSCHEMICALS                   IAPITYPE.STRING_TYPE;
      LSDATA                        IAPITYPE.INFO_TYPE;
      LSDATAUNICODE                 IAPITYPE.UNICODEINFO_TYPE;
      LSHIERLEVEL                   VARCHAR2( 60 );
      LSINGCOMMENT                  IAPITYPE.INGREDIENTCOMMENT_TYPE;
      LSINGLEVEL                    IAPITYPE.INGREDIENTLEVEL_TYPE;
      LSINGREDIENT                  VARCHAR2( 60 );
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ImportIngredientList';
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LSPID                         VARCHAR2( 60 );
      LSQUANTITY                    VARCHAR2( 60 );
      LSRECFAC                      VARCHAR2( 60 );
      LSSECTION                     VARCHAR2( 60 );
      LSSUBSECTION                  VARCHAR2( 60 );
      LSSYNONYM                     VARCHAR2( 60 );
      LTPOSTAB                      IAPITYPE.NUMBERTAB_TYPE;
      LNISJOBID                     IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPIJOBLOGGING.STARTJOB(    GSSOURCE
                                           || '.'
                                           || LSMETHOD,
                                           LNISJOBID );

      
      BEGIN
         LRFILEHANDLE := UTL_FILE.FOPEN_NCHAR( ASDIRECTORY,
                                               ASFILE,
                                               'r' );
      EXCEPTION
         WHEN OTHERS
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_UNABLETOOPENFILE,
                                                           ASDIRECTORY
                                                        || '\'
                                                        || ASFILE,
                                                        SQLERRM ) );
      END;

      LBENDOFFILE := FALSE;

      WHILE NOT LBENDOFFILE
      LOOP
         BEGIN




            
            UTL_FILE.GET_LINE_NCHAR( LRFILEHANDLE,
                                     LSDATAUNICODE );

            IF LNCOUNT = 1
            THEN
               LSDATA := SUBSTR( LSDATAUNICODE,
                                 2 );
            ELSE
               LSDATA := LSDATAUNICODE;
            END IF;

            LNCOUNT :=   LNCOUNT
                       + 1;

            
            FOR LL_I IN 1 .. 13
            LOOP
               LTPOSTAB( LL_I ) := INSTR( LSDATA,
                                          CHR( 9 ),
                                          1,
                                          LL_I );
            END LOOP;

            IF LTPOSTAB( 1 ) = 0
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_FILEERRORNOTAB ) );
            END IF;

            LNRETVAL := MANIPULATELINE( LSDATA,
                                        LTPOSTAB );

            FOR LL_I IN 1 .. 13
            LOOP
               LTPOSTAB( LL_I ) := INSTR( LSDATA,
                                          CHR( 9 ),
                                          1,
                                          LL_I );
            END LOOP;

            LNFIELDID := 1;
            LSPARTNO := NULL;
            LSPARTNO := SUBSTR( LSDATA,
                                1,
                                  LTPOSTAB( 1 )
                                - 1 );
            LNFIELDID := 2;
            LNREVISION := TO_NUMBER( SUBSTR( LSDATA,
                                               LTPOSTAB( 1 )
                                             + 1,
                                               LTPOSTAB( 2 )
                                             - LTPOSTAB( 1 )
                                             - 1 ) );
            LNFIELDID := 3;
            LSSECTION := SUBSTR( LSDATA,
                                   LTPOSTAB( 2 )
                                 + 1,
                                   LTPOSTAB( 3 )
                                 - LTPOSTAB( 2 )
                                 - 1 );

            IF LSSECTION = '#N/A'
            THEN
               LNSECTION := 0;
            ELSE
               LNSECTION := TO_NUMBER( LSSECTION );
            END IF;

            LNFIELDID := 4;
            LSSUBSECTION := SUBSTR( LSDATA,
                                      LTPOSTAB( 3 )
                                    + 1,
                                      LTPOSTAB( 4 )
                                    - LTPOSTAB( 3 )
                                    - 1 );

            IF    LSSUBSECTION = '#N/A'
               OR LSSUBSECTION IS NULL
            THEN
               LNSUBSECTION := 0;
            ELSE
               LNSUBSECTION := TO_NUMBER( LSSUBSECTION );
            END IF;

            LNFIELDID := 5;
            LSINGREDIENT := SUBSTR( LSDATA,
                                      LTPOSTAB( 4 )
                                    + 1,
                                      LTPOSTAB( 5 )
                                    - LTPOSTAB( 4 )
                                    - 1 );

            IF LSINGREDIENT = '#N/A'
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTNOTINSERTEDISNA,
                                                           LSPARTNO,
                                                           'ingredient' ) );
            END IF;

            LNINGREDIENT := TO_NUMBER( LSINGREDIENT );
            LNFIELDID := 6;
            LSSYNONYM := SUBSTR( LSDATA,
                                   LTPOSTAB( 5 )
                                 + 1,
                                   LTPOSTAB( 6 )
                                 - LTPOSTAB( 5 )
                                 - 1 );

            IF LSSYNONYM = '#N/A'
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTNOTINSERTEDISNA,
                                                           LSPARTNO,
                                                           'synonym' ) );
            END IF;

            LNSYNONYM := TO_NUMBER( LSSYNONYM );
            LNFIELDID := 7;
            LSQUANTITY := SUBSTR( LSDATA,
                                    LTPOSTAB( 6 )
                                  + 1,
                                    LTPOSTAB( 7 )
                                  - LTPOSTAB( 6 )
                                  - 1 );
            LNQUANTITY := TO_NUMBER( LSQUANTITY );
            LNFIELDID := 8;
            LSRECFAC := SUBSTR( LSDATA,
                                  LTPOSTAB( 7 )
                                + 1,
                                  LTPOSTAB( 8 )
                                - LTPOSTAB( 7 )
                                - 1 );
            LFRECFAC := TO_NUMBER( LSRECFAC );
            LNFIELDID := 9;
            LSINGLEVEL := SUBSTR( LSDATA,
                                    LTPOSTAB( 8 )
                                  + 1,
                                    LTPOSTAB( 9 )
                                  - LTPOSTAB( 8 )
                                  - 1 );
            LNFIELDID := 10;
            LSINGCOMMENT := SUBSTR( LSDATA,
                                      LTPOSTAB( 9 )
                                    + 1,
                                      LTPOSTAB( 10 )
                                    - LTPOSTAB( 9 )
                                    - 1 );
            LNFIELDID := 11;
            LSACTIVIND := SUBSTR( LSDATA,
                                    LTPOSTAB( 10 )
                                  + 1,
                                    LTPOSTAB( 11 )
                                  - LTPOSTAB( 10 )
                                  - 1 );
            LNFIELDID := 12;
            LSCHEMICALS := SUBSTR( LSDATA,
                                     LTPOSTAB( 11 )
                                   + 1,
                                     LTPOSTAB( 12 )
                                   - LTPOSTAB( 11 )
                                   - 1 );
            LNFIELDID := 13;
            LSHIERLEVEL := SUBSTR( LSDATA,
                                     LTPOSTAB( 12 )
                                   + 1,
                                     LTPOSTAB( 13 )
                                   - LTPOSTAB( 12 )
                                   - 1 );

            IF    LSHIERLEVEL = '#N/A'
               OR LSHIERLEVEL IS NULL
            THEN
               LNHIERLEVEL := 0;
            ELSE
               LNHIERLEVEL := TO_NUMBER( LSHIERLEVEL );
            END IF;

            LNFIELDID := 14;
            LSPID := TRIM( SUBSTR( LSDATA,
                                     LTPOSTAB( 13 )
                                   + 1,
                                     LENGTH( LSDATA )
                                   - LTPOSTAB( 13 ) ) );

            IF    LSPID = '#N/A'
               OR LSPID IS NULL
            THEN
               LNPID := 0;
            ELSE
               LNPID := TO_NUMBER( LSPID );
            END IF;

            LNRETVAL :=
               ADDINGREDIENT( LSPARTNO,
                              LNREVISION,
                              LNSECTION,
                              LNSUBSECTION,
                              LNINGREDIENT,
                              LNSYNONYM,
                              LNQUANTITY,
                              LFRECFAC,
                              LSINGLEVEL,
                              LSINGCOMMENT,
                              LSACTIVIND,
                              LSCHEMICALS,
                              LNHIERLEVEL,
                              LNPID );

            
            
            
            
            
            
            

            
            
            IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               COMMIT;
            ELSE
               ROLLBACK;
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
            END IF;
            
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LBENDOFFILE := TRUE;
            WHEN OTHERS
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTNOTCREATEDGEN,
                                                           LSPARTNO,
                                                           LNFIELDID,
                                                           SQLERRM ) );
         END;
      END LOOP;

      
      UTL_FILE.FCLOSE( LRFILEHANDLE );
      
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNISJOBID );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END IMPORTINGREDIENTLIST;

   
   FUNCTION IMPORTATTACHEDSPECIFICATION(
      ASDIRECTORY                IN       IAPITYPE.STRINGVAL_TYPE,
      ASFILE                     IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LBENDOFFILE                   IAPITYPE.LOGICAL_TYPE;
      LNATTACHEDREVISION            IAPITYPE.REVISION_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE := 1;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LNSECTION                     IAPITYPE.INGREDIENTSECTION_TYPE;
      LNSUBSECTION                  IAPITYPE.INGREDIENTSUBSECTION_TYPE;
      LRFILEHANDLE                  IAPITYPE.FILE_TYPE;
      LSATTACHEDPARTNO              IAPITYPE.PARTNO_TYPE;
      LSDATA                        IAPITYPE.INFO_TYPE;
      LSDATAUNICODE                 IAPITYPE.UNICODEINFO_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ImportAttachedSpecification';
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LSSECTION                     IAPITYPE.DESCRIPTION_TYPE;
      LSSUBSECTION                  IAPITYPE.DESCRIPTION_TYPE;
      LTPOSTAB                      IAPITYPE.NUMBERTAB_TYPE;
      LNISJOBID                     IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPIJOBLOGGING.STARTJOB(    GSSOURCE
                                           || '.'
                                           || LSMETHOD,
                                           LNISJOBID );

      
      BEGIN
         LRFILEHANDLE := UTL_FILE.FOPEN_NCHAR( ASDIRECTORY,
                                               ASFILE,
                                               'r' );
      EXCEPTION
         WHEN OTHERS
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_UNABLETOOPENFILE,
                                                           ASDIRECTORY
                                                        || '\'
                                                        || ASFILE,
                                                        SQLERRM ) );
      END;

      LBENDOFFILE := FALSE;

      WHILE NOT LBENDOFFILE
      LOOP
         BEGIN




            
            UTL_FILE.GET_LINE_NCHAR( LRFILEHANDLE,
                                     LSDATAUNICODE );

            IF LNCOUNT = 1
            THEN
               LSDATA := SUBSTR( LSDATAUNICODE,
                                 2 );
            ELSE
               LSDATA := LSDATAUNICODE;
            END IF;

            LNCOUNT :=   LNCOUNT
                       + 1;

            
            FOR LL_I IN 1 .. 5
            LOOP
               LTPOSTAB( LL_I ) := INSTR( LSDATA,
                                          CHR( 9 ),
                                          1,
                                          LL_I );
            END LOOP;

            IF LTPOSTAB( 1 ) = 0
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_FILEERRORNOTAB ) );
            END IF;

            LNRETVAL := MANIPULATELINE( LSDATA,
                                        LTPOSTAB );

            FOR LL_I IN 1 .. 5
            LOOP
               LTPOSTAB( LL_I ) := INSTR( LSDATA,
                                          CHR( 9 ),
                                          1,
                                          LL_I );
            END LOOP;

            LSPARTNO := NULL;
            LSPARTNO := SUBSTR( LSDATA,
                                1,
                                  LTPOSTAB( 1 )
                                - 1 );
            LNREVISION := TO_NUMBER( SUBSTR( LSDATA,
                                               LTPOSTAB( 1 )
                                             + 1,
                                               LTPOSTAB( 2 )
                                             - LTPOSTAB( 1 )
                                             - 1 ) );
            LSSECTION := SUBSTR( LSDATA,
                                   LTPOSTAB( 2 )
                                 + 1,
                                   LTPOSTAB( 3 )
                                 - LTPOSTAB( 2 )
                                 - 1 );

            IF LSSECTION = '#N/A'
            THEN
               LNSECTION := 0;
            ELSE
               LNSECTION := TO_NUMBER( LSSECTION );
            END IF;

            LSSUBSECTION := SUBSTR( LSDATA,
                                      LTPOSTAB( 3 )
                                    + 1,
                                      LTPOSTAB( 4 )
                                    - LTPOSTAB( 3 )
                                    - 1 );

            IF    LSSUBSECTION = '#N/A'
               OR LSSUBSECTION IS NULL
            THEN
               LNSUBSECTION := 0;
            ELSE
               LNSUBSECTION := TO_NUMBER( LSSUBSECTION );
            END IF;

            LSATTACHEDPARTNO := SUBSTR( LSDATA,
                                          LTPOSTAB( 4 )
                                        + 1,
                                          LTPOSTAB( 5 )
                                        - LTPOSTAB( 4 )
                                        - 1 );
            LNRETVAL := VALIDATEFIELD( 'Attached Part No',
                                       LSATTACHEDPARTNO );
            LNATTACHEDREVISION := TO_NUMBER( SUBSTR( LSDATA,
                                                       LTPOSTAB( 5 )
                                                     + 1,
                                                       LENGTH( LSDATA )
                                                     - LTPOSTAB( 5 ) ) );
            LNRETVAL := ADDATTACHEDSPEC( LSPARTNO,
                                         LNREVISION,
                                         LNSECTION,
                                         LNSUBSECTION,
                                         LSATTACHEDPARTNO,
                                         LNATTACHEDREVISION );

            
            
            
            
            
            
            

            
            
            IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               COMMIT;
            ELSE
               ROLLBACK;
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
            END IF;
            
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LBENDOFFILE := TRUE;
            WHEN OTHERS
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTNOTINSERTEDGEN,
                                                           LSPARTNO,
                                                           SQLERRM ) );
         END;
      END LOOP;

      
      UTL_FILE.FCLOSE( LRFILEHANDLE );
      
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNISJOBID );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END IMPORTATTACHEDSPECIFICATION;

   
   FUNCTION IMPORTBOM(
      ASDIRECTORY                IN       IAPITYPE.STRINGVAL_TYPE,
      ASFILE                     IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LBENDOFFILE                   IAPITYPE.LOGICAL_TYPE;
      LNALTERNATIVE                 IAPITYPE.BOMALTERNATIVE_TYPE;
      LNALTERNATIVEPRIORITY         IAPITYPE.BOMITEMALTPRIORITY_TYPE;
      LNBASEQUANTITY                IAPITYPE.BOMQUANTITY_TYPE;
      LNBOMUSAGE                    IAPITYPE.BOMUSAGE_TYPE;
      LNCOMPONENTREVISION           IAPITYPE.BOMCOMPONENTREVISION_TYPE;
      LNCOMPONENTSCRAP              IAPITYPE.BOMCOMPONENTSCRAP_TYPE;
      LNCONVFACTOR                  IAPITYPE.BOMCONVFACTOR_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE := 1;
      LNFIELDID                     IAPITYPE.NUMVAL_TYPE;
      LNHEADERID                    IAPITYPE.ID_TYPE;
      LNITEMNUMBER                  IAPITYPE.BOMITEMNUMBER_TYPE;
      LNLEADTIMEOFFSET              IAPITYPE.BOMLEADTIMEOFFSET_TYPE;
      LNMAKEUP                      IAPITYPE.BOMMAKEUP_TYPE;
      LNMAXQTY                      IAPITYPE.BOMMAXQTY_TYPE;
      LNMINQTY                      IAPITYPE.BOMMINQTY_TYPE;
      LNOPERATIONALSTEP             IAPITYPE.BOMOPERATIONALSTEP_TYPE;
      LNQUANTITY                    IAPITYPE.BOMQUANTITY_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LNYELD                        IAPITYPE.BOMYIELD_TYPE;
      LRFILEHANDLE                  IAPITYPE.FILE_TYPE;
      LSACTION                      IAPITYPE.ACTION_TYPE;
      LSALTERNATIVE                 VARCHAR2( 4 );
      LSALTERNATIVEGROUP            IAPITYPE.BOMITEMALTGROUP_TYPE;
      LSBOMITEMTYPE                 IAPITYPE.BOMITEMTYPE_TYPE;
      LSBULKMATERIAL                IAPITYPE.STRING_TYPE;
      LSCHARSTRING                  IAPITYPE.INFO_TYPE;
      LSCODE                        IAPITYPE.BOMITEMCODE_TYPE;
      LSCOMPONENTPART               IAPITYPE.PARTNO_TYPE;
      LSCOMPONENTPLANT              IAPITYPE.PLANTNO_TYPE;
      LSDATA                        IAPITYPE.INFO_TYPE;
      LSDATAUNICODE                 IAPITYPE.UNICODEINFO_TYPE;
      LSFIXEDQTY                    IAPITYPE.STRING_TYPE;
      LSHEADERCALCFLAG              IAPITYPE.BOMHEADERCALCFLAG_TYPE;
      LSHEADERDESCRIPTION           IAPITYPE.DESCRIPTION_TYPE;
      LSHEADERID                    VARCHAR2( 10 );
      LSINTLEQUIVALENT              IAPITYPE.PARTNO_TYPE;
      LSISSUELOCATION               IAPITYPE.ISSUELOCATION_TYPE;
      LSITEMCALCFLAG                IAPITYPE.BOMITEMCALCFLAG_TYPE;
      LSITEMCATEGORY                IAPITYPE.BOMITEMCATEGORY_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ImportBom';
      LSNUMSTRING                   IAPITYPE.INFO_TYPE;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LSPLANT                       IAPITYPE.PLANTNO_TYPE;
      LSRELEVANCYTOCOSTING          IAPITYPE.STRING_TYPE;
      LSTOUNIT                      IAPITYPE.BASETOUNIT_TYPE;
      LSUOM                         IAPITYPE.BASEUOM_TYPE;
      LSVALUE                       IAPITYPE.STRING_TYPE;
      LTPOSTAB                      IAPITYPE.NUMBERTAB_TYPE;
      LNISJOBID                     IAPITYPE.ID_TYPE;
      LNBOMCOUNT                    IAPITYPE.NUMVAL_TYPE := 1;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPIJOBLOGGING.STARTJOB(    GSSOURCE
                                           || '.'
                                           || LSMETHOD,
                                           LNISJOBID );

      
      BEGIN
         LRFILEHANDLE := UTL_FILE.FOPEN_NCHAR( ASDIRECTORY,
                                               ASFILE,
                                               'r' );
         LBENDOFFILE := FALSE;
      EXCEPTION
         WHEN OTHERS
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_UNABLETOOPENFILE,
                                                           ASDIRECTORY
                                                        || '\'
                                                        || ASFILE,
                                                        SQLERRM ) );
      END;

      WHILE NOT LBENDOFFILE
      LOOP
         BEGIN
            
            
            

            
            UTL_FILE.GET_LINE_NCHAR( LRFILEHANDLE,
                                     LSDATAUNICODE );

            IF LNCOUNT = 1
            THEN
               LSDATA := SUBSTR( LSDATAUNICODE,
                                 2 );
            ELSE
               LSDATA := LSDATAUNICODE;
            END IF;

            LNCOUNT :=   LNCOUNT
                       + 1;

            
            FOR LL_I IN 1 .. 36
            LOOP
               LTPOSTAB( LL_I ) := INSTR( LSDATA,
                                          CHR( 9 ),
                                          1,
                                          LL_I );
            END LOOP;

            IF LTPOSTAB( 1 ) = 0
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_FILEERRORNOTAB ) );
            END IF;

            LNRETVAL := MANIPULATELINE( LSDATA,
                                        LTPOSTAB );

            FOR LL_I IN 1 .. 36
            LOOP
               LTPOSTAB( LL_I ) := INSTR( LSDATA,
                                          CHR( 9 ),
                                          1,
                                          LL_I );
            END LOOP;

            LNFIELDID := 1;
            LSPARTNO := NULL;
            LSPARTNO := SUBSTR( LSDATA,
                                1,
                                  LTPOSTAB( 1 )
                                - 1 );
            LNRETVAL := VALIDATEFIELD( 'Part No',
                                       LSPARTNO );
            LNFIELDID := 2;
            LSNUMSTRING := SUBSTR( LSDATA,
                                     LTPOSTAB( 1 )
                                   + 1,
                                     LTPOSTAB( 2 )
                                   - LTPOSTAB( 1 )
                                   - 1 );
            LNRETVAL := IAPIGENERAL.ISNUMERIC( LSNUMSTRING );

            IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               ROLLBACK;
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                           IAPIGENERAL.GETLASTERRORTEXT( ),
                                                           LSPARTNO,
                                                           LNFIELDID ) );
            END IF;

            LNREVISION := TO_NUMBER( LSNUMSTRING );
            LNFIELDID := 3;
            LSPLANT := SUBSTR( LSDATA,
                                 LTPOSTAB( 2 )
                               + 1,
                                 LTPOSTAB( 3 )
                               - LTPOSTAB( 2 )
                               - 1 );
            LNFIELDID := 4;
            LSALTERNATIVE := SUBSTR( LSDATA,
                                       LTPOSTAB( 3 )
                                     + 1,
                                       LTPOSTAB( 4 )
                                     - LTPOSTAB( 3 )
                                     - 1 );

            IF LSALTERNATIVE = '#N/A'
            THEN
               LNALTERNATIVE := 1;
            ELSE
               LNRETVAL := IAPIGENERAL.ISNUMERIC( LSALTERNATIVE );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;

               LNALTERNATIVE := TO_NUMBER( LSALTERNATIVE );
            END IF;

            
            LNFIELDID := 5;
            LSNUMSTRING := SUBSTR( LSDATA,
                                     LTPOSTAB( 4 )
                                   + 1,
                                     LTPOSTAB( 5 )
                                   - LTPOSTAB( 4 )
                                   - 1 );
            LNRETVAL := IAPIGENERAL.ISNUMERIC( LSNUMSTRING );

            IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               ROLLBACK;
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                           IAPIGENERAL.GETLASTERRORTEXT( ),
                                                           LSPARTNO,
                                                           LNFIELDID ) );
            END IF;

            LNBASEQUANTITY := TO_NUMBER( LSNUMSTRING );
            LNFIELDID := 6;
            LSCOMPONENTPART := SUBSTR( LSDATA,
                                         LTPOSTAB( 5 )
                                       + 1,
                                         LTPOSTAB( 6 )
                                       - LTPOSTAB( 5 )
                                       - 1 );
            LNRETVAL := VALIDATEFIELD( 'Component',
                                       LSCOMPONENTPART );
            LNFIELDID := 7;
            LSNUMSTRING := SUBSTR( LSDATA,
                                     LTPOSTAB( 6 )
                                   + 1,
                                     LTPOSTAB( 7 )
                                   - LTPOSTAB( 6 )
                                   - 1 );
            LNRETVAL := IAPIGENERAL.ISNUMERIC( LSNUMSTRING );

            IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               ROLLBACK;
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                           IAPIGENERAL.GETLASTERRORTEXT( ),
                                                           LSPARTNO,
                                                           LNFIELDID ) );
            END IF;

            LNITEMNUMBER := TO_NUMBER( LSNUMSTRING );
            LNFIELDID := 8;
            LSCHARSTRING := SUBSTR( LSDATA,
                                      LTPOSTAB( 7 )
                                    + 1,
                                      LTPOSTAB( 8 )
                                    - LTPOSTAB( 7 )
                                    - 1 );

            IF LSCHARSTRING IS NOT NULL
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( LSCHARSTRING,
                                                      4 );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;
            END IF;

            LSITEMCATEGORY := LSCHARSTRING;
            LNFIELDID := 9;
            LSNUMSTRING := SUBSTR( LSDATA,
                                     LTPOSTAB( 8 )
                                   + 1,
                                     LTPOSTAB( 9 )
                                   - LTPOSTAB( 8 )
                                   - 1 );
            LNRETVAL := IAPIGENERAL.ISNUMERIC( LSNUMSTRING );

            IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               ROLLBACK;
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                           IAPIGENERAL.GETLASTERRORTEXT( ),
                                                           LSPARTNO,
                                                           LNFIELDID ) );
            END IF;

            LNQUANTITY := TO_NUMBER( LSNUMSTRING );
            LNFIELDID := 10;
            LSCHARSTRING := SUBSTR( LSDATA,
                                      LTPOSTAB( 9 )
                                    + 1,
                                      LTPOSTAB( 10 )
                                    - LTPOSTAB( 9 )
                                    - 1 );

            IF LSCHARSTRING IS NOT NULL
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( LSCHARSTRING,
                                                      3 );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;
            END IF;

            LSUOM := LSCHARSTRING;
            LNFIELDID := 11;
            LSNUMSTRING := SUBSTR( LSDATA,
                                     LTPOSTAB( 10 )
                                   + 1,
                                     LTPOSTAB( 11 )
                                   - LTPOSTAB( 10 )
                                   - 1 );
            LNRETVAL := IAPIGENERAL.ISNUMERIC( LSNUMSTRING );

            IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               ROLLBACK;
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                           IAPIGENERAL.GETLASTERRORTEXT( ),
                                                           LSPARTNO,
                                                           LNFIELDID ) );
            END IF;

            LNCOMPONENTSCRAP := TO_NUMBER( LSNUMSTRING );
            LNFIELDID := 12;
            LSCHARSTRING := SUBSTR( LSDATA,
                                      LTPOSTAB( 11 )
                                    + 1,
                                      LTPOSTAB( 12 )
                                    - LTPOSTAB( 11 )
                                    - 1 );

            IF LSCHARSTRING IS NOT NULL
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( LSCHARSTRING,
                                                      8 );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;
            END IF;

            LSCOMPONENTPLANT := LSCHARSTRING;
            LNFIELDID := 13;
            LSNUMSTRING := SUBSTR( LSDATA,
                                     LTPOSTAB(   LNFIELDID
                                               - 1 )
                                   + 1,
                                     LTPOSTAB( LNFIELDID )
                                   - LTPOSTAB(   LNFIELDID
                                               - 1 )
                                   - 1 );
            LNRETVAL := IAPIGENERAL.ISNUMERIC( LSNUMSTRING );

            IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               ROLLBACK;
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                           IAPIGENERAL.GETLASTERRORTEXT( ),
                                                           LSPARTNO,
                                                           LNFIELDID ) );
            END IF;

            LNCONVFACTOR := TO_NUMBER( LSNUMSTRING );
            LNFIELDID := 14;
            LSCHARSTRING := SUBSTR( LSDATA,
                                      LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    + 1,
                                      LTPOSTAB( LNFIELDID )
                                    - LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    - 1 );

            IF LSCHARSTRING IS NOT NULL
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( LSCHARSTRING,
                                                      3 );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;
            END IF;

            LSTOUNIT := LSCHARSTRING;
            LNFIELDID := 15;
            LSNUMSTRING := SUBSTR( LSDATA,
                                     LTPOSTAB(   LNFIELDID
                                               - 1 )
                                   + 1,
                                     LTPOSTAB( LNFIELDID )
                                   - LTPOSTAB(   LNFIELDID
                                               - 1 )
                                   - 1 );
            LNRETVAL := IAPIGENERAL.ISNUMERIC( LSNUMSTRING );

            IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               ROLLBACK;
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                           IAPIGENERAL.GETLASTERRORTEXT( ),
                                                           LSPARTNO,
                                                           LNFIELDID ) );
            END IF;

            LNYELD := TO_NUMBER( LSNUMSTRING );
            LNFIELDID := 16;
            LSNUMSTRING := SUBSTR( LSDATA,
                                     LTPOSTAB(   LNFIELDID
                                               - 1 )
                                   + 1,
                                     LTPOSTAB( LNFIELDID )
                                   - LTPOSTAB(   LNFIELDID
                                               - 1 )
                                   - 1 );
            LNRETVAL := IAPIGENERAL.ISNUMERIC( LSNUMSTRING );

            IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               ROLLBACK;
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                           IAPIGENERAL.GETLASTERRORTEXT( ),
                                                           LSPARTNO,
                                                           LNFIELDID ) );
            END IF;

            LNLEADTIMEOFFSET := TO_NUMBER( LSNUMSTRING );
            LNFIELDID := 17;
            LSCHARSTRING := SUBSTR( LSDATA,
                                      LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    + 1,
                                      LTPOSTAB( LNFIELDID )
                                    - LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    - 1 );

            IF LSCHARSTRING IS NOT NULL
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( LSCHARSTRING,
                                                      1 );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;
            END IF;

            LSRELEVANCYTOCOSTING := LSCHARSTRING;
            LNFIELDID := 18;
            LSCHARSTRING := SUBSTR( LSDATA,
                                      LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    + 1,
                                      LTPOSTAB( LNFIELDID )
                                    - LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    - 1 );

            IF LSCHARSTRING IS NOT NULL
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( LSCHARSTRING,
                                                      1 );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;
            END IF;

            LSBULKMATERIAL := LSCHARSTRING;
            LNFIELDID := 19;
            LSCHARSTRING := SUBSTR( LSDATA,
                                      LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    + 1,
                                      LTPOSTAB( LNFIELDID )
                                    - LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    - 1 );

            IF LSCHARSTRING IS NOT NULL
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( LSCHARSTRING,
                                                      4 );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;
            END IF;

            LSISSUELOCATION := LSCHARSTRING;
            LNFIELDID := 20;
            LSCHARSTRING := SUBSTR( LSDATA,
                                      LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    + 1,
                                      LTPOSTAB( LNFIELDID )
                                    - LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    - 1 );

            IF LSCHARSTRING IS NOT NULL
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( LSCHARSTRING,
                                                      2 );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;
            END IF;

            LSITEMCALCFLAG := LSCHARSTRING;
            LSITEMCALCFLAG := NVL( LSITEMCALCFLAG,
                                   'N' );
            LNFIELDID := 21;
            LSCHARSTRING := SUBSTR( LSDATA,
                                      LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    + 1,
                                      LTPOSTAB( LNFIELDID )
                                    - LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    - 1 );

            IF LSCHARSTRING IS NOT NULL
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( LSCHARSTRING,
                                                      5 );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;
            END IF;

            LSBOMITEMTYPE := LSCHARSTRING;
            LNFIELDID := 22;
            LSNUMSTRING := SUBSTR( LSDATA,
                                     LTPOSTAB(   LNFIELDID
                                               - 1 )
                                   + 1,
                                     LTPOSTAB( LNFIELDID )
                                   - LTPOSTAB(   LNFIELDID
                                               - 1 )
                                   - 1 );
            LNRETVAL := IAPIGENERAL.ISNUMERIC( LSNUMSTRING );

            IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               ROLLBACK;
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                           IAPIGENERAL.GETLASTERRORTEXT( ),
                                                           LSPARTNO,
                                                           LNFIELDID ) );
            END IF;

            LNOPERATIONALSTEP := TO_NUMBER( LSNUMSTRING );
            LNFIELDID := 23;
            LSNUMSTRING := SUBSTR( LSDATA,
                                     LTPOSTAB(   LNFIELDID
                                               - 1 )
                                   + 1,
                                     LTPOSTAB( LNFIELDID )
                                   - LTPOSTAB(   LNFIELDID
                                               - 1 )
                                   - 1 );
            LNRETVAL := IAPIGENERAL.ISNUMERIC( LSNUMSTRING );

            IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               ROLLBACK;
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                           IAPIGENERAL.GETLASTERRORTEXT( ),
                                                           LSPARTNO,
                                                           LNFIELDID ) );
            END IF;

            LNMINQTY := TO_NUMBER( LSNUMSTRING );
            LNFIELDID := 24;
            LSNUMSTRING := SUBSTR( LSDATA,
                                     LTPOSTAB(   LNFIELDID
                                               - 1 )
                                   + 1,
                                     LTPOSTAB( LNFIELDID )
                                   - LTPOSTAB(   LNFIELDID
                                               - 1 )
                                   - 1 );
            LNRETVAL := IAPIGENERAL.ISNUMERIC( LSNUMSTRING );

            IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               ROLLBACK;
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                           IAPIGENERAL.GETLASTERRORTEXT( ),
                                                           LSPARTNO,
                                                           LNFIELDID ) );
            END IF;

            LNMAXQTY := TO_NUMBER( LSNUMSTRING );
            LNFIELDID := 25;
            LSCHARSTRING := SUBSTR( LSDATA,
                                      LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    + 1,
                                      LTPOSTAB( LNFIELDID )
                                    - LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    - 1 );

            IF LSCHARSTRING IS NOT NULL
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( LSCHARSTRING,
                                                      2 );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;
            END IF;

            LSHEADERCALCFLAG := LSCHARSTRING;
            LSHEADERCALCFLAG := NVL( LSHEADERCALCFLAG,
                                     'N' );
            LNFIELDID := 26;
            LSCHARSTRING := SUBSTR( LSDATA,
                                      LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    + 1,
                                      LTPOSTAB( LNFIELDID )
                                    - LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    - 1 );

            IF LSCHARSTRING IS NOT NULL
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( LSCHARSTRING,
                                                      60 );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;
            END IF;

            LSHEADERDESCRIPTION := LSCHARSTRING;
            LNFIELDID := 27;
            LSCHARSTRING := SUBSTR( LSDATA,
                                      LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    + 1,
                                      LTPOSTAB( LNFIELDID )
                                    - LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    - 1 );

            IF LSCHARSTRING IS NOT NULL
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( LSCHARSTRING,
                                                      6 );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;
            END IF;

            LSCODE := LSCHARSTRING;
            LNFIELDID := 28;
            LSNUMSTRING := SUBSTR( LSDATA,
                                     LTPOSTAB( 27 )
                                   + 1,
                                     LTPOSTAB( 28 )
                                   - LTPOSTAB( 27 )
                                   - 1 );
            LNRETVAL := IAPIGENERAL.ISNUMERIC( LSNUMSTRING );

            IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               ROLLBACK;
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                           IAPIGENERAL.GETLASTERRORTEXT( ),
                                                           LSPARTNO,
                                                           LNFIELDID ) );
            END IF;

            LNBOMUSAGE := TO_NUMBER( LSNUMSTRING );
            LNFIELDID := 29;
            LSCHARSTRING := SUBSTR( LSDATA,
                                      LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    + 1,
                                      LTPOSTAB( LNFIELDID )
                                    - LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    - 1 );

            IF LSCHARSTRING IS NOT NULL
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( LSCHARSTRING,
                                                      60 );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;
            END IF;

            LSALTERNATIVEGROUP := LSCHARSTRING;
            LNFIELDID := 30;
            LSNUMSTRING := SUBSTR( LSDATA,
                                     LTPOSTAB(   LNFIELDID
                                               - 1 )
                                   + 1,
                                     LTPOSTAB( LNFIELDID )
                                   - LTPOSTAB(   LNFIELDID
                                               - 1 )
                                   - 1 );
            LNRETVAL := IAPIGENERAL.ISNUMERIC( LSNUMSTRING );

            IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               ROLLBACK;
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                           IAPIGENERAL.GETLASTERRORTEXT( ),
                                                           LSPARTNO,
                                                           LNFIELDID ) );
            END IF;

            LNALTERNATIVEPRIORITY := TO_NUMBER( LSNUMSTRING );
            LNALTERNATIVEPRIORITY := NVL( LNALTERNATIVEPRIORITY,
                                          1 );
            LNFIELDID := 31;
            LSCHARSTRING := SUBSTR( LSDATA,
                                      LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    + 1,
                                      LTPOSTAB( LNFIELDID )
                                    - LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    - 1 );

            IF LSCHARSTRING IS NOT NULL
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( LSCHARSTRING,
                                                      1 );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;
            END IF;

            LSFIXEDQTY := LSCHARSTRING;
            LNFIELDID := 32;
            LSCHARSTRING := SUBSTR( LSDATA,
                                      LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    + 1,
                                      LTPOSTAB( LNFIELDID )
                                    - LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    - 1 );

            IF LSCHARSTRING IS NOT NULL
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( LSCHARSTRING,
                                                      1 );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;
            END IF;

            LSACTION := LSCHARSTRING;
            LNFIELDID := 33;
            LSHEADERID := SUBSTR( LSDATA,
                                    LTPOSTAB(   LNFIELDID
                                              - 1 )
                                  + 1,
                                    LTPOSTAB( LNFIELDID )
                                  - LTPOSTAB(   LNFIELDID
                                              - 1 )
                                  - 1 );

            IF LSHEADERID = '#N/A'
            THEN
               LNHEADERID := NULL;
            ELSE
               LNRETVAL := IAPIGENERAL.ISNUMERIC( LSHEADERID );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;

               LNHEADERID := TO_NUMBER( LSHEADERID );
            END IF;

            LNFIELDID := 34;
            LSNUMSTRING := SUBSTR( LSDATA,
                                     LTPOSTAB(   LNFIELDID
                                               - 1 )
                                   + 1,
                                     LTPOSTAB( LNFIELDID )
                                   - LTPOSTAB(   LNFIELDID
                                               - 1 )
                                   - 1 );

            IF LSNUMSTRING IS NOT NULL
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( LSNUMSTRING,
                                                      255 );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;

               LSVALUE := LSNUMSTRING;
            ELSE
               LSVALUE := NULL;
            END IF;

            LNFIELDID := 35;
            LSNUMSTRING := SUBSTR( LSDATA,
                                     LTPOSTAB(   LNFIELDID
                                               - 1 )
                                   + 1,
                                     LTPOSTAB( LNFIELDID )
                                   - LTPOSTAB(   LNFIELDID
                                               - 1 )
                                   - 1 );
            LNRETVAL := IAPIGENERAL.ISNUMERIC( LSNUMSTRING );

            IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               ROLLBACK;
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                           IAPIGENERAL.GETLASTERRORTEXT( ),
                                                           LSPARTNO,
                                                           LNFIELDID ) );
            END IF;

            LNMAKEUP := TO_NUMBER( LSNUMSTRING );
            LNFIELDID := 36;
            LSCHARSTRING := SUBSTR( LSDATA,
                                      LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    + 1,
                                      LTPOSTAB( LNFIELDID )
                                    - LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    - 1 );

            IF LSCHARSTRING IS NOT NULL
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( LSCHARSTRING,
                                                      18 );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;
            END IF;

            LSINTLEQUIVALENT := LSCHARSTRING;
            LSFIXEDQTY := NVL( LSFIXEDQTY,
                               'N' );

            
            SELECT COUNT( * )
              INTO LNBOMCOUNT
              FROM BOM_HEADER
             WHERE PART_NO = LSPARTNO
               AND REVISION = LNREVISION
               AND PLANT = LSPLANT
               AND ALTERNATIVE = LNALTERNATIVE
               AND BOM_USAGE = LNBOMUSAGE;

            IF LNBOMCOUNT = 0
            THEN
               LNRETVAL :=
                      ADDBOMHEADER( LSPARTNO,
                                    LNREVISION,
                                    LSPLANT,
                                    LNALTERNATIVE,
                                    LNBOMUSAGE,
                                    LNBASEQUANTITY,
                                    LSHEADERCALCFLAG,
                                    LSHEADERDESCRIPTION );

               
               
               
               
               
               
               
               
               
               

               
               
                IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
                THEN
                    COMMIT;
                ELSE
                    ROLLBACK;
                    IAPIGENERAL.LOGERROR( GSSOURCE,
                                          LSMETHOD,
                                          IAPIGENERAL.GETLASTERRORTEXT( ) );
                END IF;
                
            END IF;

            
            IF LSCOMPONENTPART IS NOT NULL
            THEN
               LNRETVAL :=
                  ADDBOMITEM( LSPARTNO,
                              LNREVISION,
                              LSPLANT,
                              LNALTERNATIVE,
                              LNBOMUSAGE,
                              LNITEMNUMBER,
                              LSCOMPONENTPART,
                              LNCOMPONENTREVISION,
                              LSCOMPONENTPLANT,
                              LNQUANTITY,
                              LSITEMCATEGORY,
                              LNCOMPONENTSCRAP,
                              LSUOM,
                              LSITEMCALCFLAG,
                              LNCONVFACTOR,
                              LSTOUNIT,
                              LNYELD,
                              LNLEADTIMEOFFSET,
                              LSRELEVANCYTOCOSTING,
                              LSBULKMATERIAL,
                              LSISSUELOCATION,
                              LSBOMITEMTYPE,
                              LNOPERATIONALSTEP,
                              LNMINQTY,
                              LNMAXQTY,
                              LSFIXEDQTY,
                              LSCODE,
                              LSALTERNATIVEGROUP,
                              LNALTERNATIVEPRIORITY,
                              LNHEADERID,
                              LSVALUE,
                              LNMAKEUP,
                              LSINTLEQUIVALENT,
                              LSACTION );

               
               
               
               
               
               
               

               
               
                IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
                THEN
                    COMMIT;
                ELSE
                    ROLLBACK;
                    IAPIGENERAL.LOGERROR( GSSOURCE,
                                          LSMETHOD,
                                          IAPIGENERAL.GETLASTERRORTEXT( ) );
                END IF;
                
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LBENDOFFILE := TRUE;
            WHEN OTHERS
            THEN
               ROLLBACK;
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTNOTCREATEDGEN,
                                                           LSPARTNO,
                                                           LNFIELDID,
                                                           SQLERRM ) );
         END;
      END LOOP;

      
      UTL_FILE.FCLOSE( LRFILEHANDLE );
      
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNISJOBID );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END IMPORTBOM;

   
   FUNCTION IMPORTPROPERTY(
      ASDIRECTORY                IN       IAPITYPE.STRINGVAL_TYPE,
      ASFILE                     IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LBENDOFFILE                   IAPITYPE.LOGICAL_TYPE;
      LNATTRIBUTE                   IAPITYPE.ID_TYPE;
      LNALTERNATIVELANGUAGEID       IAPITYPE.LANGUAGEID_TYPE := 1;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE := 1;
      LNFIELDID                     IAPITYPE.NUMVAL_TYPE;
      LNHEADERID                    IAPITYPE.ID_TYPE;
      LNPROPERTY                    IAPITYPE.ID_TYPE;
      LNPROPERTYGROUP               IAPITYPE.ID_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LNSECTION                     IAPITYPE.ID_TYPE;
      LNSUBSECTION                  IAPITYPE.ID_TYPE;
      LRFILEHANDLE                  IAPITYPE.FILE_TYPE;
      LSATTRIBUTE                   VARCHAR2( 10 );
      LSCHARSTRING                  IAPITYPE.INFO_TYPE;
      LSDATA                        IAPITYPE.INFO_TYPE;
      LSDATAUNICODE                 IAPITYPE.UNICODEINFO_TYPE;
      LSHEADER                      VARCHAR2( 10 );
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ImportProperty';
      LSNUMSTRING                   IAPITYPE.INFO_TYPE;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LSPROPERTY                    VARCHAR2( 10 );
      LSPROPERTYGROUP               VARCHAR2( 10 );
      LSSECTION                     VARCHAR2( 10 );
      LSSUBSECTION                  VARCHAR2( 10 );
      LSVALUE                       IAPITYPE.STRING_TYPE;
      LTPOSTAB                      IAPITYPE.NUMBERTAB_TYPE;
      LQERRORS                      IAPITYPE.REF_TYPE;
      LNISJOBID                     IAPITYPE.ID_TYPE;
      LQINFO                        IAPITYPE.REF_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPIJOBLOGGING.STARTJOB(    GSSOURCE
                                           || '.'
                                           || LSMETHOD,
                                           LNISJOBID );

      
      BEGIN
         LRFILEHANDLE := UTL_FILE.FOPEN_NCHAR( ASDIRECTORY,
                                               ASFILE,
                                               'r' );
         LBENDOFFILE := FALSE;
      EXCEPTION
         WHEN OTHERS
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_UNABLETOOPENFILE,
                                                           ASDIRECTORY
                                                        || '\'
                                                        || ASFILE,
                                                        SQLERRM ) );
      END;

      WHILE NOT LBENDOFFILE
      LOOP
         BEGIN




            
            UTL_FILE.GET_LINE_NCHAR( LRFILEHANDLE,
                                     LSDATAUNICODE );

            IF LNCOUNT = 1
            THEN
               LSDATA := SUBSTR( LSDATAUNICODE,
                                 2 );
            ELSE
               LSDATA := LSDATAUNICODE;
            END IF;

            LNCOUNT :=   LNCOUNT
                       + 1;

            
            FOR LL_I IN 1 .. 9
            LOOP
               LTPOSTAB( LL_I ) := INSTR( LSDATA,
                                          CHR( 9 ),
                                          1,
                                          LL_I );
            END LOOP;

            IF LTPOSTAB( 1 ) = 0
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_FILEERRORNOTAB ) );
            END IF;

            LNRETVAL := MANIPULATELINE( LSDATA,
                                        LTPOSTAB );

            FOR LL_I IN 1 .. 9
            LOOP
               LTPOSTAB( LL_I ) := INSTR( LSDATA,
                                          CHR( 9 ),
                                          1,
                                          LL_I );
            END LOOP;

            LNFIELDID := 1;
            LSPARTNO := NULL;
            LSPARTNO := SUBSTR( LSDATA,
                                1,
                                  LTPOSTAB( 1 )
                                - 1 );
            LNRETVAL := VALIDATEFIELD( 'Part No',
                                       LSPARTNO );
            LNFIELDID := 2;
            LSNUMSTRING := SUBSTR( LSDATA,
                                     LTPOSTAB( 1 )
                                   + 1,
                                     LTPOSTAB( 2 )
                                   - LTPOSTAB( 1 )
                                   - 1 );
            LNRETVAL := IAPIGENERAL.ISNUMERIC( LSNUMSTRING );

            IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               ROLLBACK;
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                           IAPIGENERAL.GETLASTERRORTEXT( ),
                                                           LSPARTNO,
                                                           LNFIELDID ) );
            END IF;

            LNREVISION := TO_NUMBER( LSNUMSTRING );
            LNFIELDID := 3;
            LSCHARSTRING := SUBSTR( LSDATA,
                                      LTPOSTAB( 2 )
                                    + 1,
                                      LTPOSTAB( 3 )
                                    - LTPOSTAB( 2 )
                                    - 1 );

            IF LSCHARSTRING IS NOT NULL
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( LSCHARSTRING,
                                                      10 );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;
            END IF;

            LSSECTION := LSCHARSTRING;

            IF LSSECTION = '#N/A'
            THEN
               LNSECTION := 0;
            ELSE
               LNSECTION := TO_NUMBER( LSSECTION );
            END IF;

            LNFIELDID := 4;
            LSCHARSTRING := SUBSTR( LSDATA,
                                      LTPOSTAB( 3 )
                                    + 1,
                                      LTPOSTAB( 4 )
                                    - LTPOSTAB( 3 )
                                    - 1 );

            IF LSCHARSTRING IS NOT NULL
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( LSCHARSTRING,
                                                      10 );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;
            END IF;

            LSSUBSECTION := LSCHARSTRING;

            IF LSSUBSECTION = '#N/A'
            THEN
               LNSUBSECTION := 0;
            ELSE
               LNSUBSECTION := TO_NUMBER( LSSUBSECTION );
            END IF;

            LNFIELDID := 5;
            LSCHARSTRING := SUBSTR( LSDATA,
                                      LTPOSTAB( 4 )
                                    + 1,
                                      LTPOSTAB( 5 )
                                    - LTPOSTAB( 4 )
                                    - 1 );

            IF LSCHARSTRING IS NOT NULL
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( LSCHARSTRING,
                                                      10 );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;
            END IF;

            LSPROPERTYGROUP := LSCHARSTRING;

            IF LSPROPERTYGROUP = '#N/A'
            THEN
               LNPROPERTYGROUP := 0;
            ELSE
               LNPROPERTYGROUP := TO_NUMBER( LSPROPERTYGROUP );
            END IF;

            LNFIELDID := 6;
            LSCHARSTRING := SUBSTR( LSDATA,
                                      LTPOSTAB( 5 )
                                    + 1,
                                      LTPOSTAB( 6 )
                                    - LTPOSTAB( 5 )
                                    - 1 );

            IF LSCHARSTRING IS NOT NULL
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( LSCHARSTRING,
                                                      10 );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;
            END IF;

            LSPROPERTY := LSCHARSTRING;

            IF LSPROPERTY = '#N/A'
            THEN
               LNPROPERTY := 0;
            ELSE
               LNPROPERTY := TO_NUMBER( LSPROPERTY );
            END IF;

            LNFIELDID := 7;
            LSCHARSTRING := SUBSTR( LSDATA,
                                      LTPOSTAB( 6 )
                                    + 1,
                                      LTPOSTAB( 7 )
                                    - LTPOSTAB( 6 )
                                    - 1 );

            IF LSCHARSTRING IS NOT NULL
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( LSCHARSTRING,
                                                      10 );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;
            END IF;

            LSATTRIBUTE := LSCHARSTRING;

            IF LSATTRIBUTE = '#N/A'
            THEN
               LNATTRIBUTE := 0;
            ELSE
               LNATTRIBUTE := TO_NUMBER( LSATTRIBUTE );
            END IF;

            LNFIELDID := 8;
            LSCHARSTRING := SUBSTR( LSDATA,
                                      LTPOSTAB( 7 )
                                    + 1,
                                      LTPOSTAB( 8 )
                                    - LTPOSTAB( 7 )
                                    - 1 );

            IF LSCHARSTRING IS NOT NULL
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( LSCHARSTRING,
                                                      10 );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;
            END IF;

            LSHEADER := LSCHARSTRING;

            IF LSHEADER = '#N/A'
            THEN
               LNHEADERID := 0;
            ELSE
               LNHEADERID := TO_NUMBER( LSHEADER );
            END IF;

            LNFIELDID := 9;
            LSCHARSTRING := SUBSTR( LSDATA,
                                      LTPOSTAB( 8 )
                                    + 1,
                                      LTPOSTAB( 9 )
                                    - LTPOSTAB( 8 )
                                    - 1 );

            IF LSCHARSTRING IS NOT NULL
            THEN
               IF LENGTH( LSCHARSTRING ) > 256
               THEN
                  LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                  LSMETHOD,
                                                                  IAPICONSTANTDBERROR.DBERR_NOTVALIDSTRING,
                                                                  256 );
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;
            END IF;

            LSVALUE := LSCHARSTRING;


            LNFIELDID := 10;
            LSCHARSTRING := SUBSTR( LSDATA,
                                      LTPOSTAB( 9 )
                                    + 1,
                                      LENGTH( LSDATA )
                                    - LTPOSTAB( 9 ) );

            IF     LSCHARSTRING IS NOT NULL
               AND LSCHARSTRING <> '#N/A'
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( LSCHARSTRING,
                                                      3 );

               IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTERROR,
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              LSPARTNO,
                                                              LNFIELDID ) );
               END IF;
            END IF;

            IF LSCHARSTRING = '#N/A'
            THEN
               LNALTERNATIVELANGUAGEID := 1;
            ELSE
               LNALTERNATIVELANGUAGEID := TO_NUMBER( LSCHARSTRING );
            END IF;

            
            IF LNSUBSECTION IS NULL
            THEN
               LNSUBSECTION := 0;
            END IF;

            IF LNPROPERTYGROUP IS NULL
            THEN
               LNPROPERTYGROUP := 0;
            END IF;

            IF LNATTRIBUTE IS NULL
            THEN
               LNATTRIBUTE := 0;
            END IF;

            IF LNALTERNATIVELANGUAGEID IS NULL
            THEN
               LNALTERNATIVELANGUAGEID := 1;
            END IF;

            LNRETVAL :=
               IAPISPECIFICATIONPROPERTYGROUP.SAVEADDPROPERTY( LSPARTNO,
                                                               LNREVISION,
                                                               LNSECTION,
                                                               LNSUBSECTION,
                                                               LNPROPERTYGROUP,
                                                               LNPROPERTY,
                                                               LNATTRIBUTE,
                                                               LNHEADERID,
                                                               LSVALUE,
                                                               LNALTERNATIVELANGUAGEID,
                                                               LQINFO,
                                                               LQERRORS );

            
            
            
            
            
            
            

            
           
            IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
                COMMIT;
            ELSE
                ROLLBACK;
                IAPIGENERAL.LOGERROR( GSSOURCE,
                                      LSMETHOD,
                                      IAPIGENERAL.GETLASTERRORTEXT( ) );
            END IF;
            
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LBENDOFFILE := TRUE;
            WHEN OTHERS
            THEN
               ROLLBACK;
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTNOTCREATEDGEN,
                                                           LSPARTNO,
                                                           LNFIELDID,
                                                           SQLERRM ) );
         END;
      END LOOP;

      
      UTL_FILE.FCLOSE( LRFILEHANDLE );
      
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNISJOBID );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END IMPORTPROPERTY;

   
   FUNCTION IMPORTFREETEXT(
      ASDIRECTORY                IN       IAPITYPE.STRINGVAL_TYPE,
      ASFILE                     IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LBENDOFFILE                   IAPITYPE.LOGICAL_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE := 1;
      LNFIELDID                     IAPITYPE.NUMVAL_TYPE;
      LNPREVREVISION                IAPITYPE.REVISION_TYPE;
      LNPREVSECTION                 IAPITYPE.ID_TYPE;
      LNPREVSUBSECTION              IAPITYPE.ID_TYPE;
      LNPREVIOUSTEXTTYPE            IAPITYPE.NUMVAL_TYPE;
      LNTEXTTYPE                    IAPITYPE.NUMVAL_TYPE;
      LNRETCODE                     IAPITYPE.NUMVAL_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LNSECTION                     IAPITYPE.ID_TYPE;
      LNSUBSECTION                  IAPITYPE.ID_TYPE;
      LRFILEHANDLE                  IAPITYPE.FILE_TYPE;
      LSDATA                        IAPITYPE.INFO_TYPE;
      LSDATAUNICODE                 IAPITYPE.UNICODEINFO_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ImportFreeText';
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LSPREVPARTNO                  IAPITYPE.PARTNO_TYPE;
      LSPREVTEXT                    IAPITYPE.SPECTEXTTEXT_TYPE;
      LSTEXTTYPE                    VARCHAR2( 60 );
      LSSECTION                     VARCHAR2( 60 );
      LSSUBSECTION                  VARCHAR2( 60 );
      LSTEXT                        IAPITYPE.SPECTEXTTEXT_TYPE;
      LTPOSTAB                      IAPITYPE.NUMBERTAB_TYPE;
      LNISJOBID                     IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPIJOBLOGGING.STARTJOB(    GSSOURCE
                                           || '.'
                                           || LSMETHOD,
                                           LNISJOBID );
      LNPREVIOUSTEXTTYPE := NULL;
      LSPREVPARTNO := NULL;
      LSPREVTEXT := '';

      
      BEGIN
         LRFILEHANDLE := UTL_FILE.FOPEN_NCHAR( ASDIRECTORY,
                                               ASFILE,
                                               'r' );
      EXCEPTION
         WHEN OTHERS
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_UNABLETOOPENFILE,
                                                           ASDIRECTORY
                                                        || '\'
                                                        || ASFILE,
                                                        SQLERRM ) );
      END;

      LBENDOFFILE := FALSE;

      WHILE NOT LBENDOFFILE
      LOOP
         BEGIN




            
            UTL_FILE.GET_LINE_NCHAR( LRFILEHANDLE,
                                     LSDATAUNICODE );

            IF LNCOUNT = 1
            THEN
               LSDATA := SUBSTR( LSDATAUNICODE,
                                 2 );
            ELSE
               LSDATA := LSDATAUNICODE;
            END IF;

            LNCOUNT :=   LNCOUNT
                       + 1;

            
            FOR LL_I IN 1 .. 5
            LOOP
               LTPOSTAB( LL_I ) := INSTR( LSDATA,
                                          CHR( 9 ),
                                          1,
                                          LL_I );
            END LOOP;

            IF LTPOSTAB( 1 ) = 0
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_FILEERRORNOTAB ) );
            END IF;

            LNRETVAL := MANIPULATELINE( LSDATA,
                                        LTPOSTAB );

            FOR LL_I IN 1 .. 5
            LOOP
               LTPOSTAB( LL_I ) := INSTR( LSDATA,
                                          CHR( 9 ),
                                          1,
                                          LL_I );
            END LOOP;

            LNFIELDID := 1;
            LSPARTNO := NULL;
            LSPARTNO := SUBSTR( LSDATA,
                                1,
                                  LTPOSTAB( 1 )
                                - 1 );
            LNRETVAL := VALIDATEFIELD( 'Part No',
                                       LSPARTNO );

            IF LSPREVPARTNO IS NULL
            THEN
               LSPREVPARTNO := LSPARTNO;
            END IF;

            LNFIELDID := 2;
            LNREVISION := TO_NUMBER( SUBSTR( LSDATA,
                                               LTPOSTAB( 1 )
                                             + 1,
                                               LTPOSTAB( 2 )
                                             - LTPOSTAB( 1 )
                                             - 1 ) );

            IF LNPREVREVISION IS NULL
            THEN
               LNPREVREVISION := LNREVISION;
            END IF;

            LNFIELDID := 3;
            LSSECTION := SUBSTR( LSDATA,
                                   LTPOSTAB( 2 )
                                 + 1,
                                   LTPOSTAB( 3 )
                                 - LTPOSTAB( 2 )
                                 - 1 );

            IF LSSECTION = '#N/A'
            THEN
               LNSECTION := 0;
            ELSE
               LNSECTION := TO_NUMBER( LSSECTION );
            END IF;

            IF LNPREVSECTION IS NULL
            THEN
               LNPREVSECTION := LNSECTION;
            END IF;

            LNFIELDID := 4;
            LSSUBSECTION := SUBSTR( LSDATA,
                                      LTPOSTAB( 3 )
                                    + 1,
                                      LTPOSTAB( 4 )
                                    - LTPOSTAB( 3 )
                                    - 1 );

            IF    LSSUBSECTION = '#N/A'
               OR LSSUBSECTION IS NULL
            THEN
               LNSUBSECTION := 0;
            ELSE
               LNSUBSECTION := TO_NUMBER( LSSUBSECTION );
            END IF;

            IF LNPREVSUBSECTION IS NULL
            THEN
               LNPREVSUBSECTION := LNSUBSECTION;
            END IF;

            LNFIELDID := 5;
            LSTEXTTYPE := SUBSTR( LSDATA,
                                    LTPOSTAB( 4 )
                                  + 1,
                                    LTPOSTAB( 5 )
                                  - LTPOSTAB( 4 )
                                  - 1 );

            IF LSTEXTTYPE = '#N/A'
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTNOTUPDATEDISNA,
                                                           LSPARTNO,
                                                           'Text Type ' ) );
            ELSE
               LNTEXTTYPE := TO_NUMBER( LSTEXTTYPE );
            END IF;

            IF LNPREVIOUSTEXTTYPE IS NULL
            THEN
               LNPREVIOUSTEXTTYPE := LNTEXTTYPE;
            END IF;

            IF    LSPREVPARTNO <> LSPARTNO
               OR LNPREVREVISION <> LNREVISION
               OR LNPREVSECTION <> LNSECTION
               OR LNPREVSUBSECTION <> LNSUBSECTION
               OR LNPREVIOUSTEXTTYPE <> LNTEXTTYPE
            THEN
               IF LNPREVIOUSTEXTTYPE = -1
               THEN
                  LNRETVAL := ADDREASONFORISSUE( LSPREVPARTNO,
                                                 LNPREVREVISION,
                                                 LSTEXT );
               ELSE
                  LNRETVAL := ADDFREETEXT( LSPREVPARTNO,
                                           LNPREVREVISION,
                                           LNPREVSECTION,
                                           LNPREVSUBSECTION,
                                           LNPREVIOUSTEXTTYPE,
                                           LSTEXT );
               END IF;

               
               
               
               
               
               
               

               
               
                IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
                THEN
                    COMMIT;
                ELSE
                    ROLLBACK;
                    IAPIGENERAL.LOGERROR( GSSOURCE,
                                          LSMETHOD,
                                          IAPIGENERAL.GETLASTERRORTEXT( ) );
                END IF;
                

               LSTEXT := '';
            END IF;

            LNFIELDID := 6;

            IF    LSTEXT = ''
               OR LSTEXT IS NULL
            THEN
               LSTEXT := SUBSTR( LSDATA,
                                   LTPOSTAB( 5 )
                                 + 1,
                                   LENGTH( LSDATA )
                                 - LTPOSTAB( 5 ) );
            ELSE
               LSTEXT :=    LSTEXT
                         || CHR( 13 )
                         || CHR( 10 )
                         || SUBSTR( LSDATA,
                                      LTPOSTAB( 5 )
                                    + 1,
                                      LENGTH( LSDATA )
                                    - LTPOSTAB( 5 ) );
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LBENDOFFILE := TRUE;
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                        LSPARTNO
                                     || ' not inserted -> general Error: (field :'
                                     || LNFIELDID
                                     || ')  '
                                     || SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTNOTCREATEDGEN,
                                                           LSPARTNO,
                                                           LNFIELDID,
                                                           SQLERRM ) );
         END;

         LSPREVPARTNO := LSPARTNO;
         LNPREVREVISION := LNREVISION;
         LNPREVIOUSTEXTTYPE := LNTEXTTYPE;
         LNPREVSECTION := LNSECTION;
         LNPREVSUBSECTION := LNSUBSECTION;
      END LOOP;

      BEGIN
         IF LNTEXTTYPE = -1
         THEN
            LNRETVAL := ADDREASONFORISSUE( LSPARTNO,
                                           LNREVISION,
                                           LSTEXT );
         ELSE
            LNRETVAL := ADDFREETEXT( LSPARTNO,
                                     LNREVISION,
                                     LNSECTION,
                                     LNSUBSECTION,
                                     LNTEXTTYPE,
                                     LSTEXT );
         END IF;

         
         
         
         
         
         
         
         
         
         

         
         
          IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
          THEN
              COMMIT;
          ELSE
              ROLLBACK;
              IAPIGENERAL.LOGERROR( GSSOURCE,
                                    LSMETHOD,
                                    IAPIGENERAL.GETLASTERRORTEXT( ) );
          END IF;
          
      EXCEPTION
         WHEN OTHERS
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_PARTNOTCREATEDGEN,
                                                        LSPARTNO,
                                                        LNFIELDID,
                                                        SQLERRM ) );
      END;

      
      UTL_FILE.FCLOSE( LRFILEHANDLE );
      
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNISJOBID );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END IMPORTFREETEXT;

   
   FUNCTION IMPORTCLASSIFICATIONTREEVIEW(
      ASDIRECTORY                IN       IAPITYPE.STRINGVAL_TYPE,
      ASFILE                     IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LBENDOFFILE                   IAPITYPE.LOGICAL_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE := 1;
      LNMATERIALCLASSID             IAPITYPE.MATERIALCLASSID_TYPE;
      LNHIERLEVEL                   IAPITYPE.HIERLEVEL_TYPE;
      LNMAINID                      IAPITYPE.NUMVAL_TYPE;
      LNPREVIOUSLEVEL               IAPITYPE.MATERIALCLASSID_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNTREETYPE                    IAPITYPE.NUMVAL_TYPE;
      LNTREEVIEW                    IAPITYPE.NUMVAL_TYPE;
      LRFILEHANDLE                  IAPITYPE.FILE_TYPE;
      LSDATA                        IAPITYPE.INFO_TYPE;
      LSDATAUNICODE                 IAPITYPE.UNICODEINFO_TYPE;
      LSDESCRIPTOR                  IAPITYPE.STRING_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ImportClassificationTreeView';
      LSNODE                        IAPITYPE.NODE_TYPE;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LSPARTTYPE                    IAPITYPE.CLASS3PARTTYPE_TYPE;
      LSPREVPARTNO                  IAPITYPE.PARTNO_TYPE;
      LSSPECGROUP                   IAPITYPE.SPECGROUP_TYPE;
      LSSUBNODE                     IAPITYPE.NODE_TYPE;
      LSTREETYPE                    IAPITYPE.STRING_TYPE;
      LSVALUE                       IAPITYPE.STRING_TYPE;
      LTPOSTAB                      IAPITYPE.NUMBERTAB_TYPE;
      LNISJOBID                     IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPIJOBLOGGING.STARTJOB(    GSSOURCE
                                           || '.'
                                           || LSMETHOD,
                                           LNISJOBID );
      LSPREVPARTNO := NULL;

      
      BEGIN
         LRFILEHANDLE := UTL_FILE.FOPEN_NCHAR( ASDIRECTORY,
                                               ASFILE,
                                               'r' );
      EXCEPTION
         WHEN OTHERS
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_UNABLETOOPENFILE,
                                                           ASDIRECTORY
                                                        || '\'
                                                        || ASFILE,
                                                        SQLERRM ) );
      END;

      LBENDOFFILE := FALSE;

      WHILE NOT LBENDOFFILE
      LOOP
         BEGIN




            
            UTL_FILE.GET_LINE_NCHAR( LRFILEHANDLE,
                                     LSDATAUNICODE );

            IF LNCOUNT = 1
            THEN
               LSDATA := SUBSTR( LSDATAUNICODE,
                                 2 );
            ELSE
               LSDATA := LSDATAUNICODE;
            END IF;

            LNCOUNT :=   LNCOUNT
                       + 1;

            
            FOR LL_I IN 1 .. 3
            LOOP
               LTPOSTAB( LL_I ) := INSTR( LSDATA,
                                          CHR( 9 ),
                                          1,
                                          LL_I );
            END LOOP;

            IF LTPOSTAB( 1 ) = 0
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_FILEERRORNOTAB ) );
            END IF;

            LNTREEVIEW := 1;
            LSPARTNO := NULL;
            LSPARTNO := SUBSTR( LSDATA,
                                1,
                                  LTPOSTAB( 1 )
                                - 1 );
            LNRETVAL := VALIDATEFIELD( 'Part No',
                                       LSPARTNO );

            IF LSPREVPARTNO IS NULL
            THEN
               LSPREVPARTNO := LSPARTNO;
            END IF;

            LNTREEVIEW := 2;
            LSTREETYPE := SUBSTR( LSDATA,
                                    LTPOSTAB(   LNTREEVIEW
                                              - 1 )
                                  + 1,
                                    LTPOSTAB( LNTREEVIEW )
                                  - LTPOSTAB(   LNTREEVIEW
                                              - 1 )
                                  - 1 );

            IF LSTREETYPE = '#N/A'
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTNOTINSERTEDISNA,
                                                           LSPARTNO,
                                                           'tree type' ) );
            END IF;

            LNTREETYPE := TO_NUMBER( LSTREETYPE );
            LNTREEVIEW := 3;
            LNHIERLEVEL := TO_NUMBER( SUBSTR( LSDATA,
                                                LTPOSTAB(   LNTREEVIEW
                                                          - 1 )
                                              + 1,
                                                LTPOSTAB( LNTREEVIEW )
                                              - LTPOSTAB(   LNTREEVIEW
                                                          - 1 )
                                              - 1 ) );
            LNTREEVIEW := 4;
            LSVALUE := SUBSTR( LSDATA,
                                 LTPOSTAB( 3 )
                               + 1,
                                 LENGTH( LSDATA )
                               - LTPOSTAB( 3 ) );

            IF LSPREVPARTNO <> LSPARTNO
            THEN
               COMMIT;
            END IF;

            
            BEGIN
               SELECT NODE,
                      SPEC_GROUP
                 INTO LSNODE,
                      LSSPECGROUP
                 FROM ITCLD
                WHERE ID = LNTREETYPE;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTNOINFOFORTREETYPE,
                                                              LSPARTNO,
                                                              LNTREETYPE ) );
               WHEN TOO_MANY_ROWS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_TOOMANYROWSTREETYPE,
                                                              ' tree type pick up ',
                                                              LNTREETYPE ) );
            END;

            
            
            BEGIN
               SELECT TYPE
                 INTO LSPARTTYPE
                 FROM CLASS3
                WHERE CLASS IN( SELECT PART_TYPE
                                 FROM PART
                                WHERE PART_NO = LSPARTNO );

               SELECT ID
                 INTO LNMAINID
                 FROM ITCLD
                WHERE SPEC_GROUP = LSPARTTYPE;

               SELECT DISTINCT CODE
                          INTO LSSUBNODE
                          FROM ITCLAT
                         WHERE ATTRIBUTE_ID = LNTREETYPE
                           AND TYPE = 'TV'
                           AND TREE_ID = LNMAINID;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  LSSUBNODE := LSNODE;
            END;

            
            IF LNHIERLEVEL > 1
            THEN
               BEGIN
                  SELECT MATL_CLASS_ID
                    INTO LNPREVIOUSLEVEL
                    FROM ITPRCL
                   WHERE PART_NO = LSPARTNO
                     AND HIER_LEVEL =   LNHIERLEVEL
                                      - 2
                     AND TYPE = LSSUBNODE;

                  
                  BEGIN
                     SELECT CID
                       INTO LNMATERIALCLASSID
                       FROM ITCLTV
                      WHERE TYPE = LSNODE
                        AND PID = LNPREVIOUSLEVEL
                        AND DESCR = LSVALUE;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        ROLLBACK;
                        RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                    LSMETHOD,
                                                                    IAPICONSTANTDBERROR.DBERR_PARTVALUENOTVALIDONLEVEL,
                                                                    LSPARTNO,
                                                                    LSVALUE,
                                                                    LNHIERLEVEL ) );
                     WHEN TOO_MANY_ROWS
                     THEN
                        ROLLBACK;
                        RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                    LSMETHOD,
                                                                    IAPICONSTANTDBERROR.DBERR_TOOMANYROWSTREETYPE,
                                                                    ' pick up current level based on previous level ',
                                                                    LSVALUE ) );
                  END;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     ROLLBACK;
                     RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                 LSMETHOD,
                                                                 IAPICONSTANTDBERROR.DBERR_PARTNOTIMPORTEDPREVLEVEL,
                                                                 LSPARTNO,
                                                                 LNHIERLEVEL ) );
                  WHEN TOO_MANY_ROWS
                  THEN
                     ROLLBACK;
                     RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                 LSMETHOD,
                                                                 IAPICONSTANTDBERROR.DBERR_TOOMANYROWSTREETYPE,
                                                                 ' previous level ',
                                                                 LNHIERLEVEL ) );
               END;
            ELSE
               
               IF     LNHIERLEVEL = 1
                  AND LSPARTTYPE <> LSSPECGROUP
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTTREENOTMATCH,
                                                              LSPARTNO,
                                                              LSSPECGROUP,
                                                              LSPARTTYPE ) );
               END IF;

               
               BEGIN
                  SELECT CID
                    INTO LNMATERIALCLASSID
                    FROM ITCLTV
                   WHERE TYPE = LSNODE
                     AND PID = 0
                     AND DESCR = LSVALUE;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     ROLLBACK;
                     RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                 LSMETHOD,
                                                                 IAPICONSTANTDBERROR.DBERR_PARTVALUENOTVALIDONLEVEL,
                                                                 LSPARTNO,
                                                                 LSVALUE,
                                                                 LNHIERLEVEL ) );
                  WHEN TOO_MANY_ROWS
                  THEN
                     ROLLBACK;
                     RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                 LSMETHOD,
                                                                 IAPICONSTANTDBERROR.DBERR_TOOMANYROWSTREETYPE,
                                                                 ' level 0 ',
                                                                 LSVALUE ) );
               END;
            END IF;

            BEGIN
               INSERT INTO ITPRCL
                           ( PART_NO,
                             HIER_LEVEL,
                             MATL_CLASS_ID,
                             CODE,
                             TYPE )
                    VALUES ( LSPARTNO,
                               LNHIERLEVEL
                             - 1,
                             LNMATERIALCLASSID,
                             LSSUBNODE,
                             LSSUBNODE );
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTTREEVIEWEXIST,
                                                              LSPARTNO,
                                                              LSVALUE ) );
            END;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LBENDOFFILE := TRUE;
            WHEN OTHERS
            THEN
               ROLLBACK;
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTNOTCREATEDGEN,
                                                           LSPARTNO,
                                                           LNTREEVIEW,
                                                           SQLERRM ) );
         END;

         LSPREVPARTNO := LSPARTNO;
      END LOOP;

      COMMIT;
      
      UTL_FILE.FCLOSE( LRFILEHANDLE );
      
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNISJOBID );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END IMPORTCLASSIFICATIONTREEVIEW;

   
   FUNCTION IMPORTCLASSIFICATIONDESCRIPTOR(
      ASDIRECTORY                IN       IAPITYPE.STRINGVAL_TYPE,
      ASFILE                     IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LBENDOFFILE                   IAPITYPE.LOGICAL_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE := 1;
      LNDESCRLEVEL                  IAPITYPE.NUMVAL_TYPE;
      LNDESCRVALUE                  IAPITYPE.MATERIALCLASSID_TYPE;
      LNDESCRIPTORID                IAPITYPE.NUMVAL_TYPE;
      LNFIELDID                     IAPITYPE.NUMVAL_TYPE;
      LNLOWESTID                    IAPITYPE.MATERIALCLASSID_TYPE;
      LNMAXHIERLEVEL                IAPITYPE.HIERLEVEL_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNTREETYPE                    IAPITYPE.NUMVAL_TYPE;
      LRFILEHANDLE                  IAPITYPE.FILE_TYPE;
      LSDATA                        IAPITYPE.INFO_TYPE;
      LSDATAUNICODE                 IAPITYPE.UNICODEINFO_TYPE;
      LSDESCRIPTOR                  IAPITYPE.STRING_TYPE;
      LSDESCRIPTORCODE              VARCHAR2( 8 );
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ImportClassificationDescriptor';
      LSNODE                        IAPITYPE.NODE_TYPE;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LSTREETYPE                    IAPITYPE.STRING_TYPE;
      LSVALUE                       IAPITYPE.STRING_TYPE;
      LTPOSTAB                      IAPITYPE.NUMBERTAB_TYPE;
      LNISJOBID                     IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPIJOBLOGGING.STARTJOB(    GSSOURCE
                                           || '.'
                                           || LSMETHOD,
                                           LNISJOBID );

      
      BEGIN
         LRFILEHANDLE := UTL_FILE.FOPEN_NCHAR( ASDIRECTORY,
                                               ASFILE,
                                               'r' );
      EXCEPTION
         WHEN OTHERS
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_UNABLETOOPENFILE,
                                                           ASDIRECTORY
                                                        || '\'
                                                        || ASFILE,
                                                        SQLERRM ) );
      END;

      LBENDOFFILE := FALSE;

      WHILE NOT LBENDOFFILE
      LOOP
         BEGIN




            
            UTL_FILE.GET_LINE_NCHAR( LRFILEHANDLE,
                                     LSDATAUNICODE );

            IF LNCOUNT = 1
            THEN
               LSDATA := SUBSTR( LSDATAUNICODE,
                                 2 );
            ELSE
               LSDATA := LSDATAUNICODE;
            END IF;

            LNCOUNT :=   LNCOUNT
                       + 1;

            
            FOR LL_I IN 1 .. 3
            LOOP
               LTPOSTAB( LL_I ) := INSTR( LSDATA,
                                          CHR( 9 ),
                                          1,
                                          LL_I );
            END LOOP;

            IF LTPOSTAB( 1 ) = 0
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_FILEERRORNOTAB ) );
            END IF;

            LNFIELDID := 1;
            LSPARTNO := NULL;
            LSPARTNO := SUBSTR( LSDATA,
                                1,
                                  LTPOSTAB( 1 )
                                - 1 );
            LNRETVAL := VALIDATEFIELD( 'Part No',
                                       LSPARTNO );
            LNFIELDID := 2;
            LSTREETYPE := SUBSTR( LSDATA,
                                    LTPOSTAB(   LNFIELDID
                                              - 1 )
                                  + 1,
                                    LTPOSTAB( LNFIELDID )
                                  - LTPOSTAB(   LNFIELDID
                                              - 1 )
                                  - 1 );

            IF LSTREETYPE = '#N/A'
            THEN
               ROLLBACK;
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTNOTINSERTEDISNA,
                                                           LSPARTNO,
                                                           'tree type' ) );
            ELSE
               LNTREETYPE := TO_NUMBER( LSTREETYPE );
            END IF;

            LNFIELDID := 3;
            LSDESCRIPTOR := SUBSTR( LSDATA,
                                      LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    + 1,
                                      LTPOSTAB( LNFIELDID )
                                    - LTPOSTAB(   LNFIELDID
                                                - 1 )
                                    - 1 );
            LNFIELDID := 4;
            LSVALUE := SUBSTR( LSDATA,
                                 LTPOSTAB( 3 )
                               + 1,
                                 LENGTH( LSDATA )
                               - LTPOSTAB( 3 ) );

            
            BEGIN
               SELECT ATTRIBUTE_ID,
                      CODE
                 INTO LNDESCRIPTORID,
                      LSDESCRIPTORCODE
                 FROM ITCLAT
                WHERE TREE_ID = LNTREETYPE
                  AND LABEL = LSDESCRIPTOR;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTDESCRIPTORNOTVALID,
                                                              LSPARTNO,
                                                              LSDESCRIPTOR,
                                                              LNTREETYPE ) );
            END;




            BEGIN
               SELECT NODE
                 INTO LSNODE
                 FROM ITCLD
                WHERE ID = LNTREETYPE;

               
               SELECT MAX( HIER_LEVEL )
                 INTO LNMAXHIERLEVEL
                 FROM ITPRCL
                WHERE PART_NO = LSPARTNO
                  AND TYPE = LSNODE;

               IF LNMAXHIERLEVEL IS NULL
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTNOMAINCLASSFOUND,
                                                              LSPARTNO ) );
               ELSE
                  SELECT MATL_CLASS_ID
                    INTO LNLOWESTID
                    FROM ITPRCL
                   WHERE PART_NO = LSPARTNO
                     AND TYPE = LSNODE
                     AND HIER_LEVEL = LNMAXHIERLEVEL;

                  LNDESCRLEVEL := F_GET_ATT_KEY( LNLOWESTID );

                  BEGIN
                     SELECT CID
                       INTO LNDESCRVALUE
                       FROM ITCLCLF
                      WHERE ID = LNDESCRIPTORID
                        AND PID = LNDESCRLEVEL
                        AND DESCR = LSVALUE;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        ROLLBACK;
                        RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                    LSMETHOD,
                                                                    IAPICONSTANTDBERROR.DBERR_PARTVALUEDESCRNOTVALID,
                                                                    LSPARTNO,
                                                                    LSVALUE,
                                                                    LSDESCRIPTOR,
                                                                    LNTREETYPE ) );
                  END;
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTNOINFOFORTREETYPE,
                                                              LSPARTNO,
                                                              LNTREETYPE ) );
               WHEN TOO_MANY_ROWS
               THEN
                  ROLLBACK;
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_TOOMANYROWSTREETYPE,
                                                              'tree type pick up',
                                                              LNTREETYPE ) );
            END;

            BEGIN
               DELETE      ITPRCL
                     WHERE PART_NO = LSPARTNO
                       AND HIER_LEVEL = 0
                       AND CODE = LSDESCRIPTORCODE
                       AND TYPE = LSDESCRIPTORCODE;
            EXCEPTION
               WHEN OTHERS
               THEN
                  NULL;
            END;

            BEGIN
               INSERT INTO ITPRCL
                           ( PART_NO,
                             HIER_LEVEL,
                             MATL_CLASS_ID,
                             CODE,
                             TYPE )
                    VALUES ( LSPARTNO,
                             0,
                             LNDESCRVALUE,
                             LSDESCRIPTORCODE,
                             LSDESCRIPTORCODE );
            EXCEPTION
               WHEN OTHERS
               THEN
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PARTNOTCREATEDGEN,
                                                              LSPARTNO,
                                                              LNFIELDID,
                                                              SQLERRM ) );
            END;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LBENDOFFILE := TRUE;
            WHEN OTHERS
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PARTNOTCREATEDGEN,
                                                           LSPARTNO,
                                                           LNFIELDID,
                                                           SQLERRM ) );
         END;
      END LOOP;

      
      UTL_FILE.FCLOSE( LRFILEHANDLE );
      
      LNRETVAL := IAPIJOBLOGGING.ENDJOB( LNISJOBID );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END IMPORTCLASSIFICATIONDESCRIPTOR;

   
   FUNCTION SCHEDULEJOB(
      ASDIRECTORY                IN       IAPITYPE.STRINGVAL_TYPE,
      ASFILE                     IN       IAPITYPE.STRINGVAL_TYPE,
      ASMETHOD                   IN       IAPITYPE.METHOD_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS



      LNJOBID                       BINARY_INTEGER;
      LSWHAT                        VARCHAR2( 2048 );
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSUPDATEALLOWED               IAPITYPE.STRING_TYPE := '0';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           ASMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( 'upd_in_dev',
                                                       'data_migration',
                                                       LSUPDATEALLOWED );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               ASMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF LSUPDATEALLOWED = '1'
      THEN
         LSWHAT := 'DECLARE lnRet Number; BEGIN lnRet:=iapiGeneral.SetConnection( iapiGeneral.SchemaName,''DATA MIGRATION JOB'' );';
      ELSE
         LSWHAT :=
               'DECLARE lnRet Number; BEGIN lnRet:=iapiGeneral.SetConnection( '''
            || IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
            || ''',''DATA MIGRATION JOB'' );';
      END IF;

      LSWHAT :=
            LSWHAT
         || ' lnRet:=iapiMigrateData.Import'
         || ASMETHOD
         || '('''
         || ASDIRECTORY
         || ''','''
         || ASFILE
         || '''); IF lnRet<>0 THEN iapiGeneral.LogError( '''
         || GSSOURCE
         || ''','''
         || ASMETHOD
         || ''',iapiGeneral.GetLastErrorText()); END IF; END;';
      DBMS_JOB.SUBMIT( LNJOBID,
                       LSWHAT,
                       SYSDATE,
                       NULL,
                       FALSE );
      COMMIT;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               ASMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SCHEDULEJOB;

   
   FUNCTION BOM(
      ASDIRECTORY                IN       IAPITYPE.STRINGVAL_TYPE,
      ASFILE                     IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Bom';
   BEGIN
      LNRETVAL := SCHEDULEJOB( ASDIRECTORY,
                               ASFILE,
                               LSMETHOD );
      RETURN( LNRETVAL );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END BOM;

   
   FUNCTION FREETEXT(
      ASDIRECTORY                IN       IAPITYPE.STRINGVAL_TYPE,
      ASFILE                     IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FreeText';
   BEGIN
      LNRETVAL := SCHEDULEJOB( ASDIRECTORY,
                               ASFILE,
                               LSMETHOD );
      RETURN( LNRETVAL );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FREETEXT;

   
   FUNCTION SPECIFICATIONHEADER(
      ASDIRECTORY                IN       IAPITYPE.STRINGVAL_TYPE,
      ASFILE                     IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SpecificationHeader';
   BEGIN
      LNRETVAL := SCHEDULEJOB( ASDIRECTORY,
                               ASFILE,
                               LSMETHOD );
      RETURN( LNRETVAL );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SPECIFICATIONHEADER;

   
   FUNCTION PLANT(
      ASDIRECTORY                IN       IAPITYPE.STRINGVAL_TYPE,
      ASFILE                     IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Plant';
   BEGIN
      LNRETVAL := SCHEDULEJOB( ASDIRECTORY,
                               ASFILE,
                               LSMETHOD );
      RETURN( LNRETVAL );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END PLANT;

   
   FUNCTION KEYWORD(
      ASDIRECTORY                IN       IAPITYPE.STRINGVAL_TYPE,
      ASFILE                     IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Keyword';
   BEGIN
      LNRETVAL := SCHEDULEJOB( ASDIRECTORY,
                               ASFILE,
                               LSMETHOD );
      RETURN( LNRETVAL );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END KEYWORD;

   
   FUNCTION MANUFACTURER(
      ASDIRECTORY                IN       IAPITYPE.STRINGVAL_TYPE,
      ASFILE                     IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Manufacturer';
   BEGIN
      LNRETVAL := SCHEDULEJOB( ASDIRECTORY,
                               ASFILE,
                               LSMETHOD );
      RETURN( LNRETVAL );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END MANUFACTURER;

   
   FUNCTION INGREDIENTLIST(
      ASDIRECTORY                IN       IAPITYPE.STRINGVAL_TYPE,
      ASFILE                     IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IngredientList';
   BEGIN
      LNRETVAL := SCHEDULEJOB( ASDIRECTORY,
                               ASFILE,
                               LSMETHOD );
      RETURN( LNRETVAL );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END INGREDIENTLIST;

   
   FUNCTION ATTACHEDSPECIFICATION(
      ASDIRECTORY                IN       IAPITYPE.STRINGVAL_TYPE,
      ASFILE                     IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AttachedSpecification';
   BEGIN
      LNRETVAL := SCHEDULEJOB( ASDIRECTORY,
                               ASFILE,
                               LSMETHOD );
      RETURN( LNRETVAL );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ATTACHEDSPECIFICATION;

   
   FUNCTION PROPERTY(
      ASDIRECTORY                IN       IAPITYPE.STRINGVAL_TYPE,
      ASFILE                     IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Property';
   BEGIN
      LNRETVAL := SCHEDULEJOB( ASDIRECTORY,
                               ASFILE,
                               LSMETHOD );
      RETURN( LNRETVAL );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END PROPERTY;

   
   FUNCTION CLASSIFICATIONTREEVIEW(
      ASDIRECTORY                IN       IAPITYPE.STRINGVAL_TYPE,
      ASFILE                     IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ClassificationTreeView';
   BEGIN
      LNRETVAL := SCHEDULEJOB( ASDIRECTORY,
                               ASFILE,
                               LSMETHOD );
      RETURN( LNRETVAL );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CLASSIFICATIONTREEVIEW;

   
   FUNCTION CLASSIFICATIONDESCRIPTOR(
      ASDIRECTORY                IN       IAPITYPE.STRINGVAL_TYPE,
      ASFILE                     IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ClassificationDescriptor';
   BEGIN
      LNRETVAL := SCHEDULEJOB( ASDIRECTORY,
                               ASFILE,
                               LSMETHOD );
      RETURN( LNRETVAL );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CLASSIFICATIONDESCRIPTOR;
END IAPIMIGRATEDATA;
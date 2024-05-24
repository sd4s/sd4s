CREATE OR REPLACE PACKAGE BODY iapiExemption
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

   
   
   

   
   
   
   
   PROCEDURE CHECKBASICPARAMS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ADFROMDATE                 IN       IAPITYPE.DATE_TYPE,
      ADTODATE                   IN       IAPITYPE.DATE_TYPE )
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckBasicParams';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESSLEVEL                 IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ASPARTNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PartNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartNo',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ASDESCRIPTION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Description' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asDescription',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ADFROMDATE IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'FromDate' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'adFromDate',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ADTODATE IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'ToDate' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'adToDate',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
   END CHECKBASICPARAMS;

   
   FUNCTION EXISTID(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANPARTEXEMPTIONNO          IN       IAPITYPE.SEQUENCENR_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistId';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT PART_NO
        INTO LSPARTNO
        FROM EXEMPTION
       WHERE PART_NO = ASPARTNO
         AND PART_EXEMPTION_NO = ANPARTEXEMPTIONNO;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_EXEMPTIONNOTEXIST,
                                                     ASPARTNO,
                                                     ANPARTEXEMPTIONNO ) );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTID;

   
   
   
   
   FUNCTION ADDEXEMPTION(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ALTEXT                     IN       IAPITYPE.CLOB_TYPE,
      ADFROMDATE                 IN       IAPITYPE.DATE_TYPE,
      ADTODATE                   IN       IAPITYPE.DATE_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddExemption';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNPARTEXEMPTIONNO             IAPITYPE.SEQUENCENR_TYPE;
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
      
      
      
      
      CHECKBASICPARAMS( ASPARTNO,
                        ASDESCRIPTION,
                        ADFROMDATE,
                        ADTODATE );

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

      
      
      LNRETVAL := IAPIPART.EXISTID( ASPARTNO );

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

      SELECT   NVL( MAX( PART_EXEMPTION_NO ),
                    0 )
             + 1
        INTO LNPARTEXEMPTIONNO
        FROM EXEMPTION
       WHERE PART_NO = ASPARTNO;

      INSERT INTO EXEMPTION
                  ( PART_NO,
                    PART_EXEMPTION_NO,
                    DESCRIPTION,
                    TEXT,
                    FROM_DATE,
                    TO_DATE )
           VALUES ( ASPARTNO,
                    LNPARTEXEMPTIONNO,
                    ASDESCRIPTION,
                    ALTEXT,
                    ADFROMDATE,
                    ADTODATE );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDEXEMPTION;

   
   FUNCTION REMOVEEXEMPTION(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANPARTEXEMPTIONNO          IN       IAPITYPE.SEQUENCENR_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveExemption';
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
      
      
      LNRETVAL := IAPIPART.EXISTID( ASPARTNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      
      LNRETVAL := EXISTID( ASPARTNO,
                           ANPARTEXEMPTIONNO );

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

      DELETE FROM EXEMPTION
            WHERE PART_NO = ASPARTNO
              AND PART_EXEMPTION_NO = ANPARTEXEMPTIONNO;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEEXEMPTION;

   
   FUNCTION SAVEEXEMPTION(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANPARTEXEMPTIONNO          IN       IAPITYPE.SEQUENCENR_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ALTEXT                     IN       IAPITYPE.CLOB_TYPE,
      ADFROMDATE                 IN       IAPITYPE.DATE_TYPE,
      ADTODATE                   IN       IAPITYPE.DATE_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddExemption';
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
      
      
      
      
      CHECKBASICPARAMS( ASPARTNO,
                        ASDESCRIPTION,
                        ADFROMDATE,
                        ADTODATE );

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

      
      
      LNRETVAL := IAPIPART.EXISTID( ASPARTNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      
      LNRETVAL := EXISTID( ASPARTNO,
                           ANPARTEXEMPTIONNO );

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

      UPDATE EXEMPTION
         SET DESCRIPTION = ASDESCRIPTION,
             TEXT = ALTEXT,
             FROM_DATE = ADFROMDATE,
             TO_DATE = ADTODATE
       WHERE PART_NO = ASPARTNO
         AND PART_EXEMPTION_NO = ANPARTEXEMPTIONNO;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEEXEMPTION;

   
   FUNCTION GETEXEMPTIONS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      AQEXEMPTIONS               OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetExemptions';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', part_exemption_no '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ', description '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', text '
            || IAPICONSTANTCOLUMN.TEXTCOL
            || ', from_date '
            || IAPICONSTANTCOLUMN.FROMDATECOL
            || ', to_date '
            || IAPICONSTANTCOLUMN.TODATECOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'exemption';
   BEGIN
      
      
      
      
      
      IF ( AQEXEMPTIONS%ISOPEN )
      THEN
         CLOSE AQEXEMPTIONS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE part_no = NULL';

      OPEN AQEXEMPTIONS FOR LSSQLNULL;

      
      LSSQL :=    'SELECT '
               || LSSELECT
               || '  FROM '
               || LSFROM
               || ' WHERE part_no = :PartNo';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQEXEMPTIONS%ISOPEN )
      THEN
         CLOSE AQEXEMPTIONS;
      END IF;

      
      OPEN AQEXEMPTIONS FOR LSSQL USING ASPARTNO;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETEXEMPTIONS;
END IAPIEXEMPTION;
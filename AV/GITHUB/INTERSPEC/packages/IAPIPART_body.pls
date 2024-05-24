CREATE OR REPLACE PACKAGE BODY iapiPart
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

   
   
   

   
   
   
 
   
   
   PROCEDURE INSERTUPDATEPARTDESCRITION(
      ASPARTNO                            IAPITYPE.PARTNO_TYPE,
      ASDESCRIPTION                       IAPITYPE.DESCRIPTION_TYPE,
      ANLANGUAGEID                        IAPITYPE.LANGUAGEID_TYPE )
   IS
   BEGIN
      
      BEGIN
         INSERT INTO PART_L
                     ( PART_NO,
                       LANG_ID,
                       DESCRIPTION )
              VALUES ( ASPARTNO,
                       ANLANGUAGEID,
                       ASDESCRIPTION );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            UPDATE PART_L
               SET DESCRIPTION = ASDESCRIPTION
             WHERE PART_NO = ASPARTNO
               AND LANG_ID = ANLANGUAGEID;
      END;
   END INSERTUPDATEPARTDESCRITION;
   
   
   
   
   FUNCTION GETUOMSTANDARDDESCRIPTION(
      ASUOMDESCRIPTION           IN       IAPITYPE.DESCRIPTION_TYPE )
      RETURN VARCHAR2
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUoMStandardDescription';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      GSUOMDESCRIPTION := ASUOMDESCRIPTION;
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Pre-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     LSMETHOD,
                                                     'PRE',
                                                     GTERRORS );
      RETURN( GSUOMDESCRIPTION );
   END GETUOMSTANDARDDESCRIPTION;
   

   
   FUNCTION VALIDATEPARTNO(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidatePartNo';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := EXISTID( ASPARTNO );

      IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_PARTALREADYEXIST,
                                                     ASPARTNO ) );
      END IF;

      LNRETVAL := IAPIPART.VALIDATEPART( ASPARTNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN LNRETVAL;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END VALIDATEPARTNO;

   
   FUNCTION EXISTID(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE )
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
        FROM PART
       WHERE PART_NO = ASPARTNO;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_PARTNOTFOUND,
                                                     ASPARTNO ) );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTID;

   
   FUNCTION GETNEXTID(
      ASPARTNO                   OUT      IAPITYPE.PARTNO_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetNextId';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       NUMBER := 0;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      LOOP
         LNCOUNT :=   LNCOUNT
                    + 1;

         SELECT PART_NO_SEQ.NEXTVAL
           INTO ASPARTNO
           FROM DUAL;

         LNRETVAL := EXISTID( ASPARTNO );
         EXIT WHEN LNRETVAL = IAPICONSTANTDBERROR.DBERR_PARTNOTFOUND;

         IF (      ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
              AND ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_PARTNOTFOUND ) )
         THEN
            RETURN( LNRETVAL );
         END IF;
      END LOOP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETNEXTID;

   
   FUNCTION ACCESSALLOWED(
      ANACCESSALLOWED            OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AccessAllowed';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
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
   END ACCESSALLOWED;

   
   FUNCTION GETBASECOLUMNS(
      ASALIAS                    IN       IAPITYPE.STRING_TYPE DEFAULT '' )
      RETURN VARCHAR2
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetBaseColumns';
      LCBASECOLUMNS                 VARCHAR2( 4096 ) := NULL;
      LSALIAS                       IAPITYPE.STRING_TYPE := NULL;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           ASALIAS,
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
         || 'part_no '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ','
         
         


         
         
         || 'f_part_descr(' || IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID || ','
         || LSALIAS
         || 'part_no) '
         
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ','
         || LSALIAS
         || 'base_uom '
         || IAPICONSTANTCOLUMN.BASEUOMCOL
         || ','
         || LSALIAS
         || 'part_source '
         || IAPICONSTANTCOLUMN.PARTSOURCECOL
         || ','
         || LSALIAS
         || 'base_conv_factor '
         || IAPICONSTANTCOLUMN.BASECONVERSIONFACTORCOL
         || ','
         || LSALIAS
         || 'base_to_unit '
         || IAPICONSTANTCOLUMN.BASETOUNITCOL
         || ','
         || LSALIAS
         || 'part_type '
         || IAPICONSTANTCOLUMN.PARTTYPEIDCOL
         || ','
         || LSALIAS
         || 'date_imported '
         || IAPICONSTANTCOLUMN.DATEIMPORTEDCOL
         || ','
         || LSALIAS
         || 'alt_part_no '
         || IAPICONSTANTCOLUMN.ALTERNATIVEPARTNOCOL
         || ','
         || LSALIAS
         || 'Obsolete '
         || IAPICONSTANTCOLUMN.OBSOLETECOL
         || ','
         || 'c.sort_desc '
         || IAPICONSTANTCOLUMN.PARTTYPECOL;
      RETURN( LCBASECOLUMNS );
   END GETBASECOLUMNS;

   
   PROCEDURE VALIDATIONBOM(
      ASFROMPARTNO               IN       IAPITYPE.PARTNO_TYPE,
      ANFROMREVISION             IN       IAPITYPE.REVISION_TYPE,
      ASTOPARTNO                 IN       IAPITYPE.PARTNO_TYPE,
      ATPLANT                    IN OUT   IAPITYPE.PLANTTAB_TYPE,
      ANSTACKCNT                 IN OUT   IAPITYPE.NUMVAL_TYPE )
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSPARTSOURCE                  IAPITYPE.PARTSOURCE_TYPE;
      LRPLANT                       IAPITYPE.PLANTREC_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidationBom';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;

      CURSOR CUR_PP
      IS
         SELECT PLANT
           FROM BOM_HEADER
          WHERE PART_NO = ASFROMPARTNO
            AND REVISION = ANFROMREVISION
         MINUS
         SELECT PLANT
           FROM PART_PLANT
          WHERE PART_NO = ASTOPARTNO;
   BEGIN
      

      BEGIN
         SELECT PART_SOURCE
           INTO LSPARTSOURCE
           FROM PART
          WHERE PART_NO = ASTOPARTNO;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_PARTNOTFOUND,
                                                            ASTOPARTNO );
      END;

      IF LSPARTSOURCE <> 'I-S'
      THEN
         FOR REC_PP IN CUR_PP
         LOOP
            ANSTACKCNT :=   ANSTACKCNT
                          + 1;
            LRPLANT.PLANTNO := REC_PP.PLANT;
            LRPLANT.PLANTDESCRIPTION := NULL;
            LRPLANT.PLANTSOURCE := NULL;
            ATPLANT( ANSTACKCNT ) := LRPLANT;
         END LOOP;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
   END VALIDATIONBOM;

   
   
   
   
   FUNCTION ADDPART(
      ASPARTNO                   IN OUT   IAPITYPE.PARTNO_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ASBASEUOM                  IN       IAPITYPE.BASEUOM_TYPE,
      ASBASETOUNIT               IN       IAPITYPE.BASETOUNIT_TYPE DEFAULT NULL,
      ANBASECONVFACTOR           IN       IAPITYPE.NUMVAL_TYPE DEFAULT NULL,
      ASPARTSOURCE               IN       IAPITYPE.PARTSOURCE_TYPE,
      ANPARTTYPEID               IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ASEANUPCBARCODE            IN       IAPITYPE.PARTNO_TYPE DEFAULT NULL,
      ANOBSOLETE                 IN       IAPITYPE.BOOLEAN_TYPE DEFAULT NULL,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddPart';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRPART                        IAPITYPE.PARTREC_TYPE;
      LNCOUNT                       NUMBER;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      
      LNCURRENTLANGUAGEID           IAPITYPE.LANGUAGEID_TYPE := IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID;   
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
      GTPARTS.DELETE;
      LRPART.PARTNO := ASPARTNO;
      LRPART.DESCRIPTION := ASDESCRIPTION;
      
      
      LRPART.BASEUOM := GETUOMSTANDARDDESCRIPTION( ASBASEUOM );
      
      LRPART.PARTSOURCE := ASPARTSOURCE;
      LRPART.BASECONVFACTOR := ANBASECONVFACTOR;
      
      
      LRPART.BASETOUNIT := GETUOMSTANDARDDESCRIPTION( ASBASETOUNIT );
      
      LRPART.PARTTYPEID := ANPARTTYPEID;
      LRPART.DATEIMPORTED := NULL;
      LRPART.EANUPCBARCODE := ASEANUPCBARCODE;
      LRPART.OBSOLETE := ANOBSOLETE;
      GTPARTS( 0 ) := LRPART;
      
      
      
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

      
      
     
      LRPART := GTPARTS( 0 );
      ASPARTNO := LRPART.PARTNO;
      
      
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      
      
      IF (  ( LRPART.PARTNO = '@@-AUTO-@@' ) )
      THEN
         LNRETVAL := GETNEXTID( LRPART.PARTNO );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Next Id = '
                              || LRPART.PARTNO,
                              IAPICONSTANT.INFOLEVEL_3 );
         ASPARTNO := LRPART.PARTNO;
      ELSE
         
         IF ( LRPART.PARTNO IS NULL )
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_INVALIDPARTNO,
                                                            'PartNo' );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartNo',
                                                    IAPIGENERAL.GETLASTERRORTEXT( ),
                                                    GTERRORS );
         END IF;

         LNRETVAL := VALIDATEPARTNO( LRPART.PARTNO );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END IF;

      
      IF ( LRPART.DESCRIPTION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Description' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asDescription',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( LRPART.BASEUOM IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Base UoM' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asBaseUom',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( LRPART.PARTSOURCE IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Part Source' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartSource',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF NOT LRPART.PARTTYPEID IS NULL
      THEN
         
         SELECT COUNT( CLASS )
           INTO LNCOUNT
           FROM CLASS3
          WHERE CLASS = LRPART.PARTTYPEID;

         IF ( LNCOUNT = 0 )
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_INVALIDPARTTYPE,
                                                            LRPART.PARTTYPE );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anPartTypeId',
                                                    IAPIGENERAL.GETLASTERRORTEXT( ),
                                                    GTERRORS );
         END IF;
      END IF;

      
      IF ( LRPART.BASETOUNIT IS NOT NULL )
      THEN
         IF ( LRPART.BASECONVFACTOR IS NULL )
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                            'Base Conversion Factor' );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anBaseConvFactor',
                                                    IAPIGENERAL.GETLASTERRORTEXT( ),
                                                    GTERRORS );
         END IF;
      END IF;

      
      IF ( LRPART.BASECONVFACTOR IS NOT NULL )
      THEN
         IF ( LRPART.BASETOUNIT IS NULL )
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                            'Conversion UoM' );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asBaseToUnit',
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

      INSERT INTO PART
                  ( PART_NO,
                    DESCRIPTION,
                    PART_SOURCE,
                    BASE_UOM,
                    BASE_TO_UNIT,
                    BASE_CONV_FACTOR,
                    PART_TYPE,
                    ALT_PART_NO,
                    OBSOLETE )
           VALUES ( LRPART.PARTNO,
                    LRPART.DESCRIPTION,
                    LRPART.PARTSOURCE,
                    LRPART.BASEUOM,
                    LRPART.BASETOUNIT,
                    LRPART.BASECONVFACTOR,
                    LRPART.PARTTYPEID,
                    LRPART.EANUPCBARCODE,
                    LRPART.OBSOLETE );

      
      
      IF ( LNCURRENTLANGUAGEID <> 1 )
      THEN
         INSERTUPDATEPARTDESCRITION( LRPART.PARTNO,
                                     LRPART.DESCRIPTION,
                                     LNCURRENTLANGUAGEID );
      END IF;
      

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Post-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     LSMETHOD,
                                                     'POST',
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
   END ADDPART;

   
   FUNCTION ADDPARTPB(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ASBASEUOM                  IN       IAPITYPE.BASEUOM_TYPE,
      ASBASETOUNIT               IN       IAPITYPE.BASETOUNIT_TYPE DEFAULT NULL,
      ANBASECONVFACTOR           IN       IAPITYPE.NUMVAL_TYPE DEFAULT NULL,
      ASPARTSOURCE               IN       IAPITYPE.PARTSOURCE_TYPE,
      ANPARTTYPEID               IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ASEANUPCBARCODE            IN       IAPITYPE.PARTNO_TYPE DEFAULT NULL,
      ANOBSOLETE                 IN       IAPITYPE.BOOLEAN_TYPE DEFAULT NULL,
      AQPARTNO                   OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddPartPb';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE := ASPARTNO;
   BEGIN
      
      
      
      
      
      IF ( AQPARTNO%ISOPEN )
      THEN
         CLOSE AQPARTNO;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL := 'select part_no from part where part_no = null';

      OPEN AQPARTNO FOR LSSQL;

      LNRETVAL :=
         IAPIPART.ADDPART( LSPARTNO,
                           ASDESCRIPTION,
                           ASBASEUOM,
                           ASBASETOUNIT,
                           ANBASECONVFACTOR,
                           ASPARTSOURCE,
                           ANPARTTYPEID,
                           ASEANUPCBARCODE,
                           ANOBSOLETE,
                           AQERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
       
      
      
      
      
      LSSQL := 'SELECT :PartNo FROM DUAL';

      OPEN AQPARTNO FOR LSSQL USING LSPARTNO;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDPARTPB;

   
   FUNCTION REMOVEPART(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemovePart';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRPART                        IAPITYPE.PARTREC_TYPE;
      LSPARTSOURCE                  IAPITYPE.PARTSOURCE_TYPE;
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
      LRPART.PARTNO := ASPARTNO;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      
      
      

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNRETVAL := EXISTID( LRPART.PARTNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPIPART.PARTUSEDINSPECIFICATION( ASPARTNO );

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

      
      SELECT PART_SOURCE
        INTO LSPARTSOURCE
        FROM PART
       WHERE PART_NO = LRPART.PARTNO;

      IF ( LSPARTSOURCE = IAPICONSTANT.PARTSOURCE_INTERNAL )
      THEN
         DELETE FROM PART_LOCATION
               WHERE PART_NO = LRPART.PARTNO;

         DELETE FROM PART_COST
               WHERE PART_NO = LRPART.PARTNO;

         DELETE FROM PART_PLANT
               WHERE PART_NO = LRPART.PARTNO;

         DELETE FROM PART_L
               WHERE PART_NO = LRPART.PARTNO;

         DELETE FROM ITPROBJ
               WHERE PART_NO = LRPART.PARTNO;

         DELETE FROM ITPROBJ_H
               WHERE PART_NO = LRPART.PARTNO;

         DELETE FROM ITPRMFC
               WHERE PART_NO = LRPART.PARTNO;

         DELETE FROM ITPRMFC_H
               WHERE PART_NO = LRPART.PARTNO;

         DELETE FROM ITPRCL
               WHERE PART_NO = LRPART.PARTNO;

         DELETE FROM ITPRCL_H
               WHERE PART_NO = LRPART.PARTNO;

         DELETE FROM SPECIFICATION_KW
               WHERE PART_NO = LRPART.PARTNO;

         DELETE FROM SPECIFICATION_KW_H
               WHERE PART_NO = LRPART.PARTNO;

         DELETE FROM ITPRNOTE
               WHERE PART_NO = LRPART.PARTNO;

         DELETE FROM ITPRNOTE_H
               WHERE PART_NO = LRPART.PARTNO;

         DELETE FROM ITPRPL_H
               WHERE PART_NO = LRPART.PARTNO;

         DELETE FROM ITSH_H
               WHERE PART_NO = LRPART.PARTNO;

         DELETE FROM EXEMPTION
               WHERE PART_NO = LRPART.PARTNO;

         DELETE FROM PART
               WHERE PART_NO = LRPART.PARTNO;
      END IF;

      
      
      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEPART;

   
   FUNCTION GETPARTS(
      ATDEFAULTFILTER            IN       IAPITYPE.FILTERTAB_TYPE,
      ATPLANTFILTER              IN       IAPITYPE.FILTERTAB_TYPE,
      AQPARTS                    OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetParts';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRFILTER                      IAPITYPE.FILTERREC_TYPE;
      LSFILTER                      IAPITYPE.CLOB_TYPE := NULL;
      LSFILTERTOADD                 IAPITYPE.STRING_TYPE := NULL;
      LNCOUNTER                     IAPITYPE.NUMVAL_TYPE;
      LRPART                        IAPITYPE.PARTREC_TYPE;
      LRGETPART                     SPPARTRECORD_TYPE := SPPARTRECORD_TYPE( NULL,
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
      LSSELECT                      VARCHAR2( 4096 ) := GETBASECOLUMNS( 'p' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'part p, class3 c';
   BEGIN
      
      
      
      
      
      IF ( AQPARTS%ISOPEN )
      THEN
         CLOSE AQPARTS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE p.part_no = null AND p.part_type = c.class ';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQPARTS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      GTDEFAULTFILTER.DELETE;

      IF ATDEFAULTFILTER.COUNT > 0
      THEN
         FOR LNCOUNTER IN ATDEFAULTFILTER.FIRST .. ATDEFAULTFILTER.LAST
         LOOP
            GTDEFAULTFILTER( LNCOUNTER ) := ATDEFAULTFILTER( LNCOUNTER );
         END LOOP;
      END IF;

      GTPLANTFILTER.DELETE;

      IF ATPLANTFILTER.COUNT > 0
      THEN
         FOR LNCOUNTER IN ATPLANTFILTER.FIRST .. ATPLANTFILTER.LAST
         LOOP
            GTPLANTFILTER( LNCOUNTER ) := ATPLANTFILTER( LNCOUNTER );
         END LOOP;
      END IF;

      
      
      

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Number of items in DefaultFilter <'
                           || ATDEFAULTFILTER.COUNT
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR I IN 0 ..   ATDEFAULTFILTER.COUNT
                    - 1
      LOOP
         LRFILTER := ATDEFAULTFILTER( I );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'DefaultFilter ('
                              || I
                              || ') <'
                              || LRFILTER.LEFTOPERAND
                              || '> <'
                              || LRFILTER.OPERATOR
                              || '> <'
                              || LRFILTER.RIGHTOPERAND
                              || '>',
                              IAPICONSTANT.INFOLEVEL_3 );

         
         CASE LRFILTER.LEFTOPERAND
            WHEN IAPICONSTANTCOLUMN.PARTNOCOL
            THEN
               LRFILTER.LEFTOPERAND := 'p.part_no';
            WHEN IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            THEN
               LRFILTER.LEFTOPERAND := 'p.description';
            WHEN IAPICONSTANTCOLUMN.BASEUOMCOL
            THEN
               LRFILTER.LEFTOPERAND := 'p.base_uom';
            WHEN IAPICONSTANTCOLUMN.PARTSOURCECOL
            THEN
               LRFILTER.LEFTOPERAND := 'p.part_source';
            WHEN IAPICONSTANTCOLUMN.BASECONVERSIONFACTORCOL
            THEN
               LRFILTER.LEFTOPERAND := 'p.base_conv_factor';
            WHEN IAPICONSTANTCOLUMN.BASETOUNITCOL
            THEN
               LRFILTER.LEFTOPERAND := 'p.base_to_unit';
            WHEN IAPICONSTANTCOLUMN.PARTTYPEIDCOL
            THEN
               LRFILTER.LEFTOPERAND := 'p.part_type';
            WHEN IAPICONSTANTCOLUMN.DATEIMPORTEDCOL
            THEN
               LRFILTER.LEFTOPERAND := 'p.date_imported';
            WHEN IAPICONSTANTCOLUMN.ALTERNATIVEPARTNOCOL
            THEN
               LRFILTER.LEFTOPERAND := 'p.alt_part_no';
            WHEN IAPICONSTANTCOLUMN.OBSOLETECOL
            THEN
               LRFILTER.LEFTOPERAND := 'p.obsolete';
            ELSE
               LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                               LSMETHOD,
                                                               IAPICONSTANTDBERROR.DBERR_INVALIDFILTER,
                                                               LRFILTER.LEFTOPERAND );
               RETURN( LNRETVAL );
         END CASE;

         IF ( I > 0 )
         THEN
            LSFILTER :=    LSFILTER
                        || ' AND ';
         END IF;

         LRFILTER.RIGHTOPERAND := IAPIGENERAL.ESCQUOTE( LRFILTER.RIGHTOPERAND );
         LNRETVAL := IAPIGENERAL.TRANSFORMFILTERRECORD( LRFILTER,
                                                        LSFILTERTOADD );

         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            LSFILTER :=    LSFILTER
                        || LSFILTERTOADD;
         ELSE
            RETURN( LNRETVAL );
         END IF;
      END LOOP;

      IF (     ( ATPLANTFILTER.COUNT > 0 )
           OR ( IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1 ) )
      THEN
         LSFROM :=    LSFROM
                   || ', part_plant pp ';
      END IF;

      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Number of items in PlantFilter <'
                           || ATPLANTFILTER.COUNT
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR I IN 0 ..   ATPLANTFILTER.COUNT
                    - 1
      LOOP
         LRFILTER := ATPLANTFILTER( I );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'PlantFilter ('
                              || I
                              || ') <'
                              || LRFILTER.LEFTOPERAND
                              || '> <'
                              || LRFILTER.OPERATOR
                              || '> <'
                              || LRFILTER.RIGHTOPERAND
                              || '>',
                              IAPICONSTANT.INFOLEVEL_3 );

         
         CASE LRFILTER.LEFTOPERAND
            WHEN IAPICONSTANTCOLUMN.PLANTNOCOL
            THEN
               LRFILTER.LEFTOPERAND := 'pp.plant';
            WHEN IAPICONSTANTCOLUMN.PLANTOBSOLETECOL
            THEN
               LRFILTER.LEFTOPERAND := 'pp.obsolete';
            ELSE
               LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                               LSMETHOD,
                                                               IAPICONSTANTDBERROR.DBERR_INVALIDFILTER,
                                                               LRFILTER.LEFTOPERAND );
               RETURN( LNRETVAL );
         END CASE;

         IF ( LSFILTER IS NOT NULL )
         THEN
            LSFILTER :=    LSFILTER
                        || ' AND ';
         END IF;

         LRFILTER.RIGHTOPERAND := IAPIGENERAL.ESCQUOTE( LRFILTER.RIGHTOPERAND );
         LNRETVAL := IAPIGENERAL.TRANSFORMFILTERRECORD( LRFILTER,
                                                        LSFILTERTOADD );

         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            LSFILTER :=    LSFILTER
                        || LSFILTERTOADD;
         ELSE
            RETURN( LNRETVAL );
         END IF;
      END LOOP;

      
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM
               || ' WHERE p.part_type = c.class(+) ';

      IF (     ( ATPLANTFILTER.COUNT > 0 )
           OR ( IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1 ) )
      THEN
         LSSQL :=    LSSQL
                  || ' AND p.part_no = pp.part_no ';
      END IF;

      IF ( LSFILTER IS NOT NULL )
      THEN
         LSSQL :=    LSSQL
                  || ' AND '
                  || LSFILTER;
      END IF;

      
      IF ( IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1 )
      THEN
         LSSQL :=    LSSQL
                  || ' AND pp.plant_access = ''Y'' '
                  || 'AND pp.plant IN( SELECT PLANT '
                  || 'FROM ITUP '
                  || 'WHERE USER_ID = :UserId ) ';
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY p.part_no ASC';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQPARTS%ISOPEN )
      THEN
         CLOSE AQPARTS;
      END IF;

      
      IF ( IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1 )
      THEN
         OPEN AQPARTS FOR LSSQL USING IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
      ELSE
         OPEN AQPARTS FOR LSSQL;
      END IF;

      
      
      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPARTS;

   
   FUNCTION GETPART(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      AQPART                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPart';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRGETPART                     SPPARTRECORD_TYPE := SPPARTRECORD_TYPE( NULL,
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
      LSSELECT                      VARCHAR2( 4096 ) := GETBASECOLUMNS( 'p' );
      LSFROM                        VARCHAR2( 32 ) := 'part p, class3 c';
   BEGIN
      
      
      
      
      
      IF ( AQPART%ISOPEN )
      THEN
         CLOSE AQPART;
      END IF;

      LSSQLNULL :=    'select '
                   || LSSELECT
                   || ' from '
                   || LSFROM
                   || ' where p.part_no = null and p.part_type = c.class';

      OPEN AQPART FOR LSSQLNULL;

      
      
      
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
      
      
      LNRETVAL := EXISTID( ASPARTNO );

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

      
      IF ( AQPART%ISOPEN )
      THEN
         CLOSE AQPART;
      END IF;

      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM
               || ' WHERE p.part_no = '''
               || ASPARTNO
               || ''''
               || ' AND '
               || ' p.part_type = c.class';

      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );
      
                                 
      
      OPEN AQPART FOR LSSQL;

      
      
      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPART;

   
   FUNCTION SAVEPART(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ASBASEUOM                  IN       IAPITYPE.BASEUOM_TYPE,
      ASBASETOUNIT               IN       IAPITYPE.BASETOUNIT_TYPE DEFAULT NULL,
      ANBASECONVFACTOR           IN       IAPITYPE.NUMVAL_TYPE DEFAULT NULL,
      ASPARTSOURCE               IN       IAPITYPE.PARTSOURCE_TYPE,
      ANPARTTYPEID               IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ADDATEIMPORTED             IN       IAPITYPE.DATE_TYPE DEFAULT NULL,
      ASEANUPCBARCODE            IN       IAPITYPE.PARTNO_TYPE DEFAULT NULL,
      ANOBSOLETE                 IN       IAPITYPE.BOOLEAN_TYPE DEFAULT NULL,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SavePart';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRPART                        IAPITYPE.PARTREC_TYPE;
      LNOLDPARTTYPEID               IAPITYPE.ID_TYPE;
      
      LNCURRENTLANGUAGEID           IAPITYPE.LANGUAGEID_TYPE := IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID;     
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
      LRPART.PARTNO := ASPARTNO;
      LRPART.DESCRIPTION := ASDESCRIPTION;
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Base UoM <'
                           || ASBASEUOM
                           || '>, back to standard UoM <'
                           || GETUOMSTANDARDDESCRIPTION( ASBASEUOM )
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      
      LRPART.BASEUOM := GETUOMSTANDARDDESCRIPTION( ASBASEUOM );
      
      LRPART.PARTSOURCE := ASPARTSOURCE;
      LRPART.BASECONVFACTOR := ANBASECONVFACTOR;                  
      
      
      LRPART.BASETOUNIT := GETUOMSTANDARDDESCRIPTION( ASBASETOUNIT );
      
      LRPART.PARTTYPEID := ANPARTTYPEID;
      LRPART.DATEIMPORTED := ADDATEIMPORTED;
      LRPART.EANUPCBARCODE := ASEANUPCBARCODE;
      LRPART.OBSOLETE := ANOBSOLETE;
      
      
      

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := EXISTID( LRPART.PARTNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      IF ( LRPART.DESCRIPTION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Description' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asDescription',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( LRPART.BASEUOM IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Base UoM' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asBaseUom',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( LRPART.PARTSOURCE IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Part Source' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartSource',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( LRPART.BASETOUNIT IS NOT NULL )
      THEN
         IF ( LRPART.BASECONVFACTOR IS NULL )
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                            'Base Conversion Factor' );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anBaseConvFactor',
                                                    IAPIGENERAL.GETLASTERRORTEXT( ),
                                                    GTERRORS );
         END IF;
      END IF;

      
      IF ( LRPART.BASECONVFACTOR IS NOT NULL )
      THEN
         IF ( LRPART.BASETOUNIT IS NULL )
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                            'Conversion UoM' );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asBaseToUnit',
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

      BEGIN
         SELECT PART_TYPE
           INTO LNOLDPARTTYPEID
           FROM PART
          WHERE PART_NO = LRPART.PARTNO;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_PARTNOTFOUND,
                                                            LRPART.PARTNO );
      END;

      UPDATE PART
         
         
         SET DESCRIPTION = DECODE( LNCURRENTLANGUAGEID,
                                   1, LRPART.DESCRIPTION,
                                   DESCRIPTION ),
         
             BASE_UOM = LRPART.BASEUOM,
             PART_SOURCE = LRPART.PARTSOURCE,
             BASE_CONV_FACTOR = LRPART.BASECONVFACTOR,
             BASE_TO_UNIT = LRPART.BASETOUNIT,
             PART_TYPE = LRPART.PARTTYPEID,
             DATE_IMPORTED = LRPART.DATEIMPORTED,
             ALT_PART_NO = LRPART.EANUPCBARCODE,
             OBSOLETE = LRPART.OBSOLETE
       WHERE PART_NO = LRPART.PARTNO;

      
      
      IF ( LNCURRENTLANGUAGEID <> 1 )
      THEN
         INSERTUPDATEPARTDESCRITION( LRPART.PARTNO,
                                     LRPART.DESCRIPTION,
                                     LNCURRENTLANGUAGEID );
      END IF;
      


      IF    (     LRPART.PARTTYPEID IS NOT NULL
              AND LNOLDPARTTYPEID IS NOT NULL
              AND LRPART.PARTTYPEID <> LNOLDPARTTYPEID )
         OR (     LRPART.PARTTYPEID IS NOT NULL
              AND LNOLDPARTTYPEID IS NULL )
         OR (     LRPART.PARTTYPEID IS NULL
              AND LNOLDPARTTYPEID IS NOT NULL )
      THEN
         DELETE FROM ITPRCL
               WHERE PART_NO = LRPART.PARTNO;
      END IF;

      
      
      
      
      
      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF SQLCODE = -20751
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_UOMPARTBASENOTDEVSPEC,
                                                            'Conversion UoM' );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_UOMPARTBASENOTDEVSPEC ) );
         ELSE
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END IF;
   END SAVEPART;

   
   FUNCTION GETPARTS(
      AXDEFAULTFILTER            IN       IAPITYPE.XMLTYPE_TYPE,
      AXPLANTFILTER              IN       IAPITYPE.XMLTYPE_TYPE,
      AQPARTS                    OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetParts';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTDEFAULTFILTER               IAPITYPE.FILTERTAB_TYPE;
      LTPLANTFILTER                 IAPITYPE.FILTERTAB_TYPE;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 ) := GETBASECOLUMNS( 'p' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'part p, class3 c';
   BEGIN
      
      
      
      
      
      IF ( AQPARTS%ISOPEN )
      THEN
         CLOSE AQPARTS;
      END IF;

      LSSQLNULL :=    'select '
                   || LSSELECT
                   || ' from '
                   || LSFROM
                   || ' where p.part_no = null and p.part_type = c.class';

      OPEN AQPARTS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.APPENDXMLFILTER( AXDEFAULTFILTER,
                                               LTDEFAULTFILTER );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LNRETVAL := IAPIGENERAL.APPENDXMLFILTER( AXPLANTFILTER,
                                               LTPLANTFILTER );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LNRETVAL := IAPIPART.GETPARTS( LTDEFAULTFILTER,
                                     LTPLANTFILTER,
                                     AQPARTS,
                                     AQERRORS );

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
   END GETPARTS;

   
   FUNCTION GETMANUFACTURERS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      AQMANUFACTURERS            OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetManufacturers';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRMANUFACTURERS               IAPITYPE.MANUFACTURERREC_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'p.mfc_id '
            || IAPICONSTANTCOLUMN.MANUFACTURERIDCOL
            || ','
            || 'm.description '
            || IAPICONSTANTCOLUMN.MANUFACTURERCOL
            || ','
            || 'p.clearance_no '
            || IAPICONSTANTCOLUMN.CLEARANCENUMBERCOL
            || ','
            || 'p.trade_name '
            || IAPICONSTANTCOLUMN.TRADENAMECOL
            || ','
            || 'p.audit_date '
            || IAPICONSTANTCOLUMN.AUDITDATECOL
            || ','
            || 'p.audit_freq '
            || IAPICONSTANTCOLUMN.AUDITFREQUENCECOL
            || ','
            || 'f_mpl_descr(p.mpl_id) '
            || IAPICONSTANTCOLUMN.MANUFACTURERPLANTCOL
            || ','
            || 'p.intl '
            || IAPICONSTANTCOLUMN.INTERNATIONALCOL;
      LSFROM                        VARCHAR2( 32 ) := 'itprmfc p, itmfc m';
   BEGIN
      
      
      
      
      
      IF ( AQMANUFACTURERS%ISOPEN )
      THEN
         CLOSE AQMANUFACTURERS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE p.part_no = null AND p.mfc_id = m.mfc_id';

      OPEN AQMANUFACTURERS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNRETVAL := EXISTID( ASPARTNO );

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

      
      IF ( AQMANUFACTURERS%ISOPEN )
      THEN
         CLOSE AQMANUFACTURERS;
      END IF;

      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM
               || ' WHERE p.part_no = :PartNo '
               || ' AND '
               || ' p.mfc_id = m.mfc_id';

      
      IF ( AQMANUFACTURERS%ISOPEN )
      THEN
         CLOSE AQMANUFACTURERS;
      END IF;

      
      OPEN AQMANUFACTURERS FOR LSSQL USING ASPARTNO;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETMANUFACTURERS;

   
   FUNCTION PARTUSEDINSPECIFICATION(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'PartUsedInSpecification';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;

      CURSOR LQSPECIFICATION
      IS
         SELECT 'X'
           FROM SPECIFICATION_HEADER
          WHERE PART_NO = ASPARTNO;

      LSDUMMY                       VARCHAR2( 1 );
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN LQSPECIFICATION;

      FETCH LQSPECIFICATION
       INTO LSDUMMY;

      IF LQSPECIFICATION%FOUND
      THEN
         CLOSE LQSPECIFICATION;

         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_PARTUSEDINSPEC,
                                                     ASPARTNO ) );
      ELSE
         CLOSE LQSPECIFICATION;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END PARTUSEDINSPECIFICATION;

   
   FUNCTION CREATEFILTER(
      ANFILTERID                 IN OUT   IAPITYPE.FILTERID_TYPE,
      ANARRAY                    IN       IAPITYPE.NUMVAL_TYPE,
      ATCOLUMN                   IN       IAPITYPE.CHARTAB_TYPE,
      ATOPERATOR                 IN       IAPITYPE.CHARTAB_TYPE,
      ATVALUECHAR                IN       IAPITYPE.CHARTAB_TYPE,
      ATVALUEDATE                IN       IAPITYPE.DATETAB_TYPE,
      ASSORTDESC                 IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASCOMMENT                  IN       IAPITYPE.FILTERDESCRIPTION_TYPE,
      ANOVERWRITE                IN       IAPITYPE.BOOLEAN_TYPE,
      ANOPTIONS                  IN       IAPITYPE.NUMVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CreateFilter';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCURSOR                      IAPITYPE.NUMVAL_TYPE;
      LSSQLSTRING                   IAPITYPE.BUFFER_TYPE;
      LNRESULT                      IAPITYPE.NUMVAL_TYPE;
      LNCOUNTER                     IAPITYPE.NUMVAL_TYPE := 0;
      LNFILTERID                    IAPITYPE.FILTERID_TYPE;

      CURSOR L_COLUMN_CURSOR
      IS
         SELECT COLUMN_NAME
           FROM DBA_TAB_COLUMNS
          WHERE TABLE_NAME = 'ITPFLT';

      CURSOR L_OPERATOR_CURSOR
      IS
         SELECT COLUMN_NAME
           FROM DBA_TAB_COLUMNS
          WHERE TABLE_NAME = 'ITPFLTOP';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNFILTERID := ANFILTERID;

      IF ANOVERWRITE = 1
      THEN
         BEGIN
            UPDATE ITPFLTD
               SET SORT_DESC = ASSORTDESC,
                   DESCRIPTION = ASCOMMENT,
                   OPTIONS = ANOPTIONS
             WHERE FILTER_ID = LNFILTERID;
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
            SELECT SHFLT_SEQ.NEXTVAL
              INTO LNFILTERID
              FROM DUAL;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;

         ANFILTERID := LNFILTERID;

         BEGIN
            INSERT INTO ITPFLTD
                        ( FILTER_ID,
                          USER_ID,
                          SORT_DESC,
                          DESCRIPTION,
                          OPTIONS )
                 VALUES ( LNFILTERID,
                          USER,
                          ASSORTDESC,
                          ASCOMMENT,
                          ANOPTIONS );

            INSERT INTO ITPFLT
                        ( FILTER_ID )
                 VALUES ( LNFILTERID );

            INSERT INTO ITPFLTOP
                        ( FILTER_ID )
                 VALUES ( LNFILTERID );
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      END IF;

      LNCURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR L_ROW IN L_COLUMN_CURSOR
      LOOP
         IF L_ROW.COLUMN_NAME <> 'FILTER_ID'
         THEN
            LSSQLSTRING :=    'UPDATE itpflt SET '
                           || L_ROW.COLUMN_NAME
                           || ' = NULL WHERE filter_id = '
                           || LNFILTERID;

            BEGIN
               DBMS_SQL.PARSE( LNCURSOR,
                               LSSQLSTRING,
                               DBMS_SQL.V7 );
               LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
            EXCEPTION
               WHEN OTHERS
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        SQLERRM );
                  RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
            END;

            DBMS_SQL.PARSE( LNCURSOR,
                            LSSQLSTRING,
                            DBMS_SQL.V7 );
            LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
         END IF;
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LNCURSOR );
      LNCURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR L_ROW IN L_OPERATOR_CURSOR
      LOOP
         IF L_ROW.COLUMN_NAME <> 'FILTER_ID'
         THEN
            LSSQLSTRING :=    'UPDATE itpfltop SET '
                           || L_ROW.COLUMN_NAME
                           || ' = NULL WHERE filter_id = '
                           || LNFILTERID;

            BEGIN
               DBMS_SQL.PARSE( LNCURSOR,
                               LSSQLSTRING,
                               DBMS_SQL.V7 );
               LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
            EXCEPTION
               WHEN OTHERS
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        SQLERRM );
                  RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
            END;

            DBMS_SQL.PARSE( LNCURSOR,
                            LSSQLSTRING,
                            DBMS_SQL.V7 );
            LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
         END IF;
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LNCURSOR );
      LNCURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR L_COUNTER IN 1 .. ANARRAY
      LOOP
         IF ATCOLUMN( LNCOUNTER ) = 'DATE_IMPORTED'
         THEN
            LSSQLSTRING :=
                             'UPDATE itpflt SET '
                          || ATCOLUMN( LNCOUNTER )
                          || ' = '''
                          || ATVALUEDATE( LNCOUNTER )
                          || ''' WHERE filter_id = '
                          || LNFILTERID;
         ELSE
            LSSQLSTRING :=
                             'UPDATE itpflt SET '
                          || ATCOLUMN( LNCOUNTER )
                          || ' = '''
                          || ATVALUECHAR( LNCOUNTER )
                          || ''' WHERE filter_id = '
                          || LNFILTERID;
         END IF;

         BEGIN
            DBMS_SQL.PARSE( LNCURSOR,
                            LSSQLSTRING,
                            DBMS_SQL.V7 );
            LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LNCURSOR );
      LNCURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR LICOUNTER IN 1 .. ANARRAY
      LOOP
         LSSQLSTRING :=
                 'UPDATE itpfltop SET LOG_'
              || ATCOLUMN( LNCOUNTER )
              || ' = Lower('''
              || ATOPERATOR( LNCOUNTER )
              || ''') WHERE filter_id = '
              || LNFILTERID;

         BEGIN
            DBMS_SQL.PARSE( LNCURSOR,
                            LSSQLSTRING,
                            DBMS_SQL.V7 );
            LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LNCURSOR );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CREATEFILTER;

   
   FUNCTION CHECKPART(
      ASFROMPARTNO               IN       IAPITYPE.PARTNO_TYPE,
      ANFROMREVISION             IN       IAPITYPE.REVISION_TYPE,
      ANFROMMAXREV               IN OUT   IAPITYPE.REVISION_TYPE,
      ASTOPARTNO                 IN       IAPITYPE.PARTNO_TYPE,
      ANTOREVISION               IN OUT   IAPITYPE.REVISION_TYPE,
      ANINDEVREV                 IN OUT   IAPITYPE.REVISION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckPart';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
   
      BEGIN
         SELECT   MAX( MAX( SH.REVISION ) )
             INTO ANINDEVREV
             FROM STATUS A,
                  SPECIFICATION_HEADER SH,
                  WORK_FLOW WF,
                  WORKFLOW_GROUP WFG
            WHERE A.STATUS = SH.STATUS
              AND SH.PART_NO = ASTOPARTNO
              AND SH.WORKFLOW_GROUP_ID = WFG.WORKFLOW_GROUP_ID
              AND WFG.WORK_FLOW_ID = WF.WORK_FLOW_ID
              
              
              AND WF.STATUS = SH.STATUS
              
              AND (     (     A.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_DEVELOPMENT
                          AND WF.EXPORT_ERP = '0' )
                    OR (     A.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_SUBMIT
                         AND WF.EXPORT_ERP = '0' )
                    OR (     A.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_REJECT
                         AND WF.EXPORT_ERP = '0' ) )
         
         
         GROUP BY WF.STATUS,
         
                  A.STATUS_TYPE,
                  WF.EXPORT_ERP;
      EXCEPTION     
         WHEN NO_DATA_FOUND
         THEN
            ANINDEVREV := 0;
      END;

      BEGIN
         
         SELECT MAX( REVISION )
           INTO ANFROMMAXREV
           FROM SPECIFICATION_HEADER
          WHERE PART_NO = ASFROMPARTNO;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            ANFROMMAXREV := 0;
      END;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CHECKPART;

   
   FUNCTION CREATESEQUENCE(
      ANSTARTRANGE               IN       IAPITYPE.NUMVAL_TYPE,
      ANENDRANGE                 IN       IAPITYPE.NUMVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      LSSQLSTRING                   VARCHAR2( 2000 );
      LIRESULT                      INTEGER;
      LICURSOR                      INTEGER;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CreateSequence';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      BEGIN
         LNRETVAL := IAPISPECDATASERVER.STOPSPECSERVER;
      END;

      LICURSOR := DBMS_SQL.OPEN_CURSOR;
      LSSQLSTRING := 'DROP SEQUENCE PART_NO_SEQ';
      DBMS_SQL.PARSE( LICURSOR,
                      LSSQLSTRING,
                      DBMS_SQL.V7 );

      BEGIN
         LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      LICURSOR := DBMS_SQL.OPEN_CURSOR;
      LSSQLSTRING := 'CREATE SEQUENCE PART_NO_SEQ START WITH ';
      LSSQLSTRING :=    LSSQLSTRING
                     || ANSTARTRANGE;
      LSSQLSTRING :=    LSSQLSTRING
                     || ' INCREMENT BY 1 MINVALUE ';
      LSSQLSTRING :=    LSSQLSTRING
                     || ANSTARTRANGE;
      LSSQLSTRING :=    LSSQLSTRING
                     || ' MAXVALUE '
                     || ANENDRANGE
                     || ' NOCACHE  NOCYCLE  NOORDER';
      DBMS_SQL.PARSE( LICURSOR,
                      LSSQLSTRING,
                      DBMS_SQL.V7 );

      BEGIN
         LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            LICURSOR := DBMS_SQL.OPEN_CURSOR;
            LSSQLSTRING := 'CREATE SEQUENCE PART_NO_SEQ START WITH 1 INCREMENT BY 1 MINVALUE 1 ';
            LSSQLSTRING :=    LSSQLSTRING
                           || ' MAXVALUE 99999999 NOCACHE  NOCYCLE  NOORDER';
            DBMS_SQL.PARSE( LICURSOR,
                            LSSQLSTRING,
                            DBMS_SQL.V7 );

            BEGIN
               LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
            EXCEPTION
               WHEN OTHERS
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        SQLERRM );
            END;

            UPDATE INTERSPC_CFG
               SET PARAMETER_DATA = TO_CHAR( 1 )
             WHERE SECTION = 'CreateCopy'
               AND PARAMETER = 'AN-StartRange';

            UPDATE INTERSPC_CFG
               SET PARAMETER_DATA = TO_CHAR( 99999999 )
             WHERE SECTION = 'CreateCopy'
               AND PARAMETER = 'AN-EndRange';

            COMMIT;
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      DBMS_SQL.CLOSE_CURSOR( LICURSOR );

      UPDATE INTERSPC_CFG
         SET PARAMETER_DATA = TO_CHAR( ANSTARTRANGE )
       WHERE SECTION = 'CreateCopy'
         AND PARAMETER = 'AN-StartRange';

      UPDATE INTERSPC_CFG
         SET PARAMETER_DATA = TO_CHAR( ANENDRANGE )
       WHERE SECTION = 'CreateCopy'
         AND PARAMETER = 'AN-EndRange';

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CREATESEQUENCE;

   
   FUNCTION VALIDATEPART(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      OUT_OF_RANGE                  EXCEPTION;
      OUT_OF_MANUAL_RANGE           EXCEPTION;
      NOT_NUMERIC                   EXCEPTION;
      INCORRECT_CHAR                EXCEPTION;
      INCORRECT_CHARS               EXCEPTION;
      INVALID_CHAR                  EXCEPTION;
      NOT_ALLOWED                   EXCEPTION;
      LNPARTNO                      NUMBER;
      LNCHECK                       NUMBER;
      LNRANGEBEGIN                  NUMBER;
      LNRANGEEND                    NUMBER;
      LSSTARTWITH                   VARCHAR2( 255 );
      LBCHECKRANGE                  BOOLEAN := TRUE;
      LNINTLPART                    NUMBER := 0;
      LSOVERRIDEPARTVAL             VARCHAR2( 1 );
      LSAUTONUMBERING               VARCHAR2( 1 );
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidatePart';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;

      CURSOR CUR_INV_CHAR
      IS
         SELECT PARAMETER_DATA
           FROM INTERSPC_CFG
          WHERE SECTION = 'CreateCopy'
            AND PARAMETER LIKE 'InvalidChar%';
   BEGIN
      

      
      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         IAPIGENERAL.SESSION.APPLICATIONUSER.USERID := USER;
      END IF;

      SELECT OVERRIDE_PART_VAL
        INTO LSOVERRIDEPARTVAL
        FROM APPLICATION_USER
       WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

      
      SELECT PARAMETER_DATA
        INTO LSAUTONUMBERING
        FROM INTERSPC_CFG
       WHERE PARAMETER = 'AutoNumbering'
         AND SECTION = 'specx';

      SELECT COUNT( * )
        INTO LNINTLPART
        FROM SPEC_PREFIX
       WHERE PREFIX = SUBSTR( ASPARTNO,
                              1,
                                INSTR( ASPARTNO,
                                       '-' )
                              - 1 );

      IF     LNINTLPART = 0
         AND LSAUTONUMBERING = '1'
         AND LSOVERRIDEPARTVAL = 'N'
      THEN
         RAISE NOT_ALLOWED;
      END IF;

      
      BEGIN
         SELECT TO_NUMBER( PARAMETER_DATA )
           INTO LNRANGEBEGIN
           FROM INTERSPC_CFG
          WHERE SECTION = 'CreateCopy'
            AND PARAMETER = 'RangeBegin';

         SELECT TO_NUMBER( PARAMETER_DATA )
           INTO LNRANGEEND
           FROM INTERSPC_CFG
          WHERE SECTION = 'CreateCopy'
            AND PARAMETER = 'RangeEnd';
      EXCEPTION
         WHEN INVALID_NUMBER
         THEN
            
            LBCHECKRANGE := FALSE;
            NULL;
      END;

      IF LBCHECKRANGE
      THEN
         BEGIN
            LNPARTNO := TO_NUMBER( ASPARTNO );
         EXCEPTION
            WHEN OTHERS
            THEN
               
               
               NULL;
         END;

         IF LNPARTNO BETWEEN LNRANGEBEGIN AND LNRANGEEND
         THEN
            
            RAISE OUT_OF_RANGE;
         END IF;
      END IF;

      IF LSAUTONUMBERING = '1'
      THEN
         BEGIN
            SELECT TO_NUMBER( PARAMETER_DATA )
              INTO LNRANGEBEGIN
              FROM INTERSPC_CFG
             WHERE SECTION = 'CreateCopy'
               AND PARAMETER = 'AN-StartRange';

            SELECT TO_NUMBER( PARAMETER_DATA )
              INTO LNRANGEEND
              FROM INTERSPC_CFG
             WHERE SECTION = 'CreateCopy'
               AND PARAMETER = 'AN-EndRange';
         EXCEPTION
            WHEN INVALID_NUMBER
            THEN
               
               LBCHECKRANGE := FALSE;
               NULL;
         END;

         IF LBCHECKRANGE
         THEN
            BEGIN
               LNPARTNO := TO_NUMBER( ASPARTNO );
            EXCEPTION
               WHEN OTHERS
               THEN
                  
                  
                  NULL;
            END;

            IF LNPARTNO BETWEEN LNRANGEBEGIN AND LNRANGEEND
            THEN
               
               RAISE OUT_OF_MANUAL_RANGE;
            END IF;
         END IF;
      END IF;

      
      SELECT PARAMETER_DATA
        INTO LSSTARTWITH
        FROM INTERSPC_CFG
       WHERE SECTION = 'CreateCopy'
         AND PARAMETER = 'StartWith';

      IF LSSTARTWITH <> 'none'
      THEN
         IF LSSTARTWITH = '%'
         THEN
            
            LNCHECK := NULL;

            BEGIN
               LNCHECK := TO_NUMBER( SUBSTR( ASPARTNO,
                                             1,
                                             1 ) );
            EXCEPTION
               WHEN OTHERS
               THEN
                  LNCHECK := NULL;
            END;

            IF LNCHECK IS NOT NULL
            THEN
               
               RAISE INCORRECT_CHAR;
            END IF;
         ELSE
            IF SUBSTR( ASPARTNO,
                       1,
                       1 ) <> LSSTARTWITH
            THEN
               
               RAISE INCORRECT_CHAR;
            END IF;
         END IF;
      END IF;

      
      SELECT PARAMETER_DATA
        INTO LSSTARTWITH
        FROM INTERSPC_CFG
       WHERE SECTION = 'CreateCopy'
         AND PARAMETER = 'StartWithCode';

      IF LSSTARTWITH <> 'none'
      THEN
         IF SUBSTR( ASPARTNO,
                    1,
                    LENGTH( LSSTARTWITH ) ) <> LSSTARTWITH
         THEN
            
            RAISE INCORRECT_CHARS;
         END IF;
      END IF;

      
      FOR REC_INV_CHAR IN CUR_INV_CHAR
      LOOP
         LSSTARTWITH := REC_INV_CHAR.PARAMETER_DATA;

         IF LSSTARTWITH <> 'none'
         THEN
            IF INSTR( ASPARTNO,
                      LSSTARTWITH ) > 0
            THEN
               RAISE INVALID_CHAR;
            END IF;
         END IF;
      END LOOP;

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OUT_OF_RANGE
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_NUMOUTOFRANGE );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN LNRETVAL;
      WHEN OUT_OF_MANUAL_RANGE
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_NUMOUTOFMANRANGE );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN LNRETVAL;
      WHEN NOT_NUMERIC
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_NUMNOTNUMERIC );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN LNRETVAL;
      WHEN INCORRECT_CHAR
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_NUMINCORRECTCHAR );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN LNRETVAL;
      WHEN INVALID_CHAR
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_NUMINVALIDCHAR );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN LNRETVAL;
      WHEN INCORRECT_CHARS
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_NUMINCORRECTCHARS );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN LNRETVAL;
      WHEN NOT_ALLOWED
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_NUMNOTALLOWED );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN LNRETVAL;
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
   END VALIDATEPART;

   
   FUNCTION INITIALISENEWSPEC(
      ASPARTNO                   OUT      IAPITYPE.PARTNO_TYPE,
      ASDESCRIPTION              OUT      IAPITYPE.DESCRIPTION_TYPE,
      ANPARTTYPEID               OUT      IAPITYPE.ID_TYPE,
      ASBASEUOM                  OUT      IAPITYPE.BASEUOM_TYPE,
      ANBASECONVFACTOR           OUT      IAPITYPE.NUMVAL_TYPE,
      ASBASETOUNIT               OUT      IAPITYPE.BASETOUNIT_TYPE,
      ASPARTSOURCE               OUT      IAPITYPE.PARTSOURCE_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'InitialiseNewSpec';
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
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      ASPARTSOURCE := 'I-S';
      
      
      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END INITIALISENEWSPEC;

   
   FUNCTION VALIDATENEWSPEC(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ANPARTTYPEID               IN       IAPITYPE.ID_TYPE,
      ASBASEUOM                  IN       IAPITYPE.BASEUOM_TYPE,
      ANBASECONVFACTOR           IN       IAPITYPE.NUMVAL_TYPE,
      ASBASETOUNIT               IN       IAPITYPE.BASETOUNIT_TYPE,
      ASPARTSOURCE               IN       IAPITYPE.PARTSOURCE_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      CURSOR CUR_EXIST_PR(
         ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE )
      IS
         SELECT COUNT( PART_NO ) COUNT
           FROM PART
          WHERE PART_NO = ASPARTNO;

      
      CURSOR CUR_EXIST_ST(
         ANPARTTYPEID               IN       IAPITYPE.ID_TYPE )
      IS
         SELECT COUNT( CLASS ) COUNT
           FROM CLASS3
          WHERE CLASS = ANPARTTYPEID;

      LCOUNT                        NUMBER;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateNewSpec';
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
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      


      IF NOT ASPARTNO IS NULL
      THEN
         
         FOR REC_EXIST_PR IN CUR_EXIST_PR( ASPARTNO )
         LOOP
            LCOUNT := REC_EXIST_PR.COUNT;
         END LOOP;

         IF LCOUNT <> 0
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_INVALIDPARTNO,
                                                            'PartNo' );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartNo',
                                                    IAPIGENERAL.GETLASTERRORTEXT( ),
                                                    GTERRORS );
         END IF;
      END IF;

      


      
      IF ASDESCRIPTION IS NULL
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Description' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asDescription',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      


      IF NOT ANPARTTYPEID IS NULL
      THEN
         
         FOR REC_EXIST_ST IN CUR_EXIST_ST( ANPARTTYPEID )
         LOOP
            LCOUNT := REC_EXIST_ST.COUNT;
         END LOOP;

         IF LCOUNT = 0
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_INVALIDPARTTYPE,
                                                            ANPARTTYPEID );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anPartTypeId',
                                                    IAPIGENERAL.GETLASTERRORTEXT( ),
                                                    GTERRORS );
         END IF;
      END IF;

       


      
      IF ASBASEUOM IS NULL
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Base UoM' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asBaseUom',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

        


      
      
      IF NOT ASBASETOUNIT IS NULL
      THEN
         IF ANBASECONVFACTOR IS NULL
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                            'Base Conversion Factor' );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anBaseConvFactor',
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

      
      
      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END VALIDATENEWSPEC;

   
   FUNCTION VALIDATEBOM(
      ASFROMPARTNO               IN       IAPITYPE.PARTNO_TYPE,
      ANFROMREVISION             IN       IAPITYPE.REVISION_TYPE,
      ASTOPARTNO                 IN       IAPITYPE.PARTNO_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LTPLANT                       IAPITYPE.PLANTTAB_TYPE;
      LRPLANT                       IAPITYPE.PLANTREC_TYPE;
      LNMESSAGECOUNT                NUMBER;
      LNCOUNTER                     NUMBER;
      LSSTRING                      VARCHAR2( 2000 );
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateBom';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      LNCOUNTER := 0;
      LNMESSAGECOUNT := 0;
      LSSTRING := NULL;
      VALIDATIONBOM( ASFROMPARTNO,
                     ANFROMREVISION,
                     ASTOPARTNO,
                     LTPLANT,
                     LNMESSAGECOUNT );

      FOR LNCOUNTER IN 1 .. LNMESSAGECOUNT
      LOOP
         LRPLANT := LTPLANT( LNCOUNTER );

         IF LSSTRING IS NULL
         THEN
            LSSTRING := LRPLANT.PLANTNO;
         ELSE
            LSSTRING :=    LSSTRING
                        || ', '
                        || LRPLANT.PLANTNO;
         END IF;
      END LOOP;

      IF LNMESSAGECOUNT > 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_PLANTSNOTAVAILABLE,
                                                     LSSTRING ) );
      ELSE
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END VALIDATEBOM;

   
   FUNCTION CHANGEPARTTYPE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANPARTTYPEID               IN       IAPITYPE.ID_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddPart';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       NUMBER;
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

      
      IF ( ASPARTNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_INVALIDPARTNO,
                                                         'PartNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartNo',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      ELSE
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM PART
          WHERE PART_NO = ASPARTNO;

         IF ( LNCOUNT = 0 )
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_PARTNOTFOUND,
                                                            ASPARTNO );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartNo',
                                                    IAPIGENERAL.GETLASTERRORTEXT( ),
                                                    GTERRORS );
         END IF;
      END IF;

      
      IF ANPARTTYPEID IS NULL
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_PARTTYPEISNULL,
                                                         ANPARTTYPEID );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anPartTypeId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      ELSE
         SELECT COUNT( CLASS )
           INTO LNCOUNT
           FROM CLASS3
          WHERE CLASS = ANPARTTYPEID;

         IF ( LNCOUNT = 0 )
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_INVALIDPARTTYPE,
                                                            ANPARTTYPEID );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anPartTypeId',
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

      UPDATE PART
         SET PART_TYPE = ANPARTTYPEID
       WHERE PART_NO = ASPARTNO;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CHANGEPARTTYPE;
END IAPIPART;
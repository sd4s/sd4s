CREATE OR REPLACE PACKAGE BODY iapiSpecificationProcessData
AS
   
   
   
   
   
   
   
   
   
   
   
   PROCEDURE CHECKBASICPDLINEPARAMS(
      ARLINE                     IN       IAPITYPE.SPPDLINEREC_TYPE )
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckBasicPdLineParams';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESSLEVEL                 IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ARLINE.PARTNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PartNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartNo',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARLINE.REVISION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Revision' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRevision',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARLINE.PLANTNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PlantNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPlantNo',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARLINE.LINE IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Line' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asLine',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARLINE.CONFIGURATION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Configuration' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anConfiguration',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 1;

      IF F_CHECK_ITEM_ACCESS( ARLINE.PARTNO,
                              ARLINE.REVISION,
                              0,
                              0,
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
                                                ARLINE.PARTNO,
                                                ARLINE.REVISION,
                                                'PROCESS DATA LINE' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No Edit Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 0;

      IF F_CHECK_ITEM_ACCESS( ARLINE.PARTNO,
                              ARLINE.REVISION,
                              0,
                              0,
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
                                                ARLINE.PARTNO,
                                                ARLINE.REVISION,
                                                'PROCESS DATA LINE' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No View Section Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 2;

      IF F_CHECK_ITEM_ACCESS( ARLINE.PARTNO,
                              ARLINE.REVISION,
                              0,
                              0,
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
                                                ARLINE.PARTNO,
                                                ARLINE.REVISION,
                                                'PROCESS DATA LINE' );
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
   END CHECKBASICPDLINEPARAMS;

   
   PROCEDURE CHECKBASICPDSTAGEPARAMS(
      ARSTAGE                    IN       IAPITYPE.SPPDSTAGEREC_TYPE )
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckBasicPdStageParams';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESSLEVEL                 IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ARSTAGE.PARTNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PartNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartNo',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARSTAGE.REVISION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Revision' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRevision',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARSTAGE.PLANTNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PlantNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPlantNo',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARSTAGE.LINE IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Line' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asLine',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARSTAGE.CONFIGURATION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Configuration' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anConfiguration',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARSTAGE.STAGEID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'StageId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anStageId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 1;

      IF F_CHECK_ITEM_ACCESS( ARSTAGE.PARTNO,
                              ARSTAGE.REVISION,
                              0,
                              0,
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
                                                ARSTAGE.PARTNO,
                                                ARSTAGE.REVISION,
                                                'PROCESS STAGE' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No Edit Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 0;

      IF F_CHECK_ITEM_ACCESS( ARSTAGE.PARTNO,
                              ARSTAGE.REVISION,
                              0,
                              0,
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
                                                ARSTAGE.PARTNO,
                                                ARSTAGE.REVISION,
                                                'PROCESS STAGE' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No View Section Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 2;

      IF F_CHECK_ITEM_ACCESS( ARSTAGE.PARTNO,
                              ARSTAGE.REVISION,
                              0,
                              0,
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
                                                ARSTAGE.PARTNO,
                                                ARSTAGE.REVISION,
                                                'PROCESS STAGE' );
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
   END CHECKBASICPDSTAGEPARAMS;

   
   PROCEDURE CHECKBASICPDSTAGEDATAPARAMS(
      ARSTAGEDATA                IN       IAPITYPE.SPPDSTAGEDATAREC_TYPE )
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckBasicPdStageDataParams';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESSLEVEL                 IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ARSTAGEDATA.PARTNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PartNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartNo',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARSTAGEDATA.REVISION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Revision' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRevision',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARSTAGEDATA.PLANTNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PlantNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPlantNo',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARSTAGEDATA.LINE IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Line' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asLine',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARSTAGEDATA.CONFIGURATION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Configuration' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anConfiguration',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARSTAGEDATA.STAGEID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'StageId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anStageId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 1;

      IF F_CHECK_ITEM_ACCESS( ARSTAGEDATA.PARTNO,
                              ARSTAGEDATA.REVISION,
                              ARSTAGEDATA.SECTIONID,
                              ARSTAGEDATA.SUBSECTIONID,
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
                                                ARSTAGEDATA.PARTNO,
                                                ARSTAGEDATA.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARSTAGEDATA.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARSTAGEDATA.SUBSECTIONID,
                                                             0 ),
                                                'PROCESS DATA STAGE' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No Edit Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 0;

      IF F_CHECK_ITEM_ACCESS( ARSTAGEDATA.PARTNO,
                              ARSTAGEDATA.REVISION,
                              ARSTAGEDATA.SECTIONID,
                              ARSTAGEDATA.SUBSECTIONID,
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
                                                ARSTAGEDATA.PARTNO,
                                                ARSTAGEDATA.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARSTAGEDATA.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARSTAGEDATA.SUBSECTIONID,
                                                             0 ),
                                                'PROCESS DATA STAGE' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No View Section Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 2;

      IF F_CHECK_ITEM_ACCESS( ARSTAGEDATA.PARTNO,
                              ARSTAGEDATA.REVISION,
                              ARSTAGEDATA.SECTIONID,
                              ARSTAGEDATA.SUBSECTIONID,
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
                                                ARSTAGEDATA.PARTNO,
                                                ARSTAGEDATA.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARSTAGEDATA.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARSTAGEDATA.SUBSECTIONID,
                                                             0 ),
                                                'PROCESS DATA STAGE' );
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
   END CHECKBASICPDSTAGEDATAPARAMS;

   
   PROCEDURE UPDATEDISPLAY(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANLAYOUTID                 IN       IAPITYPE.ID_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      ANPROCESSLINEREV           IN       IAPITYPE.REVISION_TYPE,
      ANSTAGE                    IN       IAPITYPE.STAGEID_TYPE )
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR CUR_DISPL(
         ANLAYOUTID                 IN       IAPITYPE.ID_TYPE,
         ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
      IS
         SELECT *
           FROM PROPERTY_LAYOUT
          WHERE LAYOUT_ID = ANLAYOUTID
            AND REVISION = ANREVISION;

      TYPE DISPL_TABLE IS TABLE OF NUMBER
         INDEX BY BINARY_INTEGER;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'UpdateDisplay';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNDISPLAYFORMATREV            IAPITYPE.REVISION_TYPE;
      LIDISPLCOUNTER                INTEGER := 0;
      LIDISPLPOINTER                INTEGER := 0;
      LISTACKPOINTER                INTEGER := 22;
      LNCURSOR                      IAPITYPE.NUMVAL_TYPE;
      LSSQLSTRING                   VARCHAR2( 2000 );
      LSSQLSTRING2                  VARCHAR2( 2000 );
      LSSQLSTRING3                  VARCHAR2( 2000 );
      LSTEST                        IAPITYPE.STRING_TYPE;
      LNRESULT                      IAPITYPE.NUMVAL_TYPE;
      LTPROPDISPL                   DISPL_TABLE;
      LBUPDATE                      BOOLEAN;
      LSFIELD                       IAPITYPE.STRING_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );

      BEGIN
         SELECT MAX( REVISION )
           INTO LNDISPLAYFORMATREV
           FROM LAYOUT
          WHERE LAYOUT_ID = ANLAYOUTID
            AND STATUS = 2;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
      END;

      LIDISPLCOUNTER := 0;

      FOR REC_DISPL IN CUR_DISPL( ANLAYOUTID,
                                  LNDISPLAYFORMATREV )
      LOOP
         LIDISPLCOUNTER :=   LIDISPLCOUNTER
                           + 1;
         LTPROPDISPL( LIDISPLCOUNTER ) := REC_DISPL.FIELD_ID;
      END LOOP;

      LIDISPLPOINTER := LIDISPLCOUNTER;
      LSSQLSTRING2 := ' ';

      FOR LISTACKCOUNTER IN 1 .. LISTACKPOINTER
      LOOP
         LBUPDATE := TRUE;

         FOR LIDISPLCOUNTER IN 1 .. LIDISPLPOINTER
         LOOP
            IF LISTACKCOUNTER = LTPROPDISPL( LIDISPLCOUNTER )
            THEN
               LBUPDATE := FALSE;
            END IF;
         END LOOP;

         IF LBUPDATE
         THEN
            BEGIN
               SELECT DECODE( LISTACKCOUNTER,
                              1, IAPICONSTANT.COLUMN_NUM_1,
                              2, IAPICONSTANT.COLUMN_NUM_2,
                              3, IAPICONSTANT.COLUMN_NUM_3,
                              4, IAPICONSTANT.COLUMN_NUM_4,
                              5, IAPICONSTANT.COLUMN_NUM_5,
                              6, IAPICONSTANT.COLUMN_NUM_6,
                              7, IAPICONSTANT.COLUMN_NUM_7,
                              8, IAPICONSTANT.COLUMN_NUM_8,
                              9, IAPICONSTANT.COLUMN_NUM_9,
                              10, IAPICONSTANT.COLUMN_NUM_10,
                              11, IAPICONSTANT.COLUMN_CHAR_1,
                              12, IAPICONSTANT.COLUMN_CHAR_2,
                              13, IAPICONSTANT.COLUMN_CHAR_3,
                              14, IAPICONSTANT.COLUMN_CHAR_4,
                              15, IAPICONSTANT.COLUMN_CHAR_5,
                              16, IAPICONSTANT.COLUMN_CHAR_6,
                              17, IAPICONSTANT.COLUMN_BOOLEAN_1,
                              18, IAPICONSTANT.COLUMN_BOOLEAN_2,
                              19, IAPICONSTANT.COLUMN_BOOLEAN_3,
                              20, IAPICONSTANT.COLUMN_BOOLEAN_4,
                              21, IAPICONSTANT.COLUMN_DATE_1,
                              22, IAPICONSTANT.COLUMN_DATE_2,
                              23, IAPICONSTANT.COLUMN_UOM_ID,
                              24, IAPICONSTANT.COLUMN_ATTRIBUTE,
                              25, IAPICONSTANT.COLUMN_TEST_METHOD,
                              26, IAPICONSTANT.COLUMN_CHARACTERISTIC,
                              27, IAPICONSTANT.COLUMN_PROPERTY,
                              30, IAPICONSTANT.COLUMN_CH_2,
                              31, IAPICONSTANT.COLUMN_CH_3,
                              32, IAPICONSTANT.COLUMN_TM_DET_1,
                              33, IAPICONSTANT.COLUMN_TM_DET_2,
                              34, IAPICONSTANT.COLUMN_TM_DET_3,
                              35, IAPICONSTANT.COLUMN_TM_DET_4,
                              40, IAPICONSTANT.COLUMN_INFO )
                 INTO LSFIELD
                 FROM DUAL;

               IF LSSQLSTRING2 = ' '
               THEN
                  LSSQLSTRING2 :=    LSFIELD
                                  || '=NULL';
               ELSE
                  LSSQLSTRING2 :=    LSSQLSTRING2
                                  || ','
                                  || LSFIELD
                                  || '=NULL';
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        SQLERRM );
            END;
         END IF;
      END LOOP;

      BEGIN
         LSSQLSTRING := 'UPDATE SPECIFICATION_LINE_PROP set ';
         LSSQLSTRING3 :=
               ' WHERE part_no = '
            || ''''
            || ASPARTNO
            || ''''
            || ' AND revision = '
            || ANREVISION
            || ' AND plant = '
            || ''''
            || ASPLANTNO
            || ''''
            || ' AND line = '
            || ''''
            || ASLINE
            || ''''
            || ' AND configuration = '
            || ANCONFIGURATION
            || ' AND PROCESS_LINE_rev = '
            || ANPROCESSLINEREV
            || ' AND stage = '
            || ANSTAGE;
         LSSQLSTRING :=    LSSQLSTRING
                        || LSSQLSTRING2
                        || LSSQLSTRING3;
         LNCURSOR := DBMS_SQL.OPEN_CURSOR;
         DBMS_SQL.PARSE( LNCURSOR,
                         LSSQLSTRING,
                         DBMS_SQL.V7 );
         LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
         DBMS_SQL.CLOSE_CURSOR( LNCURSOR );
      EXCEPTION
         WHEN OTHERS
         THEN
            IF DBMS_SQL.IS_OPEN( LNCURSOR )
            THEN
               DBMS_SQL.CLOSE_CURSOR( LNCURSOR );
            END IF;

            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
      END;
   END UPDATEDISPLAY;

   
   FUNCTION CHECKMULTILANGUAGE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNMULTILANGUAGE               IAPITYPE.BOOLEAN_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckMultiLanguage';
   BEGIN
      
      LNRETVAL := IAPISPECIFICATION.ISMULTILANGUAGE( ASPARTNO,
                                                     ANREVISION,
                                                     LNMULTILANGUAGE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF ( LNMULTILANGUAGE = 0 )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SPECNOTMULTILANG,
                                                     ASPARTNO,
                                                     ANREVISION ) );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   END CHECKMULTILANGUAGE;

   
   FUNCTION REMOVESTAGEDATAINTERNAL(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      ANSTAGEID                  IN       IAPITYPE.STAGEID_TYPE,
      ANCHECKSEQUENCE            IN       IAPITYPE.BOOLEAN_TYPE,
      ANSEQUENCE                 IN       IAPITYPE.LINEPROPSEQUENCE_TYPE,
      ASCALLINGMETHOD            IN       IAPITYPE.METHOD_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQSTAGE
      IS
         SELECT STAGE
           FROM STAGE
          WHERE STAGE = ANSTAGEID;

      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRSTAGEDATA                   IAPITYPE.SPPDSTAGEDATAREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
      LNSTAGE                       STAGE.STAGE%TYPE;
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
                           ASCALLINGMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTSPPDSTAGEDATA.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRSTAGEDATA.PARTNO := ASPARTNO;
      LRSTAGEDATA.REVISION := ANREVISION;
      LRSTAGEDATA.PLANTNO := ASPLANTNO;
      LRSTAGEDATA.LINE := ASLINE;
      LRSTAGEDATA.CONFIGURATION := ANCONFIGURATION;
      LRSTAGEDATA.LINEREVISION := 0;
      LRSTAGEDATA.STAGEID := ANSTAGEID;
      LRSTAGEDATA.SEQUENCE := ANSEQUENCE;
      GTSPPDSTAGEDATA( 0 ) := LRSTAGEDATA;

      GTINFO( 0 ) := LRINFO;
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           ASCALLINGMETHOD,
                           'Call CUSTOM Pre-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     ASCALLINGMETHOD,
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
                                  ASCALLINGMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END IF;

      
      LRINFO := GTINFO( 0 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           ASCALLINGMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      
      
      
      
      
      CHECKBASICPDSTAGEDATAPARAMS( LRSTAGEDATA );

      IF ( ANCHECKSEQUENCE = 1 )
      THEN
         
         IF ( LRSTAGEDATA.SEQUENCE IS NULL )
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            ASCALLINGMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                            'StageSequence' );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSequence',
                                                    IAPIGENERAL.GETLASTERRORTEXT( ),
                                                    GTERRORS );
         END IF;
      END IF;

      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( LNRETVAL );
         END IF;
      END IF;

      
      LNRETVAL := IAPISPECIFICATIONACCESS.GETMODIFIABLEACCESS( ASPARTNO,
                                                               ANREVISION,
                                                               LNACCESS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              ASCALLINGMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF ( LNACCESS = 0 )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     ASCALLINGMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_NOUPDATEACCESS,
                                                     ASPARTNO,
                                                     ANREVISION ) );
      END IF;

      
      LNRETVAL := IAPISPECIFICATIONPROCESSDATA.EXISTSECPROCESSDATA( ASPARTNO,
                                                                    ANREVISION,
                                                                    LNSECTIONID,
                                                                    LNSUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              ASCALLINGMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      OPEN LQSTAGE;

      FETCH LQSTAGE
       INTO LNSTAGE;

      IF LQSTAGE%NOTFOUND
      THEN
         CLOSE LQSTAGE;

         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     ASCALLINGMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_STAGENOTFOUND,
                                                     ANSTAGEID ) );
      END IF;

      CLOSE LQSTAGE;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           ASCALLINGMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ANCHECKSEQUENCE = 0 )
      THEN
         DELETE FROM ITSHLNPROPLANG
               WHERE PART_NO = ASPARTNO
                 AND REVISION = ANREVISION
                 AND PLANT = ASPLANTNO
                 AND LINE = ASLINE
                 AND CONFIGURATION = ANCONFIGURATION
                 AND STAGE = ANSTAGEID;

         DELETE FROM SPECIFICATION_LINE_PROP
               WHERE PART_NO = ASPARTNO
                 AND REVISION = ANREVISION
                 AND PLANT = ASPLANTNO
                 AND LINE = ASLINE
                 AND CONFIGURATION = ANCONFIGURATION
                 AND PROCESS_LINE_REV = 0
                 AND STAGE = ANSTAGEID;
      ELSE
         DELETE FROM ITSHLNPROPLANG
               WHERE PART_NO = ASPARTNO
                 AND REVISION = ANREVISION
                 AND PLANT = ASPLANTNO
                 AND LINE = ASLINE
                 AND CONFIGURATION = ANCONFIGURATION
                 AND STAGE = ANSTAGEID
                 AND SEQUENCE_NO = ANSEQUENCE;

         DELETE FROM SPECIFICATION_LINE_PROP
               WHERE PART_NO = ASPARTNO
                 AND REVISION = ANREVISION
                 AND PLANT = ASPLANTNO
                 AND LINE = ASLINE
                 AND CONFIGURATION = ANCONFIGURATION
                 AND PROCESS_LINE_REV = 0
                 AND STAGE = ANSTAGEID
                 AND SEQUENCE_NO = ANSEQUENCE;
      END IF;

      
      INSERT INTO SPECDATA_SERVER
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID )
           VALUES ( LRSTAGEDATA.PARTNO,
                    LRSTAGEDATA.REVISION,
                    LNSECTIONID,
                    LNSUBSECTIONID );

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRSTAGEDATA.PARTNO,
                                                       LRSTAGEDATA.REVISION,
                                                       LNSECTIONID,
                                                       LNSUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              ASCALLINGMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRSTAGEDATA.PARTNO,
                                                LRSTAGEDATA.REVISION );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              ASCALLINGMETHOD,
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
                           ASCALLINGMETHOD,
                           'Call CUSTOM Post-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     ASCALLINGMETHOD,
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
                                  ASCALLINGMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           ASCALLINGMETHOD,
                           'PostConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               ASCALLINGMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVESTAGEDATAINTERNAL;

   
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

   
   
   

   
   
   
   
   
   
   FUNCTION GETLINES(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      AQLINES                    OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetLines';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
      LRFRAME                       IAPITYPE.FRAMEREC_TYPE;
      LRPDLINE                      IAPITYPE.SPPDLINEREC_TYPE;
      LRGETPDLINE                   SPPDLINERECORD_TYPE := SPPDLINERECORD_TYPE( NULL,
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
         :=    'sl.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', sl.revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', sl.plant '
            || IAPICONSTANTCOLUMN.PLANTNOCOL
            || ', sl.line '
            || IAPICONSTANTCOLUMN.LINECOL
            || ', sl.configuration '
            || IAPICONSTANTCOLUMN.CONFIGURATIONCOL
            || ', sl.item_part_no '
            || IAPICONSTANTCOLUMN.ITEMPARTNOCOL
            || ', sl.item_revision '
            || IAPICONSTANTCOLUMN.ITEMREVISIONCOL
            || ', sl.sequence '
            || IAPICONSTANTCOLUMN.SEQUENCECOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'specification_line sl';
   BEGIN
      
      
      
      
      
      IF ( AQLINES%ISOPEN )
      THEN
         CLOSE AQLINES;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE sl.part_no = NULL';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQLNULL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQLINES FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      GTSPPDLINES.DELETE;
      LRPDLINE.PARTNO := ASPARTNO;
      LRPDLINE.REVISION := ANREVISION;
      GTSPPDLINES( 0 ) := LRPDLINE;
      
      
      
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
      
      
      LNRETVAL := IAPISPECIFICATION.EXISTID( ASPARTNO,
                                             ANREVISION );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATIONPROCESSDATA.EXISTSECPROCESSDATA( ASPARTNO,
                                                                    ANREVISION,
                                                                    LNSECTIONID,
                                                                    LNSUBSECTIONID );

      IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SPSECTIONNOTFOUND )
      THEN
         
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

         
         BEGIN
            SELECT SECTION_ID,
                   SUB_SECTION_ID
              INTO LNSECTIONID,
                   LNSUBSECTIONID
              FROM FRAME_SECTION
             WHERE FRAME_NO = LRFRAME.FRAMENO
               AND REVISION = LRFRAME.REVISION
               AND OWNER = LRFRAME.OWNER
               AND TYPE = IAPICONSTANT.SECTIONTYPE_PROCESSDATA
               AND REF_ID = 0;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_FRAMESECTIONNOTFOUND,
                                                           LRFRAME.FRAMENO,
                                                           LRFRAME.REVISION,
                                                           '',
                                                           'ProcessData',
                                                           '' ) );
         END;
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
         || ' WHERE sl.part_no = :PartNo '
         || ' AND sl.revision = :Revision '
         || ' AND f_check_item_access(sl.part_no, sl.revision, :SectionId, :SubSectionId, :ItemType) = 1 ';
      LSSQL :=
                LSSQL
             || ' ORDER BY '
             || IAPICONSTANTCOLUMN.PLANTNOCOL
             || ','
             || IAPICONSTANTCOLUMN.LINECOL
             || ','
             || IAPICONSTANTCOLUMN.CONFIGURATIONCOL;
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQLINES FOR LSSQL USING ASPARTNO,
      ANREVISION,
      LNSECTIONID,
      LNSUBSECTIONID,
      IAPICONSTANT.SECTIONTYPE_PROCESSDATA;

      
      
      
      GTGETPDLINES.DELETE;

      LOOP
         LRPDLINE := NULL;

         FETCH AQLINES
          INTO LRPDLINE;

         EXIT WHEN AQLINES%NOTFOUND;
         LRGETPDLINE.PARTNO := LRPDLINE.PARTNO;
         LRGETPDLINE.REVISION := LRPDLINE.REVISION;
         LRGETPDLINE.PLANTNO := LRPDLINE.PLANTNO;
         LRGETPDLINE.LINE := LRPDLINE.LINE;
         LRGETPDLINE.CONFIGURATION := LRPDLINE.CONFIGURATION;
         LRGETPDLINE.ITEMPARTNO := LRPDLINE.ITEMPARTNO;
         LRGETPDLINE.ITEMREVISION := LRPDLINE.ITEMREVISION;
         LRGETPDLINE.SEQUENCE := LRPDLINE.SEQUENCE;
         LRGETPDLINE.ROWINDEX := LRPDLINE.ROWINDEX;
         GTGETPDLINES.EXTEND;
         GTGETPDLINES( GTGETPDLINES.COUNT ) := LRGETPDLINE;
      END LOOP;

      CLOSE AQLINES;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQLINES FOR LSSQLNULL;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Post-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     LSMETHOD,
                                                     'POST',
                                                     GTERRORS );
      LSSELECT :=
            ' Partno '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', Revision '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', Plantno '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', Line '
         || IAPICONSTANTCOLUMN.LINECOL
         || ', Configuration '
         || IAPICONSTANTCOLUMN.CONFIGURATIONCOL
         || ', Itempartno '
         || IAPICONSTANTCOLUMN.ITEMPARTNOCOL
         || ', Itemrevision '
         || IAPICONSTANTCOLUMN.ITEMREVISIONCOL
         || ', Sequence '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ', Rowindex '
         || IAPICONSTANTCOLUMN.ROWINDEXCOL;
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM TABLE( CAST( :gtGetPdLines AS SpPdLineTable_Type ) ) '
               || ' ORDER BY  RowIndex ';

      IF ( AQLINES%ISOPEN )
      THEN
         CLOSE AQLINES;
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQLINES FOR LSSQL USING GTGETPDLINES;

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
   END GETLINES;

   
   FUNCTION GETSTAGES(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE DEFAULT NULL,
      ASLINE                     IN       IAPITYPE.LINE_TYPE DEFAULT NULL,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE DEFAULT NULL,
      AQSTAGES                   OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetStages';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
      LRFRAME                       IAPITYPE.FRAMEREC_TYPE;
      LRPDSTAGE                     IAPITYPE.SPPDSTAGEREC_TYPE;
      LRGETPDSTAGE                  SPPDSTAGERECORD_TYPE
                                        := SPPDSTAGERECORD_TYPE( NULL,
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
      LSSELECT                      VARCHAR2( 4096 )
         :=    'ss.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', ss.revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', ss.plant '
            || IAPICONSTANTCOLUMN.PLANTNOCOL
            || ', ss.line '
            || IAPICONSTANTCOLUMN.LINECOL
            || ', ss.configuration '
            || IAPICONSTANTCOLUMN.CONFIGURATIONCOL
            || ', ss.process_line_rev '
            || IAPICONSTANTCOLUMN.LINEREVISIONCOL
            || ', ss.stage '
            || IAPICONSTANTCOLUMN.STAGEIDCOL
            || ', f_sth_descr(ss.stage) '
            || IAPICONSTANTCOLUMN.STAGECOL
            || ', ss.sequence_no '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ', ss.recirculate_to '
            || IAPICONSTANTCOLUMN.RECIRCULATETOCOL
            || ', ss.text_type '
            || IAPICONSTANTCOLUMN.FREETEXTIDCOL
            || ', ss.display_format '
            || IAPICONSTANTCOLUMN.DISPLAYFORMATIDCOL
            || ', ss.display_format_rev '
            || IAPICONSTANTCOLUMN.DISPLAYFORMATREVISIONCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'specification_stage ss, stage s';
   BEGIN
      
      
      
      
      
      IF ( AQSTAGES%ISOPEN )
      THEN
         CLOSE AQSTAGES;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE ss.part_no = NULL and ss.stage = s.stage';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQLNULL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQSTAGES FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      GTSPPDSTAGES.DELETE;
      LRPDSTAGE.PARTNO := ASPARTNO;
      LRPDSTAGE.REVISION := ANREVISION;
      LRPDSTAGE.PLANTNO := ASPLANTNO;
      LRPDSTAGE.LINE := ASLINE;
      LRPDSTAGE.CONFIGURATION := ANCONFIGURATION;
      LRPDSTAGE.LINEREVISION := 0;
      GTSPPDSTAGES( 0 ) := LRPDSTAGE;
      
      
      
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
      
      
      LNRETVAL := IAPISPECIFICATION.EXISTID( ASPARTNO,
                                             ANREVISION );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATIONPROCESSDATA.EXISTSECPROCESSDATA( ASPARTNO,
                                                                    ANREVISION,
                                                                    LNSECTIONID,
                                                                    LNSUBSECTIONID );

      IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SPSECTIONNOTFOUND )
      THEN
         
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

         
         BEGIN
            SELECT SECTION_ID,
                   SUB_SECTION_ID
              INTO LNSECTIONID,
                   LNSUBSECTIONID
              FROM FRAME_SECTION
             WHERE FRAME_NO = LRFRAME.FRAMENO
               AND REVISION = LRFRAME.REVISION
               AND OWNER = LRFRAME.OWNER
               AND TYPE = IAPICONSTANT.SECTIONTYPE_PROCESSDATA
               AND REF_ID = 0;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_FRAMESECTIONNOTFOUND,
                                                           LRFRAME.FRAMENO,
                                                           LRFRAME.REVISION,
                                                           '',
                                                           'ProcessData',
                                                           '' ) );
         END;
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
         || ' WHERE ss.part_no = :PartNo AND ss.revision = :Revision '
         || '   AND ss.plant = NVL(:PlantNo, ss.plant) '
         || '   AND ss.line = NVL(:Line, ss.line) '
         || '   AND ss.configuration = NVL(:Configuration, ss.configuration) '
         || '   AND ss.process_line_rev = 0 '
         || '   AND ss.stage = s.stage '
         || '   AND f_check_item_access(part_no, revision, :section_id, :sub_section_id, :SectionType) = 1 ';
      LSSQL :=    LSSQL
               || ' ORDER BY '
               || IAPICONSTANTCOLUMN.SEQUENCECOL;
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQSTAGES FOR LSSQL
      USING ASPARTNO,
            ANREVISION,
            ASPLANTNO,
            ASLINE,
            ANCONFIGURATION,
            LNSECTIONID,
            LNSUBSECTIONID,
            IAPICONSTANT.SECTIONTYPE_PROCESSDATA;

      
      
      
      GTGETPDSTAGES.DELETE;

      LOOP
         LRPDSTAGE := NULL;

         FETCH AQSTAGES
          INTO LRPDSTAGE;

         EXIT WHEN AQSTAGES%NOTFOUND;
         LRGETPDSTAGE.PARTNO := LRPDSTAGE.PARTNO;
         LRGETPDSTAGE.REVISION := LRPDSTAGE.REVISION;
         LRGETPDSTAGE.PLANTNO := LRPDSTAGE.PLANTNO;
         LRGETPDSTAGE.LINE := LRPDSTAGE.LINE;
         LRGETPDSTAGE.CONFIGURATION := LRPDSTAGE.CONFIGURATION;
         LRGETPDSTAGE.LINEREVISION := LRPDSTAGE.LINEREVISION;
         LRGETPDSTAGE.STAGEID := LRPDSTAGE.STAGEID;
         LRGETPDSTAGE.STAGE := LRPDSTAGE.STAGE;
         LRGETPDSTAGE.SEQUENCE := LRPDSTAGE.SEQUENCE;
         LRGETPDSTAGE.RECIRCULATETO := LRPDSTAGE.RECIRCULATETO;
         LRGETPDSTAGE.FREETEXTID := LRPDSTAGE.FREETEXTID;
         LRGETPDSTAGE.DISPLAYFORMATID := LRPDSTAGE.DISPLAYFORMATID;
         LRGETPDSTAGE.DISPLAYFORMATREVISION := LRPDSTAGE.DISPLAYFORMATREVISION;
         LRGETPDSTAGE.ROWINDEX := LRPDSTAGE.ROWINDEX;
         GTGETPDSTAGES.EXTEND;
         GTGETPDSTAGES( GTGETPDSTAGES.COUNT ) := LRGETPDSTAGE;
      END LOOP;

      CLOSE AQSTAGES;

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQLNULL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQSTAGES FOR LSSQLNULL;

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
         || ', Plantno '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', Line '
         || IAPICONSTANTCOLUMN.LINECOL
         || ', Configuration '
         || IAPICONSTANTCOLUMN.CONFIGURATIONCOL
         || ', Linerevision '
         || IAPICONSTANTCOLUMN.LINEREVISIONCOL
         || ', StageId '
         || IAPICONSTANTCOLUMN.STAGEIDCOL
         || ', Stage '
         || IAPICONSTANTCOLUMN.STAGECOL
         || ', Sequence '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ', Recirculateto '
         || IAPICONSTANTCOLUMN.RECIRCULATETOCOL
         || ', Freetextid '
         || IAPICONSTANTCOLUMN.FREETEXTIDCOL
         || ', Displayformatid '
         || IAPICONSTANTCOLUMN.DISPLAYFORMATIDCOL
         || ', Displayformatrevision '
         || IAPICONSTANTCOLUMN.DISPLAYFORMATREVISIONCOL
         || ', Rowindex '
         || IAPICONSTANTCOLUMN.ROWINDEXCOL;
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM TABLE( CAST( :gtGetPdStages AS SpPdStageTable_Type ) ) '
               || ' ORDER BY  RowIndex ';

      IF ( AQSTAGES%ISOPEN )
      THEN
         CLOSE AQSTAGES;
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQSTAGES FOR LSSQL USING GTGETPDSTAGES;

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
   END GETSTAGES;


   FUNCTION GETSTAGEDATA(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE DEFAULT NULL,
      ASLINE                     IN       IAPITYPE.LINE_TYPE DEFAULT NULL,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE DEFAULT NULL,
      ANSTAGEID                  IN       IAPITYPE.STAGEID_TYPE DEFAULT NULL,
      ANALTERNATIVELANGUAGEID    IN       IAPITYPE.LANGUAGEID_TYPE DEFAULT NULL,
      AQSTAGEDATA                OUT      IAPITYPE.REF_TYPE,
      AQSTAGEFREETEXT            OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetStageData';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRPDSTAGEDATA                 IAPITYPE.GETSTAGEDATAREC_TYPE;
      LRGETPDSTAGEDATA              SPPDSTAGEDATARECORD_TYPE
         := SPPDSTAGEDATARECORD_TYPE( NULL,
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
                                      NULL,
                                      NULL,
                                      NULL,
                                      NULL,
                                      NULL,
                                      NULL,
                                      NULL,
                                      NULL,
                                      NULL );
      LRPDSTAGEFREETEXT             IAPITYPE.SPPDSTAGEFREETEXTREC_TYPE;
      LRGETPDSTAGEFREETEXT          SPPDSTAGEFREETEXTRECORD_TYPE
                                             := SPPDSTAGEFREETEXTRECORD_TYPE( NULL,
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
         :=    'slp.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', slp.revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', slp.section_id '
            || IAPICONSTANTCOLUMN.SECTIONIDCOL
            || ', slp.section_rev '
            || IAPICONSTANTCOLUMN.SECTIONREVISIONCOL
            || ', slp.sub_section_id '
            || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
            || ', slp.sub_section_rev '
            || IAPICONSTANTCOLUMN.SUBSECTIONREVISIONCOL
            || ', slp.stage '
            || IAPICONSTANTCOLUMN.STAGEIDCOL
            || ', slp.property '
            || IAPICONSTANTCOLUMN.PROPERTYIDCOL
            || ', slp.property_rev '
            || IAPICONSTANTCOLUMN.PROPERTYREVISIONCOL
            || ', f_sph_descr(1, slp.property, slp.property_rev) '
            || IAPICONSTANTCOLUMN.PROPERTYCOL
            || ', slp.attribute '
            || IAPICONSTANTCOLUMN.ATTRIBUTEIDCOL
            || ', slp.attribute_rev '
            || IAPICONSTANTCOLUMN.ATTRIBUTEREVISIONCOL
            || ', f_ath_descr(1, slp.attribute, slp.attribute_rev) '
            || IAPICONSTANTCOLUMN.ATTRIBUTECOL
            || ', slp.test_method '
            || IAPICONSTANTCOLUMN.TESTMETHODIDCOL
            || ', slp.test_method_rev '
            || IAPICONSTANTCOLUMN.TESTMETHODREVISIONCOL
            || ', f_tmh_descr(1, slp.test_method, slp.test_method_rev) '
            || IAPICONSTANTCOLUMN.TESTMETHODCOL
            || ', slp.char_1 '
            || IAPICONSTANTCOLUMN.STRING1COL
            || ', slp.char_2 '
            || IAPICONSTANTCOLUMN.STRING2COL
            || ', slp.char_3 '
            || IAPICONSTANTCOLUMN.STRING3COL
            || ', slp.char_4 '
            || IAPICONSTANTCOLUMN.STRING4COL
            || ', slp.char_5 '
            || IAPICONSTANTCOLUMN.STRING5COL
            || ', slp.char_6 '
            || IAPICONSTANTCOLUMN.STRING6COL
            || ', DECODE(slp.boolean_1,''1'',1,0) '
            || IAPICONSTANTCOLUMN.BOOLEAN1COL
            || ', DECODE(slp.boolean_2,''1'',1,0) '
            || IAPICONSTANTCOLUMN.BOOLEAN2COL
            || ', DECODE(slp.boolean_3,''1'',1,0) '
            || IAPICONSTANTCOLUMN.BOOLEAN3COL
            || ', DECODE(slp.boolean_4,''1'',1,0) '
            || IAPICONSTANTCOLUMN.BOOLEAN4COL
            || ', slp.date_1 '
            || IAPICONSTANTCOLUMN.DATE1COL
            || ', slp.date_2 '
            || IAPICONSTANTCOLUMN.DATE2COL
            || ', slp.characteristic '
            || IAPICONSTANTCOLUMN.CHARACTERISTICID1COL
            || ', slp.characteristic_rev '
            || IAPICONSTANTCOLUMN.CHARACTERISTICREVISION1COL
            || ', f_chh_descr(1, slp.characteristic, slp.characteristic_rev) '
            || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION1COL
            || ', slp.num_1 '
            || IAPICONSTANTCOLUMN.NUMERIC1COL
            || ', slp.num_2 '
            || IAPICONSTANTCOLUMN.NUMERIC2COL
            || ', slp.num_3 '
            || IAPICONSTANTCOLUMN.NUMERIC3COL
            || ', slp.num_4 '
            || IAPICONSTANTCOLUMN.NUMERIC4COL
            || ', slp.num_5 '
            || IAPICONSTANTCOLUMN.NUMERIC5COL
            || ', slp.num_6 '
            || IAPICONSTANTCOLUMN.NUMERIC6COL
            || ', slp.num_7 '
            || IAPICONSTANTCOLUMN.NUMERIC7COL
            || ', slp.num_8 '
            || IAPICONSTANTCOLUMN.NUMERIC8COL
            || ', slp.num_9 '
            || IAPICONSTANTCOLUMN.NUMERIC9COL
            || ', slp.num_10 '
            || IAPICONSTANTCOLUMN.NUMERIC10COL
            || ', slp.association '
            || IAPICONSTANTCOLUMN.ASSOCIATIONID1COL
            || ', slp.association_rev '
            || IAPICONSTANTCOLUMN.ASSOCIATIONREVISION1COL
            || ', slp.intl '
            || IAPICONSTANTCOLUMN.INTERNATIONALCOL
            || ', f_find_part_pg_limit(slp.part_no, slp.revision, slp.section_id, slp.sub_section_id, slp.stage, slp.property, slp.uom_id, slp.association, 2) '
            || IAPICONSTANTCOLUMN.UPPERLIMITCOL
            || ', f_find_part_pg_limit(slp.part_no, slp.revision, slp.section_id, slp.sub_section_id, slp.stage, slp.property, slp.uom_id, slp.association, 1) '
            || IAPICONSTANTCOLUMN.LOWERLIMITCOL
            || ', slp.uom_id '
            || IAPICONSTANTCOLUMN.UOMIDCOL
            || ', slp.uom_rev '
            || IAPICONSTANTCOLUMN.UOMREVISIONCOL
            || ', DECODE(slp.value_type, 2, slp.uom, f_umh_descr(1, slp.uom_id, slp.uom_rev)) '
            || IAPICONSTANTCOLUMN.UOMCOL
            || ', f_sth_descr(slp.stage, slp.stage_rev) '
            || IAPICONSTANTCOLUMN.STAGECOL
            || ', slp.plant '
            || IAPICONSTANTCOLUMN.PLANTNOCOL
            || ', slp.configuration '
            || IAPICONSTANTCOLUMN.CONFIGURATIONCOL
            || ', slp.process_line_rev '
            || IAPICONSTANTCOLUMN.LINEREVISIONCOL
            || ', slp.line '
            || IAPICONSTANTCOLUMN.LINECOL
            || ', slp.text '
            || IAPICONSTANTCOLUMN.TEXTCOL
            || ', slp.sequence_no '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ', slp.value_type '
            || IAPICONSTANTCOLUMN.VALUETYPECOL
            || ', slp.component_part '
            || IAPICONSTANTCOLUMN.COMPONENTPARTNOCOL
            || ', f_sh_descr( 1, slp.component_part, null ) '
            || IAPICONSTANTCOLUMN.COMPONENTDESCRIPTIONCOL
            || ', slp.stage_rev '
            || IAPICONSTANTCOLUMN.STAGEREVISIONCOL
            || ', slp.quantity '
            || IAPICONSTANTCOLUMN.QUANTITYCOL
            || ', DECODE(slp.value_type, 2, DECODE(slp.uom, ''%'', f_get_bom_val(sl.Item_Part_No, sl.Item_Revision, slp.plant, slp.alternative, slp.bom_usage,  slp.component_part, NULL), slp.quantity), -999) '
            || IAPICONSTANTCOLUMN.QUANTITYBOMPCTCOL
            || ', DECODE(slp.value_type, 2, DECODE(slp.uom, ''%'', f_get_bom_qu(sl.Item_Part_No, sl.Item_Revision, slp.plant, slp.alternative, slp.bom_usage, slp.component_part, NULL), slp.uom), '''') '
            || IAPICONSTANTCOLUMN.UOMBOMPCTCOL
            || ', slp.alternative '
            || IAPICONSTANTCOLUMN.ALTERNATIVECOL
            || ', slp.bom_usage '
            || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
            || ', slpl.lang_id '
            || IAPICONSTANTCOLUMN.ALTERNATIVELANGUAGEIDCOL
            || ', NVL(slpl.char_1,slp.char_1) '
            || IAPICONSTANTCOLUMN.ALTERNATIVESTRING1COL
            || ', NVL(slpl.char_2,slp.char_2) '
            || IAPICONSTANTCOLUMN.ALTERNATIVESTRING2COL
            || ', NVL(slpl.char_3,slp.char_3) '
            || IAPICONSTANTCOLUMN.ALTERNATIVESTRING3COL
            || ', NVL(slpl.char_4,slp.char_4) '
            || IAPICONSTANTCOLUMN.ALTERNATIVESTRING4COL
            || ', NVL(slpl.char_5,slp.char_5) '
            || IAPICONSTANTCOLUMN.ALTERNATIVESTRING5COL
            || ', NVL(slpl.char_6,slp.char_6) '
            || IAPICONSTANTCOLUMN.ALTERNATIVESTRING6COL
            || ', NVL(slpl.text,slp.text) '
            || IAPICONSTANTCOLUMN.ALTERNATIVETEXTCOL
            || ', DECODE(f_ProcessData_prop_lang(slp.part_no, slp.revision,slp.plant, slp.line,slp.configuration, slp.stage, slp.property, slp.attribute, slp.sequence_no, 0),''x'',1,0) '
            || IAPICONSTANTCOLUMN.TRANSLATEDCOL
            || ', f_get_spec_owner(slp.component_part, 0) '
            || IAPICONSTANTCOLUMN.OWNERCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'specification_line sl, specification_line_prop slp, itshlnproplang slpl';
      
      LSSELECTFT                    VARCHAR2( 4096 )
         :=    'slt.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', slt.revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', slt.plant '
            || IAPICONSTANTCOLUMN.PLANTNOCOL
            || ', slt.line '
            || IAPICONSTANTCOLUMN.LINECOL
            || ', slt.configuration '
            || IAPICONSTANTCOLUMN.CONFIGURATIONCOL
            || ', slt.stage '
            || IAPICONSTANTCOLUMN.STAGEIDCOL
            || ', slt.text_type '
            || IAPICONSTANTCOLUMN.FREETEXTIDCOL
            || ', f_fth_descr(slt.lang_id, slt.text_type, 0, 1) '
            || IAPICONSTANTCOLUMN.ITEMDESCRIPTIONCOL
            || ', slt.text '
            || IAPICONSTANTCOLUMN.TEXTCOL
            || ', slt.lang_id '
            || IAPICONSTANTCOLUMN.LANGUAGEIDCOL;
      LSFROMFT                      IAPITYPE.STRING_TYPE := 'specification_line_text slt';
   BEGIN
       
       
       
       
       
      
      IF ( AQSTAGEDATA%ISOPEN )
      THEN
         CLOSE AQSTAGEDATA;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE slp.part_no = NULL ';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQLNULL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQSTAGEDATA FOR LSSQLNULL;

      
      IF ( AQSTAGEFREETEXT%ISOPEN )
      THEN
         CLOSE AQSTAGEFREETEXT;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECTFT
                   || ' FROM '
                   || LSFROMFT
                   || ' WHERE slt.part_no = NULL';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQLNULL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQSTAGEFREETEXT FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      GTGETSTAGEDATA.DELETE;
      LRPDSTAGEDATA.PARTNO := ASPARTNO;
      LRPDSTAGEDATA.REVISION := ANREVISION;
      LRPDSTAGEDATA.PLANTNO := ASPLANTNO;
      LRPDSTAGEDATA.LINE := ASLINE;
      LRPDSTAGEDATA.CONFIGURATION := ANCONFIGURATION;
      LRPDSTAGEDATA.STAGEID := ANSTAGEID;
      GTGETSTAGEDATA( 0 ) := LRPDSTAGEDATA;
      
      
      
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
      
      LSSQL :=
            'SELECT '
         || LSSELECT
         || ' FROM '
         || LSFROM   
         || ' WHERE slp.part_no = :PartNo '
         || '   AND slp.revision = :Revision '
         || '   AND slp.stage = NVL(:StageId, slp.stage) '
         || '   AND slp.plant = NVL(:PlantNo, slp.plant) '
         || '   AND slp.line = NVL(:Line, slp.line) '
         || '   AND slp.configuration = NVL(:Configuration, slp.configuration) '
         || '   AND sl.part_no = slp.part_no '
         || '   AND sl.revision = slp.revision '
         || '   AND sl.plant = slp.plant '
         || '   AND sl.line  = slp.Line '
         || '   AND sl.configuration = slp.Configuration '
         || '   AND slp.part_no = slpl.part_no(+) '   
         || '   AND slp.stage = slpl.stage(+) '
         || '   AND slp.revision = slpl.revision(+) '
         || '   AND slp.plant = slpl.plant(+) '
         || '   AND slp.line  = slpl.Line(+) '
         || '   AND slp.configuration = slpl.Configuration(+) '
         || '   AND slp.property = slpl.property(+) '
         || '   AND slp.attribute = slpl.attribute(+) '
         || '   AND slp.sequence_no = slpl.sequence_no(+) '
         || '   AND slpl.lang_id(+) = '
         || NVL( ANALTERNATIVELANGUAGEID,
                 -1 )
         || ' ORDER BY '
         || IAPICONSTANTCOLUMN.SEQUENCECOL;
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQSTAGEDATA FOR LSSQL USING ASPARTNO,
      ANREVISION,
      ANSTAGEID,
      ASPLANTNO,
      ASLINE,
      ANCONFIGURATION;

      
      LSSQL :=
            'SELECT '
         || LSSELECTFT
         || ' FROM '
         || LSFROMFT
         || ' WHERE slt.part_no = :PartNo '
         || '   AND slt.revision = :Revision '
         || '   AND slt.stage = NVL(:StageId, slt.stage) '
         || '   AND slt.plant = NVL(:PlantNo, slt.plant) '
         || '   AND slt.line = NVL(:Line, slt.line) '
         || '   AND slt.configuration = NVL(:Configuration, slt.configuration) '
         || '   AND slt.lang_id IN (1, NVL(:AlternativeLanguageId,1))';
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQSTAGEFREETEXT FOR LSSQL USING ASPARTNO,
      ANREVISION,
      ANSTAGEID,
      ASPLANTNO,
      ASLINE,
      ANCONFIGURATION,
      ANALTERNATIVELANGUAGEID;

      
       
       
      GTGETPDSTAGEDATA.DELETE;

      LOOP
         LRPDSTAGEDATA := NULL;

         FETCH AQSTAGEDATA
          INTO LRPDSTAGEDATA;

         EXIT WHEN AQSTAGEDATA%NOTFOUND;
         LRGETPDSTAGEDATA.PARTNO := LRPDSTAGEDATA.PARTNO;
         LRGETPDSTAGEDATA.REVISION := LRPDSTAGEDATA.REVISION;
         LRGETPDSTAGEDATA.SECTIONID := LRPDSTAGEDATA.SECTIONID;
         LRGETPDSTAGEDATA.SECTIONREVISION := LRPDSTAGEDATA.SECTIONREVISION;
         LRGETPDSTAGEDATA.SUBSECTIONID := LRPDSTAGEDATA.SUBSECTIONID;
         LRGETPDSTAGEDATA.SUBSECTIONREVISION := LRPDSTAGEDATA.SUBSECTIONREVISION;
         LRGETPDSTAGEDATA.STAGEID := LRPDSTAGEDATA.STAGEID;
         LRGETPDSTAGEDATA.PROPERTYID := LRPDSTAGEDATA.PROPERTYID;
         LRGETPDSTAGEDATA.PROPERTYREVISION := LRPDSTAGEDATA.PROPERTYREVISION;
         LRGETPDSTAGEDATA.PROPERTY := LRPDSTAGEDATA.PROPERTY;
         LRGETPDSTAGEDATA.ATTRIBUTEID := LRPDSTAGEDATA.ATTRIBUTEID;
         LRGETPDSTAGEDATA.ATTRIBUTEREVISION := LRPDSTAGEDATA.ATTRIBUTEREVISION;
         LRGETPDSTAGEDATA.ATTRIBUTE := LRPDSTAGEDATA.ATTRIBUTE;
         LRGETPDSTAGEDATA.TESTMETHODID := LRPDSTAGEDATA.TESTMETHODID;
         LRGETPDSTAGEDATA.TESTMETHODREVISION := LRPDSTAGEDATA.TESTMETHODREVISION;
         LRGETPDSTAGEDATA.TESTMETHOD := LRPDSTAGEDATA.TESTMETHOD;
         LRGETPDSTAGEDATA.STRING1 := LRPDSTAGEDATA.STRING1;
         LRGETPDSTAGEDATA.STRING2 := LRPDSTAGEDATA.STRING2;
         LRGETPDSTAGEDATA.STRING3 := LRPDSTAGEDATA.STRING3;
         LRGETPDSTAGEDATA.STRING4 := LRPDSTAGEDATA.STRING4;
         LRGETPDSTAGEDATA.STRING5 := LRPDSTAGEDATA.STRING5;
         LRGETPDSTAGEDATA.STRING6 := LRPDSTAGEDATA.STRING6;
         LRGETPDSTAGEDATA.BOOLEAN1 := LRPDSTAGEDATA.BOOLEAN1;
         LRGETPDSTAGEDATA.BOOLEAN2 := LRPDSTAGEDATA.BOOLEAN2;
         LRGETPDSTAGEDATA.BOOLEAN3 := LRPDSTAGEDATA.BOOLEAN3;
         LRGETPDSTAGEDATA.BOOLEAN4 := LRPDSTAGEDATA.BOOLEAN4;
         LRGETPDSTAGEDATA.DATE1 := LRPDSTAGEDATA.DATE1;
         LRGETPDSTAGEDATA.DATE2 := LRPDSTAGEDATA.DATE2;
         LRGETPDSTAGEDATA.CHARACTERISTICID1 := LRPDSTAGEDATA.CHARACTERISTICID1;
         LRGETPDSTAGEDATA.CHARACTERISTICREVISION1 := LRPDSTAGEDATA.CHARACTERISTICREVISION1;
         LRGETPDSTAGEDATA.CHARACTERISTICDESCRIPTION1 := LRPDSTAGEDATA.CHARACTERISTICDESCRIPTION1;
         LRGETPDSTAGEDATA.NUMERIC1 := LRPDSTAGEDATA.NUMERIC1;
         LRGETPDSTAGEDATA.NUMERIC2 := LRPDSTAGEDATA.NUMERIC2;
         LRGETPDSTAGEDATA.NUMERIC3 := LRPDSTAGEDATA.NUMERIC3;
         LRGETPDSTAGEDATA.NUMERIC4 := LRPDSTAGEDATA.NUMERIC4;
         LRGETPDSTAGEDATA.NUMERIC5 := LRPDSTAGEDATA.NUMERIC5;
         LRGETPDSTAGEDATA.NUMERIC6 := LRPDSTAGEDATA.NUMERIC6;
         LRGETPDSTAGEDATA.NUMERIC7 := LRPDSTAGEDATA.NUMERIC7;
         LRGETPDSTAGEDATA.NUMERIC8 := LRPDSTAGEDATA.NUMERIC8;
         LRGETPDSTAGEDATA.NUMERIC9 := LRPDSTAGEDATA.NUMERIC9;
         LRGETPDSTAGEDATA.NUMERIC10 := LRPDSTAGEDATA.NUMERIC10;
         LRGETPDSTAGEDATA.ASSOCIATIONID1 := LRPDSTAGEDATA.ASSOCIATIONID1;
         LRGETPDSTAGEDATA.ASSOCIATIONREVISION1 := LRPDSTAGEDATA.ASSOCIATIONREVISION1;
         LRGETPDSTAGEDATA.INTERNATIONAL := LRPDSTAGEDATA.INTERNATIONAL;
         LRGETPDSTAGEDATA.UPPERLIMIT := LRPDSTAGEDATA.UPPERLIMIT;
         LRGETPDSTAGEDATA.LOWERLIMIT := LRPDSTAGEDATA.LOWERLIMIT;
         LRGETPDSTAGEDATA.UOMID := LRPDSTAGEDATA.UOMID;
         LRGETPDSTAGEDATA.UOMREVISION := LRPDSTAGEDATA.UOMREVISION;
         LRGETPDSTAGEDATA.UOM := LRPDSTAGEDATA.UOM;
         LRGETPDSTAGEDATA.STAGE := LRPDSTAGEDATA.STAGE;
         LRGETPDSTAGEDATA.PLANTNO := LRPDSTAGEDATA.PLANTNO;
         LRGETPDSTAGEDATA.CONFIGURATION := LRPDSTAGEDATA.CONFIGURATION;
         LRGETPDSTAGEDATA.LINEREVISION := LRPDSTAGEDATA.LINEREVISION;
         LRGETPDSTAGEDATA.LINE := LRPDSTAGEDATA.LINE;
         LRGETPDSTAGEDATA.TEXT := LRPDSTAGEDATA.TEXT;
         LRGETPDSTAGEDATA.SEQUENCE := LRPDSTAGEDATA.SEQUENCE;
         LRGETPDSTAGEDATA.VALUETYPE := LRPDSTAGEDATA.VALUETYPE;
         LRGETPDSTAGEDATA.COMPONENTPARTNO := LRPDSTAGEDATA.COMPONENTPARTNO;
         LRGETPDSTAGEDATA.ITEMDESCRIPTION := LRPDSTAGEDATA.ITEMDESCRIPTION;
         LRGETPDSTAGEDATA.STAGEREVISION := LRPDSTAGEDATA.STAGEREVISION;
         LRGETPDSTAGEDATA.QUANTITY := LRPDSTAGEDATA.QUANTITY;
         LRGETPDSTAGEDATA.QUANTITYBOMPCT := LRPDSTAGEDATA.QUANTITYBOMPCT;
         LRGETPDSTAGEDATA.UOMBOMPCT := LRPDSTAGEDATA.UOMBOMPCT;
         LRGETPDSTAGEDATA.BOMALTERNATIVE := LRPDSTAGEDATA.BOMALTERNATIVE;
         LRGETPDSTAGEDATA.BOMUSAGEID := LRPDSTAGEDATA.BOMUSAGEID;
         LRGETPDSTAGEDATA.ALTERNATIVELANGUAGEID := LRPDSTAGEDATA.ALTERNATIVELANGUAGEID;
         LRGETPDSTAGEDATA.ALTERNATIVESTRING1 := LRPDSTAGEDATA.ALTERNATIVESTRING1;
         LRGETPDSTAGEDATA.ALTERNATIVESTRING2 := LRPDSTAGEDATA.ALTERNATIVESTRING2;
         LRGETPDSTAGEDATA.ALTERNATIVESTRING3 := LRPDSTAGEDATA.ALTERNATIVESTRING3;
         LRGETPDSTAGEDATA.ALTERNATIVESTRING4 := LRPDSTAGEDATA.ALTERNATIVESTRING4;
         LRGETPDSTAGEDATA.ALTERNATIVESTRING5 := LRPDSTAGEDATA.ALTERNATIVESTRING5;
         LRGETPDSTAGEDATA.ALTERNATIVESTRING6 := LRPDSTAGEDATA.ALTERNATIVESTRING6;
         LRGETPDSTAGEDATA.ALTERNATIVETEXT := LRPDSTAGEDATA.ALTERNATIVETEXT;
         LRGETPDSTAGEDATA.TRANSLATED := LRPDSTAGEDATA.TRANSLATED;
         LRGETPDSTAGEDATA.OWNER := LRPDSTAGEDATA.OWNER;
         LRGETPDSTAGEDATA.ROWINDEX := LRPDSTAGEDATA.ROWINDEX;
         GTGETPDSTAGEDATA.EXTEND;
         GTGETPDSTAGEDATA( GTGETPDSTAGEDATA.COUNT ) := LRGETPDSTAGEDATA;
      END LOOP;

      CLOSE AQSTAGEDATA;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE slp.part_no = NULL';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQLNULL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQSTAGEDATA FOR LSSQLNULL;

      GTGETPDSTAGEFREETEXTS.DELETE;

      LOOP
         LRPDSTAGEFREETEXT := NULL;

         FETCH AQSTAGEFREETEXT
          INTO LRPDSTAGEFREETEXT;

         EXIT WHEN AQSTAGEFREETEXT%NOTFOUND;
         LRGETPDSTAGEFREETEXT.PARTNO := LRPDSTAGEFREETEXT.PARTNO;
         LRGETPDSTAGEFREETEXT.REVISION := LRPDSTAGEFREETEXT.REVISION;
         LRGETPDSTAGEFREETEXT.PLANTNO := LRPDSTAGEFREETEXT.PLANTNO;
         LRGETPDSTAGEFREETEXT.LINE := LRPDSTAGEFREETEXT.LINE;
         LRGETPDSTAGEFREETEXT.CONFIGURATION := LRPDSTAGEFREETEXT.CONFIGURATION;
         LRGETPDSTAGEFREETEXT.STAGEID := LRPDSTAGEFREETEXT.STAGEID;
         LRGETPDSTAGEFREETEXT.FREETEXTID := LRPDSTAGEFREETEXT.FREETEXTID;
         LRGETPDSTAGEFREETEXT.ITEMDESCRIPTION := LRPDSTAGEFREETEXT.ITEMDESCRIPTION;
         LRGETPDSTAGEFREETEXT.TEXT := LRPDSTAGEFREETEXT.TEXT;
         LRGETPDSTAGEFREETEXT.LANGUAGEID := LRPDSTAGEFREETEXT.ALTERNATIVELANGUAGEID;
         LRGETPDSTAGEFREETEXT.ROWINDEX := LRPDSTAGEFREETEXT.ROWINDEX;
         GTGETPDSTAGEFREETEXTS.EXTEND;
         GTGETPDSTAGEFREETEXTS( GTGETPDSTAGEFREETEXTS.COUNT ) := LRGETPDSTAGEFREETEXT;
      END LOOP;

      CLOSE AQSTAGEFREETEXT;

      LSSQLNULL :=    'SELECT '
                   || LSSELECTFT
                   || ' FROM '
                   || LSFROMFT
                   || ' WHERE slt.part_no = NULL';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQLNULL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQSTAGEFREETEXT FOR LSSQLNULL;

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
         || ', Stageid '
         || IAPICONSTANTCOLUMN.STAGEIDCOL
         || ', Propertyid '
         || IAPICONSTANTCOLUMN.PROPERTYIDCOL
         || ', Propertyrevision '
         || IAPICONSTANTCOLUMN.PROPERTYREVISIONCOL
         || ', Property '
         || IAPICONSTANTCOLUMN.PROPERTYCOL
         || ', Attributeid '
         || IAPICONSTANTCOLUMN.ATTRIBUTEIDCOL
         || ', Attributerevision '
         || IAPICONSTANTCOLUMN.ATTRIBUTEREVISIONCOL
         || ', Attribute '
         || IAPICONSTANTCOLUMN.ATTRIBUTECOL
         || ', Testmethodid '
         || IAPICONSTANTCOLUMN.TESTMETHODIDCOL
         || ', Testmethodrevision '
         || IAPICONSTANTCOLUMN.TESTMETHODREVISIONCOL
         || ', Testmethod '
         || IAPICONSTANTCOLUMN.TESTMETHODCOL
         || ', String1 '
         || IAPICONSTANTCOLUMN.STRING1COL
         || ', String2 '
         || IAPICONSTANTCOLUMN.STRING2COL
         || ', String3 '
         || IAPICONSTANTCOLUMN.STRING3COL
         || ', String4 '
         || IAPICONSTANTCOLUMN.STRING4COL
         || ', String5 '
         || IAPICONSTANTCOLUMN.STRING5COL
         || ', String6 '
         || IAPICONSTANTCOLUMN.STRING6COL
         || ', Boolean1 '
         || IAPICONSTANTCOLUMN.BOOLEAN1COL
         || ', Boolean2 '
         || IAPICONSTANTCOLUMN.BOOLEAN2COL
         || ', Boolean3 '
         || IAPICONSTANTCOLUMN.BOOLEAN3COL
         || ', Boolean4 '
         || IAPICONSTANTCOLUMN.BOOLEAN4COL
         || ', Date1 '
         || IAPICONSTANTCOLUMN.DATE1COL
         || ', Date2 '
         || IAPICONSTANTCOLUMN.DATE2COL
         || ', Characteristicid1 '
         || IAPICONSTANTCOLUMN.CHARACTERISTICID1COL
         || ', Characteristicrevision1 '
         || IAPICONSTANTCOLUMN.CHARACTERISTICREVISION1COL
         || ', Characteristicdescription1 '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION1COL
         || ', Numeric1 '
         || IAPICONSTANTCOLUMN.NUMERIC1COL
         || ', Numeric2 '
         || IAPICONSTANTCOLUMN.NUMERIC2COL
         || ', Numeric3 '
         || IAPICONSTANTCOLUMN.NUMERIC3COL
         || ', Numeric4 '
         || IAPICONSTANTCOLUMN.NUMERIC4COL
         || ', Numeric5 '
         || IAPICONSTANTCOLUMN.NUMERIC5COL
         || ', Numeric6 '
         || IAPICONSTANTCOLUMN.NUMERIC6COL
         || ', Numeric7 '
         || IAPICONSTANTCOLUMN.NUMERIC7COL
         || ', Numeric8 '
         || IAPICONSTANTCOLUMN.NUMERIC8COL
         || ', Numeric9 '
         || IAPICONSTANTCOLUMN.NUMERIC9COL
         || ', Numeric10 '
         || IAPICONSTANTCOLUMN.NUMERIC10COL
         || ', Associationid1 '
         || IAPICONSTANTCOLUMN.ASSOCIATIONID1COL
         || ', Associationrevision1 '
         || IAPICONSTANTCOLUMN.ASSOCIATIONREVISION1COL
         || ', International '
         || IAPICONSTANTCOLUMN.INTERNATIONALCOL
         || ', Upperlimit '
         || IAPICONSTANTCOLUMN.UPPERLIMITCOL
         || ', Lowerlimit '
         || IAPICONSTANTCOLUMN.LOWERLIMITCOL
         || ', Uomid '
         || IAPICONSTANTCOLUMN.UOMIDCOL
         || ', Uomrevision '
         || IAPICONSTANTCOLUMN.UOMREVISIONCOL
         || ', Uom '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ', Stage '
         || IAPICONSTANTCOLUMN.STAGECOL
         || ', Plantno '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', Configuration '
         || IAPICONSTANTCOLUMN.CONFIGURATIONCOL
         || ', Linerevision '
         || IAPICONSTANTCOLUMN.LINEREVISIONCOL
         || ', Line '
         || IAPICONSTANTCOLUMN.LINECOL
         || ', Text '
         || IAPICONSTANTCOLUMN.TEXTCOL
         || ', Sequence '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ', Valuetype '
         || IAPICONSTANTCOLUMN.VALUETYPECOL
         || ', Componentpartno '
         || IAPICONSTANTCOLUMN.COMPONENTPARTNOCOL
         || ', Itemdescription '
         || IAPICONSTANTCOLUMN.COMPONENTDESCRIPTIONCOL
         || ', Stagerevision '
         || IAPICONSTANTCOLUMN.STAGEREVISIONCOL
         || ', Quantity '
         || IAPICONSTANTCOLUMN.QUANTITYCOL
         || ', Quantitybompct '
         || IAPICONSTANTCOLUMN.QUANTITYBOMPCTCOL
         || ', Uombompct '
         || IAPICONSTANTCOLUMN.UOMBOMPCTCOL
         || ', Bomalternative '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', Bomusageid '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', Alternativelanguageid '
         || IAPICONSTANTCOLUMN.ALTERNATIVELANGUAGEIDCOL
         || ', Alternativestring1 '
         || IAPICONSTANTCOLUMN.ALTERNATIVESTRING1COL
         || ', Alternativestring2 '
         || IAPICONSTANTCOLUMN.ALTERNATIVESTRING2COL
         || ', Alternativestring3 '
         || IAPICONSTANTCOLUMN.ALTERNATIVESTRING3COL
         || ', Alternativestring4 '
         || IAPICONSTANTCOLUMN.ALTERNATIVESTRING4COL
         || ', Alternativestring5 '
         || IAPICONSTANTCOLUMN.ALTERNATIVESTRING5COL
         || ', Alternativestring6 '
         || IAPICONSTANTCOLUMN.ALTERNATIVESTRING6COL
         || ', Alternativetext '
         || IAPICONSTANTCOLUMN.ALTERNATIVETEXTCOL
         || ', Translated '
         || IAPICONSTANTCOLUMN.TRANSLATEDCOL
         || ', Owner '
         || IAPICONSTANTCOLUMN.OWNERCOL
         || ', Rowindex '
         || IAPICONSTANTCOLUMN.ROWINDEXCOL;
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM TABLE( CAST( :gtGetPdStageData AS SpPdStageDataTable_Type ) ) '
               || ' ORDER BY  RowIndex ';

      
      IF ( AQSTAGEDATA%ISOPEN )
      THEN
         CLOSE AQSTAGEDATA;
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQSTAGEDATA FOR LSSQL USING GTGETPDSTAGEDATA;

      LSSELECTFT :=
            'Partno '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', Revision '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', Plantno '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', Line '
         || IAPICONSTANTCOLUMN.LINECOL
         || ', Configuration '
         || IAPICONSTANTCOLUMN.CONFIGURATIONCOL
         || ', Stageid '
         || IAPICONSTANTCOLUMN.STAGEIDCOL
         || ', Freetextid '
         || IAPICONSTANTCOLUMN.FREETEXTIDCOL
         || ', Itemdescription '
         || IAPICONSTANTCOLUMN.ITEMDESCRIPTIONCOL
         || ', Text '
         || IAPICONSTANTCOLUMN.TEXTCOL
         || ', Languageid '
         || IAPICONSTANTCOLUMN.LANGUAGEIDCOL
         || ', Rowindex '
         || IAPICONSTANTCOLUMN.ROWINDEXCOL;
      LSSQL :=    'SELECT '
               || LSSELECTFT
               || ' FROM TABLE( CAST( :gtGetPdStageFreeTexts AS SpPdStageFreeTextTable_Type ) ) '
               || ' ORDER BY  RowIndex ';

      
      IF ( AQSTAGEFREETEXT%ISOPEN )
      THEN
         CLOSE AQSTAGEFREETEXT;
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQSTAGEFREETEXT FOR LSSQL USING GTGETPDSTAGEFREETEXTS;

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
   END GETSTAGEDATA;

   
   FUNCTION ADDLINE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      ASUSEPART                  IN       IAPITYPE.PARTNO_TYPE DEFAULT NULL,
      ANUSEPARTREVISION          IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      ANSEQUENCE                 IN       IAPITYPE.SEQUENCENR_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQLINE
      IS
         SELECT 1
           FROM SPECIFICATION_LINE
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PLANT = ASPLANTNO
            AND LINE = ASLINE
            AND CONFIGURATION = ANCONFIGURATION
            AND PROCESS_LINE_REV = 0;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddLine';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRLINE                        IAPITYPE.SPPDLINEREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSDUMMY                       IAPITYPE.BOOLEAN_TYPE;
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
      LRFRAME                       IAPITYPE.FRAMEREC_TYPE;
      LFHANDLE                      IAPITYPE.FLOAT_TYPE;
      LNMAXREVISION                 IAPITYPE.NUMVAL_TYPE;
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
      GTSPPDLINES.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRLINE.PARTNO := ASPARTNO;
      LRLINE.REVISION := ANREVISION;
      LRLINE.PLANTNO := ASPLANTNO;
      LRLINE.LINE := ASLINE;
      LRLINE.CONFIGURATION := ANCONFIGURATION;
      GTSPPDLINES( 0 ) := LRLINE;

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
      
      
      
      
      
      
      
      
      CHECKBASICPDLINEPARAMS( LRLINE );

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

      
      OPEN LQLINE;

      FETCH LQLINE
       INTO LSDUMMY;

      IF LQLINE%FOUND
      THEN
         CLOSE LQLINE;

         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SPPDLINEEXITS,
                                                     ASPARTNO,
                                                     ANREVISION,
                                                     ASPLANTNO,
                                                     ASLINE,
                                                     0,
                                                     ANCONFIGURATION ) );
      END IF;

      CLOSE LQLINE;

      
      IF ( ASUSEPART IS NOT NULL )
      THEN
         LNRETVAL := IAPISPECIFICATION.EXISTID( ASUSEPART,
                                                ANUSEPARTREVISION );

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
      
      LNRETVAL := IAPISPECIFICATIONPROCESSDATA.EXISTSECPROCESSDATA( ASPARTNO,
                                                                    ANREVISION,
                                                                    LNSECTIONID,
                                                                    LNSUBSECTIONID );

      IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SPSECTIONNOTFOUND )
      THEN
         
         LNRETVAL := IAPISPECIFICATION.GETFRAME( LRLINE.PARTNO,
                                                 LRLINE.REVISION,
                                                 LRFRAME );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         
         BEGIN
            SELECT SECTION_ID,
                   SUB_SECTION_ID
              INTO LNSECTIONID,
                   LNSUBSECTIONID
              FROM FRAME_SECTION
             WHERE FRAME_NO = LRFRAME.FRAMENO
               AND REVISION = LRFRAME.REVISION
               AND OWNER = LRFRAME.OWNER
               AND TYPE = IAPICONSTANT.SECTIONTYPE_PROCESSDATA
               AND REF_ID = 0;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_FRAMESECTIONNOTFOUND,
                                                           LRFRAME.FRAMENO,
                                                           LRFRAME.REVISION,
                                                           '',
                                                           'ProcessData',
                                                           '' ) );
         END;

         
         LNRETVAL :=
            IAPISPECIFICATIONSECTION.ADDSECTIONITEM( LRLINE.PARTNO,
                                                     LRLINE.REVISION,
                                                     LNSECTIONID,
                                                     LNSUBSECTIONID,
                                                     IAPICONSTANT.SECTIONTYPE_PROCESSDATA,
                                                     0,
                                                     AFHANDLE => LFHANDLE );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      ELSIF( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      
      INSERT INTO SPECIFICATION_LINE
                  ( PART_NO,
                    REVISION,
                    PLANT,
                    LINE,
                    CONFIGURATION,
                    PROCESS_LINE_REV,
                    ITEM_PART_NO,
                    ITEM_REVISION,
                    SEQUENCE )
           VALUES ( ASPARTNO,
                    ANREVISION,
                    ASPLANTNO,
                    ASLINE,
                    ANCONFIGURATION,
                    0,
                    ASUSEPART,
                    ANUSEPARTREVISION,
                    ANSEQUENCE );

      
      
      LNRETVAL := IAPISPECIFICATIONPROCESSDATA.UPDATEDATA( ASPARTNO,
                                                           ANREVISION );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      INSERT INTO SPECDATA_SERVER
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID )
           VALUES ( LRLINE.PARTNO,
                    LRLINE.REVISION,
                    LNSECTIONID,
                    LNSUBSECTIONID );

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRLINE.PARTNO,
                                                       LRLINE.REVISION,
                                                       LNSECTIONID,
                                                       LNSUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRLINE.PARTNO,
                                                LRLINE.REVISION );

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
   END ADDLINE;

   
   FUNCTION REMOVELINE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQLINE
      IS
         SELECT 1
           FROM SPECIFICATION_LINE
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PLANT = ASPLANTNO
            AND LINE = ASLINE
            AND CONFIGURATION = ANCONFIGURATION
            AND PROCESS_LINE_REV = 0;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveLine';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRLINE                        IAPITYPE.SPPDLINEREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSDUMMY                       IAPITYPE.BOOLEAN_TYPE;
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
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
      GTSPPDLINES.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRLINE.PARTNO := ASPARTNO;
      LRLINE.REVISION := ANREVISION;
      LRLINE.PLANTNO := ASPLANTNO;
      LRLINE.LINE := ASLINE;
      LRLINE.CONFIGURATION := ANCONFIGURATION;
      GTSPPDLINES( 0 ) := LRLINE;

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
      
      
      
      
      
      
      
      CHECKBASICPDLINEPARAMS( LRLINE );

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

      
      LNRETVAL := IAPISPECIFICATIONPROCESSDATA.EXISTSECPROCESSDATA( ASPARTNO,
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

      
      OPEN LQLINE;

      FETCH LQLINE
       INTO LSDUMMY;

      IF LQLINE%NOTFOUND
      THEN
         CLOSE LQLINE;

         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SPPDLINENOTFOUND,
                                                     ASPARTNO,
                                                     ANREVISION,
                                                     ASPLANTNO,
                                                     ASLINE,
                                                     0,
                                                     0 ) );
      END IF;

      CLOSE LQLINE;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

       
       
       
       
        
      
      




















































      
      

      
      DELETE FROM SPECIFICATION_LINE
            WHERE PART_NO = ASPARTNO
              AND REVISION = ANREVISION
              AND PLANT = ASPLANTNO
              AND LINE = ASLINE
              AND CONFIGURATION = ANCONFIGURATION
              AND PROCESS_LINE_REV = 0;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Number of lines deleted: '
                           || SQL%ROWCOUNT,
                           IAPICONSTANT.INFOLEVEL_3 );
       
       
       
       
       
      
       
      LNRETVAL := IAPISPECIFICATIONPROCESSDATA.UPDATEDATA( ASPARTNO,
                                                           ANREVISION );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      INSERT INTO SPECDATA_SERVER
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID )
           VALUES ( LRLINE.PARTNO,
                    LRLINE.REVISION,
                    LNSECTIONID,
                    LNSUBSECTIONID );

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRLINE.PARTNO,
                                                       LRLINE.REVISION,
                                                       LNSECTIONID,
                                                       LNSUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRLINE.PARTNO,
                                                LRLINE.REVISION );

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
   END REMOVELINE;

   
   FUNCTION UPDATESTAGE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      ANSTAGEID                  IN       IAPITYPE.STAGEID_TYPE,
      ANSTAGESEQUENCE            IN       IAPITYPE.STAGESEQUENCE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'UpdateStage';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LSINTERNATIONAL               IAPITYPE.INTL_TYPE := '0';
      LNSTAGESEQUENCE               IAPITYPE.STAGESEQUENCE_TYPE := 0;

      CURSOR L_STAGE_CURSOR(
         ASPLANTNO                           IAPITYPE.PLANTNO_TYPE,
         ASLINE                              IAPITYPE.LINE_TYPE,
         ANCONFIGURATION                     IAPITYPE.CONFIGURATION_TYPE,
         ANSTAGEID                           IAPITYPE.STAGEID_TYPE )
      IS
         SELECT   A.PLANT,
                  A.LINE,
                  A.CONFIGURATION,
                  A.STAGE,
                  B.PROPERTY,
                  C.REVISION SP_REV,
                  B.UOM_ID,
                  D.REVISION UOM_REV,
                  B.ASSOCIATION,
                  E.REVISION AS_REV
             FROM PROCESS_LINE_STAGE A,
                  STAGE_LIST B,
                  PROPERTY_H C,
                  UOM_H D,
                  ASSOCIATION_H E
            WHERE A.PLANT = ASPLANTNO
              AND A.LINE = ASLINE
              AND A.CONFIGURATION = ANCONFIGURATION
              AND A.STAGE = ANSTAGEID
              AND A.STAGE = B.STAGE
              AND B.MANDATORY = 'Y'
              AND C.PROPERTY = B.PROPERTY
              AND C.MAX_REV = 1
              AND D.UOM_ID = B.UOM_ID
              AND D.MAX_REV = 1
              AND E.ASSOCIATION = B.ASSOCIATION
              AND E.MAX_REV = 1
              AND C.LANG_ID = 1
              AND D.LANG_ID = 1
              AND E.LANG_ID = 1
         ORDER BY A.PLANT,
                  A.LINE,
                  A.CONFIGURATION,
                  
                  
                  
                  A.STAGE,
                  C.DESCRIPTION;
                  
                  

   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      INSERT INTO SPECIFICATION_LINE_TEXT
                  ( PART_NO,
                    REVISION,
                    PLANT,
                    LINE,
                    CONFIGURATION,
                    STAGE,
                    TEXT_TYPE,
                    LANG_ID )
         SELECT ASPARTNO,
                ANREVISION,
                PLANT,
                LINE,
                CONFIGURATION,
                STAGE,
                TEXT_TYPE,
                1
           FROM PROCESS_LINE_STAGE
          WHERE PLANT = ASPLANTNO
            AND LINE = ASLINE
            AND CONFIGURATION = ANCONFIGURATION
            AND STAGE = ANSTAGEID
            AND TEXT_TYPE IS NOT NULL;

      IF IAPIGENERAL.SESSION.SETTINGS.INTERNATIONAL = TRUE
      THEN
         LSINTERNATIONAL := '1';
      ELSE
         LSINTERNATIONAL := '0';
      END IF;

      FOR REC_STAGE IN L_STAGE_CURSOR( ASPLANTNO,
                                       ASLINE,
                                       ANCONFIGURATION,
                                       ANSTAGEID )
      LOOP
         LNSTAGESEQUENCE :=   LNSTAGESEQUENCE
                            + 10;

         INSERT INTO SPECIFICATION_LINE_PROP
                     ( PART_NO,
                       REVISION,
                       SECTION_ID,
                       SECTION_REV,
                       SUB_SECTION_ID,
                       SUB_SECTION_REV,
                       PLANT,
                       LINE,
                       LINE_REV,
                       CONFIGURATION,
                       PROCESS_LINE_REV,
                       STAGE,
                       PROPERTY,
                       PROPERTY_REV,
                       ATTRIBUTE,
                       ATTRIBUTE_REV,
                       UOM_ID,
                       UOM_REV,
                       SEQUENCE_NO,
                       ASSOCIATION,
                       ASSOCIATION_REV,
                       INTL )
              VALUES ( ASPARTNO,
                       ANREVISION,
                       ANSECTIONID,
                       0,
                       ANSUBSECTIONID,
                       0,
                       ASPLANTNO,
                       ASLINE,
                       0,
                       ANCONFIGURATION,
                       0,
                       ANSTAGEID,
                       REC_STAGE.PROPERTY,
                       REC_STAGE.SP_REV,
                       0,
                       0,
                       REC_STAGE.UOM_ID,
                       REC_STAGE.UOM_REV,
                       LNSTAGESEQUENCE,
                       REC_STAGE.ASSOCIATION,
                       REC_STAGE.AS_REV,
                       LSINTERNATIONAL );
      END LOOP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END UPDATESTAGE;

   
   FUNCTION ADDSTAGE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      ANSTAGEID                  IN       IAPITYPE.STAGEID_TYPE,
      ANSTAGESEQUENCE            IN       IAPITYPE.STAGESEQUENCE_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQSTAGE
      IS
         SELECT STAGE
           FROM STAGE
          WHERE STAGE = ANSTAGEID;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddStage';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRSTAGE                       IAPITYPE.SPPDSTAGEREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
      LSPROCESSALLOWSTAGES          INTERSPC_CFG.PARAMETER_DATA%TYPE;
      LNSTAGE                       STAGE.STAGE%TYPE;
      LNTEXTTYPE                    IAPITYPE.ID_TYPE := NULL;
      LNDISPLAYFORMAT               IAPITYPE.ID_TYPE := NULL;
      LNDISPLAYFORMATREVISION       IAPITYPE.REVISION_TYPE := NULL;
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
      GTSPPDSTAGES.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRSTAGE.PARTNO := ASPARTNO;
      LRSTAGE.REVISION := ANREVISION;
      LRSTAGE.PLANTNO := ASPLANTNO;
      LRSTAGE.LINE := ASLINE;
      LRSTAGE.CONFIGURATION := ANCONFIGURATION;
      LRSTAGE.LINEREVISION := 0;
      LRSTAGE.STAGEID := ANSTAGEID;
      LRSTAGE.SEQUENCE := ANSTAGESEQUENCE;
      GTSPPDSTAGES( 0 ) := LRSTAGE;

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
      
      
      
      
      
      
      
      
      CHECKBASICPDSTAGEPARAMS( LRSTAGE );

      
      IF ( LRSTAGE.SEQUENCE IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'StageSequence' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anStageSequence',
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

      
      LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( 'process_allow_stages',
                                                       IAPICONSTANT.CFG_SECTION_STANDARD,
                                                       LSPROCESSALLOWSTAGES );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF LSPROCESSALLOWSTAGES <> '1'
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_CFGPARAMVALUEERROR,
                                                     'process_allow_stages',
                                                     '1' ) );
      END IF;

      
      LNRETVAL := IAPISPECIFICATIONPROCESSDATA.EXISTSECPROCESSDATA( ASPARTNO,
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

      
      OPEN LQSTAGE;

      FETCH LQSTAGE
       INTO LNSTAGE;

      IF LQSTAGE%NOTFOUND
      THEN
         CLOSE LQSTAGE;

         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_STAGENOTFOUND,
                                                     ANSTAGEID ) );
      END IF;

      CLOSE LQSTAGE;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      BEGIN
         
         BEGIN
            SELECT TEXT_TYPE,
                   DISPLAY_FORMAT,
                   LAYOUT.REVISION DISPLAY_FORMAT_REV
              INTO LNTEXTTYPE,
                   LNDISPLAYFORMAT,
                   LNDISPLAYFORMATREVISION
              FROM LAYOUT,
                   PROCESS_LINE_STAGE
             WHERE PLANT = ASPLANTNO
               AND LINE = ASLINE
               AND CONFIGURATION = ANCONFIGURATION
               AND DISPLAY_FORMAT = LAYOUT.LAYOUT_ID
               AND LAYOUT.STATUS = 2   
               AND STAGE = ANSTAGEID;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
         END;

         
         INSERT INTO SPECIFICATION_STAGE
                     ( PART_NO,
                       REVISION,
                       PLANT,
                       LINE,
                       CONFIGURATION,
                       PROCESS_LINE_REV,
                       STAGE,
                       SEQUENCE_NO,
                       TEXT_TYPE,
                       DISPLAY_FORMAT,
                       DISPLAY_FORMAT_REV )
              VALUES ( ASPARTNO,
                       ANREVISION,
                       ASPLANTNO,
                       ASLINE,
                       ANCONFIGURATION,
                       0,
                       ANSTAGEID,
                       ANSTAGESEQUENCE,
                       LNTEXTTYPE,
                       LNDISPLAYFORMAT,
                       LNDISPLAYFORMATREVISION );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_DUPLICATESPDLINESTAGE,
                                                        ASPARTNO,
                                                        ANREVISION,
                                                        ASPLANTNO,
                                                        ASLINE,
                                                        ANCONFIGURATION ) );
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      
      
      LNRETVAL :=
         IAPISPECIFICATIONPROCESSDATA.UPDATESTAGE( ASPARTNO,
                                                   ANREVISION,
                                                   LNSECTIONID,
                                                   LNSUBSECTIONID,
                                                   ASPLANTNO,
                                                   ASLINE,
                                                   ANCONFIGURATION,
                                                   ANSTAGEID,
                                                   ANSTAGESEQUENCE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      INSERT INTO SPECDATA_SERVER
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID )
           VALUES ( LRSTAGE.PARTNO,
                    LRSTAGE.REVISION,
                    LNSECTIONID,
                    LNSUBSECTIONID );

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRSTAGE.PARTNO,
                                                       LRSTAGE.REVISION,
                                                       LNSECTIONID,
                                                       LNSUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRSTAGE.PARTNO,
                                                LRSTAGE.REVISION );

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
   END ADDSTAGE;

   
   FUNCTION ADDSTAGEDATAPROPERTY(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      ANSTAGEID                  IN       IAPITYPE.STAGEID_TYPE,
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE,
      ANUOMID                    IN       IAPITYPE.ID_TYPE,
      ANTESTMETHOD               IN       IAPITYPE.ID_TYPE,
      ANSEQUENCE                 IN       IAPITYPE.LINEPROPSEQUENCE_TYPE,
      AFNUMERIC1                 IN       IAPITYPE.FLOAT_TYPE,
      AFNUMERIC2                 IN       IAPITYPE.FLOAT_TYPE,
      AFNUMERIC3                 IN       IAPITYPE.FLOAT_TYPE,
      AFNUMERIC4                 IN       IAPITYPE.FLOAT_TYPE,
      AFNUMERIC5                 IN       IAPITYPE.FLOAT_TYPE,
      AFNUMERIC6                 IN       IAPITYPE.FLOAT_TYPE,
      AFNUMERIC7                 IN       IAPITYPE.FLOAT_TYPE,
      AFNUMERIC8                 IN       IAPITYPE.FLOAT_TYPE,
      AFNUMERIC9                 IN       IAPITYPE.FLOAT_TYPE,
      AFNUMERIC10                IN       IAPITYPE.FLOAT_TYPE,
      ASSTRING1                  IN       IAPITYPE.PROPERTYSHORTSTRING_TYPE,
      ASSTRING2                  IN       IAPITYPE.PROPERTYSHORTSTRING_TYPE,
      ASSTRING3                  IN       IAPITYPE.PROPERTYSHORTSTRING_TYPE,
      ASSTRING4                  IN       IAPITYPE.PROPERTYSHORTSTRING_TYPE,
      ASSTRING5                  IN       IAPITYPE.PROPERTYSHORTSTRING_TYPE,
      ASSTRING6                  IN       IAPITYPE.PROPERTYLONGSTRING_TYPE,
      ASBOOLEAN1                 IN       IAPITYPE.BOOLEAN_TYPE,
      ASBOOLEAN2                 IN       IAPITYPE.BOOLEAN_TYPE,
      ASBOOLEAN3                 IN       IAPITYPE.BOOLEAN_TYPE,
      ASBOOLEAN4                 IN       IAPITYPE.BOOLEAN_TYPE,
      ADDATE1                    IN       IAPITYPE.DATE_TYPE,
      ADDATE2                    IN       IAPITYPE.DATE_TYPE,
      ANCHARACTERISTICID1        IN       IAPITYPE.ID_TYPE,
      ANALTERNATIVELANGUAGEID    IN       IAPITYPE.LANGUAGEID_TYPE DEFAULT NULL,
      ASALTERNATIVESTRING1       IN       IAPITYPE.PROPERTYSHORTSTRING_TYPE DEFAULT NULL,
      ASALTERNATIVESTRING2       IN       IAPITYPE.PROPERTYSHORTSTRING_TYPE DEFAULT NULL,
      ASALTERNATIVESTRING3       IN       IAPITYPE.PROPERTYSHORTSTRING_TYPE DEFAULT NULL,
      ASALTERNATIVESTRING4       IN       IAPITYPE.PROPERTYSHORTSTRING_TYPE DEFAULT NULL,
      ASALTERNATIVESTRING5       IN       IAPITYPE.PROPERTYSHORTSTRING_TYPE DEFAULT NULL,
      ASALTERNATIVESTRING6       IN       IAPITYPE.PROPERTYLONGSTRING_TYPE DEFAULT NULL,
      
      ANASSOCIATIONID            IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQSTAGE
      IS
         SELECT STAGE
           FROM STAGE
          WHERE STAGE = ANSTAGEID;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddStageDataProperty';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRSTAGEDATA                   IAPITYPE.SPPDSTAGEDATAREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
      LNSTAGE                       STAGE.STAGE%TYPE;
      LNASSOCIATION                 IAPITYPE.ID_TYPE;
      LSINTL                        IAPITYPE.INTL_TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LSSQLINFO                     IAPITYPE.SQLSTRING_TYPE;
      
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
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
      GTSPPDSTAGEDATA.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRSTAGEDATA.PARTNO := ASPARTNO;
      LRSTAGEDATA.REVISION := ANREVISION;
      LRSTAGEDATA.PLANTNO := ASPLANTNO;
      LRSTAGEDATA.LINE := ASLINE;
      LRSTAGEDATA.CONFIGURATION := ANCONFIGURATION;
      LRSTAGEDATA.LINEREVISION := 0;
      LRSTAGEDATA.STAGEID := ANSTAGEID;
      LRSTAGEDATA.SEQUENCE := ANSEQUENCE;
      GTSPPDSTAGEDATA( 0 ) := LRSTAGEDATA;

      GTINFO( 0 ) := LRINFO;

      IF IAPIGENERAL.SESSION.SETTINGS.INTERNATIONAL = TRUE
      THEN
         LSINTL := '1';
      ELSE
         LSINTL := '0';
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

      
      LRINFO := GTINFO( 0 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      
      
      
      
      
      CHECKBASICPDSTAGEDATAPARAMS( LRSTAGEDATA );

      
      IF ( ANALTERNATIVELANGUAGEID = 1 )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_STDLANGNOTALLOWED );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anAlternativeLanguageId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( LRSTAGEDATA.SEQUENCE IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'StageSequence' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSequence',
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

      IF ( ANALTERNATIVELANGUAGEID IS NOT NULL )
      THEN
         LNRETVAL := CHECKMULTILANGUAGE( ASPARTNO,
                                         ANREVISION );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
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

      
      LNRETVAL := IAPISPECIFICATIONPROCESSDATA.EXISTSECPROCESSDATA( ASPARTNO,
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

      
      OPEN LQSTAGE;

      FETCH LQSTAGE
       INTO LNSTAGE;

      IF LQSTAGE%NOTFOUND
      THEN
         CLOSE LQSTAGE;

         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_STAGENOTFOUND,
                                                     ANSTAGEID ) );
      END IF;

      CLOSE LQSTAGE;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      BEGIN
         
         IF (ANASSOCIATIONID IS NULL)
         THEN
         
             
             
             
             BEGIN
             
                 
                 SELECT ASSOCIATION
                   INTO LNASSOCIATION
                   FROM STAGE_LIST
                  WHERE STAGE = ANSTAGEID
                    AND PROPERTY = ANPROPERTYID
                    AND UOM_ID = ANUOMID;
             
             EXCEPTION
               WHEN OTHERS
               THEN
                 LNASSOCIATION := NULL;
             END;
            
         
         ELSE
            LNASSOCIATION := ANASSOCIATIONID;
         END IF;
         

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        

         
         INSERT INTO SPECIFICATION_LINE_PROP
                     ( PART_NO,
                       REVISION,
                       SECTION_ID,
                       SECTION_REV,
                       SUB_SECTION_ID,
                       SUB_SECTION_REV,
                       PLANT,
                       LINE,
                       LINE_REV,
                       CONFIGURATION,
                       PROCESS_LINE_REV,
                       STAGE,
                       STAGE_REV,
                       PROPERTY,
                       PROPERTY_REV,
                       ATTRIBUTE,
                       ATTRIBUTE_REV,
                       UOM_ID,
                       UOM_REV,
                       TEST_METHOD,
                       TEST_METHOD_REV,
                       SEQUENCE_NO,
                       VALUE_TYPE,
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
                       CHARACTERISTIC,
                       CHARACTERISTIC_REV,
                       ASSOCIATION,
                       ASSOCIATION_REV,
                       INTL )
              VALUES ( ASPARTNO,
                       ANREVISION,
                       LNSECTIONID,
                       0,
                       0,
                       0,
                       ASPLANTNO,
                       ASLINE,
                       0,
                       ANCONFIGURATION,
                       0,
                       ANSTAGEID,
                       0,
                       ANPROPERTYID,
                       0,
                       ANATTRIBUTEID,
                       0,
                       ANUOMID,
                       0,
                       ANTESTMETHOD,
                       0,
                       ANSEQUENCE,
                       0,
                       AFNUMERIC1,
                       AFNUMERIC2,
                       AFNUMERIC3,
                       AFNUMERIC4,
                       AFNUMERIC5,
                       AFNUMERIC6,
                       AFNUMERIC7,
                       AFNUMERIC8,
                       AFNUMERIC9,
                       AFNUMERIC10,
                       ASSTRING1,
                       ASSTRING2,
                       ASSTRING3,
                       ASSTRING4,
                       ASSTRING5,
                       ASSTRING6,
                       ASBOOLEAN1,
                       ASBOOLEAN2,
                       ASBOOLEAN3,
                       ASBOOLEAN4,
                       ADDATE1,
                       ADDATE2,
                       ANCHARACTERISTICID1,
                       0,
                       LNASSOCIATION,
                       0,
                       LSINTL );

         IF ( ANALTERNATIVELANGUAGEID IS NOT NULL )
         THEN
            
            IF     ASALTERNATIVESTRING1 IS NULL
               AND ASALTERNATIVESTRING2 IS NULL
               AND ASALTERNATIVESTRING3 IS NULL
               AND ASALTERNATIVESTRING4 IS NULL
               AND ASALTERNATIVESTRING5 IS NULL
               AND ASALTERNATIVESTRING6 IS NULL
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    'Delete alternative language',
                                    IAPICONSTANT.INFOLEVEL_3 );

               UPDATE ITSHLNPROPLANG
                  SET CHAR_1 = NULL,
                      CHAR_2 = NULL,
                      CHAR_3 = NULL,
                      CHAR_4 = NULL,
                      CHAR_5 = NULL,
                      CHAR_6 = NULL
                WHERE PART_NO = ASPARTNO
                  AND REVISION = ANREVISION
                  AND PLANT = ASPLANTNO
                  AND LINE = ASLINE
                  AND CONFIGURATION = ANCONFIGURATION
                  AND PROPERTY = ANPROPERTYID
                  AND ATTRIBUTE = ANATTRIBUTEID
                  AND SEQUENCE_NO = ANSEQUENCE
                  AND LANG_ID = ANALTERNATIVELANGUAGEID;

               DELETE      ITSHLNPROPLANG
                     WHERE PART_NO = ASPARTNO
                       AND REVISION = ANREVISION
                       AND PLANT = ASPLANTNO
                       AND LINE = ASLINE
                       AND CONFIGURATION = ANCONFIGURATION
                       AND PROPERTY = ANPROPERTYID
                       AND ATTRIBUTE = ANATTRIBUTEID
                       AND SEQUENCE_NO = ANSEQUENCE
                       AND LANG_ID = ANALTERNATIVELANGUAGEID
                       AND TEXT IS NULL;
            ELSE
               BEGIN
                  
                  INSERT INTO ITSHLNPROPLANG
                              ( PART_NO,
                                REVISION,
                                PLANT,
                                LINE,
                                CONFIGURATION,
                                STAGE,
                                PROPERTY,
                                ATTRIBUTE,
                                SEQUENCE_NO,
                                CHAR_1,
                                CHAR_2,
                                CHAR_3,
                                CHAR_4,
                                CHAR_5,
                                CHAR_6,
                                LANG_ID )
                       VALUES ( ASPARTNO,
                                ANREVISION,
                                ASPLANTNO,
                                ASLINE,
                                ANCONFIGURATION,
                                ANSTAGEID,
                                ANPROPERTYID,
                                ANATTRIBUTEID,
                                ANSEQUENCE,
                                ASALTERNATIVESTRING1,
                                ASALTERNATIVESTRING2,
                                ASALTERNATIVESTRING3,
                                ASALTERNATIVESTRING4,
                                ASALTERNATIVESTRING5,
                                ASALTERNATIVESTRING6,
                                ANALTERNATIVELANGUAGEID );
               EXCEPTION
                  WHEN DUP_VAL_ON_INDEX
                  THEN
                     UPDATE ITSHLNPROPLANG
                        SET CHAR_1 = ASALTERNATIVESTRING1,
                            CHAR_2 = ASALTERNATIVESTRING2,
                            CHAR_3 = ASALTERNATIVESTRING3,
                            CHAR_4 = ASALTERNATIVESTRING4,
                            CHAR_5 = ASALTERNATIVESTRING5,
                            CHAR_6 = ASALTERNATIVESTRING6
                      WHERE PART_NO = ASPARTNO
                        AND REVISION = ANREVISION
                        AND PLANT = ASPLANTNO
                        AND LINE = ASLINE
                        AND CONFIGURATION = ANCONFIGURATION
                        AND PROPERTY = ANPROPERTYID
                        AND ATTRIBUTE = ANATTRIBUTEID
                        AND SEQUENCE_NO = ANSEQUENCE
                        AND LANG_ID = ANALTERNATIVELANGUAGEID;
               END;
            END IF;
         END IF;
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_DUPLICATESPDSTAGEDATA,
                                                        ASPARTNO,
                                                        ANREVISION,
                                                        ASPLANTNO,
                                                        ASLINE,
                                                        ANCONFIGURATION ) );
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      
      INSERT INTO SPECDATA_SERVER
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID )
           VALUES ( LRSTAGEDATA.PARTNO,
                    LRSTAGEDATA.REVISION,
                    LNSECTIONID,
                    LNSUBSECTIONID );

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRSTAGEDATA.PARTNO,
                                                       LRSTAGEDATA.REVISION,
                                                       LNSECTIONID,
                                                       LNSUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRSTAGEDATA.PARTNO,
                                                LRSTAGEDATA.REVISION );

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
   END ADDSTAGEDATAPROPERTY;

   
   FUNCTION ADDSTAGEDATATEXT(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      ANSTAGEID                  IN       IAPITYPE.STAGEID_TYPE,
      ANSEQUENCE                 IN       IAPITYPE.LINEPROPSEQUENCE_TYPE,
      ASTEXT                     IN       IAPITYPE.STRING_TYPE,
      ANALTERNATIVELANGUAGEID    IN       IAPITYPE.LANGUAGEID_TYPE DEFAULT NULL,
      ASALTERNATIVETEXT          IN       IAPITYPE.STRING_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQSTAGE
      IS
         SELECT STAGE
           FROM STAGE
          WHERE STAGE = ANSTAGEID;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddStageDataText';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRSTAGEDATA                   IAPITYPE.SPPDSTAGEDATAREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
      LNSTAGE                       STAGE.STAGE%TYPE;
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
      GTSPPDSTAGEDATA.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRSTAGEDATA.PARTNO := ASPARTNO;
      LRSTAGEDATA.REVISION := ANREVISION;
      LRSTAGEDATA.PLANTNO := ASPLANTNO;
      LRSTAGEDATA.LINE := ASLINE;
      LRSTAGEDATA.CONFIGURATION := ANCONFIGURATION;
      LRSTAGEDATA.LINEREVISION := 0;
      LRSTAGEDATA.STAGEID := ANSTAGEID;
      LRSTAGEDATA.SEQUENCE := ANSEQUENCE;
      GTSPPDSTAGEDATA( 0 ) := LRSTAGEDATA;

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
      
      
      
      
      
      
      
      
      
      
      
      CHECKBASICPDSTAGEDATAPARAMS( LRSTAGEDATA );

      
      IF ( ANALTERNATIVELANGUAGEID = 1 )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_STDLANGNOTALLOWED );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anAlternativeLanguageId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( LRSTAGEDATA.SEQUENCE IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'StageSequence' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSequence',
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

      IF ( ANALTERNATIVELANGUAGEID IS NOT NULL )
      THEN
         LNRETVAL := CHECKMULTILANGUAGE( ASPARTNO,
                                         ANREVISION );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
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

      
      LNRETVAL := IAPISPECIFICATIONPROCESSDATA.EXISTSECPROCESSDATA( ASPARTNO,
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

      
      OPEN LQSTAGE;

      FETCH LQSTAGE
       INTO LNSTAGE;

      IF LQSTAGE%NOTFOUND
      THEN
         CLOSE LQSTAGE;

         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_STAGENOTFOUND,
                                                     ANSTAGEID ) );
      END IF;

      CLOSE LQSTAGE;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      BEGIN
         
         INSERT INTO SPECIFICATION_LINE_PROP
                     ( PART_NO,
                       REVISION,
                       SECTION_ID,
                       SECTION_REV,
                       SUB_SECTION_ID,
                       SUB_SECTION_REV,
                       PLANT,
                       LINE,
                       LINE_REV,
                       CONFIGURATION,
                       PROCESS_LINE_REV,
                       STAGE,
                       STAGE_REV,
                       PROPERTY,
                       PROPERTY_REV,
                       ATTRIBUTE,
                       ATTRIBUTE_REV,
                       SEQUENCE_NO,
                       VALUE_TYPE,
                       TEXT )
              VALUES ( ASPARTNO,
                       ANREVISION,
                       LNSECTIONID,
                       0,
                       0,
                       0,
                       ASPLANTNO,
                       ASLINE,
                       0,
                       ANCONFIGURATION,
                       0,
                       ANSTAGEID,
                       0,
                       0,
                       0,
                       0,
                       0,
                       ANSEQUENCE,
                       1,
                       ASTEXT );

         IF ( ANALTERNATIVELANGUAGEID IS NOT NULL )
         THEN
            
            IF ASALTERNATIVETEXT IS NULL
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    'Delete alternative language',
                                    IAPICONSTANT.INFOLEVEL_3 );

               UPDATE ITSHLNPROPLANG
                  SET TEXT = NULL
                WHERE PART_NO = ASPARTNO
                  AND REVISION = ANREVISION
                  AND PLANT = ASPLANTNO
                  AND LINE = ASLINE
                  AND CONFIGURATION = ANCONFIGURATION
                  AND PROPERTY = 0
                  AND ATTRIBUTE = 0
                  AND SEQUENCE_NO = ANSEQUENCE
                  AND LANG_ID = ANALTERNATIVELANGUAGEID;

               DELETE      ITSHLNPROPLANG
                     WHERE PART_NO = ASPARTNO
                       AND REVISION = ANREVISION
                       AND PLANT = ASPLANTNO
                       AND LINE = ASLINE
                       AND CONFIGURATION = ANCONFIGURATION
                       AND PROPERTY = 0
                       AND ATTRIBUTE = 0
                       AND SEQUENCE_NO = ANSEQUENCE
                       AND LANG_ID = ANALTERNATIVELANGUAGEID
                       AND CHAR_1 = NULL
                       AND CHAR_2 = NULL
                       AND CHAR_3 = NULL
                       AND CHAR_4 = NULL
                       AND CHAR_5 = NULL
                       AND CHAR_6 = NULL;
            ELSE
               BEGIN
                  
                  INSERT INTO ITSHLNPROPLANG
                              ( PART_NO,
                                REVISION,
                                PLANT,
                                LINE,
                                CONFIGURATION,
                                STAGE,
                                PROPERTY,
                                ATTRIBUTE,
                                SEQUENCE_NO,
                                TEXT,
                                LANG_ID )
                       VALUES ( ASPARTNO,
                                ANREVISION,
                                ASPLANTNO,
                                ASLINE,
                                ANCONFIGURATION,
                                ANSTAGEID,
                                0,
                                0,
                                ANSEQUENCE,
                                ASALTERNATIVETEXT,
                                ANALTERNATIVELANGUAGEID );
               EXCEPTION
                  WHEN DUP_VAL_ON_INDEX
                  THEN
                     UPDATE ITSHLNPROPLANG
                        SET TEXT = ASALTERNATIVETEXT
                      WHERE PART_NO = ASPARTNO
                        AND REVISION = ANREVISION
                        AND PLANT = ASPLANTNO
                        AND LINE = ASLINE
                        AND CONFIGURATION = ANCONFIGURATION
                        AND PROPERTY = 0
                        AND ATTRIBUTE = 0
                        AND SEQUENCE_NO = ANSEQUENCE
                        AND LANG_ID = ANALTERNATIVELANGUAGEID;
               END;
            END IF;
         END IF;
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_DUPLICATESPDSTAGEDATA,
                                                        ASPARTNO,
                                                        ANREVISION,
                                                        ASPLANTNO,
                                                        ASLINE,
                                                        ANCONFIGURATION ) );
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      
      INSERT INTO SPECDATA_SERVER
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID )
           VALUES ( LRSTAGEDATA.PARTNO,
                    LRSTAGEDATA.REVISION,
                    LNSECTIONID,
                    LNSUBSECTIONID );

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRSTAGEDATA.PARTNO,
                                                       LRSTAGEDATA.REVISION,
                                                       LNSECTIONID,
                                                       LNSUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRSTAGEDATA.PARTNO,
                                                LRSTAGEDATA.REVISION );

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
   END ADDSTAGEDATATEXT;

   
   FUNCTION ADDSTAGEDATABOMITEM(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      ANSTAGEID                  IN       IAPITYPE.STAGEID_TYPE,
      ANSEQUENCE                 IN       IAPITYPE.LINEPROPSEQUENCE_TYPE,
      ASCOMPONENTPART            IN       IAPITYPE.PARTNO_TYPE,
      
      
      AFQUANTITY                 IN       IAPITYPE.BOMQUANTITY_TYPE,
      
      ASUOM                      IN       IAPITYPE.BASEUOM_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANBOMUSAGE                 IN       IAPITYPE.BOMUSAGE_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQSTAGE
      IS
         SELECT STAGE
           FROM STAGE
          WHERE STAGE = ANSTAGEID;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddStageDataBomItem';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRSTAGEDATA                   IAPITYPE.SPPDSTAGEDATAREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
      LNSTAGE                       STAGE.STAGE%TYPE;
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
      GTSPPDSTAGEDATA.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRSTAGEDATA.PARTNO := ASPARTNO;
      LRSTAGEDATA.REVISION := ANREVISION;
      LRSTAGEDATA.PLANTNO := ASPLANTNO;
      LRSTAGEDATA.LINE := ASLINE;
      LRSTAGEDATA.CONFIGURATION := ANCONFIGURATION;
      LRSTAGEDATA.LINEREVISION := 0;
      LRSTAGEDATA.STAGEID := ANSTAGEID;
      LRSTAGEDATA.SEQUENCE := ANSEQUENCE;
      GTSPPDSTAGEDATA( 0 ) := LRSTAGEDATA;

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
      
      
      
      
      
      
      
      
      
      
      
      CHECKBASICPDSTAGEDATAPARAMS( LRSTAGEDATA );

      
      IF ( LRSTAGEDATA.SEQUENCE IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'StageSequence' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSequence',
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

      
      LNRETVAL := IAPISPECIFICATIONPROCESSDATA.EXISTSECPROCESSDATA( ASPARTNO,
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

      
      OPEN LQSTAGE;

      FETCH LQSTAGE
       INTO LNSTAGE;

      IF LQSTAGE%NOTFOUND
      THEN
         CLOSE LQSTAGE;

         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_STAGENOTFOUND,
                                                     ANSTAGEID ) );
      END IF;

      CLOSE LQSTAGE;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      BEGIN
         
         INSERT INTO SPECIFICATION_LINE_PROP
                     ( PART_NO,
                       REVISION,
                       SECTION_ID,
                       SECTION_REV,
                       SUB_SECTION_ID,
                       SUB_SECTION_REV,
                       PLANT,
                       LINE,
                       LINE_REV,
                       CONFIGURATION,
                       PROCESS_LINE_REV,
                       STAGE,
                       STAGE_REV,
                       PROPERTY,
                       PROPERTY_REV,
                       ATTRIBUTE,
                       ATTRIBUTE_REV,
                       SEQUENCE_NO,
                       VALUE_TYPE,
                       COMPONENT_PART,
                       QUANTITY,
                       UOM,
                       ALTERNATIVE,
                       BOM_USAGE )
              VALUES ( ASPARTNO,
                       ANREVISION,
                       LNSECTIONID,
                       0,
                       0,
                       0,
                       ASPLANTNO,
                       ASLINE,
                       0,
                       ANCONFIGURATION,
                       0,
                       ANSTAGEID,
                       0,
                       0,
                       0,
                       0,
                       0,
                       ANSEQUENCE,
                       2,
                       ASCOMPONENTPART,
                       AFQUANTITY,
                       ASUOM,
                       ANALTERNATIVE,
                       ANBOMUSAGE );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_DUPLICATESPDSTAGEDATA,
                                                        ASPARTNO,
                                                        ANREVISION,
                                                        ASPLANTNO,
                                                        ASLINE,
                                                        ANCONFIGURATION ) );
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      
      INSERT INTO SPECDATA_SERVER
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID )
           VALUES ( LRSTAGEDATA.PARTNO,
                    LRSTAGEDATA.REVISION,
                    LNSECTIONID,
                    LNSUBSECTIONID );

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRSTAGEDATA.PARTNO,
                                                       LRSTAGEDATA.REVISION,
                                                       LNSECTIONID,
                                                       LNSUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRSTAGEDATA.PARTNO,
                                                LRSTAGEDATA.REVISION );

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
   END ADDSTAGEDATABOMITEM;

   
   FUNCTION REMOVESTAGE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      ANSTAGEID                  IN       IAPITYPE.STAGEID_TYPE,
      ANSTAGESEQUENCE            IN       IAPITYPE.STAGESEQUENCE_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQSTAGE
      IS
         SELECT STAGE
           FROM STAGE
          WHERE STAGE = ANSTAGEID;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveStage';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRSTAGE                       IAPITYPE.SPPDSTAGEREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
      LSPROCESSALLOWSTAGES          INTERSPC_CFG.PARAMETER_DATA%TYPE;
      LNSTAGE                       STAGE.STAGE%TYPE;
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
      GTSPPDSTAGES.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRSTAGE.PARTNO := ASPARTNO;
      LRSTAGE.REVISION := ANREVISION;
      LRSTAGE.PLANTNO := ASPLANTNO;
      LRSTAGE.LINE := ASLINE;
      LRSTAGE.CONFIGURATION := ANCONFIGURATION;
      LRSTAGE.LINEREVISION := 0;
      LRSTAGE.STAGEID := ANSTAGEID;
      LRSTAGE.SEQUENCE := ANSTAGESEQUENCE;
      GTSPPDSTAGES( 0 ) := LRSTAGE;

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
      
      
      
      
      
      
      
      
      CHECKBASICPDSTAGEPARAMS( LRSTAGE );

      
      IF ( LRSTAGE.SEQUENCE IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'StageSequence' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anStageSequence',
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

      
      LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( 'process_allow_stages',
                                                       IAPICONSTANT.CFG_SECTION_STANDARD,
                                                       LSPROCESSALLOWSTAGES );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF LSPROCESSALLOWSTAGES <> '1'
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_CFGPARAMVALUEERROR,
                                                     'process_allow_stages',
                                                     '1' ) );
      END IF;

      
      LNRETVAL := IAPISPECIFICATIONPROCESSDATA.EXISTSECPROCESSDATA( ASPARTNO,
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

      
      OPEN LQSTAGE;

      FETCH LQSTAGE
       INTO LNSTAGE;

      IF LQSTAGE%NOTFOUND
      THEN
         CLOSE LQSTAGE;

         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_STAGENOTFOUND,
                                                     ANSTAGEID ) );
      END IF;

      CLOSE LQSTAGE;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      DELETE FROM SPECIFICATION_STAGE
            WHERE PART_NO = ASPARTNO
              AND REVISION = ANREVISION
              AND PLANT = ASPLANTNO
              AND LINE = ASLINE
              AND CONFIGURATION = ANCONFIGURATION
              AND PROCESS_LINE_REV = 0
              AND STAGE = ANSTAGEID
              AND SEQUENCE_NO = ANSTAGESEQUENCE;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SPPDSTAGENOTFOUND,
                                                     ANSTAGEID,
                                                     ASPARTNO,
                                                     ANREVISION,
                                                     ASPLANTNO,
                                                     ASLINE,
                                                     ANCONFIGURATION ) );
      END IF;

      
      DELETE FROM ITSHLNPROPLANG
            WHERE PART_NO = ASPARTNO
              AND REVISION = ANREVISION
              AND PLANT = ASPLANTNO
              AND LINE = ASLINE
              AND CONFIGURATION = ANCONFIGURATION
              AND STAGE = ANSTAGEID
              AND SEQUENCE_NO = ANSTAGESEQUENCE;

      DELETE FROM SPECIFICATION_LINE_PROP
            WHERE PART_NO = ASPARTNO
              AND REVISION = ANREVISION
              AND PLANT = ASPLANTNO
              AND LINE = ASLINE
              AND CONFIGURATION = ANCONFIGURATION
              AND PROCESS_LINE_REV = 0
              AND STAGE = ANSTAGEID;



      
      DELETE FROM SPECIFICATION_LINE_TEXT
            WHERE PART_NO = ASPARTNO
              AND REVISION = ANREVISION
              AND PLANT = ASPLANTNO
              AND LINE = ASLINE
              AND CONFIGURATION = ANCONFIGURATION
              AND STAGE = ANSTAGEID;

      
      INSERT INTO SPECDATA_SERVER
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID )
           VALUES ( LRSTAGE.PARTNO,
                    LRSTAGE.REVISION,
                    LNSECTIONID,
                    LNSUBSECTIONID );

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRSTAGE.PARTNO,
                                                       LRSTAGE.REVISION,
                                                       LNSECTIONID,
                                                       LNSUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRSTAGE.PARTNO,
                                                LRSTAGE.REVISION );

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
   END REMOVESTAGE;

   
   FUNCTION REMOVESTAGEDATA(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      ANSTAGEID                  IN       IAPITYPE.STAGEID_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveStageData';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      RETURN( REMOVESTAGEDATAINTERNAL( ASPARTNO,
                                       ANREVISION,
                                       ASPLANTNO,
                                       ASLINE,
                                       ANCONFIGURATION,
                                       ANSTAGEID,
                                       0,
                                       NULL,
                                       LSMETHOD,
                                       AQINFO,
                                       AQERRORS ) );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVESTAGEDATA;

   
   FUNCTION SAVELINE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      ASUSEPART                  IN       IAPITYPE.PARTNO_TYPE DEFAULT NULL,
      ANUSEPARTREVISION          IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      ANSEQUENCE                 IN       IAPITYPE.SEQUENCENR_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQLINE
      IS
         SELECT 1
           FROM SPECIFICATION_LINE
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PLANT = ASPLANTNO
            AND LINE = ASLINE
            AND CONFIGURATION = ANCONFIGURATION;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveLine';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRLINE                        IAPITYPE.SPPDLINEREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSDUMMY                       IAPITYPE.BOOLEAN_TYPE;
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
      LSUSEPARTNO                   SPECIFICATION_LINE.ITEM_PART_NO%TYPE;
      LNPARTREVISION                SPECIFICATION_LINE.ITEM_REVISION%TYPE;
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
      GTSPPDLINES.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRLINE.PARTNO := ASPARTNO;
      LRLINE.REVISION := ANREVISION;
      LRLINE.PLANTNO := ASPLANTNO;
      LRLINE.LINE := ASLINE;
      LRLINE.CONFIGURATION := ANCONFIGURATION;
      GTSPPDLINES( 0 ) := LRLINE;

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
      
      
      
      
      
      
      

      
      
      
      CHECKBASICPDLINEPARAMS( LRLINE );

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

      
      LNRETVAL := IAPISPECIFICATIONPROCESSDATA.EXISTSECPROCESSDATA( ASPARTNO,
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

      
      OPEN LQLINE;

      FETCH LQLINE
       INTO LSDUMMY;

      IF LQLINE%NOTFOUND
      THEN
         CLOSE LQLINE;

         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SPPDLINENOTFOUND,
                                                     ASPARTNO,
                                                     ANREVISION,
                                                     ASPLANTNO,
                                                     ASLINE,
                                                     ANCONFIGURATION,
                                                     0 ) );
      END IF;

      CLOSE LQLINE;



















      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      UPDATE SPECIFICATION_LINE
         SET ITEM_PART_NO = ASUSEPART,
             ITEM_REVISION = ANUSEPARTREVISION,
             SEQUENCE = ANSEQUENCE
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANTNO
         AND LINE = ASLINE
         AND CONFIGURATION = ANCONFIGURATION
         AND PROCESS_LINE_REV = 0;

      
      INSERT INTO SPECDATA_SERVER
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID )
           VALUES ( LRLINE.PARTNO,
                    LRLINE.REVISION,
                    LNSECTIONID,
                    LNSUBSECTIONID );

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRLINE.PARTNO,
                                                       LRLINE.REVISION,
                                                       LNSECTIONID,
                                                       LNSUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRLINE.PARTNO,
                                                LRLINE.REVISION );

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
   END SAVELINE;

   
   FUNCTION SAVESTAGE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      ANSTAGEID                  IN       IAPITYPE.STAGEID_TYPE,
      ANSTAGESEQUENCE            IN       IAPITYPE.STAGESEQUENCE_TYPE,
      ANRECIRCULATETO            IN       IAPITYPE.STAGESEQUENCE_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQSTAGE
      IS
         SELECT STAGE
           FROM STAGE
          WHERE STAGE = ANSTAGEID;

      CURSOR LQRECIRCULATETO
      IS
         SELECT SEQUENCE_NO
           FROM SPECIFICATION_STAGE
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PLANT = ASPLANTNO
            AND LINE = ASLINE
            AND CONFIGURATION = ANCONFIGURATION
            AND PROCESS_LINE_REV = 0
            AND SEQUENCE_NO = ANRECIRCULATETO;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveStage';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRSTAGE                       IAPITYPE.SPPDSTAGEREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
      LSPROCESSALLOWSTAGES          INTERSPC_CFG.PARAMETER_DATA%TYPE;
      LNSTAGE                       STAGE.STAGE%TYPE;
      LNSEQUENCENO                  SPECIFICATION_STAGE.SEQUENCE_NO%TYPE;
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
      GTSPPDSTAGES.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRSTAGE.PARTNO := ASPARTNO;
      LRSTAGE.REVISION := ANREVISION;
      LRSTAGE.PLANTNO := ASPLANTNO;
      LRSTAGE.LINE := ASLINE;
      LRSTAGE.CONFIGURATION := ANCONFIGURATION;
      LRSTAGE.LINEREVISION := 0;
      LRSTAGE.STAGEID := ANSTAGEID;
      LRSTAGE.SEQUENCE := ANSTAGESEQUENCE;
      GTSPPDSTAGES( 0 ) := LRSTAGE;

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
      
      
      
      
      
      
      
      
      CHECKBASICPDSTAGEPARAMS( LRSTAGE );

      
      IF ( LRSTAGE.SEQUENCE IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'StageSequence' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anStageSequence',
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

      
      LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( 'process_allow_stages',
                                                       IAPICONSTANT.CFG_SECTION_STANDARD,
                                                       LSPROCESSALLOWSTAGES );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF LSPROCESSALLOWSTAGES <> '1'
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_CFGPARAMVALUEERROR,
                                                     'process_allow_stages',
                                                     '1' ) );
      END IF;

      
      LNRETVAL := IAPISPECIFICATIONPROCESSDATA.EXISTSECPROCESSDATA( ASPARTNO,
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

      
      OPEN LQSTAGE;

      FETCH LQSTAGE
       INTO LNSTAGE;

      IF LQSTAGE%NOTFOUND
      THEN
         CLOSE LQSTAGE;

         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_STAGENOTFOUND,
                                                     ANSTAGEID ) );
      END IF;

      CLOSE LQSTAGE;

      IF NOT( ANRECIRCULATETO IS NULL )
      THEN
           
         
         
         OPEN LQRECIRCULATETO;

         FETCH LQRECIRCULATETO
          INTO LNSEQUENCENO;

         IF (      ( LQRECIRCULATETO%NOTFOUND )
              AND ( ANRECIRCULATETO <> ANSTAGESEQUENCE ) )
         THEN
            CLOSE LQRECIRCULATETO;

            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_SPPDRECIRULATETO,
                                                        ANRECIRCULATETO ) );
         END IF;

         CLOSE LQRECIRCULATETO;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      UPDATE SPECIFICATION_STAGE
         SET RECIRCULATE_TO = ANRECIRCULATETO,
             SEQUENCE_NO = ANSTAGESEQUENCE
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANTNO
         AND LINE = ASLINE
         AND CONFIGURATION = ANCONFIGURATION
         AND PROCESS_LINE_REV = 0
         AND STAGE = ANSTAGEID;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SPPDSTAGENOTFOUND,
                                                     ANSTAGEID,
                                                     ASPARTNO,
                                                     ANREVISION,
                                                     ASPLANTNO,
                                                     ASLINE,
                                                     ANCONFIGURATION ) );
      END IF;

      
      INSERT INTO SPECDATA_SERVER
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID )
           VALUES ( LRSTAGE.PARTNO,
                    LRSTAGE.REVISION,
                    LNSECTIONID,
                    LNSUBSECTIONID );

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRSTAGE.PARTNO,
                                                       LRSTAGE.REVISION,
                                                       LNSECTIONID,
                                                       LNSUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRSTAGE.PARTNO,
                                                LRSTAGE.REVISION );

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
   END SAVESTAGE;

   
   FUNCTION GETUSESPECIFICATIONS(
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ATDEFAULTFILTER            IN       IAPITYPE.FILTERTAB_TYPE,
      AQSPECIFICATIONS           OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUseSpecifications';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRFILTER                      IAPITYPE.FILTERREC_TYPE;
      LSFILTER                      IAPITYPE.CLOB_TYPE := NULL;
      LSFILTERTOADD                 IAPITYPE.STRING_TYPE := NULL;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'sh.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', sh.revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', sh.description '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', sh.status '
            || IAPICONSTANTCOLUMN.STATUSIDCOL
            || ', s.sort_desc '
            || IAPICONSTANTCOLUMN.STATUSCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'specification_header sh, status s';
   BEGIN
      
      
      
      
      
      IF ( AQSPECIFICATIONS%ISOPEN )
      THEN
         CLOSE AQSPECIFICATIONS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE sh.status = s.status AND sh.part_no = NULL';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQLNULL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQSPECIFICATIONS FOR LSSQLNULL;

      
      
      
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
               LRFILTER.LEFTOPERAND := 'sh.part_no';
            WHEN IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            THEN
               LRFILTER.LEFTOPERAND := 'sh.description';
            WHEN IAPICONSTANTCOLUMN.STATUSIDCOL
            THEN
               LRFILTER.LEFTOPERAND := 'sh.status';
            WHEN IAPICONSTANTCOLUMN.STATUSCOL
            THEN
               LRFILTER.LEFTOPERAND := 's.sort_desc';
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

      
      LSSQL :=
            'SELECT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE sh.status = s.status'
         || ' AND sh.revision = ( SELECT MAX( b.revision )'
         || ' FROM bom_header b'
         || ' WHERE b.part_no = sh.part_no'
         || ' AND b.plant = :Plant )'
         || ' AND EXISTS( SELECT user_id'
         || ' FROM spec_access ac'
         || ' WHERE ac.access_group = sh.access_group'
         || ' AND ac.user_id = :CURRENTUSER )';

      IF ( LSFILTER IS NOT NULL )
      THEN
         LSSQL :=    LSSQL
                  || ' AND '
                  || LSFILTER;
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY '
               || IAPICONSTANTCOLUMN.PARTNOCOL;
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQSPECIFICATIONS%ISOPEN )
      THEN
         CLOSE AQSPECIFICATIONS;
      END IF;

      OPEN AQSPECIFICATIONS FOR LSSQL USING ASPLANTNO,
      IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUSESPECIFICATIONS;

   
   FUNCTION SAVESTAGEDATAPROPERTY(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      ANSTAGEID                  IN       IAPITYPE.STAGEID_TYPE,
      ANSEQUENCE                 IN       IAPITYPE.LINEPROPSEQUENCE_TYPE,
      ANNEWSEQUENCE              IN       IAPITYPE.LINEPROPSEQUENCE_TYPE DEFAULT NULL,
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE,
      AFNUMERIC1                 IN       IAPITYPE.FLOAT_TYPE,
      AFNUMERIC2                 IN       IAPITYPE.FLOAT_TYPE,
      AFNUMERIC3                 IN       IAPITYPE.FLOAT_TYPE,
      AFNUMERIC4                 IN       IAPITYPE.FLOAT_TYPE,
      AFNUMERIC5                 IN       IAPITYPE.FLOAT_TYPE,
      AFNUMERIC6                 IN       IAPITYPE.FLOAT_TYPE,
      AFNUMERIC7                 IN       IAPITYPE.FLOAT_TYPE,
      AFNUMERIC8                 IN       IAPITYPE.FLOAT_TYPE,
      AFNUMERIC9                 IN       IAPITYPE.FLOAT_TYPE,
      AFNUMERIC10                IN       IAPITYPE.FLOAT_TYPE,
      ASSTRING1                  IN       IAPITYPE.PROPERTYSHORTSTRING_TYPE,
      ASSTRING2                  IN       IAPITYPE.PROPERTYSHORTSTRING_TYPE,
      ASSTRING3                  IN       IAPITYPE.PROPERTYSHORTSTRING_TYPE,
      ASSTRING4                  IN       IAPITYPE.PROPERTYSHORTSTRING_TYPE,
      ASSTRING5                  IN       IAPITYPE.PROPERTYSHORTSTRING_TYPE,
      ASSTRING6                  IN       IAPITYPE.PROPERTYLONGSTRING_TYPE,
      ASBOOLEAN1                 IN       IAPITYPE.BOOLEAN_TYPE,
      ASBOOLEAN2                 IN       IAPITYPE.BOOLEAN_TYPE,
      ASBOOLEAN3                 IN       IAPITYPE.BOOLEAN_TYPE,
      ASBOOLEAN4                 IN       IAPITYPE.BOOLEAN_TYPE,
      ADDATE1                    IN       IAPITYPE.DATE_TYPE,
      ADDATE2                    IN       IAPITYPE.DATE_TYPE,
      ANCHARACTERISTICID1        IN       IAPITYPE.ID_TYPE,
      ANTESTMETHODID             IN       IAPITYPE.ID_TYPE,
      ANALTERNATIVELANGUAGEID    IN       IAPITYPE.LANGUAGEID_TYPE DEFAULT NULL,
      ASALTERNATIVESTRING1       IN       IAPITYPE.PROPERTYSHORTSTRING_TYPE DEFAULT NULL,
      ASALTERNATIVESTRING2       IN       IAPITYPE.PROPERTYSHORTSTRING_TYPE DEFAULT NULL,
      ASALTERNATIVESTRING3       IN       IAPITYPE.PROPERTYSHORTSTRING_TYPE DEFAULT NULL,
      ASALTERNATIVESTRING4       IN       IAPITYPE.PROPERTYSHORTSTRING_TYPE DEFAULT NULL,
      ASALTERNATIVESTRING5       IN       IAPITYPE.PROPERTYSHORTSTRING_TYPE DEFAULT NULL,
      ASALTERNATIVESTRING6       IN       IAPITYPE.PROPERTYLONGSTRING_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQSTAGE
      IS
         SELECT STAGE
           FROM STAGE
          WHERE STAGE = ANSTAGEID;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveStageDataProperty';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRSTAGEDATA                   IAPITYPE.SPPDSTAGEDATAREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
      LNSTAGE                       STAGE.STAGE%TYPE;
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
      GTSPPDSTAGEDATA.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRSTAGEDATA.PARTNO := ASPARTNO;
      LRSTAGEDATA.REVISION := ANREVISION;
      LRSTAGEDATA.PLANTNO := ASPLANTNO;
      LRSTAGEDATA.LINE := ASLINE;
      LRSTAGEDATA.CONFIGURATION := ANCONFIGURATION;
      LRSTAGEDATA.LINEREVISION := 0;
      LRSTAGEDATA.STAGEID := ANSTAGEID;
      LRSTAGEDATA.SEQUENCE := ANSEQUENCE;
      GTSPPDSTAGEDATA( 0 ) := LRSTAGEDATA;

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
      
      
      
      
      
      
      
      
      CHECKBASICPDSTAGEDATAPARAMS( LRSTAGEDATA );

      
      IF ( ANALTERNATIVELANGUAGEID = 1 )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_STDLANGNOTALLOWED );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anAlternativeLanguageId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( LRSTAGEDATA.SEQUENCE IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'StageSequence' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSequence',
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

      IF ( ANALTERNATIVELANGUAGEID IS NOT NULL )
      THEN
         LNRETVAL := CHECKMULTILANGUAGE( ASPARTNO,
                                         ANREVISION );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
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

      
      LNRETVAL := IAPISPECIFICATIONPROCESSDATA.EXISTSECPROCESSDATA( ASPARTNO,
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

      
      OPEN LQSTAGE;

      FETCH LQSTAGE
       INTO LNSTAGE;

      IF LQSTAGE%NOTFOUND
      THEN
         CLOSE LQSTAGE;

         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_STAGENOTFOUND,
                                                     ANSTAGEID ) );
      END IF;

      CLOSE LQSTAGE;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      
      
      UPDATE SPECIFICATION_LINE_PROP
         SET NUM_1 = AFNUMERIC1,
             NUM_2 = AFNUMERIC2,
             NUM_3 = AFNUMERIC3,
             NUM_4 = AFNUMERIC4,
             NUM_5 = AFNUMERIC5,
             NUM_6 = AFNUMERIC6,
             NUM_7 = AFNUMERIC7,
             NUM_8 = AFNUMERIC8,
             NUM_9 = AFNUMERIC9,
             NUM_10 = AFNUMERIC10,
             CHAR_1 = ASSTRING1,
             CHAR_2 = ASSTRING2,
             CHAR_3 = ASSTRING3,
             CHAR_4 = ASSTRING4,
             CHAR_5 = ASSTRING5,
             CHAR_6 = ASSTRING6,
             BOOLEAN_1 = ASBOOLEAN1,
             BOOLEAN_2 = ASBOOLEAN2,
             BOOLEAN_3 = ASBOOLEAN3,
             BOOLEAN_4 = ASBOOLEAN4,
             DATE_1 = ADDATE1,
             DATE_2 = ADDATE2,
             CHARACTERISTIC = ANCHARACTERISTICID1,
             TEST_METHOD = ANTESTMETHODID,
             SEQUENCE_NO = DECODE( ANNEWSEQUENCE,
                                   NULL, ANSEQUENCE,
                                   ANSEQUENCE, ANSEQUENCE,
                                   ANNEWSEQUENCE )
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANTNO
         AND LINE = ASLINE
         AND CONFIGURATION = ANCONFIGURATION
         AND PROCESS_LINE_REV = 0
         AND STAGE = ANSTAGEID
         AND SEQUENCE_NO = ANSEQUENCE;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SPPDSTAGEDATANOTFOUND,
                                                     ASPARTNO,
                                                     ANREVISION,
                                                     ASPLANTNO,
                                                     ASLINE,
                                                     ANCONFIGURATION,
                                                     ANSTAGEID ) );
      END IF;

      
      IF ( ANALTERNATIVELANGUAGEID IS NOT NULL )
      THEN
         
         IF     ASALTERNATIVESTRING1 IS NULL
            AND ASALTERNATIVESTRING2 IS NULL
            AND ASALTERNATIVESTRING3 IS NULL
            AND ASALTERNATIVESTRING4 IS NULL
            AND ASALTERNATIVESTRING5 IS NULL
            AND ASALTERNATIVESTRING6 IS NULL
         THEN
            
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 'Delete alternative language',
                                 IAPICONSTANT.INFOLEVEL_3 );

            UPDATE ITSHLNPROPLANG
               SET CHAR_1 = NULL,
                   CHAR_2 = NULL,
                   CHAR_3 = NULL,
                   CHAR_4 = NULL,
                   CHAR_5 = NULL,
                   CHAR_6 = NULL
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND PLANT = ASPLANTNO
               AND LINE = ASLINE
               AND CONFIGURATION = ANCONFIGURATION
               AND STAGE = ANSTAGEID
               AND SEQUENCE_NO = ANSEQUENCE
               AND LANG_ID = ANALTERNATIVELANGUAGEID;

            DELETE      ITSHLNPROPLANG
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION
                    AND PLANT = ASPLANTNO
                    AND LINE = ASLINE
                    AND CONFIGURATION = ANCONFIGURATION
                    AND STAGE = ANSTAGEID
                    AND SEQUENCE_NO = ANSEQUENCE
                    AND LANG_ID = ANALTERNATIVELANGUAGEID
                    AND TEXT IS NULL;
         ELSE
            BEGIN
               
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    'Try to insert multi-language data',
                                    IAPICONSTANT.INFOLEVEL_3 );

                  
                  
                  UPDATE ITSHLNPROPLANG
                     SET SEQUENCE_NO = SEQUENCE_NO * (-1)
                   WHERE PART_NO = ASPARTNO
                     AND REVISION = ANREVISION
                     AND PLANT = ASPLANTNO
                     AND LINE = ASLINE
                     AND CONFIGURATION = ANCONFIGURATION
                     AND STAGE = ANSTAGEID
                     AND SEQUENCE_NO < 0
                     AND LANG_ID = ANALTERNATIVELANGUAGEID;
                  

               INSERT INTO ITSHLNPROPLANG
                           ( PART_NO,
                             REVISION,
                             PLANT,
                             LINE,
                             CONFIGURATION,
                             STAGE,
                             PROPERTY,
                             ATTRIBUTE,
                             LANG_ID,
                             SEQUENCE_NO,
                             CHAR_1,
                             CHAR_2,
                             CHAR_3,
                             CHAR_4,
                             CHAR_5,
                             CHAR_6 )
                    VALUES ( ASPARTNO,
                             ANREVISION,
                             ASPLANTNO,
                             ASLINE,
                             ANCONFIGURATION,
                             ANSTAGEID,
                             ANPROPERTYID,
                             ANATTRIBUTEID,
                             ANALTERNATIVELANGUAGEID,
                             
                             
                             DECODE( ANNEWSEQUENCE,
                                     NULL, ANSEQUENCE,
                                     ANSEQUENCE, ANSEQUENCE,
                                     ANNEWSEQUENCE ),
                             
                             ASALTERNATIVESTRING1,
                             ASALTERNATIVESTRING2,
                             ASALTERNATIVESTRING3,
                             ASALTERNATIVESTRING4,
                             ASALTERNATIVESTRING5,
                             ASALTERNATIVESTRING6 );
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX
               THEN
                  
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                       'Update multi-language data',
                                       IAPICONSTANT.INFOLEVEL_3 );

                  UPDATE ITSHLNPROPLANG
                     SET CHAR_1 = ASALTERNATIVESTRING1,
                         CHAR_2 = ASALTERNATIVESTRING2,
                         CHAR_3 = ASALTERNATIVESTRING3,
                         CHAR_4 = ASALTERNATIVESTRING4,
                         CHAR_5 = ASALTERNATIVESTRING5,
                         CHAR_6 = ASALTERNATIVESTRING6
                   WHERE PART_NO = ASPARTNO
                     AND REVISION = ANREVISION
                     AND PLANT = ASPLANTNO
                     AND LINE = ASLINE
                     AND CONFIGURATION = ANCONFIGURATION
                     AND STAGE = ANSTAGEID
                     
                     
                     AND SEQUENCE_NO = DECODE( ANNEWSEQUENCE,
                                               NULL, ANSEQUENCE,
                                               ANSEQUENCE, ANSEQUENCE,
                                               ANNEWSEQUENCE )
                     

                     AND LANG_ID = ANALTERNATIVELANGUAGEID;
            END;
         END IF;
      END IF;

      
      INSERT INTO SPECDATA_SERVER
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID )
           VALUES ( LRSTAGEDATA.PARTNO,
                    LRSTAGEDATA.REVISION,
                    LNSECTIONID,
                    LNSUBSECTIONID );

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRSTAGEDATA.PARTNO,
                                                       LRSTAGEDATA.REVISION,
                                                       LNSECTIONID,
                                                       LNSUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRSTAGEDATA.PARTNO,
                                                LRSTAGEDATA.REVISION );

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
   END SAVESTAGEDATAPROPERTY;

   
   FUNCTION SAVESTAGEDATATEXT(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      ANSTAGEID                  IN       IAPITYPE.STAGEID_TYPE,
      ANSEQUENCE                 IN       IAPITYPE.LINEPROPSEQUENCE_TYPE,
      ANNEWSEQUENCE              IN       IAPITYPE.LINEPROPSEQUENCE_TYPE DEFAULT NULL,
      ASTEXT                     IN       IAPITYPE.STRING_TYPE,
      ANALTERNATIVELANGUAGEID    IN       IAPITYPE.LANGUAGEID_TYPE DEFAULT NULL,
      ASALTERNATIVETEXT          IN       IAPITYPE.STRING_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQSTAGE
      IS
         SELECT STAGE
           FROM STAGE
          WHERE STAGE = ANSTAGEID;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveStageDataText';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRSTAGEDATA                   IAPITYPE.SPPDSTAGEDATAREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
      LNSTAGE                       STAGE.STAGE%TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LSSQLINFO                     IAPITYPE.SQLSTRING_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LSINTERNATIONAL               IAPITYPE.INTL_TYPE := '0';
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
      GTSPPDSTAGEDATA.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRSTAGEDATA.PARTNO := ASPARTNO;
      LRSTAGEDATA.REVISION := ANREVISION;
      LRSTAGEDATA.PLANTNO := ASPLANTNO;
      LRSTAGEDATA.LINE := ASLINE;
      LRSTAGEDATA.CONFIGURATION := ANCONFIGURATION;
      LRSTAGEDATA.LINEREVISION := 0;
      LRSTAGEDATA.STAGEID := ANSTAGEID;
      LRSTAGEDATA.SEQUENCE := ANSEQUENCE;
      GTSPPDSTAGEDATA( 0 ) := LRSTAGEDATA;

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
      
      
      
      
      
      
      
      
      
      
      
      CHECKBASICPDSTAGEDATAPARAMS( LRSTAGEDATA );

      
      IF ( ANALTERNATIVELANGUAGEID = 1 )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_STDLANGNOTALLOWED );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anAlternativeLanguageId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( LRSTAGEDATA.SEQUENCE IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'StageSequence' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSequence',
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

      IF ( ANALTERNATIVELANGUAGEID IS NOT NULL )
      THEN
         LNRETVAL := CHECKMULTILANGUAGE( ASPARTNO,
                                         ANREVISION );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
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

      
      LNRETVAL := IAPISPECIFICATIONPROCESSDATA.EXISTSECPROCESSDATA( ASPARTNO,
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

      
      OPEN LQSTAGE;

      FETCH LQSTAGE
       INTO LNSTAGE;

      IF LQSTAGE%NOTFOUND
      THEN
         CLOSE LQSTAGE;

         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_STAGENOTFOUND,
                                                     ANSTAGEID ) );
      END IF;

      CLOSE LQSTAGE;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      
      
      IF IAPIGENERAL.SESSION.SETTINGS.INTERNATIONAL = TRUE
      THEN
         LSINTERNATIONAL := '1';
      ELSE
         LSINTERNATIONAL := '0';
      END IF;

      UPDATE SPECIFICATION_LINE_PROP
         SET TEXT = ASTEXT,
             SEQUENCE_NO = DECODE( ANNEWSEQUENCE,
                                   NULL, ANSEQUENCE,
                                   ANSEQUENCE, ANSEQUENCE,
                                   ANNEWSEQUENCE ),
             INTL = LSINTERNATIONAL
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANTNO
         AND LINE = ASLINE
         AND CONFIGURATION = ANCONFIGURATION
         AND PROCESS_LINE_REV = 0
         AND STAGE = ANSTAGEID
         AND SEQUENCE_NO = ANSEQUENCE;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SPPDSTAGEDATANOTFOUND,
                                                     ASPARTNO,
                                                     ANREVISION,
                                                     ASPLANTNO,
                                                     ASLINE,
                                                     ANCONFIGURATION,
                                                     ANSTAGEID ) );
      END IF;

      
      IF ( ANALTERNATIVELANGUAGEID IS NOT NULL )
      THEN
         
         
         IF ASTEXT IS NULL
         THEN
            
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 'Delete alternative language',
                                 IAPICONSTANT.INFOLEVEL_3 );

            UPDATE ITSHLNPROPLANG
               SET TEXT = NULL
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND PLANT = ASPLANTNO
               AND LINE = ASLINE
               AND CONFIGURATION = ANCONFIGURATION
               AND STAGE = ANSTAGEID
               AND SEQUENCE_NO = ANSEQUENCE
               AND LANG_ID = ANALTERNATIVELANGUAGEID;

            DELETE      ITSHLNPROPLANG
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION
                    AND PLANT = ASPLANTNO
                    AND LINE = ASLINE
                    AND CONFIGURATION = ANCONFIGURATION
                    AND STAGE = ANSTAGEID
                    AND SEQUENCE_NO = ANSEQUENCE
                    AND LANG_ID = ANALTERNATIVELANGUAGEID
                    AND CHAR_1 IS NULL
                    AND CHAR_2 IS NULL
                    AND CHAR_3 IS NULL
                    AND CHAR_4 IS NULL
                    AND CHAR_5 IS NULL
                    AND CHAR_6 IS NULL;
         ELSE
            BEGIN
               
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    'Try to insert multi-language data',
                                    IAPICONSTANT.INFOLEVEL_3 );

             
              
              UPDATE ITSHLNPROPLANG
                 SET SEQUENCE_NO = SEQUENCE_NO * (-1)
               WHERE PART_NO = ASPARTNO
                 AND REVISION = ANREVISION
                 AND PLANT = ASPLANTNO
                 AND LINE = ASLINE
                 AND CONFIGURATION = ANCONFIGURATION
                 AND STAGE = ANSTAGEID
                 AND SEQUENCE_NO < 0
                 AND LANG_ID = ANALTERNATIVELANGUAGEID;
              

               INSERT INTO ITSHLNPROPLANG
                           ( PART_NO,
                             REVISION,
                             PLANT,
                             LINE,
                             CONFIGURATION,
                             STAGE,
                             PROPERTY,
                             ATTRIBUTE,
                             SEQUENCE_NO,
                             LANG_ID,
                             TEXT )
                    VALUES ( ASPARTNO,
                             ANREVISION,
                             ASPLANTNO,
                             ASLINE,
                             ANCONFIGURATION,
                             ANSTAGEID,
                             0,
                             0,
                             
                             
                              DECODE( ANNEWSEQUENCE,
                                      NULL, ANSEQUENCE,
                                      ANSEQUENCE, ANSEQUENCE,
                                      ANNEWSEQUENCE ),
                             
                             ANALTERNATIVELANGUAGEID,
                             ASALTERNATIVETEXT );
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX
               THEN
                  
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                       'Update multi-language data',
                                       IAPICONSTANT.INFOLEVEL_3 );

                  UPDATE ITSHLNPROPLANG
                     SET TEXT = ASALTERNATIVETEXT
                   WHERE PART_NO = ASPARTNO
                     AND REVISION = ANREVISION
                     AND PLANT = ASPLANTNO
                     AND LINE = ASLINE
                     AND CONFIGURATION = ANCONFIGURATION
                     AND STAGE = ANSTAGEID
                     
                     
                     AND SEQUENCE_NO = DECODE( ANNEWSEQUENCE,
                                               NULL, ANSEQUENCE,
                                               ANSEQUENCE, ANSEQUENCE,
                                               ANNEWSEQUENCE )
                     
                     AND LANG_ID = ANALTERNATIVELANGUAGEID;
            END;
         END IF;
      END IF;

      
      INSERT INTO SPECDATA_SERVER
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID )
           VALUES ( LRSTAGEDATA.PARTNO,
                    LRSTAGEDATA.REVISION,
                    LNSECTIONID,
                    LNSUBSECTIONID );

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRSTAGEDATA.PARTNO,
                                                       LRSTAGEDATA.REVISION,
                                                       LNSECTIONID,
                                                       LNSUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRSTAGEDATA.PARTNO,
                                                LRSTAGEDATA.REVISION );

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
   END SAVESTAGEDATATEXT;

   
   FUNCTION SAVESTAGEDATABOMITEM(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      ANSTAGEID                  IN       IAPITYPE.STAGEID_TYPE,
      ANSEQUENCE                 IN       IAPITYPE.LINEPROPSEQUENCE_TYPE,
      ANNEWSEQUENCE              IN       IAPITYPE.LINEPROPSEQUENCE_TYPE DEFAULT NULL,
      ASCOMPONENTPART            IN       IAPITYPE.PARTNO_TYPE,
      
      
      AFQUANTITY                 IN       IAPITYPE.BOMQUANTITY_TYPE,
      
      ASUOM                      IN       IAPITYPE.BASEUOM_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANBOMUSAGE                 IN       IAPITYPE.BOMUSAGE_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQSTAGE
      IS
         SELECT STAGE
           FROM STAGE
          WHERE STAGE = ANSTAGEID;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveStageDataBomItem';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRSTAGEDATA                   IAPITYPE.SPPDSTAGEDATAREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
      LNSTAGE                       STAGE.STAGE%TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LSSQLINFO                     IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
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
      GTSPPDSTAGEDATA.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRSTAGEDATA.PARTNO := ASPARTNO;
      LRSTAGEDATA.REVISION := ANREVISION;
      LRSTAGEDATA.PLANTNO := ASPLANTNO;
      LRSTAGEDATA.LINE := ASLINE;
      LRSTAGEDATA.CONFIGURATION := ANCONFIGURATION;
      LRSTAGEDATA.LINEREVISION := 0;
      LRSTAGEDATA.STAGEID := ANSTAGEID;
      LRSTAGEDATA.SEQUENCE := ANSEQUENCE;
      GTSPPDSTAGEDATA( 0 ) := LRSTAGEDATA;

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
      
      
      
      
      
      
      
      
      
      
      
      CHECKBASICPDSTAGEDATAPARAMS( LRSTAGEDATA );

      
      IF ( LRSTAGEDATA.SEQUENCE IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'StageSequence' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSequence',
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

      
      LNRETVAL := IAPISPECIFICATIONPROCESSDATA.EXISTSECPROCESSDATA( ASPARTNO,
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

      
      OPEN LQSTAGE;

      FETCH LQSTAGE
       INTO LNSTAGE;

      IF LQSTAGE%NOTFOUND
      THEN
         CLOSE LQSTAGE;

         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_STAGENOTFOUND,
                                                     ANSTAGEID ) );
      END IF;

      CLOSE LQSTAGE;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      
      
      UPDATE SPECIFICATION_LINE_PROP
         SET COMPONENT_PART = ASCOMPONENTPART,
             QUANTITY = AFQUANTITY,
             UOM = ASUOM,
             ALTERNATIVE = ANALTERNATIVE,
             BOM_USAGE = ANBOMUSAGE,
             SEQUENCE_NO = DECODE( ANNEWSEQUENCE,
                                   NULL, ANSEQUENCE,
                                   ANSEQUENCE, ANSEQUENCE,
                                   ANNEWSEQUENCE )
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANTNO
         AND LINE = ASLINE
         AND CONFIGURATION = ANCONFIGURATION
         AND PROCESS_LINE_REV = 0
         AND STAGE = ANSTAGEID
         AND SEQUENCE_NO = ANSEQUENCE;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SPPDSTAGEDATANOTFOUND,
                                                     ASPARTNO,
                                                     ANREVISION,
                                                     ASPLANTNO,
                                                     ASLINE,
                                                     ANCONFIGURATION,
                                                     ANSTAGEID ) );
      END IF;

      
      INSERT INTO SPECDATA_SERVER
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID )
           VALUES ( LRSTAGEDATA.PARTNO,
                    LRSTAGEDATA.REVISION,
                    LNSECTIONID,
                    LNSUBSECTIONID );

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRSTAGEDATA.PARTNO,
                                                       LRSTAGEDATA.REVISION,
                                                       LNSECTIONID,
                                                       LNSUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRSTAGEDATA.PARTNO,
                                                LRSTAGEDATA.REVISION );

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
   END SAVESTAGEDATABOMITEM;

   
   FUNCTION EXISTSECPROCESSDATA(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                OUT      IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             OUT      IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      CURSOR LQSECPROCESSDATA
      IS
         SELECT SECTION_ID,
                SUB_SECTION_ID
           FROM SPECIFICATION_SECTION
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND TYPE = IAPICONSTANT.SECTIONTYPE_PROCESSDATA;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistSecProcessData';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN LQSECPROCESSDATA;

      FETCH LQSECPROCESSDATA
       INTO ANSECTIONID,
            ANSUBSECTIONID;

      IF LQSECPROCESSDATA%NOTFOUND
      THEN
         CLOSE LQSECPROCESSDATA;

         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SPSECTIONNOTFOUND,
                                                     ASPARTNO,
                                                     ANREVISION,
                                                     '',
                                                     'ProcessData' ) );
      END IF;

      CLOSE LQSECPROCESSDATA;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTSECPROCESSDATA;

   
   FUNCTION SAVESTAGEDATAFREETEXT(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      ANSTAGEID                  IN       IAPITYPE.STAGEID_TYPE,
      ALTEXT                     IN       IAPITYPE.CLOB_TYPE,
      ANLANGUAGEID               IN       IAPITYPE.LANGUAGEID_TYPE DEFAULT 1,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQSTAGE
      IS
         SELECT STAGE
           FROM STAGE
          WHERE STAGE = ANSTAGEID;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveStageDataFreeText';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRSTAGE                       IAPITYPE.SPPDSTAGEREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
      LNSTAGE                       STAGE.STAGE%TYPE;
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
      GTSPPDSTAGES.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRSTAGE.PARTNO := ASPARTNO;
      LRSTAGE.REVISION := ANREVISION;
      LRSTAGE.PLANTNO := ASPLANTNO;
      LRSTAGE.LINE := ASLINE;
      LRSTAGE.CONFIGURATION := ANCONFIGURATION;
      LRSTAGE.STAGEID := ANSTAGEID;
      GTSPPDSTAGES( 0 ) := LRSTAGE;

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
      
      
      
      
      
      
      
      
      CHECKBASICPDSTAGEPARAMS( LRSTAGE );

      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( LNRETVAL );
         END IF;
      END IF;

      IF ( ANLANGUAGEID <> 1 )
      THEN
         LNRETVAL := CHECKMULTILANGUAGE( ASPARTNO,
                                         ANREVISION );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
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

      
      LNRETVAL := IAPISPECIFICATIONPROCESSDATA.EXISTSECPROCESSDATA( ASPARTNO,
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

      
      OPEN LQSTAGE;

      FETCH LQSTAGE
       INTO LNSTAGE;

      IF LQSTAGE%NOTFOUND
      THEN
         CLOSE LQSTAGE;

         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_STAGENOTFOUND,
                                                     ANSTAGEID ) );
      END IF;

      CLOSE LQSTAGE;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF (     ( ANLANGUAGEID = 1 )
           OR (      ( ANLANGUAGEID <> 1 )
                AND ( ALTEXT IS NOT NULL ) ) )
      THEN
         BEGIN
            UPDATE SPECIFICATION_LINE_TEXT
               SET TEXT = ALTEXT
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND PLANT = ASPLANTNO
               AND LINE = ASLINE
               AND CONFIGURATION = ANCONFIGURATION
               AND STAGE = ANSTAGEID
               AND LANG_ID = ANLANGUAGEID;

            IF ( SQL%ROWCOUNT = 0 )
            THEN
               
               INSERT INTO SPECIFICATION_LINE_TEXT
                           ( PART_NO,
                             REVISION,
                             PLANT,
                             LINE,
                             CONFIGURATION,
                             STAGE,
                             TEXT_TYPE,
                             TEXT,
                             LANG_ID )
                  SELECT PART_NO,
                         REVISION,
                         PLANT,
                         LINE,
                         CONFIGURATION,
                         STAGE,
                         TEXT_TYPE,
                         ALTEXT,
                         ANLANGUAGEID
                    FROM SPECIFICATION_LINE_TEXT
                   WHERE PART_NO = ASPARTNO
                     AND REVISION = ANREVISION
                     AND PLANT = ASPLANTNO
                     AND LINE = ASLINE
                     AND CONFIGURATION = ANCONFIGURATION
                     AND STAGE = ANSTAGEID
                     AND LANG_ID = 1;
            END IF;
         END;
      ELSE
         
         DELETE FROM SPECIFICATION_LINE_TEXT
               WHERE PART_NO = ASPARTNO
                 AND REVISION = ANREVISION
                 AND PLANT = ASPLANTNO
                 AND LINE = ASLINE
                 AND CONFIGURATION = ANCONFIGURATION
                 AND STAGE = ANSTAGEID
                 AND LANG_ID = ANLANGUAGEID;
      END IF;

      
      INSERT INTO SPECDATA_SERVER
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID )
           VALUES ( LRSTAGE.PARTNO,
                    LRSTAGE.REVISION,
                    LNSECTIONID,
                    LNSUBSECTIONID );

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRSTAGE.PARTNO,
                                                       LRSTAGE.REVISION,
                                                       LNSECTIONID,
                                                       LNSUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRSTAGE.PARTNO,
                                                LRSTAGE.REVISION );

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
   END SAVESTAGEDATAFREETEXT;

   
   FUNCTION GETAVAILABLELINES(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      AQLINES                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetAvailableLines';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'pp.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', pp.plant '
            || IAPICONSTANTCOLUMN.PLANTNOCOL
            || ', pl.line '
            || IAPICONSTANTCOLUMN.LINECOL
            || ', pl.configuration '
            || IAPICONSTANTCOLUMN.CONFIGURATIONCOL
            || ', f_plh_descr(pp.plant, pl.line, pl.configuration) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', rownum '
            || IAPICONSTANTCOLUMN.ROWINDEXCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'process_line pl, part_plant pp';
   BEGIN
      
      
      
      
      
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM
               || ' WHERE pp.part_no = :PartNo'
               || ' AND pp.plant = pl.plant'
               || ' AND pl.status = 2';
      LSSQL :=
                LSSQL
             || ' ORDER BY '
             || IAPICONSTANTCOLUMN.PLANTNOCOL
             || ','
             || IAPICONSTANTCOLUMN.LINECOL
             || ','
             || IAPICONSTANTCOLUMN.CONFIGURATIONCOL;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQLINES%ISOPEN )
      THEN
         CLOSE AQLINES;
      END IF;

      
      OPEN AQLINES FOR LSSQL USING ASPARTNO;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETAVAILABLELINES;

   
   FUNCTION SAVESTAGES(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      ANACTION                   IN       IAPITYPE.NUMVAL_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveStages';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRSTAGE                       IAPITYPE.SPPDSTAGEREC_TYPE;
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
      GTSPPDSTAGES.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRSTAGE.PARTNO := ASPARTNO;
      LRSTAGE.REVISION := ANREVISION;
      LRSTAGE.PLANTNO := ASPLANTNO;
      LRSTAGE.LINE := ASLINE;
      LRSTAGE.CONFIGURATION := ANCONFIGURATION;
      LRSTAGE.LINEREVISION := 0;
      GTSPPDSTAGES( 0 ) := LRSTAGE;

      GTINFO( 0 ) := LRINFO;

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
         WHEN IAPICONSTANT.ACTIONPOST
         THEN
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
   END SAVESTAGES;

   
   FUNCTION SAVELINES(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANACTION                   IN       IAPITYPE.NUMVAL_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveLines';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRLINE                        IAPITYPE.SPPDLINEREC_TYPE;
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
      GTSPPDLINES.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRLINE.PARTNO := ASPARTNO;
      LRLINE.REVISION := ANREVISION;
      GTSPPDLINES( 0 ) := LRLINE;

      GTINFO( 0 ) := LRINFO;

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
         WHEN IAPICONSTANT.ACTIONPOST
         THEN
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
   END SAVELINES;

   
   FUNCTION SAVESTAGEDATA(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      ANSTAGEID                  IN       IAPITYPE.STAGEID_TYPE,
      ANACTION                   IN       IAPITYPE.NUMVAL_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveStageData';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRSTAGEDATA                   IAPITYPE.SPPDSTAGEDATAREC_TYPE;
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
      GTSPPDSTAGEDATA.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRSTAGEDATA.PARTNO := ASPARTNO;
      LRSTAGEDATA.REVISION := ANREVISION;
      LRSTAGEDATA.PLANTNO := ASPLANTNO;
      LRSTAGEDATA.LINE := ASLINE;
      LRSTAGEDATA.CONFIGURATION := ANCONFIGURATION;
      LRSTAGEDATA.STAGEID := ANSTAGEID;
      GTSPPDSTAGEDATA( 0 ) := LRSTAGEDATA;

      GTINFO( 0 ) := LRINFO;

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
         WHEN IAPICONSTANT.ACTIONPOST
         THEN
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
   END SAVESTAGEDATA;

   
   FUNCTION GETAVAILABLESTAGES(
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      AQSTAGES                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetAvailableStages';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'p.stage '
            || IAPICONSTANTCOLUMN.STAGEIDCOL
            || ','
            || 'p.text_type '
            || IAPICONSTANTCOLUMN.TEXTTYPECOL
            || ','
            || 'p.display_format '
            || IAPICONSTANTCOLUMN.DISPLAYFORMATIDCOL
            || ', f_sth_descr(p.stage) '
            || IAPICONSTANTCOLUMN.STAGECOL
            || ','
            || 'p.intl '
            || IAPICONSTANTCOLUMN.INTERNATIONALCOL
            || ','
            || 'l.revision '
            || IAPICONSTANTCOLUMN.DISPLAYFORMATREVISIONCOL
            || ','
            || 'rownum '
            || IAPICONSTANTCOLUMN.ROWINDEXCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'process_line_stage p, layout l';
   BEGIN
      
      
      
      
      
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=
            'SELECT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE p.plant = :Plant'
         || ' AND p.line = :Line'
         || ' AND p.configuration = :Configuration'
         || ' AND p.display_format = l.layout_id'
         || ' AND l.status = 2';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQSTAGES%ISOPEN )
      THEN
         CLOSE AQSTAGES;
      END IF;

      
      OPEN AQSTAGES FOR LSSQL USING ASPLANT,
      ASLINE,
      ANCONFIGURATION;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETAVAILABLESTAGES;

   
   FUNCTION GETUSESPECIFICATIONS(
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      AXDEFAULTFILTER            IN       IAPITYPE.XMLTYPE_TYPE,
      AQSPECIFICATIONS           OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUseSpecifications';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTDEFAULTFILTER               IAPITYPE.FILTERTAB_TYPE;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'sh.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', max(bh.revision) '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', sh.description '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', sh.status '
            || IAPICONSTANTCOLUMN.STATUSIDCOL
            || ', s.sort_desc '
            || IAPICONSTANTCOLUMN.STATUSCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'specification_header sh, spec_access sa, bom_header bh, status s';
   BEGIN
      
      
      
      
      
      IF ( AQSPECIFICATIONS%ISOPEN )
      THEN
         CLOSE AQSPECIFICATIONS;
      END IF;

      LSSQLNULL :=
            'SELECT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE sh.access_group = sa.access_group '
         || '   AND sa.user_id = :CurrentUser '
         || '   AND sh.part_no = bh.part_no AND bh.plant = :Plant '
         || '   AND sh.status = s.status AND sh.part_no = NULL';
      LSSQLNULL :=    LSSQLNULL
                   || ' GROUP BY sh.part_no, sh.description, sh.status, s.sort_desc ';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQLNULL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQSPECIFICATIONS FOR LSSQLNULL USING IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
      ASPLANTNO;

      
      
      
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

      LNRETVAL := IAPISPECIFICATIONPROCESSDATA.GETUSESPECIFICATIONS( ASPLANTNO,
                                                                     LTDEFAULTFILTER,
                                                                     AQSPECIFICATIONS );

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
   END GETUSESPECIFICATIONS;

   
   FUNCTION REMOVESTAGEDATAITEM(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      ANSTAGEID                  IN       IAPITYPE.STAGEID_TYPE,
      ANSEQUENCE                 IN       IAPITYPE.LINEPROPSEQUENCE_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveStageDataItem';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      RETURN( REMOVESTAGEDATAINTERNAL( ASPARTNO,
                                       ANREVISION,
                                       ASPLANTNO,
                                       ASLINE,
                                       ANCONFIGURATION,
                                       ANSTAGEID,
                                       1,
                                       ANSEQUENCE,
                                       LSMETHOD,
                                       AQINFO,
                                       AQERRORS ) );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVESTAGEDATAITEM;

   
   FUNCTION GETBOMITEMS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      AQBOMITEMS                 OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetBomItems';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'bi.component_part '
            || IAPICONSTANTCOLUMN.COMPONENTPARTNOCOL
            || ', sum(bi.quantity) '
            || IAPICONSTANTCOLUMN.QUANTITYCOL
            || ', bi.uom '
            || IAPICONSTANTCOLUMN.UOMCOL
            || ', bi.conv_factor '
            || IAPICONSTANTCOLUMN.CONVERSIONFACTORCOL
            || ', bi.to_unit '
            || IAPICONSTANTCOLUMN.TOUNITCOL
            || ', bi.plant '
            || IAPICONSTANTCOLUMN.PLANTCOL
            || ', bi.alternative '
            || IAPICONSTANTCOLUMN.ALTERNATIVECOL
            || ', bi.bom_usage '
            || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
            || ', p.description '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'bom_item bi, part p';
   BEGIN
      
      
      
      
      
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=
            'SELECT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE bi.component_part = p.part_no'
         || ' AND bi.alt_priority = 1'
         || ' AND bi.part_no = :PartNo'
         || ' AND bi.revision = :Revision'
         || ' AND bi.plant = :Plant';
      LSSQL :=
            LSSQL
         || ' GROUP BY bi.component_part '
         || ',bi.uom '
         || ',bi.conv_factor '
         || ',bi.to_unit '
         || ',bi.plant '
         || ',bi.alternative '
         || ',bi.bom_usage '
         || ',p.description';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQBOMITEMS%ISOPEN )
      THEN
         CLOSE AQBOMITEMS;
      END IF;

      
      OPEN AQBOMITEMS FOR LSSQL USING ASPARTNO,
      ANREVISION,
      ASPLANT;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETBOMITEMS;

   
   FUNCTION VALIDATESTAGES(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      ASUSEPARTNO                IN       IAPITYPE.PARTNO_TYPE,
      ANUSEPARTREVISION          IN       IAPITYPE.REVISION_TYPE,
      ASERRORTEXT                OUT      IAPITYPE.INFO_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQSUMCHECK
      IS
         SELECT   COMPONENT_PART,
                  SUM( QUANTITY ) QUANTITY,
                  UOM,
                  ALTERNATIVE,
                  BOM_USAGE
             FROM SPECIFICATION_LINE_PROP
            WHERE PART_NO = ASPARTNO
              AND REVISION = ANREVISION
              AND VALUE_TYPE = 2
              AND PLANT = ASPLANTNO
              AND LINE = ASLINE
              AND CONFIGURATION = ANCONFIGURATION
         GROUP BY COMPONENT_PART,
                  UOM,
                  ALTERNATIVE,
                  BOM_USAGE;

      CURSOR LQSUMQUANTITY(
         ANALTERNATIVE              IN       BOM_ITEM.ALTERNATIVE%TYPE,
         ANBOMUSAGE                 IN       BOM_ITEM.BOM_USAGE%TYPE,
         ASCOMPONENTPART            IN       IAPITYPE.PARTNO_TYPE )
      IS
         SELECT SUM( QUANTITY )
           FROM BOM_ITEM
          WHERE PART_NO = ASUSEPARTNO
            AND REVISION = ANUSEPARTREVISION
            AND PLANT = ASPLANTNO
            AND ALTERNATIVE = ANALTERNATIVE
            AND BOM_USAGE = ANBOMUSAGE
            AND COMPONENT_PART = ASCOMPONENTPART;

      CURSOR LQCOMPONENTPARTSTAGE
      IS
         SELECT COMPONENT_PART
           FROM SPECIFICATION_LINE_PROP
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND VALUE_TYPE = 2
            AND PLANT = ASPLANTNO
            AND LINE = ASLINE
            AND CONFIGURATION = ANCONFIGURATION
         MINUS
         SELECT COMPONENT_PART
           FROM BOM_ITEM
          WHERE PART_NO = ASUSEPARTNO
            AND REVISION = ANUSEPARTREVISION
            AND PLANT = ASPLANTNO;

      CURSOR LQCOMPONENTPARTBOM
      IS
         SELECT COMPONENT_PART
           FROM BOM_ITEM
          WHERE ALT_PRIORITY = 1
            AND PART_NO = ASUSEPARTNO
            AND REVISION = ANUSEPARTREVISION
            AND PLANT = ASPLANTNO
         MINUS
         SELECT COMPONENT_PART
           FROM SPECIFICATION_LINE_PROP
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND VALUE_TYPE = 2
            AND PLANT = ASPLANTNO
            AND LINE = ASLINE
            AND CONFIGURATION = ANCONFIGURATION;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateStages';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSCOMPONENTPART               IAPITYPE.INFO_TYPE;
      LSINGCHECK1                   IAPITYPE.INFO_TYPE;
      LSINGCHECK2                   IAPITYPE.INFO_TYPE;
      LNQUANTITY                    BOM_ITEM.QUANTITY%TYPE;
      LNPERCENTBOM                  BOM_ITEM.QUANTITY%TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      FOR LRREC IN LQSUMCHECK
      LOOP
         IF LRREC.UOM = '%'
         THEN
            IF LRREC.QUANTITY <> 100
            THEN
               LSCOMPONENTPART :=    LSCOMPONENTPART
                                  || CHR( 10 )
                                  || LRREC.COMPONENT_PART
                                  || ' ['
                                  || LRREC.QUANTITY
                                  || '%] ';
            END IF;
         ELSE
            
            OPEN LQSUMQUANTITY( LRREC.ALTERNATIVE,
                                LRREC.BOM_USAGE,
                                LRREC.COMPONENT_PART );

            FETCH LQSUMQUANTITY
             INTO LNQUANTITY;

            CLOSE LQSUMQUANTITY;

            IF NVL( LNQUANTITY,
                    0 ) <> 0
            THEN
               LNPERCENTBOM :=   (   LRREC.QUANTITY
                                   / LNQUANTITY )
                               * 100;

               IF NVL( LNPERCENTBOM,
                       0 ) <> 100
               THEN
                  LSCOMPONENTPART :=
                        LSCOMPONENTPART
                     || CHR( 10 )
                     || LRREC.COMPONENT_PART
                     || ' ['
                     || LNPERCENTBOM
                     || '% ('
                     || LRREC.QUANTITY
                     || ' '
                     || LRREC.UOM
                     || ') ] ';
               END IF;
            END IF;
         END IF;
      END LOOP;

      IF LSCOMPONENTPART IS NOT NULL
      THEN
         LSCOMPONENTPART :=    'The following ingredients have an incorrect quantity'
                            || ':'
                            || CHR( 10 )
                            || LSCOMPONENTPART;
      END IF;

      FOR LRROWSTAGE IN LQCOMPONENTPARTSTAGE
      LOOP
         LSINGCHECK1 :=    LSINGCHECK1
                        || CHR( 10 )
                        || LRROWSTAGE.COMPONENT_PART;
      END LOOP;

      IF LSINGCHECK1 IS NOT NULL
      THEN
         LSINGCHECK1 :=    CHR( 10 )
                        || 'The following ingredients can no longer be used'
                        || ':'
                        || CHR( 10 )
                        || LSINGCHECK1;
      END IF;

      FOR LRROWBOM IN LQCOMPONENTPARTBOM
      LOOP
         LSINGCHECK2 :=    LSINGCHECK2
                        || CHR( 10 )
                        || LRROWBOM.COMPONENT_PART;
      END LOOP;

      IF LSINGCHECK2 IS NOT NULL
      THEN
         LSINGCHECK2 :=    CHR( 10 )
                        || 'The following ingredients are not used'
                        || ':'
                        || CHR( 10 )
                        || LSINGCHECK2;
      END IF;

      IF    LSCOMPONENTPART IS NOT NULL
         OR LSINGCHECK1 IS NOT NULL
         OR LSINGCHECK2 IS NOT NULL
      THEN
         ASERRORTEXT :=    LSCOMPONENTPART
                        || CHR( 10 )
                        || LSINGCHECK1
                        || CHR( 10 )
                        || LSINGCHECK2;
      ELSE
         ASERRORTEXT := 'The Process Data is valid.';
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END VALIDATESTAGES;

   
   FUNCTION COPYDATA(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANTNOFROM              IN       IAPITYPE.PLANTNO_TYPE,
      ASLINEFROM                 IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATIONFROM        IN       IAPITYPE.CONFIGURATION_TYPE,
      ASPLANTNOTO                IN       IAPITYPE.PLANTNO_TYPE,
      ASLINETO                   IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATIONTO          IN       IAPITYPE.CONFIGURATION_TYPE,
      ANSEQUENCETO               IN       IAPITYPE.SEQUENCE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CopyData';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LLTEXT                        IAPITYPE.CLOB_TYPE;
      LSINTL                        IAPITYPE.INTL_TYPE;
      LSSESSIONINTL                 IAPITYPE.INTL_TYPE;
      
      
      LNSECTIONID                   IAPITYPE.ID_TYPE := NULL;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE := NULL;     
     

      CURSOR CUR_SPECIFICATION_STAGE
      IS
         SELECT STAGE,
                SEQUENCE_NO
           FROM PROCESS_LINE_STAGE
          WHERE PLANT = ASPLANTNOTO
            AND LINE = ASLINETO
            AND CONFIGURATION = ANCONFIGURATIONTO;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      BEGIN
         INSERT INTO SPECIFICATION_LINE
                     ( PART_NO,
                       REVISION,
                       PLANT,
                       LINE,
                       CONFIGURATION,
                       PROCESS_LINE_REV,
                       ITEM_PART_NO,
                       ITEM_REVISION,
                       SEQUENCE )
            SELECT PART_NO,
                   REVISION,
                   ASPLANTNOTO,
                   ASLINETO,
                   ANCONFIGURATIONTO,
                   0,
                   ITEM_PART_NO,
                   ITEM_REVISION,
                   ANSEQUENCETO
              FROM SPECIFICATION_LINE
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND PLANT = ASPLANTNOFROM
               AND LINE = ASLINEFROM
               AND CONFIGURATION = ANCONFIGURATIONFROM;
               
                     
         LNRETVAL := IAPISPECIFICATIONPROCESSDATA.EXISTSECPROCESSDATA( ASPARTNO,
                                                                            ANREVISION,
                                                                            LNSECTIONID,
                                                                            LNSUBSECTIONID );
          
         IF (LNSECTIONID IS NOT NULL) AND (LNSUBSECTIONID IS NOT NULL)
         THEN                                                                  
              
              INSERT INTO SPECDATA_SERVER
                          ( PART_NO,
                            REVISION,
                            SECTION_ID,
                            SUB_SECTION_ID )
                   VALUES ( ASPARTNO,
                            ANREVISION,
                            LNSECTIONID,
                            LNSUBSECTIONID );
          END IF;
          
          
          LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( ASPARTNO,
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

          
          LNRETVAL := IAPISPECIFICATION.LOGCHANGES( ASPARTNO,
                                                                       ANREVISION );

          IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
          THEN
             IAPIGENERAL.LOGINFO( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
             RETURN( LNRETVAL );
          END IF;
        
               
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      BEGIN
         IF ASPLANTNOTO = 'INTL'
         THEN
            LSINTL := '1';
         ELSE
            LSINTL := '0';
         END IF;

         IF IAPIGENERAL.SESSION.SETTINGS.INTERNATIONAL = TRUE
         THEN
            LSSESSIONINTL := '1';
         ELSE
            LSSESSIONINTL := '0';
         END IF;

         INSERT INTO SPECIFICATION_LINE_PROP
                     ( PART_NO,
                       REVISION,
                       SECTION_ID,
                       SECTION_REV,
                       SUB_SECTION_ID,
                       SUB_SECTION_REV,
                       PLANT,
                       LINE,
                       LINE_REV,
                       CONFIGURATION,
                       PROCESS_LINE_REV,
                       STAGE,
                       STAGE_REV,
                       PROPERTY,
                       PROPERTY_REV,
                       ATTRIBUTE,
                       ATTRIBUTE_REV,
                       UOM_ID,
                       UOM_REV,
                       TEST_METHOD,
                       TEST_METHOD_REV,
                       SEQUENCE_NO,
                       VALUE_TYPE,
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
                       TEXT,
                       BOOLEAN_1,
                       BOOLEAN_2,
                       BOOLEAN_3,
                       BOOLEAN_4,
                       DATE_1,
                       DATE_2,
                       CHARACTERISTIC,
                       CHARACTERISTIC_REV,
                       ASSOCIATION,
                       ASSOCIATION_REV,
                       INTL,
                       COMPONENT_PART,
                       QUANTITY,
                       UOM,
                       ALTERNATIVE,
                       BOM_USAGE )
            SELECT PART_NO,
                   REVISION,
                   SECTION_ID,
                   SECTION_REV,
                   SUB_SECTION_ID,
                   SUB_SECTION_REV,
                   ASPLANTNOTO,
                   ASLINETO,
                   LINE_REV,
                   ANCONFIGURATIONTO,
                   0,
                   STAGE,
                   STAGE_REV,
                   PROPERTY,
                   PROPERTY_REV,
                   ATTRIBUTE,
                   ATTRIBUTE_REV,
                   UOM_ID,
                   UOM_REV,
                   TEST_METHOD,
                   TEST_METHOD_REV,
                   SEQUENCE_NO,
                   VALUE_TYPE,
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
                   TEXT,
                   BOOLEAN_1,
                   BOOLEAN_2,
                   BOOLEAN_3,
                   BOOLEAN_4,
                   DATE_1,
                   DATE_2,
                   CHARACTERISTIC,
                   CHARACTERISTIC_REV,
                   ASSOCIATION,
                   ASSOCIATION_REV,
                   DECODE( LSSESSIONINTL,
                           '1', INTL,
                           '0', LSINTL ),
                   COMPONENT_PART,
                   QUANTITY,
                   UOM,
                   ALTERNATIVE,
                   BOM_USAGE
              FROM SPECIFICATION_LINE_PROP
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND PLANT = ASPLANTNOFROM
               AND LINE = ASLINEFROM
               AND CONFIGURATION = ANCONFIGURATIONFROM
               AND STAGE IN( SELECT STAGE
                              FROM PROCESS_LINE_STAGE
                             WHERE PLANT = ASPLANTNOTO
                               AND LINE = ASLINETO
                               AND CONFIGURATION = ANCONFIGURATIONTO );

         INSERT INTO ITSHLNPROPLANG
                     ( PART_NO,
                       REVISION,
                       PLANT,
                       LINE,
                       CONFIGURATION,
                       STAGE,
                       PROPERTY,
                       ATTRIBUTE,
                       SEQUENCE_NO,
                       CHAR_1,
                       CHAR_2,
                       CHAR_3,
                       CHAR_4,
                       CHAR_5,
                       CHAR_6,
                       TEXT,
                       LANG_ID )
            SELECT PART_NO,
                   REVISION,
                   ASPLANTNOTO,
                   ASLINETO,
                   ANCONFIGURATIONTO,
                   STAGE,
                   PROPERTY,
                   ATTRIBUTE,
                   SEQUENCE_NO,
                   CHAR_1,
                   CHAR_2,
                   CHAR_3,
                   CHAR_4,
                   CHAR_5,
                   CHAR_6,
                   TEXT,
                   LANG_ID
              FROM ITSHLNPROPLANG
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND PLANT = ASPLANTNOFROM
               AND LINE = ASLINEFROM
               AND CONFIGURATION = ANCONFIGURATIONFROM
               AND STAGE IN( SELECT STAGE
                              FROM PROCESS_LINE_STAGE
                             WHERE PLANT = ASPLANTNOTO
                               AND LINE = ASLINETO
                               AND CONFIGURATION = ANCONFIGURATIONTO );
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      FOR REC_SPECIFICATION_STAGE IN CUR_SPECIFICATION_STAGE
      LOOP
         BEGIN
            INSERT INTO SPECIFICATION_STAGE
                        ( PART_NO,
                          REVISION,
                          PLANT,
                          LINE,
                          CONFIGURATION,
                          PROCESS_LINE_REV,
                          STAGE,
                          SEQUENCE_NO,
                          RECIRCULATE_TO,
                          TEXT_TYPE,
                          DISPLAY_FORMAT,
                          DISPLAY_FORMAT_REV )
               SELECT PART_NO,
                      REVISION,
                      ASPLANTNOTO,
                      ASLINETO,
                      ANCONFIGURATIONTO,
                      0,
                      REC_SPECIFICATION_STAGE.STAGE,
                      REC_SPECIFICATION_STAGE.SEQUENCE_NO,
                      RECIRCULATE_TO,
                      TEXT_TYPE,
                      DISPLAY_FORMAT,
                      DISPLAY_FORMAT_REV
                 FROM SPECIFICATION_STAGE S
                WHERE S.PART_NO = ASPARTNO
                  AND S.REVISION = ANREVISION
                  AND S.PLANT = ASPLANTNOFROM
                  AND S.LINE = ASLINEFROM
                  AND S.CONFIGURATION = ANCONFIGURATIONFROM
                  AND S.PROCESS_LINE_REV = 0
                  AND S.STAGE = REC_SPECIFICATION_STAGE.STAGE;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      END LOOP;

      BEGIN
         INSERT INTO SPECIFICATION_LINE_TEXT
                     ( PART_NO,
                       REVISION,
                       PLANT,
                       LINE,
                       CONFIGURATION,
                       TEXT_TYPE,
                       STAGE,
                       TEXT,
                       LANG_ID )
            SELECT PART_NO,
                   REVISION,
                   ASPLANTNOTO,
                   ASLINETO,
                   ANCONFIGURATIONTO,
                   TEXT_TYPE,
                   STAGE,
                   LLTEXT,
                   LANG_ID
              FROM SPECIFICATION_LINE_TEXT
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND PLANT = ASPLANTNOFROM
               AND LINE = ASLINEFROM
               AND CONFIGURATION = ANCONFIGURATIONFROM
               AND STAGE IN( SELECT STAGE
                              FROM PROCESS_LINE_STAGE
                             WHERE PLANT = ASPLANTNOTO
                               AND LINE = ASLINETO
                               AND CONFIGURATION = ANCONFIGURATIONTO );
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
   END COPYDATA;

   
   FUNCTION SYNCHRONISEDATA(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      CURSOR L_DEL_LINE_CURSOR
      IS
         SELECT *
           FROM PROCESS_LINE
          WHERE STATUS <> 2
            AND ( PLANT, LINE, CONFIGURATION ) IN( SELECT PLANT,
                                                          LINE,
                                                          CONFIGURATION
                                                    FROM SPECIFICATION_LINE
                                                   WHERE PART_NO = ASPARTNO
                                                     AND REVISION = ANREVISION );

      CURSOR L_DEL_STAGES_CURSOR
      IS
         SELECT PLANT,
                LINE,
                CONFIGURATION,
                STAGE,
                SEQUENCE_NO,
                RECIRCULATE_TO,
                TEXT_TYPE
           FROM SPECIFICATION_STAGE
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
         MINUS
         SELECT PLANT,
                LINE,
                CONFIGURATION,
                STAGE,
                SEQUENCE_NO,
                RECIRCULATE_TO,
                TEXT_TYPE
           FROM PROCESS_LINE_STAGE
          WHERE ( PLANT, LINE, CONFIGURATION ) IN( SELECT PLANT,
                                                          LINE,
                                                          CONFIGURATION
                                                    FROM SPECIFICATION_LINE
                                                   WHERE PART_NO = ASPARTNO
                                                     AND REVISION = ANREVISION );

      CURSOR L_INS_STAGES_CURSOR
      IS
         SELECT PLANT,
                LINE,
                CONFIGURATION,
                STAGE,
                SEQUENCE_NO,
                RECIRCULATE_TO,
                TEXT_TYPE,
                DISPLAY_FORMAT
           FROM PROCESS_LINE_STAGE
          WHERE ( PLANT, LINE, CONFIGURATION, STAGE, SEQUENCE_NO, NVL( RECIRCULATE_TO,
                                                                       '-1' ), NVL( TEXT_TYPE,
                                                                                    '-1' ) ) IN(
                   SELECT PLANT,
                          LINE,
                          CONFIGURATION,
                          STAGE,
                          SEQUENCE_NO,
                          NVL( RECIRCULATE_TO,
                               '-1' ),
                          NVL( TEXT_TYPE,
                               '-1' )
                     FROM PROCESS_LINE_STAGE
                    WHERE ( PLANT, LINE, CONFIGURATION ) IN( SELECT PLANT,
                                                                    LINE,
                                                                    CONFIGURATION
                                                              FROM SPECIFICATION_LINE
                                                             WHERE PART_NO = ASPARTNO
                                                               AND REVISION = ANREVISION )
                   MINUS
                   SELECT PLANT,
                          LINE,
                          CONFIGURATION,
                          STAGE,
                          SEQUENCE_NO,
                          NVL( RECIRCULATE_TO,
                               '-1' ),
                          NVL( TEXT_TYPE,
                               '-1' )
                     FROM SPECIFICATION_STAGE
                    WHERE PART_NO = ASPARTNO
                      AND REVISION = ANREVISION );

      CURSOR L_UPD_STAGES_CURSOR
      IS
         SELECT PLANT,
                LINE,
                CONFIGURATION,
                STAGE,
                DISPLAY_FORMAT
           FROM PROCESS_LINE_STAGE
          WHERE ( PLANT, LINE, CONFIGURATION ) IN( SELECT PLANT,
                                                          LINE,
                                                          CONFIGURATION
                                                    FROM SPECIFICATION_LINE
                                                   WHERE PART_NO = ASPARTNO
                                                     AND REVISION = ANREVISION )
         MINUS
         SELECT PLANT,
                LINE,
                CONFIGURATION,
                STAGE,
                DISPLAY_FORMAT
           FROM SPECIFICATION_STAGE
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION;

      CURSOR L_SELECT_LINE_CURSOR
      IS
         SELECT *
           FROM PROCESS_LINE
          WHERE ( PLANT, LINE, CONFIGURATION ) IN( SELECT PLANT,
                                                          LINE,
                                                          CONFIGURATION
                                                    FROM SPECIFICATION_LINE
                                                   WHERE PART_NO = ASPARTNO
                                                     AND REVISION = ANREVISION );

      CURSOR L_UPD_PROP_CURSOR(
         ASPLANTNO                           PROCESS_LINE_STAGE.PLANT%TYPE,
         ASLINE                              PROCESS_LINE_STAGE.LINE%TYPE,
         ANCONFIGURATION                     PROCESS_LINE_STAGE.CONFIGURATION%TYPE )
      IS
         SELECT A.PLANT,
                A.LINE,
                A.CONFIGURATION,
                A.STAGE,
                B.PROPERTY,
                B.UOM_ID,
                B.ASSOCIATION
           FROM PROCESS_LINE_STAGE A,
                STAGE_LIST B
          WHERE A.PLANT = ASPLANTNO
            AND A.LINE = ASLINE
            AND A.CONFIGURATION = ANCONFIGURATION
            AND A.STAGE = B.STAGE
            AND B.MANDATORY = 'Y'
         MINUS
         SELECT PLANT,
                LINE,
                CONFIGURATION,
                STAGE,
                PROPERTY,
                UOM_ID,
                ASSOCIATION
           FROM SPECIFICATION_LINE_PROP
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PLANT = ASPLANTNO
            AND LINE = ASLINE
            AND CONFIGURATION = ANCONFIGURATION;

      CURSOR L_DEL_PROP_CURSOR(
         ASPLANTNO                           PROCESS_LINE_STAGE.PLANT%TYPE,
         ASLINE                              PROCESS_LINE_STAGE.LINE%TYPE,
         ANCONFIGURATION                     PROCESS_LINE_STAGE.CONFIGURATION%TYPE )
      IS
         SELECT PLANT,
                LINE,
                CONFIGURATION,
                STAGE,
                PROPERTY,
                UOM_ID,
                ASSOCIATION
           FROM SPECIFICATION_LINE_PROP
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PLANT = ASPLANTNO
            AND LINE = ASLINE
            AND CONFIGURATION = ANCONFIGURATION
            AND PROPERTY > 0
         MINUS
         SELECT A.PLANT,
                A.LINE,
                A.CONFIGURATION,
                A.STAGE,
                B.PROPERTY,
                B.UOM_ID,
                B.ASSOCIATION
           FROM PROCESS_LINE_STAGE A,
                STAGE_LIST B
          WHERE A.PLANT = ASPLANTNO
            AND A.LINE = ASLINE
            AND A.CONFIGURATION = ANCONFIGURATION
            AND A.STAGE = B.STAGE;

      CURSOR L_UPD_TEXT_CURSOR(
         ASPLANTNO                           PROCESS_LINE_STAGE.PLANT%TYPE,
         ASLINE                              PROCESS_LINE_STAGE.LINE%TYPE,
         ANCONFIGURATION                     PROCESS_LINE_STAGE.CONFIGURATION%TYPE )
      IS
         SELECT PLANT,
                LINE,
                CONFIGURATION,
                STAGE,
                TEXT_TYPE
           FROM PROCESS_LINE_STAGE
          WHERE PLANT = ASPLANTNO
            AND LINE = ASLINE
            AND CONFIGURATION = ANCONFIGURATION
         MINUS
         SELECT PLANT,
                LINE,
                CONFIGURATION,
                STAGE,
                TEXT_TYPE
           FROM SPECIFICATION_LINE_TEXT
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PLANT = ASPLANTNO
            AND LINE = ASLINE
            AND CONFIGURATION = ANCONFIGURATION;

      CURSOR L_DEL_TEXT_CURSOR(
         ASPLANTNO                           PROCESS_LINE_STAGE.PLANT%TYPE,
         ASLINE                              PROCESS_LINE_STAGE.LINE%TYPE,
         ANCONFIGURATION                     PROCESS_LINE_STAGE.CONFIGURATION%TYPE )
      IS
         SELECT PLANT,
                LINE,
                CONFIGURATION,
                STAGE,
                TEXT_TYPE
           FROM SPECIFICATION_LINE_TEXT
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PLANT = ASPLANTNO
            AND LINE = ASLINE
            AND CONFIGURATION = ANCONFIGURATION
         MINUS
         SELECT PLANT,
                LINE,
                CONFIGURATION,
                STAGE,
                TEXT_TYPE
           FROM PROCESS_LINE_STAGE
          WHERE PLANT = ASPLANTNO
            AND LINE = ASLINE
            AND CONFIGURATION = ANCONFIGURATION;

      CURSOR CUR_ST_REV
      IS
         SELECT DISTINCT STAGE
                    FROM SPECIFICATION_LINE_PROP
                   WHERE PART_NO = ASPARTNO
                     AND REVISION = ANREVISION;

      CURSOR CUR_SP_REV
      IS
         SELECT DISTINCT PROPERTY
                    FROM SPECIFICATION_LINE_PROP
                   WHERE PART_NO = ASPARTNO
                     AND REVISION = ANREVISION
                     AND PROPERTY <> -1;

      CURSOR CUR_AT_REV
      IS
         SELECT DISTINCT ATTRIBUTE
                    FROM SPECIFICATION_LINE_PROP
                   WHERE PART_NO = ASPARTNO
                     AND REVISION = ANREVISION;

      CURSOR CUR_TM_REV
      IS
         SELECT DISTINCT TEST_METHOD
                    FROM SPECIFICATION_LINE_PROP
                   WHERE PART_NO = ASPARTNO
                     AND REVISION = ANREVISION;

      CURSOR CUR_UM_REV
      IS
         SELECT DISTINCT UOM_ID
                    FROM SPECIFICATION_LINE_PROP
                   WHERE PART_NO = ASPARTNO
                     AND REVISION = ANREVISION;

      CURSOR CUR_AS_REV
      IS
         SELECT DISTINCT ASSOCIATION
                    FROM SPECIFICATION_LINE_PROP
                   WHERE PART_NO = ASPARTNO
                     AND REVISION = ANREVISION;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SynchroniseData';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQUENCENO                  IAPITYPE.NUMVAL_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;

      
      TYPE LSPEC_LINE_PROP_TAB_TYPE IS TABLE OF SPECIFICATION_LINE_PROP%ROWTYPE
         INDEX BY BINARY_INTEGER;

      LTTABSPECPROP                 LSPEC_LINE_PROP_TAB_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      BEGIN
         
         FOR REC_DEL IN L_DEL_LINE_CURSOR
         LOOP
            DELETE FROM SPECIFICATION_LINE
                  WHERE PLANT = REC_DEL.PLANT
                    AND LINE = REC_DEL.LINE
                    AND CONFIGURATION = REC_DEL.CONFIGURATION
                    AND PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM SPECIFICATION_STAGE
                  WHERE PLANT = REC_DEL.PLANT
                    AND LINE = REC_DEL.LINE
                    AND CONFIGURATION = REC_DEL.CONFIGURATION
                    AND PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM ITSHLNPROPLANG
                  WHERE PLANT = REC_DEL.PLANT
                    AND LINE = REC_DEL.LINE
                    AND CONFIGURATION = REC_DEL.CONFIGURATION
                    AND PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;


            SELECT *
            BULK COLLECT INTO LTTABSPECPROP
              FROM SPECIFICATION_LINE_PROP
             WHERE PLANT = REC_DEL.PLANT
               AND LINE = REC_DEL.LINE
               AND CONFIGURATION = REC_DEL.CONFIGURATION
               AND PART_NO = ASPARTNO
               AND REVISION = ANREVISION;

            FORALL INDX IN 1 .. LTTABSPECPROP.COUNT
               INSERT INTO TMP_SPECIFICATION_LINE_PROP
                    VALUES LTTABSPECPROP( INDX );


            DELETE FROM SPECIFICATION_LINE_PROP
                  WHERE PLANT = REC_DEL.PLANT
                    AND LINE = REC_DEL.LINE
                    AND CONFIGURATION = REC_DEL.CONFIGURATION
                    AND PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM SPECIFICATION_LINE_TEXT
                  WHERE PLANT = REC_DEL.PLANT
                    AND LINE = REC_DEL.LINE
                    AND CONFIGURATION = REC_DEL.CONFIGURATION
                    AND PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;
         END LOOP;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      BEGIN
         
         FOR REC_DEL IN L_DEL_STAGES_CURSOR
         LOOP
            BEGIN
               DELETE FROM SPECIFICATION_STAGE
                     WHERE PART_NO = ASPARTNO
                       AND REVISION = ANREVISION
                       AND PLANT = REC_DEL.PLANT
                       AND LINE = REC_DEL.LINE
                       AND CONFIGURATION = REC_DEL.CONFIGURATION
                       AND STAGE = REC_DEL.STAGE;
            EXCEPTION
               WHEN OTHERS
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        SQLERRM );
                  RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
            END;
         END LOOP;

         BEGIN
            
            DELETE FROM ITSHLNPROPLANG
                  WHERE ( PART_NO, REVISION, PLANT, LINE, CONFIGURATION, STAGE ) NOT IN(
                                                                                 SELECT DISTINCT PART_NO,
                                                                                                 REVISION,
                                                                                                 PLANT,
                                                                                                 LINE,
                                                                                                 CONFIGURATION,
                                                                                                 STAGE
                                                                                            FROM SPECIFICATION_STAGE )
                    AND PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;


            SELECT *
            BULK COLLECT INTO LTTABSPECPROP
              FROM SPECIFICATION_LINE_PROP
             WHERE ( PART_NO, REVISION, PLANT, LINE, CONFIGURATION, STAGE ) NOT IN(
                                                                                  SELECT DISTINCT PART_NO,
                                                                                                  REVISION,
                                                                                                  PLANT,
                                                                                                  LINE,
                                                                                                  CONFIGURATION,
                                                                                                  STAGE
                                                                                             FROM SPECIFICATION_STAGE )
               AND PART_NO = ASPARTNO
               AND REVISION = ANREVISION;

            FORALL INDX IN 1 .. LTTABSPECPROP.COUNT
               INSERT INTO TMP_SPECIFICATION_LINE_PROP
                    VALUES LTTABSPECPROP( INDX );


            DELETE FROM SPECIFICATION_LINE_PROP
                  WHERE ( PART_NO, REVISION, PLANT, LINE, CONFIGURATION, STAGE ) NOT IN(
                                                                                  SELECT DISTINCT PART_NO,
                                                                                                  REVISION,
                                                                                                  PLANT,
                                                                                                  LINE,
                                                                                                  CONFIGURATION,
                                                                                                  STAGE
                                                                                             FROM SPECIFICATION_STAGE )
                    AND PART_NO = ASPARTNO
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
            
            FOR REC_UPD IN L_UPD_STAGES_CURSOR
            LOOP
               UPDATEDISPLAY( ASPARTNO,
                              ANREVISION,
                              REC_UPD.DISPLAY_FORMAT,
                              REC_UPD.PLANT,
                              REC_UPD.LINE,
                              REC_UPD.CONFIGURATION,
                              0,
                              REC_UPD.STAGE );
            END LOOP;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;

         
         FOR REC_INS IN L_INS_STAGES_CURSOR
         LOOP
            
            INSERT INTO SPECIFICATION_STAGE
                        ( PART_NO,
                          REVISION,
                          PLANT,
                          LINE,
                          CONFIGURATION,
                          PROCESS_LINE_REV,
                          STAGE,
                          SEQUENCE_NO,
                          RECIRCULATE_TO,
                          TEXT_TYPE,
                          DISPLAY_FORMAT,
                          DISPLAY_FORMAT_REV )
                 VALUES ( ASPARTNO,
                          ANREVISION,
                          REC_INS.PLANT,
                          REC_INS.LINE,
                          REC_INS.CONFIGURATION,
                          0,
                          REC_INS.STAGE,
                          REC_INS.SEQUENCE_NO,
                          REC_INS.RECIRCULATE_TO,
                          REC_INS.TEXT_TYPE,
                          REC_INS.DISPLAY_FORMAT,
                          0 );
         END LOOP;

         FOR REC_LINE IN L_SELECT_LINE_CURSOR
         LOOP
            FOR REC_TEXT IN L_UPD_TEXT_CURSOR( REC_LINE.PLANT,
                                               REC_LINE.LINE,
                                               REC_LINE.CONFIGURATION )
            LOOP
               IF REC_TEXT.TEXT_TYPE IS NOT NULL
               THEN
                  INSERT INTO SPECIFICATION_LINE_TEXT
                              ( PART_NO,
                                REVISION,
                                PLANT,
                                LINE,
                                CONFIGURATION,
                                STAGE,
                                TEXT_TYPE,
                                LANG_ID )
                       VALUES ( ASPARTNO,
                                ANREVISION,
                                REC_TEXT.PLANT,
                                REC_TEXT.LINE,
                                REC_TEXT.CONFIGURATION,
                                REC_TEXT.STAGE,
                                REC_TEXT.TEXT_TYPE,
                                1 );
               END IF;
            END LOOP;

            LNSEQUENCENO := 0;

            FOR REC_STAGE IN L_DEL_PROP_CURSOR( REC_LINE.PLANT,
                                                REC_LINE.LINE,
                                                REC_LINE.CONFIGURATION )
            LOOP

               SELECT *
               BULK COLLECT INTO LTTABSPECPROP
                 FROM SPECIFICATION_LINE_PROP
                WHERE PART_NO = ASPARTNO
                  AND REVISION = ANREVISION
                  AND PLANT = REC_STAGE.PLANT
                  AND LINE = REC_STAGE.LINE
                  AND CONFIGURATION = REC_STAGE.CONFIGURATION
                  AND STAGE = REC_STAGE.STAGE
                  AND PROPERTY = REC_STAGE.PROPERTY;

               FORALL INDX IN 1 .. LTTABSPECPROP.COUNT
                  INSERT INTO TMP_SPECIFICATION_LINE_PROP
                       VALUES LTTABSPECPROP( INDX );


               DELETE FROM SPECIFICATION_LINE_PROP
                     WHERE PART_NO = ASPARTNO
                       AND REVISION = ANREVISION
                       AND PLANT = REC_STAGE.PLANT
                       AND LINE = REC_STAGE.LINE
                       AND CONFIGURATION = REC_STAGE.CONFIGURATION
                       AND STAGE = REC_STAGE.STAGE
                       AND PROPERTY = REC_STAGE.PROPERTY;
            END LOOP;

            FOR REC_STAGE IN L_UPD_PROP_CURSOR( REC_LINE.PLANT,
                                                REC_LINE.LINE,
                                                REC_LINE.CONFIGURATION )
            LOOP
               LNSEQUENCENO :=   LNSEQUENCENO
                               + 100;

               INSERT INTO SPECIFICATION_LINE_PROP
                           ( PART_NO,
                             REVISION,
                             SECTION_ID,
                             SECTION_REV,
                             SUB_SECTION_ID,
                             SUB_SECTION_REV,
                             PLANT,
                             LINE,
                             LINE_REV,
                             CONFIGURATION,
                             PROCESS_LINE_REV,
                             STAGE,
                             PROPERTY,
                             ATTRIBUTE,
                             UOM_ID,
                             SEQUENCE_NO,
                             ASSOCIATION,
                             INTL )
                    VALUES ( ASPARTNO,
                             ANREVISION,
                             0,
                             0,
                             0,
                             0,
                             REC_STAGE.PLANT,
                             REC_STAGE.LINE,
                             0,
                             REC_STAGE.CONFIGURATION,
                             0,
                             REC_STAGE.STAGE,
                             REC_STAGE.PROPERTY,
                             0,
                             REC_STAGE.UOM_ID,
                             LNSEQUENCENO,
                             REC_STAGE.ASSOCIATION,
                             '0' );
            END LOOP;

            FOR REC_STAGE IN L_DEL_TEXT_CURSOR( REC_LINE.PLANT,
                                                REC_LINE.LINE,
                                                REC_LINE.CONFIGURATION )
            LOOP
               DELETE FROM SPECIFICATION_LINE_TEXT
                     WHERE PART_NO = ASPARTNO
                       AND REVISION = ANREVISION
                       AND PLANT = REC_STAGE.PLANT
                       AND LINE = REC_STAGE.LINE
                       AND CONFIGURATION = REC_STAGE.CONFIGURATION
                       AND STAGE = REC_STAGE.STAGE
                       AND TEXT_TYPE = REC_STAGE.TEXT_TYPE;
            END LOOP;
         END LOOP;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      BEGIN
         UPDATE SPECIFICATION_STAGE A
            SET ( A.DISPLAY_FORMAT, A.DISPLAY_FORMAT_REV ) =
                   ( SELECT  B.DISPLAY_FORMAT,
                             MAX( C.REVISION )
                        FROM PROCESS_LINE_STAGE B,
                             LAYOUT C
                       WHERE B.PLANT = A.PLANT
                         AND B.LINE = A.LINE
                         AND B.CONFIGURATION = A.CONFIGURATION
                         AND B.STAGE = A.STAGE
                         AND B.DISPLAY_FORMAT = C.LAYOUT_ID
                         AND C.STATUS = 2
                    GROUP BY B.DISPLAY_FORMAT )
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
         FOR REC_REV IN CUR_ST_REV
         LOOP
            SELECT MAX( REVISION )
              INTO LNREVISION
              FROM STAGE_H
             WHERE STAGE = REC_REV.STAGE;

            




            UPDATE SPECIFICATION_LINE_PROP
               SET STAGE_REV = LNREVISION
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND STAGE = REC_REV.STAGE;
         END LOOP;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      BEGIN
         FOR REC_REV IN CUR_SP_REV
         LOOP
            LNREVISION := 0;

            IF REC_REV.PROPERTY <> 0
            THEN
               SELECT DISTINCT REVISION
                          INTO LNREVISION
                          FROM PROPERTY_H
                         WHERE PROPERTY = REC_REV.PROPERTY
                           AND MAX_REV = 1;
            END IF;

            UPDATE SPECIFICATION_LINE_PROP
               SET PROPERTY_REV = LNREVISION
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND PROPERTY = REC_REV.PROPERTY;
         END LOOP;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      BEGIN
         FOR REC_REV IN CUR_AT_REV
         LOOP
            SELECT DISTINCT REVISION
                       INTO LNREVISION
                       FROM ATTRIBUTE_H
                      WHERE ATTRIBUTE = REC_REV.ATTRIBUTE
                        AND MAX_REV = 1;

            UPDATE SPECIFICATION_LINE_PROP
               SET ATTRIBUTE_REV = LNREVISION
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND ATTRIBUTE = REC_REV.ATTRIBUTE;
         END LOOP;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      BEGIN
         FOR REC_REV IN CUR_TM_REV
         LOOP
            IF REC_REV.TEST_METHOD > 0
            THEN
               SELECT DISTINCT REVISION
                          INTO LNREVISION
                          FROM TEST_METHOD_H
                         WHERE TEST_METHOD = REC_REV.TEST_METHOD
                           AND MAX_REV = 1;

               UPDATE SPECIFICATION_LINE_PROP
                  SET TEST_METHOD_REV = LNREVISION
                WHERE PART_NO = ASPARTNO
                  AND REVISION = ANREVISION
                  AND UOM_ID = REC_REV.TEST_METHOD;
            END IF;
         END LOOP;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      BEGIN
         FOR REC_REV IN CUR_UM_REV
         LOOP
            IF REC_REV.UOM_ID > 0
            THEN
               SELECT DISTINCT REVISION
                          INTO LNREVISION
                          FROM UOM_H
                         WHERE UOM_ID = REC_REV.UOM_ID
                           AND MAX_REV = 1;

               UPDATE SPECIFICATION_LINE_PROP
                  SET UOM_REV = LNREVISION
                WHERE PART_NO = ASPARTNO
                  AND REVISION = ANREVISION
                  AND UOM_ID = REC_REV.UOM_ID;
            END IF;
         END LOOP;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      BEGIN
         FOR REC_REV IN CUR_AS_REV
         LOOP
            IF REC_REV.ASSOCIATION > 0
            THEN
               SELECT DISTINCT REVISION
                          INTO LNREVISION
                          FROM ASSOCIATION_H
                         WHERE ASSOCIATION = REC_REV.ASSOCIATION
                           AND MAX_REV = 1;

               UPDATE SPECIFICATION_LINE_PROP
                  SET ASSOCIATION_REV = LNREVISION
                WHERE PART_NO = ASPARTNO
                  AND REVISION = ANREVISION
                  AND ASSOCIATION = REC_REV.ASSOCIATION;
            END IF;
         END LOOP;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      




















      FOR REC IN ( SELECT PART_NO,
                          REVISION,
                          0 SECTION_ID,
                          SECTION_REV,
                          SUB_SECTION_ID,
                          SUB_SECTION_REV,
                          PLANT,
                          LINE,
                          LINE_REV,
                          CONFIGURATION,
                          PROCESS_LINE_REV,
                          STAGE,
                          STAGE_REV,
                          PROPERTY,
                          PROPERTY_REV,
                          ATTRIBUTE,
                          ATTRIBUTE_REV,
                          UOM_ID,
                          UOM_REV,
                          TEST_METHOD,
                          TEST_METHOD_REV,
                          SEQUENCE_NO,
                          VALUE_TYPE,
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
                          TEXT,
                          BOOLEAN_1,
                          BOOLEAN_2,
                          BOOLEAN_3,
                          BOOLEAN_4,
                          DATE_1,
                          DATE_2,
                          CHARACTERISTIC,
                          CHARACTERISTIC_REV,
                          ASSOCIATION,
                          ASSOCIATION_REV,
                          INTL,
                          COMPONENT_PART,
                          QUANTITY,
                          UOM,
                          ALTERNATIVE,
                          BOM_USAGE
                    FROM TMP_SPECIFICATION_LINE_PROP
                   WHERE PART_NO = ASPARTNO
                     AND REVISION = ANREVISION )
      LOOP
         UPDATE SPECIFICATION_LINE_PROP S
            SET S.NUM_1 = REC.NUM_1,   
                S.NUM_2 = REC.NUM_2,
                S.NUM_3 = REC.NUM_3,
                S.NUM_4 = REC.NUM_4,
                S.NUM_5 = REC.NUM_5,
                S.NUM_6 = REC.NUM_6,
                S.NUM_7 = REC.NUM_7,
                S.NUM_8 = REC.NUM_8,
                S.NUM_9 = REC.NUM_9,
                S.NUM_10 = REC.NUM_10,
                S.CHAR_1 = REC.CHAR_1,
                S.CHAR_2 = REC.CHAR_2,
                S.CHAR_3 = REC.CHAR_3,
                S.CHAR_4 = REC.CHAR_4,
                S.CHAR_5 = REC.CHAR_5,
                S.CHAR_6 = REC.CHAR_6,
                S.TEXT = REC.TEXT,
                S.BOOLEAN_1 = REC.BOOLEAN_1,
                S.BOOLEAN_2 = REC.BOOLEAN_2,
                S.BOOLEAN_3 = REC.BOOLEAN_3,
                S.BOOLEAN_4 = REC.BOOLEAN_4,
                S.DATE_1 = REC.DATE_1,
                S.DATE_2 = REC.DATE_2
          WHERE S.PART_NO = REC.PART_NO
            AND S.REVISION = REC.REVISION
            AND S.SECTION_ID = REC.SECTION_ID
            AND S.SUB_SECTION_ID = REC.SUB_SECTION_ID
            AND S.PLANT = REC.PLANT
            AND S.LINE = REC.LINE
            AND S.CONFIGURATION = REC.CONFIGURATION
            AND S.PROCESS_LINE_REV = REC.PROCESS_LINE_REV
            AND S.STAGE = REC.STAGE
            AND S.PROPERTY = REC.PROPERTY
            AND S.ATTRIBUTE = REC.ATTRIBUTE;
      

      
      
      END LOOP;


      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SYNCHRONISEDATA;

   
   FUNCTION UPDATEDATA(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'UpdateData';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSEQUENCENO                  IAPITYPE.NUMVAL_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LSFRAMENO                     IAPITYPE.FRAMENO_TYPE;
      LNFRAMEREVISION               IAPITYPE.FRAMEREVISION_TYPE;
      LNFRAMEOWNER                  IAPITYPE.OWNER_TYPE;
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE := 0;
      LSMANDATORY                   IAPITYPE.MANDATORY_TYPE;
      LSINTERNATIONAL               IAPITYPE.INTL_TYPE := '0';
      LNSTAGE                       IAPITYPE.STAGEID_TYPE;

      CURSOR L_LINE_CURSOR
      IS
         SELECT PART_NO,
                REVISION,
                PLANT,
                LINE,
                CONFIGURATION,
                PROCESS_LINE_REV
           FROM SPECIFICATION_LINE
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
         MINUS
         SELECT DISTINCT PART_NO,
                         REVISION,
                         PLANT,
                         LINE,
                         CONFIGURATION,
                         PROCESS_LINE_REV
                    FROM SPECIFICATION_STAGE
                   WHERE PART_NO = ASPARTNO
                     AND REVISION = ANREVISION;

      CURSOR L_STAGE_CURSOR(
         ASPLANTNO                           IAPITYPE.PLANTNO_TYPE,
         ASLINE                              IAPITYPE.LINE_TYPE,
         ANCONFIGURATION                     IAPITYPE.CONFIGURATION_TYPE )
      IS
         SELECT   A.PLANT,
                  A.LINE,
                  A.CONFIGURATION,
                  A.STAGE,
                  B.PROPERTY,
                  C.REVISION SP_REV,
                  B.UOM_ID,
                  D.REVISION UOM_REV,
                  B.ASSOCIATION,
                  E.REVISION AS_REV
             FROM PROCESS_LINE_STAGE A,
                  STAGE_LIST B,
                  PROPERTY_H C,
                  UOM_H D,
                  ASSOCIATION_H E
            WHERE A.PLANT = ASPLANTNO
              AND A.LINE = ASLINE
              AND A.CONFIGURATION = ANCONFIGURATION
              AND A.STAGE = B.STAGE
              AND B.MANDATORY = 'Y'
              AND C.PROPERTY = B.PROPERTY
              AND C.MAX_REV = 1
              AND D.UOM_ID = B.UOM_ID
              AND D.MAX_REV = 1
              AND E.ASSOCIATION = B.ASSOCIATION
              AND E.MAX_REV = 1
              AND C.LANG_ID = 1
              AND D.LANG_ID = 1
              AND E.LANG_ID = 1
         ORDER BY A.PLANT,
                  A.LINE,
                  A.CONFIGURATION,
                  
                  
                  
                  A.STAGE,
                  C.DESCRIPTION;
                  
                  
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      BEGIN
         
         DELETE FROM SPECIFICATION_STAGE
               WHERE ( PART_NO, REVISION, PLANT, LINE, CONFIGURATION, PROCESS_LINE_REV ) NOT IN(
                                                                      SELECT DISTINCT PART_NO,
                                                                                      REVISION,
                                                                                      PLANT,
                                                                                      LINE,
                                                                                      CONFIGURATION,
                                                                                      PROCESS_LINE_REV
                                                                                 FROM SPECIFICATION_LINE
                                                                                WHERE PART_NO = ASPARTNO
                                                                                  AND REVISION = ANREVISION )
                 AND PART_NO = ASPARTNO
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
         
         DELETE FROM ITSHLNPROPLANG
               WHERE ( PART_NO, REVISION, PLANT, LINE, CONFIGURATION, STAGE ) NOT IN(
                                                                                 SELECT DISTINCT PART_NO,
                                                                                                 REVISION,
                                                                                                 PLANT,
                                                                                                 LINE,
                                                                                                 CONFIGURATION,
                                                                                                 STAGE
                                                                                            FROM SPECIFICATION_STAGE
                                                                                           WHERE PART_NO = ASPARTNO
                                                                                             AND REVISION = ANREVISION )
                 AND PART_NO = ASPARTNO
                 AND REVISION = ANREVISION;

         DELETE FROM SPECIFICATION_LINE_PROP
               WHERE ( PART_NO, REVISION, PLANT, LINE, CONFIGURATION, PROCESS_LINE_REV, STAGE ) NOT IN(
                                                                SELECT DISTINCT PART_NO,
                                                                                REVISION,
                                                                                PLANT,
                                                                                LINE,
                                                                                CONFIGURATION,
                                                                                PROCESS_LINE_REV,
                                                                                STAGE
                                                                           FROM SPECIFICATION_STAGE
                                                                          WHERE PART_NO = ASPARTNO
                                                                            AND REVISION = ANREVISION )
                 AND PART_NO = ASPARTNO
                 AND REVISION = ANREVISION;

         DELETE FROM SPECIFICATION_LINE_TEXT
               WHERE ( PART_NO, REVISION, PLANT, LINE, CONFIGURATION, TEXT_TYPE, LANG_ID ) NOT IN(
                                                                     SELECT DISTINCT PART_NO,
                                                                                     REVISION,
                                                                                     PLANT,
                                                                                     LINE,
                                                                                     CONFIGURATION,
                                                                                     TEXT_TYPE,
                                                                                     LANG_ID
                                                                                FROM SPECIFICATION_STAGE
                                                                               WHERE PART_NO = ASPARTNO
                                                                                 AND REVISION = ANREVISION )
                 AND PART_NO = ASPARTNO
                 AND REVISION = ANREVISION;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      FOR REC_LINE IN L_LINE_CURSOR
      LOOP
         INSERT INTO SPECIFICATION_STAGE
                     ( PART_NO,
                       REVISION,
                       PLANT,
                       LINE,
                       CONFIGURATION,
                       PROCESS_LINE_REV,
                       STAGE,
                       SEQUENCE_NO,
                       RECIRCULATE_TO,
                       TEXT_TYPE,
                       DISPLAY_FORMAT,
                       DISPLAY_FORMAT_REV )
            SELECT   ASPARTNO,
                     ANREVISION,
                     A.PLANT,
                     A.LINE,
                     A.CONFIGURATION,
                     0,
                     A.STAGE,
                     A.SEQUENCE_NO,
                     A.RECIRCULATE_TO,
                     A.TEXT_TYPE,
                     A.DISPLAY_FORMAT,
                     MAX( B.REVISION )
                FROM PROCESS_LINE_STAGE A,
                     LAYOUT B
               WHERE PLANT = REC_LINE.PLANT
                 AND LINE = REC_LINE.LINE
                 AND CONFIGURATION = REC_LINE.CONFIGURATION
                 AND A.DISPLAY_FORMAT = B.LAYOUT_ID
                 AND B.STATUS = 2
            GROUP BY A.PLANT,
                     A.LINE,
                     A.CONFIGURATION,
                     A.STAGE,
                     A.SEQUENCE_NO,
                     A.RECIRCULATE_TO,
                     A.TEXT_TYPE,
                     A.DISPLAY_FORMAT;

         INSERT INTO SPECIFICATION_LINE_TEXT
                     ( PART_NO,
                       REVISION,
                       PLANT,
                       LINE,
                       CONFIGURATION,
                       STAGE,
                       TEXT_TYPE,
                       LANG_ID )
            SELECT ASPARTNO,
                   ANREVISION,
                   PLANT,
                   LINE,
                   CONFIGURATION,
                   STAGE,
                   TEXT_TYPE,
                   1
              FROM PROCESS_LINE_STAGE
             WHERE PLANT = REC_LINE.PLANT
               AND LINE = REC_LINE.LINE
               AND CONFIGURATION = REC_LINE.CONFIGURATION
               AND TEXT_TYPE IS NOT NULL;

         LNSTAGE := NULL;

         SELECT COUNT( * )
           INTO LNCOUNT
           FROM SPECIFICATION_SECTION
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND TYPE = IAPICONSTANT.SECTIONTYPE_PROCESSDATA;

         IF LNCOUNT > 0
         THEN
            
            SELECT SECTION_ID,
                   SUB_SECTION_ID
              INTO LNSECTIONID,
                   LNSUBSECTIONID
              FROM SPECIFICATION_SECTION
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND TYPE = IAPICONSTANT.SECTIONTYPE_PROCESSDATA;
         END IF;

         IF IAPIGENERAL.SESSION.SETTINGS.INTERNATIONAL = TRUE
         THEN
            LSINTERNATIONAL := '1';
         ELSE
            LSINTERNATIONAL := '0';
         END IF;

         FOR REC_STAGE IN L_STAGE_CURSOR( REC_LINE.PLANT,
                                          REC_LINE.LINE,
                                          REC_LINE.CONFIGURATION )
         LOOP
            IF    LNSTAGE IS NULL
               OR LNSTAGE <> REC_STAGE.STAGE
            THEN
               LNSEQUENCENO := 0;
               LNSTAGE := REC_STAGE.STAGE;
            END IF;

            LNSEQUENCENO :=   LNSEQUENCENO
                            + 10;

            
            INSERT INTO SPECIFICATION_LINE_PROP
                        ( PART_NO,
                          REVISION,
                          SECTION_ID,
                          SECTION_REV,
                          SUB_SECTION_ID,
                          SUB_SECTION_REV,
                          PLANT,
                          LINE,
                          LINE_REV,
                          CONFIGURATION,
                          PROCESS_LINE_REV,
                          STAGE,
                          PROPERTY,
                          PROPERTY_REV,
                          ATTRIBUTE,
                          ATTRIBUTE_REV,
                          UOM_ID,
                          UOM_REV,
                          SEQUENCE_NO,
                          ASSOCIATION,
                          ASSOCIATION_REV,
                          INTL )
                 VALUES ( ASPARTNO,
                          ANREVISION,
                          LNSECTIONID,
                          0,
                          LNSUBSECTIONID,
                          0,
                          REC_LINE.PLANT,
                          REC_LINE.LINE,
                          0,
                          REC_LINE.CONFIGURATION,
                          0,
                          REC_STAGE.STAGE,
                          REC_STAGE.PROPERTY,
                          REC_STAGE.SP_REV,
                          0,
                          0,
                          REC_STAGE.UOM_ID,
                          REC_STAGE.UOM_REV,
                          LNSEQUENCENO,
                          REC_STAGE.ASSOCIATION,
                          REC_STAGE.AS_REV,
                          LSINTERNATIONAL );
         END LOOP;
      END LOOP;

      
      BEGIN
         
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM SPECIFICATION_STAGE
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION;

         IF LNCOUNT = 0
         THEN
            
            SELECT SECTION_ID,
                   SUB_SECTION_ID,
                   MANDATORY
              INTO LNSECTIONID,
                   LNSUBSECTIONID,
                   LSMANDATORY
              FROM SPECIFICATION_SECTION
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND TYPE = IAPICONSTANT.SECTIONTYPE_PROCESSDATA;

            IF LSMANDATORY = 'N'
            THEN
               LNRETVAL :=
                  IAPISPECIFICATIONSECTION.EDITSECTION( ASPARTNO,
                                                        ANREVISION,
                                                        NULL,
                                                        NULL,
                                                        NULL,
                                                        LNSECTIONID,
                                                        LNSUBSECTIONID,
                                                        IAPICONSTANT.SECTIONTYPE_PROCESSDATA,
                                                        0,
                                                        'rem' );

               IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
               THEN
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                       IAPIGENERAL.GETLASTERRORTEXT( ) );
                  RETURN( LNRETVAL );
               END IF;
            END IF;
         ELSE
            
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM SPECIFICATION_SECTION
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND TYPE = IAPICONSTANT.SECTIONTYPE_PROCESSDATA;

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

               SELECT SECTION_ID,
                      SUB_SECTION_ID,
                      MANDATORY
                 INTO LNSECTIONID,
                      LNSUBSECTIONID,
                      LSMANDATORY
                 FROM FRAME_SECTION
                WHERE FRAME_NO = LSFRAMENO
                  AND REVISION = LNFRAMEREVISION
                  AND OWNER = LNFRAMEOWNER
                  AND TYPE = IAPICONSTANT.SECTIONTYPE_PROCESSDATA;

               LNRETVAL :=
                  IAPISPECIFICATIONSECTION.EDITSECTION( ASPARTNO,
                                                        ANREVISION,
                                                        LSFRAMENO,
                                                        LNFRAMEREVISION,
                                                        LNFRAMEOWNER,
                                                        LNSECTIONID,
                                                        LNSUBSECTIONID,
                                                        IAPICONSTANT.SECTIONTYPE_PROCESSDATA,
                                                        0,
                                                        'add' );

               IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
               THEN
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                       IAPIGENERAL.GETLASTERRORTEXT( ) );
                  RETURN( LNRETVAL );
               END IF;
            END IF;
         END IF;
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
   END UPDATEDATA;
END IAPISPECIFICATIONPROCESSDATA;
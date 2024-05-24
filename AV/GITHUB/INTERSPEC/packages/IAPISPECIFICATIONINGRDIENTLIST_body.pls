CREATE OR REPLACE PACKAGE BODY iapiSpecificationIngrdientList
AS
   
   
   
   
   
   
   
   
   
   
   
   
   
   

   
   FUNCTION GETPACKAGEVERSION
      RETURN IAPITYPE.STRING_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPackageVersion';
   BEGIN
      
      
      
        RETURN(    IAPIGENERAL.GETVERSION
              || ' ($Revision: 6.7.0.14 (06.07.00.14-00.00) $)' );

   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   END GETPACKAGEVERSION;

   
   
   

   
   
   
   

   PROCEDURE CHECKBASICALLERGENPARAMS(
      ARALLERGEN                 IN       IAPITYPE.SPINGREDIENTALLERGENREC_TYPE )
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckBasicAllergenParams';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESSLEVEL                 IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ARALLERGEN.PARTNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PartNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartNo',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARALLERGEN.REVISION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Revision' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRevision',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARALLERGEN.SECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SectionId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSectionId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARALLERGEN.SUBSECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SubSectionId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSubSectionId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARALLERGEN.INGREDIENTID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'IngredientId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'IngredientId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARALLERGEN.ALLERGENID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'AllergenID' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'AllergenID',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;
      
      LNACCESSLEVEL := 1;

      IF F_CHECK_ITEM_ACCESS( ARALLERGEN.PARTNO,
                              ARALLERGEN.REVISION,
                              ARALLERGEN.SECTIONID,
                              ARALLERGEN.SUBSECTIONID,
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
                                                ARALLERGEN.PARTNO,
                                                ARALLERGEN.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARALLERGEN.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARALLERGEN.SUBSECTIONID,
                                                             0 ),
                                                'ALLERGEN' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No Edit Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 0;

      IF F_CHECK_ITEM_ACCESS( ARALLERGEN.PARTNO,
                              ARALLERGEN.REVISION,
                              ARALLERGEN.SECTIONID,
                              ARALLERGEN.SUBSECTIONID,
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
                                                ARALLERGEN.PARTNO,
                                                ARALLERGEN.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARALLERGEN.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARALLERGEN.SUBSECTIONID,
                                                             0 ),
                                                'ALLERGEN' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No View Section Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 2;

      IF F_CHECK_ITEM_ACCESS( ARALLERGEN.PARTNO,
                              ARALLERGEN.REVISION,
                              ARALLERGEN.SECTIONID,
                              ARALLERGEN.SUBSECTIONID,
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
                                                ARALLERGEN.PARTNO,
                                                ARALLERGEN.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARALLERGEN.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARALLERGEN.SUBSECTIONID,
                                                             0 ),
                                                'ALLERGEN' );
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
   END CHECKBASICALLERGENPARAMS;

   PROCEDURE CHECKBASICCHARPARAMS(
      ARCHARACTERISTIC               IN       IAPITYPE.SPINGCHARREC_TYPE )
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckBasicCharParams';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESSLEVEL                 IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ARCHARACTERISTIC.PARTNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PartNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartNo',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARCHARACTERISTIC.REVISION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Revision' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRevision',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARCHARACTERISTIC.SECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SectionId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSectionId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARCHARACTERISTIC.SUBSECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SubSectionId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSubSectionId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARCHARACTERISTIC.INGREDIENT IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'IngredientId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'IngredientId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;
			
      
      IF ( ARCHARACTERISTIC.INGREDIENTSEQNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'IngredientSeqNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'IngredientSeqNo',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;
			
      
      IF ( ARCHARACTERISTIC.INGDETAILTYPE IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'IngDetailType' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'IngDetailType',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARCHARACTERISTIC.CHARACTERISTICID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'CharacteristicID' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'CharacteristicID',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARCHARACTERISTIC.MANDATORY IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Mandatory' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'Mandatory',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 1;

      IF F_CHECK_ITEM_ACCESS( ARCHARACTERISTIC.PARTNO,
                              ARCHARACTERISTIC.REVISION,
                              ARCHARACTERISTIC.SECTIONID,
                              ARCHARACTERISTIC.SUBSECTIONID,
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
                                                ARCHARACTERISTIC.PARTNO,
                                                ARCHARACTERISTIC.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARCHARACTERISTIC.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARCHARACTERISTIC.SUBSECTIONID,
                                                             0 ),
                                                'Characteristic' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No Edit Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 0;

      IF F_CHECK_ITEM_ACCESS( ARCHARACTERISTIC.PARTNO,
                              ARCHARACTERISTIC.REVISION,
                              ARCHARACTERISTIC.SECTIONID,
                              ARCHARACTERISTIC.SUBSECTIONID,
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
                                                ARCHARACTERISTIC.PARTNO,
                                                ARCHARACTERISTIC.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARCHARACTERISTIC.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARCHARACTERISTIC.SUBSECTIONID,
                                                             0 ),
                                                'Characteristic' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No View Section Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 2;

      IF F_CHECK_ITEM_ACCESS( ARCHARACTERISTIC.PARTNO,
                              ARCHARACTERISTIC.REVISION,
                              ARCHARACTERISTIC.SECTIONID,
                              ARCHARACTERISTIC.SUBSECTIONID,
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
                                                ARCHARACTERISTIC.PARTNO,
                                                ARCHARACTERISTIC.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARCHARACTERISTIC.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARCHARACTERISTIC.SUBSECTIONID,
                                                             0 ),
                                                'Characteristic' );
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
   END CHECKBASICCHARPARAMS;





   PROCEDURE CHECKBASICINGRLISTPARAMS(
      ARINGREDIENTLIST           IN       IAPITYPE.SPINGREDIENTLISTREC_TYPE )
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckBasicIngrListParams';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESSLEVEL                 IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ARINGREDIENTLIST.PARTNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PartNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartNo',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARINGREDIENTLIST.REVISION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Revision' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRevision',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARINGREDIENTLIST.SECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SectionId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSectionId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARINGREDIENTLIST.SUBSECTIONID IS NULL )
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

      IF F_CHECK_ITEM_ACCESS( ARINGREDIENTLIST.PARTNO,
                              ARINGREDIENTLIST.REVISION,
                              ARINGREDIENTLIST.SECTIONID,
                              ARINGREDIENTLIST.SUBSECTIONID,
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
                                                ARINGREDIENTLIST.PARTNO,
                                                ARINGREDIENTLIST.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARINGREDIENTLIST.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARINGREDIENTLIST.SUBSECTIONID,
                                                             0 ),
                                                'INGREDIENT LIST ITEM' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No Edit Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 0;

      IF F_CHECK_ITEM_ACCESS( ARINGREDIENTLIST.PARTNO,
                              ARINGREDIENTLIST.REVISION,
                              ARINGREDIENTLIST.SECTIONID,
                              ARINGREDIENTLIST.SUBSECTIONID,
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
                                                ARINGREDIENTLIST.PARTNO,
                                                ARINGREDIENTLIST.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARINGREDIENTLIST.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARINGREDIENTLIST.SUBSECTIONID,
                                                             0 ),
                                                'INGREDIENT LIST ITEM' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No View Section Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 2;

      IF F_CHECK_ITEM_ACCESS( ARINGREDIENTLIST.PARTNO,
                              ARINGREDIENTLIST.REVISION,
                              ARINGREDIENTLIST.SECTIONID,
                              ARINGREDIENTLIST.SUBSECTIONID,
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
                                                ARINGREDIENTLIST.PARTNO,
                                                ARINGREDIENTLIST.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARINGREDIENTLIST.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARINGREDIENTLIST.SUBSECTIONID,
                                                             0 ),
                                                'INGREDIENT LIST ITEM' );
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
   END CHECKBASICINGRLISTPARAMS;

   
   PROCEDURE CHECKBASICINGRLISTITEMPARAMS(
      ARINGREDIENTLISTITEM       IN       IAPITYPE.SPINGREDIENTLISTITEMREC_TYPE )
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckBasicIngredientListParams';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRINGREDIENTLIST              IAPITYPE.SPINGREDIENTLISTREC_TYPE;
   BEGIN
      LRINGREDIENTLIST.PARTNO := ARINGREDIENTLISTITEM.PARTNO;
      LRINGREDIENTLIST.REVISION := ARINGREDIENTLISTITEM.REVISION;
      LRINGREDIENTLIST.SECTIONID := ARINGREDIENTLISTITEM.SECTIONID;
      LRINGREDIENTLIST.SUBSECTIONID := ARINGREDIENTLISTITEM.SUBSECTIONID;
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      
      CHECKBASICINGRLISTPARAMS( LRINGREDIENTLIST );

      
      IF ( ARINGREDIENTLISTITEM.INGREDIENTID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'IngredientId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anIngredientId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARINGREDIENTLISTITEM.SEQUENCE IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SequenceNumber' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSequenceNumber',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
   END CHECKBASICINGRLISTITEMPARAMS;

   
   PROCEDURE CHECKBASICCHEMLISTITEMPARAMS(
      ARCHEMICALLISTITEM         IN       IAPITYPE.SPCHEMICALLISTITEMREC_TYPE )
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckBasicChemicalListItemParams';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESSLEVEL                 IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNACCESSLEVEL := 1;

      IF F_CHECK_ITEM_ACCESS( ARCHEMICALLISTITEM.PARTNO,
                              ARCHEMICALLISTITEM.REVISION,
                              ARCHEMICALLISTITEM.SECTIONID,
                              ARCHEMICALLISTITEM.SUBSECTIONID,
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
                                                ARCHEMICALLISTITEM.PARTNO,
                                                ARCHEMICALLISTITEM.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARCHEMICALLISTITEM.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARCHEMICALLISTITEM.SUBSECTIONID,
                                                             0 ),
                                                'CHEMICAL LIST ITEM' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No Edit Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 0;

      IF F_CHECK_ITEM_ACCESS( ARCHEMICALLISTITEM.PARTNO,
                              ARCHEMICALLISTITEM.REVISION,
                              ARCHEMICALLISTITEM.SECTIONID,
                              ARCHEMICALLISTITEM.SUBSECTIONID,
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
                                                ARCHEMICALLISTITEM.PARTNO,
                                                ARCHEMICALLISTITEM.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARCHEMICALLISTITEM.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARCHEMICALLISTITEM.SUBSECTIONID,
                                                             0 ),
                                                'CHEMICAL LIST ITEM' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No View Section Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 2;

      IF F_CHECK_ITEM_ACCESS( ARCHEMICALLISTITEM.PARTNO,
                              ARCHEMICALLISTITEM.REVISION,
                              ARCHEMICALLISTITEM.SECTIONID,
                              ARCHEMICALLISTITEM.SUBSECTIONID,
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
                                                ARCHEMICALLISTITEM.PARTNO,
                                                ARCHEMICALLISTITEM.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARCHEMICALLISTITEM.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARCHEMICALLISTITEM.SUBSECTIONID,
                                                             0 ),
                                                'CHEMICAL LIST ITEM' );
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
   END CHECKBASICCHEMLISTITEMPARAMS;

   
   FUNCTION EXISTITEMINLIST(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANINGREDIENTID             IN       IAPITYPE.ID_TYPE,
      ANSEQUENCENUMBER           IN       IAPITYPE.INGREDIENTSEQUENCENUMBER_TYPE )
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
                 FROM SPECIFICATION_ING
                WHERE PART_NO = ASPARTNO
                  AND REVISION = ANREVISION
                  AND SECTION_ID = ANSECTIONID
                  AND SUB_SECTION_ID = ANSUBSECTIONID
                  AND INGREDIENT = ANINGREDIENTID
                  AND SEQ_NO = ANSEQUENCENUMBER;

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
                                                     
                                                     ANINGREDIENTID ) );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTITEMINLIST;

   
   FUNCTION GETPIDLIST(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANSEQUENCE                 IN       IAPITYPE.SEQUENCE_TYPE )
      RETURN VARCHAR2
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPidList';
      LSPIDLIST                     VARCHAR2( 2048 ) := NULL;
      LNLASTLEVEL                   NUMBER := -1;

      CURSOR LQTREE(
         ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
         ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
         ANSECTIONID                IN       IAPITYPE.ID_TYPE,
         ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
         ANSEQUENCE                 IN       IAPITYPE.SEQUENCE_TYPE )
      IS
         SELECT   *
             FROM SPECIFICATION_ING I
            WHERE I.PART_NO = ASPARTNO
              AND I.REVISION = ANREVISION
              AND I.SECTION_ID = ANSECTIONID
              AND I.SUB_SECTION_ID = ANSUBSECTIONID
              AND I.SEQ_NO <= ANSEQUENCE
         ORDER BY I.SEQ_NO DESC;
   BEGIN
      FOR RINGREDIENT IN LQTREE( ASPARTNO,
                                 ANREVISION,
                                 ANSECTIONID,
                                 ANSUBSECTIONID,
                                 ANSEQUENCE )
      LOOP
         IF ( RINGREDIENT.HIER_LEVEL = 1 )
         THEN
            IF ( LSPIDLIST IS NULL )
            THEN
               LSPIDLIST :=    RINGREDIENT.INGREDIENT
                            || '|'
                            || RINGREDIENT.PID;
            ELSE
               LSPIDLIST :=    LSPIDLIST
                            || '|'
                            || RINGREDIENT.PID;
            END IF;

            EXIT;
         ELSE
            IF (     ( RINGREDIENT.HIER_LEVEL < LNLASTLEVEL )
                 OR ( LNLASTLEVEL = -1 ) )
            THEN
               LNLASTLEVEL := RINGREDIENT.HIER_LEVEL;

               IF ( LSPIDLIST IS NULL )
               THEN
                  LSPIDLIST :=    RINGREDIENT.INGREDIENT
                               || '|'
                               || RINGREDIENT.PID;
               ELSE
                  LSPIDLIST :=    LSPIDLIST
                               || '|'
                               || RINGREDIENT.PID;
               END IF;
            END IF;
         END IF;
      END LOOP;

      RETURN LSPIDLIST;
   END;
   

   
   
   
   
   FUNCTION ADDLIST(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ASMETHOD                   IN       IAPITYPE.METHOD_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddList';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRINGREDIENTLIST              IAPITYPE.SPINGREDIENTLISTREC_TYPE;
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
      GTINGREDIENTLISTS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRINGREDIENTLIST.PARTNO := ASPARTNO;
      LRINGREDIENTLIST.REVISION := ANREVISION;
      LRINGREDIENTLIST.SECTIONID := ANSECTIONID;
      LRINGREDIENTLIST.SUBSECTIONID := ANSUBSECTIONID;
      LRINGREDIENTLIST.ITEMID := 0;   
      GTINGREDIENTLISTS( 0 ) := LRINGREDIENTLIST;

      GTINFO( 0 ) := LRINFO;
      
        
        
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Pre-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     ASMETHOD,
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
            IAPIGENERAL.LOGINFO( GSSOURCE,
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
      
      
      
      
      
      
      CHECKBASICINGRLISTPARAMS( LRINGREDIENTLIST );

      
      
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
         IAPISPECIFICATIONSECTION.ADDSECTIONITEM( LRINGREDIENTLIST.PARTNO,
                                                  LRINGREDIENTLIST.REVISION,
                                                  LRINGREDIENTLIST.SECTIONID,
                                                  LRINGREDIENTLIST.SUBSECTIONID,
                                                  IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST,
                                                  LRINGREDIENTLIST.ITEMID,
                                                  AFHANDLE => AFHANDLE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.ISACTIONALLOWED( LRINGREDIENTLIST.PARTNO,
                                                   LRINGREDIENTLIST.REVISION,
                                                   LRINGREDIENTLIST.SECTIONID,
                                                   LRINGREDIENTLIST.SUBSECTIONID,
                                                   IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST,
                                                   LRINGREDIENTLIST.ITEMID,
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
                                                     LRINGREDIENTLIST.ITEMID,
                                                     IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST,
                                                     LRINGREDIENTLIST.PARTNO,
                                                     LRINGREDIENTLIST.REVISION,
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRINGREDIENTLIST.SECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRINGREDIENTLIST.SUBSECTIONID, 0) ));
                                                     
      END IF;

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.LOGHISTORY( LRINGREDIENTLIST.PARTNO,
                                              LRINGREDIENTLIST.REVISION,
                                              LRINGREDIENTLIST.SECTIONID,
                                              LRINGREDIENTLIST.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRINGREDIENTLIST.PARTNO,
                                                LRINGREDIENTLIST.REVISION );

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

      GTINFO.DELETE;
      GTINFO( 0 ) := LRINFO;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Post-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     ASMETHOD,
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
            IAPIGENERAL.LOGINFO( GSSOURCE,
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
   END ADDLIST;



   
   FUNCTION ADJUSTPNCLAIMPROPERTYPRESDEF(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANINGREDIENTID             IN       IAPITYPE.ID_TYPE
      )

      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      


      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AdjustPNClaimPropertyPresDEF';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;

   CURSOR C_INGALLERGENS( LCINGREDIENT IN  ITINGALLERGEN.INGREDIENT%TYPE)
   IS
    SELECT ALLERGEN
    FROM ITINGALLERGEN
    WHERE INGREDIENT = LCINGREDIENT
    AND STATUS = 0;


   CURSOR C_PROPS (LCALLERGEN IN ITINGALLERGEN.ALLERGEN%TYPE)
   IS
    SELECT PROPERTY
    FROM ITPROPALLERGEN
    WHERE ALLERGEN = LCALLERGEN
    AND STATUS = 0;

   
   CURSOR C_CLAIMPROPS ( LCPARTNO   IN  ITSPECINGALLERGEN.PART_NO%TYPE,
                         LCREVISION IN  ITSPECINGALLERGEN.REVISION%TYPE,
                         LCPROPERTY IN  ITPROPALLERGEN.PROPERTY%TYPE,
                         LCCLAIMTYPE IN PROPERTY_GROUP.PG_TYPE%TYPE)
   IS
    SELECT SP.PART_NO, SP.REVISION, SP.SECTION_ID, SP.SUB_SECTION_ID, SP.PROPERTY_GROUP, SP.PROPERTY, SP.ATTRIBUTE
    FROM SPECIFICATION_PROP SP, PROPERTY_GROUP PG
    WHERE SP.PROPERTY_GROUP = PG.PROPERTY_GROUP
    AND PART_NO = LCPARTNO
    AND REVISION = LCREVISION
    AND PG_TYPE = LCCLAIMTYPE
    AND PROPERTY = LCPROPERTY;

   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR LRALLERGEN IN C_INGALLERGENS( ANINGREDIENTID)
      LOOP
          
          FOR LRPROPS IN C_PROPS( LRALLERGEN.ALLERGEN )
          LOOP

              
              FOR LRCLAIMPROPS IN C_CLAIMPROPS(ASPARTNO, ANREVISION, LRPROPS.PROPERTY, 3)
              LOOP
                UPDATE SPECIFICATION_PROP
                SET BOOLEAN_1 = 'N' 
                WHERE PART_NO = LRCLAIMPROPS.PART_NO
                AND REVISION = LRCLAIMPROPS.REVISION
                AND SECTION_ID = LRCLAIMPROPS.SECTION_ID
                AND SUB_SECTION_ID = LRCLAIMPROPS.SUB_SECTION_ID
                AND PROPERTY_GROUP = LRCLAIMPROPS.PROPERTY_GROUP
                AND PROPERTY = LRCLAIMPROPS.PROPERTY
                AND ATTRIBUTE = LRCLAIMPROPS.ATTRIBUTE;
              END LOOP;

              
              FOR LRCLAIMPROPS IN C_CLAIMPROPS(ASPARTNO, ANREVISION, LRPROPS.PROPERTY, 2)
              LOOP
                UPDATE SPECIFICATION_PROP
                SET BOOLEAN_1 = 'Y' 
                WHERE PART_NO = LRCLAIMPROPS.PART_NO
                AND REVISION = LRCLAIMPROPS.REVISION
                AND SECTION_ID = LRCLAIMPROPS.SECTION_ID
                AND SUB_SECTION_ID = LRCLAIMPROPS.SUB_SECTION_ID
                AND PROPERTY_GROUP = LRCLAIMPROPS.PROPERTY_GROUP
                AND PROPERTY = LRCLAIMPROPS.PROPERTY
                AND ATTRIBUTE = LRCLAIMPROPS.ATTRIBUTE;
              END LOOP;

          END LOOP;
      END LOOP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               'Cannot check/uncheck Claim property check box due to an error.' );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         
         
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   END ADJUSTPNCLAIMPROPERTYPRESDEF;




   
   FUNCTION ADJUSTPNCLAIMPROPERTYPRESENCES(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANINGREDIENTID             IN       IAPITYPE.ID_TYPE)
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AdjustPNClaimPropertyPresences';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;

   CURSOR C_INGALLERGENS( LCINGREDIENT IN  ITINGALLERGEN.INGREDIENT%TYPE)
   IS
    SELECT ALLERGEN
    FROM ITINGALLERGEN
    WHERE INGREDIENT = LCINGREDIENT
    AND STATUS = 0;

   CURSOR C_PROPS (LCALLERGEN IN ITINGALLERGEN.ALLERGEN%TYPE)
   IS
    SELECT PROPERTY
    FROM ITPROPALLERGEN
    WHERE ALLERGEN = LCALLERGEN
    AND STATUS = 0;

   
   CURSOR C_CLAIMPROPS ( LCPARTNO   IN  ITSPECINGALLERGEN.PART_NO%TYPE,
                         LCREVISION IN  ITSPECINGALLERGEN.REVISION%TYPE,
                         LCPROPERTY IN  ITPROPALLERGEN.PROPERTY%TYPE,
                         LCCLAIMTYPE IN PROPERTY_GROUP.PG_TYPE%TYPE)
   IS
    SELECT SP.PART_NO, SP.REVISION, SP.SECTION_ID, SP.SUB_SECTION_ID, SP.PROPERTY_GROUP, SP.PROPERTY, SP.ATTRIBUTE
    FROM SPECIFICATION_PROP SP, PROPERTY_GROUP PG
    WHERE SP.PROPERTY_GROUP = PG.PROPERTY_GROUP
    AND PART_NO = LCPARTNO
    AND REVISION = LCREVISION
    AND PG_TYPE = LCCLAIMTYPE
    AND PROPERTY = LCPROPERTY;

   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR LRALLERGEN IN C_INGALLERGENS( ANINGREDIENTID)
      LOOP
          
          FOR LRPROPS IN C_PROPS( LRALLERGEN.ALLERGEN )
          LOOP
              
              
              

              
              
              SELECT COUNT(*)
              INTO LNCOUNT
              FROM SPECIFICATION_ING SI, ITINGALLERGEN IA
              WHERE SI.INGREDIENT = IA.INGREDIENT
              AND PART_NO = ASPARTNO
              AND REVISION = ANREVISION
              AND ALLERGEN = LRALLERGEN.ALLERGEN
              AND IA.STATUS = 0; 

              
              IF (LNCOUNT = 0)
              THEN
                  
                  SELECT COUNT(*)
                  INTO LNCOUNT
                  FROM ITSPECINGALLERGEN
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION
                    AND ALLERGEN = LRALLERGEN.ALLERGEN;
              END IF;

              
              IF (LNCOUNT <> 0)
              THEN
                RETURN (IAPICONSTANTDBERROR.DBERR_SUCCESS);
              END IF;

              
              FOR LRCLAIMPROPS IN C_CLAIMPROPS(ASPARTNO, ANREVISION, LRPROPS.PROPERTY, 3)
              LOOP
                UPDATE SPECIFICATION_PROP
                SET BOOLEAN_1 = 'N' 
                WHERE PART_NO = LRCLAIMPROPS.PART_NO
                AND REVISION = LRCLAIMPROPS.REVISION
                AND SECTION_ID = LRCLAIMPROPS.SECTION_ID
                AND SUB_SECTION_ID = LRCLAIMPROPS.SUB_SECTION_ID
                AND PROPERTY_GROUP = LRCLAIMPROPS.PROPERTY_GROUP
                AND PROPERTY = LRCLAIMPROPS.PROPERTY
                AND ATTRIBUTE = LRCLAIMPROPS.ATTRIBUTE;
              END LOOP;

              
              FOR LRCLAIMPROPS IN C_CLAIMPROPS(ASPARTNO, ANREVISION, LRPROPS.PROPERTY, 2)
              LOOP
                UPDATE SPECIFICATION_PROP
                SET BOOLEAN_1 = 'Y' 
                WHERE PART_NO = LRCLAIMPROPS.PART_NO
                AND REVISION = LRCLAIMPROPS.REVISION
                AND SECTION_ID = LRCLAIMPROPS.SECTION_ID
                AND SUB_SECTION_ID = LRCLAIMPROPS.SUB_SECTION_ID
                AND PROPERTY_GROUP = LRCLAIMPROPS.PROPERTY_GROUP
                AND PROPERTY = LRCLAIMPROPS.PROPERTY
                AND ATTRIBUTE = LRCLAIMPROPS.ATTRIBUTE;
              END LOOP;

          END LOOP;
      END LOOP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               'Cannot check/uncheck Claim property check box due to an error.' );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         
         
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   END ADJUSTPNCLAIMPROPERTYPRESENCES;

   
   FUNCTION REMOVELIST(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ASMETHOD                   IN       IAPITYPE.METHOD_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveList';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRINGREDIENTLIST              IAPITYPE.SPINGREDIENTLISTREC_TYPE;
      LNALLOWED                     IAPITYPE.BOOLEAN_TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LSSQLINFO                     IAPITYPE.SQLSTRING_TYPE;
      
      LNINTL                        IAPITYPE.BOOLEAN_TYPE;

      CURSOR C_INGREDIENTS(CSPARTNO     IN       IAPITYPE.PARTNO_TYPE,
                           CNREVISION   IN       IAPITYPE.REVISION_TYPE)
      IS
        SELECT DISTINCT PART_NO, REVISION, SECTION_ID, SUB_SECTION_ID, INGREDIENT
        FROM SPECIFICATION_ING
        WHERE PART_NO = CSPARTNO
          AND REVISION = CNREVISION ;

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
      GTINGREDIENTLISTS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRINGREDIENTLIST.PARTNO := ASPARTNO;
      LRINGREDIENTLIST.REVISION := ANREVISION;
      LRINGREDIENTLIST.SECTIONID := ANSECTIONID;
      LRINGREDIENTLIST.SUBSECTIONID := ANSUBSECTIONID;
      LRINGREDIENTLIST.ITEMID := 0;   
      GTINGREDIENTLISTS( 0 ) := LRINGREDIENTLIST;

      GTINFO( 0 ) := LRINFO;
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Pre-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     ASMETHOD,
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
            IAPIGENERAL.LOGINFO( GSSOURCE,
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
      
      
      
      
      
      
      CHECKBASICINGRLISTPARAMS( LRINGREDIENTLIST );

      
      
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
         IAPISPECIFICATIONSECTION.ISACTIONALLOWED( LRINGREDIENTLIST.PARTNO,
                                                   LRINGREDIENTLIST.REVISION,
                                                   LRINGREDIENTLIST.SECTIONID,
                                                   LRINGREDIENTLIST.SUBSECTIONID,
                                                   IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST,
                                                   LRINGREDIENTLIST.ITEMID,
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
                                                     LRINGREDIENTLIST.ITEMID,
                                                     IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST,
                                                     LRINGREDIENTLIST.PARTNO,
                                                     LRINGREDIENTLIST.REVISION,
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRINGREDIENTLIST.SECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRINGREDIENTLIST.SUBSECTIONID, 0) ));
                                                     
      END IF;

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.REMOVESECTIONITEM( LRINGREDIENTLIST.PARTNO,
                                                     LRINGREDIENTLIST.REVISION,
                                                     LRINGREDIENTLIST.SECTIONID,
                                                     LRINGREDIENTLIST.SUBSECTIONID,
                                                     IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST,
                                                     LRINGREDIENTLIST.ITEMID,
                                                     AFHANDLE => AFHANDLE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;
      

      
      
      LNRETVAL := IAPISPECIFICATION.GETMODE(LRINGREDIENTLIST.PARTNO,
                                            LRINGREDIENTLIST.REVISION,
                                            LNINTL);

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN LNRETVAL;
      END IF;

      IF   (IAPIGENERAL.SESSION.SETTINGS.INTERNATIONAL = FALSE)
        OR (LNINTL = '1')
      THEN
          FOR LRINGREDIENT IN C_INGREDIENTS(LRINGREDIENTLIST.PARTNO,
                                            LRINGREDIENTLIST.REVISION)
          LOOP
            LNRETVAL := ADJUSTPNCLAIMPROPERTYPRESDEF(LRINGREDIENT.PART_NO,
                                                       LRINGREDIENT.REVISION,
                                                       LRINGREDIENT.INGREDIENT);
          END LOOP;

      END IF;
      

      
      DELETE FROM SPECIFICATION_ING
            WHERE PART_NO = LRINGREDIENTLIST.PARTNO
              AND REVISION = LRINGREDIENTLIST.REVISION;

      DELETE FROM SPECIFICATION_ING_LANG
            WHERE PART_NO = LRINGREDIENTLIST.PARTNO
              AND REVISION = LRINGREDIENTLIST.REVISION;

      
      DELETE FROM ITSPECINGDETAIL
            WHERE PART_NO = LRINGREDIENTLIST.PARTNO
              AND REVISION = LRINGREDIENTLIST.REVISION;
     

      
      BEGIN
         DELETE FROM ITSHEXT
               WHERE PART_NO = LRINGREDIENTLIST.PARTNO
                 AND REVISION = LRINGREDIENTLIST.REVISION
                 AND SECTION_ID = LRINGREDIENTLIST.SECTIONID
                 AND SUB_SECTION_ID = LRINGREDIENTLIST.SUBSECTIONID
                 AND TYPE = IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST
                 AND REF_ID = LRINGREDIENTLIST.ITEMID;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;   
      END;

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.LOGHISTORY( LRINGREDIENTLIST.PARTNO,
                                              LRINGREDIENTLIST.REVISION,
                                              LRINGREDIENTLIST.SECTIONID,
                                              LRINGREDIENTLIST.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRINGREDIENTLIST.PARTNO,
                                                LRINGREDIENTLIST.REVISION );

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

      GTINFO.DELETE;
      GTINFO( 0 ) := LRINFO;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Post-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     ASMETHOD,
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
            IAPIGENERAL.LOGINFO( GSSOURCE,
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
   END REMOVELIST;

   
   FUNCTION ADDINGREDIENTLISTITEM(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANINGREDIENTID             IN       IAPITYPE.ID_TYPE,
      ANSEQUENCENUMBER           IN       IAPITYPE.INGREDIENTSEQUENCENUMBER_TYPE,
      ANSYNONYMID                IN       IAPITYPE.ID_TYPE,
      ANQUANTITY                 IN       IAPITYPE.INGREDIENTQUANTITY_TYPE,
      ASLEVEL                    IN       IAPITYPE.INGREDIENTLEVEL_TYPE,
      ASCOMMENT                  IN       IAPITYPE.INGREDIENTCOMMENT_TYPE,
      ANDECLARE                  IN       IAPITYPE.BOOLEAN_TYPE,
      ANRECONSTITUTIONFACTOR     IN       IAPITYPE.RECONSTITUTIONFACTOR_TYPE DEFAULT NULL,
      ANHIERARCHICALLEVEL        IN       IAPITYPE.INGREDIENTHIERARCHICLEVEL_TYPE DEFAULT 1,
      ANPARENTID                 IN       IAPITYPE.ID_TYPE DEFAULT 0,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddIngredientListItem';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRINGREDIENTLISTITEM          IAPITYPE.SPINGREDIENTLISTITEMREC_TYPE;
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
      GTINGREDIENTLISTITEMS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRINGREDIENTLISTITEM.PARTNO := ASPARTNO;
      LRINGREDIENTLISTITEM.REVISION := ANREVISION;
      LRINGREDIENTLISTITEM.SECTIONID := ANSECTIONID;
      LRINGREDIENTLISTITEM.SUBSECTIONID := ANSUBSECTIONID;
      LRINGREDIENTLISTITEM.INGREDIENTID := ANINGREDIENTID;
      LRINGREDIENTLISTITEM.SEQUENCE := ANSEQUENCENUMBER;
      LRINGREDIENTLISTITEM.SYNONYMID := ANSYNONYMID;
      LRINGREDIENTLISTITEM.INGREDIENTQUANTITY := ANQUANTITY;
      LRINGREDIENTLISTITEM.INGREDIENTLEVEL := ASLEVEL;
      LRINGREDIENTLISTITEM.INGREDIENTCOMMENT := ASCOMMENT;
      LRINGREDIENTLISTITEM.RECONSTITUTIONFACTOR := ANRECONSTITUTIONFACTOR;
      LRINGREDIENTLISTITEM.HIERARCHICALLEVEL := ANHIERARCHICALLEVEL;
      LRINGREDIENTLISTITEM.PARENTID := ANPARENTID;
      LRINGREDIENTLISTITEM.DECLAREFLAG := ANDECLARE;
      GTINGREDIENTLISTITEMS( 0 ) := LRINGREDIENTLISTITEM;

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
      
      
      
      
      
      
      
      
      CHECKBASICINGRLISTITEMPARAMS( LRINGREDIENTLISTITEM );

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

      
      LNRETVAL := IAPISPECIFICATIONACCESS.GETMODIFIABLEACCESS( LRINGREDIENTLISTITEM.PARTNO,
                                                               LRINGREDIENTLISTITEM.REVISION,
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
         IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( LRINGREDIENTLISTITEM.PARTNO,
                                                      LRINGREDIENTLISTITEM.REVISION,
                                                      LRINGREDIENTLISTITEM.SECTIONID,
                                                      LRINGREDIENTLISTITEM.SUBSECTIONID,
                                                      IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST,
                                                      0 );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL :=
         EXISTITEMINLIST( LRINGREDIENTLISTITEM.PARTNO,
                                                         LRINGREDIENTLISTITEM.REVISION,
                                                         LRINGREDIENTLISTITEM.SECTIONID,
                                                         LRINGREDIENTLISTITEM.SUBSECTIONID,
                                                         LRINGREDIENTLISTITEM.INGREDIENTID,
                                                         LRINGREDIENTLISTITEM.SEQUENCE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SPITEMNOTFOUND )
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
      
      LNRETVAL := IAPISPECIFICATION.GETMODE( LRINGREDIENTLISTITEM.PARTNO,
                                             LRINGREDIENTLISTITEM.REVISION,
                                             LRINGREDIENTLISTITEM.INTERNATIONAL );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LRINGREDIENTLISTITEM.PARENTID := NVL( LRINGREDIENTLISTITEM.PARENTID,
                                            0 );

      IF (     (     LRINGREDIENTLISTITEM.HIERARCHICALLEVEL = 1
                 AND LRINGREDIENTLISTITEM.PARENTID <> 0 )
           OR (     LRINGREDIENTLISTITEM.HIERARCHICALLEVEL > 1
                AND LRINGREDIENTLISTITEM.PARENTID < 1 ) )
      THEN
         NULL;
         LNRETVAL :=
            IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                IAPICONSTANTDBERROR.DBERR_INVALIDLEVELPID,
                                                LRINGREDIENTLISTITEM.PARENTID,
                                                LRINGREDIENTLISTITEM.HIERARCHICALLEVEL );
         
         RETURN LNRETVAL;
      END IF;

      INSERT INTO SPECIFICATION_ING
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID,
                    INGREDIENT,
                    ING_SYNONYM,
                    QUANTITY,
                    ING_LEVEL,
                    ING_COMMENT,
                    RECFAC,
                    INTL,
                    SEQ_NO,
                    HIER_LEVEL,
                    PID,
                    INGDECLARE )
           VALUES ( LRINGREDIENTLISTITEM.PARTNO,
                    LRINGREDIENTLISTITEM.REVISION,
                    LRINGREDIENTLISTITEM.SECTIONID,
                    LRINGREDIENTLISTITEM.SUBSECTIONID,
                    LRINGREDIENTLISTITEM.INGREDIENTID,
                    LRINGREDIENTLISTITEM.SYNONYMID,
                    LRINGREDIENTLISTITEM.INGREDIENTQUANTITY,
                    LRINGREDIENTLISTITEM.INGREDIENTLEVEL,
                    LRINGREDIENTLISTITEM.INGREDIENTCOMMENT,
                    LRINGREDIENTLISTITEM.RECONSTITUTIONFACTOR,
                    LRINGREDIENTLISTITEM.INTERNATIONAL,
                    LRINGREDIENTLISTITEM.SEQUENCE,
                    LRINGREDIENTLISTITEM.HIERARCHICALLEVEL,
                    LRINGREDIENTLISTITEM.PARENTID,
                    LRINGREDIENTLISTITEM.DECLAREFLAG );
      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.LOGHISTORY( LRINGREDIENTLISTITEM.PARTNO,
                                              LRINGREDIENTLISTITEM.REVISION,
                                              LRINGREDIENTLISTITEM.SECTIONID,
                                              LRINGREDIENTLISTITEM.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRINGREDIENTLISTITEM.PARTNO,
                                                LRINGREDIENTLISTITEM.REVISION );

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
   END ADDINGREDIENTLISTITEM;

   
   FUNCTION REMOVELISTITEM(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANINGREDIENTID             IN       IAPITYPE.ID_TYPE,
      ANSEQUENCENUMBER           IN       IAPITYPE.INGREDIENTSEQUENCENUMBER_TYPE,
      ASMETHOD                   IN       IAPITYPE.METHOD_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveListItem';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRINGREDIENTLISTITEM          IAPITYPE.SPINGREDIENTLISTITEMREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNHIERARCHICLEVEL             IAPITYPE.INGREDIENTHIERARCHICLEVEL_TYPE;
      LQINGREDIENTLISTITEMS         IAPITYPE.REF_TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LSSQLINFO                     IAPITYPE.SQLSTRING_TYPE;
      
      LHIERLEVEL                    IAPITYPE.NUMVAL_TYPE := 0;
      
      LNINTL                        IAPITYPE.BOOLEAN_TYPE;

      
      CURSOR C_DELETE  IS
                        SELECT *
                         FROM SPECIFICATION_ING
                        WHERE PART_NO = ASPARTNO
                          AND REVISION = ANREVISION
                          AND SECTION_ID = ANSECTIONID
                          AND SUB_SECTION_ID = ANSUBSECTIONID
                          AND SEQ_NO >= ANSEQUENCENUMBER
                     ORDER BY SEQ_NO;
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
      GTINGREDIENTLISTITEMS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRINGREDIENTLISTITEM.PARTNO := ASPARTNO;
      LRINGREDIENTLISTITEM.REVISION := ANREVISION;
      LRINGREDIENTLISTITEM.SECTIONID := ANSECTIONID;
      LRINGREDIENTLISTITEM.SUBSECTIONID := ANSUBSECTIONID;
      LRINGREDIENTLISTITEM.INGREDIENTID := ANINGREDIENTID;
      LRINGREDIENTLISTITEM.SEQUENCE := ANSEQUENCENUMBER;
      GTINGREDIENTLISTITEMS( 0 ) := LRINGREDIENTLISTITEM;

      GTINFO( 0 ) := LRINFO;
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Pre-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     ASMETHOD,
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
            IAPIGENERAL.LOGINFO( GSSOURCE,
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
      
      
      
      
      
      
      
      
      CHECKBASICINGRLISTITEMPARAMS( LRINGREDIENTLISTITEM );

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

      
      LNRETVAL := IAPISPECIFICATIONACCESS.GETMODIFIABLEACCESS( LRINGREDIENTLISTITEM.PARTNO,
                                                               LRINGREDIENTLISTITEM.REVISION,
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
         IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( LRINGREDIENTLISTITEM.PARTNO,
                                                      LRINGREDIENTLISTITEM.REVISION,
                                                      LRINGREDIENTLISTITEM.SECTIONID,
                                                      LRINGREDIENTLISTITEM.SUBSECTIONID,
                                                      IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST,
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

      

      
      


































































      

     FOR LREC IN C_DELETE
     LOOP
         IF LHIERLEVEL = 0
         THEN
             
             
             
             
             
             IF LREC.SEQ_NO > ANSEQUENCENUMBER
             THEN
                EXIT;
             END IF;
             

             LHIERLEVEL := LREC.HIER_LEVEL;
         ELSE
             IF LREC.HIER_LEVEL <= LHIERLEVEL
             THEN
               
                EXIT;
             END IF;
         END IF;

        DELETE FROM SPECIFICATION_ING_LANG
               WHERE PART_NO = LRINGREDIENTLISTITEM.PARTNO
               AND REVISION = LRINGREDIENTLISTITEM.REVISION
               AND SECTION_ID = LRINGREDIENTLISTITEM.SECTIONID
               AND SUB_SECTION_ID = LRINGREDIENTLISTITEM.SUBSECTIONID
               AND SEQ_NO = LREC.SEQ_NO;

        
        DELETE FROM ITSPECINGDETAIL
        WHERE PART_NO = LRINGREDIENTLISTITEM.PARTNO
            AND REVISION = LRINGREDIENTLISTITEM.REVISION
            AND SECTION_ID = LRINGREDIENTLISTITEM.SECTIONID
            AND SUB_SECTION_ID = LRINGREDIENTLISTITEM.SUBSECTIONID
            AND INGREDIENT_SEQ_NO = LREC.SEQ_NO;
        

        DELETE FROM SPECIFICATION_ING
            WHERE PART_NO = LRINGREDIENTLISTITEM.PARTNO
              AND REVISION = LRINGREDIENTLISTITEM.REVISION
              AND SECTION_ID = LRINGREDIENTLISTITEM.SECTIONID
              AND SUB_SECTION_ID = LRINGREDIENTLISTITEM.SUBSECTIONID
              AND SEQ_NO = LREC.SEQ_NO;

        
        
        LNRETVAL := IAPISPECIFICATION.GETMODE(LRINGREDIENTLISTITEM.PARTNO,
                                              LRINGREDIENTLISTITEM.REVISION,
                                              LNINTL);

        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
        THEN
           IAPIGENERAL.LOGINFO( GSSOURCE,
                                LSMETHOD,
                                IAPIGENERAL.GETLASTERRORTEXT( ) );
           RETURN LNRETVAL;
        END IF;

        IF    (IAPIGENERAL.SESSION.SETTINGS.INTERNATIONAL = FALSE)
          OR (LNINTL = '1')
        THEN
            LNRETVAL := ADJUSTPNCLAIMPROPERTYPRESENCES(LRINGREDIENTLISTITEM.PARTNO,
                                                       LRINGREDIENTLISTITEM.REVISION,
                                                       LRINGREDIENTLISTITEM.INGREDIENTID);
        END IF;
        

     END LOOP;
      

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.LOGHISTORY( LRINGREDIENTLISTITEM.PARTNO,
                                              LRINGREDIENTLISTITEM.REVISION,
                                              LRINGREDIENTLISTITEM.SECTIONID,
                                              LRINGREDIENTLISTITEM.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRINGREDIENTLISTITEM.PARTNO,
                                                LRINGREDIENTLISTITEM.REVISION );

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

      GTINFO.DELETE;
      GTINFO( 0 ) := LRINFO;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Post-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     ASMETHOD,
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
            IAPIGENERAL.LOGINFO( GSSOURCE,
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
   END REMOVELISTITEM;


   
   FUNCTION SAVEINGREDIENTLISTITEM(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANINGREDIENTID             IN       IAPITYPE.ID_TYPE,
      ANSEQUENCENUMBER           IN       IAPITYPE.INGREDIENTSEQUENCENUMBER_TYPE,
      ANSYNONYMID                IN       IAPITYPE.ID_TYPE,
      ANQUANTITY                 IN       IAPITYPE.INGREDIENTQUANTITY_TYPE,
      ASLEVEL                    IN       IAPITYPE.INGREDIENTLEVEL_TYPE,
      ASCOMMENT                  IN       IAPITYPE.INGREDIENTCOMMENT_TYPE,
      ANDECLARE                  IN       IAPITYPE.BOOLEAN_TYPE,
      ANNEWSEQUENCE              IN       IAPITYPE.INGREDIENTSEQUENCENUMBER_TYPE DEFAULT NULL,
      ANRECONSTITUTIONFACTOR     IN       IAPITYPE.RECONSTITUTIONFACTOR_TYPE DEFAULT NULL,
      ANHIERARCHICALLEVEL        IN       IAPITYPE.INGREDIENTHIERARCHICLEVEL_TYPE DEFAULT 1,
      ANPARENTID                 IN       IAPITYPE.ID_TYPE DEFAULT 0,
      ANALTERNATIVELANGUAGEID    IN       IAPITYPE.LANGUAGEID_TYPE DEFAULT NULL,
      ASALTERNATIVELEVEL         IN       IAPITYPE.INGREDIENTLEVEL_TYPE DEFAULT NULL,
      ASALTERNATIVECOMMENT       IN       IAPITYPE.INGREDIENTCOMMENT_TYPE DEFAULT NULL,
      
      ANINGDETAILTYPE               IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANINGDETAILCHARACTERISTIC           IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQSPECINGLANG(
         ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
         ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
         ANSECTIONID                IN       IAPITYPE.ID_TYPE,
         ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
         ANINGREDIENT               IN       IAPITYPE.ID_TYPE,
         ANLANGID                   IN       IAPITYPE.LANGUAGEID_TYPE,
         ANSEQ                      IN       IAPITYPE.INGREDIENTSEQUENCENUMBER_TYPE )
      IS
         SELECT 'X'
           FROM SPECIFICATION_ING_LANG
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND INGREDIENT = ANINGREDIENT
            AND LANG_ID = ANLANGID
            AND SEQ_NO = ANSEQ;

      
      CURSOR LQSPECINGDETAIL(
         ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
         ANREVISION                IN       IAPITYPE.REVISION_TYPE,
         ANSECTIONID               IN       IAPITYPE.ID_TYPE,
         ANSUBSECTIONID         IN       IAPITYPE.ID_TYPE,
         ANINGREDIENT             IN       IAPITYPE.ID_TYPE,
         ANSEQ                      IN       IAPITYPE.INGREDIENTSEQUENCENUMBER_TYPE,
         ANINGDETAILTYPE        IN       IAPITYPE.ID_TYPE,
         ANINGDETILCHAR         IN       IAPITYPE.ID_TYPE )
      IS
         SELECT 'X'
           FROM ITSPECINGDETAIL
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND INGREDIENT = ANINGREDIENT
            AND INGREDIENT_SEQ_NO = ANSEQ
            AND INGDETAIL_TYPE = ANINGDETAILTYPE
            AND INGDETAIL_CHARACTERISTIC = ANINGDETILCHAR;
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveIngredientListItem';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRINGREDIENTLISTITEM          IAPITYPE.SPINGREDIENTLISTITEMREC_TYPE;
      LNMULTILANGUAGE               IAPITYPE.BOOLEAN_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSDUMMY                       VARCHAR2( 1 );
      LNSEQNO                       IAPITYPE.INGREDIENTSEQUENCENUMBER_TYPE;
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
      GTINGREDIENTLISTITEMS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRINGREDIENTLISTITEM.PARTNO := ASPARTNO;
      LRINGREDIENTLISTITEM.REVISION := ANREVISION;
      LRINGREDIENTLISTITEM.SECTIONID := ANSECTIONID;
      LRINGREDIENTLISTITEM.SUBSECTIONID := ANSUBSECTIONID;
      LRINGREDIENTLISTITEM.INGREDIENTID := ANINGREDIENTID;
      LRINGREDIENTLISTITEM.SEQUENCE := ANSEQUENCENUMBER;
      LRINGREDIENTLISTITEM.SYNONYMID := ANSYNONYMID;
      LRINGREDIENTLISTITEM.INGREDIENTQUANTITY := ANQUANTITY;
      LRINGREDIENTLISTITEM.INGREDIENTLEVEL := ASLEVEL;
      LRINGREDIENTLISTITEM.INGREDIENTCOMMENT := ASCOMMENT;
      LRINGREDIENTLISTITEM.RECONSTITUTIONFACTOR := ANRECONSTITUTIONFACTOR;
      LRINGREDIENTLISTITEM.HIERARCHICALLEVEL := ANHIERARCHICALLEVEL;
      LRINGREDIENTLISTITEM.PARENTID := ANPARENTID;
      LRINGREDIENTLISTITEM.ALTERNATIVELANGUAGEID := ANALTERNATIVELANGUAGEID;
      LRINGREDIENTLISTITEM.ALTERNATIVELEVEL := ASALTERNATIVELEVEL;
      LRINGREDIENTLISTITEM.ALTERNATIVECOMMENT := ASALTERNATIVECOMMENT;
      LRINGREDIENTLISTITEM.DECLAREFLAG := ANDECLARE;
      
      
      
      
      GTINGREDIENTLISTITEMS( 0 ) := LRINGREDIENTLISTITEM;

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

      
      LRINFO := GTINFO( 0 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      
      
      
      
      
      CHECKBASICINGRLISTITEMPARAMS( LRINGREDIENTLISTITEM );

      
      IF ( LRINGREDIENTLISTITEM.ALTERNATIVELANGUAGEID = 1 )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_STDLANGNOTALLOWED );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anAlternativeLanguageId',
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

      
      
      IF ( LRINGREDIENTLISTITEM.ALTERNATIVELANGUAGEID IS NOT NULL )
      THEN
         LNRETVAL := IAPISPECIFICATION.ISMULTILANGUAGE( LRINGREDIENTLISTITEM.PARTNO,
                                                        LRINGREDIENTLISTITEM.REVISION,
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
                                                        LRINGREDIENTLISTITEM.PARTNO,
                                                        LRINGREDIENTLISTITEM.REVISION ) );
         END IF;
      END IF;

      
      LNRETVAL := IAPISPECIFICATIONACCESS.GETMODIFIABLEACCESS( LRINGREDIENTLISTITEM.PARTNO,
                                                               LRINGREDIENTLISTITEM.REVISION,
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
         IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( LRINGREDIENTLISTITEM.PARTNO,
                                                      LRINGREDIENTLISTITEM.REVISION,
                                                      LRINGREDIENTLISTITEM.SECTIONID,
                                                      LRINGREDIENTLISTITEM.SUBSECTIONID,
                                                      IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST,
                                                      0 );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL :=
         EXISTITEMINLIST( LRINGREDIENTLISTITEM.PARTNO,
                                                         LRINGREDIENTLISTITEM.REVISION,
                                                         LRINGREDIENTLISTITEM.SECTIONID,
                                                         LRINGREDIENTLISTITEM.SUBSECTIONID,
                                                         LRINGREDIENTLISTITEM.INGREDIENTID,
                                                         LRINGREDIENTLISTITEM.SEQUENCE );

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
      
      LNRETVAL := IAPISPECIFICATION.GETMODE( LRINGREDIENTLISTITEM.PARTNO,
                                             LRINGREDIENTLISTITEM.REVISION,
                                             LRINGREDIENTLISTITEM.INTERNATIONAL );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LRINGREDIENTLISTITEM.PARENTID := NVL( LRINGREDIENTLISTITEM.PARENTID,
                                            0 );

      IF (     (     LRINGREDIENTLISTITEM.HIERARCHICALLEVEL = 1
                 AND LRINGREDIENTLISTITEM.PARENTID <> 0 )
           OR (     LRINGREDIENTLISTITEM.HIERARCHICALLEVEL > 1
                AND LRINGREDIENTLISTITEM.PARENTID < 1 ) )
      THEN
         NULL;
         LNRETVAL :=
            IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                IAPICONSTANTDBERROR.DBERR_INVALIDLEVELPID,
                                                LRINGREDIENTLISTITEM.PARENTID,
                                                LRINGREDIENTLISTITEM.HIERARCHICALLEVEL );
         
         RETURN LNRETVAL;
      END IF;

      UPDATE SPECIFICATION_ING
         SET ING_SYNONYM = LRINGREDIENTLISTITEM.SYNONYMID,
             QUANTITY = LRINGREDIENTLISTITEM.INGREDIENTQUANTITY,
             ING_LEVEL = LRINGREDIENTLISTITEM.INGREDIENTLEVEL,
             ING_COMMENT = LRINGREDIENTLISTITEM.INGREDIENTCOMMENT,
             INTL = LRINGREDIENTLISTITEM.INTERNATIONAL,
             RECFAC = LRINGREDIENTLISTITEM.RECONSTITUTIONFACTOR,
             HIER_LEVEL = LRINGREDIENTLISTITEM.HIERARCHICALLEVEL,
             PID = LRINGREDIENTLISTITEM.PARENTID,
             INGDECLARE = LRINGREDIENTLISTITEM.DECLAREFLAG,
             SEQ_NO = DECODE( ANNEWSEQUENCE,
                              NULL, ANSEQUENCENUMBER,
                              ANSEQUENCENUMBER, ANSEQUENCENUMBER,
                              ANNEWSEQUENCE )
       WHERE PART_NO = LRINGREDIENTLISTITEM.PARTNO
         AND REVISION = LRINGREDIENTLISTITEM.REVISION
         AND SECTION_ID = LRINGREDIENTLISTITEM.SECTIONID
         AND SUB_SECTION_ID = LRINGREDIENTLISTITEM.SUBSECTIONID
         AND INGREDIENT = LRINGREDIENTLISTITEM.INGREDIENTID
         AND SEQ_NO = LRINGREDIENTLISTITEM.SEQUENCE
         AND PID = LRINGREDIENTLISTITEM.PARENTID  
         AND HIER_LEVEL = LRINGREDIENTLISTITEM.HIERARCHICALLEVEL;

      
      IF ( LRINGREDIENTLISTITEM.ALTERNATIVELANGUAGEID IS NOT NULL )
      THEN
         BEGIN
            
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 'Try to insert multi-language data',
                                 IAPICONSTANT.INFOLEVEL_3 );

            
            
            OPEN LQSPECINGLANG( LRINGREDIENTLISTITEM.PARTNO,
                                LRINGREDIENTLISTITEM.REVISION,
                                LRINGREDIENTLISTITEM.SECTIONID,
                                LRINGREDIENTLISTITEM.SUBSECTIONID,
                                LRINGREDIENTLISTITEM.INGREDIENTID,
                                LRINGREDIENTLISTITEM.ALTERNATIVELANGUAGEID,
                                LRINGREDIENTLISTITEM.SEQUENCE );

            FETCH LQSPECINGLANG
             INTO LSDUMMY;

            IF LQSPECINGLANG%FOUND
            THEN
               LNSEQNO := LRINGREDIENTLISTITEM.SEQUENCE;
            ELSE
               LNSEQNO := ANNEWSEQUENCE;
            END IF;

            CLOSE LQSPECINGLANG;

            LRINGREDIENTLISTITEM.PARENTID := NVL( LRINGREDIENTLISTITEM.PARENTID,
                                                  0 );

            INSERT INTO SPECIFICATION_ING_LANG
                        ( PART_NO,
                          REVISION,
                          SECTION_ID,
                          SUB_SECTION_ID,
                          INGREDIENT,
                          LANG_ID,
                          ING_LEVEL,
                          ING_COMMENT,
                          PID,
                          HIER_LEVEL,
                          SEQ_NO )
                 VALUES ( LRINGREDIENTLISTITEM.PARTNO,
                          LRINGREDIENTLISTITEM.REVISION,
                          LRINGREDIENTLISTITEM.SECTIONID,
                          LRINGREDIENTLISTITEM.SUBSECTIONID,
                          LRINGREDIENTLISTITEM.INGREDIENTID,
                          LRINGREDIENTLISTITEM.ALTERNATIVELANGUAGEID,
                          LRINGREDIENTLISTITEM.ALTERNATIVELEVEL,
                          LRINGREDIENTLISTITEM.ALTERNATIVECOMMENT,
                          LRINGREDIENTLISTITEM.PARENTID,
                          LRINGREDIENTLISTITEM.HIERARCHICALLEVEL,
                          LNSEQNO );
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
               
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    'Update multi-language data',
                                    IAPICONSTANT.INFOLEVEL_3 );

               LRINGREDIENTLISTITEM.PARENTID := NVL( LRINGREDIENTLISTITEM.PARENTID,
                                                     0 );

               IF (     (     LRINGREDIENTLISTITEM.HIERARCHICALLEVEL = 1
                          AND LRINGREDIENTLISTITEM.PARENTID <> 0 )
                    OR (     LRINGREDIENTLISTITEM.HIERARCHICALLEVEL > 1
                         AND LRINGREDIENTLISTITEM.PARENTID < 1 ) )
               THEN
                  NULL;
                  LNRETVAL :=
                     IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_INVALIDLEVELPID,
                                                         LRINGREDIENTLISTITEM.PARENTID,
                                                         LRINGREDIENTLISTITEM.HIERARCHICALLEVEL );
                  
                  RETURN LNRETVAL;
               END IF;

               UPDATE SPECIFICATION_ING_LANG
                  SET ING_LEVEL = LRINGREDIENTLISTITEM.ALTERNATIVELEVEL,
                      ING_COMMENT = LRINGREDIENTLISTITEM.ALTERNATIVECOMMENT,
                      HIER_LEVEL = LRINGREDIENTLISTITEM.HIERARCHICALLEVEL,
                      PID = LRINGREDIENTLISTITEM.PARENTID,
                      SEQ_NO = DECODE( ANNEWSEQUENCE,
                                       NULL, ANSEQUENCENUMBER,
                                       ANSEQUENCENUMBER, ANSEQUENCENUMBER,
                                       ANNEWSEQUENCE )
                WHERE PART_NO = LRINGREDIENTLISTITEM.PARTNO
                  AND REVISION = LRINGREDIENTLISTITEM.REVISION
                  AND SECTION_ID = LRINGREDIENTLISTITEM.SECTIONID
                  AND SUB_SECTION_ID = LRINGREDIENTLISTITEM.SUBSECTIONID
                  AND INGREDIENT = LRINGREDIENTLISTITEM.INGREDIENTID
                  AND LANG_ID = LRINGREDIENTLISTITEM.ALTERNATIVELANGUAGEID
                  AND SEQ_NO = LRINGREDIENTLISTITEM.SEQUENCE;
         END;
      END IF;

     
      
      
      
      IF ( ANINGDETAILTYPE IS NOT NULL
        AND  ANINGDETAILCHARACTERISTIC IS NOT NULL )
      THEN
         BEGIN
            
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 'Try to insert ingredient detail data',
                                 IAPICONSTANT.INFOLEVEL_3 );

            
            
            OPEN LQSPECINGDETAIL( LRINGREDIENTLISTITEM.PARTNO,
                                LRINGREDIENTLISTITEM.REVISION,
                                LRINGREDIENTLISTITEM.SECTIONID,
                                LRINGREDIENTLISTITEM.SUBSECTIONID,
                                LRINGREDIENTLISTITEM.INGREDIENTID,
                                LRINGREDIENTLISTITEM.SEQUENCE,
                                
                                
                                ANINGDETAILTYPE,
                                ANINGDETAILCHARACTERISTIC);

            FETCH LQSPECINGDETAIL
             INTO LSDUMMY;

            IF LQSPECINGDETAIL%FOUND
            THEN
               LNSEQNO := LRINGREDIENTLISTITEM.SEQUENCE;
            ELSE
               LNSEQNO := ANNEWSEQUENCE;
            END IF;

            CLOSE LQSPECINGDETAIL;

            INSERT INTO ITSPECINGDETAIL
                        ( PART_NO,
                          REVISION,
                          SECTION_ID,
                          SUB_SECTION_ID,
                          INGREDIENT,
                          INGREDIENT_SEQ_NO,
                          INGDETAIL_TYPE,
                          INGDETAIL_CHARACTERISTIC)
                 VALUES ( LRINGREDIENTLISTITEM.PARTNO,
                          LRINGREDIENTLISTITEM.REVISION,
                          LRINGREDIENTLISTITEM.SECTIONID,
                          LRINGREDIENTLISTITEM.SUBSECTIONID,
                          LRINGREDIENTLISTITEM.INGREDIENTID,
                          LNSEQNO,
                          
                          
                          ANINGDETAILTYPE,
                          ANINGDETAILCHARACTERISTIC );
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
               
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    'Update indredient detail data',
                                    IAPICONSTANT.INFOLEVEL_3 );

               UPDATE ITSPECINGDETAIL
                  SET INGREDIENT_SEQ_NO = DECODE( ANNEWSEQUENCE,
                                       NULL, ANSEQUENCENUMBER,
                                       ANSEQUENCENUMBER, ANSEQUENCENUMBER,
                                       ANNEWSEQUENCE )
                WHERE PART_NO = LRINGREDIENTLISTITEM.PARTNO
                  AND REVISION = LRINGREDIENTLISTITEM.REVISION
                  AND SECTION_ID = LRINGREDIENTLISTITEM.SECTIONID
                  AND SUB_SECTION_ID = LRINGREDIENTLISTITEM.SUBSECTIONID
                  AND INGREDIENT = LRINGREDIENTLISTITEM.INGREDIENTID
                  AND INGREDIENT_SEQ_NO = LRINGREDIENTLISTITEM.SEQUENCE
                  
                  
                  AND INGDETAIL_TYPE = ANINGDETAILTYPE
                  AND INGDETAIL_CHARACTERISTIC = ANINGDETAILCHARACTERISTIC;
         END;
      END IF;
      
      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.LOGHISTORY( LRINGREDIENTLISTITEM.PARTNO,
                                              LRINGREDIENTLISTITEM.REVISION,
                                              LRINGREDIENTLISTITEM.SECTIONID,
                                              LRINGREDIENTLISTITEM.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRINGREDIENTLISTITEM.PARTNO,
                                                LRINGREDIENTLISTITEM.REVISION );

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
   END SAVEINGREDIENTLISTITEM;



   
   FUNCTION SAVEINGREDIENTLISTITEMPB(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANINGREDIENTID             IN       IAPITYPE.ID_TYPE,
      ANSEQUENCENUMBER           IN       IAPITYPE.INGREDIENTSEQUENCENUMBER_TYPE,
      ANSYNONYMID                IN       IAPITYPE.ID_TYPE,
      ANQUANTITY                 IN       IAPITYPE.INGREDIENTQUANTITY_TYPE,
      ASLEVEL                    IN       IAPITYPE.INGREDIENTLEVEL_TYPE,
      ASCOMMENT                  IN       IAPITYPE.INGREDIENTCOMMENT_TYPE,
      ANDECLARE                  IN       IAPITYPE.BOOLEAN_TYPE,
      ANNEWSEQUENCE              IN       IAPITYPE.INGREDIENTSEQUENCENUMBER_TYPE DEFAULT NULL,
      ANRECONSTITUTIONFACTOR     IN       IAPITYPE.RECONSTITUTIONFACTOR_TYPE DEFAULT NULL,
      ANHIERARCHICALLEVEL        IN       IAPITYPE.INGREDIENTHIERARCHICLEVEL_TYPE DEFAULT 1,
      ANPARENTID                 IN       IAPITYPE.ID_TYPE DEFAULT 0,
      
      ANNEWPARENTID              IN       IAPITYPE.ID_TYPE DEFAULT 0,
      
      ANALTERNATIVELANGUAGEID    IN       IAPITYPE.LANGUAGEID_TYPE DEFAULT NULL,
      ASALTERNATIVELEVEL         IN       IAPITYPE.INGREDIENTLEVEL_TYPE DEFAULT NULL,
      ASALTERNATIVECOMMENT       IN       IAPITYPE.INGREDIENTCOMMENT_TYPE DEFAULT NULL,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQSPECINGLANG(
         ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
         ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
         ANSECTIONID                IN       IAPITYPE.ID_TYPE,
         ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
         ANINGREDIENT               IN       IAPITYPE.ID_TYPE,
         ANLANGID                   IN       IAPITYPE.LANGUAGEID_TYPE,
         ANSEQ                      IN       IAPITYPE.INGREDIENTSEQUENCENUMBER_TYPE )
      IS
         SELECT 'X'
           FROM SPECIFICATION_ING_LANG
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND INGREDIENT = ANINGREDIENT
            AND LANG_ID = ANLANGID
            AND SEQ_NO = ANSEQ;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveIngredientListItemPb';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRINGREDIENTLISTITEM          IAPITYPE.SPINGREDIENTLISTITEMREC_TYPE;
      LNMULTILANGUAGE               IAPITYPE.BOOLEAN_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSDUMMY                       VARCHAR2( 1 );
      LNSEQNO                       IAPITYPE.INGREDIENTSEQUENCENUMBER_TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LSSQLINFO                     IAPITYPE.SQLSTRING_TYPE;
      
      LNNEWPARENTID                 IAPITYPE.ID_TYPE;

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
      GTINGREDIENTLISTITEMS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRINGREDIENTLISTITEM.PARTNO := ASPARTNO;
      LRINGREDIENTLISTITEM.REVISION := ANREVISION;
      LRINGREDIENTLISTITEM.SECTIONID := ANSECTIONID;
      LRINGREDIENTLISTITEM.SUBSECTIONID := ANSUBSECTIONID;
      LRINGREDIENTLISTITEM.INGREDIENTID := ANINGREDIENTID;
      LRINGREDIENTLISTITEM.SEQUENCE := ANSEQUENCENUMBER;
      LRINGREDIENTLISTITEM.SYNONYMID := ANSYNONYMID;
      LRINGREDIENTLISTITEM.INGREDIENTQUANTITY := ANQUANTITY;
      LRINGREDIENTLISTITEM.INGREDIENTLEVEL := ASLEVEL;
      LRINGREDIENTLISTITEM.INGREDIENTCOMMENT := ASCOMMENT;
      LRINGREDIENTLISTITEM.RECONSTITUTIONFACTOR := ANRECONSTITUTIONFACTOR;
      LRINGREDIENTLISTITEM.HIERARCHICALLEVEL := ANHIERARCHICALLEVEL;
      LRINGREDIENTLISTITEM.PARENTID := ANPARENTID;
      LRINGREDIENTLISTITEM.ALTERNATIVELANGUAGEID := ANALTERNATIVELANGUAGEID;
      LRINGREDIENTLISTITEM.ALTERNATIVELEVEL := ASALTERNATIVELEVEL;
      LRINGREDIENTLISTITEM.ALTERNATIVECOMMENT := ASALTERNATIVECOMMENT;
      LRINGREDIENTLISTITEM.DECLAREFLAG := ANDECLARE;
      GTINGREDIENTLISTITEMS( 0 ) := LRINGREDIENTLISTITEM;

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

      
      LRINFO := GTINFO( 0 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      
      
      
      
      
      CHECKBASICINGRLISTITEMPARAMS( LRINGREDIENTLISTITEM );

      
      IF ( LRINGREDIENTLISTITEM.ALTERNATIVELANGUAGEID = 1 )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_STDLANGNOTALLOWED );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anAlternativeLanguageId',
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

      
      
      IF ( LRINGREDIENTLISTITEM.ALTERNATIVELANGUAGEID IS NOT NULL )
      THEN
         LNRETVAL := IAPISPECIFICATION.ISMULTILANGUAGE( LRINGREDIENTLISTITEM.PARTNO,
                                                        LRINGREDIENTLISTITEM.REVISION,
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
                                                        LRINGREDIENTLISTITEM.PARTNO,
                                                        LRINGREDIENTLISTITEM.REVISION ) );
         END IF;
      END IF;

      
      LNRETVAL := IAPISPECIFICATIONACCESS.GETMODIFIABLEACCESS( LRINGREDIENTLISTITEM.PARTNO,
                                                               LRINGREDIENTLISTITEM.REVISION,
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
         IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( LRINGREDIENTLISTITEM.PARTNO,
                                                      LRINGREDIENTLISTITEM.REVISION,
                                                      LRINGREDIENTLISTITEM.SECTIONID,
                                                      LRINGREDIENTLISTITEM.SUBSECTIONID,
                                                      IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST,
                                                      0 );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL :=
         EXISTITEMINLIST( LRINGREDIENTLISTITEM.PARTNO,
                                                         LRINGREDIENTLISTITEM.REVISION,
                                                         LRINGREDIENTLISTITEM.SECTIONID,
                                                         LRINGREDIENTLISTITEM.SUBSECTIONID,
                                                         LRINGREDIENTLISTITEM.INGREDIENTID,
                                                         LRINGREDIENTLISTITEM.SEQUENCE );

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
      
      LNRETVAL := IAPISPECIFICATION.GETMODE( LRINGREDIENTLISTITEM.PARTNO,
                                             LRINGREDIENTLISTITEM.REVISION,
                                             LRINGREDIENTLISTITEM.INTERNATIONAL );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LRINGREDIENTLISTITEM.PARENTID := NVL( LRINGREDIENTLISTITEM.PARENTID,
                                            0 );

      IF (     (     LRINGREDIENTLISTITEM.HIERARCHICALLEVEL = 1
                 AND LRINGREDIENTLISTITEM.PARENTID <> 0 )
           OR (     LRINGREDIENTLISTITEM.HIERARCHICALLEVEL > 1
                AND LRINGREDIENTLISTITEM.PARENTID < 1 ) )
      THEN
         NULL;
         LNRETVAL :=
            IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                IAPICONSTANTDBERROR.DBERR_INVALIDLEVELPID,
                                                LRINGREDIENTLISTITEM.PARENTID,
                                                LRINGREDIENTLISTITEM.HIERARCHICALLEVEL );
         
         RETURN LNRETVAL;
      END IF;


      
      LNNEWPARENTID := NVL( ANNEWPARENTID, 0 );

      IF (     (     LRINGREDIENTLISTITEM.HIERARCHICALLEVEL = 1
                 AND LNNEWPARENTID <> 0 )
           OR (     LRINGREDIENTLISTITEM.HIERARCHICALLEVEL > 1
                AND LNNEWPARENTID < 1 ) )

      THEN
         NULL;
         LNRETVAL :=
            IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                IAPICONSTANTDBERROR.DBERR_INVALIDLEVELPID,
                                                LNNEWPARENTID,
                                                LRINGREDIENTLISTITEM.HIERARCHICALLEVEL );
         
         RETURN LNRETVAL;
      END IF;
      

      UPDATE SPECIFICATION_ING
         SET ING_SYNONYM = LRINGREDIENTLISTITEM.SYNONYMID,
             QUANTITY = LRINGREDIENTLISTITEM.INGREDIENTQUANTITY,
             ING_LEVEL = LRINGREDIENTLISTITEM.INGREDIENTLEVEL,
             ING_COMMENT = LRINGREDIENTLISTITEM.INGREDIENTCOMMENT,
             INTL = LRINGREDIENTLISTITEM.INTERNATIONAL,
             RECFAC = LRINGREDIENTLISTITEM.RECONSTITUTIONFACTOR,
             HIER_LEVEL = LRINGREDIENTLISTITEM.HIERARCHICALLEVEL,
             
             
             PID = LNNEWPARENTID,
             
             INGDECLARE = LRINGREDIENTLISTITEM.DECLAREFLAG,
             SEQ_NO = DECODE( ANNEWSEQUENCE,
                              NULL, ANSEQUENCENUMBER,
                              ANSEQUENCENUMBER, ANSEQUENCENUMBER,
                              ANNEWSEQUENCE )
       WHERE PART_NO = LRINGREDIENTLISTITEM.PARTNO
         AND REVISION = LRINGREDIENTLISTITEM.REVISION
         AND SECTION_ID = LRINGREDIENTLISTITEM.SECTIONID
         AND SUB_SECTION_ID = LRINGREDIENTLISTITEM.SUBSECTIONID
         AND INGREDIENT = LRINGREDIENTLISTITEM.INGREDIENTID
         AND SEQ_NO = LRINGREDIENTLISTITEM.SEQUENCE
         AND PID = LRINGREDIENTLISTITEM.PARENTID  
         AND HIER_LEVEL = LRINGREDIENTLISTITEM.HIERARCHICALLEVEL;

        
       
        IF (ANSEQUENCENUMBER <> ANNEWSEQUENCE
            AND ANNEWSEQUENCE IS NOT NULL)
        THEN
            UPDATE ITSPECINGDETAIL
            SET INGREDIENT_SEQ_NO = DECODE( ANNEWSEQUENCE,
                              NULL, ANSEQUENCENUMBER,
                              ANSEQUENCENUMBER, ANSEQUENCENUMBER,
                              ANNEWSEQUENCE )
            WHERE PART_NO = LRINGREDIENTLISTITEM.PARTNO
                AND REVISION = LRINGREDIENTLISTITEM.REVISION
                AND SECTION_ID = LRINGREDIENTLISTITEM.SECTIONID
                AND SUB_SECTION_ID =  LRINGREDIENTLISTITEM.SUBSECTIONID
                AND INGREDIENT =  LRINGREDIENTLISTITEM.INGREDIENTID
                AND INGREDIENT_SEQ_NO =  LRINGREDIENTLISTITEM.SEQUENCE;
                
                
        END IF;
        

      
      IF ( LRINGREDIENTLISTITEM.ALTERNATIVELANGUAGEID IS NOT NULL )
      THEN
         BEGIN
            
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 'Try to insert multi-language data',
                                 IAPICONSTANT.INFOLEVEL_3 );

            
            
            OPEN LQSPECINGLANG( LRINGREDIENTLISTITEM.PARTNO,
                                LRINGREDIENTLISTITEM.REVISION,
                                LRINGREDIENTLISTITEM.SECTIONID,
                                LRINGREDIENTLISTITEM.SUBSECTIONID,
                                LRINGREDIENTLISTITEM.INGREDIENTID,
                                LRINGREDIENTLISTITEM.ALTERNATIVELANGUAGEID,
                                LRINGREDIENTLISTITEM.SEQUENCE );

            FETCH LQSPECINGLANG
             INTO LSDUMMY;

            IF LQSPECINGLANG%FOUND
            THEN
               LNSEQNO := LRINGREDIENTLISTITEM.SEQUENCE;
            ELSE
               LNSEQNO := ANNEWSEQUENCE;
            END IF;

            CLOSE LQSPECINGLANG;

            
            
            
            
            
            
            

            INSERT INTO SPECIFICATION_ING_LANG
                        ( PART_NO,
                          REVISION,
                          SECTION_ID,
                          SUB_SECTION_ID,
                          INGREDIENT,
                          LANG_ID,
                          ING_LEVEL,
                          ING_COMMENT,
                          PID,
                          HIER_LEVEL,
                          SEQ_NO )
                 VALUES ( LRINGREDIENTLISTITEM.PARTNO,
                          LRINGREDIENTLISTITEM.REVISION,
                          LRINGREDIENTLISTITEM.SECTIONID,
                          LRINGREDIENTLISTITEM.SUBSECTIONID,
                          LRINGREDIENTLISTITEM.INGREDIENTID,
                          LRINGREDIENTLISTITEM.ALTERNATIVELANGUAGEID,
                          LRINGREDIENTLISTITEM.ALTERNATIVELEVEL,
                          LRINGREDIENTLISTITEM.ALTERNATIVECOMMENT,
                          
                          
                          LNNEWPARENTID,
                          
                          LRINGREDIENTLISTITEM.HIERARCHICALLEVEL,
                          LNSEQNO );
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
               
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    'Update multi-language data',
                                    IAPICONSTANT.INFOLEVEL_3 );

               
               
               
               

               
               
               
               
               

               
               

               IF (     (     LRINGREDIENTLISTITEM.HIERARCHICALLEVEL = 1
                          AND LNNEWPARENTID <> 0 )
                    OR (     LRINGREDIENTLISTITEM.HIERARCHICALLEVEL > 1
                         AND LNNEWPARENTID < 1 ) )
               
               THEN
                  NULL;
                  LNRETVAL :=
                     IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_INVALIDLEVELPID,
                                                         
                                                         
                                                         LNNEWPARENTID,
                                                         
                                                         LRINGREDIENTLISTITEM.HIERARCHICALLEVEL );
                  
                  RETURN LNRETVAL;
               END IF;

               UPDATE SPECIFICATION_ING_LANG
                  SET ING_LEVEL = LRINGREDIENTLISTITEM.ALTERNATIVELEVEL,
                      ING_COMMENT = LRINGREDIENTLISTITEM.ALTERNATIVECOMMENT,
                      HIER_LEVEL = LRINGREDIENTLISTITEM.HIERARCHICALLEVEL,
                      
                      
                      PID = LNNEWPARENTID,
                      
                      SEQ_NO = DECODE( ANNEWSEQUENCE,
                                       NULL, ANSEQUENCENUMBER,
                                       ANSEQUENCENUMBER, ANSEQUENCENUMBER,
                                       ANNEWSEQUENCE )
                WHERE PART_NO = LRINGREDIENTLISTITEM.PARTNO
                  AND REVISION = LRINGREDIENTLISTITEM.REVISION
                  AND SECTION_ID = LRINGREDIENTLISTITEM.SECTIONID
                  AND SUB_SECTION_ID = LRINGREDIENTLISTITEM.SUBSECTIONID
                  AND INGREDIENT = LRINGREDIENTLISTITEM.INGREDIENTID
                  AND LANG_ID = LRINGREDIENTLISTITEM.ALTERNATIVELANGUAGEID
                  AND SEQ_NO = LRINGREDIENTLISTITEM.SEQUENCE;
         END;
      END IF;
      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.LOGHISTORY( LRINGREDIENTLISTITEM.PARTNO,
                                              LRINGREDIENTLISTITEM.REVISION,
                                              LRINGREDIENTLISTITEM.SECTIONID,
                                              LRINGREDIENTLISTITEM.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRINGREDIENTLISTITEM.PARTNO,
                                                LRINGREDIENTLISTITEM.REVISION );

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
   END SAVEINGREDIENTLISTITEMPB;



   
   FUNCTION GETINGREDIENTLISTITEMS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANALTERNATIVELANGUAGEID    IN       IAPITYPE.LANGUAGEID_TYPE DEFAULT NULL,
      AQINGREDIENTLISTITEMS      OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetIngredientListItems';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRINGREDIENTLISTITEMS         IAPITYPE.SPINGREDIENTLISTITEMREC_TYPE;
      LRGETINGREDIENTLISTITEMS      SPINGLISTITEMRECORD_TYPE
         := SPINGLISTITEMRECORD_TYPE( NULL,
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
                                      
                                      
                                      
                                      
                                      NULL);
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'si.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', si.revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', si.section_id '
            || IAPICONSTANTCOLUMN.SECTIONIDCOL
            || ', si.sub_section_id '
            || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
            || ', si.ingredient '
            || IAPICONSTANTCOLUMN.INGREDIENTIDCOL
            || ', si.ingredient_rev '
            || IAPICONSTANTCOLUMN.INGREDIENTREVISIONCOL
            || ', si.quantity '
            || IAPICONSTANTCOLUMN.INGREDIENTQUANTITYCOL
            || ', si.ing_level '
            || IAPICONSTANTCOLUMN.INGREDIENTLEVELCOL
            || ', si.ing_comment '
            || IAPICONSTANTCOLUMN.INGREDIENTCOMMENTCOL
            || ', si.intl '
            || IAPICONSTANTCOLUMN.INTERNATIONALCOL
            || ', si.seq_no '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ', si.pid '
            || IAPICONSTANTCOLUMN.PARENTIDCOL
            || ', si.hier_level '
            || IAPICONSTANTCOLUMN.HIERARCHICALLEVELCOL
            || ', si.recfac '
            || IAPICONSTANTCOLUMN.RECONSTITUTIONFACTORCOL
            || ', si.ing_synonym '
            || IAPICONSTANTCOLUMN.SYNONYMIDCOL
            || ', si.ing_synonym_rev '
            || IAPICONSTANTCOLUMN.SYNONYMREVISIONCOL
            || ', sil.lang_id '
            || IAPICONSTANTCOLUMN.ALTERNATIVELANGUAGEIDCOL
            || ', sil.ing_level '
            || IAPICONSTANTCOLUMN.ALTERNATIVELEVELCOL
            || ', sil.ing_comment '
            || IAPICONSTANTCOLUMN.ALTERNATIVECOMMENTCOL
            || ', f_ing_descr(:AlternativeLanguageId'
            || ', si.ingredient, si.ingredient_rev) '
            || IAPICONSTANTCOLUMN.INGREDIENTCOL
            || ', f_syn_descr(:AlternativeLanguageId'
            
            
            || ', si.ing_synonym, NVL(si.ing_synonym_rev, 0)) '
            
            || IAPICONSTANTCOLUMN.SYNONYMNAMECOL
            || ', DECODE(:AlternativeLanguageId'
            || ', 1, 0, -1, 0, iapiSpecificationIngrdientList.IsIngredientDataTranslated(si.part_no, si.revision, si.section_id, si.sub_section_id, si.ingredient, si.pid, si.hier_level))'
            || IAPICONSTANTCOLUMN.TRANSLATEDCOL
            || ', si.ingdeclare '
            
            || IAPICONSTANTCOLUMN.DECLARECOL; 
            
            
            
            
            
            
      LSFROM                        IAPITYPE.STRING_TYPE := 'specification_ing si, specification_ing_lang sil';
   BEGIN
      
      
      
      
      
      IF ( AQINGREDIENTLISTITEMS%ISOPEN )
      THEN
         CLOSE AQINGREDIENTLISTITEMS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE si.part_no = NULL'
                   || '   AND si.part_no = sil.part_no ';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQINGREDIENTLISTITEMS FOR LSSQLNULL USING NVL( ANALTERNATIVELANGUAGEID,
                                                          -1 ),
      NVL( ANALTERNATIVELANGUAGEID,
           -1 ),
      NVL( ANALTERNATIVELANGUAGEID,
           -1 );

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      GTINGREDIENTLISTITEMS.DELETE;
      LRINGREDIENTLISTITEMS.PARTNO := ASPARTNO;
      LRINGREDIENTLISTITEMS.REVISION := ANREVISION;
      LRINGREDIENTLISTITEMS.SECTIONID := ANSECTIONID;
      LRINGREDIENTLISTITEMS.SUBSECTIONID := ANSUBSECTIONID;
      LRINGREDIENTLISTITEMS.ALTERNATIVELANGUAGEID := ANALTERNATIVELANGUAGEID;
      GTINGREDIENTLISTITEMS( 0 ) := LRINGREDIENTLISTITEMS;
      
      
      
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

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

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

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=
            'SELECT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE si.part_no = :PartNo '
         || ' AND si.revision = :Revision '
         || ' AND si.section_id = :SectionId '
         || ' AND si.sub_section_id = :SubSectionId '
         || ' AND si.part_no = sil.part_no(+) '
         || ' AND si.revision = sil.revision(+) '
         || ' AND si.section_id = sil.section_id(+) '
         || ' AND si.sub_section_id = sil.sub_section_id(+) '
         || ' AND si.ingredient = sil.ingredient(+) '
         || ' AND si.seq_no = sil.seq_no(+) '
         || ' AND sil.lang_id(+) = :AlternativeLanguageId '
         || ' ORDER BY '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ','
         || IAPICONSTANTCOLUMN.HIERARCHICALLEVELCOL;
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQINGREDIENTLISTITEMS%ISOPEN )
      THEN
         CLOSE AQINGREDIENTLISTITEMS;
      END IF;

      
      OPEN AQINGREDIENTLISTITEMS FOR LSSQL
      USING NVL( ANALTERNATIVELANGUAGEID,
                 -1 ),
            NVL( ANALTERNATIVELANGUAGEID,
                 -1 ),
            NVL( ANALTERNATIVELANGUAGEID,
                 -1 ),
            ASPARTNO,
            ANREVISION,
            ANSECTIONID,
            ANSUBSECTIONID,
            NVL( ANALTERNATIVELANGUAGEID,
                 -1 );

      
       
      

      
      
      
      GTGETINGREDIENTLISTITEMS.DELETE;

      LOOP
         LRINGREDIENTLISTITEMS := NULL;

         FETCH AQINGREDIENTLISTITEMS
          INTO LRINGREDIENTLISTITEMS;

         EXIT WHEN AQINGREDIENTLISTITEMS%NOTFOUND;
         LRGETINGREDIENTLISTITEMS.PARTNO := LRINGREDIENTLISTITEMS.PARTNO;
         LRGETINGREDIENTLISTITEMS.REVISION := LRINGREDIENTLISTITEMS.REVISION;
         LRGETINGREDIENTLISTITEMS.SECTIONID := LRINGREDIENTLISTITEMS.SECTIONID;
         LRGETINGREDIENTLISTITEMS.SUBSECTIONID := LRINGREDIENTLISTITEMS.SUBSECTIONID;
         LRGETINGREDIENTLISTITEMS.INGREDIENTID := LRINGREDIENTLISTITEMS.INGREDIENTID;
         LRGETINGREDIENTLISTITEMS.INGREDIENTREVISION := LRINGREDIENTLISTITEMS.INGREDIENTREVISION;
         LRGETINGREDIENTLISTITEMS.INGREDIENTQUANTITY := LRINGREDIENTLISTITEMS.INGREDIENTQUANTITY;
         LRGETINGREDIENTLISTITEMS.INGREDIENTLEVEL := LRINGREDIENTLISTITEMS.INGREDIENTLEVEL;
         LRGETINGREDIENTLISTITEMS.INGREDIENTCOMMENT := LRINGREDIENTLISTITEMS.INGREDIENTCOMMENT;
         LRGETINGREDIENTLISTITEMS.INTERNATIONAL := LRINGREDIENTLISTITEMS.INTERNATIONAL;
         LRGETINGREDIENTLISTITEMS.SEQUENCE := LRINGREDIENTLISTITEMS.SEQUENCE;
         LRGETINGREDIENTLISTITEMS.PARENTID := LRINGREDIENTLISTITEMS.PARENTID;
         LRGETINGREDIENTLISTITEMS.HIERARCHICALLEVEL := LRINGREDIENTLISTITEMS.HIERARCHICALLEVEL;
         LRGETINGREDIENTLISTITEMS.RECONSTITUTIONFACTOR := LRINGREDIENTLISTITEMS.RECONSTITUTIONFACTOR;
         LRGETINGREDIENTLISTITEMS.SYNONYMID := LRINGREDIENTLISTITEMS.SYNONYMID;
         LRGETINGREDIENTLISTITEMS.SYNONYMREVISION := LRINGREDIENTLISTITEMS.SYNONYMREVISION;
         LRGETINGREDIENTLISTITEMS.ALTERNATIVELANGUAGEID := LRINGREDIENTLISTITEMS.ALTERNATIVELANGUAGEID;
         LRGETINGREDIENTLISTITEMS.ALTERNATIVELEVEL := LRINGREDIENTLISTITEMS.ALTERNATIVELEVEL;
         LRGETINGREDIENTLISTITEMS.ALTERNATIVECOMMENT := LRINGREDIENTLISTITEMS.ALTERNATIVECOMMENT;
         LRGETINGREDIENTLISTITEMS.INGREDIENT := LRINGREDIENTLISTITEMS.INGREDIENT;
         LRGETINGREDIENTLISTITEMS.SYNONYMNAME := LRINGREDIENTLISTITEMS.SYNONYMNAME;
         LRGETINGREDIENTLISTITEMS.TRANSLATED := LRINGREDIENTLISTITEMS.TRANSLATED;
         LRGETINGREDIENTLISTITEMS.DECLAREFLAG := LRINGREDIENTLISTITEMS.DECLAREFLAG;
         LRGETINGREDIENTLISTITEMS.ROWINDEX := LRINGREDIENTLISTITEMS.ROWINDEX;
         GTGETINGREDIENTLISTITEMS.EXTEND;
         GTGETINGREDIENTLISTITEMS( GTGETINGREDIENTLISTITEMS.COUNT ) := LRGETINGREDIENTLISTITEMS;
      END LOOP;

      CLOSE AQINGREDIENTLISTITEMS;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQINGREDIENTLISTITEMS FOR LSSQLNULL USING NVL( ANALTERNATIVELANGUAGEID,
                                                          -1 ),
      NVL( ANALTERNATIVELANGUAGEID,
           -1 ),
      NVL( ANALTERNATIVELANGUAGEID,
           -1 );

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Post-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
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
         || ', SUBSECTIONID '
         || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
         || ', INGREDIENTID '
         || IAPICONSTANTCOLUMN.INGREDIENTIDCOL
         || ', INGREDIENTREVISION '
         || IAPICONSTANTCOLUMN.INGREDIENTREVISIONCOL
         || ', INGREDIENTQUANTITY '
         || IAPICONSTANTCOLUMN.INGREDIENTQUANTITYCOL
         || ', INGREDIENTLEVEL  '
         || IAPICONSTANTCOLUMN.INGREDIENTLEVELCOL
         || ', INGREDIENTCOMMENT '
         || IAPICONSTANTCOLUMN.INGREDIENTCOMMENTCOL
         || ', INTERNATIONAL '
         || IAPICONSTANTCOLUMN.INTERNATIONALCOL
         || ', SEQUENCE '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ', PARENTID '
         || IAPICONSTANTCOLUMN.PARENTIDCOL
         || ', HIERARCHICALLEVEL '
         || IAPICONSTANTCOLUMN.HIERARCHICALLEVELCOL
         || ', RECONSTITUTIONFACTOR '
         || IAPICONSTANTCOLUMN.RECONSTITUTIONFACTORCOL
         || ', SYNONYMID '
         || IAPICONSTANTCOLUMN.SYNONYMIDCOL
         || ', SYNONYMREVISION '
         || IAPICONSTANTCOLUMN.SYNONYMREVISIONCOL
         || ', ALTERNATIVELANGUAGEID '
         || IAPICONSTANTCOLUMN.ALTERNATIVELANGUAGEIDCOL
         || ', ALTERNATIVELEVEL '
         || IAPICONSTANTCOLUMN.ALTERNATIVELEVELCOL
         || ', ALTERNATIVECOMMENT '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOMMENTCOL
         || ', INGREDIENT '
         || IAPICONSTANTCOLUMN.INGREDIENTCOL
         || ', SYNONYMNAME '
         || IAPICONSTANTCOLUMN.SYNONYMNAMECOL
         || ', TRANSLATED '
         || IAPICONSTANTCOLUMN.TRANSLATEDCOL
         || ', DECLAREFLAG '
         || IAPICONSTANTCOLUMN.DECLARECOL
         || ', ROWINDEX '
         || IAPICONSTANTCOLUMN.ROWINDEXCOL;
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM TABLE( CAST( :gtGetIngredientListItems AS SpIngListItemTable_Type ) ) ';

      
      IF ( AQINGREDIENTLISTITEMS%ISOPEN )
      THEN
         CLOSE AQINGREDIENTLISTITEMS;
      END IF;

      
      OPEN AQINGREDIENTLISTITEMS FOR LSSQL USING GTGETINGREDIENTLISTITEMS;

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
   END GETINGREDIENTLISTITEMS;




FUNCTION GETINGREDIENTLISTITEMSPB(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANALTERNATIVELANGUAGEID    IN       IAPITYPE.LANGUAGEID_TYPE DEFAULT NULL,
      AQINGREDIENTLISTITEMS      OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetIngredientListItemsPb';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      
      LRINGREDIENTLISTITEMSPB         IAPITYPE.SPINGREDIENTLISTITEMRECPB_TYPE;
      
      LRGETINGREDIENTLISTITEMSPB      SPINGLISTITEMRECORDPB_TYPE
         := SPINGLISTITEMRECORDPB_TYPE( NULL,
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
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'si.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', si.revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', si.section_id '
            || IAPICONSTANTCOLUMN.SECTIONIDCOL
            || ', si.sub_section_id '
            || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
            || ', si.ingredient '
            || IAPICONSTANTCOLUMN.INGREDIENTIDCOL
            || ', si.ingredient_rev '
            || IAPICONSTANTCOLUMN.INGREDIENTREVISIONCOL
            || ', si.quantity '
            || IAPICONSTANTCOLUMN.INGREDIENTQUANTITYCOL
            || ', si.ing_level '
            || IAPICONSTANTCOLUMN.INGREDIENTLEVELCOL
            || ', si.ing_comment '
            || IAPICONSTANTCOLUMN.INGREDIENTCOMMENTCOL
            || ', si.intl '
            || IAPICONSTANTCOLUMN.INTERNATIONALCOL
            || ', si.seq_no '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ', si.pid '
            || IAPICONSTANTCOLUMN.PARENTIDCOL
            || ', si.hier_level '
            || IAPICONSTANTCOLUMN.HIERARCHICALLEVELCOL
            || ', si.recfac '
            || IAPICONSTANTCOLUMN.RECONSTITUTIONFACTORCOL
            || ', si.ing_synonym '
            || IAPICONSTANTCOLUMN.SYNONYMIDCOL
            || ', si.ing_synonym_rev '
            || IAPICONSTANTCOLUMN.SYNONYMREVISIONCOL
            || ', sil.lang_id '
            || IAPICONSTANTCOLUMN.ALTERNATIVELANGUAGEIDCOL
            || ', sil.ing_level '
            || IAPICONSTANTCOLUMN.ALTERNATIVELEVELCOL
            || ', sil.ing_comment '
            || IAPICONSTANTCOLUMN.ALTERNATIVECOMMENTCOL
            || ', f_ing_descr(:AlternativeLanguageId'
            || ', si.ingredient, si.ingredient_rev) '
            || IAPICONSTANTCOLUMN.INGREDIENTCOL
            || ', f_syn_descr(:AlternativeLanguageId'
            
            
            || ', si.ing_synonym, NVL(si.ing_synonym_rev, 0)) '
            
            || IAPICONSTANTCOLUMN.SYNONYMNAMECOL
            || ', DECODE(:AlternativeLanguageId'
            || ', 1, 0, -1, 0, iapiSpecificationIngrdientList.IsIngredientDataTranslated(si.part_no, si.revision, si.section_id, si.sub_section_id, si.ingredient, si.pid, si.hier_level))'
            || IAPICONSTANTCOLUMN.TRANSLATEDCOL
            || ', si.ingdeclare '
            
            
            || IAPICONSTANTCOLUMN.DECLARECOL
            || ', iapiSpecificationIngrdientList.GetPidList(si.part_no, si.revision, si.section_id, si.sub_section_id, si.seq_no) '
            || IAPICONSTANTCOLUMN.PIDLISTCOL;
            
      LSFROM                        IAPITYPE.STRING_TYPE := 'specification_ing si, specification_ing_lang sil';
   BEGIN
      
      
      
      
      
      IF ( AQINGREDIENTLISTITEMS%ISOPEN )
      THEN
         CLOSE AQINGREDIENTLISTITEMS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE si.part_no = NULL'
                   || '   AND si.part_no = sil.part_no ';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQINGREDIENTLISTITEMS FOR LSSQLNULL USING NVL( ANALTERNATIVELANGUAGEID,
                                                          -1 ),
      NVL( ANALTERNATIVELANGUAGEID,
           -1 ),
      NVL( ANALTERNATIVELANGUAGEID,
           -1 );

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      GTINGREDIENTLISTITEMSPB.DELETE;
      LRINGREDIENTLISTITEMSPB.PARTNO := ASPARTNO;
      LRINGREDIENTLISTITEMSPB.REVISION := ANREVISION;
      LRINGREDIENTLISTITEMSPB.SECTIONID := ANSECTIONID;
      LRINGREDIENTLISTITEMSPB.SUBSECTIONID := ANSUBSECTIONID;
      LRINGREDIENTLISTITEMSPB.ALTERNATIVELANGUAGEID := ANALTERNATIVELANGUAGEID;
      GTINGREDIENTLISTITEMSPB( 0 ) := LRINGREDIENTLISTITEMSPB;
      
      
      
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

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
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

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=
            'SELECT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE si.part_no = :PartNo '
         || ' AND si.revision = :Revision '
         || ' AND si.section_id = :SectionId '
         || ' AND si.sub_section_id = :SubSectionId '
         || ' AND si.part_no = sil.part_no(+) '
         || ' AND si.revision = sil.revision(+) '
         || ' AND si.section_id = sil.section_id(+) '
         || ' AND si.sub_section_id = sil.sub_section_id(+) '
         || ' AND si.ingredient = sil.ingredient(+) '
         || ' AND si.seq_no = sil.seq_no(+) '
         || ' AND sil.lang_id(+) = :AlternativeLanguageId '
         || ' ORDER BY '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ','
         || IAPICONSTANTCOLUMN.HIERARCHICALLEVELCOL;
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQINGREDIENTLISTITEMS%ISOPEN )
      THEN
         CLOSE AQINGREDIENTLISTITEMS;
      END IF;

      
      OPEN AQINGREDIENTLISTITEMS FOR LSSQL
      USING NVL( ANALTERNATIVELANGUAGEID,
                 -1 ),
            NVL( ANALTERNATIVELANGUAGEID,
                 -1 ),
            NVL( ANALTERNATIVELANGUAGEID,
                 -1 ),
            ASPARTNO,
            ANREVISION,
            ANSECTIONID,
            ANSUBSECTIONID,
            NVL( ANALTERNATIVELANGUAGEID,
                 -1 );

      
       
      

      
      
      
      GTGETINGREDIENTLISTITEMSPB.DELETE;

      LOOP
         LRINGREDIENTLISTITEMSPB := NULL;

         FETCH AQINGREDIENTLISTITEMS
          INTO LRINGREDIENTLISTITEMSPB;

         EXIT WHEN AQINGREDIENTLISTITEMS%NOTFOUND;
         LRGETINGREDIENTLISTITEMSPB.PARTNO := LRINGREDIENTLISTITEMSPB.PARTNO;
         LRGETINGREDIENTLISTITEMSPB.REVISION := LRINGREDIENTLISTITEMSPB.REVISION;
         LRGETINGREDIENTLISTITEMSPB.SECTIONID := LRINGREDIENTLISTITEMSPB.SECTIONID;
         LRGETINGREDIENTLISTITEMSPB.SUBSECTIONID := LRINGREDIENTLISTITEMSPB.SUBSECTIONID;
         LRGETINGREDIENTLISTITEMSPB.INGREDIENTID := LRINGREDIENTLISTITEMSPB.INGREDIENTID;
         LRGETINGREDIENTLISTITEMSPB.INGREDIENTREVISION := LRINGREDIENTLISTITEMSPB.INGREDIENTREVISION;
         LRGETINGREDIENTLISTITEMSPB.INGREDIENTQUANTITY := LRINGREDIENTLISTITEMSPB.INGREDIENTQUANTITY;
         LRGETINGREDIENTLISTITEMSPB.INGREDIENTLEVEL := LRINGREDIENTLISTITEMSPB.INGREDIENTLEVEL;
         LRGETINGREDIENTLISTITEMSPB.INGREDIENTCOMMENT := LRINGREDIENTLISTITEMSPB.INGREDIENTCOMMENT;
         LRGETINGREDIENTLISTITEMSPB.INTERNATIONAL := LRINGREDIENTLISTITEMSPB.INTERNATIONAL;
         LRGETINGREDIENTLISTITEMSPB.SEQUENCE := LRINGREDIENTLISTITEMSPB.SEQUENCE;
         LRGETINGREDIENTLISTITEMSPB.PARENTID := LRINGREDIENTLISTITEMSPB.PARENTID;
         LRGETINGREDIENTLISTITEMSPB.HIERARCHICALLEVEL := LRINGREDIENTLISTITEMSPB.HIERARCHICALLEVEL;
         LRGETINGREDIENTLISTITEMSPB.RECONSTITUTIONFACTOR := LRINGREDIENTLISTITEMSPB.RECONSTITUTIONFACTOR;
         LRGETINGREDIENTLISTITEMSPB.SYNONYMID := LRINGREDIENTLISTITEMSPB.SYNONYMID;
         LRGETINGREDIENTLISTITEMSPB.SYNONYMREVISION := LRINGREDIENTLISTITEMSPB.SYNONYMREVISION;
         LRGETINGREDIENTLISTITEMSPB.ALTERNATIVELANGUAGEID := LRINGREDIENTLISTITEMSPB.ALTERNATIVELANGUAGEID;
         LRGETINGREDIENTLISTITEMSPB.ALTERNATIVELEVEL := LRINGREDIENTLISTITEMSPB.ALTERNATIVELEVEL;
         LRGETINGREDIENTLISTITEMSPB.ALTERNATIVECOMMENT := LRINGREDIENTLISTITEMSPB.ALTERNATIVECOMMENT;
         LRGETINGREDIENTLISTITEMSPB.INGREDIENT := LRINGREDIENTLISTITEMSPB.INGREDIENT;
         LRGETINGREDIENTLISTITEMSPB.SYNONYMNAME := LRINGREDIENTLISTITEMSPB.SYNONYMNAME;
         LRGETINGREDIENTLISTITEMSPB.TRANSLATED := LRINGREDIENTLISTITEMSPB.TRANSLATED;
         LRGETINGREDIENTLISTITEMSPB.DECLAREFLAG := LRINGREDIENTLISTITEMSPB.DECLAREFLAG;
         
         LRGETINGREDIENTLISTITEMSPB.PIDLIST := LRINGREDIENTLISTITEMSPB.PIDLIST;
         
         LRGETINGREDIENTLISTITEMSPB.ROWINDEX := LRINGREDIENTLISTITEMSPB.ROWINDEX;
         GTGETINGREDIENTLISTITEMSPB.EXTEND;
         GTGETINGREDIENTLISTITEMSPB( GTGETINGREDIENTLISTITEMSPB.COUNT ) := LRGETINGREDIENTLISTITEMSPB;
      END LOOP;

      CLOSE AQINGREDIENTLISTITEMS;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQINGREDIENTLISTITEMS FOR LSSQLNULL USING NVL( ANALTERNATIVELANGUAGEID,
                                                          -1 ),
      NVL( ANALTERNATIVELANGUAGEID,
           -1 ),
      NVL( ANALTERNATIVELANGUAGEID,
           -1 );

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Post-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
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
         || ', SUBSECTIONID '
         || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
         || ', INGREDIENTID '
         || IAPICONSTANTCOLUMN.INGREDIENTIDCOL
         || ', INGREDIENTREVISION '
         || IAPICONSTANTCOLUMN.INGREDIENTREVISIONCOL
         || ', INGREDIENTQUANTITY '
         || IAPICONSTANTCOLUMN.INGREDIENTQUANTITYCOL
         || ', INGREDIENTLEVEL  '
         || IAPICONSTANTCOLUMN.INGREDIENTLEVELCOL
         || ', INGREDIENTCOMMENT '
         || IAPICONSTANTCOLUMN.INGREDIENTCOMMENTCOL
         || ', INTERNATIONAL '
         || IAPICONSTANTCOLUMN.INTERNATIONALCOL
         || ', SEQUENCE '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ', PARENTID '
         || IAPICONSTANTCOLUMN.PARENTIDCOL
         || ', HIERARCHICALLEVEL '
         || IAPICONSTANTCOLUMN.HIERARCHICALLEVELCOL
         || ', RECONSTITUTIONFACTOR '
         || IAPICONSTANTCOLUMN.RECONSTITUTIONFACTORCOL
         || ', SYNONYMID '
         || IAPICONSTANTCOLUMN.SYNONYMIDCOL
         || ', SYNONYMREVISION '
         || IAPICONSTANTCOLUMN.SYNONYMREVISIONCOL
         || ', ALTERNATIVELANGUAGEID '
         || IAPICONSTANTCOLUMN.ALTERNATIVELANGUAGEIDCOL
         || ', ALTERNATIVELEVEL '
         || IAPICONSTANTCOLUMN.ALTERNATIVELEVELCOL
         || ', ALTERNATIVECOMMENT '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOMMENTCOL
         || ', INGREDIENT '
         || IAPICONSTANTCOLUMN.INGREDIENTCOL
         || ', SYNONYMNAME '
         || IAPICONSTANTCOLUMN.SYNONYMNAMECOL
         || ', TRANSLATED '
         || IAPICONSTANTCOLUMN.TRANSLATEDCOL
         || ', DECLAREFLAG '
         || IAPICONSTANTCOLUMN.DECLARECOL
         
         || ', PIDLIST '
         || IAPICONSTANTCOLUMN.PIDLISTCOL
         
         || ', ROWINDEX '
         || IAPICONSTANTCOLUMN.ROWINDEXCOL;
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM TABLE( CAST( :gtGetIngredientListItemsPb AS SpIngListItemTablePb_Type ) ) ';

      
      IF ( AQINGREDIENTLISTITEMS%ISOPEN )
      THEN
         CLOSE AQINGREDIENTLISTITEMS;
      END IF;

      
      OPEN AQINGREDIENTLISTITEMS FOR LSSQL USING GTGETINGREDIENTLISTITEMSPB;

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
   END GETINGREDIENTLISTITEMSPB;



   
   FUNCTION ADDCHEMICALLIST(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddChemicalList';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      LNRETVAL := ADDLIST( ASPARTNO,
                                                          ANREVISION,
                                                          ANSECTIONID,
                                                          ANSUBSECTIONID,
                                                          LSMETHOD,
                                                          AFHANDLE,
                                                          AQINFO,
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
   END ADDCHEMICALLIST;

   
   FUNCTION ADDINGREDIENTLIST(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddIngredientList';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      LNRETVAL := ADDLIST( ASPARTNO,
                                                          ANREVISION,
                                                          ANSECTIONID,
                                                          ANSUBSECTIONID,
                                                          LSMETHOD,
                                                          AFHANDLE,
                                                          AQINFO,
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
   END ADDINGREDIENTLIST;

   
   FUNCTION REMOVECHEMICALLIST(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveChemicalList';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      LNRETVAL :=
                 REMOVELIST( ASPARTNO,
                                                            ANREVISION,
                                                            ANSECTIONID,
                                                            ANSUBSECTIONID,
                                                            LSMETHOD,
                                                            AFHANDLE,
                                                            AQINFO,
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
   END REMOVECHEMICALLIST;

   
   FUNCTION REMOVEINGREDIENTLIST(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveIngredientList';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      LNRETVAL :=
                 REMOVELIST( ASPARTNO,
                                                            ANREVISION,
                                                            ANSECTIONID,
                                                            ANSUBSECTIONID,
                                                            LSMETHOD,
                                                            AFHANDLE,
                                                            AQINFO,
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
   END REMOVEINGREDIENTLIST;

   
   FUNCTION ADDCHEMICALLISTITEM(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANINGREDIENTID             IN       IAPITYPE.ID_TYPE,
      ANSEQUENCENUMBER           IN       IAPITYPE.INGREDIENTSEQUENCENUMBER_TYPE,
      ANSYNONYMID                IN       IAPITYPE.ID_TYPE,
      ANQUANTITY                 IN       IAPITYPE.INGREDIENTQUANTITY_TYPE,
      ASLEVEL                    IN       IAPITYPE.INGREDIENTLEVEL_TYPE,
      ASCOMMENT                  IN       IAPITYPE.INGREDIENTCOMMENT_TYPE,
      ANDECLARE                  IN       IAPITYPE.BOOLEAN_TYPE,
      ANACTIVEINGREDIENT         IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddChemicalListItem';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRCHEMICALLISTITEM            IAPITYPE.SPCHEMICALLISTITEMREC_TYPE;
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
      GTCHEMICALLISTITEMS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRCHEMICALLISTITEM.PARTNO := ASPARTNO;
      LRCHEMICALLISTITEM.REVISION := ANREVISION;
      LRCHEMICALLISTITEM.SECTIONID := ANSECTIONID;
      LRCHEMICALLISTITEM.SUBSECTIONID := ANSUBSECTIONID;
      LRCHEMICALLISTITEM.INGREDIENTID := ANINGREDIENTID;
      LRCHEMICALLISTITEM.SEQUENCE := ANSEQUENCENUMBER;
      LRCHEMICALLISTITEM.SYNONYMID := ANSYNONYMID;
      LRCHEMICALLISTITEM.INGREDIENTQUANTITY := ANQUANTITY;
      LRCHEMICALLISTITEM.INGREDIENTLEVEL := ASLEVEL;
      LRCHEMICALLISTITEM.INGREDIENTCOMMENT := ASCOMMENT;
      LRCHEMICALLISTITEM.ACTIVEINGREDIENT := ANACTIVEINGREDIENT;
      LRCHEMICALLISTITEM.DECLAREFLAG := ANDECLARE;
      GTCHEMICALLISTITEMS( 0 ) := LRCHEMICALLISTITEM;
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
      
      
      
      
      
      
      
      
      CHECKBASICCHEMLISTITEMPARAMS( LRCHEMICALLISTITEM );

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

      
      LNRETVAL := IAPISPECIFICATIONACCESS.GETMODIFIABLEACCESS( LRCHEMICALLISTITEM.PARTNO,
                                                               LRCHEMICALLISTITEM.REVISION,
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
         IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( LRCHEMICALLISTITEM.PARTNO,
                                                      LRCHEMICALLISTITEM.REVISION,
                                                      LRCHEMICALLISTITEM.SECTIONID,
                                                      LRCHEMICALLISTITEM.SUBSECTIONID,
                                                      IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST,
                                                      0 );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL :=
         EXISTITEMINLIST( LRCHEMICALLISTITEM.PARTNO,
                                                         LRCHEMICALLISTITEM.REVISION,
                                                         LRCHEMICALLISTITEM.SECTIONID,
                                                         LRCHEMICALLISTITEM.SUBSECTIONID,
                                                         LRCHEMICALLISTITEM.INGREDIENTID,
                                                         LRCHEMICALLISTITEM.SEQUENCE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SPITEMNOTFOUND )
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
      
      LNRETVAL := IAPISPECIFICATION.GETMODE( LRCHEMICALLISTITEM.PARTNO,
                                             LRCHEMICALLISTITEM.REVISION,
                                             LRCHEMICALLISTITEM.INTERNATIONAL );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      INSERT INTO SPECIFICATION_ING
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID,
                    INGREDIENT,
                    ING_SYNONYM,
                    QUANTITY,
                    ING_LEVEL,
                    ING_COMMENT,
                    INTL,
                    SEQ_NO,
                    ACTIV_IND,
                    INGDECLARE )
           VALUES ( LRCHEMICALLISTITEM.PARTNO,
                    LRCHEMICALLISTITEM.REVISION,
                    LRCHEMICALLISTITEM.SECTIONID,
                    LRCHEMICALLISTITEM.SUBSECTIONID,
                    LRCHEMICALLISTITEM.INGREDIENTID,
                    LRCHEMICALLISTITEM.SYNONYMID,
                    LRCHEMICALLISTITEM.INGREDIENTQUANTITY,
                    LRCHEMICALLISTITEM.INGREDIENTLEVEL,
                    LRCHEMICALLISTITEM.INGREDIENTCOMMENT,
                    LRCHEMICALLISTITEM.INTERNATIONAL,
                    LRCHEMICALLISTITEM.SEQUENCE,
                    LRCHEMICALLISTITEM.ACTIVEINGREDIENT,
                    LRCHEMICALLISTITEM.DECLAREFLAG );

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.LOGHISTORY( LRCHEMICALLISTITEM.PARTNO,
                                              LRCHEMICALLISTITEM.REVISION,
                                              LRCHEMICALLISTITEM.SECTIONID,
                                              LRCHEMICALLISTITEM.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRCHEMICALLISTITEM.PARTNO,
                                                LRCHEMICALLISTITEM.REVISION );

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
   END ADDCHEMICALLISTITEM;

   
   FUNCTION REMOVECHEMICALLISTITEM(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANINGREDIENTID             IN       IAPITYPE.ID_TYPE,
      ANSEQUENCENUMBER           IN       IAPITYPE.INGREDIENTSEQUENCENUMBER_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveChemicalListItem';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      LNRETVAL :=
         REMOVELISTITEM( ASPARTNO,
                                                        ANREVISION,
                                                        ANSECTIONID,
                                                        ANSUBSECTIONID,
                                                        ANINGREDIENTID,
                                                        ANSEQUENCENUMBER,
                                                        LSMETHOD,
                                                        AFHANDLE,
                                                        AQINFO,
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
   END REMOVECHEMICALLISTITEM;

   
   FUNCTION REMOVEINGREDIENTLISTITEM(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANINGREDIENTID             IN       IAPITYPE.ID_TYPE,
      ANSEQUENCENUMBER           IN       IAPITYPE.INGREDIENTSEQUENCENUMBER_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveIngredientListItem';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      LNRETVAL :=
         REMOVELISTITEM( ASPARTNO,
                                                        ANREVISION,
                                                        ANSECTIONID,
                                                        ANSUBSECTIONID,
                                                        ANINGREDIENTID,
                                                        ANSEQUENCENUMBER,
                                                        LSMETHOD,
                                                        AFHANDLE,
                                                        AQINFO,
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
   END REMOVEINGREDIENTLISTITEM;

   
   FUNCTION SAVECHEMICALLISTITEM(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANINGREDIENTID             IN       IAPITYPE.ID_TYPE,
      ANSEQUENCENUMBER           IN       IAPITYPE.INGREDIENTSEQUENCENUMBER_TYPE,
      ANSYNONYMID                IN       IAPITYPE.ID_TYPE,
      ANQUANTITY                 IN       IAPITYPE.INGREDIENTQUANTITY_TYPE,
      ASLEVEL                    IN       IAPITYPE.INGREDIENTLEVEL_TYPE,
      ASCOMMENT                  IN       IAPITYPE.INGREDIENTCOMMENT_TYPE,
      ANDECLARE                  IN       IAPITYPE.BOOLEAN_TYPE,
      ANNEWSEQUENCE              IN       IAPITYPE.INGREDIENTSEQUENCENUMBER_TYPE DEFAULT NULL,
      ANACTIVEINGREDIENT         IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANALTERNATIVELANGUAGEID    IN       IAPITYPE.LANGUAGEID_TYPE DEFAULT NULL,
      ASALTERNATIVELEVEL         IN       IAPITYPE.INGREDIENTLEVEL_TYPE DEFAULT NULL,
      ASALTERNATIVECOMMENT       IN       IAPITYPE.INGREDIENTCOMMENT_TYPE DEFAULT NULL,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      CURSOR LQSPECINGLANG(
         ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
         ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
         ANSECTIONID                IN       IAPITYPE.ID_TYPE,
         ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
         ANINGREDIENT               IN       IAPITYPE.ID_TYPE,
         ANLANGID                   IN       IAPITYPE.LANGUAGEID_TYPE,
         ANSEQ                      IN       IAPITYPE.INGREDIENTSEQUENCENUMBER_TYPE )
      IS
         SELECT 'X'
           FROM SPECIFICATION_ING_LANG
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND INGREDIENT = ANINGREDIENT
            AND LANG_ID = ANLANGID
            AND SEQ_NO = ANSEQ;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveChemicalListItem';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRCHEMICALLISTITEM            IAPITYPE.SPCHEMICALLISTITEMREC_TYPE;
      LNMULTILANGUAGE               IAPITYPE.BOOLEAN_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSDUMMY                       VARCHAR2( 1 );
      LNSEQNO                       IAPITYPE.INGREDIENTSEQUENCENUMBER_TYPE;
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
      GTCHEMICALLISTITEMS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRCHEMICALLISTITEM.PARTNO := ASPARTNO;
      LRCHEMICALLISTITEM.REVISION := ANREVISION;
      LRCHEMICALLISTITEM.SECTIONID := ANSECTIONID;
      LRCHEMICALLISTITEM.SUBSECTIONID := ANSUBSECTIONID;
      LRCHEMICALLISTITEM.INGREDIENTID := ANINGREDIENTID;
      LRCHEMICALLISTITEM.SEQUENCE := ANSEQUENCENUMBER;
      LRCHEMICALLISTITEM.SYNONYMID := ANSYNONYMID;
      LRCHEMICALLISTITEM.INGREDIENTQUANTITY := ANQUANTITY;
      LRCHEMICALLISTITEM.INGREDIENTLEVEL := ASLEVEL;
      LRCHEMICALLISTITEM.INGREDIENTCOMMENT := ASCOMMENT;
      LRCHEMICALLISTITEM.ACTIVEINGREDIENT := ANACTIVEINGREDIENT;
      LRCHEMICALLISTITEM.ALTERNATIVELANGUAGEID := ANALTERNATIVELANGUAGEID;
      LRCHEMICALLISTITEM.ALTERNATIVELEVEL := ASALTERNATIVELEVEL;
      LRCHEMICALLISTITEM.ALTERNATIVECOMMENT := ASALTERNATIVECOMMENT;
      LRCHEMICALLISTITEM.DECLAREFLAG := ANDECLARE;
      GTCHEMICALLISTITEMS( 0 ) := LRCHEMICALLISTITEM;

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

      
      LRINFO := GTINFO( 0 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      
      
      
      
      
      CHECKBASICCHEMLISTITEMPARAMS( LRCHEMICALLISTITEM );

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

      
      
      IF ( LRCHEMICALLISTITEM.ALTERNATIVELANGUAGEID IS NOT NULL )
      THEN
         LNRETVAL := IAPISPECIFICATION.ISMULTILANGUAGE( LRCHEMICALLISTITEM.PARTNO,
                                                        LRCHEMICALLISTITEM.REVISION,
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
                                                        LRCHEMICALLISTITEM.PARTNO,
                                                        LRCHEMICALLISTITEM.REVISION ) );
         END IF;
      END IF;

      
      LNRETVAL := IAPISPECIFICATIONACCESS.GETMODIFIABLEACCESS( LRCHEMICALLISTITEM.PARTNO,
                                                               LRCHEMICALLISTITEM.REVISION,
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
         IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( LRCHEMICALLISTITEM.PARTNO,
                                                      LRCHEMICALLISTITEM.REVISION,
                                                      LRCHEMICALLISTITEM.SECTIONID,
                                                      LRCHEMICALLISTITEM.SUBSECTIONID,
                                                      IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST,
                                                      0 );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL :=
         EXISTITEMINLIST( LRCHEMICALLISTITEM.PARTNO,
                                                         LRCHEMICALLISTITEM.REVISION,
                                                         LRCHEMICALLISTITEM.SECTIONID,
                                                         LRCHEMICALLISTITEM.SUBSECTIONID,
                                                         LRCHEMICALLISTITEM.INGREDIENTID,
                                                         LRCHEMICALLISTITEM.SEQUENCE );

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
      
      LNRETVAL := IAPISPECIFICATION.GETMODE( LRCHEMICALLISTITEM.PARTNO,
                                             LRCHEMICALLISTITEM.REVISION,
                                             LRCHEMICALLISTITEM.INTERNATIONAL );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      UPDATE SPECIFICATION_ING
         SET ING_SYNONYM = LRCHEMICALLISTITEM.SYNONYMID,
             QUANTITY = LRCHEMICALLISTITEM.INGREDIENTQUANTITY,
             ING_LEVEL = LRCHEMICALLISTITEM.INGREDIENTLEVEL,
             ING_COMMENT = LRCHEMICALLISTITEM.INGREDIENTCOMMENT,
             INTL = LRCHEMICALLISTITEM.INTERNATIONAL,
             ACTIV_IND = LRCHEMICALLISTITEM.ACTIVEINGREDIENT,
             INGDECLARE = LRCHEMICALLISTITEM.DECLAREFLAG,
             SEQ_NO = DECODE( ANNEWSEQUENCE,
                              NULL, ANSEQUENCENUMBER,
                              ANSEQUENCENUMBER, ANSEQUENCENUMBER,
                              ANNEWSEQUENCE )
       WHERE PART_NO = LRCHEMICALLISTITEM.PARTNO
         AND REVISION = LRCHEMICALLISTITEM.REVISION
         AND SECTION_ID = LRCHEMICALLISTITEM.SECTIONID
         AND SUB_SECTION_ID = LRCHEMICALLISTITEM.SUBSECTIONID
         AND INGREDIENT = LRCHEMICALLISTITEM.INGREDIENTID
         AND SEQ_NO = LRCHEMICALLISTITEM.SEQUENCE;

      
      IF ( LRCHEMICALLISTITEM.ALTERNATIVELANGUAGEID IS NOT NULL )
      THEN
         BEGIN
            
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 'Try to insert multi-language data',
                                 IAPICONSTANT.INFOLEVEL_3 );

            
            
            OPEN LQSPECINGLANG( LRCHEMICALLISTITEM.PARTNO,
                                LRCHEMICALLISTITEM.REVISION,
                                LRCHEMICALLISTITEM.SECTIONID,
                                LRCHEMICALLISTITEM.SUBSECTIONID,
                                LRCHEMICALLISTITEM.INGREDIENTID,
                                LRCHEMICALLISTITEM.ALTERNATIVELANGUAGEID,
                                LRCHEMICALLISTITEM.SEQUENCE );

            FETCH LQSPECINGLANG
             INTO LSDUMMY;

            IF LQSPECINGLANG%FOUND
            THEN
               LNSEQNO := LRCHEMICALLISTITEM.SEQUENCE;
            ELSE
               LNSEQNO := ANNEWSEQUENCE;
            END IF;

            CLOSE LQSPECINGLANG;

            INSERT INTO SPECIFICATION_ING_LANG
                        ( PART_NO,
                          REVISION,
                          SECTION_ID,
                          SUB_SECTION_ID,
                          INGREDIENT,
                          LANG_ID,
                          ING_LEVEL,
                          ING_COMMENT,
                          SEQ_NO )
                 VALUES ( LRCHEMICALLISTITEM.PARTNO,
                          LRCHEMICALLISTITEM.REVISION,
                          LRCHEMICALLISTITEM.SECTIONID,
                          LRCHEMICALLISTITEM.SUBSECTIONID,
                          LRCHEMICALLISTITEM.INGREDIENTID,
                          LRCHEMICALLISTITEM.ALTERNATIVELANGUAGEID,
                          LRCHEMICALLISTITEM.ALTERNATIVELEVEL,
                          LRCHEMICALLISTITEM.ALTERNATIVECOMMENT,
                          LNSEQNO );
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    'Update multi-language data',
                                    IAPICONSTANT.INFOLEVEL_3 );

               UPDATE SPECIFICATION_ING_LANG
                  SET ING_LEVEL = LRCHEMICALLISTITEM.ALTERNATIVELEVEL,
                      ING_COMMENT = LRCHEMICALLISTITEM.ALTERNATIVECOMMENT
                WHERE PART_NO = LRCHEMICALLISTITEM.PARTNO
                  AND REVISION = LRCHEMICALLISTITEM.REVISION
                  AND SECTION_ID = LRCHEMICALLISTITEM.SECTIONID
                  AND SUB_SECTION_ID = LRCHEMICALLISTITEM.SUBSECTIONID
                  AND INGREDIENT = LRCHEMICALLISTITEM.INGREDIENTID
                  AND LANG_ID = LRCHEMICALLISTITEM.ALTERNATIVELANGUAGEID
                  AND SEQ_NO = LRCHEMICALLISTITEM.SEQUENCE;
         END;
      END IF;

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.LOGHISTORY( LRCHEMICALLISTITEM.PARTNO,
                                              LRCHEMICALLISTITEM.REVISION,
                                              LRCHEMICALLISTITEM.SECTIONID,
                                              LRCHEMICALLISTITEM.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRCHEMICALLISTITEM.PARTNO,
                                                LRCHEMICALLISTITEM.REVISION );

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
   END SAVECHEMICALLISTITEM;

   
   FUNCTION GETCHEMICALLISTITEMS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANALTERNATIVELANGUAGEID    IN       IAPITYPE.LANGUAGEID_TYPE DEFAULT NULL,
      AQCHEMICALLISTITEMS        OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetChemicalListItems';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRCHEMICALLISTITEMS           IAPITYPE.SPCHEMICALLISTITEMREC_TYPE;
      LRGETCHEMICALLISTITEMS        SPCHEMICALLISTITEMRECORD_TYPE
         := SPCHEMICALLISTITEMRECORD_TYPE( NULL,
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
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'si.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', si.revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', si.section_id '
            || IAPICONSTANTCOLUMN.SECTIONIDCOL
            || ', si.sub_section_id '
            || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
            || ', si.ingredient '
            || IAPICONSTANTCOLUMN.INGREDIENTIDCOL
            || ', si.ingredient_rev '
            || IAPICONSTANTCOLUMN.INGREDIENTREVISIONCOL
            || ', si.quantity '
            || IAPICONSTANTCOLUMN.INGREDIENTQUANTITYCOL
            || ', si.ing_level '
            || IAPICONSTANTCOLUMN.INGREDIENTLEVELCOL
            || ', si.ing_comment '
            || IAPICONSTANTCOLUMN.INGREDIENTCOMMENTCOL
            || ', si.intl '
            || IAPICONSTANTCOLUMN.INTERNATIONALCOL
            || ', si.seq_no '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ', si.activ_ind '
            || IAPICONSTANTCOLUMN.ACTIVEINGREDIENTCOL
            || ', si.ing_synonym '
            || IAPICONSTANTCOLUMN.SYNONYMIDCOL
            || ', si.ing_synonym_rev '
            || IAPICONSTANTCOLUMN.SYNONYMREVISIONCOL
            || ', sil.lang_id '
            || IAPICONSTANTCOLUMN.ALTERNATIVELANGUAGEIDCOL
            || ', sil.ing_level '
            || IAPICONSTANTCOLUMN.ALTERNATIVELEVELCOL
            || ', sil.ing_comment '
            || IAPICONSTANTCOLUMN.ALTERNATIVECOMMENTCOL
            || ', f_ing_descr(:AlternativeLanguageId'
            || ', si.ingredient, si.ingredient_rev) '
            || IAPICONSTANTCOLUMN.INGREDIENTCOL
            || ', f_syn_descr(:AlternativeLanguageId'
            
            
            || ', si.ing_synonym, NVL(si.ing_synonym_rev, 0)) '
            
            || IAPICONSTANTCOLUMN.SYNONYMNAMECOL
            || ', 0 '
            || IAPICONSTANTCOLUMN.TRANSLATEDCOL
            || ', si.ingdeclare '
            || IAPICONSTANTCOLUMN.DECLARECOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'specification_ing si, specification_ing_lang sil';
   BEGIN
      
      
      
      
      
      IF ( AQCHEMICALLISTITEMS%ISOPEN )
      THEN
         CLOSE AQCHEMICALLISTITEMS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE si.part_no = NULL'
                   || '   AND si.part_no = sil.part_no ';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQCHEMICALLISTITEMS FOR LSSQLNULL USING NVL( ANALTERNATIVELANGUAGEID,
                                                        -1 ),
      NVL( ANALTERNATIVELANGUAGEID,
           -1 );

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      GTCHEMICALLISTITEMS.DELETE;
      LRCHEMICALLISTITEMS.PARTNO := ASPARTNO;
      LRCHEMICALLISTITEMS.REVISION := ANREVISION;
      LRCHEMICALLISTITEMS.SECTIONID := ANSECTIONID;
      LRCHEMICALLISTITEMS.SUBSECTIONID := ANSUBSECTIONID;
      LRCHEMICALLISTITEMS.ALTERNATIVELANGUAGEID := ANALTERNATIVELANGUAGEID;
      GTCHEMICALLISTITEMS( 0 ) := LRCHEMICALLISTITEMS;
      
      
      
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

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
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

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=
            'SELECT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE si.part_no = :PartNo '
         || ' AND si.revision = :Revision '
         || ' AND si.section_id = :SectionId '
         || ' AND si.sub_section_id = :SubSectionId '
         || ' AND si.part_no = sil.part_no(+) '
         || ' AND si.revision = sil.revision(+) '
         || ' AND si.section_id = sil.section_id(+) '
         || ' AND si.sub_section_id = sil.sub_section_id(+) '
         || ' AND si.ingredient = sil.ingredient(+) '
         || ' AND si.seq_no = sil.seq_no(+) '
         || ' AND sil.lang_id(+) = :AlternativeLanguageId '
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

      
      IF ( AQCHEMICALLISTITEMS%ISOPEN )
      THEN
         CLOSE AQCHEMICALLISTITEMS;
      END IF;

      
      OPEN AQCHEMICALLISTITEMS FOR LSSQL
      USING NVL( ANALTERNATIVELANGUAGEID,
                 -1 ),
            NVL( ANALTERNATIVELANGUAGEID,
                 -1 ),
            ASPARTNO,
            ANREVISION,
            ANSECTIONID,
            ANSUBSECTIONID,
            NVL( ANALTERNATIVELANGUAGEID,
                 -1 );

      
       
       
      GTGETCHEMICALLISTITEMS.DELETE;

      LOOP
         LRCHEMICALLISTITEMS := NULL;

         FETCH AQCHEMICALLISTITEMS
          INTO LRCHEMICALLISTITEMS;

         EXIT WHEN AQCHEMICALLISTITEMS%NOTFOUND;
         LRGETCHEMICALLISTITEMS.PARTNO := LRCHEMICALLISTITEMS.PARTNO;
         LRGETCHEMICALLISTITEMS.REVISION := LRCHEMICALLISTITEMS.REVISION;
         LRGETCHEMICALLISTITEMS.SECTIONID := LRCHEMICALLISTITEMS.SECTIONID;
         LRGETCHEMICALLISTITEMS.SUBSECTIONID := LRCHEMICALLISTITEMS.SUBSECTIONID;
         LRGETCHEMICALLISTITEMS.INGREDIENTID := LRCHEMICALLISTITEMS.INGREDIENTID;
         LRGETCHEMICALLISTITEMS.INGREDIENTREVISION := LRCHEMICALLISTITEMS.INGREDIENTREVISION;
         LRGETCHEMICALLISTITEMS.INGREDIENTQUANTITY := LRCHEMICALLISTITEMS.INGREDIENTQUANTITY;
         LRGETCHEMICALLISTITEMS.INGREDIENTLEVEL := LRCHEMICALLISTITEMS.INGREDIENTLEVEL;
         LRGETCHEMICALLISTITEMS.INGREDIENTCOMMENT := LRCHEMICALLISTITEMS.INGREDIENTCOMMENT;
         LRGETCHEMICALLISTITEMS.INTERNATIONAL := LRCHEMICALLISTITEMS.INTERNATIONAL;
         LRGETCHEMICALLISTITEMS.SEQUENCE := LRCHEMICALLISTITEMS.SEQUENCE;
         LRGETCHEMICALLISTITEMS.ACTIVEINGREDIENT := LRCHEMICALLISTITEMS.ACTIVEINGREDIENT;
         LRGETCHEMICALLISTITEMS.SYNONYMID := LRCHEMICALLISTITEMS.SYNONYMID;
         LRGETCHEMICALLISTITEMS.SYNONYMREVISION := LRCHEMICALLISTITEMS.SYNONYMREVISION;
         LRGETCHEMICALLISTITEMS.ALTERNATIVELANGUAGEID := LRCHEMICALLISTITEMS.ALTERNATIVELANGUAGEID;
         LRGETCHEMICALLISTITEMS.ALTERNATIVELEVEL := LRCHEMICALLISTITEMS.ALTERNATIVELEVEL;
         LRGETCHEMICALLISTITEMS.ALTERNATIVECOMMENT := LRCHEMICALLISTITEMS.ALTERNATIVECOMMENT;
         LRGETCHEMICALLISTITEMS.INGREDIENT := LRCHEMICALLISTITEMS.INGREDIENT;
         LRGETCHEMICALLISTITEMS.SYNONYMNAME := LRCHEMICALLISTITEMS.SYNONYMNAME;
         LRGETCHEMICALLISTITEMS.TRANSLATED := LRCHEMICALLISTITEMS.TRANSLATED;
         LRGETCHEMICALLISTITEMS.DECLAREFLAG := LRCHEMICALLISTITEMS.DECLAREFLAG;
         LRGETCHEMICALLISTITEMS.ROWINDEX := LRCHEMICALLISTITEMS.ROWINDEX;
         GTGETCHEMICALLISTITEMS.EXTEND;
         GTGETCHEMICALLISTITEMS( GTGETCHEMICALLISTITEMS.COUNT ) := LRGETCHEMICALLISTITEMS;
      END LOOP;

      CLOSE AQCHEMICALLISTITEMS;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQCHEMICALLISTITEMS FOR LSSQLNULL USING NVL( ANALTERNATIVELANGUAGEID,
                                                        -1 ),
      NVL( ANALTERNATIVELANGUAGEID,
           -1 );

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Post-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
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
         || ', SUBSECTIONID '
         || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
         || ', INGREDIENTID '
         || IAPICONSTANTCOLUMN.INGREDIENTIDCOL
         || ', INGREDIENTREVISION '
         || IAPICONSTANTCOLUMN.INGREDIENTREVISIONCOL
         || ', INGREDIENTQUANTITY '
         || IAPICONSTANTCOLUMN.INGREDIENTQUANTITYCOL
         || ', INGREDIENTLEVEL '
         || IAPICONSTANTCOLUMN.INGREDIENTLEVELCOL
         || ', INGREDIENTCOMMENT '
         || IAPICONSTANTCOLUMN.INGREDIENTCOMMENTCOL
         || ', INTERNATIONAL '
         || IAPICONSTANTCOLUMN.INTERNATIONALCOL
         || ', SEQUENCE '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ', ACTIVEINGREDIENT '
         || IAPICONSTANTCOLUMN.ACTIVEINGREDIENTCOL
         || ', SYNONYMID '
         || IAPICONSTANTCOLUMN.SYNONYMIDCOL
         || ', SYNONYMREVISION '
         || IAPICONSTANTCOLUMN.SYNONYMREVISIONCOL
         || ', ALTERNATIVELANGUAGEID '
         || IAPICONSTANTCOLUMN.ALTERNATIVELANGUAGEIDCOL
         || ', ALTERNATIVELEVEL '
         || IAPICONSTANTCOLUMN.ALTERNATIVELEVELCOL
         || ', ALTERNATIVECOMMENT '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOMMENTCOL
         || ', INGREDIENT '
         || IAPICONSTANTCOLUMN.INGREDIENTCOL
         || ', SYNONYMNAME  '
         || IAPICONSTANTCOLUMN.SYNONYMNAMECOL
         || ', TRANSLATED '
         || IAPICONSTANTCOLUMN.TRANSLATEDCOL
         || ', DECLAREFLAG '
         || IAPICONSTANTCOLUMN.DECLARECOL
         || ', ROWINDEX '
         || IAPICONSTANTCOLUMN.ROWINDEXCOL;
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM TABLE( CAST( :gtGetChemicalListItems AS SpChemicalListItemTable_Type ) ) ';

      
      IF ( AQCHEMICALLISTITEMS%ISOPEN )
      THEN
         CLOSE AQCHEMICALLISTITEMS;
      END IF;

      
      OPEN AQCHEMICALLISTITEMS FOR LSSQL USING GTGETCHEMICALLISTITEMS;

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
   END GETCHEMICALLISTITEMS;

   
   FUNCTION ISINGREDIENTDATATRANSLATED(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANINGREDIENTID             IN       IAPITYPE.ID_TYPE,
      ANPARENTID                 IN       IAPITYPE.ID_TYPE,
      ANHIERARCHICALLEVEL        IN       IAPITYPE.INGREDIENTHIERARCHICLEVEL_TYPE )
      RETURN IAPITYPE.BOOLEAN_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsIngredientDataTranslated';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNPARENTID                    IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( F_ING_LANG( ASPARTNO,
                       ANREVISION,
                       ANSECTIONID,
                       ANSUBSECTIONID,
                       ANINGREDIENTID,
                       ANPARENTID,
                       ANHIERARCHICALLEVEL,
                       0 ) = 'x' )
      THEN
         RETURN( 1 );
      ELSE
         RETURN( 0 );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              SQLERRM,
                              IAPICONSTANT.INFOLEVEL_1 );
         RETURN( 0 );
   END ISINGREDIENTDATATRANSLATED;

   
   FUNCTION SAVELIST(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANACTION                   IN       IAPITYPE.NUMVAL_TYPE,
      ASMETHOD                   IN       IAPITYPE.METHOD_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveList';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRINGREDIENTLIST              IAPITYPE.SPINGREDIENTLISTREC_TYPE;
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
      GTINGREDIENTLISTS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRINGREDIENTLIST.PARTNO := ASPARTNO;
      LRINGREDIENTLIST.REVISION := ANREVISION;
      LRINGREDIENTLIST.SECTIONID := ANSECTIONID;
      LRINGREDIENTLIST.SUBSECTIONID := ANSUBSECTIONID;
      LRINGREDIENTLIST.ITEMID := 0;   
      GTINGREDIENTLISTS( 0 ) := LRINGREDIENTLIST;

      GTINFO( 0 ) := LRINFO;

      CASE ANACTION
         WHEN IAPICONSTANT.ACTIONPRE
         THEN
            
            
            
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 'Call CUSTOM Pre-Action',
                                 IAPICONSTANT.INFOLEVEL_3 );
            LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                           ASMETHOD,
                                                           'PRE',
                                                           GTERRORS );

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

               
            
            LRINFO := GTINFO( 0 );
         WHEN IAPICONSTANT.ACTIONPOST
         THEN
            
            
            
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

            GTINFO.DELETE;
            GTINFO( 0 ) := LRINFO;

            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 'Call CUSTOM Post-Action',
                                 IAPICONSTANT.INFOLEVEL_3 );
            LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                           ASMETHOD,
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
   END SAVELIST;

   
   FUNCTION SAVECHEMICALLIST(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANACTION                   IN       IAPITYPE.NUMVAL_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveChemicalList';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      RETURN( SAVELIST( ASPARTNO,
                        ANREVISION,
                        ANSECTIONID,
                        ANSUBSECTIONID,
                        ANACTION,
                        LSMETHOD,
                        AFHANDLE,
                        AQINFO,
                        AQERRORS ) );
   END SAVECHEMICALLIST;

   
   FUNCTION SAVEINGREDIENTLIST(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANACTION                   IN       IAPITYPE.NUMVAL_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveIngredientList';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      RETURN( SAVELIST( ASPARTNO,
                        ANREVISION,
                        ANSECTIONID,
                        ANSUBSECTIONID,
                        ANACTION,
                        LSMETHOD,
                        AFHANDLE,
                        AQINFO,
                        AQERRORS ) );
   END SAVEINGREDIENTLIST;

   
   FUNCTION REMOVELISTDATA(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveListData';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LSSQLINFO                     IAPITYPE.SQLSTRING_TYPE;
      
      LNINTL                        IAPITYPE.BOOLEAN_TYPE;

      
      CURSOR C_INGREDIENTS(CSPARTNO     IN       IAPITYPE.PARTNO_TYPE,
                           CNREVISION   IN       IAPITYPE.REVISION_TYPE)
      IS
        SELECT DISTINCT PART_NO, REVISION, SECTION_ID, SUB_SECTION_ID, INGREDIENT
        FROM SPECIFICATION_ING
        WHERE PART_NO = CSPARTNO
          AND REVISION = CNREVISION;

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
      GTINFO.DELETE;
      GTINFO( 0 ) := LRINFO;

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

      
      IF ( ANREVISION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Revision' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRevision',
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

     BEGIN
          
          
          LNRETVAL := IAPISPECIFICATION.GETMODE(ASPARTNO,
                                                ANREVISION,
                                                LNINTL);

          IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
          THEN
             IAPIGENERAL.LOGINFO( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
             RETURN LNRETVAL;
          END IF;

          IF   (IAPIGENERAL.SESSION.SETTINGS.INTERNATIONAL = FALSE)
            OR (LNINTL = '1')
          THEN
              FOR LRINGREDIENT IN C_INGREDIENTS(ASPARTNO,
                                                ANREVISION)
              LOOP
                LNRETVAL := ADJUSTPNCLAIMPROPERTYPRESDEF(LRINGREDIENT.PART_NO,
                                                           LRINGREDIENT.REVISION,
                                                           LRINGREDIENT.INGREDIENT);
              END LOOP;

          END IF;
          

         
         DELETE FROM SPECIFICATION_ING
               WHERE PART_NO = ASPARTNO
                 AND REVISION = ANREVISION;

         DELETE FROM SPECIFICATION_ING_LANG
               WHERE PART_NO = ASPARTNO
                 AND REVISION = ANREVISION;

         
        DELETE FROM ITSPECINGDETAIL
        WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION;
        

      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( ASPARTNO,
                                                ANREVISION );

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
   END REMOVELISTDATA;


  
   FUNCTION ADDINGREDIENTALLERGEN(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANINGREDIENTID             IN       IAPITYPE.ID_TYPE, 
      ANALLERGENID               IN       IAPITYPE.ID_TYPE, 
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddIngredientAllergen';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
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
 
      LRINFO.PARAMETERDATA := IAPICONSTANT.REFRESHWINDOW;
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
      GTINFO.DELETE;
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS, AQERRORS );
      GRALLERGEN.PARTNO := ASPARTNO;
      GRALLERGEN.REVISION := ANREVISION;
      GRALLERGEN.SECTIONID := ANSECTIONID;
      GRALLERGEN.SUBSECTIONID := ANSUBSECTIONID;
      GRALLERGEN.INGREDIENTID := ANINGREDIENTID;
      GRALLERGEN.ALLERGENID := ANALLERGENID;

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
      
      
      
      
      
      
      
      
			
      CHECKBASICALLERGENPARAMS( GRALLERGEN );

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

      
      
      
      BEGIN
            INSERT INTO ITSPECINGALLERGEN
                        ( PART_NO,
                          REVISION,
                          SECTION_ID,
                          SUB_SECTION_ID,
                          INGREDIENT,
                          ALLERGEN )
               VALUES (GRALLERGEN.PARTNO,
                       GRALLERGEN.REVISION,
                       GRALLERGEN.SECTIONID,
                       GRALLERGEN.SUBSECTIONID,
                       GRALLERGEN.INGREDIENTID,
                       GRALLERGEN.ALLERGENID);
        
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
               NULL;   
     END;

      
      
      
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
   END ADDINGREDIENTALLERGEN;

   FUNCTION ADDINGREDIENTCHARACTERISTIC(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANINGREDIENT               IN       IAPITYPE.ID_TYPE,
			ANINGREDIENTSEQNO          IN       IAPITYPE.INGREDIENTSEQUENCENUMBER_TYPE ,
			ANINGDETAILTYPE            IN       IAPITYPE.ID_TYPE ,
			ANCHARACTERISTIC           IN       IAPITYPE.ID_TYPE ,
			ASMANDATORY                IN       IAPITYPE.MANDATORY_TYPE ,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddIngredientCharacteristic';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
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
 
      LRINFO.PARAMETERDATA := IAPICONSTANT.REFRESHWINDOW;
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
      GTINFO.DELETE;
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS, AQERRORS );
			
			GRCHARACTERISTIC.CHARACTERISTICID := ANCHARACTERISTIC;
			GRCHARACTERISTIC.DESCRIPTION := F_CHH_DESCR(NVL(IAPIGENERAL.SESSION.SETTINGS.ALTERNATIVELANGUAGEID, 1), ANCHARACTERISTIC, 0);
      GRCHARACTERISTIC.PARTNO := ASPARTNO;
      GRCHARACTERISTIC.REVISION := ANREVISION;
      GRCHARACTERISTIC.SECTIONID := ANSECTIONID;
      GRCHARACTERISTIC.SUBSECTIONID := ANSUBSECTIONID;
      GRCHARACTERISTIC.INGREDIENT := ANINGREDIENT;
			GRCHARACTERISTIC.INGREDIENTSEQNO := ANINGREDIENTSEQNO;
      GRCHARACTERISTIC.INGDETAILTYPE := ANINGDETAILTYPE;
			GRCHARACTERISTIC.MANDATORY := ASMANDATORY;

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
      
      
      
      
      
      
      
      
			
     CHECKBASICCHARPARAMS( GRCHARACTERISTIC );

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

      
      
      
      BEGIN
            INSERT INTO ITSPECINGDETAIL
                        ( PART_NO,
                          REVISION,
                          SECTION_ID,
                          SUB_SECTION_ID,
                          INGREDIENT,
                          INGREDIENT_SEQ_NO,
													INGDETAIL_TYPE,
													INGDETAIL_CHARACTERISTIC,
													MANDATORY )
               VALUES (GRCHARACTERISTIC.PARTNO,
                       GRCHARACTERISTIC.REVISION,
                       GRCHARACTERISTIC.SECTIONID,
                       GRCHARACTERISTIC.SUBSECTIONID,
                       GRCHARACTERISTIC.INGREDIENT,
                       GRCHARACTERISTIC.INGREDIENTSEQNO,
											 GRCHARACTERISTIC.INGDETAILTYPE,
											 GRCHARACTERISTIC.CHARACTERISTICID,
											 GRCHARACTERISTIC.MANDATORY);

         EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
               NULL;   
     END;

      
      
      
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
   END ADDINGREDIENTCHARACTERISTIC;

   FUNCTION REMOVEINGREDIENTCHARACTERISTIC(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANINGREDIENT               IN       IAPITYPE.ID_TYPE,
			ANINGREDIENTSEQNO          IN       IAPITYPE.INGREDIENTSEQUENCENUMBER_TYPE ,
			ANINGDETAILTYPE            IN       IAPITYPE.ID_TYPE ,
			ANCHARACTERISTIC           IN       IAPITYPE.ID_TYPE ,
			ASMANDATORY                IN       IAPITYPE.MANDATORY_TYPE ,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
			
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveIngredientCharacteristic';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
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
 
      LRINFO.PARAMETERDATA := IAPICONSTANT.REFRESHWINDOW;
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
      GTINFO.DELETE;
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS, AQERRORS );
			
			GRCHARACTERISTIC.CHARACTERISTICID := ANCHARACTERISTIC;
			GRCHARACTERISTIC.DESCRIPTION := F_CHH_DESCR(NVL(IAPIGENERAL.SESSION.SETTINGS.ALTERNATIVELANGUAGEID, 1), ANCHARACTERISTIC, 0);
      GRCHARACTERISTIC.PARTNO := ASPARTNO;
      GRCHARACTERISTIC.REVISION := ANREVISION;
      GRCHARACTERISTIC.SECTIONID := ANSECTIONID;
      GRCHARACTERISTIC.SUBSECTIONID := ANSUBSECTIONID;
      GRCHARACTERISTIC.INGREDIENT := ANINGREDIENT;
			GRCHARACTERISTIC.INGREDIENTSEQNO := ANINGREDIENTSEQNO;
      GRCHARACTERISTIC.INGDETAILTYPE := ANINGDETAILTYPE;
			GRCHARACTERISTIC.MANDATORY := ASMANDATORY;

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
      
      
      
      
      
      
      
      
      
      
      
			
      CHECKBASICCHARPARAMS( GRCHARACTERISTIC );

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

      
      
      
      
			
      IF GRCHARACTERISTIC.MANDATORY = 'N' THEN
			  BEGIN
			      DELETE ITSPECINGDETAIL WHERE
                       PART_NO = GRCHARACTERISTIC.PARTNO 
                   AND REVISION = GRCHARACTERISTIC.REVISION 
                   AND SECTION_ID = GRCHARACTERISTIC.SECTIONID 
                   AND SUB_SECTION_ID = GRCHARACTERISTIC.SUBSECTIONID 
                   AND INGREDIENT = GRCHARACTERISTIC.INGREDIENT 
                   AND INGREDIENT_SEQ_NO = GRCHARACTERISTIC.INGREDIENTSEQNO 
                   AND INGDETAIL_TYPE = GRCHARACTERISTIC.INGDETAILTYPE 
                   AND INGDETAIL_CHARACTERISTIC = GRCHARACTERISTIC.CHARACTERISTICID ;
						        
         EXCEPTION
            WHEN OTHERS
            THEN
               NULL; 
			  END;
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
   END REMOVEINGREDIENTCHARACTERISTIC;





   FUNCTION REMOVEINGREDIENTALLERGEN(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANINGREDIENTID             IN       IAPITYPE.ID_TYPE,
      ANALLERGENID               IN       IAPITYPE.ID_TYPE,

			AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )

      RETURN IAPITYPE.ERRORNUM_TYPE
      
      
      
  IS
   LSMETHOD                      IAPITYPE.SOURCE_TYPE := 'RemoveIngredientAllergen';
   LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   LNCOUNT                       IAPITYPE.NUMVAL_TYPE;

   LRINFO                        IAPITYPE.INFOREC_TYPE;
   LSSQLINFO                     IAPITYPE.SQLSTRING_TYPE;
   LNREFRESHWINDOW               IAPITYPE.ITEMINFO_TYPE DEFAULT 0;  

   CURSOR C_PROPS (LCALLERGEN IN ITINGALLERGEN.ALLERGEN%TYPE)
   IS
    SELECT PROPERTY
    FROM ITPROPALLERGEN
    WHERE ALLERGEN = LCALLERGEN
    AND STATUS = 0;

   
   CURSOR C_CLAIMPROPS ( LCPARTNO   IN  ITSPECINGALLERGEN.PART_NO%TYPE,
                         LCREVISION IN  ITSPECINGALLERGEN.REVISION%TYPE,
                         LCPROPERTY IN  ITPROPALLERGEN.PROPERTY%TYPE,
                         LCCLAIMTYPE IN PROPERTY_GROUP.PG_TYPE%TYPE)
   IS
    SELECT SP.PART_NO, SP.REVISION, SP.SECTION_ID, SP.SUB_SECTION_ID, SP.PROPERTY_GROUP, SP.PROPERTY, SP.ATTRIBUTE
    FROM SPECIFICATION_PROP SP, PROPERTY_GROUP PG
    WHERE SP.PROPERTY_GROUP = PG.PROPERTY_GROUP
    AND PART_NO = LCPARTNO
    AND REVISION = LCREVISION
    AND PG_TYPE = LCCLAIMTYPE
    AND PROPERTY = LCPROPERTY;

  BEGIN
      
      
      
      
      

    IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
    THEN
      LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      IAPIGENERAL.LOGERROR( GSSOURCE,
                            LSMETHOD,
                            IAPIGENERAL.GETLASTERRORTEXT( ) );
       RETURN (IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
    END IF;


      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;

      IF ( AQINFO%ISOPEN )
      THEN
         CLOSE AQINFO;
      END IF;

      LRINFO.PARAMETERNAME := IAPICONSTANT.REFRESHWINDOWDESCR;
 
      LRINFO.PARAMETERDATA := IAPICONSTANT.REFRESHWINDOW;
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
      GTINFO.DELETE;
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS, AQERRORS );
      GRALLERGEN.PARTNO := ASPARTNO;
      GRALLERGEN.REVISION := ANREVISION;
      GRALLERGEN.SECTIONID := ANSECTIONID;
      GRALLERGEN.SUBSECTIONID := ANSUBSECTIONID;
      GRALLERGEN.INGREDIENTID := ANINGREDIENTID;
      GRALLERGEN.ALLERGENID := ANALLERGENID;
			
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
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      
      
      
      
      
			
      CHECKBASICALLERGENPARAMS( GRALLERGEN );

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
      
      
      

    DELETE FROM ITSPECINGALLERGEN
    WHERE PART_NO = GRALLERGEN.PARTNO
      AND REVISION = GRALLERGEN.REVISION
      AND SECTION_ID = GRALLERGEN.SECTIONID
      AND SUB_SECTION_ID = GRALLERGEN.SUBSECTIONID
      AND INGREDIENT = GRALLERGEN.INGREDIENTID
      AND ALLERGEN = GRALLERGEN.ALLERGENID;

    
    BEGIN
        
        
        

        
        
        SELECT COUNT(*)
        INTO LNCOUNT
        FROM SPECIFICATION_ING SI, ITINGALLERGEN IA
        WHERE SI.INGREDIENT = IA.INGREDIENT
        AND PART_NO = GRALLERGEN.PARTNO
        AND REVISION = GRALLERGEN.REVISION
        AND ALLERGEN = GRALLERGEN.ALLERGENID
        AND IA.STATUS = 0; 

        
        IF (LNCOUNT = 0)
        THEN
          
          SELECT COUNT(*)
          INTO LNCOUNT
          FROM ITSPECINGALLERGEN
          WHERE PART_NO = GRALLERGEN.PARTNO
            AND REVISION = GRALLERGEN.REVISION
            AND ALLERGEN = GRALLERGEN.ALLERGENID;
        END IF;

        
        IF (LNCOUNT <> 0)
        THEN
            RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
        END IF;

        
        FOR LRPROPS IN C_PROPS( GRALLERGEN.ALLERGENID )
        LOOP
          
          FOR LRCLAIMPROPS IN C_CLAIMPROPS(GRALLERGEN.PARTNO, GRALLERGEN.REVISION, LRPROPS.PROPERTY, 3)
          LOOP
            UPDATE SPECIFICATION_PROP
            SET BOOLEAN_1 = 'N' 
            WHERE PART_NO = LRCLAIMPROPS.PART_NO
            AND REVISION = LRCLAIMPROPS.REVISION
            AND SECTION_ID = LRCLAIMPROPS.SECTION_ID
            AND SUB_SECTION_ID = LRCLAIMPROPS.SUB_SECTION_ID
            AND PROPERTY_GROUP = LRCLAIMPROPS.PROPERTY_GROUP
            AND PROPERTY = LRCLAIMPROPS.PROPERTY
            AND ATTRIBUTE = LRCLAIMPROPS.ATTRIBUTE;
          END LOOP;

          
          FOR LRCLAIMPROPS IN C_CLAIMPROPS(GRALLERGEN.PARTNO, GRALLERGEN.REVISION, LRPROPS.PROPERTY, 2)
          LOOP
            UPDATE SPECIFICATION_PROP
            SET BOOLEAN_1 = 'Y' 
            WHERE PART_NO = LRCLAIMPROPS.PART_NO
            AND REVISION = LRCLAIMPROPS.REVISION
            AND SECTION_ID = LRCLAIMPROPS.SECTION_ID
            AND SUB_SECTION_ID = LRCLAIMPROPS.SUB_SECTION_ID
            AND PROPERTY_GROUP = LRCLAIMPROPS.PROPERTY_GROUP
            AND PROPERTY = LRCLAIMPROPS.PROPERTY
            AND ATTRIBUTE = LRCLAIMPROPS.ATTRIBUTE;
          END LOOP;

        END LOOP;

    EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               'Cannot check/uncheck Claim property check box due to an error.' );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
        
        
        RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
    END;

      
      
      
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
  END REMOVEINGREDIENTALLERGEN;


   FUNCTION REMOVEINGREDIENTALLERGENS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANINGREDIENTID             IN       IAPITYPE.ID_TYPE,

			AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )

       RETURN IAPITYPE.ERRORNUM_TYPE
      
      
      
  IS
   LSMETHOD                      IAPITYPE.SOURCE_TYPE := 'RemoveIngredientAllergens';
   LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   LNALLERGENID                  IAPITYPE.ID_TYPE;

   CURSOR C_ALLERGENS ( LCPARTNO   IN  ITSPECINGALLERGEN.PART_NO%TYPE,
                        LCREVISION IN  ITSPECINGALLERGEN.REVISION%TYPE,
                        LCSECTION IN  ITSPECINGALLERGEN.SECTION_ID%TYPE,
                        LCSUBSECTION IN  ITSPECINGALLERGEN.SUB_SECTION_ID%TYPE,
                        LCINGREDIENT IN  ITSPECINGALLERGEN.INGREDIENT%TYPE)
   IS
     SELECT ALLERGEN
     FROM ITSPECINGALLERGEN
     WHERE PART_NO = LCPARTNO
       AND REVISION = LCREVISION
       AND SECTION_ID = LCSECTION
       AND SUB_SECTION_ID = LCSUBSECTION
       AND INGREDIENT = LCINGREDIENT;

  BEGIN
      
      
      
      
      









    IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
    THEN
      LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      IAPIGENERAL.LOGERROR( GSSOURCE,
                            LSMETHOD,
                            IAPIGENERAL.GETLASTERRORTEXT( ) );
       RETURN (IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
    END IF;

    FOR GRALLERGENS IN C_ALLERGENS(ASPARTNO, ANREVISION, ANSECTIONID, ANSUBSECTIONID, ANINGREDIENTID)
    LOOP

        LNRETVAL := REMOVEINGREDIENTALLERGEN( ASPARTNO,
                                              ANREVISION,
                                              ANSECTIONID,
                                              ANSUBSECTIONID,
                                              ANINGREDIENTID,
                                              GRALLERGENS.ALLERGEN,
																							
                                         			AFHANDLE,
                                              AQINFO,
                                              AQERRORS
																							  
																								);

       IF (LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS)
       THEN
          IAPIGENERAL.LOGERROR( GSSOURCE,
                                LSMETHOD,
                                IAPIGENERAL.GETLASTERRORTEXT( ) );

          RETURN LNRETVAL;
       END IF;

    END LOOP;

    RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );

  EXCEPTION
    WHEN OTHERS
    THEN
     IAPIGENERAL.LOGERROR( GSSOURCE,
                           LSMETHOD,
                           SQLERRM );
  END REMOVEINGREDIENTALLERGENS;



   
   FUNCTION ADDINGREDIENTDETAIL(
      
      ASDESCRIPTION                  IN       IAPITYPE.PARTNO_TYPE,
      ANINGDETAILASSOCIATION     IN       IAPITYPE.SEQUENCENR_TYPE,
      ANINGDETAILTYPE              OUT    IAPITYPE.SEQUENCENR_TYPE)
      RETURN IAPITYPE.ERRORNUM_TYPE
  IS
   LSMETHOD                     IAPITYPE.SOURCE_TYPE := 'AddIngredientDetail';
   LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   LNINGDETAILTYPE          IAPITYPE.SEQUENCENR_TYPE;
   LNCOUNT                      IAPITYPE.NUMVAL_TYPE;
  BEGIN

    
    SELECT COUNT(*)
    INTO LNCOUNT
    FROM ITINGDETAILCONFIG
    WHERE TRIM(LOWER(DESCRIPTION)) = TRIM(LOWER(ASDESCRIPTION))
      AND STATUS = 0;

    IF (LNCOUNT > 0)
    THEN
         RETURN ( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_DESCRNOTUNIQUE ));
    END IF;

    
    SELECT COUNT(*)
    INTO LNCOUNT
    FROM ASSOCIATION
    WHERE ASSOCIATION = ANINGDETAILASSOCIATION
      AND ASSOCIATION_TYPE = 'C';

    IF (LNCOUNT = 0)
    THEN
         RETURN ( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_ITEMNOTFOUND ,
                                                     'Association',
                                                     ANINGDETAILASSOCIATION));
    END IF;

    LNRETVAL := IAPISEQUENCE.GETNEXTVALUE( '1', 'ingdetail', LNINGDETAILTYPE);

    INSERT INTO ITINGDETAILCONFIG
      VALUES  ( LNINGDETAILTYPE, ASDESCRIPTION, ANINGDETAILASSOCIATION, 0);

    ANINGDETAILTYPE := LNINGDETAILTYPE;

    RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );

  EXCEPTION
    WHEN OTHERS
    THEN
     IAPIGENERAL.LOGERROR( GSSOURCE,
                           LSMETHOD,
                           SQLERRM );
  END ADDINGREDIENTDETAIL;


   FUNCTION SAVEINGREDIENTDETAIL(
      ANINGDETAILTYPE              IN       IAPITYPE.SEQUENCENR_TYPE,
      ASDESCRIPTION                  IN       IAPITYPE.PARTNO_TYPE,
      ANINGDETAILASSOCIATION     IN       IAPITYPE.SEQUENCENR_TYPE)
      RETURN IAPITYPE.ERRORNUM_TYPE
  IS
   LSMETHOD                      IAPITYPE.SOURCE_TYPE := 'SaveIngredientDetail';
   LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   LSOLDDESCRIPTION                IAPITYPE.PARTNO_TYPE;
   LNOLDINGDETAILASSOCIATION   IAPITYPE.SEQUENCENR_TYPE;
   LNCOUNT                      IAPITYPE.NUMVAL_TYPE;
   LNSTATUS                     IAPITYPE.BOOLEAN_TYPE;

  BEGIN
    
    BEGIN
        SELECT DESCRIPTION, INGDETAIL_ASSOCIATION, STATUS
          INTO LSOLDDESCRIPTION, LNOLDINGDETAILASSOCIATION, LNSTATUS
        FROM ITINGDETAILCONFIG
        WHERE INGDETAIL_TYPE = ANINGDETAILTYPE;

    EXCEPTION
      WHEN NO_DATA_FOUND
        THEN
         
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_ITEMNOTFOUND ,
                                                     'Ingredient detail',
                                                     ANINGDETAILTYPE));
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
    END;

    IF (LNSTATUS = 1)
    THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                         LSMETHOD,
                                         'The ingredient detail association is historic and cannot be modified.',
                                         IAPICONSTANT.INFOLEVEL_3);

         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS);
    END IF;

    
    SELECT COUNT(*)
    INTO LNCOUNT
    FROM ITSPECINGDETAIL
    WHERE INGDETAIL_TYPE = LNOLDINGDETAILASSOCIATION;

    IF (LNCOUNT = 0)
    THEN
        SELECT COUNT(*)
        INTO LNCOUNT
        FROM FRAMEINGLY
        WHERE INGDETAIL_TYPE = LNOLDINGDETAILASSOCIATION;
    END IF;

    IF (LNCOUNT > 0)
    THEN
         RETURN ( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_INGDETAILASSOCINUSE ));
    END IF;

    
    SELECT COUNT(*)
    INTO LNCOUNT
    FROM ITINGDETAILCONFIG
    WHERE TRIM(LOWER(DESCRIPTION)) = TRIM(LOWER(ASDESCRIPTION))
      AND STATUS = 0
      AND INGDETAIL_TYPE <> ANINGDETAILTYPE;

    IF (LNCOUNT > 0)
    THEN
         RETURN ( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_DESCRNOTUNIQUE ));
    END IF;

    
    SELECT COUNT(*)
    INTO LNCOUNT
    FROM ASSOCIATION
    WHERE ASSOCIATION = ANINGDETAILASSOCIATION
      AND ASSOCIATION_TYPE = 'C';

    IF (LNCOUNT = 0)
    THEN
         RETURN ( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_ITEMNOTFOUND ,
                                                     'Association',
                                                     ANINGDETAILASSOCIATION));
    END IF;


    UPDATE ITINGDETAILCONFIG
    SET DESCRIPTION = ASDESCRIPTION,
           INGDETAIL_ASSOCIATION = ANINGDETAILASSOCIATION
    WHERE INGDETAIL_TYPE = ANINGDETAILTYPE;

    RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );

  EXCEPTION
    WHEN OTHERS
    THEN
     IAPIGENERAL.LOGERROR( GSSOURCE,
                           LSMETHOD,
                           SQLERRM );
  END SAVEINGREDIENTDETAIL;


   FUNCTION REMOVEINGREDIENTDETAIL(
      ANINGDETAILTYPE     IN       IAPITYPE.SEQUENCENR_TYPE)
      RETURN IAPITYPE.ERRORNUM_TYPE
  IS
   LSMETHOD                      IAPITYPE.SOURCE_TYPE := 'RemoveIngredientDetail';
   LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;

  BEGIN

    UPDATE ITINGDETAILCONFIG
     SET STATUS = 1
    WHERE INGDETAIL_TYPE = ANINGDETAILTYPE;

    RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );

  EXCEPTION
    WHEN OTHERS
    THEN
     IAPIGENERAL.LOGERROR( GSSOURCE,
                           LSMETHOD,
                           SQLERRM );
  END REMOVEINGREDIENTDETAIL;
   

   
   FUNCTION GETINGREDIENTCHARACTERISTICS(
      ASPARTNO                      IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                    IN       IAPITYPE.REVISION_TYPE,
      ANINGREDIENT                  IN       IAPITYPE.ID_TYPE,
      ANINGDETAILTYPE               IN       IAPITYPE.ID_TYPE DEFAULT -1,
      ANLANGUAGEID                  IN       IAPITYPE.LANGUAGEID_TYPE DEFAULT NULL,
      AQINGCHAR                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                      OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetIngredientCharacteristics';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRINGCHAR                     IAPITYPE.SPINGCHARREC_TYPE;
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'ca.characteristic '
            || IAPICONSTANTCOLUMN.CHARACTERISTICIDCOL
            || ', f_chh_descr(NVL(:LanguageId, 1), ca.characteristic, 0) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', sh.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', sh.revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', si.section_id '
            || IAPICONSTANTCOLUMN.SECTIONIDCOL
            || ', si.sub_section_id '
            || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
            || ', si.ingredient '
            || IAPICONSTANTCOLUMN.INGREDIENTIDCOL
            || ', si.seq_no '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ', fil.ingdetail_type '
            || IAPICONSTANTCOLUMN.INGREDIENTTYPECOL
            || ', ''N'' '
            || IAPICONSTANTCOLUMN.MANDATORYCOL;
      LSFROM IAPITYPE.STRING_TYPE := 'specification_header sh, frameingly fil, specification_ing si, itingdetailconfig idc, characteristic_association ca, itspecingdetail sid';

      LSSELECT1                      VARCHAR2( 4096 )
         :=    'idc.ingdetail_characteristic '
            || IAPICONSTANTCOLUMN.CHARACTERISTICIDCOL
            || ', f_chh_descr(NVL(:LanguageId, 1), idc.ingdetail_characteristic, 0) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', si.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', si.revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', si.section_id '
            || IAPICONSTANTCOLUMN.SECTIONIDCOL
            || ', si.sub_section_id '
            || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
            || ', si.ingredient '
            || IAPICONSTANTCOLUMN.INGREDIENTIDCOL
            || ', si.seq_no '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ', idc.ingdetail_type '
            || IAPICONSTANTCOLUMN.INGREDIENTTYPECOL
            || ', ''Y'' '
            || IAPICONSTANTCOLUMN.MANDATORYCOL;
      LSFROM1 IAPITYPE.STRING_TYPE := 'specification_ing si, itingdetailconfig_charassoc idc';

      LSSELECT2                      VARCHAR2( 4096 )
         :=    'ca.characteristic_id '
            || IAPICONSTANTCOLUMN.CHARACTERISTICIDCOL
            || ', f_chh_descr(NVL(:LanguageId, 1), ca.characteristic_id, 0) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', sid.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', sid.revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', sid.section_id '
            || IAPICONSTANTCOLUMN.SECTIONIDCOL
            || ', sid.sub_section_id '
            || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
            || ', sid.ingredient '
            || IAPICONSTANTCOLUMN.INGREDIENTIDCOL
            || ', sid.ingredient_seq_no '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ', sid.ingdetail_type '
            || IAPICONSTANTCOLUMN.INGREDIENTTYPECOL
            || ', sid.mandatory '
            || IAPICONSTANTCOLUMN.MANDATORYCOL;
      LSFROM2 IAPITYPE.STRING_TYPE := 'itspecingdetail sid, characteristic ca';

   BEGIN
      
      
      
      
      
      IF ( AQINGCHAR%ISOPEN )
      THEN
         CLOSE AQINGCHAR;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE sh.part_no = NULL'
                   || '   AND sh.part_no = si.part_no ';

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQINGCHAR FOR LSSQLNULL USING ANLANGUAGEID;
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      GTINGCHAR.DELETE;
      LRINGCHAR.PARTNO := ASPARTNO;
      LRINGCHAR.REVISION := ANREVISION;
      LRINGCHAR.INGREDIENT := ANINGREDIENT;
      LRINGCHAR.INGDETAILTYPE := ANINGDETAILTYPE;

      GTINGCHAR( 0 ) := LRINGCHAR;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
     SELECT S.STATUS_TYPE
        INTO LSSTATUSTYPE
        FROM SPECIFICATION_HEADER SH,
             STATUS S
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
        AND S.STATUS = SH.STATUS;

        
        IF ( AQINGCHAR%ISOPEN )
        THEN
           CLOSE AQINGCHAR;
        END IF;


   IF LSSTATUSTYPE = IAPICONSTANT.STATUSTYPE_DEVELOPMENT THEN
     IF ANINGDETAILTYPE != -1 THEN
      LSSQL :=
            'SELECT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE sh.part_no = :PartNo '
         || ' AND sh.revision = :Revision '
         || ' AND sh.frame_id = fil.frame_no '
         || ' AND sh.frame_rev = fil.revision '
         || ' AND sh.frame_owner = fil.owner '
         || ' AND fil.ingdetail_type = :IngDetailType '
         || ' AND si.ingredient = :Ingredient '
         || ' AND sh.part_no = si.part_no '
         || ' AND sh.revision = si.revision '
         || ' AND fil.ingdetail_type = idc.ingdetail_type '
         || ' AND idc.ingdetail_association = ca.association '
         || ' AND EXISTS (SELECT 1 FROM characteristic ch WHERE ca.characteristic = ch.characteristic_id AND ch.status = 0) '
         || ' AND EXISTS (SELECT 1 FROM association assoc WHERE idc.ingdetail_association = assoc.association AND assoc.status = 0) '
         || ' AND sid.part_no = sh.part_no AND sid.revision = sh.revision AND sid.ingredient = si.ingredient '
         || ' AND sid.ingdetail_type = fil.IngDetail_Type AND sid.ingdetail_characteristic = ca.characteristic '
         || ' UNION '
         || ' SELECT '
         || LSSELECT1
         || ' FROM '
         || LSFROM1
         || ' WHERE si.part_no = :PartNo '
         || ' AND si.revision = :Revision '
         || ' AND si.ingredient = idc.ingredient '
         || ' AND idc.ingdetail_type = :IngDetailType '
         || ' AND si.ingredient = :Ingredient '
         || ' AND idc.status = 0 '
         || ' AND (si.section_id, si.sub_section_id) IN (SELECT c.section_id, c.sub_section_id FROM specification_section c '
         || ' WHERE c.part_no = :PartNo AND c.revision = :Revision AND c.TYPE = 9) '
           ;
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

        
        OPEN AQINGCHAR FOR LSSQL
        USING ANLANGUAGEID,
              ASPARTNO,
              ANREVISION,
              ANINGDETAILTYPE,
              ANINGREDIENT,
              ANLANGUAGEID,
              ASPARTNO,
              ANREVISION,
              ANINGDETAILTYPE,
              ANINGREDIENT,
              ASPARTNO,
              ANREVISION
              ;

        RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      ELSE
      LSSQL :=
            'SELECT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE sh.part_no = :PartNo '
         || ' AND sh.revision = :Revision '
         || ' AND sh.frame_id = fil.frame_no '
         || ' AND sh.frame_rev = fil.revision '
         || ' AND sh.frame_owner = fil.owner '
         || ' AND si.ingredient = :Ingredient '
         || ' AND sh.part_no = si.part_no '
         || ' AND sh.revision = si.revision '
         || ' AND fil.ingdetail_type = idc.ingdetail_type '
         || ' AND idc.ingdetail_association = ca.association '
         || ' AND EXISTS (SELECT 1 FROM characteristic ch WHERE ca.characteristic = ch.characteristic_id AND ch.status = 0) '
         || ' AND EXISTS (SELECT 1 FROM association assoc WHERE idc.ingdetail_association = assoc.association AND assoc.status = 0) '
         || ' AND sid.part_no = sh.part_no AND sid.revision = sh.revision AND sid.ingredient = si.ingredient '
         || ' AND sid.ingdetail_type = fil.IngDetail_Type AND sid.ingdetail_characteristic = ca.characteristic '
         || ' UNION '
         || ' SELECT '
         || LSSELECT1
         || ' FROM '
         || LSFROM1
         || ' WHERE si.part_no = :PartNo '
         || ' AND si.revision = :Revision '
         || ' AND si.ingredient = idc.ingredient '
         || ' AND si.ingredient = :Ingredient '
         || ' AND idc.status = 0 '
         || ' AND (si.section_id, si.sub_section_id) IN (SELECT c.section_id, c.sub_section_id FROM specification_section c '
         || ' WHERE c.part_no = :PartNo AND c.revision = :Revision AND c.TYPE = 9) '
           ;
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

        
        OPEN AQINGCHAR FOR LSSQL
        USING ANLANGUAGEID,
              ASPARTNO,
              ANREVISION,
              ANINGREDIENT,
              ANLANGUAGEID,
              ASPARTNO,
              ANREVISION,
              ANINGREDIENT,
              ASPARTNO,
              ANREVISION
              ;

        RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;
    ELSE
     IF ANINGDETAILTYPE != -1 THEN
        LSSQL :=
            ' SELECT '
         || LSSELECT2
         || ' FROM '
         || LSFROM2
         || ' WHERE sid.part_no = :PartNo '
         || ' AND sid.revision = :Revision '
         || ' AND sid.ingdetail_characteristic = ca.characteristic_id '
         || ' AND sid.ingdetail_type = :IngDetailType '
         || ' AND sid.ingredient = :Ingredient '
         ;

        IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                     LSMETHOD,
                                     LSSQL,
                                     IAPICONSTANT.INFOLEVEL_3 );

        
        OPEN AQINGCHAR FOR LSSQL
        USING ANLANGUAGEID,
              ASPARTNO,
              ANREVISION,
              ANINGDETAILTYPE,
              ANINGREDIENT
              ;

        RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
     ELSE
        LSSQL :=
            ' SELECT '
         || LSSELECT2
         || ' FROM '
         || LSFROM2
         || ' WHERE sid.part_no = :PartNo '
         || ' AND sid.revision = :Revision '
         || ' AND sid.ingdetail_characteristic = ca.characteristic_id '
         || ' AND sid.ingredient = :Ingredient '
         ;

        IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                     LSMETHOD,
                                     LSSQL,
                                     IAPICONSTANT.INFOLEVEL_3 );

        
        OPEN AQINGCHAR FOR LSSQL
        USING ANLANGUAGEID,
              ASPARTNO,
              ANREVISION,
              ANINGREDIENT
              ;

        RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
     END IF;
   END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETINGREDIENTCHARACTERISTICS;

END IAPISPECIFICATIONINGRDIENTLIST;
CREATE OR REPLACE PACKAGE BODY iapiSpecificationPropertyGroup
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

   
   
   

   
   
   
   
   FUNCTION ISITEMEXTENDED(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE,
      ANREFID                    IN       IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPID          IN       IAPITYPE.ID_TYPE,
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE,
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

      SELECT DECODE( COUNT( * ),
                     0, 0,
                     1 )
        INTO ANEXTENDED
        FROM ITSHEXT
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND SECTION_ID = ANSECTIONID
         AND SUB_SECTION_ID = ANSUBSECTIONID
         AND (     (     ANTYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY
                     AND TYPE = ANTYPE )
               OR (     ANTYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP
                    AND TYPE IN( IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY, IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP ) ) )
         AND REF_ID = ANREFID
         AND PROPERTY_GROUP = ANPROPERTYGROUPID
         AND PROPERTY = ANPROPERTYID
         AND ATTRIBUTE = ANATTRIBUTEID;

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
      ANREFID                    IN       IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPID          IN       IAPITYPE.ID_TYPE,
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE )
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
      LNRETVAL :=
         IAPISPECIFICATIONPROPERTYGROUP.ISITEMEXTENDED( ASPARTNO,
                                                        ANREVISION,
                                                        ANSECTIONID,
                                                        ANSUBSECTIONID,
                                                        ANTYPE,
                                                        ANREFID,
                                                        ANPROPERTYGROUPID,
                                                        ANPROPERTYID,
                                                        ANATTRIBUTEID,
                                                        LNEXTENDED );
      
      RETURN( LNEXTENDED );
   END ISITEMEXTENDED;

   
   PROCEDURE CHECKBASICPROPGROUPPARAMS(
      ARPROPERTYGROUP            IN       IAPITYPE.SPPROPERTYGROUPREC_TYPE )
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckBasicPropGroupParams';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESSLEVEL                 IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ARPROPERTYGROUP.PARTNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PartNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartNo',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARPROPERTYGROUP.REVISION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Revision' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRevision',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARPROPERTYGROUP.SECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SectionId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSectionId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARPROPERTYGROUP.SUBSECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SubSectionId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSubSectionId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARPROPERTYGROUP.ITEMID IS NULL )
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

      IF F_CHECK_ITEM_ACCESS( ARPROPERTYGROUP.PARTNO,
                              ARPROPERTYGROUP.REVISION,
                              ARPROPERTYGROUP.SECTIONID,
                              ARPROPERTYGROUP.SUBSECTIONID,
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
                                                ARPROPERTYGROUP.PARTNO,
                                                ARPROPERTYGROUP.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARPROPERTYGROUP.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARPROPERTYGROUP.SUBSECTIONID,
                                                             0 ),
                                                'PROPERTY GROUP' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No Edit Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 0;

      IF F_CHECK_ITEM_ACCESS( ARPROPERTYGROUP.PARTNO,
                              ARPROPERTYGROUP.REVISION,
                              ARPROPERTYGROUP.SECTIONID,
                              ARPROPERTYGROUP.SUBSECTIONID,
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
                                                ARPROPERTYGROUP.PARTNO,
                                                ARPROPERTYGROUP.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARPROPERTYGROUP.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARPROPERTYGROUP.SUBSECTIONID,
                                                             0 ),
                                                'PROPERTY GROUP' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No View Section Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 2;

      IF F_CHECK_ITEM_ACCESS( ARPROPERTYGROUP.PARTNO,
                              ARPROPERTYGROUP.REVISION,
                              ARPROPERTYGROUP.SECTIONID,
                              ARPROPERTYGROUP.SUBSECTIONID,
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
                                                ARPROPERTYGROUP.PARTNO,
                                                ARPROPERTYGROUP.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARPROPERTYGROUP.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARPROPERTYGROUP.SUBSECTIONID,
                                                             0 ),
                                                'PROPERTY GROUP' );
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
   END CHECKBASICPROPGROUPPARAMS;

   
   FUNCTION GETINSERTCOLUMNNAMES
      RETURN IAPITYPE.CLOB_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetInsertColumnNames';
      LSINSERT                      IAPITYPE.CLOB_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSINSERT := 'part_no,revision,section_id,sub_section_id,section_rev,sub_section_rev,';
      LSINSERT :=    LSINSERT
                  || 'property_group,property,attribute,uom_id,';
      LSINSERT :=    LSINSERT
                  || 'property_group_rev,property_rev,attribute_rev,uom_rev,';
      LSINSERT :=    LSINSERT
                  || 'test_method,test_method_rev,sequence_no,characteristic,characteristic_rev,';
      LSINSERT :=    LSINSERT
                  || 'association,association_rev,intl,';
      LSINSERT :=    LSINSERT
                  || 'num_1,num_2,num_3,num_4,num_5,num_6,num_7,num_8,num_9,num_10,';
      LSINSERT :=    LSINSERT
                  || 'char_1,char_2,char_3,char_4,char_5,char_6,';
      LSINSERT :=    LSINSERT
                  || 'boolean_1,boolean_2,boolean_3,boolean_4,';
      LSINSERT :=    LSINSERT
                  || 'date_1,date_2,';
      LSINSERT :=    LSINSERT
                  || 'ch_2,ch_rev_2,ch_3,ch_rev_3,';
      LSINSERT :=    LSINSERT
                  || 'as_2,as_rev_2,as_3,as_rev_3,';
      LSINSERT :=    LSINSERT
                  || 'uom_alt_id,uom_alt_rev';
      RETURN( LSINSERT );
   END GETINSERTCOLUMNNAMES;

   
   PROCEDURE CHECKBASICPROPERTYPARAMS(
      ARPROPERTY                 IN       IAPITYPE.SPPROPERTYREC_TYPE )
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckBasicPropertyParams';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESSLEVEL                 IAPITYPE.ID_TYPE;
      LNASSOCIATION                 IAPITYPE.ID_TYPE;
      LNTESTMETHOD                  IAPITYPE.ID_TYPE;
      LNCOUNT                       NUMBER;
      LNLOGGINGENABLED              BOOLEAN := FALSE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ARPROPERTY.PARTNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PartNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartNo',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARPROPERTY.REVISION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Revision' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRevision',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARPROPERTY.SECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SectionId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSectionId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARPROPERTY.SUBSECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SubSectionId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSubSectionId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARPROPERTY.PROPERTYGROUPID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PropertyGroupId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anPropertyGroupId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARPROPERTY.PROPERTYID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PropertyId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anPropertyId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARPROPERTY.ATTRIBUTEID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'AttributeId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anAttributeId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      IF ARPROPERTY.TESTMETHODID > 0
      THEN
         BEGIN
            SELECT TEST_METHOD
              INTO LNTESTMETHOD
              FROM SPECIFICATION_PROP
             WHERE PART_NO = ARPROPERTY.PARTNO
               AND REVISION = ARPROPERTY.REVISION
               AND SECTION_ID = ARPROPERTY.SECTIONID
               AND SUB_SECTION_ID = ARPROPERTY.SUBSECTIONID
               AND PROPERTY_GROUP = ARPROPERTY.PROPERTYGROUPID
               AND PROPERTY = ARPROPERTY.PROPERTYID
               AND ATTRIBUTE = ARPROPERTY.ATTRIBUTEID;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LNTESTMETHOD := NULL;
         END;

         
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM PROPERTY_TEST_METHOD,
                TEST_METHOD_H,
                TEST_METHOD
          WHERE ( PROPERTY_TEST_METHOD.TEST_METHOD = TEST_METHOD_H.TEST_METHOD )
            AND ( TEST_METHOD_H.TEST_METHOD = TEST_METHOD.TEST_METHOD )
            AND (      ( PROPERTY_TEST_METHOD.PROPERTY = ARPROPERTY.PROPERTYID )
                  AND ( TEST_METHOD_H.MAX_REV = 1 ) )
            AND TEST_METHOD.STATUS = 0
            AND TEST_METHOD.TEST_METHOD = ARPROPERTY.TESTMETHODID;

         IF LNCOUNT = 0
         THEN
            IF     LNTESTMETHOD IS NOT NULL
               AND LNTESTMETHOD = ARPROPERTY.TESTMETHODID
            THEN
               LNLOGGINGENABLED := IAPIGENERAL.LOGGINGENABLED;

               IF NOT IAPIGENERAL.LOGGINGENABLED
               THEN
                  IAPIGENERAL.LOGGINGENABLED := TRUE;
               END IF;

               IAPIGENERAL.LOGWARNING( GSSOURCE,
                                       LSMETHOD,
                                          'Test method <'
                                       || ARPROPERTY.TESTMETHODID
                                       || '> not assigned to property <'
                                       || ARPROPERTY.PROPERTYID
                                       || '>' );
               IAPIGENERAL.LOGGINGENABLED := LNLOGGINGENABLED;
               LNRETVAL :=
                  IAPIGENERAL.ADDERRORTOLIST( 'anTestMethodId',
                                                 'Test method <'
                                              || ARPROPERTY.TESTMETHODID
                                              || '> not assigned to property <'
                                              || ARPROPERTY.PROPERTYID
                                              || '>',
                                              GTERRORS,
                                              IAPICONSTANT.ERRORMESSAGE_WARNING );
            ELSE
               LNRETVAL :=
                  IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                      LSMETHOD,
                                                      IAPICONSTANTDBERROR.DBERR_TMNOTASSIGNEDTOPROP,
                                                      ARPROPERTY.TESTMETHODID,
                                                      
                                                      
                                                      F_SPH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ARPROPERTY.PROPERTYID, 0) );                                            
                                                      
               LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anTestMethodId',
                                                       IAPICONSTANTDBERROR.DBERR_TMNOTASSIGNEDTOPROP,
                                                       GTERRORS );
            END IF;
         END IF;
      END IF;

      IF ARPROPERTY.CHARACTERISTICID1 > 0
      THEN
         
         BEGIN
            SELECT ASSOCIATION
              INTO LNASSOCIATION
              FROM SPECIFICATION_PROP
             WHERE PART_NO = ARPROPERTY.PARTNO
               AND REVISION = ARPROPERTY.REVISION
               AND SECTION_ID = ARPROPERTY.SECTIONID
               AND SUB_SECTION_ID = ARPROPERTY.SUBSECTIONID
               AND PROPERTY_GROUP = ARPROPERTY.PROPERTYGROUPID
               AND PROPERTY = ARPROPERTY.PROPERTYID
               AND ATTRIBUTE = ARPROPERTY.ATTRIBUTEID;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LNASSOCIATION := NULL;
         END;

         IF LNASSOCIATION IS NOT NULL
         THEN
            BEGIN
               SELECT COUNT( * )
                 INTO LNCOUNT
                 FROM CHARACTERISTIC_ASSOCIATION
                WHERE ASSOCIATION = LNASSOCIATION
                  AND CHARACTERISTIC = ARPROPERTY.CHARACTERISTICID1;
            END;

            IF LNCOUNT = 0
            THEN
               LNRETVAL :=
                        IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_CHARNOTASSIGNEDTOASS,
                                                            'CharacteristicId1' );
               LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'CharacteristicId1',
                                                       IAPIGENERAL.GETLASTERRORTEXT( ),
                                                       GTERRORS );
            END IF;
         END IF;
      END IF;

      IF ARPROPERTY.CHARACTERISTICID2 > 0
      THEN
         
         BEGIN
            SELECT AS_2
              INTO LNASSOCIATION
              FROM SPECIFICATION_PROP
             WHERE PART_NO = ARPROPERTY.PARTNO
               AND REVISION = ARPROPERTY.REVISION
               AND SECTION_ID = ARPROPERTY.SECTIONID
               AND SUB_SECTION_ID = ARPROPERTY.SUBSECTIONID
               AND PROPERTY_GROUP = ARPROPERTY.PROPERTYGROUPID
               AND PROPERTY = ARPROPERTY.PROPERTYID
               AND ATTRIBUTE = ARPROPERTY.ATTRIBUTEID;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LNASSOCIATION := NULL;
         END;

         IF LNASSOCIATION IS NOT NULL
         THEN
            BEGIN
               SELECT COUNT( * )
                 INTO LNCOUNT
                 FROM CHARACTERISTIC_ASSOCIATION
                WHERE ASSOCIATION = LNASSOCIATION
                  AND CHARACTERISTIC = ARPROPERTY.CHARACTERISTICID2;
            END;

            IF LNCOUNT = 0
            THEN
               LNRETVAL :=
                        IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_CHARNOTASSIGNEDTOASS,
                                                            'CharacteristicId2' );
               LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'CharacteristicId2',
                                                       IAPIGENERAL.GETLASTERRORTEXT( ),
                                                       GTERRORS );
            END IF;
         END IF;
      END IF;

      IF ARPROPERTY.CHARACTERISTICID3 > 0
      THEN
         
         BEGIN
            SELECT AS_3
              INTO LNASSOCIATION
              FROM SPECIFICATION_PROP
             WHERE PART_NO = ARPROPERTY.PARTNO
               AND REVISION = ARPROPERTY.REVISION
               AND SECTION_ID = ARPROPERTY.SECTIONID
               AND SUB_SECTION_ID = ARPROPERTY.SUBSECTIONID
               AND PROPERTY_GROUP = ARPROPERTY.PROPERTYGROUPID
               AND PROPERTY = ARPROPERTY.PROPERTYID
               AND ATTRIBUTE = ARPROPERTY.ATTRIBUTEID;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LNASSOCIATION := NULL;
         END;

         IF LNASSOCIATION IS NOT NULL
         THEN
            BEGIN
               SELECT COUNT( * )
                 INTO LNCOUNT
                 FROM CHARACTERISTIC_ASSOCIATION
                WHERE ASSOCIATION = LNASSOCIATION
                  AND CHARACTERISTIC = ARPROPERTY.CHARACTERISTICID3;
            END;

            IF LNCOUNT = 0
            THEN
               LNRETVAL :=
                        IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_CHARNOTASSIGNEDTOASS,
                                                            'CharacteristicId3' );
               LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'CharacteristicId3',
                                                       IAPIGENERAL.GETLASTERRORTEXT( ),
                                                       GTERRORS );
            END IF;
         END IF;
      END IF;

      IF ARPROPERTY.ALTERNATIVELANGUAGEID > 1
      THEN
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM ITLANG
          WHERE LANG_ID = ARPROPERTY.ALTERNATIVELANGUAGEID;

         IF LNCOUNT <> 1
         THEN
            LNRETVAL :=
                IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_INVALIDLANGUAGE,
                                                    ARPROPERTY.ALTERNATIVELANGUAGEID );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'AlternativeLanguageId',
                                                    IAPIGENERAL.GETLASTERRORTEXT( ),
                                                    GTERRORS );
         END IF;
      END IF;

      
      LNACCESSLEVEL := 1;

      IF F_CHECK_ITEM_ACCESS( ARPROPERTY.PARTNO,
                              ARPROPERTY.REVISION,
                              ARPROPERTY.SECTIONID,
                              ARPROPERTY.SUBSECTIONID,
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
                                                ARPROPERTY.PARTNO,
                                                ARPROPERTY.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARPROPERTY.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARPROPERTY.SUBSECTIONID,
                                                             0 ),
                                                'PROPERTY GROUP' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No Edit Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 0;

      IF F_CHECK_ITEM_ACCESS( ARPROPERTY.PARTNO,
                              ARPROPERTY.REVISION,
                              ARPROPERTY.SECTIONID,
                              ARPROPERTY.SUBSECTIONID,
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
                                                ARPROPERTY.PARTNO,
                                                ARPROPERTY.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARPROPERTY.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARPROPERTY.SUBSECTIONID,
                                                             0 ),
                                                'PROPERTY GROUP' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No View Section Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 2;

      IF F_CHECK_ITEM_ACCESS( ARPROPERTY.PARTNO,
                              ARPROPERTY.REVISION,
                              ARPROPERTY.SECTIONID,
                              ARPROPERTY.SUBSECTIONID,
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
                                                ARPROPERTY.PARTNO,
                                                ARPROPERTY.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARPROPERTY.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARPROPERTY.SUBSECTIONID,
                                                             0 ),
                                                'PROPERTY GROUP' );
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
   END CHECKBASICPROPERTYPARAMS;

   
   PROCEDURE CHECKBASICTESTMETHODPARAMS(
      ARTESTMETHOD               IN       IAPITYPE.SPTESTMETHODREC_TYPE )
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckBasicTestMethodParams';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESSLEVEL                 IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ARTESTMETHOD.PARTNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PartNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartNo',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARTESTMETHOD.REVISION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Revision' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRevision',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARTESTMETHOD.SECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SectionId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSectionId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARTESTMETHOD.SUBSECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SubSectionId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSubSectionId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARTESTMETHOD.PROPERTYGROUPID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PropertyGroupId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anPropertyGroupId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARTESTMETHOD.PROPERTYID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PropertyId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anPropertyId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARTESTMETHOD.ATTRIBUTEID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'AttributeId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anAttributeId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ARTESTMETHOD.SEQUENCENO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SequenceNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSequenceNo',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 1;

      IF F_CHECK_ITEM_ACCESS( ARTESTMETHOD.PARTNO,
                              ARTESTMETHOD.REVISION,
                              ARTESTMETHOD.SECTIONID,
                              ARTESTMETHOD.SUBSECTIONID,
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
                                                ARTESTMETHOD.PARTNO,
                                                ARTESTMETHOD.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARTESTMETHOD.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARTESTMETHOD.SUBSECTIONID,
                                                             0 ),
                                                'PROPERTY GROUP' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No Edit Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 0;

      IF F_CHECK_ITEM_ACCESS( ARTESTMETHOD.PARTNO,
                              ARTESTMETHOD.REVISION,
                              ARTESTMETHOD.SECTIONID,
                              ARTESTMETHOD.SUBSECTIONID,
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
                                                ARTESTMETHOD.PARTNO,
                                                ARTESTMETHOD.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARTESTMETHOD.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARTESTMETHOD.SUBSECTIONID,
                                                             0 ),
                                                'PROPERTY GROUP' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'No View Section Access ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      LNACCESSLEVEL := 2;

      IF F_CHECK_ITEM_ACCESS( ARTESTMETHOD.PARTNO,
                              ARTESTMETHOD.REVISION,
                              ARTESTMETHOD.SECTIONID,
                              ARTESTMETHOD.SUBSECTIONID,
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
                                                ARTESTMETHOD.PARTNO,
                                                ARTESTMETHOD.REVISION,
                                                F_SCH_DESCR( NULL,
                                                             ARTESTMETHOD.SECTIONID,
                                                             0 ),
                                                F_SBH_DESCR( NULL,
                                                             ARTESTMETHOD.SUBSECTIONID,
                                                             0 ),
                                                'PROPERTY GROUP' );
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
   END CHECKBASICTESTMETHODPARAMS;

   
   FUNCTION EXISTPROPERTYINGROUP(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPID          IN       IAPITYPE.ID_TYPE,
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistPropertyInGroup';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LRFRAME                       IAPITYPE.FRAMEREC_TYPE;
      LBINFRAME                     IAPITYPE.BOOLEAN_TYPE DEFAULT 0;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE DEFAULT 0;
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

      
      LNRETVAL := IAPISPECIFICATIONSECTION.EXISTID( ASPARTNO,
                                                    ANREVISION,
                                                    ANSECTIONID,
                                                    ANSUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         LNRETVAL := IAPIFRAMESECTION.EXISTID( LRFRAME.FRAMENO,
                                               LRFRAME.REVISION,
                                               LRFRAME.OWNER,
                                               ANSECTIONID,
                                               ANSUBSECTIONID );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         LBINFRAME := 1;
      END IF;

      
      IF ( ANPROPERTYGROUPID = 0 )
      THEN
         
         LNRETVAL :=
            IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( ASPARTNO,
                                                         ANREVISION,
                                                         ANSECTIONID,
                                                         ANSUBSECTIONID,
                                                         IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY,
                                                         ANPROPERTYID );
      ELSE
         IF LBINFRAME = 0
         THEN
            
            LNRETVAL :=
               IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( ASPARTNO,
                                                            ANREVISION,
                                                            ANSECTIONID,
                                                            ANSUBSECTIONID,
                                                            IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP,
                                                            ANPROPERTYGROUPID );
         ELSE
            LNRETVAL :=
               IAPIFRAMESECTION.EXISTITEMINSECTION( LRFRAME.FRAMENO,
                                                    LRFRAME.REVISION,
                                                    LRFRAME.OWNER,
                                                    ANSECTIONID,
                                                    ANSUBSECTIONID,
                                                    IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP,
                                                    ANPROPERTYGROUPID );
         END IF;
      END IF;

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

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM SPECIFICATION_PROP
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PROPERTY_GROUP = ANPROPERTYGROUPID
         AND PROPERTY = ANPROPERTYID
         AND ATTRIBUTE = ANATTRIBUTEID
         AND SECTION_ID = ANSECTIONID
         AND SUB_SECTION_ID = ANSUBSECTIONID;

      IF LNCOUNT = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SPPROPERTYNOTFOUND,
                                                     ASPARTNO,
                                                     ANREVISION,
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSUBSECTIONID, 0),                                            
                                                     F_PGH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANPROPERTYGROUPID, 0),                                            
                                                     F_SPH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANPROPERTYID, 0),                                            
                                                     F_ATH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANATTRIBUTEID, 0)));
                                                     
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTPROPERTYINGROUP;

   
   FUNCTION ISPROPERTYACTIONALLOWED(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPID          IN       IAPITYPE.ID_TYPE,
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE,
      ASACTION                   IN       IAPITYPE.STRING_TYPE,
      ANALLOWED                  OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsPropertyActionAllowed';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRFRAME                       IAPITYPE.FRAMEREC_TYPE;
      LSMANDATORY                   IAPITYPE.MANDATORY_TYPE;
      LNCOUNT                       NUMBER;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              ' asPartNo = '
                           || ASPARTNO
                           || ' anRevision = '
                           || ANREVISION
                           || ' anSectionId = '
                           || ANSECTIONID
                           || ' anSubSectionId = '
                           || ANSUBSECTIONID
                           || ' anPropertyGroupId = '
                           || ANPROPERTYGROUPID
                           || ' anPropertyId = '
                           || ANPROPERTYID
                           || ' anAttributeId = '
                           || ANATTRIBUTEID
                           || ' asAction = '
                           || ASACTION,
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

      IF ( ASACTION = 'EXTEND' )
      THEN
         
         
         BEGIN
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM FRAME_PROP
             WHERE FRAME_NO = LRFRAME.FRAMENO
               AND REVISION = LRFRAME.REVISION
               AND OWNER = LRFRAME.OWNER
               AND SECTION_ID = ANSECTIONID
               AND SUB_SECTION_ID = ANSUBSECTIONID
               AND PROPERTY_GROUP = ANPROPERTYGROUPID
               AND PROPERTY = ANPROPERTYID
               AND ATTRIBUTE = ANATTRIBUTEID;

            IF ( LNCOUNT > 0 )
            THEN
               ANALLOWED := 0;
            ELSE
               ANALLOWED := 1;
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               ANALLOWED := 1;
         END;
      ELSE
         IF ( LRFRAME.MASKID IS NULL )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 'No mask specified; check mandatory flag in frame_prop.',
                                 IAPICONSTANT.INFOLEVEL_3 );

            
            BEGIN
               SELECT MANDATORY
                 INTO LSMANDATORY
                 FROM FRAME_PROP
                WHERE FRAME_NO = LRFRAME.FRAMENO
                  AND REVISION = LRFRAME.REVISION
                  AND OWNER = LRFRAME.OWNER
                  AND SECTION_ID = ANSECTIONID
                  AND SUB_SECTION_ID = ANSUBSECTIONID
                  AND PROPERTY_GROUP = ANPROPERTYGROUPID
                  AND PROPERTY = ANPROPERTYID
                  AND ATTRIBUTE = ANATTRIBUTEID;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;   
            END;
         ELSE
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 'Mask specified; check mandatory flag in itfrmvpg.',
                                 IAPICONSTANT.INFOLEVEL_3 );

            
            BEGIN
               SELECT MANDATORY
                 INTO LSMANDATORY
                 FROM ITFRMVPG
                WHERE FRAME_NO = LRFRAME.FRAMENO
                  AND REVISION = LRFRAME.REVISION
                  AND OWNER = LRFRAME.OWNER
                  AND SECTION_ID = ANSECTIONID
                  AND SUB_SECTION_ID = ANSUBSECTIONID
                  AND PROPERTY_GROUP = ANPROPERTYGROUPID
                  AND PROPERTY = ANPROPERTYID
                  AND ATTRIBUTE = ANATTRIBUTEID
                  AND VIEW_ID = LRFRAME.MASKID;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;   
            END;
         END IF;

         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Value of lsMandatory: '
                              || LSMANDATORY );






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
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Action <'
                           || ASACTION
                           || '>, Mandatory <'
                           || LSMANDATORY
                           || '> and Allowed <'
                           || ANALLOWED
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ISPROPERTYACTIONALLOWED;

   
   FUNCTION ISEXTENDABLE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ASTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE,
      ANEXTENDABLE               OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsExtendable';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRFRAME                       IAPITYPE.FRAMEREC_TYPE;
   BEGIN
      IF ASTYPE NOT IN( IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP, IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY )
      THEN
         ANEXTENDABLE := 0;
         RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      IF ASTYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP
      THEN
         LNRETVAL :=
            IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( ASPARTNO,
                                                         ANREVISION,
                                                         ANSECTIONID,
                                                         ANSUBSECTIONID,
                                                         IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP,
                                                         ANITEMID );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END IF;

      IF ASTYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY
      THEN
         LNRETVAL :=
            IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( ASPARTNO,
                                                         ANREVISION,
                                                         ANSECTIONID,
                                                         ANSUBSECTIONID,
                                                         IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY,
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

      IF ( ASTYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP )
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

         ANEXTENDABLE :=
            IAPISPECIFICATIONPROPERTYGROUP.ISITEMEXTENDED( ASPARTNO,
                                                           ANREVISION,
                                                           ANSECTIONID,
                                                           ANSUBSECTIONID,
                                                           IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP,
                                                           ANITEMID,
                                                           ANITEMID,
                                                           0,
                                                           0 );

         IF ANEXTENDABLE = 0
         THEN
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
                        AND TYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP
                        AND REF_ID = ANITEMID;
         END IF;
      END IF;

      IF ( ASTYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY )
      THEN
         ANEXTENDABLE :=
            IAPISPECIFICATIONPROPERTYGROUP.ISITEMEXTENDED( ASPARTNO,
                                                           ANREVISION,
                                                           ANSECTIONID,
                                                           ANSUBSECTIONID,
                                                           IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY,
                                                           ANITEMID,
                                                           0,
                                                           ANITEMID,
                                                           0 );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      
      WHEN NO_DATA_FOUND
      THEN
         NULL;
         
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );       
      
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ISEXTENDABLE;

   
   FUNCTION ISEXTENDABLE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ASTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE )
      RETURN IAPITYPE.BOOLEAN_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsExtendable';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNEXTENDED                    IAPITYPE.BOOLEAN_TYPE := 0;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPISPECIFICATIONPROPERTYGROUP.ISEXTENDABLE( ASPARTNO,
                                                               ANREVISION,
                                                               ANSECTIONID,
                                                               ANSUBSECTIONID,
                                                               ANITEMID,
                                                               ASTYPE,
                                                               LNEXTENDED );
      RETURN( LNEXTENDED );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ISEXTENDABLE;

   
   
   
   
   FUNCTION ADDPROPERTYGROUP(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANSINGLEPROPERTY           IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      
      
      
      AQINFO                     IN OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   IN OUT      IAPITYPE.REF_TYPE )
      
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddPropertyGroup';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRPROPERTYGROUP               IAPITYPE.SPPROPERTYGROUPREC_TYPE;
      LRFRAME                       IAPITYPE.FRAMEREC_TYPE;
      LSINSERT                      IAPITYPE.CLOB_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSELECT                      IAPITYPE.CLOB_TYPE;
      LSSPECIFICATIONSECTIONTYPE    IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE;
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
      GTPROPERTYGROUPS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRPROPERTYGROUP.PARTNO := ASPARTNO;
      LRPROPERTYGROUP.REVISION := ANREVISION;
      LRPROPERTYGROUP.SECTIONID := ANSECTIONID;
      LRPROPERTYGROUP.SUBSECTIONID := ANSUBSECTIONID;
      LRPROPERTYGROUP.ITEMID := ANITEMID;
      GTPROPERTYGROUPS( 0 ) := LRPROPERTYGROUP;

      GTINFO( 0 ) := LRINFO;

      IF ( ANSINGLEPROPERTY = 0 )
      THEN
         LSSPECIFICATIONSECTIONTYPE := IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP;
      ELSE
         LSSPECIFICATIONSECTIONTYPE := IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY;
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
      
      
      
      
      
      
      
      
      
      
      
      CHECKBASICPROPGROUPPARAMS( LRPROPERTYGROUP );

      
      
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
         IAPISPECIFICATIONSECTION.ADDSECTIONITEM( LRPROPERTYGROUP.PARTNO,
                                                  LRPROPERTYGROUP.REVISION,
                                                  LRPROPERTYGROUP.SECTIONID,
                                                  LRPROPERTYGROUP.SUBSECTIONID,
                                                  LSSPECIFICATIONSECTIONTYPE,
                                                  LRPROPERTYGROUP.ITEMID,
                                                  AFHANDLE => AFHANDLE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.ISACTIONALLOWED( LRPROPERTYGROUP.PARTNO,
                                                   LRPROPERTYGROUP.REVISION,
                                                   LRPROPERTYGROUP.SECTIONID,
                                                   LRPROPERTYGROUP.SUBSECTIONID,
                                                   LSSPECIFICATIONSECTIONTYPE,
                                                   LRPROPERTYGROUP.ITEMID,
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
                                                     LRPROPERTYGROUP.ITEMID,
                                                     LSSPECIFICATIONSECTIONTYPE,
                                                     LRPROPERTYGROUP.PARTNO,
                                                     LRPROPERTYGROUP.REVISION,
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTYGROUP.SECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTYGROUP.SUBSECTIONID, 0) ));
                                                     
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.GETFRAME( LRPROPERTYGROUP.PARTNO,
                                              LRPROPERTYGROUP.REVISION,
                                              LRFRAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LSINSERT := GETINSERTCOLUMNNAMES;
      
      LSSELECT := ':PartNo,:PartRevision,';
      LSSELECT :=
            LSSELECT
         || 'fp.section_id,fp.sub_section_id,f_get_sub_rev(fp.section_id,fp.section_rev,null,null,''SC''),f_get_sub_rev(fp.sub_section_id,fp.sub_section_rev,null,null,''SB''),';
      LSSELECT :=    LSSELECT
                  || 'fp.property_group,fp.property,fp.attribute,fp.uom_id,';
      LSSELECT :=
            LSSELECT
         || 'f_get_sub_rev(fp.property_group,fp.property_group_rev,null,null,''PG''),f_get_sub_rev(fp.property,fp.property_rev,null,null,''SP''),f_get_sub_rev(fp.attribute,fp.attribute_rev,null,null,''AT''),f_get_sub_rev(fp.uom_id,fp.uom_rev,null,null,''UO''),';
      LSSELECT :=
            LSSELECT
         || 'fp.test_method,f_get_sub_rev(fp.test_method,fp.test_method_rev,null,null,''TM''),fp.sequence_no,fp.characteristic,NVL(f_get_sub_rev(fp.characteristic,fp.characteristic_rev,null,null,''CH''),0),';
      LSSELECT :=    LSSELECT
                  || 'fp.association,f_get_sub_rev(fp.association,fp.association_rev,null,null,''AS''),fp.intl,';
      LSSELECT :=    LSSELECT
                  || 'fp.num_1,fp.num_2,fp.num_3,fp.num_4,fp.num_5,fp.num_6,fp.num_7,fp.num_8,fp.num_9,fp.num_10,';
      LSSELECT :=    LSSELECT
                  || 'fp.char_1,fp.char_2,fp.char_3,fp.char_4,fp.char_5,fp.char_6,';
      LSSELECT :=    LSSELECT
                  || 'fp.boolean_1,fp.boolean_2,fp.boolean_3,fp.boolean_4,';
      LSSELECT :=    LSSELECT
                  || 'fp.date_1,fp.date_2,';
      LSSELECT :=
            LSSELECT
         || 'fp.ch_2,NVL(f_get_sub_rev(fp.ch_2,fp.ch_rev_2,null,null,''CH''),0),fp.ch_3,NVL(f_get_sub_rev(fp.ch_3,fp.ch_rev_3,null,null,''CH''),0),';
      LSSELECT :=
                   LSSELECT
                || 'fp.as_2,f_get_sub_rev(fp.as_2,fp.as_rev_2,null,null,''AS''),fp.as_3,f_get_sub_rev(fp.as_3,fp.as_rev_3,null,null,''AS''),';
      LSSELECT :=    LSSELECT
                  || 'fp.uom_alt_id,f_get_sub_rev(fp.uom_alt_id,fp.uom_alt_rev,null,null,''UO'') ';
      
      LSSQL := 'INSERT INTO specification_prop (';
      LSSQL :=    LSSQL
               || LSINSERT
               || ') ';
      LSSQL :=    LSSQL
               || 'SELECT '
               || LSSELECT;
      LSSQL :=    LSSQL
               || '  FROM frame_prop fp ';
      LSSQL :=    LSSQL
               || ' WHERE fp.frame_no = :FrameNo AND fp.revision = :FrameRevision AND fp.owner = :FrameOwner';
      LSSQL :=    LSSQL
               || '   AND fp.section_id = :SectionId AND fp.sub_section_id = :SubSectionId';

      
      IF ( LSSPECIFICATIONSECTIONTYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP )
      THEN
         LSSQL :=    LSSQL
                  || ' AND fp.property_group = :ItemId';
      ELSE
         LSSQL :=    LSSQL
                  || ' AND fp.property_group = 0 AND fp.property = :ItemId';
      END IF;

      LSSQL :=    LSSQL
               || '   AND fp.mandatory = '''
               || IAPICONSTANT.FLAG_YES
               || '''';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      
      
      
      BEGIN      
      
      EXECUTE IMMEDIATE LSSQL
                  USING LRPROPERTYGROUP.PARTNO,
                        LRPROPERTYGROUP.REVISION,
                        LRFRAME.FRAMENO,
                        LRFRAME.REVISION,
                        LRFRAME.OWNER,
                        LRPROPERTYGROUP.SECTIONID,
                        LRPROPERTYGROUP.SUBSECTIONID,
                        LRPROPERTYGROUP.ITEMID;
     
       EXCEPTION
       WHEN DUP_VAL_ON_INDEX
       THEN
            NULL;
       END;      
      

      
      LSSQL := 'INSERT INTO specification_prop (';
      LSSQL :=    LSSQL
               || LSINSERT
               || ') ';
      LSSQL :=    LSSQL
               || 'SELECT '
               || LSSELECT;
      LSSQL :=    LSSQL
               || '  FROM frame_prop fp, itfrmvpg i ';
      LSSQL :=    LSSQL
               || ' WHERE fp.frame_no = :FrameNo AND fp.revision = :FrameRevision AND fp.owner = :FrameRevision';
      LSSQL :=    LSSQL
               || '   AND fp.section_id = :SectionId AND fp.sub_section_id = :SubSectionId';

      
      IF ( LSSPECIFICATIONSECTIONTYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP )
      THEN
         LSSQL :=    LSSQL
                  || ' AND fp.property_group = :ItemId';
      ELSE
         LSSQL :=    LSSQL
                  || ' AND fp.property_group = 0 AND fp.property = :ItemId';
      END IF;

      LSSQL :=    LSSQL
               || '   AND fp.frame_no = i.frame_no AND fp.revision = i.revision AND fp.owner = i.owner';
      LSSQL :=    LSSQL
               || '   AND fp.section_id = i.section_id AND fp.sub_section_id = i.sub_section_id AND fp.property_group = i.property_group';
      LSSQL :=    LSSQL
               || '   AND fp.property = i.property AND fp.attribute = i.attribute';
      LSSQL :=    LSSQL
               || '   AND i.view_id = :MaskId';
      LSSQL :=    LSSQL
               || '   AND i.mandatory = '''
               || IAPICONSTANT.FLAG_YES
               || '''';

      
      IF ( LSSPECIFICATIONSECTIONTYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP )
      THEN
         LSSQL :=    LSSQL
                  || '   AND (fp.property,fp.attribute) NOT IN (SELECT sp.property, sp.attribute FROM specification_prop sp ';
      ELSE
         LSSQL :=    LSSQL
                  || '   AND (fp.attribute) NOT IN (SELECT sp.attribute FROM specification_prop sp ';
      END IF;

      LSSQL :=
            LSSQL
         || '   WHERE sp.part_no = :PartNo AND sp.revision = :PartRevision AND sp.section_id = :SectionId AND sp.sub_section_id = :SubSectionId';

      
      IF ( LSSPECIFICATIONSECTIONTYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP )
      THEN
         LSSQL :=    LSSQL
                  || ' AND sp.property_group = :ItemId)';
      ELSE
         LSSQL :=    LSSQL
                  || ' AND sp.property_group = 0 AND sp.property = :ItemId)';
      END IF;

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      
      BEGIN
      
      EXECUTE IMMEDIATE LSSQL
                  USING LRPROPERTYGROUP.PARTNO,
                        LRPROPERTYGROUP.REVISION,
                        LRFRAME.FRAMENO,
                        LRFRAME.REVISION,
                        LRFRAME.OWNER,
                        LRPROPERTYGROUP.SECTIONID,
                        LRPROPERTYGROUP.SUBSECTIONID,
                        LRPROPERTYGROUP.ITEMID,
                        LRFRAME.MASKID,
                        LRPROPERTYGROUP.PARTNO,
                        LRPROPERTYGROUP.REVISION,
                        LRPROPERTYGROUP.SECTIONID,
                        LRPROPERTYGROUP.SUBSECTIONID,
                        LRPROPERTYGROUP.ITEMID;
      
       EXCEPTION
       WHEN DUP_VAL_ON_INDEX
       THEN
            NULL;
       END;
       

      
      INSERT INTO SPECDATA_SERVER
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID )
           VALUES ( LRPROPERTYGROUP.PARTNO,
                    LRPROPERTYGROUP.REVISION,
                    LRPROPERTYGROUP.SECTIONID,
                    LRPROPERTYGROUP.SUBSECTIONID );

      LNRETVAL := IAPISPECIFICATION.UPDATELAYOUT( LRPROPERTYGROUP.PARTNO,
                                                  LRPROPERTYGROUP.REVISION,
                                                  1 );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.LOGHISTORY( LRPROPERTYGROUP.PARTNO,
                                              LRPROPERTYGROUP.REVISION,
                                              LRPROPERTYGROUP.SECTIONID,
                                              LRPROPERTYGROUP.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRPROPERTYGROUP.PARTNO,
                                                LRPROPERTYGROUP.REVISION );

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
   END ADDPROPERTYGROUP;

   
   FUNCTION REMOVEPROPERTYGROUP(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANSINGLEPROPERTY           IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemovePropertyGroup';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRPROPERTYGROUP               IAPITYPE.SPPROPERTYGROUPREC_TYPE;
      LSSPECIFICATIONSECTIONTYPE    IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE;
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
      GTPROPERTYGROUPS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRPROPERTYGROUP.PARTNO := ASPARTNO;
      LRPROPERTYGROUP.REVISION := ANREVISION;
      LRPROPERTYGROUP.SECTIONID := ANSECTIONID;
      LRPROPERTYGROUP.SUBSECTIONID := ANSUBSECTIONID;
      LRPROPERTYGROUP.ITEMID := ANITEMID;
      GTPROPERTYGROUPS( 0 ) := LRPROPERTYGROUP;

      GTINFO( 0 ) := LRINFO;

      IF ( ANSINGLEPROPERTY = 0 )
      THEN
         LSSPECIFICATIONSECTIONTYPE := IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP;
      ELSE
         LSSPECIFICATIONSECTIONTYPE := IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY;
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
      
      
      
      
      
      
      
      
      
      
      
      CHECKBASICPROPGROUPPARAMS( LRPROPERTYGROUP );

      
      
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
         IAPISPECIFICATIONSECTION.ISACTIONALLOWED( LRPROPERTYGROUP.PARTNO,
                                                   LRPROPERTYGROUP.REVISION,
                                                   LRPROPERTYGROUP.SECTIONID,
                                                   LRPROPERTYGROUP.SUBSECTIONID,
                                                   LSSPECIFICATIONSECTIONTYPE,
                                                   LRPROPERTYGROUP.ITEMID,
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
                                                     LRPROPERTYGROUP.ITEMID,
                                                     LSSPECIFICATIONSECTIONTYPE,
                                                     LRPROPERTYGROUP.PARTNO,
                                                     LRPROPERTYGROUP.REVISION,
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTYGROUP.SECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTYGROUP.SUBSECTIONID, 0) ));
                                                     
      END IF;

    
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.REMOVESECTIONITEM( LRPROPERTYGROUP.PARTNO,
                                                     LRPROPERTYGROUP.REVISION,
                                                     LRPROPERTYGROUP.SECTIONID,
                                                     LRPROPERTYGROUP.SUBSECTIONID,
                                                     LSSPECIFICATIONSECTIONTYPE,
                                                     LRPROPERTYGROUP.ITEMID,
                                                     AFHANDLE => AFHANDLE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;
    

      
      
      IF ( LSSPECIFICATIONSECTIONTYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP )
      THEN
         DELETE FROM SPECIFICATION_PROP
               WHERE PART_NO = LRPROPERTYGROUP.PARTNO
                 AND REVISION = LRPROPERTYGROUP.REVISION
                 AND SECTION_ID = LRPROPERTYGROUP.SECTIONID
                 AND SUB_SECTION_ID = LRPROPERTYGROUP.SUBSECTIONID
                 AND PROPERTY_GROUP = LRPROPERTYGROUP.ITEMID;

         DELETE FROM SPECIFICATION_TM
               WHERE PART_NO = LRPROPERTYGROUP.PARTNO
                 AND REVISION = LRPROPERTYGROUP.REVISION
                 AND SECTION_ID = LRPROPERTYGROUP.SECTIONID
                 AND SUB_SECTION_ID = LRPROPERTYGROUP.SUBSECTIONID
                 AND PROPERTY_GROUP = LRPROPERTYGROUP.ITEMID;

         DELETE FROM SPECIFICATION_PROP_LANG
               WHERE PART_NO = LRPROPERTYGROUP.PARTNO
                 AND REVISION = LRPROPERTYGROUP.REVISION
                 AND SECTION_ID = LRPROPERTYGROUP.SECTIONID
                 AND SUB_SECTION_ID = LRPROPERTYGROUP.SUBSECTIONID
                 AND PROPERTY_GROUP = LRPROPERTYGROUP.ITEMID;
      ELSE
         DELETE FROM SPECIFICATION_PROP
               WHERE PART_NO = LRPROPERTYGROUP.PARTNO
                 AND REVISION = LRPROPERTYGROUP.REVISION
                 AND SECTION_ID = LRPROPERTYGROUP.SECTIONID
                 AND SUB_SECTION_ID = LRPROPERTYGROUP.SUBSECTIONID
                 AND PROPERTY_GROUP = 0
                 AND PROPERTY = LRPROPERTYGROUP.ITEMID;

         DELETE FROM SPECIFICATION_TM
               WHERE PART_NO = LRPROPERTYGROUP.PARTNO
                 AND REVISION = LRPROPERTYGROUP.REVISION
                 AND SECTION_ID = LRPROPERTYGROUP.SECTIONID
                 AND SUB_SECTION_ID = LRPROPERTYGROUP.SUBSECTIONID
                 AND PROPERTY_GROUP = 0
                 AND PROPERTY = LRPROPERTYGROUP.ITEMID;

         DELETE FROM SPECIFICATION_PROP_LANG
               WHERE PART_NO = LRPROPERTYGROUP.PARTNO
                 AND REVISION = LRPROPERTYGROUP.REVISION
                 AND SECTION_ID = LRPROPERTYGROUP.SECTIONID
                 AND SUB_SECTION_ID = LRPROPERTYGROUP.SUBSECTIONID
                 AND PROPERTY_GROUP = 0
                 AND PROPERTY = LRPROPERTYGROUP.ITEMID;
      END IF;

      
      INSERT INTO SPECDATA_SERVER
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID )
           VALUES ( LRPROPERTYGROUP.PARTNO,
                    LRPROPERTYGROUP.REVISION,
                    LRPROPERTYGROUP.SECTIONID,
                    LRPROPERTYGROUP.SUBSECTIONID );

      
      BEGIN
         
         IF ( LSSPECIFICATIONSECTIONTYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP )
         THEN
            DELETE FROM ITSHEXT
                  WHERE PART_NO = LRPROPERTYGROUP.PARTNO
                    AND REVISION = LRPROPERTYGROUP.REVISION
                    AND SECTION_ID = LRPROPERTYGROUP.SECTIONID
                    AND SUB_SECTION_ID = LRPROPERTYGROUP.SUBSECTIONID
                    AND TYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY
                    AND PROPERTY_GROUP = LRPROPERTYGROUP.ITEMID;
         ELSE
            DELETE FROM ITSHEXT
                  WHERE PART_NO = LRPROPERTYGROUP.PARTNO
                    AND REVISION = LRPROPERTYGROUP.REVISION
                    AND SECTION_ID = LRPROPERTYGROUP.SECTIONID
                    AND SUB_SECTION_ID = LRPROPERTYGROUP.SUBSECTIONID
                    AND TYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY
                    AND PROPERTY_GROUP = 0
                    AND PROPERTY = LRPROPERTYGROUP.ITEMID;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;   
      END;

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.LOGHISTORY( LRPROPERTYGROUP.PARTNO,
                                              LRPROPERTYGROUP.REVISION,
                                              LRPROPERTYGROUP.SECTIONID,
                                              LRPROPERTYGROUP.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRPROPERTYGROUP.PARTNO,
                                                LRPROPERTYGROUP.REVISION );

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
   END REMOVEPROPERTYGROUP;

   
   FUNCTION ADDPROPERTY(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPID          IN       IAPITYPE.ID_TYPE,
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      
      
      
      AQINFO                     IN OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   IN OUT      IAPITYPE.REF_TYPE )
      
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddProperty';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRPROPERTY                    IAPITYPE.SPPROPERTYREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LRFRAME                       IAPITYPE.FRAMEREC_TYPE;
      LSINSERT                      IAPITYPE.CLOB_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSELECT                      IAPITYPE.CLOB_TYPE;
      LSMANDATORY                   IAPITYPE.MANDATORY_TYPE;
      LNALLOWED                     IAPITYPE.BOOLEAN_TYPE;
      LSFRAMENO                     IAPITYPE.FRAMENO_TYPE;
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
      GTPROPERTIES.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRPROPERTY.PARTNO := ASPARTNO;
      LRPROPERTY.REVISION := ANREVISION;
      LRPROPERTY.SECTIONID := ANSECTIONID;
      LRPROPERTY.SUBSECTIONID := ANSUBSECTIONID;
      LRPROPERTY.PROPERTYGROUPID := ANPROPERTYGROUPID;
      LRPROPERTY.PROPERTYID := ANPROPERTYID;
      LRPROPERTY.ATTRIBUTEID := ANATTRIBUTEID;
      GTPROPERTIES( 0 ) := LRPROPERTY;

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
      
      
      
      
      
      
      
      
      
      
      
      
      
      CHECKBASICPROPERTYPARAMS( LRPROPERTY );

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

      
      LNRETVAL := IAPISPECIFICATIONACCESS.GETMODIFIABLEACCESS( LRPROPERTY.PARTNO,
                                                               LRPROPERTY.REVISION,
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
                                                     LRPROPERTY.PARTNO,
                                                     LRPROPERTY.REVISION ) );
      END IF;

      
      
      LNRETVAL :=
         IAPISPECIFICATIONPROPERTYGROUP.EXISTPROPERTYINGROUP( LRPROPERTY.PARTNO,
                                                              LRPROPERTY.REVISION,
                                                              LRPROPERTY.SECTIONID,
                                                              LRPROPERTY.SUBSECTIONID,
                                                              LRPROPERTY.PROPERTYGROUPID,
                                                              LRPROPERTY.PROPERTYID,
                                                              LRPROPERTY.ATTRIBUTEID );

      CASE LNRETVAL
         WHEN IAPICONSTANTDBERROR.DBERR_SUCCESS
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_SPPROPERTYALREADYINGROUP,
                                                        LRPROPERTY.PARTNO,
                                                        LRPROPERTY.REVISION,
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.SECTIONID, 0),
                                                        F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.SUBSECTIONID, 0),                                            
                                                        F_PGH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.PROPERTYGROUPID, 0),                                            
                                                        F_SPH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.PROPERTYID, 0),                                            
                                                        F_ATH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.ATTRIBUTEID, 0)));
                                                        
         WHEN IAPICONSTANTDBERROR.DBERR_SPPROPERTYNOTFOUND
         THEN
            
            
            LNRETVAL := IAPISPECIFICATION.GETFRAME( LRPROPERTY.PARTNO,
                                                    LRPROPERTY.REVISION,
                                                    LRFRAME );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    IAPIGENERAL.GETLASTERRORTEXT( ) );
               RETURN( LNRETVAL );
            END IF;

            BEGIN
               SELECT FRAME_NO
                 INTO LSFRAMENO
                 FROM FRAME_PROP
                WHERE FRAME_NO = LRFRAME.FRAMENO
                  AND REVISION = LRFRAME.REVISION
                  AND OWNER = LRFRAME.OWNER
                  AND PROPERTY_GROUP = LRPROPERTY.PROPERTYGROUPID
                  AND PROPERTY = LRPROPERTY.PROPERTYID
                  AND ATTRIBUTE = LRPROPERTY.ATTRIBUTEID
                  AND SECTION_ID = LRPROPERTY.SECTIONID
                  AND SUB_SECTION_ID = LRPROPERTY.SUBSECTIONID;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_FRPROPERTYNOTFOUND,
                                                              LRFRAME.FRAMENO,
                                                              LRFRAME.REVISION,
                                                              LRFRAME.OWNER,
                                                              
                                                              
                                                              
                                                              
                                                              
                                                              
                                                              
                                                              
                                                              F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.SECTIONID, 0),
                                                              F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.SUBSECTIONID, 0),                                            
                                                              F_PGH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.PROPERTYGROUPID, 0),                                            
                                                              F_SPH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.PROPERTYID, 0),                                            
                                                              F_ATH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.ATTRIBUTEID, 0)));
                                                              
               WHEN OTHERS
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        SQLERRM );
                  RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
            END;
         WHEN IAPICONSTANTDBERROR.DBERR_SPSECTIONNOTFOUND
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
      END CASE;

      
      LNRETVAL :=
         IAPISPECIFICATIONPROPERTYGROUP.ISPROPERTYACTIONALLOWED( LRPROPERTY.PARTNO,
                                                                 LRPROPERTY.REVISION,
                                                                 LRPROPERTY.SECTIONID,
                                                                 LRPROPERTY.SUBSECTIONID,
                                                                 LRPROPERTY.PROPERTYGROUPID,
                                                                 LRPROPERTY.PROPERTYID,
                                                                 LRPROPERTY.ATTRIBUTEID,
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
                                                     IAPICONSTANTDBERROR.DBERR_SPPROPERTYNOTALLOWED,
                                                     LRPROPERTY.PARTNO,
                                                     LRPROPERTY.REVISION,
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.SECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.SUBSECTIONID, 0),                                            
                                                     F_PGH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.PROPERTYGROUPID, 0),                                            
                                                     F_SPH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.PROPERTYID, 0),                                            
                                                     F_ATH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.ATTRIBUTEID, 0)));
                                                     
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNRETVAL := IAPISPECIFICATION.GETFRAME( LRPROPERTY.PARTNO,
                                              LRPROPERTY.REVISION,
                                              LRFRAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LSINSERT := GETINSERTCOLUMNNAMES;
      
      LSSELECT := ':PartNo,:PartRevision,';
      LSSELECT :=
            LSSELECT
         || 'fp.section_id,fp.sub_section_id,f_get_sub_rev(fp.section_id,fp.section_rev,null,null,''SC''),f_get_sub_rev(fp.sub_section_id,fp.sub_section_rev,null,null,''SB''),';
      LSSELECT :=    LSSELECT
                  || 'fp.property_group,fp.property,fp.attribute,fp.uom_id,';
      LSSELECT :=
            LSSELECT
         || 'f_get_sub_rev(fp.property_group,fp.property_group_rev,null,null,''PG''),f_get_sub_rev(fp.property,fp.property_rev,null,null,''SP''),f_get_sub_rev(fp.attribute,fp.attribute_rev,null,null,''AT''),f_get_sub_rev(fp.uom_id,fp.uom_rev,null,null,''UO''),';
      LSSELECT :=
            LSSELECT
         || 'fp.test_method,f_get_sub_rev(fp.test_method,fp.test_method_rev,null,null,''TM''),fp.sequence_no,fp.characteristic,NVL(f_get_sub_rev(fp.characteristic,fp.characteristic_rev,null,null,''CH''),0),';
      LSSELECT :=    LSSELECT
                  || 'fp.association,f_get_sub_rev(fp.association,fp.association_rev,null,null,''AS''),fp.intl,';
      LSSELECT :=    LSSELECT
                  || 'fp.num_1,fp.num_2,fp.num_3,fp.num_4,fp.num_5,fp.num_6,fp.num_7,fp.num_8,fp.num_9,fp.num_10,';
      LSSELECT :=    LSSELECT
                  || 'fp.char_1,fp.char_2,fp.char_3,fp.char_4,fp.char_5,fp.char_6,';
      LSSELECT :=    LSSELECT
                  || 'fp.boolean_1,fp.boolean_2,fp.boolean_3,fp.boolean_4,';
      LSSELECT :=    LSSELECT
                  || 'fp.date_1,fp.date_2,';
      LSSELECT :=
            LSSELECT
         || 'fp.ch_2,NVL(f_get_sub_rev(fp.ch_2,fp.ch_rev_2,null,null,''CH''),0),fp.ch_3,NVL(f_get_sub_rev(fp.ch_3,fp.ch_rev_3,null,null,''CH''),0),';
      LSSELECT :=
                   LSSELECT
                || 'fp.as_2,f_get_sub_rev(fp.as_2,fp.as_rev_2,null,null,''AS''),fp.as_3,f_get_sub_rev(fp.as_3,fp.as_rev_3,null,null,''AS''),';
      LSSELECT :=    LSSELECT
                  || 'fp.uom_alt_id,f_get_sub_rev(fp.uom_alt_id,fp.uom_alt_rev,null,null,''UO'') ';
      
      LSSQL := 'INSERT INTO specification_prop (';
      LSSQL :=    LSSQL
               || LSINSERT
               || ') ';
      LSSQL :=    LSSQL
               || 'SELECT '
               || LSSELECT;
      LSSQL :=    LSSQL
               || '  FROM frame_prop fp ';
      LSSQL :=    LSSQL
               || ' WHERE fp.frame_no = :FrameNo AND fp.revision = :FrameRevision AND fp.owner = :FrameOwner';
      LSSQL :=    LSSQL
               || '   AND fp.section_id = :SectionId AND fp.sub_section_id = :SubSectionId AND fp.property_group = :PropertyGroupId';
      LSSQL :=    LSSQL
               || '   AND fp.property = :PropertyId AND fp.attribute = :AttributeId';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      EXECUTE IMMEDIATE LSSQL
                  USING LRPROPERTY.PARTNO,
                        LRPROPERTY.REVISION,
                        LRFRAME.FRAMENO,
                        LRFRAME.REVISION,
                        LRFRAME.OWNER,
                        LRPROPERTY.SECTIONID,
                        LRPROPERTY.SUBSECTIONID,
                        LRPROPERTY.PROPERTYGROUPID,
                        LRPROPERTY.PROPERTYID,
                        LRPROPERTY.ATTRIBUTEID;

      
      INSERT INTO SPECDATA_SERVER
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID )
           VALUES ( LRPROPERTY.PARTNO,
                    LRPROPERTY.REVISION,
                    LRPROPERTY.SECTIONID,
                    LRPROPERTY.SUBSECTIONID );

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRPROPERTY.PARTNO,
                                                       LRPROPERTY.REVISION,
                                                       LRPROPERTY.SECTIONID,
                                                       LRPROPERTY.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRPROPERTY.PARTNO,
                                                LRPROPERTY.REVISION );

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
   END ADDPROPERTY;

   
   FUNCTION REMOVEPROPERTY(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPID          IN       IAPITYPE.ID_TYPE,
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveProperty';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRPROPERTY                    IAPITYPE.SPPROPERTYREC_TYPE;
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

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTPROPERTIES.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRPROPERTY.PARTNO := ASPARTNO;
      LRPROPERTY.REVISION := ANREVISION;
      LRPROPERTY.SECTIONID := ANSECTIONID;
      LRPROPERTY.SUBSECTIONID := ANSUBSECTIONID;
      LRPROPERTY.PROPERTYGROUPID := ANPROPERTYGROUPID;
      LRPROPERTY.PROPERTYID := ANPROPERTYID;
      LRPROPERTY.ATTRIBUTEID := ANATTRIBUTEID;
      GTPROPERTIES( 0 ) := LRPROPERTY;

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
      
      
      
      
      
      
      
      
      
      
      
      
      
      CHECKBASICPROPERTYPARAMS( LRPROPERTY );

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

      
      LNRETVAL := IAPISPECIFICATIONACCESS.GETMODIFIABLEACCESS( LRPROPERTY.PARTNO,
                                                               LRPROPERTY.REVISION,
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
                                                     LRPROPERTY.PARTNO,
                                                     LRPROPERTY.REVISION ) );
      END IF;

      
      
      LNRETVAL :=
         IAPISPECIFICATIONPROPERTYGROUP.EXISTPROPERTYINGROUP( LRPROPERTY.PARTNO,
                                                              LRPROPERTY.REVISION,
                                                              LRPROPERTY.SECTIONID,
                                                              LRPROPERTY.SUBSECTIONID,
                                                              LRPROPERTY.PROPERTYGROUPID,
                                                              LRPROPERTY.PROPERTYID,
                                                              LRPROPERTY.ATTRIBUTEID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL :=
         IAPISPECIFICATIONPROPERTYGROUP.ISPROPERTYACTIONALLOWED( LRPROPERTY.PARTNO,
                                                                 LRPROPERTY.REVISION,
                                                                 LRPROPERTY.SECTIONID,
                                                                 LRPROPERTY.SUBSECTIONID,
                                                                 LRPROPERTY.PROPERTYGROUPID,
                                                                 LRPROPERTY.PROPERTYID,
                                                                 LRPROPERTY.ATTRIBUTEID,
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
                                                     IAPICONSTANTDBERROR.DBERR_SPPROPERTYNOTALLOWED,
                                                     LRPROPERTY.PARTNO,
                                                     LRPROPERTY.REVISION,
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.SECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.SUBSECTIONID, 0),                                            
                                                     F_PGH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.PROPERTYGROUPID, 0),                                            
                                                     F_SPH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.PROPERTYID, 0),                                            
                                                     F_ATH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.ATTRIBUTEID, 0)));
                                                     
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      DELETE FROM SPECIFICATION_PROP
            WHERE PART_NO = LRPROPERTY.PARTNO
              AND REVISION = LRPROPERTY.REVISION
              AND PROPERTY_GROUP = LRPROPERTY.PROPERTYGROUPID
              AND PROPERTY = LRPROPERTY.PROPERTYID
              AND ATTRIBUTE = LRPROPERTY.ATTRIBUTEID
              AND SECTION_ID = LRPROPERTY.SECTIONID
              AND SUB_SECTION_ID = LRPROPERTY.SUBSECTIONID;

      DELETE FROM SPECIFICATION_PROP_LANG
            WHERE PART_NO = LRPROPERTY.PARTNO
              AND REVISION = LRPROPERTY.REVISION
              AND PROPERTY_GROUP = LRPROPERTY.PROPERTYGROUPID
              AND PROPERTY = LRPROPERTY.PROPERTYID
              AND ATTRIBUTE = LRPROPERTY.ATTRIBUTEID
              AND SECTION_ID = LRPROPERTY.SECTIONID
              AND SUB_SECTION_ID = LRPROPERTY.SUBSECTIONID;

      DELETE FROM SPECIFICATION_TM
            WHERE PART_NO = LRPROPERTY.PARTNO
              AND REVISION = LRPROPERTY.REVISION
              AND PROPERTY_GROUP = LRPROPERTY.PROPERTYGROUPID
              AND PROPERTY = LRPROPERTY.PROPERTYID
              AND ATTRIBUTE = LRPROPERTY.ATTRIBUTEID
              AND SECTION_ID = LRPROPERTY.SECTIONID
              AND SUB_SECTION_ID = LRPROPERTY.SUBSECTIONID;

      
      INSERT INTO SPECDATA_SERVER
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID )
           VALUES ( LRPROPERTY.PARTNO,
                    LRPROPERTY.REVISION,
                    LRPROPERTY.SECTIONID,
                    LRPROPERTY.SUBSECTIONID );

      
      BEGIN
         DELETE FROM ITSHEXT
               WHERE PART_NO = LRPROPERTY.PARTNO
                 AND REVISION = LRPROPERTY.REVISION
                 AND SECTION_ID = LRPROPERTY.SECTIONID
                 AND SUB_SECTION_ID = LRPROPERTY.SUBSECTIONID
                 AND TYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY
                 AND PROPERTY_GROUP = LRPROPERTY.PROPERTYGROUPID
                 AND PROPERTY = LRPROPERTY.PROPERTYID
                 AND ATTRIBUTE = LRPROPERTY.ATTRIBUTEID;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;   
      END;

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRPROPERTY.PARTNO,
                                                       LRPROPERTY.REVISION,
                                                       LRPROPERTY.SECTIONID,
                                                       LRPROPERTY.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRPROPERTY.PARTNO,
                                                LRPROPERTY.REVISION );

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
   END REMOVEPROPERTY;

   
   FUNCTION SAVEPROPERTY(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPID          IN       IAPITYPE.ID_TYPE,
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE,
      ANTESTMETHODID             IN       IAPITYPE.ID_TYPE,
      ANTESTMETHODSETNO          IN       IAPITYPE.TESTMETHODSETNO_TYPE,
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
      ASINFO                     IN       IAPITYPE.INFO_TYPE,
      ANBOOLEAN1                 IN       IAPITYPE.BOOLEAN_TYPE,
      ANBOOLEAN2                 IN       IAPITYPE.BOOLEAN_TYPE,
      ANBOOLEAN3                 IN       IAPITYPE.BOOLEAN_TYPE,
      ANBOOLEAN4                 IN       IAPITYPE.BOOLEAN_TYPE,
      ADDATE1                    IN       IAPITYPE.DATE_TYPE,
      ADDATE2                    IN       IAPITYPE.DATE_TYPE,
      ANCHARACTERISTICID1        IN       IAPITYPE.ID_TYPE,
      ANCHARACTERISTICID2        IN       IAPITYPE.ID_TYPE,
      ANCHARACTERISTICID3        IN       IAPITYPE.ID_TYPE,
      ANTESTMETHODDETAILS1       IN       IAPITYPE.BOOLEAN_TYPE,
      ANTESTMETHODDETAILS2       IN       IAPITYPE.BOOLEAN_TYPE,
      ANTESTMETHODDETAILS3       IN       IAPITYPE.BOOLEAN_TYPE,
      ANTESTMETHODDETAILS4       IN       IAPITYPE.BOOLEAN_TYPE,
      ANALTERNATIVELANGUAGEID    IN       IAPITYPE.LANGUAGEID_TYPE DEFAULT NULL,
      ASALTERNATIVESTRING1       IN       IAPITYPE.PROPERTYSHORTSTRING_TYPE DEFAULT NULL,
      ASALTERNATIVESTRING2       IN       IAPITYPE.PROPERTYSHORTSTRING_TYPE DEFAULT NULL,
      ASALTERNATIVESTRING3       IN       IAPITYPE.PROPERTYSHORTSTRING_TYPE DEFAULT NULL,
      ASALTERNATIVESTRING4       IN       IAPITYPE.PROPERTYSHORTSTRING_TYPE DEFAULT NULL,
      ASALTERNATIVESTRING5       IN       IAPITYPE.PROPERTYSHORTSTRING_TYPE DEFAULT NULL,
      ASALTERNATIVESTRING6       IN       IAPITYPE.PROPERTYLONGSTRING_TYPE DEFAULT NULL,
      ASALTERNATIVEINFO          IN       IAPITYPE.INFO_TYPE DEFAULT NULL,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      
      
      
      AQINFO                     IN OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   IN OUT      IAPITYPE.REF_TYPE )
      
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveProperty';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRPROPERTY                    IAPITYPE.SPPROPERTYREC_TYPE;
      LNMULTILANGUAGE               IAPITYPE.BOOLEAN_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNALLOWED                     IAPITYPE.BOOLEAN_TYPE;
      LNSEQUENCE                    SPECIFICATION_PROP.SEQUENCE_NO%TYPE;
      LNMARKEDFOREDITING            IAPITYPE.BOOLEAN_TYPE;
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
      GTPROPERTIES.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRPROPERTY.PARTNO := ASPARTNO;
      LRPROPERTY.REVISION := ANREVISION;
      LRPROPERTY.SECTIONID := ANSECTIONID;
      LRPROPERTY.SUBSECTIONID := ANSUBSECTIONID;
      LRPROPERTY.PROPERTYGROUPID := ANPROPERTYGROUPID;
      LRPROPERTY.PROPERTYID := ANPROPERTYID;
      LRPROPERTY.ATTRIBUTEID := ANATTRIBUTEID;
      LRPROPERTY.TESTMETHODID := ANTESTMETHODID;
      LRPROPERTY.TESTMETHODSETNO := ANTESTMETHODSETNO;
      LRPROPERTY.NUMERIC1 := AFNUMERIC1;
      LRPROPERTY.NUMERIC2 := AFNUMERIC2;
      LRPROPERTY.NUMERIC3 := AFNUMERIC3;
      LRPROPERTY.NUMERIC4 := AFNUMERIC4;
      LRPROPERTY.NUMERIC5 := AFNUMERIC5;
      LRPROPERTY.NUMERIC6 := AFNUMERIC6;
      LRPROPERTY.NUMERIC7 := AFNUMERIC7;
      LRPROPERTY.NUMERIC8 := AFNUMERIC8;
      LRPROPERTY.NUMERIC9 := AFNUMERIC9;
      LRPROPERTY.NUMERIC10 := AFNUMERIC10;
      LRPROPERTY.STRING1 := ASSTRING1;
      LRPROPERTY.STRING2 := ASSTRING2;
      LRPROPERTY.STRING3 := ASSTRING3;
      LRPROPERTY.STRING4 := ASSTRING4;
      LRPROPERTY.STRING5 := ASSTRING5;
      LRPROPERTY.STRING6 := ASSTRING6;
      LRPROPERTY.INFO := ASINFO;
      LRPROPERTY.BOOLEAN1 := ANBOOLEAN1;
      LRPROPERTY.BOOLEAN2 := ANBOOLEAN2;
      LRPROPERTY.BOOLEAN3 := ANBOOLEAN3;
      LRPROPERTY.BOOLEAN4 := ANBOOLEAN4;
      LRPROPERTY.DATE1 := ADDATE1;
      LRPROPERTY.DATE2 := ADDATE2;
      LRPROPERTY.CHARACTERISTICID1 := ANCHARACTERISTICID1;
      LRPROPERTY.CHARACTERISTICID2 := ANCHARACTERISTICID2;
      LRPROPERTY.CHARACTERISTICID3 := ANCHARACTERISTICID3;
      LRPROPERTY.TESTMETHODDETAILS1 := ANTESTMETHODDETAILS1;
      LRPROPERTY.TESTMETHODDETAILS2 := ANTESTMETHODDETAILS2;
      LRPROPERTY.TESTMETHODDETAILS3 := ANTESTMETHODDETAILS3;
      LRPROPERTY.TESTMETHODDETAILS4 := ANTESTMETHODDETAILS4;
      LRPROPERTY.ALTERNATIVELANGUAGEID := ANALTERNATIVELANGUAGEID;
      LRPROPERTY.ALTERNATIVESTRING1 := ASALTERNATIVESTRING1;
      LRPROPERTY.ALTERNATIVESTRING2 := ASALTERNATIVESTRING2;
      LRPROPERTY.ALTERNATIVESTRING3 := ASALTERNATIVESTRING3;
      LRPROPERTY.ALTERNATIVESTRING4 := ASALTERNATIVESTRING4;
      LRPROPERTY.ALTERNATIVESTRING5 := ASALTERNATIVESTRING5;
      LRPROPERTY.ALTERNATIVESTRING6 := ASALTERNATIVESTRING6;
      LRPROPERTY.ALTERNATIVEINFO := ASALTERNATIVEINFO;
      GTPROPERTIES( 0 ) := LRPROPERTY;

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
      LRPROPERTY := GTPROPERTIES( 0 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      
      
      
      
      
      
      
      
      
      

      CHECKBASICPROPERTYPARAMS( LRPROPERTY );

      
      IF ( LRPROPERTY.ALTERNATIVELANGUAGEID = 1 )
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

      
      
      IF ( LRPROPERTY.ALTERNATIVELANGUAGEID IS NOT NULL )
      THEN
         LNRETVAL := IAPISPECIFICATION.ISMULTILANGUAGE( LRPROPERTY.PARTNO,
                                                        LRPROPERTY.REVISION,
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
                                                        LRPROPERTY.PARTNO,
                                                        LRPROPERTY.REVISION ) );
         END IF;
      END IF;

      
      LNRETVAL := IAPISPECIFICATIONACCESS.GETMODIFIABLEACCESS( LRPROPERTY.PARTNO,
                                                               LRPROPERTY.REVISION,
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
                                                     LRPROPERTY.PARTNO,
                                                     LRPROPERTY.REVISION ) );
      END IF;

      
      
      LNRETVAL :=
         IAPISPECIFICATIONPROPERTYGROUP.EXISTPROPERTYINGROUP( LRPROPERTY.PARTNO,
                                                              LRPROPERTY.REVISION,
                                                              LRPROPERTY.SECTIONID,
                                                              LRPROPERTY.SUBSECTIONID,
                                                              LRPROPERTY.PROPERTYGROUPID,
                                                              LRPROPERTY.PROPERTYID,
                                                              LRPROPERTY.ATTRIBUTEID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL :=
         IAPISPECIFICATIONPROPERTYGROUP.ISPROPERTYACTIONALLOWED( LRPROPERTY.PARTNO,
                                                                 LRPROPERTY.REVISION,
                                                                 LRPROPERTY.SECTIONID,
                                                                 LRPROPERTY.SUBSECTIONID,
                                                                 LRPROPERTY.PROPERTYGROUPID,
                                                                 LRPROPERTY.PROPERTYID,
                                                                 LRPROPERTY.ATTRIBUTEID,
                                                                 'SAVE',
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
                                                     IAPICONSTANTDBERROR.DBERR_SPPROPERTYNOTALLOWED,
                                                     LRPROPERTY.PARTNO,
                                                     LRPROPERTY.REVISION,
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.SECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.SUBSECTIONID, 0),                                            
                                                     F_PGH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.PROPERTYGROUPID, 0),                                            
                                                     F_SPH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.PROPERTYID, 0),                                            
                                                     F_ATH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.ATTRIBUTEID, 0)));
                                                     
      END IF;

      
      IF ( AFHANDLE IS NOT NULL )
      THEN
         LNRETVAL := IAPISPECIFICATIONSECTION.ISMARKEDFOREDITING( ASPARTNO,
                                                                  ANREVISION,
                                                                  ANSECTIONID,
                                                                  ANSUBSECTIONID,
                                                                  AFHANDLE,
                                                                  LNMARKEDFOREDITING );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         CASE LNMARKEDFOREDITING
            WHEN -1
            THEN
               LNRETVAL := IAPIGENERAL.SETERRORTEXT( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_NOSAVEALLOWED,
                                                     ASPARTNO,
                                                     ANREVISION );
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
               RETURN( LNRETVAL );
            WHEN -2
            THEN
               SELECT    F_SCH_DESCR( IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,
                                      ANSECTIONID,
                                      0 )
                      || DECODE( ANSUBSECTIONID,
                                 0, NULL,
                                    ' - '
                                 || F_SCH_DESCR( IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,
                                                 ANSUBSECTIONID,
                                                 0 ) )
                 INTO LSSECTION
                 FROM DUAL;

               LNRETVAL :=
                     IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_SAVEAFTERMOD,
                                                         ASPARTNO,
                                                         ANREVISION,
                                                         LSSECTION );
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
               RETURN( LNRETVAL );
            ELSE   
               NULL;
         END CASE;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      UPDATE SPECIFICATION_PROP
         SET TEST_METHOD = LRPROPERTY.TESTMETHODID,
             NUM_1 = LRPROPERTY.NUMERIC1,
             NUM_2 = LRPROPERTY.NUMERIC2,
             NUM_3 = LRPROPERTY.NUMERIC3,
             NUM_4 = LRPROPERTY.NUMERIC4,
             NUM_5 = LRPROPERTY.NUMERIC5,
             NUM_6 = LRPROPERTY.NUMERIC6,
             NUM_7 = LRPROPERTY.NUMERIC7,
             NUM_8 = LRPROPERTY.NUMERIC8,
             NUM_9 = LRPROPERTY.NUMERIC9,
             NUM_10 = LRPROPERTY.NUMERIC10,
             CHAR_1 = LRPROPERTY.STRING1,
             CHAR_2 = LRPROPERTY.STRING2,
             CHAR_3 = LRPROPERTY.STRING3,
             CHAR_4 = LRPROPERTY.STRING4,
             CHAR_5 = LRPROPERTY.STRING5,
             CHAR_6 = LRPROPERTY.STRING6,
             INFO = LRPROPERTY.INFO,
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             BOOLEAN_1 = DECODE( LRPROPERTY.BOOLEAN1,
                                 NULL, NULL,
                                 1, 'Y',
                                 'N' ),
             BOOLEAN_2 = DECODE( LRPROPERTY.BOOLEAN2,
                                 NULL, NULL,
                                 1, 'Y',
                                 'N' ),
             BOOLEAN_3 = DECODE( LRPROPERTY.BOOLEAN3,
                                 NULL, NULL,
                                 1, 'Y',
                                 'N' ),
             BOOLEAN_4 = DECODE( LRPROPERTY.BOOLEAN4,
                                 NULL, NULL,
                                 1, 'Y',
                                 'N' ),                                              
             
             DATE_1 = LRPROPERTY.DATE1,
             DATE_2 = LRPROPERTY.DATE2,
             CHARACTERISTIC = LRPROPERTY.CHARACTERISTICID1,
             CH_2 = LRPROPERTY.CHARACTERISTICID2,
             CH_3 = LRPROPERTY.CHARACTERISTICID3,
             TM_DET_1 = DECODE( LRPROPERTY.TESTMETHODDETAILS1,
                                1, 'Y',
                                'N' ),
             TM_DET_2 = DECODE( LRPROPERTY.TESTMETHODDETAILS2,
                                1, 'Y',
                                'N' ),
             TM_DET_3 = DECODE( LRPROPERTY.TESTMETHODDETAILS3,
                                1, 'Y',
                                'N' ),
             TM_DET_4 = DECODE( LRPROPERTY.TESTMETHODDETAILS4,
                                1, 'Y',
                                'N' ),
             TM_SET_NO = LRPROPERTY.TESTMETHODSETNO,
             TEST_METHOD_REV = 0,   
             CHARACTERISTIC_REV = 0,
             CH_REV_2 = 0,
             CH_REV_3 = 0
       WHERE PART_NO = LRPROPERTY.PARTNO
         AND REVISION = LRPROPERTY.REVISION
         AND SECTION_ID = LRPROPERTY.SECTIONID
         AND SUB_SECTION_ID = LRPROPERTY.SUBSECTIONID
         AND PROPERTY_GROUP = LRPROPERTY.PROPERTYGROUPID
         AND PROPERTY = LRPROPERTY.PROPERTYID
         AND ATTRIBUTE = LRPROPERTY.ATTRIBUTEID;

      
      IF ( LRPROPERTY.ALTERNATIVELANGUAGEID IS NOT NULL )
      THEN
         
         IF     LRPROPERTY.ALTERNATIVESTRING1 IS NULL
            AND LRPROPERTY.ALTERNATIVESTRING2 IS NULL
            AND LRPROPERTY.ALTERNATIVESTRING3 IS NULL
            AND LRPROPERTY.ALTERNATIVESTRING4 IS NULL
            AND LRPROPERTY.ALTERNATIVESTRING5 IS NULL
            AND LRPROPERTY.ALTERNATIVESTRING6 IS NULL
            AND LRPROPERTY.ALTERNATIVEINFO IS NULL
         THEN
            
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 'Delete alternative language',
                                 IAPICONSTANT.INFOLEVEL_3 );

            DELETE      SPECIFICATION_PROP_LANG
                  WHERE PART_NO = LRPROPERTY.PARTNO
                    AND REVISION = LRPROPERTY.REVISION
                    AND SECTION_ID = LRPROPERTY.SECTIONID
                    AND SUB_SECTION_ID = LRPROPERTY.SUBSECTIONID
                    AND PROPERTY_GROUP = LRPROPERTY.PROPERTYGROUPID
                    AND PROPERTY = LRPROPERTY.PROPERTYID
                    AND ATTRIBUTE = LRPROPERTY.ATTRIBUTEID
                    AND LANG_ID = LRPROPERTY.ALTERNATIVELANGUAGEID;
         ELSE
            BEGIN
               
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    'Try to insert multi-language data',
                                    IAPICONSTANT.INFOLEVEL_3 );

               
               SELECT SEQUENCE_NO
                 INTO LNSEQUENCE
                 FROM SPECIFICATION_PROP
                WHERE PART_NO = LRPROPERTY.PARTNO
                  AND REVISION = LRPROPERTY.REVISION
                  AND SECTION_ID = LRPROPERTY.SECTIONID
                  AND SUB_SECTION_ID = LRPROPERTY.SUBSECTIONID
                  AND PROPERTY_GROUP = LRPROPERTY.PROPERTYGROUPID
                  AND PROPERTY = LRPROPERTY.PROPERTYID
                  AND ATTRIBUTE = LRPROPERTY.ATTRIBUTEID;

               INSERT INTO SPECIFICATION_PROP_LANG
                           ( PART_NO,
                             REVISION,
                             SECTION_ID,
                             SUB_SECTION_ID,
                             PROPERTY_GROUP,
                             PROPERTY,
                             ATTRIBUTE,
                             LANG_ID,
                             SEQUENCE_NO,
                             CHAR_1,
                             CHAR_2,
                             CHAR_3,
                             CHAR_4,
                             CHAR_5,
                             CHAR_6,
                             INFO )
                    VALUES ( LRPROPERTY.PARTNO,
                             LRPROPERTY.REVISION,
                             LRPROPERTY.SECTIONID,
                             LRPROPERTY.SUBSECTIONID,
                             LRPROPERTY.PROPERTYGROUPID,
                             LRPROPERTY.PROPERTYID,
                             LRPROPERTY.ATTRIBUTEID,
                             LRPROPERTY.ALTERNATIVELANGUAGEID,
                             LNSEQUENCE,
                             LRPROPERTY.ALTERNATIVESTRING1,
                             LRPROPERTY.ALTERNATIVESTRING2,
                             LRPROPERTY.ALTERNATIVESTRING3,
                             LRPROPERTY.ALTERNATIVESTRING4,
                             LRPROPERTY.ALTERNATIVESTRING5,
                             LRPROPERTY.ALTERNATIVESTRING6,
                             LRPROPERTY.ALTERNATIVEINFO );
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX
               THEN
                  
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                       'Update multi-language data',
                                       IAPICONSTANT.INFOLEVEL_3 );

                  UPDATE SPECIFICATION_PROP_LANG
                     SET CHAR_1 = LRPROPERTY.ALTERNATIVESTRING1,
                         CHAR_2 = LRPROPERTY.ALTERNATIVESTRING2,
                         CHAR_3 = LRPROPERTY.ALTERNATIVESTRING3,
                         CHAR_4 = LRPROPERTY.ALTERNATIVESTRING4,
                         CHAR_5 = LRPROPERTY.ALTERNATIVESTRING5,
                         CHAR_6 = LRPROPERTY.ALTERNATIVESTRING6,
                         INFO = LRPROPERTY.ALTERNATIVEINFO
                   WHERE PART_NO = LRPROPERTY.PARTNO
                     AND REVISION = LRPROPERTY.REVISION
                     AND SECTION_ID = LRPROPERTY.SECTIONID
                     AND SUB_SECTION_ID = LRPROPERTY.SUBSECTIONID
                     AND PROPERTY_GROUP = LRPROPERTY.PROPERTYGROUPID
                     AND PROPERTY = LRPROPERTY.PROPERTYID
                     AND ATTRIBUTE = LRPROPERTY.ATTRIBUTEID
                     AND LANG_ID = LRPROPERTY.ALTERNATIVELANGUAGEID;
            END;
         END IF;
      END IF;

      
      INSERT INTO SPECDATA_SERVER
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID )
           VALUES ( LRPROPERTY.PARTNO,
                    LRPROPERTY.REVISION,
                    LRPROPERTY.SECTIONID,
                    LRPROPERTY.SUBSECTIONID );

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRPROPERTY.PARTNO,
                                                       LRPROPERTY.REVISION,
                                                       LRPROPERTY.SECTIONID,
                                                       LRPROPERTY.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRPROPERTY.PARTNO,
                                                LRPROPERTY.REVISION );

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
   END SAVEPROPERTY;

   
   FUNCTION EXTENDPROPERTY(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPID          IN       IAPITYPE.ID_TYPE,
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE,
      ANUOMID                    IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANASSOCIATIONID1           IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANASSOCIATIONID2           IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANASSOCIATIONID3           IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANDISPLAYFORMATID          IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      ANPROPERTYSEQUENCENUMBER   OUT      IAPITYPE.PROPERTYSEQUENCENUMBER_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExtendProperty';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRPROPERTY                    IAPITYPE.SPPROPERTYREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNEXTENDABLE                  IAPITYPE.BOOLEAN_TYPE;
      LNALLOWED                     IAPITYPE.BOOLEAN_TYPE;
      LNSECTIONREVISION             IAPITYPE.REVISION_TYPE;
      LNSUBSECTIONREVISION          IAPITYPE.REVISION_TYPE;
      LNPROPERTYGROUPREVISION       IAPITYPE.REVISION_TYPE;
      LNPROPERTYREVISION            IAPITYPE.REVISION_TYPE := 0;
      LNATTRIBUTEREVISION           IAPITYPE.REVISION_TYPE := 0;
      LNUOMREVISION                 IAPITYPE.REVISION_TYPE := 0;
      LNASSOCIATIONID1REVISION      IAPITYPE.REVISION_TYPE := 0;
      LNASSOCIATIONID2REVISION      IAPITYPE.REVISION_TYPE := 0;
      LNASSOCIATIONID3REVISION      IAPITYPE.REVISION_TYPE := 0;
      LNSPECIFICATIONMODE           IAPITYPE.BOOLEAN_TYPE;
      LNCOUNT                       NUMBER;
      LSSPECIFICATIONSECTIONTYPE    IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LRINFO1                       IAPITYPE.INFOREC_TYPE;
      LTINFO                        IAPITYPE.INFOTAB_TYPE;
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
      GTPROPERTIES.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRPROPERTY.PARTNO := ASPARTNO;
      LRPROPERTY.REVISION := ANREVISION;
      LRPROPERTY.SECTIONID := ANSECTIONID;
      LRPROPERTY.SUBSECTIONID := ANSUBSECTIONID;
      LRPROPERTY.PROPERTYGROUPID := ANPROPERTYGROUPID;
      LRPROPERTY.PROPERTYID := ANPROPERTYID;
      LRPROPERTY.ATTRIBUTEID := ANATTRIBUTEID;
      
      
      IF (ANUOMID = 0)
      THEN
        LRPROPERTY.UOMID := NULL;
      ELSE   
        LRPROPERTY.UOMID := ANUOMID;
      END IF;  
      
      LRPROPERTY.ASSOCIATIONID1 := ANASSOCIATIONID1;
      LRPROPERTY.ASSOCIATIONID2 := ANASSOCIATIONID2;
      LRPROPERTY.ASSOCIATIONID3 := ANASSOCIATIONID3;
      LRPROPERTY.DISPLAYFORMATID := ANDISPLAYFORMATID;
      GTPROPERTIES( 0 ) := LRPROPERTY;

      GTINFO( 0 ) := LRINFO;

      IF ( LRPROPERTY.PROPERTYGROUPID = 0 )
      THEN
         LSSPECIFICATIONSECTIONTYPE := IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY;
      ELSE
         LSSPECIFICATIONSECTIONTYPE := IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP;
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
      
      
      
      
      
      
      
      
      
      
      
      
      
      CHECKBASICPROPERTYPARAMS( LRPROPERTY );

      
      IF ( LSSPECIFICATIONSECTIONTYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY )
      THEN
         
         IF ( LRPROPERTY.DISPLAYFORMATID IS NULL )
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                            'DisplayFormatId' );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anDisplayFormatId',
                                                    IAPIGENERAL.GETLASTERRORTEXT( ),
                                                    GTERRORS );
         ELSE
            
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM PROPERTY_DISPLAY
             WHERE PROPERTY = LRPROPERTY.PROPERTYID
               AND DISPLAY_FORMAT = LRPROPERTY.DISPLAYFORMATID;

            IF ( LNCOUNT = 0 )
            THEN
               LNRETVAL :=
                  IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                      LSMETHOD,
                                                      IAPICONSTANTDBERROR.DBERR_INVALIDPROPDF,
                                                      F_SPH_DESCR( NULL,
                                                                   LRPROPERTY.PROPERTYID,
                                                                   0 ),
                                                      F_LAYOUT_DESCR_ALL_SS( NULL,
                                                                             LRPROPERTY.DISPLAYFORMATID,
                                                                             0 ) );
               LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anDisplayFormatId',
                                                       IAPIGENERAL.GETLASTERRORTEXT( ),
                                                       GTERRORS );
            END IF;
         END IF;
      END IF;

      IF ( LSSPECIFICATIONSECTIONTYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY )
      THEN
         
         IF ( LRPROPERTY.ATTRIBUTEID IS NULL )
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                            'AttributeId' );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anAttributeId',
                                                    IAPIGENERAL.GETLASTERRORTEXT( ),
                                                    GTERRORS );
         ELSE
            IF ( LRPROPERTY.ATTRIBUTEID <> 0 )
            THEN
               
               SELECT COUNT( * )
                 INTO LNCOUNT
                 FROM ATTRIBUTE_PROPERTY
                WHERE PROPERTY = LRPROPERTY.PROPERTYID
                  AND ATTRIBUTE = LRPROPERTY.ATTRIBUTEID;

               IF ( LNCOUNT = 0 )
               THEN
                  LNRETVAL :=
                     IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_INVALIDPROPATT,
                                                         F_SPH_DESCR( NULL,
                                                                      LRPROPERTY.PROPERTYID,
                                                                      0 ),
                                                         F_ATH_DESCR( NULL,
                                                                      LRPROPERTY.ATTRIBUTEID,
                                                                      0 ) );
                  LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anAttributeId',
                                                          IAPIGENERAL.GETLASTERRORTEXT( ),
                                                          GTERRORS );
               END IF;
            END IF;
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

      
      LNRETVAL := IAPISPECIFICATIONACCESS.GETMODIFIABLEACCESS( LRPROPERTY.PARTNO,
                                                               LRPROPERTY.REVISION,
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
                                                     LRPROPERTY.PARTNO,
                                                     LRPROPERTY.REVISION ) );
      END IF;

      
      
      IF ( LSSPECIFICATIONSECTIONTYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY )
      THEN
         LNRETVAL :=
            ISEXTENDABLE( LRPROPERTY.PARTNO,
                          LRPROPERTY.REVISION,
                          LRPROPERTY.SECTIONID,
                          LRPROPERTY.SUBSECTIONID,
                          LRPROPERTY.PROPERTYID,
                          1,
                          LNEXTENDABLE );

         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SPITEMNOTFOUND )
         THEN
            
            LNRETVAL :=
               EXTENDPROPERTYGROUP( LRPROPERTY.PARTNO,
                                    LRPROPERTY.REVISION,
                                    LRPROPERTY.SECTIONID,
                                    LRPROPERTY.SUBSECTIONID,
                                    LRPROPERTY.PROPERTYID,
                                    LRPROPERTY.DISPLAYFORMATID,
                                    1,   
                                    LRPROPERTY.ATTRIBUTEID,
                                    AFHANDLE,
                                    ANPROPERTYSEQUENCENUMBER,
                                    AQINFO,
                                    AQERRORS );
            LNEXTENDABLE := 1;

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
      ELSE
         
         LNRETVAL :=
            IAPISPECIFICATIONSECTION.ISITEMEXTENDED( LRPROPERTY.PARTNO,
                                                     LRPROPERTY.REVISION,
                                                     LRPROPERTY.SECTIONID,
                                                     LRPROPERTY.SUBSECTIONID,
                                                     IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP,
                                                     LRPROPERTY.PROPERTYGROUPID,
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
            
            LNRETVAL :=
               ISEXTENDABLE( LRPROPERTY.PARTNO,
                             LRPROPERTY.REVISION,
                             LRPROPERTY.SECTIONID,
                             LRPROPERTY.SUBSECTIONID,
                             LRPROPERTY.PROPERTYGROUPID,
                             LSSPECIFICATIONSECTIONTYPE,
                             LNEXTENDABLE );
         END IF;
      END IF;

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
                                                     IAPICONSTANTDBERROR.DBERR_PROPERTYGRPNOTEXTENDABLE,
                                                     LRPROPERTY.PARTNO,
                                                     LRPROPERTY.REVISION,
                                                     
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.SECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.SUBSECTIONID, 0),                                            
                                                     F_PGH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.PROPERTYGROUPID, 0) ));                                            
                                                     
      END IF;

      
      LNRETVAL :=
         IAPISPECIFICATIONPROPERTYGROUP.EXISTPROPERTYINGROUP( LRPROPERTY.PARTNO,
                                                              LRPROPERTY.REVISION,
                                                              LRPROPERTY.SECTIONID,
                                                              LRPROPERTY.SUBSECTIONID,
                                                              LRPROPERTY.PROPERTYGROUPID,
                                                              LRPROPERTY.PROPERTYID,
                                                              LRPROPERTY.ATTRIBUTEID );

      IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_SPPROPERTYALREADYINGROUP,
                                                     LRPROPERTY.PARTNO,
                                                     LRPROPERTY.REVISION,
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.SECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.SUBSECTIONID, 0),                                            
                                                     F_PGH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.PROPERTYGROUPID, 0),                                            
                                                     F_SPH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.PROPERTYID, 0),                                            
                                                     F_ATH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.ATTRIBUTEID, 0)));
                                                     
      ELSIF( LNRETVAL NOT IN( IAPICONSTANTDBERROR.DBERR_SPPROPERTYNOTFOUND, IAPICONSTANTDBERROR.DBERR_SPSECTIONNOTFOUND ) )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL :=
         IAPISPECIFICATIONPROPERTYGROUP.ISPROPERTYACTIONALLOWED( LRPROPERTY.PARTNO,
                                                                 LRPROPERTY.REVISION,
                                                                 LRPROPERTY.SECTIONID,
                                                                 LRPROPERTY.SUBSECTIONID,
                                                                 LRPROPERTY.PROPERTYGROUPID,
                                                                 LRPROPERTY.PROPERTYID,
                                                                 LRPROPERTY.ATTRIBUTEID,
                                                                 'EXTEND',
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
                                                     IAPICONSTANTDBERROR.DBERR_SPPROPERTYNOTALLOWED,
                                                     LRPROPERTY.PARTNO,
                                                     LRPROPERTY.REVISION,
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.SECTIONID, 0),
                                                     F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.SUBSECTIONID, 0),                                            
                                                     F_PGH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.PROPERTYGROUPID, 0),                                            
                                                     F_SPH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.PROPERTYID, 0),                                            
                                                     F_ATH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRPROPERTY.ATTRIBUTEID, 0)));
                                                     
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      SELECT NVL( MAX( SEQUENCE_NO ),
                  0 )
        INTO ANPROPERTYSEQUENCENUMBER
        FROM SPECIFICATION_PROP
       WHERE PART_NO = LRPROPERTY.PARTNO
         AND REVISION = LRPROPERTY.REVISION
         AND SECTION_ID = LRPROPERTY.SECTIONID
         AND SUB_SECTION_ID = LRPROPERTY.SUBSECTIONID
         AND PROPERTY_GROUP = LRPROPERTY.PROPERTYGROUPID;

      
      ANPROPERTYSEQUENCENUMBER :=   ANPROPERTYSEQUENCENUMBER
                                  + 10;

      
      SELECT DISTINCT SECTION_REV,
                      SUB_SECTION_REV
                 INTO LNSECTIONREVISION,
                      LNSUBSECTIONREVISION
                 FROM SPECIFICATION_SECTION
                WHERE PART_NO = LRPROPERTY.PARTNO
                  AND REVISION = LRPROPERTY.REVISION
                  AND SECTION_ID = LRPROPERTY.SECTIONID
                  AND SUB_SECTION_ID = LRPROPERTY.SUBSECTIONID
                  AND TYPE = LSSPECIFICATIONSECTIONTYPE
                  AND REF_ID =
                         DECODE( LSSPECIFICATIONSECTIONTYPE,
                                 IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY, LRPROPERTY.PROPERTYID,
                                 LRPROPERTY.PROPERTYGROUPID );

      IF ( LSSPECIFICATIONSECTIONTYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP )
      THEN
         
         SELECT DISTINCT REF_VER
                    INTO LNPROPERTYGROUPREVISION
                    FROM SPECIFICATION_SECTION
                   WHERE PART_NO = LRPROPERTY.PARTNO
                     AND REVISION = LRPROPERTY.REVISION
                     AND SECTION_ID = LRPROPERTY.SECTIONID
                     AND SUB_SECTION_ID = LRPROPERTY.SUBSECTIONID
                     AND TYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP
                     AND REF_ID = LRPROPERTY.PROPERTYGROUPID;
      ELSE
         LNPROPERTYGROUPREVISION := 0;
      END IF;

      
      BEGIN
         SELECT DISTINCT REVISION
                    INTO LNPROPERTYREVISION
                    FROM PROPERTY_H
                   WHERE PROPERTY = LRPROPERTY.PROPERTYID
                     AND MAX_REV = 1;
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      
      BEGIN
         SELECT DISTINCT REVISION
                    INTO LNATTRIBUTEREVISION
                    FROM ATTRIBUTE_H
                   WHERE ATTRIBUTE = LRPROPERTY.ATTRIBUTEID
                     AND MAX_REV = 1;
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      
      IF ( LRPROPERTY.UOMID IS NOT NULL )
      THEN
         BEGIN
            SELECT DISTINCT REVISION
                       INTO LNUOMREVISION
                       FROM UOM_H
                      WHERE UOM_ID = LRPROPERTY.UOMID
                        AND MAX_REV = 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               NULL;
         END;
      END IF;

      
      IF ( LRPROPERTY.ASSOCIATIONID1 IS NOT NULL )
      THEN
         BEGIN
            SELECT DISTINCT REVISION
                       INTO LNASSOCIATIONID1REVISION
                       FROM ASSOCIATION_H
                      WHERE ASSOCIATION = LRPROPERTY.ASSOCIATIONID1
                        AND MAX_REV = 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               NULL;
         END;
      END IF;

      
      IF ( LRPROPERTY.ASSOCIATIONID1 IS NOT NULL )
      THEN
         BEGIN
            SELECT DISTINCT REVISION
                       INTO LNASSOCIATIONID2REVISION
                       FROM ASSOCIATION_H
                      WHERE ASSOCIATION = LRPROPERTY.ASSOCIATIONID2
                        AND MAX_REV = 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               NULL;
         END;
      END IF;

      
      IF ( LRPROPERTY.ASSOCIATIONID1 IS NOT NULL )
      THEN
         BEGIN
            SELECT DISTINCT REVISION
                       INTO LNASSOCIATIONID3REVISION
                       FROM ASSOCIATION_H
                      WHERE ASSOCIATION = LRPROPERTY.ASSOCIATIONID3
                        AND MAX_REV = 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               NULL;
         END;
      END IF;

      
      SELECT INTL
        INTO LNSPECIFICATIONMODE
        FROM SPECIFICATION_HEADER
       WHERE PART_NO = LRPROPERTY.PARTNO
         AND REVISION = LRPROPERTY.REVISION;

      
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
           VALUES ( LRPROPERTY.PARTNO,
                    LRPROPERTY.REVISION,
                    LRPROPERTY.SECTIONID,
                    LRPROPERTY.SUBSECTIONID,
                    LRPROPERTY.PROPERTYGROUPID,
                    LRPROPERTY.PROPERTYID,
                    LRPROPERTY.ATTRIBUTEID,
                    LRPROPERTY.UOMID,
                    LRPROPERTY.ASSOCIATIONID1,
                    LRPROPERTY.ASSOCIATIONID2,
                    LRPROPERTY.ASSOCIATIONID3,
                    ANPROPERTYSEQUENCENUMBER,
                    LNSECTIONREVISION,
                    LNSUBSECTIONREVISION,
                    LNPROPERTYGROUPREVISION,
                    LNPROPERTYREVISION,
                    LNATTRIBUTEREVISION,
                    LNUOMREVISION,
                    LNASSOCIATIONID1REVISION,
                    LNASSOCIATIONID2REVISION,
                    LNASSOCIATIONID3REVISION,
                    LNSPECIFICATIONMODE );

      
      
      
      IF ( LSSPECIFICATIONSECTIONTYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP )
      THEN
         
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
              VALUES ( LRPROPERTY.PARTNO,
                       LRPROPERTY.REVISION,
                       LRPROPERTY.SECTIONID,
                       LRPROPERTY.SUBSECTIONID,
                       IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY,
                       0,
                       0,
                       0,
                       LRPROPERTY.PROPERTYGROUPID,
                       LRPROPERTY.PROPERTYID,
                       LRPROPERTY.ATTRIBUTEID );
      END IF;

      
      INSERT INTO SPECDATA_SERVER
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID )
           VALUES ( LRPROPERTY.PARTNO,
                    LRPROPERTY.REVISION,
                    LRPROPERTY.SECTIONID,
                    LRPROPERTY.SUBSECTIONID );

      
      IF ( AFHANDLE IS NOT NULL )
      THEN
         LNRETVAL :=
            IAPISPECIFICATIONSECTION.MARKFOREDITING( LRPROPERTY.PARTNO,
                                                     LRPROPERTY.REVISION,
                                                     LRPROPERTY.SECTIONID,
                                                     LRPROPERTY.SUBSECTIONID,
                                                     AFHANDLE );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END IF;

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRPROPERTY.PARTNO,
                                                       LRPROPERTY.REVISION,
                                                       LRPROPERTY.SECTIONID,
                                                       LRPROPERTY.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRPROPERTY.PARTNO,
                                                LRPROPERTY.REVISION );

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
   END EXTENDPROPERTY;

   
   FUNCTION EXTENDPROPERTYGROUP(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANDISPLAYFORMATID          IN       IAPITYPE.ID_TYPE,
      ANSINGLEPROPERTY           IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      ANSECTIONSEQUENCENUMBER    OUT      IAPITYPE.SPSECTIONSEQUENCENUMBER_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExtendPropertyGroup';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRPROPERTYGROUP               IAPITYPE.SPPROPERTYGROUPREC_TYPE;
      LNCOUNT                       NUMBER;
      LSSPECIFICATIONSECTIONTYPE    IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE;
      LNPROPERTYSEQUENCENUMBER      IAPITYPE.PROPERTYSEQUENCENUMBER_TYPE;
      LSPGDESC                      IAPITYPE.DESCRIPTION_TYPE;
      LSLYDESC                      IAPITYPE.DESCRIPTION_TYPE;
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
      GTPROPERTYGROUPS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRPROPERTYGROUP.PARTNO := ASPARTNO;
      LRPROPERTYGROUP.REVISION := ANREVISION;
      LRPROPERTYGROUP.SECTIONID := ANSECTIONID;
      LRPROPERTYGROUP.SUBSECTIONID := ANSUBSECTIONID;
      LRPROPERTYGROUP.ITEMID := ANITEMID;
      LRPROPERTYGROUP.DISPLAYFORMATID := ANDISPLAYFORMATID;

      IF ( ANSINGLEPROPERTY = 0 )
      THEN
         LSSPECIFICATIONSECTIONTYPE := IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP;
         LRPROPERTYGROUP.ATTRIBUTEID := 0;
      ELSE
         LSSPECIFICATIONSECTIONTYPE := IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY;
         LRPROPERTYGROUP.ATTRIBUTEID := ANATTRIBUTEID;
      END IF;

      GTPROPERTYGROUPS( 0 ) := LRPROPERTYGROUP;

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
      
      
      
      
      
      
      
      
      
      
      
      CHECKBASICPROPGROUPPARAMS( LRPROPERTYGROUP );

      
      IF ( LRPROPERTYGROUP.DISPLAYFORMATID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'DisplayFormatId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anDisplayFormatId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( LSSPECIFICATIONSECTIONTYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP )
      THEN
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM PROPERTY_GROUP
          WHERE PROPERTY_GROUP = LRPROPERTYGROUP.ITEMID;

         IF ( LNCOUNT = 0 )
         THEN
            LNRETVAL :=
               IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPICONSTANTDBERROR.DBERR_INVALIDPG,
                                                   F_PGH_DESCR( NULL,
                                                                LRPROPERTYGROUP.ITEMID,
                                                                0 ) );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anItemId',
                                                    IAPIGENERAL.GETLASTERRORTEXT( ),
                                                    GTERRORS );
         END IF;
      ELSE
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM PROPERTY
          WHERE PROPERTY = LRPROPERTYGROUP.ITEMID;

         IF ( LNCOUNT = 0 )
         THEN
            LNRETVAL :=
               IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPICONSTANTDBERROR.DBERR_INVALIDPROP,
                                                   F_SPH_DESCR( NULL,
                                                                LRPROPERTYGROUP.ITEMID,
                                                                0 ) );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anItemId',
                                                    IAPIGENERAL.GETLASTERRORTEXT( ),
                                                    GTERRORS );
         END IF;
      END IF;

      
      IF ( LSSPECIFICATIONSECTIONTYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP )
      THEN
         
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM PROPERTY_GROUP_DISPLAY
          WHERE PROPERTY_GROUP = LRPROPERTYGROUP.ITEMID
            AND DISPLAY_FORMAT = LRPROPERTYGROUP.DISPLAYFORMATID;

         IF ( LNCOUNT = 0 )
         THEN
            LNRETVAL :=
               IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPICONSTANTDBERROR.DBERR_INVALIDPGDF,
                                                   F_PGH_DESCR( NULL,
                                                                LRPROPERTYGROUP.ITEMID,
                                                                0 ),
                                                   F_LAYOUT_DESCR_ALL_SS( NULL,
                                                                          LRPROPERTYGROUP.DISPLAYFORMATID,
                                                                          0 ) );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anDisplayFormatId',
                                                    IAPIGENERAL.GETLASTERRORTEXT( ),
                                                    GTERRORS );
         END IF;
      ELSE
         
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM PROPERTY_DISPLAY
          WHERE PROPERTY = LRPROPERTYGROUP.ITEMID
            AND DISPLAY_FORMAT = LRPROPERTYGROUP.DISPLAYFORMATID;

         IF ( LNCOUNT = 0 )
         THEN
            LNRETVAL :=
               IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPICONSTANTDBERROR.DBERR_INVALIDPROPDF,
                                                   F_SPH_DESCR( NULL,
                                                                LRPROPERTYGROUP.ITEMID,
                                                                0 ),
                                                   F_LAYOUT_DESCR_ALL_SS( NULL,
                                                                          LRPROPERTYGROUP.DISPLAYFORMATID,
                                                                          0 ) );
            LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anDisplayFormatId',
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

      IF ( LSSPECIFICATIONSECTIONTYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP )
      THEN
         
         BEGIN
            SELECT REVISION
              INTO LRPROPERTYGROUP.ITEMREVISION
              FROM PROPERTY_GROUP_H
             WHERE PROPERTY_GROUP = LRPROPERTYGROUP.ITEMID
               AND MAX_REV = 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               LRPROPERTYGROUP.ITEMREVISION := 0;
         END;
      ELSE
         
         BEGIN
            SELECT REVISION
              INTO LRPROPERTYGROUP.ITEMREVISION
              FROM PROPERTY_H
             WHERE PROPERTY = LRPROPERTYGROUP.ITEMID
               AND MAX_REV = 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               LRPROPERTYGROUP.ITEMREVISION := 0;
         END;
      END IF;

      
      BEGIN
         SELECT REVISION
           INTO LRPROPERTYGROUP.DISPLAYFORMATREVISION
           FROM LAYOUT
          WHERE LAYOUT_ID = LRPROPERTYGROUP.DISPLAYFORMATID
            AND STATUS = 2;
      EXCEPTION
         WHEN OTHERS
         THEN
            LRPROPERTYGROUP.DISPLAYFORMATREVISION := 0;
      END;

      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.EXTENDSECTION( LRPROPERTYGROUP.PARTNO,
                                                 LRPROPERTYGROUP.REVISION,
                                                 LRPROPERTYGROUP.SECTIONID,
                                                 LRPROPERTYGROUP.SUBSECTIONID,
                                                 LSSPECIFICATIONSECTIONTYPE,
                                                 LRPROPERTYGROUP.ITEMID,
                                                 LRPROPERTYGROUP.ITEMREVISION,
                                                 LRPROPERTYGROUP.DISPLAYFORMATID,
                                                 LRPROPERTYGROUP.DISPLAYFORMATREVISION,
                                                 LRPROPERTYGROUP.ATTRIBUTEID,
                                                 AFHANDLE,
                                                 ANSECTIONSEQUENCENUMBER );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRPROPERTYGROUP.PARTNO,
                                                LRPROPERTYGROUP.REVISION );

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
   END EXTENDPROPERTYGROUP;

   
   FUNCTION SAVEPROPERTYGROUP(
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
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SavePropertyGroup';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRPROPERTYGROUP               IAPITYPE.SPPROPERTYGROUPREC_TYPE;
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
      
      
      
      IF (ANACTION = IAPICONSTANT.ACTIONPOST)
      THEN      
            LRINFO.PARAMETERDATA := IAPICONSTANT.REFRESHWINDOW;
      ELSE        
            LRINFO.PARAMETERDATA := IAPICONSTANT.NOREFRESHWINDOW;
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

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTPROPERTYGROUPS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRPROPERTYGROUP.PARTNO := ASPARTNO;
      LRPROPERTYGROUP.REVISION := ANREVISION;
      LRPROPERTYGROUP.SECTIONID := ANSECTIONID;
      LRPROPERTYGROUP.SUBSECTIONID := ANSUBSECTIONID;
      LRPROPERTYGROUP.ITEMID := ANITEMID;
      GTPROPERTYGROUPS( 0 ) := LRPROPERTYGROUP;

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
   END SAVEPROPERTYGROUP;
    
   
   FUNCTION GETPROPERTIES(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANITEMID                   IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANINCLUDEDONLY             IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1,
      ANSINGLEPROPERTY           IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANALTERNATIVELANGUAGEID    IN       IAPITYPE.LANGUAGEID_TYPE DEFAULT NULL,
      AQPROPERTIES               OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetProperties';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSPECIFICATIONSECTIONTYPE    IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE;
      LRFRAME                       IAPITYPE.FRAMEREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LRPROPERTIES                  IAPITYPE.SPPROPERTYREC_TYPE;
      LRGETPROPERTIES               SPPROPERTYRECORD_TYPE
         := SPPROPERTYRECORD_TYPE( NULL,
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
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT1                     IAPITYPE.SQLSTRING_TYPE
         :=      







              

              ' :PartNo '
           || IAPICONSTANTCOLUMN.PARTNOCOL
           || ', :Revision '
           || IAPICONSTANTCOLUMN.REVISIONCOL
           || ', sp.section_id '
           || IAPICONSTANTCOLUMN.SECTIONIDCOL
           || ', sp.section_rev '
           || IAPICONSTANTCOLUMN.SECTIONREVISIONCOL
           || ', sp.sub_section_id '
           || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
           || ', sp.sub_section_rev '
           || IAPICONSTANTCOLUMN.SUBSECTIONREVISIONCOL
           || ', sp.property_group '
           || IAPICONSTANTCOLUMN.PROPERTYGROUPIDCOL
           || ', sp.property_group_rev '
           || IAPICONSTANTCOLUMN.PROPERTYGROUPREVISIONCOL
           || ', f_pgh_descr(1, sp.property_group, sp.property_group_rev) '
           || IAPICONSTANTCOLUMN.PROPERTYGROUPCOL
           || ', sp.property '
           || IAPICONSTANTCOLUMN.PROPERTYIDCOL
           || ', sp.property_rev '
           || IAPICONSTANTCOLUMN.PROPERTYREVISIONCOL
           || ', f_sph_descr(1, sp.property, sp.property_rev) '
           || IAPICONSTANTCOLUMN.PROPERTYCOL
           || ', sp.attribute '
           || IAPICONSTANTCOLUMN.ATTRIBUTEIDCOL
           || ', sp.attribute_rev '
           || IAPICONSTANTCOLUMN.ATTRIBUTEREVISIONCOL
           || ', f_ath_descr(1, sp.attribute, sp.attribute_rev) '
           || IAPICONSTANTCOLUMN.ATTRIBUTECOL
           || ', -1 '   
           || IAPICONSTANTCOLUMN.DISPLAYFORMATIDCOL
           || ', sp.test_method '
           || IAPICONSTANTCOLUMN.TESTMETHODIDCOL
           || ', sp.test_method_rev '
           || IAPICONSTANTCOLUMN.TESTMETHODREVISIONCOL
	   
	   
           
           
           
	   
           || ', DECODE(sp.test_method, null, null, f_tmh_descr(1, sp.test_method, decode(:statustype, '''
           || IAPICONSTANT.STATUSTYPE_DEVELOPMENT
           || ''', 0, sp.test_method_rev))) '
	   
           || IAPICONSTANTCOLUMN.TESTMETHODCOL
           || ', sp.char_1 '
           || IAPICONSTANTCOLUMN.STRING1COL
           || ', sp.char_2 '
           || IAPICONSTANTCOLUMN.STRING2COL
           || ', sp.char_3 '
           || IAPICONSTANTCOLUMN.STRING3COL
           || ', sp.char_4 '
           || IAPICONSTANTCOLUMN.STRING4COL
           || ', sp.char_5 '
           || IAPICONSTANTCOLUMN.STRING5COL
           || ', sp.char_6 '
           || IAPICONSTANTCOLUMN.STRING6COL
           
           
           
           
           
           
           
           
           
           
             
           || ', DECODE(sp.boolean_1, NULL, NULL, ''Y'',1,0) '
           || IAPICONSTANTCOLUMN.BOOLEAN1COL
           || ', DECODE(sp.boolean_2, NULL, NULL, ''Y'',1,0) '
           || IAPICONSTANTCOLUMN.BOOLEAN2COL
           || ', DECODE(sp.boolean_3, NULL, NULL, ''Y'',1,0) '
           || IAPICONSTANTCOLUMN.BOOLEAN3COL
           || ', DECODE(sp.boolean_4, NULL, NULL, ''Y'',1,0) '
           || IAPICONSTANTCOLUMN.BOOLEAN4COL
           
           || ', sp.date_1 '
           || IAPICONSTANTCOLUMN.DATE1COL
           || ', sp.date_2 '
           || IAPICONSTANTCOLUMN.DATE2COL
           || ', sp.characteristic '
           || IAPICONSTANTCOLUMN.CHARACTERISTICID1COL
           || ', sp.characteristic_rev '
           || IAPICONSTANTCOLUMN.CHARACTERISTICREVISION1COL
	   
           
           || ', DECODE(sp.characteristic , null, null, f_chh_descr(1, sp.characteristic, sp.characteristic_rev)) '
	   
           || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION1COL
           || ', sp.ch_2 '
           || IAPICONSTANTCOLUMN.CHARACTERISTICID2COL
           || ', sp.ch_rev_2 '
           || IAPICONSTANTCOLUMN.CHARACTERISTICREVISION2COL
	   
           
           || ', DECODE(sp.ch_2, null, null, f_chh_descr(1, sp.ch_2, sp.ch_rev_2)) '
	   
           || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION2COL
           || ', sp.ch_3 '
           || IAPICONSTANTCOLUMN.CHARACTERISTICID3COL
           || ', sp.ch_rev_3 '
           || IAPICONSTANTCOLUMN.CHARACTERISTICREVISION3COL
	   
           
           || ', DECODE(sp.ch_3, null, null, f_chh_descr(1, sp.ch_3, sp.ch_rev_3)) '
	   
           || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION3COL;
           
      LSSELECTSPEC                  IAPITYPE.SQLSTRING_TYPE
         :=    ' sp.tm_set_no '
            || IAPICONSTANTCOLUMN.TESTMETHODSETNOCOL
            || ', '''''   
            || IAPICONSTANTCOLUMN.METHODDETAILCOL
            || ', sp.info '
            || IAPICONSTANTCOLUMN.INFOCOL
   	    
	    
            
            || ', iapiSpecificationPropertyGroup.GetUomDescription(sp.part_no, sp.revision, sp.uom_id, sp.uom_rev, sp.uom_alt_id, sp.uom_alt_rev, :EditOnSpec) '
	    
            || IAPICONSTANTCOLUMN.UOMCOL
            || ', DECODE(sp.num_1,NULL,NULL,ROUND(iapiSpecificationPropertyGroup.ConvertNumericValue(sp.part_no, sp.revision, sp.num_1, sp.uom_id, sp.uom_alt_id),10)) '
            || IAPICONSTANTCOLUMN.NUMERIC1COL
            || ', DECODE(sp.num_2,NULL,NULL,ROUND(iapiSpecificationPropertyGroup.ConvertNumericValue(sp.part_no, sp.revision, sp.num_2, sp.uom_id, sp.uom_alt_id),10)) '
            || IAPICONSTANTCOLUMN.NUMERIC2COL
            || ', DECODE(sp.num_3,NULL,NULL,ROUND(iapiSpecificationPropertyGroup.ConvertNumericValue(sp.part_no, sp.revision, sp.num_3, sp.uom_id, sp.uom_alt_id),10)) '
            || IAPICONSTANTCOLUMN.NUMERIC3COL
            || ', DECODE(sp.num_4,NULL,NULL,ROUND(iapiSpecificationPropertyGroup.ConvertNumericValue(sp.part_no, sp.revision, sp.num_4, sp.uom_id, sp.uom_alt_id),10)) '
            || IAPICONSTANTCOLUMN.NUMERIC4COL
            || ', DECODE(sp.num_5,NULL,NULL,ROUND(iapiSpecificationPropertyGroup.ConvertNumericValue(sp.part_no, sp.revision, sp.num_5, sp.uom_id, sp.uom_alt_id),10)) '
            || IAPICONSTANTCOLUMN.NUMERIC5COL
            || ', DECODE(sp.num_6,NULL,NULL,ROUND(iapiSpecificationPropertyGroup.ConvertNumericValue(sp.part_no, sp.revision, sp.num_6, sp.uom_id, sp.uom_alt_id),10)) '
            || IAPICONSTANTCOLUMN.NUMERIC6COL
            || ', DECODE(sp.num_7,NULL,NULL,ROUND(iapiSpecificationPropertyGroup.ConvertNumericValue(sp.part_no, sp.revision, sp.num_7, sp.uom_id, sp.uom_alt_id),10)) '
            || IAPICONSTANTCOLUMN.NUMERIC7COL
            || ', DECODE(sp.num_8,NULL,NULL,ROUND(iapiSpecificationPropertyGroup.ConvertNumericValue(sp.part_no, sp.revision, sp.num_8, sp.uom_id, sp.uom_alt_id),10)) '
            || IAPICONSTANTCOLUMN.NUMERIC8COL
            || ', DECODE(sp.num_9,NULL,NULL,ROUND(iapiSpecificationPropertyGroup.ConvertNumericValue(sp.part_no, sp.revision, sp.num_9, sp.uom_id, sp.uom_alt_id),10)) '
            || IAPICONSTANTCOLUMN.NUMERIC9COL
            || ', DECODE(sp.num_10,NULL,NULL,ROUND(iapiSpecificationPropertyGroup.ConvertNumericValue(sp.part_no, sp.revision, sp.num_10, sp.uom_id, sp.uom_alt_id),10)) '
            || IAPICONSTANTCOLUMN.NUMERIC10COL
            || ', DECODE(tm_det_1,''Y'',1,0) '
            || IAPICONSTANTCOLUMN.TESTMETHODDETAILS1COL
            || ', DECODE(tm_det_2,''Y'',1,0) '
            || IAPICONSTANTCOLUMN.TESTMETHODDETAILS2COL
            || ', DECODE(tm_det_3,''Y'',1,0) '
            || IAPICONSTANTCOLUMN.TESTMETHODDETAILS3COL
            || ', DECODE(tm_det_4,''Y'',1,0) '
            || IAPICONSTANTCOLUMN.TESTMETHODDETAILS4COL
            || ', spl.lang_id '
            || IAPICONSTANTCOLUMN.ALTERNATIVELANGUAGEIDCOL
            || ', NVL(spl.char_1,sp.char_1) '
            || IAPICONSTANTCOLUMN.ALTERNATIVESTRING1COL
            || ', NVL(spl.char_2,sp.char_2) '
            || IAPICONSTANTCOLUMN.ALTERNATIVESTRING2COL
            || ', NVL(spl.char_3,sp.char_3) '
            || IAPICONSTANTCOLUMN.ALTERNATIVESTRING3COL
            || ', NVL(spl.char_4,sp.char_4) '
            || IAPICONSTANTCOLUMN.ALTERNATIVESTRING4COL
            || ', NVL(spl.char_5,sp.char_5) '
            || IAPICONSTANTCOLUMN.ALTERNATIVESTRING5COL
            || ', NVL(spl.char_6,sp.char_6) '
            || IAPICONSTANTCOLUMN.ALTERNATIVESTRING6COL
            || ', NVL(spl.info,sp.info) '
            || IAPICONSTANTCOLUMN.ALTERNATIVEINFOCOL;
      LSSELECTFRAME                 IAPITYPE.SQLSTRING_TYPE
         :=    ' NULL '
            || IAPICONSTANTCOLUMN.TESTMETHODSETNOCOL
            || ', ''1'' '
            || IAPICONSTANTCOLUMN.METHODDETAILCOL
            || ', NULL '
            || IAPICONSTANTCOLUMN.INFOCOL
            
	    
            
            
            
            
            
	    
            || ', iapiSpecificationPropertyGroup.GetUomDescription(:PartNo, :Revision, sp.uom_id, sp.uom_rev, sp.uom_alt_id, sp.uom_alt_rev, :EditOnSpec) '
            
            || IAPICONSTANTCOLUMN.UOMCOL
            || ', DECODE(sp.num_1,NULL,NULL,ROUND(sp.num_1, 10)) '
            || IAPICONSTANTCOLUMN.NUMERIC1COL
            || ', DECODE(sp.num_2,NULL,NULL,ROUND(sp.num_2, 10)) '
            || IAPICONSTANTCOLUMN.NUMERIC2COL
            || ', DECODE(sp.num_3,NULL,NULL,ROUND(sp.num_3, 10)) '
            || IAPICONSTANTCOLUMN.NUMERIC3COL
            || ', DECODE(sp.num_4,NULL,NULL,ROUND(sp.num_4, 10)) '
            || IAPICONSTANTCOLUMN.NUMERIC4COL
            || ', DECODE(sp.num_5,NULL,NULL,ROUND(sp.num_5, 10)) '
            || IAPICONSTANTCOLUMN.NUMERIC5COL
            || ', DECODE(sp.num_6,NULL,NULL,ROUND(sp.num_6, 10)) '
            || IAPICONSTANTCOLUMN.NUMERIC6COL
            || ', DECODE(sp.num_7,NULL,NULL,ROUND(sp.num_7, 10)) '
            || IAPICONSTANTCOLUMN.NUMERIC7COL
            || ', DECODE(sp.num_8,NULL,NULL,ROUND(sp.num_8, 10)) '
            || IAPICONSTANTCOLUMN.NUMERIC8COL
            || ', DECODE(sp.num_9,NULL,NULL,ROUND(sp.num_9, 10)) '
            || IAPICONSTANTCOLUMN.NUMERIC9COL
            || ', DECODE(sp.num_10,NULL,NULL,ROUND(sp.num_10, 10)) '
            || IAPICONSTANTCOLUMN.NUMERIC10COL
            || ', NULL '
            || IAPICONSTANTCOLUMN.TESTMETHODDETAILS1COL
            || ', NULL '
            || IAPICONSTANTCOLUMN.TESTMETHODDETAILS2COL
            || ', NULL '
            || IAPICONSTANTCOLUMN.TESTMETHODDETAILS3COL
            || ', NULL '
            || IAPICONSTANTCOLUMN.TESTMETHODDETAILS4COL
            || ', NULL '
            || IAPICONSTANTCOLUMN.ALTERNATIVELANGUAGEIDCOL
            || ', NULL '
            || IAPICONSTANTCOLUMN.ALTERNATIVESTRING1COL
            || ', NULL '
            || IAPICONSTANTCOLUMN.ALTERNATIVESTRING2COL
            || ', NULL '
            || IAPICONSTANTCOLUMN.ALTERNATIVESTRING3COL
            || ', NULL '
            || IAPICONSTANTCOLUMN.ALTERNATIVESTRING4COL
            || ', NULL '
            || IAPICONSTANTCOLUMN.ALTERNATIVESTRING5COL
            || ', NULL '
            || IAPICONSTANTCOLUMN.ALTERNATIVESTRING6COL
            || ', NULL '
            || IAPICONSTANTCOLUMN.ALTERNATIVEINFOCOL;
            
      LSSELECT2                     IAPITYPE.SQLSTRING_TYPE
	 
         
         :=    ' iapiSpecificationPropertyGroup.GetUomId_AltUomId(:PartNo, :Revision, sp.uom_id, sp.uom_rev, sp.uom_alt_id, sp.uom_alt_rev, :EditOnSpec) '
	 

            || IAPICONSTANTCOLUMN.UOMIDCOL
	    
            
            || ', iapiSpecificationPropertyGroup.GetUomRevision_AltUomRevision(:PartNo, :Revision, sp.uom_id, sp.uom_rev, sp.uom_alt_id, sp.uom_alt_rev, :EditOnSpec) '
	    
            || IAPICONSTANTCOLUMN.UOMREVISIONCOL
            || ', sp.association '
            || IAPICONSTANTCOLUMN.ASSOCIATIONID1COL
            || ', sp.association_rev '
            || IAPICONSTANTCOLUMN.ASSOCIATIONREVISION1COL
	    
            
            || ', DECODE(sp.association, null, null, f_ash_descr(1, sp.association, sp.association_rev)) '
	    
            || IAPICONSTANTCOLUMN.ASSOCIATIONDESCRIPTION1COL
            || ', sp.as_2 '
            || IAPICONSTANTCOLUMN.ASSOCIATIONID2COL
            || ', sp.as_rev_2 '
            || IAPICONSTANTCOLUMN.ASSOCIATIONREVISION2COL
	    
            
            || ', DECODE(sp.as_2, null, null, f_ash_descr(1, sp.as_2, sp.as_rev_2)) '
	    
            || IAPICONSTANTCOLUMN.ASSOCIATIONDESCRIPTION2COL
            || ', sp.as_3 '
            || IAPICONSTANTCOLUMN.ASSOCIATIONID3COL
            || ', sp.as_rev_3 '
            || IAPICONSTANTCOLUMN.ASSOCIATIONREVISION3COL
	    
            
            || ', DECODE(sp.as_3, null, null, f_ash_descr(1, sp.as_3, sp.as_rev_3)) '
	    
            || IAPICONSTANTCOLUMN.ASSOCIATIONDESCRIPTION3COL
            || ', sp.intl '
            || IAPICONSTANTCOLUMN.INTERNATIONALCOL
            || ', sp.sequence_no '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
	    
            
            || ', DECODE(sp.uom_id, null, null, f_find_part_pg_limit(NULL, NULL, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, sp.uom_id, NULL, 2)) '
	    
            || IAPICONSTANTCOLUMN.UPPERLIMITCOL
	    
            
            || ', DECODE(sp.uom_id, null, null, f_find_part_pg_limit(NULL, NULL, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, sp.uom_id, NULL, 1)) '
	    
            || IAPICONSTANTCOLUMN.LOWERLIMITCOL




            || ', f_check_tm_condition(:PartNo, :Revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, sp.attribute) '
            || IAPICONSTANTCOLUMN.HASTESTMETHODCONDITIONCOL;
      LSFROMSPEC                    IAPITYPE.STRING_TYPE := 'specification_prop sp, specification_prop_lang spl';
      LSFROMFRAME                   IAPITYPE.STRING_TYPE := 'frame_prop sp';
      LNEDIT                        IAPITYPE.BOOLEAN_TYPE;
      LNVIEW                        IAPITYPE.BOOLEAN_TYPE;
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE := IAPICONSTANT.STATUSTYPE_DEVELOPMENT;
   BEGIN
      
      IAPISPECIFICATIONACCESS.ENABLEARCACHE;

      
      
      
      
      
      IF ( AQPROPERTIES%ISOPEN )
      THEN
         CLOSE AQPROPERTIES;
      END IF;

      LSSQLNULL :=
            'SELECT '
         || LSSELECT1
         || ', '
         || LSSELECTSPEC
         || ', '
         || LSSELECT2
         || ', NULL '
         || IAPICONSTANTCOLUMN.INCLUDEDCOL   
         || ', NULL '
         || IAPICONSTANTCOLUMN.OPTIONALCOL   
         || ', NULL '
         || IAPICONSTANTCOLUMN.EXTENDEDCOL   
         || ', NULL '
         || IAPICONSTANTCOLUMN.TRANSLATEDCOL   
         || ' FROM '
         || LSFROMSPEC
         || ' WHERE sp.part_no = NULL'
         || ' AND sp.part_no = spl.part_no';
      LSSQLNULL :=
                   'SELECT a.*, RowNum '
                || IAPICONSTANTCOLUMN.ROWINDEXCOL

                || ', 0 '
                || IAPICONSTANTCOLUMN.EDITABLECOL

                || ' FROM ('
                || LSSQLNULL
                || ') a';

      OPEN AQPROPERTIES FOR LSSQLNULL
      USING ASPARTNO,
            ANREVISION,
            LSSTATUSTYPE,
	    
	    0,   
            ASPARTNO,
            ANREVISION,
	    
	    0,   
            ASPARTNO,
            ANREVISION,
	    
	    0,   
            ASPARTNO,
            ANREVISION;

      
      
      
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      GTPROPERTIES.DELETE;
      LRPROPERTIES.PARTNO := ASPARTNO;
      LRPROPERTIES.REVISION := ANREVISION;
      LRPROPERTIES.SECTIONID := ANSECTIONID;
      LRPROPERTIES.SUBSECTIONID := ANSUBSECTIONID;

      IF ANSINGLEPROPERTY = 1
      THEN
         LRPROPERTIES.PROPERTYID := ANITEMID;
         LSSPECIFICATIONSECTIONTYPE := IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY;
      ELSE
         LRPROPERTIES.PROPERTYGROUPID := ANITEMID;
         LSSPECIFICATIONSECTIONTYPE := IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP;
      END IF;

      LRPROPERTIES.ALTERNATIVELANGUAGEID := ANALTERNATIVELANGUAGEID;
      GTPROPERTIES( 0 ) := LRPROPERTIES;
      
      
      
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

      
      
      IF     NOT ANSECTIONID IS NULL
         AND ANITEMID IS NOT NULL
      THEN
         LNRETVAL :=
               IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( ASPARTNO,
                                                            ANREVISION,
                                                            ANSECTIONID,
                                                            ANSUBSECTIONID,
                                                            LSSPECIFICATIONSECTIONTYPE,
                                                            ANITEMID );

         IF ( LNRETVAL IN( IAPICONSTANTDBERROR.DBERR_SPSECTIONNOTFOUND, IAPICONSTANTDBERROR.DBERR_SPITEMNOTFOUND ) )
         THEN
            
            LNRETVAL :=
               IAPIFRAMESECTION.EXISTITEMINSECTION( LRFRAME.FRAMENO,
                                                    LRFRAME.REVISION,
                                                    LRFRAME.OWNER,
                                                    ANSECTIONID,
                                                    ANSUBSECTIONID,
                                                    LSSPECIFICATIONSECTIONTYPE,
                                                    ANITEMID );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    IAPIGENERAL.GETLASTERRORTEXT( ) );
               
               IAPISPECIFICATIONACCESS.DISABLEARCACHE;
                                                   
               RETURN( LNRETVAL );
            END IF;
         ELSIF( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );

               
               IAPISPECIFICATIONACCESS.DISABLEARCACHE;
            
            RETURN( LNRETVAL );
         END IF;
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
                              
         
         IAPISPECIFICATIONACCESS.DISABLEARCACHE;
                     
         RETURN( LNRETVAL );
      END IF;

      
      
      LSSQL :=
            'SELECT '
         || LSSELECT1
         || ', '
         || LSSELECTSPEC
         || ', '
         || LSSELECT2
         || ', 1 '
         || IAPICONSTANTCOLUMN.INCLUDEDCOL   
         || ', DECODE(f_get_mandatory(:FrameNo, :FrameRevision, :FrameOwner, :MaskId, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, sp.attribute) ,''Y'',0,1) '
         || IAPICONSTANTCOLUMN.OPTIONALCOL
         || ', iapiSpecificationPropertyGroup.IsItemExtended(sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, :SectionType, 0, sp.property_group, sp.property,  sp.attribute) '
         || IAPICONSTANTCOLUMN.EXTENDEDCOL   
         || ', DECODE(f_prop_lang(sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, sp.attribute, 0),''x'',1,0) '
         || IAPICONSTANTCOLUMN.TRANSLATEDCOL
         || ' FROM '
         || LSFROMSPEC
         || ' WHERE sp.part_no = :PartNo '
         || ' AND sp.revision = :Revision '
         || ' AND sp.section_id = NVL(:SectionId, sp.section_id)  '
         || ' AND sp.sub_section_id = NVL(:SubsectionId, sp.sub_section_id) ';

      IF ( LSSPECIFICATIONSECTIONTYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP )
      THEN
         LSSQL :=
               LSSQL
            || ' AND sp.property_group = NVL(:ItemId, sp.property_group) '
            || ' AND sp.property_group <> 0 '
	    
            
            || ' AND f_check_item_access(sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, 1, sp.property_group, 0, sp.property, sp.attribute, 0, :EditOnSpec) = 1 ';
	    
      ELSE
         LSSQL :=
               LSSQL
            || ' AND sp.property_group = 0 AND sp.property = NVL(:ItemId, sp.property) '
	    
            
            || ' AND f_check_item_access(sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, 4, 0, 0, sp.property, sp.attribute, 0, :EditOnSpec) = 1 ';
	    
      END IF;

      
      LSSQL :=
            LSSQL
         || '   AND sp.part_no = spl.part_no(+) '
         || '   AND sp.revision = spl.revision(+) '
         || '   AND sp.section_id = spl.section_id(+) '
         || '   AND sp.sub_section_id = spl.sub_section_id(+) '
         || '   AND sp.property_group = spl.property_group(+) '
         || '   AND sp.property = spl.property(+) '
         || '   AND sp.attribute = spl.attribute(+) '
         || '   AND nvl(sp.sequence_no,0) = nvl(spl.sequence_no(+),0) '
         || '   AND spl.lang_id(+) = '
         || NVL( ANALTERNATIVELANGUAGEID,
                 -1 );

      
      IF ( ANINCLUDEDONLY = 0 )
      THEN
         LSSQL :=
               LSSQL
            || ' UNION '
            || 'SELECT '
            || LSSELECT1
            || ', '
            || LSSELECTFRAME
            || ', '
            || LSSELECT2
            || ', 0 '
            || IAPICONSTANTCOLUMN.INCLUDEDCOL   
            || ', DECODE(f_get_mandatory(:FrameNo, :FrameRevision, :FrameOwner, :MaskId, sp.section_id, sp.sub_section_id, sp.property_group, sp.property, sp.attribute) ,''Y'',0,1) '
            || IAPICONSTANTCOLUMN.OPTIONALCOL
            || ', -1 '
            || IAPICONSTANTCOLUMN.EXTENDEDCOL   
            || ', -1 '
            || IAPICONSTANTCOLUMN.TRANSLATEDCOL   
            || ' FROM '
            || LSFROMFRAME
            || ' WHERE sp.frame_no = :FrameNo '
            || ' AND sp.revision = :FrameRevision '
            || ' AND sp.owner = :FrameOwner '
            || ' AND sp.section_id = NVL(:SectionId,sp.section_id) '
            || ' AND sp.sub_section_id = NVL(:SubsectionId, sp.sub_section_id) ';

         IF ( LSSPECIFICATIONSECTIONTYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP )
         THEN
            LSSQL :=
                  LSSQL
               || ' AND sp.property_group = NVL(:ItemId, sp.property_group) '
               || ' AND sp.property_group <> 0 '
	       
               
               || ' AND f_check_item_access(:PartNo, :Revision, sp.section_id, sp.sub_section_id, 1, sp.property_group, 0, sp.property, sp.attribute, 0, :EditOnSpec) = 1 ';
	       
         ELSE
            LSSQL :=
                  LSSQL
               || ' AND sp.property_group = 0 AND sp.property = NVL(:ItemId, sp.property) '
	       
               
               || ' AND f_check_item_access(:PartNo, :Revision, sp.section_id, sp.sub_section_id, 4, 0, 0, sp.property, sp.attribute, 0, :EditOnSpec) = 1 ';
	       
         END IF;

         LSSQL :=
               LSSQL
            || ' AND (sp.section_id, sp.sub_section_id, sp.property_group, sp.property, sp.attribute) '
            || ' NOT IN (SELECT section_id, sub_section_id, property_group, property, attribute FROM specification_prop '
            || ' WHERE part_no = :PartNo '
            || ' AND revision = :Revision '
            || ' AND section_id = NVL(:SectionId, section_id) '
            || ' AND sub_section_id = NVL(:SubSectionId, sub_section_id) ';

         IF ( LSSPECIFICATIONSECTIONTYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP )
         THEN
            LSSQL :=    LSSQL
                     || ' AND property_group = NVL(:ItemId, property_group) '
                     || ' AND property_group <> 0 ';
         ELSE
            LSSQL :=    LSSQL
                     || ' AND property_group = 0 AND property = NVL(:ItemId, property) ';
         END IF;

         LSSQL :=
               LSSQL
            || ' UNION '
            || ' SELECT section_id, sub_section_id, property_group, property, attribute FROM itfrmvpg '
            || ' WHERE frame_no = :FrameNo '
            || ' AND revision = :FrameRevision '
            || ' AND owner = :FrameOwner '
            || ' AND view_id = NVL( :MaskId, -1 ) '
            || ' AND section_id = NVL(:SectionId, section_id) '
            || ' AND sub_section_id = NVL(:SubSectionId, sub_section_id) ';

         IF ( LSSPECIFICATIONSECTIONTYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP )
         THEN
            LSSQL :=    LSSQL
                     || ' AND property_group = NVL(:ItemId, property_group) '
                     || ' AND property_group <> 0 ';
         ELSE
            LSSQL :=    LSSQL
                     || ' AND property_group = 0 AND property = NVL(:ItemId, property) ';
         END IF;

         LSSQL :=    LSSQL
                  || ' AND mandatory = ''H'' )';
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY '
               || IAPICONSTANTCOLUMN.SEQUENCECOL;
      LSSQL :=
            'SELECT a.*, RowNum '
         || IAPICONSTANTCOLUMN.ROWINDEXCOL

         || ', DECODE(:EditOnSpec, 0, 0, f_check_item_access(:PartNo, :Revision, a.'
         || IAPICONSTANTCOLUMN.SECTIONIDCOL
         || ', a.'
         || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
         || ', :PGorSP, DECODE(:PGorSP, 1, a.'
         || IAPICONSTANTCOLUMN.PROPERTYGROUPIDCOL
         || ', a.'
         || IAPICONSTANTCOLUMN.PROPERTYGROUPIDCOL
         || ', 0), 0, a.'
         || IAPICONSTANTCOLUMN.PROPERTYIDCOL
         || ', a.'
         || IAPICONSTANTCOLUMN.ATTRIBUTEIDCOL
	 
         
         || ', 1, :EditOnSpec)) '
	 
         || IAPICONSTANTCOLUMN.EDITABLECOL

         || ' FROM ('
         || LSSQL
         || ') a';

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );
      
      
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

      
      IF ( AQPROPERTIES%ISOPEN )
      THEN
         CLOSE AQPROPERTIES;
      END IF;

      
      IF ( ANINCLUDEDONLY = 0 )
      THEN
         OPEN AQPROPERTIES FOR LSSQL
         USING LNEDIT,
               ASPARTNO,
               ANREVISION,
               LSSPECIFICATIONSECTIONTYPE,
               LSSPECIFICATIONSECTIONTYPE,
	       
               LNEDIT,   
               ASPARTNO,
               ANREVISION,
               LSSTATUSTYPE,
	       
               LNEDIT,   

               ASPARTNO,
               ANREVISION,
	       
               LNEDIT,   
               ASPARTNO,
               ANREVISION,
	       
               LNEDIT,   

               ASPARTNO,
               ANREVISION,
               LRFRAME.FRAMENO,
               LRFRAME.REVISION,               
               LRFRAME.OWNER,
               LRFRAME.MASKID,
               LSSPECIFICATIONSECTIONTYPE,
               ASPARTNO,
               ANREVISION,
               ANSECTIONID,
               ANSUBSECTIONID,
               ANITEMID,
	       
               LNVIEW,   
               ASPARTNO,               
               ANREVISION,
               LSSTATUSTYPE,
           
               ASPARTNO,
               ANREVISION,
           
	       
               LNEDIT,   



               
               



               ASPARTNO,
               ANREVISION,
	       
               LNEDIT,   
               ASPARTNO,
               ANREVISION,               
	       
               LNEDIT,   
               ASPARTNO,
               ANREVISION,
               LRFRAME.FRAMENO,
               LRFRAME.REVISION,
               LRFRAME.OWNER,
               LRFRAME.MASKID,
               LRFRAME.FRAMENO,
               LRFRAME.REVISION,
               LRFRAME.OWNER,               
               ANSECTIONID,
               ANSUBSECTIONID,
               ANITEMID,
               ASPARTNO,
               ANREVISION,
	       
               LNVIEW,   
               ASPARTNO,
               ANREVISION,
               ANSECTIONID,
               ANSUBSECTIONID,               
               ANITEMID,
               LRFRAME.FRAMENO,
               LRFRAME.REVISION,
               LRFRAME.OWNER,
               LRFRAME.MASKID,
               ANSECTIONID,
               ANSUBSECTIONID,
               ANITEMID;
      ELSE
         OPEN AQPROPERTIES FOR LSSQL
         USING LNEDIT,
               ASPARTNO,
               ANREVISION,
               LSSPECIFICATIONSECTIONTYPE,
               LSSPECIFICATIONSECTIONTYPE,
	       
               LNEDIT,   
               ASPARTNO,
               ANREVISION,
               LSSTATUSTYPE,
	       
               LNEDIT,   
               ASPARTNO,
               ANREVISION,
	       
               LNEDIT,   
               ASPARTNO,
               ANREVISION,
	       
               LNEDIT,   
               ASPARTNO,
               ANREVISION,
               LRFRAME.FRAMENO,
               LRFRAME.REVISION,
               LRFRAME.OWNER,
               LRFRAME.MASKID,
               LSSPECIFICATIONSECTIONTYPE,
               ASPARTNO,
               ANREVISION,
               ANSECTIONID,
               ANSUBSECTIONID,
	       
               
               ANITEMID,
               LNVIEW;   
	       
      END IF;

      
      
      
      GTGETPROPERTIES.DELETE;

      LOOP
         LRPROPERTIES := NULL;

         FETCH AQPROPERTIES
          INTO LRPROPERTIES;

         EXIT WHEN AQPROPERTIES%NOTFOUND;
         LRGETPROPERTIES.PARTNO := LRPROPERTIES.PARTNO;
         LRGETPROPERTIES.REVISION := LRPROPERTIES.REVISION;
         LRGETPROPERTIES.SECTIONID := LRPROPERTIES.SECTIONID;
         LRGETPROPERTIES.SECTIONREVISION := LRPROPERTIES.SECTIONREVISION;
         LRGETPROPERTIES.SUBSECTIONID := LRPROPERTIES.SUBSECTIONID;
         LRGETPROPERTIES.SUBSECTIONREVISION := LRPROPERTIES.SUBSECTIONREVISION;
         LRGETPROPERTIES.PROPERTYGROUPID := LRPROPERTIES.PROPERTYGROUPID;
         LRGETPROPERTIES.PROPERTYGROUPREVISION := LRPROPERTIES.PROPERTYGROUPREVISION;
         LRGETPROPERTIES.PROPERTYGROUP := LRPROPERTIES.PROPERTYGROUP;
         LRGETPROPERTIES.PROPERTYID := LRPROPERTIES.PROPERTYID;
         LRGETPROPERTIES.PROPERTYREVISION := LRPROPERTIES.PROPERTYREVISION;
         LRGETPROPERTIES.PROPERTY := LRPROPERTIES.PROPERTY;
         LRGETPROPERTIES.ATTRIBUTEID := LRPROPERTIES.ATTRIBUTEID;
         LRGETPROPERTIES.ATTRIBUTEREVISION := LRPROPERTIES.ATTRIBUTEREVISION;
         LRGETPROPERTIES.ATTRIBUTE := LRPROPERTIES.ATTRIBUTE;
         LRGETPROPERTIES.DISPLAYFORMATID := LRPROPERTIES.DISPLAYFORMATID;
         LRGETPROPERTIES.TESTMETHODID := LRPROPERTIES.TESTMETHODID;
         LRGETPROPERTIES.TESTMETHODREVISION := LRPROPERTIES.TESTMETHODREVISION;
         LRGETPROPERTIES.TESTMETHOD := LRPROPERTIES.TESTMETHOD;
         LRGETPROPERTIES.STRING1 := LRPROPERTIES.STRING1;
         LRGETPROPERTIES.STRING2 := LRPROPERTIES.STRING2;
         LRGETPROPERTIES.STRING3 := LRPROPERTIES.STRING3;
         LRGETPROPERTIES.STRING4 := LRPROPERTIES.STRING4;
         LRGETPROPERTIES.STRING5 := LRPROPERTIES.STRING5;
         LRGETPROPERTIES.STRING6 := LRPROPERTIES.STRING6;
         LRGETPROPERTIES.BOOLEAN1 := LRPROPERTIES.BOOLEAN1;
         LRGETPROPERTIES.BOOLEAN2 := LRPROPERTIES.BOOLEAN2;
         LRGETPROPERTIES.BOOLEAN3 := LRPROPERTIES.BOOLEAN3;
         LRGETPROPERTIES.BOOLEAN4 := LRPROPERTIES.BOOLEAN4;
         LRGETPROPERTIES.DATE1 := LRPROPERTIES.DATE1;
         LRGETPROPERTIES.DATE2 := LRPROPERTIES.DATE2;
         LRGETPROPERTIES.CHARACTERISTICID1 := LRPROPERTIES.CHARACTERISTICID1;
         LRGETPROPERTIES.CHARACTERISTICREVISION1 := LRPROPERTIES.CHARACTERISTICREVISION1;
         LRGETPROPERTIES.CHARACTERISTICDESCRIPTION1 := LRPROPERTIES.CHARACTERISTICDESCRIPTION1;
         LRGETPROPERTIES.CHARACTERISTICID2 := LRPROPERTIES.CHARACTERISTICID2;
         LRGETPROPERTIES.CHARACTERISTICREVISION2 := LRPROPERTIES.CHARACTERISTICREVISION2;
         LRGETPROPERTIES.CHARACTERISTICDESCRIPTION2 := LRPROPERTIES.CHARACTERISTICDESCRIPTION2;
         LRGETPROPERTIES.CHARACTERISTICID3 := LRPROPERTIES.CHARACTERISTICID3;
         LRGETPROPERTIES.CHARACTERISTICREVISION3 := LRPROPERTIES.CHARACTERISTICREVISION3;
         LRGETPROPERTIES.CHARACTERISTICDESCRIPTION3 := LRPROPERTIES.CHARACTERISTICDESCRIPTION3;
         LRGETPROPERTIES.TESTMETHODSETNO := LRPROPERTIES.TESTMETHODSETNO;
         LRGETPROPERTIES.METHODDETAIL := LRPROPERTIES.METHODDETAIL;
         LRGETPROPERTIES.INFO := LRPROPERTIES.INFO;
         LRGETPROPERTIES.UOM := LRPROPERTIES.UOM;
         LRGETPROPERTIES.NUMERIC1 := LRPROPERTIES.NUMERIC1;
         LRGETPROPERTIES.NUMERIC2 := LRPROPERTIES.NUMERIC2;
         LRGETPROPERTIES.NUMERIC3 := LRPROPERTIES.NUMERIC3;
         LRGETPROPERTIES.NUMERIC4 := LRPROPERTIES.NUMERIC4;
         LRGETPROPERTIES.NUMERIC5 := LRPROPERTIES.NUMERIC5;
         LRGETPROPERTIES.NUMERIC6 := LRPROPERTIES.NUMERIC6;
         LRGETPROPERTIES.NUMERIC7 := LRPROPERTIES.NUMERIC7;
         LRGETPROPERTIES.NUMERIC8 := LRPROPERTIES.NUMERIC8;
         LRGETPROPERTIES.NUMERIC9 := LRPROPERTIES.NUMERIC9;
         LRGETPROPERTIES.NUMERIC10 := LRPROPERTIES.NUMERIC10;
         LRGETPROPERTIES.TESTMETHODDETAILS1 := LRPROPERTIES.TESTMETHODDETAILS1;
         LRGETPROPERTIES.TESTMETHODDETAILS2 := LRPROPERTIES.TESTMETHODDETAILS2;
         LRGETPROPERTIES.TESTMETHODDETAILS3 := LRPROPERTIES.TESTMETHODDETAILS3;
         LRGETPROPERTIES.TESTMETHODDETAILS4 := LRPROPERTIES.TESTMETHODDETAILS4;
         LRGETPROPERTIES.ALTERNATIVELANGUAGEID := LRPROPERTIES.ALTERNATIVELANGUAGEID;
         LRGETPROPERTIES.ALTERNATIVESTRING1 := LRPROPERTIES.ALTERNATIVESTRING1;
         LRGETPROPERTIES.ALTERNATIVESTRING2 := LRPROPERTIES.ALTERNATIVESTRING2;
         LRGETPROPERTIES.ALTERNATIVESTRING3 := LRPROPERTIES.ALTERNATIVESTRING3;
         LRGETPROPERTIES.ALTERNATIVESTRING4 := LRPROPERTIES.ALTERNATIVESTRING4;
         LRGETPROPERTIES.ALTERNATIVESTRING5 := LRPROPERTIES.ALTERNATIVESTRING5;
         LRGETPROPERTIES.ALTERNATIVESTRING6 := LRPROPERTIES.ALTERNATIVESTRING6;
         LRGETPROPERTIES.ALTERNATIVEINFO := LRPROPERTIES.ALTERNATIVEINFO;
         LRGETPROPERTIES.UOMID := LRPROPERTIES.UOMID;
         LRGETPROPERTIES.UOMREVISION := LRPROPERTIES.UOMREVISION;
         LRGETPROPERTIES.ASSOCIATIONID1 := LRPROPERTIES.ASSOCIATIONID1;
         LRGETPROPERTIES.ASSOCIATIONREVISION1 := LRPROPERTIES.ASSOCIATIONREVISION1;
         LRGETPROPERTIES.ASSOCIATIONDESCRIPTION1 := LRPROPERTIES.ASSOCIATIONDESCRIPTION1;
         LRGETPROPERTIES.ASSOCIATIONID2 := LRPROPERTIES.ASSOCIATIONID2;
         LRGETPROPERTIES.ASSOCIATIONREVISION2 := LRPROPERTIES.ASSOCIATIONREVISION2;
         LRGETPROPERTIES.ASSOCIATIONDESCRIPTION2 := LRPROPERTIES.ASSOCIATIONDESCRIPTION2;
         LRGETPROPERTIES.ASSOCIATIONID3 := LRPROPERTIES.ASSOCIATIONID3;
         LRGETPROPERTIES.ASSOCIATIONREVISION3 := LRPROPERTIES.ASSOCIATIONREVISION3;
         LRGETPROPERTIES.ASSOCIATIONDESCRIPTION3 := LRPROPERTIES.ASSOCIATIONDESCRIPTION3;
         LRGETPROPERTIES.INTERNATIONAL := LRPROPERTIES.INTERNATIONAL;
         LRGETPROPERTIES.SEQUENCE := LRPROPERTIES.SEQUENCE;
         LRGETPROPERTIES.UPPERLIMIT := LRPROPERTIES.UPPERLIMIT;
         LRGETPROPERTIES.LOWERLIMIT := LRPROPERTIES.LOWERLIMIT;
         LRGETPROPERTIES.EDITABLE := LRPROPERTIES.EDITABLE;
         LRGETPROPERTIES.HASTESTMETHODCONDITION := LRPROPERTIES.HASTESTMETHODCONDITION;
         LRGETPROPERTIES.INCLUDED := LRPROPERTIES.INCLUDED;
         LRGETPROPERTIES.OPTIONAL := LRPROPERTIES.OPTIONAL;
         LRGETPROPERTIES.EXTENDED := LRPROPERTIES.EXTENDED;
         LRGETPROPERTIES.TRANSLATED := LRPROPERTIES.TRANSLATED;
         LRGETPROPERTIES.ROWINDEX := LRPROPERTIES.ROWINDEX;
         GTGETPROPERTIES.EXTEND;
         GTGETPROPERTIES( GTGETPROPERTIES.COUNT ) := LRGETPROPERTIES;
      END LOOP;

      CLOSE AQPROPERTIES;

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQLNULL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQPROPERTIES FOR LSSQLNULL USING ASPARTNO,
      ANREVISION,
      LSSTATUSTYPE,
      
      0,
      ASPARTNO,
      ANREVISION,
      
      0,
      ASPARTNO,
      ANREVISION,
      
      0,
      ASPARTNO,
      ANREVISION;

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
         || ', Sectionid '
         || IAPICONSTANTCOLUMN.SECTIONIDCOL
         || ', Sectionrevision '
         || IAPICONSTANTCOLUMN.SECTIONREVISIONCOL
         || ', Subsectionid '
         || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
         || ', Subsectionrevision '
         || IAPICONSTANTCOLUMN.SUBSECTIONREVISIONCOL
         || ', Propertygroupid '
         || IAPICONSTANTCOLUMN.PROPERTYGROUPIDCOL
         || ', Propertygrouprevision '
         || IAPICONSTANTCOLUMN.PROPERTYGROUPREVISIONCOL
         || ', PropertyGroup '
         || IAPICONSTANTCOLUMN.PROPERTYGROUPCOL
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
         || ', Displayformatid '
         || IAPICONSTANTCOLUMN.DISPLAYFORMATIDCOL
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
         || ', Characteristicid2 '
         || IAPICONSTANTCOLUMN.CHARACTERISTICID2COL
         || ', Characteristicrevision2 '
         || IAPICONSTANTCOLUMN.CHARACTERISTICREVISION2COL
         || ', Characteristicdescription2 '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION2COL
         || ', Characteristicid3 '
         || IAPICONSTANTCOLUMN.CHARACTERISTICID3COL
         || ', Characteristicrevision3 '
         || IAPICONSTANTCOLUMN.CHARACTERISTICREVISION3COL
         || ', Characteristicdescription3 '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION3COL
         || ', Testmethodsetno '
         || IAPICONSTANTCOLUMN.TESTMETHODSETNOCOL
         || ', Methoddetail '
         || IAPICONSTANTCOLUMN.METHODDETAILCOL
         || ', Info '
         || IAPICONSTANTCOLUMN.INFOCOL
         || ', Uom '
         || IAPICONSTANTCOLUMN.UOMCOL
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
         || ', Testmethoddetails1 '
         || IAPICONSTANTCOLUMN.TESTMETHODDETAILS1COL
         || ', Testmethoddetails2 '
         || IAPICONSTANTCOLUMN.TESTMETHODDETAILS2COL
         || ', Testmethoddetails3 '
         || IAPICONSTANTCOLUMN.TESTMETHODDETAILS3COL
         || ', Testmethoddetails4 '
         || IAPICONSTANTCOLUMN.TESTMETHODDETAILS4COL
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
         || ', Alternativeinfo '
         || IAPICONSTANTCOLUMN.ALTERNATIVEINFOCOL
         || ', Uomid '
         || IAPICONSTANTCOLUMN.UOMIDCOL
         || ', Uomrevision '
         || IAPICONSTANTCOLUMN.UOMREVISIONCOL
         || ', Associationid1 '
         || IAPICONSTANTCOLUMN.ASSOCIATIONID1COL
         || ', Associationrevision1 '
         || IAPICONSTANTCOLUMN.ASSOCIATIONREVISION1COL
         || ', Associationdescription1 '
         || IAPICONSTANTCOLUMN.ASSOCIATIONDESCRIPTION1COL
         || ', Associationid2 '
         || IAPICONSTANTCOLUMN.ASSOCIATIONID2COL
         || ', Associationrevision2 '
         || IAPICONSTANTCOLUMN.ASSOCIATIONREVISION2COL
         || ', Associationdescription2 '
         || IAPICONSTANTCOLUMN.ASSOCIATIONDESCRIPTION2COL
         || ', Associationid3 '
         || IAPICONSTANTCOLUMN.ASSOCIATIONID3COL
         || ', Associationrevision3 '
         || IAPICONSTANTCOLUMN.ASSOCIATIONREVISION3COL
         || ', Associationdescription3 '
         || IAPICONSTANTCOLUMN.ASSOCIATIONDESCRIPTION3COL
         || ', International '
         || IAPICONSTANTCOLUMN.INTERNATIONALCOL
         || ', Sequence '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ', upperlimit '
         || IAPICONSTANTCOLUMN.UPPERLIMITCOL
         || ', lowerlimit '
         || IAPICONSTANTCOLUMN.LOWERLIMITCOL
         || ', HasTestMethodCondition '
         || IAPICONSTANTCOLUMN.HASTESTMETHODCONDITIONCOL
         || ', Included '
         || IAPICONSTANTCOLUMN.INCLUDEDCOL
         || ', Optional '
         || IAPICONSTANTCOLUMN.OPTIONALCOL
         || ', Extended '
         || IAPICONSTANTCOLUMN.EXTENDEDCOL
         || ', Translated '
         || IAPICONSTANTCOLUMN.TRANSLATEDCOL
         || ', Rowindex '
         || IAPICONSTANTCOLUMN.ROWINDEXCOL
         || ', Editable '
         || IAPICONSTANTCOLUMN.EDITABLECOL;
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM TABLE( CAST( :gtGetProperties AS SpPropertyTable_Type ) ) ';

      IF ( AQPROPERTIES%ISOPEN )
      THEN
         CLOSE AQPROPERTIES;
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );


      OPEN AQPROPERTIES FOR LSSQL USING GTGETPROPERTIES;

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
   END GETPROPERTIES;

   
   FUNCTION CONVERTNUMERICVALUE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      AFVALUE                    IN       IAPITYPE.FLOAT_TYPE,
      ANUOMID                    IN       IAPITYPE.ID_TYPE,
      ANALTERNATIVEUOMID         IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.FLOAT_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ConvertNumericValue';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LFRETVAL                      IAPITYPE.FLOAT_TYPE;
      LFVALUE                       IAPITYPE.FLOAT_TYPE;
      LNUOMTYPE                     IAPITYPE.BOOLEAN_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNCONVERSIONFACTOR            IAPITYPE.NUMVAL_TYPE;
      LNCONVERSIONFUNCTION          IAPITYPE.NUMVAL_TYPE;
      LNROUND                       IAPITYPE.NUMVAL_TYPE;
      LNROUNDVALUE                  IAPITYPE.NUMVAL_TYPE;
      LNROUNDCONVERSIONFACTOR       IAPITYPE.NUMVAL_TYPE;
      
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;            
   BEGIN
      
      
      
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
         
         RETURN( AFVALUE );
      END IF;

      IF ( LNACCESS = 1 )
      THEN
         
         LFRETVAL := AFVALUE;
      ELSIF ANALTERNATIVEUOMID IS NULL
      THEN
         LFRETVAL := AFVALUE;
      ELSE
         

         

















         BEGIN
            
            SELECT UOM_TYPE
              INTO LNUOMTYPE
              FROM SPECIFICATION_HEADER
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION;

            SELECT   LENGTH( ROUND( AFVALUE,
                                    37 ) )
                   - ( DECODE( INSTR( AFVALUE,
                                      '.' ),
                               0, LENGTH( ROUND( AFVALUE,
                                                 37 ) ),
                               INSTR( AFVALUE,
                                      '.' ) ) )
                   + 2
              INTO LNROUNDVALUE
              FROM DUAL;

            
            SELECT CONV_FCT,
                   CONV_FACTOR
              INTO LNCONVERSIONFUNCTION,
                   LNCONVERSIONFACTOR
              FROM ITUMC
             WHERE UOM_ID = ANUOMID
               AND UOM_ALT_ID = ANALTERNATIVEUOMID;

            IF (     ( LNCONVERSIONFACTOR = 0 )
                 OR ( LNCONVERSIONFACTOR IS NULL ) )
            THEN
               LNROUNDCONVERSIONFACTOR := 0;
            ELSE
              
              
              LNROUNDCONVERSIONFACTOR := 12;
              
            END IF;

            LNROUND :=   LNROUNDVALUE
                       + LNROUNDCONVERSIONFACTOR;
            
            
            
            SELECT STATUS_TYPE
              INTO LSSTATUSTYPE
              FROM SPECIFICATION_HEADER SH, STATUS S
             WHERE SH.STATUS = S.STATUS 
               AND PART_NO = ASPARTNO
               AND REVISION = ANREVISION;                             
            

            
            
            
            
            
            IF (LSSTATUSTYPE = IAPICONSTANT.STATUSTYPE_DEVELOPMENT)
            THEN               
                 LFRETVAL := AFVALUE;
            ELSE
            
                IF (      ( NOT IAPIGENERAL.SESSION.SETTINGS.METRIC )
                     AND ( LNUOMTYPE = IAPICONSTANT.UOMTYPE_METRIC ) )
                THEN
                   
                   IAPIGENERAL.LOGINFO( GSSOURCE,
                                        LSMETHOD,
                                           'You are in non-metric mode and specification '
                                        || ASPARTNO
                                        || ' ['
                                        || TO_CHAR( ANREVISION )
                                        || ']'
                                        || ' is metric, conversion will be done.',
                                        IAPICONSTANT.INFOLEVEL_3 );

                   CASE LNCONVERSIONFUNCTION
                      WHEN 1
                      THEN   
                         LNCONVERSIONFACTOR := F_CONVERT_C2F( AFVALUE );
                         LFRETVAL := ROUND( LNCONVERSIONFACTOR,
                                            LNROUNDVALUE );
                      WHEN 2
                      THEN   
                         LNCONVERSIONFACTOR := F_CONVERT_F2C( AFVALUE );
                         LFRETVAL := ROUND(   1
                                            / LNCONVERSIONFACTOR,
                                            LNROUNDVALUE );
                      ELSE
                         LFRETVAL := ROUND(   LNCONVERSIONFACTOR
                                            * AFVALUE,
                                            LNROUND );
                   END CASE;
                ELSIF(      ( IAPIGENERAL.SESSION.SETTINGS.METRIC )
                       AND ( LNUOMTYPE = IAPICONSTANT.UOMTYPE_NONMETRIC ) )
                THEN
                   
                   IAPIGENERAL.LOGINFO( GSSOURCE,
                                        LSMETHOD,
                                           'You are in metric mode and specification '
                                        || ASPARTNO
                                        || ' ['
                                        || TO_CHAR( ANREVISION )
                                        || ']'
                                        || ' is non-metric, conversion will be done.',
                                        IAPICONSTANT.INFOLEVEL_3 );

                   CASE LNCONVERSIONFUNCTION
                      WHEN 1
                      THEN   
                         LNCONVERSIONFACTOR := F_CONVERT_F2C( AFVALUE );
                         LFRETVAL := ROUND( LNCONVERSIONFACTOR,
                                            LNROUNDVALUE );
                      WHEN 2
                      THEN   
                         LNCONVERSIONFACTOR := F_CONVERT_C2F( AFVALUE );
                         LFRETVAL := ROUND(   1
                                            / LNCONVERSIONFACTOR,
                                            LNROUNDVALUE );
                      ELSE
                         IF (     ( LNCONVERSIONFACTOR = 0 )
                              OR ( LNCONVERSIONFACTOR IS NULL ) )
                         THEN
                            LNCONVERSIONFACTOR := 1;
                         END IF;

                         LFRETVAL := ROUND(    (   1
                                                 / LNCONVERSIONFACTOR )
                                            * AFVALUE,
                                            LNROUND );
                   END CASE;
                ELSE
                   
                   
                   IF IAPIGENERAL.SESSION.SETTINGS.METRIC
                   THEN
                      IAPIGENERAL.LOGINFO( GSSOURCE,
                                           LSMETHOD,
                                              'You are in metric mode and specification '
                                           || ASPARTNO
                                           || ' ['
                                           || TO_CHAR( ANREVISION )
                                           || ']'
                                           || ' is metric, no conversion will be done.',
                                           IAPICONSTANT.INFOLEVEL_3 );
                   ELSE
                      IAPIGENERAL.LOGINFO( GSSOURCE,
                                           LSMETHOD,
                                              'You are in non-metric mode and specification '
                                           || ASPARTNO
                                           || ' ['
                                           || TO_CHAR( ANREVISION )
                                           || ']'
                                           || ' is non-metric, no conversion will be done.',
                                           IAPICONSTANT.INFOLEVEL_3 );
                   END IF;

                   LFRETVAL := AFVALUE;
                END IF;
            
            
            END IF;
            
            
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               LFRETVAL := AFVALUE;
         END;
      END IF;

      RETURN( LFRETVAL );
   END CONVERTNUMERICVALUE;

   
   FUNCTION GETUOMDESCRIPTION(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANUOMID                    IN       IAPITYPE.ID_TYPE,
      ANUOMREVISION              IN       IAPITYPE.REVISION_TYPE,
      ANALTERNATIVEUOMID         IN       IAPITYPE.ID_TYPE,
      
      
      ANALTERNATIVEUOMREVISION   IN       IAPITYPE.REVISION_TYPE,
      ANACCESS                   IN       IAPITYPE.BOOLEAN_TYPE DEFAULT NULL )
      
      RETURN IAPITYPE.DESCRIPTION_TYPE
   IS
       
       
       
       
      
       
       
       
       
       
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUomDescription';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNUOMID                       IAPITYPE.ID_TYPE;
      LNUOMREVISION                 IAPITYPE.REVISION_TYPE;
      LSDESCRIPTION                 IAPITYPE.DESCRIPTION_TYPE;
      LNUOMTYPE                     IAPITYPE.BOOLEAN_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF NOT( ASPARTNO IS NULL )
      THEN
         
         SELECT UOM_TYPE
           INTO LNUOMTYPE
           FROM SPECIFICATION_HEADER
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION;
      END IF;

      
      LNUOMID := ANUOMID;
      LNUOMREVISION := ANUOMREVISION;

      IF (      ( LNUOMTYPE = IAPICONSTANT.UOMTYPE_NONMETRIC )
           AND ( ANALTERNATIVEUOMID IS NOT NULL ) )
      THEN
         LNUOMID := ANALTERNATIVEUOMID;
         LNUOMREVISION := ANALTERNATIVEUOMREVISION;
      END IF;

      
      IF ( ANACCESS IS NOT NULL )
      THEN
         LNACCESS := ANACCESS;
      ELSE
      
      IF NOT( ASPARTNO IS NULL )
      THEN
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
      ELSE
         LNACCESS := 1;
      END IF;

      
      END IF;
      

      IF ( LNACCESS = 0 )
      THEN
         
         IF (      ( NOT IAPIGENERAL.SESSION.SETTINGS.METRIC )
              AND ( ANALTERNATIVEUOMID IS NOT NULL ) )
         THEN
            LNUOMID := ANALTERNATIVEUOMID;
            LNUOMREVISION := ANALTERNATIVEUOMREVISION;
         END IF;

         IF ( IAPIGENERAL.SESSION.SETTINGS.METRIC )
         THEN
            LNUOMID := ANUOMID;
            LNUOMREVISION := ANUOMREVISION;
         END IF;
      END IF;

      IF ( IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID IS NULL )
      THEN
         IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID := 1;
      END IF;

      IF LNUOMID IS NOT NULL
      THEN
         IF ( ANREVISION = 0 )
         THEN
            BEGIN
               SELECT DESCRIPTION
                 INTO LSDESCRIPTION
                 FROM UOM_H
                WHERE UOM_ID = LNUOMID
                  AND LANG_ID = IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID
                  AND MAX_REV = 1;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  SELECT DESCRIPTION
                    INTO LSDESCRIPTION
                    FROM UOM_H
                   WHERE UOM_ID = LNUOMID
                     AND LANG_ID = 1
                     AND MAX_REV = 1;
            END;
         ELSE
            BEGIN
               SELECT DESCRIPTION
                 INTO LSDESCRIPTION
                 FROM UOM_H
                WHERE UOM_ID = LNUOMID
                  AND REVISION = LNUOMREVISION
                  AND LANG_ID = IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  SELECT DESCRIPTION
                    INTO LSDESCRIPTION
                    FROM UOM_H
                   WHERE UOM_ID = LNUOMID
                     AND REVISION = LNUOMREVISION
                     AND LANG_ID = 1;
            END;
         END IF;
      END IF;

      RETURN( LSDESCRIPTION );
   EXCEPTION
      
      WHEN NO_DATA_FOUND
      THEN
         
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
         RETURN (NULL);             
      
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( NULL );
   END GETUOMDESCRIPTION;

   
   FUNCTION GETUOMID_ALTUOMID(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANUOMID                    IN       IAPITYPE.ID_TYPE,
      ANUOMREVISION              IN       IAPITYPE.REVISION_TYPE,
      ANALTERNATIVEUOMID         IN       IAPITYPE.ID_TYPE,
      
      
      ANALTERNATIVEUOMREVISION   IN       IAPITYPE.REVISION_TYPE,
      ANACCESS                   IN       IAPITYPE.BOOLEAN_TYPE DEFAULT NULL )
      
      RETURN IAPITYPE.ID_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUomId_AltUomId';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNUOMID                       IAPITYPE.ID_TYPE;
      LNUOMREVISION                 IAPITYPE.REVISION_TYPE;
      LNUOMTYPE                     IAPITYPE.BOOLEAN_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF NOT( ASPARTNO IS NULL )
      THEN
         
         SELECT UOM_TYPE
           INTO LNUOMTYPE
           FROM SPECIFICATION_HEADER
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION;
      END IF;

      LNUOMID := ANUOMID;
      LNUOMREVISION := ANUOMREVISION;

      IF (      ( LNUOMTYPE = IAPICONSTANT.UOMTYPE_NONMETRIC )
           AND ( ANALTERNATIVEUOMID IS NOT NULL ) )
      THEN
         LNUOMID := ANALTERNATIVEUOMID;
         LNUOMREVISION := ANALTERNATIVEUOMREVISION;
      END IF;

      
      IF ( ANACCESS IS NOT NULL )
      THEN
         LNACCESS := ANACCESS;
      ELSE
      
      IF NOT( ASPARTNO IS NULL )
      THEN
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
      ELSE
         LNACCESS := 1;
      END IF;
      
      END IF;
      


      IF ( LNACCESS = 0 )
      THEN
         
         IF (      ( NOT IAPIGENERAL.SESSION.SETTINGS.METRIC )
              AND ( ANALTERNATIVEUOMID IS NOT NULL ) )
         THEN
            LNUOMID := ANALTERNATIVEUOMID;
            LNUOMREVISION := ANALTERNATIVEUOMREVISION;
         END IF;

         IF ( IAPIGENERAL.SESSION.SETTINGS.METRIC )
         THEN
            LNUOMID := ANUOMID;
            LNUOMREVISION := ANUOMREVISION;
         END IF;
      END IF;

      RETURN( LNUOMID );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( NULL );
   END GETUOMID_ALTUOMID;

   
   FUNCTION GETUOMREVISION_ALTUOMREVISION(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANUOMID                    IN       IAPITYPE.ID_TYPE,
      ANUOMREVISION              IN       IAPITYPE.REVISION_TYPE,
      ANALTERNATIVEUOMID         IN       IAPITYPE.ID_TYPE,
      
      
      ANALTERNATIVEUOMREVISION   IN       IAPITYPE.REVISION_TYPE,
      ANACCESS                   IN       IAPITYPE.BOOLEAN_TYPE DEFAULT NULL )
      
      RETURN IAPITYPE.REVISION_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUomRevision_AltUomRevision';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNUOMID                       IAPITYPE.ID_TYPE;
      LNUOMREVISION                 IAPITYPE.REVISION_TYPE;
      LNUOMTYPE                     IAPITYPE.BOOLEAN_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF NOT( ASPARTNO IS NULL )
      THEN
         
         SELECT UOM_TYPE
           INTO LNUOMTYPE
           FROM SPECIFICATION_HEADER
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION;
      END IF;

      LNUOMID := ANUOMID;
      LNUOMREVISION := ANUOMREVISION;

      IF (      ( LNUOMTYPE = IAPICONSTANT.UOMTYPE_NONMETRIC )
           AND ( ANALTERNATIVEUOMID IS NOT NULL ) )
      THEN
         LNUOMID := ANALTERNATIVEUOMID;
         LNUOMREVISION := ANALTERNATIVEUOMREVISION;
      END IF;

      
      IF ( ANACCESS IS NOT NULL )
      THEN
         LNACCESS := ANACCESS;
      ELSE
      
      IF NOT( ASPARTNO IS NULL )
      THEN
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
      ELSE
         LNACCESS := 1;
      END IF;

      
      END IF;
      

      IF ( LNACCESS = 0 )
      THEN
         
         IF (      ( NOT IAPIGENERAL.SESSION.SETTINGS.METRIC )
              AND ( ANALTERNATIVEUOMID IS NOT NULL ) )
         THEN
            LNUOMID := ANALTERNATIVEUOMID;
            LNUOMREVISION := ANALTERNATIVEUOMREVISION;
         END IF;

         IF ( IAPIGENERAL.SESSION.SETTINGS.METRIC )
         THEN
            LNUOMID := ANUOMID;
            LNUOMREVISION := ANUOMREVISION;
         END IF;
      END IF;

      RETURN( LNUOMREVISION );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( NULL );
   END GETUOMREVISION_ALTUOMREVISION;

   
   FUNCTION GETPROPERTYGROUPS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANINCLUDEDONLY             IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1,
      AQPROPERTYGROUPS           OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPropertyGroups';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' DISTINCT PART_NO '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', REVISION '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', SECTION_ID '
            || IAPICONSTANTCOLUMN.SECTIONIDCOL
            || ', SUB_SECTION_ID '
            || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
            || ', PROPERTY_GROUP '
            || IAPICONSTANTCOLUMN.PROPERTYGROUPIDCOL
            || ', property_group_rev '
            || IAPICONSTANTCOLUMN.PROPERTYGROUPREVISIONCOL
            || ', f_pgh_descr(1, sp.property_group, sp.property_group_rev) '
            || IAPICONSTANTCOLUMN.PROPERTYGROUPCOL
            || ', DECODE(:EditOnSpec, 0, 0, f_check_item_access(sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, 1, sp.property_group, 0, 0, 0, 1)) '
            || IAPICONSTANTCOLUMN.EDITABLECOL
            || ', 1 '
            || IAPICONSTANTCOLUMN.INCLUDEDCOL;
      LSSELECTFRAME                 IAPITYPE.SQLSTRING_TYPE
         :=    ' SELECT :asPartNo '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', :anRevision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', section_id '
            || IAPICONSTANTCOLUMN.SECTIONIDCOL
            || ', sub_section_id '
            || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
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
            || IAPICONSTANTCOLUMN.PROPERTYGROUPIDCOL
            || ', ref_ver '
            || IAPICONSTANTCOLUMN.PROPERTYGROUPREVISIONCOL
            || ',  f_pgh_descr( 1, '
            || '               DECODE(type, '
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
            || ' ,ref_ver ) '
            || IAPICONSTANTCOLUMN.PROPERTYGROUPCOL
            || ', DECODE(:EditOnSpec, 0, 0, f_check_item_access(:asPartNo, :anRevision, section_id, sub_section_id, type, decode(type, 4, 0 ,ref_id), NVL(ref_owner,0),  decode(type, 4,ref_id, 0), 0, 1)) '
            || IAPICONSTANTCOLUMN.EDITABLECOL
            || ', 0 '
            || IAPICONSTANTCOLUMN.INCLUDEDCOL   
                                             ;
      LSFROM                        VARCHAR2( 128 ) := ' FROM specification_prop sp ';
      LSWHERE                       VARCHAR2( 512 )
         :=    '  Where PART_NO = :asPartNo '
            || ' AND REVISION = :anRevision '
            || ' AND SECTION_ID = NVL(:anSectionId, SECTION_ID) '
            || ' AND SUB_SECTION_ID = NVL(:anSubSectionId, SUB_SECTION_ID) '
            || ' AND DECODE(:ViewOnSpec, 0, 0, f_check_item_access(sp.part_no, sp.revision, sp.section_id, sp.sub_section_id, 1, sp.property_group)) = 1 '
            
            || ' AND sp.property_group <> 0 ';
      LNEDIT                        IAPITYPE.BOOLEAN_TYPE;
      LNVIEW                        IAPITYPE.BOOLEAN_TYPE;
      LSFROMFRAME                   IAPITYPE.STRING_TYPE := 'frame_section';
      LRFRAME                       IAPITYPE.FRAMEREC_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQPROPERTYGROUPS%ISOPEN )
      THEN
         CLOSE AQPROPERTYGROUPS;
      END IF;

      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || ' WHERE 1=2 ';

      OPEN AQPROPERTYGROUPS FOR LSSQL USING 0;

      
      
      
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

       
       
      
      IF NOT ANSECTIONID IS NULL
      THEN
         LNRETVAL := IAPISPECIFICATIONSECTION.EXISTID( ASPARTNO,
                                                       ANREVISION,
                                                       ANSECTIONID,
                                                       ANSUBSECTIONID );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            LNRETVAL := IAPIFRAMESECTION.EXISTID( LRFRAME.FRAMENO,
                                                  LRFRAME.REVISION,
                                                  LRFRAME.OWNER,
                                                  ANSECTIONID,
                                                  ANSUBSECTIONID );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
               RETURN( LNRETVAL );
            END IF;
         END IF;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
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
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );



      
      IF ANINCLUDEDONLY = 0
      THEN
         LSSQL :=
               LSSQL
            || ' UNION '
            || LSSELECTFRAME
            || ' FROM '
            || LSFROMFRAME
            || ' WHERE frame_no = :FrameNo '
            || ' AND revision = :FrameRevision '
            || ' AND owner = :FrameOwner '
            || ' AND section_id = NVL(:SectionId, section_id) '
            || ' AND sub_section_id = NVL(:SubsectionId, sub_section_id) '
            || ' AND TYPE = '
            || IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP
            || ' AND DECODE(:ViewOnSpec, 0, 0, f_check_item_access(:asPartNo, :anRevision, section_id, sub_section_id, type, decode(type, 4, 0 ,ref_id), NVL(ref_owner,0), decode(type, 4, ref_id, 0))) = 1 '
            || ' AND (section_id, sub_section_id, type, ref_id) '
            || ' NOT IN (SELECT section_id, sub_section_id, TYPE, DECODE( TYPE, '
            || IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC
            || ', 0, '
            || IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST
            || ', 0, ref_id ) FROM specification_section '
            || ' WHERE part_no = :asPartNo '
            || ' AND revision = :anRevision '
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
            || ' AND mandatory = ''H'' )';

         IF IAPIGENERAL.SESSION.APPLICATIONUSER.VIEWBOMALLOWED = 0
         THEN
            LSSQL :=    LSSQL
                     || ' AND type NOT IN (3,7)';
         END IF;
      END IF;




      LSSQL :=    'SELECT a.* '
               || ' FROM ('
               || LSSQL
               || ') a';


      IF ( AQPROPERTYGROUPS%ISOPEN )
      THEN
         CLOSE AQPROPERTYGROUPS;
      END IF;

      IF ANINCLUDEDONLY = 0
      THEN
         OPEN AQPROPERTYGROUPS FOR LSSQL
         USING LNEDIT,
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
         OPEN AQPROPERTYGROUPS FOR LSSQL USING LNEDIT,
         ASPARTNO,
         ANREVISION,
         ANSECTIONID,
         ANSUBSECTIONID,
         LNVIEW;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPROPERTYGROUPS;

   
   FUNCTION GETNUMERICPGHEADERS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANPROPERTYGROUP            IN       IAPITYPE.ID_TYPE,
      AQNUMPGHEADERS             OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetNumericPGHeaders';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 2048 );
      LSSELECT                      VARCHAR2( 1536 )
                        :=    ' header_id '
                           || IAPICONSTANTCOLUMN.HEADERIDCOL
                           || ', f_hdh_descr(0,pl.header_id,0) '
                           || IAPICONSTANTCOLUMN.HEADERVALUECOL;
      LSFROM                        VARCHAR2( 128 ) := ' FROM property_layout pl ';
      LSWHERE                       VARCHAR2( 512 )
         :=    ' WHERE (layout_id, revision) IN '
            || ' (SELECT display_format, display_format_rev '
            || ' FROM specification_Section '
            || ' WHERE part_no = :asPartNo '
            || ' AND revision = :anRevision '
            || ' AND ref_id = :anPropertyGroup '
            || ' AND section_id = :anSectionId '
            || ' AND sub_section_id = :anSubSectionId '
            || ' AND type = 1 ) '
            || ' AND pl.field_id > 0 and pl.field_id < 11 ';
   BEGIN
      
      
      
      
      
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || ' AND 1=2 ';

      OPEN AQNUMPGHEADERS FOR LSSQL USING ASPARTNO,
      ANREVISION,
      ANPROPERTYGROUP,
      ANSECTIONID,
      ANSUBSECTIONID;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
       
       
       
      
      LNRETVAL :=
         IAPISPECIFICATIONSECTION.EXISTITEMINSECTION( ASPARTNO,
                                                      ANREVISION,
                                                      ANSECTIONID,
                                                      ANSUBSECTIONID,
                                                      IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP,
                                                      ANPROPERTYGROUP );

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
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQNUMPGHEADERS FOR LSSQL USING ASPARTNO,
      ANREVISION,
      ANPROPERTYGROUP,
      ANSECTIONID,
      ANSUBSECTIONID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'SELECT '
                  || LSSELECT
                  || LSFROM
                  || LSWHERE
                  || ' AND 1=2 ';

         OPEN AQNUMPGHEADERS FOR LSSQL USING ASPARTNO,
         ANREVISION,
         ANPROPERTYGROUP,
         ANSECTIONID,
         ANSUBSECTIONID;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETNUMERICPGHEADERS;

   
   FUNCTION EXTENDPROPERTYGROUPPB(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANDISPLAYFORMATID          IN       IAPITYPE.ID_TYPE,
      ANSINGLEPROPERTY           IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQSECTIONSEQUENCENUMBER    OUT      IAPITYPE.REF_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExtendPropertyGroupPb';
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
         IAPISPECIFICATIONPROPERTYGROUP.EXTENDPROPERTYGROUP( ASPARTNO,
                                                             ANREVISION,
                                                             ANSECTIONID,
                                                             ANSUBSECTIONID,
                                                             ANITEMID,
                                                             ANDISPLAYFORMATID,
                                                             ANSINGLEPROPERTY,
                                                             ANATTRIBUTEID,
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
   END EXTENDPROPERTYGROUPPB;

   
   FUNCTION EXTENDPROPERTYPB(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPID          IN       IAPITYPE.ID_TYPE,
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE,
      ANUOMID                    IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANASSOCIATIONID1           IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANASSOCIATIONID2           IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANASSOCIATIONID3           IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANDISPLAYFORMATID          IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQPROPERTYSEQUENCENUMBER   OUT      IAPITYPE.REF_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExtendPropertyPb';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNPROPERTYSEQUENCENUMBER      IAPITYPE.PROPERTYSEQUENCENUMBER_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 ) :=    ':PropertySequenceNumber '
                                                        || IAPICONSTANTCOLUMN.SEQUENCECOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'dual';
      
      LNUOMID                       IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQPROPERTYSEQUENCENUMBER%ISOPEN )
      THEN
         CLOSE AQPROPERTYSEQUENCENUMBER;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM;

      OPEN AQPROPERTYSEQUENCENUMBER FOR LSSQLNULL USING LNPROPERTYSEQUENCENUMBER;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF (ANUOMID = 0)
      THEN
        LNUOMID := NULL;
      ELSE
        LNUOMID := ANUOMID;
      END IF;  
      

      LNRETVAL :=
         IAPISPECIFICATIONPROPERTYGROUP.EXTENDPROPERTY( ASPARTNO,
                                                        ANREVISION,
                                                        ANSECTIONID,
                                                        ANSUBSECTIONID,
                                                        ANPROPERTYGROUPID,
                                                        ANPROPERTYID,
                                                        ANATTRIBUTEID,
						        
                                                        
                                                        LNUOMID,
							
                                                        ANASSOCIATIONID1,
                                                        ANASSOCIATIONID2,
                                                        ANASSOCIATIONID3,
                                                        ANDISPLAYFORMATID,
                                                        AFHANDLE,
                                                        LNPROPERTYSEQUENCENUMBER,
                                                        AQINFO,
                                                        AQERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF ( AQPROPERTYSEQUENCENUMBER%ISOPEN )
      THEN
         CLOSE AQPROPERTYSEQUENCENUMBER;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM;

      OPEN AQPROPERTYSEQUENCENUMBER FOR LSSQLNULL USING LNPROPERTYSEQUENCENUMBER;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXTENDPROPERTYPB;

   
   FUNCTION SAVEADDPROPERTY(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPID          IN       IAPITYPE.ID_TYPE,
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE,
      ANHEADERID                 IN       IAPITYPE.ID_TYPE,
      ASVALUE                    IN       IAPITYPE.INFO_TYPE,
      ANALTERNATIVELANGUAGEID    IN       IAPITYPE.LANGUAGEID_TYPE DEFAULT NULL,
      
      
      
      AQINFO                     IN OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   IN OUT      IAPITYPE.REF_TYPE )
      
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LNLAYOUTID                    IAPITYPE.ID_TYPE;
      LNLAYOUTIDREVISION            IAPITYPE.REVISION_TYPE;
      LNTYPE                        NUMBER;
      LNITEMID                      IAPITYPE.ID_TYPE;
      LNFIELD                       NUMBER;
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveAddProperty';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       NUMBER;
      LSERRORMESSAGE                VARCHAR2( 250 );
      LNTESTMETHODID                IAPITYPE.ID_TYPE;
      LNTESTMETHODSETNO             IAPITYPE.TESTMETHODSETNO_TYPE;
      LFNUMERIC1                    IAPITYPE.FLOAT_TYPE;
      LFNUMERIC2                    IAPITYPE.FLOAT_TYPE;
      LFNUMERIC3                    IAPITYPE.FLOAT_TYPE;
      LFNUMERIC4                    IAPITYPE.FLOAT_TYPE;
      LFNUMERIC5                    IAPITYPE.FLOAT_TYPE;
      LFNUMERIC6                    IAPITYPE.FLOAT_TYPE;
      LFNUMERIC7                    IAPITYPE.FLOAT_TYPE;
      LFNUMERIC8                    IAPITYPE.FLOAT_TYPE;
      LFNUMERIC9                    IAPITYPE.FLOAT_TYPE;
      LFNUMERIC10                   IAPITYPE.FLOAT_TYPE;
      LSSTRING1                     IAPITYPE.PROPERTYSHORTSTRING_TYPE;
      LSSTRING2                     IAPITYPE.PROPERTYSHORTSTRING_TYPE;
      LSSTRING3                     IAPITYPE.PROPERTYSHORTSTRING_TYPE;
      LSSTRING4                     IAPITYPE.PROPERTYSHORTSTRING_TYPE;
      LSSTRING5                     IAPITYPE.PROPERTYSHORTSTRING_TYPE;
      LSSTRING6                     IAPITYPE.PROPERTYLONGSTRING_TYPE;
      LSINFO                        IAPITYPE.INFO_TYPE;
      LNBOOLEAN1                    IAPITYPE.BOOLEAN_TYPE;
      LNBOOLEAN2                    IAPITYPE.BOOLEAN_TYPE;
      LNBOOLEAN3                    IAPITYPE.BOOLEAN_TYPE;
      LNBOOLEAN4                    IAPITYPE.BOOLEAN_TYPE;
      LDDATE1                       IAPITYPE.DATE_TYPE;
      LDDATE2                       IAPITYPE.DATE_TYPE;
      LNCHARACTERISTICID1           IAPITYPE.ID_TYPE;
      LNCHARACTERISTICID2           IAPITYPE.ID_TYPE;
      LNCHARACTERISTICID3           IAPITYPE.ID_TYPE;
      LNTESTMETHODDETAILS1          IAPITYPE.BOOLEAN_TYPE;
      LNTESTMETHODDETAILS2          IAPITYPE.BOOLEAN_TYPE;
      LNTESTMETHODDETAILS3          IAPITYPE.BOOLEAN_TYPE;
      LNTESTMETHODDETAILS4          IAPITYPE.BOOLEAN_TYPE;
      LNALTERNATIVELANGUAGEID       IAPITYPE.LANGUAGEID_TYPE;
      LSALTERNATIVESTRING1          IAPITYPE.PROPERTYSHORTSTRING_TYPE;
      LSALTERNATIVESTRING2          IAPITYPE.PROPERTYSHORTSTRING_TYPE;
      LSALTERNATIVESTRING3          IAPITYPE.PROPERTYSHORTSTRING_TYPE;
      LSALTERNATIVESTRING4          IAPITYPE.PROPERTYSHORTSTRING_TYPE;
      LSALTERNATIVESTRING5          IAPITYPE.PROPERTYSHORTSTRING_TYPE;
      LSALTERNATIVESTRING6          IAPITYPE.PROPERTYLONGSTRING_TYPE;
      LSALTERNATIVEINFO             IAPITYPE.INFO_TYPE;
      LQERRORS                      IAPITYPE.REF_TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LRINFO1                       IAPITYPE.INFOREC_TYPE;
      LTINFO                        IAPITYPE.INFOTAB_TYPE;
      LSSQLINFO                     IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQINFO%ISOPEN )
      THEN
         CLOSE AQINFO;
      END IF;

      
      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;

      IAPISPECIFICATIONPROPERTYGROUP.GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      

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
      IAPISPECIFICATIONPROPERTYGROUP.GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );

      
      IF NVL( ANPROPERTYGROUPID,
              0 ) <> 0
      THEN
      
         
         SELECT COUNT( * )
           INTO LNCOUNT
           
           
          FROM SPECIFICATION_SECTION
          
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            
            
            AND REF_ID = ANPROPERTYGROUPID;
            

         IF LNCOUNT = 0
         THEN
            LNRETVAL :=
               IAPISPECIFICATIONPROPERTYGROUP.ADDPROPERTYGROUP( ASPARTNO,
                                                                ANREVISION,
                                                                ANSECTIONID,
                                                                ANSUBSECTIONID,
                                                                ANPROPERTYGROUPID,
                                                                AQINFO => AQINFO,
                                                                AQERRORS => AQERRORS );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
               THEN
                  
                  LNRETVAL := IAPIGENERAL.ERRORLISTCONTAINSERRORS( GTERRORS );

                  IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
                  THEN
                     RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
                  END IF;
               ELSE
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        IAPIGENERAL.GETLASTERRORTEXT( ) );
                  RETURN( LNRETVAL );
               END IF;
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
      
      END IF;
      

      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM SPECIFICATION_PROP
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND SECTION_ID = ANSECTIONID
         AND SUB_SECTION_ID = ANSUBSECTIONID
         AND PROPERTY_GROUP = ANPROPERTYGROUPID
         AND PROPERTY = ANPROPERTYID
         AND ATTRIBUTE = ANATTRIBUTEID;

      IF LNCOUNT = 0
      THEN
         LNRETVAL :=
            IAPISPECIFICATIONPROPERTYGROUP.ADDPROPERTY( ASPARTNO,
                                                        ANREVISION,
                                                        ANSECTIONID,
                                                        ANSUBSECTIONID,
                                                        ANPROPERTYGROUPID,
                                                        ANPROPERTYID,
                                                        ANATTRIBUTEID,
                                                        NULL,
                                                        AQINFO,
                                                        AQERRORS => AQERRORS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
            THEN
               
               LNRETVAL := IAPIGENERAL.ERRORLISTCONTAINSERRORS( GTERRORS );

               IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
               THEN
                  RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
               END IF;
            ELSE
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
               RETURN( LNRETVAL );
            END IF;
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

      SELECT TEST_METHOD,
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
             INFO,
             DECODE( BOOLEAN_1,
                     'Y', 1,
                     0 ),
             DECODE( BOOLEAN_2,
                     'Y', 1,
                     0 ),
             DECODE( BOOLEAN_3,
                     'Y', 1,
                     0 ),
             DECODE( BOOLEAN_4,
                     'Y', 1,
                     0 ),
             DATE_1,
             DATE_2,
             CHARACTERISTIC,
             CH_2,
             CH_3,
             DECODE( TM_DET_1,
                     'Y', 1,
                     'N', 0,
                     TM_DET_1 ),
             DECODE( TM_DET_2,
                     'Y', 1,
                     'N', 0,
                     TM_DET_2 ),
             DECODE( TM_DET_3,
                     'Y', 1,
                     'N', 0,
                     TM_DET_3 ),
             DECODE( TM_DET_4,
                     'Y', 1,
                     'N', 0,
                     TM_DET_4 ),
             TM_SET_NO
        INTO LNTESTMETHODID,
             LFNUMERIC1,
             LFNUMERIC2,
             LFNUMERIC3,
             LFNUMERIC4,
             LFNUMERIC5,
             LFNUMERIC6,
             LFNUMERIC7,
             LFNUMERIC8,
             LFNUMERIC9,
             LFNUMERIC10,
             LSSTRING1,
             LSSTRING2,
             LSSTRING3,
             LSSTRING4,
             LSSTRING5,
             LSSTRING6,
             LSINFO,
             LNBOOLEAN1,
             LNBOOLEAN2,
             LNBOOLEAN3,
             LNBOOLEAN4,
             LDDATE1,
             LDDATE2,
             LNCHARACTERISTICID1,
             LNCHARACTERISTICID2,
             LNCHARACTERISTICID3,
             LNTESTMETHODDETAILS1,
             LNTESTMETHODDETAILS2,
             LNTESTMETHODDETAILS3,
             LNTESTMETHODDETAILS4,
             LNTESTMETHODSETNO
        FROM SPECIFICATION_PROP
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND SECTION_ID = ANSECTIONID
         AND SUB_SECTION_ID = ANSUBSECTIONID
         AND PROPERTY_GROUP = ANPROPERTYGROUPID
         AND PROPERTY = ANPROPERTYID
         AND ATTRIBUTE = ANATTRIBUTEID;

      IF ANALTERNATIVELANGUAGEID > 1
      THEN
         BEGIN
            SELECT CHAR_1,
                   CHAR_2,
                   CHAR_3,
                   CHAR_4,
                   CHAR_5,
                   CHAR_6,
                   INFO
              INTO LSALTERNATIVESTRING1,
                   LSALTERNATIVESTRING2,
                   LSALTERNATIVESTRING3,
                   LSALTERNATIVESTRING4,
                   LSALTERNATIVESTRING5,
                   LSALTERNATIVESTRING6,
                   LSALTERNATIVEINFO
              FROM SPECIFICATION_PROP_LANG
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND SECTION_ID = ANSECTIONID
               AND SUB_SECTION_ID = ANSUBSECTIONID
               AND PROPERTY_GROUP = ANPROPERTYGROUPID
               AND PROPERTY = ANPROPERTYID
               
               
               AND ATTRIBUTE = ANATTRIBUTEID
               AND LANG_ID = ANALTERNATIVELANGUAGEID;               
               
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;   
         END;
      END IF;

      
      
      
      IF ANPROPERTYGROUPID = 0
      THEN
         LNTYPE := IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY;
         LNITEMID := ANPROPERTYID;
      ELSE
         LNTYPE := IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP;
         LNITEMID := ANPROPERTYGROUPID;
      END IF;

      
      BEGIN
         SELECT DISPLAY_FORMAT,
                DISPLAY_FORMAT_REV
           INTO LNLAYOUTID,
                LNLAYOUTIDREVISION
           FROM SPECIFICATION_SECTION
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND TYPE = LNTYPE
            AND REF_ID = LNITEMID;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_SPPROPERTYNOTFOUND,
                                                        ASPARTNO,
                                                        ANREVISION,
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSECTIONID, 0),
                                                        F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSUBSECTIONID, 0),                                            
                                                        F_PGH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANPROPERTYGROUPID, 0),                                            
                                                        F_SPH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANPROPERTYID, 0),                                            
                                                        F_ATH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANATTRIBUTEID, 0)));
                                                        
      END;

      BEGIN
         SELECT DISTINCT FIELD_ID FIELD_ID
                    INTO LNFIELD
                    FROM PROPERTY_LAYOUT
                   WHERE LAYOUT_ID = LNLAYOUTID
                     AND REVISION = LNLAYOUTIDREVISION
                     AND HEADER_ID = ANHEADERID;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_HEADERNOTFOUND,
                                                        ANHEADERID ) );
      END;

      IF LNFIELD IN( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 )
      THEN
         LNRETVAL := IAPIGENERAL.ISNUMERIC( ASVALUE );

         IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        LNRETVAL,
                                                        ASVALUE ) );
         END IF;

         CASE LNFIELD
            WHEN 1
            THEN
               LFNUMERIC1 := TO_NUMBER( ASVALUE );
            WHEN 2
            THEN
               LFNUMERIC2 := TO_NUMBER( ASVALUE );
            WHEN 3
            THEN
               LFNUMERIC3 := TO_NUMBER( ASVALUE );
            WHEN 4
            THEN
               LFNUMERIC4 := TO_NUMBER( ASVALUE );
            WHEN 5
            THEN
               LFNUMERIC5 := TO_NUMBER( ASVALUE );
            WHEN 6
            THEN
               LFNUMERIC6 := TO_NUMBER( ASVALUE );
            WHEN 7
            THEN
               LFNUMERIC7 := TO_NUMBER( ASVALUE );
            WHEN 8
            THEN
               LFNUMERIC8 := TO_NUMBER( ASVALUE );
            WHEN 9
            THEN
               LFNUMERIC9 := TO_NUMBER( ASVALUE );
            WHEN 10
            THEN
               LFNUMERIC10 := TO_NUMBER( ASVALUE );
         END CASE;
      ELSIF LNFIELD IN( 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 26, 30, 31 )
      THEN
         IF ASVALUE IS NOT NULL
         THEN
            IF LNFIELD IN( 16 )
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( ASVALUE,
                                                      256 );
            ELSIF LNFIELD IN( 17, 18, 19, 20 )
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( ASVALUE,
                                                      1 );
            
            ELSIF LNFIELD IN( 26, 30, 31 )
            THEN
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( ASVALUE,
                                                      60 );
            
            ELSE
               LNRETVAL := IAPIGENERAL.ISVALIDSTRING( ASVALUE,
                                                      40 );
            END IF;

            IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           LNRETVAL,
                                                           ASVALUE ) );
            END IF;
         END IF;

         CASE LNFIELD
            WHEN 11
            THEN
               IF ANALTERNATIVELANGUAGEID > 1
               THEN
                  LSALTERNATIVESTRING1 := ASVALUE;
               ELSE
                  LSSTRING1 := ASVALUE;
               END IF;
            WHEN 12
            THEN
               IF ANALTERNATIVELANGUAGEID > 1
               THEN
                  LSALTERNATIVESTRING2 := ASVALUE;
               ELSE
                  LSSTRING2 := ASVALUE;
               END IF;
            WHEN 13
            THEN
               IF ANALTERNATIVELANGUAGEID > 1
               THEN
                  LSALTERNATIVESTRING3 := ASVALUE;
               ELSE
                  LSSTRING3 := ASVALUE;
               END IF;
            WHEN 14
            THEN
               IF ANALTERNATIVELANGUAGEID > 1
               THEN
                  LSALTERNATIVESTRING4 := ASVALUE;
               ELSE
                  LSSTRING4 := ASVALUE;
               END IF;
            WHEN 15
            THEN
               IF ANALTERNATIVELANGUAGEID > 1
               THEN
                  LSALTERNATIVESTRING5 := ASVALUE;
               ELSE
                  LSSTRING5 := ASVALUE;
               END IF;
            WHEN 16
            THEN
               IF ANALTERNATIVELANGUAGEID > 1
               THEN
                  LSALTERNATIVESTRING6 := ASVALUE;
               ELSE
                  LSSTRING6 := ASVALUE;
               END IF;
            WHEN 17
            THEN
               IF ASVALUE IN( '1', 'Y' )
               THEN
                  LNBOOLEAN1 := 1;
               ELSE
                  LNBOOLEAN1 := 0;
               END IF;
            WHEN 18
            THEN
               IF ASVALUE IN( '1', 'Y' )
               THEN
                  LNBOOLEAN2 := 1;
               ELSE
                  LNBOOLEAN2 := 0;
               END IF;
            WHEN 19
            THEN
               IF ASVALUE IN( '1', 'Y' )
               THEN
                  LNBOOLEAN3 := 1;
               ELSE
                  LNBOOLEAN3 := 0;
               END IF;
            WHEN 20
            THEN
               IF ASVALUE IN( '1', 'Y' )
               THEN
                  LNBOOLEAN4 := 1;
               ELSE
                  LNBOOLEAN4 := 0;
               END IF;
            WHEN 26
            THEN
               LNRETVAL := IAPIMIGRATEDATA.GETCHARACTERISTICID( ASVALUE,
                                                                LNCHARACTERISTICID1 );

               IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        IAPIGENERAL.GETLASTERRORTEXT( ) );
                  RETURN( LNRETVAL );
               END IF;

               IF NOT( LNCHARACTERISTICID1 > 0 )
               THEN
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_CHARACTERISTICNOTFOUND,
                                                              ASVALUE ) );
               END IF;
            WHEN 30
            THEN
               LNRETVAL := IAPIMIGRATEDATA.GETCHARACTERISTICID( ASVALUE,
                                                                LNCHARACTERISTICID2 );

               IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        IAPIGENERAL.GETLASTERRORTEXT( ) );
                  RETURN( LNRETVAL );
               END IF;

               IF NOT( LNCHARACTERISTICID2 > 0 )
               THEN
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_CHARACTERISTICNOTFOUND,
                                                              ASVALUE ) );
               END IF;
            WHEN 31
            THEN
               LNRETVAL := IAPIMIGRATEDATA.GETCHARACTERISTICID( ASVALUE,
                                                                LNCHARACTERISTICID3 );

               IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        IAPIGENERAL.GETLASTERRORTEXT( ) );
                  RETURN( LNRETVAL );
               END IF;

               IF NOT( LNCHARACTERISTICID3 > 0 )
               THEN
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_CHARACTERISTICNOTFOUND,
                                                              ASVALUE ) );
               END IF;
         END CASE;
      ELSIF LNFIELD IN( 21, 22 )
      THEN
         IF ASVALUE IS NOT NULL
         THEN
            LNRETVAL := IAPIGENERAL.ISDATE( ASVALUE,
                                            'dd/mon/yyyy hh24:mi:ss' );

            IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           LNRETVAL,
                                                           ASVALUE ) );
            END IF;
         END IF;

         IF LNFIELD = 21
         THEN
            LDDATE1 := TO_DATE( ASVALUE,
                                'dd/mon/yyyy hh24:mi:ss' );
         ELSIF LNFIELD = 22
         THEN
            LDDATE2 := TO_DATE( ASVALUE,
                                'dd/mon/yyyy hh24:mi:ss' );
         END IF;
      ELSIF LNFIELD IN( 32, 33, 34, 35 )
      THEN
         CASE LNFIELD
            WHEN 32
            THEN
               IF ASVALUE IN( '1', 'Y' )
               THEN
                  LNTESTMETHODDETAILS1 := 1;
               ELSE
                  LNTESTMETHODDETAILS1 := 0;
               END IF;
            WHEN 33
            THEN
               IF ASVALUE IN( '1', 'Y' )
               THEN
                  LNTESTMETHODDETAILS2 := 1;
               ELSE
                  LNTESTMETHODDETAILS2 := 0;
               END IF;
            WHEN 34
            THEN
               IF ASVALUE IN( '1', 'Y' )
               THEN
                  LNTESTMETHODDETAILS3 := 1;
               ELSE
                  LNTESTMETHODDETAILS3 := 0;
               END IF;
            WHEN 35
            THEN
               IF ASVALUE IN( '1', 'Y' )
               THEN
                  LNTESTMETHODDETAILS4 := 1;
               ELSE
                  LNTESTMETHODDETAILS4 := 0;
               END IF;
         END CASE;
      ELSIF LNFIELD IN( 25 )   
      THEN
         
         
         BEGIN
             SELECT TEST_METHOD
             INTO LNTESTMETHODID  
             FROM TEST_METHOD_H
                 WHERE DESCRIPTION = ASVALUE
                 AND LANG_ID = NVL(ANALTERNATIVELANGUAGEID, 1) 
                 AND MAX_REV = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                
                IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               'Method: ' || ASVALUE || ' cannot be found!' );
                               
                RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_GENFAIL) );                               
         END;                
         
      ELSIF LNFIELD IN( 40 )   
      THEN
         IF ANALTERNATIVELANGUAGEID > 1
         THEN
            LSALTERNATIVEINFO := ASVALUE;
         ELSE
            LSINFO := ASVALUE;
         END IF;
      END IF;

      IF ANALTERNATIVELANGUAGEID = 1
      THEN
         LNALTERNATIVELANGUAGEID := NULL;
      ELSE
         LNALTERNATIVELANGUAGEID := ANALTERNATIVELANGUAGEID;
      END IF;

      IAPISPECIFICATIONPROPERTYGROUP.GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( IAPISPECIFICATIONPROPERTYGROUP.GTERRORS,
                                                             LQERRORS );
      LNRETVAL :=
         IAPISPECIFICATIONPROPERTYGROUP.SAVEPROPERTY( ASPARTNO,
                                                      ANREVISION,
                                                      ANSECTIONID,
                                                      ANSUBSECTIONID,
                                                      ANPROPERTYGROUPID,
                                                      ANPROPERTYID,
                                                      ANATTRIBUTEID,
                                                      LNTESTMETHODID,
                                                      LNTESTMETHODSETNO,
                                                      LFNUMERIC1,
                                                      LFNUMERIC2,
                                                      LFNUMERIC3,
                                                      LFNUMERIC4,
                                                      LFNUMERIC5,
                                                      LFNUMERIC6,
                                                      LFNUMERIC7,
                                                      LFNUMERIC8,
                                                      LFNUMERIC9,
                                                      LFNUMERIC10,
                                                      LSSTRING1,
                                                      LSSTRING2,
                                                      LSSTRING3,
                                                      LSSTRING4,
                                                      LSSTRING5,
                                                      LSSTRING6,
                                                      LSINFO,
                                                      LNBOOLEAN1,
                                                      LNBOOLEAN2,
                                                      LNBOOLEAN3,
                                                      LNBOOLEAN4,
                                                      LDDATE1,
                                                      LDDATE2,
                                                      LNCHARACTERISTICID1,
                                                      LNCHARACTERISTICID2,
                                                      LNCHARACTERISTICID3,
                                                      LNTESTMETHODDETAILS1,
                                                      LNTESTMETHODDETAILS2,
                                                      LNTESTMETHODDETAILS3,
                                                      LNTESTMETHODDETAILS4,
                                                      LNALTERNATIVELANGUAGEID,
                                                      LSALTERNATIVESTRING1,
                                                      LSALTERNATIVESTRING2,
                                                      LSALTERNATIVESTRING3,
                                                      LSALTERNATIVESTRING4,
                                                      LSALTERNATIVESTRING5,
                                                      LSALTERNATIVESTRING6,
                                                      LSALTERNATIVEINFO,
                                                      NULL,
                                                      AQINFO,
                                                      AQERRORS => AQERRORS );

      
      
      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
         THEN
            
            LNRETVAL := IAPIGENERAL.ERRORLISTCONTAINSERRORS( IAPISPECIFICATIONPROPERTYGROUP.GTERRORS );

            IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
            END IF;
         ELSE
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
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
   END SAVEADDPROPERTY;

   
   FUNCTION ADDTESTMETHOD(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPID          IN       IAPITYPE.ID_TYPE,
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE,
      ANSEQUENCENO               IN       IAPITYPE.SEQUENCENR_TYPE,
      ANTESTMETHODTYPEID         IN       IAPITYPE.ID_TYPE,
      ANTESTMETHODID             IN       IAPITYPE.ID_TYPE,
      ANTESTMETHODREVISION       IN       IAPITYPE.REVISION_TYPE,
      ANTESTMETHODSETNO          IN       IAPITYPE.TESTMETHODSETNO_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      CURSOR LQTESTMETHODTYPE
      IS
         SELECT TM_TYPE
           FROM ITTMTYPE
          WHERE TM_TYPE = ANTESTMETHODTYPEID;

      CURSOR LQTESTMETHOD
      IS
         SELECT TEST_METHOD
           FROM TEST_METHOD
          WHERE TEST_METHOD = ANTESTMETHODID;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddTestMethod';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRTESTMETHOD                  IAPITYPE.SPTESTMETHODREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNTESTMETHODTYPEID            IAPITYPE.ID_TYPE;
      LNTESTMETHODID                IAPITYPE.ID_TYPE;
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
      GTTESTMETHODS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRTESTMETHOD.PARTNO := ASPARTNO;
      LRTESTMETHOD.REVISION := ANREVISION;
      LRTESTMETHOD.SECTIONID := ANSECTIONID;
      LRTESTMETHOD.SUBSECTIONID := ANSUBSECTIONID;
      LRTESTMETHOD.PROPERTYGROUPID := ANPROPERTYGROUPID;
      LRTESTMETHOD.PROPERTYID := ANPROPERTYID;
      LRTESTMETHOD.ATTRIBUTEID := ANATTRIBUTEID;
      LRTESTMETHOD.SEQUENCENO := ANSEQUENCENO;
      LRTESTMETHOD.TESTMETHODTYPEID := ANTESTMETHODTYPEID;
      LRTESTMETHOD.TESTMETHODID := ANTESTMETHODID;
      LRTESTMETHOD.TESTMETHODREVISION := ANTESTMETHODREVISION;
      LRTESTMETHOD.TESTMETHODSETNO := ANTESTMETHODSETNO;
      GTTESTMETHODS( 0 ) := LRTESTMETHOD;

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
      
      
      
      
      
      CHECKBASICTESTMETHODPARAMS( LRTESTMETHOD );

      
      IF ( LRTESTMETHOD.TESTMETHODTYPEID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'TestMethodType' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anTestMethodTypeId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( LRTESTMETHOD.TESTMETHODID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'TestMethod' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anTestMethodId',
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

      
      
      LNRETVAL :=
         IAPISPECIFICATIONPROPERTYGROUP.EXISTPROPERTYINGROUP( LRTESTMETHOD.PARTNO,
                                                              LRTESTMETHOD.REVISION,
                                                              LRTESTMETHOD.SECTIONID,
                                                              LRTESTMETHOD.SUBSECTIONID,
                                                              LRTESTMETHOD.PROPERTYGROUPID,
                                                              LRTESTMETHOD.PROPERTYID,
                                                              LRTESTMETHOD.ATTRIBUTEID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      OPEN LQTESTMETHODTYPE;

      FETCH LQTESTMETHODTYPE
       INTO LNTESTMETHODTYPEID;

      IF LQTESTMETHODTYPE%NOTFOUND
      THEN
         CLOSE LQTESTMETHODTYPE;

         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_TESTMETHODNOTFOUND,
                                                     ANTESTMETHODTYPEID ) );
      END IF;

      CLOSE LQTESTMETHODTYPE;

      
      OPEN LQTESTMETHOD;

      FETCH LQTESTMETHOD
       INTO LNTESTMETHODID;

      IF LQTESTMETHOD%NOTFOUND
      THEN
         CLOSE LQTESTMETHOD;

         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_TESTMETHODTYPENOTFOUND,
                                                     ANTESTMETHODID ) );
      END IF;

      CLOSE LQTESTMETHOD;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      INSERT INTO SPECIFICATION_TM
                  ( PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID,
                    PROPERTY_GROUP,
                    PROPERTY,
                    ATTRIBUTE,
                    SEQ_NO,
                    TM_TYPE,
                    TM,
                    TM_REV,
                    TM_SET_NO )
           VALUES ( LRTESTMETHOD.PARTNO,
                    LRTESTMETHOD.REVISION,
                    LRTESTMETHOD.SECTIONID,
                    LRTESTMETHOD.SUBSECTIONID,
                    LRTESTMETHOD.PROPERTYGROUPID,
                    LRTESTMETHOD.PROPERTYID,
                    LRTESTMETHOD.ATTRIBUTEID,
                    LRTESTMETHOD.SEQUENCENO,
                    LRTESTMETHOD.TESTMETHODTYPEID,
                    LRTESTMETHOD.TESTMETHODID,
                    LRTESTMETHOD.TESTMETHODREVISION,
                    LRTESTMETHOD.TESTMETHODSETNO );

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRTESTMETHOD.PARTNO,
                                                       LRTESTMETHOD.REVISION,
                                                       LRTESTMETHOD.SECTIONID,
                                                       LRTESTMETHOD.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRTESTMETHOD.PARTNO,
                                                LRTESTMETHOD.REVISION );

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
   END ADDTESTMETHOD;

   
   FUNCTION SAVETESTMETHOD(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPID          IN       IAPITYPE.ID_TYPE,
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE,
      ANSEQUENCENO               IN       IAPITYPE.SEQUENCENR_TYPE,
      ANTESTMETHODTYPEID         IN       IAPITYPE.ID_TYPE,
      ANTESTMETHODID             IN       IAPITYPE.ID_TYPE,
      ANTESTMETHODREVISION       IN       IAPITYPE.REVISION_TYPE,
      ANTESTMETHODSETNO          IN       IAPITYPE.TESTMETHODSETNO_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      CURSOR LQTESTMETHODTYPE
      IS
         SELECT TM_TYPE
           FROM ITTMTYPE
          WHERE TM_TYPE = ANTESTMETHODTYPEID;

      CURSOR LQTESTMETHOD
      IS
         SELECT TEST_METHOD
           FROM TEST_METHOD
          WHERE TEST_METHOD = ANTESTMETHODID;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveTestMethod';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRTESTMETHOD                  IAPITYPE.SPTESTMETHODREC_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNTESTMETHODTYPEID            IAPITYPE.ID_TYPE;
      LNTESTMETHODID                IAPITYPE.ID_TYPE;
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
      GTTESTMETHODS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRTESTMETHOD.PARTNO := ASPARTNO;
      LRTESTMETHOD.REVISION := ANREVISION;
      LRTESTMETHOD.SECTIONID := ANSECTIONID;
      LRTESTMETHOD.SUBSECTIONID := ANSUBSECTIONID;
      LRTESTMETHOD.PROPERTYGROUPID := ANPROPERTYGROUPID;
      LRTESTMETHOD.PROPERTYID := ANPROPERTYID;
      LRTESTMETHOD.ATTRIBUTEID := ANATTRIBUTEID;
      LRTESTMETHOD.SEQUENCENO := ANSEQUENCENO;
      LRTESTMETHOD.TESTMETHODTYPEID := ANTESTMETHODTYPEID;
      LRTESTMETHOD.TESTMETHODID := ANTESTMETHODID;
      LRTESTMETHOD.TESTMETHODREVISION := ANTESTMETHODREVISION;
      LRTESTMETHOD.TESTMETHODSETNO := ANTESTMETHODSETNO;
      GTTESTMETHODS( 0 ) := LRTESTMETHOD;

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
       
       
      
      
      
       
      CHECKBASICTESTMETHODPARAMS( LRTESTMETHOD );

      
      IF ( LRTESTMETHOD.TESTMETHODTYPEID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'TestMethodType' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anTestMethodTypeId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( LRTESTMETHOD.TESTMETHODID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'TestMethod' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anTestMethodId',
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

      
      
      LNRETVAL :=
         IAPISPECIFICATIONPROPERTYGROUP.EXISTPROPERTYINGROUP( LRTESTMETHOD.PARTNO,
                                                              LRTESTMETHOD.REVISION,
                                                              LRTESTMETHOD.SECTIONID,
                                                              LRTESTMETHOD.SUBSECTIONID,
                                                              LRTESTMETHOD.PROPERTYGROUPID,
                                                              LRTESTMETHOD.PROPERTYID,
                                                              LRTESTMETHOD.ATTRIBUTEID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      OPEN LQTESTMETHODTYPE;

      FETCH LQTESTMETHODTYPE
       INTO LNTESTMETHODTYPEID;

      IF LQTESTMETHODTYPE%NOTFOUND
      THEN
         CLOSE LQTESTMETHODTYPE;

         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_TESTMETHODNOTFOUND,
                                                     ANTESTMETHODTYPEID ) );
      END IF;

      CLOSE LQTESTMETHODTYPE;

      
      OPEN LQTESTMETHOD;

      FETCH LQTESTMETHOD
       INTO LNTESTMETHODID;

      IF LQTESTMETHOD%NOTFOUND
      THEN
         CLOSE LQTESTMETHOD;

         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_TESTMETHODTYPENOTFOUND,
                                                     ANTESTMETHODID ) );
      END IF;

      CLOSE LQTESTMETHOD;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      UPDATE SPECIFICATION_TM
         SET TM_TYPE = LRTESTMETHOD.TESTMETHODTYPEID,
             TM = LRTESTMETHOD.TESTMETHODID,
             TM_REV = LRTESTMETHOD.TESTMETHODREVISION,
             TM_SET_NO = LRTESTMETHOD.TESTMETHODSETNO
       WHERE PART_NO = LRTESTMETHOD.PARTNO
         AND REVISION = LRTESTMETHOD.REVISION
         AND SECTION_ID = LRTESTMETHOD.SECTIONID
         AND SUB_SECTION_ID = LRTESTMETHOD.SUBSECTIONID
         AND PROPERTY_GROUP = LRTESTMETHOD.PROPERTYGROUPID
         AND PROPERTY = LRTESTMETHOD.PROPERTYID
         AND ATTRIBUTE = LRTESTMETHOD.ATTRIBUTEID
         AND SEQ_NO = LRTESTMETHOD.SEQUENCENO;

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRTESTMETHOD.PARTNO,
                                                       LRTESTMETHOD.REVISION,
                                                       LRTESTMETHOD.SECTIONID,
                                                       LRTESTMETHOD.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRTESTMETHOD.PARTNO,
                                                LRTESTMETHOD.REVISION );

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
   END SAVETESTMETHOD;

   
   FUNCTION REMOVETESTMETHOD(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPID          IN       IAPITYPE.ID_TYPE,
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE,
      ANSEQUENCENO               IN       IAPITYPE.SEQUENCENR_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveTestMethod';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRTESTMETHOD                  IAPITYPE.SPTESTMETHODREC_TYPE;
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
      GTTESTMETHODS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LRTESTMETHOD.PARTNO := ASPARTNO;
      LRTESTMETHOD.REVISION := ANREVISION;
      LRTESTMETHOD.SECTIONID := ANSECTIONID;
      LRTESTMETHOD.SUBSECTIONID := ANSUBSECTIONID;
      LRTESTMETHOD.PROPERTYGROUPID := ANPROPERTYGROUPID;
      LRTESTMETHOD.PROPERTYID := ANPROPERTYID;
      LRTESTMETHOD.ATTRIBUTEID := ANATTRIBUTEID;
      LRTESTMETHOD.SEQUENCENO := ANSEQUENCENO;
      GTTESTMETHODS( 0 ) := LRTESTMETHOD;

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
       
       
      
      
      
      CHECKBASICTESTMETHODPARAMS( LRTESTMETHOD );

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

      
      
      LNRETVAL :=
         IAPISPECIFICATIONPROPERTYGROUP.EXISTPROPERTYINGROUP( LRTESTMETHOD.PARTNO,
                                                              LRTESTMETHOD.REVISION,
                                                              LRTESTMETHOD.SECTIONID,
                                                              LRTESTMETHOD.SUBSECTIONID,
                                                              LRTESTMETHOD.PROPERTYGROUPID,
                                                              LRTESTMETHOD.PROPERTYID,
                                                              LRTESTMETHOD.ATTRIBUTEID );

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

      DELETE FROM SPECIFICATION_TM
            WHERE PART_NO = LRTESTMETHOD.PARTNO
              AND REVISION = LRTESTMETHOD.REVISION
              AND SECTION_ID = LRTESTMETHOD.SECTIONID
              AND SUB_SECTION_ID = LRTESTMETHOD.SUBSECTIONID
              AND PROPERTY_GROUP = LRTESTMETHOD.PROPERTYGROUPID
              AND PROPERTY = LRTESTMETHOD.PROPERTYID
              AND ATTRIBUTE = LRTESTMETHOD.ATTRIBUTEID
              AND SEQ_NO = LRTESTMETHOD.SEQUENCENO;

      
      LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( LRTESTMETHOD.PARTNO,
                                                       LRTESTMETHOD.REVISION,
                                                       LRTESTMETHOD.SECTIONID,
                                                       LRTESTMETHOD.SUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := IAPISPECIFICATION.LOGCHANGES( LRTESTMETHOD.PARTNO,
                                                LRTESTMETHOD.REVISION );

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
   END REMOVETESTMETHOD;
END IAPISPECIFICATIONPROPERTYGROUP;
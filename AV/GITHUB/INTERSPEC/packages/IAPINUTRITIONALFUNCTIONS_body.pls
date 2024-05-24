CREATE OR REPLACE PACKAGE BODY iapiNutritionalFunctions
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

   
   
   

   
   
   
   
   
   
   

   
   FUNCTION GETNUTRIENT(
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ANROWID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTREVISION           IN       IAPITYPE.REVISION_TYPE,
      ANCOLID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.CLOB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'getNutrient';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      BEGIN
         SELECT    F_SPH_DESCR( 1,
                                PROPERTY,
                                PROPERTY_REV )
                || DECODE(  ( TRIM( F_ATH_DESCR( 1,
                                                 ATTRIBUTE,
                                                 ATTRIBUTE_REV ) ) ),
                           '-', NULL,
                              ' '
                           || ( F_ATH_DESCR( 1,
                                             ATTRIBUTE,
                                             ATTRIBUTE_REV ) ) )
           INTO ASOUTVAL
           FROM ITNUTEXPLOSION
          WHERE BOM_EXP_NO = ANUNIQUEID
            AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
            AND ROW_ID = ANROWID
            AND ROWNUM = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_NUTEXPNOTFOUND,
                                                  ANUNIQUEID,
                                                  ANMOPSEQUENCENO,
                                                  ANROWID );
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT );
            RETURN LNRETVAL;
      END;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETNUTRIENT;

   
   FUNCTION GETVALUE(
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ANROWID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTREVISION           IN       IAPITYPE.REVISION_TYPE,
      ANCOLID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANOUTVAL                   OUT      IAPITYPE.NUMVAL_TYPE,
      ANNUTPROPERTY              OUT      IAPITYPE.SEQUENCE_TYPE,
      ANNUTPROPERTYREV           OUT      IAPITYPE.REVISION_TYPE,
      ANNUTATTRIBUTE             OUT      IAPITYPE.SEQUENCE_TYPE,
      ANNUTATTRIBUTEREV          OUT      IAPITYPE.REVISION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetValue';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNNUTVALUE                    IAPITYPE.FLOAT_TYPE;
      LNNUTPROPERTY                 IAPITYPE.SEQUENCE_TYPE;
      LNNUTPROPERTYREV              IAPITYPE.REVISION_TYPE;
      LNNUTATTRIBUTE                IAPITYPE.SEQUENCE_TYPE;
      LNNUTATTRIBUTEREV             IAPITYPE.REVISION_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPINUTRITIONALCALCULATION.EXISTREFERENCESPECIFICATION( ASNUTREFTYPE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM ITNUTRESULTDETAIL
       WHERE BOM_EXP_NO = ANUNIQUEID
         AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
         AND COL_ID = ANROWID;

      IF LNCOUNT = 0
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_NUTLOGRESDETNOTEXIST,
                                               ANUNIQUEID,
                                               ANROWID,
                                               ANMOPSEQUENCENO );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      SELECT SUM( NUM_VAL ),
             MAX( PROPERTY ),
             MAX( PROPERTY_REV ),
             MAX( ATTRIBUTE ),
             MAX( ATTRIBUTE_REV )
        INTO LNNUTVALUE,
             LNNUTPROPERTY,
             LNNUTPROPERTYREV,
             LNNUTATTRIBUTE,
             LNNUTATTRIBUTEREV
        FROM ITNUTRESULTDETAIL
       WHERE BOM_EXP_NO = ANUNIQUEID
         AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
         AND COL_ID = ANROWID;

      ANOUTVAL := LNNUTVALUE;
      ANNUTPROPERTY := LNNUTPROPERTY;
      ANNUTPROPERTYREV := LNNUTPROPERTYREV;
      ANNUTATTRIBUTE := LNNUTATTRIBUTE;
      ANNUTATTRIBUTEREV := LNNUTATTRIBUTEREV;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETVALUE;


   
   FUNCTION GETVALUERV(
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      ANROWID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANCOLID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANLOGID                    IN       IAPITYPE.LOGID_TYPE,
      ANOUTVAL                   OUT      IAPITYPE.NUMVAL_TYPE,
      ANNUTPROPERTY              OUT      IAPITYPE.SEQUENCE_TYPE,
      ANNUTATTRIBUTE             OUT      IAPITYPE.SEQUENCE_TYPE)
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetValueRV';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNNUTVALUE                    IAPITYPE.FLOAT_TYPE;
      LNNUTPROPERTY                 IAPITYPE.SEQUENCE_TYPE;
      LNNUTATTRIBUTE                IAPITYPE.SEQUENCE_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
     
     LSLOGDECSEP                 IAPITYPE.DECIMALSEPERATOR_TYPE DEFAULT IAPIGENERAL.GETDBDECIMALSEPERATOR;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPINUTRITIONALCALCULATION.EXISTREFERENCESPECIFICATION( ASNUTREFTYPE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT COUNT( * )
        INTO LNCOUNT
      FROM ITNUTLOGRESULT
      WHERE LOG_ID = ANLOGID
        AND COL_ID = ANCOLID
        AND ROW_ID = ANROWID;

      IF LNCOUNT = 0
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_NUTLOGRESDETNOTEXIST,
                                               ANLOGID,
                                               ANCOLID,
                                               ANROWID );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

        
        SELECT DEC_SEP
        INTO LSLOGDECSEP
        FROM ITNUTLOG
        WHERE LOG_ID = ANLOGID;

      
      
      SELECT REPLACE (TO_CHAR(VALUE), LSLOGDECSEP, IAPIGENERAL.GETDBDECIMALSEPERATOR) VAL,
      
             PROPERTY,
             ATTRIBUTE
     INTO LNNUTVALUE,
          LNNUTPROPERTY,
          LNNUTATTRIBUTE
      FROM ITNUTLOGRESULT
      WHERE LOG_ID = ANLOGID
        AND COL_ID = ANCOLID
        AND ROW_ID = ANROWID;

      ANOUTVAL := LNNUTVALUE;
      ANNUTPROPERTY := LNNUTPROPERTY;
      ANNUTATTRIBUTE := LNNUTATTRIBUTE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETVALUERV;

   
   FUNCTION GETVALUEUNROUNDED(
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ANROWID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTREVISION           IN       IAPITYPE.REVISION_TYPE,
      ANCOLID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.CLOB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetValueUnRounded';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNNUTVALUE                    IAPITYPE.FLOAT_TYPE;
      LNNUTPROPERTY                 IAPITYPE.SEQUENCE_TYPE;
      LNNUTPROPERTYREV              IAPITYPE.REVISION_TYPE;
      LNNUTATTRIBUTE                IAPITYPE.SEQUENCE_TYPE;
      LNNUTATTRIBUTEREV             IAPITYPE.REVISION_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL :=
         GETVALUE( ASNUTREFTYPE,
                   ANUNIQUEID,
                   ANMOPSEQUENCENO,
                   ANROWID,
                   ANLAYOUTID,
                   ANLAYOUTREVISION,
                   ANCOLID,
                   LNNUTVALUE,
                   LNNUTPROPERTY,
                   LNNUTPROPERTYREV,
                   LNNUTATTRIBUTE,
                   LNNUTATTRIBUTEREV );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      ASOUTVAL := TO_CHAR( LNNUTVALUE );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETVALUEUNROUNDED;


   
   FUNCTION GETVALUEUNROUNDEDRV(
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      ANROWID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANCOLID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANLOGID                    IN       IAPITYPE.LOGID_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.CLOB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetValueUnRoundedRV';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNNUTVALUE                    IAPITYPE.FLOAT_TYPE;
      LNNUTPROPERTY                 IAPITYPE.SEQUENCE_TYPE;
      LNNUTATTRIBUTE                IAPITYPE.SEQUENCE_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL :=
         GETVALUERV( ASNUTREFTYPE,
                   ANROWID,
                   ANCOLID,
                   ANLOGID,
                   LNNUTVALUE,
                   LNNUTPROPERTY,
                   LNNUTATTRIBUTE);

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      ASOUTVAL := TO_CHAR( LNNUTVALUE );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETVALUEUNROUNDEDRV;

   
   FUNCTION GETVALUECALCULATED(
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ANROWID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTREVISION           IN       IAPITYPE.REVISION_TYPE,
      ANCOLID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.CLOB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'getValueCalculated';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNNUTVALUE                    IAPITYPE.FLOAT_TYPE;
      LNNUTPROPERTY                 IAPITYPE.SEQUENCE_TYPE;
      LNNUTPROPERTYREV              IAPITYPE.REVISION_TYPE;
      LNNUTATTRIBUTE                IAPITYPE.SEQUENCE_TYPE;
      LNNUTATTRIBUTEREV             IAPITYPE.REVISION_TYPE;
      LNCHARACTERISTICID            IAPITYPE.ID_TYPE;
      LSPROCEDURENAME               IAPITYPE.STRING_TYPE;
      LSROUNDNUTVALUE               IAPITYPE.STRING_TYPE;
      LSNUTROUNDING                 IAPITYPE.INFO_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL :=
         GETVALUE( ASNUTREFTYPE,
                   ANUNIQUEID,
                   ANMOPSEQUENCENO,
                   ANROWID,
                   ANLAYOUTID,
                   ANLAYOUTREVISION,
                   ANCOLID,
                   LNNUTVALUE,
                   LNNUTPROPERTY,
                   LNNUTPROPERTYREV,
                   LNNUTATTRIBUTE,
                   LNNUTATTRIBUTEREV );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      BEGIN
         SELECT DECODE( B.ROUND_VALUE_COL,
                        26, CHARACTERISTIC,
                        30, CH_2,
                        31, CH_3 )
           INTO LNCHARACTERISTICID
           FROM SPECIFICATION_PROP A,
                ITNUTREFTYPE B
          WHERE A.PART_NO = B.PART_NO
            AND A.REVISION = F_STATUS_REV( B.PART_NO,
                                           'd' )
            AND A.SECTION_ID = B.ROUND_SECTION_ID
            AND A.SUB_SECTION_ID = B.ROUND_SUB_SECTION_ID
            AND A.PROPERTY_GROUP = B.ROUND_PROPERTY_GROUP
            AND B.REF_TYPE = ASNUTREFTYPE
            AND PROPERTY = LNNUTPROPERTY
            AND ATTRIBUTE = LNNUTATTRIBUTE;
      EXCEPTION
         WHEN OTHERS
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_INVALIDROUNDRULESETTING,
                                                  ASNUTREFTYPE );
            
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT );
            RETURN LNRETVAL;
      END;

      IF NVL( LNCHARACTERISTICID,
              0 ) <> 0
      THEN
         BEGIN
            SELECT PROCEDURE_NAME
              INTO LSPROCEDURENAME
              FROM ITNUTROUNDING
             WHERE CHARACTERISTIC_ID = LNCHARACTERISTICID;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_NOROUNDFUNCTIONMAPPING,
                                                     LNCHARACTERISTICID );
               
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT );
               RETURN LNRETVAL;
         END;
      END IF;

      IF LSPROCEDURENAME IS NOT NULL
      THEN
         BEGIN
            LSNUTROUNDING :=    'BEGIN '
                             || ':lnRetVal := '
                             || LSPROCEDURENAME
                             || '('
                             || ':lnNutValue,'
                             || ':lsRoundNutValue);'
                             || ' end;';

            EXECUTE IMMEDIATE LSNUTROUNDING
                        USING OUT LNRETVAL,
                              LNNUTVALUE,
                              OUT LSROUNDNUTVALUE;

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
               RETURN( LNRETVAL );
            END IF;

            ASOUTVAL := LSROUNDNUTVALUE;
         EXCEPTION
            WHEN OTHERS
            THEN
               IF SQLCODE = -6550
               THEN
                  LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_ROUNDFUNCTIONNOTFOUND,
                                                        LSPROCEDURENAME );
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        IAPIGENERAL.GETLASTERRORTEXT );
                  RETURN LNRETVAL;
               ELSE
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        SQLERRM );
                  RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
               END IF;
         END;
      ELSE
         ASOUTVAL := TO_CHAR( LNNUTVALUE );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETVALUECALCULATED;


   
   FUNCTION GETVALUECALCULATEDRV(
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      ANROWID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANCOLID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANLOGID                    IN       IAPITYPE.LOGID_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.CLOB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'getValueCalculatedRV';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNNUTVALUE                    IAPITYPE.FLOAT_TYPE;
      LNNUTPROPERTY                 IAPITYPE.SEQUENCE_TYPE;
      LNNUTATTRIBUTE                IAPITYPE.SEQUENCE_TYPE;
      LNCHARACTERISTICID            IAPITYPE.ID_TYPE;
      LSPROCEDURENAME               IAPITYPE.STRING_TYPE;
      LSROUNDNUTVALUE               IAPITYPE.STRING_TYPE;
      LSNUTROUNDING                 IAPITYPE.INFO_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL :=
         GETVALUERV( ASNUTREFTYPE,
                   ANROWID,
                   ANCOLID,
                   ANLOGID,
                   LNNUTVALUE,
                   LNNUTPROPERTY,
                   LNNUTATTRIBUTE);

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      BEGIN
         SELECT DECODE( B.ROUND_VALUE_COL,
                        26, CHARACTERISTIC,
                        30, CH_2,
                        31, CH_3 )
           INTO LNCHARACTERISTICID
           FROM SPECIFICATION_PROP A,
                ITNUTREFTYPE B
          WHERE A.PART_NO = B.PART_NO
            AND A.REVISION = F_STATUS_REV( B.PART_NO,
                                           'd' )
            AND A.SECTION_ID = B.ROUND_SECTION_ID
            AND A.SUB_SECTION_ID = B.ROUND_SUB_SECTION_ID
            AND A.PROPERTY_GROUP = B.ROUND_PROPERTY_GROUP
            AND B.REF_TYPE = ASNUTREFTYPE
            AND PROPERTY = LNNUTPROPERTY
            AND ATTRIBUTE = LNNUTATTRIBUTE;
      EXCEPTION
         WHEN OTHERS
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_INVALIDROUNDRULESETTING,
                                                  ASNUTREFTYPE );
            
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT );
            RETURN LNRETVAL;
      END;

      IF NVL( LNCHARACTERISTICID,
              0 ) <> 0
      THEN
         BEGIN
            SELECT PROCEDURE_NAME
              INTO LSPROCEDURENAME
              FROM ITNUTROUNDING
             WHERE CHARACTERISTIC_ID = LNCHARACTERISTICID;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_NOROUNDFUNCTIONMAPPING,
                                                     LNCHARACTERISTICID );
               
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT );
               RETURN LNRETVAL;
         END;
      END IF;

      IF LSPROCEDURENAME IS NOT NULL
      THEN
         BEGIN
            LSNUTROUNDING :=    'BEGIN '
                             || ':lnRetVal := '
                             || LSPROCEDURENAME
                             || '('
                             || ':lnNutValue,'
                             || ':lsRoundNutValue);'
                             || ' end;';

            EXECUTE IMMEDIATE LSNUTROUNDING
                        USING OUT LNRETVAL,
                              LNNUTVALUE,
                              OUT LSROUNDNUTVALUE;

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
               RETURN( LNRETVAL );
            END IF;

            ASOUTVAL := LSROUNDNUTVALUE;
         EXCEPTION
            WHEN OTHERS
            THEN
               IF SQLCODE = -6550
               THEN
                  LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_ROUNDFUNCTIONNOTFOUND,
                                                        LSPROCEDURENAME );
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        IAPIGENERAL.GETLASTERRORTEXT );
                  RETURN LNRETVAL;
               ELSE
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        SQLERRM );
                  RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
               END IF;
         END;
      ELSE
         ASOUTVAL := TO_CHAR( LNNUTVALUE );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETVALUECALCULATEDRV;

   
   FUNCTION GETCOMMENTS(
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ANROWID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTREVISION           IN       IAPITYPE.REVISION_TYPE,
      ANCOLID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.CLOB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'getComments';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      
      
      
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
   END GETCOMMENTS;

   
   FUNCTION GETCONTRIBUTEDKJCALCULATED(
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ANROWID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTREVISION           IN       IAPITYPE.REVISION_TYPE,
      ANCOLID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.CLOB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'getContributedKjCalculated';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNNUTVALUE                    IAPITYPE.BOMQUANTITY_TYPE;
      LNNUTENERGYFACTORVALUE        IAPITYPE.FLOAT_TYPE;
      LNNUTPROPERTY                 IAPITYPE.SEQUENCE_TYPE;
      LNNUTPROPERTYREV              IAPITYPE.REVISION_TYPE;
      LNNUTATTRIBUTE                IAPITYPE.SEQUENCE_TYPE;
      LNNUTATTRIBUTEREV             IAPITYPE.REVISION_TYPE;
      LSSQLNUTENERGY                VARCHAR2( 1000 );
      LTNUTENERGYFACTOR             IAPITYPE.NUTENERGYFACTORTAB_TYPE;
      LRNUTREFTYPE                  IAPITYPE.NUTREFROWTYPE_TYPE;
      LFNUTENERGYKJ                 IAPITYPE.FLOAT_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPINUTRITIONALCALCULATION.EXISTREFERENCESPECIFICATION( ASNUTREFTYPE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      SELECT *
        INTO LRNUTREFTYPE
        FROM ITNUTREFTYPE
       WHERE REF_TYPE = ASNUTREFTYPE;

      SELECT TO_CHAR( SUM( NUM_VAL ) ),
             MAX( PROPERTY ),
             MAX( PROPERTY_REV ),
             MAX( ATTRIBUTE ),
             MAX( ATTRIBUTE_REV )
        INTO LNNUTVALUE,
             LNNUTPROPERTY,
             LNNUTPROPERTYREV,
             LNNUTATTRIBUTE,
             LNNUTATTRIBUTEREV
        FROM ITNUTRESULTDETAIL
       WHERE BOM_EXP_NO = ANUNIQUEID
         AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
         AND COL_ID = ANROWID;

      LSSQLNUTENERGY :=
            'SELECT '
         || 'a.PROPERTY '
         || ',a.PROPERTY_rev '
         || ',a.ATTRIBUTE '
         || ',a.ATTRIBUTE_rev '
         || ',NUM_'
         || LRNUTREFTYPE.ENERGY_KJ_COL
         || ' FROM specification_prop a '
         || ' WHERE a.PART_NO = :PART_NO '
         || ' AND a.REVISION = f_status_rev(:PART_NO,''d'') '
         || ' AND a.SECTION_ID= :ENERGY_SECTION_ID '
         || ' AND a.SUB_SECTION_ID = :ENERGY_SUB_SECTION_ID '
         || ' AND a.PROPERTY_GROUP = :ENERGY_PROPERTY_GROUP ';

      EXECUTE IMMEDIATE LSSQLNUTENERGY
      BULK COLLECT INTO LTNUTENERGYFACTOR
                  USING LRNUTREFTYPE.PART_NO,
                        LRNUTREFTYPE.PART_NO,
                        LRNUTREFTYPE.ENERGY_SECTION_ID,
                        LRNUTREFTYPE.ENERGY_SUB_SECTION_ID,
                        LRNUTREFTYPE.ENERGY_PROPERTY_GROUP;

      IF LTNUTENERGYFACTOR.COUNT > 0
      THEN
         FOR I IN LTNUTENERGYFACTOR.FIRST .. LTNUTENERGYFACTOR.LAST
         LOOP
            IF     LRNUTREFTYPE.ENERGY_KJ_PROPERTY = LNNUTPROPERTY
               AND LRNUTREFTYPE.ENERGY_KJ_ATTRIBUTE = LNNUTATTRIBUTE
            THEN
               SELECT NVL( SUM( NUM_VAL ),
                           0 )
                 INTO LNNUTENERGYFACTORVALUE
                 FROM ITNUTRESULTDETAIL
                WHERE BOM_EXP_NO = ANUNIQUEID
                  AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                  AND PROPERTY = LTNUTENERGYFACTOR( I ).PROPERTY
                  AND ATTRIBUTE = LTNUTENERGYFACTOR( I ).ATTRIBUTE;





               LFNUTENERGYKJ :=   NVL( LFNUTENERGYKJ,
                                       0 )
                                + (   LNNUTENERGYFACTORVALUE
                                    * NVL( LTNUTENERGYFACTOR( I ).VALUE,
                                           0 ) );
            ELSIF     LTNUTENERGYFACTOR( I ).PROPERTY = LNNUTPROPERTY
                  AND LTNUTENERGYFACTOR( I ).ATTRIBUTE = LNNUTATTRIBUTE




            THEN
               LFNUTENERGYKJ :=   LNNUTVALUE
                                * LTNUTENERGYFACTOR( I ).VALUE;
               EXIT;
            END IF;
         END LOOP;
      END IF;

      ASOUTVAL := TO_CHAR( LFNUTENERGYKJ );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETCONTRIBUTEDKJCALCULATED;


   
   FUNCTION GETCONTRIBUTEDKJCALCULATEDRV(
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      ANROWID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANCOLID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANLOGID                    IN       IAPITYPE.LOGID_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.CLOB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'getContributedKjCalculatedRV';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LFNUTVALUE                    IAPITYPE.FLOAT_TYPE;
      LNNUTENERGYFACTORVALUE        IAPITYPE.FLOAT_TYPE;
      LNNUTPROPERTY                 IAPITYPE.SEQUENCE_TYPE;
      LNNUTATTRIBUTE                IAPITYPE.SEQUENCE_TYPE;
      LSSQLNUTENERGY                VARCHAR2( 1000 );
      LTNUTENERGYFACTOR             IAPITYPE.NUTENERGYFACTORTAB_TYPE;
      LRNUTREFTYPE                  IAPITYPE.NUTREFROWTYPE_TYPE;
      LFNUTENERGYKJ                 IAPITYPE.FLOAT_TYPE;
      
      LSLOGDECSEP                  IAPITYPE.DECIMALSEPERATOR_TYPE DEFAULT IAPIGENERAL.GETDBDECIMALSEPERATOR;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPINUTRITIONALCALCULATION.EXISTREFERENCESPECIFICATION( ASNUTREFTYPE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      SELECT *
        INTO LRNUTREFTYPE
        FROM ITNUTREFTYPE
       WHERE REF_TYPE = ASNUTREFTYPE;

        
        SELECT DEC_SEP
        INTO LSLOGDECSEP
        FROM ITNUTLOG
        WHERE LOG_ID = ANLOGID;

      
      
      SELECT REPLACE (TO_CHAR(VALUE), LSLOGDECSEP, IAPIGENERAL.GETDBDECIMALSEPERATOR) VAL,
      
             PROPERTY,
             ATTRIBUTE
     INTO LFNUTENERGYKJ,
          LNNUTPROPERTY,
          LNNUTATTRIBUTE
      FROM ITNUTLOGRESULT
      WHERE LOG_ID = ANLOGID
        AND COL_ID = ANCOLID
        AND ROW_ID = ANROWID;

      IF (LRNUTREFTYPE.ENERGY_KJ_PROPERTY = LNNUTPROPERTY)
         AND (LRNUTREFTYPE.ENERGY_KJ_ATTRIBUTE = LNNUTATTRIBUTE)
      THEN
          
           ASOUTVAL := NULL;

          RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;

      LSSQLNUTENERGY :=
            'SELECT '
         || 'a.PROPERTY '
         || ',a.PROPERTY_rev '
         || ',a.ATTRIBUTE '
         || ',a.ATTRIBUTE_rev '
         || ',NUM_'
         || LRNUTREFTYPE.ENERGY_KJ_COL
         || ' FROM specification_prop a '
         || ' WHERE a.PART_NO = :PART_NO '
         || ' AND a.REVISION = f_status_rev(:PART_NO,''d'') '
         || ' AND a.SECTION_ID= :ENERGY_SECTION_ID '
         || ' AND a.SUB_SECTION_ID = :ENERGY_SUB_SECTION_ID '
         || ' AND a.PROPERTY_GROUP = :ENERGY_PROPERTY_GROUP ';

      EXECUTE IMMEDIATE LSSQLNUTENERGY
      BULK COLLECT INTO LTNUTENERGYFACTOR
                  USING LRNUTREFTYPE.PART_NO,
                        LRNUTREFTYPE.PART_NO,
                        LRNUTREFTYPE.ENERGY_SECTION_ID,
                        LRNUTREFTYPE.ENERGY_SUB_SECTION_ID,
                        LRNUTREFTYPE.ENERGY_PROPERTY_GROUP;

      IF LTNUTENERGYFACTOR.COUNT > 0
      THEN
         FOR I IN LTNUTENERGYFACTOR.FIRST .. LTNUTENERGYFACTOR.LAST
         LOOP
            IF LTNUTENERGYFACTOR( I ).PROPERTY = LNNUTPROPERTY
               AND LTNUTENERGYFACTOR( I ).ATTRIBUTE = LNNUTATTRIBUTE
            THEN
                 


               LFNUTVALUE := LFNUTENERGYKJ
                                / LTNUTENERGYFACTOR( I ).VALUE;

               EXIT;
            END IF;
         END LOOP;
      END IF;

      ASOUTVAL := TO_CHAR( LFNUTVALUE );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETCONTRIBUTEDKJCALCULATEDRV;

   
   FUNCTION GETCONTRIBUTEDKCALCALCULATED(
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ANROWID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTREVISION           IN       IAPITYPE.REVISION_TYPE,
      ANCOLID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.CLOB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'getContributedKCalCalculated';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNNUTVALUE                    IAPITYPE.BOMQUANTITY_TYPE;
      LNNUTENERGYFACTORVALUE        IAPITYPE.FLOAT_TYPE;
      LNNUTPROPERTY                 IAPITYPE.SEQUENCE_TYPE;
      LNNUTPROPERTYREV              IAPITYPE.REVISION_TYPE;
      LNNUTATTRIBUTE                IAPITYPE.SEQUENCE_TYPE;
      LNNUTATTRIBUTEREV             IAPITYPE.REVISION_TYPE;
      LSSQLNUTENERGY                VARCHAR2( 1000 );
      LTNUTENERGYFACTOR             IAPITYPE.NUTENERGYFACTORTAB_TYPE;
      LRNUTREFTYPE                  IAPITYPE.NUTREFROWTYPE_TYPE;
      LFNUTENERGYKCAL               IAPITYPE.FLOAT_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPINUTRITIONALCALCULATION.EXISTREFERENCESPECIFICATION( ASNUTREFTYPE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      SELECT *
        INTO LRNUTREFTYPE
        FROM ITNUTREFTYPE
       WHERE REF_TYPE = ASNUTREFTYPE;

      SELECT TO_CHAR( SUM( NUM_VAL ) ),
             MAX( PROPERTY ),
             MAX( PROPERTY_REV ),
             MAX( ATTRIBUTE ),
             MAX( ATTRIBUTE_REV )
        INTO LNNUTVALUE,
             LNNUTPROPERTY,
             LNNUTPROPERTYREV,
             LNNUTATTRIBUTE,
             LNNUTATTRIBUTEREV
        FROM ITNUTRESULTDETAIL
       WHERE BOM_EXP_NO = ANUNIQUEID
         AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
         AND COL_ID = ANROWID;

      LSSQLNUTENERGY :=
            'SELECT '
         || 'a.PROPERTY '
         || ',a.PROPERTY_rev '
         || ',a.ATTRIBUTE '
         || ',a.ATTRIBUTE_rev '
         || ',NUM_'
         || LRNUTREFTYPE.ENERGY_KCAL_COL
         || ' FROM specification_prop a '
         || ' WHERE a.PART_NO = :PART_NO '
         || ' AND a.REVISION = f_status_rev(:PART_NO,''d'') '
         || ' AND a.SECTION_ID= :ENERGY_SECTION_ID '
         || ' AND a.SUB_SECTION_ID = :ENERGY_SUB_SECTION_ID '
         || ' AND a.PROPERTY_GROUP = :ENERGY_PROPERTY_GROUP ';

      EXECUTE IMMEDIATE LSSQLNUTENERGY
      BULK COLLECT INTO LTNUTENERGYFACTOR
                  USING LRNUTREFTYPE.PART_NO,
                        LRNUTREFTYPE.PART_NO,
                        LRNUTREFTYPE.ENERGY_SECTION_ID,
                        LRNUTREFTYPE.ENERGY_SUB_SECTION_ID,
                        LRNUTREFTYPE.ENERGY_PROPERTY_GROUP;

      IF LTNUTENERGYFACTOR.COUNT > 0
      THEN
         FOR I IN LTNUTENERGYFACTOR.FIRST .. LTNUTENERGYFACTOR.LAST
         LOOP
            NULL;

            IF     LRNUTREFTYPE.ENERGY_KCAL_PROPERTY = LNNUTPROPERTY
               AND LRNUTREFTYPE.ENERGY_KCAL_ATTRIBUTE = LNNUTATTRIBUTE
            THEN
               SELECT NVL( SUM( NUM_VAL ),
                           0 )
                 INTO LNNUTENERGYFACTORVALUE
                 FROM ITNUTRESULTDETAIL
                WHERE BOM_EXP_NO = ANUNIQUEID
                  AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                  AND PROPERTY = LTNUTENERGYFACTOR( I ).PROPERTY
                  AND ATTRIBUTE = LTNUTENERGYFACTOR( I ).ATTRIBUTE;





               LFNUTENERGYKCAL :=   NVL( LFNUTENERGYKCAL,
                                         0 )
                                  + (   LNNUTENERGYFACTORVALUE
                                      * NVL( LTNUTENERGYFACTOR( I ).VALUE,
                                             0 ) );
            ELSIF     LTNUTENERGYFACTOR( I ).PROPERTY = LNNUTPROPERTY
                  AND LTNUTENERGYFACTOR( I ).ATTRIBUTE = LNNUTATTRIBUTE




            THEN
               LFNUTENERGYKCAL :=   LNNUTVALUE
                                  * LTNUTENERGYFACTOR( I ).VALUE;
               EXIT;
            END IF;
         END LOOP;
      END IF;

      ASOUTVAL := TO_CHAR( LFNUTENERGYKCAL );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETCONTRIBUTEDKCALCALCULATED;


   FUNCTION GETCONTRIBUTEDKCALCALCULATEDRV(
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      
      
      ANROWID                    IN       IAPITYPE.SEQUENCE_TYPE,
      
      
      ANCOLID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANLOGID                    IN       IAPITYPE.LOGID_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.CLOB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'getContributedKCalCalculatedRV';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LFNUTVALUE                    IAPITYPE.FLOAT_TYPE;
      LNNUTENERGYFACTORVALUE        IAPITYPE.FLOAT_TYPE;
      LNNUTPROPERTY                 IAPITYPE.SEQUENCE_TYPE;
      
      LNNUTATTRIBUTE                IAPITYPE.SEQUENCE_TYPE;
      
      LSSQLNUTENERGY                VARCHAR2( 1000 );
      LTNUTENERGYFACTOR             IAPITYPE.NUTENERGYFACTORTAB_TYPE;
      LRNUTREFTYPE                  IAPITYPE.NUTREFROWTYPE_TYPE;
      LFNUTENERGYKCAL               IAPITYPE.FLOAT_TYPE;
      
      LSLOGDECSEP                   IAPITYPE.DECIMALSEPERATOR_TYPE DEFAULT IAPIGENERAL.GETDBDECIMALSEPERATOR;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPINUTRITIONALCALCULATION.EXISTREFERENCESPECIFICATION( ASNUTREFTYPE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      SELECT *
        INTO LRNUTREFTYPE
        FROM ITNUTREFTYPE
       WHERE REF_TYPE = ASNUTREFTYPE;
















        
        SELECT DEC_SEP
        INTO LSLOGDECSEP
        FROM ITNUTLOG
        WHERE LOG_ID = ANLOGID;

      SELECT
         
         
         REPLACE (TO_CHAR(VALUE), LSLOGDECSEP, IAPIGENERAL.GETDBDECIMALSEPERATOR) VAL,
         
         PROPERTY,
         
         ATTRIBUTE
         
     INTO LFNUTENERGYKCAL,
          LNNUTPROPERTY,
          
          LNNUTATTRIBUTE
          
      FROM ITNUTLOGRESULT
      WHERE LOG_ID = ANLOGID
        AND COL_ID = ANCOLID
        AND ROW_ID = ANROWID;


      IF (LRNUTREFTYPE.ENERGY_KCAL_PROPERTY = LNNUTPROPERTY)
         AND (LRNUTREFTYPE.ENERGY_KCAL_ATTRIBUTE = LNNUTATTRIBUTE)
      THEN
          
           ASOUTVAL := NULL;

          RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;

      LSSQLNUTENERGY :=
            'SELECT '
         || 'a.PROPERTY '
         || ',a.PROPERTY_rev '
         || ',a.ATTRIBUTE '
         || ',a.ATTRIBUTE_rev '
         || ',NUM_'
         || LRNUTREFTYPE.ENERGY_KCAL_COL
         || ' FROM specification_prop a '
         || ' WHERE a.PART_NO = :PART_NO '
         || ' AND a.REVISION = f_status_rev(:PART_NO,''d'') '
         || ' AND a.SECTION_ID= :ENERGY_SECTION_ID '
         || ' AND a.SUB_SECTION_ID = :ENERGY_SUB_SECTION_ID '
         || ' AND a.PROPERTY_GROUP = :ENERGY_PROPERTY_GROUP ';

      EXECUTE IMMEDIATE LSSQLNUTENERGY
      BULK COLLECT INTO LTNUTENERGYFACTOR
                  USING LRNUTREFTYPE.PART_NO,
                        LRNUTREFTYPE.PART_NO,
                        LRNUTREFTYPE.ENERGY_SECTION_ID,
                        LRNUTREFTYPE.ENERGY_SUB_SECTION_ID,
                        LRNUTREFTYPE.ENERGY_PROPERTY_GROUP;

      IF LTNUTENERGYFACTOR.COUNT > 0
      THEN
         FOR I IN LTNUTENERGYFACTOR.FIRST .. LTNUTENERGYFACTOR.LAST
         LOOP
            NULL;

            
























            IF LTNUTENERGYFACTOR( I ).PROPERTY = LNNUTPROPERTY
               AND LTNUTENERGYFACTOR( I ).ATTRIBUTE = LNNUTATTRIBUTE




            THEN
                   


                   LFNUTVALUE :=   LFNUTENERGYKCAL
                                      / LTNUTENERGYFACTOR( I ).VALUE;
                   EXIT;
            END IF;
         END LOOP;
      END IF;

      ASOUTVAL := TO_CHAR( LFNUTVALUE );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETCONTRIBUTEDKCALCALCULATEDRV;

   
   FUNCTION GETUOM(
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ANROWID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTREVISION           IN       IAPITYPE.REVISION_TYPE,
      ANCOLID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.CLOB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'getUoM';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT F_UMH_DESCR( 0,
                          UOM_ID,
                          UOM_REV )
        INTO ASOUTVAL
        FROM SPECIFICATION_PROP A,
             ITNUTREFTYPE B,
             ( SELECT PROPERTY,
                      PROPERTY_REV,
                      ATTRIBUTE,
                      ATTRIBUTE_REV
                FROM ITNUTRESULTDETAIL
               WHERE BOM_EXP_NO = ANUNIQUEID
                 AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                 AND COL_ID = ANROWID
                 AND ROWNUM = 1 ) C
       WHERE A.PART_NO = B.PART_NO
         AND A.REVISION = F_STATUS_REV( B.PART_NO,
                                        'd' )
         AND A.SECTION_ID = B.SECTION_ID
         AND A.SUB_SECTION_ID = B.SUB_SECTION_ID
         AND A.PROPERTY_GROUP = B.PROPERTY_GROUP
         AND B.REF_TYPE = ASNUTREFTYPE
         AND C.ATTRIBUTE = A.ATTRIBUTE
         AND C.PROPERTY = A.PROPERTY;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUOM;

   
   FUNCTION GETRDA(
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ANROWID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTREVISION           IN       IAPITYPE.REVISION_TYPE,
      ANCOLID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.CLOB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'getRDA';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNRDAVALUE                    IAPITYPE.FLOAT_TYPE;
      LNNUTPROPERTY                 IAPITYPE.SEQUENCE_TYPE;
      LNNUTPROPERTYREV              IAPITYPE.REVISION_TYPE;
      LNNUTATTRIBUTE                IAPITYPE.SEQUENCE_TYPE;
      LNNUTATTRIBUTEREV             IAPITYPE.REVISION_TYPE;
      LRNUTREFTYPE                  IAPITYPE.NUTREFROWTYPE_TYPE;
      LNCHARACTERISTICID            IAPITYPE.ID_TYPE;
      LSPROCEDURENAME               IAPITYPE.STRING_TYPE;
      LSROUNDRDAVALUE               IAPITYPE.STRING_TYPE;
      LSNUTROUNDING                 VARCHAR2( 1000 );
   BEGIN
      
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPINUTRITIONALCALCULATION.EXISTREFERENCESPECIFICATION( ASNUTREFTYPE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT TO_CHAR( DECODE( VALUE_COL,
                              1, NUM_1,
                              2, NUM_2,
                              3, NUM_2,
                              4, NUM_2,
                              5, NUM_2,
                              6, NUM_2,
                              7, NUM_2,
                              8, NUM_2,
                              9, NUM_2,
                              10, NUM_2,
                              NUM_1 ) )
        INTO LNRDAVALUE
        FROM SPECIFICATION_PROP A,
             ITNUTREFTYPE B,
             ( SELECT PROPERTY,
                      PROPERTY_REV,
                      ATTRIBUTE,
                      ATTRIBUTE_REV
                FROM ITNUTRESULTDETAIL
               WHERE BOM_EXP_NO = ANUNIQUEID
                 AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                 AND COL_ID = ANROWID
                 AND ROWNUM = 1 ) C
       WHERE A.PART_NO = B.PART_NO
         AND A.REVISION = F_STATUS_REV( B.PART_NO,
                                        'd' )
         AND A.SECTION_ID = B.SECTION_ID
         AND A.SUB_SECTION_ID = B.SUB_SECTION_ID
         AND A.PROPERTY_GROUP = B.PROPERTY_GROUP
         AND B.REF_TYPE = ASNUTREFTYPE
         AND C.ATTRIBUTE = A.ATTRIBUTE
         AND C.PROPERTY = A.PROPERTY;









































































































		
         ASOUTVAL := TO_CHAR( LNRDAVALUE );



      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETRDA;

   
   FUNCTION GETPERCENTRDA(
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ANROWID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTREVISION           IN       IAPITYPE.REVISION_TYPE,
      ANCOLID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANOUTVAL                   OUT      IAPITYPE.NUMVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'getPercentRDA';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;

   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT   TOTAL_VAL
             / DECODE(  ( DECODE( VALUE_COL,
                                  1, NUM_1,
                                  2, NUM_2,
                                  3, NUM_2,
                                  4, NUM_2,
                                  5, NUM_2,
                                  6, NUM_2,
                                  7, NUM_2,
                                  8, NUM_2,
                                  9, NUM_2,
                                  10, NUM_2,
                                  NUM_1 ) ),
                       0, NULL,
                       ( DECODE( VALUE_COL,
                                 1, NUM_1,
                                 2, NUM_2,
                                 3, NUM_2,
                                 4, NUM_2,
                                 5, NUM_2,
                                 6, NUM_2,
                                 7, NUM_2,
                                 8, NUM_2,
                                 9, NUM_2,
                                 10, NUM_2,
                                 NUM_1 ) ) )
             * 100
        INTO ANOUTVAL
        FROM SPECIFICATION_PROP A,
             ITNUTREFTYPE B,
             ( SELECT TO_CHAR( SUM( NUM_VAL ) ) TOTAL_VAL,
                      MAX( PROPERTY ) PROPERTY,
                      MAX( PROPERTY_REV ) PROPERTY_REV,
                      MAX( ATTRIBUTE ) ATTRIBUTE,
                      MAX( ATTRIBUTE_REV ) ATTRIBUTE_REV
                FROM ITNUTRESULTDETAIL
               WHERE BOM_EXP_NO = ANUNIQUEID
                 AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                 AND COL_ID = ANROWID ) C
       WHERE A.PART_NO = B.PART_NO
         AND A.REVISION = F_STATUS_REV( B.PART_NO,
                                        'd' )
         AND A.SECTION_ID = B.SECTION_ID
         AND A.SUB_SECTION_ID = B.SUB_SECTION_ID
         AND A.PROPERTY_GROUP = B.PROPERTY_GROUP
         AND B.REF_TYPE = ASNUTREFTYPE
         AND C.ATTRIBUTE = A.ATTRIBUTE
         AND C.PROPERTY = A.PROPERTY;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPERCENTRDA;


   
   FUNCTION GETPERCENTRDARV(
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      ANROWID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANCOLID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANLOGID                    IN       IAPITYPE.LOGID_TYPE,
      ANOUTVAL                   OUT      IAPITYPE.NUMVAL_TYPE )

      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'getPercentRDARV';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
     
      LSLOGDECSEP                IAPITYPE.DECIMALSEPERATOR_TYPE DEFAULT IAPIGENERAL.GETDBDECIMALSEPERATOR;
   BEGIN
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
        
        SELECT DEC_SEP
        INTO LSLOGDECSEP
        FROM ITNUTLOG
        WHERE LOG_ID = ANLOGID;

      SELECT   TOTAL_VAL
             * DECODE(  ( DECODE( VALUE_COL,
                                  1, NUM_1,
                                  2, NUM_2,
                                  3, NUM_2,
                                  4, NUM_2,
                                  5, NUM_2,
                                  6, NUM_2,
                                  7, NUM_2,
                                  8, NUM_2,
                                  9, NUM_2,
                                  10, NUM_2,
                                  NUM_1 ) ),
                       0, NULL,
                       ( DECODE( VALUE_COL,
                                 1, NUM_1,
                                 2, NUM_2,
                                 3, NUM_2,
                                 4, NUM_2,
                                 5, NUM_2,
                                 6, NUM_2,
                                 7, NUM_2,
                                 8, NUM_2,
                                 9, NUM_2,
                                 10, NUM_2,
                                 NUM_1 ) ) )
             / 100
        INTO ANOUTVAL
        FROM SPECIFICATION_PROP A,
             ITNUTREFTYPE B,
             
            
            ( SELECT REPLACE (TO_CHAR(VALUE), LSLOGDECSEP, IAPIGENERAL.GETDBDECIMALSEPERATOR) TOTAL_VAL,
            
                     PROPERTY,
                     PROPERTY_REV,
                     ATTRIBUTE,
                     ATTRIBUTE_REV
              FROM ITNUTLOGRESULT
              WHERE LOG_ID = ANLOGID
                AND COL_ID = ANCOLID
                AND ROW_ID = ANROWID) C

       WHERE A.PART_NO = B.PART_NO
         AND A.REVISION = F_STATUS_REV( B.PART_NO,
                                        'd' )
         AND A.SECTION_ID = B.SECTION_ID
         AND A.SUB_SECTION_ID = B.SUB_SECTION_ID
         AND A.PROPERTY_GROUP = B.PROPERTY_GROUP
         AND B.REF_TYPE = ASNUTREFTYPE
         AND C.ATTRIBUTE = A.ATTRIBUTE
         AND C.PROPERTY = A.PROPERTY;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPERCENTRDARV;


   
   FUNCTION GETPERCENTRDAUNROUNDED(
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ANROWID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTREVISION           IN       IAPITYPE.REVISION_TYPE,
      ANCOLID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.CLOB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'getPercentRDAUnRounded';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNOUTVAL                      IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := GETPERCENTRDA( ASNUTREFTYPE,
                                 ANUNIQUEID,
                                 ANMOPSEQUENCENO,
                                 ANROWID,
                                 ANLAYOUTID,
                                 ANLAYOUTREVISION,
                                 ANCOLID,
                                 LNOUTVAL );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      ASOUTVAL := TO_CHAR( LNOUTVAL );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPERCENTRDAUNROUNDED;


   
   FUNCTION GETPERCENTRDAUNROUNDEDRV(
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      ANROWID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANCOLID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANLOGID                    IN       IAPITYPE.LOGID_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.CLOB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'getPercentRDAUnRoundedRV';

      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNOUTVAL                      IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := GETPERCENTRDARV( ASNUTREFTYPE,
                                 ANROWID,
                                 ANCOLID,
                                 ANLOGID,
                                 LNOUTVAL );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      ASOUTVAL := TO_CHAR( LNOUTVAL );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPERCENTRDAUNROUNDEDRV;

   
   FUNCTION GETPERCENTRDACALCULATED(
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ANROWID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTREVISION           IN       IAPITYPE.REVISION_TYPE,
      ANCOLID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.CLOB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'getPercentRDACalculated';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNOUTVAL                      IAPITYPE.NUMVAL_TYPE;
			
      LNCHARACTERISTICID            IAPITYPE.ID_TYPE;
			LSPROCEDURENAME               IAPITYPE.STRING_TYPE;
      LSROUNDRDAVALUE               IAPITYPE.STRING_TYPE;
      LSNUTROUNDING                 VARCHAR2( 1000 );
			
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := GETPERCENTRDA( ASNUTREFTYPE,
                                 ANUNIQUEID,
                                 ANMOPSEQUENCENO,
                                 ANROWID,
                                 ANLAYOUTID,
                                 ANLAYOUTREVISION,
                                 ANCOLID,
                                 LNOUTVAL );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;


			BEGIN
         SELECT DECODE( B.ROUND_RDA_COL,
                        26, CHARACTERISTIC,
                        30, CH_2,
                        31, CH_3 )
           INTO LNCHARACTERISTICID
           FROM SPECIFICATION_PROP A,
                ITNUTREFTYPE B,
                ( SELECT PROPERTY,
                         PROPERTY_REV,
                         ATTRIBUTE,
                         ATTRIBUTE_REV
                   FROM ITNUTRESULTDETAIL
                  WHERE BOM_EXP_NO = ANUNIQUEID
                    AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                    AND COL_ID = ANROWID
                    AND ROWNUM = 1 ) C
          WHERE A.PART_NO = B.PART_NO
            AND A.REVISION = F_STATUS_REV( B.PART_NO,
                                           'd' )
            AND A.SECTION_ID = B.ROUND_SECTION_ID
            AND A.SUB_SECTION_ID = B.ROUND_SUB_SECTION_ID
            AND A.PROPERTY_GROUP = B.ROUND_PROPERTY_GROUP
            AND B.REF_TYPE = ASNUTREFTYPE
            AND C.ATTRIBUTE = A.ATTRIBUTE
            AND C.PROPERTY = A.PROPERTY;
      EXCEPTION
         WHEN OTHERS
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_INVALIDROUNDRULESETTING,
                                                  ASNUTREFTYPE );
            
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT );
            RETURN LNRETVAL;
      END;

      IF NVL( LNCHARACTERISTICID,
              0 ) <> 0
      THEN
         BEGIN
            SELECT PROCEDURE_NAME
              INTO LSPROCEDURENAME
              FROM ITNUTROUNDING
             WHERE CHARACTERISTIC_ID = LNCHARACTERISTICID;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_NOROUNDFUNCTIONMAPPING,
                                                     LNCHARACTERISTICID );
               
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT );
               RETURN LNRETVAL;
         END;
      END IF;

      IF LSPROCEDURENAME IS NOT NULL
      THEN
         BEGIN
            LSNUTROUNDING :=    'BEGIN '
                             || ':lnRetVal := '
                             || LSPROCEDURENAME
                             || '('
                             || ':lnOutVal,'
                             || ':lsRoundRDAValue);'
                             || ' end;';

            EXECUTE IMMEDIATE LSNUTROUNDING
                        USING OUT LNRETVAL,
                              LNOUTVAL,
                              OUT LSROUNDRDAVALUE;

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
               RETURN( LNRETVAL );
            END IF;

            ASOUTVAL := LSROUNDRDAVALUE;
         EXCEPTION
            WHEN OTHERS
            THEN
               IF SQLCODE = -6550
               THEN
                  LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_ROUNDFUNCTIONNOTFOUND,
                                                        LSPROCEDURENAME );
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        IAPIGENERAL.GETLASTERRORTEXT );
                  RETURN LNRETVAL;
               ELSE
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        SQLERRM );
                  RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
               END IF;
         END;
      ELSE
         ASOUTVAL := TO_CHAR( LNOUTVAL );
      END IF;		



      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPERCENTRDACALCULATED;


   
   FUNCTION GETPERCENTRDACALCULATEDRV(
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      ANROWID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANCOLID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANLOGID                    IN       IAPITYPE.LOGID_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.CLOB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'getPercentRDACalculatedRV';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNOUTVAL                      IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := GETPERCENTRDARV( ASNUTREFTYPE,
                                 ANROWID,
                                 ANCOLID,
                                 ANLOGID,
                                 LNOUTVAL );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      ASOUTVAL := TO_CHAR( ROUND( LNOUTVAL ) );
 
     RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPERCENTRDACALCULATEDRV;

END IAPINUTRITIONALFUNCTIONS;
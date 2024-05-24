CREATE OR REPLACE PACKAGE BODY iapiImport
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


   FUNCTION CHECKACCESS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LNACCESSLEVEL                 IAPITYPE.ID_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckAccess';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNACCESSLEVEL := 1;

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
                                                    F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSUBSECTIONID, 0),                                            
                                                    
                                                    'BOM' );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CHECKACCESS;


   PROCEDURE IMPORTLOG(
      ANIMPGETDATANO             IN       IAPITYPE.ID_TYPE,
      ASLOGTYPE                  IN       ITIMPLOG.LOG_TYPE%TYPE,
      ASMESSAGE                  IN       ITIMPLOG.MESSAGE%TYPE )
   IS












      PRAGMA AUTONOMOUS_TRANSACTION;
      LSMETHOD                      IAPITYPE.SOURCE_TYPE := 'ImportLog';
   BEGIN

      IF ASLOGTYPE NOT IN( 'I', 'W', 'E' )
      THEN

         RETURN;
      END IF;


      INSERT INTO ITIMPLOG
                  ( IMPGETDATA_NO,
                    LINE_NO,
                    TIMESTAMP,
                    LOG_TYPE,
                    MESSAGE )
           VALUES ( ANIMPGETDATANO,
                    GNLINENO,
                    SYSDATE,
                    ASLOGTYPE,
                    SUBSTR( ASMESSAGE,
                            1,
                            255 ) );


      GNLINENO :=   GNLINENO
                  + 10;
      
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
   END IMPORTLOG;

   FUNCTION IMPORTBOMS(
      ANIMPGETDATANO             IN       IAPITYPE.ID_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.SOURCE_TYPE := 'ImportBOMs';
      LQERRORS                      IAPITYPE.REF_TYPE;


      CURSOR LQBOMS(
         LNIMPGETDATANO             IN       IAPITYPE.ID_TYPE )
      IS
         SELECT   IMPGETDATA_NO,
                  LINE_NO,
                  BOM_HEADER_DESC,
                  BOM_HEADER_BASE_QTY,
                  PLANT,
                  ALTERNATIVE,
                  ITEM_NUMBER,
                  COMPONENT_PART,
                  COMPONENT_REVISION,
                  QUANTITY,
                  UOM,
                  CONV_FACTOR,
                  TO_UNIT,
                  YIELD,
                  ASSEMBLY_SCRAP,
                  COMPONENT_SCRAP,
                  LEAD_TIME_OFFSET,
                  ITEM_CATEGORY,
                  ISSUE_LOCATION,
                  CALC_FLAG,
                  BOM_ITEM_TYPE,
                  OPERATIONAL_STEP,
                  BOM_USAGE,
                  MIN_QTY,
                  MAX_QTY,
                  CHAR_1,
                  CHAR_2,
                  CODE,
                  ALT_GROUP,
                  ALT_PRIORITY,
                  NUM_1,
                  NUM_2,
                  NUM_3,
                  NUM_4,
                  NUM_5,
                  CHAR_3,
                  CHAR_4,
                  CHAR_5,
                  DATE_1,
                  DATE_2,
                  CH_1,
                  CH_2,
                  CH_3,
                  RELEVENCY_TO_COSTING,
                  BULK_MATERIAL,
                  FIXED_QTY,
                  BOOLEAN_1,
                  BOOLEAN_2,
                  BOOLEAN_3,
                  BOOLEAN_4,
                  MAKE_UP
             FROM ITIMPBOM
            WHERE IMPGETDATA_NO = LNIMPGETDATANO
         ORDER BY LINE_NO;

      LNRET                         PLS_INTEGER;
      LNRETVAL                      PLS_INTEGER;
      LNCOUNT                       PLS_INTEGER;
      LSPLANTPREV                   IAPITYPE.PLANT_TYPE;
      LNALTERNATIVEPREV             IAPITYPE.ID_TYPE;
      LNBOMUSAGEPREV                IAPITYPE.BOMUSAGE_TYPE;
      LNITEMNUMBER                  IAPITYPE.BOMITEMNUMBER_TYPE;
      LBCONTINUEWITHBOMITEMS        BOOLEAN;
      LDPED                         IAPITYPE.DATE_TYPE;
      LNDATAERROR                   IAPITYPE.BOOLEAN_TYPE;
      LRERROR                       IAPITYPE.ERRORREC_TYPE;
      LTERRORS                      IAPITYPE.ERRORTAB_TYPE;
   BEGIN

      LNRETVAL := IAPICONSTANTDBERROR.DBERR_SUCCESS;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      
      LNRET := IAPISPECIFICATIONSECTION.EXISTID( ASPARTNO,
                                                 ANREVISION,
                                                 ANSECTIONID,
                                                 ANSUBSECTIONID );

      IF LNRET <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         IMPORTLOG( ANIMPGETDATANO,
                    'E',
                    IAPIGENERAL.GETLASTERRORTEXT( ) );
         
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;



      FOR LRBOMS IN LQBOMS( ANIMPGETDATANO )
      LOOP
         LBCONTINUEWITHBOMITEMS := TRUE;
         LNDATAERROR := 0;





         
         IF LRBOMS.COMPONENT_PART IS NULL
         THEN
            IMPORTLOG( ANIMPGETDATANO,
                       'E',
                       'Invalid Record: Component Part can not be Empty' );
            LNDATAERROR := 1;
            LNRETVAL := IAPICONSTANTDBERROR.DBERR_GENFAIL;
         ELSE
            IF LRBOMS.PLANT IS NULL
            THEN
               IMPORTLOG( ANIMPGETDATANO,
                          'E',
                             'Plant is empty for Bom item <'
                          || LRBOMS.COMPONENT_PART
                          || '> and line number <'
                          || LRBOMS.ITEM_NUMBER
                          || '>.' );
               LNDATAERROR := 1;
               LNRETVAL := IAPICONSTANTDBERROR.DBERR_GENFAIL;
            END IF;

            IF LRBOMS.BOM_USAGE IS NULL
            THEN
               IMPORTLOG( ANIMPGETDATANO,
                          'E',
                             'Bom Usage is empty for Bom item <'
                          || LRBOMS.COMPONENT_PART
                          || '> and line number <'
                          || LRBOMS.ITEM_NUMBER
                          || '>.' );
               LNDATAERROR := 1;
               LNRETVAL := IAPICONSTANTDBERROR.DBERR_GENFAIL;
            END IF;

            IF LRBOMS.ALTERNATIVE IS NULL
            THEN
               IMPORTLOG( ANIMPGETDATANO,
                          'E',
                             'Bom Header Alternative is empty for Bom item <'
                          || LRBOMS.COMPONENT_PART
                          || '> and line number <'
                          || LRBOMS.ITEM_NUMBER
                          || '>.' );
               LNDATAERROR := 1;
               LNRETVAL := IAPICONSTANTDBERROR.DBERR_GENFAIL;
            END IF;

            IF LRBOMS.QUANTITY IS NULL
            THEN
               IMPORTLOG( ANIMPGETDATANO,
                          'E',
                             'Quantity is empty for Bom item <'
                          || LRBOMS.COMPONENT_PART
                          || '> and line number <'
                          || LRBOMS.ITEM_NUMBER
                          || '>.' );
               LNDATAERROR := 1;
               LNRETVAL := IAPICONSTANTDBERROR.DBERR_GENFAIL;
            END IF;

            IF LRBOMS.UOM IS NULL
            THEN
               IMPORTLOG( ANIMPGETDATANO,
                          'E',
                             'Uom is empty for Bom item <'
                          || LRBOMS.COMPONENT_PART
                          || '> and line number <'
                          || LRBOMS.ITEM_NUMBER
                          || '>.' );
               LNDATAERROR := 1;
               LNRETVAL := IAPICONSTANTDBERROR.DBERR_GENFAIL;
            END IF;

            IF LRBOMS.ITEM_CATEGORY IS NULL
            THEN
               IMPORTLOG( ANIMPGETDATANO,
                          'E',
                             'Item Category is empty for Bom item <'
                          || LRBOMS.COMPONENT_PART
                          || '> and line number <'
                          || LRBOMS.ITEM_NUMBER
                          || '>.' );
               LNDATAERROR := 1;
               LNRETVAL := IAPICONSTANTDBERROR.DBERR_GENFAIL;
            END IF;

            IF LRBOMS.ALT_PRIORITY IS NULL
            THEN
               IMPORTLOG( ANIMPGETDATANO,
                          'E',
                             'Alternative Priority is empty for Bom item <'
                          || LRBOMS.COMPONENT_PART
                          || '> and line number <'
                          || LRBOMS.ITEM_NUMBER
                          || '>.' );
               LNDATAERROR := 1;
               LNRETVAL := IAPICONSTANTDBERROR.DBERR_GENFAIL;
            END IF;

            IF LRBOMS.RELEVENCY_TO_COSTING IS NULL
            THEN
               IMPORTLOG( ANIMPGETDATANO,
                          'E',
                             'Relevency To Costing is empty for Bom item <'
                          || LRBOMS.COMPONENT_PART
                          || '> and line number <'
                          || LRBOMS.ITEM_NUMBER
                          || '>.' );
               LNDATAERROR := 1;
               LNRETVAL := IAPICONSTANTDBERROR.DBERR_GENFAIL;
            END IF;

            IF LRBOMS.BULK_MATERIAL IS NULL
            THEN
               IMPORTLOG( ANIMPGETDATANO,
                          'E',
                             'Bulk Material is empty for Bom item <'
                          || LRBOMS.COMPONENT_PART
                          || '> and line number <'
                          || LRBOMS.ITEM_NUMBER
                          || '>.' );
               LNDATAERROR := 1;
               LNRETVAL := IAPICONSTANTDBERROR.DBERR_GENFAIL;
            END IF;

            IF LRBOMS.FIXED_QTY IS NULL
            THEN
               IMPORTLOG( ANIMPGETDATANO,
                          'E',
                             'Fixed Quantity is empty for Bom item <'
                          || LRBOMS.COMPONENT_PART
                          || '> and line number <'
                          || LRBOMS.ITEM_NUMBER
                          || '>.' );
               LNDATAERROR := 1;
               LNRETVAL := IAPICONSTANTDBERROR.DBERR_GENFAIL;
            END IF;

            IF LRBOMS.BOOLEAN_1 IS NULL
            THEN
               IMPORTLOG( ANIMPGETDATANO,
                          'E',
                             'Boolean 1 is empty for Bom item <'
                          || LRBOMS.COMPONENT_PART
                          || '> and line number <'
                          || LRBOMS.ITEM_NUMBER
                          || '>.' );
               LNDATAERROR := 1;
               LNRETVAL := IAPICONSTANTDBERROR.DBERR_GENFAIL;
            END IF;

            IF LRBOMS.BOOLEAN_2 IS NULL
            THEN
               IMPORTLOG( ANIMPGETDATANO,
                          'E',
                             'Boolean 2 is empty for Bom item <'
                          || LRBOMS.COMPONENT_PART
                          || '> and line number <'
                          || LRBOMS.ITEM_NUMBER
                          || '>.' );
               LNDATAERROR := 1;
               LNRETVAL := IAPICONSTANTDBERROR.DBERR_GENFAIL;
            END IF;

            IF LRBOMS.BOOLEAN_3 IS NULL
            THEN
               IMPORTLOG( ANIMPGETDATANO,
                          'E',
                             'Boolean 3 is empty for Bom item <'
                          || LRBOMS.COMPONENT_PART
                          || '> and line number <'
                          || LRBOMS.ITEM_NUMBER
                          || '>.' );
               LNDATAERROR := 1;
               LNRETVAL := IAPICONSTANTDBERROR.DBERR_GENFAIL;
            END IF;

            IF LRBOMS.BOOLEAN_4 IS NULL
            THEN
               IMPORTLOG( ANIMPGETDATANO,
                          'E',
                             'Boolean 4 is empty for Bom item <'
                          || LRBOMS.COMPONENT_PART
                          || '> and line number <'
                          || LRBOMS.ITEM_NUMBER
                          || '>.' );
               LNDATAERROR := 1;
               LNRETVAL := IAPICONSTANTDBERROR.DBERR_GENFAIL;
            END IF;

            IF LRBOMS.MAKE_UP IS NULL
            THEN
               IMPORTLOG( ANIMPGETDATANO,
                          'E',
                             'Make Up is empty for Bom item <'
                          || LRBOMS.COMPONENT_PART
                          || '> and line number <'
                          || LRBOMS.ITEM_NUMBER
                          || '>.' );
               LNDATAERROR := 1;
               LNRETVAL := IAPICONSTANTDBERROR.DBERR_GENFAIL;
            END IF;
         END IF;

         IF LNDATAERROR = 0
         THEN

            IF    LSPLANTPREV IS NULL
               OR LSPLANTPREV <> LRBOMS.PLANT
               OR LNALTERNATIVEPREV IS NULL
               OR LNALTERNATIVEPREV <> LRBOMS.ALTERNATIVE
               OR LNBOMUSAGEPREV IS NULL
               OR LNBOMUSAGEPREV <> LRBOMS.BOM_USAGE
            THEN
               
               SELECT COUNT( * )
                 INTO LNCOUNT
                 FROM BOM_HEADER
                WHERE PART_NO = ASPARTNO
                  AND REVISION = ANREVISION
                  AND PLANT = LRBOMS.PLANT
                  AND ALTERNATIVE = LRBOMS.ALTERNATIVE
                  AND BOM_USAGE = LRBOMS.BOM_USAGE;

               IF LNCOUNT = 0
               THEN
                  SELECT PLANNED_EFFECTIVE_DATE
                    INTO LDPED
                    FROM SPECIFICATION_HEADER
                   WHERE PART_NO = ASPARTNO
                     AND REVISION = ANREVISION;

                  
                  SELECT   NVL( MAX( ALTERNATIVE ),
                                0 )
                         + 1
                    INTO LRBOMS.ALTERNATIVE
                    FROM BOM_HEADER
                   WHERE PART_NO = ASPARTNO
                     AND REVISION = ANREVISION
                     AND PLANT = LRBOMS.PLANT
                     AND BOM_USAGE = LRBOMS.BOM_USAGE;

                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                          'The first free alternative for this plant/usage: '
                                       || LRBOMS.ALTERNATIVE,
                                       IAPICONSTANT.INFOLEVEL_1 );
                  
                  LNRET :=
                     IAPISPECIFICATIONBOM.ADDHEADER( ASPARTNO,
                                                     ANREVISION,
                                                     LRBOMS.PLANT,
                                                     LRBOMS.ALTERNATIVE,
                                                     LRBOMS.BOM_USAGE,
                                                     LRBOMS.BOM_HEADER_DESC,
                                                     LRBOMS.BOM_HEADER_BASE_QTY,
                                                     NULL,
                                                     NULL,
                                                     100,
                                                     'N',
                                                     NULL,
                                                     NULL,
                                                     NULL,
                                                     LDPED,



                                                     AQINFO,
                                                     LQERRORS );

                  IF LNRET <> IAPICONSTANTDBERROR.DBERR_SUCCESS
                  THEN
                     IF ( LNRET = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
                     THEN
                        
                        FETCH LQERRORS
                        BULK COLLECT INTO LTERRORS;

                        IF ( LTERRORS.COUNT > 0 )
                        THEN
                           FOR LNINDEX IN LTERRORS.FIRST .. LTERRORS.LAST
                           LOOP
                              LRERROR := LTERRORS( LNINDEX );

                              IF LRERROR.MESSAGETYPE = IAPICONSTANT.ERRORMESSAGE_ERROR
                              THEN
                                 IMPORTLOG( ANIMPGETDATANO,
                                            'E',
                                            LRERROR.ERRORTEXT );
                              ELSE
                                 IMPORTLOG( ANIMPGETDATANO,
                                            'I',
                                            LRERROR.ERRORTEXT );
                              END IF;
                           END LOOP;
                        END IF;
                     ELSE
                        IMPORTLOG( ANIMPGETDATANO,
                                   'E',
                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
                     END IF;
                  ELSE
                     
                     IMPORTLOG( ANIMPGETDATANO,
                                'I',
                                   'Imported BOM header <'
                                || LRBOMS.PLANT
                                || '/'
                                || LRBOMS.ALTERNATIVE
                                || '/'
                                || LRBOMS.BOM_USAGE
                                || '> for Specification '
                                || ASPARTNO
                                || ' ['
                                || ANREVISION
                                || '].' );
                  END IF;
               END IF;


               LSPLANTPREV := LRBOMS.PLANT;
               LNALTERNATIVEPREV := LRBOMS.ALTERNATIVE;
               LNBOMUSAGEPREV := LRBOMS.BOM_USAGE;
            END IF;




            IF LRBOMS.ITEM_NUMBER IS NULL
            THEN

               SELECT   NVL( MAX( ITEM_NUMBER ),
                             0 )
                      + 10
                 INTO LNITEMNUMBER
                 FROM BOM_ITEM BI
                WHERE BOM_USAGE = LRBOMS.BOM_USAGE
                  AND ALTERNATIVE = LRBOMS.ALTERNATIVE
                  AND PLANT = LRBOMS.PLANT
                  AND REVISION = ANREVISION
                  AND PART_NO = ASPARTNO;
            ELSE
               LNITEMNUMBER := LRBOMS.ITEM_NUMBER;
            END IF;

            LNRET :=
               IAPISPECIFICATIONBOM.ADDITEM( ASPARTNO,
                                             ANREVISION,
                                             LRBOMS.PLANT,
                                             LRBOMS.ALTERNATIVE,
                                             LRBOMS.BOM_USAGE,
                                             LNITEMNUMBER,
                                             LRBOMS.ALT_GROUP,
                                             LRBOMS.ALT_PRIORITY,
                                             LRBOMS.COMPONENT_PART,
                                             LRBOMS.COMPONENT_REVISION,
                                             LRBOMS.PLANT,   
                                             LRBOMS.QUANTITY,
                                             LRBOMS.UOM,
                                             LRBOMS.CONV_FACTOR,
                                             LRBOMS.TO_UNIT,
                                             LRBOMS.YIELD,
                                             LRBOMS.ASSEMBLY_SCRAP,
                                             LRBOMS.COMPONENT_SCRAP,
                                             LRBOMS.LEAD_TIME_OFFSET,
                                             LRBOMS.RELEVENCY_TO_COSTING,
                                             LRBOMS.BULK_MATERIAL,
                                             LRBOMS.ITEM_CATEGORY,
                                             LRBOMS.ISSUE_LOCATION,
                                             LRBOMS.CALC_FLAG,
                                             LRBOMS.BOM_ITEM_TYPE,
                                             LRBOMS.OPERATIONAL_STEP,
                                             LRBOMS.MIN_QTY,
                                             LRBOMS.MAX_QTY,
                                             LRBOMS.FIXED_QTY,
                                             LRBOMS.CODE,
                                             LRBOMS.CHAR_1,
                                             LRBOMS.CHAR_2,
                                             LRBOMS.CHAR_3,
                                             LRBOMS.CHAR_4,
                                             LRBOMS.CHAR_5,
                                             LRBOMS.NUM_1,
                                             LRBOMS.NUM_2,
                                             LRBOMS.NUM_3,
                                             LRBOMS.NUM_4,
                                             LRBOMS.NUM_5,
                                             LRBOMS.BOOLEAN_1,
                                             LRBOMS.BOOLEAN_2,
                                             LRBOMS.BOOLEAN_3,
                                             LRBOMS.BOOLEAN_4,
                                             LRBOMS.DATE_1,
                                             LRBOMS.DATE_2,
                                             LRBOMS.CH_1,
                                             LRBOMS.CH_2,
                                             LRBOMS.CH_3,
                                             LRBOMS.MAKE_UP,
                                             NULL,



                                             0,
                                             0,
                                             AQINFO,
                                             LQERRORS );

            IF LNRET <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               IF ( LNRET = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
               THEN
                  
                  FETCH LQERRORS
                  BULK COLLECT INTO LTERRORS;

                  IF ( LTERRORS.COUNT > 0 )
                  THEN
                     FOR LNINDEX IN LTERRORS.FIRST .. LTERRORS.LAST
                     LOOP
                        LRERROR := LTERRORS( LNINDEX );

                        IF LRERROR.MESSAGETYPE = IAPICONSTANT.ERRORMESSAGE_ERROR
                        THEN
                           IMPORTLOG( ANIMPGETDATANO,
                                      'E',
                                      LRERROR.ERRORTEXT );
                        ELSE
                           IMPORTLOG( ANIMPGETDATANO,
                                      'I',
                                      LRERROR.ERRORTEXT );
                        END IF;
                     END LOOP;
                  END IF;
               ELSE
                  IMPORTLOG( ANIMPGETDATANO,
                             'E',
                             IAPIGENERAL.GETLASTERRORTEXT( ) );
               END IF;
            ELSE

               IMPORTLOG( ANIMPGETDATANO,
                          'I',
                             'Imported BOM item <'
                          || LRBOMS.COMPONENT_PART
                          || '> for line number <'
                          || LNITEMNUMBER
                          || '>.' );
            END IF;
         END IF;
      END LOOP;

      RETURN LNRETVAL;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END IMPORTBOMS;

   FUNCTION IMPORTPROPERTIES(
      ANIMPGETDATANO             IN       IAPITYPE.ID_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.SOURCE_TYPE := 'ImportProperties';


      CURSOR LQPROPERTIES(
         LNIMPGETDATANO             IN       IAPITYPE.ID_TYPE )
      IS
         SELECT   IP.LINE_NO,
                  IP.PROPERTY_GROUP,
                  IP.PROPERTY,
                  IP.ATTRIBUTE,
                  IP.HEADER_ID,
                  IP.VALUE_S,
                  IP.VALUE_N,
                  IP.LANG_ID
             FROM ITIMPPROP IP
            WHERE IP.IMPGETDATA_NO = LNIMPGETDATANO
              AND IP.PROPERTY_GROUP IS NOT NULL
              AND IP.PROPERTY IS NOT NULL
              AND IP.ATTRIBUTE IS NOT NULL
              AND IP.HEADER_ID IS NOT NULL


         ORDER BY IP.PROPERTY_GROUP,
                  IP.LINE_NO;


      LNRET                         PLS_INTEGER;
      LNRETVAL                      PLS_INTEGER;
      LNMULTILANG                   PLS_INTEGER;
      LSPROPERTYGROUP               IAPITYPE.DESCRIPTION_TYPE;
      LSPROPERTY                    IAPITYPE.DESCRIPTION_TYPE;
      LSATTRIBUTE                   IAPITYPE.DESCRIPTION_TYPE;
      LSHEADER                      IAPITYPE.DESCRIPTION_TYPE;
      LSVALUE                       ITIMPPROP.VALUE_S%TYPE;
      LQINFO                        IAPITYPE.REF_TYPE;
      LQERRORS                      IAPITYPE.REF_TYPE;
      LRERROR                       IAPITYPE.ERRORREC_TYPE;
      LTERRORS                      IAPITYPE.ERRORTAB_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;

      LNPROPERTYGROUP               IAPITYPE.ID_TYPE := -1;
      LNRETBULK                     IAPITYPE.ERRORNUM_TYPE;

   BEGIN

      LNRETVAL := IAPICONSTANTDBERROR.DBERR_SUCCESS;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );


      
      
      





      








      
      
      SELECT MULTILANG
        INTO LNMULTILANG
        FROM SPECIFICATION_HEADER
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION;

      
      FOR LRPROPERTIES IN LQPROPERTIES( ANIMPGETDATANO )
      LOOP
         
         IF     LRPROPERTIES.LANG_ID <> 1
            AND LNMULTILANG = 0
         THEN
            NULL;
         ELSE
            IF LRPROPERTIES.VALUE_N IS NOT NULL
            THEN
               LSVALUE := TO_CHAR( LRPROPERTIES.VALUE_N );
            ELSE
               LSVALUE := LRPROPERTIES.VALUE_S;
            END IF;



            
            IF LNPROPERTYGROUP <> LRPROPERTIES.PROPERTY_GROUP
            THEN
               LNRETBULK :=
                  IAPISPECIFICATIONPROPERTYGROUP.SAVEPROPERTYGROUP( ASPARTNO,
                                                                    ANREVISION,
                                                                    ANSECTIONID,
                                                                    ANSUBSECTIONID,
                                                                    LRPROPERTIES.PROPERTY_GROUP,
                                                                    IAPICONSTANT.ACTIONPRE,
                                                                    NULL,
                                                                    LQINFO,
                                                                    LQERRORS );
               LNPROPERTYGROUP := LRPROPERTIES.PROPERTY_GROUP;

               IF LNRETBULK <> IAPICONSTANTDBERROR.DBERR_SUCCESS
               THEN
                  IF ( LNRETBULK = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
                  THEN
                     
                     FETCH LQERRORS
                     BULK COLLECT INTO LTERRORS;

                     IF ( LTERRORS.COUNT > 0 )
                     THEN
                        FOR LNINDEX IN LTERRORS.FIRST .. LTERRORS.LAST
                        LOOP
                           LRERROR := LTERRORS( LNINDEX );

                           IF LRERROR.MESSAGETYPE = IAPICONSTANT.ERRORMESSAGE_ERROR
                           THEN
                              IMPORTLOG( ANIMPGETDATANO,
                                         'E',
                                         LRERROR.ERRORTEXT );
                              RETURN LNRETBULK;
                           ELSE
                              IMPORTLOG( ANIMPGETDATANO,
                                         'I',
                                         LRERROR.ERRORTEXT );
                           END IF;
                        END LOOP;
                     END IF;
                  ELSE
                     IMPORTLOG( ANIMPGETDATANO,
                                'E',
                                IAPIGENERAL.GETLASTERRORTEXT( ) );
                     RETURN LNRETBULK;
                  END IF;
               END IF;
            END IF;


            SELECT COUNT( * )
              INTO LNCOUNT
              FROM SPECIFICATION_PROP
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND PROPERTY_GROUP = LRPROPERTIES.PROPERTY_GROUP
               AND SECTION_ID = ANSECTIONID
               AND SUB_SECTION_ID = ANSUBSECTIONID;

            IF LNCOUNT = 0
            THEN
               LNRET :=
                  IAPISPECIFICATIONPROPERTYGROUP.ADDPROPERTYGROUP( ASPARTNO,
                                                                   ANREVISION,
                                                                   ANSECTIONID,
                                                                   ANSUBSECTIONID,
                                                                   LRPROPERTIES.PROPERTY_GROUP,
                                                                   0,
                                                                   NULL,
                                                                   AQINFO,
                                                                   LQERRORS );
            END IF;

            LNRET :=
               IAPISPECIFICATIONPROPERTYGROUP.SAVEADDPROPERTY( ASPARTNO,
                                                               ANREVISION,
                                                               ANSECTIONID,
                                                               ANSUBSECTIONID,
                                                               LRPROPERTIES.PROPERTY_GROUP,
                                                               LRPROPERTIES.PROPERTY,
                                                               LRPROPERTIES.ATTRIBUTE,
                                                               LRPROPERTIES.HEADER_ID,
                                                               LSVALUE,
                                                               LRPROPERTIES.LANG_ID,
                                                               AQINFO,
                                                               LQERRORS );

            LSPROPERTYGROUP := F_PGH_DESCR( 1,   
                                            LRPROPERTIES.PROPERTY_GROUP,
                                            0 );   
            LSPROPERTY := F_SPH_DESCR( 1,   
                                       LRPROPERTIES.PROPERTY,
                                       0 );   
            LSATTRIBUTE := F_ATH_DESCR( 1,   
                                        LRPROPERTIES.ATTRIBUTE,
                                        0 );   
            LSHEADER := F_HDH_DESCR( 1,   
                                     LRPROPERTIES.HEADER_ID,
                                     0 );   

            IF LNRET <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               IF ( LNRET = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
               THEN
                  
                  FETCH LQERRORS
                  BULK COLLECT INTO LTERRORS;

                  IF ( LTERRORS.COUNT > 0 )
                  THEN
                     FOR LNINDEX IN LTERRORS.FIRST .. LTERRORS.LAST
                     LOOP
                        LRERROR := LTERRORS( LNINDEX );

                        IF LRERROR.MESSAGETYPE = IAPICONSTANT.ERRORMESSAGE_ERROR
                        THEN
                           IMPORTLOG( ANIMPGETDATANO,
                                      'E',
                                      LRERROR.ERRORTEXT );
                        ELSE
                           IMPORTLOG( ANIMPGETDATANO,
                                      'I',
                                      LRERROR.ERRORTEXT );
                        END IF;
                     END LOOP;
                  END IF;
               ELSE
                  IMPORTLOG( ANIMPGETDATANO,
                             'E',
                             IAPIGENERAL.GETLASTERRORTEXT( ) );
               END IF;


               LNRETVAL := IAPICONSTANTDBERROR.DBERR_GENFAIL;
            ELSE

               IMPORTLOG( ANIMPGETDATANO,
                          'I',
                             'Imported value <'
                          || LSVALUE
                          || '> for property group <'
                          || LSPROPERTYGROUP
                          || '> and property <'
                          || LSPROPERTY
                          || '> and attribute <'
                          || LSATTRIBUTE
                          || '> for header <'
                          || LSHEADER
                          || '>.' );
            END IF;
         END IF;
      END LOOP;


      IF LNPROPERTYGROUP > 0
      THEN
         LNRETBULK :=
            IAPISPECIFICATIONPROPERTYGROUP.SAVEPROPERTYGROUP( ASPARTNO,
                                                              ANREVISION,
                                                              ANSECTIONID,
                                                              ANSUBSECTIONID,
                                                              LNPROPERTYGROUP,
                                                              IAPICONSTANT.ACTIONPOST,
                                                              NULL,
                                                              LQINFO,
                                                              LQERRORS );

         IF LNRETBULK <> IAPICONSTANTDBERROR.DBERR_SUCCESS
         THEN
            IF ( LNRETBULK = IAPICONSTANTDBERROR.DBERR_ERRORLIST )
            THEN
               
               FETCH LQERRORS
               BULK COLLECT INTO LTERRORS;

               IF ( LTERRORS.COUNT > 0 )
               THEN
                  FOR LNINDEX IN LTERRORS.FIRST .. LTERRORS.LAST
                  LOOP
                     LRERROR := LTERRORS( LNINDEX );

                     IF LRERROR.MESSAGETYPE = IAPICONSTANT.ERRORMESSAGE_ERROR
                     THEN
                        IMPORTLOG( ANIMPGETDATANO,
                                   'E',
                                   LRERROR.ERRORTEXT );
                        RETURN LNRETBULK;
                     ELSE
                        IMPORTLOG( ANIMPGETDATANO,
                                   'I',
                                   LRERROR.ERRORTEXT );
                     END IF;
                  END LOOP;
               END IF;
            ELSE
               IMPORTLOG( ANIMPGETDATANO,
                          'E',
                          IAPIGENERAL.GETLASTERRORTEXT( ) );
               RETURN LNRETBULK;
            END IF;
         END IF;
      END IF;


      RETURN LNRETBULK;


   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END IMPORTPROPERTIES;

   FUNCTION CHECKIMPORTDATAEXIST(
      ANIMPGETDATANO             IN       IAPITYPE.ID_TYPE,
      ANTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE,
      ABEXISTS                   OUT      BOOLEAN )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.SOURCE_TYPE := 'CheckImportDataExist';


      CURSOR LQPROPCOUNTER(
         LSIMPGETDATANO             IN       IAPITYPE.ID_TYPE )
      IS
         SELECT COUNT( 1 ) COUNTER
           FROM ITIMPPROP IP
          WHERE IP.IMPGETDATA_NO = LSIMPGETDATANO
            AND IP.PROPERTY_GROUP IS NOT NULL
            AND IP.PROPERTY IS NOT NULL
            AND IP.ATTRIBUTE IS NOT NULL
            AND IP.HEADER_ID IS NOT NULL;


      CURSOR LQBOMCOUNTER(
         LSIMPGETDATANO             IN       IAPITYPE.ID_TYPE )
      IS
         SELECT COUNT( 1 ) COUNTER
           FROM ITIMPBOM IB
          WHERE IB.IMPGETDATA_NO = LSIMPGETDATANO;

      LNPROPCOUNTER                 PLS_INTEGER DEFAULT 0;
      LNBOMCOUNTER                  PLS_INTEGER DEFAULT 0;
   BEGIN

      ABEXISTS := TRUE;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ANTYPE IN( IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP, IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY )
      THEN

         FOR LRPROPCOUNTER IN LQPROPCOUNTER( ANIMPGETDATANO )
         LOOP
            LNPROPCOUNTER := LRPROPCOUNTER.COUNTER;
         END LOOP;
      ELSE

         FOR LRBOMCOUNTER IN LQBOMCOUNTER( ANIMPGETDATANO )
         LOOP
            LNBOMCOUNTER := LRBOMCOUNTER.COUNTER;
         END LOOP;
      END IF;

      IF   LNPROPCOUNTER
         + LNBOMCOUNTER = 0
      THEN

         ABEXISTS := FALSE;
      END IF;


      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CHECKIMPORTDATAEXIST;

   FUNCTION IMPORTDATA(
      ANIMPGETDATANO             IN       IAPITYPE.ID_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS












      LSMETHOD                      IAPITYPE.SOURCE_TYPE := 'ImportData';
      LNRET                         PLS_INTEGER;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LBEXISTS                      BOOLEAN;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GNLINENO := 10;
      LNRET := CHECKACCESS( ASPARTNO,
                            ANREVISION,
                            ANSECTIONID,
                            ANSUBSECTIONID );

      IF ( LNRET <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IMPORTLOG( ANIMPGETDATANO,
                    'E',
                    IAPIGENERAL.GETLASTERRORTEXT( ) );
         
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      UPDATE ITIMPPROP IP
         SET IP.PROPERTY_GROUP = 0
       WHERE IP.PROPERTY_GROUP IS NULL
         AND IP.IMPGETDATA_NO = ANIMPGETDATANO;

      UPDATE ITIMPPROP IP
         SET IP.ATTRIBUTE = 0
       WHERE IP.ATTRIBUTE IS NULL
         AND IP.IMPGETDATA_NO = ANIMPGETDATANO;

      
      UPDATE ITIMPBOM IB
         SET IB.ALTERNATIVE = 1
       WHERE IB.ALTERNATIVE IS NULL
         AND IB.IMPGETDATA_NO = ANIMPGETDATANO;

      UPDATE ITIMPBOM IB
         SET IB.BOM_USAGE = 1
       WHERE IB.BOM_USAGE IS NULL
         AND IB.IMPGETDATA_NO = ANIMPGETDATANO;

      UPDATE ITIMPBOM IB
         SET IB.ITEM_CATEGORY = ( SELECT ITEM_CATEGORY
                                   FROM PART_PLANT PP
                                  WHERE PP.PART_NO = IB.COMPONENT_PART
                                    AND PP.PLANT = IB.PLANT )
       WHERE IB.ITEM_CATEGORY IS NULL
         AND IB.IMPGETDATA_NO = ANIMPGETDATANO;

      
      DELETE FROM ITIMPLOG IL
            WHERE IL.IMPGETDATA_NO = ANIMPGETDATANO;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      IMPORTLOG( ANIMPGETDATANO,
                 'I',
                    'Start import for Specification '
                 || ASPARTNO
                 || ' ['
                 || ANREVISION
                 || '].' );

      
      IF ANTYPE NOT IN( IAPICONSTANT.SECTIONTYPE_BOM, IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP, IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY )
      THEN
         IMPORTLOG( ANIMPGETDATANO,
                    'E',
                       'Invalid type <'
                    || ANTYPE
                    || '> supplied for import.' );
         
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      
      
      
      LNRET := IAPISPECIFICATIONACCESS.GETMODEINDEPMODIFIABLEACCESS( ASPARTNO,
                                                                     ANREVISION,
                                                                     LNACCESS );

      IF ( LNRET <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IMPORTLOG( ANIMPGETDATANO,
                    'E',
                    IAPIGENERAL.GETLASTERRORTEXT( ) );
         
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      IF LNACCESS = 0
      THEN
         LNRET := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_NOUPDATEACCESS,
                                            ASPARTNO,
                                            ANREVISION );
         IMPORTLOG( ANIMPGETDATANO,
                    'E',
                    IAPIGENERAL.GETLASTERRORTEXT( ) );
         
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_SUCCESS ) );
      END IF;


















    
      
      LNRET := CHECKIMPORTDATAEXIST( ANIMPGETDATANO,
                                     ANTYPE,
                                     LBEXISTS );

      
      IF    ( LNRET <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         OR ( NOT LBEXISTS )
      THEN
         IMPORTLOG( ANIMPGETDATANO,
                    'I',
                       'Nothing to import for Specification '
                    || ASPARTNO
                    || ' ['
                    || ANREVISION
                    || '].' );
         RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
      END IF;

      
      IF ANTYPE IN( IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP, IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY )
      THEN
         
         LNRET := IMPORTPROPERTIES( ANIMPGETDATANO,
                                    ASPARTNO,
                                    ANREVISION,
                                    ANSECTIONID,
                                    ANSUBSECTIONID,
                                    AQINFO );
      ELSE
         
         LNRET := IMPORTBOMS( ANIMPGETDATANO,
                              ASPARTNO,
                              ANREVISION,
                              ANSECTIONID,
                              ANSUBSECTIONID,
                              AQINFO );
      END IF;

      
      IMPORTLOG( ANIMPGETDATANO,
                 'I',
                    'Import for Specification '
                 || ASPARTNO
                 || ' ['
                 || ANREVISION
                 || '] finished.' );
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END IMPORTDATA;

   
   FUNCTION GETMAPPINGS(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ASTYPE                     IN       IAPITYPE.MAPTYPE_TYPE,
      ASGROUP                    IN       IAPITYPE.MAPGROUP_TYPE,
      AQMAPPINGNAMES             OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetMappings';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 1024 );
      LSSELECT                      VARCHAR2( 256 ) :=    ' DISTINCT remap_name '
                                                       || IAPICONSTANTCOLUMN.NAMECOL;
      LSFROM                        VARCHAR2( 128 ) := ' FROM itimp_mapping	';
      LSWHERE                       VARCHAR2( 256 ) :=    ' WHERE user_id = :asUserId '
                                                       || ' AND remap_Type = :asType '
                                                       || ' AND remap_group = :asGroup ';
      LSORDERBY                     VARCHAR2( 128 ) := ' ORDER BY 1 ';
   BEGIN
      
      
      
      
      
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || ' AND 1=2 ';

      OPEN AQMAPPINGNAMES FOR LSSQL USING ASUSERID,
      ASTYPE,
      ASGROUP;

      
      
      
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

      OPEN AQMAPPINGNAMES FOR LSSQL USING ASUSERID,
      ASTYPE,
      ASGROUP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'SELECT '
                  || LSSELECT
                  || LSFROM
                  || LSWHERE
                  || ' AND 1=2 ';

         OPEN AQMAPPINGNAMES FOR LSSQL USING ASUSERID,
         ASTYPE,
         ASGROUP;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETMAPPINGS;

   
   FUNCTION GETMAPPING(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ASNAME                     IN       IAPITYPE.MAPNAME_TYPE,
      ASTYPE                     IN       IAPITYPE.MAPTYPE_TYPE,
      ASGROUP                    IN       IAPITYPE.MAPGROUP_TYPE,
      AQMAPPINGS                 OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetMapping';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 2048 );
      LSSELECT                      VARCHAR2( 1024 )
         :=    ' user_id '
            || IAPICONSTANTCOLUMN.USERIDCOL
            || ', remap_name '
            || IAPICONSTANTCOLUMN.NAMECOL
            || ', remap_seq '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ', remap_Type '
            || IAPICONSTANTCOLUMN.REMAPTYPECOL
            || ', remap_group '
            || IAPICONSTANTCOLUMN.REMAPGROUPCOL
            || ', remap_item '
            || IAPICONSTANTCOLUMN.REMAPITEMCOL
            || ', orig_value '
            || IAPICONSTANTCOLUMN.REMAPORIGINALVALUECOL
            || ', remap_value '
            || IAPICONSTANTCOLUMN.REMAPVALUECOL;
      LSFROM                        VARCHAR2( 128 ) := ' FROM itimp_mapping	';
      LSWHERE                       VARCHAR2( 256 )
                    :=    ' WHERE user_id = :asUserId '
                       || ' AND remap_name = :asName '
                       || ' AND remap_Type = :asType '
                       || ' AND remap_group = :asGroup ';
      LSORDERBY                     VARCHAR2( 128 ) := ' ORDER BY remap_seq ';
   BEGIN
      
      
      
      
      
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || ' AND 1=2 ';

      OPEN AQMAPPINGS FOR LSSQL USING ASUSERID,
      ASNAME,
      ASTYPE,
      ASGROUP;

      
      
      
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

      OPEN AQMAPPINGS FOR LSSQL USING ASUSERID,
      ASNAME,
      ASTYPE,
      ASGROUP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'SELECT '
                  || LSSELECT
                  || LSFROM
                  || LSWHERE
                  || ' AND 1=2 ';

         OPEN AQMAPPINGS FOR LSSQL USING ASUSERID,
         ASNAME,
         ASTYPE,
         ASGROUP;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETMAPPING;

   
   FUNCTION SAVEMAPPING(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ASNAME                     IN       IAPITYPE.MAPNAME_TYPE,
      ANSEQUENCE                 IN       IAPITYPE.SEQUENCE_TYPE,
      ASTYPE                     IN       IAPITYPE.MAPTYPE_TYPE,
      ASGROUP                    IN       IAPITYPE.MAPGROUP_TYPE,
      ASITEM                     IN       IAPITYPE.MAPITEM_TYPE,
      ASORIGINALVALUE            IN       IAPITYPE.MAPVALUE_TYPE,
      ASREMAPVALUE               IN       IAPITYPE.MAPVALUE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveMapping';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      UPDATE ITIMP_MAPPING
         SET REMAP_ITEM = ASITEM,
             ORIG_VALUE = ASORIGINALVALUE,
             REMAP_VALUE = ASREMAPVALUE
       WHERE USER_ID = ASUSERID
         AND REMAP_NAME = ASNAME
         AND REMAP_SEQ = ANSEQUENCE
         AND REMAP_TYPE = ASTYPE
         AND REMAP_GROUP = ASGROUP;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_MAPPINGNOTFOUND,
                                                    ASUSERID,
                                                    ASNAME,
                                                    ANSEQUENCE,
                                                    ASTYPE,
                                                    ASGROUP );
        
      
      
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEMAPPING;

   
   FUNCTION ADDMAPPING(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ASNAME                     IN       IAPITYPE.MAPNAME_TYPE,
      ANSEQUENCE                 IN       IAPITYPE.SEQUENCE_TYPE,
      ASTYPE                     IN       IAPITYPE.MAPTYPE_TYPE,
      ASGROUP                    IN       IAPITYPE.MAPGROUP_TYPE,
      ASITEM                     IN       IAPITYPE.MAPITEM_TYPE,
      ASORIGINALVALUE            IN       IAPITYPE.MAPVALUE_TYPE,
      ASREMAPVALUE               IN       IAPITYPE.MAPVALUE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddMapping';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      INSERT INTO ITIMP_MAPPING
                  ( USER_ID,
                    REMAP_NAME,
                    REMAP_SEQ,
                    REMAP_TYPE,
                    REMAP_GROUP,
                    REMAP_ITEM,
                    ORIG_VALUE,
                    REMAP_VALUE )
           VALUES ( ASUSERID,
                    ASNAME,
                    ANSEQUENCE,
                    ASTYPE,
                    ASGROUP,
                    ASITEM,
                    ASORIGINALVALUE,
                    ASREMAPVALUE );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDMAPPING;

   
   FUNCTION REMOVEMAPPING(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ASNAME                     IN       IAPITYPE.MAPNAME_TYPE,
      ASTYPE                     IN       IAPITYPE.MAPTYPE_TYPE,
      ASGROUP                    IN       IAPITYPE.MAPGROUP_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveMapping';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      DELETE FROM ITIMP_MAPPING
            WHERE USER_ID = ASUSERID
              AND REMAP_NAME = ASNAME
              AND REMAP_TYPE = ASTYPE
              AND REMAP_GROUP = ASGROUP;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_MAPPINGNOTFOUND,
                                                    ASUSERID,
                                                    ASNAME,
                                                    ASTYPE,
                                                    ASGROUP );
        
      
      
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEMAPPING;

   
   FUNCTION ADDBOM(
      ANIMPGETDATANO             IN OUT   IAPITYPE.ID_TYPE,
      ASBOMHEADERDESC            IN       IAPITYPE.DESCRIPTION_TYPE,
      ANBOMHEADERBASEQTY         IN       IAPITYPE.BOMQUANTITY_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANITEMNUMBER               IN       IAPITYPE.BOMITEMNUMBER_TYPE,
      ASCOMPONENTPARTNO          IN       IAPITYPE.PARTNO_TYPE,
      ANCOMPONENTREVISION        IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      ASCOMPONENTPLANT           IN       IAPITYPE.PLANT_TYPE,
      ANQUANTITY                 IN       IAPITYPE.BOMQUANTITY_TYPE DEFAULT NULL,
      ASUOM                      IN       IAPITYPE.DESCRIPTION_TYPE,
      ANCONVERSIONFACTOR         IN       IAPITYPE.BOMCONVFACTOR_TYPE DEFAULT NULL,
      ASTOUNIT                   IN       IAPITYPE.BASEUOM_TYPE DEFAULT NULL,
      ANYIELD                    IN       IAPITYPE.BOMYIELD_TYPE DEFAULT NULL,
      ANASSEMBLYSCRAP            IN       IAPITYPE.SCRAP_TYPE DEFAULT NULL,
      ANCOMPONENTSCRAP           IN       IAPITYPE.SCRAP_TYPE DEFAULT NULL,
      ANLEADTIMEOFFSET           IN       IAPITYPE.BOMLEADTIMEOFFSET_TYPE DEFAULT NULL,
      ASITEMCATEGORY             IN       IAPITYPE.BOMITEMCATEGORY_TYPE,
      ASISSUELOCATION            IN       IAPITYPE.BOMISSUELOCATION_TYPE DEFAULT NULL,
      ASCALCULATIONMODE          IN       IAPITYPE.BOMITEMCALCFLAG_TYPE DEFAULT NULL,
      ASBOMITEMTYPE              IN       IAPITYPE.BOMITEMTYPE_TYPE DEFAULT NULL,
      ANOPERATIONALSTEP          IN       IAPITYPE.BOMOPERATIONALSTEP_TYPE DEFAULT NULL,
      ANBOMUSAGE                 IN       IAPITYPE.BOMUSAGE_TYPE,
      ANMINIMUMQUANTITY          IN       IAPITYPE.BOMQUANTITY_TYPE DEFAULT NULL,
      ANMAXIMUMQUANTITY          IN       IAPITYPE.BOMQUANTITY_TYPE DEFAULT NULL,
      ASTEXT1                    IN       IAPITYPE.BOMITEMLONGCHARACTER_TYPE DEFAULT NULL,
      ASTEXT2                    IN       IAPITYPE.BOMITEMLONGCHARACTER_TYPE DEFAULT NULL,
      ASCODE                     IN       IAPITYPE.BOMITEMCODE_TYPE DEFAULT NULL,
      ASALTERNATIVEGROUP         IN       IAPITYPE.BOMITEMALTGROUP_TYPE DEFAULT NULL,
      ANALTERNATIVEPRIORITY      IN       IAPITYPE.BOMITEMALTPRIORITY_TYPE DEFAULT 1,
      ANNUMERIC1                 IN       IAPITYPE.BOMITEMNUMERIC_TYPE DEFAULT NULL,
      ANNUMERIC2                 IN       IAPITYPE.BOMITEMNUMERIC_TYPE DEFAULT NULL,
      ANNUMERIC3                 IN       IAPITYPE.BOMITEMNUMERIC_TYPE DEFAULT NULL,
      ANNUMERIC4                 IN       IAPITYPE.BOMITEMNUMERIC_TYPE DEFAULT NULL,
      ANNUMERIC5                 IN       IAPITYPE.BOMITEMNUMERIC_TYPE DEFAULT NULL,
      ASTEXT3                    IN       IAPITYPE.BOMITEMCHARACTER_TYPE DEFAULT NULL,
      ASTEXT4                    IN       IAPITYPE.BOMITEMCHARACTER_TYPE DEFAULT NULL,
      ASTEXT5                    IN       IAPITYPE.BOMITEMCHARACTER_TYPE DEFAULT NULL,
      ADDATE1                    IN       IAPITYPE.DATE_TYPE DEFAULT NULL,
      ADDATE2                    IN       IAPITYPE.DATE_TYPE DEFAULT NULL,
      ANCHARACTERISTIC1          IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANCHARACTERISTIC2          IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANCHARACTERISTIC3          IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANRELEVANCYTOCOSTING       IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANBULKMATERIAL             IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANFIXEDQUANTITY            IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANBOOLEAN1                 IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANBOOLEAN2                 IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANBOOLEAN3                 IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANBOOLEAN4                 IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANMAKEUP                   IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0 )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddBom';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNLINENO                      IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( ANIMPGETDATANO > 0 )
      THEN
         NULL;
      ELSE
         SELECT ITIMPGETDATA_SEQ.NEXTVAL
           INTO ANIMPGETDATANO
           FROM DUAL;
      END IF;

      SELECT   NVL( MAX( LINE_NO ),
                    0 )
             + 1
        INTO LNLINENO
        FROM ITIMPBOM
       WHERE IMPGETDATA_NO = ANIMPGETDATANO;

      BEGIN
         INSERT INTO ITIMPBOM
                     ( IMPGETDATA_NO,
                       LINE_NO,
                       BOM_HEADER_DESC,
                       BOM_HEADER_BASE_QTY,
                       PLANT,
                       ALTERNATIVE,
                       ITEM_NUMBER,
                       COMPONENT_PART,
                       COMPONENT_REVISION,
                       COMPONENT_PLANT,
                       QUANTITY,
                       UOM,
                       CONV_FACTOR,
                       TO_UNIT,
                       YIELD,
                       ASSEMBLY_SCRAP,
                       COMPONENT_SCRAP,
                       LEAD_TIME_OFFSET,
                       ITEM_CATEGORY,
                       ISSUE_LOCATION,
                       CALC_FLAG,
                       BOM_ITEM_TYPE,
                       OPERATIONAL_STEP,
                       BOM_USAGE,
                       MIN_QTY,
                       MAX_QTY,
                       CHAR_1,
                       CHAR_2,
                       CODE,
                       ALT_GROUP,
                       ALT_PRIORITY,
                       NUM_1,
                       NUM_2,
                       NUM_3,
                       NUM_4,
                       NUM_5,
                       CHAR_3,
                       CHAR_4,
                       CHAR_5,
                       DATE_1,
                       DATE_2,
                       CH_1,
                       CH_2,
                       CH_3,
                       RELEVENCY_TO_COSTING,
                       BULK_MATERIAL,
                       FIXED_QTY,
                       BOOLEAN_1,
                       BOOLEAN_2,
                       BOOLEAN_3,
                       BOOLEAN_4,
                       MAKE_UP )
              VALUES ( ANIMPGETDATANO,
                       LNLINENO,
                       ASBOMHEADERDESC,
                       ANBOMHEADERBASEQTY,
                       ASPLANT,
                       ANALTERNATIVE,
                       ANITEMNUMBER,
                       ASCOMPONENTPARTNO,
                       ANCOMPONENTREVISION,
                       ASCOMPONENTPLANT,
                       ANQUANTITY,
                       ASUOM,
                       ANCONVERSIONFACTOR,
                       ASTOUNIT,
                       ANYIELD,
                       ANASSEMBLYSCRAP,
                       ANCOMPONENTSCRAP,
                       ANLEADTIMEOFFSET,
                       ASITEMCATEGORY,
                       ASISSUELOCATION,
                       ASCALCULATIONMODE,
                       ASBOMITEMTYPE,
                       ANOPERATIONALSTEP,
                       ANBOMUSAGE,
                       ANMINIMUMQUANTITY,
                       ANMAXIMUMQUANTITY,
                       ASTEXT1,
                       ASTEXT2,
                       ASCODE,
                       ASALTERNATIVEGROUP,
                       ANALTERNATIVEPRIORITY,
                       ANNUMERIC1,
                       ANNUMERIC2,
                       ANNUMERIC3,
                       ANNUMERIC4,
                       ANNUMERIC5,
                       ASTEXT3,
                       ASTEXT4,
                       ASTEXT5,
                       ADDATE1,
                       ADDATE2,
                       ANCHARACTERISTIC1,
                       ANCHARACTERISTIC2,
                       ANCHARACTERISTIC3,
                       ANRELEVANCYTOCOSTING,
                       ANBULKMATERIAL,
                       ANFIXEDQUANTITY,
                       ANBOOLEAN1,
                       ANBOOLEAN2,
                       ANBOOLEAN3,
                       ANBOOLEAN4,
                       ANMAKEUP );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            SELECT   NVL( MAX( LINE_NO ),
                          0 )
                   + 1
              INTO LNLINENO
              FROM ITIMPBOM
             WHERE IMPGETDATA_NO = ANIMPGETDATANO;

            INSERT INTO ITIMPBOM
                        ( IMPGETDATA_NO,
                          LINE_NO,
                          BOM_HEADER_DESC,
                          BOM_HEADER_BASE_QTY,
                          PLANT,
                          ALTERNATIVE,
                          ITEM_NUMBER,
                          COMPONENT_PART,
                          COMPONENT_REVISION,
                          COMPONENT_PLANT,
                          QUANTITY,
                          UOM,
                          CONV_FACTOR,
                          TO_UNIT,
                          YIELD,
                          ASSEMBLY_SCRAP,
                          COMPONENT_SCRAP,
                          LEAD_TIME_OFFSET,
                          ITEM_CATEGORY,
                          ISSUE_LOCATION,
                          CALC_FLAG,
                          BOM_ITEM_TYPE,
                          OPERATIONAL_STEP,
                          BOM_USAGE,
                          MIN_QTY,
                          MAX_QTY,
                          CHAR_1,
                          CHAR_2,
                          CODE,
                          ALT_GROUP,
                          ALT_PRIORITY,
                          NUM_1,
                          NUM_2,
                          NUM_3,
                          NUM_4,
                          NUM_5,
                          CHAR_3,
                          CHAR_4,
                          CHAR_5,
                          DATE_1,
                          DATE_2,
                          CH_1,
                          CH_2,
                          CH_3,
                          RELEVENCY_TO_COSTING,
                          BULK_MATERIAL,
                          FIXED_QTY,
                          BOOLEAN_1,
                          BOOLEAN_2,
                          BOOLEAN_3,
                          BOOLEAN_4,
                          MAKE_UP )
                 VALUES ( ANIMPGETDATANO,
                          LNLINENO,
                          ASBOMHEADERDESC,
                          ANBOMHEADERBASEQTY,
                          ASPLANT,
                          ANALTERNATIVE,
                          ANITEMNUMBER,
                          ASCOMPONENTPARTNO,
                          ANCOMPONENTREVISION,
                          ASCOMPONENTPLANT,
                          ANQUANTITY,
                          ASUOM,
                          ANCONVERSIONFACTOR,
                          ASTOUNIT,
                          ANYIELD,
                          ANASSEMBLYSCRAP,
                          ANCOMPONENTSCRAP,
                          ANLEADTIMEOFFSET,
                          ASITEMCATEGORY,
                          ASISSUELOCATION,
                          ASCALCULATIONMODE,
                          ASBOMITEMTYPE,
                          ANOPERATIONALSTEP,
                          ANBOMUSAGE,
                          ANMINIMUMQUANTITY,
                          ANMAXIMUMQUANTITY,
                          ASTEXT1,
                          ASTEXT2,
                          ASCODE,
                          ASALTERNATIVEGROUP,
                          ANALTERNATIVEPRIORITY,
                          ANNUMERIC1,
                          ANNUMERIC2,
                          ANNUMERIC3,
                          ANNUMERIC4,
                          ANNUMERIC5,
                          ASTEXT3,
                          ASTEXT4,
                          ASTEXT5,
                          ADDATE1,
                          ADDATE2,
                          ANCHARACTERISTIC1,
                          ANCHARACTERISTIC2,
                          ANCHARACTERISTIC3,
                          ANRELEVANCYTOCOSTING,
                          ANBULKMATERIAL,
                          ANFIXEDQUANTITY,
                          ANBOOLEAN1,
                          ANBOOLEAN2,
                          ANBOOLEAN3,
                          ANBOOLEAN4,
                          ANMAKEUP );
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
   END ADDBOM;

   
   FUNCTION ADDPROPERTY(
      ANIMPGETDATANO             IN OUT   IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPID          IN       IAPITYPE.ID_TYPE,
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE,
      ANHEADERID                 IN       IAPITYPE.ID_TYPE,
      ASVALUE                    IN       IAPITYPE.PROPERTYLONGSTRING_TYPE,
      ANVALUE                    IN       IAPITYPE.FLOAT_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddProperty';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNLINENO                      IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( ANIMPGETDATANO > 0 )
      THEN
         NULL;
      ELSE
         SELECT ITIMPGETDATA_SEQ.NEXTVAL
           INTO ANIMPGETDATANO
           FROM DUAL;
      END IF;

      SELECT   NVL( MAX( LINE_NO ),
                    0 )
             + 1
        INTO LNLINENO
        FROM ITIMPPROP
       WHERE IMPGETDATA_NO = ANIMPGETDATANO;

      BEGIN
         INSERT INTO ITIMPPROP
                     ( IMPGETDATA_NO,
                       LINE_NO,
                       PROPERTY_GROUP,
                       PROPERTY,
                       ATTRIBUTE,
                       HEADER_ID,
                       VALUE_S,
                       VALUE_N )
              VALUES ( ANIMPGETDATANO,
                       LNLINENO,
                       ANPROPERTYGROUPID,
                       ANPROPERTYID,
                       ANATTRIBUTEID,
                       ANHEADERID,
                       ASVALUE,
                       ANVALUE );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            SELECT   NVL( MAX( LINE_NO ),
                          0 )
                   + 1
              INTO LNLINENO
              FROM ITIMPPROP
             WHERE IMPGETDATA_NO = ANIMPGETDATANO;

            INSERT INTO ITIMPPROP
                        ( IMPGETDATA_NO,
                          LINE_NO,
                          PROPERTY_GROUP,
                          PROPERTY,
                          ATTRIBUTE,
                          HEADER_ID,
                          VALUE_S,
                          VALUE_N )
                 VALUES ( ANIMPGETDATANO,
                          LNLINENO,
                          ANPROPERTYGROUPID,
                          ANPROPERTYID,
                          ANATTRIBUTEID,
                          ANHEADERID,
                          ASVALUE,
                          ANVALUE );
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
   END ADDPROPERTY;

   
   FUNCTION GETLOGGING(
      ANIMPGETDATANO             IN       IAPITYPE.ID_TYPE,
      AQIMPORTLOGS               OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetLogging';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'i.timestamp '
            || IAPICONSTANTCOLUMN.TIMESTAMPCOL
            || ','
            || 'i.log_Type '
            || IAPICONSTANTCOLUMN.LOGTYPECOL
            || ','
            || 'i.message '
            || IAPICONSTANTCOLUMN.MESSAGECOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'itimplog i';
   BEGIN
      
      
      
      
      
      IF ( AQIMPORTLOGS%ISOPEN )
      THEN
         CLOSE AQIMPORTLOGS;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=    ' SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM
               || ' WHERE i.impgetdata_no = :ImpGetDataNo ORDER BY i.line_no';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQIMPORTLOGS FOR LSSQL USING ANIMPGETDATANO;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETLOGGING;
END IAPIIMPORT;
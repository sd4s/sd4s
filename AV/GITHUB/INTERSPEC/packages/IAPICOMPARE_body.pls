CREATE OR REPLACE PACKAGE BODY iapiCompare
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











   FUNCTION GETCOMPAREBHSTATUS

   (
      ANFROM                     IN       IAPITYPE.ID_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE,
      ASPARTNO2                  IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION2                IN       IAPITYPE.REVISION_TYPE,
      ASPLANT2                   IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE2             IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANUSAGE2                   IN       IAPITYPE.BOMUSAGE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LNCOUNT                       IAPITYPE.ID_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetCompareBHStatus';
   BEGIN
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM BOM_HEADER
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANT
         AND ALTERNATIVE = ANALTERNATIVE
         AND BOM_USAGE = ANUSAGE;

      IF LNCOUNT = 0
      THEN
         RETURN ANFROM;
      ELSE
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM BOM_HEADER A,
                BOM_HEADER B
          WHERE A.PART_NO = ASPARTNO
            AND A.REVISION = ANREVISION
            AND A.PLANT = ASPLANT2
            AND A.ALTERNATIVE = ANALTERNATIVE2
            AND A.BOM_USAGE = ANUSAGE2
            AND B.PART_NO = ASPARTNO2
            AND B.REVISION = ANREVISION2
            AND B.PLANT = ASPLANT
            AND B.ALTERNATIVE = ANALTERNATIVE
            AND B.BOM_USAGE = ANUSAGE
            AND A.BASE_QUANTITY = B.BASE_QUANTITY
            AND DECODE( A.DESCRIPTION,
                        NULL, '//',
                        '', '//',
                        A.DESCRIPTION ) = DECODE( B.DESCRIPTION,
                                                  NULL, '//',
                                                  '', '//',
                                                  B.DESCRIPTION )
            AND DECODE( A.YIELD,
                        NULL, '//',
                        '', '//',
                        A.YIELD ) = DECODE( B.YIELD,
                                            NULL, '//',
                                            '', '//',
                                            B.YIELD )
            AND DECODE( A.CONV_FACTOR,
                        NULL, '//',
                        '', '//',
                        A.CONV_FACTOR ) = DECODE( B.CONV_FACTOR,
                                                  NULL, '//',
                                                  '', '//',
                                                  B.CONV_FACTOR )
            AND DECODE( A.TO_UNIT,
                        NULL, '//',
                        '', '//',
                        A.TO_UNIT ) = DECODE( B.TO_UNIT,
                                              NULL, '//',
                                              '', '//',
                                              B.TO_UNIT )
            AND DECODE( A.CALC_FLAG,
                        NULL, '//',
                        '', '//',
                        A.CALC_FLAG ) = DECODE( B.CALC_FLAG,
                                                NULL, '//',
                                                '', '//',
                                                B.CALC_FLAG )
            AND DECODE( A.BOM_TYPE,
                        NULL, '//',
                        '', '//',
                        A.BOM_TYPE ) = DECODE( B.BOM_TYPE,
                                               NULL, '//',
                                               '', '//',
                                               B.BOM_TYPE )
            AND DECODE( A.MIN_QTY,
                        NULL, '//',
                        '', '//',
                        A.MIN_QTY ) = DECODE( B.MIN_QTY,
                                              NULL, '//',
                                              '', '//',
                                              B.MIN_QTY )
            AND DECODE( A.MAX_QTY,
                        NULL, '//',
                        '', '//',
                        A.MAX_QTY ) = DECODE( B.MAX_QTY,
                                              NULL, '//',
                                              '', '//',
                                              B.MAX_QTY )
            AND DECODE( A.PLANT_EFFECTIVE_DATE,
                        NULL, '//',
                        '', '//',
                        A.PLANT_EFFECTIVE_DATE ) = DECODE( B.PLANT_EFFECTIVE_DATE,
                                                           NULL, '//',
                                                           '', '//',
                                                           B.PLANT_EFFECTIVE_DATE )
            AND A.PREFERRED = B.PREFERRED;

         IF LNCOUNT > 0
         THEN
            RETURN 0;   
         ELSE
            RETURN 3;   
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RAISE_APPLICATION_ERROR( -20000,
                                  SQLERRM );
   END GETCOMPAREBHSTATUS;


   FUNCTION GETCOMPAREBISTATUS

   (
      ANFROM                     IN       IAPITYPE.ID_TYPE,
      ASPARTNOCOMPARE            IN       IAPITYPE.PARTNO_TYPE,
      ANREVISIONCOMPARE          IN       IAPITYPE.REVISION_TYPE,
      ASPLANTCOMPARE             IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVECOMPARE       IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANUSAGECOMPARE             IN       IAPITYPE.BOMUSAGE_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE,
      ASCOMPONENTPART            IN       IAPITYPE.PARTNO_TYPE,
      ANCOMPONENTREVISION        IN       IAPITYPE.REVISION_TYPE,
      ASCOMPONENTPLANT           IN       IAPITYPE.PLANT_TYPE,
      ANQUANTITY                 IN       IAPITYPE.BOMQUANTITY_TYPE,
      ASUOM                      IN       IAPITYPE.DESCRIPTION_TYPE,
      ANCONVERSIONFACTOR         IN       IAPITYPE.BOMCONVFACTOR_TYPE,
      ASCONVERTEDUOM             IN       IAPITYPE.DESCRIPTION_TYPE,
      ANYIELD                    IN       IAPITYPE.BOMYIELD_TYPE,
      ANASSEMBLYSCRAP            IN       IAPITYPE.SCRAP_TYPE,
      ANCOMPONENTSCRAP           IN       IAPITYPE.SCRAP_TYPE,
      ANLEADTIMEOFFSET           IN       IAPITYPE.BOMLEADTIMEOFFSET_TYPE,
      ASITEMCATEGORY             IN       IAPITYPE.BOMITEMCATEGORY_TYPE,
      ASISSUELOCATION            IN       IAPITYPE.BOMISSUELOCATION_TYPE,
      ASCALCULATIONMODE          IN       IAPITYPE.BOMITEMCALCFLAG_TYPE,
      ASBOMITEMTYPE              IN       IAPITYPE.BOMITEMTYPE_TYPE,
      ANOPERATIONALSTEP          IN       IAPITYPE.BOMOPERATIONALSTEP_TYPE,
      ANMINIMUMQUANTITY          IN       IAPITYPE.BOMQUANTITY_TYPE,
      ANMAXIMUMQUANTITY          IN       IAPITYPE.BOMQUANTITY_TYPE,
      ASCODE                     IN       IAPITYPE.BOMITEMCODE_TYPE,
      ASALTERNATIVEGROUP         IN       IAPITYPE.BOMITEMALTGROUP_TYPE,
      ANALTERNATIVEPRIORITY      IN       IAPITYPE.BOMITEMALTPRIORITY_TYPE,
      ANNUMERIC1                 IN       IAPITYPE.BOMITEMNUMERIC_TYPE,
      ANNUMERIC2                 IN       IAPITYPE.BOMITEMNUMERIC_TYPE,
      ANNUMERIC3                 IN       IAPITYPE.BOMITEMNUMERIC_TYPE,
      ANNUMERIC4                 IN       IAPITYPE.BOMITEMNUMERIC_TYPE,
      ANNUMERIC5                 IN       IAPITYPE.BOMITEMNUMERIC_TYPE,
      ASTEXT1                    IN       IAPITYPE.BOMITEMLONGCHARACTER_TYPE,
      ASTEXT2                    IN       IAPITYPE.BOMITEMLONGCHARACTER_TYPE,
      ASTEXT3                    IN       IAPITYPE.BOMITEMLONGCHARACTER_TYPE,
      ASTEXT4                    IN       IAPITYPE.BOMITEMLONGCHARACTER_TYPE,
      ASTEXT5                    IN       IAPITYPE.BOMITEMLONGCHARACTER_TYPE,
      ADDATE1                    IN       IAPITYPE.DATE_TYPE,
      ADDATE2                    IN       IAPITYPE.DATE_TYPE,
      ASCHARACTERISTIC1          IN       IAPITYPE.DESCRIPTION_TYPE,
      ASCHARACTERISTIC2          IN       IAPITYPE.DESCRIPTION_TYPE,
      ASCHARACTERISTIC3          IN       IAPITYPE.DESCRIPTION_TYPE,
      ANRELEVANCYTOCOSTING       IN       IAPITYPE.BOOLEAN_TYPE,
      ANBULKMATERIAL             IN       IAPITYPE.BOOLEAN_TYPE,
      ANFIXEDQUANTITY            IN       IAPITYPE.BOOLEAN_TYPE,
      ANBOOLEAN1                 IN       IAPITYPE.BOOLEAN_TYPE,
      ANBOOLEAN2                 IN       IAPITYPE.BOOLEAN_TYPE,
      ANBOOLEAN3                 IN       IAPITYPE.BOOLEAN_TYPE,
      ANBOOLEAN4                 IN       IAPITYPE.BOOLEAN_TYPE,
      ASINTERNATIONALEQUIVALENT  IN       IAPITYPE.PARTNO_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LNCOUNT                       IAPITYPE.ID_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetCompareBIStatus';
   BEGIN
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM BOM_ITEM A,
             BOM_ITEM B
       WHERE A.PART_NO = ASPARTNOCOMPARE
         AND A.REVISION = ANREVISIONCOMPARE
         AND A.PLANT = ASPLANTCOMPARE
         AND A.ALTERNATIVE = ANALTERNATIVECOMPARE
         AND A.BOM_USAGE = ANUSAGECOMPARE
         AND B.PART_NO = ASPARTNO
         AND B.REVISION = ANREVISION
         AND B.PLANT = ASPLANT
         AND B.ALTERNATIVE = ANALTERNATIVE
         AND B.BOM_USAGE = ANUSAGE
         AND A.COMPONENT_PART = ASCOMPONENTPART
         AND A.COMPONENT_PART = B.COMPONENT_PART;

      DBMS_OUTPUT.PUT_LINE(    'lncount1-'
                            || LNCOUNT );

      IF LNCOUNT = 0
      THEN
         RETURN ANFROM;
      ELSIF LNCOUNT = 1
      THEN
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM BOM_ITEM A,
                BOM_ITEM B
          WHERE A.PART_NO = ASPARTNOCOMPARE
            AND A.REVISION = ANREVISIONCOMPARE
            AND A.PLANT = ASPLANTCOMPARE
            AND A.ALTERNATIVE = ANALTERNATIVECOMPARE
            AND A.BOM_USAGE = ANUSAGECOMPARE
            AND B.PART_NO = ASPARTNO
            AND B.REVISION = ANREVISION
            AND B.PLANT = ASPLANT
            AND B.ALTERNATIVE = ANALTERNATIVE
            AND B.BOM_USAGE = ANUSAGE
            AND A.COMPONENT_PART = ASCOMPONENTPART
            AND A.COMPONENT_PART = B.COMPONENT_PART
            AND DECODE( A.COMPONENT_REVISION,
                        NULL, '//',
                        '', '//',
                        A.COMPONENT_REVISION ) = DECODE( ANCOMPONENTREVISION,
                                                         NULL, '//',
                                                         '', '//',
                                                         ANCOMPONENTREVISION )
            AND NVL( A.COMPONENT_REVISION,
                     0 ) = NVL( B.COMPONENT_REVISION,
                                0 )
            AND DECODE( A.COMPONENT_PLANT,
                        NULL, '//',
                        '', '//',
                        A.COMPONENT_PLANT ) = DECODE( ASCOMPONENTPLANT,
                                                      NULL, '//',
                                                      '', '//',
                                                      ASCOMPONENTPLANT )
            AND A.COMPONENT_PLANT = B.COMPONENT_PLANT
            AND DECODE( A.QUANTITY,
                        NULL, '//',
                        '', '//',
                        A.QUANTITY ) = DECODE( ANQUANTITY,
                                               NULL, '//',
                                               '', '//',
                                               ANQUANTITY )
            AND A.QUANTITY = B.QUANTITY
            AND DECODE( A.UOM,
                        NULL, '//',
                        '', '//',
                        A.UOM ) = DECODE( ASUOM,
                                          NULL, '//',
                                          '', '//',
                                          ASUOM )
            AND A.UOM = B.UOM
            AND DECODE( A.CONV_FACTOR,
                        NULL, '//',
                        '', '//',
                        A.CONV_FACTOR ) = DECODE( ANCONVERSIONFACTOR,
                                                  NULL, '//',
                                                  '', '//',
                                                  ANCONVERSIONFACTOR )
            AND NVL( A.CONV_FACTOR,
                     0 ) = NVL( B.CONV_FACTOR,
                                0 )
            AND DECODE( A.TO_UNIT,
                        NULL, '//',
                        '', '//',
                        A.TO_UNIT ) = DECODE( ASCONVERTEDUOM,
                                              NULL, '//',
                                              '', '//',
                                              ASCONVERTEDUOM )
            AND NVL( A.TO_UNIT,
                     0 ) = NVL( B.TO_UNIT,
                                0 )
            AND DECODE( A.YIELD,
                        NULL, '//',
                        '', '//',
                        A.YIELD ) = DECODE( ANYIELD,
                                            NULL, '//',
                                            '', '//',
                                            ANYIELD )
            AND NVL( A.YIELD,
                     0 ) = NVL( B.YIELD,
                                0 )
            AND DECODE( A.ASSEMBLY_SCRAP,
                        NULL, '//',
                        '', '//',
                        A.ASSEMBLY_SCRAP ) = DECODE( ANASSEMBLYSCRAP,
                                                     NULL, '//',
                                                     '', '//',
                                                     ANASSEMBLYSCRAP )
            AND NVL( A.ASSEMBLY_SCRAP,
                     0 ) = NVL( B.ASSEMBLY_SCRAP,
                                0 )
            AND DECODE( A.COMPONENT_SCRAP,
                        NULL, '//',
                        '', '//',
                        A.COMPONENT_SCRAP ) = DECODE( ANCOMPONENTSCRAP,
                                                      NULL, '//',
                                                      '', '//',
                                                      ANCOMPONENTSCRAP )
            AND NVL( A.COMPONENT_SCRAP,
                     0 ) = NVL( B.COMPONENT_SCRAP,
                                0 )
            AND DECODE( A.LEAD_TIME_OFFSET,
                        NULL, '//',
                        '', '//',
                        A.LEAD_TIME_OFFSET ) = DECODE( ANLEADTIMEOFFSET,
                                                       NULL, '//',
                                                       '', '//',
                                                       ANLEADTIMEOFFSET )
            AND NVL( A.LEAD_TIME_OFFSET,
                     0 ) = NVL( B.LEAD_TIME_OFFSET,
                                0 )
            AND DECODE( A.ITEM_CATEGORY,
                        NULL, '//',
                        '', '//',
                        A.ITEM_CATEGORY ) = DECODE( ASITEMCATEGORY,
                                                    NULL, '//',
                                                    '', '//',
                                                    ASITEMCATEGORY )
            AND NVL( A.ITEM_CATEGORY,
                     '0' ) = NVL( B.ITEM_CATEGORY,
                                  '0' )
            AND DECODE( A.ISSUE_LOCATION,
                        NULL, '//',
                        '', '//',
                        A.ISSUE_LOCATION ) = DECODE( ASISSUELOCATION,
                                                     NULL, '//',
                                                     '', '//',
                                                     ASISSUELOCATION )
            AND NVL( A.ISSUE_LOCATION,
                     '0' ) = NVL( B.ISSUE_LOCATION,
                                  '0' )
            AND DECODE( A.CALC_FLAG,
                        NULL, '//',
                        '', '//',
                        A.CALC_FLAG ) = DECODE( ASCALCULATIONMODE,
                                                NULL, '//',
                                                '', '//',
                                                ASCALCULATIONMODE )
            AND NVL( A.CALC_FLAG,
                     '0' ) = NVL( B.CALC_FLAG,
                                  '0' )
            AND DECODE( A.BOM_ITEM_TYPE,
                        NULL, '//',
                        '', '//',
                        A.BOM_ITEM_TYPE ) = DECODE( ASBOMITEMTYPE,
                                                    NULL, '//',
                                                    '', '//',
                                                    ASBOMITEMTYPE )
            AND NVL( A.BOM_ITEM_TYPE,
                     '0' ) = NVL( B.BOM_ITEM_TYPE,
                                  '0' )
            AND DECODE( A.OPERATIONAL_STEP,
                        NULL, '//',
                        '', '//',
                        A.OPERATIONAL_STEP ) = DECODE( ANOPERATIONALSTEP,
                                                       NULL, '//',
                                                       '', '//',
                                                       ANOPERATIONALSTEP )
            AND NVL( A.OPERATIONAL_STEP,
                     0 ) = NVL( B.OPERATIONAL_STEP,
                                0 )
            AND DECODE( A.MIN_QTY,
                        NULL, '//',
                        '', '//',
                        A.MIN_QTY ) = DECODE( ANMINIMUMQUANTITY,
                                              NULL, '//',
                                              '', '//',
                                              ANMINIMUMQUANTITY )
            AND NVL( A.MIN_QTY,
                     0 ) = NVL( B.MIN_QTY,
                                0 )
            AND DECODE( A.MAX_QTY,
                        NULL, '//',
                        '', '//',
                        A.MAX_QTY ) = DECODE( ANMAXIMUMQUANTITY,
                                              NULL, '//',
                                              '', '//',
                                              ANMAXIMUMQUANTITY )
            AND NVL( A.MAX_QTY,
                     0 ) = NVL( B.MAX_QTY,
                                0 )
            AND DECODE( A.CODE,
                        NULL, '//',
                        '', '//',
                        A.CODE ) = DECODE( ASCODE,
                                           NULL, '//',
                                           '', '//',
                                           ASCODE )
            AND NVL( A.MAX_QTY,
                     0 ) = NVL( B.MAX_QTY,
                                0 )
            AND DECODE( A.ALT_GROUP,
                        NULL, '//',
                        '', '//',
                        A.ALT_GROUP ) = DECODE( ASALTERNATIVEGROUP,
                                                NULL, '//',
                                                '', '//',
                                                ASALTERNATIVEGROUP )
            AND NVL( A.ALT_GROUP,
                     '0' ) = NVL( B.ALT_GROUP,
                                  '0' )
            AND DECODE( A.ALT_PRIORITY,
                        NULL, '//',
                        '', '//',
                        A.ALT_PRIORITY ) = DECODE( ANALTERNATIVEPRIORITY,
                                                   NULL, '//',
                                                   '', '//',
                                                   ANALTERNATIVEPRIORITY )
            AND NVL( A.ALT_PRIORITY,
                     0 ) = NVL( B.ALT_PRIORITY,
                                0 )
            AND DECODE( A.NUM_1,
                        NULL, '//',
                        '', '//',
                        A.NUM_1 ) = DECODE( ANNUMERIC1,
                                            NULL, '//',
                                            '', '//',
                                            ANNUMERIC1 )
            AND NVL( A.NUM_1,
                     0 ) = NVL( B.NUM_1,
                                0 )
            AND DECODE( A.NUM_2,
                        NULL, '//',
                        '', '//',
                        A.NUM_2 ) = DECODE( ANNUMERIC2,
                                            NULL, '//',
                                            '', '//',
                                            ANNUMERIC2 )
            AND NVL( A.NUM_2,
                     0 ) = NVL( B.NUM_2,
                                0 )
            AND DECODE( A.NUM_3,
                        NULL, '//',
                        '', '//',
                        A.NUM_3 ) = DECODE( ANNUMERIC3,
                                            NULL, '//',
                                            '', '//',
                                            ANNUMERIC3 )
            AND NVL( A.NUM_3,
                     0 ) = NVL( B.NUM_3,
                                0 )
            AND DECODE( A.NUM_4,
                        NULL, '//',
                        '', '//',
                        A.NUM_4 ) = DECODE( ANNUMERIC4,
                                            NULL, '//',
                                            '', '//',
                                            ANNUMERIC4 )
            AND NVL( A.NUM_4,
                     0 ) = NVL( B.NUM_4,
                                0 )
            AND DECODE( A.NUM_5,
                        NULL, '//',
                        '', '//',
                        A.NUM_5 ) = DECODE( ANNUMERIC5,
                                            NULL, '//',
                                            '', '//',
                                            ANNUMERIC5 )
            AND NVL( A.NUM_5,
                     0 ) = NVL( B.NUM_5,
                                0 )
            AND DECODE( A.CHAR_1,
                        NULL, '//',
                        '', '//',
                        A.CHAR_1 ) = DECODE( ASTEXT1,
                                             NULL, '//',
                                             '', '//',
                                             ASTEXT1 )
            AND NVL( A.CHAR_1,
                     '0' ) = NVL( B.CHAR_1,
                                  '0' )
            AND DECODE( A.CHAR_2,
                        NULL, '//',
                        '', '//',
                        A.CHAR_2 ) = DECODE( ASTEXT2,
                                             NULL, '//',
                                             '', '//',
                                             ASTEXT2 )
            AND NVL( A.CHAR_2,
                     '0' ) = NVL( B.CHAR_2,
                                  '0' )
            AND DECODE( A.CHAR_3,
                        NULL, '//',
                        '', '//',
                        A.CHAR_3 ) = DECODE( ASTEXT3,
                                             NULL, '//',
                                             '', '//',
                                             ASTEXT3 )
            AND NVL( A.CHAR_3,
                     '0' ) = NVL( B.CHAR_3,
                                  '0' )
            AND DECODE( A.CHAR_4,
                        NULL, '//',
                        '', '//',
                        A.CHAR_4 ) = DECODE( ASTEXT4,
                                             NULL, '//',
                                             '', '//',
                                             ASTEXT4 )
            AND NVL( A.CHAR_4,
                     '0' ) = NVL( B.CHAR_4,
                                  '0' )
            AND DECODE( A.CHAR_5,
                        NULL, '//',
                        '', '//',
                        A.CHAR_5 ) = DECODE( ASTEXT5,
                                             NULL, '//',
                                             '', '//',
                                             ASTEXT5 )
            AND NVL( A.CHAR_5,
                     '0' ) = NVL( B.CHAR_5,
                                  '0' )
            AND DECODE( A.DATE_1,
                        NULL, '//',
                        '', '//',
                        A.DATE_1 ) = DECODE( ADDATE1,
                                             NULL, '//',
                                             '', '//',
                                             ADDATE1 )
            AND DECODE( A.DATE_1,
                        NULL, '//',
                        '', '//',
                        A.DATE_1 ) = DECODE( B.DATE_1,
                                             NULL, '//',
                                             '', '//',
                                             B.DATE_1 )
            AND DECODE( A.DATE_2,
                        NULL, '//',
                        '', '//',
                        A.DATE_2 ) = DECODE( ADDATE2,
                                             NULL, '//',
                                             '', '//',
                                             ADDATE2 )
            AND DECODE( A.DATE_2,
                        NULL, '//',
                        '', '//',
                        A.DATE_2 ) = DECODE( B.DATE_2,
                                             NULL, '//',
                                             '', '//',
                                             B.DATE_2 )
            AND DECODE( F_CHH_DESCR( 1,
                                     A.CH_1,
                                     A.CH_REV_1 ),
                        NULL, '//',
                        '', '//',
                        F_CHH_DESCR( 1,
                                     A.CH_1,
                                     A.CH_REV_1 ) ) = DECODE( ASCHARACTERISTIC1,
                                                              NULL, '//',
                                                              '', '//',
                                                              ASCHARACTERISTIC1 )
            AND NVL( F_CHH_DESCR( 1,
                                  A.CH_1,
                                  A.CH_REV_1 ),
                     '0' ) = NVL( F_CHH_DESCR( 1,
                                               B.CH_1,
                                               B.CH_REV_1 ),
                                  '0' )
            AND DECODE( F_CHH_DESCR( 1,
                                     A.CH_2,
                                     A.CH_REV_2 ),
                        NULL, '//',
                        '', '//',
                        F_CHH_DESCR( 1,
                                     A.CH_2,
                                     A.CH_REV_2 ) ) = DECODE( ASCHARACTERISTIC2,
                                                              NULL, '//',
                                                              '', '//',
                                                              ASCHARACTERISTIC2 )
            AND NVL( F_CHH_DESCR( 1,
                                  A.CH_2,
                                  A.CH_REV_2 ),
                     '0' ) = NVL( F_CHH_DESCR( 1,
                                               B.CH_2,
                                               B.CH_REV_2 ),
                                  '0' )
            AND DECODE( F_CHH_DESCR( 1,
                                     A.CH_3,
                                     A.CH_REV_3 ),
                        NULL, '//',
                        '', '//',
                        F_CHH_DESCR( 1,
                                     A.CH_3,
                                     A.CH_REV_3 ) ) = DECODE( ASCHARACTERISTIC3,
                                                              NULL, '//',
                                                              '', '//',
                                                              ASCHARACTERISTIC3 )
            AND NVL( F_CHH_DESCR( 1,
                                  A.CH_3,
                                  A.CH_REV_3 ),
                     '0' ) = NVL( F_CHH_DESCR( 1,
                                               B.CH_3,
                                               B.CH_REV_3 ),
                                  '0' )
            AND DECODE( A.RELEVENCY_TO_COSTING,
                        NULL, '//',
                        '', '//',
                        A.RELEVENCY_TO_COSTING ) = DECODE( ANRELEVANCYTOCOSTING,
                                                           NULL, '//',
                                                           '', '//',
                                                           ANRELEVANCYTOCOSTING )
            AND NVL( A.RELEVENCY_TO_COSTING,
                     0 ) = NVL( B.RELEVENCY_TO_COSTING,
                                0 )
            AND DECODE( A.BULK_MATERIAL,
                        NULL, '//',
                        '', '//',
                        A.BULK_MATERIAL ) = DECODE( ANBULKMATERIAL,
                                                    NULL, '//',
                                                    '', '//',
                                                    ANBULKMATERIAL )
            AND NVL( A.BULK_MATERIAL,
                     0 ) = NVL( B.BULK_MATERIAL,
                                0 )
            AND DECODE( A.FIXED_QTY,
                        NULL, '//',
                        '', '//',
                        A.FIXED_QTY ) = DECODE( ANFIXEDQUANTITY,
                                                NULL, '//',
                                                '', '//',
                                                ANFIXEDQUANTITY )
            AND NVL( A.FIXED_QTY,
                     0 ) = NVL( B.FIXED_QTY,
                                0 )
            AND DECODE( A.BOOLEAN_1,
                        NULL, '//',
                        '', '//',
                        A.BOOLEAN_1 ) = DECODE( ANBOOLEAN1,
                                                NULL, '//',
                                                '', '//',
                                                ANBOOLEAN1 )
            AND NVL( A.BOOLEAN_1,
                     0 ) = NVL( B.BOOLEAN_1,
                                0 )
            AND DECODE( A.BOOLEAN_2,
                        NULL, '//',
                        '', '//',
                        A.BOOLEAN_2 ) = DECODE( ANBOOLEAN2,
                                                NULL, '//',
                                                '', '//',
                                                ANBOOLEAN2 )
            AND NVL( A.BOOLEAN_2,
                     0 ) = NVL( B.BOOLEAN_2,
                                0 )
            AND DECODE( A.BOOLEAN_3,
                        NULL, '//',
                        '', '//',
                        A.BOOLEAN_3 ) = DECODE( ANBOOLEAN3,
                                                NULL, '//',
                                                '', '//',
                                                ANBOOLEAN3 )
            AND NVL( A.BOOLEAN_3,
                     0 ) = NVL( B.BOOLEAN_3,
                                0 )
            AND DECODE( A.BOOLEAN_4,
                        NULL, '//',
                        '', '//',
                        A.BOOLEAN_4 ) = DECODE( ANBOOLEAN4,
                                                NULL, '//',
                                                '', '//',
                                                ANBOOLEAN4 )
            AND NVL( A.BOOLEAN_4,
                     0 ) = NVL( B.BOOLEAN_4,
                                0 )
            AND DECODE( A.INTL_EQUIVALENT,
                        NULL, '//',
                        '', '//',
                        A.INTL_EQUIVALENT ) = DECODE( ASINTERNATIONALEQUIVALENT,
                                                      NULL, '//',
                                                      '', '//',
                                                      ASINTERNATIONALEQUIVALENT )
            AND NVL( A.INTL_EQUIVALENT,
                     '0' ) = NVL( B.INTL_EQUIVALENT,
                                  '0' );

         IF LNCOUNT > 0
         THEN
            RETURN 0;   
         ELSE
            RETURN 3;   
         END IF;
      ELSE
         RETURN 3;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RAISE_APPLICATION_ERROR( -20000,
                                  SQLERRM );
   END GETCOMPAREBISTATUS;


   FUNCTION GETCOMPARELOCALISEDBISTATUS

   (
      ANFROM                     IN       IAPITYPE.ID_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE,
      ASCOMPONENTPART            IN       IAPITYPE.PARTNO_TYPE,
      ANCOMPONENTREVISION        IN       IAPITYPE.REVISION_TYPE,
      ASCOMPONENTPLANT           IN       IAPITYPE.PLANT_TYPE,
      ANITEMNUMBER               IN       IAPITYPE.BOMITEMNUMBER_TYPE,
      ANQUANTITY                 IN       IAPITYPE.BOMQUANTITY_TYPE,
      ASUOM                      IN       IAPITYPE.DESCRIPTION_TYPE,
      ANYIELD                    IN       IAPITYPE.BOMYIELD_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LNCOUNT                       IAPITYPE.ID_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetCompareLocalisedBIStatus';
   BEGIN
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM BOM_ITEM
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANT
         AND ALTERNATIVE = ANALTERNATIVE
         AND BOM_USAGE = ANUSAGE
         AND F_GET_INTL_PART( COMPONENT_PART ) = ASCOMPONENTPART;

      IF LNCOUNT = 0
      THEN
         RETURN ANFROM;
      ELSIF LNCOUNT = 1
      THEN
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM BOM_ITEM
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PLANT = ASPLANT
            AND ALTERNATIVE = ANALTERNATIVE
            AND BOM_USAGE = ANUSAGE
            AND COMPONENT_PART = ASCOMPONENTPART
            AND DECODE( COMPONENT_REVISION,
                        NULL, '//',
                        '', '//',
                        COMPONENT_REVISION ) = DECODE( ANCOMPONENTREVISION,
                                                       NULL, '//',
                                                       '', '//',
                                                       ANCOMPONENTREVISION )
            AND DECODE( COMPONENT_PLANT,
                        NULL, '//',
                        '', '//',
                        COMPONENT_PLANT ) = DECODE( ASCOMPONENTPLANT,
                                                    NULL, '//',
                                                    '', '//',
                                                    ASCOMPONENTPLANT )
            AND DECODE( ITEM_NUMBER,
                        NULL, '//',
                        '', '//',
                        ITEM_NUMBER ) = DECODE( ANITEMNUMBER,
                                                NULL, '//',
                                                '', '//',
                                                ANITEMNUMBER )
            AND DECODE( QUANTITY,
                        NULL, '//',
                        '', '//',
                        QUANTITY ) = DECODE( ANQUANTITY,
                                             NULL, '//',
                                             '', '//',
                                             ANQUANTITY )
            AND DECODE( UOM,
                        NULL, '//',
                        '', '//',
                        UOM ) = DECODE( ASUOM,
                                        NULL, '//',
                                        '', '//',
                                        ASUOM )
            AND DECODE( YIELD,
                        NULL, '//',
                        '', '//',
                        YIELD ) = DECODE( ANYIELD,
                                          NULL, '//',
                                          '', '//',
                                          ANYIELD );

         IF LNCOUNT > 0
         THEN
            RETURN 0;   
         ELSE
            RETURN 3;   
         END IF;
      ELSE
         RETURN 3;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RAISE_APPLICATION_ERROR( -20000,
                                  SQLERRM );
   END GETCOMPARELOCALISEDBISTATUS;


   FUNCTION GETCOMPARELOCALISEDBHSTATUS

   (
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE,
      ASINTLPLANT                IN       IAPITYPE.PLANT_TYPE,
      ANINTLALTERNATIVE          IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANINTLUSAGE                IN       IAPITYPE.BOMUSAGE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS





















      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetCompareLocalisedBHStatus';
      LNCHECK                       IAPITYPE.ID_TYPE;
      LSINTPARTNO                   IAPITYPE.PARTNO_TYPE;
      LIINT_PART_REV                IAPITYPE.REVISION_TYPE;
   BEGIN

      SELECT INT_PART_NO,
             INT_PART_REV
        INTO LSINTPARTNO,
             LIINT_PART_REV
        FROM SPECIFICATION_HEADER
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION;

      IF LSINTPARTNO IS NULL
      THEN   
         RETURN -1;
      END IF;

      SELECT COUNT( * )   
        INTO LNCHECK
        FROM ( ( SELECT F_GET_INTL_PART( I.COMPONENT_PART ),
                        TRUNC(  (   I.QUANTITY
                                  / H.BASE_QUANTITY ),
                               6 )
                  FROM BOM_ITEM I,
                       BOM_HEADER H
                 WHERE I.PART_NO = H.PART_NO
                   AND I.REVISION = H.REVISION
                   AND I.ALTERNATIVE = H.ALTERNATIVE
                   AND I.BOM_USAGE = H.BOM_USAGE
                   AND I.PLANT = H.PLANT
                   AND I.PART_NO = ASPARTNO
                   AND I.REVISION = ANREVISION
                   AND I.ALTERNATIVE = ANALTERNATIVE
                   AND I.BOM_USAGE = ANUSAGE
                   AND I.PLANT = ASPLANT
                MINUS
                SELECT I.COMPONENT_PART,
                       TRUNC(  (   I.QUANTITY
                                 / H.BASE_QUANTITY ),
                              6 )
                  FROM BOM_ITEM I,
                       BOM_HEADER H
                 WHERE I.PART_NO = H.PART_NO
                   AND I.REVISION = H.REVISION
                   AND I.ALTERNATIVE = H.ALTERNATIVE
                   AND I.BOM_USAGE = H.BOM_USAGE
                   AND I.PLANT = H.PLANT
                   AND I.PART_NO = LSINTPARTNO
                   AND I.REVISION = LIINT_PART_REV
                   AND I.PLANT = ASINTLPLANT
                   AND I.ALTERNATIVE = ANINTLALTERNATIVE
                   AND I.BOM_USAGE = ANINTLUSAGE )
              UNION
              ( SELECT I.COMPONENT_PART,
                       TRUNC(  (   I.QUANTITY
                                 / H.BASE_QUANTITY ),
                              6 )
                 FROM BOM_ITEM I,
                      BOM_HEADER H
                WHERE I.PART_NO = H.PART_NO
                  AND I.REVISION = H.REVISION
                  AND I.ALTERNATIVE = H.ALTERNATIVE
                  AND I.BOM_USAGE = H.BOM_USAGE
                  AND I.PLANT = H.PLANT
                  AND I.PART_NO = LSINTPARTNO
                  AND I.REVISION = LIINT_PART_REV
                  AND I.PLANT = ASINTLPLANT
                  AND I.ALTERNATIVE = ANINTLALTERNATIVE
                  AND I.BOM_USAGE = ANINTLUSAGE
               MINUS
               SELECT F_GET_INTL_PART( I.COMPONENT_PART ),
                      TRUNC(  (   I.QUANTITY
                                / H.BASE_QUANTITY ),
                             6 )
                 FROM BOM_ITEM I,
                      BOM_HEADER H
                WHERE I.PART_NO = H.PART_NO
                  AND I.REVISION = H.REVISION
                  AND I.ALTERNATIVE = H.ALTERNATIVE
                  AND I.BOM_USAGE = H.BOM_USAGE
                  AND I.PLANT = H.PLANT
                  AND I.PART_NO = ASPARTNO
                  AND I.REVISION = ANREVISION
                  AND I.ALTERNATIVE = ANALTERNATIVE
                  AND I.BOM_USAGE = ANUSAGE
                  AND I.PLANT = ASPLANT ) );

      IF LNCHECK = 0
      THEN
         RETURN 0;
      ELSE
         RETURN 1;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN -1;
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RAISE_APPLICATION_ERROR( -20000,
                                  SQLERRM );
   END GETCOMPARELOCALISEDBHSTATUS;


   FUNCTION GETCITOTAL

   (
      ANUNIQUEID                 IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.NUMVAL_TYPE
   IS
      
      
      
      
      
      
      LNCOUNT                       IAPITYPE.ID_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetCITotal';
      LNTOTQTY                      IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );




      SELECT SUM( QTY )
        INTO LNTOTQTY
        FROM ( SELECT SUM(    (   COMPONENT_CALC_QTY
                                * ING_QTY )
                           / 100 ) QTY
                FROM ITINGEXPLOSION
               WHERE BOM_EXP_NO = ANUNIQUEID );

      RETURN ROUND( LNTOTQTY,
                    4 );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RAISE_APPLICATION_ERROR( -20000,
                                  SQLERRM );
   END GETCITOTAL;


   FUNCTION GETCISUM

   (
      ANINGREDIENT               IN       IAPITYPE.ID_TYPE,
      ANUNIQUEID                 IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.NUMVAL_TYPE
   IS
      
      
      
      
      
      
      LNCOUNT                       IAPITYPE.ID_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetCISum';
      LNSUMQTY                      IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );




      SELECT SUM( QTY )
        INTO LNSUMQTY
        FROM ( SELECT SUM(    (   COMPONENT_CALC_QTY
                                * ING_QTY )
                           / 100 ) QTY
                FROM ITINGEXPLOSION
               WHERE BOM_EXP_NO = ANUNIQUEID
                 AND INGREDIENT = ANINGREDIENT );

      RETURN ROUND( LNSUMQTY,
                    4 );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RAISE_APPLICATION_ERROR( -20000,
                                  SQLERRM );
   END GETCISUM;


   FUNCTION GETCIPERC

   (
      ANINGREDIENT               IN       IAPITYPE.ID_TYPE,
      ANUNIQUEID                 IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.NUMVAL_TYPE
   IS
      
      
      
      
      
      
      LNCOUNT                       IAPITYPE.ID_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetCIPerc';
      LNPERC                        IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );



      LNPERC :=   (   GETCISUM( ANINGREDIENT,
                                ANUNIQUEID )
                    / GETCITOTAL( ANUNIQUEID ) )
                * 100;
      RETURN( ROUND( LNPERC,
                     4 ) );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RAISE_APPLICATION_ERROR( -20000,
                                  SQLERRM );
   END GETCIPERC;


   FUNCTION GETCOMPARECILISTSTATUS

   (
      ANFROM                     IN       IAPITYPE.ID_TYPE,
      ANINGREDIENT               IN       IAPITYPE.ID_TYPE,
      ANUNIQUEID1                IN       IAPITYPE.ID_TYPE,
      ASCHEMICALINGREDIENT1      IN       IAPITYPE.STRINGVAL_TYPE,
      ANUNIQUEID2                IN       IAPITYPE.ID_TYPE,
      ASCHEMICALINGREDIENT2      IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ID_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LNCOUNT                       IAPITYPE.ID_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetCompareCIListStatus';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ANINGREDIENT < 0
      THEN
         RETURN 0;
      END IF;




      SELECT COUNT( * )
        INTO LNCOUNT
        FROM ITINGEXPLOSION
       WHERE INGREDIENT = ANINGREDIENT
         AND BOM_EXP_NO = ANUNIQUEID1;

      IF LNCOUNT = 0
      THEN
         RETURN ANFROM;
      END IF;

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM ITINGEXPLOSION
       WHERE INGREDIENT = ANINGREDIENT
         AND BOM_EXP_NO = ANUNIQUEID2;

      IF LNCOUNT = 0
      THEN
         RETURN ANFROM;
      END IF;

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM ITINGEXPLOSION A,
             ITINGEXPLOSION B
       WHERE A.BOM_EXP_NO = ANUNIQUEID2
         AND A.INGREDIENT = ANINGREDIENT
         AND B.BOM_EXP_NO = ANUNIQUEID1
         AND B.INGREDIENT = ANINGREDIENT
         AND A.DESCRIPTION = B.DESCRIPTION
         AND GETCISUM( ANINGREDIENT,
                       ANUNIQUEID1 ) = GETCISUM( ANINGREDIENT,
                                                 ANUNIQUEID2 )
         AND GETCIPERC( ANINGREDIENT,
                        ANUNIQUEID1 ) = GETCIPERC( ANINGREDIENT,
                                                   ANUNIQUEID2 )
         AND A.COMPONENT_UOM = B.COMPONENT_UOM
         AND (     (     ASCHEMICALINGREDIENT1 = 'C'
                     AND ASCHEMICALINGREDIENT2 = 'C'
                     AND A.ACTIVE = B.ACTIVE )
               OR (    ASCHEMICALINGREDIENT1 = 'I'
                    OR ASCHEMICALINGREDIENT2 = 'I' ) );

      IF LNCOUNT > 0
      THEN
         RETURN 0;   
      ELSE
         RETURN 3;   
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RAISE_APPLICATION_ERROR( -20000,
                                  SQLERRM );
   END GETCOMPARECILISTSTATUS;


   FUNCTION GETBOMHEADERS

   (
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE DEFAULT NULL,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE DEFAULT NULL,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE DEFAULT NULL,
      ASPARTNO2                  IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION2                IN       IAPITYPE.REVISION_TYPE,
      ASPLANT2                   IN       IAPITYPE.PLANT_TYPE DEFAULT NULL,
      ANALTERNATIVE2             IN       IAPITYPE.BOMALTERNATIVE_TYPE DEFAULT NULL,
      ANUSAGE2                   IN       IAPITYPE.BOMUSAGE_TYPE DEFAULT NULL,
      AQBOMS                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetBomHeaders';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSSQL                         VARCHAR2( 8192 );
      LSSQLBHKEY                    VARCHAR2( 1000 );
      LSSQLNOCOMP                   VARCHAR2( 4000 );
      LSSQLCOMP                     VARCHAR2( 4000 );
      LSPARTNO                      IAPITYPE.PARTNO_TYPE := NULL;
      LNREVISION                    IAPITYPE.REVISION_TYPE := NULL;



   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQLBHKEY :=
            IAPICONSTANTCOLUMN.BOMHEADERCMPSTATUSCOL
         || ', a.PART_NO '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', a.REVISION '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', a.PLANT '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', a.ALTERNATIVE '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', a.Bom_USAGE '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', f_bu_descr(a.Bom_USAGE) '
         || IAPICONSTANTCOLUMN.BOMUSAGEDESCRIPTIONCOL
         || ',';
      LSSQLCOMP :=
            'DECODE( c.BASE_UOM,d.BASE_UOM, 0, 1 ) '
         || IAPICONSTANTCOLUMN.UOMCMPSTATUSCOL
         || ', c.BASE_UOM '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ', DECODE( a.BASE_QUANTITY, b.BASE_QUANTITY, 0, 1 ) '
         || IAPICONSTANTCOLUMN.BASEQUANTITYCMPSTATUSCOL
         || ', a.BASE_QUANTITY '
         || IAPICONSTANTCOLUMN.BASEQUANTITYCOL
         || ', DECODE( a.DESCRIPTION, b.DESCRIPTION, 0, 1 ) '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCMPSTATUSCOL
         || ', a.DESCRIPTION '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ', DECODE( a.YIELD, b.YIELD, 0, 1 ) '
         || IAPICONSTANTCOLUMN.YIELDCMPSTATUSCOL
         || ', a.YIELD '
         || IAPICONSTANTCOLUMN.YIELDCOL
         || ', DECODE( a.CONV_FACTOR,  b.CONV_FACTOR, 0, 1 ) '
         || IAPICONSTANTCOLUMN.CONVERSIONFACTORCMPSTATUSCOL
         || ', Round(a.CONV_FACTOR,10) '
         || IAPICONSTANTCOLUMN.CONVERSIONFACTORCOL
         || ', DECODE( a.TO_UNIT, b.TO_UNIT, 0, 1 ) '
         || IAPICONSTANTCOLUMN.TOUNITCMPSTATUSCOL
         || ', a.TO_UNIT '
         || IAPICONSTANTCOLUMN.TOUNITCOL
         || ', DECODE( a.CALC_FLAG,  b.CALC_FLAG, 0, 1 ) '
         || IAPICONSTANTCOLUMN.CALCULATIONMODECMPSTATUSCOL
         || ', a.CALC_FLAG '
         || IAPICONSTANTCOLUMN.CALCULATIONMODECOL
         || ', DECODE( a.Bom_Type, b.Bom_Type, 0, 1 ) '
         || IAPICONSTANTCOLUMN.BOMTYPECMPSTATUSCOL
         || ', a.Bom_Type '
         || IAPICONSTANTCOLUMN.BOMTYPECOL
         || ', DECODE( a.MIN_QTY, b.MIN_QTY, 0, 1 ) '
         || IAPICONSTANTCOLUMN.MINIMUMQUANTITYCMPSTATUSCOL
         || ', a.MIN_QTY '
         || IAPICONSTANTCOLUMN.MINIMUMQUANTITYCOL
         || ', DECODE( a.MAX_QTY,  b.MAX_QTY, 0, 1 ) '
         || IAPICONSTANTCOLUMN.MAXIMUMQUANTITYCMPSTATUSCOL
         || ', a.MAX_QTY '
         || IAPICONSTANTCOLUMN.MAXIMUMQUANTITYCOL
         || ', DECODE( a.PLANT_EFFECTIVE_DATE, b.PLANT_EFFECTIVE_DATE, 0, 1 ) '
         || IAPICONSTANTCOLUMN.PLANTEFFECTIVEDATECMPSTATUSCOL
         || ', a.PLANT_EFFECTIVE_DATE '
         || IAPICONSTANTCOLUMN.PLANTEFFECTIVEDATECOL
         || ' FROM Bom_HEADER a, Bom_HEADER b, PART c, PART d, PART_PLANT pp ';
      LSSQLNOCOMP :=
            '0 '
         || IAPICONSTANTCOLUMN.UOMCMPSTATUSCOL
         || ', c.BASE_UOM '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ', 0 '
         || IAPICONSTANTCOLUMN.BASEQUANTITYCMPSTATUSCOL
         || ', a.BASE_QUANTITY '
         || IAPICONSTANTCOLUMN.BASEQUANTITYCOL
         || ', 0 '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCMPSTATUSCOL
         || ', a.DESCRIPTION '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ', 0 '
         || IAPICONSTANTCOLUMN.YIELDCMPSTATUSCOL
         || ', a.YIELD '
         || IAPICONSTANTCOLUMN.YIELDCOL
         || ', 0 '
         || IAPICONSTANTCOLUMN.CONVERSIONFACTORCMPSTATUSCOL
         || ', round(a.CONV_FACTOR,10) '
         || IAPICONSTANTCOLUMN.CONVERSIONFACTORCOL
         || ', 0 '
         || IAPICONSTANTCOLUMN.TOUNITCMPSTATUSCOL
         || ', a.TO_UNIT '
         || IAPICONSTANTCOLUMN.TOUNITCOL
         || ', 0 '
         || IAPICONSTANTCOLUMN.CALCULATIONMODECMPSTATUSCOL
         || ', a.CALC_FLAG '
         || IAPICONSTANTCOLUMN.CALCULATIONMODECOL
         || ', 0 '
         || IAPICONSTANTCOLUMN.BOMTYPECMPSTATUSCOL
         || ', a.Bom_Type '
         || IAPICONSTANTCOLUMN.BOMTYPECOL
         || ', 0 '
         || IAPICONSTANTCOLUMN.MINIMUMQUANTITYCMPSTATUSCOL
         || ', a.MIN_QTY '
         || IAPICONSTANTCOLUMN.MINIMUMQUANTITYCOL
         || ', 0 '
         || IAPICONSTANTCOLUMN.MAXIMUMQUANTITYCMPSTATUSCOL
         || ', a.MAX_QTY '
         || IAPICONSTANTCOLUMN.MAXIMUMQUANTITYCOL
         || ', 0 '
         || IAPICONSTANTCOLUMN.PLANTEFFECTIVEDATECMPSTATUSCOL
         || ', a.PLANT_EFFECTIVE_DATE '
         || IAPICONSTANTCOLUMN.PLANTEFFECTIVEDATECOL
         || ' FROM Bom_HEADER a, PART c, PART_PLANT pp ';
      LSSQL :=
            'SELECT iapiCompare.GetCompareBHStatus(1, :asPartNo2, :anRevision2, a.PLANT, a.ALTERNATIVE, a.Bom_USAGE, '
         || 'a.part_no, a.revision, b.PLANT, b.ALTERNATIVE, b.Bom_USAGE ) '
         || LSSQLBHKEY
         || LSSQLCOMP
         || ' WHERE a.part_no = :asPartNo'
         || ' AND a.revision = :anRevision'
         || ' AND (a.PLANT = :asPlant OR :asPlant IS NULL)'
         || ' AND (a.ALTERNATIVE = :anAlternative OR :anAlternative IS NULL)'
         || ' AND (a.Bom_USAGE = :anUsage OR :anUsage IS NULL)'
         || ' AND b.part_no = :asPartNo2'
         || ' AND b.revision = :anRevision2'
         || ' AND (b.PLANT = :asPlant2 OR :asPlant2 IS NULL)'
         || ' AND (b.ALTERNATIVE = :anAlternative2 OR :anAlternative2 IS NULL)'
         || ' AND (b.Bom_USAGE = :anUsage2 OR :anUsage2 IS NULL)'
         || ' AND a.part_no = c.part_no'
         || ' AND b.part_no = d.part_no'
         || ' AND a.PLANT = b.PLANT'
         || ' AND a.ALTERNATIVE = b.ALTERNATIVE'
         || ' AND a.Bom_USAGE = b.Bom_USAGE'
         || ' AND pp.PLANT = a.PLANT'
         || ' AND pp.PART_NO = a.PART_NO';

      IF ( AQBOMS%ISOPEN )
      THEN
         CLOSE AQBOMS;
      END IF;




      OPEN AQBOMS FOR LSSQL
      USING ASPARTNO2,
            ANREVISION2,
            LSPARTNO,   
            LNREVISION,   
            ASPLANT,
            ASPLANT,
            ANALTERNATIVE,
            ANALTERNATIVE,
            ANUSAGE,
            ANUSAGE,
            ASPARTNO2,
            ANREVISION2,
            ASPLANT2,
            ASPLANT2,
            ANALTERNATIVE2,
            ANALTERNATIVE2,
            ANUSAGE2,
            ANUSAGE2;

      LNRETVAL := IAPISPECIFICATIONACCESS.GETVIEWACCESS( ASPARTNO,
                                                         ANREVISION,
                                                         LNACCESS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF LNACCESS = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOVIEWACCESS,
                                                    ASPARTNO,
                                                    ANREVISION );
      END IF;

      LNRETVAL := IAPISPECIFICATIONACCESS.GETVIEWACCESS( ASPARTNO2,
                                                         ANREVISION2,
                                                         LNACCESS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF LNACCESS = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOVIEWACCESS,
                                                    ASPARTNO2,
                                                    ANREVISION2 );
      END IF;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.VIEWBOMALLOWED = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOVIEWBOMACCESS,
                                                    IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );
      END IF;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
      THEN   
         LSSQL :=    LSSQL
                  || ' AND pp.PLANT_ACCESS = ''Y'''
                  || ' AND a.PLANT IN (SELECT PLANT FROM ITUP WHERE USER_ID = :UserId)';
      END IF;

      LSSQL :=
            LSSQL
         || ' UNION ALL '
         || ' SELECT iapiCompare.GetCompareBHStatus( 2, :asPartNo, :anRevision, a.PLANT, a.ALTERNATIVE, a.Bom_USAGE, '
         || 'a.part_no, a.revision, b.PLANT, b.ALTERNATIVE, b.Bom_USAGE ) '
         || LSSQLBHKEY
         || LSSQLCOMP
         || ' WHERE a.part_no = :asPartNo2'
         || ' AND a.revision = :anRevision2'
         || ' AND (a.PLANT = :asPlant2 OR :asPlant2 IS NULL)'
         || ' AND (a.ALTERNATIVE = :anAlternative2 OR :anAlternative2 IS NULL)'
         || ' AND (a.Bom_USAGE = :anUsage2 OR :anUsage2 IS NULL)'
         || ' AND b.part_no = :asPartNo'
         || ' AND b.revision = :anRevision'
         || ' AND (b.PLANT = :asPlant OR :asPlant IS NULL)'
         || ' AND (b.ALTERNATIVE = :anAlternative OR :anAlternative IS NULL)'
         || ' AND (b.Bom_USAGE = :anUsage OR :anUsage IS NULL)'
         || ' AND a.part_no = c.part_no'
         || ' AND b.part_no = d.part_no'
         || ' AND a.PLANT = b.PLANT'
         || ' AND a.ALTERNATIVE = b.ALTERNATIVE'
         || ' AND a.Bom_USAGE = b.Bom_USAGE'
         || ' AND pp.PLANT = a.PLANT'
         || ' AND pp.PART_NO = a.PART_NO';

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
      THEN   
         LSSQL :=    LSSQL
                  || ' AND pp.PLANT_ACCESS = ''Y'''
                  || ' AND a.PLANT IN (SELECT PLANT FROM ITUP WHERE USER_ID = :UserId)';
      END IF;

      LSSQL :=
            LSSQL
         || ' UNION ALL '
         || ' SELECT 1 '
         || LSSQLBHKEY
         || LSSQLNOCOMP
         || ' WHERE a.part_no = :asPartNo'
         || ' AND a.revision = :anRevision'
         || ' AND (a.PLANT = :asPlant OR :asPlant IS NULL )'
         || ' AND (a.ALTERNATIVE = :anAlternative OR :anAlternative IS NULL )'
         || ' AND (a.Bom_USAGE = :anUsage OR :anUsage IS NULL )'
         || ' AND a.part_no = c.part_no'
         || ' AND NOT EXISTS('
         || ' SELECT part_no'
         || ' FROM Bom_header'
         || ' WHERE part_no = :asPartNo2'
         || ' AND revision = :anRevision2'
         || ' AND (PLANT = :asPlant2 OR :asPlant2 IS NULL )'
         || ' AND (ALTERNATIVE = :anAlternative2 OR :anAlternative2 IS NULL )'
         || ' AND (Bom_USAGE = :anUsage2 OR :anUsage2 IS NULL )'
         || ' AND plant = a.plant'
         || ' AND alternative = a.alternative'
         || ' AND Bom_usage = a.Bom_usage)'
         || ' AND pp.PLANT = a.PLANT'
         || ' AND pp.PART_NO = a.PART_NO';

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
      THEN   
         LSSQL :=    LSSQL
                  || ' AND pp.PLANT_ACCESS = ''Y'''
                  || ' AND a.PLANT IN (SELECT PLANT FROM ITUP WHERE USER_ID = :UserId)';
      END IF;

      LSSQL :=
            LSSQL
         || ' UNION ALL '
         || ' SELECT 2 '
         || LSSQLBHKEY
         || LSSQLNOCOMP
         || ' WHERE a.part_no = :asPartNo2'
         || ' AND a.revision = :anRevision2'
         || ' AND (a.PLANT = :asPlant2 OR :asPlant2 IS NULL)'
         || ' AND (a.ALTERNATIVE = :anAlternative2 OR :anAlternative2 IS NULL)'
         || ' AND (a.Bom_USAGE = :anUsage2 OR :anUsage2 IS NULL)'
         || ' AND a.part_no = c.part_no'
         || ' AND NOT EXISTS('
         || ' SELECT part_no'
         || ' FROM Bom_header'
         || ' WHERE part_no = :asPartNo'
         || ' AND revision = :anRevision'
         || ' AND (PLANT = :asPlant OR :asPlant IS NULL)'
         || ' AND (ALTERNATIVE = :anAlternative OR :anAlternative IS NULL)'
         || ' AND (Bom_USAGE = :anUsage OR :anUsage IS NULL)'
         || ' AND plant = a.plant'
         || ' AND alternative = a.alternative'
         || ' AND Bom_usage = a.Bom_usage)'
         || ' AND pp.PLANT = a.PLANT'
         || ' AND pp.PART_NO = a.PART_NO';

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
      THEN   
         LSSQL :=    LSSQL
                  || ' AND pp.PLANT_ACCESS = ''Y'''
                  || ' AND a.PLANT IN (SELECT PLANT FROM ITUP WHERE USER_ID = :UserId)';
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY 2, 3, 4, 5, 6';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
      THEN
         OPEN AQBOMS FOR LSSQL
         USING ASPARTNO2,
               ANREVISION2,
               ASPARTNO,
               ANREVISION,
               ASPLANT,
               ASPLANT,
               ANALTERNATIVE,
               ANALTERNATIVE,
               ANUSAGE,
               ANUSAGE,
               ASPARTNO2,
               ANREVISION2,
               ASPLANT2,
               ASPLANT2,
               ANALTERNATIVE2,
               ANALTERNATIVE2,
               ANUSAGE2,
               ANUSAGE2,
               IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
               ASPARTNO,
               ANREVISION,
               ASPARTNO2,
               ANREVISION2,
               ASPLANT2,
               ASPLANT2,
               ANALTERNATIVE2,
               ANALTERNATIVE2,
               ANUSAGE2,
               ANUSAGE2,
               ASPARTNO,
               ANREVISION,
               ASPLANT,
               ASPLANT,
               ANALTERNATIVE,
               ANALTERNATIVE,
               ANUSAGE,
               ANUSAGE,
               IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
               ASPARTNO,
               ANREVISION,
               ASPLANT,
               ASPLANT,
               ANALTERNATIVE,
               ANALTERNATIVE,
               ANUSAGE,
               ANUSAGE,
               ASPARTNO2,
               ANREVISION2,
               ASPLANT2,
               ASPLANT2,
               ANALTERNATIVE2,
               ANALTERNATIVE2,
               ANUSAGE2,
               ANUSAGE2,
               IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
               ASPARTNO2,
               ANREVISION2,
               ASPLANT2,
               ASPLANT2,
               ANALTERNATIVE2,
               ANALTERNATIVE2,
               ANUSAGE2,
               ANUSAGE2,
               ASPARTNO,
               ANREVISION,
               ASPLANT,
               ASPLANT,
               ANALTERNATIVE,
               ANALTERNATIVE,
               ANUSAGE,
               ANUSAGE,
               IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
      ELSE
         OPEN AQBOMS FOR LSSQL
         USING ASPARTNO2,
               ANREVISION2,
               ASPARTNO,
               ANREVISION,
               ASPLANT,
               ASPLANT,
               ANALTERNATIVE,
               ANALTERNATIVE,
               ANUSAGE,
               ANUSAGE,
               ASPARTNO2,
               ANREVISION2,
               ASPLANT2,
               ASPLANT2,
               ANALTERNATIVE2,
               ANALTERNATIVE2,
               ANUSAGE2,
               ANUSAGE2,
               ASPARTNO,
               ANREVISION,
               ASPARTNO2,
               ANREVISION2,
               ASPLANT2,
               ASPLANT2,
               ANALTERNATIVE2,
               ANALTERNATIVE2,
               ANUSAGE2,
               ANUSAGE2,
               ASPARTNO,
               ANREVISION,
               ASPLANT,
               ASPLANT,
               ANALTERNATIVE,
               ANALTERNATIVE,
               ANUSAGE,
               ANUSAGE,
               ASPARTNO,
               ANREVISION,
               ASPLANT,
               ASPLANT,
               ANALTERNATIVE,
               ANALTERNATIVE,
               ANUSAGE,
               ANUSAGE,
               ASPARTNO2,
               ANREVISION2,
               ASPLANT2,
               ASPLANT2,
               ANALTERNATIVE2,
               ANALTERNATIVE2,
               ANUSAGE2,
               ANUSAGE2,
               ASPARTNO2,
               ANREVISION2,
               ASPLANT2,
               ASPLANT2,
               ANALTERNATIVE2,
               ANALTERNATIVE2,
               ANUSAGE2,
               ANUSAGE2,
               ASPARTNO,
               ANREVISION,
               ASPLANT,
               ASPLANT,
               ANALTERNATIVE,
               ANALTERNATIVE,
               ANUSAGE,
               ANUSAGE;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETBOMHEADERS;


   FUNCTION GETBOMITEMS

   (
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE DEFAULT NULL,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE DEFAULT NULL,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE DEFAULT NULL,
      ASPARTNO2                  IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION2                IN       IAPITYPE.REVISION_TYPE,
      ASPLANT2                   IN       IAPITYPE.PLANT_TYPE DEFAULT NULL,
      ANALTERNATIVE2             IN       IAPITYPE.BOMALTERNATIVE_TYPE DEFAULT NULL,
      ANUSAGE2                   IN       IAPITYPE.BOMUSAGE_TYPE DEFAULT NULL,
      AQBOMS                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetBomItems';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSSQL                         VARCHAR2( 32000 );
      LSPARTNO                      IAPITYPE.PARTNO_TYPE := NULL;
      LNREVISION                    IAPITYPE.REVISION_TYPE := NULL;



   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=
            'SELECT '
         || 'max('
         || IAPICONSTANTCOLUMN.BOMITEMCMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.BOMITEMCMPSTATUSCOL
         || ', '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ','
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ','
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ','
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ','
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ','
         || IAPICONSTANTCOLUMN.ITEMNUMBERCOL
         || ','
         || IAPICONSTANTCOLUMN.COMPONENTPARTNOCOL
         || ','
         || 'max('
         || IAPICONSTANTCOLUMN.COMPONENTREVISIONCMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.COMPONENTREVISIONCMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.COMPONENTREVISIONCOL
         || ') '
         || IAPICONSTANTCOLUMN.COMPONENTREVISIONCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.COMPONENTDESCRIPTIONCOL
         || ') '
         || IAPICONSTANTCOLUMN.COMPONENTDESCRIPTIONCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.COMPONENTPLANTCMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.COMPONENTPLANTCMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.COMPONENTPLANTCOL
         || ') '
         || IAPICONSTANTCOLUMN.COMPONENTPLANTCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.QUANTITYCMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.QUANTITYCMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.QUANTITYCOL
         || ') '
         || IAPICONSTANTCOLUMN.QUANTITYCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.UOMCMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.UOMCMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.UOMCOL
         || ') '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.CONVERSIONFACTORCMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.CONVERSIONFACTORCMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.CONVERSIONFACTORCOL
         || ') '
         || IAPICONSTANTCOLUMN.CONVERSIONFACTORCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.TOUNITCMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.TOUNITCMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.TOUNITCOL
         || ') '
         || IAPICONSTANTCOLUMN.TOUNITCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.YIELDCMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.YIELDCMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.YIELDCOL
         || ') '
         || IAPICONSTANTCOLUMN.YIELDCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.ASSEMBLYSCRAPCMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.ASSEMBLYSCRAPCMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.ASSEMBLYSCRAPCOL
         || ') '
         || IAPICONSTANTCOLUMN.ASSEMBLYSCRAPCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.COMPONENTSCRAPCMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.COMPONENTSCRAPCMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.COMPONENTSCRAPCOL
         || ') '
         || IAPICONSTANTCOLUMN.COMPONENTSCRAPCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.LEADTIMEOFFSETCMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.LEADTIMEOFFSETCMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.LEADTIMEOFFSETCOL
         || ') '
         || IAPICONSTANTCOLUMN.LEADTIMEOFFSETCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.ITEMCATEGORYCMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.ITEMCATEGORYCMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.ITEMCATEGORYCOL
         || ') '
         || IAPICONSTANTCOLUMN.ITEMCATEGORYCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.ISSUELOCATIONCMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.ISSUELOCATIONCMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.ISSUELOCATIONCOL
         || ') '
         || IAPICONSTANTCOLUMN.ISSUELOCATIONCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.CALCULATIONMODECMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.CALCULATIONMODECMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.CALCULATIONMODECOL
         || ') '
         || IAPICONSTANTCOLUMN.CALCULATIONMODECOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.BOMITEMTYPECMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.BOMITEMTYPECMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.BOMITEMTYPECOL
         || ') '
         || IAPICONSTANTCOLUMN.BOMITEMTYPECOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.OPERATIONALSTEPCMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.OPERATIONALSTEPCMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.OPERATIONALSTEPCOL
         || ') '
         || IAPICONSTANTCOLUMN.OPERATIONALSTEPCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.MINIMUMQUANTITYCMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.MINIMUMQUANTITYCMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.MINIMUMQUANTITYCOL
         || ') '
         || IAPICONSTANTCOLUMN.MINIMUMQUANTITYCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.MAXIMUMQUANTITYCMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.MAXIMUMQUANTITYCMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.MAXIMUMQUANTITYCOL
         || ') '
         || IAPICONSTANTCOLUMN.MAXIMUMQUANTITYCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.CODECMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.CODECMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.CODECOL
         || ') '
         || IAPICONSTANTCOLUMN.CODECOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.ALTERNATIVEGROUPCMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.ALTERNATIVEGROUPCMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.ALTERNATIVEGROUPCOL
         || ') '
         || IAPICONSTANTCOLUMN.ALTERNATIVEGROUPCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.ALTERNATIVEPRIOCMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.ALTERNATIVEPRIOCMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.ALTERNATIVEPRIORITYCOL
         || ') '
         || IAPICONSTANTCOLUMN.ALTERNATIVEPRIORITYCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.NUMERIC1CMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.NUMERIC1CMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.NUMERIC1COL
         || ') '
         || IAPICONSTANTCOLUMN.NUMERIC1COL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.NUMERIC2CMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.NUMERIC2CMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.NUMERIC2COL
         || ') '
         || IAPICONSTANTCOLUMN.NUMERIC2COL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.NUMERIC3CMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.NUMERIC3CMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.NUMERIC3COL
         || ') '
         || IAPICONSTANTCOLUMN.NUMERIC3COL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.NUMERIC4CMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.NUMERIC4CMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.NUMERIC4COL
         || ') '
         || IAPICONSTANTCOLUMN.NUMERIC4COL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.NUMERIC5CMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.NUMERIC5CMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.NUMERIC5COL
         || ') '
         || IAPICONSTANTCOLUMN.NUMERIC5COL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.STRING1CMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.STRING1CMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.STRING1COL
         || ') '
         || IAPICONSTANTCOLUMN.STRING1COL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.STRING2CMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.STRING2CMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.STRING2COL
         || ') '
         || IAPICONSTANTCOLUMN.STRING2COL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.STRING3CMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.STRING3CMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.STRING3COL
         || ') '
         || IAPICONSTANTCOLUMN.STRING3COL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.STRING4CMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.STRING4CMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.STRING4COL
         || ') '
         || IAPICONSTANTCOLUMN.STRING4COL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.STRING5CMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.STRING5CMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.STRING5COL
         || ') '
         || IAPICONSTANTCOLUMN.STRING5COL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.DATE1CMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.DATE1CMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.DATE1COL
         || ') '
         || IAPICONSTANTCOLUMN.DATE1COL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.DATE2CMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.DATE2CMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.DATE2COL
         || ') '
         || IAPICONSTANTCOLUMN.DATE2COL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESC1CMPSTSCOL
         || ') '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESC1CMPSTSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION1COL
         || ') '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION1COL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESC2CMPSTSCOL
         || ') '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESC2CMPSTSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION2COL
         || ') '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION2COL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESC3CMPSTSCOL
         || ') '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESC3CMPSTSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION3COL
         || ') '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION3COL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.RELEVANCYTOCOSTINGCMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.RELEVANCYTOCOSTINGCMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.RELEVANCYTOCOSTINGCOL
         || ') '
         || IAPICONSTANTCOLUMN.RELEVANCYTOCOSTINGCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.BULKMATERIALCMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.BULKMATERIALCMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.BULKMATERIALCOL
         || ') '
         || IAPICONSTANTCOLUMN.BULKMATERIALCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.FIXEDQUANTITYCMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.FIXEDQUANTITYCMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.FIXEDQUANTITYCOL
         || ') '
         || IAPICONSTANTCOLUMN.FIXEDQUANTITYCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.BOOLEAN1CMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.BOOLEAN1CMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.BOOLEAN1COL
         || ') '
         || IAPICONSTANTCOLUMN.BOOLEAN1COL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.BOOLEAN2CMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.BOOLEAN2CMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.BOOLEAN2COL
         || ') '
         || IAPICONSTANTCOLUMN.BOOLEAN2COL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.BOOLEAN3CMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.BOOLEAN3CMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.BOOLEAN3COL
         || ') '
         || IAPICONSTANTCOLUMN.BOOLEAN3COL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.BOOLEAN4CMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.BOOLEAN4CMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.BOOLEAN4COL
         || ') '
         || IAPICONSTANTCOLUMN.BOOLEAN4COL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.INTLEQLNTCMPSTATUSCOL
         || ') '
         || IAPICONSTANTCOLUMN.INTLEQLNTCMPSTATUSCOL
         || ', '
         || 'max('
         || IAPICONSTANTCOLUMN.INTERNATIONALEQUIVALENTCOL
         || ') '
         || IAPICONSTANTCOLUMN.INTERNATIONALEQUIVALENTCOL
         || ' from ('
         || 'SELECT   iapiCompare.GetCompareBIStatus( 1, '
         || ' :asPartNo2,:anRevision2,b.PLANT,b.ALTERNATIVE,b.Bom_USAGE, '
         || '  a.part_no,a.revision,a.PLANT, '
         || ' a.ALTERNATIVE, '
         || ' a.Bom_USAGE, '
         || ' a.COMPONENT_PART, '
         || ' a.COMPONENT_REVISION, '
         || ' a.COMPONENT_PLANT, '
         || ' a.QUANTITY, '
         || ' a.UOM, '
         || ' round(a.CONV_FACTOR,10), '
         || ' a.TO_UNIT, '
         || ' a.YIELD, '
         || ' a.ASSEMBLY_SCRAP, '
         || ' a.COMPONENT_SCRAP, '
         || ' a.LEAD_TIME_OFFSET, '
         || ' a.ITEM_CATEGORY, '
         || ' a.ISSUE_LOCATION, '
         || ' a.CALC_FLAG, '
         || ' a.Bom_ITEM_Type, '
         || ' a.OPERATIONAL_STEP, '
         || ' a.MIN_QTY, '
         || ' a.MAX_QTY, '
         || ' a.CODE, '
         || ' a.ALT_GROUP, '
         || ' a.ALT_PRIORITY, '
         || ' round(a.NUM_1,10), '
         || ' round(a.NUM_2,10), '
         || ' round(a.NUM_3,10), '
         || ' round(a.NUM_4,10), '
         || ' round(a.NUM_5,10), '
         || ' a.CHAR_1, '
         || ' a.CHAR_2, '
         || ' a.CHAR_3, '
         || ' a.CHAR_4, '
         || ' a.CHAR_5, '
         || ' a.DATE_1, '
         || ' a.DATE_2, '
         || ' f_chh_descr( 1,a.CH_1,a.CH_REV_1 ), '
         || ' f_chh_descr( 1,a.CH_2,a.CH_REV_2 ), '
         || ' f_chh_descr( 1,a.CH_3,a.CH_REV_3 ), '
         || ' a.RELEVENCY_TO_COSTING, '
         || ' a.BULK_MATERIAL, '
         || ' a.FIXED_QTY, '
         || ' a.BOOLEAN_1, '
         || ' a.BOOLEAN_2, '
         || ' a.BOOLEAN_3, '
         || ' a.BOOLEAN_4, '
         || ' a.INTL_EQUIVALENT ) '
         || IAPICONSTANTCOLUMN.BOMITEMCMPSTATUSCOL
         || ', a.PART_NO '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', a.REVISION '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', a.PLANT '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', a.ALTERNATIVE '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', a.Bom_USAGE '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', a.ITEM_NUMBER '
         || IAPICONSTANTCOLUMN.ITEMNUMBERCOL
         || ', a.COMPONENT_PART '
         || IAPICONSTANTCOLUMN.COMPONENTPARTNOCOL
         || ', DECODE( a.COMPONENT_REVISION, b.COMPONENT_REVISION, 0, 1 ) '
         || IAPICONSTANTCOLUMN.COMPONENTREVISIONCMPSTATUSCOL
         || ', a.COMPONENT_REVISION '
         || IAPICONSTANTCOLUMN.COMPONENTREVISIONCOL
         || ', f_sh_descr( 1,a.component_part, a.component_revision )  '
         || IAPICONSTANTCOLUMN.COMPONENTDESCRIPTIONCOL
         || ', DECODE( a.COMPONENT_PLANT, b.COMPONENT_PLANT, 0, 1 )  '
         || IAPICONSTANTCOLUMN.COMPONENTPLANTCMPSTATUSCOL
         || ', a.COMPONENT_PLANT '
         || IAPICONSTANTCOLUMN.COMPONENTPLANTCOL
         || ', DECODE( a.QUANTITY, b.QUANTITY, 0, 1 )  '
         || IAPICONSTANTCOLUMN.QUANTITYCMPSTATUSCOL
         || ', a.QUANTITY '
         || IAPICONSTANTCOLUMN.QUANTITYCOL
         || ', DECODE( a.UOM, b.UOM, 0, 1 )  '
         || IAPICONSTANTCOLUMN.UOMCMPSTATUSCOL
         || ', a.UOM '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ', DECODE( a.CONV_FACTOR, b.CONV_FACTOR, 0, 1 )  '
         || IAPICONSTANTCOLUMN.CONVERSIONFACTORCMPSTATUSCOL
         || ', round(a.CONV_FACTOR,10) '
         || IAPICONSTANTCOLUMN.CONVERSIONFACTORCOL
         || ', DECODE( a.TO_UNIT, b.TO_UNIT, 0, 1 )  '
         || IAPICONSTANTCOLUMN.TOUNITCMPSTATUSCOL
         || ', a.TO_UNIT '
         || IAPICONSTANTCOLUMN.TOUNITCOL
         || ', DECODE( a.YIELD, b.YIELD, 0, 1 )  '
         || IAPICONSTANTCOLUMN.YIELDCMPSTATUSCOL
         || ', a.YIELD '
         || IAPICONSTANTCOLUMN.YIELDCOL
         || ', DECODE( a.ASSEMBLY_SCRAP, b.ASSEMBLY_SCRAP, 0, 1 )  '
         || IAPICONSTANTCOLUMN.ASSEMBLYSCRAPCMPSTATUSCOL
         || ', a.ASSEMBLY_SCRAP '
         || IAPICONSTANTCOLUMN.ASSEMBLYSCRAPCOL
         || ', DECODE( a.COMPONENT_SCRAP, b.COMPONENT_SCRAP, 0, 1 )  '
         || IAPICONSTANTCOLUMN.COMPONENTSCRAPCMPSTATUSCOL
         || ', a.COMPONENT_SCRAP '
         || IAPICONSTANTCOLUMN.COMPONENTSCRAPCOL
         || ', DECODE( a.LEAD_TIME_OFFSET, b.LEAD_TIME_OFFSET, 0, 1 )  '
         || IAPICONSTANTCOLUMN.LEADTIMEOFFSETCMPSTATUSCOL
         || ', a.LEAD_TIME_OFFSET '
         || IAPICONSTANTCOLUMN.LEADTIMEOFFSETCOL
         || ', DECODE( a.ITEM_CATEGORY, b.ITEM_CATEGORY, 0, 1 )  '
         || IAPICONSTANTCOLUMN.ITEMCATEGORYCMPSTATUSCOL
         || ', a.ITEM_CATEGORY '
         || IAPICONSTANTCOLUMN.ITEMCATEGORYCOL
         || ', DECODE( a.ISSUE_LOCATION, b.ISSUE_LOCATION, 0, 1 )  '
         || IAPICONSTANTCOLUMN.ISSUELOCATIONCMPSTATUSCOL
         || ', a.ISSUE_LOCATION '
         || IAPICONSTANTCOLUMN.ISSUELOCATIONCOL
         || ', DECODE( a.CALC_FLAG, b.CALC_FLAG, 0, 1 )  '
         || IAPICONSTANTCOLUMN.CALCULATIONMODECMPSTATUSCOL
         || ', a.CALC_FLAG '
         || IAPICONSTANTCOLUMN.CALCULATIONMODECOL
         || ', DECODE( a.Bom_ITEM_Type, b.Bom_ITEM_Type, 0, 1 )  '
         || IAPICONSTANTCOLUMN.BOMITEMTYPECMPSTATUSCOL
         || ', a.Bom_ITEM_Type '
         || IAPICONSTANTCOLUMN.BOMITEMTYPECOL
         || ', DECODE( a.OPERATIONAL_STEP, b.OPERATIONAL_STEP, 0, 1)  '
         || IAPICONSTANTCOLUMN.OPERATIONALSTEPCMPSTATUSCOL
         || ', a.OPERATIONAL_STEP '
         || IAPICONSTANTCOLUMN.OPERATIONALSTEPCOL
         || ', DECODE( a.MIN_QTY, b.MIN_QTY, 0, 1 ) '
         || IAPICONSTANTCOLUMN.MINIMUMQUANTITYCMPSTATUSCOL
         || ', a.MIN_QTY '
         || IAPICONSTANTCOLUMN.MINIMUMQUANTITYCOL
         || ', DECODE( a.MAX_QTY, b.MAX_QTY, 0, 1 )  '
         || IAPICONSTANTCOLUMN.MAXIMUMQUANTITYCMPSTATUSCOL
         || ', a.MAX_QTY '
         || IAPICONSTANTCOLUMN.MAXIMUMQUANTITYCOL
         || ', DECODE( a.CODE, b.CODE, 0, 1 )  '
         || IAPICONSTANTCOLUMN.CODECMPSTATUSCOL
         || ', a.CODE '
         || IAPICONSTANTCOLUMN.CODECOL
         || ', DECODE( a.ALT_GROUP, b.ALT_GROUP, 0, 1 )  '
         || IAPICONSTANTCOLUMN.ALTERNATIVEGROUPCMPSTATUSCOL
         || ', a.ALT_GROUP '
         || IAPICONSTANTCOLUMN.ALTERNATIVEGROUPCOL
         || ', DECODE( a.ALT_PRIORITY,b.ALT_PRIORITY, 0, 1 )  '
         || IAPICONSTANTCOLUMN.ALTERNATIVEPRIOCMPSTATUSCOL
         || ', a.ALT_PRIORITY '
         || IAPICONSTANTCOLUMN.ALTERNATIVEPRIORITYCOL
         || ', DECODE( a.NUM_1, b.NUM_1, 0, 1 )  '
         || IAPICONSTANTCOLUMN.NUMERIC1CMPSTATUSCOL
         || ', round(a.NUM_1,10) '
         || IAPICONSTANTCOLUMN.NUMERIC1COL
         || ', DECODE( a.NUM_2, b.NUM_2, 0, 1 )  '
         || IAPICONSTANTCOLUMN.NUMERIC2CMPSTATUSCOL
         || ', round(a.NUM_2,10) '
         || IAPICONSTANTCOLUMN.NUMERIC2COL
         || ', DECODE( a.NUM_3, b.NUM_3, 0, 1 )  '
         || IAPICONSTANTCOLUMN.NUMERIC3CMPSTATUSCOL
         || ', round(a.NUM_3,10) '
         || IAPICONSTANTCOLUMN.NUMERIC3COL
         || ', DECODE( a.NUM_4, b.NUM_4, 0, 1 )  '
         || IAPICONSTANTCOLUMN.NUMERIC4CMPSTATUSCOL
         || ', round(a.NUM_4,10) '
         || IAPICONSTANTCOLUMN.NUMERIC4COL
         || ', DECODE( a.NUM_5, b.NUM_5, 0, 1 )  '
         || IAPICONSTANTCOLUMN.NUMERIC5CMPSTATUSCOL
         || ', round(a.NUM_5,10) '
         || IAPICONSTANTCOLUMN.NUMERIC5COL
         || ', DECODE( a.CHAR_1, b.CHAR_1, 0, 1 )  '
         || IAPICONSTANTCOLUMN.STRING1CMPSTATUSCOL
         || ', a.CHAR_1 '
         || IAPICONSTANTCOLUMN.STRING1COL
         || ', DECODE( a.CHAR_2, b.CHAR_2, 0, 1 )  '
         || IAPICONSTANTCOLUMN.STRING2CMPSTATUSCOL
         || ', a.CHAR_2 '
         || IAPICONSTANTCOLUMN.STRING2COL
         || ', DECODE( a.CHAR_3, b.CHAR_3, 0, 1 )  '
         || IAPICONSTANTCOLUMN.STRING3CMPSTATUSCOL
         || ', a.CHAR_3 '
         || IAPICONSTANTCOLUMN.STRING3COL
         || ', DECODE( a.CHAR_4, b.CHAR_4, 0, 1 )  '
         || IAPICONSTANTCOLUMN.STRING4CMPSTATUSCOL
         || ', a.CHAR_4 '
         || IAPICONSTANTCOLUMN.STRING4COL
         || ', DECODE( a.CHAR_5, b.CHAR_5, 0, 1 )  '
         || IAPICONSTANTCOLUMN.STRING5CMPSTATUSCOL
         || ', a.CHAR_5 '
         || IAPICONSTANTCOLUMN.STRING5COL
         || ', DECODE( a.DATE_1, b.DATE_1, 0, 1 )  '
         || IAPICONSTANTCOLUMN.DATE1CMPSTATUSCOL
         || ', a.DATE_1 '
         || IAPICONSTANTCOLUMN.DATE1COL
         || ', DECODE( a.DATE_2, b.DATE_2, 0, 1 )  '
         || IAPICONSTANTCOLUMN.DATE2CMPSTATUSCOL
         || ', a.DATE_2 '
         || IAPICONSTANTCOLUMN.DATE2COL
         || ', DECODE( f_chh_descr( 1, a.CH_1, a.CH_REV_1 ), f_chh_descr( 1, b.CH_1, b.CH_REV_1 ), 0, 1 )  '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESC1CMPSTSCOL
         || ', f_chh_descr( 1, a.CH_1, a.CH_REV_1 )  '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION1COL
         || ', DECODE( f_chh_descr( 1, a.CH_2, a.CH_REV_2 ), f_chh_descr( 1, b.CH_2, b.CH_REV_2 ), 0, 1 )  '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESC2CMPSTSCOL
         || ', f_chh_descr( 1, a.CH_2, a.CH_REV_2 )  '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION2COL
         || ', DECODE( f_chh_descr( 1, a.CH_3, a.CH_REV_3 ), f_chh_descr( 1, b.CH_3, b.CH_REV_3 ), 0, 1 )  '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESC3CMPSTSCOL
         || ', f_chh_descr( 1, a.CH_3, a.CH_REV_3 )  '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION3COL
         || ', DECODE( a.RELEVENCY_TO_COSTING, b.RELEVENCY_TO_COSTING, 0, 1 )  '
         || IAPICONSTANTCOLUMN.RELEVANCYTOCOSTINGCMPSTATUSCOL
         || ', a.RELEVENCY_TO_COSTING '
         || IAPICONSTANTCOLUMN.RELEVANCYTOCOSTINGCOL
         || ', DECODE( a.BULK_MATERIAL, b.BULK_MATERIAL, 0, 1 )  '
         || IAPICONSTANTCOLUMN.BULKMATERIALCMPSTATUSCOL
         || ', a.BULK_MATERIAL '
         || IAPICONSTANTCOLUMN.BULKMATERIALCOL
         || ', DECODE( a.FIXED_QTY, b.FIXED_QTY, 0, 1 )  '
         || IAPICONSTANTCOLUMN.FIXEDQUANTITYCMPSTATUSCOL
         || ', a.FIXED_QTY '
         || IAPICONSTANTCOLUMN.FIXEDQUANTITYCOL
         || ', DECODE( a.BOOLEAN_1, b.BOOLEAN_1, 0, 1 )  '
         || IAPICONSTANTCOLUMN.BOOLEAN1CMPSTATUSCOL
         || ', a.BOOLEAN_1 '
         || IAPICONSTANTCOLUMN.BOOLEAN1COL
         || ', DECODE( a.BOOLEAN_2, b.BOOLEAN_2, 0, 1 )  '
         || IAPICONSTANTCOLUMN.BOOLEAN2CMPSTATUSCOL
         || ', a.BOOLEAN_2 '
         || IAPICONSTANTCOLUMN.BOOLEAN2COL
         || ', DECODE( a.BOOLEAN_3, b.BOOLEAN_3, 0, 1 )  '
         || IAPICONSTANTCOLUMN.BOOLEAN3CMPSTATUSCOL
         || ', a.BOOLEAN_3 '
         || IAPICONSTANTCOLUMN.BOOLEAN3COL
         || ', DECODE( a.BOOLEAN_4, b.BOOLEAN_4, 0, 1 )  '
         || IAPICONSTANTCOLUMN.BOOLEAN4CMPSTATUSCOL
         || ', a.BOOLEAN_4 '
         || IAPICONSTANTCOLUMN.BOOLEAN4COL
         || ', DECODE( a.INTL_EQUIVALENT , b.INTL_EQUIVALENT , 0, 1 )  '
         || IAPICONSTANTCOLUMN.INTLEQLNTCMPSTATUSCOL
         || ', a.INTL_EQUIVALENT '
         || IAPICONSTANTCOLUMN.INTERNATIONALEQUIVALENTCOL
         || ' FROM Bom_ITEM a, Bom_ITEM b '
         || ' WHERE a.part_no = :asPartNo '
         || ' AND a.revision = :anRevision '
         || ' AND ( a.PLANT = :asPlant OR ( :asPlant IS NULL AND a.plant = b.plant ) ) '
         || ' AND ( a.ALTERNATIVE = :anAlternative OR ( :anAlternative IS NULL AND a.alternative = b.alternative ) ) '
         || ' AND ( a.Bom_USAGE = :anUsage OR ( :anUsage IS NULL AND a.bom_usage = b.bom_usage ) ) '
         || ' AND b.part_no = :asPartNo2 '
         || ' AND b.revision = :anRevision2 '
         || ' AND ( b.PLANT = :asPlant2 OR :asPlant2 IS NULL ) '
         || ' AND ( b.ALTERNATIVE = :anAlternative2 OR :anAlternative2 IS NULL ) '
         || ' AND ( b.Bom_USAGE = :anUsage2 OR :anUsage2 IS NULL ) '
         || ' AND a.COMPONENT_PART = b.COMPONENT_PART '
         || ')group by '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ','
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ','
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ','
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ','
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ','
         || IAPICONSTANTCOLUMN.ITEMNUMBERCOL
         || ','
         || IAPICONSTANTCOLUMN.COMPONENTPARTNOCOL;

      IF ( AQBOMS%ISOPEN )
      THEN
         CLOSE AQBOMS;
      END IF;

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );




      OPEN AQBOMS FOR LSSQL
      USING ASPARTNO2,
            ANREVISION2,
            LSPARTNO,   
            LNREVISION,   
            ASPLANT,
            ASPLANT,
            ANALTERNATIVE,
            ANALTERNATIVE,
            ANUSAGE,
            ANUSAGE,
            ASPARTNO2,
            ANREVISION2,
            ASPLANT2,
            ASPLANT2,
            ANALTERNATIVE2,
            ANALTERNATIVE2,
            ANUSAGE2,
            ANUSAGE2;

      LNRETVAL := IAPISPECIFICATIONACCESS.GETVIEWACCESS( ASPARTNO,
                                                         ANREVISION,
                                                         LNACCESS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF LNACCESS = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOVIEWACCESS,
                                                    ASPARTNO,
                                                    ANREVISION );
      END IF;

      LNRETVAL := IAPISPECIFICATIONACCESS.GETVIEWACCESS( ASPARTNO2,
                                                         ANREVISION2,
                                                         LNACCESS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF LNACCESS = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOVIEWACCESS,
                                                    ASPARTNO2,
                                                    ANREVISION2 );
      END IF;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.VIEWBOMALLOWED = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOVIEWBOMACCESS,
                                                    IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );
      END IF;

      LSSQL :=
            LSSQL
         || ' UNION ALL '
         || 'SELECT '
         || 'max('
         || IAPICONSTANTCOLUMN.BOMITEMCMPSTATUSCOL
         || '), '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ','
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ','
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ','
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ','
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ','
         || IAPICONSTANTCOLUMN.ITEMNUMBERCOL
         || ','
         || IAPICONSTANTCOLUMN.COMPONENTPARTNOCOL
         || ','
         || 'max('
         || IAPICONSTANTCOLUMN.COMPONENTREVISIONCMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.COMPONENTREVISIONCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.COMPONENTDESCRIPTIONCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.COMPONENTPLANTCMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.COMPONENTPLANTCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.QUANTITYCMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.QUANTITYCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.UOMCMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.UOMCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.CONVERSIONFACTORCMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.CONVERSIONFACTORCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.TOUNITCMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.TOUNITCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.YIELDCMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.YIELDCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.ASSEMBLYSCRAPCMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.ASSEMBLYSCRAPCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.COMPONENTSCRAPCMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.COMPONENTSCRAPCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.LEADTIMEOFFSETCMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.LEADTIMEOFFSETCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.ITEMCATEGORYCMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.ITEMCATEGORYCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.ISSUELOCATIONCMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.ISSUELOCATIONCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.CALCULATIONMODECMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.CALCULATIONMODECOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.BOMITEMTYPECMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.BOMITEMTYPECOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.OPERATIONALSTEPCMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.OPERATIONALSTEPCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.MINIMUMQUANTITYCMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.MINIMUMQUANTITYCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.MAXIMUMQUANTITYCMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.MAXIMUMQUANTITYCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.CODECMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.CODECOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.ALTERNATIVEGROUPCMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.ALTERNATIVEGROUPCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.ALTERNATIVEPRIOCMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.ALTERNATIVEPRIORITYCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.NUMERIC1CMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.NUMERIC1COL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.NUMERIC2CMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.NUMERIC2COL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.NUMERIC3CMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.NUMERIC3COL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.NUMERIC4CMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.NUMERIC4COL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.NUMERIC5CMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.NUMERIC5COL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.STRING1CMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.STRING1COL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.STRING2CMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.STRING2COL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.STRING3CMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.STRING3COL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.STRING4CMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.STRING4COL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.STRING5CMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.STRING5COL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.DATE1CMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.DATE1COL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.DATE2CMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.DATE2COL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESC1CMPSTSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION1COL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESC2CMPSTSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION2COL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESC3CMPSTSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION3COL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.RELEVANCYTOCOSTINGCMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.RELEVANCYTOCOSTINGCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.BULKMATERIALCMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.BULKMATERIALCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.FIXEDQUANTITYCMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.FIXEDQUANTITYCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.BOOLEAN1CMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.BOOLEAN1COL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.BOOLEAN2CMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.BOOLEAN2COL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.BOOLEAN3CMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.BOOLEAN3COL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.BOOLEAN4CMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.BOOLEAN4COL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.INTLEQLNTCMPSTATUSCOL
         || '), '
         || 'max('
         || IAPICONSTANTCOLUMN.INTERNATIONALEQUIVALENTCOL
         || ') '
         || ' from ('
         || ' SELECT   iapiCompare.GetCompareBIStatus( 2,:asPartNo,:anRevision,b.PLANT,b.ALTERNATIVE,b.Bom_USAGE, '
         || '  a.part_no,a.revision,a.PLANT,a.ALTERNATIVE,a.Bom_USAGE,a.COMPONENT_PART, '
         || ' a.COMPONENT_REVISION,a.COMPONENT_PLANT,a.QUANTITY,a.UOM,a.CONV_FACTOR, '
         || ' a.TO_UNIT,a.YIELD,a.ASSEMBLY_SCRAP,a.COMPONENT_SCRAP,a.LEAD_TIME_OFFSET, '
         || ' a.ITEM_CATEGORY,a.ISSUE_LOCATION,a.CALC_FLAG,a.Bom_ITEM_Type,a.OPERATIONAL_STEP, '
         || ' a.MIN_QTY,a.MAX_QTY,a.CODE,a.ALT_GROUP,a.ALT_PRIORITY,a.NUM_1,a.NUM_2,a.NUM_3, '
         || ' a.NUM_4,a.NUM_5,a.CHAR_1,a.CHAR_2,a.CHAR_3,a.CHAR_4,a.CHAR_5,a.DATE_1,a.DATE_2, '
         || ' f_chh_descr( 1,a.CH_1,a.CH_REV_1 ),f_chh_descr( 1,a.CH_2,a.CH_REV_2 ), '
         || ' f_chh_descr( 1,a.CH_3,a.CH_REV_3 ),a.RELEVENCY_TO_COSTING,a.BULK_MATERIAL, '
         || ' a.FIXED_QTY,a.BOOLEAN_1,a.BOOLEAN_2,a.BOOLEAN_3,a.BOOLEAN_4,a.INTL_EQUIVALENT ) '
         || IAPICONSTANTCOLUMN.BOMITEMCMPSTATUSCOL
         || ', a.PART_NO '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', a.REVISION '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', a.PLANT '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', a.ALTERNATIVE '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', a.Bom_USAGE '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', a.ITEM_NUMBER '
         || IAPICONSTANTCOLUMN.ITEMNUMBERCOL
         || ', a.COMPONENT_PART '
         || IAPICONSTANTCOLUMN.COMPONENTPARTNOCOL
         || ', DECODE( a.COMPONENT_REVISION, b.COMPONENT_REVISION, 0, 1 ) '
         || IAPICONSTANTCOLUMN.COMPONENTREVISIONCMPSTATUSCOL
         || ', a.COMPONENT_REVISION '
         || IAPICONSTANTCOLUMN.COMPONENTREVISIONCOL
         || ', f_sh_descr( 1,a.component_part, a.component_revision )  '
         || IAPICONSTANTCOLUMN.COMPONENTDESCRIPTIONCOL
         || ', DECODE( a.COMPONENT_PLANT, b.COMPONENT_PLANT, 0, 1 )  '
         || IAPICONSTANTCOLUMN.COMPONENTPLANTCMPSTATUSCOL
         || ', a.COMPONENT_PLANT '
         || IAPICONSTANTCOLUMN.COMPONENTPLANTCOL
         || ', DECODE( a.QUANTITY, b.QUANTITY, 0, 1 )  '
         || IAPICONSTANTCOLUMN.QUANTITYCMPSTATUSCOL
         || ', a.QUANTITY '
         || IAPICONSTANTCOLUMN.QUANTITYCOL
         || ', DECODE( a.UOM, b.UOM, 0, 1 )  '
         || IAPICONSTANTCOLUMN.UOMCMPSTATUSCOL
         || ', a.UOM '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ', DECODE( a.CONV_FACTOR, b.CONV_FACTOR, 0, 1 )  '
         || IAPICONSTANTCOLUMN.CONVERSIONFACTORCMPSTATUSCOL
         || ', round(a.CONV_FACTOR,10) '
         || IAPICONSTANTCOLUMN.CONVERSIONFACTORCOL
         || ', DECODE( a.TO_UNIT, b.TO_UNIT, 0, 1 )  '
         || IAPICONSTANTCOLUMN.TOUNITCMPSTATUSCOL
         || ', a.TO_UNIT '
         || IAPICONSTANTCOLUMN.TOUNITCOL
         || ', DECODE( a.YIELD, b.YIELD, 0, 1 )  '
         || IAPICONSTANTCOLUMN.YIELDCMPSTATUSCOL
         || ', a.YIELD '
         || IAPICONSTANTCOLUMN.YIELDCOL
         || ', DECODE( a.ASSEMBLY_SCRAP, b.ASSEMBLY_SCRAP, 0, 1 )  '
         || IAPICONSTANTCOLUMN.ASSEMBLYSCRAPCMPSTATUSCOL
         || ', a.ASSEMBLY_SCRAP '
         || IAPICONSTANTCOLUMN.ASSEMBLYSCRAPCOL
         || ', DECODE( a.COMPONENT_SCRAP, b.COMPONENT_SCRAP, 0, 1 )  '
         || IAPICONSTANTCOLUMN.COMPONENTSCRAPCMPSTATUSCOL
         || ', a.COMPONENT_SCRAP '
         || IAPICONSTANTCOLUMN.COMPONENTSCRAPCOL
         || ', DECODE( a.LEAD_TIME_OFFSET, b.LEAD_TIME_OFFSET, 0, 1 )  '
         || IAPICONSTANTCOLUMN.LEADTIMEOFFSETCMPSTATUSCOL
         || ', a.LEAD_TIME_OFFSET '
         || IAPICONSTANTCOLUMN.LEADTIMEOFFSETCOL
         || ', DECODE( a.ITEM_CATEGORY, b.ITEM_CATEGORY, 0, 1 )  '
         || IAPICONSTANTCOLUMN.ITEMCATEGORYCMPSTATUSCOL
         || ', a.ITEM_CATEGORY '
         || IAPICONSTANTCOLUMN.ITEMCATEGORYCOL
         || ', DECODE( a.ISSUE_LOCATION, b.ISSUE_LOCATION, 0, 1 )  '
         || IAPICONSTANTCOLUMN.ISSUELOCATIONCMPSTATUSCOL
         || ', a.ISSUE_LOCATION '
         || IAPICONSTANTCOLUMN.ISSUELOCATIONCOL
         || ', DECODE( a.CALC_FLAG, b.CALC_FLAG, 0, 1 )  '
         || IAPICONSTANTCOLUMN.CALCULATIONMODECMPSTATUSCOL
         || ', a.CALC_FLAG '
         || IAPICONSTANTCOLUMN.CALCULATIONMODECOL
         || ', DECODE( a.Bom_ITEM_Type, b.Bom_ITEM_Type, 0, 1 )  '
         || IAPICONSTANTCOLUMN.BOMITEMTYPECMPSTATUSCOL
         || ', a.Bom_ITEM_Type '
         || IAPICONSTANTCOLUMN.BOMITEMTYPECOL
         || ', DECODE( a.OPERATIONAL_STEP, b.OPERATIONAL_STEP, 0, 1)  '
         || IAPICONSTANTCOLUMN.OPERATIONALSTEPCMPSTATUSCOL
         || ', a.OPERATIONAL_STEP '
         || IAPICONSTANTCOLUMN.OPERATIONALSTEPCOL
         || ', DECODE( a.MIN_QTY, b.MIN_QTY, 0, 1 ) '
         || IAPICONSTANTCOLUMN.MINIMUMQUANTITYCMPSTATUSCOL
         || ', a.MIN_QTY '
         || IAPICONSTANTCOLUMN.MINIMUMQUANTITYCOL
         || ', DECODE( a.MAX_QTY, b.MAX_QTY, 0, 1 )  '
         || IAPICONSTANTCOLUMN.MAXIMUMQUANTITYCMPSTATUSCOL
         || ', a.MAX_QTY '
         || IAPICONSTANTCOLUMN.MAXIMUMQUANTITYCOL
         || ', DECODE( a.CODE, b.CODE, 0, 1 )  '
         || IAPICONSTANTCOLUMN.CODECMPSTATUSCOL
         || ', a.CODE '
         || IAPICONSTANTCOLUMN.CODECOL
         || ', DECODE( a.ALT_GROUP, b.ALT_GROUP, 0, 1 )  '
         || IAPICONSTANTCOLUMN.ALTERNATIVEGROUPCMPSTATUSCOL
         || ', a.ALT_GROUP '
         || IAPICONSTANTCOLUMN.ALTERNATIVEGROUPCOL
         || ', DECODE( a.ALT_PRIORITY,b.ALT_PRIORITY, 0, 1 )  '
         || IAPICONSTANTCOLUMN.ALTERNATIVEPRIOCMPSTATUSCOL
         || ', a.ALT_PRIORITY '
         || IAPICONSTANTCOLUMN.ALTERNATIVEPRIORITYCOL
         || ', DECODE( a.NUM_1, b.NUM_1, 0, 1 )  '
         || IAPICONSTANTCOLUMN.NUMERIC1CMPSTATUSCOL
         || ', round(a.NUM_1,10) '
         || IAPICONSTANTCOLUMN.NUMERIC1COL
         || ', DECODE( a.NUM_2, b.NUM_2, 0, 1 )  '
         || IAPICONSTANTCOLUMN.NUMERIC2CMPSTATUSCOL
         || ', round(a.NUM_2,10) '
         || IAPICONSTANTCOLUMN.NUMERIC2COL
         || ', DECODE( a.NUM_3, b.NUM_3, 0, 1 )  '
         || IAPICONSTANTCOLUMN.NUMERIC3CMPSTATUSCOL
         || ', round(a.NUM_3,10) '
         || IAPICONSTANTCOLUMN.NUMERIC3COL
         || ', DECODE( a.NUM_4, b.NUM_4, 0, 1 )  '
         || IAPICONSTANTCOLUMN.NUMERIC4CMPSTATUSCOL
         || ', round(a.NUM_4,10) '
         || IAPICONSTANTCOLUMN.NUMERIC4COL
         || ', DECODE( a.NUM_5, b.NUM_5, 0, 1 )  '
         || IAPICONSTANTCOLUMN.NUMERIC5CMPSTATUSCOL
         || ', round(a.NUM_5,10) '
         || IAPICONSTANTCOLUMN.NUMERIC5COL
         || ', DECODE( a.CHAR_1, b.CHAR_1, 0, 1 )  '
         || IAPICONSTANTCOLUMN.STRING1CMPSTATUSCOL
         || ', a.CHAR_1 '
         || IAPICONSTANTCOLUMN.STRING1COL
         || ', DECODE( a.CHAR_2, b.CHAR_2, 0, 1 )  '
         || IAPICONSTANTCOLUMN.STRING2CMPSTATUSCOL
         || ', a.CHAR_2 '
         || IAPICONSTANTCOLUMN.STRING2COL
         || ', DECODE( a.CHAR_3, b.CHAR_3, 0, 1 )  '
         || IAPICONSTANTCOLUMN.STRING3CMPSTATUSCOL
         || ', a.CHAR_3 '
         || IAPICONSTANTCOLUMN.STRING3COL
         || ', DECODE( a.CHAR_4, b.CHAR_4, 0, 1 )  '
         || IAPICONSTANTCOLUMN.STRING4CMPSTATUSCOL
         || ', a.CHAR_4 '
         || IAPICONSTANTCOLUMN.STRING4COL
         || ', DECODE( a.CHAR_5, b.CHAR_5, 0, 1 )  '
         || IAPICONSTANTCOLUMN.STRING5CMPSTATUSCOL
         || ', a.CHAR_5 '
         || IAPICONSTANTCOLUMN.STRING5COL
         || ', DECODE( a.DATE_1, b.DATE_1, 0, 1 )  '
         || IAPICONSTANTCOLUMN.DATE1CMPSTATUSCOL
         || ', a.DATE_1 '
         || IAPICONSTANTCOLUMN.DATE1COL
         || ', DECODE( a.DATE_2, b.DATE_2, 0, 1 )  '
         || IAPICONSTANTCOLUMN.DATE2CMPSTATUSCOL
         || ', a.DATE_2 '
         || IAPICONSTANTCOLUMN.DATE2COL
         || ', DECODE( f_chh_descr( 1, a.CH_1, a.CH_REV_1 ), f_chh_descr( 1, b.CH_1, b.CH_REV_1 ), 0, 1 )  '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESC1CMPSTSCOL
         || ', f_chh_descr( 1, a.CH_1, a.CH_REV_1 )  '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION1COL
         || ', DECODE( f_chh_descr( 1, a.CH_2, a.CH_REV_2 ), f_chh_descr( 1, b.CH_2, b.CH_REV_2 ), 0, 1 )  '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESC2CMPSTSCOL
         || ', f_chh_descr( 1, a.CH_2, a.CH_REV_2 )  '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION2COL
         || ', DECODE( f_chh_descr( 1, a.CH_3, a.CH_REV_3 ), f_chh_descr( 1, b.CH_3, b.CH_REV_3 ), 0, 1 )  '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESC3CMPSTSCOL
         || ', f_chh_descr( 1, a.CH_3, a.CH_REV_3 )  '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION3COL
         || ', DECODE( a.RELEVENCY_TO_COSTING, b.RELEVENCY_TO_COSTING, 0, 1 )  '
         || IAPICONSTANTCOLUMN.RELEVANCYTOCOSTINGCMPSTATUSCOL
         || ', a.RELEVENCY_TO_COSTING '
         || IAPICONSTANTCOLUMN.RELEVANCYTOCOSTINGCOL
         || ', DECODE( a.BULK_MATERIAL, b.BULK_MATERIAL, 0, 1 )  '
         || IAPICONSTANTCOLUMN.BULKMATERIALCMPSTATUSCOL
         || ', a.BULK_MATERIAL '
         || IAPICONSTANTCOLUMN.BULKMATERIALCOL
         || ', DECODE( a.FIXED_QTY, b.FIXED_QTY, 0, 1 )  '
         || IAPICONSTANTCOLUMN.FIXEDQUANTITYCMPSTATUSCOL
         || ', a.FIXED_QTY '
         || IAPICONSTANTCOLUMN.FIXEDQUANTITYCOL
         || ', DECODE( a.BOOLEAN_1, b.BOOLEAN_1, 0, 1 )  '
         || IAPICONSTANTCOLUMN.BOOLEAN1CMPSTATUSCOL
         || ', a.BOOLEAN_1 '
         || IAPICONSTANTCOLUMN.BOOLEAN1COL
         || ', DECODE( a.BOOLEAN_2, b.BOOLEAN_2, 0, 1 )  '
         || IAPICONSTANTCOLUMN.BOOLEAN2CMPSTATUSCOL
         || ', a.BOOLEAN_2 '
         || IAPICONSTANTCOLUMN.BOOLEAN2COL
         || ', DECODE( a.BOOLEAN_3, b.BOOLEAN_3, 0, 1 )  '
         || IAPICONSTANTCOLUMN.BOOLEAN3CMPSTATUSCOL
         || ', a.BOOLEAN_3 '
         || IAPICONSTANTCOLUMN.BOOLEAN3COL
         || ', DECODE( a.BOOLEAN_4, b.BOOLEAN_4, 0, 1 )  '
         || IAPICONSTANTCOLUMN.BOOLEAN4CMPSTATUSCOL
         || ', a.BOOLEAN_4 '
         || IAPICONSTANTCOLUMN.BOOLEAN4COL
         || ', DECODE( a.INTL_EQUIVALENT , b.INTL_EQUIVALENT , 0, 1 )  '
         || IAPICONSTANTCOLUMN.INTLEQLNTCMPSTATUSCOL
         || ', a.INTL_EQUIVALENT '
         || IAPICONSTANTCOLUMN.INTERNATIONALEQUIVALENTCOL
         || ' FROM Bom_ITEM a, Bom_ITEM b '
         || ' WHERE a.part_no = :asPartNo2 '
         || ' AND a.revision = :anRevision2 '
         || ' AND ( a.PLANT = :asPlant2  OR  ( :asPlant2 IS NULL AND a.plant = b.plant )  ) '
         || ' AND ( a.ALTERNATIVE = :anAlternative2  OR ( :anAlternative2 IS NULL AND a.alternative = b.alternative ) ) '
         || ' AND ( a.Bom_USAGE = :anUsage2  OR ( :anUsage2 IS NULL  AND a.bom_usage = b.bom_usage ) ) '
         || ' AND b.part_no = :asPartNo '
         || ' AND b.revision = :anRevision '
         || ' AND ( b.PLANT = :asPlant OR :asPlant IS NULL ) '
         || ' AND ( b.ALTERNATIVE = :anAlternative OR :anAlternative IS NULL ) '
         || ' AND ( b.Bom_USAGE = :anUsage OR :anUsage IS NULL ) '
         || ' AND a.COMPONENT_PART = b.COMPONENT_PART '
         || ')group by '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ','
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ','
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ','
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ','
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ','
         || IAPICONSTANTCOLUMN.ITEMNUMBERCOL
         || ','
         || IAPICONSTANTCOLUMN.COMPONENTPARTNOCOL;
      LSSQL :=
            LSSQL
         || ' UNION ALL '
         || ' SELECT   1 BI_STATUS, '
         || ' a.PART_NO, '
         || ' a.REVISION, '
         || ' a.PLANT, '
         || ' a.ALTERNATIVE, '
         || ' a.Bom_USAGE, '
         || ' a.ITEM_NUMBER, '
         || ' a.COMPONENT_PART, '
         || ' 0 COMPONENT_REVISION_SS, '
         || ' a.COMPONENT_REVISION, '
         || ' f_sh_descr( 1, a.component_part, a.component_revision ) component_description, '
         || ' 0 COMPONENT_PLANT_SS, '
         || ' a.COMPONENT_PLANT, '
         || ' 0 QUANTITY_SS, '
         || ' a.QUANTITY, '
         || ' 0 UOM_SS, '
         || ' a.UOM, '
         || ' 0 CONV_FACTOR_SS, '
         || ' round(a.CONV_FACTOR,10), '
         || ' 0 TO_UNIT_SS, '
         || ' a.TO_UNIT, '
         || ' 0 YIELD_SS, '
         || ' a.YIELD, '
         || ' 0 ASSEMBLY_SCRAP_SS, '
         || ' a.ASSEMBLY_SCRAP, '
         || ' 0 COMPONENT_SCRAP_SS, '
         || ' a.COMPONENT_SCRAP, '
         || ' 0 LEAD_TIME_OFFSET_SS, '
         || ' a.LEAD_TIME_OFFSET, '
         || ' 0 ITEM_CATEGORY_SS, '
         || ' a.ITEM_CATEGORY, '
         || ' 0 ISSUE_LOCATION_SS, '
         || ' a.ISSUE_LOCATION, '
         || ' 0 CALC_FLAG_SS, '
         || ' a.CALC_FLAG, '
         || ' 0 Bom_ITEM_Type_SS, '
         || ' a.Bom_ITEM_Type, '
         || ' 0 OPERATIONAL_STEP_SS, '
         || ' a.OPERATIONAL_STEP, '
         || ' 0 MIN_QTY_SS, '
         || ' a.MIN_QTY, '
         || ' 0 MAX_QTY_SS, '
         || ' a.MAX_QTY, '
         || ' 0 CODE_SS, '
         || ' a.CODE, '
         || ' 0 ALT_GROUP_SS, '
         || ' a.ALT_GROUP, '
         || ' 0 ALT_PRIORITY_SS, '
         || ' a.ALT_PRIORITY, '
         || ' 0 NUM_1_SS, '
         || ' round(a.NUM_1,10), '
         || ' 0 NUM_2_SS, '
         || ' round(a.NUM_2,10), '
         || ' 0 NUM_3_SS, '
         || ' round(a.NUM_3,10), '
         || ' 0 NUM_4_SS, '
         || ' round(a.NUM_4,10), '
         || ' 0 NUM_5_SS, '
         || ' round(a.NUM_5,10), '
         || ' 0 CHAR_1_SS, '
         || ' a.CHAR_1, '
         || ' 0 CHAR_2_SS, '
         || ' a.CHAR_2, '
         || ' 0 CHAR_3_SS, '
         || ' a.CHAR_3, '
         || ' 0 CHAR_4_SS, '
         || ' a.CHAR_4, '
         || ' 0 CHAR_5_SS, '
         || ' a.CHAR_5, '
         || ' 0 DATE_1_SS, '
         || ' a.DATE_1, '
         || ' 0 DATE_2_SS, '
         || ' a.DATE_2, '
         || ' 0 CH1_SS, '
         || ' f_chh_descr( 1, a.CH_1, a.CH_REV_1 ) CH1, '
         || ' 0 CH2_SS, '
         || ' f_chh_descr( 1, a.CH_2, a.CH_REV_2 ) CH2, '
         || ' 0 CH3_SS, '
         || ' f_chh_descr( 1, a.CH_3, a.CH_REV_3 ) CH3, '
         || ' 0 RELEVENCY_TO_COSTING_SS, '
         || ' a.RELEVENCY_TO_COSTING, '
         || ' 0 BULK_MATERIAL_SS, '
         || ' a.BULK_MATERIAL, '
         || ' 0 FIXED_QTY_SS, '
         || ' a.FIXED_QTY, '
         || ' 0 BOOLEAN_1_SS, '
         || ' a.BOOLEAN_1, '
         || ' 0 BOOLEAN_2_SS, '
         || ' a.BOOLEAN_2, '
         || ' 0 BOOLEAN_3_SS, '
         || ' a.BOOLEAN_3, '
         || ' 0 BOOLEAN_4_SS, '
         || ' a.BOOLEAN_4 '
         || ', 0 '
         || ', a.INTL_EQUIVALENT '
         || ' FROM Bom_ITEM a '
         || ' WHERE a.part_no = :asPartNo '
         || '  AND a.revision = :anRevision '
         || ' AND ( a.PLANT = :asPlant OR :asPlant IS NULL ) '
         || ' AND ( a.ALTERNATIVE = :anAlternative OR :anAlternative IS NULL ) '
         || ' AND (    a.Bom_USAGE = :anUsage OR :anUsage IS NULL ) '
         || ' AND NOT EXISTS( '
         || ' SELECT part_no '
         || ' FROM Bom_ITEM '
         || ' WHERE part_no = :asPartNo2 '
         || ' AND revision = :anRevision2 '
         || ' AND ( PLANT = :asPlant2 OR ( :asPlant2 IS NULL AND plant = a.plant ) ) '
         || ' AND ( ALTERNATIVE = :anAlternative2 OR ( :anAlternative2 IS NULL AND alternative = a.alternative ) ) '
         || ' AND ( Bom_USAGE = :anUsage2 OR ( :anUsage2 IS NULL AND Bom_usage = a.Bom_usage ) ) '
         || ' AND COMPONENT_PART = a.COMPONENT_PART ) ';
      LSSQL :=
            LSSQL
         || ' UNION ALL '
         || ' SELECT   2 BI_STATUS, '
         || ' a.PART_NO, '
         || ' a.REVISION, '
         || ' a.PLANT, '
         || ' a.ALTERNATIVE, '
         || ' a.Bom_USAGE, '
         || ' a.ITEM_NUMBER, '
         || ' a.COMPONENT_PART, '
         || ' 0 COMPONENT_REVISION_SS, '
         || ' a.COMPONENT_REVISION, '
         || ' f_sh_descr( 1, a.component_part, a.component_revision ) component_description, '
         || ' 0 COMPONENT_PLANT_SS, '
         || ' a.COMPONENT_PLANT, '
         || ' 0 QUANTITY_SS, '
         || ' a.QUANTITY, '
         || ' 0 UOM_SS, '
         || ' a.UOM, '
         || ' 0 CONV_FACTOR_SS, '
         || ' round(a.CONV_FACTOR,10), '
         || ' 0 TO_UNIT_SS, '
         || ' a.TO_UNIT, '
         || ' 0 YIELD_SS, '
         || ' a.YIELD, '
         || ' 0 ASSEMBLY_SCRAP_SS, '
         || ' a.ASSEMBLY_SCRAP, '
         || ' 0 COMPONENT_SCRAP_SS, '
         || ' a.COMPONENT_SCRAP, '
         || ' 0 LEAD_TIME_OFFSET_SS, '
         || ' a.LEAD_TIME_OFFSET, '
         || ' 0 ITEM_CATEGORY_SS, '
         || ' a.ITEM_CATEGORY, '
         || ' 0 ISSUE_LOCATION_SS, '
         || ' a.ISSUE_LOCATION, '
         || ' 0 CALC_FLAG_SS, '
         || ' a.CALC_FLAG, '
         || ' 0 Bom_ITEM_Type_SS, '
         || ' a.Bom_ITEM_Type, '
         || ' 0 OPERATIONAL_STEP_SS, '
         || ' a.OPERATIONAL_STEP, '
         || ' 0 MIN_QTY_SS, '
         || ' a.MIN_QTY, '
         || ' 0 MAX_QTY_SS, '
         || ' a.MAX_QTY, '
         || ' 0 CODE_SS, '
         || ' a.CODE, '
         || ' 0 ALT_GROUP_SS, '
         || ' a.ALT_GROUP, '
         || ' 0 ALT_PRIORITY_SS, '
         || ' a.ALT_PRIORITY, '
         || ' 0 NUM_1_SS, '
         || ' round(a.NUM_1,10), '
         || ' 0 NUM_2_SS, '
         || ' round(a.NUM_2,10), '
         || ' 0 NUM_3_SS, '
         || ' round(a.NUM_3,10), '
         || ' 0 NUM_4_SS, '
         || ' round(a.NUM_4,10), '
         || ' 0 NUM_5_SS, '
         || ' round(a.NUM_5,10), '
         || ' 0 CHAR_1_SS, '
         || ' a.CHAR_1, '
         || ' 0 CHAR_2_SS, '
         || ' a.CHAR_2, '
         || ' 0 CHAR_3_SS, '
         || ' a.CHAR_3, '
         || ' 0 CHAR_4_SS, '
         || ' a.CHAR_4, '
         || ' 0 CHAR_5_SS, '
         || ' a.CHAR_5, '
         || ' 0 DATE_1_SS, '
         || ' a.DATE_1, '
         || ' 0 DATE_2_SS, '
         || ' a.DATE_2, '
         || ' 0 CH1_SS, '
         || ' f_chh_descr( 1, a.CH_1, a.CH_REV_1 ) CH1, '
         || ' 0 CH2_SS, '
         || ' f_chh_descr( 1, a.CH_2, a.CH_REV_2 ) CH2, '
         || ' 0 CH3_SS, '
         || ' f_chh_descr( 1, a.CH_3, a.CH_REV_3 ) CH3, '
         || ' 0 RELEVENCY_TO_COSTING_SS, '
         || ' a.RELEVENCY_TO_COSTING, '
         || ' 0 BULK_MATERIAL_SS, '
         || ' a.BULK_MATERIAL, '
         || ' 0 FIXED_QTY_SS, '
         || ' a.FIXED_QTY, '
         || ' 0 BOOLEAN_1_SS, '
         || ' a.BOOLEAN_1, '
         || ' 0 BOOLEAN_2_SS, '
         || ' a.BOOLEAN_2, '
         || ' 0 BOOLEAN_3_SS, '
         || ' a.BOOLEAN_3, '
         || ' 0 BOOLEAN_4_SS, '
         || ' a.BOOLEAN_4 '
         || ', 0 '
         || ', a.INTL_EQUIVALENT '
         || ' FROM Bom_ITEM a '
         || ' WHERE a.part_no = :asPartNo2 '
         || ' AND a.revision = :anRevision2 '
         || ' AND ( a.PLANT = :asPlant2 OR :asPlant2 IS NULL ) '
         || ' AND ( a.ALTERNATIVE = :anAlternative2 OR :anAlternative2 IS NULL ) '
         || ' AND ( a.Bom_USAGE = :anUsage2 OR :anUsage2 IS NULL ) '
         || ' AND NOT EXISTS( '
         || ' SELECT part_no '
         || ' FROM Bom_ITEM '
         || ' WHERE part_no = :asPartNo '
         || ' AND revision = :anRevision '
         || ' AND ( PLANT = :asPlant OR ( :asPlant IS NULL AND plant = a.plant ) ) '
         || ' AND ( ALTERNATIVE = :anAlternative OR ( :anAlternative IS NULL AND alternative = a.alternative ) ) '
         || ' AND ( Bom_USAGE = :anUsage OR ( :anUsage IS NULL AND Bom_usage = a.Bom_usage ) ) '
         || ' AND COMPONENT_PART = a.COMPONENT_PART ) ';
      LSSQL :=    LSSQL
               || ' ORDER BY 2, 3, 4, 5, 6, 7 ';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      
      OPEN AQBOMS FOR LSSQL
      USING ASPARTNO2,
            ANREVISION2,
            ASPARTNO,
            ANREVISION,
            ASPLANT,
            ASPLANT,
            ANALTERNATIVE,
            ANALTERNATIVE,
            ANUSAGE,
            ANUSAGE,
            ASPARTNO2,
            ANREVISION2,
            ASPLANT2,
            ASPLANT2,
            ANALTERNATIVE2,
            ANALTERNATIVE2,
            ANUSAGE2,
            ANUSAGE2,
            ASPARTNO,
            ANREVISION,
            ASPARTNO2,
            ANREVISION2,
            ASPLANT2,
            ASPLANT2,
            ANALTERNATIVE2,
            ANALTERNATIVE2,
            ANUSAGE2,
            ANUSAGE2,
            ASPARTNO,
            ANREVISION,
            ASPLANT,
            ASPLANT,
            ANALTERNATIVE,
            ANALTERNATIVE,
            ANUSAGE,
            ANUSAGE,
            ASPARTNO,
            ANREVISION,
            ASPLANT,
            ASPLANT,
            ANALTERNATIVE,
            ANALTERNATIVE,
            ANUSAGE,
            ANUSAGE,
            ASPARTNO2,
            ANREVISION2,
            ASPLANT2,
            ASPLANT2,
            ANALTERNATIVE2,
            ANALTERNATIVE2,
            ANUSAGE2,
            ANUSAGE2,
            ASPARTNO2,
            ANREVISION2,
            ASPLANT2,
            ASPLANT2,
            ANALTERNATIVE2,
            ANALTERNATIVE2,
            ANUSAGE2,
            ANUSAGE2,
            ASPARTNO,
            ANREVISION,
            ASPLANT,
            ASPLANT,
            ANALTERNATIVE,
            ANALTERNATIVE,
            ANUSAGE,
            ANUSAGE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETBOMITEMS;


   FUNCTION GETLOCALISEDBOMHEADERS

   (
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASINTLPLANT                IN       IAPITYPE.PLANT_TYPE,
      ANINTLALTERNATIVE          IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANINTLBOMUSAGE             IN       IAPITYPE.BOMUSAGE_TYPE,
      AQBOMS                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetLocalisedBomHeaders';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSSQL                         VARCHAR2( 8192 );
      LSSQLBHKEY                    VARCHAR2( 1000 );
      LSSQLNOCOMP                   VARCHAR2( 4000 );
      LSSQLCOMP                     VARCHAR2( 4000 );
      LSPARTNO                      IAPITYPE.PARTNO_TYPE := NULL;
      LNREVISION                    IAPITYPE.REVISION_TYPE := NULL;



   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=
            'SELECT Bom_HEADER.PART_NO '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', Bom_HEADER.REVISION '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', Bom_HEADER.PLANT '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', Bom_HEADER.ALTERNATIVE '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', Bom_HEADER.Bom_USAGE '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', f_bu_descr(Bom_HEADER.Bom_USAGE) '
         || IAPICONSTANTCOLUMN.BOMUSAGEDESCRIPTIONCOL
         || ', Bom_HEADER.DESCRIPTION '
         || IAPICONSTANTCOLUMN.BOMDESCRIPTIONCOL
         || ', a.INT_PART_NO '
         || IAPICONSTANTCOLUMN.INTERNATIONALPARTNOCOL
         || ', a.INT_PART_REV '
         || IAPICONSTANTCOLUMN.INTERNATIONALREVISIONCOL
         || ', iapiCompare.GetCompareLocalisedBHStatus('
         || '  Bom_HEADER.PART_NO, Bom_HEADER.REVISION, Bom_HEADER.PLANT, Bom_HEADER.ALTERNATIVE, Bom_HEADER.Bom_USAGE'
         || ', :asIntlPlant, :anIntlAlternative, :anIntlBomUsage ) '
         || IAPICONSTANTCOLUMN.BOMHEADERCMPSTATUSCOL
         || ', a.DESCRIPTION '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ', b.DESCRIPTION '
         || IAPICONSTANTCOLUMN.INTERNATIONALDESCRIPTIONCOL
         || ' FROM PART_PLANT, Bom_HEADER, SPECIFICATION_HEADER a, SPECIFICATION_HEADER b'
         || ' WHERE PART_PLANT.PLANT = Bom_HEADER.PLANT'
         || ' AND PART_PLANT.PART_NO = Bom_HEADER.PART_NO'
         || ' AND Bom_HEADER.PART_NO = a.PART_NO'
         || ' AND Bom_HEADER.REVISION = a.REVISION'
         || ' AND a.INT_PART_NO = b.PART_NO'
         || ' AND a.INT_PART_REV = b.REVISION'
         || ' AND a.INT_PART_NO IS NOT NULL'
         || ' AND Bom_HEADER.PART_NO = :asPartNo'
         || ' AND Bom_HEADER.REVISION = :anRevision';

      IF ( AQBOMS%ISOPEN )
      THEN
         CLOSE AQBOMS;
      END IF;




      OPEN AQBOMS FOR LSSQL USING ASINTLPLANT,
      ANINTLALTERNATIVE,
      ANINTLBOMUSAGE,
      LSPARTNO,   
      LNREVISION;   

      LNRETVAL := IAPISPECIFICATIONACCESS.GETVIEWACCESS( ASPARTNO,
                                                         ANREVISION,
                                                         LNACCESS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF LNACCESS = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOVIEWACCESS,
                                                    ASPARTNO,
                                                    ANREVISION );
      END IF;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.VIEWBOMALLOWED = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOVIEWBOMACCESS,
                                                    IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );
      END IF;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
      THEN   
         LSSQL :=    LSSQL
                  || ' AND PART_PLANT.PLANT_ACCESS = ''Y'''
                  || ' AND Bom_HEADER.PLANT IN (SELECT PLANT FROM ITUP WHERE USER_ID = :UserId)';
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY 1, 2, 3, 4';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
      THEN
         OPEN AQBOMS FOR LSSQL USING ASINTLPLANT,
         ANINTLALTERNATIVE,
         ANINTLBOMUSAGE,
         ASPARTNO,
         ANREVISION,
         IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
      ELSE
         OPEN AQBOMS FOR LSSQL USING ASINTLPLANT,
         ANINTLALTERNATIVE,
         ANINTLBOMUSAGE,
         ASPARTNO,
         ANREVISION;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETLOCALISEDBOMHEADERS;


   FUNCTION GETLOCALISEDBOMITEMS

   (
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE,
      ASINTLPLANT                IN       IAPITYPE.PLANT_TYPE,
      ANINTLALTERNATIVE          IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANINTLBOMUSAGE             IN       IAPITYPE.BOMUSAGE_TYPE,
      AQBOMS                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetLocalisedBomItems';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSINTLPARTNO                  IAPITYPE.PARTNO_TYPE;
      LNINTLREVISION                IAPITYPE.REVISION_TYPE;
      LNBASEQUANTITY                IAPITYPE.BOMQUANTITY_TYPE;
      LSSQL                         VARCHAR2( 12288 );
      LSPARTNO                      IAPITYPE.PARTNO_TYPE := NULL;
      LNREVISION                    IAPITYPE.REVISION_TYPE := NULL;



   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=
            ' SELECT '
         || ' iapiCompare.GetCompareLocalisedBIStatus( 1,:lsIntlPartNo,:lnIntlRevision,b.PLANT,b.ALTERNATIVE, '
         || ' b.Bom_USAGE,f_get_intl_part( a.COMPONENT_PART ),a.COMPONENT_REVISION,a.COMPONENT_PLANT, '
         || ' a.ITEM_NUMBER,a.QUANTITY,a.UOM,a.YIELD )  '
         || IAPICONSTANTCOLUMN.BOMITEMCMPSTATUSCOL
         || ', a.PART_NO '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', a.REVISION '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', a.PLANT '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', a.ALTERNATIVE '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', a.Bom_USAGE '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', a.COMPONENT_PART '
         || IAPICONSTANTCOLUMN.COMPONENTPARTNOCOL
         || ', f_sh_descr( 1, a.component_part, a.component_revision ) '
         || IAPICONSTANTCOLUMN.COMPONENTDESCRIPTIONCOL
         || ', DECODE( a.COMPONENT_REVISION, b.COMPONENT_REVISION, 0, 1 )  '
         || IAPICONSTANTCOLUMN.COMPONENTREVISIONCMPSTATUSCOL
         || ', a.COMPONENT_REVISION '
         || IAPICONSTANTCOLUMN.COMPONENTREVISIONCOL
         || ', DECODE( a.COMPONENT_PLANT, b.COMPONENT_PLANT, 0, 1 )  '
         || IAPICONSTANTCOLUMN.COMPONENTPLANTCMPSTATUSCOL
         || ', a.COMPONENT_PLANT '
         || IAPICONSTANTCOLUMN.COMPONENTPLANTCOL
         || ', DECODE( a.ITEM_NUMBER, b.ITEM_NUMBER, 0, 1 )  '
         || IAPICONSTANTCOLUMN.ITEMNUMBERCMPSTATUSCOL
         || ', a.ITEM_NUMBER '
         || IAPICONSTANTCOLUMN.ITEMNUMBERCOL
         || ', DECODE( a.QUANTITY, b.QUANTITY, 0, 1 )  '
         || IAPICONSTANTCOLUMN.QUANTITYCMPSTATUSCOL
         || ', a.QUANTITY '
         || IAPICONSTANTCOLUMN.QUANTITYCOL
         || ', TRUNC( ( a.QUANTITY * ( NVL( a.YIELD,100 ) / 100 ) )/ :lnBaseQuantity, 6 )  '
         || IAPICONSTANTCOLUMN.RELATIVEQUANTITYCOL
         || ', DECODE( a.UOM, b.UOM, 0, 1 )  '
         || IAPICONSTANTCOLUMN.UOMCMPSTATUSCOL
         || ', a.UOM '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ', DECODE( a.YIELD, b.YIELD, 0, 1 )  '
         || IAPICONSTANTCOLUMN.YIELDCMPSTATUSCOL
         || ', a.YIELD '
         || IAPICONSTANTCOLUMN.YIELDCOL
         || ', a.ALT_PRIORITY '
         || IAPICONSTANTCOLUMN.ALTERNATIVEPRIORITYCOL
         || ', DECODE( a.ALT_PRIORITY, b.ALT_PRIORITY, 0, 1 )  '
         || IAPICONSTANTCOLUMN.ALTERNATIVEPRIOCMPSTATUSCOL
         || ', a.ALT_GROUP '
         || IAPICONSTANTCOLUMN.ALTERNATIVEGROUPCOL
         || ', DECODE( a.ALT_GROUP, b.ALT_GROUP, 0, 1 )  '
         || IAPICONSTANTCOLUMN.ALTERNATIVEGROUPCMPSTATUSCOL
         || ' FROM Bom_ITEM a, Bom_ITEM b '
         || ' WHERE a.part_no = :asPartNo '
         || ' AND a.revision = :anRevision '
         || ' AND a.PLANT = :asPlant '
         || ' AND a.ALTERNATIVE = :anAlternative '
         || ' AND a.Bom_USAGE = :anUsage '
         || ' AND b.part_no = :lsIntlPartNo '
         || ' AND b.revision = :lnIntlRevision '
         || ' AND b.PLANT = :asIntlPlant '
         || ' AND b.ALTERNATIVE = :anIntlAlternative '
         || ' AND b.Bom_USAGE = :anIntlBomUsage '
         || ' AND ( a.COMPONENT_PART = b.COMPONENT_PART OR f_get_intl_part( a.COMPONENT_PART ) = b.COMPONENT_PART ) ';




      OPEN AQBOMS FOR LSSQL
      USING LSINTLPARTNO,
            LNINTLREVISION,
            LNBASEQUANTITY,
            LSPARTNO,   
            LNREVISION,   
            ASPLANT,
            ANALTERNATIVE,
            ANUSAGE,
            LSINTLPARTNO,
            LNINTLREVISION,
            ASINTLPLANT,
            ANINTLALTERNATIVE,
            ANINTLBOMUSAGE;

      IF ( AQBOMS%ISOPEN )
      THEN
         CLOSE AQBOMS;
      END IF;

      LNRETVAL := IAPISPECIFICATIONACCESS.GETVIEWACCESS( ASPARTNO,
                                                         ANREVISION,
                                                         LNACCESS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF LNACCESS = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOVIEWACCESS,
                                                    ASPARTNO,
                                                    ANREVISION );
      END IF;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.VIEWBOMALLOWED = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOVIEWBOMACCESS,
                                                    IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );
      END IF;

      
      SELECT INT_PART_NO,
             INT_PART_REV
        INTO LSINTLPARTNO,
             LNINTLREVISION
        FROM SPECIFICATION_HEADER
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION;

      IF NOT( LNINTLREVISION > 0 )
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOTLOCALISED,
                                                    ASPARTNO,
                                                    ANREVISION );
      END IF;

      SELECT BASE_QUANTITY
        INTO LNBASEQUANTITY
        FROM BOM_HEADER
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANT
         AND ALTERNATIVE = ANALTERNATIVE
         AND BOM_USAGE = ANUSAGE;

      LSSQL :=
            LSSQL
         || ' UNION ALL '
         || ' SELECT '
         || ' iapiCompare.GetCompareLocalisedBIStatus( 2,:asPartNo,:anRevision,b.PLANT,b.ALTERNATIVE, '
         || ' b.Bom_USAGE,a.COMPONENT_PART,a.COMPONENT_REVISION,a.COMPONENT_PLANT, '
         || ' a.ITEM_NUMBER,a.QUANTITY,a.UOM,a.YIELD ) BI_STATUS, '
         || ' a.PART_NO, '
         || ' a.REVISION, '
         || ' a.PLANT, '
         || ' a.ALTERNATIVE, '
         || ' a.Bom_USAGE, '
         || ' a.COMPONENT_PART, '
         || ' f_sh_descr( 1,a.component_part,a.component_revision ), '
         || ' DECODE( a.COMPONENT_REVISION, b.COMPONENT_REVISION, 0, 1 ) COMPONENT_REVISION_SS, '
         || ' a.COMPONENT_REVISION, '
         || ' DECODE( a.COMPONENT_PLANT, b.COMPONENT_PLANT, 0, 1 ) COMPONENT_PLANT_SS, '
         || ' a.COMPONENT_PLANT, '
         || ' DECODE( a.ITEM_NUMBER, b.ITEM_NUMBER, 0, 1 ) ITEM_NUMBER_SS, '
         || ' a.ITEM_NUMBER, '
         || ' DECODE( a.QUANTITY, b.QUANTITY, 0, 1 ) QUANTITY_SS, '
         || ' a.QUANTITY, '
         || ' TRUNC( ( a.QUANTITY * ( NVL( a.YIELD, 100 ) / 100 ) ) / :lnBaseQuantity, 6 ) RELATIVE_QTY, '
         || ' DECODE( a.UOM, b.UOM, 0, 1 ) UOM_SS, '
         || ' a.UOM, '
         || ' DECODE( a.YIELD, b.YIELD, 0, 1 ) YIELD_SS, '
         || ' a.YIELD, '
         || ' a.ALT_PRIORITY, '
         || ' DECODE( a.ALT_PRIORITY, b.ALT_PRIORITY, 0, 1 ) ALT_PRIORITY_SS, '
         || ' a.ALT_GROUP, '
         || ' DECODE( a.ALT_GROUP, b.ALT_GROUP, 0, 1 ) ALT_GROUP_SS '
         || ' FROM Bom_ITEM a, Bom_ITEM b '
         || ' WHERE a.part_no = :lsIntlPartNo '
         || ' AND a.revision = :lnIntlRevision '
         || ' AND a.PLANT = :asIntlPlant '
         || ' AND a.ALTERNATIVE = :anIntlAlternative '
         || ' AND a.Bom_USAGE = :anIntlBomUsage '
         || ' AND b.part_no = :asPartNo '
         || ' AND b.revision = :anRevision '
         || ' AND b.PLANT = :asPlant '
         || ' AND b.ALTERNATIVE = :anAlternative '
         || ' AND b.Bom_USAGE = :anUsage '
         || ' AND ( a.COMPONENT_PART = b.COMPONENT_PART OR a.COMPONENT_PART = f_get_intl_part( b.COMPONENT_PART ) ) ';
      LSSQL :=
            LSSQL
         || ' UNION ALL '
         || ' SELECT '
         || ' 1 BI_STATUS, '
         || ' a.PART_NO, '
         || ' a.REVISION, '
         || ' a.PLANT, '
         || ' a.ALTERNATIVE, '
         || ' a.Bom_USAGE, '
         || ' a.COMPONENT_PART, '
         || ' f_sh_descr( 1, a.component_part, a.component_revision ), '
         || ' 0 COMPONENT_REVISION_SS, '
         || ' a.COMPONENT_REVISION, '
         || ' 0 COMPONENT_PLANT_SS, '
         || ' a.COMPONENT_PLANT, '
         || ' 0 ITEM_NUMBER_SS, '
         || ' a.ITEM_NUMBER, '
         || ' 0 QUANTITY_SS, '
         || ' a.QUANTITY, '
         || ' TRUNC( ( a.QUANTITY * ( NVL( a.YIELD, 100 ) / 100 ) ) / :lnBaseQuantity, 6 ) RELATIVE_QTY, '
         || ' 0 UOM_SS, '
         || ' a.UOM, '
         || ' 0 YIELD_SS, '
         || ' a.YIELD, '
         || ' a.ALT_PRIORITY, '
         || ' 0 ALT_PRIORITY_SS, '
         || ' a.ALT_GROUP, '
         || ' 0 ALT_GROUP_SS '
         || ' FROM Bom_ITEM a '
         || ' WHERE a.part_no = :asPartNo '
         || ' AND a.revision = :anRevision '
         || ' AND a.PLANT = :asPlant '
         || ' AND a.ALTERNATIVE = :anAlternative '
         || ' AND a.Bom_USAGE = :anUsage '
         || ' AND NOT EXISTS( '
         || ' SELECT part_no '
         || ' FROM Bom_ITEM '
         || ' WHERE part_no = :lsIntlPartNo '
         || ' AND revision = :lnIntlRevision '
         || ' AND plant = :asIntlPlant '
         || ' AND alternative = :anIntlAlternative '
         || ' AND Bom_usage = :anIntlBomUsage '
         || ' AND ( COMPONENT_PART = a.COMPONENT_PART OR f_get_intl_part( a.COMPONENT_PART ) = COMPONENT_PART ) ) ';
      LSSQL :=
            LSSQL
         || ' UNION ALL '
         || ' SELECT '
         || ' 2 BI_STATUS, '
         || ' a.PART_NO, '
         || ' a.REVISION, '
         || ' a.PLANT, '
         || ' a.ALTERNATIVE, '
         || ' a.Bom_USAGE, '
         || ' a.COMPONENT_PART, '
         || ' f_sh_descr( 1, a.component_part, a.component_revision ), '
         || ' 0 COMPONENT_REVISION_SS, '
         || ' a.COMPONENT_REVISION, '
         || ' 0 COMPONENT_PLANT_SS, '
         || ' a.COMPONENT_PLANT, '
         || ' 0 ITEM_NUMBER_SS, '
         || ' a.ITEM_NUMBER, '
         || ' 0 QUANTITY_SS, '
         || ' a.QUANTITY, '
         || ' TRUNC( ( a.QUANTITY * ( NVL( a.YIELD, 100 ) / 100 ) ) / :lnBaseQuantity, 6 ) RELATIVE_QTY, '
         || ' 0 UOM_SS, '
         || ' a.UOM, '
         || ' 0 YIELD_SS, '
         || ' a.YIELD, '
         || ' a.ALT_PRIORITY, '
         || ' 0 ALT_PRIORITY_SS, '
         || ' a.ALT_GROUP, '
         || ' 0 ALT_GROUP_SS '
         || ' FROM Bom_ITEM a '
         || ' WHERE a.part_no = :lsIntlPartNo '
         || ' AND a.revision = :lnIntlRevision '
         || ' AND a.PLANT = :asIntlPlant '
         || ' AND a.ALTERNATIVE = :anIntlAlternative '
         || ' AND a.Bom_USAGE = :anIntlBomUsage '
         || ' AND NOT EXISTS( '
         || ' SELECT part_no '
         || ' FROM Bom_ITEM '
         || ' WHERE part_no = :asPartNo '
         || ' AND revision = :anRevision '
         || ' AND plant = :asPlant '
         || ' AND alternative = :anAlternative '
         || ' AND Bom_usage = :anUsage '
         || ' AND ( COMPONENT_PART = a.COMPONENT_PART OR f_get_intl_part( COMPONENT_PART ) = a.COMPONENT_PART ) ) ';
      LSSQL :=    LSSQL
               || 'ORDER BY 14, 2, 3, 4, 5, 6 ';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      OPEN AQBOMS FOR LSSQL
      USING LSINTLPARTNO,
            LNINTLREVISION,
            LNBASEQUANTITY,
            ASPARTNO,
            ANREVISION,
            ASPLANT,
            ANALTERNATIVE,
            ANUSAGE,
            LSINTLPARTNO,
            LNINTLREVISION,
            ASINTLPLANT,
            ANINTLALTERNATIVE,
            ANINTLBOMUSAGE,
            ASPARTNO,
            ANREVISION,
            LNBASEQUANTITY,
            LSINTLPARTNO,
            LNINTLREVISION,
            ASINTLPLANT,
            ANINTLALTERNATIVE,
            ANINTLBOMUSAGE,
            ASPARTNO,
            ANREVISION,
            ASPLANT,
            ANALTERNATIVE,
            ANUSAGE,
            LNBASEQUANTITY,
            ASPARTNO,
            ANREVISION,
            ASPLANT,
            ANALTERNATIVE,
            ANUSAGE,
            LSINTLPARTNO,
            LNINTLREVISION,
            ASINTLPLANT,
            ANINTLALTERNATIVE,
            ANINTLBOMUSAGE,
            LNBASEQUANTITY,
            LSINTLPARTNO,
            LNINTLREVISION,
            ASINTLPLANT,
            ANINTLALTERNATIVE,
            ANINTLBOMUSAGE,
            ASPARTNO,
            ANREVISION,
            ASPLANT,
            ANALTERNATIVE,
            ANUSAGE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETLOCALISEDBOMITEMS;

   
   FUNCTION GETCOMPARELABELDETAILS(
      ANLOGID1                   IN       IAPITYPE.ID_TYPE,
      ANLOGID2                   IN       IAPITYPE.ID_TYPE,
      AQLABELCOMMONDETAILS       OUT      IAPITYPE.REF_TYPE,
      AQLABELUNIQUEDETAILS       OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetCompareLabelDetails';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTLOGSEQUENCETAB1             SPNUMTABLE_TYPE DEFAULT SPNUMTABLE_TYPE( );
      LTLOGSEQUENCETAB2             SPNUMTABLE_TYPE DEFAULT SPNUMTABLE_TYPE( );
      LSSELECTCOMMMONLOG1           VARCHAR2( 4000 )
         :=    ' SELECT '
            || ' decode(log1.Ingredient '
            || '||log1.is_in_group '
            || '||log1.is_in_function '
            || '||log1.description '
            || '||log1.quantity '
            || '||to_char(log1.note) '
            || '||log1.rec_from_id '
            || '||log1.rec_from_description '
            || '||log1.rec_with_id '
            || '||log1.rec_with_description '
            || '||log1.show_rec '
            || '||log1.active_ingredient '
            || '||log1.quid '
            || '||log1.use_perc '
            || '||log1.show_items '
            || '||log1.use_perc_rel '
            || '||log1.use_perc_abs '
            || '||log1.use_brackets '
            || '||log1.allergen '
            || '||log1.soi '
            || '||log1.complex_label_log_id '
            || '||log1.paragraph '
            || '||log1.sort_sequence_no '
            || ', log2.Ingredient '
            || '||log2.is_in_group '
            || '||log2.is_in_function '
            || '||log2.description '
            || '||log2.quantity '
            || '||to_char(log2.note) '
            || '||log2.rec_from_id '
            || '||log2.rec_from_description '
            || '||log2.rec_with_id '
            || '||log2.rec_with_description '
            || '||log2.show_rec '
            || '||log2.active_ingredient '
            || '||log2.quid '
            || '||log2.use_perc '
            || '||log2.show_items '
            || '||log2.use_perc_rel '
            || '||log2.use_perc_abs '
            || '||log2.use_brackets '
            || '||log2.allergen '
            || '||log2.soi '
            || '||log2.complex_label_log_id '
            || '||log2.paragraph '
            || '||log2.sort_sequence_no '
            || ',0,3) '
            || IAPICONSTANTCOLUMN.LABELITEMCMPSTATUSCOL
            || ' ,log1.log_id '
            || IAPICONSTANTCOLUMN.LOGIDCOL
            || ' ,log1.sequence_no '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ' ,log1.parent_sequence_no '
            || IAPICONSTANTCOLUMN.PARENTSEQUENCECOL
            || ' ,log1.bom_level '
            || IAPICONSTANTCOLUMN.BOMLEVELCOL
            || ' ,decode(log1.bom_level,log2.bom_level,0,1) '
            || IAPICONSTANTCOLUMN.BOMLEVELCMPSTATUSCOL
            || ' ,log1.ingredient '
            || IAPICONSTANTCOLUMN.INGREDIENTIDCOL
            || ' ,decode(log1.ingredient,log2.ingredient,0,1) '
            || IAPICONSTANTCOLUMN.INGREDIENTIDCMPSTATUSCOL
            || ' ,log1.is_in_group '
            || IAPICONSTANTCOLUMN.ISINGROUPCOL
            || ' ,decode(log1.is_in_group,log2.is_in_group,0,1) '
            || IAPICONSTANTCOLUMN.ISINGROUPCMPSTATUSCOL
            || ' ,log1.is_in_function '
            || IAPICONSTANTCOLUMN.ISINFUNCTIONCOL
            || ' ,decode(log1.is_in_function,log2.is_in_function,0,1) '
            || IAPICONSTANTCOLUMN.ISINFUNCTIONCMPSTATUSCOL
            || ' ,log1.description '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ' ,decode(log1.description,log2.description,0,1) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCMPSTATUSCOL
            || ' ,log1.quantity '
            || IAPICONSTANTCOLUMN.QUANTITYCOL
            || ' ,decode(log1.quantity,log2.quantity,0,1) '
            || IAPICONSTANTCOLUMN.QUANTITYCMPSTATUSCOL
            || ' ,log1.note '
            || IAPICONSTANTCOLUMN.NOTECOL
            || ' ,decode(log1.note,log2.note,0,1) '
            || IAPICONSTANTCOLUMN.NOTECMPSTATUSCOL
            || ' ,log1.rec_from_id '
            || IAPICONSTANTCOLUMN.RECFROMIDCOL
            || ' ,decode(log1.rec_from_id,log2.rec_from_id,0,1) '
            || IAPICONSTANTCOLUMN.RECFROMIDCMPSTATUSCOL
            || ' ,log1.rec_from_description '
            || IAPICONSTANTCOLUMN.RECFROMDESCRIPTIONCOL
            || ' ,decode(log1.rec_from_description,log2.rec_from_description,0,1) '
            || IAPICONSTANTCOLUMN.RECFROMDESCRIPTIONCMPSTATUSCOL
            || ' ,log1.rec_with_id '
            || IAPICONSTANTCOLUMN.RECWITHIDCOL
            || ' ,decode(log1.rec_with_id,log2.rec_with_id,0,1) '
            || IAPICONSTANTCOLUMN.RECWITHIDCMPSTATUSCOL
            || ' ,log1.rec_with_description '
            || IAPICONSTANTCOLUMN.RECWITHDESCRIPTIONCOL
            || ' ,decode(log1.rec_with_description,log2.rec_with_description,0,1) '
            || IAPICONSTANTCOLUMN.RECWITHDESCRIPTIONCMPSTATUSCOL
            || ' ,log1.show_rec '
            || IAPICONSTANTCOLUMN.SHOWRECONSTITUTESCOL
            || ' ,decode(log1.show_rec,log2.show_rec,0,1) '
            || IAPICONSTANTCOLUMN.SHOWRECONSTITUTESCMPSTATUSCOL
            || ' ,log1.active_ingredient '
            || IAPICONSTANTCOLUMN.ACTIVEINGREDIENTCOL
            || ' ,decode(log1.active_ingredient,log2.active_ingredient,0,1) '
            || IAPICONSTANTCOLUMN.ACTIVEINGREDIENTCMPSTATUSCOL
            || ' ,log1.quid '
            || IAPICONSTANTCOLUMN.QUIDCOL
            || ' ,decode(log1.quid,log2.quid,0,1) '
            || IAPICONSTANTCOLUMN.QUIDCMPSTATUSCOL
            || ' ,log1.use_perc '
            || IAPICONSTANTCOLUMN.USEPERCENTAGECOL
            || ' ,decode(log1.use_perc,log2.use_perc,0,1) '
            || IAPICONSTANTCOLUMN.USEPERCENTAGECMPSTATUSCOL
            || ' ,log1.show_items '
            || IAPICONSTANTCOLUMN.SHOWITEMSCOL
            || ' ,decode(log1.show_items,log2.show_items,0,1) '
            || IAPICONSTANTCOLUMN.SHOWITEMSCMPSTATUSCOL
            || ' ,log1.use_perc_rel '
            || IAPICONSTANTCOLUMN.USEPERCRELCOL
            || ' ,decode(log1.use_perc_rel,log2.use_perc_rel,0,1) '
            || IAPICONSTANTCOLUMN.USEPERCRELCMPSTATUSCOL
            || ' ,log1.use_perc_abs '
            || IAPICONSTANTCOLUMN.USEPERCABSCOL
            || ' ,decode(log1.use_perc_abs,log2.use_perc_abs,0,1) '
            || IAPICONSTANTCOLUMN.USEPERCABSCMPSTATUSCOL
            || ' ,log1.use_brackets '
            || IAPICONSTANTCOLUMN.USEBRACKETSCOL
            || ' ,decode(log1.use_brackets,log2.use_brackets,0,1) '
            || IAPICONSTANTCOLUMN.USEBRACKETSCMPSTATUSCOL
            || ' ,log1.allergen '
            || IAPICONSTANTCOLUMN.ALLERGENCOL
            || ' ,decode(log1.allergen,log2.allergen,0,1) '
            || IAPICONSTANTCOLUMN.ALLERGENCMPSTATUSCOL
            || ' ,log1.soi '
            || IAPICONSTANTCOLUMN.SOICOL
            || ' ,decode(log1.soi,log2.soi,0,1) '
            || IAPICONSTANTCOLUMN.SOICMPSTATUSCOL
            || ' ,log1.complex_label_log_id '
            || IAPICONSTANTCOLUMN.COMPLEXLABELLOGIDCOL
            || ' ,decode(log1.complex_label_log_id,log2.complex_label_log_id,0,1) '
            || IAPICONSTANTCOLUMN.COMPLEXLABELLOGIDCMPSTATUSCOL
            || ' ,(select log_name from itlabellog lg where lg.log_id = log1.complex_label_log_id ) '
            || IAPICONSTANTCOLUMN.COMPLEXLABELLOGCOL
            || ' ,log1.paragraph '
            || IAPICONSTANTCOLUMN.PARAGRAPHCOL
            || ' ,decode(log1.paragraph,log2.paragraph,0,1) '
            || IAPICONSTANTCOLUMN.PARAGRAPHCMPSTATUSCOL
            || ' ,log1.sort_sequence_no '
            || IAPICONSTANTCOLUMN.SORTSEQUENCECOL
            || ' ,decode(log1.sort_sequence_no,log2.sort_sequence_no,0,1) '
            || IAPICONSTANTCOLUMN.SORTSEQUENCECMPSTATUSCOL;
      LSSELECTCOMMMONLOG2           VARCHAR2( 4000 )
         :=    ' SELECT '
            || ' decode(log2.Ingredient '
            || '||log2.is_in_group '
            || '||log2.is_in_function '
            || '||log2.description '
            || '||log2.quantity '
            || '||to_char(log2.note) '
            || '||log2.rec_from_id '
            || '||log2.rec_from_description '
            || '||log2.rec_with_id '
            || '||log2.rec_with_description '
            || '||log2.show_rec '
            || '||log2.active_ingredient '
            || '||log2.quid '
            || '||log2.use_perc '
            || '||log2.show_items '
            || '||log2.use_perc_rel '
            || '||log2.use_perc_abs '
            || '||log2.use_brackets '
            || '||log2.allergen '
            || '||log2.soi '
            || '||log2.complex_label_log_id '
            || '||log2.paragraph '
            || '||log2.sort_sequence_no '
            || ', log1.Ingredient '
            || '||log1.is_in_group '
            || '||log1.is_in_function '
            || '||log1.description '
            || '||log1.quantity '
            || '||to_char(log1.note) '
            || '||log1.rec_from_id '
            || '||log1.rec_from_description '
            || '||log1.rec_with_id '
            || '||log1.rec_with_description '
            || '||log1.show_rec '
            || '||log1.active_ingredient '
            || '||log1.quid '
            || '||log1.use_perc '
            || '||log1.show_items '
            || '||log1.use_perc_rel '
            || '||log1.use_perc_abs '
            || '||log1.use_brackets '
            || '||log1.allergen '
            || '||log1.soi '
            || '||log1.complex_label_log_id '
            || '||log1.paragraph '
            || '||log1.sort_sequence_no '
            || ',0,3) '
            || ' ,log2.log_id '
            || ' ,log2.sequence_no '
            || ' ,log2.parent_sequence_no '
            || ' ,log2.bom_level '
            || ' ,decode(log2.bom_level,log1.bom_level,0,1) '
            || ' ,log2.ingredient '
            || ' ,decode(log2.ingredient,log1.ingredient,0,1) '
            || ' ,log2.is_in_group '
            || ' ,decode(log2.is_in_group,log1.is_in_group,0,1) '
            || ' ,log2.is_in_function '
            || ' ,decode(log2.is_in_function,log1.is_in_function,0,1) '
            || ' ,log2.description '
            || ' ,decode(log2.description,log1.description,0,1) '
            || ' ,log2.quantity '
            || ' ,decode(log2.quantity,log1.quantity,0,1) '
            || ' ,log2.note '
            || ' ,decode(log2.note,log1.note,0,1) '
            || ' ,log2.rec_from_id '
            || ' ,decode(log2.rec_from_id,log1.rec_from_id,0,1) '
            || ' ,log2.rec_from_description '
            || ' ,decode(log2.rec_from_description,log1.rec_from_description,0,1) '
            || ' ,log2.rec_with_id '
            || ' ,decode(log2.rec_with_id,log1.rec_with_id,0,1) '
            || ' ,log2.rec_with_description '
            || ' ,decode(log2.rec_with_description,log1.rec_with_description,0,1) '
            || ' ,log2.show_rec '
            || ' ,decode(log2.show_rec,log1.show_rec,0,1) '
            || ' ,log2.active_ingredient '
            || ' ,decode(log2.active_ingredient,log1.active_ingredient,0,1) '
            || ' ,log2.quid '
            || ' ,decode(log2.quid,log1.quid,0,1) '
            || ' ,log2.use_perc '
            || ' ,decode(log2.use_perc,log1.use_perc,0,1) '
            || ' ,log2.show_items '
            || ' ,decode(log2.show_items,log1.show_items,0,1) '
            || ' ,log2.use_perc_rel '
            || ' ,decode(log2.use_perc_rel,log1.use_perc_rel,0,1) '
            || ' ,log2.use_perc_abs '
            || ' ,decode(log2.use_perc_abs,log1.use_perc_abs,0,1) '
            || ' ,log2.use_brackets '
            || ' ,decode(log2.use_brackets,log1.use_brackets,0,1) '
            || ' ,log2.allergen '
            || ' ,decode(log2.allergen,log1.allergen,0,1) '
            || ' ,log2.soi '
            || ' ,decode(log2.soi,log1.soi,0,1) '
            || ' ,log2.complex_label_log_id '
            || ' ,decode(log2.complex_label_log_id,log1.complex_label_log_id,0,1) '
            || ' ,(select log_name from itlabellog lg where lg.log_id = log2.complex_label_log_id ) '
            || ' ,log2.paragraph '
            || ' ,decode(log2.paragraph,log1.paragraph,0,1) '
            || ' ,log2.sort_sequence_no '
            || ' ,decode(log2.sort_sequence_no,log1.sort_sequence_no,0,1) ';
      LSFROMCOMMON                  VARCHAR2( 2000 )
         :=    ' FROM '
            || ' (SELECT a.* '
            || ' ,sys_connect_by_path(a.ingredient,''/'') ingpath '
            || '   FROM  '
            || '   (select log_id,sequence_no,parent_sequence_no,bom_level,ingredient '
            || ' 		,is_in_group,is_in_function,description,quantity,to_char(note) note '
            || ' 		,rec_from_id,rec_from_description,rec_with_id,rec_with_description,show_rec '
            || ' 		,active_ingredient,quid,use_perc,show_items,use_perc_rel '
            || ' 		,use_perc_abs,use_brackets,allergen,soi,complex_label_log_id '
            || ' 		,paragraph,sort_sequence_no '
            || ' 	FROM itlabellogresultdetails '
            || ' 	WHERE log_id = :anLogId1 '
            || ' 	UNION  ALL '
            || ' 	SELECT :anLogId1, (SELECT min(parent_sequence_no) '
            || '  	             FROM itlabellogresultdetails WHERE log_id = :anLogId1),null,null,null '
            || ' 		 ,null,null,null,null,null '
            || ' 		 ,null,null,null,null,null '
            || ' 		 ,null,null,null,null,null '
            || ' 		 ,null,null,null,null,null '
            || ' 		 ,null,null '
            || ' 		 from dual ) a '
            || ' START WITH a.parent_sequence_no is null '
            || ' CONNECT BY PRIOR a.sequence_no = a.parent_sequence_no) log1, '
            || ' (SELECT a.* '
            || ' ,sys_connect_by_path(a.ingredient,''/'') ingpath '
            || '   FROM  '
            || '   (SELECT log_id,sequence_no,parent_sequence_no,bom_level,ingredient '
            || ' 		,is_in_group,is_in_function,description,quantity,to_char(note) note '
            || ' 		,rec_from_id,rec_from_description,rec_with_id,rec_with_description,show_rec '
            || ' 		,active_ingredient,quid,use_perc,show_items,use_perc_rel '
            || ' 		,use_perc_abs,use_brackets,allergen,soi,complex_label_log_id '
            || ' 		,paragraph,sort_sequence_no '
            || ' 	FROM itlabellogresultdetails '
            || ' 	WHERE log_id = :anLogId2 '
            || ' 	UNION  ALL '
            || ' 	SELECT :anLogId2, (SELECT min(parent_sequence_no) '
            || '            	FROM itlabellogresultdetails WHERE log_id = :anLogId2),null,null,null '
            || ' 	   	,null,null,null,null,null '
            || ' 	   	,null,null,null,null,null '
            || ' 	   	,null,null,null,null,null '
            || ' 	   	,null,null,null,null,null '
            || ' 	   	,null,null '
            || ' 	   FROM dual ) a '
            || ' START WITH a.parent_sequence_no is null '
            || ' CONNECT BY PRIOR a.sequence_no = a.parent_sequence_no) log2 ';
      LSWHERECOMMON                 VARCHAR2( 200 ) :=    ' WHERE log1.ingredient = log2.ingredient '
                                                       || ' AND  log1.ingpath = log2.ingpath ';
      LSSELECTUNIQUELOG1            VARCHAR2( 2000 )
         :=    ' SELECT '
            || ' 1 '
            || IAPICONSTANTCOLUMN.LABELITEMCMPSTATUSCOL
            || ' ,log_id '
            || IAPICONSTANTCOLUMN.LOGIDCOL
            || ' ,sequence_no '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ' ,parent_sequence_no '
            || IAPICONSTANTCOLUMN.PARENTSEQUENCECOL
            || ' ,bom_level '
            || IAPICONSTANTCOLUMN.BOMLEVELCOL
            || ' ,1 '
            || IAPICONSTANTCOLUMN.BOMLEVELCMPSTATUSCOL
            || ' ,ingredient '
            || IAPICONSTANTCOLUMN.INGREDIENTIDCOL
            || ' ,1 '
            || IAPICONSTANTCOLUMN.INGREDIENTIDCMPSTATUSCOL
            || ' ,is_in_group '
            || IAPICONSTANTCOLUMN.ISINGROUPCOL
            || ' ,1 '
            || IAPICONSTANTCOLUMN.ISINGROUPCMPSTATUSCOL
            || ' ,is_in_function '
            || IAPICONSTANTCOLUMN.ISINFUNCTIONCOL
            || ' ,1 '
            || IAPICONSTANTCOLUMN.ISINFUNCTIONCMPSTATUSCOL
            || ' ,description '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ' ,1 '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCMPSTATUSCOL
            || ' ,quantity '
            || IAPICONSTANTCOLUMN.QUANTITYCOL
            || ' ,1 '
            || IAPICONSTANTCOLUMN.QUANTITYCMPSTATUSCOL
            || ' ,to_char(note) '
            || IAPICONSTANTCOLUMN.NOTECOL
            || ' ,1 '
            || IAPICONSTANTCOLUMN.NOTECMPSTATUSCOL
            || ' ,rec_from_id '
            || IAPICONSTANTCOLUMN.RECFROMIDCOL
            || ' ,1 '
            || IAPICONSTANTCOLUMN.RECFROMIDCMPSTATUSCOL
            || ' ,rec_from_description '
            || IAPICONSTANTCOLUMN.RECFROMDESCRIPTIONCOL
            || ' ,1 '
            || IAPICONSTANTCOLUMN.RECFROMDESCRIPTIONCMPSTATUSCOL
            || ' ,rec_with_id '
            || IAPICONSTANTCOLUMN.RECWITHIDCOL
            || ' ,1 '
            || IAPICONSTANTCOLUMN.RECWITHIDCMPSTATUSCOL
            || ' ,rec_with_description '
            || IAPICONSTANTCOLUMN.RECWITHDESCRIPTIONCOL
            || ' ,1 '
            || IAPICONSTANTCOLUMN.RECWITHDESCRIPTIONCMPSTATUSCOL
            || ' ,show_rec '
            || IAPICONSTANTCOLUMN.SHOWRECONSTITUTESCOL
            || ' ,1 '
            || IAPICONSTANTCOLUMN.SHOWRECONSTITUTESCMPSTATUSCOL
            || ' ,active_ingredient '
            || IAPICONSTANTCOLUMN.ACTIVEINGREDIENTCOL
            || ' ,1 '
            || IAPICONSTANTCOLUMN.ACTIVEINGREDIENTCMPSTATUSCOL
            || ' ,quid '
            || IAPICONSTANTCOLUMN.QUIDCOL
            || ' ,1 '
            || IAPICONSTANTCOLUMN.QUIDCMPSTATUSCOL
            || ' ,use_perc '
            || IAPICONSTANTCOLUMN.USEPERCENTAGECOL
            || ' ,1 '
            || IAPICONSTANTCOLUMN.USEPERCENTAGECMPSTATUSCOL
            || ' ,show_items '
            || IAPICONSTANTCOLUMN.SHOWITEMSCOL
            || ' ,1 '
            || IAPICONSTANTCOLUMN.SHOWITEMSCMPSTATUSCOL
            || ' ,use_perc_rel '
            || IAPICONSTANTCOLUMN.USEPERCRELCOL
            || ' ,1 '
            || IAPICONSTANTCOLUMN.USEPERCRELCMPSTATUSCOL
            || ' ,use_perc_abs '
            || IAPICONSTANTCOLUMN.USEPERCABSCOL
            || ' ,1 '
            || IAPICONSTANTCOLUMN.USEPERCABSCMPSTATUSCOL
            || ' ,use_brackets '
            || IAPICONSTANTCOLUMN.USEBRACKETSCOL
            || ' ,1 '
            || IAPICONSTANTCOLUMN.USEBRACKETSCMPSTATUSCOL
            || ' ,allergen '
            || IAPICONSTANTCOLUMN.ALLERGENCOL
            || ' ,1 '
            || IAPICONSTANTCOLUMN.ALLERGENCMPSTATUSCOL
            || ' ,soi '
            || IAPICONSTANTCOLUMN.SOICOL
            || ' ,1 '
            || IAPICONSTANTCOLUMN.SOICMPSTATUSCOL
            || ' ,complex_label_log_id '
            || IAPICONSTANTCOLUMN.COMPLEXLABELLOGIDCOL
            || ' ,1 '
            || IAPICONSTANTCOLUMN.COMPLEXLABELLOGIDCMPSTATUSCOL
            || ' ,(select log_name from itlabellog lg where lg.log_id = complex_label_log_id ) '
            || IAPICONSTANTCOLUMN.COMPLEXLABELLOGCOL
            || ' ,paragraph '
            || IAPICONSTANTCOLUMN.PARAGRAPHCOL
            || ' ,1 '
            || IAPICONSTANTCOLUMN.PARAGRAPHCMPSTATUSCOL
            || ' ,sort_sequence_no '
            || IAPICONSTANTCOLUMN.SORTSEQUENCECOL
            || ' ,1 '
            || IAPICONSTANTCOLUMN.SORTSEQUENCECMPSTATUSCOL;
      LSFROMUNIQUELOG1              VARCHAR2( 200 ) := ' FROM itlabellogresultdetails ';
      LSWHEREUNIQUELOG1             VARCHAR2( 400 )
         :=    ' WHERE LOG_ID = :anLogId1 '
            || ' AND sequence_no NOT IN '
            || '  (SELECT * FROM TABLE( CAST( :ltLogSequenceTab1 as SpNumTable_Type ) ) ) ';
      LSSELECTUNIQUELOG2            VARCHAR2( 2000 )
         :=    ' SELECT '
            || ' 2 '
            || ' ,log_id '
            || ' ,sequence_no '
            || ' ,parent_sequence_no '
            || ' ,bom_level '
            || ' ,1 '
            || ' ,ingredient '
            || ' ,1 '
            || ' ,is_in_group '
            || ' ,1 '
            || ' ,is_in_function '
            || ' ,1 '
            || ' ,description '
            || ' ,1 '
            || ' ,quantity '
            || ' ,1 '
            || ' ,to_char(note) '
            || ' ,1 '
            || ' ,rec_from_id '
            || ' ,1 '
            || ' ,rec_from_description '
            || ' ,1 '
            || ' ,rec_with_id '
            || ' ,1 '
            || ' ,rec_with_description '
            || ' ,1 '
            || ' ,show_rec '
            || ' ,1 '
            || ' ,active_ingredient '
            || ' ,1 '
            || ' ,quid '
            || ' ,1 '
            || ' ,use_perc '
            || ' ,1 '
            || ' ,show_items '
            || ' ,1 '
            || ' ,use_perc_rel '
            || ' ,1 '
            || ' ,use_perc_abs '
            || ' ,1 '
            || ' ,use_brackets '
            || ' ,1 '
            || ' ,allergen '
            || ' ,1 '
            || ' ,soi '
            || ' ,1 '
            || ' ,complex_label_log_id '
            || ' ,1 '
            || ' ,(select log_name from itlabellog lg where lg.log_id = complex_label_log_id ) '
            || ' ,paragraph '
            || ' ,1 '
            || ' ,sort_sequence_no '
            || ' ,1 ';
      LSFROMUNIQUELOG2              VARCHAR2( 200 ) := ' FROM itlabellogresultdetails ';
      LSWHEREUNIQUELOG2             VARCHAR2( 400 )
         :=    ' WHERE LOG_ID = :anLogId2 '
            || ' AND sequence_no NOT IN '
            || '  (SELECT * FROM TABLE( CAST( :ltLogSequenceTab2 as SpNumTable_Type ) ) ) ';
      LSSQLCOMMON                   VARCHAR2( 10000 );
      LSSQLUNIQUE                   VARCHAR2( 10000 );
      LSSQLCOMMONSEQUENCE           VARCHAR2( 3000 )
         :=    ' SELECT log1.SEQUENCE_NO, '
            || ' log2.SEQUENCE_NO '
            || ' FROM ( SELECT    SEQUENCE_NO, '
            || ' PARENT_SEQUENCE_NO, '
            || ' INGREDIENT, '
            || ' SYS_CONNECT_BY_PATH( a.INGREDIENT, '
            || ' ''/'' ) INGpath '
            || ' FROM ( SELECT SEQUENCE_NO, '
            || ' INGREDIENT, '
            || ' PARENT_SEQUENCE_NO '
            || ' FROM itlabellogresultdetails '
            || ' WHERE LOG_ID = :anLogId1 '
            || ' UNION ALL '
            || ' SELECT ( SELECT MIN( PARENT_SEQUENCE_NO ) '
            || ' FROM itlabellogresultdetails '
            || ' WHERE LOG_ID = :anLogId1 ), '
            || ' NULL, '
            || ' NULL '
            || ' FROM DUAL ) a '
            || ' START WITH a.PARENT_SEQUENCE_NO IS NULL '
            || ' CONNECT BY PRIOR a.SEQUENCE_NO = a.PARENT_SEQUENCE_NO ) log1, '
            || ' ( SELECT    SEQUENCE_NO, '
            || ' PARENT_SEQUENCE_NO, '
            || ' INGREDIENT, '
            || ' SYS_CONNECT_BY_PATH( a.INGREDIENT, '
            || ' ''/'' ) INGpath '
            || ' FROM ( SELECT SEQUENCE_NO, '
            || ' INGREDIENT, '
            || ' PARENT_SEQUENCE_NO '
            || ' FROM itlabellogresultdetails '
            || ' WHERE LOG_ID = :anLogId2 '
            || ' UNION ALL '
            || ' SELECT ( SELECT MIN( PARENT_SEQUENCE_NO ) '
            || ' FROM itlabellogresultdetails '
            || ' WHERE LOG_ID = :anLogId2 ), '
            || ' NULL, '
            || ' NULL '
            || ' FROM DUAL ) a '
            || ' START WITH a.PARENT_SEQUENCE_NO IS NULL '
            || ' CONNECT BY PRIOR a.SEQUENCE_NO = a.PARENT_SEQUENCE_NO ) log2 '
            || ' WHERE log1.INGREDIENT = log2.INGREDIENT '
            || ' AND log1.INGpath = log2.INGpath ';
      LQCOMMONSEQUENCE              IAPITYPE.REF_TYPE;
   BEGIN
      
      
      
      
      
      LSSQLCOMMON :=    LSSELECTCOMMMONLOG1
                     || LSFROMCOMMON
                     || LSWHERECOMMON;

      OPEN AQLABELCOMMONDETAILS FOR LSSQLCOMMON USING 0,
      0,
      0,
      0,
      0,
      0;

      LSSQLUNIQUE :=    LSSELECTUNIQUELOG1
                     || LSFROMUNIQUELOG1
                     || LSWHEREUNIQUELOG1;

      OPEN AQLABELUNIQUEDETAILS FOR LSSQLUNIQUE USING 0,
      LTLOGSEQUENCETAB1;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN LQCOMMONSEQUENCE FOR LSSQLCOMMONSEQUENCE USING ANLOGID1,
      ANLOGID1,
      ANLOGID2,
      ANLOGID2;

      FETCH LQCOMMONSEQUENCE
      BULK COLLECT INTO LTLOGSEQUENCETAB1,
             LTLOGSEQUENCETAB2;

      CLOSE LQCOMMONSEQUENCE;

      LSSQLCOMMON :=    LSSELECTCOMMMONLOG1
                     || LSFROMCOMMON
                     || LSWHERECOMMON
                     || ' UNION ALL '
                     || LSSELECTCOMMMONLOG2
                     || LSFROMCOMMON
                     || LSWHERECOMMON;

      OPEN AQLABELCOMMONDETAILS FOR LSSQLCOMMON
      USING ANLOGID1,
            ANLOGID1,
            ANLOGID1,
            ANLOGID2,
            ANLOGID2,
            ANLOGID2,
            ANLOGID1,
            ANLOGID1,
            ANLOGID1,
            ANLOGID2,
            ANLOGID2,
            ANLOGID2;

      LSSQLUNIQUE :=
              LSSELECTUNIQUELOG1
           || LSFROMUNIQUELOG1
           || LSWHEREUNIQUELOG1
           || ' UNION ALL '
           || LSSELECTUNIQUELOG2
           || LSFROMUNIQUELOG2
           || LSWHEREUNIQUELOG2;

      OPEN AQLABELUNIQUEDETAILS FOR LSSQLUNIQUE USING ANLOGID1,
      LTLOGSEQUENCETAB1,
      ANLOGID2,
      LTLOGSEQUENCETAB2;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETCOMPARELABELDETAILS;


   FUNCTION GETOBJECTDETAIL(

      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANOBJECTID                 IN       IAPITYPE.ID_TYPE,
      ANOBJECTREVISION           IN       IAPITYPE.REVISION_TYPE,
      ANOBJECTOWNER              IN       IAPITYPE.OWNER_TYPE,
      AQOBJECT                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS









      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetObjectDetail';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

         OPEN AQOBJECT FOR
            SELECT ITOID.FILE_NAME,
                   ITOID.FILE_SIZE,
                   ITOID.OLE_OBJECT,
                   ITOIH.DESCRIPTION,
                   0 OBJECT_ID,
                   0 REVISION,
                   0 OWNER
              FROM ITOID,
                   ITOIH
             WHERE ITOID.OBJECT_ID = ITOIH.OBJECT_ID
               AND ITOID.OWNER = ITOIH.OWNER
               AND ITOID.OBJECT_ID IS NULL;

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM SPECIFICATION_SECTION
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND TYPE = IAPICONSTANT.SECTIONTYPE_OBJECT
         AND REF_ID = ANOBJECTID
         AND REF_OWNER = ANOBJECTOWNER
         AND DECODE( REF_VER,
                     0, DECODE( F_GET_REF_REVISION( TYPE,
                                                    REF_ID,
                                                    REF_OWNER,
                                                    SYSDATE ),
                                ANOBJECTREVISION, 1,
                                0 ),
                     DECODE( ANOBJECTREVISION,
                             ANOBJECTREVISION, 1,
                             0 ) ) = 1;

      IF LNCOUNT <> 0
      THEN
         OPEN AQOBJECT FOR
            SELECT ITOID.FILE_NAME,
                   ITOID.FILE_SIZE,
                   ITOID.OLE_OBJECT,
                   ITOIH.DESCRIPTION,
                   ITOID.OBJECT_ID,
                   ITOID.REVISION,
                   ITOID.OWNER
              FROM ITOID,
                   ITOIH
             WHERE ITOID.OBJECT_ID = ITOIH.OBJECT_ID
               AND ITOID.OWNER = ITOIH.OWNER
               AND ITOID.OBJECT_ID = ANOBJECTID
               AND ITOID.REVISION = ANOBJECTREVISION
               AND ITOID.OWNER = ANOBJECTOWNER
               AND ITOIH.LANG_ID = 1; 
      ELSE
         
         OPEN AQOBJECT FOR
            SELECT ITOID.FILE_NAME,
                   ITOID.FILE_SIZE,
                   ITOID.OLE_OBJECT,
                   ITOIH.DESCRIPTION,
                   0 OBJECT_ID,
                   0 REVISION,
                   0 OWNER
              FROM ITOID,
                   ITOIH
             WHERE ITOID.OBJECT_ID = ITOIH.OBJECT_ID
               AND ITOID.OWNER = ITOIH.OWNER
               AND ITOIH.LANG_ID = IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID
               AND ITOID.OBJECT_ID IS NULL;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         OPEN AQOBJECT FOR
            SELECT 'Error'
              FROM DUAL;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETOBJECTDETAIL;



   FUNCTION GETOBJECTDETAILWEB(

      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANOBJECTID                 IN       IAPITYPE.ID_TYPE,
      ANOBJECTREVISION           IN       IAPITYPE.REVISION_TYPE,
      ANOBJECTOWNER              IN       IAPITYPE.OWNER_TYPE,
      AQOBJECT                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS









      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetObjectDetailWeb';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LNOBJECTREVISION              IAPITYPE.REVISION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
         
         OPEN AQOBJECT FOR
            SELECT ITOID.FILE_NAME,
                   ITOID.FILE_SIZE,
                   ITOID.OLE_OBJECT,
                   ITOIH.DESCRIPTION,
                   0 OBJECT_ID,
                   0 REVISION,
                   0 OWNER
              FROM ITOID,
                   ITOIH
             WHERE ITOID.OBJECT_ID = ITOIH.OBJECT_ID
               AND ITOID.OWNER = ITOIH.OWNER
               AND ITOID.OBJECT_ID IS NULL;

      IF NVL(ANOBJECTREVISION, 0) = 0 THEN 
            LNOBJECTREVISION := F_GET_REF_REVISION( IAPICONSTANT.SECTIONTYPE_OBJECT,
                                                    ANOBJECTID,
                                                    ANOBJECTOWNER,
                                                    SYSDATE );
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM SPECIFICATION_SECTION
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND TYPE = IAPICONSTANT.SECTIONTYPE_OBJECT
               AND SECTION_ID = ANSECTIONID
               AND SUB_SECTION_ID = ANSUBSECTIONID
               AND REF_ID = ANOBJECTID
               AND REF_OWNER = ANOBJECTOWNER;
        ELSE 
            LNOBJECTREVISION := ANOBJECTREVISION;
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM SPECIFICATION_SECTION
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND TYPE = IAPICONSTANT.SECTIONTYPE_OBJECT
               AND SECTION_ID = ANSECTIONID
               AND SUB_SECTION_ID = ANSUBSECTIONID
               AND REF_ID = ANOBJECTID
               AND REF_OWNER = ANOBJECTOWNER
               AND REF_VER = LNOBJECTREVISION;
      END IF;

      IF LNCOUNT <> 0
      THEN
         OPEN AQOBJECT FOR
            SELECT ITOID.FILE_NAME,
                   ITOID.FILE_SIZE,
                   ITOID.OLE_OBJECT,
                   ITOIH.DESCRIPTION,
                   ITOID.OBJECT_ID,
                   ITOID.REVISION,
                   ITOID.OWNER
              FROM ITOID,
                   ITOIH
             WHERE ITOID.OBJECT_ID = ITOIH.OBJECT_ID
               AND ITOID.OWNER = ITOIH.OWNER
               AND ITOID.OBJECT_ID = ANOBJECTID
               AND ITOID.REVISION = LNOBJECTREVISION
               AND ITOID.OWNER = ANOBJECTOWNER
               AND ITOIH.LANG_ID = IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID;
      ELSE
         
         OPEN AQOBJECT FOR
            SELECT ITOID.FILE_NAME,
                   ITOID.FILE_SIZE,
                   ITOID.OLE_OBJECT,
                   ITOIH.DESCRIPTION,
                   0 OBJECT_ID,
                   0 REVISION,
                   0 OWNER
              FROM ITOID,
                   ITOIH
             WHERE ITOID.OBJECT_ID = ITOIH.OBJECT_ID
               AND ITOID.OWNER = ITOIH.OWNER
               AND ITOIH.LANG_ID = IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID
               AND ITOID.OBJECT_ID IS NULL;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         OPEN AQOBJECT FOR
            SELECT 'Error'
              FROM DUAL;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETOBJECTDETAILWEB;


   FUNCTION GETPROCESSTEXTDETAIL(

      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANTEXTTYPE                 IN       IAPITYPE.TEXTTYPE_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      ANSTAGE                    IN       IAPITYPE.STAGEID_TYPE,
      AQPROCESSTEXT              OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS









      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetProcessTextDetail';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQPROCESSTEXT FOR
         SELECT TEXT,
                PART_NO,
                REVISION,
                TEXT_TYPE,
                SUBSTR( F_FTH_DESCR( 1,
                                     TEXT_TYPE,
                                     0 ),
                        1,
                        60 ) F_TEXT_DESCR
           FROM SPECIFICATION_LINE_TEXT
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND TEXT_TYPE = ANTEXTTYPE
            AND PLANT = ASPLANT
            AND LINE = ASLINE
            AND CONFIGURATION = ANCONFIGURATION
            AND STAGE = ANSTAGE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         OPEN AQPROCESSTEXT FOR
            SELECT 'Error'
              FROM DUAL;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPROCESSTEXTDETAIL;


   FUNCTION GETPROCESSDATADETAIL(

      ASPARTNO1                  IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION1                IN       IAPITYPE.REVISION_TYPE,
      ASPARTNO2                  IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION2                IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      ANSTAGE                    IN       IAPITYPE.STAGEID_TYPE,
      AQPROCESSDATA              OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS









      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetProcessDataDetail';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQPROCESSDATA FOR
         SELECT DISTINCT SECTION_ID SC_ID,
                         SUB_SECTION_ID SB_ID,
                         DECODE( HEADER_ID,
                                 NULL, '- text -',
                                 NVL( SUBSTR( F_SPH_DESCR( 1,
                                                           PROPERTY,
                                                           0 ),
                                              1,
                                              40 ),
                                      '<no data>' ) ) F_SP,
                         SUBSTR( F_ATH_DESCR( 1,
                                              ATTRIBUTE,
                                              0 ),
                                 1,
                                 40 ) F_AT,
                         SUBSTR( F_HDH_DESCR( 1,
                                              HEADER_ID,
                                              0 ),
                                 1,
                                 40 ) F_HD,
                         SUBSTR( F_GET_SVAL_PL( ASPARTNO1,
                                                ANREVISION1,
                                                SECTION_ID,
                                                SUB_SECTION_ID,
                                                PLANT,
                                                LINE,
                                                CONFIGURATION,
                                                STAGE,
                                                PROPERTY,
                                                ATTRIBUTE,
                                                HEADER_ID,
                                                VALUE_S,
                                                1,
                                                F_SEQ ),
                                 1,
                                 120 ) F_SP1,
                         SUBSTR( F_GET_SVAL_PL( ASPARTNO2,
                                                ANREVISION2,
                                                SECTION_ID,
                                                SUB_SECTION_ID,
                                                PLANT,
                                                LINE,
                                                CONFIGURATION,
                                                STAGE,
                                                PROPERTY,
                                                ATTRIBUTE,
                                                HEADER_ID,
                                                VALUE_S,
                                                1,
                                                F_SEQ ),
                                 1,
                                 120 ) F_SP2
                    FROM ( SELECT SECTION_ID,
                                  SUB_SECTION_ID,
                                  PLANT,
                                  LINE,
                                  CONFIGURATION,
                                  STAGE,
                                  PROPERTY,
                                  ATTRIBUTE,
                                  HEADER_ID,
                                  VALUE_S,
                                  SEQUENCE_NO F_SEQ
                            FROM SPECDATA_PROCESS
                           WHERE PART_NO = ASPARTNO1
                             AND REVISION = ANREVISION1
                             AND SECTION_ID = ANSECTIONID
                             AND SUB_SECTION_ID = ANSUBSECTIONID
                             AND TYPE = ANTYPE
                             AND PLANT = ASPLANT
                             AND LINE = ASLINE
                             AND CONFIGURATION = ANCONFIGURATION
                             AND STAGE = ANSTAGE
                             AND VALUE_TYPE < 2
                          MINUS
                          SELECT SECTION_ID,
                                 SUB_SECTION_ID,
                                 PLANT,
                                 LINE,
                                 CONFIGURATION,
                                 STAGE,
                                 PROPERTY,
                                 ATTRIBUTE,
                                 HEADER_ID,
                                 VALUE_S,
                                 SEQUENCE_NO F_SEQ
                            FROM SPECDATA_PROCESS
                           WHERE PART_NO = ASPARTNO2
                             AND REVISION = ANREVISION2
                             AND SECTION_ID = ANSECTIONID
                             AND SUB_SECTION_ID = ANSUBSECTIONID
                             AND TYPE = ANTYPE
                             AND PLANT = ASPLANT
                             AND LINE = ASLINE
                             AND CONFIGURATION = ANCONFIGURATION
                             AND STAGE = ANSTAGE
                             AND VALUE_TYPE < 2
                          UNION
                          ( SELECT SECTION_ID,
                                   SUB_SECTION_ID,
                                   PLANT,
                                   LINE,
                                   CONFIGURATION,
                                   STAGE,
                                   PROPERTY,
                                   ATTRIBUTE,
                                   HEADER_ID,
                                   VALUE_S,
                                   SEQUENCE_NO F_SEQ
                             FROM SPECDATA_PROCESS
                            WHERE PART_NO = ASPARTNO2
                              AND REVISION = ANREVISION2
                              AND SECTION_ID = ANSECTIONID
                              AND SUB_SECTION_ID = ANSUBSECTIONID
                              AND TYPE = ANTYPE
                              AND PLANT = ASPLANT
                              AND LINE = ASLINE
                              AND CONFIGURATION = ANCONFIGURATION
                              AND STAGE = ANSTAGE
                              AND VALUE_TYPE < 2
                           MINUS
                           SELECT SECTION_ID,
                                  SUB_SECTION_ID,
                                  PLANT,
                                  LINE,
                                  CONFIGURATION,
                                  STAGE,
                                  PROPERTY,
                                  ATTRIBUTE,
                                  HEADER_ID,
                                  VALUE_S,
                                  SEQUENCE_NO F_SEQ
                             FROM SPECDATA_PROCESS
                            WHERE PART_NO = ASPARTNO1
                              AND REVISION = ANREVISION1
                              AND SECTION_ID = ANSECTIONID
                              AND SUB_SECTION_ID = ANSUBSECTIONID
                              AND TYPE = ANTYPE
                              AND PLANT = ASPLANT
                              AND LINE = ASLINE
                              AND CONFIGURATION = ANCONFIGURATION
                              AND STAGE = ANSTAGE
                              AND VALUE_TYPE < 2 ) )
         UNION
         SELECT DISTINCT SECTION_ID SC_ID,
                         SUB_SECTION_ID SB_ID,
                         DECODE( HEADER_ID,
                                 NULL, '- text -',
                                 NVL( SUBSTR( F_SPH_DESCR( 1,
                                                           PROPERTY,
                                                           0 ),
                                              1,
                                              40 ),
                                      '<no data>' ) ) F_SP,
                         SUBSTR( F_ATH_DESCR( 1,
                                              ATTRIBUTE,
                                              0 ),
                                 1,
                                 40 ) F_AT,
                         SUBSTR( F_HDH_DESCR( 1,
                                              HEADER_ID,
                                              0 ),
                                 1,
                                 40 ) F_HD,
                         SUBSTR( F_GET_SVAL_PL( ASPARTNO1,
                                                ANREVISION1,
                                                SECTION_ID,
                                                SUB_SECTION_ID,
                                                PLANT,
                                                LINE,
                                                CONFIGURATION,
                                                STAGE,
                                                PROPERTY,
                                                ATTRIBUTE,
                                                HEADER_ID,
                                                VALUE_S,
                                                1,
                                                F_SEQ ),
                                 1,
                                 120 ) F_SP1,
                         SUBSTR( F_GET_SVAL_PL( ASPARTNO2,
                                                ANREVISION2,
                                                SECTION_ID,
                                                SUB_SECTION_ID,
                                                PLANT,
                                                LINE,
                                                CONFIGURATION,
                                                STAGE,
                                                PROPERTY,
                                                ATTRIBUTE,
                                                HEADER_ID,
                                                VALUE_S,
                                                1,
                                                F_SEQ ),
                                 1,
                                 120 ) F_SP2
                    FROM ( SELECT SECTION_ID,
                                  SUB_SECTION_ID,
                                  PLANT,
                                  LINE,
                                  CONFIGURATION,
                                  STAGE,
                                  PROPERTY,
                                  ATTRIBUTE,
                                  HEADER_ID,
                                  VALUE_S,
                                  SEQUENCE_NO F_SEQ
                            FROM SPECDATA_PROCESS
                           WHERE PART_NO = ASPARTNO1
                             AND REVISION = ANREVISION1
                             AND SECTION_ID = ANSECTIONID
                             AND SUB_SECTION_ID = ANSUBSECTIONID
                             AND TYPE = ANTYPE
                             AND PLANT = ASPLANT
                             AND LINE = ASLINE
                             AND CONFIGURATION = ANCONFIGURATION
                             AND STAGE = ANSTAGE
                             AND VALUE_TYPE = 4
                          MINUS
                          SELECT SECTION_ID,
                                 SUB_SECTION_ID,
                                 PLANT,
                                 LINE,
                                 CONFIGURATION,
                                 STAGE,
                                 PROPERTY,
                                 ATTRIBUTE,
                                 HEADER_ID,
                                 VALUE_S,
                                 SEQUENCE_NO F_SEQ
                            FROM SPECDATA_PROCESS
                           WHERE PART_NO = ASPARTNO2
                             AND REVISION = ANREVISION2
                             AND SECTION_ID = ANSECTIONID
                             AND SUB_SECTION_ID = ANSUBSECTIONID
                             AND TYPE = ANTYPE
                             AND PLANT = ASPLANT
                             AND LINE = ASLINE
                             AND CONFIGURATION = ANCONFIGURATION
                             AND STAGE = ANSTAGE
                             AND VALUE_TYPE = 4
                          UNION
                          ( SELECT SECTION_ID,
                                   SUB_SECTION_ID,
                                   PLANT,
                                   LINE,
                                   CONFIGURATION,
                                   STAGE,
                                   PROPERTY,
                                   ATTRIBUTE,
                                   HEADER_ID,
                                   VALUE_S,
                                   SEQUENCE_NO F_SEQ
                             FROM SPECDATA_PROCESS
                            WHERE PART_NO = ASPARTNO2
                              AND REVISION = ANREVISION2
                              AND SECTION_ID = ANSECTIONID
                              AND SUB_SECTION_ID = ANSUBSECTIONID
                              AND TYPE = ANTYPE
                              AND PLANT = ASPLANT
                              AND LINE = ASLINE
                              AND CONFIGURATION = ANCONFIGURATION
                              AND STAGE = ANSTAGE
                              AND VALUE_TYPE = 4
                           MINUS
                           SELECT SECTION_ID,
                                  SUB_SECTION_ID,
                                  PLANT,
                                  LINE,
                                  CONFIGURATION,
                                  STAGE,
                                  PROPERTY,
                                  ATTRIBUTE,
                                  HEADER_ID,
                                  VALUE_S,
                                  SEQUENCE_NO F_SEQ
                             FROM SPECDATA_PROCESS
                            WHERE PART_NO = ASPARTNO1
                              AND REVISION = ANREVISION1
                              AND SECTION_ID = ANSECTIONID
                              AND SUB_SECTION_ID = ANSUBSECTIONID
                              AND TYPE = ANTYPE
                              AND PLANT = ASPLANT
                              AND LINE = ASLINE
                              AND CONFIGURATION = ANCONFIGURATION
                              AND STAGE = ANSTAGE
                              AND VALUE_TYPE = 4 ) )
         UNION
         SELECT DISTINCT SECTION_ID SC_ID,
                         SUB_SECTION_ID SB_ID,
                         NVL( SUBSTR( F_SPH_DESCR( 1,
                                                   PROPERTY,
                                                   0 ),
                                      1,
                                      40 ),
                              '<no data>' ) F_SP,
                         SUBSTR( F_ATH_DESCR( 1,
                                              ATTRIBUTE,
                                              0 ),
                                 1,
                                 40 ) F_AT,
                         SUBSTR( F_HDH_DESCR( 1,
                                              HEADER_ID,
                                              0 ),
                                 1,
                                 40 ) F_HD,
                         SUBSTR( F_GET_SVAL_PL( ASPARTNO1,
                                                ANREVISION1,
                                                SECTION_ID,
                                                SUB_SECTION_ID,
                                                PLANT,
                                                LINE,
                                                CONFIGURATION,
                                                STAGE,
                                                PROPERTY,
                                                ATTRIBUTE,
                                                HEADER_ID,
                                                COMPONENT_PART,
                                                2,
                                                QUANTITY ),
                                 1,
                                 120 ) F_SP1,
                         SUBSTR( F_GET_SVAL_PL( ASPARTNO2,
                                                ANREVISION2,
                                                SECTION_ID,
                                                SUB_SECTION_ID,
                                                PLANT,
                                                LINE,
                                                CONFIGURATION,
                                                STAGE,
                                                PROPERTY,
                                                ATTRIBUTE,
                                                HEADER_ID,
                                                COMPONENT_PART,
                                                2,
                                                QUANTITY ),
                                 1,
                                 120 ) F_SP2
                    FROM ( SELECT SECTION_ID,
                                  SUB_SECTION_ID,
                                  PLANT,
                                  LINE,
                                  CONFIGURATION,
                                  STAGE,
                                  PROPERTY,
                                  ATTRIBUTE,
                                  HEADER_ID,
                                  COMPONENT_PART,
                                  TO_CHAR( QUANTITY ),
                                  QUANTITY
                            FROM SPECDATA_PROCESS
                           WHERE PART_NO = ASPARTNO1
                             AND REVISION = ANREVISION1
                             AND SECTION_ID = ANSECTIONID
                             AND SUB_SECTION_ID = ANSUBSECTIONID
                             AND TYPE = ANTYPE
                             AND PLANT = ASPLANT
                             AND LINE = ASLINE
                             AND CONFIGURATION = ANCONFIGURATION
                             AND STAGE = ANSTAGE
                             AND VALUE_TYPE = 2
                          MINUS
                          SELECT SECTION_ID,
                                 SUB_SECTION_ID,
                                 PLANT,
                                 LINE,
                                 CONFIGURATION,
                                 STAGE,
                                 PROPERTY,
                                 ATTRIBUTE,
                                 HEADER_ID,
                                 COMPONENT_PART,
                                 TO_CHAR( QUANTITY ),
                                 QUANTITY
                            FROM SPECDATA_PROCESS
                           WHERE PART_NO = ASPARTNO2
                             AND REVISION = ANREVISION2
                             AND SECTION_ID = ANSECTIONID
                             AND SUB_SECTION_ID = ANSUBSECTIONID
                             AND TYPE = ANTYPE
                             AND PLANT = ASPLANT
                             AND LINE = ASLINE
                             AND CONFIGURATION = ANCONFIGURATION
                             AND STAGE = ANSTAGE
                             AND VALUE_TYPE = 2
                          UNION
                          ( SELECT SECTION_ID,
                                   SUB_SECTION_ID,
                                   PLANT,
                                   LINE,
                                   CONFIGURATION,
                                   STAGE,
                                   PROPERTY,
                                   ATTRIBUTE,
                                   HEADER_ID,
                                   COMPONENT_PART,
                                   TO_CHAR( QUANTITY ),
                                   QUANTITY
                             FROM SPECDATA_PROCESS
                            WHERE PART_NO = ASPARTNO2
                              AND REVISION = ANREVISION2
                              AND SECTION_ID = ANSECTIONID
                              AND SUB_SECTION_ID = ANSUBSECTIONID
                              AND TYPE = ANTYPE
                              AND PLANT = ASPLANT
                              AND LINE = ASLINE
                              AND CONFIGURATION = ANCONFIGURATION
                              AND STAGE = ANSTAGE
                              AND VALUE_TYPE = 2
                           MINUS
                           SELECT SECTION_ID,
                                  SUB_SECTION_ID,
                                  PLANT,
                                  LINE,
                                  CONFIGURATION,
                                  STAGE,
                                  PROPERTY,
                                  ATTRIBUTE,
                                  HEADER_ID,
                                  COMPONENT_PART,
                                  TO_CHAR( QUANTITY ),
                                  QUANTITY
                             FROM SPECDATA_PROCESS
                            WHERE PART_NO = ASPARTNO1
                              AND REVISION = ANREVISION1
                              AND SECTION_ID = ANSECTIONID
                              AND SUB_SECTION_ID = ANSUBSECTIONID
                              AND TYPE = ANTYPE
                              AND PLANT = ASPLANT
                              AND LINE = ASLINE
                              AND CONFIGURATION = ANCONFIGURATION
                              AND STAGE = ANSTAGE
                              AND VALUE_TYPE = 2 ) )
         UNION
         SELECT DISTINCT SECTION_ID SC_ID,
                         SUB_SECTION_ID SB_ID,
                         NVL( SUBSTR( F_SPH_DESCR( 1,
                                                   PROPERTY,
                                                   0 ),
                                      1,
                                      40 ),
                              '<no data>' ) F_SP,
                         SUBSTR( F_ATH_DESCR( 1,
                                              ATTRIBUTE,
                                              0 ),
                                 1,
                                 40 ) F_AT,
                         '- Testmethod -' F_HD,
                         DECODE( F_GET_INF_PL( ASPARTNO1,
                                               ANREVISION1,
                                               SECTION_ID,
                                               SUB_SECTION_ID,
                                               PLANT,
                                               LINE,
                                               CONFIGURATION,
                                               STAGE,
                                               PROPERTY,
                                               ATTRIBUTE,
                                               0,
                                               3 ),
                                 -999, '@-no data found-@',
                                 SUBSTR( F_TMH_DESCR( 1,
                                                      F_GET_INF_PL( ASPARTNO1,
                                                                    ANREVISION1,
                                                                    SECTION_ID,
                                                                    SUB_SECTION_ID,
                                                                    PLANT,
                                                                    LINE,
                                                                    CONFIGURATION,
                                                                    STAGE,
                                                                    PROPERTY,
                                                                    ATTRIBUTE,
                                                                    0,
                                                                    3 ),
                                                      F_GET_INF_PL( ASPARTNO1,
                                                                    ANREVISION1,
                                                                    SECTION_ID,
                                                                    SUB_SECTION_ID,
                                                                    PLANT,
                                                                    LINE,
                                                                    CONFIGURATION,
                                                                    STAGE,
                                                                    PROPERTY,
                                                                    ATTRIBUTE,
                                                                    0,
                                                                    4 ) ),
                                         1,
                                         120 ) ) F_SP1,
                         DECODE( F_GET_INF_PL( ASPARTNO2,
                                               ANREVISION2,
                                               SECTION_ID,
                                               SUB_SECTION_ID,
                                               PLANT,
                                               LINE,
                                               CONFIGURATION,
                                               STAGE,
                                               PROPERTY,
                                               ATTRIBUTE,
                                               0,
                                               3 ),
                                 -999, '@-no data found-@',
                                 SUBSTR( F_TMH_DESCR( 1,
                                                      F_GET_INF_PL( ASPARTNO2,
                                                                    ANREVISION2,
                                                                    SECTION_ID,
                                                                    SUB_SECTION_ID,
                                                                    PLANT,
                                                                    LINE,
                                                                    CONFIGURATION,
                                                                    STAGE,
                                                                    PROPERTY,
                                                                    ATTRIBUTE,
                                                                    0,
                                                                    3 ),
                                                      F_GET_INF_PL( ASPARTNO2,
                                                                    ANREVISION2,
                                                                    SECTION_ID,
                                                                    SUB_SECTION_ID,
                                                                    PLANT,
                                                                    LINE,
                                                                    CONFIGURATION,
                                                                    STAGE,
                                                                    PROPERTY,
                                                                    ATTRIBUTE,
                                                                    0,
                                                                    4 ) ),
                                         1,
                                         120 ) ) F_SP2
                    FROM ( SELECT SECTION_ID,
                                  SUB_SECTION_ID,
                                  PLANT,
                                  LINE,
                                  CONFIGURATION,
                                  STAGE,
                                  PROPERTY,
                                  ATTRIBUTE,
                                  TEST_METHOD
                            FROM SPECDATA_PROCESS
                           WHERE PART_NO = ASPARTNO1
                             AND REVISION = ANREVISION1
                             AND SECTION_ID = ANSECTIONID
                             AND SUB_SECTION_ID = ANSUBSECTIONID
                             AND TYPE = ANTYPE
                             AND PLANT = ASPLANT
                             AND LINE = ASLINE
                             AND CONFIGURATION = ANCONFIGURATION
                             AND STAGE = ANSTAGE
                             AND VALUE_TYPE NOT IN( 2, 4 )
                          MINUS
                          SELECT SECTION_ID,
                                 SUB_SECTION_ID,
                                 PLANT,
                                 LINE,
                                 CONFIGURATION,
                                 STAGE,
                                 PROPERTY,
                                 ATTRIBUTE,
                                 TEST_METHOD
                            FROM SPECDATA_PROCESS
                           WHERE PART_NO = ASPARTNO2
                             AND REVISION = ANREVISION2
                             AND SECTION_ID = ANSECTIONID
                             AND SUB_SECTION_ID = ANSUBSECTIONID
                             AND TYPE = ANTYPE
                             AND PLANT = ASPLANT
                             AND LINE = ASLINE
                             AND CONFIGURATION = ANCONFIGURATION
                             AND STAGE = ANSTAGE
                             AND VALUE_TYPE NOT IN( 2, 4 )
                          UNION
                          ( SELECT SECTION_ID,
                                   SUB_SECTION_ID,
                                   PLANT,
                                   LINE,
                                   CONFIGURATION,
                                   STAGE,
                                   PROPERTY,
                                   ATTRIBUTE,
                                   TEST_METHOD
                             FROM SPECDATA_PROCESS
                            WHERE PART_NO = ASPARTNO2
                              AND REVISION = ANREVISION2
                              AND SECTION_ID = ANSECTIONID
                              AND SUB_SECTION_ID = ANSUBSECTIONID
                              AND TYPE = ANTYPE
                              AND PLANT = ASPLANT
                              AND LINE = ASLINE
                              AND CONFIGURATION = ANCONFIGURATION
                              AND STAGE = ANSTAGE
                              AND VALUE_TYPE NOT IN( 2, 4 )
                           MINUS
                           SELECT SECTION_ID,
                                  SUB_SECTION_ID,
                                  PLANT,
                                  LINE,
                                  CONFIGURATION,
                                  STAGE,
                                  PROPERTY,
                                  ATTRIBUTE,
                                  TEST_METHOD
                             FROM SPECDATA_PROCESS
                            WHERE PART_NO = ASPARTNO1
                              AND REVISION = ANREVISION1
                              AND SECTION_ID = ANSECTIONID
                              AND SUB_SECTION_ID = ANSUBSECTIONID
                              AND TYPE = ANTYPE
                              AND PLANT = ASPLANT
                              AND LINE = ASLINE
                              AND CONFIGURATION = ANCONFIGURATION
                              AND STAGE = ANSTAGE
                              AND VALUE_TYPE NOT IN( 2, 4 ) ) )
         UNION
         SELECT DISTINCT SECTION_ID SC_ID,
                         SUB_SECTION_ID SB_ID,
                         NVL( SUBSTR( F_SPH_DESCR( 1,
                                                   PROPERTY,
                                                   0 ),
                                      1,
                                      40 ),
                              '<no data>' ) F_SP,
                         SUBSTR( F_ATH_DESCR( 1,
                                              ATTRIBUTE,
                                              0 ),
                                 1,
                                 40 ) F_AT,
                         '- UoM -' F_HD,
                         DECODE( F_GET_INF_PL( ASPARTNO1,
                                               ANREVISION1,
                                               SECTION_ID,
                                               SUB_SECTION_ID,
                                               PLANT,
                                               LINE,
                                               CONFIGURATION,
                                               STAGE,
                                               PROPERTY,
                                               ATTRIBUTE,
                                               0,
                                               1 ),
                                 -999, '@-no data found-@',
                                 SUBSTR( F_UMH_DESCR( 1,
                                                      F_GET_INF_PL( ASPARTNO1,
                                                                    ANREVISION1,
                                                                    SECTION_ID,
                                                                    SUB_SECTION_ID,
                                                                    PLANT,
                                                                    LINE,
                                                                    CONFIGURATION,
                                                                    STAGE,
                                                                    PROPERTY,
                                                                    ATTRIBUTE,
                                                                    0,
                                                                    1 ),
                                                      F_GET_INF_PL( ASPARTNO1,
                                                                    ANREVISION1,
                                                                    SECTION_ID,
                                                                    SUB_SECTION_ID,
                                                                    PLANT,
                                                                    LINE,
                                                                    CONFIGURATION,
                                                                    STAGE,
                                                                    PROPERTY,
                                                                    ATTRIBUTE,
                                                                    0,
                                                                    2 ) ),
                                         1,
                                         40 ) ) F_SP1,
                         DECODE( F_GET_INF_PL( ASPARTNO2,
                                               ANREVISION2,
                                               SECTION_ID,
                                               SUB_SECTION_ID,
                                               PLANT,
                                               LINE,
                                               CONFIGURATION,
                                               STAGE,
                                               PROPERTY,
                                               ATTRIBUTE,
                                               0,
                                               1 ),
                                 -999, '@-no data found-@',
                                 SUBSTR( F_UMH_DESCR( 1,
                                                      F_GET_INF_PL( ASPARTNO2,
                                                                    ANREVISION2,
                                                                    SECTION_ID,
                                                                    SUB_SECTION_ID,
                                                                    PLANT,
                                                                    LINE,
                                                                    CONFIGURATION,
                                                                    STAGE,
                                                                    PROPERTY,
                                                                    ATTRIBUTE,
                                                                    0,
                                                                    1 ),
                                                      F_GET_INF_PL( ASPARTNO2,
                                                                    ANREVISION2,
                                                                    SECTION_ID,
                                                                    SUB_SECTION_ID,
                                                                    PLANT,
                                                                    LINE,
                                                                    CONFIGURATION,
                                                                    STAGE,
                                                                    PROPERTY,
                                                                    ATTRIBUTE,
                                                                    0,
                                                                    2 ) ),
                                         1,
                                         40 ) ) F_SP2
                    FROM ( SELECT SECTION_ID,
                                  SUB_SECTION_ID,
                                  PLANT,
                                  LINE,
                                  CONFIGURATION,
                                  STAGE,
                                  PROPERTY,
                                  ATTRIBUTE,
                                  UOM_ID
                            FROM SPECDATA_PROCESS
                           WHERE PART_NO = ASPARTNO1
                             AND REVISION = ANREVISION1
                             AND SECTION_ID = ANSECTIONID
                             AND SUB_SECTION_ID = ANSUBSECTIONID
                             AND TYPE = ANTYPE
                             AND PLANT = ASPLANT
                             AND LINE = ASLINE
                             AND CONFIGURATION = ANCONFIGURATION
                             AND STAGE = ANSTAGE
                             AND VALUE_TYPE NOT IN( 2, 4 )
                          MINUS
                          SELECT SECTION_ID,
                                 SUB_SECTION_ID,
                                 PLANT,
                                 LINE,
                                 CONFIGURATION,
                                 STAGE,
                                 PROPERTY,
                                 ATTRIBUTE,
                                 UOM_ID
                            FROM SPECDATA_PROCESS
                           WHERE PART_NO = ASPARTNO2
                             AND REVISION = ANREVISION2
                             AND SECTION_ID = ANSECTIONID
                             AND SUB_SECTION_ID = ANSUBSECTIONID
                             AND TYPE = ANTYPE
                             AND PLANT = ASPLANT
                             AND LINE = ASLINE
                             AND CONFIGURATION = ANCONFIGURATION
                             AND STAGE = ANSTAGE
                             AND VALUE_TYPE NOT IN( 2, 4 )
                          UNION
                          ( SELECT SECTION_ID,
                                   SUB_SECTION_ID,
                                   PLANT,
                                   LINE,
                                   CONFIGURATION,
                                   STAGE,
                                   PROPERTY,
                                   ATTRIBUTE,
                                   UOM_ID
                             FROM SPECDATA_PROCESS
                            WHERE PART_NO = ASPARTNO2
                              AND REVISION = ANREVISION2
                              AND SECTION_ID = ANSECTIONID
                              AND SUB_SECTION_ID = ANSUBSECTIONID
                              AND TYPE = ANTYPE
                              AND PLANT = ASPLANT
                              AND LINE = ASLINE
                              AND CONFIGURATION = ANCONFIGURATION
                              AND STAGE = ANSTAGE
                              AND VALUE_TYPE NOT IN( 2, 4 )
                           MINUS
                           SELECT SECTION_ID,
                                  SUB_SECTION_ID,
                                  PLANT,
                                  LINE,
                                  CONFIGURATION,
                                  STAGE,
                                  PROPERTY,
                                  ATTRIBUTE,
                                  UOM_ID
                             FROM SPECDATA_PROCESS
                            WHERE PART_NO = ASPARTNO1
                              AND REVISION = ANREVISION1
                              AND SECTION_ID = ANSECTIONID
                              AND SUB_SECTION_ID = ANSUBSECTIONID
                              AND TYPE = ANTYPE
                              AND PLANT = ASPLANT
                              AND LINE = ASLINE
                              AND CONFIGURATION = ANCONFIGURATION
                              AND STAGE = ANSTAGE
                              AND VALUE_TYPE NOT IN( 2, 4 ) ) );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         OPEN AQPROCESSDATA FOR
            SELECT 'Error'
              FROM DUAL;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPROCESSDATADETAIL;


   FUNCTION GETPROPERTYGROUPDETAIL(

      ASPARTNO1                  IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION1                IN       IAPITYPE.REVISION_TYPE,
      ASPARTNO2                  IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION2                IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE,
      ANREFID                    IN       IAPITYPE.ID_TYPE,
      AQPROPERTYGROUP            OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS









      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPropertyGroupDetail';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQPROPERTYGROUP FOR
         SELECT *
           FROM ( SELECT DISTINCT SECTION_ID SC_ID,
                                  SUB_SECTION_ID SB_ID,
                                  PROPERTY_GROUP,
                                  NVL( SUBSTR( F_SPH_DESCR( 1,
                                                            PROPERTY,
                                                            0 ),
                                               1,
                                               60 ),
                                       '<no data>' ) F_SP,
                                  SUBSTR( F_ATH_DESCR( 1,
                                                       ATTRIBUTE,
                                                       0 ),
                                          1,
                                          60 ) F_AT,
                                  SUBSTR( F_HDH_DESCR( 1,
                                                       HEADER_ID,
                                                       0 ),
                                          1,
                                          60 ) F_HD,
                                  SUBSTR( F_GET_SVAL_REP( ASPARTNO1,
                                                          ANREVISION1,
                                                          SECTION_ID,
                                                          SUB_SECTION_ID,
                                                          PROPERTY_GROUP,
                                                          PROPERTY,
                                                          ATTRIBUTE,
                                                          HEADER_ID ),
                                          1,
                                          120 ) F_SP1,
                                  SUBSTR( F_GET_SVAL_REP( ASPARTNO2,
                                                          ANREVISION2,
                                                          SECTION_ID,
                                                          SUB_SECTION_ID,
                                                          PROPERTY_GROUP,
                                                          PROPERTY,
                                                          ATTRIBUTE,
                                                          HEADER_ID ),
                                          1,
                                          120 ) F_SP2
                            FROM ( SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          HEADER_ID,
                                          VALUE_S
                                    FROM SPECDATA
                                   WHERE PART_NO = ASPARTNO1
                                     AND REVISION = ANREVISION1
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND TYPE = ANTYPE
                                     AND REF_ID = ANREFID
                                  MINUS
                                  SELECT SECTION_ID,
                                         SUB_SECTION_ID,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         HEADER_ID,
                                         VALUE_S
                                    FROM SPECDATA
                                   WHERE PART_NO = ASPARTNO2
                                     AND REVISION = ANREVISION2
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND TYPE = ANTYPE
                                     AND REF_ID = ANREFID
                                  UNION
                                  ( SELECT SECTION_ID,
                                           SUB_SECTION_ID,
                                           PROPERTY_GROUP,
                                           PROPERTY,
                                           ATTRIBUTE,
                                           HEADER_ID,
                                           VALUE_S
                                     FROM SPECDATA
                                    WHERE PART_NO = ASPARTNO2
                                      AND REVISION = ANREVISION2
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND TYPE = ANTYPE
                                      AND REF_ID = ANREFID
                                   MINUS
                                   SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          HEADER_ID,
                                          VALUE_S
                                     FROM SPECDATA
                                    WHERE PART_NO = ASPARTNO1
                                      AND REVISION = ANREVISION1
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND TYPE = ANTYPE
                                      AND REF_ID = ANREFID ) )
                 UNION
                 SELECT DISTINCT SECTION_ID SC_ID,
                                 SUB_SECTION_ID SB_ID,
                                 PROPERTY_GROUP,
                                 NVL( SUBSTR( F_SPH_DESCR( 1,
                                                           PROPERTY,
                                                           0 ),
                                              1,
                                              60 ),
                                      '<no data>' ) F_SP,
                                 SUBSTR( F_ATH_DESCR( 1,
                                                      ATTRIBUTE,
                                                      0 ),
                                         1,
                                         60 ) F_AT,
                                 '- Testmethod -' F_HD,
                                 DECODE( F_GET_INF_REP( ASPARTNO1,
                                                        ANREVISION1,
                                                        SECTION_ID,
                                                        SUB_SECTION_ID,
                                                        PROPERTY_GROUP,
                                                        PROPERTY,
                                                        ATTRIBUTE,
                                                        0,
                                                        3 ),
                                         -999, '@-no data found-@',
                                         SUBSTR( F_TMH_DESCR( 1,
                                                              F_GET_INF_REP( ASPARTNO1,
                                                                             ANREVISION1,
                                                                             SECTION_ID,
                                                                             SUB_SECTION_ID,
                                                                             PROPERTY_GROUP,
                                                                             PROPERTY,
                                                                             ATTRIBUTE,
                                                                             0,
                                                                             3 ),
                                                              F_GET_INF_REP( ASPARTNO1,
                                                                             ANREVISION1,
                                                                             SECTION_ID,
                                                                             SUB_SECTION_ID,
                                                                             PROPERTY_GROUP,
                                                                             PROPERTY,
                                                                             ATTRIBUTE,
                                                                             0,
                                                                             4 ) ),
                                                 1,
                                                 120 ) ) F_SP1,
                                 DECODE( F_GET_INF_REP( ASPARTNO2,
                                                        ANREVISION2,
                                                        SECTION_ID,
                                                        SUB_SECTION_ID,
                                                        PROPERTY_GROUP,
                                                        PROPERTY,
                                                        ATTRIBUTE,
                                                        0,
                                                        3 ),
                                         -999, '@-no data found-@',
                                         SUBSTR( F_TMH_DESCR( 1,
                                                              F_GET_INF_REP( ASPARTNO2,
                                                                             ANREVISION2,
                                                                             SECTION_ID,
                                                                             SUB_SECTION_ID,
                                                                             PROPERTY_GROUP,
                                                                             PROPERTY,
                                                                             ATTRIBUTE,
                                                                             0,
                                                                             3 ),
                                                              F_GET_INF_REP( ASPARTNO2,
                                                                             ANREVISION2,
                                                                             SECTION_ID,
                                                                             SUB_SECTION_ID,
                                                                             PROPERTY_GROUP,
                                                                             PROPERTY,
                                                                             ATTRIBUTE,
                                                                             0,
                                                                             4 ) ),
                                                 1,
                                                 120 ) ) F_SP2
                            FROM ( SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TEST_METHOD
                                    FROM SPECDATA
                                   WHERE PART_NO = ASPARTNO1
                                     AND REVISION = ANREVISION1
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND TYPE = ANTYPE
                                     AND REF_ID = ANREFID
                                  MINUS
                                  SELECT SECTION_ID,
                                         SUB_SECTION_ID,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         TEST_METHOD
                                    FROM SPECDATA
                                   WHERE PART_NO = ASPARTNO2
                                     AND REVISION = ANREVISION2
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND TYPE = ANTYPE
                                     AND REF_ID = ANREFID
                                  UNION
                                  ( SELECT SECTION_ID,
                                           SUB_SECTION_ID,
                                           PROPERTY_GROUP,
                                           PROPERTY,
                                           ATTRIBUTE,
                                           TEST_METHOD
                                     FROM SPECDATA
                                    WHERE PART_NO = ASPARTNO2
                                      AND REVISION = ANREVISION2
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND TYPE = ANTYPE
                                      AND REF_ID = ANREFID
                                   MINUS
                                   SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TEST_METHOD
                                     FROM SPECDATA
                                    WHERE PART_NO = ASPARTNO1
                                      AND REVISION = ANREVISION1
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND TYPE = ANTYPE
                                      AND REF_ID = ANREFID ) )
                 UNION
                 SELECT DISTINCT SECTION_ID SC_ID,
                                 SUB_SECTION_ID SB_ID,
                                 PROPERTY_GROUP,
                                 NVL( SUBSTR( F_SPH_DESCR( 1,
                                                           PROPERTY,
                                                           0 ),
                                              1,
                                              60 ),
                                      '<no data>' ) F_SP,
                                 SUBSTR( F_ATH_DESCR( 1,
                                                      ATTRIBUTE,
                                                      0 ),
                                         1,
                                         60 ) F_AT,
                                 '- UoM -' F_HD,
                                 DECODE( F_GET_INF_REP( ASPARTNO1,
                                                        ANREVISION1,
                                                        SECTION_ID,
                                                        SUB_SECTION_ID,
                                                        PROPERTY_GROUP,
                                                        PROPERTY,
                                                        ATTRIBUTE,
                                                        0,
                                                        1 ),
                                         -999, '@-no data found-@',
                                         SUBSTR( F_UMH_DESCR( 1,
                                                              F_GET_INF_REP( ASPARTNO1,
                                                                             ANREVISION1,
                                                                             SECTION_ID,
                                                                             SUB_SECTION_ID,
                                                                             PROPERTY_GROUP,
                                                                             PROPERTY,
                                                                             ATTRIBUTE,
                                                                             0,
                                                                             1 ),
                                                              F_GET_INF_REP( ASPARTNO1,
                                                                             ANREVISION1,
                                                                             SECTION_ID,
                                                                             SUB_SECTION_ID,
                                                                             PROPERTY_GROUP,
                                                                             PROPERTY,
                                                                             ATTRIBUTE,
                                                                             0,
                                                                             2 ) ),
                                                 1,
                                                 60 ) ) F_SP1,
                                 DECODE( F_GET_INF_REP( ASPARTNO2,
                                                        ANREVISION2,
                                                        SECTION_ID,
                                                        SUB_SECTION_ID,
                                                        PROPERTY_GROUP,
                                                        PROPERTY,
                                                        ATTRIBUTE,
                                                        0,
                                                        1 ),
                                         -999, '@-no data found-@',
                                         SUBSTR( F_UMH_DESCR( 1,
                                                              F_GET_INF_REP( ASPARTNO2,
                                                                             ANREVISION2,
                                                                             SECTION_ID,
                                                                             SUB_SECTION_ID,
                                                                             PROPERTY_GROUP,
                                                                             PROPERTY,
                                                                             ATTRIBUTE,
                                                                             0,
                                                                             1 ),
                                                              F_GET_INF_REP( ASPARTNO2,
                                                                             ANREVISION2,
                                                                             SECTION_ID,
                                                                             SUB_SECTION_ID,
                                                                             PROPERTY_GROUP,
                                                                             PROPERTY,
                                                                             ATTRIBUTE,
                                                                             0,
                                                                             2 ) ),
                                                 1,
                                                 60 ) ) F_SP2
                            FROM ( SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          UOM_ID
                                    FROM SPECDATA
                                   WHERE PART_NO = ASPARTNO1
                                     AND REVISION = ANREVISION1
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND TYPE = ANTYPE
                                     AND REF_ID = ANREFID
                                  MINUS
                                  SELECT SECTION_ID,
                                         SUB_SECTION_ID,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         UOM_ID
                                    FROM SPECDATA
                                   WHERE PART_NO = ASPARTNO2
                                     AND REVISION = ANREVISION2
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND TYPE = ANTYPE
                                     AND REF_ID = ANREFID
                                  UNION
                                  ( SELECT SECTION_ID,
                                           SUB_SECTION_ID,
                                           PROPERTY_GROUP,
                                           PROPERTY,
                                           ATTRIBUTE,
                                           UOM_ID
                                     FROM SPECDATA
                                    WHERE PART_NO = ASPARTNO2
                                      AND REVISION = ANREVISION2
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND TYPE = ANTYPE
                                      AND REF_ID = ANREFID
                                   MINUS
                                   SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          UOM_ID
                                     FROM SPECDATA
                                    WHERE PART_NO = ASPARTNO1
                                      AND REVISION = ANREVISION1
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND TYPE = ANTYPE
                                      AND REF_ID = ANREFID ) )
                 UNION
                 SELECT DISTINCT SECTION_ID SC_ID,
                                 SUB_SECTION_ID SB_ID,
                                 PROPERTY_GROUP,
                                 NVL( SUBSTR( F_SPH_DESCR( 1,
                                                           PROPERTY,
                                                           0 ),
                                              1,
                                              60 ),
                                      '<no data>' ) F_SP,
                                 SUBSTR( F_ATH_DESCR( 1,
                                                      ATTRIBUTE,
                                                      0 ),
                                         1,
                                         60 ) F_AT,
                                 SUBSTR( F_TMH_DESCR( 1,
                                                      TM,
                                                      TM_REV ),
                                         1,
                                         60 ) F_HD,
                                 DECODE( F_GET_INF_REP( ASPARTNO1,
                                                        ANREVISION1,
                                                        SECTION_ID,
                                                        SUB_SECTION_ID,
                                                        PROPERTY_GROUP,
                                                        PROPERTY,
                                                        ATTRIBUTE,
                                                        TM,
                                                        5 ),
                                         -999, '@-no data found-@',
                                         SUBSTR(    F_REP_TMTYPE( F_GET_INF_REP( ASPARTNO1,
                                                                                 ANREVISION1,
                                                                                 SECTION_ID,
                                                                                 SUB_SECTION_ID,
                                                                                 PROPERTY_GROUP,
                                                                                 PROPERTY,
                                                                                 ATTRIBUTE,
                                                                                 TM,
                                                                                 5 ) )
                                                 || '  '
                                                 || F_GET_INF_REP( ASPARTNO1,
                                                                   ANREVISION1,
                                                                   SECTION_ID,
                                                                   SUB_SECTION_ID,
                                                                   PROPERTY_GROUP,
                                                                   PROPERTY,
                                                                   ATTRIBUTE,
                                                                   TM,
                                                                   6 ),
                                                 1,
                                                 120 ) ) F_SP1,
                                 DECODE( F_GET_INF_REP( ASPARTNO2,
                                                        ANREVISION2,
                                                        SECTION_ID,
                                                        SUB_SECTION_ID,
                                                        PROPERTY_GROUP,
                                                        PROPERTY,
                                                        ATTRIBUTE,
                                                        TM,
                                                        5 ),
                                         -999, '@-no data found-@',
                                         SUBSTR(    F_REP_TMTYPE( F_GET_INF_REP( ASPARTNO2,
                                                                                 ANREVISION2,
                                                                                 SECTION_ID,
                                                                                 SUB_SECTION_ID,
                                                                                 PROPERTY_GROUP,
                                                                                 PROPERTY,
                                                                                 ATTRIBUTE,
                                                                                 TM,
                                                                                 5 ) )
                                                 || '  '
                                                 || F_GET_INF_REP( ASPARTNO2,
                                                                   ANREVISION2,
                                                                   SECTION_ID,
                                                                   SUB_SECTION_ID,
                                                                   PROPERTY_GROUP,
                                                                   PROPERTY,
                                                                   ATTRIBUTE,
                                                                   TM,
                                                                   6 ),
                                                 1,
                                                 120 ) ) F_SP2
                            FROM ( SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_TYPE,
                                          TM,
                                          TM_REV,
                                          TM_SET_NO
                                    FROM SPECIFICATION_TM
                                   WHERE PART_NO = ASPARTNO1
                                     AND REVISION = ANREVISION1
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                  1, ANREFID,
                                                                  -99 )
                                  MINUS
                                  SELECT SECTION_ID,
                                         SUB_SECTION_ID,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         TM_TYPE,
                                         TM,
                                         TM_REV,
                                         TM_SET_NO
                                    FROM SPECIFICATION_TM
                                   WHERE PART_NO = ASPARTNO2
                                     AND REVISION = ANREVISION2
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                  1, ANREFID,
                                                                  -99 )
                                  UNION
                                  ( SELECT SECTION_ID,
                                           SUB_SECTION_ID,
                                           PROPERTY_GROUP,
                                           PROPERTY,
                                           ATTRIBUTE,
                                           TM_TYPE,
                                           TM,
                                           TM_REV,
                                           TM_SET_NO
                                     FROM SPECIFICATION_TM
                                    WHERE PART_NO = ASPARTNO2
                                      AND REVISION = ANREVISION2
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                   1, ANREFID,
                                                                   -99 )
                                   MINUS
                                   SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_TYPE,
                                          TM,
                                          TM_REV,
                                          TM_SET_NO
                                     FROM SPECIFICATION_TM
                                    WHERE PART_NO = ASPARTNO1
                                      AND REVISION = ANREVISION1
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                   1, ANREFID,
                                                                   -99 ) ) )
                 UNION
                 SELECT DISTINCT SECTION_ID SC_ID,
                                 SUB_SECTION_ID SB_ID,
                                 PROPERTY_GROUP,
                                 NVL( SUBSTR( F_SPH_DESCR( 1,
                                                           PROPERTY,
                                                           0 ),
                                              1,
                                              60 ),
                                      '<no data>' ) F_SP,
                                 SUBSTR( F_ATH_DESCR( 1,
                                                      ATTRIBUTE,
                                                      0 ),
                                         1,
                                         60 ) F_AT,
                                 SUBSTR( F_TMH_DESCR( 1,
                                                      TM,
                                                      TM_REV ),
                                         1,
                                         60 ) F_HD,
                                 DECODE( F_GET_INF_REP( ASPARTNO1,
                                                        ANREVISION1,
                                                        SECTION_ID,
                                                        SUB_SECTION_ID,
                                                        PROPERTY_GROUP,
                                                        PROPERTY,
                                                        ATTRIBUTE,
                                                        TM,
                                                        5 ),
                                         -999, '@-no data found-@',
                                         SUBSTR(    F_REP_TMTYPE( F_GET_INF_REP( ASPARTNO1,
                                                                                 ANREVISION1,
                                                                                 SECTION_ID,
                                                                                 SUB_SECTION_ID,
                                                                                 PROPERTY_GROUP,
                                                                                 PROPERTY,
                                                                                 ATTRIBUTE,
                                                                                 TM,
                                                                                 5 ) )
                                                 || '  '
                                                 || F_GET_INF_REP( ASPARTNO1,
                                                                   ANREVISION1,
                                                                   SECTION_ID,
                                                                   SUB_SECTION_ID,
                                                                   PROPERTY_GROUP,
                                                                   PROPERTY,
                                                                   ATTRIBUTE,
                                                                   TM,
                                                                   6 ),
                                                 1,
                                                 120 ) ) F_SP1,
                                 DECODE( F_GET_INF_REP( ASPARTNO2,
                                                        ANREVISION2,
                                                        SECTION_ID,
                                                        SUB_SECTION_ID,
                                                        PROPERTY_GROUP,
                                                        PROPERTY,
                                                        ATTRIBUTE,
                                                        TM,
                                                        5 ),
                                         -999, '@-no data found-@',
                                         SUBSTR(    F_REP_TMTYPE( F_GET_INF_REP( ASPARTNO2,
                                                                                 ANREVISION2,
                                                                                 SECTION_ID,
                                                                                 SUB_SECTION_ID,
                                                                                 PROPERTY_GROUP,
                                                                                 PROPERTY,
                                                                                 ATTRIBUTE,
                                                                                 TM,
                                                                                 5 ) )
                                                 || '  '
                                                 || F_GET_INF_REP( ASPARTNO2,
                                                                   ANREVISION2,
                                                                   SECTION_ID,
                                                                   SUB_SECTION_ID,
                                                                   PROPERTY_GROUP,
                                                                   PROPERTY,
                                                                   ATTRIBUTE,
                                                                   TM,
                                                                   6 ),
                                                 1,
                                                 120 ) ) F_SP2
                            FROM ( SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_TYPE,
                                          TM,
                                          TM_REV,
                                          TM_SET_NO
                                    FROM SPECIFICATION_TM
                                   WHERE PART_NO = ASPARTNO1
                                     AND REVISION = ANREVISION1
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = 0
                                     AND PROPERTY = DECODE( ANTYPE,
                                                            4, ANREFID,
                                                            -99 )
                                  MINUS
                                  SELECT SECTION_ID,
                                         SUB_SECTION_ID,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         TM_TYPE,
                                         TM,
                                         TM_REV,
                                         TM_SET_NO
                                    FROM SPECIFICATION_TM
                                   WHERE PART_NO = ASPARTNO2
                                     AND REVISION = ANREVISION2
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = 0
                                     AND PROPERTY = DECODE( ANTYPE,
                                                            4, ANREFID,
                                                            -99 )
                                  UNION
                                  ( SELECT SECTION_ID,
                                           SUB_SECTION_ID,
                                           PROPERTY_GROUP,
                                           PROPERTY,
                                           ATTRIBUTE,
                                           TM_TYPE,
                                           TM,
                                           TM_REV,
                                           TM_SET_NO
                                     FROM SPECIFICATION_TM
                                    WHERE PART_NO = ASPARTNO2
                                      AND REVISION = ANREVISION2
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = 0
                                      AND PROPERTY = DECODE( ANTYPE,
                                                             4, ANREFID,
                                                             -99 )
                                   MINUS
                                   SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_TYPE,
                                          TM,
                                          TM_REV,
                                          TM_SET_NO
                                     FROM SPECIFICATION_TM
                                    WHERE PART_NO = ASPARTNO1
                                      AND REVISION = ANREVISION1
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = 0
                                      AND PROPERTY = DECODE( ANTYPE,
                                                             4, ANREFID,
                                                             -99 ) ) )
                 UNION
                 SELECT DISTINCT SECTION_ID SC_ID,
                                 SUB_SECTION_ID SB_ID,
                                 PROPERTY_GROUP,
                                 NVL( SUBSTR( F_SPH_DESCR( 1,
                                                           PROPERTY,
                                                           0 ),
                                              1,
                                              60 ),
                                      '<no data>' ) F_SP,
                                 SUBSTR( F_ATH_DESCR( 1,
                                                      ATTRIBUTE,
                                                      0 ),
                                         1,
                                         60 ) F_AT,
                                    '- '
                                 || SUBSTR( F_REP_TMTYPE( 1 ),
                                            1,
                                            120 )
                                 || ' -' F_HD,
                                 DECODE( F_REP_TMTYPE( 1 ),
                                         'none', '@-no data found-@',
                                         DECODE( F_GET_INF_REP( ASPARTNO1,
                                                                ANREVISION1,
                                                                SECTION_ID,
                                                                SUB_SECTION_ID,
                                                                PROPERTY_GROUP,
                                                                PROPERTY,
                                                                ATTRIBUTE,
                                                                0,
                                                                7 ),
                                                 1, 'Y',
                                                 -999, '@-no data found-@',
                                                 'N' ) ) F_SP1,
                                 DECODE( F_REP_TMTYPE( 1 ),
                                         'none', '@-no data found-@',
                                         DECODE( F_GET_INF_REP( ASPARTNO2,
                                                                ANREVISION2,
                                                                SECTION_ID,
                                                                SUB_SECTION_ID,
                                                                PROPERTY_GROUP,
                                                                PROPERTY,
                                                                ATTRIBUTE,
                                                                0,
                                                                7 ),
                                                 1, 'Y',
                                                 -999, '@-no data found-@',
                                                 'N' ) ) F_SP2
                            FROM ( SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_DET_1
                                    FROM SPECIFICATION_PROP
                                   WHERE PART_NO = ASPARTNO1
                                     AND REVISION = ANREVISION1
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                  1, ANREFID,
                                                                  -99 )
                                  MINUS
                                  SELECT SECTION_ID,
                                         SUB_SECTION_ID,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         TM_DET_1
                                    FROM SPECIFICATION_PROP
                                   WHERE PART_NO = ASPARTNO2
                                     AND REVISION = ANREVISION2
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                  1, ANREFID,
                                                                  -99 )
                                  UNION
                                  ( SELECT SECTION_ID,
                                           SUB_SECTION_ID,
                                           PROPERTY_GROUP,
                                           PROPERTY,
                                           ATTRIBUTE,
                                           TM_DET_1
                                     FROM SPECIFICATION_PROP
                                    WHERE PART_NO = ASPARTNO2
                                      AND REVISION = ANREVISION2
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                   1, ANREFID,
                                                                   -99 )
                                   MINUS
                                   SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_DET_1
                                     FROM SPECIFICATION_PROP
                                    WHERE PART_NO = ASPARTNO1
                                      AND REVISION = ANREVISION1
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                   1, ANREFID,
                                                                   -99 ) ) )
                 UNION
                 SELECT DISTINCT SECTION_ID SC_ID,
                                 SUB_SECTION_ID SB_ID,
                                 PROPERTY_GROUP,
                                 NVL( SUBSTR( F_SPH_DESCR( 1,
                                                           PROPERTY,
                                                           0 ),
                                              1,
                                              60 ),
                                      '<no data>' ) F_SP,
                                 SUBSTR( F_ATH_DESCR( 1,
                                                      ATTRIBUTE,
                                                      0 ),
                                         1,
                                         60 ) F_AT,
                                    '- '
                                 || SUBSTR( F_REP_TMTYPE( 2 ),
                                            1,
                                            120 )
                                 || ' -' F_HD,
                                 DECODE( F_REP_TMTYPE( 2 ),
                                         'none', '@-no data found-@',
                                         DECODE( F_GET_INF_REP( ASPARTNO1,
                                                                ANREVISION1,
                                                                SECTION_ID,
                                                                SUB_SECTION_ID,
                                                                PROPERTY_GROUP,
                                                                PROPERTY,
                                                                ATTRIBUTE,
                                                                0,
                                                                8 ),
                                                 1, 'Y',
                                                 -999, '@-no data found-@',
                                                 'N' ) ) F_SP1,
                                 DECODE( F_REP_TMTYPE( 2 ),
                                         'none', '@-no data found-@',
                                         DECODE( F_GET_INF_REP( ASPARTNO2,
                                                                ANREVISION2,
                                                                SECTION_ID,
                                                                SUB_SECTION_ID,
                                                                PROPERTY_GROUP,
                                                                PROPERTY,
                                                                ATTRIBUTE,
                                                                0,
                                                                8 ),
                                                 1, 'Y',
                                                 -999, '@-no data found-@',
                                                 'N' ) ) F_SP2
                            FROM ( SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_DET_2
                                    FROM SPECIFICATION_PROP
                                   WHERE PART_NO = ASPARTNO1
                                     AND REVISION = ANREVISION1
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                  1, ANREFID,
                                                                  -99 )
                                  MINUS
                                  SELECT SECTION_ID,
                                         SUB_SECTION_ID,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         TM_DET_2
                                    FROM SPECIFICATION_PROP
                                   WHERE PART_NO = ASPARTNO2
                                     AND REVISION = ANREVISION2
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                  1, ANREFID,
                                                                  -99 )
                                  UNION
                                  ( SELECT SECTION_ID,
                                           SUB_SECTION_ID,
                                           PROPERTY_GROUP,
                                           PROPERTY,
                                           ATTRIBUTE,
                                           TM_DET_2
                                     FROM SPECIFICATION_PROP
                                    WHERE PART_NO = ASPARTNO2
                                      AND REVISION = ANREVISION2
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                   1, ANREFID,
                                                                   -99 )
                                   MINUS
                                   SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_DET_2
                                     FROM SPECIFICATION_PROP
                                    WHERE PART_NO = ASPARTNO1
                                      AND REVISION = ANREVISION1
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                   1, ANREFID,
                                                                   -99 ) ) )
                 UNION
                 SELECT DISTINCT SECTION_ID SC_ID,
                                 SUB_SECTION_ID SB_ID,
                                 PROPERTY_GROUP,
                                 NVL( SUBSTR( F_SPH_DESCR( 1,
                                                           PROPERTY,
                                                           0 ),
                                              1,
                                              60 ),
                                      '<no data>' ) F_SP,
                                 SUBSTR( F_ATH_DESCR( 1,
                                                      ATTRIBUTE,
                                                      0 ),
                                         1,
                                         60 ) F_AT,
                                    '- '
                                 || SUBSTR( F_REP_TMTYPE( 3 ),
                                            1,
                                            120 )
                                 || ' -' F_HD,
                                 DECODE( F_REP_TMTYPE( 3 ),
                                         'none', '@-no data found-@',
                                         DECODE( F_GET_INF_REP( ASPARTNO1,
                                                                ANREVISION1,
                                                                SECTION_ID,
                                                                SUB_SECTION_ID,
                                                                PROPERTY_GROUP,
                                                                PROPERTY,
                                                                ATTRIBUTE,
                                                                0,
                                                                9 ),
                                                 1, 'Y',
                                                 -999, '@-no data found-@',
                                                 'N' ) ) F_SP1,
                                 DECODE( F_REP_TMTYPE( 3 ),
                                         'none', '@-no data found-@',
                                         DECODE( F_GET_INF_REP( ASPARTNO2,
                                                                ANREVISION2,
                                                                SECTION_ID,
                                                                SUB_SECTION_ID,
                                                                PROPERTY_GROUP,
                                                                PROPERTY,
                                                                ATTRIBUTE,
                                                                0,
                                                                9 ),
                                                 1, 'Y',
                                                 -999, '@-no data found-@',
                                                 'N' ) ) F_SP2
                            FROM ( SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_DET_3
                                    FROM SPECIFICATION_PROP
                                   WHERE PART_NO = ASPARTNO1
                                     AND REVISION = ANREVISION1
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                  1, ANREFID,
                                                                  -99 )
                                  MINUS
                                  SELECT SECTION_ID,
                                         SUB_SECTION_ID,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         TM_DET_3
                                    FROM SPECIFICATION_PROP
                                   WHERE PART_NO = ASPARTNO2
                                     AND REVISION = ANREVISION2
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                  1, ANREFID,
                                                                  -99 )
                                  UNION
                                  ( SELECT SECTION_ID,
                                           SUB_SECTION_ID,
                                           PROPERTY_GROUP,
                                           PROPERTY,
                                           ATTRIBUTE,
                                           TM_DET_3
                                     FROM SPECIFICATION_PROP
                                    WHERE PART_NO = ASPARTNO2
                                      AND REVISION = ANREVISION2
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                   1, ANREFID,
                                                                   -99 )
                                   MINUS
                                   SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_DET_3
                                     FROM SPECIFICATION_PROP
                                    WHERE PART_NO = ASPARTNO1
                                      AND REVISION = ANREVISION1
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                   1, ANREFID,
                                                                   -99 ) ) )
                 UNION
                 SELECT DISTINCT SECTION_ID SC_ID,
                                 SUB_SECTION_ID SB_ID,
                                 PROPERTY_GROUP,
                                 NVL( SUBSTR( F_SPH_DESCR( 1,
                                                           PROPERTY,
                                                           0 ),
                                              1,
                                              60 ),
                                      '<no data>' ) F_SP,
                                 SUBSTR( F_ATH_DESCR( 1,
                                                      ATTRIBUTE,
                                                      0 ),
                                         1,
                                         60 ) F_AT,
                                    '- '
                                 || SUBSTR( F_REP_TMTYPE( 4 ),
                                            1,
                                            120 )
                                 || ' -' F_HD,
                                 DECODE( F_REP_TMTYPE( 4 ),
                                         'none', '@-no data found-@',
                                         DECODE( F_GET_INF_REP( ASPARTNO1,
                                                                ANREVISION1,
                                                                SECTION_ID,
                                                                SUB_SECTION_ID,
                                                                PROPERTY_GROUP,
                                                                PROPERTY,
                                                                ATTRIBUTE,
                                                                0,
                                                                10 ),
                                                 1, 'Y',
                                                 -999, '@-no data found-@',
                                                 'N' ) ) F_SP1,
                                 DECODE( F_REP_TMTYPE( 4 ),
                                         'none', '@-no data found-@',
                                         DECODE( F_GET_INF_REP( ASPARTNO2,
                                                                ANREVISION2,
                                                                SECTION_ID,
                                                                SUB_SECTION_ID,
                                                                PROPERTY_GROUP,
                                                                PROPERTY,
                                                                ATTRIBUTE,
                                                                0,
                                                                10 ),
                                                 1, 'Y',
                                                 -999, '@-no data found-@',
                                                 'N' ) ) F_SP2
                            FROM ( SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_DET_4
                                    FROM SPECIFICATION_PROP
                                   WHERE PART_NO = ASPARTNO1
                                     AND REVISION = ANREVISION1
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                  1, ANREFID,
                                                                  -99 )
                                  MINUS
                                  SELECT SECTION_ID,
                                         SUB_SECTION_ID,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         TM_DET_4
                                    FROM SPECIFICATION_PROP
                                   WHERE PART_NO = ASPARTNO2
                                     AND REVISION = ANREVISION2
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                  1, ANREFID,
                                                                  -99 )
                                  UNION
                                  ( SELECT SECTION_ID,
                                           SUB_SECTION_ID,
                                           PROPERTY_GROUP,
                                           PROPERTY,
                                           ATTRIBUTE,
                                           TM_DET_4
                                     FROM SPECIFICATION_PROP
                                    WHERE PART_NO = ASPARTNO2
                                      AND REVISION = ANREVISION2
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                   1, ANREFID,
                                                                   -99 )
                                   MINUS
                                   SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_DET_4
                                     FROM SPECIFICATION_PROP
                                    WHERE PART_NO = ASPARTNO1
                                      AND REVISION = ANREVISION1
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                   1, ANREFID,
                                                                   -99 ) ) )
                 UNION
                 SELECT DISTINCT SECTION_ID SC_ID,
                                 SUB_SECTION_ID SB_ID,
                                 PROPERTY_GROUP,
                                 NVL( SUBSTR( F_SPH_DESCR( 1,
                                                           PROPERTY,
                                                           0 ),
                                              1,
                                              60 ),
                                      '<no data>' ) F_SP,
                                 SUBSTR( F_ATH_DESCR( 1,
                                                      ATTRIBUTE,
                                                      0 ),
                                         1,
                                         60 ) F_AT,
                                 '- Condition Set -' F_HD,
                                 DECODE(    F_GET_INF_REP( ASPARTNO1,
                                                           ANREVISION1,
                                                           SECTION_ID,
                                                           SUB_SECTION_ID,
                                                           PROPERTY_GROUP,
                                                           PROPERTY,
                                                           ATTRIBUTE,
                                                           0,
                                                           11 )
                                         || ' ',
                                         -999, '@-no data found-@',
                                            F_GET_INF_REP( ASPARTNO1,
                                                           ANREVISION1,
                                                           SECTION_ID,
                                                           SUB_SECTION_ID,
                                                           PROPERTY_GROUP,
                                                           PROPERTY,
                                                           ATTRIBUTE,
                                                           0,
                                                           11 )
                                         || ' ' ) F_SP1,
                                 DECODE(    F_GET_INF_REP( ASPARTNO2,
                                                           ANREVISION2,
                                                           SECTION_ID,
                                                           SUB_SECTION_ID,
                                                           PROPERTY_GROUP,
                                                           PROPERTY,
                                                           ATTRIBUTE,
                                                           0,
                                                           11 )
                                         || ' ',
                                         -999, '@-no data found-@',
                                            F_GET_INF_REP( ASPARTNO2,
                                                           ANREVISION2,
                                                           SECTION_ID,
                                                           SUB_SECTION_ID,
                                                           PROPERTY_GROUP,
                                                           PROPERTY,
                                                           ATTRIBUTE,
                                                           0,
                                                           11 )
                                         || ' ' ) F_SP2
                            FROM ( SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_SET_NO
                                    FROM SPECIFICATION_PROP
                                   WHERE PART_NO = ASPARTNO1
                                     AND REVISION = ANREVISION1
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                  1, ANREFID,
                                                                  -99 )
                                  MINUS
                                  SELECT SECTION_ID,
                                         SUB_SECTION_ID,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         TM_SET_NO
                                    FROM SPECIFICATION_PROP
                                   WHERE PART_NO = ASPARTNO2
                                     AND REVISION = ANREVISION2
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                  1, ANREFID,
                                                                  -99 )
                                  UNION
                                  ( SELECT SECTION_ID,
                                           SUB_SECTION_ID,
                                           PROPERTY_GROUP,
                                           PROPERTY,
                                           ATTRIBUTE,
                                           TM_SET_NO
                                     FROM SPECIFICATION_PROP
                                    WHERE PART_NO = ASPARTNO2
                                      AND REVISION = ANREVISION2
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                   1, ANREFID,
                                                                   -99 )
                                   MINUS
                                   SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_SET_NO
                                     FROM SPECIFICATION_PROP
                                    WHERE PART_NO = ASPARTNO1
                                      AND REVISION = ANREVISION1
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                   1, ANREFID,
                                                                   -99 ) ) ) )
          WHERE (    F_SP1 <> '@-no data found-@'
                  OR F_SP2 <> '@-no data found-@' );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         OPEN AQPROPERTYGROUP FOR
            SELECT DISTINCT 0,
                            0,
                            0
                       FROM DUAL;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPROPERTYGROUPDETAIL;


   FUNCTION GETPROPERTYGROUPDETAILLANG(

      ASPARTNO1                  IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION1                IN       IAPITYPE.REVISION_TYPE,
      ANLANGID1                  IN       IAPITYPE.LANGUAGEID_TYPE,
      ASPARTNO2                  IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION2                IN       IAPITYPE.REVISION_TYPE,
      ANLANGID2                  IN       IAPITYPE.LANGUAGEID_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE,
      ANREFID                    IN       IAPITYPE.ID_TYPE,
      AQPROPERTYGROUP            OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS









      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPropertyGroupDetailLang';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQPROPERTYGROUP FOR
         SELECT *
           FROM ( SELECT DISTINCT SECTION_ID SC_ID,
                                  SUB_SECTION_ID SB_ID,
                                  PROPERTY_GROUP,
                                  NVL( SUBSTR( F_SPH_DESCR( 1,
                                                            PROPERTY,
                                                            0 ),
                                               1,
                                               60 ),
                                       '<no data>' ) F_SP,
                                  SUBSTR( F_ATH_DESCR( 1,
                                                       ATTRIBUTE,
                                                       0 ),
                                          1,
                                          60 ) F_AT,
                                  SUBSTR( F_HDH_DESCR( 1,
                                                       HEADER_ID,
                                                       0 ),
                                          1,
                                          60 ) F_HD,
                                  SUBSTR( F_GET_SVAL_REP_LANG( ASPARTNO1,
                                                               ANREVISION1,
                                                               SECTION_ID,
                                                               SUB_SECTION_ID,
                                                               PROPERTY_GROUP,
                                                               PROPERTY,
                                                               ATTRIBUTE,
                                                               HEADER_ID,
                                                               ANLANGID1 ),
                                          1,
                                          120 ) F_SP1,
                                  SUBSTR( F_GET_SVAL_REP_LANG( ASPARTNO2,
                                                               ANREVISION2,
                                                               SECTION_ID,
                                                               SUB_SECTION_ID,
                                                               PROPERTY_GROUP,
                                                               PROPERTY,
                                                               ATTRIBUTE,
                                                               HEADER_ID,
                                                               ANLANGID2 ),
                                          1,
                                          120 ) F_SP2
                            FROM ( ( SELECT SECTION_ID,
                                            SUB_SECTION_ID,
                                            PROPERTY_GROUP,
                                            PROPERTY,
                                            ATTRIBUTE,
                                            HEADER_ID,
                                            VALUE_S
                                      FROM SPECDATA
                                     WHERE PART_NO = ASPARTNO1
                                       AND REVISION = ANREVISION1
                                       AND SECTION_ID = ANSECTIONID
                                       AND SUB_SECTION_ID = ANSUBSECTIONID
                                       AND TYPE = ANTYPE
                                       AND REF_ID = ANREFID
                                       AND LANG_ID = 1
                                    UNION
                                    SELECT SECTION_ID,
                                           SUB_SECTION_ID,
                                           PROPERTY_GROUP,
                                           PROPERTY,
                                           ATTRIBUTE,
                                           HEADER_ID,
                                           VALUE_S
                                      FROM SPECDATA
                                     WHERE PART_NO = ASPARTNO1
                                       AND REVISION = ANREVISION1
                                       AND SECTION_ID = ANSECTIONID
                                       AND SUB_SECTION_ID = ANSUBSECTIONID
                                       AND TYPE = ANTYPE
                                       AND REF_ID = ANREFID
                                       AND LANG_ID = ANLANGID1 )
                                  MINUS
                                  ( SELECT SECTION_ID,
                                           SUB_SECTION_ID,
                                           PROPERTY_GROUP,
                                           PROPERTY,
                                           ATTRIBUTE,
                                           HEADER_ID,
                                           VALUE_S
                                     FROM SPECDATA
                                    WHERE PART_NO = ASPARTNO2
                                      AND REVISION = ANREVISION2
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND TYPE = ANTYPE
                                      AND REF_ID = ANREFID
                                      AND LANG_ID = 1
                                   UNION
                                   SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          HEADER_ID,
                                          VALUE_S
                                     FROM SPECDATA
                                    WHERE PART_NO = ASPARTNO2
                                      AND REVISION = ANREVISION2
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND TYPE = ANTYPE
                                      AND REF_ID = ANREFID
                                      AND LANG_ID = ANLANGID2 )
                                  UNION
                                  ( ( SELECT SECTION_ID,
                                             SUB_SECTION_ID,
                                             PROPERTY_GROUP,
                                             PROPERTY,
                                             ATTRIBUTE,
                                             HEADER_ID,
                                             VALUE_S
                                       FROM SPECDATA
                                      WHERE PART_NO = ASPARTNO2
                                        AND REVISION = ANREVISION2
                                        AND SECTION_ID = ANSECTIONID
                                        AND SUB_SECTION_ID = ANSUBSECTIONID
                                        AND TYPE = ANTYPE
                                        AND REF_ID = ANREFID
                                        AND LANG_ID = 1
                                     UNION
                                     SELECT SECTION_ID,
                                            SUB_SECTION_ID,
                                            PROPERTY_GROUP,
                                            PROPERTY,
                                            ATTRIBUTE,
                                            HEADER_ID,
                                            VALUE_S
                                       FROM SPECDATA
                                      WHERE PART_NO = ASPARTNO2
                                        AND REVISION = ANREVISION2
                                        AND SECTION_ID = ANSECTIONID
                                        AND SUB_SECTION_ID = ANSUBSECTIONID
                                        AND TYPE = ANTYPE
                                        AND REF_ID = ANREFID
                                        AND LANG_ID = ANLANGID2 )
                                   MINUS
                                   ( SELECT SECTION_ID,
                                            SUB_SECTION_ID,
                                            PROPERTY_GROUP,
                                            PROPERTY,
                                            ATTRIBUTE,
                                            HEADER_ID,
                                            VALUE_S
                                      FROM SPECDATA
                                     WHERE PART_NO = ASPARTNO1
                                       AND REVISION = ANREVISION1
                                       AND SECTION_ID = ANSECTIONID
                                       AND SUB_SECTION_ID = ANSUBSECTIONID
                                       AND TYPE = ANTYPE
                                       AND REF_ID = ANREFID
                                       AND LANG_ID = 1
                                    UNION
                                    SELECT SECTION_ID,
                                           SUB_SECTION_ID,
                                           PROPERTY_GROUP,
                                           PROPERTY,
                                           ATTRIBUTE,
                                           HEADER_ID,
                                           VALUE_S
                                      FROM SPECDATA
                                     WHERE PART_NO = ASPARTNO1
                                       AND REVISION = ANREVISION1
                                       AND SECTION_ID = ANSECTIONID
                                       AND SUB_SECTION_ID = ANSUBSECTIONID
                                       AND TYPE = ANTYPE
                                       AND REF_ID = ANREFID
                                       AND LANG_ID = ANLANGID1 ) ) )
                 UNION
                 SELECT DISTINCT SECTION_ID SC_ID,
                                 SUB_SECTION_ID SB_ID,
                                 PROPERTY_GROUP,
                                 NVL( SUBSTR( F_SPH_DESCR( 1,
                                                           PROPERTY,
                                                           0 ),
                                              1,
                                              60 ),
                                      '<no data>' ) F_SP,
                                 SUBSTR( F_ATH_DESCR( 1,
                                                      ATTRIBUTE,
                                                      0 ),
                                         1,
                                         60 ) F_AT,
                                 '- Testmethod -' F_HD,
                                 DECODE( F_GET_INF_REP( ASPARTNO1,
                                                        ANREVISION1,
                                                        SECTION_ID,
                                                        SUB_SECTION_ID,
                                                        PROPERTY_GROUP,
                                                        PROPERTY,
                                                        ATTRIBUTE,
                                                        0,
                                                        3 ),
                                         -999, '@-no data found-@',
                                         SUBSTR( F_TMH_DESCR( 1,
                                                              F_GET_INF_REP( ASPARTNO1,
                                                                             ANREVISION1,
                                                                             SECTION_ID,
                                                                             SUB_SECTION_ID,
                                                                             PROPERTY_GROUP,
                                                                             PROPERTY,
                                                                             ATTRIBUTE,
                                                                             0,
                                                                             3 ),
                                                              F_GET_INF_REP( ASPARTNO1,
                                                                             ANREVISION1,
                                                                             SECTION_ID,
                                                                             SUB_SECTION_ID,
                                                                             PROPERTY_GROUP,
                                                                             PROPERTY,
                                                                             ATTRIBUTE,
                                                                             0,
                                                                             4 ) ),
                                                 1,
                                                 120 ) ) F_SP1,
                                 DECODE( F_GET_INF_REP( ASPARTNO2,
                                                        ANREVISION2,
                                                        SECTION_ID,
                                                        SUB_SECTION_ID,
                                                        PROPERTY_GROUP,
                                                        PROPERTY,
                                                        ATTRIBUTE,
                                                        0,
                                                        3 ),
                                         -999, '@-no data found-@',
                                         SUBSTR( F_TMH_DESCR( 1,
                                                              F_GET_INF_REP( ASPARTNO2,
                                                                             ANREVISION2,
                                                                             SECTION_ID,
                                                                             SUB_SECTION_ID,
                                                                             PROPERTY_GROUP,
                                                                             PROPERTY,
                                                                             ATTRIBUTE,
                                                                             0,
                                                                             3 ),
                                                              F_GET_INF_REP( ASPARTNO2,
                                                                             ANREVISION2,
                                                                             SECTION_ID,
                                                                             SUB_SECTION_ID,
                                                                             PROPERTY_GROUP,
                                                                             PROPERTY,
                                                                             ATTRIBUTE,
                                                                             0,
                                                                             4 ) ),
                                                 1,
                                                 120 ) ) F_SP2
                            FROM ( SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TEST_METHOD
                                    FROM SPECDATA
                                   WHERE PART_NO = ASPARTNO1
                                     AND REVISION = ANREVISION1
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND TYPE = ANTYPE
                                     AND REF_ID = ANREFID
                                  MINUS
                                  SELECT SECTION_ID,
                                         SUB_SECTION_ID,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         TEST_METHOD
                                    FROM SPECDATA
                                   WHERE PART_NO = ASPARTNO2
                                     AND REVISION = ANREVISION2
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND TYPE = ANTYPE
                                     AND REF_ID = ANREFID
                                  UNION
                                  ( SELECT SECTION_ID,
                                           SUB_SECTION_ID,
                                           PROPERTY_GROUP,
                                           PROPERTY,
                                           ATTRIBUTE,
                                           TEST_METHOD
                                     FROM SPECDATA
                                    WHERE PART_NO = ASPARTNO2
                                      AND REVISION = ANREVISION2
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND TYPE = ANTYPE
                                      AND REF_ID = ANREFID
                                   MINUS
                                   SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TEST_METHOD
                                     FROM SPECDATA
                                    WHERE PART_NO = ASPARTNO1
                                      AND REVISION = ANREVISION1
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND TYPE = ANTYPE
                                      AND REF_ID = ANREFID ) )
                 UNION
                 SELECT DISTINCT SECTION_ID SC_ID,
                                 SUB_SECTION_ID SB_ID,
                                 PROPERTY_GROUP,
                                 NVL( SUBSTR( F_SPH_DESCR( 1,
                                                           PROPERTY,
                                                           0 ),
                                              1,
                                              60 ),
                                      '<no data>' ) F_SP,
                                 SUBSTR( F_ATH_DESCR( 1,
                                                      ATTRIBUTE,
                                                      0 ),
                                         1,
                                         60 ) F_AT,
                                 '- UoM -' F_HD,
                                 DECODE( F_GET_INF_REP( ASPARTNO1,
                                                        ANREVISION1,
                                                        SECTION_ID,
                                                        SUB_SECTION_ID,
                                                        PROPERTY_GROUP,
                                                        PROPERTY,
                                                        ATTRIBUTE,
                                                        0,
                                                        1 ),
                                         -999, '@-no data found-@',
                                         SUBSTR( F_UMH_DESCR( 1,
                                                              F_GET_INF_REP( ASPARTNO1,
                                                                             ANREVISION1,
                                                                             SECTION_ID,
                                                                             SUB_SECTION_ID,
                                                                             PROPERTY_GROUP,
                                                                             PROPERTY,
                                                                             ATTRIBUTE,
                                                                             0,
                                                                             1 ),
                                                              F_GET_INF_REP( ASPARTNO1,
                                                                             ANREVISION1,
                                                                             SECTION_ID,
                                                                             SUB_SECTION_ID,
                                                                             PROPERTY_GROUP,
                                                                             PROPERTY,
                                                                             ATTRIBUTE,
                                                                             0,
                                                                             2 ) ),
                                                 1,
                                                 60 ) ) F_SP1,
                                 DECODE( F_GET_INF_REP( ASPARTNO2,
                                                        ANREVISION2,
                                                        SECTION_ID,
                                                        SUB_SECTION_ID,
                                                        PROPERTY_GROUP,
                                                        PROPERTY,
                                                        ATTRIBUTE,
                                                        0,
                                                        1 ),
                                         -999, '@-no data found-@',
                                         SUBSTR( F_UMH_DESCR( 1,
                                                              F_GET_INF_REP( ASPARTNO2,
                                                                             ANREVISION2,
                                                                             SECTION_ID,
                                                                             SUB_SECTION_ID,
                                                                             PROPERTY_GROUP,
                                                                             PROPERTY,
                                                                             ATTRIBUTE,
                                                                             0,
                                                                             1 ),
                                                              F_GET_INF_REP( ASPARTNO2,
                                                                             ANREVISION2,
                                                                             SECTION_ID,
                                                                             SUB_SECTION_ID,
                                                                             PROPERTY_GROUP,
                                                                             PROPERTY,
                                                                             ATTRIBUTE,
                                                                             0,
                                                                             2 ) ),
                                                 1,
                                                 60 ) ) F_SP2
                            FROM ( SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          UOM_ID
                                    FROM SPECDATA
                                   WHERE PART_NO = ASPARTNO1
                                     AND REVISION = ANREVISION1
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND TYPE = ANTYPE
                                     AND REF_ID = ANREFID
                                  MINUS
                                  SELECT SECTION_ID,
                                         SUB_SECTION_ID,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         UOM_ID
                                    FROM SPECDATA
                                   WHERE PART_NO = ASPARTNO2
                                     AND REVISION = ANREVISION2
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND TYPE = ANTYPE
                                     AND REF_ID = ANREFID
                                  UNION
                                  ( SELECT SECTION_ID,
                                           SUB_SECTION_ID,
                                           PROPERTY_GROUP,
                                           PROPERTY,
                                           ATTRIBUTE,
                                           UOM_ID
                                     FROM SPECDATA
                                    WHERE PART_NO = ASPARTNO2
                                      AND REVISION = ANREVISION2
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND TYPE = ANTYPE
                                      AND REF_ID = ANREFID
                                   MINUS
                                   SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          UOM_ID
                                     FROM SPECDATA
                                    WHERE PART_NO = ASPARTNO1
                                      AND REVISION = ANREVISION1
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND TYPE = ANTYPE
                                      AND REF_ID = ANREFID ) )
                 UNION
                 SELECT DISTINCT SECTION_ID SC_ID,
                                 SUB_SECTION_ID SB_ID,
                                 PROPERTY_GROUP,
                                 NVL( SUBSTR( F_SPH_DESCR( 1,
                                                           PROPERTY,
                                                           0 ),
                                              1,
                                              60 ),
                                      '<no data>' ) F_SP,
                                 SUBSTR( F_ATH_DESCR( 1,
                                                      ATTRIBUTE,
                                                      0 ),
                                         1,
                                         60 ) F_AT,
                                 SUBSTR( F_TMH_DESCR( 1,
                                                      TM,
                                                      TM_REV ),
                                         1,
                                         60 ) F_HD,
                                 DECODE( F_GET_INF_REP( ASPARTNO1,
                                                        ANREVISION1,
                                                        SECTION_ID,
                                                        SUB_SECTION_ID,
                                                        PROPERTY_GROUP,
                                                        PROPERTY,
                                                        ATTRIBUTE,
                                                        TM,
                                                        5 ),
                                         -999, '@-no data found-@',
                                         SUBSTR(    F_REP_TMTYPE( F_GET_INF_REP( ASPARTNO1,
                                                                                 ANREVISION1,
                                                                                 SECTION_ID,
                                                                                 SUB_SECTION_ID,
                                                                                 PROPERTY_GROUP,
                                                                                 PROPERTY,
                                                                                 ATTRIBUTE,
                                                                                 TM,
                                                                                 5 ) )
                                                 || '  '
                                                 || F_GET_INF_REP( ASPARTNO1,
                                                                   ANREVISION1,
                                                                   SECTION_ID,
                                                                   SUB_SECTION_ID,
                                                                   PROPERTY_GROUP,
                                                                   PROPERTY,
                                                                   ATTRIBUTE,
                                                                   TM,
                                                                   6 ),
                                                 1,
                                                 120 ) ) F_SP1,
                                 DECODE( F_GET_INF_REP( ASPARTNO2,
                                                        ANREVISION2,
                                                        SECTION_ID,
                                                        SUB_SECTION_ID,
                                                        PROPERTY_GROUP,
                                                        PROPERTY,
                                                        ATTRIBUTE,
                                                        TM,
                                                        5 ),
                                         -999, '@-no data found-@',
                                         SUBSTR(    F_REP_TMTYPE( F_GET_INF_REP( ASPARTNO2,
                                                                                 ANREVISION2,
                                                                                 SECTION_ID,
                                                                                 SUB_SECTION_ID,
                                                                                 PROPERTY_GROUP,
                                                                                 PROPERTY,
                                                                                 ATTRIBUTE,
                                                                                 TM,
                                                                                 5 ) )
                                                 || '  '
                                                 || F_GET_INF_REP( ASPARTNO2,
                                                                   ANREVISION2,
                                                                   SECTION_ID,
                                                                   SUB_SECTION_ID,
                                                                   PROPERTY_GROUP,
                                                                   PROPERTY,
                                                                   ATTRIBUTE,
                                                                   TM,
                                                                   6 ),
                                                 1,
                                                 120 ) ) F_SP2
                            FROM ( SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_TYPE,
                                          TM,
                                          TM_REV,
                                          TM_SET_NO
                                    FROM SPECIFICATION_TM
                                   WHERE PART_NO = ASPARTNO1
                                     AND REVISION = ANREVISION1
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                  1, ANREFID,
                                                                  -99 )
                                  MINUS
                                  SELECT SECTION_ID,
                                         SUB_SECTION_ID,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         TM_TYPE,
                                         TM,
                                         TM_REV,
                                         TM_SET_NO
                                    FROM SPECIFICATION_TM
                                   WHERE PART_NO = ASPARTNO2
                                     AND REVISION = ANREVISION2
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                  1, ANREFID,
                                                                  -99 )
                                  UNION
                                  ( SELECT SECTION_ID,
                                           SUB_SECTION_ID,
                                           PROPERTY_GROUP,
                                           PROPERTY,
                                           ATTRIBUTE,
                                           TM_TYPE,
                                           TM,
                                           TM_REV,
                                           TM_SET_NO
                                     FROM SPECIFICATION_TM
                                    WHERE PART_NO = ASPARTNO2
                                      AND REVISION = ANREVISION2
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                   1, ANREFID,
                                                                   -99 )
                                   MINUS
                                   SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_TYPE,
                                          TM,
                                          TM_REV,
                                          TM_SET_NO
                                     FROM SPECIFICATION_TM
                                    WHERE PART_NO = ASPARTNO1
                                      AND REVISION = ANREVISION1
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                   1, ANREFID,
                                                                   -99 ) ) )
                 UNION
                 SELECT DISTINCT SECTION_ID SC_ID,
                                 SUB_SECTION_ID SB_ID,
                                 PROPERTY_GROUP,
                                 NVL( SUBSTR( F_SPH_DESCR( 1,
                                                           PROPERTY,
                                                           0 ),
                                              1,
                                              60 ),
                                      '<no data>' ) F_SP,
                                 SUBSTR( F_ATH_DESCR( 1,
                                                      ATTRIBUTE,
                                                      0 ),
                                         1,
                                         60 ) F_AT,
                                 SUBSTR( F_TMH_DESCR( 1,
                                                      TM,
                                                      TM_REV ),
                                         1,
                                         60 ) F_HD,
                                 DECODE( F_GET_INF_REP( ASPARTNO1,
                                                        ANREVISION1,
                                                        SECTION_ID,
                                                        SUB_SECTION_ID,
                                                        PROPERTY_GROUP,
                                                        PROPERTY,
                                                        ATTRIBUTE,
                                                        TM,
                                                        5 ),
                                         -999, '@-no data found-@',
                                         SUBSTR(    F_REP_TMTYPE( F_GET_INF_REP( ASPARTNO1,
                                                                                 ANREVISION1,
                                                                                 SECTION_ID,
                                                                                 SUB_SECTION_ID,
                                                                                 PROPERTY_GROUP,
                                                                                 PROPERTY,
                                                                                 ATTRIBUTE,
                                                                                 TM,
                                                                                 5 ) )
                                                 || '  '
                                                 || F_GET_INF_REP( ASPARTNO1,
                                                                   ANREVISION1,
                                                                   SECTION_ID,
                                                                   SUB_SECTION_ID,
                                                                   PROPERTY_GROUP,
                                                                   PROPERTY,
                                                                   ATTRIBUTE,
                                                                   TM,
                                                                   6 ),
                                                 1,
                                                 120 ) ) F_SP1,
                                 DECODE( F_GET_INF_REP( ASPARTNO2,
                                                        ANREVISION2,
                                                        SECTION_ID,
                                                        SUB_SECTION_ID,
                                                        PROPERTY_GROUP,
                                                        PROPERTY,
                                                        ATTRIBUTE,
                                                        TM,
                                                        5 ),
                                         -999, '@-no data found-@',
                                         SUBSTR(    F_REP_TMTYPE( F_GET_INF_REP( ASPARTNO2,
                                                                                 ANREVISION2,
                                                                                 SECTION_ID,
                                                                                 SUB_SECTION_ID,
                                                                                 PROPERTY_GROUP,
                                                                                 PROPERTY,
                                                                                 ATTRIBUTE,
                                                                                 TM,
                                                                                 5 ) )
                                                 || '  '
                                                 || F_GET_INF_REP( ASPARTNO2,
                                                                   ANREVISION2,
                                                                   SECTION_ID,
                                                                   SUB_SECTION_ID,
                                                                   PROPERTY_GROUP,
                                                                   PROPERTY,
                                                                   ATTRIBUTE,
                                                                   TM,
                                                                   6 ),
                                                 1,
                                                 120 ) ) F_SP2
                            FROM ( SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_TYPE,
                                          TM,
                                          TM_REV,
                                          TM_SET_NO
                                    FROM SPECIFICATION_TM
                                   WHERE PART_NO = ASPARTNO1
                                     AND REVISION = ANREVISION1
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = 0
                                     AND PROPERTY = DECODE( ANTYPE,
                                                            4, ANREFID,
                                                            -99 )
                                  MINUS
                                  SELECT SECTION_ID,
                                         SUB_SECTION_ID,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         TM_TYPE,
                                         TM,
                                         TM_REV,
                                         TM_SET_NO
                                    FROM SPECIFICATION_TM
                                   WHERE PART_NO = ASPARTNO2
                                     AND REVISION = ANREVISION2
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = 0
                                     AND PROPERTY = DECODE( ANTYPE,
                                                            4, ANREFID,
                                                            -99 )
                                  UNION
                                  ( SELECT SECTION_ID,
                                           SUB_SECTION_ID,
                                           PROPERTY_GROUP,
                                           PROPERTY,
                                           ATTRIBUTE,
                                           TM_TYPE,
                                           TM,
                                           TM_REV,
                                           TM_SET_NO
                                     FROM SPECIFICATION_TM
                                    WHERE PART_NO = ASPARTNO2
                                      AND REVISION = ANREVISION2
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = 0
                                      AND PROPERTY = DECODE( ANTYPE,
                                                             4, ANREFID,
                                                             -99 )
                                   MINUS
                                   SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_TYPE,
                                          TM,
                                          TM_REV,
                                          TM_SET_NO
                                     FROM SPECIFICATION_TM
                                    WHERE PART_NO = ASPARTNO1
                                      AND REVISION = ANREVISION1
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = 0
                                      AND PROPERTY = DECODE( ANTYPE,
                                                             4, ANREFID,
                                                             -99 ) ) )
                 UNION
                 SELECT DISTINCT SECTION_ID SC_ID,
                                 SUB_SECTION_ID SB_ID,
                                 PROPERTY_GROUP,
                                 NVL( SUBSTR( F_SPH_DESCR( 1,
                                                           PROPERTY,
                                                           0 ),
                                              1,
                                              60 ),
                                      '<no data>' ) F_SP,
                                 SUBSTR( F_ATH_DESCR( 1,
                                                      ATTRIBUTE,
                                                      0 ),
                                         1,
                                         60 ) F_AT,
                                    '- '
                                 || SUBSTR( F_REP_TMTYPE( 1 ),
                                            1,
                                            120 )
                                 || ' -' F_HD,
                                 DECODE( F_REP_TMTYPE( 1 ),
                                         'none', '@-no data found-@',
                                         DECODE( F_GET_INF_REP( ASPARTNO1,
                                                                ANREVISION1,
                                                                SECTION_ID,
                                                                SUB_SECTION_ID,
                                                                PROPERTY_GROUP,
                                                                PROPERTY,
                                                                ATTRIBUTE,
                                                                0,
                                                                7 ),
                                                 1, 'Y',
                                                 -999, '@-no data found-@',
                                                 'N' ) ) F_SP1,
                                 DECODE( F_REP_TMTYPE( 1 ),
                                         'none', '@-no data found-@',
                                         DECODE( F_GET_INF_REP( ASPARTNO2,
                                                                ANREVISION2,
                                                                SECTION_ID,
                                                                SUB_SECTION_ID,
                                                                PROPERTY_GROUP,
                                                                PROPERTY,
                                                                ATTRIBUTE,
                                                                0,
                                                                7 ),
                                                 1, 'Y',
                                                 -999, '@-no data found-@',
                                                 'N' ) ) F_SP2
                            FROM ( SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_DET_1
                                    FROM SPECIFICATION_PROP
                                   WHERE PART_NO = ASPARTNO1
                                     AND REVISION = ANREVISION1
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                  1, ANREFID,
                                                                  -99 )
                                  MINUS
                                  SELECT SECTION_ID,
                                         SUB_SECTION_ID,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         TM_DET_1
                                    FROM SPECIFICATION_PROP
                                   WHERE PART_NO = ASPARTNO2
                                     AND REVISION = ANREVISION2
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                  1, ANREFID,
                                                                  -99 )
                                  UNION
                                  ( SELECT SECTION_ID,
                                           SUB_SECTION_ID,
                                           PROPERTY_GROUP,
                                           PROPERTY,
                                           ATTRIBUTE,
                                           TM_DET_1
                                     FROM SPECIFICATION_PROP
                                    WHERE PART_NO = ASPARTNO2
                                      AND REVISION = ANREVISION2
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                   1, ANREFID,
                                                                   -99 )
                                   MINUS
                                   SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_DET_1
                                     FROM SPECIFICATION_PROP
                                    WHERE PART_NO = ASPARTNO1
                                      AND REVISION = ANREVISION1
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                   1, ANREFID,
                                                                   -99 ) ) )
                 UNION
                 SELECT DISTINCT SECTION_ID SC_ID,
                                 SUB_SECTION_ID SB_ID,
                                 PROPERTY_GROUP,
                                 NVL( SUBSTR( F_SPH_DESCR( 1,
                                                           PROPERTY,
                                                           0 ),
                                              1,
                                              60 ),
                                      '<no data>' ) F_SP,
                                 SUBSTR( F_ATH_DESCR( 1,
                                                      ATTRIBUTE,
                                                      0 ),
                                         1,
                                         60 ) F_AT,
                                    '- '
                                 || SUBSTR( F_REP_TMTYPE( 2 ),
                                            1,
                                            120 )
                                 || ' -' F_HD,
                                 DECODE( F_REP_TMTYPE( 2 ),
                                         'none', '@-no data found-@',
                                         DECODE( F_GET_INF_REP( ASPARTNO1,
                                                                ANREVISION1,
                                                                SECTION_ID,
                                                                SUB_SECTION_ID,
                                                                PROPERTY_GROUP,
                                                                PROPERTY,
                                                                ATTRIBUTE,
                                                                0,
                                                                8 ),
                                                 1, 'Y',
                                                 -999, '@-no data found-@',
                                                 'N' ) ) F_SP1,
                                 DECODE( F_REP_TMTYPE( 2 ),
                                         'none', '@-no data found-@',
                                         DECODE( F_GET_INF_REP( ASPARTNO2,
                                                                ANREVISION2,
                                                                SECTION_ID,
                                                                SUB_SECTION_ID,
                                                                PROPERTY_GROUP,
                                                                PROPERTY,
                                                                ATTRIBUTE,
                                                                0,
                                                                8 ),
                                                 1, 'Y',
                                                 -999, '@-no data found-@',
                                                 'N' ) ) F_SP2
                            FROM ( SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_DET_2
                                    FROM SPECIFICATION_PROP
                                   WHERE PART_NO = ASPARTNO1
                                     AND REVISION = ANREVISION1
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                  1, ANREFID,
                                                                  -99 )
                                  MINUS
                                  SELECT SECTION_ID,
                                         SUB_SECTION_ID,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         TM_DET_2
                                    FROM SPECIFICATION_PROP
                                   WHERE PART_NO = ASPARTNO2
                                     AND REVISION = ANREVISION2
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                  1, ANREFID,
                                                                  -99 )
                                  UNION
                                  ( SELECT SECTION_ID,
                                           SUB_SECTION_ID,
                                           PROPERTY_GROUP,
                                           PROPERTY,
                                           ATTRIBUTE,
                                           TM_DET_2
                                     FROM SPECIFICATION_PROP
                                    WHERE PART_NO = ASPARTNO2
                                      AND REVISION = ANREVISION2
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                   1, ANREFID,
                                                                   -99 )
                                   MINUS
                                   SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_DET_2
                                     FROM SPECIFICATION_PROP
                                    WHERE PART_NO = ASPARTNO1
                                      AND REVISION = ANREVISION1
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                   1, ANREFID,
                                                                   -99 ) ) )
                 UNION
                 SELECT DISTINCT SECTION_ID SC_ID,
                                 SUB_SECTION_ID SB_ID,
                                 PROPERTY_GROUP,
                                 NVL( SUBSTR( F_SPH_DESCR( 1,
                                                           PROPERTY,
                                                           0 ),
                                              1,
                                              60 ),
                                      '<no data>' ) F_SP,
                                 SUBSTR( F_ATH_DESCR( 1,
                                                      ATTRIBUTE,
                                                      0 ),
                                         1,
                                         60 ) F_AT,
                                    '- '
                                 || SUBSTR( F_REP_TMTYPE( 3 ),
                                            1,
                                            120 )
                                 || ' -' F_HD,
                                 DECODE( F_REP_TMTYPE( 3 ),
                                         'none', '@-no data found-@',
                                         DECODE( F_GET_INF_REP( ASPARTNO1,
                                                                ANREVISION1,
                                                                SECTION_ID,
                                                                SUB_SECTION_ID,
                                                                PROPERTY_GROUP,
                                                                PROPERTY,
                                                                ATTRIBUTE,
                                                                0,
                                                                9 ),
                                                 1, 'Y',
                                                 -999, '@-no data found-@',
                                                 'N' ) ) F_SP1,
                                 DECODE( F_REP_TMTYPE( 3 ),
                                         'none', '@-no data found-@',
                                         DECODE( F_GET_INF_REP( ASPARTNO2,
                                                                ANREVISION2,
                                                                SECTION_ID,
                                                                SUB_SECTION_ID,
                                                                PROPERTY_GROUP,
                                                                PROPERTY,
                                                                ATTRIBUTE,
                                                                0,
                                                                9 ),
                                                 1, 'Y',
                                                 -999, '@-no data found-@',
                                                 'N' ) ) F_SP2
                            FROM ( SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_DET_3
                                    FROM SPECIFICATION_PROP
                                   WHERE PART_NO = ASPARTNO1
                                     AND REVISION = ANREVISION1
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                  1, ANREFID,
                                                                  -99 )
                                  MINUS
                                  SELECT SECTION_ID,
                                         SUB_SECTION_ID,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         TM_DET_3
                                    FROM SPECIFICATION_PROP
                                   WHERE PART_NO = ASPARTNO2
                                     AND REVISION = ANREVISION2
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                  1, ANREFID,
                                                                  -99 )
                                  UNION
                                  ( SELECT SECTION_ID,
                                           SUB_SECTION_ID,
                                           PROPERTY_GROUP,
                                           PROPERTY,
                                           ATTRIBUTE,
                                           TM_DET_3
                                     FROM SPECIFICATION_PROP
                                    WHERE PART_NO = ASPARTNO2
                                      AND REVISION = ANREVISION2
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                   1, ANREFID,
                                                                   -99 )
                                   MINUS
                                   SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_DET_3
                                     FROM SPECIFICATION_PROP
                                    WHERE PART_NO = ASPARTNO1
                                      AND REVISION = ANREVISION1
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                   1, ANREFID,
                                                                   -99 ) ) )
                 UNION
                 SELECT DISTINCT SECTION_ID SC_ID,
                                 SUB_SECTION_ID SB_ID,
                                 PROPERTY_GROUP,
                                 NVL( SUBSTR( F_SPH_DESCR( 1,
                                                           PROPERTY,
                                                           0 ),
                                              1,
                                              60 ),
                                      '<no data>' ) F_SP,
                                 SUBSTR( F_ATH_DESCR( 1,
                                                      ATTRIBUTE,
                                                      0 ),
                                         1,
                                         60 ) F_AT,
                                    '- '
                                 || SUBSTR( F_REP_TMTYPE( 4 ),
                                            1,
                                            120 )
                                 || ' -' F_HD,
                                 DECODE( F_REP_TMTYPE( 4 ),
                                         'none', '@-no data found-@',
                                         DECODE( F_GET_INF_REP( ASPARTNO1,
                                                                ANREVISION1,
                                                                SECTION_ID,
                                                                SUB_SECTION_ID,
                                                                PROPERTY_GROUP,
                                                                PROPERTY,
                                                                ATTRIBUTE,
                                                                0,
                                                                10 ),
                                                 1, 'Y',
                                                 -999, '@-no data found-@',
                                                 'N' ) ) F_SP1,
                                 DECODE( F_REP_TMTYPE( 4 ),
                                         'none', '@-no data found-@',
                                         DECODE( F_GET_INF_REP( ASPARTNO2,
                                                                ANREVISION2,
                                                                SECTION_ID,
                                                                SUB_SECTION_ID,
                                                                PROPERTY_GROUP,
                                                                PROPERTY,
                                                                ATTRIBUTE,
                                                                0,
                                                                10 ),
                                                 1, 'Y',
                                                 -999, '@-no data found-@',
                                                 'N' ) ) F_SP2
                            FROM ( SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_DET_4
                                    FROM SPECIFICATION_PROP
                                   WHERE PART_NO = ASPARTNO1
                                     AND REVISION = ANREVISION1
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                  1, ANREFID,
                                                                  -99 )
                                  MINUS
                                  SELECT SECTION_ID,
                                         SUB_SECTION_ID,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         TM_DET_4
                                    FROM SPECIFICATION_PROP
                                   WHERE PART_NO = ASPARTNO2
                                     AND REVISION = ANREVISION2
                                     AND SECTION_ID = ANSECTIONID
                                     AND SUB_SECTION_ID = ANSUBSECTIONID
                                     AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                  1, ANREFID,
                                                                  -99 )
                                  UNION
                                  ( SELECT SECTION_ID,
                                           SUB_SECTION_ID,
                                           PROPERTY_GROUP,
                                           PROPERTY,
                                           ATTRIBUTE,
                                           TM_DET_4
                                     FROM SPECIFICATION_PROP
                                    WHERE PART_NO = ASPARTNO2
                                      AND REVISION = ANREVISION2
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                   1, ANREFID,
                                                                   -99 )
                                   MINUS
                                   SELECT SECTION_ID,
                                          SUB_SECTION_ID,
                                          PROPERTY_GROUP,
                                          PROPERTY,
                                          ATTRIBUTE,
                                          TM_DET_4
                                     FROM SPECIFICATION_PROP
                                    WHERE PART_NO = ASPARTNO1
                                      AND REVISION = ANREVISION1
                                      AND SECTION_ID = ANSECTIONID
                                      AND SUB_SECTION_ID = ANSUBSECTIONID
                                      AND PROPERTY_GROUP = DECODE( ANTYPE,
                                                                   1, ANREFID,
                                                                   -99 ) ) ) )
          WHERE (    F_SP1 <> '@-no data found-@'
                  OR F_SP2 <> '@-no data found-@' );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         OPEN AQPROPERTYGROUP FOR
            SELECT DISTINCT 0,
                            0,
                            0
                       FROM DUAL;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPROPERTYGROUPDETAILLANG;


   FUNCTION GETPROPERTYGROUPNOTEDETAIL(

      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANLANGID                   IN       IAPITYPE.LANGUAGEID_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPID          IN       IAPITYPE.ID_TYPE,
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE,
      AQPROPERTYGROUPNOTE        OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS









      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPropertyGroupNoteDetail';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQPROPERTYGROUPNOTE FOR
         SELECT F_PROP_LANG_ARG( PART_NO,
                                 REVISION,
                                 SECTION_ID,
                                 SUB_SECTION_ID,
                                 PROPERTY_GROUP,
                                 PROPERTY,
                                 ATTRIBUTE,
                                 7,
                                 ANLANGID ) INFO,
                SPECIFICATION_PROP.PART_NO,
                SPECIFICATION_PROP.REVISION,
                   SUBSTR( F_SPH_DESCR( 1,
                                        SPECIFICATION_PROP.PROPERTY,
                                        SPECIFICATION_PROP.PROPERTY_REV ),
                           1,
                           60 )
                || ' ['
                || SUBSTR( F_ATH_DESCR( 1,
                                        SPECIFICATION_PROP.ATTRIBUTE,
                                        SPECIFICATION_PROP.ATTRIBUTE_REV ),
                           1,
                           60 )
                || ' ]' F_TEXT_DESCR
           FROM SPECIFICATION_PROP
          WHERE ( SPECIFICATION_PROP.PART_NO = ASPARTNO )
            AND ( SPECIFICATION_PROP.REVISION = ANREVISION )
            AND ( SPECIFICATION_PROP.PROPERTY_GROUP = ANPROPERTYGROUPID )
            AND ( SPECIFICATION_PROP.SECTION_ID = ANSECTIONID )
            AND ( SPECIFICATION_PROP.SUB_SECTION_ID = ANSUBSECTIONID )
            AND ( SPECIFICATION_PROP.PROPERTY = ANPROPERTYID )
            AND ( SPECIFICATION_PROP.ATTRIBUTE = ANATTRIBUTEID )
            AND F_GET_NOTE( SPECIFICATION_PROP.PART_NO,
                            SPECIFICATION_PROP.REVISION,
                            SPECIFICATION_PROP.SECTION_ID,
                            SPECIFICATION_PROP.SUB_SECTION_ID,
                            SPECIFICATION_PROP.PROPERTY_GROUP,
                            SPECIFICATION_PROP.PROPERTY ) = 1;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         OPEN AQPROPERTYGROUPNOTE FOR
            SELECT DISTINCT 0,
                            0,
                            0
                       FROM DUAL;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPROPERTYGROUPNOTEDETAIL;


   FUNCTION GETCLASSIFICATIONDETAIL(

      ASPARTNO1                  IN       IAPITYPE.PARTNO_TYPE,
      ASPARTNO2                  IN       IAPITYPE.PARTNO_TYPE,
      AQCLASSIFICATION           OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS









      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetClassificationDetail';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQCLASSIFICATION FOR
         SELECT   2 CF_VAL_REF,
                  A.PART_NO PARTNO,
                  A.HIER_LEVEL,
                  A.MATL_CLASS_ID,
                  DECODE( TYPE,
                          'C1030', 1,
                          'C1030', 1,
                          2 ) CF_SEQ,
                  C.LONG_NAME CF_HEADER,
                  DECODE(    HIER_LEVEL
                          || TYPE,
                          '0C1030', B.DESCRIPTION,
                          '0CPGM', B.DESCRIPTION,
                          '0C2156', B.DESCRIPTION,
                          B.LONG_NAME ) DESCRIPTION,
                  A.CODE PRCLCODE,
                  A.TYPE,
                  0 CF_DIFF
             FROM ITPRCL A,
                  MATERIAL_CLASS B,
                  MATERIAL_CLASS C
            WHERE A.PART_NO = ASPARTNO2
              AND A.MATL_CLASS_ID = B.IDENTIFIER
              AND A.TYPE = C.CODE
              AND B.IDENTIFIER > 0
              AND C.IDENTIFIER > 0
         UNION
         SELECT   1 CF_VAL_REF,
                  A.PART_NO PARTNO,
                  A.HIER_LEVEL,
                  A.MATL_CLASS_ID,
                  DECODE( TYPE,
                          'C1030', 1,
                          'C1030', 1,
                          2 ) CF_SEQ,
                  C.LONG_NAME CF_HEADER,
                  DECODE(    HIER_LEVEL
                          || TYPE,
                          '0C1030', B.DESCRIPTION,
                          '0CPGM', B.DESCRIPTION,
                          '0C2156', B.DESCRIPTION,
                          B.LONG_NAME ) DESCRIPTION,
                  A.CODE PRCLCODE,
                  A.TYPE,
                  0 CF_DIFF
             FROM ITPRCL A,
                  MATERIAL_CLASS B,
                  MATERIAL_CLASS C
            WHERE A.PART_NO = ASPARTNO1
              AND A.MATL_CLASS_ID = B.IDENTIFIER
              AND A.TYPE = C.CODE
              AND B.IDENTIFIER > 0
              AND C.IDENTIFIER > 0
         ORDER BY CF_VAL_REF,
                  CF_SEQ,
                  TYPE,
                  HIER_LEVEL,
                  PRCLCODE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         OPEN AQCLASSIFICATION FOR
            SELECT DISTINCT 0,
                            0,
                            0
                       FROM DUAL;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETCLASSIFICATIONDETAIL;


   FUNCTION GETCHEMICALINGREDIENT(
      ANUNIQUEID1                IN       IAPITYPE.SEQUENCE_TYPE,
      ASPARTNO1                  IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION1                IN       IAPITYPE.REVISION_TYPE,
      ASPLANT1                   IN       IAPITYPE.PLANT_TYPE DEFAULT NULL,
      ASCHEMICALINGREDIENT1      IN       IAPITYPE.STRINGVAL_TYPE,
      ANALTERNATIVE1             IN       IAPITYPE.BOMALTERNATIVE_TYPE DEFAULT NULL,
      ANUSAGE1                   IN       IAPITYPE.BOMUSAGE_TYPE DEFAULT NULL,
      ANUNIQUEID2                IN       IAPITYPE.SEQUENCE_TYPE,
      ASPARTNO2                  IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION2                IN       IAPITYPE.REVISION_TYPE,
      ASPLANT2                   IN       IAPITYPE.PLANT_TYPE DEFAULT NULL,
      ASCHEMICALINGREDIENT2      IN       IAPITYPE.STRINGVAL_TYPE,
      ANALTERNATIVE2             IN       IAPITYPE.BOMALTERNATIVE_TYPE DEFAULT NULL,
      ANUSAGE2                   IN       IAPITYPE.BOMUSAGE_TYPE DEFAULT NULL,
      AQCHEMICALINGREDIENTS      OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetChemicalIngredient';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE := NULL;
      LNREVISION                    IAPITYPE.REVISION_TYPE := NULL;



   BEGIN

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );









      LSSQL :=
            ' SELECT   MAX( '
         || IAPICONSTANTCOLUMN.CHEMICALINGREDIENTCMPSTATUSCOL
         || ' ) '
         || IAPICONSTANTCOLUMN.CHEMICALINGREDIENTCMPSTATUSCOL
         
         
         || ', :asPartNo1 '
         
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', :anRevision1 ' 
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', :asPlant1 '  
         || IAPICONSTANTCOLUMN.PLANTCOL
         || ', :anAlternative1 ' 
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', :anUsage1 ' 
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', f_bu_descr(:anUsage1) ' 
         || IAPICONSTANTCOLUMN.BOMUSAGEDESCRIPTIONCOL
         || ','
         || IAPICONSTANTCOLUMN.INGREDIENTCOL
         || ',  MAX( '
         || IAPICONSTANTCOLUMN.UOMCMPSTATUSCOL
         || ' ) '
         || IAPICONSTANTCOLUMN.UOMCMPSTATUSCOL
         || ',  MAX( '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ' ) '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ',  MAX( '
         || IAPICONSTANTCOLUMN.INGQTYCMPSTATUSCOL
         || ' ) '
         || IAPICONSTANTCOLUMN.INGQTYCMPSTATUSCOL
         || ',  MAX( '
         || IAPICONSTANTCOLUMN.INGQTYCOL
         || ' ) '
         || IAPICONSTANTCOLUMN.INGQTYCOL
         || ',  MAX( '
         || IAPICONSTANTCOLUMN.COMPONENTCALCQTYCMPSTATUSCOL
         || ' ) '
         || IAPICONSTANTCOLUMN.COMPONENTCALCQTYCMPSTATUSCOL
         || ',  MAX( '
         || IAPICONSTANTCOLUMN.COMPONENTCALCQTYCOL
         || ' ) '
         || IAPICONSTANTCOLUMN.COMPONENTCALCQTYCOL
         || ',  MAX( '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCMPSTATUSCOL
         || ' ) '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCMPSTATUSCOL
         || ',  MAX( '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ' ) '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ',  MAX( '
         || IAPICONSTANTCOLUMN.ACTIVECMPSTATUSCOL
         || ' ) '
         || IAPICONSTANTCOLUMN.ACTIVECMPSTATUSCOL
         || ',  MAX( '
         || IAPICONSTANTCOLUMN.ACTIVECOL
         || ' ) '
         || IAPICONSTANTCOLUMN.ACTIVECOL
         || '     FROM ( SELECT iapiCompare.GetCompareCIListStatus( 1,   '
         || '                                                       a.ingredient,  '
         || '                                                       b.bom_exp_no,  '
         || '                                                       :asChemicalIngredient2,  '
         || '                                                       a.bom_exp_no,  '
         || '                                                       :asChemicalIngredient1 ) '
         || IAPICONSTANTCOLUMN.CHEMICALINGREDIENTCMPSTATUSCOL
         || ' ,                 :asPartNo1   '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ' ,                 :anRevision1   '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ' ,                 :asPlant1   '
         || IAPICONSTANTCOLUMN.PLANTCOL
         || ' ,                 :anAlternative1   '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ' ,                 :anUsage1   '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', f_bu_descr(:anUsage1) '
         || IAPICONSTANTCOLUMN.BOMUSAGEDESCRIPTIONCOL
         || ',                  CASE  '
         || '                      WHEN a.ingredient < 0  '
         || '                         THEN    :asPartNo1  '
         || '                              || TO_CHAR( a.ingredient ) '
         || '                         ELSE TO_CHAR( a.ingredient ) '
         || '                      END '

         || IAPICONSTANTCOLUMN.INGREDIENTCOL
         || ' ,                  DECODE( c.base_uom, d.base_uom, 0, 1 )  '
         || IAPICONSTANTCOLUMN.UOMCMPSTATUSCOL
         || ' ,                  c.base_uom  '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ' ,                  DECODE( iapiCompare.GetCIPerc(a.ingredient, a.Bom_Exp_No),  '
         || '                            iapiCompare.GetCIPerc(b.ingredient, b.Bom_Exp_No), 0, 1 )   '
         || IAPICONSTANTCOLUMN.INGQTYCMPSTATUSCOL
         || ' ,                  iapiCompare.GetCIPerc(a.ingredient, a.Bom_Exp_No)  '
         || IAPICONSTANTCOLUMN.INGQTYCOL
         || ' ,                  DECODE( iapiCompare.GetCISum(a.ingredient, a.Bom_Exp_No),  '
         || '                            iapiCompare.GetCISum(b.ingredient, b.Bom_Exp_No), 0, 1 )   '
         || IAPICONSTANTCOLUMN.COMPONENTCALCQTYCMPSTATUSCOL
         || ' ,                  iapiCompare.GetCISum(a.ingredient, a.Bom_Exp_No)   '
         || IAPICONSTANTCOLUMN.COMPONENTCALCQTYCOL
         || ' ,                  DECODE( a.description, b.description, 0, 1 )  '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCMPSTATUSCOL
         || ' ,                  a.description   '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ' ,                  DECODE( a.active, b.active, 0, 1 )  '
         || IAPICONSTANTCOLUMN.ACTIVECMPSTATUSCOL
         || ' ,                  a.active  '
         || IAPICONSTANTCOLUMN.ACTIVECOL
         || '             FROM itingexplosion a,   '
         || '                  itingexplosion b,   '
         || '                  part c,     '
         || '                  part d      '
         || '            WHERE a.bom_exp_no = :anUniqueId1   '
         || '              AND b.bom_exp_no = :anUniqueId2   '
         || '              AND a.ingredient = b.ingredient   '
         || '              AND a.component_part_no = c.part_no   '
         || '              AND b.component_part_no = d.part_no )   '
         || ' GROUP BY '
         || IAPICONSTANTCOLUMN.INGREDIENTCOL;

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      IF ( AQCHEMICALINGREDIENTS%ISOPEN )
      THEN
         CLOSE AQCHEMICALINGREDIENTS;
      END IF;




      OPEN AQCHEMICALINGREDIENTS FOR LSSQL
      USING



            
            ASPARTNO1,
            ANREVISION1,
            ASPLANT1,
            ANALTERNATIVE1,
            ANUSAGE1,
            ANUSAGE1,
            
            ASCHEMICALINGREDIENT2,
            ASCHEMICALINGREDIENT1,
            ASPARTNO1,
            ANREVISION1,
            ASPLANT1,
            ANALTERNATIVE1,
            ANUSAGE1,
            ANUSAGE1,
            ASPARTNO1,
            ANUNIQUEID1,
            ANUNIQUEID2;

      LNRETVAL := IAPISPECIFICATIONACCESS.GETVIEWACCESS( ASPARTNO1,
                                                         ANREVISION1,
                                                         LNACCESS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF LNACCESS = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOVIEWACCESS,
                                                    ASPARTNO1,
                                                    ANREVISION1 );
      END IF;

      LNRETVAL := IAPISPECIFICATIONACCESS.GETVIEWACCESS( ASPARTNO2,
                                                         ANREVISION2,
                                                         LNACCESS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF LNACCESS = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOVIEWACCESS,
                                                    ASPARTNO2,
                                                    ANREVISION2 );
      END IF;










      LSSQL :=
            LSSQL
         || ' UNION ALL '
         || ' SELECT   MAX( '
         || IAPICONSTANTCOLUMN.CHEMICALINGREDIENTCMPSTATUSCOL
         || ' ) '
         || IAPICONSTANTCOLUMN.CHEMICALINGREDIENTCMPSTATUSCOL
         
         
         || ', :asPartNo2 '
         
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', :anRevision2 ' 
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', :asPlant2 ' 
         || IAPICONSTANTCOLUMN.PLANTCOL
         || ', :anAlternative2 ' 
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', :anUsage2 ' 
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', f_bu_descr(:anUsage2) ' 
         || IAPICONSTANTCOLUMN.BOMUSAGEDESCRIPTIONCOL
         || ','
         || IAPICONSTANTCOLUMN.INGREDIENTCOL
         || ',  MAX( '
         || IAPICONSTANTCOLUMN.UOMCMPSTATUSCOL
         || ' ) '
         || IAPICONSTANTCOLUMN.UOMCMPSTATUSCOL
         || ',  MAX( '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ' ) '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ',  MAX( '
         || IAPICONSTANTCOLUMN.INGQTYCMPSTATUSCOL
         || ' ) '
         || IAPICONSTANTCOLUMN.INGQTYCMPSTATUSCOL
         || ',  MAX( '
         || IAPICONSTANTCOLUMN.INGQTYCOL
         || ' ) '
         || IAPICONSTANTCOLUMN.INGQTYCOL
         || ',  MAX( '
         || IAPICONSTANTCOLUMN.COMPONENTCALCQTYCMPSTATUSCOL
         || ' ) '
         || IAPICONSTANTCOLUMN.COMPONENTCALCQTYCMPSTATUSCOL
         || ',  MAX( '
         || IAPICONSTANTCOLUMN.COMPONENTCALCQTYCOL
         || ' ) '
         || IAPICONSTANTCOLUMN.COMPONENTCALCQTYCOL
         || ',  MAX( '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCMPSTATUSCOL
         || ' ) '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCMPSTATUSCOL
         || ',  MAX( '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ' ) '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ',  MAX( '
         || IAPICONSTANTCOLUMN.ACTIVECMPSTATUSCOL
         || ' ) '
         || IAPICONSTANTCOLUMN.ACTIVECMPSTATUSCOL
         || ',  MAX( '
         || IAPICONSTANTCOLUMN.ACTIVECOL
         || ' ) '
         || IAPICONSTANTCOLUMN.ACTIVECOL
         || '     FROM ( SELECT iapiCompare.GetCompareCIListStatus( 2,   '
         || '                                                       a.ingredient,  '
         || '                                                       b.bom_exp_no,  '
         || '                                                       :asChemicalIngredient1,  '
         || '                                                       a.bom_exp_no,  '
         || '                                                       :asChemicalIngredient2 ) '
         || IAPICONSTANTCOLUMN.CHEMICALINGREDIENTCMPSTATUSCOL
         || ' ,                 :asPartNo2  '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ' ,                 :anRevision2  '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ' ,                 :asPlant2   '
         || IAPICONSTANTCOLUMN.PLANTCOL
         || ' ,                 :anAlternative2  '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ' ,                 :anUsage2   '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', f_bu_descr(:anUsage2) '
         || IAPICONSTANTCOLUMN.BOMUSAGEDESCRIPTIONCOL
         || ',                  CASE  '
         || '                      WHEN a.ingredient < 0  '
         || '                         THEN    :asPartNo2  '
         || '                              || TO_CHAR( a.ingredient ) '
         || '                         ELSE TO_CHAR( a.ingredient ) '
         || '                      END '

         || IAPICONSTANTCOLUMN.INGREDIENTCOL
         || ' ,                  DECODE( c.base_uom, d.base_uom, 0, 1 )  '
         || IAPICONSTANTCOLUMN.UOMCMPSTATUSCOL
         || ' ,                  c.base_uom   '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ' ,                  DECODE( iapiCompare.GetCIPerc(a.ingredient, a.Bom_Exp_No),  '
         || '                            iapiCompare.GetCIPerc(b.ingredient, b.Bom_Exp_No), 0, 1 )   '
         || IAPICONSTANTCOLUMN.INGQTYCMPSTATUSCOL
         || ' ,                  iapiCompare.GetCIPerc(a.ingredient, a.Bom_Exp_No)   '
         || IAPICONSTANTCOLUMN.INGQTYCOL
         || ' ,                  DECODE( iapiCompare.GetCISum(a.ingredient, a.Bom_Exp_No),  '
         || '                            iapiCompare.GetCISum(b.ingredient, b.Bom_Exp_No), 0, 1 )   '
         || IAPICONSTANTCOLUMN.COMPONENTCALCQTYCMPSTATUSCOL
         || ' ,                  iapiCompare.GetCISum(a.ingredient, a.Bom_Exp_No)  '
         || IAPICONSTANTCOLUMN.COMPONENTCALCQTYCOL
         || ' ,                  DECODE( a.description, b.description, 0, 1 )  '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCMPSTATUSCOL
         || ' ,                  a.description   '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ' ,                  DECODE( a.active, b.active, 0, 1 )  '
         || IAPICONSTANTCOLUMN.ACTIVECMPSTATUSCOL
         || ' ,                  a.active  '
         || IAPICONSTANTCOLUMN.ACTIVECOL
         || '             FROM itingexplosion a,  '
         || '                  itingexplosion b,   '
         || '                  part c,  '
         || '                  part d  '
         || '            WHERE a.bom_exp_no = :anUniqueId2   '
         || '              AND b.bom_exp_no = :anUniqueId1   '
         || '              AND a.ingredient = b.ingredient   '
         || '              AND a.component_part_no = c.part_no   '
         || '              AND b.component_part_no = d.part_no )   '
         || ' GROUP BY '
         || IAPICONSTANTCOLUMN.INGREDIENTCOL;

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );



      LSSQL :=
            LSSQL
         || ' UNION ALL                    '
         || ' SELECT  DISTINCT 1  '
         || IAPICONSTANTCOLUMN.CHEMICALINGREDIENTCMPSTATUSCOL
         || ' ,                 :asPartNo1 '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ' ,                 :anRevision1  '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ' ,                 :asPlant1  '
         || IAPICONSTANTCOLUMN.PLANTCOL
         || ' ,                 :anAlternative1 '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ' ,                 :anUsage1  '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', f_bu_descr(:anUsage1) '
         || IAPICONSTANTCOLUMN.BOMUSAGEDESCRIPTIONCOL
         || ',                  CASE  '
         || '                      WHEN a.ingredient < 0  '
         || '                         THEN    :asPartNo1  '
         || '                              || TO_CHAR( a.ingredient ) '
         || '                         ELSE TO_CHAR( a.ingredient ) '
         || '                      END '

         || IAPICONSTANTCOLUMN.INGREDIENTCOL
         || ' ,                  0  '
         || IAPICONSTANTCOLUMN.UOMCMPSTATUSCOL
         || ' ,                  c.base_uom  '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ' ,                  0  '
         || IAPICONSTANTCOLUMN.INGQTYCMPSTATUSCOL
         || ' ,                  iapiCompare.GetCIPerc(a.ingredient, a.Bom_Exp_No)   '
         || IAPICONSTANTCOLUMN.INGQTYCOL
         || ' ,                  0  '
         || IAPICONSTANTCOLUMN.COMPONENTCALCQTYCMPSTATUSCOL
         || ' ,                  iapiCompare.GetCISum(a.ingredient, a.Bom_Exp_No)  '
         || IAPICONSTANTCOLUMN.COMPONENTCALCQTYCOL
         || ' ,                  0  '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCMPSTATUSCOL
         || ' ,                  a.description   '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ' ,                  0  '
         || IAPICONSTANTCOLUMN.ACTIVECMPSTATUSCOL
         || ' ,                  a.active  '
         || IAPICONSTANTCOLUMN.ACTIVECOL
         || '     FROM itingexplosion a,   '
         || '          part c   '
         || '    WHERE a.bom_exp_no = :anUniqueId1 '
         || '      AND a.component_part_no = c.part_no  '
         || '      AND NOT EXISTS(   '
         || '             SELECT component_part_no  '
         || '               FROM itingexplosion  '
         || '              WHERE bom_exp_no = :anUniqueId2  '
         || '                AND ingredient = a.ingredient )   ';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );



      LSSQL :=
            LSSQL
         || ' UNION ALL                    '
         || ' SELECT   DISTINCT 2                   '
         || IAPICONSTANTCOLUMN.CHEMICALINGREDIENTCMPSTATUSCOL
         || ' ,                 :asPartNo2   '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ' ,                 :anRevision2  '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ' ,                 :asPlant2  '
         || IAPICONSTANTCOLUMN.PLANTCOL
         || ' ,                 :anAlternative2 '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ' ,                 :anUsage2  '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', f_bu_descr(:anUsage2) '
         || IAPICONSTANTCOLUMN.BOMUSAGEDESCRIPTIONCOL
         || ',                  CASE  '
         || '                      WHEN a.ingredient < 0  '
         || '                         THEN    :asPartNo2  '
         || '                              || TO_CHAR( a.ingredient ) '
         || '                         ELSE TO_CHAR( a.ingredient ) '
         || '                      END '

         || IAPICONSTANTCOLUMN.INGREDIENTCOL
         || ' ,                  0  '
         || IAPICONSTANTCOLUMN.UOMCMPSTATUSCOL
         || ' ,                  c.base_uom  '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ' ,                  0  '
         || IAPICONSTANTCOLUMN.INGQTYCMPSTATUSCOL
         || ' ,                  iapiCompare.GetCIPerc(a.ingredient, a.Bom_Exp_No)  '
         || IAPICONSTANTCOLUMN.INGQTYCOL
         || ' ,                  0  '
         || IAPICONSTANTCOLUMN.COMPONENTCALCQTYCMPSTATUSCOL
         || ' ,                  iapiCompare.GetCISum(a.ingredient, a.Bom_Exp_No)   '
         || IAPICONSTANTCOLUMN.COMPONENTCALCQTYCOL
         || ' ,                  0  '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCMPSTATUSCOL
         || ' ,                  a.description  '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ' ,                  0  '
         || IAPICONSTANTCOLUMN.ACTIVECMPSTATUSCOL
         || ' ,                  a.active  '
         || IAPICONSTANTCOLUMN.ACTIVECOL
         || '     FROM itingexplosion a,  '
         || '          part c  '
         || '    WHERE a.bom_exp_no = :anUniqueId2  '
         || '      AND a.component_part_no = c.part_no   '
         || '      AND NOT EXISTS(  '
         || '             SELECT component_part_no   '
         || '               FROM itingexplosion   '
         || '              WHERE bom_exp_no = :anUniqueId1   '
         || '                AND ingredient = a.Ingredient )   ';
      LSSQL :=    LSSQL
               || ' ORDER BY  '
               || IAPICONSTANTCOLUMN.INGREDIENTCOL;

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      OPEN AQCHEMICALINGREDIENTS FOR LSSQL
      USING



            
            ASPARTNO1,
            ANREVISION1,
            ASPLANT1,
            ANALTERNATIVE1,
            ANUSAGE1,
            ANUSAGE1,
            
            ASCHEMICALINGREDIENT2,
            ASCHEMICALINGREDIENT1,
            ASPARTNO1,
            ANREVISION1,
            ASPLANT1,
            ANALTERNATIVE1,
            ANUSAGE1,
            ANUSAGE1,
            ASPARTNO1,
            ANUNIQUEID1,
            ANUNIQUEID2,



            
            ASPARTNO2,
            ANREVISION2,
            ASPLANT2,
            ANALTERNATIVE2,
            ANUSAGE2,
            ANUSAGE2,
            
            ASCHEMICALINGREDIENT1,
            ASCHEMICALINGREDIENT2,
            ASPARTNO2,
            ANREVISION2,
            ASPLANT2,
            ANALTERNATIVE2,
            ANUSAGE2,
            ANUSAGE2,
            ASPARTNO2,
            ANUNIQUEID2,
            ANUNIQUEID1,



            ASPARTNO1,
            ANREVISION1,
            ASPLANT1,
            ANALTERNATIVE1,
            ANUSAGE1,
            ANUSAGE1,
            ASPARTNO1,
            ANUNIQUEID1,
            ANUNIQUEID2,



            ASPARTNO2,
            ANREVISION2,
            ASPLANT2,
            ANALTERNATIVE2,
            ANUSAGE2,
            ANUSAGE2,
            ASPARTNO2,
            ANUNIQUEID2,
            ANUNIQUEID1;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETCHEMICALINGREDIENT;


   FUNCTION CHEMICALINGREDIENT(
      ASPARTNO1                  IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION1                IN       IAPITYPE.REVISION_TYPE,
      ASPLANT1                   IN       IAPITYPE.PLANT_TYPE,
      ASCHEMICALINGREDIENT1      IN       IAPITYPE.STRINGVAL_TYPE,
      ANALTERNATIVE1             IN       IAPITYPE.BOMALTERNATIVE_TYPE DEFAULT 1,
      ANUSAGE1                   IN       IAPITYPE.BOMUSAGE_TYPE DEFAULT 1,
      ADEXPLOSIONDATE1           IN       IAPITYPE.DATE_TYPE DEFAULT SYSDATE,
      ANINCLUDEINDEVELOPMENT1    IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANUSEBOMPATH1              IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ASPARTNO2                  IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION2                IN       IAPITYPE.REVISION_TYPE,
      ASPLANT2                   IN       IAPITYPE.PLANT_TYPE,
      ASCHEMICALINGREDIENT2      IN       IAPITYPE.STRINGVAL_TYPE,
      ANALTERNATIVE2             IN       IAPITYPE.BOMALTERNATIVE_TYPE DEFAULT 1,
      ANUSAGE2                   IN       IAPITYPE.BOMUSAGE_TYPE DEFAULT 1,
      ADEXPLOSIONDATE2           IN       IAPITYPE.DATE_TYPE DEFAULT SYSDATE,
      ANINCLUDEINDEVELOPMENT2    IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANUSEBOMPATH2              IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      AQCHEMICALINGREDIENTS      OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ChemicalIngredient';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNUNIQUEID                    IAPITYPE.SEQUENCE_TYPE;
      LNUNIQUEID1                   IAPITYPE.SEQUENCE_TYPE;
      LNUNIQUEID2                   IAPITYPE.SEQUENCE_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LQERRORS                      IAPITYPE.REF_TYPE;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LSPLANT                       IAPITYPE.PLANT_TYPE;
      LNALTERNATIVE                 IAPITYPE.BOMALTERNATIVE_TYPE;
      LNUSAGE                       IAPITYPE.BOMUSAGE_TYPE;
      LDEXPLOSIONDATE               IAPITYPE.DATE_TYPE;
      LNINCLUDEINDEVELOPMENT        IAPITYPE.BOOLEAN_TYPE;
      LNBASEQUANTITY                IAPITYPE.BOMQUANTITY_TYPE;
      LNUSEBOMPATH                  IAPITYPE.BOOLEAN_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;



   BEGIN

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( AQCHEMICALINGREDIENTS%ISOPEN )
      THEN
         CLOSE AQCHEMICALINGREDIENTS;
      END IF;

      LSSQL :=
            '  SELECT 0 '
         || IAPICONSTANTCOLUMN.CHEMICALINGREDIENTCMPSTATUSCOL
         || ' ,                 :asPartNo1   '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ' ,                 :anRevision1   '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ' ,                 :asPlant1   '
         || IAPICONSTANTCOLUMN.PLANTCOL
         || ' ,                 :anAlternative1   '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ' ,                 :anUsage1   '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', f_bu_descr(:anUsage1) '
         || IAPICONSTANTCOLUMN.BOMUSAGEDESCRIPTIONCOL
         || ',                  0  '
         || IAPICONSTANTCOLUMN.INGREDIENTCOL
         || ' ,                  0   '
         || IAPICONSTANTCOLUMN.UOMCMPSTATUSCOL
         || ' ,                  c.base_uom  '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ' ,                  0   '
         || IAPICONSTANTCOLUMN.INGQTYCMPSTATUSCOL
         || ' ,                  0   '
         || IAPICONSTANTCOLUMN.INGQTYCOL
         || ' ,                  0   '
         || IAPICONSTANTCOLUMN.COMPONENTCALCQTYCMPSTATUSCOL
         || ' ,                  0   '
         || IAPICONSTANTCOLUMN.COMPONENTCALCQTYCOL
         || ' ,                  0   '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCMPSTATUSCOL
         || ' ,                  a.description   '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ' ,                  0   '
         || IAPICONSTANTCOLUMN.ACTIVECMPSTATUSCOL
         || ' ,                  a.active  '
         || IAPICONSTANTCOLUMN.ACTIVECOL
         || '             FROM itingexplosion a,   '
         || '                  itingexplosion b,   '
         || '                  part c,     '
         || '                  part d      '
         || '            WHERE a.bom_exp_no = NULL   '
         || '              AND b.bom_exp_no = NULL   '
         || '              AND a.ingredient = b.ingredient   '
         || '              AND a.component_part_no = c.part_no   '
         || '              AND b.component_part_no = d.part_no   ';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      OPEN AQCHEMICALINGREDIENTS FOR LSSQL USING '',
      0,
      '',
      0,
      0,
      0;


      LNRETVAL := IAPISEQUENCE.GETNEXTVALUE( '0',
                                             'ingredient',
                                             LNUNIQUEID1 );

      LNRETVAL := IAPISEQUENCE.GETNEXTVALUE( '0',
                                             'ingredient',
                                             LNUNIQUEID2 );

      LNUNIQUEID := LNUNIQUEID1;
      LSPARTNO := ASPARTNO1;
      LNREVISION := ANREVISION1;
      LSPLANT := ASPLANT1;
      LNALTERNATIVE := ANALTERNATIVE1;
      LNUSAGE := ANUSAGE1;
      LDEXPLOSIONDATE := ADEXPLOSIONDATE1;
      LNINCLUDEINDEVELOPMENT := ANINCLUDEINDEVELOPMENT1;
      LNUSEBOMPATH := ANUSEBOMPATH1;

      FOR LNINDEX IN 1 .. 2
      LOOP
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM BOM_HEADER
          WHERE PART_NO = LSPARTNO
            AND REVISION = LNREVISION
            AND PLANT = LSPLANT
            AND ALTERNATIVE = LNALTERNATIVE
            AND BOM_USAGE = LNUSAGE;

         IF LNCOUNT > 0
         THEN
            SELECT BASE_QUANTITY
              INTO LNBASEQUANTITY
              FROM BOM_HEADER
             WHERE PART_NO = LSPARTNO
               AND REVISION = LNREVISION
               AND PLANT = LSPLANT
               AND ALTERNATIVE = LNALTERNATIVE
               AND BOM_USAGE = LNUSAGE;
         ELSE
            LNBASEQUANTITY := 100;
         END IF;

         LNRETVAL :=
            IAPISPECIFICATIONBOM.EXPLODE( LNUNIQUEID,
                                          LSPARTNO,
                                          LNREVISION,
                                          LSPLANT,
                                          LNALTERNATIVE,
                                          LNUSAGE,
                                          1,
                                          LDEXPLOSIONDATE,
                                          LNBASEQUANTITY,
                                          LNINCLUDEINDEVELOPMENT,
                                          0,
                                          LNUSEBOMPATH,
                                          IAPICONSTANT.EXPLOSION_INGREDIENT,
                                          NULL,
                                          NULL,
                                          NULL,
                                          NULL,
                                          LQERRORS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         SELECT COUNT( * )
           INTO LNCOUNT
           FROM ITBOMEXPLOSION
          WHERE BOM_EXP_NO = LNUNIQUEID
            AND COMPONENT_REVISION IS NULL;

         
         
         IF LNCOUNT > 0
         THEN
            SELECT COMPONENT_PART,
                   COMPONENT_REVISION
              INTO LSPARTNO,
                   LNREVISION
              FROM ITBOMEXPLOSION
             WHERE BOM_EXP_NO = LNUNIQUEID
               AND BOM_LEVEL = 0;

            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_EXPLOSIONINCOMPLETE,
                                                       LSPARTNO,
                                                       LNREVISION );
         END IF;

         IF LNINDEX = 1
         THEN
            LNUNIQUEID := LNUNIQUEID2;
            LSPARTNO := ASPARTNO2;
            LNREVISION := ANREVISION2;
            LSPLANT := ASPLANT2;
            LNALTERNATIVE := ANALTERNATIVE2;
            LNUSAGE := ANUSAGE2;
            LDEXPLOSIONDATE := ADEXPLOSIONDATE2;
            LNINCLUDEINDEVELOPMENT := ANINCLUDEINDEVELOPMENT2;
            LNUSEBOMPATH := ANUSEBOMPATH2;
         END IF;
      END LOOP;

      LNRETVAL :=
         GETCHEMICALINGREDIENT( LNUNIQUEID1,
                                ASPARTNO1,
                                ANREVISION1,
                                ASPLANT1,
                                ASCHEMICALINGREDIENT1,
                                ANALTERNATIVE1,
                                ANUSAGE1,
                                LNUNIQUEID2,
                                ASPARTNO2,
                                ANREVISION2,
                                ASPLANT2,
                                ASCHEMICALINGREDIENT2,
                                ANALTERNATIVE2,
                                ANUSAGE2,
                                AQCHEMICALINGREDIENTS );

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
   END CHEMICALINGREDIENT;


   FUNCTION CHEMICALINGREDIENT(
      ANUNIQUEID1                IN       IAPITYPE.SEQUENCE_TYPE,
      ASPARTNO1                  IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION1                IN       IAPITYPE.REVISION_TYPE,
      ASPLANT1                   IN       IAPITYPE.PLANT_TYPE,
      ASCHEMICALINGREDIENT1      IN       IAPITYPE.STRINGVAL_TYPE,
      ANALTERNATIVE1             IN       IAPITYPE.BOMALTERNATIVE_TYPE DEFAULT 1,
      ANUSAGE1                   IN       IAPITYPE.BOMUSAGE_TYPE DEFAULT 1,
      ADEXPLOSIONDATE1           IN       IAPITYPE.DATE_TYPE DEFAULT SYSDATE,
      ANINCLUDEINDEVELOPMENT1    IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANUSEBOMPATH1              IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANUNIQUEID2                IN       IAPITYPE.SEQUENCE_TYPE,
      ASPARTNO2                  IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION2                IN       IAPITYPE.REVISION_TYPE,
      ASPLANT2                   IN       IAPITYPE.PLANT_TYPE,
      ASCHEMICALINGREDIENT2      IN       IAPITYPE.STRINGVAL_TYPE,
      ANALTERNATIVE2             IN       IAPITYPE.BOMALTERNATIVE_TYPE DEFAULT 1,
      ANUSAGE2                   IN       IAPITYPE.BOMUSAGE_TYPE DEFAULT 1,
      ADEXPLOSIONDATE2           IN       IAPITYPE.DATE_TYPE DEFAULT SYSDATE,
      ANINCLUDEINDEVELOPMENT2    IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANUSEBOMPATH2              IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      AQCHEMICALINGREDIENTS      OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ChemicalIngredient';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNUNIQUEID                    IAPITYPE.SEQUENCE_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LQERRORS                      IAPITYPE.REF_TYPE;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LSPLANT                       IAPITYPE.PLANT_TYPE;
      LNALTERNATIVE                 IAPITYPE.BOMALTERNATIVE_TYPE;
      LNUSAGE                       IAPITYPE.BOMUSAGE_TYPE;
      LDEXPLOSIONDATE               IAPITYPE.DATE_TYPE;
      LNINCLUDEINDEVELOPMENT        IAPITYPE.BOOLEAN_TYPE;
      LNBASEQUANTITY                IAPITYPE.BOMQUANTITY_TYPE;
      LNUSEBOMPATH                  IAPITYPE.BOOLEAN_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;



   BEGIN

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( AQCHEMICALINGREDIENTS%ISOPEN )
      THEN
         CLOSE AQCHEMICALINGREDIENTS;
      END IF;

      LSSQL :=
            '  SELECT 0 '
         || IAPICONSTANTCOLUMN.CHEMICALINGREDIENTCMPSTATUSCOL
         || ' ,                 :asPartNo1   '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ' ,                 :anRevision1   '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ' ,                 :asPlant1   '
         || IAPICONSTANTCOLUMN.PLANTCOL
         || ' ,                 :anAlternative1   '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ' ,                 :anUsage1   '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', f_bu_descr(:anUsage1) '
         || IAPICONSTANTCOLUMN.BOMUSAGEDESCRIPTIONCOL
         || ',                  0  '
         || IAPICONSTANTCOLUMN.INGREDIENTCOL
         || ' ,                  0   '
         || IAPICONSTANTCOLUMN.UOMCMPSTATUSCOL
         || ' ,                  c.base_uom  '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ' ,                  0   '
         || IAPICONSTANTCOLUMN.INGQTYCMPSTATUSCOL
         || ' ,                  0   '
         || IAPICONSTANTCOLUMN.INGQTYCOL
         || ' ,                  0   '
         || IAPICONSTANTCOLUMN.COMPONENTCALCQTYCMPSTATUSCOL
         || ' ,                  0   '
         || IAPICONSTANTCOLUMN.COMPONENTCALCQTYCOL
         || ' ,                  0   '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCMPSTATUSCOL
         || ' ,                  a.description   '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ' ,                  0   '
         || IAPICONSTANTCOLUMN.ACTIVECMPSTATUSCOL
         || ' ,                  a.active  '
         || IAPICONSTANTCOLUMN.ACTIVECOL
         || '             FROM itingexplosion a,   '
         || '                  itingexplosion b,   '
         || '                  part c,     '
         || '                  part d      '
         || '            WHERE a.bom_exp_no = NULL   '
         || '              AND b.bom_exp_no = NULL   '
         || '              AND a.ingredient = b.ingredient   '
         || '              AND a.component_part_no = c.part_no   '
         || '              AND b.component_part_no = d.part_no   ';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      OPEN AQCHEMICALINGREDIENTS FOR LSSQL USING '',
      0,
      '',
      0,
      0,
      0;


      LNUNIQUEID := ANUNIQUEID1;
      LSPARTNO := ASPARTNO1;
      LNREVISION := ANREVISION1;
      LSPLANT := ASPLANT1;
      LNALTERNATIVE := ANALTERNATIVE1;
      LNUSAGE := ANUSAGE1;
      LDEXPLOSIONDATE := ADEXPLOSIONDATE1;
      LNINCLUDEINDEVELOPMENT := ANINCLUDEINDEVELOPMENT1;
      LNUSEBOMPATH := ANUSEBOMPATH1;

      FOR LNINDEX IN 1 .. 2
      LOOP
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM BOM_HEADER
          WHERE PART_NO = LSPARTNO
            AND REVISION = LNREVISION
            AND PLANT = LSPLANT
            AND ALTERNATIVE = LNALTERNATIVE
            AND BOM_USAGE = LNUSAGE;

         IF LNCOUNT > 0
         THEN
            SELECT BASE_QUANTITY
              INTO LNBASEQUANTITY
              FROM BOM_HEADER
             WHERE PART_NO = LSPARTNO
               AND REVISION = LNREVISION
               AND PLANT = LSPLANT
               AND ALTERNATIVE = LNALTERNATIVE
               AND BOM_USAGE = LNUSAGE;
         ELSE
            LNBASEQUANTITY := 100;
         END IF;

         LNRETVAL :=
            IAPISPECIFICATIONBOM.EXPLODE( LNUNIQUEID,
                                          LSPARTNO,
                                          LNREVISION,
                                          LSPLANT,
                                          LNALTERNATIVE,
                                          LNUSAGE,
                                          1,
                                          LDEXPLOSIONDATE,
                                          LNBASEQUANTITY,
                                          LNINCLUDEINDEVELOPMENT,
                                          0,
                                          LNUSEBOMPATH,
                                          IAPICONSTANT.EXPLOSION_INGREDIENT,
                                          NULL,
                                          NULL,
                                          NULL,
                                          NULL,
                                          LQERRORS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         SELECT COUNT( * )
           INTO LNCOUNT
           FROM ITBOMEXPLOSION
          WHERE BOM_EXP_NO = LNUNIQUEID
            AND COMPONENT_REVISION IS NULL;

         
         
         IF LNCOUNT > 0
         THEN
            SELECT COMPONENT_PART,
                   COMPONENT_REVISION
              INTO LSPARTNO,
                   LNREVISION
              FROM ITBOMEXPLOSION
             WHERE BOM_EXP_NO = LNUNIQUEID
               AND BOM_LEVEL = 0;

            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_EXPLOSIONINCOMPLETE,
                                                       LSPARTNO,
                                                       LNREVISION );
         END IF;

         IF LNINDEX = 1
         THEN
            LNUNIQUEID := ANUNIQUEID2;
            LSPARTNO := ASPARTNO2;
            LNREVISION := ANREVISION2;
            LSPLANT := ASPLANT2;
            LNALTERNATIVE := ANALTERNATIVE2;
            LNUSAGE := ANUSAGE2;
            LDEXPLOSIONDATE := ADEXPLOSIONDATE2;
            LNINCLUDEINDEVELOPMENT := ANINCLUDEINDEVELOPMENT2;
            LNUSEBOMPATH := ANUSEBOMPATH2;
         END IF;
      END LOOP;

      LNRETVAL :=
         GETCHEMICALINGREDIENT( ANUNIQUEID1,
                                ASPARTNO1,
                                ANREVISION1,
                                ASPLANT1,
                                ASCHEMICALINGREDIENT1,
                                ANALTERNATIVE1,
                                ANUSAGE1,
                                ANUNIQUEID2,
                                ASPARTNO2,
                                ANREVISION2,
                                ASPLANT2,
                                ASCHEMICALINGREDIENT2,
                                ANALTERNATIVE2,
                                ANUSAGE2,
                                AQCHEMICALINGREDIENTS );

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
   END CHEMICALINGREDIENT;
END IAPICOMPARE;
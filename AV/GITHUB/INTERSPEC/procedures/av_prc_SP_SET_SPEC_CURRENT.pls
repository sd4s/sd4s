CREATE OR REPLACE PROCEDURE SP_SET_SPEC_CURRENT(
   ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
   ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
IS















   LSSOURCE                      IAPITYPE.SOURCE_TYPE := 'SP_SET_SPEC_CURRENT';
   LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   
   LNCLASSID                      IAPITYPE.CLASSIFICATIONCODE_TYPE;
   LNCOUNT                        IAPITYPE.ERRORNUM_TYPE;
BEGIN



   IAPIGENERAL.LOGINFO( LSSOURCE,
                        '',
                        'Body of FUNCTION',
                        IAPICONSTANT.INFOLEVEL_3 );

   
   UPDATE SPECIFICATION_ING SI
      SET INGREDIENT_REV = ( SELECT MAX( REVISION )
                              FROM ITING_H
                             WHERE INGREDIENT = SI.INGREDIENT ),
          ING_SYNONYM_REV = ( SELECT MAX( REVISION )
                               FROM ITINGCFG_H
                              WHERE CID = SI.ING_SYNONYM )
    WHERE PART_NO = ASPARTNO
      AND REVISION = ANREVISION;
     
   
   
   
   UPDATE SPECIFICATION_ING SI
      SET ING_SYNONYM_REV = 0
    WHERE PART_NO = ASPARTNO
      AND REVISION = ANREVISION
      AND ING_SYNONYM_REV IS NULL;
    
  
   
   UPDATE ITSHBN
      SET BASE_NAME_REV = ( SELECT MAX( REVISION )
                             FROM ITING_H
                            WHERE INGREDIENT = ITSHBN.BASE_NAME_ID )
    WHERE PART_NO = ASPARTNO
      AND REVISION = ANREVISION;


   
   IAPIGENERAL.SESSION.DATABASE.CREATESECTIONHISTORY := FALSE;

   
   UPDATE SPECIFICATION_PROP SP
      SET CHARACTERISTIC_REV = ( SELECT COALESCE( MAX( REVISION ),
                                                  0 )
                                  FROM CHARACTERISTIC_H
                                 WHERE CHARACTERISTIC_ID = SP.CHARACTERISTIC )
    WHERE PART_NO = ASPARTNO
      AND REVISION = ANREVISION
      AND CHARACTERISTIC IS NOT NULL;

   UPDATE SPECIFICATION_PROP SP
      SET CH_REV_2 = ( SELECT COALESCE( MAX( REVISION ),
                                        0 )
                        FROM CHARACTERISTIC_H
                       WHERE CHARACTERISTIC_ID = SP.CH_2 )
    WHERE PART_NO = ASPARTNO
      AND REVISION = ANREVISION
      AND CH_2 IS NOT NULL;

   UPDATE SPECIFICATION_PROP SP
      SET CH_REV_3 = ( SELECT MAX( REVISION )
                        FROM CHARACTERISTIC_H
                       WHERE CHARACTERISTIC_ID = SP.CH_3 )
    WHERE PART_NO = ASPARTNO
      AND REVISION = ANREVISION
      AND CH_3 IS NOT NULL;



   
   UPDATE SPECIFICATION_LINE_PROP SLP
      SET CHARACTERISTIC_REV = ( SELECT COALESCE( MAX( REVISION ),
                                                  0 )
                                  FROM CHARACTERISTIC_H
                                 WHERE CHARACTERISTIC_ID = SLP.CHARACTERISTIC )
    WHERE PART_NO = ASPARTNO
      AND REVISION = ANREVISION
      AND CHARACTERISTIC IS NOT NULL;


    
    
    UPDATE SPECIFICATION_PROP SP
      SET TEST_METHOD_REV = ( SELECT COALESCE( MAX( REVISION ), 0)
                               FROM TEST_METHOD_H
                              WHERE TEST_METHOD = SP.TEST_METHOD )
    WHERE PART_NO = ASPARTNO
      AND REVISION = ANREVISION
      AND TEST_METHOD IS NOT NULL;   
    

   
   IAPIGENERAL.SESSION.DATABASE.CREATESECTIONHISTORY := TRUE;

   
   UPDATE BOM_ITEM
      SET CH_REV_1 = ( SELECT MAX( REVISION )
                        FROM CHARACTERISTIC_H
                       WHERE CHARACTERISTIC_ID = BOM_ITEM.CH_1 )
    WHERE PART_NO = ASPARTNO
      AND REVISION = ANREVISION;

   UPDATE BOM_ITEM
      SET CH_REV_2 = ( SELECT MAX( REVISION )
                        FROM CHARACTERISTIC_H
                       WHERE CHARACTERISTIC_ID = BOM_ITEM.CH_2 )
    WHERE PART_NO = ASPARTNO
      AND REVISION = ANREVISION;

   UPDATE BOM_ITEM
      SET CH_REV_3 = ( SELECT MAX( REVISION )
                        FROM CHARACTERISTIC_H
                       WHERE CHARACTERISTIC_ID = BOM_ITEM.CH_3 )
    WHERE PART_NO = ASPARTNO
      AND REVISION = ANREVISION;

   
   
    
    
    
  
    SELECT CLASS3_ID 
    INTO LNCLASSID
    FROM SPECIFICATION_HEADER                     
    WHERE PART_NO =  ASPARTNO 
        AND REVISION = ANREVISION;
        
    SELECT COUNT(*)
    INTO LNCOUNT
    FROM ITBOMLYSOURCE
    WHERE SOURCE = F_PART_SOURCE(  ASPARTNO )
        AND LAYOUT_TYPE = 2
        AND CLASS_ID = LNCLASSID;
     
    IF (LNCOUNT = 1)
    THEN
           UPDATE SPECIFICATION_SECTION
              SET DISPLAY_FORMAT = ( SELECT LAYOUT_ID
                                     FROM ITBOMLYSOURCE
                                     WHERE SOURCE = F_PART_SOURCE( ASPARTNO )
                                       AND LAYOUT_TYPE = 2
                                       AND CLASS_ID = LNCLASSID ),
                  DISPLAY_FORMAT_REV = ( SELECT LAYOUT_REV
                                         FROM ITBOMLYSOURCE
                                         WHERE SOURCE = F_PART_SOURCE( ASPARTNO )
                                           AND LAYOUT_TYPE = 2
                                           AND CLASS_ID = LNCLASSID )
            WHERE PART_NO = ASPARTNO
              AND REVISION = ANREVISION
              AND TYPE = IAPICONSTANT.SECTIONTYPE_BOM
              AND DISPLAY_FORMAT IS NULL;                
                               
    ELSE
    
       UPDATE SPECIFICATION_SECTION
          SET DISPLAY_FORMAT = ( SELECT LAYOUT_ID
                                  FROM ITBOMLYSOURCE
                                 WHERE SOURCE = F_PART_SOURCE( ASPARTNO )
                                   AND LAYOUT_TYPE = 2
                                   AND PREFERRED = 1 ),
              DISPLAY_FORMAT_REV = ( SELECT LAYOUT_REV
                                      FROM ITBOMLYSOURCE
                                     WHERE SOURCE = F_PART_SOURCE( ASPARTNO )
                                       AND LAYOUT_TYPE = 2
                                       AND PREFERRED = 1 )
        WHERE PART_NO = ASPARTNO
          AND REVISION = ANREVISION
          AND TYPE = IAPICONSTANT.SECTIONTYPE_BOM
          AND DISPLAY_FORMAT IS NULL;
  
    END IF;
  
  
   UPDATE SPECIFICATION_SECTION
      SET DISPLAY_FORMAT_REV = ( SELECT COALESCE( MAX( REVISION ),
                                                  0 )
                                  FROM ITBOMLY
                                 WHERE LAYOUT_ID = SPECIFICATION_SECTION.DISPLAY_FORMAT
                                   AND STATUS = 2 )
    WHERE PART_NO = ASPARTNO
      AND REVISION = ANREVISION
      AND TYPE = IAPICONSTANT.SECTIONTYPE_BOM
      AND DISPLAY_FORMAT NOT IN( 2, 3 );

   
   UPDATE SPECIFICATION_STAGE SS
      SET DISPLAY_FORMAT_REV = ( SELECT MAX( REVISION )
                                  FROM LAYOUT
                                 WHERE LAYOUT_ID = SS.DISPLAY_FORMAT )
    WHERE PART_NO = ASPARTNO
      AND REVISION = ANREVISION;

   


   DELETE FROM SPECIFICATION_CD
         WHERE PART_NO = ASPARTNO
           AND REVISION = ANREVISION;

   
   INSERT INTO SPECIFICATION_CD
               ( PART_NO,
                 REVISION,
                 SECTION_ID,
                 SUB_SECTION_ID,
                 PROPERTY_GROUP,
                 PROPERTY,
                 ATTRIBUTE,
                 SEQ_NO,
                 CD )
      SELECT A.PART_NO,
             A.REVISION,
             A.SECTION_ID,
             A.SUB_SECTION_ID,
             A.PROPERTY_GROUP,
             A.PROPERTY,
             A.ATTRIBUTE,
             1 SEQ_NO,
             B.CONDITION
        FROM SPECIFICATION_PROP A,
             TEST_METHOD_CONDITION B
       WHERE A.PART_NO = ASPARTNO
         AND A.REVISION = ANREVISION
         AND A.TM_SET_NO IS NOT NULL
         AND A.TEST_METHOD = B.TEST_METHOD
         AND A.TM_SET_NO = B.SET_NO
      UNION
      SELECT A.PART_NO,
             A.REVISION,
             A.SECTION_ID,
             A.SUB_SECTION_ID,
             A.PROPERTY_GROUP,
             A.PROPERTY,
             A.ATTRIBUTE,
             A.SEQ_NO,
             B.CONDITION
        FROM SPECIFICATION_TM A,
             TEST_METHOD_CONDITION B
       WHERE A.PART_NO = ASPARTNO
         AND A.REVISION = ANREVISION
         AND TM_SET_NO IS NOT NULL
         AND A.TM = B.TEST_METHOD
         AND A.TM_SET_NO = B.SET_NO;

   
   UPDATE SPECIFICATION_CD SC
      SET CD_REV = ( SELECT MAX( REVISION )
                      FROM CONDITION_H
                     WHERE CONDITION = SC.CD )
    WHERE PART_NO = ASPARTNO
      AND REVISION = ANREVISION;
EXCEPTION
   WHEN OTHERS
   THEN
      IAPIGENERAL.LOGERROR( LSSOURCE,
                            '',
                            SQLERRM );
      LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      RAISE_APPLICATION_ERROR( -20000,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
END SP_SET_SPEC_CURRENT;
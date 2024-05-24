CREATE OR REPLACE PROCEDURE SP_COMPARE_SPEC (
   ANUNIQUEID      IN OUT IAPITYPE.SEQUENCE_TYPE,
   ASPARTNO1       IN     IAPITYPE.PARTNO_TYPE,
   ANREVISION1     IN     IAPITYPE.REVISION_TYPE,
   ANLANGUAGEID1   IN     IAPITYPE.LANGUAGEID_TYPE,
   ASPARTNO2       IN     IAPITYPE.PARTNO_TYPE,
   ANREVISION2     IN     IAPITYPE.REVISION_TYPE,
   ANLANGUAGEID2   IN     IAPITYPE.LANGUAGEID_TYPE)
IS
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   

   
   L_TEXT1        CLOB;
   L_TEXT2        CLOB;
   V_LANG_ID      IAPITYPE.LANGUAGEID_TYPE;
   V_LANG_ID1     IAPITYPE.LANGUAGEID_TYPE;
   V_LANG_ID2     IAPITYPE.LANGUAGEID_TYPE;
   V_VALUE_S      SPECDATA.VALUE_S%TYPE;
   L_BOM_CHECK    CHAR := '';
   L_ATT_CHECK    CHAR := '';
   L_ING_CHECK    CHAR := '';
   L_SECTION_ID   IAPITYPE.ID_TYPE;
   LSSOURCE       IAPITYPE.METHOD_TYPE := 'SP_COMPARE_SPEC';
   LNRETVAL       IAPITYPE.ERRORNUM_TYPE;

   
   CURSOR CUR_FREE_TEXT
   IS
      (SELECT SECTION_ID, SUB_SECTION_ID, REF_ID
         FROM SPECIFICATION_SECTION
        WHERE     PART_NO = ASPARTNO1
              AND REVISION = ANREVISION1
              AND TYPE = IAPICONSTANT.SECTIONTYPE_FREETEXT
       UNION
       SELECT SECTION_ID, SUB_SECTION_ID, REF_ID
         FROM SPECIFICATION_SECTION
        WHERE     PART_NO = ASPARTNO2
              AND REVISION = ANREVISION2
              AND TYPE = IAPICONSTANT.SECTIONTYPE_FREETEXT)
      MINUS
      SELECT SECTION_ID, SUB_SECTION_ID, REF_ID
        FROM ITSHCMP
       WHERE COMP_NO = ANUNIQUEID
             AND TYPE = IAPICONSTANT.SECTIONTYPE_FREETEXT;

   
   CURSOR CUR_STAGE_TEXT
   IS
      SELECT S.SECTION_ID,
             STAGE,
             PLANT,
             LINE,
             CONFIGURATION,
             TEXT_TYPE
        FROM SPECIFICATION_LINE_TEXT T, SPECIFICATION_SECTION S
       WHERE     T.PART_NO = ASPARTNO1
             AND T.REVISION = ANREVISION1
             AND S.PART_NO = T.PART_NO
             AND S.REVISION = T.REVISION
             AND TYPE = IAPICONSTANT.SECTIONTYPE_PROCESSDATA
      UNION
      SELECT S.SECTION_ID,
             STAGE,
             PLANT,
             LINE,
             CONFIGURATION,
             TEXT_TYPE
        FROM SPECIFICATION_LINE_TEXT T, SPECIFICATION_SECTION S
       WHERE     T.PART_NO = ASPARTNO2
             AND T.REVISION = ANREVISION2
             AND S.PART_NO = T.PART_NO
             AND S.REVISION = T.REVISION
             AND TYPE = IAPICONSTANT.SECTIONTYPE_PROCESSDATA;

   
   CURSOR CUR_BOM
   IS
      (SELECT SECTION_ID, SUB_SECTION_ID, REF_ID
         FROM SPECIFICATION_SECTION
        WHERE     PART_NO = ASPARTNO1
              AND REVISION = ANREVISION1
              AND TYPE = IAPICONSTANT.SECTIONTYPE_BOM
       UNION
       SELECT SECTION_ID, SUB_SECTION_ID, REF_ID
         FROM SPECIFICATION_SECTION
        WHERE     PART_NO = ASPARTNO2
              AND REVISION = ANREVISION2
              AND TYPE = IAPICONSTANT.SECTIONTYPE_BOM)
      MINUS
      SELECT SECTION_ID, SUB_SECTION_ID, REF_ID
        FROM ITSHCMP
       WHERE COMP_NO = ANUNIQUEID AND TYPE = IAPICONSTANT.SECTIONTYPE_BOM;

   
   CURSOR CUR_ATT
   IS
      SELECT DISTINCT SECTION_ID, SUB_SECTION_ID
        FROM ( (SELECT SECTION_ID, SUB_SECTION_ID, REF_ID
                  FROM SPECIFICATION_SECTION
                 WHERE     PART_NO = ASPARTNO1
                       AND REVISION = ANREVISION1
                       AND TYPE = IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC
                UNION
                SELECT SECTION_ID, SUB_SECTION_ID, REF_ID
                  FROM SPECIFICATION_SECTION
                 WHERE     PART_NO = ASPARTNO2
                       AND REVISION = ANREVISION2
                       AND TYPE = IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC)
              MINUS
              SELECT SECTION_ID, SUB_SECTION_ID, REF_ID
                FROM ITSHCMP
               WHERE COMP_NO = ANUNIQUEID
                     AND TYPE = IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC);

   
   CURSOR CUR_ING
   IS
      (SELECT SECTION_ID, SUB_SECTION_ID, REF_ID
         FROM SPECIFICATION_SECTION
        WHERE     PART_NO = ASPARTNO1
              AND REVISION = ANREVISION1
              AND TYPE = IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST
       UNION
       SELECT SECTION_ID, SUB_SECTION_ID, REF_ID
         FROM SPECIFICATION_SECTION
        WHERE     PART_NO = ASPARTNO2
              AND REVISION = ANREVISION2
              AND TYPE = IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST)
      MINUS
      SELECT SECTION_ID, SUB_SECTION_ID, REF_ID
        FROM ITSHCMP
       WHERE COMP_NO = ANUNIQUEID
             AND TYPE = IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST;

   
   CURSOR CUR_BN
   IS
      (SELECT SECTION_ID, SUB_SECTION_ID
         FROM SPECIFICATION_SECTION
        WHERE     PART_NO = ASPARTNO1
              AND REVISION = ANREVISION1
              AND TYPE = IAPICONSTANT.SECTIONTYPE_BASENAME
       UNION
       SELECT SECTION_ID, SUB_SECTION_ID
         FROM SPECIFICATION_SECTION
        WHERE     PART_NO = ASPARTNO2
              AND REVISION = ANREVISION2
              AND TYPE = IAPICONSTANT.SECTIONTYPE_BASENAME)
      MINUS
      SELECT SECTION_ID, SUB_SECTION_ID
        FROM ITSHCMP
       WHERE COMP_NO = ANUNIQUEID
             AND TYPE = IAPICONSTANT.SECTIONTYPE_BASENAME;

   CURSOR CUR_PG
   IS
      SELECT DISTINCT
             SECTION_ID,
             SUB_SECTION_ID,
             TYPE,
             DECODE (TYPE,
                     IAPICONSTANT.SECTIONTYPE_PROCESSDATA, -2,
                     IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP, PROPERTY_GROUP,
                     PROPERTY)
                REF_ID
        FROM ( (SELECT TYPE,
                       SECTION_ID,
                       SUB_SECTION_ID,
                       PROPERTY_GROUP,
                       PROPERTY,
                       ATTRIBUTE,
                       HEADER_ID,
                       UOM_ID,
                       TEST_METHOD,
                       VALUE_S
                  FROM SPECDATA
                 WHERE     PART_NO = ASPARTNO1
                       AND REVISION = ANREVISION1
                       AND LANG_ID = 1
                MINUS
                SELECT TYPE,
                       SECTION_ID,
                       SUB_SECTION_ID,
                       PROPERTY_GROUP,
                       PROPERTY,
                       ATTRIBUTE,
                       HEADER_ID,
                       UOM_ID,
                       TEST_METHOD,
                       VALUE_S
                  FROM SPECDATA
                 WHERE     PART_NO = ASPARTNO2
                       AND REVISION = ANREVISION2
                       AND LANG_ID = 1)
              UNION
              (SELECT TYPE,
                      SECTION_ID,
                      SUB_SECTION_ID,
                      PROPERTY_GROUP,
                      PROPERTY,
                      ATTRIBUTE,
                      HEADER_ID,
                      UOM_ID,
                      TEST_METHOD,
                      VALUE_S
                 FROM SPECDATA
                WHERE     PART_NO = ASPARTNO2
                      AND REVISION = ANREVISION2
                      AND LANG_ID = 1
               MINUS
               SELECT TYPE,
                      SECTION_ID,
                      SUB_SECTION_ID,
                      PROPERTY_GROUP,
                      PROPERTY,
                      ATTRIBUTE,
                      HEADER_ID,
                      UOM_ID,
                      TEST_METHOD,
                      VALUE_S
                 FROM SPECDATA
                WHERE     PART_NO = ASPARTNO1
                      AND REVISION = ANREVISION1
                      AND LANG_ID = 1));

   CURSOR CUR_TM
   IS
      SELECT DISTINCT
             SECTION_ID,
             SUB_SECTION_ID,
             DECODE (PROPERTY_GROUP,
                     0, 4,
                     IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP)
                REF_TYPE,
             DECODE (PROPERTY_GROUP, 0, PROPERTY, PROPERTY_GROUP) REF_ID
        FROM ( (SELECT SECTION_ID,
                       SUB_SECTION_ID,
                       PROPERTY_GROUP,
                       PROPERTY,
                       ATTRIBUTE,
                       SEQ_NO,
                       TM_TYPE,
                       TM,
                       TM_SET_NO
                  FROM SPECIFICATION_TM
                 WHERE PART_NO = ASPARTNO1 AND REVISION = ANREVISION1
                MINUS
                SELECT SECTION_ID,
                       SUB_SECTION_ID,
                       PROPERTY_GROUP,
                       PROPERTY,
                       ATTRIBUTE,
                       SEQ_NO,
                       TM_TYPE,
                       TM,
                       TM_SET_NO
                  FROM SPECIFICATION_TM
                 WHERE PART_NO = ASPARTNO2 AND REVISION = ANREVISION2)
              UNION
              (SELECT SECTION_ID,
                      SUB_SECTION_ID,
                      PROPERTY_GROUP,
                      PROPERTY,
                      ATTRIBUTE,
                      SEQ_NO,
                      TM_TYPE,
                      TM,
                      TM_SET_NO
                 FROM SPECIFICATION_TM
                WHERE PART_NO = ASPARTNO2 AND REVISION = ANREVISION2
               MINUS
               SELECT SECTION_ID,
                      SUB_SECTION_ID,
                      PROPERTY_GROUP,
                      PROPERTY,
                      ATTRIBUTE,
                      SEQ_NO,
                      TM_TYPE,
                      TM,
                      TM_SET_NO
                 FROM SPECIFICATION_TM
                WHERE PART_NO = ASPARTNO1 AND REVISION = ANREVISION1));

   CURSOR CUR_TM_DET
   IS
      SELECT DISTINCT
             SECTION_ID,
             SUB_SECTION_ID,
             DECODE (PROPERTY_GROUP,
                     0, 4,
                     IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP)
                REF_TYPE,
             DECODE (PROPERTY_GROUP, 0, PROPERTY, PROPERTY_GROUP) REF_ID
        FROM ( (SELECT SECTION_ID,
                       SUB_SECTION_ID,
                       PROPERTY_GROUP,
                       PROPERTY,
                       ATTRIBUTE,
                       NVL (TM_DET_1, 'N'),
                       NVL (TM_DET_2, 'N'),
                       NVL (TM_DET_3, 'N'),
                       NVL (TM_DET_4, 'N'),
                       TM_SET_NO
                  FROM SPECIFICATION_PROP
                 WHERE PART_NO = ASPARTNO1 AND REVISION = ANREVISION1
                MINUS
                SELECT SECTION_ID,
                       SUB_SECTION_ID,
                       PROPERTY_GROUP,
                       PROPERTY,
                       ATTRIBUTE,
                       NVL (TM_DET_1, 'N'),
                       NVL (TM_DET_2, 'N'),
                       NVL (TM_DET_3, 'N'),
                       NVL (TM_DET_4, 'N'),
                       TM_SET_NO
                  FROM SPECIFICATION_PROP
                 WHERE PART_NO = ASPARTNO2 AND REVISION = ANREVISION2)
              UNION
              (SELECT SECTION_ID,
                      SUB_SECTION_ID,
                      PROPERTY_GROUP,
                      PROPERTY,
                      ATTRIBUTE,
                      NVL (TM_DET_1, 'N'),
                      NVL (TM_DET_2, 'N'),
                      NVL (TM_DET_3, 'N'),
                      NVL (TM_DET_4, 'N'),
                      TM_SET_NO
                 FROM SPECIFICATION_PROP
                WHERE PART_NO = ASPARTNO2 AND REVISION = ANREVISION2
               MINUS
               SELECT SECTION_ID,
                      SUB_SECTION_ID,
                      PROPERTY_GROUP,
                      PROPERTY,
                      ATTRIBUTE,
                      NVL (TM_DET_1, 'N'),
                      NVL (TM_DET_2, 'N'),
                      NVL (TM_DET_3, 'N'),
                      NVL (TM_DET_4, 'N'),
                      TM_SET_NO
                 FROM SPECIFICATION_PROP
                WHERE PART_NO = ASPARTNO1 AND REVISION = ANREVISION1));

   CURSOR CUR_INFO
   IS
      SELECT DISTINCT
             SECTION_ID,
             SUB_SECTION_ID,
             DECODE (PROPERTY_GROUP,
                     0, 4,
                     IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP)
                REF_TYPE,
             DECODE (PROPERTY_GROUP, 0, PROPERTY, PROPERTY_GROUP) REF_ID,
             PROPERTY_GROUP,
             PROPERTY,
             ATTRIBUTE
        FROM ( (SELECT SECTION_ID,
                       SUB_SECTION_ID,
                       PROPERTY_GROUP,
                       PROPERTY,
                       ATTRIBUTE,
                       F_PROP_LANG_ARG (PART_NO,
                                        REVISION,
                                        SECTION_ID,
                                        SUB_SECTION_ID,
                                        PROPERTY_GROUP,
                                        PROPERTY,
                                        ATTRIBUTE,
                                        IAPICONSTANT.SECTIONTYPE_PROCESSDATA,
                                        ANLANGUAGEID1)
                  FROM SPECIFICATION_PROP
                 WHERE     PART_NO = ASPARTNO1
                       AND REVISION = ANREVISION1
                       AND F_GET_NOTE (PART_NO,
                                       REVISION,
                                       SECTION_ID,
                                       SUB_SECTION_ID,
                                       PROPERTY_GROUP,
                                       PROPERTY) = 1
                MINUS
                SELECT SECTION_ID,
                       SUB_SECTION_ID,
                       PROPERTY_GROUP,
                       PROPERTY,
                       ATTRIBUTE,
                       F_PROP_LANG_ARG (PART_NO,
                                        REVISION,
                                        SECTION_ID,
                                        SUB_SECTION_ID,
                                        PROPERTY_GROUP,
                                        PROPERTY,
                                        ATTRIBUTE,
                                        IAPICONSTANT.SECTIONTYPE_PROCESSDATA,
                                        ANLANGUAGEID2)
                  FROM SPECIFICATION_PROP
                 WHERE     PART_NO = ASPARTNO2
                       AND REVISION = ANREVISION2
                       AND F_GET_NOTE (PART_NO,
                                       REVISION,
                                       SECTION_ID,
                                       SUB_SECTION_ID,
                                       PROPERTY_GROUP,
                                       PROPERTY) = 1)
              UNION
              (SELECT SECTION_ID,
                      SUB_SECTION_ID,
                      PROPERTY_GROUP,
                      PROPERTY,
                      ATTRIBUTE,
                      F_PROP_LANG_ARG (PART_NO,
                                       REVISION,
                                       SECTION_ID,
                                       SUB_SECTION_ID,
                                       PROPERTY_GROUP,
                                       PROPERTY,
                                       ATTRIBUTE,
                                       IAPICONSTANT.SECTIONTYPE_PROCESSDATA,
                                       ANLANGUAGEID2)
                 FROM SPECIFICATION_PROP
                WHERE     PART_NO = ASPARTNO2
                      AND REVISION = ANREVISION2
                      AND F_GET_NOTE (PART_NO,
                                      REVISION,
                                      SECTION_ID,
                                      SUB_SECTION_ID,
                                      PROPERTY_GROUP,
                                      PROPERTY) = 1
               MINUS
               SELECT SECTION_ID,
                      SUB_SECTION_ID,
                      PROPERTY_GROUP,
                      PROPERTY,
                      ATTRIBUTE,
                      F_PROP_LANG_ARG (PART_NO,
                                       REVISION,
                                       SECTION_ID,
                                       SUB_SECTION_ID,
                                       PROPERTY_GROUP,
                                       PROPERTY,
                                       ATTRIBUTE,
                                       IAPICONSTANT.SECTIONTYPE_PROCESSDATA,
                                       ANLANGUAGEID1)
                 FROM SPECIFICATION_PROP
                WHERE     PART_NO = ASPARTNO1
                      AND REVISION = ANREVISION1
                      AND F_GET_NOTE (PART_NO,
                                      REVISION,
                                      SECTION_ID,
                                      SUB_SECTION_ID,
                                      PROPERTY_GROUP,
                                      PROPERTY) = 1));

   CURSOR CUR_PL
   IS
      SELECT DISTINCT SECTION_ID,
                      SUB_SECTION_ID,
                      PLANT,
                      LINE,
                      CONFIGURATION,
                      STAGE,
                      TYPE
        FROM ( (SELECT TYPE,
                       SECTION_ID,
                       SUB_SECTION_ID,
                       PLANT,
                       LINE,
                       CONFIGURATION,
                       STAGE,
                       PROPERTY,
                       ATTRIBUTE,
                       HEADER_ID,
                       UOM_ID,
                       TEST_METHOD,
                       VALUE_S,
                       COMPONENT_PART,
                       QUANTITY
                  FROM SPECDATA_PROCESS
                 WHERE PART_NO = ASPARTNO1 AND REVISION = ANREVISION1
                MINUS
                SELECT TYPE,
                       SECTION_ID,
                       SUB_SECTION_ID,
                       PLANT,
                       LINE,
                       CONFIGURATION,
                       STAGE,
                       PROPERTY,
                       ATTRIBUTE,
                       HEADER_ID,
                       UOM_ID,
                       TEST_METHOD,
                       VALUE_S,
                       COMPONENT_PART,
                       QUANTITY
                  FROM SPECDATA_PROCESS
                 WHERE PART_NO = ASPARTNO2 AND REVISION = ANREVISION2)
              UNION
              (SELECT TYPE,
                      SECTION_ID,
                      SUB_SECTION_ID,
                      PLANT,
                      LINE,
                      CONFIGURATION,
                      STAGE,
                      PROPERTY,
                      ATTRIBUTE,
                      HEADER_ID,
                      UOM_ID,
                      TEST_METHOD,
                      VALUE_S,
                      COMPONENT_PART,
                      QUANTITY
                 FROM SPECDATA_PROCESS
                WHERE PART_NO = ASPARTNO2 AND REVISION = ANREVISION2
               MINUS
               SELECT TYPE,
                      SECTION_ID,
                      SUB_SECTION_ID,
                      PLANT,
                      LINE,
                      CONFIGURATION,
                      STAGE,
                      PROPERTY,
                      ATTRIBUTE,
                      HEADER_ID,
                      UOM_ID,
                      TEST_METHOD,
                      VALUE_S,
                      COMPONENT_PART,
                      QUANTITY
                 FROM SPECDATA_PROCESS
                WHERE PART_NO = ASPARTNO1 AND REVISION = ANREVISION1));

   
   CURSOR CUR_PL_PA
   IS
      SELECT DISTINCT SECTION_ID,
                      SUB_SECTION_ID,
                      PLANT,
                      LINE,
                      CONFIGURATION,
                      STAGE,
                      TYPE
        FROM ( (SELECT TYPE,
                       SECTION_ID,
                       SUB_SECTION_ID,
                       PLANT,
                       LINE,
                       CONFIGURATION,
                       STAGE,
                       PROPERTY,
                       ATTRIBUTE,
                       HEADER_ID,
                       UOM_ID,
                       TEST_METHOD,
                       VALUE_S,
                       COMPONENT_PART,
                       QUANTITY
                  FROM SPECDATA_PROCESS
                 WHERE PART_NO = ASPARTNO1 AND REVISION = ANREVISION1
                       AND EXISTS
                             (SELECT PART_NO
                                FROM PART_PLANT PP, ITUP UP
                               WHERE PP.PLANT_ACCESS = 'Y'
                                     AND PP.PLANT = SPECDATA_PROCESS.PLANT
                                     AND PP.PART_NO =
                                           SPECDATA_PROCESS.PART_NO
                                     
                                     AND UP.PLANT = SPECDATA_PROCESS.PLANT
                                     AND UP.USER_ID =
                                           IAPIGENERAL.SESSION.APPLICATIONUSER.USERID)
                MINUS
                SELECT TYPE,
                       SECTION_ID,
                       SUB_SECTION_ID,
                       PLANT,
                       LINE,
                       CONFIGURATION,
                       STAGE,
                       PROPERTY,
                       ATTRIBUTE,
                       HEADER_ID,
                       UOM_ID,
                       TEST_METHOD,
                       VALUE_S,
                       COMPONENT_PART,
                       QUANTITY
                  FROM SPECDATA_PROCESS
                 WHERE PART_NO = ASPARTNO2 AND REVISION = ANREVISION2
                       AND EXISTS
                             (SELECT PART_NO
                                FROM PART_PLANT PP, ITUP UP
                               WHERE PP.PLANT_ACCESS = 'Y'
                                     AND PP.PLANT = SPECDATA_PROCESS.PLANT
                                     AND PP.PART_NO =
                                           SPECDATA_PROCESS.PART_NO
                                     
                                     AND UP.PLANT = SPECDATA_PROCESS.PLANT
                                     AND UP.USER_ID =
                                           IAPIGENERAL.SESSION.APPLICATIONUSER.USERID))
              UNION
              (SELECT TYPE,
                      SECTION_ID,
                      SUB_SECTION_ID,
                      PLANT,
                      LINE,
                      CONFIGURATION,
                      STAGE,
                      PROPERTY,
                      ATTRIBUTE,
                      HEADER_ID,
                      UOM_ID,
                      TEST_METHOD,
                      VALUE_S,
                      COMPONENT_PART,
                      QUANTITY
                 FROM SPECDATA_PROCESS
                WHERE PART_NO = ASPARTNO2 AND REVISION = ANREVISION2
                      AND EXISTS
                            (SELECT PART_NO
                               FROM PART_PLANT PP, ITUP UP
                              WHERE     PP.PLANT_ACCESS = 'Y'
                                    AND PP.PLANT = SPECDATA_PROCESS.PLANT
                                    AND PP.PART_NO = SPECDATA_PROCESS.PART_NO
                                    
                                    AND UP.PLANT = SPECDATA_PROCESS.PLANT
                                    AND UP.USER_ID =
                                          IAPIGENERAL.SESSION.APPLICATIONUSER.USERID)
               MINUS
               SELECT TYPE,
                      SECTION_ID,
                      SUB_SECTION_ID,
                      PLANT,
                      LINE,
                      CONFIGURATION,
                      STAGE,
                      PROPERTY,
                      ATTRIBUTE,
                      HEADER_ID,
                      UOM_ID,
                      TEST_METHOD,
                      VALUE_S,
                      COMPONENT_PART,
                      QUANTITY
                 FROM SPECDATA_PROCESS
                WHERE PART_NO = ASPARTNO1 AND REVISION = ANREVISION1
                      AND EXISTS
                            (SELECT PART_NO
                               FROM PART_PLANT PP, ITUP UP
                              WHERE     PP.PLANT_ACCESS = 'Y'
                                    AND PP.PLANT = SPECDATA_PROCESS.PLANT
                                    AND PP.PART_NO = SPECDATA_PROCESS.PART_NO
                                    
                                    AND UP.PLANT = SPECDATA_PROCESS.PLANT
                                    AND UP.USER_ID =
                                          IAPIGENERAL.SESSION.APPLICATIONUSER.USERID)));

   CURSOR CUR_PG_LANG (
      ANLANGUAGEID1                 IAPITYPE.LANGUAGEID_TYPE,
      ANLANGUAGEID2                 IAPITYPE.LANGUAGEID_TYPE)
   IS
      SELECT DISTINCT
             SECTION_ID,
             SUB_SECTION_ID,
             TYPE,
             DECODE (TYPE,
                     IAPICONSTANT.SECTIONTYPE_PROCESSDATA, -2,
                     IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP, PROPERTY_GROUP,
                     PROPERTY)
                REF_ID
        FROM ( ( (SELECT TYPE,
                         SECTION_ID,
                         SUB_SECTION_ID,
                         PROPERTY_GROUP,
                         PROPERTY,
                         ATTRIBUTE,
                         HEADER_ID,
                         UOM_ID,
                         TEST_METHOD,
                         VALUE_S
                    FROM SPECDATA
                   WHERE     PART_NO = ASPARTNO1
                         AND REVISION = ANREVISION1
                         AND LANG_ID = 1
                  UNION
                  SELECT TYPE,
                         SECTION_ID,
                         SUB_SECTION_ID,
                         PROPERTY_GROUP,
                         PROPERTY,
                         ATTRIBUTE,
                         HEADER_ID,
                         UOM_ID,
                         TEST_METHOD,
                         VALUE_S
                    FROM SPECDATA
                   WHERE     PART_NO = ASPARTNO1
                         AND REVISION = ANREVISION1
                         AND LANG_ID = ANLANGUAGEID1)
                MINUS
                (SELECT TYPE,
                        SECTION_ID,
                        SUB_SECTION_ID,
                        PROPERTY_GROUP,
                        PROPERTY,
                        ATTRIBUTE,
                        HEADER_ID,
                        UOM_ID,
                        TEST_METHOD,
                        VALUE_S
                   FROM SPECDATA
                  WHERE     PART_NO = ASPARTNO2
                        AND REVISION = ANREVISION2
                        AND LANG_ID = 1
                 UNION
                 SELECT TYPE,
                        SECTION_ID,
                        SUB_SECTION_ID,
                        PROPERTY_GROUP,
                        PROPERTY,
                        ATTRIBUTE,
                        HEADER_ID,
                        UOM_ID,
                        TEST_METHOD,
                        VALUE_S
                   FROM SPECDATA
                  WHERE     PART_NO = ASPARTNO2
                        AND REVISION = ANREVISION2
                        AND LANG_ID = ANLANGUAGEID2))
              UNION
              ( (SELECT TYPE,
                        SECTION_ID,
                        SUB_SECTION_ID,
                        PROPERTY_GROUP,
                        PROPERTY,
                        ATTRIBUTE,
                        HEADER_ID,
                        UOM_ID,
                        TEST_METHOD,
                        VALUE_S
                   FROM SPECDATA
                  WHERE     PART_NO = ASPARTNO2
                        AND REVISION = ANREVISION2
                        AND LANG_ID = 1
                 UNION
                 SELECT TYPE,
                        SECTION_ID,
                        SUB_SECTION_ID,
                        PROPERTY_GROUP,
                        PROPERTY,
                        ATTRIBUTE,
                        HEADER_ID,
                        UOM_ID,
                        TEST_METHOD,
                        VALUE_S
                   FROM SPECDATA
                  WHERE     PART_NO = ASPARTNO2
                        AND REVISION = ANREVISION2
                        AND LANG_ID = ANLANGUAGEID2)
               MINUS
               (SELECT TYPE,
                       SECTION_ID,
                       SUB_SECTION_ID,
                       PROPERTY_GROUP,
                       PROPERTY,
                       ATTRIBUTE,
                       HEADER_ID,
                       UOM_ID,
                       TEST_METHOD,
                       VALUE_S
                  FROM SPECDATA
                 WHERE     PART_NO = ASPARTNO1
                       AND REVISION = ANREVISION1
                       AND LANG_ID = 1
                UNION
                SELECT TYPE,
                       SECTION_ID,
                       SUB_SECTION_ID,
                       PROPERTY_GROUP,
                       PROPERTY,
                       ATTRIBUTE,
                       HEADER_ID,
                       UOM_ID,
                       TEST_METHOD,
                       VALUE_S
                  FROM SPECDATA
                 WHERE     PART_NO = ASPARTNO1
                       AND REVISION = ANREVISION1
                       AND LANG_ID = ANLANGUAGEID1)));

   CURSOR CUR_SC
   IS
      
      SELECT DISTINCT SECTION_ID,
                      SUB_SECTION_ID,
                      TYPE,
                      REF_ID,
                      REF_VERSION,
                      NVL (REF_OWNER, -1) REF_OWNER,
                      NVL (REF_INFO, -1) REF_INFO
        FROM ( (SELECT SECTION_ID,
                       SUB_SECTION_ID,
                       TYPE,
                       REF_ID,
                       NVL (
                          DECODE (
                             TYPE,
                             2,
                             DECODE (
                                REF_ID,
                                0,
                                0,
                                DECODE (REF_VER,
                                        0, F_GET_REF_REVISION (TYPE,
                                                               REF_ID,
                                                               REF_OWNER,
                                                               SYSDATE),
                                        REF_VER)),
                             DECODE (
                                TYPE,
                                6,
                                DECODE (
                                   REF_ID,
                                   0,
                                   0,
                                   DECODE (REF_VER,
                                           0, F_GET_REF_REVISION (TYPE,
                                                                  REF_ID,
                                                                  REF_OWNER,
                                                                  SYSDATE),
                                           REF_VER)),
                                REF_VER)),
                          -1)
                          REF_VERSION,
                       REF_OWNER,
                       REF_INFO
                  FROM SPECIFICATION_SECTION
                 WHERE PART_NO = ASPARTNO1 AND REVISION = ANREVISION1
                       AND TYPE NOT IN
                                (IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP,
                                 IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY,
                                 IAPICONSTANT.SECTIONTYPE_FREETEXT,
                                 IAPICONSTANT.SECTIONTYPE_PROCESSDATA,
                                 IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC)
                MINUS
                SELECT SECTION_ID,
                       SUB_SECTION_ID,
                       TYPE,
                       REF_ID,
                       NVL (
                          DECODE (
                             TYPE,
                             2,
                             DECODE (
                                REF_ID,
                                0,
                                0,
                                DECODE (REF_VER,
                                        0, F_GET_REF_REVISION (TYPE,
                                                               REF_ID,
                                                               REF_OWNER,
                                                               SYSDATE),
                                        REF_VER)),
                             DECODE (
                                TYPE,
                                6,
                                DECODE (
                                   REF_ID,
                                   0,
                                   0,
                                   DECODE (REF_VER,
                                           0, F_GET_REF_REVISION (TYPE,
                                                                  REF_ID,
                                                                  REF_OWNER,
                                                                  SYSDATE),
                                           REF_VER)),
                                REF_VER)),
                          -1)
                          REF_VERSION,
                       REF_OWNER,
                       REF_INFO
                  FROM SPECIFICATION_SECTION
                 WHERE PART_NO = ASPARTNO2 AND REVISION = ANREVISION2
                       AND TYPE NOT IN
                                (IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP,
                                 IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY,
                                 IAPICONSTANT.SECTIONTYPE_FREETEXT,
                                 IAPICONSTANT.SECTIONTYPE_PROCESSDATA,
                                 IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC))
              UNION
              (SELECT SECTION_ID,
                      SUB_SECTION_ID,
                      TYPE,
                      REF_ID,
                      NVL (
                         DECODE (
                            TYPE,
                            2,
                            DECODE (REF_ID,
                                    0, 0,
                                    DECODE (REF_VER,
                                            0, F_GET_REF_REVISION (TYPE,
                                                                   REF_ID,
                                                                   REF_OWNER,
                                                                   SYSDATE),
                                            REF_VER)),
                            DECODE (
                               TYPE,
                               6,
                               DECODE (
                                  REF_ID,
                                  0,
                                  0,
                                  DECODE (REF_VER,
                                          0, F_GET_REF_REVISION (TYPE,
                                                                 REF_ID,
                                                                 REF_OWNER,
                                                                 SYSDATE),
                                          REF_VER)),
                               REF_VER)),
                         -1)
                         REF_VERSION,
                      REF_OWNER,
                      REF_INFO
                 FROM SPECIFICATION_SECTION
                WHERE PART_NO = ASPARTNO2 AND REVISION = ANREVISION2
                      AND TYPE NOT IN
                               (IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP,
                                IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY,
                                IAPICONSTANT.SECTIONTYPE_FREETEXT,
                                IAPICONSTANT.SECTIONTYPE_PROCESSDATA,
                                IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC)
               MINUS
               SELECT SECTION_ID,
                      SUB_SECTION_ID,
                      TYPE,
                      REF_ID,
                      NVL (
                         DECODE (
                            TYPE,
                            2,
                            DECODE (REF_ID,
                                    0, 0,
                                    DECODE (REF_VER,
                                            0, F_GET_REF_REVISION (TYPE,
                                                                   REF_ID,
                                                                   REF_OWNER,
                                                                   SYSDATE),
                                            REF_VER)),
                            DECODE (
                               TYPE,
                               6,
                               DECODE (
                                  REF_ID,
                                  0,
                                  0,
                                  DECODE (REF_VER,
                                          0, F_GET_REF_REVISION (TYPE,
                                                                 REF_ID,
                                                                 REF_OWNER,
                                                                 SYSDATE),
                                          REF_VER)),
                               REF_VER)),
                         -1)
                         REF_VERSION,
                      REF_OWNER,
                      REF_INFO
                 FROM SPECIFICATION_SECTION
                WHERE PART_NO = ASPARTNO1 AND REVISION = ANREVISION1
                      AND TYPE NOT IN
                               (IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP,
                                IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY,
                                IAPICONSTANT.SECTIONTYPE_FREETEXT,
                                IAPICONSTANT.SECTIONTYPE_PROCESSDATA,
                                IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC)));

   CURSOR CUR_KW
   IS
      SELECT KW_ID,
             KW_VALUE,
             F_GET_VAL_KW (ASPARTNO1, KW_ID, KW_VALUE) KW_VAL2
        FROM SPECIFICATION_KW
       WHERE PART_NO = ASPARTNO2
      UNION
      SELECT KW_ID,
             KW_VALUE,
             F_GET_VAL_KW (ASPARTNO2, KW_ID, KW_VALUE) KW_VAL2
        FROM SPECIFICATION_KW
       WHERE PART_NO = ASPARTNO1;

   CURSOR CUR_CL
   IS
      (SELECT HIER_LEVEL,
              MATL_CLASS_ID,
              CODE,
              TYPE
         FROM ITPRCL
        WHERE PART_NO = ASPARTNO2
       MINUS
       SELECT HIER_LEVEL,
              MATL_CLASS_ID,
              CODE,
              TYPE
         FROM ITPRCL
        WHERE PART_NO = ASPARTNO1)
      UNION
      (SELECT HIER_LEVEL,
              MATL_CLASS_ID,
              CODE,
              TYPE
         FROM ITPRCL
        WHERE PART_NO = ASPARTNO1
       MINUS
       SELECT HIER_LEVEL,
              MATL_CLASS_ID,
              CODE,
              TYPE
         FROM ITPRCL
        WHERE PART_NO = ASPARTNO2);

   FUNCTION EXISTSTRANSLATION (ASPARTNO          IAPITYPE.PARTNO_TYPE,
                               ANREVISION        IAPITYPE.REVISION_TYPE,
                               ANSECTIONID       IAPITYPE.ID_TYPE,
                               ANSUBSECTIONID    IAPITYPE.ID_TYPE,
                               ANTEXTTYPE        IAPITYPE.ID_TYPE,
                               ANLANGUAGEID      IAPITYPE.LANGUAGEID_TYPE)
      RETURN INTEGER
   IS
      V_COUNTER   NUMBER := 800;
   BEGIN
      BEGIN
         SELECT COUNT ( * )
           INTO V_COUNTER
           FROM SPECIFICATION_TEXT
          WHERE     PART_NO = ASPARTNO
                AND REVISION = ANREVISION
                AND SECTION_ID = ANSECTIONID
                AND SUB_SECTION_ID = ANSUBSECTIONID
                AND TEXT_TYPE = ANTEXTTYPE
                AND LANG_ID = ANLANGUAGEID;
      EXCEPTION
         WHEN OTHERS
         THEN
            RETURN 1;
      END;

      IF V_COUNTER = 0
      THEN
         RETURN 1;
      ELSE
         RETURN ANLANGUAGEID;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 1;
   END EXISTSTRANSLATION;
BEGIN
   IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
   THEN
      LNRETVAL :=
         IAPIGENERAL.SETERRORTEXTANDLOGINFO (
            LSSOURCE,
            '',
            IAPICONSTANTDBERROR.DBERR_NOINITSESSION);
      RAISE_APPLICATION_ERROR (-20000, IAPIGENERAL.GETLASTERRORTEXT ());
   END IF;

   
   SELECT SPEC_COMP_SEQ.NEXTVAL INTO ANUNIQUEID FROM DUAL;

   
   IF ANLANGUAGEID1 = 0
   THEN
      V_LANG_ID1 := 1;
   ELSE
      V_LANG_ID1 := ANLANGUAGEID1;
   END IF;

   IF ANLANGUAGEID2 = 0
   THEN
      V_LANG_ID2 := 1;
   ELSE
      V_LANG_ID2 := ANLANGUAGEID2;
   END IF;

   
   FOR REC_KW IN CUR_KW
   LOOP
      IF REC_KW.KW_VALUE <> REC_KW.KW_VAL2
      THEN
         INSERT INTO ITSHCMP (COMP_NO,
                              SECTION_ID,
                              SUB_SECTION_ID,
                              TYPE,
                              REF_ID)
             VALUES (ANUNIQUEID,
                     -1,
                     0,
                     -2,
                     0);

         EXIT;
      END IF;
   END LOOP;

   
   FOR REC_CL IN CUR_CL
   LOOP
      INSERT INTO ITSHCMP (COMP_NO,
                           SECTION_ID,
                           SUB_SECTION_ID,
                           TYPE,
                           REF_ID)
          VALUES (ANUNIQUEID,
                  -2,
                  0,
                  -1,
                  0);

      EXIT;
   END LOOP;

   
   INSERT INTO ITSHCMP (COMP_NO,
                        SECTION_ID,
                        SUB_SECTION_ID,
                        TYPE,
                        REF_ID)
       VALUES (ANUNIQUEID,
               0,
               0,
               0,
               0);

   
   IF V_LANG_ID1 <> 1 OR V_LANG_ID2 <> 1
   THEN
      FOR REC_PG IN CUR_PG_LANG (V_LANG_ID1, V_LANG_ID2)
      LOOP
         INSERT INTO ITSHCMP (COMP_NO,
                              SECTION_ID,
                              SUB_SECTION_ID,
                              TYPE,
                              REF_ID)
             VALUES (ANUNIQUEID,
                     REC_PG.SECTION_ID,
                     REC_PG.SUB_SECTION_ID,
                     REC_PG.TYPE,
                     REC_PG.REF_ID);
      END LOOP;
   ELSE
      FOR REC_PG IN CUR_PG
      LOOP
         INSERT INTO ITSHCMP (COMP_NO,
                              SECTION_ID,
                              SUB_SECTION_ID,
                              TYPE,
                              REF_ID)
             VALUES (ANUNIQUEID,
                     REC_PG.SECTION_ID,
                     REC_PG.SUB_SECTION_ID,
                     REC_PG.TYPE,
                     REC_PG.REF_ID);
      END LOOP;
   END IF;

   FOR REC_TM IN CUR_TM
   LOOP
      BEGIN
         INSERT INTO ITSHCMP (COMP_NO,
                              SECTION_ID,
                              SUB_SECTION_ID,
                              TYPE,
                              REF_ID)
             VALUES (ANUNIQUEID,
                     REC_TM.SECTION_ID,
                     REC_TM.SUB_SECTION_ID,
                     REC_TM.REF_TYPE,
                     REC_TM.REF_ID);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            
            NULL;
      END;
   END LOOP;

   FOR REC_TM IN CUR_TM_DET
   LOOP
      BEGIN
         INSERT INTO ITSHCMP (COMP_NO,
                              SECTION_ID,
                              SUB_SECTION_ID,
                              TYPE,
                              REF_ID)
             VALUES (ANUNIQUEID,
                     REC_TM.SECTION_ID,
                     REC_TM.SUB_SECTION_ID,
                     REC_TM.REF_TYPE,
                     REC_TM.REF_ID);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            
            NULL;
      END;
   END LOOP;

   FOR REC_INFO IN CUR_INFO
   LOOP
      BEGIN
         
         INSERT INTO ITSHCMP (COMP_NO,
                              SECTION_ID,
                              SUB_SECTION_ID,
                              TYPE,
                              REF_ID,
                              REF_INFO,
                              PROPERTY_GROUP,
                              PROPERTY,
                              ATTRIBUTE)
             VALUES (ANUNIQUEID,
                     REC_INFO.SECTION_ID,
                     REC_INFO.SUB_SECTION_ID,
                     REC_INFO.REF_TYPE,
                     REC_INFO.REF_ID,
                     REC_INFO.PROPERTY + REC_INFO.ATTRIBUTE,
                     REC_INFO.PROPERTY_GROUP,
                     REC_INFO.PROPERTY,
                     REC_INFO.ATTRIBUTE);
      EXCEPTION
         WHEN OTHERS
         THEN
            
            NULL;
      END;
   END LOOP;

   
   
   
   IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
   THEN
      FOR REC_PL IN CUR_PL_PA
      LOOP
         INSERT INTO ITSHCMP (COMP_NO,
                              SECTION_ID,
                              SUB_SECTION_ID,
                              PLANT,
                              LINE,
                              CONFIGURATION,
                              TYPE,
                              REF_ID,
                              PROPERTY_GROUP)
             VALUES (ANUNIQUEID,
                     REC_PL.SECTION_ID,
                     REC_PL.SUB_SECTION_ID,
                     REC_PL.PLANT,
                     REC_PL.LINE,
                     REC_PL.CONFIGURATION,
                     REC_PL.TYPE,
                     REC_PL.STAGE,
                     REC_PL.STAGE);
      END LOOP;
   ELSE
      
      FOR REC_PL IN CUR_PL
      LOOP
         INSERT INTO ITSHCMP (COMP_NO,
                              SECTION_ID,
                              SUB_SECTION_ID,
                              PLANT,
                              LINE,
                              CONFIGURATION,
                              TYPE,
                              REF_ID,
                              PROPERTY_GROUP)
             VALUES (ANUNIQUEID,
                     REC_PL.SECTION_ID,
                     REC_PL.SUB_SECTION_ID,
                     REC_PL.PLANT,
                     REC_PL.LINE,
                     REC_PL.CONFIGURATION,
                     REC_PL.TYPE,
                     REC_PL.STAGE,
                     REC_PL.STAGE);
      END LOOP;
   END IF;

   
   
   
   FOR REC_SC IN CUR_SC
   LOOP
      INSERT INTO ITSHCMP (COMP_NO,
                           SECTION_ID,
                           SUB_SECTION_ID,
                           TYPE,
                           REF_ID,
                           REF_VER,
                           REF_OWNER,
                           REF_INFO)
          VALUES (ANUNIQUEID,
                  REC_SC.SECTION_ID,
                  REC_SC.SUB_SECTION_ID,
                  REC_SC.TYPE,
                  REC_SC.REF_ID,
                  REC_SC.REF_VERSION,
                  REC_SC.REF_OWNER,
                  REC_SC.REF_INFO);
   END LOOP;

   FOR REC_FREE_TEXT IN CUR_FREE_TEXT
   LOOP
      IF ANLANGUAGEID1 > 1
      THEN
         V_LANG_ID :=
            EXISTSTRANSLATION (ASPARTNO1,
                               ANREVISION1,
                               REC_FREE_TEXT.SECTION_ID,
                               REC_FREE_TEXT.SUB_SECTION_ID,
                               REC_FREE_TEXT.REF_ID,
                               ANLANGUAGEID1);
      ELSE
         V_LANG_ID := 1;
      END IF;

      BEGIN
         SELECT TEXT
           INTO L_TEXT1
           FROM SPECIFICATION_TEXT
          WHERE     TEXT_TYPE = REC_FREE_TEXT.REF_ID
                AND PART_NO = ASPARTNO1
                AND REVISION = ANREVISION1
                AND SECTION_ID = REC_FREE_TEXT.SECTION_ID
                AND SUB_SECTION_ID = REC_FREE_TEXT.SUB_SECTION_ID
                AND LANG_ID = V_LANG_ID;
      EXCEPTION
         WHEN OTHERS
         THEN
            L_TEXT1 := 'no data';
      END;

      IF ANLANGUAGEID2 > 1
      THEN
         V_LANG_ID :=
            EXISTSTRANSLATION (ASPARTNO2,
                               ANREVISION2,
                               REC_FREE_TEXT.SECTION_ID,
                               REC_FREE_TEXT.SUB_SECTION_ID,
                               REC_FREE_TEXT.REF_ID,
                               ANLANGUAGEID2);
      ELSE
         V_LANG_ID := 1;
      END IF;

      BEGIN
         SELECT TEXT
           INTO L_TEXT2
           FROM SPECIFICATION_TEXT
          WHERE     TEXT_TYPE = REC_FREE_TEXT.REF_ID
                AND PART_NO = ASPARTNO2
                AND REVISION = ANREVISION2
                AND SECTION_ID = REC_FREE_TEXT.SECTION_ID
                AND SUB_SECTION_ID = REC_FREE_TEXT.SUB_SECTION_ID
                AND LANG_ID = V_LANG_ID;
      EXCEPTION
         WHEN OTHERS
         THEN
            L_TEXT2 := 'no data';
      END;

      IF NVL (L_TEXT1, '?') <> NVL (L_TEXT2, '?')
      THEN
         BEGIN
            INSERT INTO ITSHCMP (COMP_NO,
                                 SECTION_ID,
                                 SUB_SECTION_ID,
                                 TYPE,
                                 REF_ID)
                VALUES (ANUNIQUEID,
                        REC_FREE_TEXT.SECTION_ID,
                        REC_FREE_TEXT.SUB_SECTION_ID,
                        IAPICONSTANT.SECTIONTYPE_FREETEXT,
                        REC_FREE_TEXT.REF_ID);
         EXCEPTION
            WHEN OTHERS
            THEN
               NULL;
         END;
      END IF;
   END LOOP;

   
   FOR REC_STAGE_TEXT IN CUR_STAGE_TEXT
   LOOP
      BEGIN
         SELECT TEXT
           INTO L_TEXT1
           FROM SPECIFICATION_LINE_TEXT
          WHERE     TEXT_TYPE = REC_STAGE_TEXT.TEXT_TYPE
                AND PART_NO = ASPARTNO1
                AND REVISION = ANREVISION1
                AND PLANT = REC_STAGE_TEXT.PLANT
                AND LINE = REC_STAGE_TEXT.LINE
                AND CONFIGURATION = REC_STAGE_TEXT.CONFIGURATION
                AND STAGE = REC_STAGE_TEXT.STAGE;
      EXCEPTION
         WHEN OTHERS
         THEN
            L_TEXT1 := 'no data';
      END;

      BEGIN
         SELECT TEXT
           INTO L_TEXT2
           FROM SPECIFICATION_LINE_TEXT
          WHERE     TEXT_TYPE = REC_STAGE_TEXT.TEXT_TYPE
                AND PART_NO = ASPARTNO2
                AND REVISION = ANREVISION2
                AND PLANT = REC_STAGE_TEXT.PLANT
                AND LINE = REC_STAGE_TEXT.LINE
                AND CONFIGURATION = REC_STAGE_TEXT.CONFIGURATION
                AND STAGE = REC_STAGE_TEXT.STAGE;
      EXCEPTION
         WHEN OTHERS
         THEN
            L_TEXT2 := 'no data';
      END;

      IF NVL (L_TEXT1, '?') <> NVL (L_TEXT2, '?')
      THEN
         BEGIN
            INSERT INTO ITSHCMP (COMP_NO,
                                 SECTION_ID,
                                 SUB_SECTION_ID,
                                 PLANT,
                                 LINE,
                                 CONFIGURATION,
                                 TYPE,
                                 PROPERTY_GROUP,
                                 REF_ID)
                VALUES (ANUNIQUEID,
                        REC_STAGE_TEXT.SECTION_ID,
                        -1,
                        REC_STAGE_TEXT.PLANT,
                        REC_STAGE_TEXT.LINE,
                        REC_STAGE_TEXT.CONFIGURATION,
                        IAPICONSTANT.SECTIONTYPE_PROCESSDATA,
                        REC_STAGE_TEXT.STAGE,
                        REC_STAGE_TEXT.TEXT_TYPE);
         EXCEPTION
            WHEN OTHERS
            THEN
               NULL;
         END;
      END IF;
   END LOOP;

   
   FOR REC_BOM IN CUR_BOM
   LOOP
      DBMS_OUTPUT.PUT_LINE (' rec_bom ' || REC_BOM.REF_ID);

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
      THEN
         BEGIN
            BEGIN
               SELECT 'x'
                 INTO L_BOM_CHECK
                 FROM DUAL
                WHERE EXISTS
                         (SELECT    BH.PLANT
                                 || BH.ALTERNATIVE
                                 || BH.BOM_USAGE
                                 || BH.BASE_QUANTITY
                                 || BH.DESCRIPTION
                                 || BH.YIELD
                                 || BH.CONV_FACTOR
                                 || BH.TO_UNIT
                                 || BH.MIN_QTY
                                 || BH.MAX_QTY
                                 || BH.CALC_FLAG
                                 || BH.BOM_TYPE
                                 || BH.PLANT_EFFECTIVE_DATE
                                 || BH.PREFERRED
                            FROM PART_PLANT PP, ITUP UP, BOM_HEADER BH
                           WHERE     PP.PLANT_ACCESS = 'Y'
                                 AND PP.PLANT = UP.PLANT
                                 AND PP.PLANT = BH.PLANT
                                 AND PP.PART_NO = BH.PART_NO
                                 
                                 AND UP.USER_ID =
                                       IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
                                 
                                 AND BH.REVISION = ANREVISION1
                                 AND BH.PART_NO = ASPARTNO1
                          MINUS
                          SELECT    BH.PLANT
                                 || BH.ALTERNATIVE
                                 || BH.BOM_USAGE
                                 || BH.BASE_QUANTITY
                                 || BH.DESCRIPTION
                                 || BH.YIELD
                                 || BH.CONV_FACTOR
                                 || BH.TO_UNIT
                                 || BH.MIN_QTY
                                 || BH.MAX_QTY
                                 || BH.CALC_FLAG
                                 || BH.BOM_TYPE
                                 || BH.PLANT_EFFECTIVE_DATE
                                 || BH.PREFERRED
                            FROM PART_PLANT PP, ITUP UP, BOM_HEADER BH
                           WHERE     PP.PLANT_ACCESS = 'Y'
                                 AND PP.PLANT = UP.PLANT
                                 AND PP.PLANT = BH.PLANT
                                 AND PP.PART_NO = BH.PART_NO
                                 
                                 AND UP.USER_ID =
                                       IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
                                 
                                 AND BH.REVISION = ANREVISION2
                                 AND BH.PART_NO = ASPARTNO2);
            EXCEPTION
               WHEN OTHERS
               THEN
                  BEGIN
                     SELECT 'x'
                       INTO L_BOM_CHECK
                       FROM DUAL
                      WHERE EXISTS
                               (SELECT    BI.PLANT
                                       || BI.ALTERNATIVE
                                       || BI.ITEM_NUMBER
                                       || BI.COMPONENT_PART
                                       || BI.COMPONENT_REVISION
                                       || BI.COMPONENT_PLANT
                                       || BI.QUANTITY
                                       || BI.UOM
                                       || BI.CONV_FACTOR
                                       || BI.TO_UNIT
                                       || BI.YIELD
                                       || BI.ASSEMBLY_SCRAP
                                       || BI.COMPONENT_SCRAP
                                       || BI.LEAD_TIME_OFFSET
                                       || BI.ITEM_CATEGORY
                                       || BI.ISSUE_LOCATION
                                       || BI.CALC_FLAG
                                       || BI.BOM_ITEM_TYPE
                                       || BI.OPERATIONAL_STEP
                                       || BI.BOM_USAGE
                                       || BI.MIN_QTY
                                       || BI.MAX_QTY
                                       || BI.CHAR_1
                                       || BI.CHAR_2
                                       || BI.CODE
                                       || BI.ALT_GROUP
                                       || BI.ALT_PRIORITY
                                       || BI.NUM_1
                                       || BI.NUM_2
                                       || BI.NUM_3
                                       || BI.NUM_4
                                       || BI.NUM_5
                                       || BI.CHAR_3
                                       || BI.CHAR_4
                                       || BI.CHAR_5
                                       || BI.DATE_1
                                       || BI.DATE_2
                                       || BI.CH_1
                                       || BI.CH_REV_1
                                       || BI.CH_2
                                       || BI.CH_REV_2
                                       || BI.CH_3
                                       || BI.CH_REV_3
                                       || BI.BOOLEAN_1
                                       || BI.BOOLEAN_2
                                       || BI.BOOLEAN_3
                                       || BI.BOOLEAN_4
                                       || BI.MAKE_UP
                                       || BI.INTL_EQUIVALENT
                                       || BI.RELEVENCY_TO_COSTING
                                       || BI.BULK_MATERIAL
                                       || BI.FIXED_QTY
                                  FROM PART_PLANT PP, ITUP UP, BOM_ITEM BI
                                 WHERE     PP.PLANT_ACCESS = 'Y'
                                       AND PP.PLANT = UP.PLANT
                                       AND PP.PLANT = BI.PLANT
                                       AND PP.PART_NO = BI.PART_NO
                                       
                                       AND UP.USER_ID =
                                             IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
                                       
                                       AND BI.REVISION = ANREVISION1
                                       AND BI.PART_NO = ASPARTNO1
                                MINUS
                                SELECT    BI.PLANT
                                       || BI.ALTERNATIVE
                                       || BI.ITEM_NUMBER
                                       || BI.COMPONENT_PART
                                       || BI.COMPONENT_REVISION
                                       || BI.COMPONENT_PLANT
                                       || BI.QUANTITY
                                       || BI.UOM
                                       || BI.CONV_FACTOR
                                       || BI.TO_UNIT
                                       || BI.YIELD
                                       || BI.ASSEMBLY_SCRAP
                                       || BI.COMPONENT_SCRAP
                                       || BI.LEAD_TIME_OFFSET
                                       || BI.ITEM_CATEGORY
                                       || BI.ISSUE_LOCATION
                                       || BI.CALC_FLAG
                                       || BI.BOM_ITEM_TYPE
                                       || BI.OPERATIONAL_STEP
                                       || BI.BOM_USAGE
                                       || BI.MIN_QTY
                                       || BI.MAX_QTY
                                       || BI.CHAR_1
                                       || BI.CHAR_2
                                       || BI.CODE
                                       || BI.ALT_GROUP
                                       || BI.ALT_PRIORITY
                                       || BI.NUM_1
                                       || BI.NUM_2
                                       || BI.NUM_3
                                       || BI.NUM_4
                                       || BI.NUM_5
                                       || BI.CHAR_3
                                       || BI.CHAR_4
                                       || BI.CHAR_5
                                       || BI.DATE_1
                                       || BI.DATE_2
                                       || BI.CH_1
                                       || BI.CH_REV_1
                                       || BI.CH_2
                                       || BI.CH_REV_2
                                       || BI.CH_3
                                       || BI.CH_REV_3
                                       || BI.BOOLEAN_1
                                       || BI.BOOLEAN_2
                                       || BI.BOOLEAN_3
                                       || BI.BOOLEAN_4
                                       || BI.MAKE_UP
                                       || BI.INTL_EQUIVALENT
                                       || BI.RELEVENCY_TO_COSTING
                                       || BI.BULK_MATERIAL
                                       || BI.FIXED_QTY
                                  FROM PART_PLANT PP, ITUP UP, BOM_ITEM BI
                                 WHERE     PP.PLANT_ACCESS = 'Y'
                                       AND PP.PLANT = UP.PLANT
                                       AND PP.PLANT = BI.PLANT
                                       AND PP.PART_NO = BI.PART_NO
                                       
                                       AND UP.USER_ID =
                                             IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
                                       
                                       AND BI.REVISION = ANREVISION2
                                       AND BI.PART_NO = ASPARTNO2);
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        
                        SELECT 'x'
                          INTO L_BOM_CHECK
                          FROM DUAL
                         WHERE EXISTS
                                  (SELECT    BI.PLANT
                                          || BI.ALTERNATIVE
                                          || BI.ITEM_NUMBER
                                          || BI.COMPONENT_PART
                                          || BI.COMPONENT_REVISION
                                          || BI.COMPONENT_PLANT
                                          || BI.QUANTITY
                                          || BI.UOM
                                          || BI.CONV_FACTOR
                                          || BI.TO_UNIT
                                          || BI.YIELD
                                          || BI.ASSEMBLY_SCRAP
                                          || BI.COMPONENT_SCRAP
                                          || BI.LEAD_TIME_OFFSET
                                          || BI.ITEM_CATEGORY
                                          || BI.ISSUE_LOCATION
                                          || BI.CALC_FLAG
                                          || BI.BOM_ITEM_TYPE
                                          || BI.OPERATIONAL_STEP
                                          || BI.BOM_USAGE
                                          || BI.MIN_QTY
                                          || BI.MAX_QTY
                                          || BI.CHAR_1
                                          || BI.CHAR_2
                                          || BI.CODE
                                          || BI.ALT_GROUP
                                          || BI.ALT_PRIORITY
                                          || BI.NUM_1
                                          || BI.NUM_2
                                          || BI.NUM_3
                                          || BI.NUM_4
                                          || BI.NUM_5
                                          || BI.CHAR_3
                                          || BI.CHAR_4
                                          || BI.CHAR_5
                                          || BI.DATE_1
                                          || BI.DATE_2
                                          || BI.CH_1
                                          || BI.CH_REV_1
                                          || BI.CH_2
                                          || BI.CH_REV_2
                                          || BI.CH_3
                                          || BI.CH_REV_3
                                          || BI.BOOLEAN_1
                                          || BI.BOOLEAN_2
                                          || BI.BOOLEAN_3
                                          || BI.BOOLEAN_4
                                          || BI.MAKE_UP
                                          || BI.INTL_EQUIVALENT
                                          || BI.RELEVENCY_TO_COSTING
                                          || BI.BULK_MATERIAL
                                          || BI.FIXED_QTY
                                     FROM PART_PLANT PP, ITUP UP, BOM_ITEM BI
                                    WHERE     PP.PLANT_ACCESS = 'Y'
                                          AND PP.PLANT = UP.PLANT
                                          AND PP.PLANT = BI.PLANT
                                          AND PP.PART_NO = BI.PART_NO
                                          
                                          AND UP.USER_ID =
                                                IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
                                          
                                          AND BI.REVISION = ANREVISION2
                                          AND BI.PART_NO = ASPARTNO2
                                   MINUS
                                   SELECT    BI.PLANT
                                          || BI.ALTERNATIVE
                                          || BI.ITEM_NUMBER
                                          || BI.COMPONENT_PART
                                          || BI.COMPONENT_REVISION
                                          || BI.COMPONENT_PLANT
                                          || BI.QUANTITY
                                          || BI.UOM
                                          || BI.CONV_FACTOR
                                          || BI.TO_UNIT
                                          || BI.YIELD
                                          || BI.ASSEMBLY_SCRAP
                                          || BI.COMPONENT_SCRAP
                                          || BI.LEAD_TIME_OFFSET
                                          || BI.ITEM_CATEGORY
                                          || BI.ISSUE_LOCATION
                                          || BI.CALC_FLAG
                                          || BI.BOM_ITEM_TYPE
                                          || BI.OPERATIONAL_STEP
                                          || BI.BOM_USAGE
                                          || BI.MIN_QTY
                                          || BI.MAX_QTY
                                          || BI.CHAR_1
                                          || BI.CHAR_2
                                          || BI.CODE
                                          || BI.ALT_GROUP
                                          || BI.ALT_PRIORITY
                                          || BI.NUM_1
                                          || BI.NUM_2
                                          || BI.NUM_3
                                          || BI.NUM_4
                                          || BI.NUM_5
                                          || BI.CHAR_3
                                          || BI.CHAR_4
                                          || BI.CHAR_5
                                          || BI.DATE_1
                                          || BI.DATE_2
                                          || BI.CH_1
                                          || BI.CH_REV_1
                                          || BI.CH_2
                                          || BI.CH_REV_2
                                          || BI.CH_3
                                          || BI.CH_REV_3
                                          || BI.BOOLEAN_1
                                          || BI.BOOLEAN_2
                                          || BI.BOOLEAN_3
                                          || BI.BOOLEAN_4
                                          || BI.MAKE_UP
                                          || BI.INTL_EQUIVALENT
                                          || BI.RELEVENCY_TO_COSTING
                                          || BI.BULK_MATERIAL
                                          || BI.FIXED_QTY
                                     FROM PART_PLANT PP, ITUP UP, BOM_ITEM BI
                                    WHERE     PP.PLANT_ACCESS = 'Y'
                                          AND PP.PLANT = UP.PLANT
                                          AND PP.PLANT = BI.PLANT
                                          AND PP.PART_NO = BI.PART_NO
                                          
                                          AND UP.USER_ID =
                                                IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
                                          
                                          AND BI.REVISION = ANREVISION1
                                          AND BI.PART_NO = ASPARTNO1);
                  END;
            END;

            IF L_BOM_CHECK = 'x'
            THEN
               DBMS_OUTPUT.PUT_LINE (' rec_bom check III ' || REC_BOM.REF_ID);

               BEGIN
                  INSERT INTO ITSHCMP (COMP_NO,
                                       SECTION_ID,
                                       SUB_SECTION_ID,
                                       TYPE,
                                       REF_ID)
                      VALUES (ANUNIQUEID,
                              REC_BOM.SECTION_ID,
                              REC_BOM.SUB_SECTION_ID,
                              IAPICONSTANT.SECTIONTYPE_BOM,
                              REC_BOM.REF_ID);
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     NULL;
               END;
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               


               DBMS_OUTPUT.PUT_LINE (' 12 ' || SQLERRM);
         END;
      ELSE
         BEGIN
            BEGIN
               SELECT 'x'
                 INTO L_BOM_CHECK
                 FROM DUAL
                WHERE EXISTS
                         (SELECT    PLANT
                                 || ALTERNATIVE
                                 || BOM_USAGE
                                 || BASE_QUANTITY
                                 || DESCRIPTION
                                 || YIELD
                                 || CONV_FACTOR
                                 || TO_UNIT
                                 || MIN_QTY
                                 || MAX_QTY
                                 || CALC_FLAG
                                 || BOM_TYPE
                                 || PLANT_EFFECTIVE_DATE
                                 || PREFERRED
                            FROM BOM_HEADER
                           WHERE PART_NO = ASPARTNO1
                                 AND REVISION = ANREVISION1
                          MINUS
                          SELECT    PLANT
                                 || ALTERNATIVE
                                 || BOM_USAGE
                                 || BASE_QUANTITY
                                 || DESCRIPTION
                                 || YIELD
                                 || CONV_FACTOR
                                 || TO_UNIT
                                 || MIN_QTY
                                 || MAX_QTY
                                 || CALC_FLAG
                                 || BOM_TYPE
                                 || PLANT_EFFECTIVE_DATE
                                 || PREFERRED
                            FROM BOM_HEADER
                           WHERE PART_NO = ASPARTNO2
                                 AND REVISION = ANREVISION2);
            EXCEPTION
               WHEN OTHERS
               THEN
                  BEGIN
                     SELECT 'x'
                       INTO L_BOM_CHECK
                       FROM DUAL
                      WHERE EXISTS
                               (SELECT    BI.PLANT
                                       || BI.ALTERNATIVE
                                       || BI.ITEM_NUMBER
                                       || BI.COMPONENT_PART
                                       || BI.COMPONENT_REVISION
                                       || BI.COMPONENT_PLANT
                                       || BI.QUANTITY
                                       || BI.UOM
                                       || BI.CONV_FACTOR
                                       || BI.TO_UNIT
                                       || BI.YIELD
                                       || BI.ASSEMBLY_SCRAP
                                       || BI.COMPONENT_SCRAP
                                       || BI.LEAD_TIME_OFFSET
                                       || BI.ITEM_CATEGORY
                                       || BI.ISSUE_LOCATION
                                       || BI.CALC_FLAG
                                       || BI.BOM_ITEM_TYPE
                                       || BI.OPERATIONAL_STEP
                                       || BI.BOM_USAGE
                                       || BI.MIN_QTY
                                       || BI.MAX_QTY
                                       || BI.CHAR_1
                                       || BI.CHAR_2
                                       || BI.CODE
                                       || BI.ALT_GROUP
                                       || BI.ALT_PRIORITY
                                       || BI.NUM_1
                                       || BI.NUM_2
                                       || BI.NUM_3
                                       || BI.NUM_4
                                       || BI.NUM_5
                                       || BI.CHAR_3
                                       || BI.CHAR_4
                                       || BI.CHAR_5
                                       || BI.DATE_1
                                       || BI.DATE_2
                                       || BI.CH_1
                                       || BI.CH_REV_1
                                       || BI.CH_2
                                       || BI.CH_REV_2
                                       || BI.CH_3
                                       || BI.CH_REV_3
                                       || BI.BOOLEAN_1
                                       || BI.BOOLEAN_2
                                       || BI.BOOLEAN_3
                                       || BI.BOOLEAN_4
                                       || BI.MAKE_UP
                                       || BI.INTL_EQUIVALENT
                                       || BI.RELEVENCY_TO_COSTING
                                       || BI.BULK_MATERIAL
                                       || BI.FIXED_QTY
                                  FROM BOM_ITEM BI
                                 WHERE PART_NO = ASPARTNO1
                                       AND REVISION = ANREVISION1
                                MINUS
                                SELECT    BI.PLANT
                                       || BI.ALTERNATIVE
                                       || BI.ITEM_NUMBER
                                       || BI.COMPONENT_PART
                                       || BI.COMPONENT_REVISION
                                       || BI.COMPONENT_PLANT
                                       || BI.QUANTITY
                                       || BI.UOM
                                       || BI.CONV_FACTOR
                                       || BI.TO_UNIT
                                       || BI.YIELD
                                       || BI.ASSEMBLY_SCRAP
                                       || BI.COMPONENT_SCRAP
                                       || BI.LEAD_TIME_OFFSET
                                       || BI.ITEM_CATEGORY
                                       || BI.ISSUE_LOCATION
                                       || BI.CALC_FLAG
                                       || BI.BOM_ITEM_TYPE
                                       || BI.OPERATIONAL_STEP
                                       || BI.BOM_USAGE
                                       || BI.MIN_QTY
                                       || BI.MAX_QTY
                                       || BI.CHAR_1
                                       || BI.CHAR_2
                                       || BI.CODE
                                       || BI.ALT_GROUP
                                       || BI.ALT_PRIORITY
                                       || BI.NUM_1
                                       || BI.NUM_2
                                       || BI.NUM_3
                                       || BI.NUM_4
                                       || BI.NUM_5
                                       || BI.CHAR_3
                                       || BI.CHAR_4
                                       || BI.CHAR_5
                                       || BI.DATE_1
                                       || BI.DATE_2
                                       || BI.CH_1
                                       || BI.CH_REV_1
                                       || BI.CH_2
                                       || BI.CH_REV_2
                                       || BI.CH_3
                                       || BI.CH_REV_3
                                       || BI.BOOLEAN_1
                                       || BI.BOOLEAN_2
                                       || BI.BOOLEAN_3
                                       || BI.BOOLEAN_4
                                       || BI.MAKE_UP
                                       || BI.INTL_EQUIVALENT
                                       || BI.RELEVENCY_TO_COSTING
                                       || BI.BULK_MATERIAL
                                       || BI.FIXED_QTY
                                  FROM BOM_ITEM BI
                                 WHERE PART_NO = ASPARTNO2
                                       AND REVISION = ANREVISION2);
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        
                        SELECT 'x'
                          INTO L_BOM_CHECK
                          FROM DUAL
                         WHERE EXISTS
                                  (SELECT    BI.PLANT
                                          || BI.ALTERNATIVE
                                          || BI.ITEM_NUMBER
                                          || BI.COMPONENT_PART
                                          || BI.COMPONENT_REVISION
                                          || BI.COMPONENT_PLANT
                                          || BI.QUANTITY
                                          || BI.UOM
                                          || BI.CONV_FACTOR
                                          || BI.TO_UNIT
                                          || BI.YIELD
                                          || BI.ASSEMBLY_SCRAP
                                          || BI.COMPONENT_SCRAP
                                          || BI.LEAD_TIME_OFFSET
                                          || BI.ITEM_CATEGORY
                                          || BI.ISSUE_LOCATION
                                          || BI.CALC_FLAG
                                          || BI.BOM_ITEM_TYPE
                                          || BI.OPERATIONAL_STEP
                                          || BI.BOM_USAGE
                                          || BI.MIN_QTY
                                          || BI.MAX_QTY
                                          || BI.CHAR_1
                                          || BI.CHAR_2
                                          || BI.CODE
                                          || BI.ALT_GROUP
                                          || BI.ALT_PRIORITY
                                          || BI.NUM_1
                                          || BI.NUM_2
                                          || BI.NUM_3
                                          || BI.NUM_4
                                          || BI.NUM_5
                                          || BI.CHAR_3
                                          || BI.CHAR_4
                                          || BI.CHAR_5
                                          || BI.DATE_1
                                          || BI.DATE_2
                                          || BI.CH_1
                                          || BI.CH_REV_1
                                          || BI.CH_2
                                          || BI.CH_REV_2
                                          || BI.CH_3
                                          || BI.CH_REV_3
                                          || BI.BOOLEAN_1
                                          || BI.BOOLEAN_2
                                          || BI.BOOLEAN_3
                                          || BI.BOOLEAN_4
                                          || BI.MAKE_UP
                                          || BI.INTL_EQUIVALENT
                                          || BI.RELEVENCY_TO_COSTING
                                          || BI.BULK_MATERIAL
                                          || BI.FIXED_QTY
                                     FROM BOM_ITEM BI
                                    WHERE PART_NO = ASPARTNO2
                                          AND REVISION = ANREVISION2
                                   MINUS
                                   SELECT    BI.PLANT
                                          || BI.ALTERNATIVE
                                          || BI.ITEM_NUMBER
                                          || BI.COMPONENT_PART
                                          || BI.COMPONENT_REVISION
                                          || BI.COMPONENT_PLANT
                                          || BI.QUANTITY
                                          || BI.UOM
                                          || BI.CONV_FACTOR
                                          || BI.TO_UNIT
                                          || BI.YIELD
                                          || BI.ASSEMBLY_SCRAP
                                          || BI.COMPONENT_SCRAP
                                          || BI.LEAD_TIME_OFFSET
                                          || BI.ITEM_CATEGORY
                                          || BI.ISSUE_LOCATION
                                          || BI.CALC_FLAG
                                          || BI.BOM_ITEM_TYPE
                                          || BI.OPERATIONAL_STEP
                                          || BI.BOM_USAGE
                                          || BI.MIN_QTY
                                          || BI.MAX_QTY
                                          || BI.CHAR_1
                                          || BI.CHAR_2
                                          || BI.CODE
                                          || BI.ALT_GROUP
                                          || BI.ALT_PRIORITY
                                          || BI.NUM_1
                                          || BI.NUM_2
                                          || BI.NUM_3
                                          || BI.NUM_4
                                          || BI.NUM_5
                                          || BI.CHAR_3
                                          || BI.CHAR_4
                                          || BI.CHAR_5
                                          || BI.DATE_1
                                          || BI.DATE_2
                                          || BI.CH_1
                                          || BI.CH_REV_1
                                          || BI.CH_2
                                          || BI.CH_REV_2
                                          || BI.CH_3
                                          || BI.CH_REV_3
                                          || BI.BOOLEAN_1
                                          || BI.BOOLEAN_2
                                          || BI.BOOLEAN_3
                                          || BI.BOOLEAN_4
                                          || BI.MAKE_UP
                                          || BI.INTL_EQUIVALENT
                                          || BI.RELEVENCY_TO_COSTING
                                          || BI.BULK_MATERIAL
                                          || BI.FIXED_QTY
                                     FROM BOM_ITEM BI
                                    WHERE PART_NO = ASPARTNO1
                                          AND REVISION = ANREVISION1);
                  END;
            END;

            IF L_BOM_CHECK = 'x'
            THEN
               DBMS_OUTPUT.PUT_LINE (' rec_bom check III ' || REC_BOM.REF_ID);

               BEGIN
                  INSERT INTO ITSHCMP (COMP_NO,
                                       SECTION_ID,
                                       SUB_SECTION_ID,
                                       TYPE,
                                       REF_ID)
                      VALUES (ANUNIQUEID,
                              REC_BOM.SECTION_ID,
                              REC_BOM.SUB_SECTION_ID,
                              IAPICONSTANT.SECTIONTYPE_BOM,
                              REC_BOM.REF_ID);
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     NULL;
               END;
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               


               DBMS_OUTPUT.PUT_LINE (' 12 ' || SQLERRM);
         END;
      END IF;
   END LOOP;

   FOR REC_ING IN CUR_ING
   LOOP
      BEGIN
         BEGIN
            SELECT 'x'
              INTO L_ING_CHECK
              FROM DUAL
             WHERE EXISTS
                      (SELECT    INGREDIENT
                              || QUANTITY
                              || ING_LEVEL
                              || ING_COMMENT
                              || INTL
                              || ACTIV_IND
                              || RECFAC
                              || ING_SYNONYM
                              || PID
                              || HIER_LEVEL
                              || INGDECLARE
                         FROM SPECIFICATION_ING
                        WHERE PART_NO = ASPARTNO1 AND REVISION = ANREVISION1
                       MINUS
                       SELECT    INGREDIENT
                              || QUANTITY
                              || ING_LEVEL
                              || ING_COMMENT
                              || INTL
                              || ACTIV_IND
                              || RECFAC
                              || ING_SYNONYM
                              || PID
                              || HIER_LEVEL
                              || INGDECLARE
                         FROM SPECIFICATION_ING
                        WHERE PART_NO = ASPARTNO2 AND REVISION = ANREVISION2);
         EXCEPTION
            WHEN OTHERS
            THEN
               BEGIN
                  SELECT 'x'
                    INTO L_ING_CHECK
                    FROM DUAL
                   WHERE EXISTS
                            (SELECT    INGREDIENT
                                    || QUANTITY
                                    || ING_LEVEL
                                    || ING_COMMENT
                                    || INTL
                                    || ACTIV_IND
                                    || RECFAC
                                    || ING_SYNONYM
                                    || PID
                                    || HIER_LEVEL
                                    || INGDECLARE
                               FROM SPECIFICATION_ING
                              WHERE PART_NO = ASPARTNO2
                                    AND REVISION = ANREVISION2
                             MINUS
                             SELECT    INGREDIENT
                                    || QUANTITY
                                    || ING_LEVEL
                                    || ING_COMMENT
                                    || INTL
                                    || ACTIV_IND
                                    || RECFAC
                                    || ING_SYNONYM
                                    || PID
                                    || HIER_LEVEL
                                    || INGDECLARE
                               FROM SPECIFICATION_ING
                              WHERE PART_NO = ASPARTNO1
                                    AND REVISION = ANREVISION1);
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     NULL;
               END;
         END;

         IF L_ING_CHECK = 'x'
         THEN
            BEGIN
               INSERT INTO ITSHCMP (COMP_NO,
                                    SECTION_ID,
                                    SUB_SECTION_ID,
                                    TYPE,
                                    REF_ID)
                   VALUES (ANUNIQUEID,
                           REC_ING.SECTION_ID,
                           REC_ING.SUB_SECTION_ID,
                           IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST,
                           REC_ING.REF_ID);
            EXCEPTION
               WHEN OTHERS
               THEN
                  NULL;
            END;
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            


            DBMS_OUTPUT.PUT_LINE (' 12 ing ' || SQLERRM);
      END;
   END LOOP;

   
   FOR REC_ING IN CUR_ING
   LOOP
      BEGIN
         BEGIN
            SELECT 'x'
              INTO L_ING_CHECK
              FROM DUAL
             WHERE EXISTS
                      ( (SELECT    SECTION_ID
                                || SUB_SECTION_ID
                                || INGREDIENT
                                || ALLERGEN
                           FROM ITSPECINGALLERGEN
                          WHERE PART_NO = ASPARTNO1
                                AND REVISION = ANREVISION1
                         UNION
                         SELECT    SI.SECTION_ID
                                || SI.SUB_SECTION_ID
                                || SI.INGREDIENT
                                || ALLERGEN
                           FROM ITINGALLERGEN AL, SPECIFICATION_ING SI
                          WHERE AL.INGREDIENT IN
                                      (SELECT INGREDIENT
                                         FROM SPECIFICATION_ING
                                        WHERE PART_NO = ASPARTNO1
                                              AND REVISION = ANREVISION1)
                                AND SI.PART_NO = ASPARTNO1
                                AND SI.REVISION = ANREVISION1)
                       MINUS
                       (SELECT    SECTION_ID
                               || SUB_SECTION_ID
                               || INGREDIENT
                               || ALLERGEN
                          FROM ITSPECINGALLERGEN
                         WHERE PART_NO = ASPARTNO2 AND REVISION = ANREVISION2
                        UNION
                        SELECT    SI.SECTION_ID
                               || SI.SUB_SECTION_ID
                               || SI.INGREDIENT
                               || ALLERGEN
                          FROM ITINGALLERGEN AL, SPECIFICATION_ING SI
                         WHERE AL.INGREDIENT IN
                                     (SELECT INGREDIENT
                                        FROM SPECIFICATION_ING
                                       WHERE PART_NO = ASPARTNO2
                                             AND REVISION = ANREVISION2)
                               AND SI.PART_NO = ASPARTNO2
                               AND SI.REVISION = ANREVISION2));
         EXCEPTION
            WHEN OTHERS
            THEN
               BEGIN
                  SELECT 'x'
                    INTO L_ING_CHECK
                    FROM DUAL
                   WHERE EXISTS
                            ( (SELECT    SECTION_ID
                                      || SUB_SECTION_ID
                                      || INGREDIENT
                                      || ALLERGEN
                                 FROM ITSPECINGALLERGEN
                                WHERE PART_NO = ASPARTNO2
                                      AND REVISION = ANREVISION2
                               UNION
                               SELECT    SI.SECTION_ID
                                      || SI.SUB_SECTION_ID
                                      || SI.INGREDIENT
                                      || ALLERGEN
                                 FROM ITINGALLERGEN AL, SPECIFICATION_ING SI
                                WHERE AL.INGREDIENT IN
                                            (SELECT INGREDIENT
                                               FROM SPECIFICATION_ING
                                              WHERE PART_NO = ASPARTNO2
                                                    AND REVISION =
                                                          ANREVISION2)
                                      AND SI.PART_NO = ASPARTNO2
                                      AND SI.REVISION = ANREVISION2)
                             MINUS
                             (SELECT    SECTION_ID
                                     || SUB_SECTION_ID
                                     || INGREDIENT
                                     || ALLERGEN
                                FROM ITSPECINGALLERGEN
                               WHERE PART_NO = ASPARTNO1
                                     AND REVISION = ANREVISION1
                              UNION
                              SELECT    SI.SECTION_ID
                                     || SI.SUB_SECTION_ID
                                     || SI.INGREDIENT
                                     || ALLERGEN
                                FROM ITINGALLERGEN AL, SPECIFICATION_ING SI
                               WHERE AL.INGREDIENT IN
                                           (SELECT INGREDIENT
                                              FROM SPECIFICATION_ING
                                             WHERE PART_NO = ASPARTNO1
                                                   AND REVISION = ANREVISION1)
                                     AND SI.PART_NO = ASPARTNO1
                                     AND SI.REVISION = ANREVISION1));
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     NULL;
               END;
         END;

         IF L_ING_CHECK = 'x'
         THEN
            BEGIN
               INSERT INTO ITSHCMP (COMP_NO,
                                    SECTION_ID,
                                    SUB_SECTION_ID,
                                    TYPE,
                                    REF_ID)
                   VALUES (ANUNIQUEID,
                           REC_ING.SECTION_ID,
                           REC_ING.SUB_SECTION_ID,
                           IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST,
                           REC_ING.REF_ID);
            EXCEPTION
               WHEN OTHERS
               THEN
                  NULL;
            END;
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            


            DBMS_OUTPUT.PUT_LINE (' 12 ing ' || SQLERRM);
      END;
   END LOOP;

   

   FOR REC_BN IN CUR_BN
   LOOP
      BEGIN
         BEGIN
            SELECT 'x'
              INTO L_ING_CHECK
              FROM DUAL
             WHERE EXISTS
                      (SELECT BASE_NAME_ID
                         FROM ITSHBN
                        WHERE     PART_NO = ASPARTNO1
                              AND REVISION = ANREVISION1
                              AND SECTION_ID = REC_BN.SECTION_ID
                              AND SUB_SECTION_ID = REC_BN.SUB_SECTION_ID
                       MINUS
                       SELECT BASE_NAME_ID
                         FROM ITSHBN
                        WHERE     PART_NO = ASPARTNO2
                              AND REVISION = ANREVISION2
                              AND SECTION_ID = REC_BN.SECTION_ID
                              AND SUB_SECTION_ID = REC_BN.SUB_SECTION_ID);
         EXCEPTION
            WHEN OTHERS
            THEN
               BEGIN
                  SELECT 'x'
                    INTO L_ING_CHECK
                    FROM DUAL
                   WHERE EXISTS
                            (SELECT BASE_NAME_ID
                               FROM ITSHBN
                              WHERE     PART_NO = ASPARTNO2
                                    AND REVISION = ANREVISION2
                                    AND SECTION_ID = REC_BN.SECTION_ID
                                    AND SUB_SECTION_ID =
                                          REC_BN.SUB_SECTION_ID
                             MINUS
                             SELECT BASE_NAME_ID
                               FROM ITSHBN
                              WHERE     PART_NO = ASPARTNO1
                                    AND REVISION = ANREVISION1
                                    AND SECTION_ID = REC_BN.SECTION_ID
                                    AND SUB_SECTION_ID =
                                          REC_BN.SUB_SECTION_ID);
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     NULL;
               END;
         END;

         IF L_ING_CHECK = 'x'
         THEN
            BEGIN
               INSERT INTO ITSHCMP (COMP_NO,
                                    SECTION_ID,
                                    SUB_SECTION_ID,
                                    TYPE,
                                    REF_ID)
                   VALUES (ANUNIQUEID,
                           REC_BN.SECTION_ID,
                           REC_BN.SUB_SECTION_ID,
                           IAPICONSTANT.SECTIONTYPE_BASENAME,
                           0);
            EXCEPTION
               WHEN OTHERS
               THEN
                  NULL;
            END;
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.PUT_LINE (' 12 bn ' || SQLERRM);
      END;
   END LOOP;

   FOR REC_ATT IN CUR_ATT
   LOOP
      
      
      L_ATT_CHECK := '';

      DBMS_OUTPUT.PUT_LINE (' rec_att ' || REC_ATT.SECTION_ID);

      BEGIN
         BEGIN
            SELECT 'x'
              INTO L_ATT_CHECK
              FROM DUAL
             WHERE EXISTS
                      (SELECT ATTACHED_PART_NO, ATTACHED_REVISION
                         FROM ATTACHED_SPECIFICATION
                        WHERE     PART_NO = ASPARTNO1
                              AND REVISION = ANREVISION1
                              AND SECTION_ID = REC_ATT.SECTION_ID
                              AND SUB_SECTION_ID = REC_ATT.SUB_SECTION_ID
                       MINUS
                       SELECT ATTACHED_PART_NO, ATTACHED_REVISION
                         FROM ATTACHED_SPECIFICATION
                        WHERE     PART_NO = ASPARTNO2
                              AND REVISION = ANREVISION2
                              AND SECTION_ID = REC_ATT.SECTION_ID
                              AND SUB_SECTION_ID = REC_ATT.SUB_SECTION_ID);
         EXCEPTION
            WHEN OTHERS
            THEN
               
               BEGIN
                  SELECT 'x'
                    INTO L_ATT_CHECK
                    FROM DUAL
                   WHERE EXISTS
                            (SELECT ATTACHED_PART_NO, ATTACHED_REVISION
                               FROM ATTACHED_SPECIFICATION
                              WHERE     PART_NO = ASPARTNO2
                                    AND REVISION = ANREVISION2
                                    AND SECTION_ID = REC_ATT.SECTION_ID
                                    AND SUB_SECTION_ID =
                                          REC_ATT.SUB_SECTION_ID
                             MINUS
                             SELECT ATTACHED_PART_NO, ATTACHED_REVISION
                               FROM ATTACHED_SPECIFICATION
                              WHERE     PART_NO = ASPARTNO1
                                    AND REVISION = ANREVISION1
                                    AND SECTION_ID = REC_ATT.SECTION_ID
                                    AND SUB_SECTION_ID =
                                          REC_ATT.SUB_SECTION_ID);
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     

                     NULL;
               END;
         END;

         IF L_ATT_CHECK = 'x'
         THEN
            BEGIN
               INSERT INTO ITSHCMP (COMP_NO,
                                    SECTION_ID,
                                    SUB_SECTION_ID,
                                    TYPE,
                                    REF_ID)
                   VALUES (ANUNIQUEID,
                           REC_ATT.SECTION_ID,
                           REC_ATT.SUB_SECTION_ID,
                           IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC,
                           0);
            EXCEPTION
               WHEN OTHERS
               THEN
                  NULL;
            END;
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            

            DBMS_OUTPUT.PUT_LINE ('12 ' || SQLERRM);
      END;
   END LOOP;
EXCEPTION
   WHEN OTHERS
   THEN
      IAPIGENERAL.LOGERROR (LSSOURCE, '', SQLERRM);
      LNRETVAL := IAPIGENERAL.SETERRORTEXT (IAPICONSTANTDBERROR.DBERR_GENFAIL);
      RAISE_APPLICATION_ERROR (-20000, IAPIGENERAL.GETLASTERRORTEXT ());
END SP_COMPARE_SPEC;
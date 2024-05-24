CREATE OR REPLACE PROCEDURE SP_COMPARE_FRAME(
   AI_COMP_NO                 IN OUT   ITSHCMP.COMP_NO%TYPE,
   AS_FRAME_NO1               IN       FRAME_HEADER.FRAME_NO%TYPE,
   AI_REVISION1               IN       FRAME_HEADER.REVISION%TYPE,
   AI_OWNER1                  IN       FRAME_HEADER.OWNER%TYPE,
   AS_FRAME_NO2               IN       FRAME_HEADER.FRAME_NO%TYPE,
   AI_REVISION2               IN       FRAME_HEADER.REVISION%TYPE,
   AI_OWNER2                  IN       FRAME_HEADER.OWNER%TYPE )
IS






















   
   L_TEXT1                       LONG;
   L_TEXT2                       LONG;

   
   CURSOR CUR_FREE_TEXT
   IS
      ( SELECT SECTION_ID,
               SUB_SECTION_ID,
               REF_ID
         FROM FRAME_SECTION
        WHERE FRAME_NO = AS_FRAME_NO1
          AND REVISION = AI_REVISION1
          AND OWNER = AI_OWNER1
          AND TYPE = 5
       UNION
       SELECT SECTION_ID,
              SUB_SECTION_ID,
              REF_ID
         FROM FRAME_SECTION
        WHERE FRAME_NO = AS_FRAME_NO2
          AND REVISION = AI_REVISION2
          AND OWNER = AI_OWNER2
          AND TYPE = 5 )
      MINUS
      SELECT SECTION_ID,
             SUB_SECTION_ID,
             REF_ID
        FROM ITSHCMP
       WHERE COMP_NO = AI_COMP_NO
         AND TYPE = 5;

   CURSOR CUR_PG
   IS
      SELECT DISTINCT SECTION_ID,
                      SUB_SECTION_ID,
                      TYPE,
                      DECODE( TYPE,
                              7, -2,
                              1, PROPERTY_GROUP,
                              PROPERTY ) REF_ID
                 FROM ( ( SELECT TYPE,
                                 SECTION_ID,
                                 SUB_SECTION_ID,
                                 PROPERTY_GROUP,
                                 PROPERTY,
                                 ATTRIBUTE,
                                 HEADER_ID,
                                 UOM_ID,
                                 TEST_METHOD,
                                 VALUE_S,
                                 ASSOCIATION
                           FROM FRAMEDATA
                          WHERE FRAME_NO = AS_FRAME_NO1
                            AND REVISION = AI_REVISION1
                            AND OWNER = AI_OWNER1
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
                                VALUE_S,
                                ASSOCIATION
                           FROM FRAMEDATA
                          WHERE FRAME_NO = AS_FRAME_NO2
                            AND REVISION = AI_REVISION2
                            AND OWNER = AI_OWNER2 )
                       UNION
                       ( SELECT TYPE,
                                SECTION_ID,
                                SUB_SECTION_ID,
                                PROPERTY_GROUP,
                                PROPERTY,
                                ATTRIBUTE,
                                HEADER_ID,
                                UOM_ID,
                                TEST_METHOD,
                                VALUE_S,
                                ASSOCIATION
                          FROM FRAMEDATA
                         WHERE FRAME_NO = AS_FRAME_NO2
                           AND REVISION = AI_REVISION2
                           AND OWNER = AI_OWNER2
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
                               VALUE_S,
                               ASSOCIATION
                          FROM FRAMEDATA
                         WHERE FRAME_NO = AS_FRAME_NO1
                           AND REVISION = AI_REVISION1
                           AND OWNER = AI_OWNER1 ) );

   CURSOR CUR_SC
   IS
      SELECT DISTINCT SECTION_ID,
                      SUB_SECTION_ID,
                      TYPE,
                      REF_ID,
                      NVL( REF_VER,
                           -1 ) REF_VER,
                      NVL( REF_OWNER,
                           -1 ) REF_OWNER,
                      NVL( REF_INFO,
                           -1 ) REF_INFO
                 FROM ( ( SELECT SECTION_ID,
                                 SUB_SECTION_ID,
                                 TYPE,
                                 REF_ID,
                                 REF_VER,
                                 REF_OWNER,
                                 REF_INFO
                           FROM FRAME_SECTION
                          WHERE FRAME_NO = AS_FRAME_NO1
                            AND REVISION = AI_REVISION1
                            AND OWNER = AI_OWNER1
                            AND TYPE NOT IN( 1, 4, 5 )
                         MINUS
                         SELECT SECTION_ID,
                                SUB_SECTION_ID,
                                TYPE,
                                REF_ID,
                                REF_VER,
                                REF_OWNER,
                                REF_INFO
                           FROM FRAME_SECTION
                          WHERE FRAME_NO = AS_FRAME_NO2
                            AND REVISION = AI_REVISION2
                            AND OWNER = AI_OWNER2
                            AND TYPE NOT IN( 1, 4, 5 ) )
                       UNION
                       ( SELECT SECTION_ID,
                                SUB_SECTION_ID,
                                TYPE,
                                REF_ID,
                                REF_VER,
                                REF_OWNER,
                                REF_INFO
                          FROM FRAME_SECTION
                         WHERE FRAME_NO = AS_FRAME_NO2
                           AND REVISION = AI_REVISION2
                           AND OWNER = AI_OWNER2
                           AND TYPE NOT IN( 1, 4, 5 )
                        MINUS
                        SELECT SECTION_ID,
                               SUB_SECTION_ID,
                               TYPE,
                               REF_ID,
                               REF_VER,
                               REF_OWNER,
                               REF_INFO
                          FROM FRAME_SECTION
                         WHERE FRAME_NO = AS_FRAME_NO1
                           AND REVISION = AI_REVISION1
                           AND OWNER = AI_OWNER1
                           AND TYPE NOT IN( 1, 4, 5 ) ) );

   CURSOR CUR_KW
   IS
      SELECT KW_ID,
             KW_VALUE,
             F_GET_FRAME_KEYWORD_VALUE( AS_FRAME_NO1,
                                        AI_OWNER1,
                                        KW_ID,
                                        KW_VALUE ) KW_VAL2
        FROM FRAME_KW
       WHERE FRAME_NO = AS_FRAME_NO2
         AND OWNER = AI_OWNER2
      UNION
      SELECT KW_ID,
             KW_VALUE,
             F_GET_FRAME_KEYWORD_VALUE( AS_FRAME_NO2,
                                        AI_OWNER2,
                                        KW_ID,
                                        KW_VALUE ) KW_VAL2
        FROM FRAME_KW
       WHERE FRAME_NO = AS_FRAME_NO1
         AND OWNER = AI_OWNER1;
BEGIN
   
   SELECT SPEC_COMP_SEQ.NEXTVAL
     INTO AI_COMP_NO
     FROM DUAL;

   DBMS_OUTPUT.PUT_LINE(    'compare sequence '
                         || AI_COMP_NO );

   
   FOR REC_KW IN CUR_KW
   LOOP
      IF REC_KW.KW_VALUE <> REC_KW.KW_VAL2
      THEN
         INSERT INTO ITSHCMP
                     ( COMP_NO,
                       SECTION_ID,
                       SUB_SECTION_ID,
                       TYPE,
                       REF_ID )
              VALUES ( AI_COMP_NO,
                       -1,
                       0,
                       -2,
                       0 );

         EXIT;
      END IF;
   END LOOP;

   
   INSERT INTO ITSHCMP
               ( COMP_NO,
                 SECTION_ID,
                 SUB_SECTION_ID,
                 TYPE,
                 REF_ID )
        VALUES ( AI_COMP_NO,
                 0,
                 0,
                 0,
                 0 );

   
   INSERT INTO ITSHCMP
               ( COMP_NO,
                 SECTION_ID,
                 SUB_SECTION_ID,
                 TYPE,
                 REF_ID )
        VALUES ( AI_COMP_NO,
                 -3,
                 0,
                 -3,
                 0 );

   
   FOR REC_PG IN CUR_PG
   LOOP
      INSERT INTO ITSHCMP
                  ( COMP_NO,
                    SECTION_ID,
                    SUB_SECTION_ID,
                    TYPE,
                    REF_ID )
           VALUES ( AI_COMP_NO,
                    REC_PG.SECTION_ID,
                    REC_PG.SUB_SECTION_ID,
                    REC_PG.TYPE,
                    REC_PG.REF_ID );
   END LOOP;

   
   FOR REC_SC IN CUR_SC
   LOOP
      INSERT INTO ITSHCMP
                  ( COMP_NO,
                    SECTION_ID,
                    SUB_SECTION_ID,
                    TYPE,
                    REF_ID,
                    REF_VER,
                    REF_OWNER,
                    REF_INFO )
           VALUES ( AI_COMP_NO,
                    REC_SC.SECTION_ID,
                    REC_SC.SUB_SECTION_ID,
                    REC_SC.TYPE,
                    REC_SC.REF_ID,
                    REC_SC.REF_VER,
                    REC_SC.REF_OWNER,
                    REC_SC.REF_INFO );
   END LOOP;

   FOR REC_FREE_TEXT IN CUR_FREE_TEXT
   LOOP
      BEGIN
         BEGIN
            SELECT TEXT
              INTO L_TEXT1
              FROM FRAME_TEXT
             WHERE TEXT_TYPE = REC_FREE_TEXT.REF_ID
               AND FRAME_NO = AS_FRAME_NO1
               AND REVISION = AI_REVISION1
               AND OWNER = AI_OWNER1
               AND SECTION_ID = REC_FREE_TEXT.SECTION_ID
               AND SUB_SECTION_ID = REC_FREE_TEXT.SUB_SECTION_ID;
         EXCEPTION
            WHEN OTHERS
            THEN
               L_TEXT1 := 'no data';
         END;

         BEGIN
            SELECT TEXT
              INTO L_TEXT2
              FROM FRAME_TEXT
             WHERE TEXT_TYPE = REC_FREE_TEXT.REF_ID
               AND FRAME_NO = AS_FRAME_NO2
               AND REVISION = AI_REVISION2
               AND OWNER = AI_OWNER2
               AND SECTION_ID = REC_FREE_TEXT.SECTION_ID
               AND SUB_SECTION_ID = REC_FREE_TEXT.SUB_SECTION_ID;
         EXCEPTION
            WHEN OTHERS
            THEN
               L_TEXT2 := 'no data';
         END;

         IF NVL( L_TEXT1,
                 '?' ) <> NVL( L_TEXT2,
                               '?' )
         THEN
            BEGIN
               INSERT INTO ITSHCMP
                           ( COMP_NO,
                             SECTION_ID,
                             SUB_SECTION_ID,
                             TYPE,
                             REF_ID )
                    VALUES ( AI_COMP_NO,
                             REC_FREE_TEXT.SECTION_ID,
                             REC_FREE_TEXT.SUB_SECTION_ID,
                             5,
                             REC_FREE_TEXT.REF_ID );
            EXCEPTION
               WHEN OTHERS
               THEN
                  NULL;
            END;
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            RAISE_APPLICATION_ERROR( -20011,
                                     SQLERRM );
            DBMS_OUTPUT.PUT_LINE(    ' 12 '
                                  || SQLERRM );
      END;
   END LOOP;
EXCEPTION
   WHEN OTHERS
   THEN
      RAISE_APPLICATION_ERROR( -20012,
                               SQLERRM );
END;
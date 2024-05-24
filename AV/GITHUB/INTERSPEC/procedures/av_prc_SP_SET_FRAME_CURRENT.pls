CREATE OR REPLACE PROCEDURE SP_SET_FRAME_CURRENT(
   AS_FRAME_NO                IN       VARCHAR2,
   AI_REVISION                IN       NUMBER,
   AI_OWNER                   IN       NUMBER )
IS

















   LSSOURCE                      IAPITYPE.SOURCE_TYPE := 'SP_SET_FRAME_CURRENT';
   LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;

   CURSOR L_FRAME_PROP_ATT
   IS
      SELECT DISTINCT FRAME_NO,
                      REVISION,
                      OWNER,
                      ATTRIBUTE
                 FROM FRAME_PROP
                WHERE FRAME_NO = AS_FRAME_NO
                  AND REVISION = AI_REVISION
                  AND OWNER = AI_OWNER;

   CURSOR L_FRAME_PROP_ASS
   IS
      SELECT DISTINCT FRAME_NO,
                      REVISION,
                      OWNER,
                      ASSOCIATION
                 FROM FRAME_PROP
                WHERE FRAME_NO = AS_FRAME_NO
                  AND REVISION = AI_REVISION
                  AND OWNER = AI_OWNER;

   CURSOR L_FRAME_PROP_ASS2
   IS
      SELECT DISTINCT FRAME_NO,
                      REVISION,
                      OWNER,
                      AS_2
                 FROM FRAME_PROP
                WHERE FRAME_NO = AS_FRAME_NO
                  AND REVISION = AI_REVISION
                  AND OWNER = AI_OWNER;

   CURSOR L_FRAME_PROP_ASS3
   IS
      SELECT DISTINCT FRAME_NO,
                      REVISION,
                      OWNER,
                      AS_3
                 FROM FRAME_PROP
                WHERE FRAME_NO = AS_FRAME_NO
                  AND REVISION = AI_REVISION
                  AND OWNER = AI_OWNER;

   CURSOR L_FRAME_PROP_TMT
   IS
      SELECT DISTINCT FRAME_NO,
                      REVISION,
                      OWNER,
                      TEST_METHOD
                 FROM FRAME_PROP
                WHERE FRAME_NO = AS_FRAME_NO
                  AND REVISION = AI_REVISION
                  AND OWNER = AI_OWNER;

   CURSOR L_FRAME_PROP_UOM
   IS
      SELECT DISTINCT FRAME_NO,
                      REVISION,
                      OWNER,
                      UOM_ID
                 FROM FRAME_PROP
                WHERE FRAME_NO = AS_FRAME_NO
                  AND REVISION = AI_REVISION
                  AND OWNER = AI_OWNER;

   CURSOR L_FRAME_PROP_UOM_ALT
   IS
      SELECT DISTINCT FRAME_NO,
                      REVISION,
                      OWNER,
                      UOM_ALT_ID
                 FROM FRAME_PROP
                WHERE FRAME_NO = AS_FRAME_NO
                  AND REVISION = AI_REVISION
                  AND OWNER = AI_OWNER;

   CURSOR L_FRAME_PROP_CHH
   IS
      SELECT DISTINCT FRAME_NO,
                      REVISION,
                      OWNER,
                      CHARACTERISTIC
                 FROM FRAME_PROP
                WHERE FRAME_NO = AS_FRAME_NO
                  AND REVISION = AI_REVISION
                  AND OWNER = AI_OWNER;

   CURSOR L_FRAME_PROP_PG
   IS
      SELECT DISTINCT FRAME_NO,
                      REVISION,
                      OWNER,
                      PROPERTY_GROUP
                 FROM FRAME_PROP
                WHERE FRAME_NO = AS_FRAME_NO
                  AND REVISION = AI_REVISION
                  AND OWNER = AI_OWNER
                  AND PROPERTY_GROUP > 0;

   CURSOR L_FRAME_PROP_SP
   IS
      SELECT DISTINCT FRAME_NO,
                      REVISION,
                      OWNER,
                      PROPERTY
                 FROM FRAME_PROP
                WHERE FRAME_NO = AS_FRAME_NO
                  AND REVISION = AI_REVISION
                  AND OWNER = AI_OWNER;

   CURSOR L_FRAME_SECTION
   IS
      SELECT DISTINCT FRAME_NO,
                      REVISION,
                      OWNER,
                      SECTION_ID
                 FROM FRAME_SECTION
                WHERE FRAME_NO = AS_FRAME_NO
                  AND REVISION = AI_REVISION
                  AND OWNER = AI_OWNER;

   CURSOR L_FRAME_SUB_SECTION
   IS
      SELECT DISTINCT FRAME_NO,
                      REVISION,
                      OWNER,
                      SUB_SECTION_ID
                 FROM FRAME_SECTION
                WHERE FRAME_NO = AS_FRAME_NO
                  AND REVISION = AI_REVISION
                  AND OWNER = AI_OWNER;

   CURSOR L_FRAME_SECTION_TYPE
   IS
      SELECT *
        FROM FRAME_SECTION
       WHERE FRAME_NO = AS_FRAME_NO
         AND REVISION = AI_REVISION
         AND OWNER = AI_OWNER;

   L_ROW                         L_FRAME_PROP_PG%ROWTYPE;
   L_FS                          L_FRAME_SECTION%ROWTYPE;
   V_SECTION_REV                 FRAME_SECTION.SECTION_REV%TYPE;
   V_SUB_SECTION_REV             FRAME_SECTION.SUB_SECTION_REV%TYPE;
BEGIN
   FOR L_ROW IN L_FRAME_SECTION
   LOOP
      
      SELECT MAX( REVISION )
        INTO V_SECTION_REV
        FROM SECTION_H
       WHERE SECTION_ID = L_ROW.SECTION_ID;

      UPDATE FRAME_PROP
         SET SECTION_REV = V_SECTION_REV
       WHERE FRAME_NO = L_ROW.FRAME_NO
         AND REVISION = L_ROW.REVISION
         AND OWNER = L_ROW.OWNER
         AND SECTION_ID = L_ROW.SECTION_ID;

      UPDATE FRAME_TEXT
         SET SECTION_REV = V_SECTION_REV
       WHERE FRAME_NO = L_ROW.FRAME_NO
         AND REVISION = L_ROW.REVISION
         AND OWNER = L_ROW.OWNER
         AND SECTION_ID = L_ROW.SECTION_ID;

      UPDATE FRAME_SECTION
         SET SECTION_REV = V_SECTION_REV
       WHERE FRAME_NO = L_ROW.FRAME_NO
         AND REVISION = L_ROW.REVISION
         AND OWNER = L_ROW.OWNER
         AND SECTION_ID = L_ROW.SECTION_ID;
   END LOOP;

   FOR L_ROW IN L_FRAME_SUB_SECTION
   LOOP
      
      SELECT MAX( REVISION )
        INTO V_SUB_SECTION_REV
        FROM SUB_SECTION_H
       WHERE SUB_SECTION_ID = L_ROW.SUB_SECTION_ID;

      UPDATE FRAME_PROP
         SET SUB_SECTION_REV = V_SUB_SECTION_REV
       WHERE FRAME_NO = L_ROW.FRAME_NO
         AND REVISION = L_ROW.REVISION
         AND OWNER = L_ROW.OWNER
         AND SUB_SECTION_ID = L_ROW.SUB_SECTION_ID;

      UPDATE FRAME_TEXT
         SET SUB_SECTION_REV = V_SUB_SECTION_REV
       WHERE FRAME_NO = L_ROW.FRAME_NO
         AND REVISION = L_ROW.REVISION
         AND OWNER = L_ROW.OWNER
         AND SUB_SECTION_ID = L_ROW.SUB_SECTION_ID;

      UPDATE FRAME_SECTION
         SET SUB_SECTION_REV = V_SUB_SECTION_REV
       WHERE FRAME_NO = L_ROW.FRAME_NO
         AND REVISION = L_ROW.REVISION
         AND OWNER = L_ROW.OWNER
         AND SUB_SECTION_ID = L_ROW.SUB_SECTION_ID;
   END LOOP;

   FOR L_ROW IN L_FRAME_PROP_ATT
   LOOP
      
      UPDATE FRAME_PROP
         SET ATTRIBUTE_REV = ( SELECT MAX( REVISION )
                                FROM ATTRIBUTE_H
                               WHERE ATTRIBUTE = L_ROW.ATTRIBUTE )
       WHERE FRAME_NO = L_ROW.FRAME_NO
         AND REVISION = L_ROW.REVISION
         AND OWNER = L_ROW.OWNER
         AND ATTRIBUTE = L_ROW.ATTRIBUTE;
   END LOOP;

   FOR L_ROW IN L_FRAME_PROP_PG
   LOOP
      
      UPDATE FRAME_PROP
         SET PROPERTY_GROUP_REV = ( SELECT MAX( REVISION )
                                     FROM PROPERTY_GROUP_H
                                    WHERE PROPERTY_GROUP = L_ROW.PROPERTY_GROUP )
       WHERE FRAME_NO = L_ROW.FRAME_NO
         AND REVISION = L_ROW.REVISION
         AND OWNER = L_ROW.OWNER
         AND PROPERTY_GROUP = L_ROW.PROPERTY_GROUP;
   END LOOP;

   FOR L_ROW IN L_FRAME_PROP_SP
   LOOP
      
      UPDATE FRAME_PROP
         SET PROPERTY_REV = ( SELECT MAX( REVISION )
                               FROM PROPERTY_H
                              WHERE PROPERTY = L_ROW.PROPERTY )
       WHERE FRAME_NO = L_ROW.FRAME_NO
         AND REVISION = L_ROW.REVISION
         AND OWNER = L_ROW.OWNER
         AND PROPERTY = L_ROW.PROPERTY;
   END LOOP;

   FOR L_ROW IN L_FRAME_PROP_UOM
   LOOP
      
      UPDATE FRAME_PROP
         SET UOM_REV = ( SELECT MAX( REVISION )
                          FROM UOM_H
                         WHERE UOM_ID = L_ROW.UOM_ID )
       WHERE FRAME_NO = L_ROW.FRAME_NO
         AND REVISION = L_ROW.REVISION
         AND OWNER = L_ROW.OWNER
         AND UOM_ID = L_ROW.UOM_ID;
   END LOOP;

   FOR L_ROW IN L_FRAME_PROP_UOM_ALT
   LOOP
      
      UPDATE FRAME_PROP
         SET UOM_ALT_REV = ( SELECT MAX( REVISION )
                              FROM UOM_H
                             WHERE UOM_ID = L_ROW.UOM_ALT_ID )
       WHERE FRAME_NO = L_ROW.FRAME_NO
         AND REVISION = L_ROW.REVISION
         AND OWNER = L_ROW.OWNER
         AND UOM_ALT_ID = L_ROW.UOM_ALT_ID;
   END LOOP;

   FOR L_ROW IN L_FRAME_PROP_TMT
   LOOP
      
      UPDATE FRAME_PROP
         SET TEST_METHOD_REV = ( SELECT MAX( REVISION )
                                  FROM TEST_METHOD_H
                                 WHERE TEST_METHOD = L_ROW.TEST_METHOD )
       WHERE FRAME_NO = L_ROW.FRAME_NO
         AND REVISION = L_ROW.REVISION
         AND OWNER = L_ROW.OWNER
         AND TEST_METHOD = L_ROW.TEST_METHOD;
   END LOOP;

   FOR L_ROW IN L_FRAME_PROP_CHH
   LOOP
      
      UPDATE FRAME_PROP
         SET CHARACTERISTIC_REV = ( SELECT MAX( REVISION )
                                     FROM CHARACTERISTIC_H
                                    WHERE CHARACTERISTIC_ID = L_ROW.CHARACTERISTIC )
       WHERE FRAME_NO = L_ROW.FRAME_NO
         AND REVISION = L_ROW.REVISION
         AND OWNER = L_ROW.OWNER
         AND CHARACTERISTIC = L_ROW.CHARACTERISTIC;
   END LOOP;

   FOR L_ROW IN L_FRAME_PROP_ASS
   LOOP
      
      UPDATE FRAME_PROP
         SET ASSOCIATION_REV = ( SELECT MAX( REVISION )
                                  FROM ASSOCIATION_H
                                 WHERE ASSOCIATION = L_ROW.ASSOCIATION )
       WHERE FRAME_NO = L_ROW.FRAME_NO
         AND REVISION = L_ROW.REVISION
         AND OWNER = L_ROW.OWNER
         AND ASSOCIATION = L_ROW.ASSOCIATION;
   END LOOP;

   FOR L_ROW IN L_FRAME_PROP_ASS2
   LOOP
      
      UPDATE FRAME_PROP
         SET AS_REV_2 = ( SELECT MAX( REVISION )
                           FROM ASSOCIATION_H
                          WHERE ASSOCIATION = L_ROW.AS_2 )
       WHERE FRAME_NO = L_ROW.FRAME_NO
         AND REVISION = L_ROW.REVISION
         AND OWNER = L_ROW.OWNER
         AND AS_2 = L_ROW.AS_2;
   END LOOP;

   FOR L_ROW IN L_FRAME_PROP_ASS3
   LOOP
      
      UPDATE FRAME_PROP
         SET AS_REV_3 = ( SELECT MAX( REVISION )
                           FROM ASSOCIATION_H
                          WHERE ASSOCIATION = L_ROW.AS_3 )
       WHERE FRAME_NO = L_ROW.FRAME_NO
         AND REVISION = L_ROW.REVISION
         AND OWNER = L_ROW.OWNER
         AND AS_3 = L_ROW.AS_3;
   END LOOP;

   FOR L_FS IN L_FRAME_SECTION_TYPE
   LOOP
      IF L_FS.TYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP
      THEN
         
         UPDATE FRAME_SECTION
            SET REF_VER = ( SELECT MAX( REVISION )
                             FROM PROPERTY_GROUP_H
                            WHERE PROPERTY_GROUP = L_FS.REF_ID )
          WHERE FRAME_NO = L_FS.FRAME_NO
            AND REVISION = L_FS.REVISION
            AND OWNER = L_FS.OWNER
            AND SECTION_ID = L_FS.SECTION_ID
            AND REF_ID = L_FS.REF_ID
            AND TYPE = L_FS.TYPE;

         UPDATE FRAME_SECTION
            SET DISPLAY_FORMAT_REV = ( SELECT MAX( REVISION )
                                        FROM LAYOUT
                                       WHERE LAYOUT_ID = L_FS.DISPLAY_FORMAT
                                         AND STATUS = 2 )
          WHERE FRAME_NO = L_FS.FRAME_NO
            AND REVISION = L_FS.REVISION
            AND OWNER = L_FS.OWNER
            AND SECTION_ID = L_FS.SECTION_ID
            AND SUB_SECTION_ID = L_FS.SUB_SECTION_ID
            AND REF_ID = L_FS.REF_ID
            AND TYPE = L_FS.TYPE;
      ELSIF L_FS.TYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY
      THEN
         
         UPDATE FRAME_SECTION
            SET REF_VER = ( SELECT MAX( REVISION )
                             FROM PROPERTY_H
                            WHERE PROPERTY = L_FS.REF_ID )
          WHERE FRAME_NO = L_FS.FRAME_NO
            AND REVISION = L_FS.REVISION
            AND OWNER = L_FS.OWNER
            AND SECTION_ID = L_FS.SECTION_ID
            AND REF_ID = L_FS.REF_ID
            AND TYPE = L_FS.TYPE;

         UPDATE FRAME_SECTION
            SET DISPLAY_FORMAT_REV = ( SELECT MAX( REVISION )
                                        FROM LAYOUT
                                       WHERE LAYOUT_ID = L_FS.DISPLAY_FORMAT
                                         AND STATUS = 2 )
          WHERE FRAME_NO = L_FS.FRAME_NO
            AND REVISION = L_FS.REVISION
            AND OWNER = L_FS.OWNER
            AND SECTION_ID = L_FS.SECTION_ID
            AND SUB_SECTION_ID = L_FS.SUB_SECTION_ID
            AND REF_ID = L_FS.REF_ID
            AND TYPE = L_FS.TYPE;
      ELSIF L_FS.TYPE = IAPICONSTANT.SECTIONTYPE_FREETEXT
      THEN
         
         UPDATE FRAME_SECTION
            SET REF_VER = ( SELECT MAX( REVISION )
                             FROM TEXT_TYPE_H
                            WHERE TEXT_TYPE = L_FS.REF_ID )
          WHERE FRAME_NO = L_FS.FRAME_NO
            AND REVISION = L_FS.REVISION
            AND OWNER = L_FS.OWNER
            AND SECTION_ID = L_FS.SECTION_ID
            AND REF_ID = L_FS.REF_ID
            AND TYPE = L_FS.TYPE;

         UPDATE FRAME_TEXT
            SET TEXT_TYPE_REV = ( SELECT MAX( REVISION )
                                   FROM TEXT_TYPE_H
                                  WHERE TEXT_TYPE = L_FS.REF_ID )
          WHERE FRAME_NO = L_FS.FRAME_NO
            AND REVISION = L_FS.REVISION
            AND OWNER = L_FS.OWNER
            AND SECTION_ID = L_FS.SECTION_ID
            AND TEXT_TYPE = L_FS.REF_ID;
      ELSIF L_FS.TYPE = IAPICONSTANT.SECTIONTYPE_REFERENCETEXT
      THEN
         
         UPDATE FRAME_SECTION
            SET REF_VER = ( SELECT COALESCE( MAX( TEXT_REVISION ),
                                             0 )
                             FROM REFERENCE_TEXT
                            WHERE REF_TEXT_TYPE = L_FS.REF_ID
                              AND OWNER = L_FS.REF_OWNER
                              AND STATUS = 2 )
          WHERE FRAME_NO = L_FS.FRAME_NO
            AND REVISION = L_FS.REVISION
            AND OWNER = L_FS.OWNER
            AND SECTION_ID = L_FS.SECTION_ID
            AND REF_ID = L_FS.REF_ID
            AND TYPE = L_FS.TYPE;
      ELSIF L_FS.TYPE = IAPICONSTANT.SECTIONTYPE_OBJECT
      THEN
         
         UPDATE FRAME_SECTION
            SET REF_VER = ( SELECT COALESCE( MAX( REVISION ),
                                             0 )
                             FROM ITOID
                            WHERE OBJECT_ID = L_FS.REF_ID
                              AND OWNER = L_FS.REF_OWNER
                              AND STATUS = 2 )
          WHERE FRAME_NO = L_FS.FRAME_NO
            AND REVISION = L_FS.REVISION
            AND OWNER = L_FS.OWNER
            AND SECTION_ID = L_FS.SECTION_ID
            AND REF_ID = L_FS.REF_ID
            AND TYPE = L_FS.TYPE;
      END IF;
   END LOOP;

   LNRETVAL := IAPIFRAME.SYNCHRONISEMASKS( AS_FRAME_NO,
                                           AI_REVISION,
                                           AI_OWNER );
EXCEPTION
   WHEN OTHERS
   THEN
      IAPIGENERAL.LOGERROR( LSSOURCE,
                            '',
                            SQLERRM );

      IF L_FRAME_SECTION%ISOPEN
      THEN
         CLOSE L_FRAME_SECTION;
      END IF;

      IF L_FRAME_SUB_SECTION%ISOPEN
      THEN
         CLOSE L_FRAME_SUB_SECTION;
      END IF;

      IF L_FRAME_SECTION_TYPE%ISOPEN
      THEN
         CLOSE L_FRAME_SECTION_TYPE;
      END IF;

      IF L_FRAME_PROP_ATT%ISOPEN
      THEN
         CLOSE L_FRAME_PROP_ATT;
      END IF;

      IF L_FRAME_PROP_UOM%ISOPEN
      THEN
         CLOSE L_FRAME_PROP_UOM;
      END IF;

      IF L_FRAME_PROP_CHH%ISOPEN
      THEN
         CLOSE L_FRAME_PROP_CHH;
      END IF;

      IF L_FRAME_PROP_SP%ISOPEN
      THEN
         CLOSE L_FRAME_PROP_SP;
      END IF;

      IF L_FRAME_PROP_ASS%ISOPEN
      THEN
         CLOSE L_FRAME_PROP_ASS;
      END IF;

      IF L_FRAME_PROP_TMT%ISOPEN
      THEN
         CLOSE L_FRAME_PROP_TMT;
      END IF;

      LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      RAISE_APPLICATION_ERROR( -20000,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
END SP_SET_FRAME_CURRENT;
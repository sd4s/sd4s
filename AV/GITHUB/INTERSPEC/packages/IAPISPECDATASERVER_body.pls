CREATE OR REPLACE PACKAGE BODY iapiSpecDataServer
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

   
   
   
   
   
   
   
 
   PROCEDURE RELEASELOCK  
   (ASLOCKNAME       IN        VARCHAR2,
    ASLOCKHANDLE     IN        VARCHAR2)
   IS   
   LNRETURNCODE                   INTEGER;
   BEGIN    
      
      LNRETURNCODE := DBMS_LOCK.RELEASE(ASLOCKHANDLE);
      IF LNRETURNCODE = 4 THEN
         RAISE_APPLICATION_ERROR(-20000, 'The owner of user lock '||ASLOCKNAME||' is not the interspec dba (delete record from sys.dbms_lock_allocated if problem persists)');      
      ELSIF LNRETURNCODE <> 0 THEN
         RAISE_APPLICATION_ERROR(-20000, 'Release Lock for '||ASLOCKNAME||' failed with:'||TO_CHAR(LNRETURNCODE)||' (see DBMS_LOCK.RELEASE doc for details)');
      END IF; 
   END RELEASELOCK;
   
   
   
   
   FUNCTION INSERTSPECDATACHECK
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      CURSOR CUR_SH
      IS
         SELECT SC.PART_NO,
                SC.REVISION,
                SC.SECTION_ID,
                SC.SUB_SECTION_ID,
                SC.DISPLAY_FORMAT,
                SC.DISPLAY_FORMAT_REV,
                SP.PROPERTY_GROUP,
                SP.PROPERTY,
                SP.ATTRIBUTE,
                LY.HEADER_ID,
                LY.FIELD_ID,
                SP.NUM_1,
                SP.NUM_2,
                SP.NUM_3,
                SP.NUM_4,
                SP.NUM_5,
                SP.NUM_6,
                SP.NUM_7,
                SP.NUM_8,
                SP.NUM_9,
                SP.NUM_10,
                SP.CHAR_1,
                SP.CHAR_2,
                SP.CHAR_3,
                SP.CHAR_4,
                SP.CHAR_5,
                SP.CHAR_6,
                SP.BOOLEAN_1,
                SP.BOOLEAN_2,
                SP.BOOLEAN_3,
                SP.BOOLEAN_4,
                SP.DATE_1,
                SP.DATE_2,
                SP.UOM_ID,
                SP.CHARACTERISTIC,
                SP.ASSOCIATION,
                SP.CH_2,
                SP.CH_3,
                SP.AS_2,
                SP.AS_3
           FROM PROPERTY_LAYOUT LY,
                SPECIFICATION_SECTION SC,
                SPECIFICATION_PROP SP
          WHERE LY.LAYOUT_ID = SC.DISPLAY_FORMAT
            AND LY.REVISION = SC.DISPLAY_FORMAT_REV
            AND SC.PART_NO = SP.PART_NO
            AND SC.REVISION = SP.REVISION
            AND SC.REF_ID = SP.PROPERTY_GROUP
            AND SC.SECTION_ID = SP.SECTION_ID
            AND SC.SUB_SECTION_ID = SP.SUB_SECTION_ID
            AND SC.TYPE = 1
            AND SP.PROPERTY_GROUP <> 0
            AND LY.FIELD_ID NOT IN( 23, 24, 25, 27, 32, 33, 34, 35, 40, 41 );

      CURSOR CUR_SH_LANG(
         P_PART_NO                           SPECIFICATION_HEADER.PART_NO%TYPE,
         P_REVISION                          SPECIFICATION_HEADER.REVISION%TYPE,
         P_SECTION                           SPECIFICATION_SECTION.SECTION_ID%TYPE,
         P_SUB_SECTION                       SPECIFICATION_SECTION.SUB_SECTION_ID%TYPE,
         P_PROPERTY_GROUP                    SPECIFICATION_PROP.PROPERTY_GROUP%TYPE,
         P_PROPERTY                          SPECIFICATION_PROP.PROPERTY%TYPE,
         P_ATTRIBUTE                         SPECIFICATION_PROP.ATTRIBUTE%TYPE,
         P_HEADER_ID                         PROPERTY_LAYOUT.HEADER_ID%TYPE,
         P_FIELD_ID                          PROPERTY_LAYOUT.FIELD_ID%TYPE )
      IS
         SELECT   SP.PART_NO,
                  SP.REVISION,
                  SP.SECTION_ID,
                  SP.SUB_SECTION_ID,
                  SP.PROPERTY_GROUP,
                  SP.PROPERTY,
                  SP.ATTRIBUTE,
                  SP.LANG_ID,
                  LY.FIELD_ID,
                  LY.HEADER_ID,
                  SP.CHAR_1,
                  SP.CHAR_2,
                  SP.CHAR_3,
                  SP.CHAR_4,
                  SP.CHAR_5,
                  SP.CHAR_6
             FROM PROPERTY_LAYOUT LY,
                  SPECIFICATION_SECTION SC,
                  SPECIFICATION_PROP_LANG SP
            WHERE SP.PART_NO = P_PART_NO
              AND SP.REVISION = P_REVISION
              AND SP.SECTION_ID = P_SECTION
              AND SP.SUB_SECTION_ID = P_SUB_SECTION
              AND SP.PROPERTY_GROUP = P_PROPERTY_GROUP
              AND SP.PROPERTY = P_PROPERTY
              AND SP.ATTRIBUTE = P_ATTRIBUTE
              AND LY.LAYOUT_ID = SC.DISPLAY_FORMAT
              AND LY.REVISION = SC.DISPLAY_FORMAT_REV
              AND SC.PART_NO = SP.PART_NO
              AND SC.REVISION = SP.REVISION
              AND SC.REF_ID = SP.PROPERTY_GROUP
              AND SC.SECTION_ID = SP.SECTION_ID
              AND SC.SUB_SECTION_ID = SP.SUB_SECTION_ID
              AND LY.HEADER_ID = P_HEADER_ID
              AND LY.FIELD_ID = P_FIELD_ID
         ORDER BY SP.SEQUENCE_NO;

      CURSOR CUR_SH_SP_LANG(
         P_PART_NO                           SPECIFICATION_HEADER.PART_NO%TYPE,
         P_REVISION                          SPECIFICATION_HEADER.REVISION%TYPE,
         P_SECTION                           SPECIFICATION_SECTION.SECTION_ID%TYPE,
         P_SUB_SECTION                       SPECIFICATION_SECTION.SUB_SECTION_ID%TYPE,
         P_PROPERTY_GROUP                    SPECIFICATION_PROP.PROPERTY_GROUP%TYPE,
         P_PROPERTY                          SPECIFICATION_PROP.PROPERTY%TYPE,
         P_ATTRIBUTE                         SPECIFICATION_PROP.ATTRIBUTE%TYPE,
         P_HEADER_ID                         PROPERTY_LAYOUT.HEADER_ID%TYPE,
         P_FIELD_ID                          PROPERTY_LAYOUT.FIELD_ID%TYPE )
      IS
         SELECT   SP.PART_NO,
                  SP.REVISION,
                  SP.SECTION_ID,
                  SP.SUB_SECTION_ID,
                  SP.PROPERTY_GROUP,
                  SP.PROPERTY,
                  SP.ATTRIBUTE,
                  SP.LANG_ID,
                  LY.FIELD_ID,
                  LY.HEADER_ID,
                  SP.CHAR_1,
                  SP.CHAR_2,
                  SP.CHAR_3,
                  SP.CHAR_4,
                  SP.CHAR_5,
                  SP.CHAR_6
             FROM PROPERTY_LAYOUT LY,
                  SPECIFICATION_SECTION SC,
                  SPECIFICATION_PROP_LANG SP
            WHERE SP.PART_NO = P_PART_NO
              AND SP.REVISION = P_REVISION
              AND SP.SECTION_ID = P_SECTION
              AND SP.SUB_SECTION_ID = P_SUB_SECTION
              AND SP.PROPERTY_GROUP = P_PROPERTY_GROUP
              AND SP.PROPERTY = P_PROPERTY
              AND SP.ATTRIBUTE = P_ATTRIBUTE
              AND LY.LAYOUT_ID = SC.DISPLAY_FORMAT
              AND LY.REVISION = SC.DISPLAY_FORMAT_REV
              AND SC.PART_NO = SP.PART_NO
              AND SC.REVISION = SP.REVISION
              AND SC.REF_ID = SP.PROPERTY
              AND SC.SECTION_ID = SP.SECTION_ID
              AND SC.SUB_SECTION_ID = SP.SUB_SECTION_ID
              AND LY.HEADER_ID = P_HEADER_ID
              AND LY.FIELD_ID = P_FIELD_ID
         ORDER BY SP.SEQUENCE_NO;

      
      CURSOR CUR_SH_SP
      IS
         SELECT SC.PART_NO,
                SC.REVISION,
                SC.SECTION_ID,
                SC.SUB_SECTION_ID,
                SP.PROPERTY_GROUP,
                SP.PROPERTY,
                SP.ATTRIBUTE,
                LY.HEADER_ID,
                LY.FIELD_ID,
                SP.NUM_1,
                SP.NUM_2,
                SP.NUM_3,
                SP.NUM_4,
                SP.NUM_5,
                SP.NUM_6,
                SP.NUM_7,
                SP.NUM_8,
                SP.NUM_9,
                SP.NUM_10,
                SP.CHAR_1,
                SP.CHAR_2,
                SP.CHAR_3,
                SP.CHAR_4,
                SP.CHAR_5,
                SP.CHAR_6,
                SP.BOOLEAN_1,
                SP.BOOLEAN_2,
                SP.BOOLEAN_3,
                SP.BOOLEAN_4,
                SP.DATE_1,
                SP.DATE_2,
                SP.UOM_ID,
                SP.CHARACTERISTIC,
                SP.ASSOCIATION,
                SP.CH_2,
                SP.CH_3,
                SP.AS_2,
                SP.AS_3
           FROM PROPERTY_LAYOUT LY,
                SPECIFICATION_SECTION SC,
                SPECIFICATION_PROP SP
          WHERE LY.LAYOUT_ID = SC.DISPLAY_FORMAT
            AND LY.REVISION = SC.DISPLAY_FORMAT_REV
            AND SC.PART_NO = SP.PART_NO
            AND SC.REVISION = SP.REVISION
            AND SC.REF_ID = SP.PROPERTY
            AND SC.SECTION_ID = SP.SECTION_ID
            AND SC.SUB_SECTION_ID = SP.SUB_SECTION_ID
            AND SC.TYPE = 4
            AND SP.PROPERTY_GROUP = 0
            AND LY.FIELD_ID NOT IN( 23, 24, 25, 27, 32, 33, 34, 35, 40, 41 );

      CURSOR LQCOUNT(
         ASPARTNO                   IN       SPECDATA.PART_NO%TYPE,
         ANREVISION                 IN       SPECDATA.REVISION%TYPE,
         ANSECTIONID                IN       SPECDATA.SECTION_ID%TYPE,
         ANSUBSECTIONID             IN       SPECDATA.SUB_SECTION_ID%TYPE,
         ANPROPERTYGROUP            IN       SPECDATA.PROPERTY_GROUP%TYPE,
         ANPROPERTY                 IN       SPECDATA.PROPERTY%TYPE,
         ANATTRIBUTEID              IN       SPECDATA.ATTRIBUTE%TYPE,
         ANHEADERID                 IN       SPECDATA.HEADER_ID%TYPE,
         ANLANGID                   IN       SPECDATA.LANG_ID%TYPE )
      IS
         SELECT VALUE,
                VALUE_S,
                CHARACTERISTIC,
                ASSOCIATION
           FROM SPECDATA
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND PROPERTY_GROUP = ANPROPERTYGROUP
            AND PROPERTY = ANPROPERTY
            AND ATTRIBUTE = ANATTRIBUTEID
            AND HEADER_ID = ANHEADERID
            AND LANG_ID = ANLANGID;

      CURSOR LQCOUNTLANG(
         ASPARTNO                   IN       SPECDATA.PART_NO%TYPE,
         ANREVISION                 IN       SPECDATA.REVISION%TYPE,
         ANSECTIONID                IN       SPECDATA.SECTION_ID%TYPE,
         ANSUBSECTIONID             IN       SPECDATA.SUB_SECTION_ID%TYPE,
         ANPROPERTYGROUP            IN       SPECDATA.PROPERTY_GROUP%TYPE,
         ANPROPERTY                 IN       SPECDATA.PROPERTY%TYPE,
         ANATTRIBUTEID              IN       SPECDATA.ATTRIBUTE%TYPE,
         ANLANGID                   IN       SPECDATA.LANG_ID%TYPE )
      IS
         SELECT VALUE,
                VALUE_S,
                CHARACTERISTIC,
                ASSOCIATION
           FROM SPECDATA
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND PROPERTY_GROUP = ANPROPERTYGROUP
            AND PROPERTY = ANPROPERTY
            AND LANG_ID = ANLANGID;

      CURSOR LQSPECDATA
      IS
         SELECT PART_NO,
                REVISION,
                SECTION_ID,
                SUB_SECTION_ID,
                PROPERTY_GROUP,
                PROPERTY,
                ATTRIBUTE,
                HEADER_ID,
                HEADER_REV,
                PROPERTY_REV,
                ATTRIBUTE_REV,
                PROPERTY_GROUP_REV,
                TYPE,
                LANG_ID
           FROM SPECDATA
          WHERE TYPE IN( 1, 4 )
            AND HEADER_ID IS NOT NULL
            AND PROPERTY IS NOT NULL
            AND ATTRIBUTE IS NOT NULL;

      V_CNT                         NUMBER;
      L_COLUMN                      VARCHAR2( 255 );
      L_F_COLUMN                    NUMBER;
      L_DT_COLUMN                   DATE;
      L_CHARACTERISTIC              NUMBER;
      L_ASSOCIATION                 NUMBER;
      LNCHARSPECDATA                NUMBER;
      LNASSSPECDATA                 NUMBER;
      LFCOLUMN                      SPECDATA.VALUE%TYPE;
      LSCOLUMN                      SPECDATA.VALUE_S%TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'InsertSpecDataCheck';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      INSERT INTO SPECDATA_CHECK
                  ( PART_NO,
                    REVISION,
                    REASON )
           VALUES ( 'Started',
                    0,
                       'Procedure started on '
                    || SYSDATE );

      FOR REC_SH IN CUR_SH
      LOOP
         OPEN LQCOUNT( REC_SH.PART_NO,
                       REC_SH.REVISION,
                       REC_SH.SECTION_ID,
                       REC_SH.SUB_SECTION_ID,
                       REC_SH.PROPERTY_GROUP,
                       REC_SH.PROPERTY,
                       REC_SH.ATTRIBUTE,
                       REC_SH.HEADER_ID,
                       1 );

         FETCH LQCOUNT
          INTO LFCOLUMN,
               LSCOLUMN,
               LNCHARSPECDATA,
               LNASSSPECDATA;

         IF LQCOUNT%NOTFOUND
         THEN
            CLOSE LQCOUNT;

            BEGIN
               INSERT INTO SPECDATA_CHECK
                           ( PART_NO,
                             REVISION,
                             SECTION_ID,
                             SUB_SECTION_ID,
                             PROPERTY_GROUP,
                             PROPERTY,
                             ATTRIBUTE,
                             HEADER_ID,
                             REASON )
                    VALUES ( REC_SH.PART_NO,
                             REC_SH.REVISION,
                             REC_SH.SECTION_ID,
                             REC_SH.SUB_SECTION_ID,
                             REC_SH.PROPERTY_GROUP,
                             REC_SH.PROPERTY,
                             REC_SH.ATTRIBUTE,
                             REC_SH.HEADER_ID,
                             'Item available in specification but missing in specdata' );
            EXCEPTION
               WHEN OTHERS
               THEN
                  DBMS_OUTPUT.PUT_LINE( SQLERRM );
            END;

            COMMIT;
         ELSIF LQCOUNT%FOUND
         THEN
            CLOSE LQCOUNT;

            L_COLUMN := NULL;
            L_DT_COLUMN := NULL;

            IF REC_SH.FIELD_ID = 1
            THEN
               L_F_COLUMN := REC_SH.NUM_1;
               L_COLUMN := TO_CHAR( L_F_COLUMN );
            ELSIF REC_SH.FIELD_ID = 2
            THEN
               L_F_COLUMN := REC_SH.NUM_2;
               L_COLUMN := TO_CHAR( L_F_COLUMN );
            ELSIF REC_SH.FIELD_ID = 3
            THEN
               L_F_COLUMN := REC_SH.NUM_3;
               L_COLUMN := TO_CHAR( L_F_COLUMN );
            ELSIF REC_SH.FIELD_ID = 4
            THEN
               L_F_COLUMN := REC_SH.NUM_4;
               L_COLUMN := TO_CHAR( L_F_COLUMN );
            ELSIF REC_SH.FIELD_ID = 5
            THEN
               L_F_COLUMN := REC_SH.NUM_5;
               L_COLUMN := TO_CHAR( L_F_COLUMN );
            ELSIF REC_SH.FIELD_ID = 6
            THEN
               L_F_COLUMN := REC_SH.NUM_6;
               L_COLUMN := TO_CHAR( L_F_COLUMN );
            ELSIF REC_SH.FIELD_ID = 7
            THEN
               L_F_COLUMN := REC_SH.NUM_7;
               L_COLUMN := TO_CHAR( L_F_COLUMN );
            ELSIF REC_SH.FIELD_ID = 8
            THEN
               L_F_COLUMN := REC_SH.NUM_8;
               L_COLUMN := TO_CHAR( L_F_COLUMN );
            ELSIF REC_SH.FIELD_ID = 9
            THEN
               L_F_COLUMN := REC_SH.NUM_9;
               L_COLUMN := TO_CHAR( L_F_COLUMN );
            ELSIF REC_SH.FIELD_ID = 10
            THEN
               L_F_COLUMN := REC_SH.NUM_10;
               L_COLUMN := TO_CHAR( L_F_COLUMN );
            ELSIF REC_SH.FIELD_ID = 11
            THEN
               L_F_COLUMN := 0;
               L_COLUMN := REC_SH.CHAR_1;
            ELSIF REC_SH.FIELD_ID = 12
            THEN
               L_F_COLUMN := 0;
               L_COLUMN := REC_SH.CHAR_2;
            ELSIF REC_SH.FIELD_ID = 13
            THEN
               L_F_COLUMN := 0;
               L_COLUMN := REC_SH.CHAR_3;
            ELSIF REC_SH.FIELD_ID = 14
            THEN
               L_F_COLUMN := 0;
               L_COLUMN := REC_SH.CHAR_4;
            ELSIF REC_SH.FIELD_ID = 15
            THEN
               L_F_COLUMN := 0;
               L_COLUMN := REC_SH.CHAR_5;
            ELSIF REC_SH.FIELD_ID = 16
            THEN
               L_F_COLUMN := 0;
               L_COLUMN := REC_SH.CHAR_6;
            ELSIF REC_SH.FIELD_ID = 17
            THEN
               L_F_COLUMN := 0;
               L_COLUMN := REC_SH.BOOLEAN_1;

               IF L_COLUMN IS NULL
               THEN
                  L_COLUMN := 'N';
               END IF;
            ELSIF REC_SH.FIELD_ID = 18
            THEN
               L_F_COLUMN := 0;
               L_COLUMN := REC_SH.BOOLEAN_2;

               IF L_COLUMN IS NULL
               THEN
                  L_COLUMN := 'N';
               END IF;
            ELSIF REC_SH.FIELD_ID = 19
            THEN
               L_F_COLUMN := 0;
               L_COLUMN := REC_SH.BOOLEAN_3;

               IF L_COLUMN IS NULL
               THEN
                  L_COLUMN := 'N';
               END IF;
            ELSIF REC_SH.FIELD_ID = 20
            THEN
               L_F_COLUMN := 0;
               L_COLUMN := REC_SH.BOOLEAN_4;

               IF L_COLUMN IS NULL
               THEN
                  L_COLUMN := 'N';
               END IF;
            ELSIF REC_SH.FIELD_ID = 21
            THEN
               L_F_COLUMN := 0;
               L_COLUMN := TO_CHAR( REC_SH.DATE_1,
                                    'dd-mm-yyyy hh24:mi:ss' );
            ELSIF REC_SH.FIELD_ID = 22
            THEN
               L_F_COLUMN := 0;
               L_COLUMN := TO_CHAR( REC_SH.DATE_2,
                                    'dd-mm-yyyy hh24:mi:ss' );
            ELSIF REC_SH.FIELD_ID = 26
            THEN
               L_F_COLUMN := REC_SH.CHARACTERISTIC;
               L_COLUMN := F_CHH_DESCR( 1,
                                        REC_SH.CHARACTERISTIC,
                                        0 );
            ELSIF REC_SH.FIELD_ID = 30
            THEN
               L_F_COLUMN := REC_SH.CH_2;
               L_COLUMN := F_CHH_DESCR( 1,
                                        REC_SH.CH_2,
                                        0 );
            ELSIF REC_SH.FIELD_ID = 31
            THEN
               L_F_COLUMN := REC_SH.CH_3;
               L_COLUMN := F_CHH_DESCR( 1,
                                        REC_SH.CH_3,
                                        0 );
            END IF;

            
            IF NVL( L_COLUMN,
                    '@@' ) <> NVL( LSCOLUMN,
                                   '@@' )
            THEN
               BEGIN
                  INSERT INTO SPECDATA_CHECK
                              ( PART_NO,
                                REVISION,
                                SECTION_ID,
                                SUB_SECTION_ID,
                                PROPERTY_GROUP,
                                PROPERTY,
                                ATTRIBUTE,
                                HEADER_ID,
                                REASON )
                       VALUES ( REC_SH.PART_NO,
                                REC_SH.REVISION,
                                REC_SH.SECTION_ID,
                                REC_SH.SUB_SECTION_ID,
                                REC_SH.PROPERTY_GROUP,
                                REC_SH.PROPERTY,
                                REC_SH.ATTRIBUTE,
                                REC_SH.HEADER_ID,
                                   'Value <'
                                || L_COLUMN
                                || '> in specification differs from value <'
                                || LSCOLUMN
                                || '> in specdata' );
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     DBMS_OUTPUT.PUT_LINE( SQLERRM );
               END;

               COMMIT;
            END IF;

            
            IF REC_SH.FIELD_ID IN( 11, 12, 13, 14, 15, 16 )
            THEN
               FOR REC_SH_LANG IN CUR_SH_LANG( REC_SH.PART_NO,
                                               REC_SH.REVISION,
                                               REC_SH.SECTION_ID,
                                               REC_SH.SUB_SECTION_ID,
                                               REC_SH.PROPERTY_GROUP,
                                               REC_SH.PROPERTY,
                                               REC_SH.ATTRIBUTE,
                                               REC_SH.HEADER_ID,
                                               REC_SH.FIELD_ID )
               LOOP
                  OPEN LQCOUNT( REC_SH_LANG.PART_NO,
                                REC_SH_LANG.REVISION,
                                REC_SH_LANG.SECTION_ID,
                                REC_SH_LANG.SUB_SECTION_ID,
                                REC_SH_LANG.PROPERTY_GROUP,
                                REC_SH_LANG.PROPERTY,
                                REC_SH_LANG.ATTRIBUTE,
                                REC_SH.HEADER_ID,
                                REC_SH_LANG.LANG_ID );

                  FETCH LQCOUNT
                   INTO LFCOLUMN,
                        LSCOLUMN,
                        LNCHARSPECDATA,
                        LNASSSPECDATA;

                  IF LQCOUNT%NOTFOUND
                  THEN
                     CLOSE LQCOUNT;

                     BEGIN
                        INSERT INTO SPECDATA_CHECK
                                    ( PART_NO,
                                      REVISION,
                                      SECTION_ID,
                                      SUB_SECTION_ID,
                                      PROPERTY_GROUP,
                                      PROPERTY,
                                      ATTRIBUTE,
                                      HEADER_ID,
                                      REASON )
                             VALUES ( REC_SH_LANG.PART_NO,
                                      REC_SH_LANG.REVISION,
                                      REC_SH_LANG.SECTION_ID,
                                      REC_SH_LANG.SUB_SECTION_ID,
                                      REC_SH_LANG.PROPERTY_GROUP,
                                      REC_SH_LANG.PROPERTY,
                                      REC_SH_LANG.ATTRIBUTE,
                                      REC_SH.HEADER_ID,
                                      'Item available in specification but missing in specdata' );
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           DBMS_OUTPUT.PUT_LINE( SQLERRM );
                     END;

                     COMMIT;
                  ELSIF LQCOUNT%FOUND
                  THEN
                     CLOSE LQCOUNT;

                     L_COLUMN := NULL;
                     L_DT_COLUMN := NULL;

                     IF REC_SH.FIELD_ID = 11
                     THEN
                        L_F_COLUMN := 0;
                        L_COLUMN := REC_SH_LANG.CHAR_1;
                     ELSIF REC_SH.FIELD_ID = 12
                     THEN
                        L_F_COLUMN := 0;
                        L_COLUMN := REC_SH_LANG.CHAR_2;
                     ELSIF REC_SH.FIELD_ID = 13
                     THEN
                        L_F_COLUMN := 0;
                        L_COLUMN := REC_SH_LANG.CHAR_3;
                     ELSIF REC_SH.FIELD_ID = 14
                     THEN
                        L_F_COLUMN := 0;
                        L_COLUMN := REC_SH_LANG.CHAR_4;
                     ELSIF REC_SH.FIELD_ID = 15
                     THEN
                        L_F_COLUMN := 0;
                        L_COLUMN := REC_SH_LANG.CHAR_5;
                     ELSIF REC_SH.FIELD_ID = 16
                     THEN
                        L_F_COLUMN := 0;
                        L_COLUMN := REC_SH_LANG.CHAR_6;
                     END IF;

                     
                     IF NVL( L_COLUMN,
                             '@@' ) <> NVL( LSCOLUMN,
                                            '@@' )
                     THEN
                        BEGIN
                           INSERT INTO SPECDATA_CHECK
                                       ( PART_NO,
                                         REVISION,
                                         SECTION_ID,
                                         SUB_SECTION_ID,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         HEADER_ID,
                                         REASON )
                                VALUES ( REC_SH_LANG.PART_NO,
                                         REC_SH_LANG.REVISION,
                                         REC_SH_LANG.SECTION_ID,
                                         REC_SH_LANG.SUB_SECTION_ID,
                                         REC_SH_LANG.PROPERTY_GROUP,
                                         REC_SH_LANG.PROPERTY,
                                         REC_SH_LANG.ATTRIBUTE,
                                         REC_SH.HEADER_ID,
                                            'Value <'
                                         || L_COLUMN
                                         || '> in specification differs from value <'
                                         || LSCOLUMN
                                         || '> in specdata' );
                        EXCEPTION
                           WHEN OTHERS
                           THEN
                              DBMS_OUTPUT.PUT_LINE( SQLERRM );
                        END;

                        COMMIT;
                     END IF;
                  END IF;
               END LOOP;
            END IF;
         END IF;
      END LOOP;

      
      FOR REC_SH_SP IN CUR_SH_SP
      LOOP
         OPEN LQCOUNT( REC_SH_SP.PART_NO,
                       REC_SH_SP.REVISION,
                       REC_SH_SP.SECTION_ID,
                       REC_SH_SP.SUB_SECTION_ID,
                       REC_SH_SP.PROPERTY_GROUP,
                       REC_SH_SP.PROPERTY,
                       REC_SH_SP.ATTRIBUTE,
                       REC_SH_SP.HEADER_ID,
                       1 );

         FETCH LQCOUNT
          INTO LFCOLUMN,
               LSCOLUMN,
               LNCHARSPECDATA,
               LNASSSPECDATA;

         IF LQCOUNT%NOTFOUND
         THEN
            CLOSE LQCOUNT;

            BEGIN
               INSERT INTO SPECDATA_CHECK
                           ( PART_NO,
                             REVISION,
                             SECTION_ID,
                             SUB_SECTION_ID,
                             PROPERTY_GROUP,
                             PROPERTY,
                             ATTRIBUTE,
                             HEADER_ID,
                             REASON )
                    VALUES ( REC_SH_SP.PART_NO,
                             REC_SH_SP.REVISION,
                             REC_SH_SP.SECTION_ID,
                             REC_SH_SP.SUB_SECTION_ID,
                             REC_SH_SP.PROPERTY_GROUP,
                             REC_SH_SP.PROPERTY,
                             REC_SH_SP.ATTRIBUTE,
                             REC_SH_SP.HEADER_ID,
                             'Item available in specification but missing in specdata' );
            EXCEPTION
               WHEN OTHERS
               THEN
                  DBMS_OUTPUT.PUT_LINE( SQLERRM );
            END;

            COMMIT;
         ELSIF LQCOUNT%FOUND
         THEN
            CLOSE LQCOUNT;

            
            L_COLUMN := NULL;
            L_DT_COLUMN := NULL;

            IF REC_SH_SP.FIELD_ID = 1
            THEN
               L_F_COLUMN := REC_SH_SP.NUM_1;
               L_COLUMN := TO_CHAR( L_F_COLUMN );
            ELSIF REC_SH_SP.FIELD_ID = 2
            THEN
               L_F_COLUMN := REC_SH_SP.NUM_2;
               L_COLUMN := TO_CHAR( L_F_COLUMN );
            ELSIF REC_SH_SP.FIELD_ID = 3
            THEN
               L_F_COLUMN := REC_SH_SP.NUM_3;
               L_COLUMN := TO_CHAR( L_F_COLUMN );
            ELSIF REC_SH_SP.FIELD_ID = 4
            THEN
               L_F_COLUMN := REC_SH_SP.NUM_4;
               L_COLUMN := TO_CHAR( L_F_COLUMN );
            ELSIF REC_SH_SP.FIELD_ID = 5
            THEN
               L_F_COLUMN := REC_SH_SP.NUM_5;
               L_COLUMN := TO_CHAR( L_F_COLUMN );
            ELSIF REC_SH_SP.FIELD_ID = 6
            THEN
               L_F_COLUMN := REC_SH_SP.NUM_6;
               L_COLUMN := TO_CHAR( L_F_COLUMN );
            ELSIF REC_SH_SP.FIELD_ID = 7
            THEN
               L_F_COLUMN := REC_SH_SP.NUM_7;
               L_COLUMN := TO_CHAR( L_F_COLUMN );
            ELSIF REC_SH_SP.FIELD_ID = 8
            THEN
               L_F_COLUMN := REC_SH_SP.NUM_8;
               L_COLUMN := TO_CHAR( L_F_COLUMN );
            ELSIF REC_SH_SP.FIELD_ID = 9
            THEN
               L_F_COLUMN := REC_SH_SP.NUM_9;
               L_COLUMN := TO_CHAR( L_F_COLUMN );
            ELSIF REC_SH_SP.FIELD_ID = 10
            THEN
               L_F_COLUMN := REC_SH_SP.NUM_10;
               L_COLUMN := TO_CHAR( L_F_COLUMN );
            ELSIF REC_SH_SP.FIELD_ID = 11
            THEN
               L_F_COLUMN := 0;
               L_COLUMN := REC_SH_SP.CHAR_1;
            ELSIF REC_SH_SP.FIELD_ID = 12
            THEN
               L_F_COLUMN := 0;
               L_COLUMN := REC_SH_SP.CHAR_2;
            ELSIF REC_SH_SP.FIELD_ID = 13
            THEN
               L_F_COLUMN := 0;
               L_COLUMN := REC_SH_SP.CHAR_3;
            ELSIF REC_SH_SP.FIELD_ID = 14
            THEN
               L_F_COLUMN := 0;
               L_COLUMN := REC_SH_SP.CHAR_4;
            ELSIF REC_SH_SP.FIELD_ID = 15
            THEN
               L_F_COLUMN := 0;
               L_COLUMN := REC_SH_SP.CHAR_5;
            ELSIF REC_SH_SP.FIELD_ID = 16
            THEN
               L_F_COLUMN := 0;
               L_COLUMN := REC_SH_SP.CHAR_6;
            ELSIF REC_SH_SP.FIELD_ID = 17
            THEN
               L_F_COLUMN := 0;
               L_COLUMN := REC_SH_SP.BOOLEAN_1;

               IF L_COLUMN IS NULL
               THEN
                  L_COLUMN := 'N';
               END IF;
            ELSIF REC_SH_SP.FIELD_ID = 18
            THEN
               L_F_COLUMN := 0;
               L_COLUMN := REC_SH_SP.BOOLEAN_2;

               IF L_COLUMN IS NULL
               THEN
                  L_COLUMN := 'N';
               END IF;
            ELSIF REC_SH_SP.FIELD_ID = 19
            THEN
               L_F_COLUMN := 0;
               L_COLUMN := REC_SH_SP.BOOLEAN_3;

               IF L_COLUMN IS NULL
               THEN
                  L_COLUMN := 'N';
               END IF;
            ELSIF REC_SH_SP.FIELD_ID = 20
            THEN
               L_F_COLUMN := 0;
               L_COLUMN := REC_SH_SP.BOOLEAN_4;

               IF L_COLUMN IS NULL
               THEN
                  L_COLUMN := 'N';
               END IF;
            ELSIF REC_SH_SP.FIELD_ID = 21
            THEN
               L_F_COLUMN := 0;
               L_COLUMN := TO_CHAR( REC_SH_SP.DATE_1,
                                    'dd-mm-yyyy hh24:mi:ss' );
            ELSIF REC_SH_SP.FIELD_ID = 22
            THEN
               L_F_COLUMN := 0;
               L_COLUMN := TO_CHAR( REC_SH_SP.DATE_2,
                                    'dd-mm-yyyy hh24:mi:ss' );
            ELSIF REC_SH_SP.FIELD_ID = 26
            THEN
               L_F_COLUMN := REC_SH_SP.CHARACTERISTIC;
               L_COLUMN := F_CHH_DESCR( 1,
                                        REC_SH_SP.CHARACTERISTIC,
                                        0 );
            ELSIF REC_SH_SP.FIELD_ID = 30
            THEN
               L_F_COLUMN := REC_SH_SP.CH_2;
               L_COLUMN := F_CHH_DESCR( 1,
                                        REC_SH_SP.CH_2,
                                        0 );
            ELSIF REC_SH_SP.FIELD_ID = 31
            THEN
               L_F_COLUMN := REC_SH_SP.CH_3;
               L_COLUMN := F_CHH_DESCR( 1,
                                        REC_SH_SP.CH_3,
                                        0 );
            END IF;

            
            IF NVL( L_COLUMN,
                    '@@' ) <> NVL( LSCOLUMN,
                                   '@@' )
            THEN
               BEGIN
                  INSERT INTO SPECDATA_CHECK
                              ( PART_NO,
                                REVISION,
                                SECTION_ID,
                                SUB_SECTION_ID,
                                PROPERTY_GROUP,
                                PROPERTY,
                                ATTRIBUTE,
                                HEADER_ID,
                                REASON )
                       VALUES ( REC_SH_SP.PART_NO,
                                REC_SH_SP.REVISION,
                                REC_SH_SP.SECTION_ID,
                                REC_SH_SP.SUB_SECTION_ID,
                                REC_SH_SP.PROPERTY_GROUP,
                                REC_SH_SP.PROPERTY,
                                REC_SH_SP.ATTRIBUTE,
                                REC_SH_SP.HEADER_ID,
                                   'Value <'
                                || L_COLUMN
                                || '> in specification differs from value <'
                                || LSCOLUMN
                                || '> in specdata' );
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     DBMS_OUTPUT.PUT_LINE( SQLERRM );
               END;

               COMMIT;
            END IF;

            
            IF REC_SH_SP.FIELD_ID IN( 11, 12, 13, 14, 15, 16 )
            THEN
               FOR REC_SH_SP_LANG IN CUR_SH_SP_LANG( REC_SH_SP.PART_NO,
                                                     REC_SH_SP.REVISION,
                                                     REC_SH_SP.SECTION_ID,
                                                     REC_SH_SP.SUB_SECTION_ID,
                                                     REC_SH_SP.PROPERTY_GROUP,
                                                     REC_SH_SP.PROPERTY,
                                                     REC_SH_SP.ATTRIBUTE,
                                                     REC_SH_SP.HEADER_ID,
                                                     REC_SH_SP.FIELD_ID )
               LOOP
                  OPEN LQCOUNT( REC_SH_SP_LANG.PART_NO,
                                REC_SH_SP_LANG.REVISION,
                                REC_SH_SP_LANG.SECTION_ID,
                                REC_SH_SP_LANG.SUB_SECTION_ID,
                                REC_SH_SP_LANG.PROPERTY_GROUP,
                                REC_SH_SP_LANG.PROPERTY,
                                REC_SH_SP_LANG.ATTRIBUTE,
                                REC_SH_SP.HEADER_ID,
                                REC_SH_SP_LANG.LANG_ID );

                  FETCH LQCOUNT
                   INTO LFCOLUMN,
                        LSCOLUMN,
                        LNCHARSPECDATA,
                        LNASSSPECDATA;

                  IF LQCOUNT%NOTFOUND
                  THEN
                     CLOSE LQCOUNT;

                     BEGIN
                        INSERT INTO SPECDATA_CHECK
                                    ( PART_NO,
                                      REVISION,
                                      SECTION_ID,
                                      SUB_SECTION_ID,
                                      PROPERTY_GROUP,
                                      PROPERTY,
                                      ATTRIBUTE,
                                      HEADER_ID,
                                      REASON )
                             VALUES ( REC_SH_SP_LANG.PART_NO,
                                      REC_SH_SP_LANG.REVISION,
                                      REC_SH_SP_LANG.SECTION_ID,
                                      REC_SH_SP_LANG.SUB_SECTION_ID,
                                      REC_SH_SP_LANG.PROPERTY_GROUP,
                                      REC_SH_SP_LANG.PROPERTY,
                                      REC_SH_SP_LANG.ATTRIBUTE,
                                      REC_SH_SP.HEADER_ID,
                                      'Item available in specification but missing in specdata' );
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           DBMS_OUTPUT.PUT_LINE( SQLERRM );
                     END;

                     COMMIT;
                  ELSIF LQCOUNT%FOUND
                  THEN
                     CLOSE LQCOUNT;

                     L_COLUMN := NULL;
                     
                     L_DT_COLUMN := NULL;

                     IF REC_SH_SP.FIELD_ID = 11
                     THEN
                        L_F_COLUMN := 0;
                        L_COLUMN := REC_SH_SP_LANG.CHAR_1;
                     ELSIF REC_SH_SP.FIELD_ID = 12
                     THEN
                        L_F_COLUMN := 0;
                        L_COLUMN := REC_SH_SP_LANG.CHAR_2;
                     ELSIF REC_SH_SP.FIELD_ID = 13
                     THEN
                        L_F_COLUMN := 0;
                        L_COLUMN := REC_SH_SP_LANG.CHAR_3;
                     ELSIF REC_SH_SP.FIELD_ID = 14
                     THEN
                        L_F_COLUMN := 0;
                        L_COLUMN := REC_SH_SP_LANG.CHAR_4;
                     ELSIF REC_SH_SP.FIELD_ID = 15
                     THEN
                        L_F_COLUMN := 0;
                        L_COLUMN := REC_SH_SP_LANG.CHAR_5;
                     ELSIF REC_SH_SP.FIELD_ID = 16
                     THEN
                        L_F_COLUMN := 0;
                        L_COLUMN := REC_SH_SP_LANG.CHAR_6;
                     END IF;

                     
                     IF NVL( L_COLUMN,
                             '@@' ) <> NVL( LSCOLUMN,
                                            '@@' )
                     THEN
                        BEGIN
                           INSERT INTO SPECDATA_CHECK
                                       ( PART_NO,
                                         REVISION,
                                         SECTION_ID,
                                         SUB_SECTION_ID,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         HEADER_ID,
                                         REASON )
                                VALUES ( REC_SH_SP_LANG.PART_NO,
                                         REC_SH_SP_LANG.REVISION,
                                         REC_SH_SP_LANG.SECTION_ID,
                                         REC_SH_SP_LANG.SUB_SECTION_ID,
                                         REC_SH_SP_LANG.PROPERTY_GROUP,
                                         REC_SH_SP_LANG.PROPERTY,
                                         REC_SH_SP_LANG.ATTRIBUTE,
                                         REC_SH_SP.HEADER_ID,
                                            'Value <'
                                         || L_COLUMN
                                         || '> in specification differs from value <'
                                         || LSCOLUMN
                                         || '> in specdata' );
                        EXCEPTION
                           WHEN OTHERS
                           THEN
                              DBMS_OUTPUT.PUT_LINE( SQLERRM );
                        END;

                        COMMIT;
                     END IF;
                  END IF;
               END LOOP;
            END IF;
         END IF;
      END LOOP;

      
      FOR LRSPECDATA IN LQSPECDATA
      LOOP
         IF LRSPECDATA.TYPE = 1
         THEN
            IF LRSPECDATA.LANG_ID = 1
            THEN
               SELECT COUNT( * )
                 INTO V_CNT
                 FROM PROPERTY_LAYOUT LY,
                      SPECIFICATION_SECTION SC,
                      SPECIFICATION_PROP SP
                WHERE LY.LAYOUT_ID = SC.DISPLAY_FORMAT
                  AND LY.REVISION = SC.DISPLAY_FORMAT_REV
                  AND SC.PART_NO = SP.PART_NO
                  AND SC.REVISION = SP.REVISION
                  AND SC.REF_ID = SP.PROPERTY_GROUP
                  AND SC.SECTION_ID = SP.SECTION_ID
                  AND SC.SUB_SECTION_ID = SP.SUB_SECTION_ID
                  AND LY.HEADER_ID = LRSPECDATA.HEADER_ID
                  AND SC.PART_NO = LRSPECDATA.PART_NO
                  AND SC.REVISION = LRSPECDATA.REVISION
                  AND SC.SECTION_ID = LRSPECDATA.SECTION_ID
                  AND SC.SUB_SECTION_ID = LRSPECDATA.SUB_SECTION_ID
                  AND SP.PROPERTY_GROUP = LRSPECDATA.PROPERTY_GROUP
                  AND SP.PROPERTY_GROUP_REV = LRSPECDATA.PROPERTY_GROUP_REV
                  AND SP.PROPERTY = LRSPECDATA.PROPERTY
                  AND SP.PROPERTY_REV = LRSPECDATA.PROPERTY_REV
                  AND SP.ATTRIBUTE = LRSPECDATA.ATTRIBUTE
                  AND SP.ATTRIBUTE_REV = LRSPECDATA.ATTRIBUTE_REV;
            ELSE
               SELECT COUNT( * )
                 INTO V_CNT
                 FROM PROPERTY_LAYOUT LY,
                      SPECIFICATION_SECTION SC,
                      SPECIFICATION_PROP_LANG SP
                WHERE LY.LAYOUT_ID = SC.DISPLAY_FORMAT
                  AND LY.REVISION = SC.DISPLAY_FORMAT_REV
                  AND SC.PART_NO = SP.PART_NO
                  AND SC.REVISION = SP.REVISION
                  AND SC.REF_ID = SP.PROPERTY_GROUP
                  AND SC.SECTION_ID = SP.SECTION_ID
                  AND SC.SUB_SECTION_ID = SP.SUB_SECTION_ID
                  AND LY.HEADER_ID = LRSPECDATA.HEADER_ID
                  AND SC.PART_NO = LRSPECDATA.PART_NO
                  AND SC.REVISION = LRSPECDATA.REVISION
                  AND SC.SECTION_ID = LRSPECDATA.SECTION_ID
                  AND SC.SUB_SECTION_ID = LRSPECDATA.SUB_SECTION_ID
                  AND SP.PROPERTY_GROUP = LRSPECDATA.PROPERTY_GROUP
                  AND SP.PROPERTY = LRSPECDATA.PROPERTY
                  AND SP.ATTRIBUTE = LRSPECDATA.ATTRIBUTE;
            END IF;
         ELSIF LRSPECDATA.TYPE = 4
         THEN
            IF LRSPECDATA.LANG_ID = 1
            THEN
               SELECT COUNT( * )
                 INTO V_CNT
                 FROM PROPERTY_LAYOUT LY,
                      SPECIFICATION_SECTION SC,
                      SPECIFICATION_PROP SP
                WHERE LY.LAYOUT_ID = SC.DISPLAY_FORMAT
                  AND LY.REVISION = SC.DISPLAY_FORMAT_REV
                  AND SC.PART_NO = SP.PART_NO
                  AND SC.REVISION = SP.REVISION
                  AND SC.REF_ID = SP.PROPERTY
                  AND SC.SECTION_ID = SP.SECTION_ID
                  AND SC.SUB_SECTION_ID = SP.SUB_SECTION_ID
                  AND LY.HEADER_ID = LRSPECDATA.HEADER_ID
                  AND SC.PART_NO = LRSPECDATA.PART_NO
                  AND SC.REVISION = LRSPECDATA.REVISION
                  AND SC.SECTION_ID = LRSPECDATA.SECTION_ID
                  AND SC.SUB_SECTION_ID = LRSPECDATA.SUB_SECTION_ID
                  AND SP.PROPERTY_GROUP = LRSPECDATA.PROPERTY_GROUP
                  AND SP.PROPERTY_GROUP_REV = LRSPECDATA.PROPERTY_GROUP_REV
                  AND SP.PROPERTY = LRSPECDATA.PROPERTY
                  AND SP.PROPERTY_REV = LRSPECDATA.PROPERTY_REV
                  AND SP.ATTRIBUTE = LRSPECDATA.ATTRIBUTE
                  AND SP.ATTRIBUTE_REV = LRSPECDATA.ATTRIBUTE_REV;
            ELSE
               SELECT COUNT( * )
                 INTO V_CNT
                 FROM PROPERTY_LAYOUT LY,
                      SPECIFICATION_SECTION SC,
                      SPECIFICATION_PROP_LANG SP
                WHERE LY.LAYOUT_ID = SC.DISPLAY_FORMAT
                  AND LY.REVISION = SC.DISPLAY_FORMAT_REV
                  AND SC.PART_NO = SP.PART_NO
                  AND SC.REVISION = SP.REVISION
                  AND SC.REF_ID = SP.PROPERTY
                  AND SC.SECTION_ID = SP.SECTION_ID
                  AND SC.SUB_SECTION_ID = SP.SUB_SECTION_ID
                  AND LY.HEADER_ID = LRSPECDATA.HEADER_ID
                  AND SC.PART_NO = LRSPECDATA.PART_NO
                  AND SC.REVISION = LRSPECDATA.REVISION
                  AND SC.SECTION_ID = LRSPECDATA.SECTION_ID
                  AND SC.SUB_SECTION_ID = LRSPECDATA.SUB_SECTION_ID
                  AND SP.PROPERTY_GROUP = LRSPECDATA.PROPERTY_GROUP
                  AND SP.PROPERTY = LRSPECDATA.PROPERTY
                  AND SP.ATTRIBUTE = LRSPECDATA.ATTRIBUTE;
            END IF;
         END IF;

         IF V_CNT = 0
         THEN
            BEGIN
               INSERT INTO SPECDATA_CHECK
                           ( PART_NO,
                             REVISION,
                             SECTION_ID,
                             SUB_SECTION_ID,
                             PROPERTY_GROUP,
                             PROPERTY,
                             ATTRIBUTE,
                             HEADER_ID,
                             REASON )
                    VALUES ( LRSPECDATA.PART_NO,
                             LRSPECDATA.REVISION,
                             LRSPECDATA.SECTION_ID,
                             LRSPECDATA.SUB_SECTION_ID,
                             LRSPECDATA.PROPERTY_GROUP,
                             LRSPECDATA.PROPERTY,
                             LRSPECDATA.ATTRIBUTE,
                             LRSPECDATA.HEADER_ID,
                             'Item available in specdata but missing in specification' );
            EXCEPTION
               WHEN OTHERS
               THEN
                  DBMS_OUTPUT.PUT_LINE( SQLERRM );
            END;

            COMMIT;
         END IF;
      END LOOP;

      
      INSERT INTO SPECDATA_CHECK
                  ( PART_NO,
                    REVISION,
                    REASON )
           VALUES ( 'Finished',
                    0,
                       'Procedure finished on '
                    || SYSDATE );

      COMMIT;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.PUT_LINE( SQLERRM );
   END INSERTSPECDATACHECK;

   
   PROCEDURE CONVERTSPECIFICATION(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE )
   IS
      
      
      
      
      
      
      
      
      
      
      LSCOLUMN                      VARCHAR2( 256 );
      LNFLOATCOLUMN                 NUMBER;
      LDDATECOLUMN                  DATE;
      LNCHARACTERISTICID            IAPITYPE.ID_TYPE;
      LNASSOCIATIONID               IAPITYPE.ID_TYPE;
      LNRESULT                      INTEGER;
      LNVALUETYPE                   SPECDATA.VALUE_TYPE%TYPE;
      LNCOUNTER                     NUMBER;
      LNCOUNTSTAGES                 NUMBER;
      LBDATA                        BOOLEAN;
      LNUOMTYPE                     SPECIFICATION_HEADER.UOM_TYPE%TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ConvertSpecification';

      CURSOR CUR_SECTION(
         P_PART_NO                           IAPITYPE.PARTNO_TYPE,
         P_REVISION                          IAPITYPE.REVISION_TYPE,
         P_SC                                IAPITYPE.ID_TYPE,
         P_SB                                IAPITYPE.ID_TYPE )
      IS
         SELECT   *
             FROM SPECIFICATION_SECTION
            WHERE PART_NO = P_PART_NO
              AND REVISION = P_REVISION
              AND SECTION_ID = DECODE( P_SC,
                                       NULL, SECTION_ID,
                                       P_SC )
              AND SUB_SECTION_ID = DECODE( P_SB,
                                           NULL, SUB_SECTION_ID,
                                           P_SB )
         ORDER BY SECTION_SEQUENCE_NO;


      CURSOR CUR_LAYOUT(
         P_LAYOUT_ID                         IAPITYPE.ID_TYPE,
         P_LAYOUT_REV                        IAPITYPE.REVISION_TYPE )
      IS
         SELECT *
           FROM PROPERTY_LAYOUT
          WHERE LAYOUT_ID = P_LAYOUT_ID
            AND REVISION = P_LAYOUT_REV;

      CURSOR CUR_LAYOUT_PROCESS(
         P_LAYOUT_ID                         IAPITYPE.ID_TYPE )
      IS
         SELECT *
           FROM PROPERTY_LAYOUT B
          WHERE B.LAYOUT_ID = P_LAYOUT_ID
            AND B.REVISION = ( SELECT MAX( A.REVISION )
                                FROM PROPERTY_LAYOUT A
                               WHERE A.LAYOUT_ID = B.LAYOUT_ID );


      CURSOR CUR_PG(
         P_PART_NO                           IAPITYPE.PARTNO_TYPE,
         P_REVISION                          IAPITYPE.ID_TYPE,
         P_SECTION                           IAPITYPE.REVISION_TYPE,
         P_SUB_SECTION                       IAPITYPE.ID_TYPE,
         P_PROPERTY_GROUP                    IAPITYPE.ID_TYPE )
      IS
         SELECT   *
             FROM SPECIFICATION_PROP
            WHERE PART_NO = P_PART_NO
              AND REVISION = P_REVISION
              AND SECTION_ID = P_SECTION
              AND SUB_SECTION_ID = P_SUB_SECTION
              AND PROPERTY_GROUP = P_PROPERTY_GROUP
         ORDER BY SEQUENCE_NO;


      CURSOR CUR_SP(
         P_PART_NO                           IAPITYPE.PARTNO_TYPE,
         P_REVISION                          IAPITYPE.REVISION_TYPE,
         P_SECTION                           IAPITYPE.ID_TYPE,
         P_SUB_SECTION                       IAPITYPE.ID_TYPE,
         P_PROPERTY                          IAPITYPE.ID_TYPE )
      IS
         SELECT   *
             FROM SPECIFICATION_PROP
            WHERE PART_NO = P_PART_NO
              AND REVISION = P_REVISION
              AND SECTION_ID = P_SECTION
              AND SUB_SECTION_ID = P_SUB_SECTION
              AND PROPERTY_GROUP = 0
              AND PROPERTY = P_PROPERTY
         ORDER BY SEQUENCE_NO;


      CURSOR CUR_PG_LANG(
         P_PART_NO                           IAPITYPE.PARTNO_TYPE,
         P_REVISION                          IAPITYPE.REVISION_TYPE,
         P_SECTION                           IAPITYPE.ID_TYPE,
         P_SUB_SECTION                       IAPITYPE.ID_TYPE,
         P_PROPERTY_GROUP                    IAPITYPE.ID_TYPE,
         P_PROPERTY                          IAPITYPE.ID_TYPE,
         P_ATTRIBUTE                         IAPITYPE.ID_TYPE )
      IS
         SELECT   *
             FROM SPECIFICATION_PROP_LANG
            WHERE PART_NO = P_PART_NO
              AND REVISION = P_REVISION
              AND SECTION_ID = P_SECTION
              AND SUB_SECTION_ID = P_SUB_SECTION
              AND PROPERTY_GROUP = P_PROPERTY_GROUP
              AND PROPERTY = P_PROPERTY
              AND ATTRIBUTE = P_ATTRIBUTE
         ORDER BY SEQUENCE_NO;


      CURSOR CUR_SP_LANG(
         P_PART_NO                           IAPITYPE.PARTNO_TYPE,
         P_REVISION                          IAPITYPE.REVISION_TYPE,
         P_SECTION                           IAPITYPE.ID_TYPE,
         P_SUB_SECTION                       IAPITYPE.ID_TYPE,
         P_PROPERTY_GROUP                    IAPITYPE.ID_TYPE,
         P_PROPERTY                          IAPITYPE.ID_TYPE,
         P_ATTRIBUTE                         IAPITYPE.ID_TYPE )
      IS
         SELECT   *
             FROM SPECIFICATION_PROP_LANG
            WHERE PART_NO = P_PART_NO
              AND REVISION = P_REVISION
              AND SECTION_ID = P_SECTION
              AND SUB_SECTION_ID = P_SUB_SECTION
              AND PROPERTY_GROUP = 0
              AND PROPERTY = P_PROPERTY
              AND ATTRIBUTE = P_ATTRIBUTE
         ORDER BY SEQUENCE_NO;



      CURSOR CUR_PROCESS(
         P_PART_NO                           IAPITYPE.PARTNO_TYPE,
         P_REVISION                          IAPITYPE.REVISION_TYPE )
      IS
         SELECT *
           FROM SPECIFICATION_LINE
          WHERE PART_NO = P_PART_NO
            AND REVISION = P_REVISION;

      CURSOR CUR_STAGE(
         P_PART_NO                           IAPITYPE.PARTNO_TYPE,
         P_REVISION                          IAPITYPE.REVISION_TYPE,
         P_PLANT                             IAPITYPE.PLANTNO_TYPE,
         P_LINE                              IAPITYPE.LINE_TYPE,
         P_CONFIGURATION                     IAPITYPE.CONFIGURATION_TYPE,
         P_PROCESS_LINE_REV                  IAPITYPE.REVISION_TYPE )
      IS
         SELECT   *
             FROM SPECIFICATION_STAGE
            WHERE PART_NO = P_PART_NO
              AND REVISION = P_REVISION
              AND PLANT = P_PLANT
              AND LINE = P_LINE
              AND CONFIGURATION = P_CONFIGURATION
              AND PROCESS_LINE_REV IN( 0, 1 )
         ORDER BY SEQUENCE_NO;

      CURSOR CUR_STAGE_PROP(
         P_PART_NO                           IAPITYPE.PARTNO_TYPE,
         P_REVISION                          IAPITYPE.REVISION_TYPE,
         P_PLANT                             IAPITYPE.PLANTNO_TYPE,
         P_LINE                              IAPITYPE.LINE_TYPE,
         P_CONFIGURATION                     IAPITYPE.CONFIGURATION_TYPE,
         P_PROCESS_LINE_REV                  IAPITYPE.REVISION_TYPE,
         P_SECTION                           IAPITYPE.ID_TYPE,
         P_SUB_SECTION                       IAPITYPE.ID_TYPE,
         P_STAGE                             IAPITYPE.ID_TYPE )
      IS
         SELECT   *
             FROM SPECIFICATION_LINE_PROP
            WHERE PART_NO = P_PART_NO
              AND REVISION = P_REVISION
              AND PLANT = P_PLANT
              AND LINE = P_LINE
              AND CONFIGURATION = P_CONFIGURATION
              AND PROCESS_LINE_REV = P_PROCESS_LINE_REV
              AND STAGE = P_STAGE
         ORDER BY SEQUENCE_NO;


      CURSOR CUR_STAGE_PROP_LANG(
         P_PART_NO                           IAPITYPE.PARTNO_TYPE,
         P_REVISION                          IAPITYPE.REVISION_TYPE,
         P_PLANT                             IAPITYPE.PLANTNO_TYPE,
         P_LINE                              IAPITYPE.LINE_TYPE,
         P_CONFIGURATION                     IAPITYPE.CONFIGURATION_TYPE,
         P_STAGE                             IAPITYPE.ID_TYPE,
         P_PROPERTY                          IAPITYPE.ID_TYPE,
         P_ATTRIBUTE                         IAPITYPE.ID_TYPE,
         P_SEQUENCE                          IAPITYPE.SEQUENCE_TYPE )
      IS
         SELECT   *
             FROM ITSHLNPROPLANG
            WHERE PART_NO = P_PART_NO
              AND REVISION = P_REVISION
              AND PLANT = P_PLANT
              AND LINE = P_LINE
              AND CONFIGURATION = P_CONFIGURATION
              AND PROPERTY = P_PROPERTY
              AND ATTRIBUTE = P_ATTRIBUTE
              AND SEQUENCE_NO = P_SEQUENCE
         ORDER BY SEQUENCE_NO;


      CURSOR CUR_BOOLEAN
      IS
         SELECT *
           FROM SPECIFICATION_SECTION
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND TYPE IN( IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP, IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY );
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );


      BEGIN
         SELECT UOM_TYPE
           INTO LNUOMTYPE
           FROM SPECIFICATION_HEADER
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION;
      EXCEPTION
         WHEN OTHERS
         THEN
            LNUOMTYPE := 0;
      END;

      LNCOUNTER := 1;

      BEGIN
         IF ANSECTIONID IS NULL
         THEN

            DELETE FROM SPECDATA
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;

            DELETE FROM SPECDATA_PROCESS
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION;
         ELSE

            DELETE FROM SPECDATA
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION
                    AND SECTION_ID = ANSECTIONID
                    AND SUB_SECTION_ID = ANSUBSECTIONID;

            DELETE FROM SPECDATA_PROCESS
                  WHERE PART_NO = ASPARTNO
                    AND REVISION = ANREVISION
                    AND SECTION_ID = ANSECTIONID
                    AND SUB_SECTION_ID = ANSUBSECTIONID;
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RAISE_APPLICATION_ERROR( -20000,
                                     SQLERRM );
      END;


      FOR REC_SECTION IN CUR_SECTION( ASPARTNO,
                                      ANREVISION,
                                      ANSECTIONID,
                                      ANSUBSECTIONID )
      LOOP
         LBDATA := FALSE;


         IF REC_SECTION.TYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP
         THEN   
            FOR REC_PG IN CUR_PG( ASPARTNO,
                                  ANREVISION,
                                  REC_SECTION.SECTION_ID,
                                  REC_SECTION.SUB_SECTION_ID,
                                  REC_SECTION.REF_ID )
            LOOP
               LBDATA := TRUE;

               FOR REC_LAYOUT IN CUR_LAYOUT( REC_SECTION.DISPLAY_FORMAT,
                                             REC_SECTION.DISPLAY_FORMAT_REV )
               LOOP

                  LSCOLUMN := '';
                  LDDATECOLUMN := NULL;

                  IF REC_LAYOUT.FIELD_ID = 1
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_1;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( LNFLOATCOLUMN );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 2
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_2;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( LNFLOATCOLUMN );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 3
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_3;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( LNFLOATCOLUMN );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 4
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_4;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( LNFLOATCOLUMN );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 5
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_5;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( LNFLOATCOLUMN );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 6
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_6;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( LNFLOATCOLUMN );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 7
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_7;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( LNFLOATCOLUMN );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 8
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_8;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( LNFLOATCOLUMN );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 9
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_9;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( LNFLOATCOLUMN );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 10
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_10;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( LNFLOATCOLUMN );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 11
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.CHAR_1;
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 12
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.CHAR_2;
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 13
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.CHAR_3;
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 14
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.CHAR_4;
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 15
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.CHAR_5;
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 16
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.CHAR_6;
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 17
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.BOOLEAN_1;

                     IF LSCOLUMN IS NULL
                     THEN
                        LSCOLUMN := 'N';
                     END IF;

                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 18
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.BOOLEAN_2;

                     IF LSCOLUMN IS NULL
                     THEN
                        LSCOLUMN := 'N';
                     END IF;

                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 19
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.BOOLEAN_3;

                     IF LSCOLUMN IS NULL
                     THEN
                        LSCOLUMN := 'N';
                     END IF;

                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 20
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.BOOLEAN_4;

                     IF LSCOLUMN IS NULL
                     THEN
                        LSCOLUMN := 'N';
                     END IF;

                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 21
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := TO_CHAR( REC_PG.DATE_1,
                                          'dd-mm-yyyy hh24:mi:ss' );
                     LDDATECOLUMN := REC_PG.DATE_1;

                     IF LDDATECOLUMN IS NULL
                     THEN
                        LNVALUETYPE := 1;
                     ELSE
                        LNVALUETYPE := 2;
                     END IF;
                  ELSIF REC_LAYOUT.FIELD_ID = 22
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := TO_CHAR( REC_PG.DATE_2,
                                          'dd-mm-yyyy hh24:mi:ss' );
                     LDDATECOLUMN := REC_PG.DATE_2;

                     IF LDDATECOLUMN IS NULL
                     THEN
                        LNVALUETYPE := 1;
                     ELSE
                        LNVALUETYPE := 2;
                     END IF;
                  ELSIF REC_LAYOUT.FIELD_ID = 26
                  THEN
                     LNFLOATCOLUMN := REC_PG.CHARACTERISTIC;
                     LSCOLUMN := F_CHH_DESCR( 1,
                                              REC_PG.CHARACTERISTIC,
                                              0 );
                     LNVALUETYPE := 0;
                     LNCHARACTERISTICID := REC_PG.CHARACTERISTIC;
                     LNASSOCIATIONID := REC_PG.ASSOCIATION;

                  ELSIF REC_LAYOUT.FIELD_ID = 30
                  THEN
                     LNFLOATCOLUMN := REC_PG.CH_2;
                     LSCOLUMN := F_CHH_DESCR( 1,
                                              REC_PG.CH_2,
                                              0 );
                     LNVALUETYPE := 0;
                     LNCHARACTERISTICID := REC_PG.CH_2;
                     LNASSOCIATIONID := REC_PG.AS_2;

                  ELSIF REC_LAYOUT.FIELD_ID = 31
                  THEN
                     LNFLOATCOLUMN := REC_PG.CH_3;
                     LSCOLUMN := F_CHH_DESCR( 1,
                                              REC_PG.CH_3,
                                              0 );
                     LNVALUETYPE := 0;
                     LNCHARACTERISTICID := REC_PG.CH_3;
                     LNASSOCIATIONID := REC_PG.AS_3;

                  END IF;


                  IF    REC_LAYOUT.FIELD_ID < 23
                     OR REC_LAYOUT.FIELD_ID = 24
                     OR REC_LAYOUT.FIELD_ID = 26
                     OR REC_LAYOUT.FIELD_ID = 30
                     OR REC_LAYOUT.FIELD_ID = 31
                  THEN
                     BEGIN
                        LNCOUNTER :=   LNCOUNTER
                                     + 1;

                        IF LNVALUETYPE = 2
                        THEN

                           INSERT INTO SPECDATA
                                       ( REVISION,
                                         PART_NO,
                                         SECTION_ID,
                                         SUB_SECTION_ID,
                                         SECTION_REV,
                                         SUB_SECTION_REV,
                                         SEQUENCE_NO,
                                         TYPE,
                                         REF_ID,
                                         REF_VER,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         PROPERTY_GROUP_REV,
                                         PROPERTY_REV,
                                         ATTRIBUTE_REV,
                                         HEADER_ID,
                                         HEADER_REV,
                                         VALUE,
                                         VALUE_S,
                                         VALUE_DT,
                                         VALUE_TYPE,
                                         UOM_ID,
                                         TEST_METHOD,
                                         CHARACTERISTIC,
                                         ASSOCIATION,
                                         UOM_REV,
                                         TEST_METHOD_REV,
                                         CHARACTERISTIC_REV,
                                         ASSOCIATION_REV,
                                         REF_INFO,
                                         INTL )
                                VALUES ( ANREVISION,
                                         ASPARTNO,
                                         REC_SECTION.SECTION_ID,
                                         REC_SECTION.SUB_SECTION_ID,
                                         REC_SECTION.SECTION_REV,
                                         REC_SECTION.SUB_SECTION_REV,
                                         NVL( LNCOUNTER,
                                              0 ),
                                         REC_SECTION.TYPE,
                                         NVL( REC_SECTION.REF_ID,
                                              -1 ),
                                         NVL( REC_SECTION.REF_VER,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_GROUP,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY,
                                              -1 ),
                                         NVL( REC_PG.ATTRIBUTE,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_GROUP_REV,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_REV,
                                              -1 ),
                                         NVL( REC_PG.ATTRIBUTE_REV,
                                              -1 ),
                                         NVL( REC_LAYOUT.HEADER_ID,
                                              -1 ),
                                         NVL( REC_LAYOUT.HEADER_REV,
                                              -1 ),
                                         NVL( LNFLOATCOLUMN,
                                              0 ),
                                         LSCOLUMN,
                                         TO_DATE( LSCOLUMN,
                                                  'dd-mm-yyyy hh24:mi:ss' ),
                                         NVL( LNVALUETYPE,
                                              0 ),
                                         NVL( REC_PG.UOM_ID,
                                              -1 ),
                                         DECODE( REC_PG.TEST_METHOD,
                                                 0, -1,
                                                 NVL( REC_PG.TEST_METHOD,
                                                      -1 ) ),
                                         NVL( LNCHARACTERISTICID,
                                              -1 ),
                                         NVL( LNASSOCIATIONID,
                                              -1 ),
                                         NVL( REC_PG.UOM_REV,
                                              -1 ),
                                         NVL( REC_PG.TEST_METHOD_REV,
                                              -1 ),
                                         NVL( REC_PG.CHARACTERISTIC_REV,
                                              -1 ),
                                         NVL( REC_PG.ASSOCIATION_REV,
                                              -1 ),
                                         NVL( REC_SECTION.REF_INFO,
                                              -1 ),
                                         NVL( REC_SECTION.INTL,
                                              -1 ) );

                        ELSE

                           INSERT INTO SPECDATA
                                       ( REVISION,
                                         PART_NO,
                                         SECTION_ID,
                                         SUB_SECTION_ID,
                                         SECTION_REV,
                                         SUB_SECTION_REV,
                                         SEQUENCE_NO,
                                         TYPE,
                                         REF_ID,
                                         REF_VER,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         PROPERTY_GROUP_REV,
                                         PROPERTY_REV,
                                         ATTRIBUTE_REV,
                                         HEADER_ID,
                                         HEADER_REV,
                                         VALUE,
                                         VALUE_S,
                                         VALUE_TYPE,
                                         UOM_ID,
                                         TEST_METHOD,
                                         CHARACTERISTIC,
                                         ASSOCIATION,
                                         UOM_REV,
                                         TEST_METHOD_REV,
                                         CHARACTERISTIC_REV,
                                         ASSOCIATION_REV,
                                         REF_INFO,
                                         INTL )
                                VALUES ( ANREVISION,
                                         ASPARTNO,
                                         REC_SECTION.SECTION_ID,
                                         REC_SECTION.SUB_SECTION_ID,
                                         REC_SECTION.SECTION_REV,
                                         REC_SECTION.SUB_SECTION_REV,
                                         NVL( LNCOUNTER,
                                              0 ),
                                         REC_SECTION.TYPE,
                                         NVL( REC_SECTION.REF_ID,
                                              -1 ),
                                         NVL( REC_SECTION.REF_VER,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_GROUP,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY,
                                              -1 ),
                                         NVL( REC_PG.ATTRIBUTE,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_GROUP_REV,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_REV,
                                              -1 ),
                                         NVL( REC_PG.ATTRIBUTE_REV,
                                              -1 ),
                                         NVL( REC_LAYOUT.HEADER_ID,
                                              -1 ),
                                         NVL( REC_LAYOUT.HEADER_REV,
                                              -1 ),
                                         LNFLOATCOLUMN,
                                         LSCOLUMN,
                                         NVL( LNVALUETYPE,
                                              0 ),
                                         NVL( DECODE( LNUOMTYPE,
                                                      1, DECODE( REC_PG.UOM_ALT_ID,
                                                                 NULL, REC_PG.UOM_ID,
                                                                 REC_PG.UOM_ALT_ID ),
                                                      REC_PG.UOM_ID ),
                                              -1 ),
                                         DECODE( REC_PG.TEST_METHOD,
                                                 0, -1,
                                                 NVL( REC_PG.TEST_METHOD,
                                                      -1 ) ),
                                         NVL( LNCHARACTERISTICID,
                                              -1 ),
                                         NVL( LNASSOCIATIONID,
                                              -1 ),
                                         NVL( DECODE( LNUOMTYPE,
                                                      1, DECODE( REC_PG.UOM_ALT_ID,
                                                                 NULL, REC_PG.UOM_REV,
                                                                 REC_PG.UOM_ALT_REV ),
                                                      REC_PG.UOM_REV ),
                                              -1 ),
                                         NVL( REC_PG.TEST_METHOD_REV,
                                              -1 ),
                                         NVL( REC_PG.CHARACTERISTIC_REV,
                                              -1 ),
                                         NVL( REC_PG.ASSOCIATION_REV,
                                              -1 ),
                                         NVL( REC_SECTION.REF_INFO,
                                              -1 ),
                                         NVL( REC_SECTION.INTL,
                                              -1 ) );

                        END IF;
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                 LSMETHOD,
                                                 SQLERRM );
                           DBMS_OUTPUT.PUT_LINE(    'PG '
                                                 || SUBSTR( SQLERRM,
                                                            1,
                                                            255 ) );
                           DBMS_OUTPUT.PUT_LINE(    'PG info  '
                                                 || LSCOLUMN
                                                 || '    '
                                                 || REC_LAYOUT.FIELD_ID );
                           RAISE_APPLICATION_ERROR( -20000,
                                                    SQLERRM );
                     END;
                  END IF;
               END LOOP;


               FOR REC_PG_LANG IN CUR_PG_LANG( ASPARTNO,
                                               ANREVISION,
                                               REC_PG.SECTION_ID,
                                               REC_PG.SUB_SECTION_ID,
                                               REC_PG.PROPERTY_GROUP,
                                               REC_PG.PROPERTY,
                                               REC_PG.ATTRIBUTE )
               LOOP
                  LBDATA := TRUE;

                  FOR REC_LAYOUT IN CUR_LAYOUT( REC_SECTION.DISPLAY_FORMAT,
                                                REC_SECTION.DISPLAY_FORMAT_REV )
                  LOOP

                     LSCOLUMN := '';
                     LDDATECOLUMN := NULL;

                     IF REC_LAYOUT.FIELD_ID = 11
                     THEN
                        LNFLOATCOLUMN := 0;
                        LSCOLUMN := REC_PG_LANG.CHAR_1;
                     ELSIF REC_LAYOUT.FIELD_ID = 12
                     THEN
                        LNFLOATCOLUMN := 0;
                        LSCOLUMN := REC_PG_LANG.CHAR_2;
                     ELSIF REC_LAYOUT.FIELD_ID = 13
                     THEN
                        LNFLOATCOLUMN := 0;
                        LSCOLUMN := REC_PG_LANG.CHAR_3;
                     ELSIF REC_LAYOUT.FIELD_ID = 14
                     THEN
                        LNFLOATCOLUMN := 0;
                        LSCOLUMN := REC_PG_LANG.CHAR_4;
                     ELSIF REC_LAYOUT.FIELD_ID = 15
                     THEN
                        LNFLOATCOLUMN := 0;
                        LSCOLUMN := REC_PG_LANG.CHAR_5;
                     ELSIF REC_LAYOUT.FIELD_ID = 16
                     THEN
                        LNFLOATCOLUMN := 0;
                        LSCOLUMN := REC_PG_LANG.CHAR_6;
                     END IF;


                     IF REC_LAYOUT.FIELD_ID IN( 11, 12, 13, 14, 15, 16 )
                     THEN
                        BEGIN
                           LNCOUNTER :=   LNCOUNTER
                                        + 1;


                           INSERT INTO SPECDATA
                                       ( REVISION,
                                         PART_NO,
                                         LANG_ID,
                                         SECTION_ID,
                                         SUB_SECTION_ID,
                                         SECTION_REV,
                                         SUB_SECTION_REV,
                                         SEQUENCE_NO,
                                         TYPE,
                                         REF_ID,
                                         REF_VER,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         PROPERTY_GROUP_REV,
                                         PROPERTY_REV,
                                         ATTRIBUTE_REV,
                                         HEADER_ID,
                                         HEADER_REV,
                                         VALUE,
                                         VALUE_S,
                                         VALUE_TYPE,
                                         UOM_ID,
                                         TEST_METHOD,
                                         CHARACTERISTIC,
                                         ASSOCIATION,
                                         UOM_REV,
                                         TEST_METHOD_REV,
                                         CHARACTERISTIC_REV,
                                         ASSOCIATION_REV,
                                         REF_INFO,
                                         INTL )
                                VALUES ( ANREVISION,
                                         ASPARTNO,
                                         REC_PG_LANG.LANG_ID,
                                         REC_SECTION.SECTION_ID,
                                         REC_SECTION.SUB_SECTION_ID,
                                         REC_SECTION.SECTION_REV,
                                         REC_SECTION.SUB_SECTION_REV,
                                         NVL( LNCOUNTER,
                                              0 ),
                                         REC_SECTION.TYPE,
                                         NVL( REC_SECTION.REF_ID,
                                              -1 ),
                                         NVL( REC_SECTION.REF_VER,
                                              -1 ),
                                         NVL( REC_PG_LANG.PROPERTY_GROUP,
                                              -1 ),
                                         NVL( REC_PG_LANG.PROPERTY,
                                              -1 ),
                                         NVL( REC_PG_LANG.ATTRIBUTE,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_GROUP_REV,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_REV,
                                              -1 ),
                                         NVL( REC_PG.ATTRIBUTE_REV,
                                              -1 ),
                                         NVL( REC_LAYOUT.HEADER_ID,
                                              -1 ),
                                         NVL( REC_LAYOUT.HEADER_REV,
                                              -1 ),
                                         LNFLOATCOLUMN,
                                         LSCOLUMN,
                                         NVL( LNVALUETYPE,
                                              0 ),
                                         NVL( DECODE( LNUOMTYPE,
                                                      1, DECODE( REC_PG.UOM_ALT_ID,
                                                                 NULL, REC_PG.UOM_ID,
                                                                 REC_PG.UOM_ALT_ID ),
                                                      REC_PG.UOM_ID ),
                                              -1 ),
                                         DECODE( REC_PG.TEST_METHOD,
                                                 0, -1,
                                                 NVL( REC_PG.TEST_METHOD,
                                                      -1 ) ),
                                         NVL( REC_PG.CHARACTERISTIC,
                                              -1 ),
                                         NVL( REC_PG.ASSOCIATION,
                                              -1 ),
                                         NVL( DECODE( LNUOMTYPE,
                                                      1, DECODE( REC_PG.UOM_ALT_ID,
                                                                 NULL, REC_PG.UOM_REV,
                                                                 REC_PG.UOM_ALT_REV ),
                                                      REC_PG.UOM_REV ),
                                              -1 ),
                                         NVL( REC_PG.TEST_METHOD_REV,
                                              -1 ),
                                         NVL( REC_PG.CHARACTERISTIC_REV,
                                              -1 ),
                                         NVL( REC_PG.ASSOCIATION_REV,
                                              -1 ),
                                         NVL( REC_SECTION.REF_INFO,
                                              -1 ),
                                         NVL( REC_SECTION.INTL,
                                              -1 ) );
                        EXCEPTION
                           WHEN OTHERS
                           THEN
                              IAPIGENERAL.LOGERROR( GSSOURCE,
                                                    LSMETHOD,
                                                    SQLERRM );
                              RAISE_APPLICATION_ERROR( -20000,
                                                       SQLERRM );
                        END;
                     END IF;
                  END LOOP;
               END LOOP;
            END LOOP;

            IF NOT( LBDATA )
            THEN
               BEGIN
                 
                 
                 LSCOLUMN := '';
 
                  LNCOUNTER :=   LNCOUNTER
                               + 1;

                  INSERT INTO SPECDATA
                              ( REVISION,
                                PART_NO,
                                SECTION_ID,
                                SUB_SECTION_ID,
                                SECTION_REV,
                                SUB_SECTION_REV,
                                SEQUENCE_NO,
                                TYPE,
                                REF_ID,
                                REF_VER,
                                REF_OWNER,
                                PROPERTY_GROUP,
                                VALUE_S,
                                REF_INFO,
                                INTL )
                       VALUES ( ANREVISION,
                                ASPARTNO,
                                REC_SECTION.SECTION_ID,
                                REC_SECTION.SUB_SECTION_ID,
                                REC_SECTION.SECTION_REV,
                                REC_SECTION.SUB_SECTION_REV,
                                NVL( LNCOUNTER,
                                     0 ),
                                REC_SECTION.TYPE,
                                NVL( REC_SECTION.REF_ID,
                                     -1 ),
                                NVL( REC_SECTION.REF_VER,
                                     -1 ),
                                NVL( REC_SECTION.REF_OWNER,
                                     -1 ),
                                NVL( REC_SECTION.REF_ID,
                                     -1 ),
                                LSCOLUMN,
                                NVL( REC_SECTION.REF_INFO,
                                     -1 ),
                                NVL( REC_SECTION.INTL,
                                     0 ) );
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     IAPIGENERAL.LOGERROR( GSSOURCE,
                                           LSMETHOD,
                                           SQLERRM );
                     RAISE_APPLICATION_ERROR( -20000,
                                              SQLERRM );
               END;
            END IF;


            UPDATE SPECIFICATION_PROP
               SET TM_SET_NO = NULL
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND TEST_METHOD IS NULL
               AND TM_SET_NO IS NOT NULL;
         ELSIF REC_SECTION.TYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY
         THEN

            FOR REC_PG IN CUR_SP( ASPARTNO,
                                  ANREVISION,
                                  REC_SECTION.SECTION_ID,
                                  REC_SECTION.SUB_SECTION_ID,
                                  REC_SECTION.REF_ID )
            LOOP
               FOR REC_LAYOUT IN CUR_LAYOUT( REC_SECTION.DISPLAY_FORMAT,
                                             REC_SECTION.DISPLAY_FORMAT_REV )
               LOOP
                  LSCOLUMN := '';
                  LDDATECOLUMN := NULL;

                  IF REC_LAYOUT.FIELD_ID = 1
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_1;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_1 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 2
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_2;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_2 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 3
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_3;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_3 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 4
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_4;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_4 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 5
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_5;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_5 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 6
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_6;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_6 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 7
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_7;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_7 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 8
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_8;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_8 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 9
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_9;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_9 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 10
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_10;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_10 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 11
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.CHAR_1;
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 12
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.CHAR_2;
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 13
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.CHAR_3;
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 14
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.CHAR_4;
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 15
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.CHAR_5;
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 16
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.CHAR_6;
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 17
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.BOOLEAN_1;

                     IF LSCOLUMN IS NULL
                     THEN
                        LSCOLUMN := 'N';
                     END IF;

                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 18
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.BOOLEAN_2;

                     IF LSCOLUMN IS NULL
                     THEN
                        LSCOLUMN := 'N';
                     END IF;

                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 19
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.BOOLEAN_3;

                     IF LSCOLUMN IS NULL
                     THEN
                        LSCOLUMN := 'N';
                     END IF;

                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 20
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.BOOLEAN_4;

                     IF LSCOLUMN IS NULL
                     THEN
                        LSCOLUMN := 'N';
                     END IF;

                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 21
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := TO_CHAR( REC_PG.DATE_1,
                                          'dd-mm-yyyy hh24:mi:ss' );
                     LDDATECOLUMN := REC_PG.DATE_1;

                     IF LDDATECOLUMN IS NULL
                     THEN
                        LNVALUETYPE := 1;
                     ELSE
                        LNVALUETYPE := 2;
                     END IF;
                  ELSIF REC_LAYOUT.FIELD_ID = 22
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := TO_CHAR( REC_PG.DATE_2,
                                          'dd-mm-yyyy hh24:mi:ss' );
                     LDDATECOLUMN := REC_PG.DATE_2;

                     IF LDDATECOLUMN IS NULL
                     THEN
                        LNVALUETYPE := 1;
                     ELSE
                        LNVALUETYPE := 2;
                     END IF;
                  ELSIF REC_LAYOUT.FIELD_ID = 26
                  THEN

                     LNFLOATCOLUMN := 0;
                     LNFLOATCOLUMN := REC_PG.CHARACTERISTIC;
                     LSCOLUMN := F_CHH_DESCR( 1,
                                              REC_PG.CHARACTERISTIC,
                                              0 );
                     LNVALUETYPE := 0;
                     LNCHARACTERISTICID := REC_PG.CHARACTERISTIC;
                     LNASSOCIATIONID := REC_PG.ASSOCIATION;
                  ELSIF REC_LAYOUT.FIELD_ID = 30
                  THEN
                     LNFLOATCOLUMN := REC_PG.CH_2;
                     LSCOLUMN := F_CHH_DESCR( 1,
                                              REC_PG.CH_2,
                                              0 );
                     LNVALUETYPE := 0;
                     LNCHARACTERISTICID := REC_PG.CH_2;
                     LNASSOCIATIONID := REC_PG.AS_2;

                  ELSIF REC_LAYOUT.FIELD_ID = 31
                  THEN
                     LNFLOATCOLUMN := REC_PG.CH_3;
                     LSCOLUMN := F_CHH_DESCR( 1,
                                              REC_PG.CH_3,
                                              0 );
                     LNVALUETYPE := 0;
                     LNCHARACTERISTICID := REC_PG.CH_3;
                     LNASSOCIATIONID := REC_PG.AS_3;

                  END IF;

                  IF    REC_LAYOUT.FIELD_ID < 23
                     OR REC_LAYOUT.FIELD_ID = 26
                     OR REC_LAYOUT.FIELD_ID = 30
                     OR REC_LAYOUT.FIELD_ID = 31
                  THEN
                     BEGIN
                        LNCOUNTER :=   LNCOUNTER
                                     + 1;

                        IF LNVALUETYPE = 2
                        THEN   
                           INSERT INTO SPECDATA
                                       ( REVISION,
                                         PART_NO,
                                         SECTION_ID,
                                         SUB_SECTION_ID,
                                         SECTION_REV,
                                         SUB_SECTION_REV,
                                         SEQUENCE_NO,
                                         TYPE,
                                         REF_ID,
                                         REF_VER,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         PROPERTY_GROUP_REV,
                                         PROPERTY_REV,
                                         ATTRIBUTE_REV,
                                         HEADER_ID,
                                         HEADER_REV,
                                         VALUE,
                                         VALUE_S,
                                         VALUE_DT,
                                         VALUE_TYPE,
                                         UOM_ID,
                                         TEST_METHOD,
                                         CHARACTERISTIC,
                                         ASSOCIATION,
                                         UOM_REV,
                                         TEST_METHOD_REV,
                                         CHARACTERISTIC_REV,
                                         ASSOCIATION_REV,
                                         REF_INFO,
                                         INTL )
                                VALUES ( ANREVISION,
                                         ASPARTNO,
                                         REC_SECTION.SECTION_ID,
                                         REC_SECTION.SUB_SECTION_ID,
                                         REC_SECTION.SECTION_REV,
                                         REC_SECTION.SUB_SECTION_REV,
                                         NVL( LNCOUNTER,
                                              0 ),
                                         REC_SECTION.TYPE,
                                         NVL( REC_SECTION.REF_ID,
                                              -1 ),
                                         NVL( REC_SECTION.REF_VER,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_GROUP,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY,
                                              -1 ),
                                         NVL( REC_PG.ATTRIBUTE,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_GROUP_REV,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_REV,
                                              -1 ),
                                         NVL( REC_PG.ATTRIBUTE_REV,
                                              -1 ),
                                         NVL( REC_LAYOUT.HEADER_ID,
                                              -1 ),
                                         NVL( REC_LAYOUT.HEADER_REV,
                                              -1 ),
                                         NVL( LNFLOATCOLUMN,
                                              0 ),
                                         LSCOLUMN,
                                         TO_DATE( LSCOLUMN,
                                                  'dd-mm-yyyy hh24:mi:ss' ),
                                         NVL( LNVALUETYPE,
                                              0 ),
                                         NVL( REC_PG.UOM_ID,
                                              -1 ),
                                         DECODE( REC_PG.TEST_METHOD,
                                                 0, -1,
                                                 NVL( REC_PG.TEST_METHOD,
                                                      -1 ) ),
                                         NVL( LNCHARACTERISTICID,
                                              -1 ),
                                         NVL( LNASSOCIATIONID,
                                              -1 ),
                                         NVL( REC_PG.UOM_REV,
                                              -1 ),
                                         NVL( REC_PG.TEST_METHOD_REV,
                                              -1 ),
                                         NVL( REC_PG.CHARACTERISTIC_REV,
                                              -1 ),
                                         NVL( REC_PG.ASSOCIATION_REV,
                                              -1 ),
                                         NVL( REC_SECTION.REF_INFO,
                                              -1 ),
                                         NVL( REC_SECTION.INTL,
                                              -1 ) );
                        ELSE
                           INSERT INTO SPECDATA
                                       ( REVISION,
                                         PART_NO,
                                         SECTION_ID,
                                         SUB_SECTION_ID,
                                         SECTION_REV,
                                         SUB_SECTION_REV,
                                         SEQUENCE_NO,
                                         TYPE,
                                         REF_ID,
                                         REF_VER,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         PROPERTY_GROUP_REV,
                                         PROPERTY_REV,
                                         ATTRIBUTE_REV,
                                         HEADER_ID,
                                         HEADER_REV,
                                         VALUE,
                                         VALUE_S,
                                         VALUE_TYPE,
                                         UOM_ID,
                                         TEST_METHOD,
                                         CHARACTERISTIC,
                                         ASSOCIATION,
                                         UOM_REV,
                                         TEST_METHOD_REV,
                                         CHARACTERISTIC_REV,
                                         ASSOCIATION_REV,
                                         REF_INFO,
                                         INTL )
                                VALUES ( ANREVISION,
                                         ASPARTNO,
                                         REC_SECTION.SECTION_ID,
                                         REC_SECTION.SUB_SECTION_ID,
                                         REC_SECTION.SECTION_REV,
                                         REC_SECTION.SUB_SECTION_REV,
                                         NVL( LNCOUNTER,
                                              0 ),
                                         REC_SECTION.TYPE,
                                         NVL( REC_SECTION.REF_ID,
                                              -1 ),
                                         NVL( REC_SECTION.REF_VER,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_GROUP,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY,
                                              -1 ),
                                         NVL( REC_PG.ATTRIBUTE,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_GROUP_REV,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_REV,
                                              -1 ),
                                         NVL( REC_PG.ATTRIBUTE_REV,
                                              -1 ),
                                         NVL( REC_LAYOUT.HEADER_ID,
                                              -1 ),
                                         NVL( REC_LAYOUT.HEADER_REV,
                                              -1 ),
                                         LNFLOATCOLUMN,
                                         LSCOLUMN,
                                         NVL( LNVALUETYPE,
                                              0 ),
                                         NVL( DECODE( LNUOMTYPE,
                                                      1, DECODE( REC_PG.UOM_ALT_ID,
                                                                 NULL, REC_PG.UOM_ID,
                                                                 REC_PG.UOM_ALT_ID ),
                                                      REC_PG.UOM_ID ),
                                              -1 ),
                                         DECODE( REC_PG.TEST_METHOD,
                                                 0, -1,
                                                 NVL( REC_PG.TEST_METHOD,
                                                      -1 ) ),
                                         NVL( LNCHARACTERISTICID,
                                              -1 ),
                                         NVL( LNASSOCIATIONID,
                                              -1 ),
                                         NVL( DECODE( LNUOMTYPE,
                                                      1, DECODE( REC_PG.UOM_ALT_ID,
                                                                 NULL, REC_PG.UOM_REV,
                                                                 REC_PG.UOM_ALT_REV ),
                                                      REC_PG.UOM_REV ),
                                              -1 ),
                                         NVL( REC_PG.TEST_METHOD_REV,
                                              -1 ),
                                         NVL( REC_PG.CHARACTERISTIC_REV,
                                              -1 ),
                                         NVL( REC_PG.ASSOCIATION_REV,
                                              -1 ),
                                         NVL( REC_SECTION.REF_INFO,
                                              -1 ),
                                         NVL( REC_SECTION.INTL,
                                              0 ) );
                        END IF;
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                 LSMETHOD,
                                                 SQLERRM );
                           RAISE_APPLICATION_ERROR( -20000,
                                                    SQLERRM );
                     END;
                  END IF;
               END LOOP;


               FOR REC_PG_LANG IN CUR_SP_LANG( ASPARTNO,
                                               ANREVISION,
                                               REC_PG.SECTION_ID,
                                               REC_PG.SUB_SECTION_ID,
                                               REC_PG.PROPERTY_GROUP,
                                               REC_PG.PROPERTY,
                                               REC_PG.ATTRIBUTE )
               LOOP
                  LBDATA := TRUE;

                  FOR REC_LAYOUT IN CUR_LAYOUT( REC_SECTION.DISPLAY_FORMAT,
                                                REC_SECTION.DISPLAY_FORMAT_REV )
                  LOOP
                     LSCOLUMN := '';
                     LDDATECOLUMN := NULL;

                     IF REC_LAYOUT.FIELD_ID = 11
                     THEN
                        LNFLOATCOLUMN := 0;
                        LSCOLUMN := REC_PG_LANG.CHAR_1;
                     ELSIF REC_LAYOUT.FIELD_ID = 12
                     THEN
                        LNFLOATCOLUMN := 0;
                        LSCOLUMN := REC_PG_LANG.CHAR_2;
                     ELSIF REC_LAYOUT.FIELD_ID = 13
                     THEN
                        LNFLOATCOLUMN := 0;
                        LSCOLUMN := REC_PG_LANG.CHAR_3;
                     ELSIF REC_LAYOUT.FIELD_ID = 14
                     THEN
                        LNFLOATCOLUMN := 0;
                        LSCOLUMN := REC_PG_LANG.CHAR_4;
                     ELSIF REC_LAYOUT.FIELD_ID = 15
                     THEN
                        LNFLOATCOLUMN := 0;
                        LSCOLUMN := REC_PG_LANG.CHAR_5;
                     ELSIF REC_LAYOUT.FIELD_ID = 16
                     THEN
                        LNFLOATCOLUMN := 0;
                        LSCOLUMN := REC_PG_LANG.CHAR_6;
                     END IF;

                     IF REC_LAYOUT.FIELD_ID IN( 11, 12, 13, 14, 15, 16 )
                     THEN
                        BEGIN
                           LNCOUNTER :=   LNCOUNTER
                                        + 1;


                           INSERT INTO SPECDATA
                                       ( REVISION,
                                         PART_NO,
                                         LANG_ID,
                                         SECTION_ID,
                                         SUB_SECTION_ID,
                                         SECTION_REV,
                                         SUB_SECTION_REV,
                                         SEQUENCE_NO,
                                         TYPE,
                                         REF_ID,
                                         REF_VER,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         PROPERTY_GROUP_REV,
                                         PROPERTY_REV,
                                         ATTRIBUTE_REV,
                                         HEADER_ID,
                                         HEADER_REV,
                                         VALUE,
                                         VALUE_S,
                                         VALUE_TYPE,
                                         UOM_ID,
                                         TEST_METHOD,
                                         CHARACTERISTIC,
                                         ASSOCIATION,
                                         UOM_REV,
                                         TEST_METHOD_REV,
                                         CHARACTERISTIC_REV,
                                         ASSOCIATION_REV,
                                         REF_INFO,
                                         INTL )
                                VALUES ( ANREVISION,
                                         ASPARTNO,
                                         REC_PG_LANG.LANG_ID,
                                         REC_SECTION.SECTION_ID,
                                         REC_SECTION.SUB_SECTION_ID,
                                         REC_SECTION.SECTION_REV,
                                         REC_SECTION.SUB_SECTION_REV,
                                         NVL( LNCOUNTER,
                                              0 ),
                                         REC_SECTION.TYPE,
                                         NVL( REC_SECTION.REF_ID,
                                              -1 ),
                                         NVL( REC_SECTION.REF_VER,
                                              -1 ),
                                         NVL( REC_PG_LANG.PROPERTY_GROUP,
                                              -1 ),
                                         NVL( REC_PG_LANG.PROPERTY,
                                              -1 ),
                                         NVL( REC_PG_LANG.ATTRIBUTE,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_GROUP_REV,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_REV,
                                              -1 ),
                                         NVL( REC_PG.ATTRIBUTE_REV,
                                              -1 ),
                                         NVL( REC_LAYOUT.HEADER_ID,
                                              -1 ),
                                         NVL( REC_LAYOUT.HEADER_REV,
                                              -1 ),
                                         LNFLOATCOLUMN,
                                         LSCOLUMN,
                                         NVL( LNVALUETYPE,
                                              0 ),
                                         NVL( DECODE( LNUOMTYPE,
                                                      1, DECODE( REC_PG.UOM_ALT_ID,
                                                                 NULL, REC_PG.UOM_REV,
                                                                 REC_PG.UOM_ALT_REV ),
                                                      REC_PG.UOM_REV ),
                                              -1 ),
                                         DECODE( REC_PG.TEST_METHOD,
                                                 0, -1,
                                                 NVL( REC_PG.TEST_METHOD,
                                                      -1 ) ),
                                         NVL( REC_PG.CHARACTERISTIC,
                                              -1 ),
                                         NVL( REC_PG.ASSOCIATION,
                                              -1 ),
                                         NVL( DECODE( LNUOMTYPE,
                                                      1, DECODE( REC_PG.UOM_ALT_ID,
                                                                 NULL, REC_PG.UOM_REV,
                                                                 REC_PG.UOM_ALT_REV ),
                                                      REC_PG.UOM_REV ),
                                              -1 ),
                                         NVL( REC_PG.TEST_METHOD_REV,
                                              -1 ),
                                         NVL( REC_PG.CHARACTERISTIC_REV,
                                              -1 ),
                                         NVL( REC_PG.ASSOCIATION_REV,
                                              -1 ),
                                         NVL( REC_SECTION.REF_INFO,
                                              -1 ),
                                         NVL( REC_SECTION.INTL,
                                              -1 ) );

                        EXCEPTION
                           WHEN OTHERS
                           THEN
                              IAPIGENERAL.LOGERROR( GSSOURCE,
                                                    LSMETHOD,
                                                    SQLERRM );
                              RAISE_APPLICATION_ERROR( -20000,
                                                       SQLERRM );
                        END;
                     END IF;
                  END LOOP;
               END LOOP;
            END LOOP;


            UPDATE SPECIFICATION_PROP
               SET TM_SET_NO = NULL
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND TEST_METHOD IS NULL
               AND TM_SET_NO IS NOT NULL;
         ELSIF REC_SECTION.TYPE = IAPICONSTANT.SECTIONTYPE_PROCESSDATA
         THEN   
            FOR REC_PROCESS IN CUR_PROCESS( ASPARTNO,
                                            ANREVISION )
            LOOP
               FOR REC_STAGE IN CUR_STAGE( ASPARTNO,
                                           ANREVISION,
                                           REC_PROCESS.PLANT,
                                           REC_PROCESS.LINE,
                                           REC_PROCESS.CONFIGURATION,
                                           REC_PROCESS.PROCESS_LINE_REV )
               LOOP
                  LNCOUNTSTAGES := 0;

                  FOR REC_PG IN CUR_STAGE_PROP( ASPARTNO,
                                                ANREVISION,
                                                REC_PROCESS.PLANT,
                                                REC_PROCESS.LINE,
                                                REC_PROCESS.CONFIGURATION,
                                                REC_PROCESS.PROCESS_LINE_REV,
                                                REC_SECTION.SECTION_ID,
                                                REC_SECTION.SUB_SECTION_ID,
                                                REC_STAGE.STAGE )
                  LOOP
                     
                     IF    REC_PG.VALUE_TYPE IS NULL
                        OR REC_PG.VALUE_TYPE = 0
                     THEN
                        FOR REC_LAYOUT IN CUR_LAYOUT_PROCESS( REC_STAGE.DISPLAY_FORMAT )
                        LOOP
                           LSCOLUMN := '';
                           LDDATECOLUMN := NULL;

                           IF REC_LAYOUT.FIELD_ID = 1
                           THEN
                              LNFLOATCOLUMN := REC_PG.NUM_1;
                              LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_1 );
                              LNVALUETYPE := 0;
                           ELSIF REC_LAYOUT.FIELD_ID = 2
                           THEN
                              LNFLOATCOLUMN := REC_PG.NUM_2;
                              LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_2 );
                              LNVALUETYPE := 0;
                           ELSIF REC_LAYOUT.FIELD_ID = 3
                           THEN
                              LNFLOATCOLUMN := REC_PG.NUM_3;
                              LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_3 );
                              LNVALUETYPE := 0;
                           ELSIF REC_LAYOUT.FIELD_ID = 4
                           THEN
                              LNFLOATCOLUMN := REC_PG.NUM_4;
                              LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_4 );
                              LNVALUETYPE := 0;
                           ELSIF REC_LAYOUT.FIELD_ID = 5
                           THEN
                              LNFLOATCOLUMN := REC_PG.NUM_5;
                              LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_5 );
                              LNVALUETYPE := 0;
                           ELSIF REC_LAYOUT.FIELD_ID = 6
                           THEN
                              LNFLOATCOLUMN := REC_PG.NUM_6;
                              LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_6 );
                              LNVALUETYPE := 0;
                           ELSIF REC_LAYOUT.FIELD_ID = 7
                           THEN
                              LNFLOATCOLUMN := REC_PG.NUM_7;
                              LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_7 );
                              LNVALUETYPE := 0;
                           ELSIF REC_LAYOUT.FIELD_ID = 8
                           THEN
                              LNFLOATCOLUMN := REC_PG.NUM_8;
                              LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_8 );
                              LNVALUETYPE := 0;
                           ELSIF REC_LAYOUT.FIELD_ID = 9
                           THEN
                              LNFLOATCOLUMN := REC_PG.NUM_9;
                              LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_9 );
                              LNVALUETYPE := 0;
                           ELSIF REC_LAYOUT.FIELD_ID = 10
                           THEN
                              LNFLOATCOLUMN := REC_PG.NUM_10;
                              LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_10 );
                              LNVALUETYPE := 0;
                           ELSIF REC_LAYOUT.FIELD_ID = 11
                           THEN
                              LNFLOATCOLUMN := 0;
                              LSCOLUMN := REC_PG.CHAR_1;
                              LNVALUETYPE := 1;
                           ELSIF REC_LAYOUT.FIELD_ID = 12
                           THEN
                              LNFLOATCOLUMN := 0;
                              LSCOLUMN := REC_PG.CHAR_2;
                              LNVALUETYPE := 1;
                           ELSIF REC_LAYOUT.FIELD_ID = 13
                           THEN
                              LNFLOATCOLUMN := 0;
                              LSCOLUMN := REC_PG.CHAR_3;
                              LNVALUETYPE := 1;
                           ELSIF REC_LAYOUT.FIELD_ID = 14
                           THEN
                              LNFLOATCOLUMN := 0;
                              LSCOLUMN := REC_PG.CHAR_4;
                              LNVALUETYPE := 1;
                           ELSIF REC_LAYOUT.FIELD_ID = 15
                           THEN
                              LNFLOATCOLUMN := 0;
                              LSCOLUMN := REC_PG.CHAR_5;
                              LNVALUETYPE := 1;
                           ELSIF REC_LAYOUT.FIELD_ID = 16
                           THEN
                              LNFLOATCOLUMN := 0;
                              LSCOLUMN := REC_PG.CHAR_6;
                              LNVALUETYPE := 1;
                           ELSIF REC_LAYOUT.FIELD_ID = 17
                           THEN
                              LNFLOATCOLUMN := 0;
                              LSCOLUMN := REC_PG.BOOLEAN_1;

                              IF LSCOLUMN IS NULL
                              THEN
                                 LSCOLUMN := 'N';
                              END IF;

                              LNVALUETYPE := 1;
                           ELSIF REC_LAYOUT.FIELD_ID = 18
                           THEN
                              LNFLOATCOLUMN := 0;
                              LSCOLUMN := REC_PG.BOOLEAN_2;

                              IF LSCOLUMN IS NULL
                              THEN
                                 LSCOLUMN := 'N';
                              END IF;

                              LNVALUETYPE := 1;
                           ELSIF REC_LAYOUT.FIELD_ID = 19
                           THEN
                              LNFLOATCOLUMN := 0;
                              LSCOLUMN := REC_PG.BOOLEAN_3;

                              IF LSCOLUMN IS NULL
                              THEN
                                 LSCOLUMN := 'N';
                              END IF;

                              LNVALUETYPE := 1;
                           ELSIF REC_LAYOUT.FIELD_ID = 20
                           THEN
                              LNFLOATCOLUMN := 0;
                              LSCOLUMN := REC_PG.BOOLEAN_4;

                              IF LSCOLUMN IS NULL
                              THEN
                                 LSCOLUMN := 'N';
                              END IF;

                              LNVALUETYPE := 1;
                           ELSIF REC_LAYOUT.FIELD_ID = 21
                           THEN
                              LNFLOATCOLUMN := 0;
                              LSCOLUMN := TO_CHAR( REC_PG.DATE_1,
                                                   'dd-mm-yyyy hh24:mi:ss' );
                              LDDATECOLUMN := REC_PG.DATE_1;

                              IF LDDATECOLUMN IS NULL
                              THEN
                                 LNVALUETYPE := 1;
                              ELSE
                                 LNVALUETYPE := 2;
                              END IF;
                           ELSIF REC_LAYOUT.FIELD_ID = 22
                           THEN
                              LNFLOATCOLUMN := 0;
                              LSCOLUMN := TO_CHAR( REC_PG.DATE_2,
                                                   'dd-mm-yyyy hh24:mi:ss' );
                              LDDATECOLUMN := REC_PG.DATE_2;

                              IF LDDATECOLUMN IS NULL
                              THEN
                                 LNVALUETYPE := 1;
                              ELSE
                                 LNVALUETYPE := 2;
                              END IF;
                           ELSIF REC_LAYOUT.FIELD_ID = 26
                           THEN
                              LNFLOATCOLUMN := REC_PG.CHARACTERISTIC;
                              LSCOLUMN := F_CHH_DESCR( 1,
                                                       REC_PG.CHARACTERISTIC,
                                                       0 );
                              LNVALUETYPE := 0;
                           END IF;

                           IF    REC_LAYOUT.FIELD_ID < 23
                              OR REC_LAYOUT.FIELD_ID = 26
                           THEN
                              BEGIN
                                 LNCOUNTSTAGES :=   LNCOUNTSTAGES
                                                  + 1;

                                 IF LNVALUETYPE = 2   
                                 THEN
                                    INSERT INTO SPECDATA_PROCESS
                                                ( REVISION,
                                                  PART_NO,
                                                  SECTION_ID,
                                                  SUB_SECTION_ID,
                                                  SECTION_REV,
                                                  SUB_SECTION_REV,
                                                  SEQUENCE_NO,
                                                  TYPE,
                                                  PLANT,
                                                  LINE,
                                                  CONFIGURATION,
                                                  PROCESS_LINE_REV,
                                                  STAGE,
                                                  PROPERTY,
                                                  ATTRIBUTE,
                                                  STAGE_REV,
                                                  PROPERTY_REV,
                                                  ATTRIBUTE_REV,
                                                  HEADER_ID,
                                                  HEADER_REV,
                                                  VALUE,
                                                  VALUE_S,
                                                  VALUE_DT,
                                                  VALUE_TYPE,
                                                  UOM_ID,
                                                  TEST_METHOD,
                                                  CHARACTERISTIC,
                                                  ASSOCIATION,
                                                  UOM_REV,
                                                  TEST_METHOD_REV,
                                                  CHARACTERISTIC_REV,
                                                  ASSOCIATION_REV,
                                                  REF_INFO,
                                                  INTL )
                                         VALUES ( ANREVISION,
                                                  ASPARTNO,
                                                  REC_SECTION.SECTION_ID,
                                                  REC_SECTION.SUB_SECTION_ID,
                                                  REC_SECTION.SECTION_REV,
                                                  REC_SECTION.SUB_SECTION_REV,
                                                  NVL( LNCOUNTSTAGES,
                                                       0 ),
                                                  REC_SECTION.TYPE,
                                                  REC_PG.PLANT,
                                                  REC_PG.LINE,
                                                  NVL( REC_PG.CONFIGURATION,
                                                       -1 ),
                                                  NVL( REC_PG.PROCESS_LINE_REV,
                                                       -1 ),
                                                  NVL( REC_PG.STAGE,
                                                       -1 ),
                                                  NVL( REC_PG.PROPERTY,
                                                       -1 ),
                                                  NVL( REC_PG.ATTRIBUTE,
                                                       -1 ),
                                                  NVL( REC_PG.STAGE_REV,
                                                       -1 ),
                                                  NVL( REC_PG.PROPERTY_REV,
                                                       -1 ),
                                                  NVL( REC_PG.ATTRIBUTE_REV,
                                                       -1 ),
                                                  NVL( REC_LAYOUT.HEADER_ID,
                                                       -1 ),
                                                  NVL( REC_LAYOUT.HEADER_REV,
                                                       -1 ),
                                                  LNFLOATCOLUMN,
                                                  LSCOLUMN,
                                                  TO_DATE( LSCOLUMN,
                                                           'dd-mm-yyyy hh24:mi:ss' ),
                                                  NVL( LNVALUETYPE,
                                                       0 ),
                                                  NVL( REC_PG.UOM_ID,
                                                       -1 ),
                                                  DECODE( REC_PG.TEST_METHOD,
                                                          0, -1,
                                                          NVL( REC_PG.TEST_METHOD,
                                                               -1 ) ),
                                                  NVL( REC_PG.CHARACTERISTIC,
                                                       -1 ),
                                                  NVL( REC_PG.ASSOCIATION,
                                                       -1 ),
                                                  NVL( REC_PG.UOM_REV,
                                                       -1 ),
                                                  NVL( REC_PG.TEST_METHOD_REV,
                                                       -1 ),
                                                  NVL( REC_PG.CHARACTERISTIC_REV,
                                                       -1 ),
                                                  NVL( REC_PG.ASSOCIATION_REV,
                                                       -1 ),
                                                  NVL( REC_SECTION.REF_INFO,
                                                       -1 ),
                                                  NVL( REC_SECTION.INTL,
                                                       -1 ) );
                                 ELSE
                                    INSERT INTO SPECDATA_PROCESS
                                                ( REVISION,
                                                  PART_NO,
                                                  SECTION_ID,
                                                  SUB_SECTION_ID,
                                                  SECTION_REV,
                                                  SUB_SECTION_REV,
                                                  SEQUENCE_NO,
                                                  TYPE,
                                                  PLANT,
                                                  LINE,
                                                  CONFIGURATION,
                                                  PROCESS_LINE_REV,
                                                  STAGE,
                                                  PROPERTY,
                                                  ATTRIBUTE,
                                                  STAGE_REV,
                                                  PROPERTY_REV,
                                                  ATTRIBUTE_REV,
                                                  HEADER_ID,
                                                  HEADER_REV,
                                                  VALUE,
                                                  VALUE_S,
                                                  VALUE_TYPE,
                                                  UOM_ID,
                                                  TEST_METHOD,
                                                  CHARACTERISTIC,
                                                  ASSOCIATION,
                                                  UOM_REV,
                                                  TEST_METHOD_REV,
                                                  CHARACTERISTIC_REV,
                                                  ASSOCIATION_REV,
                                                  REF_INFO,
                                                  INTL )
                                         VALUES ( ANREVISION,
                                                  ASPARTNO,
                                                  REC_SECTION.SECTION_ID,
                                                  REC_SECTION.SUB_SECTION_ID,
                                                  REC_SECTION.SECTION_REV,
                                                  REC_SECTION.SUB_SECTION_REV,
                                                  NVL( LNCOUNTSTAGES,
                                                       0 ),
                                                  REC_SECTION.TYPE,
                                                  REC_PG.PLANT,
                                                  REC_PG.LINE,
                                                  NVL( REC_PG.CONFIGURATION,
                                                       -1 ),
                                                  NVL( REC_PG.PROCESS_LINE_REV,
                                                       -1 ),
                                                  NVL( REC_PG.STAGE,
                                                       -1 ),
                                                  NVL( REC_PG.PROPERTY,
                                                       -1 ),
                                                  NVL( REC_PG.ATTRIBUTE,
                                                       -1 ),
                                                  NVL( REC_PG.STAGE_REV,
                                                       -1 ),
                                                  NVL( REC_PG.PROPERTY_REV,
                                                       -1 ),
                                                  NVL( REC_PG.ATTRIBUTE_REV,
                                                       -1 ),
                                                  NVL( REC_LAYOUT.HEADER_ID,
                                                       -1 ),
                                                  NVL( REC_LAYOUT.HEADER_REV,
                                                       -1 ),
                                                  LNFLOATCOLUMN,
                                                  LSCOLUMN,
                                                  NVL( LNVALUETYPE,
                                                       0 ),
                                                  NVL( REC_PG.UOM_ID,
                                                       -1 ),
                                                  DECODE( REC_PG.TEST_METHOD,
                                                          0, -1,
                                                          NVL( REC_PG.TEST_METHOD,
                                                               -1 ) ),
                                                  NVL( REC_PG.CHARACTERISTIC,
                                                       -1 ),
                                                  NVL( REC_PG.ASSOCIATION,
                                                       -1 ),
                                                  NVL( REC_PG.UOM_REV,
                                                       -1 ),
                                                  NVL( REC_PG.TEST_METHOD_REV,
                                                       -1 ),
                                                  NVL( REC_PG.CHARACTERISTIC_REV,
                                                       -1 ),
                                                  NVL( REC_PG.ASSOCIATION_REV,
                                                       -1 ),
                                                  NVL( REC_SECTION.REF_INFO,
                                                       -1 ),
                                                  NVL( REC_SECTION.INTL,
                                                       -1 ) );

                                    
                                    FOR REC_PG_LANG IN CUR_STAGE_PROP_LANG( ASPARTNO,
                                                                            ANREVISION,
                                                                            REC_PROCESS.PLANT,
                                                                            REC_PROCESS.LINE,
                                                                            REC_PROCESS.CONFIGURATION,
                                                                            REC_STAGE.STAGE,
                                                                            REC_PG.PROPERTY,
                                                                            REC_PG.ATTRIBUTE,
                                                                            REC_PG.SEQUENCE_NO )
                                    LOOP
                                       INSERT INTO SPECDATA_PROCESS
                                                   ( REVISION,
                                                     PART_NO,
                                                     SECTION_ID,
                                                     SUB_SECTION_ID,
                                                     SECTION_REV,
                                                     SUB_SECTION_REV,
                                                     SEQUENCE_NO,
                                                     TYPE,
                                                     PLANT,
                                                     LINE,
                                                     CONFIGURATION,
                                                     PROCESS_LINE_REV,
                                                     STAGE,
                                                     PROPERTY,
                                                     ATTRIBUTE,
                                                     STAGE_REV,
                                                     PROPERTY_REV,
                                                     ATTRIBUTE_REV,
                                                     VALUE_S,
                                                     VALUE_TYPE,
                                                     REF_INFO,
                                                     INTL,
                                                     LANG_ID )
                                            VALUES ( ANREVISION,
                                                     ASPARTNO,
                                                     REC_SECTION.SECTION_ID,
                                                     REC_SECTION.SUB_SECTION_ID,
                                                     REC_SECTION.SECTION_REV,
                                                     REC_SECTION.SUB_SECTION_REV,
                                                     NVL( LNCOUNTSTAGES,
                                                          0 ),
                                                     REC_SECTION.TYPE,
                                                     REC_PG.PLANT,
                                                     REC_PG.LINE,
                                                     NVL( REC_PG.CONFIGURATION,
                                                          -1 ),
                                                     NVL( REC_PG.PROCESS_LINE_REV,
                                                          -1 ),
                                                     NVL( REC_PG.STAGE,
                                                          -1 ),
                                                     NVL( REC_PG.PROPERTY,
                                                          -1 ),
                                                     NVL( REC_PG.ATTRIBUTE,
                                                          -1 ),
                                                     NVL( REC_PG.STAGE_REV,
                                                          -1 ),
                                                     NVL( REC_PG.PROPERTY_REV,
                                                          -1 ),
                                                     NVL( REC_PG.ATTRIBUTE_REV,
                                                          -1 ),
                                                     LSCOLUMN,
                                                     NVL( LNVALUETYPE,
                                                          0 ),
                                                     NVL( REC_SECTION.REF_INFO,
                                                          -1 ),
                                                     NVL( REC_SECTION.INTL,
                                                          -1 ),
                                                     REC_PG_LANG.LANG_ID );
                                    END LOOP;
                                 END IF;
                              EXCEPTION
                                 WHEN OTHERS
                                 THEN
                                    IAPIGENERAL.LOGERROR( GSSOURCE,
                                                          LSMETHOD,
                                                          SQLERRM );
                                    DBMS_OUTPUT.PUT_LINE(    'stage info  '
                                                          || LSCOLUMN
                                                          || '    '
                                                          || REC_LAYOUT.FIELD_ID );
                                    RAISE_APPLICATION_ERROR( -20000,
                                                             SQLERRM );
                              END;
                           END IF;
                        END LOOP;   
                     ELSIF REC_PG.VALUE_TYPE = 1   
                     THEN
                        BEGIN
                           LNCOUNTSTAGES :=   LNCOUNTSTAGES
                                            + 1;

                           INSERT INTO SPECDATA_PROCESS
                                       ( REVISION,
                                         PART_NO,
                                         SECTION_ID,
                                         SUB_SECTION_ID,
                                         SECTION_REV,
                                         SUB_SECTION_REV,
                                         SEQUENCE_NO,
                                         TYPE,
                                         PLANT,
                                         LINE,
                                         CONFIGURATION,
                                         PROCESS_LINE_REV,
                                         STAGE,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         STAGE_REV,
                                         PROPERTY_REV,
                                         ATTRIBUTE_REV,
                                         VALUE_S,
                                         VALUE_TYPE,
                                         REF_INFO,
                                         INTL )
                                VALUES ( ANREVISION,
                                         ASPARTNO,
                                         REC_SECTION.SECTION_ID,
                                         REC_SECTION.SUB_SECTION_ID,
                                         REC_SECTION.SECTION_REV,
                                         REC_SECTION.SUB_SECTION_REV,
                                         NVL( LNCOUNTSTAGES,
                                              0 ),
                                         REC_SECTION.TYPE,
                                         REC_PG.PLANT,
                                         REC_PG.LINE,
                                         NVL( REC_PG.CONFIGURATION,
                                              -1 ),
                                         NVL( REC_PG.PROCESS_LINE_REV,
                                              -1 ),
                                         NVL( REC_PG.STAGE,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY,
                                              -1 ),
                                         NVL( REC_PG.ATTRIBUTE,
                                              -1 ),
                                         NVL( REC_PG.STAGE_REV,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_REV,
                                              -1 ),
                                         NVL( REC_PG.ATTRIBUTE_REV,
                                              -1 ),
                                         REC_PG.TEXT,
                                         4,
                                         NVL( REC_SECTION.REF_INFO,
                                              -1 ),
                                         NVL( REC_SECTION.INTL,
                                              -1 ) );

                           
                           FOR REC_PG_LANG IN CUR_STAGE_PROP_LANG( ASPARTNO,
                                                                   ANREVISION,
                                                                   REC_PROCESS.PLANT,
                                                                   REC_PROCESS.LINE,
                                                                   REC_PROCESS.CONFIGURATION,
                                                                   REC_STAGE.STAGE,
                                                                   REC_PG.PROPERTY,
                                                                   REC_PG.ATTRIBUTE,
                                                                   REC_PG.SEQUENCE_NO )
                           LOOP
                              INSERT INTO SPECDATA_PROCESS
                                          ( REVISION,
                                            PART_NO,
                                            SECTION_ID,
                                            SUB_SECTION_ID,
                                            SECTION_REV,
                                            SUB_SECTION_REV,
                                            SEQUENCE_NO,
                                            TYPE,
                                            PLANT,
                                            LINE,
                                            CONFIGURATION,
                                            PROCESS_LINE_REV,
                                            STAGE,
                                            PROPERTY,
                                            ATTRIBUTE,
                                            STAGE_REV,
                                            PROPERTY_REV,
                                            ATTRIBUTE_REV,
                                            VALUE_S,
                                            VALUE_TYPE,
                                            REF_INFO,
                                            INTL,
                                            LANG_ID )
                                   VALUES ( ANREVISION,
                                            ASPARTNO,
                                            REC_SECTION.SECTION_ID,
                                            REC_SECTION.SUB_SECTION_ID,
                                            REC_SECTION.SECTION_REV,
                                            REC_SECTION.SUB_SECTION_REV,
                                            NVL( LNCOUNTSTAGES,
                                                 0 ),
                                            REC_SECTION.TYPE,
                                            REC_PG.PLANT,
                                            REC_PG.LINE,
                                            NVL( REC_PG.CONFIGURATION,
                                                 -1 ),
                                            NVL( REC_PG.PROCESS_LINE_REV,
                                                 -1 ),
                                            NVL( REC_PG.STAGE,
                                                 -1 ),
                                            NVL( REC_PG.PROPERTY,
                                                 -1 ),
                                            NVL( REC_PG.ATTRIBUTE,
                                                 -1 ),
                                            NVL( REC_PG.STAGE_REV,
                                                 -1 ),
                                            NVL( REC_PG.PROPERTY_REV,
                                                 -1 ),
                                            NVL( REC_PG.ATTRIBUTE_REV,
                                                 -1 ),
                                            REC_PG_LANG.TEXT,
                                            4,
                                            NVL( REC_SECTION.REF_INFO,
                                                 -1 ),
                                            NVL( REC_SECTION.INTL,
                                                 -1 ),
                                            REC_PG_LANG.LANG_ID );
                           END LOOP;
                        EXCEPTION
                           WHEN OTHERS
                           THEN
                              IAPIGENERAL.LOGERROR( GSSOURCE,
                                                    LSMETHOD,
                                                    SQLERRM );
                              RAISE_APPLICATION_ERROR( -20000,
                                                       SQLERRM );
                        END;
                     ELSIF REC_PG.VALUE_TYPE = 2   
                     THEN
                        BEGIN
                           LNCOUNTSTAGES :=   LNCOUNTSTAGES
                                            + 1;

                           INSERT INTO SPECDATA_PROCESS
                                       ( REVISION,
                                         PART_NO,
                                         SECTION_ID,
                                         SUB_SECTION_ID,
                                         SECTION_REV,
                                         SUB_SECTION_REV,
                                         SEQUENCE_NO,
                                         TYPE,
                                         PLANT,
                                         LINE,
                                         CONFIGURATION,
                                         PROCESS_LINE_REV,
                                         STAGE,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         STAGE_REV,
                                         PROPERTY_REV,
                                         ATTRIBUTE_REV,
                                         VALUE_TYPE,
                                         COMPONENT_PART,
                                         QUANTITY,
                                         REF_INFO,
                                         INTL,
                                         UOM )
                                VALUES ( ANREVISION,
                                         ASPARTNO,
                                         REC_SECTION.SECTION_ID,
                                         REC_SECTION.SUB_SECTION_ID,
                                         REC_SECTION.SECTION_REV,
                                         REC_SECTION.SUB_SECTION_REV,
                                         NVL( LNCOUNTSTAGES,
                                              0 ),
                                         REC_SECTION.TYPE,
                                         REC_PG.PLANT,
                                         REC_PG.LINE,
                                         NVL( REC_PG.CONFIGURATION,
                                              -1 ),
                                         NVL( REC_PG.PROCESS_LINE_REV,
                                              -1 ),
                                         NVL( REC_PG.STAGE,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY,
                                              -1 ),
                                         NVL( REC_PG.ATTRIBUTE,
                                              -1 ),
                                         NVL( REC_PG.STAGE_REV,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_REV,
                                              -1 ),
                                         NVL( REC_PG.ATTRIBUTE_REV,
                                              -1 ),
                                         NVL( REC_PG.VALUE_TYPE,
                                              0 ),
                                         REC_PG.COMPONENT_PART,
                                         NVL( REC_PG.QUANTITY,
                                              0 ),
                                         NVL( REC_SECTION.REF_INFO,
                                              -1 ),
                                         NVL( REC_SECTION.INTL,
                                              -1 ),
                                         REC_PG.UOM );
                        EXCEPTION
                           WHEN OTHERS
                           THEN
                              IAPIGENERAL.LOGERROR( GSSOURCE,
                                                    LSMETHOD,
                                                    SQLERRM );
                              RAISE_APPLICATION_ERROR( -20000,
                                                       SQLERRM );
                        END;
                     END IF;
                  END LOOP;   
               END LOOP;   
            END LOOP;   

            LSCOLUMN := 'Process Data';

            BEGIN
               LNCOUNTER :=   LNCOUNTER
                            + 1;

               INSERT INTO SPECDATA
                           ( REVISION,
                             PART_NO,
                             SECTION_ID,
                             SUB_SECTION_ID,
                             SECTION_REV,
                             SUB_SECTION_REV,
                             SEQUENCE_NO,
                             TYPE,
                             REF_ID,
                             REF_VER,
                             VALUE,
                             VALUE_S,
                             REF_INFO,
                             INTL )
                    VALUES ( ANREVISION,
                             ASPARTNO,
                             REC_SECTION.SECTION_ID,
                             REC_SECTION.SUB_SECTION_ID,
                             REC_SECTION.SECTION_REV,
                             REC_SECTION.SUB_SECTION_REV,
                             NVL( LNCOUNTER,
                                  0 ),
                             REC_SECTION.TYPE,
                             NVL( REC_SECTION.REF_ID,
                                  -1 ),
                             NVL( REC_SECTION.REF_VER,
                                  -1 ),
                             NVL( REC_SECTION.REF_ID,
                                  -1 ),
                             LSCOLUMN,
                             NVL( REC_SECTION.REF_INFO,
                                  -1 ),
                             NVL( REC_SECTION.INTL,
                                  -1 ) );
            EXCEPTION
               WHEN OTHERS
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        SQLERRM );
                  RAISE_APPLICATION_ERROR( -20000,
                                           SQLERRM );
            END;
         END IF;
      END LOOP;
   END CONVERTSPECIFICATION;

   PROCEDURE CONVERTFRAME(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE )
   IS









      LSCOLUMN                      VARCHAR2( 256 );
      LNFLOATCOLUMN                 NUMBER;
      LDDATECOLUMN                  DATE;
      LNRESULT                      INTEGER;
      LNVALUETYPE                   FRAMEDATA.VALUE_TYPE%TYPE;
      LNCOUNTER                     NUMBER;
      LBDATA                        BOOLEAN;
      LNLAYOUTREVISION              IAPITYPE.REVISION_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ConvertFrame';

      CURSOR CUR_SECTION(
         P_FRAME_NO                          IAPITYPE.FRAMENO_TYPE,
         P_REVISION                          IAPITYPE.REVISION_TYPE,
         P_OWNER                             IAPITYPE.OWNER_TYPE )
      IS
         SELECT   *
             FROM FRAME_SECTION
            WHERE FRAME_NO = P_FRAME_NO
              AND REVISION = P_REVISION
              AND OWNER = P_OWNER
         ORDER BY SECTION_SEQUENCE_NO;





      CURSOR CUR_LAYOUT(
         P_LAYOUT_ID                         IAPITYPE.ID_TYPE,
         P_LAYOUT_REV                        IAPITYPE.REVISION_TYPE )
      IS
         SELECT *
           FROM PROPERTY_LAYOUT
          WHERE LAYOUT_ID = P_LAYOUT_ID
            AND REVISION = P_LAYOUT_REV;




      CURSOR CUR_PROPERTY_GROUP(
         P_FRAME_NO                          IAPITYPE.FRAMENO_TYPE,
         P_REVISION                          IAPITYPE.REVISION_TYPE,
         P_OWNER                             IAPITYPE.OWNER_TYPE,
         P_SECTION                           IAPITYPE.ID_TYPE,
         P_SUB_SECTION                       IAPITYPE.ID_TYPE,
         P_PROPERTY_GROUP                    IAPITYPE.ID_TYPE )
      IS
         SELECT   *
             FROM FRAME_PROP
            WHERE FRAME_NO = P_FRAME_NO
              AND REVISION = P_REVISION
              AND OWNER = P_OWNER
              AND SECTION_ID = P_SECTION
              AND SUB_SECTION_ID = P_SUB_SECTION
              AND PROPERTY_GROUP = P_PROPERTY_GROUP
         ORDER BY SEQUENCE_NO;




      CURSOR CUR_PROPERTY(
         P_FRAME_NO                          IAPITYPE.FRAMENO_TYPE,
         P_REVISION                          IAPITYPE.REVISION_TYPE,
         P_OWNER                             IAPITYPE.OWNER_TYPE,
         P_SECTION                           IAPITYPE.ID_TYPE,
         P_SUB_SECTION                       IAPITYPE.ID_TYPE,
         P_PROPERTY                          IAPITYPE.ID_TYPE )
      IS
         SELECT   *
             FROM FRAME_PROP
            WHERE FRAME_NO = P_FRAME_NO
              AND REVISION = P_REVISION
              AND OWNER = P_OWNER
              AND SECTION_ID = P_SECTION
              AND SUB_SECTION_ID = P_SUB_SECTION
              AND PROPERTY_GROUP = 0
              AND PROPERTY = P_PROPERTY
         ORDER BY SEQUENCE_NO;




      CURSOR CUR_BOOLEAN
      IS
         SELECT *
           FROM FRAME_SECTION
          WHERE FRAME_NO = ASFRAMENO
            AND REVISION = ANREVISION
            AND OWNER = ANOWNER
            AND TYPE IN( IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP, IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY );
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNCOUNTER := 1;





      BEGIN

         DELETE FROM FRAMEDATA
               WHERE FRAME_NO = ASFRAMENO
                 AND REVISION = ANREVISION
                 AND OWNER = ANOWNER;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RAISE_APPLICATION_ERROR( -20000,
                                     SQLERRM );
      END;





      FOR REC_SECTION IN CUR_SECTION( ASFRAMENO,
                                      ANREVISION,
                                      ANOWNER )
      LOOP
         LBDATA := FALSE;




         IF REC_SECTION.TYPE = 1
         THEN   
            FOR REC_PG IN CUR_PROPERTY_GROUP( ASFRAMENO,
                                              ANREVISION,
                                              ANOWNER,
                                              REC_SECTION.SECTION_ID,
                                              REC_SECTION.SUB_SECTION_ID,
                                              REC_SECTION.REF_ID )
            LOOP
               LBDATA := TRUE;

               IF REC_SECTION.DISPLAY_FORMAT_REV = 0
               THEN
                  SELECT MAX( REVISION )
                    INTO LNLAYOUTREVISION
                    FROM LAYOUT
                   WHERE LAYOUT_ID = REC_SECTION.DISPLAY_FORMAT
                     AND STATUS = 2;
               ELSE
                  LNLAYOUTREVISION := REC_SECTION.DISPLAY_FORMAT_REV;
               END IF;

               FOR REC_LAYOUT IN CUR_LAYOUT( REC_SECTION.DISPLAY_FORMAT,
                                             LNLAYOUTREVISION )
               LOOP
                  LSCOLUMN := '';
                  LDDATECOLUMN := NULL;

                  IF REC_LAYOUT.FIELD_ID = 1
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_1;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_1 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 2
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_2;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_2 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 3
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_3;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_3 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 4
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_4;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_4 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 5
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_5;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_5 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 6
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_6;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_6 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 7
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_7;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_7 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 8
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_8;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_8 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 9
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_9;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_9 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 10
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_10;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_10 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 11
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.CHAR_1;
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 12
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.CHAR_2;
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 13
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.CHAR_3;
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 14
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.CHAR_4;
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 15
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.CHAR_5;
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 16
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.CHAR_6;
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 17
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.BOOLEAN_1;

                     IF LSCOLUMN IS NULL
                     THEN
                        LSCOLUMN := 'N';
                     END IF;

                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 18
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.BOOLEAN_2;

                     IF LSCOLUMN IS NULL
                     THEN
                        LSCOLUMN := 'N';
                     END IF;

                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 19
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.BOOLEAN_3;

                     IF LSCOLUMN IS NULL
                     THEN
                        LSCOLUMN := 'N';
                     END IF;

                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 20
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.BOOLEAN_4;

                     IF LSCOLUMN IS NULL
                     THEN
                        LSCOLUMN := 'N';
                     END IF;

                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 21
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := TO_CHAR( REC_PG.DATE_1,
                                          'dd-mm-yyyy hh24:mi:ss' );
                     LDDATECOLUMN := REC_PG.DATE_1;

                     IF LDDATECOLUMN IS NULL
                     THEN
                        LNVALUETYPE := 1;
                     ELSE
                        LNVALUETYPE := 2;
                     END IF;
                  ELSIF REC_LAYOUT.FIELD_ID = 22
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := TO_CHAR( REC_PG.DATE_2,
                                          'dd-mm-yyyy hh24:mi:ss' );
                     LDDATECOLUMN := REC_PG.DATE_2;

                     IF LDDATECOLUMN IS NULL
                     THEN
                        LNVALUETYPE := 1;
                     ELSE
                        LNVALUETYPE := 2;
                     END IF;
                  ELSIF REC_LAYOUT.FIELD_ID = 26
                  THEN
                     LNFLOATCOLUMN := REC_PG.CHARACTERISTIC;
                     LSCOLUMN := F_CHH_DESCR( 1,
                                              REC_PG.CHARACTERISTIC,
                                              0 );
                     LNVALUETYPE := 0;

                  ELSIF REC_LAYOUT.FIELD_ID = 30
                  THEN
                     LNFLOATCOLUMN := REC_PG.CH_2;
                     LSCOLUMN := F_CHH_DESCR( 1,
                                              REC_PG.CH_2,
                                              0 );
                     LNVALUETYPE := 0;

                  ELSIF REC_LAYOUT.FIELD_ID = 31
                  THEN
                     LNFLOATCOLUMN := REC_PG.CH_3;
                     LSCOLUMN := F_CHH_DESCR( 1,
                                              REC_PG.CH_3,
                                              0 );
                     LNVALUETYPE := 0;

                  END IF;

                  IF    REC_LAYOUT.FIELD_ID < 23
                     OR REC_LAYOUT.FIELD_ID = 26
                     OR REC_LAYOUT.FIELD_ID = 30
                     OR REC_LAYOUT.FIELD_ID = 31
                  THEN
                     BEGIN
                        LNCOUNTER :=   LNCOUNTER
                                     + 1;

                        IF LNVALUETYPE = 2
                        THEN
                           INSERT INTO FRAMEDATA
                                       ( REVISION,
                                         FRAME_NO,
                                         OWNER,
                                         SECTION_ID,
                                         SUB_SECTION_ID,
                                         SECTION_REV,
                                         SUB_SECTION_REV,
                                         SEQUENCE_NO,
                                         TYPE,
                                         REF_ID,
                                         REF_VER,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         PROPERTY_GROUP_REV,
                                         PROPERTY_REV,
                                         ATTRIBUTE_REV,
                                         HEADER_ID,
                                         HEADER_REV,
                                         VALUE,
                                         VALUE_S,
                                         VALUE_DT,
                                         VALUE_TYPE,
                                         UOM_ID,
                                         TEST_METHOD,
                                         CHARACTERISTIC,
                                         ASSOCIATION,
                                         UOM_REV,
                                         TEST_METHOD_REV,
                                         CHARACTERISTIC_REV,
                                         ASSOCIATION_REV,
                                         REF_INFO,
                                         INTL )
                                VALUES ( ANREVISION,
                                         ASFRAMENO,
                                         ANOWNER,
                                         REC_SECTION.SECTION_ID,
                                         REC_SECTION.SUB_SECTION_ID,
                                         REC_SECTION.SECTION_REV,
                                         REC_SECTION.SUB_SECTION_REV,
                                         NVL( LNCOUNTER,
                                              0 ),
                                         REC_SECTION.TYPE,
                                         NVL( REC_SECTION.REF_ID,
                                              -1 ),
                                         NVL( REC_SECTION.REF_VER,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_GROUP,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY,
                                              -1 ),
                                         NVL( REC_PG.ATTRIBUTE,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_GROUP_REV,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_REV,
                                              -1 ),
                                         NVL( REC_PG.ATTRIBUTE_REV,
                                              -1 ),
                                         NVL( REC_LAYOUT.HEADER_ID,
                                              -1 ),
                                         NVL( REC_LAYOUT.HEADER_REV,
                                              -1 ),
                                         NVL( LNFLOATCOLUMN,
                                              0 ),
                                         LSCOLUMN,
                                         TO_DATE( LSCOLUMN,
                                                  'dd-mm-yyyy hh24:mi:ss' ),
                                         NVL( LNVALUETYPE,
                                              0 ),
                                         NVL( REC_PG.UOM_ID,
                                              -1 ),
                                         DECODE( REC_PG.TEST_METHOD,
                                                 0, -1,
                                                 NVL( REC_PG.TEST_METHOD,
                                                      -1 ) ),
                                         NVL( REC_PG.CHARACTERISTIC,
                                              -1 ),
                                         NVL( REC_PG.ASSOCIATION,
                                              -1 ),
                                         NVL( REC_PG.UOM_REV,
                                              -1 ),
                                         NVL( REC_PG.TEST_METHOD_REV,
                                              -1 ),
                                         NVL( REC_PG.CHARACTERISTIC_REV,
                                              -1 ),
                                         NVL( REC_PG.ASSOCIATION_REV,
                                              -1 ),
                                         NVL( REC_SECTION.REF_INFO,
                                              -1 ),
                                         NVL( REC_SECTION.INTL,
                                              -1 ) );
                        ELSE
                           INSERT INTO FRAMEDATA
                                       ( REVISION,
                                         FRAME_NO,
                                         OWNER,
                                         SECTION_ID,
                                         SUB_SECTION_ID,
                                         SECTION_REV,
                                         SUB_SECTION_REV,
                                         SEQUENCE_NO,
                                         TYPE,
                                         REF_ID,
                                         REF_VER,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         PROPERTY_GROUP_REV,
                                         PROPERTY_REV,
                                         ATTRIBUTE_REV,
                                         HEADER_ID,
                                         HEADER_REV,
                                         VALUE,
                                         VALUE_S,
                                         VALUE_TYPE,
                                         UOM_ID,
                                         TEST_METHOD,
                                         CHARACTERISTIC,
                                         ASSOCIATION,
                                         UOM_REV,
                                         TEST_METHOD_REV,
                                         CHARACTERISTIC_REV,
                                         ASSOCIATION_REV,
                                         REF_INFO,
                                         INTL )
                                VALUES ( ANREVISION,
                                         ASFRAMENO,
                                         ANOWNER,
                                         REC_SECTION.SECTION_ID,
                                         REC_SECTION.SUB_SECTION_ID,
                                         REC_SECTION.SECTION_REV,
                                         REC_SECTION.SUB_SECTION_REV,
                                         NVL( LNCOUNTER,
                                              0 ),
                                         REC_SECTION.TYPE,
                                         NVL( REC_SECTION.REF_ID,
                                              -1 ),
                                         NVL( REC_SECTION.REF_VER,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_GROUP,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY,
                                              -1 ),
                                         NVL( REC_PG.ATTRIBUTE,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_GROUP_REV,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_REV,
                                              -1 ),
                                         NVL( REC_PG.ATTRIBUTE_REV,
                                              -1 ),
                                         NVL( REC_LAYOUT.HEADER_ID,
                                              -1 ),
                                         NVL( REC_LAYOUT.HEADER_REV,
                                              -1 ),
                                         LNFLOATCOLUMN,
                                         LSCOLUMN,
                                         NVL( LNVALUETYPE,
                                              0 ),
                                         NVL( REC_PG.UOM_ID,
                                              -1 ),
                                         NVL( REC_PG.TEST_METHOD,
                                              -1 ),
                                         NVL( REC_PG.CHARACTERISTIC,
                                              -1 ),
                                         NVL( REC_PG.ASSOCIATION,
                                              -1 ),
                                         NVL( REC_PG.UOM_REV,
                                              -1 ),
                                         NVL( REC_PG.TEST_METHOD_REV,
                                              -1 ),
                                         NVL( REC_PG.CHARACTERISTIC_REV,
                                              -1 ),
                                         NVL( REC_PG.ASSOCIATION_REV,
                                              -1 ),
                                         NVL( REC_SECTION.REF_INFO,
                                              -1 ),
                                         NVL( REC_SECTION.INTL,
                                              -1 ) );
                        END IF;
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                 LSMETHOD,
                                                 SQLERRM );
                           DBMS_OUTPUT.PUT_LINE(    'PG info  '
                                                 || LSCOLUMN
                                                 || '    '
                                                 || REC_LAYOUT.FIELD_ID );
                           RAISE_APPLICATION_ERROR( -20000,
                                                    SQLERRM );
                     END;
                  END IF;
               END LOOP;
            END LOOP;

            IF NOT( LBDATA )
            THEN

	     
             
             LSCOLUMN := '';

               BEGIN
                  LNCOUNTER :=   LNCOUNTER
                               + 1;

                  INSERT INTO FRAMEDATA
                              ( REVISION,
                                FRAME_NO,
                                OWNER,
                                SECTION_ID,
                                SUB_SECTION_ID,
                                SECTION_REV,
                                SUB_SECTION_REV,
                                SEQUENCE_NO,
                                TYPE,
                                REF_ID,
                                REF_VER,
                                REF_OWNER,
                                PROPERTY_GROUP,
                                VALUE_S,
                                REF_INFO,
                                INTL )
                       VALUES ( ANREVISION,
                                ASFRAMENO,
                                ANOWNER,
                                REC_SECTION.SECTION_ID,
                                REC_SECTION.SUB_SECTION_ID,
                                REC_SECTION.SECTION_REV,
                                REC_SECTION.SUB_SECTION_REV,
                                NVL( LNCOUNTER,
                                     0 ),
                                REC_SECTION.TYPE,
                                NVL( REC_SECTION.REF_ID,
                                     -1 ),
                                NVL( REC_SECTION.REF_VER,
                                     -1 ),
                                NVL( REC_SECTION.REF_OWNER,
                                     -1 ),
                                NVL( REC_SECTION.REF_ID,
                                     -1 ),
                                LSCOLUMN,
                                NVL( REC_SECTION.REF_INFO,
                                     -1 ),
                                NVL( REC_SECTION.INTL,
                                     -1 ) );
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     DBMS_OUTPUT.PUT_LINE(    ' 2'
                                           || SQLERRM );
                     RAISE_APPLICATION_ERROR( -20000,
                                              SQLERRM );
               END;
            END IF;
         ELSIF REC_SECTION.TYPE = 4
         THEN

            FOR REC_PG IN CUR_PROPERTY( ASFRAMENO,
                                        ANREVISION,
                                        ANOWNER,
                                        REC_SECTION.SECTION_ID,
                                        REC_SECTION.SUB_SECTION_ID,
                                        REC_SECTION.REF_ID )
            LOOP
               IF REC_SECTION.DISPLAY_FORMAT_REV = 0
               THEN
                  SELECT MAX( REVISION )
                    INTO LNLAYOUTREVISION
                    FROM LAYOUT
                   WHERE LAYOUT_ID = REC_SECTION.DISPLAY_FORMAT
                     AND STATUS = 2;
               ELSE
                  LNLAYOUTREVISION := REC_SECTION.DISPLAY_FORMAT_REV;
               END IF;

               FOR REC_LAYOUT IN CUR_LAYOUT( REC_SECTION.DISPLAY_FORMAT,
                                             LNLAYOUTREVISION )
               LOOP
                  LSCOLUMN := '';
                  LDDATECOLUMN := NULL;

                  IF REC_LAYOUT.FIELD_ID = 1
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_1;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_1 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 2
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_2;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_2 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 3
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_3;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_3 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 4
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_4;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_4 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 5
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_5;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_5 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 6
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_6;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_6 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 7
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_7;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_7 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 8
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_8;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_8 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 9
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_9;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_9 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 10
                  THEN
                     LNFLOATCOLUMN := REC_PG.NUM_10;
                     LSCOLUMN := IAPIGENERAL.TOCHAR( REC_PG.NUM_10 );
                     LNVALUETYPE := 0;
                  ELSIF REC_LAYOUT.FIELD_ID = 11
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.CHAR_1;
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 12
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.CHAR_2;
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 13
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.CHAR_3;
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 14
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.CHAR_4;
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 15
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.CHAR_5;
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 16
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.CHAR_6;
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 17
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.BOOLEAN_1;

                     IF LSCOLUMN IS NULL
                     THEN
                        LSCOLUMN := 'N';
                     END IF;

                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 18
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.BOOLEAN_2;

                     IF LSCOLUMN IS NULL
                     THEN
                        LSCOLUMN := 'N';
                     END IF;

                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 19
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.BOOLEAN_3;

                     IF LSCOLUMN IS NULL
                     THEN
                        LSCOLUMN := 'N';
                     END IF;

                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 20
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := REC_PG.BOOLEAN_4;

                     IF LSCOLUMN IS NULL
                     THEN
                        LSCOLUMN := 'N';
                     END IF;

                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 21
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := TO_CHAR( REC_PG.DATE_1,
                                          'dd-mm-yyyy hh24:mi:ss' );
                     LDDATECOLUMN := REC_PG.DATE_1;

                     IF LDDATECOLUMN IS NULL
                     THEN
                        LNVALUETYPE := 1;
                     ELSE
                        LNVALUETYPE := 2;
                     END IF;
                  ELSIF REC_LAYOUT.FIELD_ID = 22
                  THEN
                     LNFLOATCOLUMN := 0;
                     LSCOLUMN := TO_CHAR( REC_PG.DATE_2,
                                          'dd-mm-yyyy hh24:mi:ss' );
                     LDDATECOLUMN := REC_PG.DATE_2;

                     IF LDDATECOLUMN IS NULL
                     THEN
                        LNVALUETYPE := 1;
                     ELSE
                        LNVALUETYPE := 2;
                     END IF;
                  ELSIF REC_LAYOUT.FIELD_ID = 26
                  THEN

                     LNFLOATCOLUMN := 0;
                     LNFLOATCOLUMN := REC_PG.CHARACTERISTIC;
                     LSCOLUMN := F_CHH_DESCR( 1,
                                              REC_PG.CHARACTERISTIC,
                                              0 );
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 30
                  THEN

                     LNFLOATCOLUMN := 0;
                     LNFLOATCOLUMN := REC_PG.CH_2;
                     LSCOLUMN := F_CHH_DESCR( 1,
                                              REC_PG.CH_2,
                                              0 );
                     LNVALUETYPE := 1;
                  ELSIF REC_LAYOUT.FIELD_ID = 31
                  THEN

                     LNFLOATCOLUMN := 0;
                     LNFLOATCOLUMN := REC_PG.CH_3;
                     LSCOLUMN := F_CHH_DESCR( 1,
                                              REC_PG.CH_3,
                                              0 );
                     LNVALUETYPE := 1;
                  END IF;

                  IF    REC_LAYOUT.FIELD_ID < 23
                     OR REC_LAYOUT.FIELD_ID = 26
                     OR REC_LAYOUT.FIELD_ID = 30
                     OR REC_LAYOUT.FIELD_ID = 31
                  THEN
                     BEGIN
                        LNCOUNTER :=   LNCOUNTER
                                     + 1;

                        IF LNVALUETYPE = 2
                        THEN
                           INSERT INTO FRAMEDATA
                                       ( REVISION,
                                         FRAME_NO,
                                         OWNER,
                                         SECTION_ID,
                                         SUB_SECTION_ID,
                                         SECTION_REV,
                                         SUB_SECTION_REV,
                                         SEQUENCE_NO,
                                         TYPE,
                                         REF_ID,
                                         REF_VER,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         PROPERTY_GROUP_REV,
                                         PROPERTY_REV,
                                         ATTRIBUTE_REV,
                                         HEADER_ID,
                                         HEADER_REV,
                                         VALUE,
                                         VALUE_S,
                                         VALUE_DT,
                                         VALUE_TYPE,
                                         UOM_ID,
                                         TEST_METHOD,
                                         CHARACTERISTIC,
                                         ASSOCIATION,
                                         UOM_REV,
                                         TEST_METHOD_REV,
                                         CHARACTERISTIC_REV,
                                         ASSOCIATION_REV,
                                         REF_INFO,
                                         INTL )
                                VALUES ( ANREVISION,
                                         ASFRAMENO,
                                         ANOWNER,
                                         REC_SECTION.SECTION_ID,
                                         REC_SECTION.SUB_SECTION_ID,
                                         REC_SECTION.SECTION_REV,
                                         REC_SECTION.SUB_SECTION_REV,
                                         NVL( LNCOUNTER,
                                              0 ),
                                         REC_SECTION.TYPE,
                                         NVL( REC_SECTION.REF_ID,
                                              -1 ),
                                         NVL( REC_SECTION.REF_VER,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_GROUP,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY,
                                              -1 ),
                                         NVL( REC_PG.ATTRIBUTE,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_GROUP_REV,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_REV,
                                              -1 ),
                                         NVL( REC_PG.ATTRIBUTE_REV,
                                              -1 ),
                                         NVL( REC_LAYOUT.HEADER_ID,
                                              -1 ),
                                         NVL( REC_LAYOUT.HEADER_REV,
                                              -1 ),
                                         LNFLOATCOLUMN,
                                         LSCOLUMN,
                                         TO_DATE( LSCOLUMN,
                                                  'dd-mm-yyyy hh24:mi:ss' ),
                                         NVL( LNVALUETYPE,
                                              0 ),
                                         NVL( REC_PG.UOM_ID,
                                              -1 ),
                                         NVL( REC_PG.TEST_METHOD,
                                              -1 ),
                                         NVL( REC_PG.CHARACTERISTIC,
                                              -1 ),
                                         NVL( REC_PG.ASSOCIATION,
                                              -1 ),
                                         NVL( REC_PG.UOM_REV,
                                              -1 ),
                                         NVL( REC_PG.TEST_METHOD_REV,
                                              -1 ),
                                         NVL( REC_PG.CHARACTERISTIC_REV,
                                              -1 ),
                                         NVL( REC_PG.ASSOCIATION_REV,
                                              -1 ),
                                         NVL( REC_SECTION.REF_INFO,
                                              -1 ),
                                         NVL( REC_SECTION.INTL,
                                              -1 ) );
                        ELSE
                           INSERT INTO FRAMEDATA
                                       ( REVISION,
                                         FRAME_NO,
                                         OWNER,
                                         SECTION_ID,
                                         SUB_SECTION_ID,
                                         SECTION_REV,
                                         SUB_SECTION_REV,
                                         SEQUENCE_NO,
                                         TYPE,
                                         REF_ID,
                                         REF_VER,
                                         PROPERTY_GROUP,
                                         PROPERTY,
                                         ATTRIBUTE,
                                         PROPERTY_GROUP_REV,
                                         PROPERTY_REV,
                                         ATTRIBUTE_REV,
                                         HEADER_ID,
                                         HEADER_REV,
                                         VALUE,
                                         VALUE_S,
                                         VALUE_TYPE,
                                         UOM_ID,
                                         TEST_METHOD,
                                         CHARACTERISTIC,
                                         ASSOCIATION,
                                         UOM_REV,
                                         TEST_METHOD_REV,
                                         CHARACTERISTIC_REV,
                                         ASSOCIATION_REV,
                                         REF_INFO,
                                         INTL )
                                VALUES ( ANREVISION,
                                         ASFRAMENO,
                                         ANOWNER,
                                         REC_SECTION.SECTION_ID,
                                         REC_SECTION.SUB_SECTION_ID,
                                         REC_SECTION.SECTION_REV,
                                         REC_SECTION.SUB_SECTION_REV,
                                         NVL( LNCOUNTER,
                                              0 ),
                                         REC_SECTION.TYPE,
                                         NVL( REC_SECTION.REF_ID,
                                              -1 ),
                                         NVL( REC_SECTION.REF_VER,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_GROUP,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY,
                                              -1 ),
                                         NVL( REC_PG.ATTRIBUTE,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_GROUP_REV,
                                              -1 ),
                                         NVL( REC_PG.PROPERTY_REV,
                                              -1 ),
                                         NVL( REC_PG.ATTRIBUTE_REV,
                                              -1 ),
                                         NVL( REC_LAYOUT.HEADER_ID,
                                              -1 ),
                                         NVL( REC_LAYOUT.HEADER_REV,
                                              -1 ),
                                         NVL( LNFLOATCOLUMN,
                                              0 ),
                                         LSCOLUMN,
                                         NVL( LNVALUETYPE,
                                              0 ),
                                         NVL( REC_PG.UOM_ID,
                                              -1 ),
                                         NVL( REC_PG.TEST_METHOD,
                                              -1 ),
                                         NVL( REC_PG.CHARACTERISTIC,
                                              -1 ),
                                         NVL( REC_PG.ASSOCIATION,
                                              -1 ),
                                         NVL( REC_PG.UOM_REV,
                                              -1 ),
                                         NVL( REC_PG.TEST_METHOD_REV,
                                              -1 ),
                                         NVL( REC_PG.CHARACTERISTIC_REV,
                                              -1 ),
                                         NVL( REC_PG.ASSOCIATION_REV,
                                              -1 ),
                                         NVL( REC_SECTION.REF_INFO,
                                              -1 ),
                                         NVL( REC_SECTION.INTL,
                                              -1 ) );
                        END IF;
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                 LSMETHOD,
                                                 SQLERRM );
                           RAISE_APPLICATION_ERROR( -20000,
                                                    SQLERRM );
                     END;
                  END IF;
               END LOOP;
            END LOOP;
         END IF;
      END LOOP;
   END CONVERTFRAME;

   
   PROCEDURE RUNSPECSERVER(
      ASJOBNAME                  IN       IAPITYPE.STRING_TYPE )
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSALERTMESSAGE                VARCHAR2( 200 );
      LNSTATUS                      INTEGER;      
      
      
      
      
      
      
      LSERRORMESSAGE                VARCHAR2( 255 );
      LNCOUNT                       NUMBER;
      
      L_PREV_PART_NO                IAPITYPE.PARTNO_TYPE;
      L_PREV_PART_REVISION          IAPITYPE.REVISION_TYPE;
      L_PREV_SECTION_ID             IAPITYPE.ID_TYPE;
      L_PREV_SUB_SECTION_ID         IAPITYPE.ID_TYPE;
      L_PREV_FRAME_NO               IAPITYPE.FRAMENO_TYPE;
      L_PREV_FRAME_REVISION         IAPITYPE.REVISION_TYPE;
      L_PREV_FRAME_OWNER            IAPITYPE.OWNER_TYPE;
      LSLOCKNAME                    VARCHAR2(30);
      LSLOCKHANDLE                  VARCHAR2(200);
      LBLOCKED                      BOOLEAN;            
      LNRETURNCODE                    INTEGER;
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RunSpecServer';

      TYPE TABLE_ROWID IS TABLE OF ROWID
         INDEX BY BINARY_INTEGER;

      LTB_ROWID                     TABLE_ROWID;

      CURSOR C_SPECDATA_SERVER
      IS
         SELECT PART_NO,
                REVISION,
                SECTION_ID,
                SUB_SECTION_ID,
                ROWID
           FROM SPECDATA_SERVER
         
          
          WHERE DATE_PROCESSED IS NULL
          ORDER BY PART_NO, REVISION, SECTION_ID, SUB_SECTION_ID;
         
      
      
      TYPE SPECDATASERVERRECTYPETAB IS TABLE OF C_SPECDATA_SERVER%ROWTYPE;
      L_SPECDATA_REC_TAB SPECDATASERVERRECTYPETAB;  
      

      CURSOR C_FRAMEDATA_SERVER
      IS
         SELECT FRAME_NO,
                REVISION,
                OWNER,
                ROWID
           FROM FRAMEDATA_SERVER
          
          
          WHERE DATE_PROCESSED IS NULL
          ORDER BY FRAME_NO, REVISION, OWNER;
          

      
      TYPE FRAMEDATASERVERRECTYPETAB IS TABLE OF C_FRAMEDATA_SERVER%ROWTYPE;
      L_FRAMEDATA_REC_TAB FRAMEDATASERVERRECTYPETAB;  
      
      
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      




















































































      
      LBLOCKED := FALSE;
      
      
      
      
      
      
      
      
      
      LSLOCKNAME := 'ISPEC_SPECSERVERJOB_RUN';
      DBMS_LOCK.ALLOCATE_UNIQUE(LOCKNAME => LSLOCKNAME,
                                LOCKHANDLE => LSLOCKHANDLE,
                                EXPIRATION_SECS => 2144448000); 
      
            
      
      
      LNRETURNCODE := DBMS_LOCK.REQUEST(LOCKHANDLE => LSLOCKHANDLE,
                                      LOCKMODE => DBMS_LOCK.X_MODE,
                                      TIMEOUT => 0.01,
                                      RELEASE_ON_COMMIT => FALSE);  
      IF LNRETURNCODE = 1 THEN  
         NULL;
      ELSIF LNRETURNCODE = 4 THEN
         RAISE_APPLICATION_ERROR(-20000, 'The owner of user lock '||LSLOCKNAME||' is not the interspec dba (delete record from sys.dbms_lock_allocated if problem persists)');      
      ELSIF LNRETURNCODE <> 0 THEN
         RAISE_APPLICATION_ERROR(-20000, 'Request Lock for '||LSLOCKNAME||' failed with:'||TO_CHAR(LNRETURNCODE)||' (see DBMS_LOCK.REQUEST doc for details)');
      ELSE
         LBLOCKED := TRUE;
         DBMS_APPLICATION_INFO.SET_ACTION( 'SPECSERVER IS PROCESSING SPECIFICATION CONVERSIONS...' );
         
                  
         
         
         
         L_PREV_PART_NO := NULL;
         L_PREV_PART_REVISION := NULL;
         L_PREV_SECTION_ID := NULL;
         L_PREV_SUB_SECTION_ID := NULL;

         OPEN C_SPECDATA_SERVER;
         FETCH C_SPECDATA_SERVER BULK COLLECT INTO L_SPECDATA_REC_TAB; 
         
         FOR L_X IN 1..L_SPECDATA_REC_TAB.COUNT()
         LOOP
            
            IF NVL(L_PREV_PART_NO, '*') = NVL(L_SPECDATA_REC_TAB(L_X).PART_NO, '*') AND
               NVL(L_PREV_PART_REVISION, -1) = NVL(L_SPECDATA_REC_TAB(L_X).REVISION, -1) AND
               
               
               NVL(L_PREV_SECTION_ID, -1) = NVL(L_SPECDATA_REC_TAB(L_X).SECTION_ID, -1) AND
               NVL(L_PREV_SUB_SECTION_ID, -1) = NVL(L_SPECDATA_REC_TAB(L_X).SUB_SECTION_ID, -1) THEN

               IAPIGENERAL.LOGINFO( GSSOURCE,
                        LSMETHOD,
                        'Skipping duplicate record part_no='||NVL(L_SPECDATA_REC_TAB(L_X).PART_NO, '*')||
                        '#revision='||NVL(L_SPECDATA_REC_TAB(L_X).REVISION, -1)||


                        '#section_id='||NVL(L_SPECDATA_REC_TAB(L_X).SECTION_ID, -1)||
                        '#sub_section_id='||NVL(L_SPECDATA_REC_TAB(L_X).SUB_SECTION_ID, -1),
                        IAPICONSTANT.INFOLEVEL_3 );
            ELSE
            
               SELECT COUNT( * )
                 INTO LNCOUNT
                 FROM SPECIFICATION_HEADER
                WHERE PART_NO = L_SPECDATA_REC_TAB(L_X).PART_NO
                  AND REVISION = L_SPECDATA_REC_TAB(L_X).REVISION;

               IF LNCOUNT > 0
               THEN
                  IAPISPECDATASERVER.CONVERTSPECIFICATION( L_SPECDATA_REC_TAB(L_X).PART_NO,
                                                           L_SPECDATA_REC_TAB(L_X).REVISION,
                                                           L_SPECDATA_REC_TAB(L_X).SECTION_ID,
                                                           L_SPECDATA_REC_TAB(L_X).SUB_SECTION_ID );
                  COMMIT;
               END IF;
               L_PREV_PART_NO := L_SPECDATA_REC_TAB(L_X).PART_NO;
               L_PREV_PART_REVISION := L_SPECDATA_REC_TAB(L_X).REVISION;
               L_PREV_SECTION_ID := L_SPECDATA_REC_TAB(L_X).SECTION_ID;
               L_PREV_SUB_SECTION_ID := L_SPECDATA_REC_TAB(L_X).SUB_SECTION_ID;
            END IF;
            
            
            
            
            
            
            UPDATE SPECDATA_SERVER 
            SET DATE_PROCESSED = SYSDATE
            WHERE ROWID = L_SPECDATA_REC_TAB(L_X).ROWID;
            
            COMMIT;
            
            
         END LOOP;
         CLOSE C_SPECDATA_SERVER;

         
         
         
         
         
         
         
         
         
         
         
         
         
         DBMS_APPLICATION_INFO.SET_ACTION( 'SPECSERVER IS PROCESSING FRAME CONVERSIONS...' );

         
         

         L_PREV_FRAME_NO := NULL;
         L_PREV_FRAME_REVISION := NULL;
         L_PREV_FRAME_OWNER := NULL;

         OPEN C_FRAMEDATA_SERVER;
         FETCH C_FRAMEDATA_SERVER BULK COLLECT INTO L_FRAMEDATA_REC_TAB; 
         
         FOR L_X IN 1..L_FRAMEDATA_REC_TAB.COUNT()
         LOOP
            
            IF NVL(L_PREV_FRAME_NO, '*') = NVL(L_FRAMEDATA_REC_TAB(L_X).FRAME_NO, '*') AND
               NVL(L_PREV_FRAME_REVISION, -1) = NVL(L_FRAMEDATA_REC_TAB(L_X).REVISION, -1) AND

               NVL(L_PREV_FRAME_OWNER, -1) = NVL(L_FRAMEDATA_REC_TAB(L_X).OWNER, -1) THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                       LSMETHOD,
                       'Skipping duplicate record frame_no='||NVL(L_FRAMEDATA_REC_TAB(L_X).FRAME_NO, '*')||
                       '#revision='||NVL(L_FRAMEDATA_REC_TAB(L_X).REVISION, -1)||

                       '#owner='||NVL(L_FRAMEDATA_REC_TAB(L_X).OWNER, -1),
                       IAPICONSTANT.INFOLEVEL_3 );
            ELSE             
               IAPISPECDATASERVER.CONVERTFRAME(L_FRAMEDATA_REC_TAB(L_X).FRAME_NO,
                                               L_FRAMEDATA_REC_TAB(L_X).REVISION,
                                               L_FRAMEDATA_REC_TAB(L_X).OWNER );
               COMMIT;
               L_PREV_FRAME_NO := L_FRAMEDATA_REC_TAB(L_X).FRAME_NO;
               L_PREV_FRAME_REVISION := L_FRAMEDATA_REC_TAB(L_X).REVISION;
               L_PREV_FRAME_OWNER := L_FRAMEDATA_REC_TAB(L_X).OWNER;
            END IF;
            
            
            
            
            
            
            UPDATE FRAMEDATA_SERVER 
            SET DATE_PROCESSED = SYSDATE
            WHERE ROWID = L_FRAMEDATA_REC_TAB(L_X).ROWID;
            
            COMMIT;            
            
            
         END LOOP;
         CLOSE C_FRAMEDATA_SERVER;
                  
         
         
         
         
         
         
         
         
         
         
         
       END IF;
       
       IF LBLOCKED THEN
          RELEASELOCK(LSLOCKNAME, LSLOCKHANDLE);
          LBLOCKED := FALSE;
       END IF;
       DBMS_APPLICATION_INFO.SET_ACTION( 'SPECSERVER JOB GOING TO SLEEP' );
      
   EXCEPTION
      WHEN OTHERS
      THEN
         
         IF LBLOCKED THEN
            BEGIN
               RELEASELOCK(LSLOCKNAME, LSLOCKHANDLE);
               LBLOCKED := FALSE;
            EXCEPTION
            WHEN OTHERS THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
            END;
         END IF;  
        

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         IF C_SPECDATA_SERVER%ISOPEN
         THEN
            CLOSE C_SPECDATA_SERVER;
         END IF;

         IF C_FRAMEDATA_SERVER%ISOPEN
         THEN
            CLOSE C_FRAMEDATA_SERVER;
         END IF;
         ROLLBACK;
   END RUNSPECSERVER;

   
   FUNCTION STARTSPECSERVER(
      ASUPDATESTATUS             IN       IAPITYPE.BOOLEAN_TYPE DEFAULT '1' )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      LSSPECSERVERNAME              VARCHAR2( 20 ) := 'SPEC_SERVER';
      LSQUEUENAME                   VARCHAR2( 20 ) := 'DB_Q';
      LNRETURNCODE                  NUMBER;
      LNJOBS                        NUMBER;
      LNCOUNT                       NUMBER;
      LNEMAILINSTALLED              NUMBER;
      LIJOB                         BINARY_INTEGER;
      
      LSLOCKNAME                    VARCHAR2(30);
      LSLOCKHANDLE                  VARCHAR2(200);
      LBLOCKED                      BOOLEAN;            
      LSSPECSERVERJOBINTERVAL       VARCHAR2(200);
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'StartSpecServer';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );	
      
      
      
      LBLOCKED := FALSE;
      
      LSLOCKNAME := 'ISPEC_SPECSERVERJOB_STARTSTOP';
      DBMS_LOCK.ALLOCATE_UNIQUE(LOCKNAME => LSLOCKNAME,
                                LOCKHANDLE => LSLOCKHANDLE,
                                EXPIRATION_SECS => 2144448000); 
      
      
      
      
      LNRETURNCODE := DBMS_LOCK.REQUEST(LOCKHANDLE => LSLOCKHANDLE,
                                      LOCKMODE => DBMS_LOCK.X_MODE,
                                      TIMEOUT => 0.01,
                                      RELEASE_ON_COMMIT => FALSE);  
      IF LNRETURNCODE = 1 THEN  
         RAISE_APPLICATION_ERROR(-20000, 'Another session trying to stop or to start the jobs. Your attempt to stop or start has been aborted.');
      ELSIF LNRETURNCODE = 4 THEN
         RAISE_APPLICATION_ERROR(-20000, 'The owner of user lock '||LSLOCKNAME||' is not the interspec dba (delete record from sys.dbms_lock_allocated if problem persists)');      
      ELSIF LNRETURNCODE <> 0 THEN
         RAISE_APPLICATION_ERROR(-20000, 'Request Lock for '||LSLOCKNAME||' failed with:'||TO_CHAR(LNRETURNCODE)||' (see DBMS_LOCK.REQUEST doc for details)');
      ELSE
         
         LBLOCKED := TRUE;		
      
         
         
         
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Trying to start E-mail job' );
         LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( 'email',
                                                          ASPARAMETERDATA => LNEMAILINSTALLED );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            LNEMAILINSTALLED := 0;
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
         END IF;

         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'E-mail installed <'
                              || LNEMAILINSTALLED
                              || '>' );

         IF LNEMAILINSTALLED = 1
         THEN
            LNRETVAL := IAPIEMAIL.STARTJOB( );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
            END IF;

            LNRETURNCODE := 0;
         END IF;

         COMMIT;
         
         
         
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Trying to start SpecServer job' );

         
         SELECT COUNT( JOB )
           INTO LNJOBS
           FROM DBA_JOBS
          WHERE UPPER( WHAT ) LIKE    '%'
                                   || UPPER( GSSOURCE )
                                   || '%';

         IF LNJOBS > 0
         THEN
            
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 'SpecServer job already started' );
            LNRETURNCODE := -1;
         ELSE
            
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    'Reading setting in interspc_cfg section <Specserver> Parameter <JOBINTERVAL>'
                                  );         
            LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( 'JOBINTERVAL', 'Specserver', 
                                                             ASPARAMETERDATA => LSSPECSERVERJOBINTERVAL );

            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    'Return='||LNRETVAL||' for GetConfigurationSetting for  section <Specserver> Parameter <JOBINTERVAL>'
                                  );         
            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               LSSPECSERVERJOBINTERVAL := 'SYSDATE + (1/100)'; 
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
            END IF;

            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    'Interval used for SpecServer job <'
                                 || LSSPECSERVERJOBINTERVAL
                                 || '>' );  
            
            DBMS_JOB.SUBMIT( LIJOB,
                                GSSOURCE
                             || '.RunSpecServer('''
                             || LSSPECSERVERNAME
                             || ''' ) ;',
                             SYSDATE,	
       
				 			 
                             LSSPECSERVERJOBINTERVAL );
       
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 'SpecServer job started' );
            LNRETURNCODE := 0;
         END IF;
         
         


         
		 
         COMMIT;
         
         
         
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Trying to start Queue Server job' );

         
         SELECT COUNT( JOB )
           INTO LNJOBS
           FROM DBA_JOBS
          WHERE UPPER( WHAT ) LIKE UPPER( '%iapiQueue.ExecuteQueue%' );

         IF LNJOBS > 0
         THEN
            
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 ' Queue Server job already started' );
            LNRETURNCODE := -1;
         ELSE
            DBMS_JOB.SUBMIT( LIJOB,
                             'iapiQueue.ExecuteQueue;',
                             SYSDATE,
                             '' );
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 ' Queue Server job started' );
            LNRETURNCODE := 0;
         END IF;

         IF ASUPDATESTATUS = '1'
         THEN
            UPDATE INTERSPC_CFG
               SET PARAMETER_DATA = 'ENABLED'
             WHERE SECTION = 'Specserver'
               AND PARAMETER = 'STATUS';
         END IF;

         COMMIT;  
	  
      END IF;
      IF LBLOCKED THEN
         RELEASELOCK(LSLOCKNAME, LSLOCKHANDLE);
         LBLOCKED := FALSE;
      END IF;			
     
      
      RETURN LNRETURNCODE;
   EXCEPTION
      WHEN OTHERS
      THEN	
         
         IF LBLOCKED THEN
            BEGIN
               RELEASELOCK(LSLOCKNAME, LSLOCKHANDLE);
               LBLOCKED := FALSE;
            EXCEPTION
            WHEN OTHERS THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
            END;
         END IF;
         
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
   END STARTSPECSERVER;

   
   FUNCTION STOPSPECSERVER(
      ASUPDATESTATUS             IN       IAPITYPE.BOOLEAN_TYPE DEFAULT '1' )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      LNEMAILINSTALLED              NUMBER;	 
      
      LSLOCKNAME                    VARCHAR2(30);
      LSLOCKHANDLE                  VARCHAR2(200);
      LBLOCKED                      BOOLEAN;            
      LNRETURNCODE                  INTEGER;
      LIJOBSPECSERVER               BINARY_INTEGER;
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'StopSpecServer';
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );	
      
      
      
      LBLOCKED := FALSE;
      
      LSLOCKNAME := 'ISPEC_SPECSERVERJOB_STARTSTOP';
      DBMS_LOCK.ALLOCATE_UNIQUE(LOCKNAME => LSLOCKNAME,
                                LOCKHANDLE => LSLOCKHANDLE,
                                EXPIRATION_SECS => 2144448000); 
      
      
      
      
      LNRETURNCODE := DBMS_LOCK.REQUEST(LOCKHANDLE => LSLOCKHANDLE,
                                      LOCKMODE => DBMS_LOCK.X_MODE,
                                      TIMEOUT => 0.01,
                                      RELEASE_ON_COMMIT => FALSE);  
      IF LNRETURNCODE = 1 THEN  
         RAISE_APPLICATION_ERROR(-20000, 'Another session trying to stop or to start the jobs. Your attempt to stop or start has been aborted.');
      ELSIF LNRETURNCODE = 4 THEN
         RAISE_APPLICATION_ERROR(-20000, 'The owner of user lock '||LSLOCKNAME||' is not the interspec dba (delete record from sys.dbms_lock_allocated if problem persists)');      
      ELSIF LNRETURNCODE <> 0 THEN
         RAISE_APPLICATION_ERROR(-20000, 'Request Lock for '||LSLOCKNAME||' failed with:'||TO_CHAR(LNRETURNCODE)||' (see DBMS_LOCK.REQUEST doc for details)');
      ELSE
         
         LBLOCKED := TRUE; 
      
         
         
         
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Trying to stop E-mail job' );
         DBMS_ALERT.SIGNAL( 'MAIL',
                            '2' );
         
         
         
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Trying to stop SpecServer job' );
         
         


         
         
         LIJOBSPECSERVER := NULL;
         BEGIN
            SELECT JOB
              INTO LIJOBSPECSERVER
              FROM DBA_JOBS
             WHERE UPPER( WHAT ) LIKE    '%'
                                          || UPPER( GSSOURCE || '.RunSpecServer' )
                                || '%';
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'No SpecServer job found to stop it' );
         WHEN TOO_MANY_ROWS THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  'More than one specserver job has been found and stopped. This is not supported. Contact the dba to investigate how this happened.' );         
            FOR L_JOB_REC IN (SELECT JOB
                              FROM DBA_JOBS
                              WHERE UPPER( WHAT ) LIKE    '%'
                                                                        || UPPER( GSSOURCE || '.RunSpecServer' )
                                || '%')
            LOOP
               DBMS_JOB.REMOVE(L_JOB_REC.JOB);
            END LOOP;

         END;
         IF LIJOBSPECSERVER IS NOT NULL THEN
            DBMS_JOB.REMOVE(LIJOBSPECSERVER);
         END IF;
        
         
         
         
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Trying to stop Queue Server job' );
         DBMS_ALERT.SIGNAL( 'DB_Q',
                            'Q_STOP' );

         IF ASUPDATESTATUS = '1'
         THEN
            UPDATE INTERSPC_CFG
               SET PARAMETER_DATA = 'DISABLED'
             WHERE SECTION = 'Specserver'
               AND PARAMETER = 'STATUS';
         END IF;

         COMMIT;		 
      
      END IF;
      IF LBLOCKED THEN
         RELEASELOCK(LSLOCKNAME, LSLOCKHANDLE);
         LBLOCKED := FALSE;
      END IF;
      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN		   
         
         IF LBLOCKED THEN
            BEGIN
               RELEASELOCK(LSLOCKNAME, LSLOCKHANDLE);
               LBLOCKED := FALSE;
               
            EXCEPTION
            WHEN OTHERS THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
            END;
         END IF;   
         
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
   END STOPSPECSERVER;

   
   FUNCTION ISSPECSERVERRUNNING
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsSpecserverRunning';
   
   
   
   
   
   
   
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM DBA_JOBS
       WHERE UPPER( WHAT ) LIKE    '%'
                                || UPPER( GSSOURCE )
                                || '%';

      IF LNCOUNT > 0
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      ELSE
         RETURN( IAPICONSTANTDBERROR.DBERR_SPECSERVERNOTRUNNING );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
   END ISSPECSERVERRUNNING;
END IAPISPECDATASERVER;
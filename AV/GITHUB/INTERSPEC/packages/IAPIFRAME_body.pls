CREATE OR REPLACE PACKAGE BODY iapiFrame
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

   
   
   
   
   
   
   FUNCTION CHECKFRAMEINDEV(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE )
      RETURN IAPITYPE.NUMVAL_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LNCOUNTER                     IAPITYPE.NUMVAL_TYPE := 1;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckFrameInDev';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT COUNT( * )
        INTO LNCOUNTER
        FROM FRAME_HEADER
       WHERE FRAME_NO = ASFRAMENO
         AND OWNER = ANOWNER
         AND STATUS = 1;

      RETURN LNCOUNTER;
   END CHECKFRAMEINDEV;

   
   FUNCTION UPDATEDISPLAY(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ANLAYOUTID                 IN       IAPITYPE.ID_TYPE,
      ANLAYOUTREVISION           IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANREFID                    IN       IAPITYPE.ID_TYPE,
      ANTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQDISPLAY(
         LNLAYOUTID                 IN       IAPITYPE.ID_TYPE,
         LNREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE )
      IS
         SELECT FIELD_ID
           FROM PROPERTY_LAYOUT
          WHERE LAYOUT_ID = LNLAYOUTID
            AND REVISION = ANREVISION;

      LNDISPLAYFRAMEREVISION        IAPITYPE.REVISION_TYPE;
      LNDISPLAYCOUNTER              IAPITYPE.NUMVAL_TYPE := 0;
      LNDISPLAYPOINTER              IAPITYPE.NUMVAL_TYPE := 0;
      LNSTACKCOUNTER                IAPITYPE.NUMVAL_TYPE := 0;
      LNSTACKPOINTER                IAPITYPE.NUMVAL_TYPE := 22;
      LNINSERTPROPCURSOR            IAPITYPE.NUMVAL_TYPE;
      LSSQLSTRING                   IAPITYPE.BUFFER_TYPE;
      LSSQLSTRING2                  IAPITYPE.BUFFER_TYPE;
      LSSQLSTRING3                  IAPITYPE.BUFFER_TYPE;
      LNRESULT                      IAPITYPE.NUMVAL_TYPE;
      LTPROPERTYDISPLAY             IAPITYPE.NUMBERTAB_TYPE;
      LBUPDATE                      IAPITYPE.LOGICAL_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'UpdateDisplay';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSFIELD                       IAPITYPE.STRING_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ANLAYOUTREVISION = 0
      THEN
         BEGIN
            SELECT MAX( REVISION )
              INTO LNDISPLAYFRAMEREVISION
              FROM LAYOUT
             WHERE LAYOUT_ID = ANLAYOUTID
               AND STATUS = 2;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      ELSE
         LNDISPLAYFRAMEREVISION := ANLAYOUTREVISION;
      END IF;

      LNDISPLAYCOUNTER := 0;

      FOR REC_DISPL IN LQDISPLAY( ANLAYOUTID,
                                  LNDISPLAYFRAMEREVISION )
      LOOP
         LNDISPLAYCOUNTER :=   LNDISPLAYCOUNTER
                             + 1;
         LTPROPERTYDISPLAY( LNDISPLAYCOUNTER ) := REC_DISPL.FIELD_ID;
      END LOOP;

      LNDISPLAYPOINTER := LNDISPLAYCOUNTER;
      LNSTACKCOUNTER := 1;
      LSSQLSTRING2 := ' ';

      
      
      FOR LNSTACKCOUNTER IN 1 .. LNSTACKPOINTER
      LOOP
         LBUPDATE := TRUE;

         FOR LNDISPLAYCOUNTER IN 1 .. LNDISPLAYPOINTER
         LOOP
            IF LNSTACKCOUNTER = LTPROPERTYDISPLAY( LNDISPLAYCOUNTER )
            THEN
               LBUPDATE := FALSE;
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                       'FALSE'
                                    || LNSTACKCOUNTER,
                                    IAPICONSTANT.INFOLEVEL_3 );
            END IF;
         END LOOP;

         IF LBUPDATE
         THEN
            BEGIN
               SELECT DECODE( LNSTACKCOUNTER,
                              1, IAPICONSTANT.COLUMN_NUM_1,
                              2, IAPICONSTANT.COLUMN_NUM_2,
                              3, IAPICONSTANT.COLUMN_NUM_3,
                              4, IAPICONSTANT.COLUMN_NUM_4,
                              5, IAPICONSTANT.COLUMN_NUM_5,
                              6, IAPICONSTANT.COLUMN_NUM_6,
                              7, IAPICONSTANT.COLUMN_NUM_7,
                              8, IAPICONSTANT.COLUMN_NUM_8,
                              9, IAPICONSTANT.COLUMN_NUM_9,
                              10, IAPICONSTANT.COLUMN_NUM_10,
                              11, IAPICONSTANT.COLUMN_CHAR_1,
                              12, IAPICONSTANT.COLUMN_CHAR_2,
                              13, IAPICONSTANT.COLUMN_CHAR_3,
                              14, IAPICONSTANT.COLUMN_CHAR_4,
                              15, IAPICONSTANT.COLUMN_CHAR_5,
                              16, IAPICONSTANT.COLUMN_CHAR_6,
                              17, IAPICONSTANT.COLUMN_BOOLEAN_1,
                              18, IAPICONSTANT.COLUMN_BOOLEAN_2,
                              19, IAPICONSTANT.COLUMN_BOOLEAN_3,
                              20, IAPICONSTANT.COLUMN_BOOLEAN_4,
                              21, IAPICONSTANT.COLUMN_DATE_1,
                              22, IAPICONSTANT.COLUMN_DATE_2,
                              23, IAPICONSTANT.COLUMN_UOM_ID,
                              24, IAPICONSTANT.COLUMN_ATTRIBUTE,
                              25, IAPICONSTANT.COLUMN_TEST_METHOD,
                              26, IAPICONSTANT.COLUMN_CHARACTERISTIC,
                              27, IAPICONSTANT.COLUMN_PROPERTY,
                              30, IAPICONSTANT.COLUMN_CH_2,
                              31, IAPICONSTANT.COLUMN_CH_3,
                              32, IAPICONSTANT.COLUMN_TM_DET_1,
                              33, IAPICONSTANT.COLUMN_TM_DET_2,
                              34, IAPICONSTANT.COLUMN_TM_DET_3,
                              35, IAPICONSTANT.COLUMN_TM_DET_4,
                              40, IAPICONSTANT.COLUMN_INFO )
                 INTO LSFIELD
                 FROM DUAL;

               IF LSSQLSTRING2 = ' '
               THEN
                  LSSQLSTRING2 :=    LSFIELD
                                  || '=NULL';
               ELSE
                  LSSQLSTRING2 :=    LSSQLSTRING2
                                  || ','
                                  || LSFIELD
                                  || '=NULL';
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        SQLERRM );
                  RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
            END;
         END IF;
      END LOOP;

      BEGIN
         LSSQLSTRING := 'UPDATE frame_prop set ';

         IF ANTYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP
         THEN
            LSSQLSTRING3 :=
                  ' WHERE frame_no = '
               || ''''
               || ASFRAMENO
               || ''''
               || ' AND revision = '
               || ANREVISION
               || ' AND owner = '
               || ANOWNER
               || ' AND section_id = '
               || ANSECTIONID
               || ' AND sub_section_id = '
               || ANSUBSECTIONID
               || ' AND property_group = '
               || ANREFID;
         ELSIF ANTYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY
         THEN
            LSSQLSTRING3 :=
                  ' WHERE frame_no = '
               || ''''
               || ASFRAMENO
               || ''''
               || ' AND revision = '
               || ANREVISION
               || ' AND owner = '
               || ANOWNER
               || ' AND section_id = '
               || ANSECTIONID
               || ' AND sub_section_id = '
               || ANSUBSECTIONID
               || ' AND property_group = 0 '
               || ' AND property = '
               || ANREFID;
         END IF;

         IF LSSQLSTRING2 <> ' '
         THEN
            LSSQLSTRING :=    LSSQLSTRING
                           || LSSQLSTRING2
                           || LSSQLSTRING3;
            LNINSERTPROPCURSOR := DBMS_SQL.OPEN_CURSOR;
            DBMS_SQL.PARSE( LNINSERTPROPCURSOR,
                            LSSQLSTRING,
                            DBMS_SQL.V7 );
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 LSSQLSTRING,
                                 IAPICONSTANT.INFOLEVEL_3 );
            LNRESULT := DBMS_SQL.EXECUTE( LNINSERTPROPCURSOR );
            DBMS_SQL.CLOSE_CURSOR( LNINSERTPROPCURSOR );
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            
            
            
            
            DBMS_SQL.CLOSE_CURSOR( LNINSERTPROPCURSOR );
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
   END UPDATEDISPLAY;

   
   FUNCTION UPDATELAYOUT(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQLAYOUTPROPERTYGROUP
      IS
         SELECT DISTINCT REF_ID,
                         DISPLAY_FORMAT,
                         DISPLAY_FORMAT_REV
                    FROM FRAME_SECTION
                   WHERE FRAME_NO = ASFRAMENO
                     AND REVISION = ANREVISION
                     AND OWNER = ANOWNER
                     AND TYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP;

      CURSOR LQLAYOUTSINGLEPROPERTY
      IS
         SELECT DISTINCT REF_ID,
                         DISPLAY_FORMAT,
                         DISPLAY_FORMAT_REV
                    FROM FRAME_SECTION
                   WHERE FRAME_NO = ASFRAMENO
                     AND REVISION = ANREVISION
                     AND OWNER = ANOWNER
                     AND TYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY;

      CURSOR LQLAYOUT2(
         LNLAYOUT                            IAPITYPE.ID_TYPE,
         LNREVISION                          IAPITYPE.REVISION_TYPE )
      IS
         SELECT DISTINCT FIELD_ID
                    FROM PROPERTY_LAYOUT
                   WHERE LAYOUT_ID = LNLAYOUT
                     AND REVISION = LNREVISION
                     AND FIELD_ID < 23;

      CURSOR LQLAYOUT3PROPERTYGROUP(
         LNPROPERTYGROUP                     IAPITYPE.FRAMEPROPERTYGROUP_TYPE,
         LNLAYOUT                            IAPITYPE.ID_TYPE,
         LNLAYOUTREVISION                    IAPITYPE.REVISION_TYPE )
      IS
         SELECT     FP.FRAME_NO,
                    FP.REVISION,
                    FP.OWNER,
                    FP.NUM_1,
                    FP.NUM_2,
                    FP.NUM_3,
                    FP.NUM_4,
                    FP.NUM_5,
                    FP.NUM_6,
                    FP.NUM_7,
                    FP.NUM_8,
                    FP.NUM_9,
                    FP.NUM_10,
                    FP.CHAR_1,
                    FP.CHAR_2,
                    FP.CHAR_3,
                    FP.CHAR_4,
                    FP.CHAR_5,
                    FP.CHAR_6,
                    FP.BOOLEAN_1,
                    FP.BOOLEAN_2,
                    FP.BOOLEAN_3,
                    FP.BOOLEAN_4,
                    FP.DATE_1,
                    FP.DATE_2,
                    FP.CH_2,
                    FP.CH_3,
                    FP.AS_2,
                    FP.AS_3
               FROM FRAME_PROP FP,
                    FRAME_SECTION FS
              WHERE FP.FRAME_NO = ASFRAMENO
                AND FP.REVISION = ANREVISION
                AND FP.OWNER = ANOWNER
                AND FP.PROPERTY_GROUP = LNPROPERTYGROUP
                AND FS.FRAME_NO = FP.FRAME_NO
                AND FS.REVISION = FP.REVISION
                AND FS.OWNER = FP.OWNER
                AND FS.REF_ID = FP.PROPERTY_GROUP
                AND FS.DISPLAY_FORMAT = LNLAYOUT
                AND FS.DISPLAY_FORMAT_REV = LNLAYOUTREVISION
                AND FS.SECTION_ID = FP.SECTION_ID
                AND FS.SUB_SECTION_ID = FP.SUB_SECTION_ID
                AND FS.SECTION_SEQUENCE_NO = FP.SEQUENCE_NO
                AND FS.TYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP
         FOR UPDATE;

      CURSOR LQLAYOUT3SINGLEPROPERTY(
         LNSINGLEPROPERTY                    IAPITYPE.ID_TYPE )
      IS
         SELECT     FRAME_NO,
                    REVISION,
                    OWNER,
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
                    BOOLEAN_1,
                    BOOLEAN_2,
                    BOOLEAN_3,
                    BOOLEAN_4,
                    DATE_1,
                    DATE_2
               FROM FRAME_PROP
              WHERE FRAME_NO = ASFRAMENO
                AND REVISION = ANREVISION
                AND OWNER = ANOWNER
                AND PROPERTY_GROUP = 0
                AND PROPERTY = LNSINGLEPROPERTY
         FOR UPDATE;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'UpdateLayout';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTALLFIELDS                   IAPITYPE.NUMBERTAB_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LNINDEX                       IAPITYPE.NUMVAL_TYPE;
      LNINDEXLAYOUTPROPERTYGROUP    IAPITYPE.NUMVAL_TYPE;
      LNINDEXLAYOUTSINGLEPROPERTY   IAPITYPE.NUMVAL_TYPE;
      LNINDEXLAYOUT2                IAPITYPE.NUMVAL_TYPE;
      LNINDEXLAYOUT3                IAPITYPE.NUMVAL_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
   
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR LNINDEXLAYOUTPROPERTYGROUP IN LQLAYOUTPROPERTYGROUP
      LOOP
         FOR LNCOUNT IN 1 .. 22
         LOOP
            LTALLFIELDS( LNCOUNT ) := LNCOUNT;
         END LOOP;

         SELECT MAX( REVISION )
           INTO LNREVISION
           FROM LAYOUT
          WHERE LAYOUT_ID = LNINDEXLAYOUTPROPERTYGROUP.DISPLAY_FORMAT
            AND STATUS = 2;
         
         
         FOR LNINDEXLAYOUT2 IN LQLAYOUT2( LNINDEXLAYOUTPROPERTYGROUP.DISPLAY_FORMAT,
                                          LNREVISION )
         LOOP
            LTALLFIELDS( LNINDEXLAYOUT2.FIELD_ID ) := NULL;
         END LOOP;

         
         
         FOR LNINDEXLAYOUT3 IN LQLAYOUT3PROPERTYGROUP( LNINDEXLAYOUTPROPERTYGROUP.REF_ID,
                                                       LNINDEXLAYOUTPROPERTYGROUP.DISPLAY_FORMAT,
                                                       LNINDEXLAYOUTPROPERTYGROUP.DISPLAY_FORMAT_REV )
         LOOP
            IF LTALLFIELDS( 1 ) = 1
            THEN
               UPDATE FRAME_PROP
                  SET NUM_1 = NULL
                WHERE CURRENT OF LQLAYOUT3PROPERTYGROUP;
            END IF;

            IF LTALLFIELDS( 2 ) = 2
            THEN
               UPDATE FRAME_PROP
                  SET NUM_2 = NULL
                WHERE CURRENT OF LQLAYOUT3PROPERTYGROUP;
            END IF;

            IF LTALLFIELDS( 3 ) = 3
            THEN
               UPDATE FRAME_PROP
                  SET NUM_3 = NULL
                WHERE CURRENT OF LQLAYOUT3PROPERTYGROUP;
            END IF;

            IF LTALLFIELDS( 4 ) = 4
            THEN
               UPDATE FRAME_PROP
                  SET NUM_4 = NULL
                WHERE CURRENT OF LQLAYOUT3PROPERTYGROUP;
            END IF;

            IF LTALLFIELDS( 5 ) = 5
            THEN
               UPDATE FRAME_PROP
                  SET NUM_5 = NULL
                WHERE CURRENT OF LQLAYOUT3PROPERTYGROUP;
            END IF;

            IF LTALLFIELDS( 6 ) = 6
            THEN
               UPDATE FRAME_PROP
                  SET NUM_6 = NULL
                WHERE CURRENT OF LQLAYOUT3PROPERTYGROUP;
            END IF;

            IF LTALLFIELDS( 7 ) = 7
            THEN
               UPDATE FRAME_PROP
                  SET NUM_7 = NULL
                WHERE CURRENT OF LQLAYOUT3PROPERTYGROUP;
            END IF;

            IF LTALLFIELDS( 8 ) = 8
            THEN
               UPDATE FRAME_PROP
                  SET NUM_8 = NULL
                WHERE CURRENT OF LQLAYOUT3PROPERTYGROUP;
            END IF;

            IF LTALLFIELDS( 9 ) = 9
            THEN
               UPDATE FRAME_PROP
                  SET NUM_9 = NULL
                WHERE CURRENT OF LQLAYOUT3PROPERTYGROUP;
            END IF;

            IF LTALLFIELDS( 10 ) = 10
            THEN
               UPDATE FRAME_PROP
                  SET NUM_10 = NULL
                WHERE CURRENT OF LQLAYOUT3PROPERTYGROUP;
            END IF;

            IF LTALLFIELDS( 11 ) = 11
            THEN
               UPDATE FRAME_PROP
                  SET CHAR_1 = NULL
                WHERE CURRENT OF LQLAYOUT3PROPERTYGROUP;
            END IF;

            IF LTALLFIELDS( 12 ) = 12
            THEN
               UPDATE FRAME_PROP
                  SET CHAR_2 = NULL
                WHERE CURRENT OF LQLAYOUT3PROPERTYGROUP;
            END IF;

            IF LTALLFIELDS( 13 ) = 13
            THEN
               UPDATE FRAME_PROP
                  SET CHAR_3 = NULL
                WHERE CURRENT OF LQLAYOUT3PROPERTYGROUP;
            END IF;

            IF LTALLFIELDS( 14 ) = 14
            THEN
               UPDATE FRAME_PROP
                  SET CHAR_4 = NULL
                WHERE CURRENT OF LQLAYOUT3PROPERTYGROUP;
            END IF;

            IF LTALLFIELDS( 15 ) = 15
            THEN
               UPDATE FRAME_PROP
                  SET CHAR_5 = NULL
                WHERE CURRENT OF LQLAYOUT3PROPERTYGROUP;
            END IF;

            IF LTALLFIELDS( 16 ) = 16
            THEN
               UPDATE FRAME_PROP
                  SET CHAR_6 = NULL
                WHERE CURRENT OF LQLAYOUT3PROPERTYGROUP;
            END IF;

            IF LTALLFIELDS( 17 ) = 17
            THEN
               UPDATE FRAME_PROP
                  SET BOOLEAN_1 = NULL
                WHERE CURRENT OF LQLAYOUT3PROPERTYGROUP;
            END IF;

            IF LTALLFIELDS( 18 ) = 18
            THEN
               UPDATE FRAME_PROP
                  SET BOOLEAN_2 = NULL
                WHERE CURRENT OF LQLAYOUT3PROPERTYGROUP;
            END IF;

            IF LTALLFIELDS( 19 ) = 19
            THEN
               UPDATE FRAME_PROP
                  SET BOOLEAN_3 = NULL
                WHERE CURRENT OF LQLAYOUT3PROPERTYGROUP;
            END IF;

            IF LTALLFIELDS( 20 ) = 20
            THEN
               UPDATE FRAME_PROP
                  SET BOOLEAN_4 = NULL
                WHERE CURRENT OF LQLAYOUT3PROPERTYGROUP;
            END IF;

            IF LTALLFIELDS( 21 ) = 21
            THEN
               UPDATE FRAME_PROP
                  SET DATE_1 = NULL
                WHERE CURRENT OF LQLAYOUT3PROPERTYGROUP;
            END IF;

            IF LTALLFIELDS( 22 ) = 22
            THEN
               UPDATE FRAME_PROP
                  SET DATE_2 = NULL
                WHERE CURRENT OF LQLAYOUT3PROPERTYGROUP;
            END IF;
         END LOOP;
      END LOOP;

      FOR LNINDEXLAYOUTSINGLEPROPERTY IN LQLAYOUTSINGLEPROPERTY
      LOOP
         FOR LNCOUNT IN 1 .. 22
         LOOP
            LTALLFIELDS( LNCOUNT ) := LNCOUNT;
         END LOOP;

         SELECT MAX( REVISION )
           INTO LNREVISION
           FROM LAYOUT
          WHERE LAYOUT_ID = LNINDEXLAYOUTSINGLEPROPERTY.DISPLAY_FORMAT
            AND STATUS = 2;
          
         
         FOR LNINDEXLAYOUT2 IN LQLAYOUT2( LNINDEXLAYOUTSINGLEPROPERTY.DISPLAY_FORMAT,
                                          LNREVISION )
         LOOP
            LTALLFIELDS( LNINDEXLAYOUT2.FIELD_ID ) := NULL;
         END LOOP;

         
         
         FOR LNINDEXLAYOUT3_SP IN LQLAYOUT3SINGLEPROPERTY( LNINDEXLAYOUTSINGLEPROPERTY.REF_ID )
         LOOP
            IF LTALLFIELDS( 1 ) = 1
            THEN
               UPDATE FRAME_PROP
                  SET NUM_1 = NULL
                WHERE CURRENT OF LQLAYOUT3SINGLEPROPERTY;
            END IF;

            IF LTALLFIELDS( 2 ) = 2
            THEN
               UPDATE FRAME_PROP
                  SET NUM_2 = NULL
                WHERE CURRENT OF LQLAYOUT3SINGLEPROPERTY;
            END IF;

            IF LTALLFIELDS( 3 ) = 3
            THEN
               UPDATE FRAME_PROP
                  SET NUM_3 = NULL
                WHERE CURRENT OF LQLAYOUT3SINGLEPROPERTY;
            END IF;

            IF LTALLFIELDS( 4 ) = 4
            THEN
               UPDATE FRAME_PROP
                  SET NUM_4 = NULL
                WHERE CURRENT OF LQLAYOUT3SINGLEPROPERTY;
            END IF;

            IF LTALLFIELDS( 5 ) = 5
            THEN
               UPDATE FRAME_PROP
                  SET NUM_5 = NULL
                WHERE CURRENT OF LQLAYOUT3SINGLEPROPERTY;
            END IF;

            IF LTALLFIELDS( 6 ) = 6
            THEN
               UPDATE FRAME_PROP
                  SET NUM_6 = NULL
                WHERE CURRENT OF LQLAYOUT3SINGLEPROPERTY;
            END IF;

            IF LTALLFIELDS( 7 ) = 7
            THEN
               UPDATE FRAME_PROP
                  SET NUM_7 = NULL
                WHERE CURRENT OF LQLAYOUT3SINGLEPROPERTY;
            END IF;

            IF LTALLFIELDS( 8 ) = 8
            THEN
               UPDATE FRAME_PROP
                  SET NUM_8 = NULL
                WHERE CURRENT OF LQLAYOUT3SINGLEPROPERTY;
            END IF;

            IF LTALLFIELDS( 9 ) = 9
            THEN
               UPDATE FRAME_PROP
                  SET NUM_9 = NULL
                WHERE CURRENT OF LQLAYOUT3SINGLEPROPERTY;
            END IF;

            IF LTALLFIELDS( 10 ) = 10
            THEN
               UPDATE FRAME_PROP
                  SET NUM_10 = NULL
                WHERE CURRENT OF LQLAYOUT3SINGLEPROPERTY;
            END IF;

            IF LTALLFIELDS( 11 ) = 11
            THEN
               UPDATE FRAME_PROP
                  SET CHAR_1 = NULL
                WHERE CURRENT OF LQLAYOUT3SINGLEPROPERTY;
            END IF;

            IF LTALLFIELDS( 12 ) = 12
            THEN
               UPDATE FRAME_PROP
                  SET CHAR_2 = NULL
                WHERE CURRENT OF LQLAYOUT3SINGLEPROPERTY;
            END IF;

            IF LTALLFIELDS( 13 ) = 13
            THEN
               UPDATE FRAME_PROP
                  SET CHAR_3 = NULL
                WHERE CURRENT OF LQLAYOUT3SINGLEPROPERTY;
            END IF;

            IF LTALLFIELDS( 14 ) = 14
            THEN
               UPDATE FRAME_PROP
                  SET CHAR_4 = NULL
                WHERE CURRENT OF LQLAYOUT3SINGLEPROPERTY;
            END IF;

            IF LTALLFIELDS( 15 ) = 15
            THEN
               UPDATE FRAME_PROP
                  SET CHAR_5 = NULL
                WHERE CURRENT OF LQLAYOUT3SINGLEPROPERTY;
            END IF;

            IF LTALLFIELDS( 16 ) = 16
            THEN
               UPDATE FRAME_PROP
                  SET CHAR_6 = NULL
                WHERE CURRENT OF LQLAYOUT3SINGLEPROPERTY;
            END IF;

            IF LTALLFIELDS( 17 ) = 17
            THEN
               UPDATE FRAME_PROP
                  SET BOOLEAN_1 = NULL
                WHERE CURRENT OF LQLAYOUT3SINGLEPROPERTY;
            END IF;

            IF LTALLFIELDS( 18 ) = 18
            THEN
               UPDATE FRAME_PROP
                  SET BOOLEAN_2 = NULL
                WHERE CURRENT OF LQLAYOUT3SINGLEPROPERTY;
            END IF;

            IF LTALLFIELDS( 19 ) = 19
            THEN
               UPDATE FRAME_PROP
                  SET BOOLEAN_3 = NULL
                WHERE CURRENT OF LQLAYOUT3SINGLEPROPERTY;
            END IF;

            IF LTALLFIELDS( 20 ) = 20
            THEN
               UPDATE FRAME_PROP
                  SET BOOLEAN_4 = NULL
                WHERE CURRENT OF LQLAYOUT3SINGLEPROPERTY;
            END IF;

            IF LTALLFIELDS( 21 ) = 21
            THEN
               UPDATE FRAME_PROP
                  SET DATE_1 = NULL
                WHERE CURRENT OF LQLAYOUT3SINGLEPROPERTY;
            END IF;

            IF LTALLFIELDS( 22 ) = 22
            THEN
               UPDATE FRAME_PROP
                  SET DATE_2 = NULL
                WHERE CURRENT OF LQLAYOUT3SINGLEPROPERTY;
            END IF;
         END LOOP;
      END LOOP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END UPDATELAYOUT;

   
   FUNCTION SYNCHRONISEVALIDATION(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SynchroniseValidation';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;

      CURSOR LQFRAMEVALIDATION
      IS
         SELECT VAL_ID
           FROM ITFRMVAL
          WHERE FRAME_NO = ASFRAMENO
            AND REVISION = ANREVISION
            AND OWNER = ANOWNER;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR LNFRAMEVALIDATION IN LQFRAMEVALIDATION
      LOOP
         
         DELETE FROM ITFRMVALD
               WHERE VAL_ID = LNFRAMEVALIDATION.VAL_ID
                 AND ( SECTION_ID, SUB_SECTION_ID ) NOT IN( SELECT DISTINCT SECTION_ID,
                                                                            SUB_SECTION_ID
                                                                      FROM FRAME_SECTION
                                                                     WHERE FRAME_NO = ASFRAMENO
                                                                       AND REVISION = ANREVISION
                                                                       AND OWNER = ANOWNER );

         
         DELETE FROM ITFRMVALD
               WHERE VAL_ID = LNFRAMEVALIDATION.VAL_ID
                 AND TYPE = 1
                 AND ( SECTION_ID, SUB_SECTION_ID, PROPERTY_GROUP, PROPERTY, ATTRIBUTE ) NOT IN(
                                                                 SELECT DISTINCT SECTION_ID,
                                                                                 SUB_SECTION_ID,
                                                                                 PROPERTY_GROUP,
                                                                                 PROPERTY,
                                                                                 ATTRIBUTE
                                                                            FROM FRAME_PROP
                                                                           WHERE FRAME_NO = ASFRAMENO
                                                                             AND REVISION = ANREVISION
                                                                             AND OWNER = ANOWNER
                                                                             AND TYPE = 1 );

         
         DELETE FROM ITFRMVALD
               WHERE VAL_ID = LNFRAMEVALIDATION.VAL_ID
                 AND TYPE = 2
                 AND ( SECTION_ID, SUB_SECTION_ID ) NOT IN( SELECT DISTINCT SECTION_ID,
                                                                            SUB_SECTION_ID
                                                                      FROM FRAME_SECTION
                                                                     WHERE FRAME_NO = ASFRAMENO
                                                                       AND REVISION = ANREVISION
                                                                       AND OWNER = ANOWNER
                                                                       AND TYPE = 2 );

         
         DELETE FROM ITFRMVALD
               WHERE VAL_ID = LNFRAMEVALIDATION.VAL_ID
                 AND TYPE = 3
                 AND ( SECTION_ID, SUB_SECTION_ID ) NOT IN( SELECT DISTINCT SECTION_ID,
                                                                            SUB_SECTION_ID
                                                                      FROM FRAME_SECTION
                                                                     WHERE FRAME_NO = ASFRAMENO
                                                                       AND REVISION = ANREVISION
                                                                       AND OWNER = ANOWNER
                                                                       AND TYPE = 3 );

         
         DELETE FROM ITFRMVALD
               WHERE VAL_ID = LNFRAMEVALIDATION.VAL_ID
                 AND TYPE = 4
                 AND ( SECTION_ID, SUB_SECTION_ID, PROPERTY_GROUP, PROPERTY, ATTRIBUTE ) NOT IN(
                                                                 SELECT DISTINCT SECTION_ID,
                                                                                 SUB_SECTION_ID,
                                                                                 PROPERTY_GROUP,
                                                                                 PROPERTY,
                                                                                 ATTRIBUTE
                                                                            FROM FRAME_PROP
                                                                           WHERE FRAME_NO = ASFRAMENO
                                                                             AND REVISION = ANREVISION
                                                                             AND OWNER = ANOWNER
                                                                             AND TYPE = 4 );

         
         DELETE FROM ITFRMVALD
               WHERE VAL_ID = LNFRAMEVALIDATION.VAL_ID
                 AND TYPE = 5
                 AND ( SECTION_ID, SUB_SECTION_ID ) NOT IN( SELECT DISTINCT SECTION_ID,
                                                                            SUB_SECTION_ID
                                                                      FROM FRAME_SECTION
                                                                     WHERE FRAME_NO = ASFRAMENO
                                                                       AND REVISION = ANREVISION
                                                                       AND OWNER = ANOWNER
                                                                       AND TYPE = 5 );

         
         DELETE FROM ITFRMVALD
               WHERE VAL_ID = LNFRAMEVALIDATION.VAL_ID
                 AND TYPE = 6
                 AND ( SECTION_ID, SUB_SECTION_ID ) NOT IN( SELECT DISTINCT SECTION_ID,
                                                                            SUB_SECTION_ID
                                                                      FROM FRAME_SECTION
                                                                     WHERE FRAME_NO = ASFRAMENO
                                                                       AND REVISION = ANREVISION
                                                                       AND OWNER = ANOWNER
                                                                       AND TYPE = 6 );

         
         DELETE FROM ITFRMVALD
               WHERE VAL_ID = LNFRAMEVALIDATION.VAL_ID
                 AND TYPE = 7
                 AND ( SECTION_ID, SUB_SECTION_ID ) NOT IN( SELECT DISTINCT SECTION_ID,
                                                                            SUB_SECTION_ID
                                                                      FROM FRAME_SECTION
                                                                     WHERE FRAME_NO = ASFRAMENO
                                                                       AND REVISION = ANREVISION
                                                                       AND OWNER = ANOWNER
                                                                       AND TYPE = 7 );

         
         DELETE FROM ITFRMVALD
               WHERE VAL_ID = LNFRAMEVALIDATION.VAL_ID
                 AND TYPE = 8
                 AND ( SECTION_ID, SUB_SECTION_ID ) NOT IN( SELECT DISTINCT SECTION_ID,
                                                                            SUB_SECTION_ID
                                                                      FROM FRAME_SECTION
                                                                     WHERE FRAME_NO = ASFRAMENO
                                                                       AND REVISION = ANREVISION
                                                                       AND OWNER = ANOWNER
                                                                       AND TYPE = 8 );

         
         DELETE FROM ITFRMVALD
               WHERE VAL_ID = LNFRAMEVALIDATION.VAL_ID
                 AND TYPE = 9
                 AND ( SECTION_ID, SUB_SECTION_ID ) NOT IN( SELECT DISTINCT SECTION_ID,
                                                                            SUB_SECTION_ID
                                                                      FROM FRAME_SECTION
                                                                     WHERE FRAME_NO = ASFRAMENO
                                                                       AND REVISION = ANREVISION
                                                                       AND OWNER = ANOWNER
                                                                       AND TYPE = 9 );
      END LOOP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         
         NULL;
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SYNCHRONISEVALIDATION;

   
   
   
   
   FUNCTION EXISTID(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE DEFAULT 1 )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistId';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSFRAMENO                     IAPITYPE.FRAMENO_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT FRAME_NO
        INTO LSFRAMENO
        FROM FRAME_HEADER
       WHERE FRAME_NO = ASFRAMENO
         AND REVISION = ANREVISION
         AND OWNER = ANOWNER;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_FRAMENOTFOUND,
                                                     ASFRAMENO,
                                                     ANREVISION,
                                                     ANOWNER ) );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTID;

   
   FUNCTION CREATEMASKSECTION(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANTYPE                     IN       IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE,
      ANREFERENCEID              IN       IAPITYPE.ID_TYPE,
      ANSEQUENCENR               IN       IAPITYPE.SEQUENCE_TYPE,
      ANVIEWID                   IN       IAPITYPE.ID_TYPE,
      ASACTION                   IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CreateMaskSection';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ASACTION <> 'rem'
      THEN
         BEGIN
            INSERT INTO ITFRMVSC
                        ( VIEW_ID,
                          FRAME_NO,
                          REVISION,
                          OWNER,
                          SECTION_ID,
                          SUB_SECTION_ID,
                          TYPE,
                          REF_ID,
                          SECTION_SEQUENCE_NO,
                          MANDATORY )
                 VALUES ( ANVIEWID,
                          ASFRAMENO,
                          ANREVISION,
                          ANOWNER,
                          ANSECTIONID,
                          ANSUBSECTIONID,
                          ANTYPE,
                          ANREFERENCEID,
                          ANSEQUENCENR,
                          ASACTION );
         EXCEPTION
            WHEN OTHERS
            THEN
               UPDATE ITFRMVSC
                  SET MANDATORY = ASACTION
                WHERE VIEW_ID = ANVIEWID
                  AND FRAME_NO = ASFRAMENO
                  AND REVISION = ANREVISION
                  AND OWNER = ANOWNER
                  AND SECTION_ID = ANSECTIONID
                  AND SUB_SECTION_ID = ANSUBSECTIONID
                  AND TYPE = ANTYPE
                  AND REF_ID = ANREFERENCEID
                  AND SECTION_SEQUENCE_NO = ANSEQUENCENR;
         END;
      ELSIF ASACTION = 'rem'
      THEN
         DELETE FROM ITFRMVSC
               WHERE VIEW_ID = ANVIEWID
                 AND FRAME_NO = ASFRAMENO
                 AND REVISION = ANREVISION
                 AND OWNER = ANOWNER
                 AND SECTION_ID = ANSECTIONID
                 AND SUB_SECTION_ID = ANSUBSECTIONID
                 AND TYPE = ANTYPE
                 AND REF_ID = ANREFERENCEID
                 AND SECTION_SEQUENCE_NO = ANSEQUENCENR;
      END IF;

      UPDATE ITFRMV
         SET LAST_MODIFIED_BY = USER,
             LAST_MODIFIED_ON = SYSDATE
       WHERE VIEW_ID = ANVIEWID
         AND FRAME_NO = ASFRAMENO
         AND REVISION = ANREVISION
         AND OWNER = ANOWNER;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CREATEMASKSECTION;

   
   FUNCTION CREATEMASKPROPERTYGROUP(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPID          IN       IAPITYPE.FRAMEPROPERTYGROUP_TYPE,
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE,
      ANVIEWID                   IN       IAPITYPE.ID_TYPE,
      ASACTION                   IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CreateMaskPropertyGroup';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ASACTION <> 'rem'
      THEN
         BEGIN
            INSERT INTO ITFRMVPG
                        ( VIEW_ID,
                          FRAME_NO,
                          REVISION,
                          OWNER,
                          SECTION_ID,
                          SUB_SECTION_ID,
                          PROPERTY_GROUP,
                          PROPERTY,
                          ATTRIBUTE,
                          MANDATORY )
                 VALUES ( ANVIEWID,
                          ASFRAMENO,
                          ANREVISION,
                          ANOWNER,
                          ANSECTIONID,
                          ANSUBSECTIONID,
                          ANPROPERTYGROUPID,
                          ANPROPERTYID,
                          ANATTRIBUTEID,
                          ASACTION );
         EXCEPTION
            WHEN OTHERS
            THEN
               UPDATE ITFRMVPG
                  SET MANDATORY = ASACTION
                WHERE VIEW_ID = ANVIEWID
                  AND FRAME_NO = ASFRAMENO
                  AND REVISION = ANREVISION
                  AND OWNER = ANOWNER
                  AND SECTION_ID = ANSECTIONID
                  AND SUB_SECTION_ID = ANSUBSECTIONID
                  AND PROPERTY_GROUP = ANPROPERTYGROUPID
                  AND PROPERTY = ANPROPERTYID
                  AND ATTRIBUTE = ANATTRIBUTEID;
         END;
      ELSIF ASACTION = 'rem'
      THEN
         DELETE FROM ITFRMVPG
               WHERE VIEW_ID = ANVIEWID
                 AND FRAME_NO = ASFRAMENO
                 AND REVISION = ANREVISION
                 AND OWNER = ANOWNER
                 AND SECTION_ID = ANSECTIONID
                 AND SUB_SECTION_ID = ANSUBSECTIONID
                 AND PROPERTY_GROUP = ANPROPERTYGROUPID
                 AND PROPERTY = ANPROPERTYID
                 AND ATTRIBUTE = ANATTRIBUTEID;
      END IF;

      UPDATE ITFRMV
         SET LAST_MODIFIED_BY = USER,
             LAST_MODIFIED_ON = SYSDATE
       WHERE VIEW_ID = ANVIEWID
         AND FRAME_NO = ASFRAMENO
         AND REVISION = ANREVISION
         AND OWNER = ANOWNER;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CREATEMASKPROPERTYGROUP;

   
   FUNCTION GETSECTIONSUBSECTION(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ASVIEWBOM                  IN       IAPITYPE.PROPERTYBOOLEAN_TYPE,
      AQRESULT                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetSectionSubSection';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQRESULT%ISOPEN )
      THEN
         CLOSE AQRESULT;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ASVIEWBOM = 'Y'
      THEN
         LSSQL :=
               ' SELECT   section_id sc_id, '
            || ' sub_section_id sb_id, '
            || ' f_section_descr sc_name, '
            || ' f_sub_section_descr sb_name, '
            || ' MAX( section_rev ) sc_revision, '
            || ' sub_section_rev sb_revision, '
            || ' MAX( seq_no ) seq_no, '
            || ' MAX( sc_ext ) ext '
            || ' FROM ( SELECT DISTINCT section_id, '
            || ' sub_section_id, '
            || ' F_Sch_Descr( 1,section_id,section_rev ) f_section_descr, '
            || ' F_Sbh_Descr( 1,sub_section_id,sub_section_rev ) f_sub_section_descr, '
            || ' section_rev, '
            || ' sub_section_rev, '
            || ' TYPE, '
            || ' section_sequence_no seq_no, '
            || ' DECODE( SC_EXT,''Y'',1,0 ) sc_ext '
            || ' FROM FRAME_SECTION '
            || ' WHERE ( frame_no = :asFrameNo ) '
            || ' AND ( revision = :anRevision ) '
            || ' AND ( owner = :anOwner ) '
            || ' UNION '
            || ' SELECT 0 section_id, '
            || ' 0 sub_section_id, '
            || ' ''Header'' f_section_descr, '
            || ' ''(none)'' f_sub_section_descr, '
            || ' 0 section_rev, '
            || ' 0 sub_section_rev, '
            || ' 0 TYPE, '
            || ' 0 seq_no, '
            || ' 0 sc_ext '
            || ' FROM DUAL ) '
            || ' GROUP BY section_id, '
            || ' sub_section_id, '
            || ' f_section_descr, '
            || ' f_sub_section_descr, '
            || ' sub_section_rev '
            || ' ORDER BY seq_no ';

         OPEN AQRESULT FOR LSSQL USING ASFRAMENO,
         ANREVISION,
         ANOWNER;
      ELSE
         LSSQL :=
               ' SELECT   section_id sc_id, '
            || ' sub_section_id sb_id, '
            || ' f_section_descr sc_name, '
            || ' f_sub_section_descr sb_name, '
            || ' MAX( section_rev ) sc_revision, '
            || ' sub_section_rev sb_revision, '
            || ' MAX( seq_no ) seq_no, '
            || ' MAX( sc_ext ) ext '
            || ' FROM ( SELECT DISTINCT section_id, '
            || ' sub_section_id, '
            || ' F_Sch_Descr( 1,section_id,section_rev ) f_section_descr, '
            || ' F_Sbh_Descr( 1,sub_section_id,sub_section_rev ) f_sub_section_descr, '
            || ' section_rev, '
            || ' sub_section_rev, '
            || ' TYPE, '
            || ' section_sequence_no seq_no, '
            || ' DECODE( SC_EXT,''Y'', 1,0 ) sc_ext '
            || ' FROM FRAME_SECTION '
            || ' WHERE ( frame_no = :asFrameNo ) '
            || ' AND ( revision = :anRevision ) '
            || ' AND ( owner = :anOwner ) '
            || ' AND ( TYPE <> 3 )   -- Remove type = 8 and ref id = 0 '
            || ' UNION '
            || ' SELECT 0 section_id, '
            || ' 0 sub_section_id, '
            || ' ''Header'' f_section_descr, '
            || ' ''(none)'' f_sub_section_descr, '
            || ' 0 section_rev, '
            || ' 0 sub_section_rev, '
            || ' 0 TYPE, '
            || ' 0 seq_no, '
            || ' 0 sc_ext '
            || ' FROM DUAL ) '
            || ' GROUP BY section_id, '
            || ' sub_section_id, '
            || ' f_section_descr, '
            || ' f_sub_section_descr, '
            || ' sub_section_rev '
            || ' ORDER BY seq_no ';

         OPEN AQRESULT FOR LSSQL USING ASFRAMENO,
         ANREVISION,
         ANOWNER;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETSECTIONSUBSECTION;

   
   FUNCTION GETSECTIONSUBSECTIONITEMS(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ASVIEWBOM                  IN       IAPITYPE.PROPERTYBOOLEAN_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      AQRESULT                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetSectionSubSectionItems';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQRESULT%ISOPEN )
      THEN
         CLOSE AQRESULT;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ASVIEWBOM = 'N'
      THEN
         LSSQL :=
               ' SELECT TYPE, '
            || ' section_sequence_no, '
            || ' ref_id, '
            || ' ref_ver, '
            || ' ref_info, '
            || ' ref_owner, '
            || ' DECODE( HEADER,''1'', 1,0 ) HEADER, '
            || ' DECODE( mandatory,''Y'', 1,0 ) mandatory, '
            || ' display_format, '
            || ' display_format_rev, '
            || ' ASSOCIATION, '
            || ' DECODE( intl,2, 1,0 ) lm '
            || ' FROM FRAME_SECTION '
            || ' WHERE ( frame_no = :asFrameNo ) '
            || ' AND ( revision = :anRevision ) '
            || ' AND ( owner = :anOwner ) '
            || ' AND ( section_id = :anSectionId ) '
            || ' AND ( sub_section_id = :anSubSectionId ) '
            || ' AND ( TYPE <> 3 )   -- Remove type = 8 and ref id = 0 '
            || ' ORDER BY 2 ';

         OPEN AQRESULT FOR LSSQL USING ASFRAMENO,
         ANREVISION,
         ANOWNER,
         ANSECTIONID,
         ANSUBSECTIONID;
      ELSE
         LSSQL :=
               ' SELECT   TYPE, '
            || ' section_sequence_no, '
            || ' ref_id, '
            || ' ref_ver, '
            || ' ref_info, '
            || ' ref_owner, '
            || ' DECODE( HEADER,''1'', 1,0 ) HEADER, '
            || ' DECODE( mandatory,''Y'', 1,0 ) mandatory, '
            || ' display_format, '
            || ' display_format_rev, '
            || ' ASSOCIATION, '
            || ' DECODE( intl,2, 1,0 ) lm '
            || ' FROM FRAME_SECTION '
            || ' WHERE ( frame_no = :asFrameNo ) '
            || ' AND ( revision = :anRevision ) '
            || ' AND ( owner = :anOwner ) '
            || ' AND ( section_id = :anSectionId ) '
            || ' AND ( sub_section_id = :anSubSectionId ) '
            || ' ORDER BY 2 ';

         OPEN AQRESULT FOR LSSQL USING ASFRAMENO,
         ANREVISION,
         ANOWNER,
         ANSECTIONID,
         ANSUBSECTIONID;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETSECTIONSUBSECTIONITEMS;

   
   FUNCTION GETEXTENDABLEFRAME(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      AQSECTIONS                 OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetExtendableFrame';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'section_id '
            || IAPICONSTANTCOLUMN.SECTIONIDCOL
            || ', section_rev '
            || IAPICONSTANTCOLUMN.SECTIONREVISIONCOL
            || ', sub_section_id '
            || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
            || ', sub_section_rev '
            || IAPICONSTANTCOLUMN.SUBSECTIONREVISIONCOL
            || ', section_sequence_no '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ', type '
            || IAPICONSTANTCOLUMN.TYPECOL
            || ', SUBSTR( f_ref_type_descr( 1, TYPE, ref_id ), 1, 60 ) '
            || IAPICONSTANTCOLUMN.TYPENAMECOL
            || ', f_sch_descr(1, section_id, section_rev) '
            || IAPICONSTANTCOLUMN.SECTIONNAMECOL
            || ', f_sbh_descr(1, sub_section_id, sub_section_rev) '
            || IAPICONSTANTCOLUMN.SUBSECTIONNAMECOL
            || ', DECODE(sc_ext,''Y'',1,0 ) '
            || IAPICONSTANTCOLUMN.EXTENDABLESECTIONCOL
            || ', DECODE(ref_ext,''Y'',1,0 ) '
            || IAPICONSTANTCOLUMN.EXTENDABLEPROPERTYGROUPCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'frame_section';
   BEGIN
      
      
      
      
      
      IF ( AQSECTIONS%ISOPEN )
      THEN
         CLOSE AQSECTIONS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE frame_no = null AND revision = null AND owner = null';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQSECTIONS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNRETVAL := IAPIFRAME.EXISTID( ASFRAMENO,
                                     ANREVISION,
                                     ANOWNER );

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

      
      IF ( AQSECTIONS%ISOPEN )
      THEN
         CLOSE AQSECTIONS;
      END IF;

      LSSQL :=
            'SELECT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE frame_no = :FrameNo '
         || '   AND revision = :Revision '
         || '   AND owner    = :Owner'
         || ' ORDER BY SECTION_SEQUENCE_NO  ASC ';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQSECTIONS%ISOPEN )
      THEN
         CLOSE AQSECTIONS;
      END IF;

      
      OPEN AQSECTIONS FOR LSSQL USING ASFRAMENO,
      ANREVISION,
      ANOWNER;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETEXTENDABLEFRAME;

   
   FUNCTION CREATEFRAMEHEADER(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ASCREATEDBY                IN       IAPITYPE.USERID_TYPE,
      ANCLASS3ID                 IN       IAPITYPE.ID_TYPE,
      ANWORKFLOWGROUPID          IN       IAPITYPE.ID_TYPE,
      ANACCESSGROUP              IN       IAPITYPE.ID_TYPE,
      ASINTL                     IN       IAPITYPE.INTL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CreateFrameHeader';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCHECK                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      SELECT COUNT( * )
        INTO LNCHECK
        FROM FRAME_HEADER
       WHERE FRAME_NO = ASFRAMENO
         AND OWNER = IAPIGENERAL.SESSION.DATABASE.OWNER;

      IF LNCHECK = 0
      THEN
         INSERT INTO FRAME_HEADER
                     ( FRAME_NO,
                       REVISION,
                       OWNER,
                       STATUS,
                       STATUS_CHANGE_DATE,
                       DESCRIPTION,
                       CREATED_BY,
                       CREATED_ON,
                       LAST_MODIFIED_BY,
                       LAST_MODIFIED_ON,
                       CLASS3_ID,
                       WORKFLOW_GROUP_ID,
                       ACCESS_GROUP,
                       INTL )
              VALUES ( ASFRAMENO,
                       1,
                       IAPIGENERAL.SESSION.DATABASE.OWNER,
                       1,
                       SYSDATE,
                       ASDESCRIPTION,
                       UPPER( USER ),
                       SYSDATE,
                       UPPER( USER ),
                       SYSDATE,
                       ANCLASS3ID,
                       ANWORKFLOWGROUPID,
                       ANACCESSGROUP,
                       ASINTL );
      ELSE
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_FRAMEALREADYEXIST );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CREATEFRAMEHEADER;


   FUNCTION COPYFRAME(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ASFRAMENOFROM              IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ASCREATEDBY                IN       IAPITYPE.USERID_TYPE,
      ANCLASS3ID                 IN       IAPITYPE.ID_TYPE,
      ANWORKFLOWGROUPID          IN       IAPITYPE.ID_TYPE,
      ANACCESSGROUP              IN       IAPITYPE.ID_TYPE,
      ASINTLFROM                 IN       IAPITYPE.INTL_TYPE,
      ASINTL                     IN       IAPITYPE.INTL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CopyFrame';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNTER                     IAPITYPE.NUMVAL_TYPE;
      LNREVISION                    IAPITYPE.FRAMEREVISION_TYPE;
      LSINTL                        IAPITYPE.INTL_TYPE;
      LNINCLDEV                     IAPITYPE.NUMVAL_TYPE := 0;
      LNOWNER                       IAPITYPE.OWNER_TYPE;
      LNSYNCREVISION                IAPITYPE.FRAMEREVISION_TYPE := 0;
      LNSYNCCHECK                   IAPITYPE.NUMVAL_TYPE := 0;
      LNFRAMEREVISION               IAPITYPE.FRAMEREVISION_TYPE;
      LNHIGHESTREVISION             IAPITYPE.FRAMEREVISION_TYPE;
      LNFRAMENOTE                   IAPITYPE.NUMVAL_TYPE;
      LNFRAMETEXTREC                IAPITYPE.NUMVAL_TYPE;

      
      CURSOR LQFRAMETEXT(
         LNFRAMEREVISION                     IAPITYPE.FRAMEREVISION_TYPE )
      IS
         SELECT *
           FROM FRAME_TEXT
          WHERE FRAME_NO = ASFRAMENOFROM
            AND REVISION = LNFRAMEREVISION
            AND OWNER = ANOWNER;

      CURSOR LQINTLFRAMETEXT(
         LNFRAMEREVISION                     IAPITYPE.FRAMEREVISION_TYPE )
      IS
         SELECT A.SECTION_ID,
                A.SECTION_REV,
                A.SUB_SECTION_ID,
                A.SUB_SECTION_REV,
                A.TEXT_TYPE,
                A.TEXT
           FROM FRAME_TEXT A,
                FRAME_SECTION B
          WHERE A.FRAME_NO = ASFRAMENOFROM
            AND A.REVISION = LNFRAMEREVISION
            AND A.OWNER = ANOWNER
            AND A.FRAME_NO = B.FRAME_NO
            AND A.REVISION = B.REVISION
            AND A.OWNER = B.OWNER
            AND A.SECTION_ID = B.SECTION_ID
            AND A.SUB_SECTION_ID = B.SUB_SECTION_ID
            AND A.TEXT_TYPE = B.REF_ID
            AND B.INTL IN( '1', '2' )
            AND B.TYPE = 5;

      CURSOR LQFRAMENOTE
      IS
         SELECT *
           FROM ITFRMNOTE
          WHERE FRAME_NO = ASFRAMENOFROM
            AND OWNER = ANOWNER;

   BEGIN
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNFRAMEREVISION := ANREVISION;
      LNCOUNTER := CHECKFRAMEINDEV( ASFRAMENO,
                                    ANOWNER );

      IF LNCOUNTER > 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_FRAMEINDEVALREADYEXIST,
                                                    ASFRAMENO,
                                                    ANOWNER );
      END IF;

      
      IF ASFRAMENO = ASFRAMENOFROM
      THEN
         
         IF ASINTL = '0'
         THEN
            
            IF ASINTLFROM = '1'
            THEN
               
               
               
               SELECT   MAX( REVISION )
                      + 0.01
                 INTO LNREVISION
                 FROM FRAME_HEADER
                WHERE FRAME_NO = ASFRAMENO
                  AND OWNER = ANOWNER;

               
               
               LSINTL := '1';
               LNINCLDEV := 1;
               
               LNOWNER := ANOWNER;

               IF MOD(   LNFRAMEREVISION
                       * 100,
                       100 ) = 0
               THEN
                  
                  BEGIN
                     SELECT MAX( REVISION )
                       INTO LNSYNCREVISION
                       FROM FRAME_HEADER
                      WHERE FRAME_NO = ASFRAMENO
                        AND MOD(   REVISION
                                 * 100,
                                 100 ) > 0
                        AND REVISION < LNFRAMEREVISION
                        AND OWNER = ANOWNER;

                     LNSYNCCHECK := MOD(   LNSYNCREVISION
                                         * 100,
                                         100 );
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        LNSYNCCHECK := 0;
                  END;
               ELSE
                  
                  
                  
                  
                  BEGIN
                     SELECT MAX( REVISION )
                       INTO LNHIGHESTREVISION
                       FROM FRAME_HEADER
                      WHERE FRAME_NO = ASFRAMENO
                        AND REVISION > LNFRAMEREVISION
                        AND MOD(   REVISION
                                 * 100,
                                 100 ) = 0
                        AND OWNER = ANOWNER;

                     IF LNHIGHESTREVISION IS NULL
                     THEN
                                                                
                        
                        LNSYNCREVISION := LNFRAMEREVISION;

                        SELECT   MAX( REVISION )
                               + 0.01
                          INTO LNREVISION
                          FROM FRAME_HEADER
                         WHERE FRAME_NO = ASFRAMENO
                           AND OWNER = ANOWNER;

                        
                        LSINTL := '1';
                        LNINCLDEV := 1;
                        
                        LNOWNER := ANOWNER;
                        LNSYNCCHECK := 0;
                     ELSE
                        
                        LNSYNCREVISION := LNFRAMEREVISION;
                        
                        LNFRAMEREVISION := LNHIGHESTREVISION;

                        
                        
                        SELECT   MAX( REVISION )
                               + 0.01
                          INTO LNREVISION
                          FROM FRAME_HEADER
                         WHERE FRAME_NO = ASFRAMENO
                           AND OWNER = ANOWNER;

                        
                        
                        LSINTL := '1';
                        LNINCLDEV := 1;
                        
                        LNOWNER := ANOWNER;
                        LNSYNCCHECK := MOD(   LNSYNCREVISION
                                            * 100,
                                            100 );
                     END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        
                        
                        SELECT   MAX( REVISION )
                               + 1
                          INTO LNREVISION
                          FROM FRAME_HEADER
                         WHERE FRAME_NO = ASFRAMENO
                           AND OWNER = ANOWNER;

                        
                        LSINTL := '1';
                        LNINCLDEV := 1;
                        
                        LNOWNER := ANOWNER;
                  END;
               END IF;
            END IF;

            
            IF ASINTLFROM = '0'
            THEN
               
               SELECT   MAX( REVISION )
                      + 1
                 INTO LNREVISION
                 FROM FRAME_HEADER
                WHERE FRAME_NO = ASFRAMENO
                  AND OWNER = ANOWNER;

               
               LSINTL := '0';
               LNINCLDEV := 1;
               
               LNOWNER := ANOWNER;
            END IF;
         END IF;

         
         IF ASINTL = '1'
         THEN
            
            IF ASINTLFROM = '1'
            THEN
               
               
               
               IF ANOWNER = IAPIGENERAL.SESSION.DATABASE.OWNER
               THEN
                  
                  
                  SELECT   MAX( REVISION )
                         + 1
                    INTO LNREVISION
                    FROM FRAME_HEADER
                   WHERE FRAME_NO = ASFRAMENO
                     AND MOD(   REVISION
                              * 100,
                              100 ) = 0
                     AND OWNER = ANOWNER;

                  
                  
                  LSINTL := '1';
                  LNINCLDEV := 0;
                  
                  LNOWNER := ANOWNER;
               ELSE
                  
                  
                  
                  RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                             LSMETHOD,
                                                             IAPICONSTANTDBERROR.DBERR_USERNOTOWNERINTLFRAME );
               END IF;
            END IF;

            
            IF ASINTLFROM = '0'
            THEN
               
               RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                          LSMETHOD,
                                                          IAPICONSTANTDBERROR.DBERR_LOCALFRAMECOPYBYINTLUSER );
            END IF;
         END IF;
      ELSE   
         
         IF ASINTL = '0'
         THEN
            
            BEGIN
               
               SELECT COUNT( * )
                 INTO LNCOUNTER
                 FROM FRAME_HEADER
                WHERE FRAME_NO = ASFRAMENO
                  AND INTL = '1';

               IF LNCOUNTER > 0
               THEN
                  RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                             LSMETHOD,
                                                             IAPICONSTANTDBERROR.DBERR_FRAMEINTLCANNOTCOPYONTO );
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  NULL;
            END;

            
            BEGIN
               
               SELECT   MAX( REVISION )
                      + 1
                 INTO LNREVISION
                 FROM FRAME_HEADER
                WHERE FRAME_NO = ASFRAMENO;

               IF LNREVISION IS NULL
               THEN
                  LNREVISION := 1;
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  LNREVISION := 1;
            END;

            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    'Revision : '
                                 || LNREVISION,
                                 IAPICONSTANT.INFOLEVEL_3 );
            
            
            
            LNOWNER := IAPIGENERAL.SESSION.DATABASE.OWNER;
            
            LSINTL := '0';
            LNINCLDEV := 1;
         END IF;

         
         IF ASINTL = '1'
         THEN
            
            IF ASINTLFROM = '0'
            THEN
               
               RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                          LSMETHOD,
                                                          IAPICONSTANTDBERROR.DBERR_LOCALFRAMECOPYBYINTLUSER );
            END IF;

            
            IF ASINTLFROM = '1'
            THEN
               
               LNOWNER := IAPIGENERAL.SESSION.DATABASE.OWNER;
               
               
               LSINTL := '1';
               LNINCLDEV := 0;

               
               SELECT   MAX( REVISION )
                      + 1
                 INTO LNREVISION
                 FROM FRAME_HEADER
                WHERE FRAME_NO = ASFRAMENO
                  AND MOD(   REVISION
                           * 100,
                           100 ) = 0
                  AND OWNER = LNOWNER;

               
               IF LNREVISION IS NULL
               THEN
                  LNREVISION := 1;
               END IF;
            END IF;
         END IF;
      END IF;

      
      BEGIN
         
         INSERT INTO FRAME_HEADER
                     ( FRAME_NO,
                       REVISION,
                       OWNER,
                       STATUS,
                       STATUS_CHANGE_DATE,
                       DESCRIPTION,
                       CREATED_BY,
                       CREATED_ON,
                       LAST_MODIFIED_BY,
                       LAST_MODIFIED_ON,
                       CLASS3_ID,
                       WORKFLOW_GROUP_ID,
                       ACCESS_GROUP,
                       INTL )
            SELECT ASFRAMENO,
                   LNREVISION,
                   LNOWNER,
                   1,
                   SYSDATE,
                   ASDESCRIPTION,
                   UPPER( USER ),
                   SYSDATE,
                   UPPER( USER ),
                   SYSDATE,
                   ANCLASS3ID,
                   ANWORKFLOWGROUPID,
                   ANACCESSGROUP,
                   LSINTL
              FROM FRAME_HEADER
             WHERE FRAME_NO = ASFRAMENOFROM
               AND REVISION = LNFRAMEREVISION
               AND OWNER = ANOWNER;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      
      BEGIN
         IF LNINCLDEV = 0
         THEN
            
            INSERT INTO FRAME_SECTION
                        ( FRAME_NO,
                          REVISION,
                          OWNER,
                          SECTION_ID,
                          SUB_SECTION_ID,
                          TYPE,
                          REF_ID,
                          SEQUENCE_NO,
                          HEADER,
                          MANDATORY,
                          SECTION_SEQUENCE_NO,
                          REF_VER,
                          REF_INFO,
                          REF_OWNER,
                          DISPLAY_FORMAT,
                          
                          DISPLAY_FORMAT_REV,                          
                          ASSOCIATION,
                          INTL,
                          SC_EXT,
                          REF_EXT )
               SELECT ASFRAMENO,
                      LNREVISION,
                      LNOWNER,
                      SECTION_ID,
                      SUB_SECTION_ID,
                      TYPE,
                      REF_ID,
                      SEQUENCE_NO,
                      HEADER,
                      MANDATORY,
                      SECTION_SEQUENCE_NO,
                      DECODE( TYPE,
                              IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY, 0,
                              DECODE( TYPE,
                                      IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP, 0,
                                      DECODE( TYPE,
                                              IAPICONSTANT.SECTIONTYPE_FREETEXT, 0,
                                              DECODE( TYPE,
                                                      IAPICONSTANT.SECTIONTYPE_REFERENCETEXT, F_GET_REFERENCETEXT_REV( REF_ID,
                                                                                                                       0,
                                                                                                                       OWNER ),
                                                      DECODE( TYPE,
                                                              IAPICONSTANT.SECTIONTYPE_OBJECT, F_GET_OBJ_REV( REF_ID,
                                                                                                              0,
                                                                                                              OWNER ),
                                                              REF_VER ) ) ) ) ),
                      REF_INFO,
                      REF_OWNER,
                      DISPLAY_FORMAT,
                      
                      DISPLAY_FORMAT_REV,                      
                      ASSOCIATION,
                      DECODE( LSINTL,
                              0, LSINTL,
                              INTL ),
                      SC_EXT,
                      REF_EXT
                 FROM FRAME_SECTION
                WHERE FRAME_NO = ASFRAMENOFROM
                  AND REVISION = LNFRAMEREVISION
                  AND OWNER = ANOWNER
                  AND INTL IN( LSINTL, '2' );
         ELSE
            
            INSERT INTO FRAME_SECTION
                        ( FRAME_NO,
                          REVISION,
                          OWNER,
                          SECTION_ID,
                          SUB_SECTION_ID,
                          TYPE,
                          REF_ID,
                          SEQUENCE_NO,
                          HEADER,
                          MANDATORY,
                          SECTION_SEQUENCE_NO,
                          REF_VER,
                          REF_INFO,
                          REF_OWNER,
                          DISPLAY_FORMAT,
                          
                          DISPLAY_FORMAT_REV,                                                    
                          ASSOCIATION,
                          INTL,
                          SC_EXT,
                          REF_EXT )
               SELECT ASFRAMENO,
                      LNREVISION,
                      LNOWNER,
                      SECTION_ID,
                      SUB_SECTION_ID,
                      TYPE,
                      REF_ID,
                      SEQUENCE_NO,
                      HEADER,
                      MANDATORY,
                      SECTION_SEQUENCE_NO,
                      DECODE( TYPE,
                              IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY, 0,
                              DECODE( TYPE,
                                      IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP, 0,
                                      DECODE( TYPE,
                                              IAPICONSTANT.SECTIONTYPE_FREETEXT, 0,
                                              DECODE( TYPE,
                                                      IAPICONSTANT.SECTIONTYPE_REFERENCETEXT, F_GET_REFERENCETEXT_REV( REF_ID,
                                                                                                                       0,
                                                                                                                       OWNER ),
                                                      DECODE( TYPE,
                                                              IAPICONSTANT.SECTIONTYPE_OBJECT, F_GET_OBJ_REV( REF_ID,
                                                                                                              0,
                                                                                                              OWNER ),
                                                              REF_VER ) ) ) ) ),
                      REF_INFO,
                      REF_OWNER,
                      DISPLAY_FORMAT,
                      
                      DISPLAY_FORMAT_REV,                                            
                      ASSOCIATION,
                      DECODE( MOD(   REVISION
                                   * 100,
                                   100 ),
                              0, DECODE( LSINTL,
                                         0, LSINTL,
                                         INTL ),
                              DECODE( ASFRAMENOFROM,
                                      ASFRAMENO, INTL,
                                      LSINTL ) ),
                      SC_EXT,
                      REF_EXT
                 FROM FRAME_SECTION
                WHERE FRAME_NO = ASFRAMENOFROM
                  AND REVISION = LNFRAMEREVISION
                  AND OWNER = ANOWNER;
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      
      BEGIN
         FOR LNFRAMENOTE IN LQFRAMENOTE
         LOOP
            SELECT COUNT( * )
              INTO LNCOUNTER
              FROM ITFRMNOTE
             WHERE FRAME_NO = ASFRAMENO
               AND OWNER = LNOWNER;

            IF LNCOUNTER = 0
            THEN
               INSERT INTO ITFRMNOTE
                           ( FRAME_NO,
                             OWNER )
                    VALUES ( ASFRAMENO,
                             LNOWNER );

               UPDATE ITFRMNOTE
                  SET TEXT = LNFRAMENOTE.TEXT
                WHERE FRAME_NO = ASFRAMENO
                  AND OWNER = LNOWNER;
            END IF;
         END LOOP;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      
      BEGIN
         
         INSERT INTO FRAME_KW
                     ( FRAME_NO,
                       OWNER,
                       KW_ID,
                       KW_VALUE,
                       INTL )
            SELECT ASFRAMENO,
                   LNOWNER,
                   KW_ID,
                   KW_VALUE,
                   DECODE( ASINTL,
                           '1', INTL,
                           '0' )
              FROM FRAME_KW S
             WHERE S.FRAME_NO = ASFRAMENOFROM
               AND S.OWNER = ANOWNER
               AND ( S.KW_ID, S.KW_VALUE ) NOT IN( SELECT T.KW_ID,
                                                          T.KW_VALUE
                                                    FROM FRAME_KW T
                                                   WHERE T.FRAME_NO = ASFRAMENO
                                                     AND T.OWNER = LNOWNER );
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

 
 
      BEGIN
         INSERT INTO FRAME_ICON
                     ( FRAME_NO,
                       REVISION,
                       OWNER,
                       ICON )
            SELECT ASFRAMENO,
                   LNFRAMEREVISION,
                   LNOWNER,
                   ICON
              FROM FRAME_ICON S
           WHERE FRAME_NO = ASFRAMENOFROM
             AND REVISION = ANREVISION
             AND OWNER = ANOWNER
             AND NOT EXISTS ( SELECT 1 FROM FRAME_ICON T
                                WHERE T.FRAME_NO = ASFRAMENO
                                  AND T.REVISION = LNFRAMEREVISION
                                  AND T.OWNER = LNOWNER );
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;


      
      BEGIN
         IF LNINCLDEV = 0
         THEN
            INSERT INTO FRAME_PROP
                        ( FRAME_NO,
                          REVISION,
                          OWNER,
                          SECTION_ID,
                          SUB_SECTION_ID,
                          PROPERTY_GROUP,
                          PROPERTY,
                          ATTRIBUTE,
                          MANDATORY,
                          ASSOCIATION,
                          UOM_ID,
                          TEST_METHOD,
                          SEQUENCE_NO,
                          CHARACTERISTIC,
                          INTL,
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
                          BOOLEAN_1,
                          BOOLEAN_2,
                          BOOLEAN_3,
                          BOOLEAN_4,
                          DATE_1,
                          DATE_2,
                          CH_2,
                          CH_3,
                          AS_2,
                          AS_3,
                          UOM_ALT_ID )
               SELECT ASFRAMENO,
                      LNREVISION,
                      LNOWNER,
                      SECTION_ID,
                      SUB_SECTION_ID,
                      PROPERTY_GROUP,
                      PROPERTY,
                      ATTRIBUTE,
                      MANDATORY,
                      ASSOCIATION,
                      UOM_ID,
                      TEST_METHOD,
                      SEQUENCE_NO,
                      CHARACTERISTIC,
                      DECODE( LSINTL,
                              0, LSINTL,
                              INTL ),
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
                      BOOLEAN_1,
                      BOOLEAN_2,
                      BOOLEAN_3,
                      BOOLEAN_4,
                      DATE_1,
                      DATE_2,
                      CH_2,
                      CH_3,
                      AS_2,
                      AS_3,
                      UOM_ALT_ID
                 FROM FRAME_PROP
                WHERE FRAME_NO = ASFRAMENOFROM
                  AND REVISION = LNFRAMEREVISION
                  AND OWNER = ANOWNER
                  AND INTL IN( LSINTL, '2' );
         ELSE
            INSERT INTO FRAME_PROP
                        ( FRAME_NO,
                          REVISION,
                          OWNER,
                          SECTION_ID,
                          SUB_SECTION_ID,
                          PROPERTY_GROUP,
                          PROPERTY,
                          ATTRIBUTE,
                          MANDATORY,
                          ASSOCIATION,
                          UOM_ID,
                          TEST_METHOD,
                          SEQUENCE_NO,
                          CHARACTERISTIC,
                          INTL,
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
                          BOOLEAN_1,
                          BOOLEAN_2,
                          BOOLEAN_3,
                          BOOLEAN_4,
                          DATE_1,
                          DATE_2,
                          CH_2,
                          CH_3,
                          AS_2,
                          AS_3,
                          UOM_ALT_ID )
               SELECT ASFRAMENO,
                      LNREVISION,
                      LNOWNER,
                      SECTION_ID,
                      SUB_SECTION_ID,
                      PROPERTY_GROUP,
                      PROPERTY,
                      ATTRIBUTE,
                      MANDATORY,
                      ASSOCIATION,
                      UOM_ID,
                      TEST_METHOD,
                      SEQUENCE_NO,
                      CHARACTERISTIC,
                      DECODE( MOD(   REVISION
                                   * 100,
                                   100 ),
                              0, DECODE( LSINTL,
                                         0, LSINTL,
                                         INTL ),
                              DECODE( ASFRAMENOFROM,
                                      ASFRAMENO, INTL,
                                      DECODE( LSINTL,
                                              0, LSINTL,
                                              INTL ) ) ),
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
                      BOOLEAN_1,
                      BOOLEAN_2,
                      BOOLEAN_3,
                      BOOLEAN_4,
                      DATE_1,
                      DATE_2,
                      CH_2,
                      CH_3,
                      AS_2,
                      AS_3,
                      UOM_ALT_ID
                 FROM FRAME_PROP
                WHERE FRAME_NO = ASFRAMENOFROM
                  AND REVISION = LNFRAMEREVISION
                  AND OWNER = ANOWNER;
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      
      BEGIN
         IF LNINCLDEV = 0
         THEN
            
            FOR LNFRAMETEXTREC IN LQINTLFRAMETEXT( LNFRAMEREVISION )
            LOOP
               INSERT INTO FRAME_TEXT
                           ( FRAME_NO,
                             REVISION,
                             OWNER,
                             SECTION_ID,
                             SUB_SECTION_ID,
                             TEXT_TYPE,
                             TEXT )
                    VALUES ( ASFRAMENO,
                             LNREVISION,
                             LNOWNER,
                             LNFRAMETEXTREC.SECTION_ID,
                             LNFRAMETEXTREC.SUB_SECTION_ID,
                             LNFRAMETEXTREC.TEXT_TYPE,
                             LNFRAMETEXTREC.TEXT );
            END LOOP;
         ELSE
            
            FOR LNFRAMETEXTREC IN LQFRAMETEXT( LNFRAMEREVISION )
            LOOP
               INSERT INTO FRAME_TEXT
                           ( FRAME_NO,
                             REVISION,
                             OWNER,
                             SECTION_ID,
                             SUB_SECTION_ID,
                             TEXT_TYPE,
                             TEXT )
                    VALUES ( ASFRAMENO,
                             LNREVISION,
                             LNOWNER,
                             LNFRAMETEXTREC.SECTION_ID,
                             LNFRAMETEXTREC.SUB_SECTION_ID,
                             LNFRAMETEXTREC.TEXT_TYPE,
                             LNFRAMETEXTREC.TEXT );
            END LOOP;
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      
      BEGIN
         LNRETVAL := COPYMASKS( ASFRAMENO,
                                LNREVISION,
                                LNOWNER,
                                ASFRAMENOFROM,
                                LNFRAMEREVISION,
                                ANOWNER );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      
      BEGIN
         LNRETVAL := COPYVALIDATION( ASFRAMENO,
                                     LNREVISION,
                                     LNOWNER,
                                     ASFRAMENOFROM,
                                     LNFRAMEREVISION,
                                     ANOWNER );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;
      
      
      
      INSERT INTO FRAMEINGLY
            (FRAME_NO,
             REVISION,
             OWNER,
             INGDETAIL_TYPE,
             SEQUENCE)
      SELECT ASFRAMENO,
                  LNREVISION,
                  LNOWNER,
                  INGDETAIL_TYPE,
                  SEQUENCE  
        FROM FRAMEINGLY
                WHERE FRAME_NO = ASFRAMENOFROM
                  AND REVISION = LNFRAMEREVISION
                  AND OWNER = ANOWNER;                     
      

      
      LNRETVAL := UPDATELAYOUT( ASFRAMENO,
                                LNREVISION,
                                LNOWNER );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF LNSYNCCHECK <> 0
      THEN
         LNRETVAL := SYNCHRONISEFRAME( ASFRAMENO,
                                       LNREVISION,
                                       ASFRAMENO,
                                       LNSYNCREVISION,
                                       LNOWNER );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END IF;

      
      BEGIN
         INSERT INTO FRAMEDATA_SERVER
                     ( FRAME_NO,
                       REVISION,
                       OWNER )
              VALUES ( ASFRAMENO,
                       LNREVISION,
                       LNOWNER );
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      
      BEGIN
         INSERT INTO FRAME_ICON
                     ( FRAME_NO,
                       REVISION,
                       OWNER )
              VALUES ( ASFRAMENO,
                       LNREVISION,
                       LNOWNER );
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END COPYFRAME;

   
   FUNCTION UPDATEFRAMEFROMSECTION(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'UpdateFrameFromSection';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;

      
      CURSOR LQLAYOUT
      IS
         SELECT *
           FROM FRAME_SECTION
          WHERE FRAME_NO = ASFRAMENO
            AND REVISION = ANREVISION
            AND OWNER = ANOWNER
            AND TYPE IN( IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP, IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY )
            AND ASSOCIATION = 1;

      LNLAYOUT                      IAPITYPE.NUMVAL_TYPE;
   BEGIN
         
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      BEGIN
         FOR LNLAYOUT IN LQLAYOUT
         LOOP
            LNRETVAL :=
               UPDATEDISPLAY( ASFRAMENO,
                              ANREVISION,
                              ANOWNER,
                              LNLAYOUT.DISPLAY_FORMAT,
                              LNLAYOUT.DISPLAY_FORMAT_REV,
                              LNLAYOUT.SECTION_ID,
                              LNLAYOUT.SUB_SECTION_ID,
                              LNLAYOUT.REF_ID,
                              LNLAYOUT.TYPE );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
               RETURN( LNRETVAL );
            END IF;

            UPDATE FRAME_SECTION
               SET ASSOCIATION = NULL
             WHERE FRAME_NO = ASFRAMENO
               AND REVISION = ANREVISION
               AND OWNER = ANOWNER
               AND SECTION_ID = LNLAYOUT.SECTION_ID
               AND SUB_SECTION_ID = LNLAYOUT.SUB_SECTION_ID
               AND REF_ID = LNLAYOUT.REF_ID
               AND TYPE = LNLAYOUT.TYPE
               AND SECTION_SEQUENCE_NO = LNLAYOUT.SECTION_SEQUENCE_NO;
         END LOOP;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      
      BEGIN
         INSERT INTO FRAME_PROP
                     ( FRAME_NO,
                       REVISION,
                       OWNER,
                       SECTION_ID,
                       SUB_SECTION_ID,
                       PROPERTY_GROUP,
                       PROPERTY,
                       ATTRIBUTE,
                       SEQUENCE_NO,
                       TEST_METHOD,
                       ASSOCIATION,
                       MANDATORY,
                       INTL )
            SELECT FS.FRAME_NO,
                   FS.REVISION,
                   FS.OWNER,
                   FS.SECTION_ID,
                   FS.SUB_SECTION_ID,
                   0,
                   100,
                   FS.REF_ID,
                   0,
                   F_GET_TEST_METHOD( FS.REF_ID ),
                   F_GET_ASSOCIATION( FS.REF_ID ),
                   'Y',
                   FS.INTL
              FROM FRAME_SECTION FS
             WHERE FS.FRAME_NO = ASFRAMENO
               AND FS.REVISION = ANREVISION
               AND FS.OWNER = ANOWNER
               AND FS.TYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY
               AND ( FS.SECTION_ID, FS.SUB_SECTION_ID, 0, FS.REF_ID ) NOT IN( SELECT SECTION_ID,
                                                                                     SUB_SECTION_ID,
                                                                                     PROPERTY_GROUP,
                                                                                     PROPERTY
                                                                               FROM FRAME_PROP
                                                                              WHERE FRAME_NO = ASFRAMENO
                                                                                AND REVISION = ANREVISION
                                                                                AND OWNER = ANOWNER );
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      
      BEGIN
         DELETE FROM FRAME_PROP
               WHERE FRAME_NO = ASFRAMENO
                 AND REVISION = ANREVISION
                 AND OWNER = ANOWNER
                 AND PROPERTY_GROUP > 0
                 AND ( SECTION_ID, SUB_SECTION_ID, PROPERTY_GROUP ) NOT IN(
                                                                 SELECT SECTION_ID,
                                                                        SUB_SECTION_ID,
                                                                        REF_ID
                                                                   FROM FRAME_SECTION
                                                                  WHERE FRAME_NO = ASFRAMENO
                                                                    AND REVISION = ANREVISION
                                                                    AND OWNER = ANOWNER
                                                                    AND TYPE = 1 );

         DELETE FROM ITFRMVPG
               WHERE FRAME_NO = ASFRAMENO
                 AND REVISION = ANREVISION
                 AND OWNER = ANOWNER
                 AND PROPERTY_GROUP > 0
                 AND ( SECTION_ID, SUB_SECTION_ID, PROPERTY_GROUP ) NOT IN(
                                                                 SELECT SECTION_ID,
                                                                        SUB_SECTION_ID,
                                                                        REF_ID
                                                                   FROM FRAME_SECTION
                                                                  WHERE FRAME_NO = ASFRAMENO
                                                                    AND REVISION = ANREVISION
                                                                    AND OWNER = ANOWNER
                                                                    AND TYPE = 1 );
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      
      BEGIN
         DELETE FROM FRAME_PROP
               WHERE FRAME_NO = ASFRAMENO
                 AND REVISION = ANREVISION
                 AND OWNER = ANOWNER
                 AND PROPERTY_GROUP = 0
                 AND ( SECTION_ID, SUB_SECTION_ID, PROPERTY ) NOT IN(
                           SELECT SECTION_ID,
                                  SUB_SECTION_ID,
                                  REF_ID
                             FROM FRAME_SECTION
                            WHERE FRAME_NO = ASFRAMENO
                              AND REVISION = ANREVISION
                              AND TYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY
                              AND OWNER = ANOWNER );

         DELETE FROM ITFRMVPG
               WHERE FRAME_NO = ASFRAMENO
                 AND REVISION = ANREVISION
                 AND OWNER = ANOWNER
                 AND PROPERTY_GROUP = 0
                 AND ( SECTION_ID, SUB_SECTION_ID, PROPERTY ) NOT IN(
                           SELECT SECTION_ID,
                                  SUB_SECTION_ID,
                                  REF_ID
                             FROM FRAME_SECTION
                            WHERE FRAME_NO = ASFRAMENO
                              AND REVISION = ANREVISION
                              AND TYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY
                              AND OWNER = ANOWNER );
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      
      BEGIN
         DELETE FROM FRAME_TEXT
               WHERE FRAME_NO = ASFRAMENO
                 AND REVISION = ANREVISION
                 AND OWNER = ANOWNER
                 AND ( SECTION_ID, SUB_SECTION_ID, TEXT_TYPE ) NOT IN(
                                 SELECT SECTION_ID,
                                        SUB_SECTION_ID,
                                        REF_ID
                                   FROM FRAME_SECTION
                                  WHERE FRAME_NO = ASFRAMENO
                                    AND REVISION = ANREVISION
                                    AND OWNER = ANOWNER
                                    AND TYPE = IAPICONSTANT.SECTIONTYPE_FREETEXT );
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      
      BEGIN
         INSERT INTO FRAME_TEXT
                     ( FRAME_NO,
                       REVISION,
                       OWNER,
                       SECTION_ID,
                       SUB_SECTION_ID,
                       TEXT_TYPE )
            SELECT FRAME_NO,
                   REVISION,
                   OWNER,
                   SECTION_ID,
                   SUB_SECTION_ID,
                   REF_ID
              FROM FRAME_SECTION
             WHERE FRAME_NO = ASFRAMENO
               AND REVISION = ANREVISION
               AND OWNER = ANOWNER
               AND TYPE = IAPICONSTANT.SECTIONTYPE_FREETEXT
               AND ( SECTION_ID, SUB_SECTION_ID, REF_ID ) NOT IN( SELECT SECTION_ID,
                                                                         SUB_SECTION_ID,
                                                                         TEXT_TYPE
                                                                   FROM FRAME_TEXT B
                                                                  WHERE B.FRAME_NO = ASFRAMENO
                                                                    AND B.REVISION = ANREVISION
                                                                    AND B.OWNER = ANOWNER );
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      
      LNRETVAL := UPDATELAYOUT( ASFRAMENO,
                                ANREVISION,
                                ANOWNER );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      BEGIN
         UPDATE FRAME_HEADER
            SET LAST_MODIFIED_ON = SYSDATE,
                LAST_MODIFIED_BY = USER
          WHERE FRAME_NO = ASFRAMENO
            AND REVISION = ANREVISION
            AND OWNER = ANOWNER;
      EXCEPTION
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
   END UPDATEFRAMEFROMSECTION;

   
   FUNCTION REMOVEFRAME(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ANCHECK                    IN       IAPITYPE.NUMVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LNCHECK                       IAPITYPE.NUMVAL_TYPE;
      LNSTATUS                      IAPITYPE.STATUSID_TYPE;
      LSUSERID                      IAPITYPE.USERID_TYPE;
      LSFORENAME                    IAPITYPE.FORENAME_TYPE;
      LSLASTNAME                    IAPITYPE.LASTNAME_TYPE;
      LSSCHEMANAME                  IAPITYPE.DATABASESCHEMANAME_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveFrame';
   BEGIN
         
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              ASFRAMENO
                           || '('
                           || ANREVISION
                           || ')',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT STATUS
        INTO LNSTATUS
        FROM FRAME_HEADER
       WHERE FRAME_NO = ASFRAMENO
         AND REVISION = ANREVISION
         AND OWNER = ANOWNER;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'status'
                           || LNSTATUS,
                           IAPICONSTANT.INFOLEVEL_3 );
      LSUSERID := USER;
      LNRETVAL := IAPIDATABASE.GETSCHEMANAME( LSSCHEMANAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      IF LSUSERID = LSSCHEMANAME
      THEN
         LSFORENAME := 'system';
         LSLASTNAME := 'user';
      ELSE
         BEGIN
            SELECT FORENAME,
                   LAST_NAME
              INTO LSFORENAME,
                   LSLASTNAME
              FROM APPLICATION_USER
             WHERE USER_ID = LSUSERID;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               LSFORENAME := 'user';
               LSLASTNAME := 'unknown';
         END;
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              LSFORENAME
                           || '  '
                           || LSLASTNAME,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      BEGIN
         DELETE FROM FRAME_SECTION
               WHERE FRAME_NO = ASFRAMENO
                 AND REVISION = ANREVISION
                 AND OWNER = ANOWNER;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      
      BEGIN
         DELETE FROM FRAME_PROP
               WHERE FRAME_NO = ASFRAMENO
                 AND REVISION = ANREVISION
                 AND OWNER = ANOWNER;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      
      BEGIN
         DELETE FROM FRAME_TEXT
               WHERE FRAME_NO = ASFRAMENO
                 AND REVISION = ANREVISION
                 AND OWNER = ANOWNER;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      
      BEGIN
         DELETE FROM FRAMEDATA_SERVER
               WHERE FRAME_NO = ASFRAMENO
                 AND REVISION = ANREVISION
                 AND OWNER = ANOWNER;

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
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      
      BEGIN
         DELETE FROM ITFRMV
               WHERE FRAME_NO = ASFRAMENO
                 AND REVISION = ANREVISION
                 AND OWNER = ANOWNER;

         DELETE FROM ITFRMVSC
               WHERE FRAME_NO = ASFRAMENO
                 AND REVISION = ANREVISION
                 AND OWNER = ANOWNER;

         DELETE FROM ITFRMVPG
               WHERE FRAME_NO = ASFRAMENO
                 AND REVISION = ANREVISION
                 AND OWNER = ANOWNER;

         DELETE FROM ITFRMVALD
               WHERE VAL_ID IN( SELECT VAL_ID
                                 FROM ITFRMVAL
                                WHERE FRAME_NO = ASFRAMENO
                                  AND REVISION = ANREVISION
                                  AND OWNER = ANOWNER );

         DELETE FROM ITFRMVAL
               WHERE FRAME_NO = ASFRAMENO
                 AND REVISION = ANREVISION
                 AND OWNER = ANOWNER;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      BEGIN
         
         SELECT COUNT( * )
           INTO LNCHECK
           FROM FRAME_HEADER
          WHERE FRAME_NO = ASFRAMENO
            AND OWNER = ANOWNER;

         IF LNCHECK = 0
         THEN
            DELETE FROM FRAME_KW
                  WHERE FRAME_NO = ASFRAMENO
                    AND OWNER = ANOWNER;

            DELETE FROM ITFRMNOTE
                  WHERE FRAME_NO = ASFRAMENO
                    AND OWNER = ANOWNER;
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;


      BEGIN
         
          DELETE FROM FRAME_ICON
                  WHERE FRAME_NO = ASFRAMENO
                    AND REVISION = ANREVISION
                    AND OWNER = ANOWNER
                    AND NOT EXISTS (SELECT 1 FROM FRAME_HEADER WHERE FRAME_NO = ASFRAMENO
                                                                 AND REVISION = ANREVISION
                                                                 AND OWNER = ANOWNER);
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;


     
      BEGIN         
            DELETE FROM FRAMEINGLY
               WHERE FRAME_NO = ASFRAMENO
                 AND REVISION = ANREVISION
                 AND OWNER = ANOWNER;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;
     
     
      
      BEGIN
         DELETE FROM FRAME_HEADER
               WHERE FRAME_NO = ASFRAMENO
                 AND REVISION = ANREVISION
                 AND OWNER = ANOWNER;

         INSERT INTO ITFRMDEL
              VALUES ( ASFRAMENO,
                       ANREVISION,
                       ANOWNER,
                       SYSDATE,
                       LNSTATUS,
                       LSUSERID,
                       LSFORENAME,
                       LSLASTNAME );
      EXCEPTION
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
   END REMOVEFRAME;

   
   FUNCTION SYNCHRONISEFRAME(
      ASSOURCEFRAMENO            IN       IAPITYPE.FRAMENO_TYPE,
      ANSOURCEREVISION           IN       IAPITYPE.FRAMEREVISION_TYPE,
      ASTARGETFRAMENO            IN       IAPITYPE.FRAMENO_TYPE,
      ANTARGETREVISION           IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SynchroniseFrame';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNREVISION                    IAPITYPE.FRAMEREVISION_TYPE;
      LSCREATEDBY                   IAPITYPE.USERID_TYPE;
      LNSEQUENCENO                  IAPITYPE.NUMVAL_TYPE;
      LNCHECK                       IAPITYPE.NUMVAL_TYPE;
      LNPREVSECTIONID               IAPITYPE.ID_TYPE := 0;
      LNPREVSUBSECTIONID            IAPITYPE.ID_TYPE := 0;
      LNPREVPROPERTYGROUP           IAPITYPE.FRAMEPROPERTYGROUP_TYPE := 0;
      LNPREVSINGLEPROPERTY          IAPITYPE.ID_TYPE := 0;
      LNPREVATTRIBUTE               IAPITYPE.ID_TYPE := 0;

      CURSOR LQFRAMESECTION(
         LNREVISION                          IAPITYPE.FRAMEREVISION_TYPE )
      IS
         SELECT DISTINCT *
                    FROM FRAME_SECTION
                   WHERE FRAME_NO = ASTARGETFRAMENO
                     AND REVISION = LNREVISION
                     AND OWNER = ANOWNER
                ORDER BY SECTION_SEQUENCE_NO;

      
      CURSOR LQFRAMEPROPERTYGROUP(
         LNREVISION                          IAPITYPE.FRAMEREVISION_TYPE )
      IS
         SELECT DISTINCT *
                    FROM FRAME_PROP
                   WHERE FRAME_NO = ASTARGETFRAMENO
                     AND REVISION = LNREVISION
                     AND OWNER = ANOWNER
                     AND PROPERTY_GROUP <> 0
                ORDER BY SECTION_ID,
                         SUB_SECTION_ID,
                         PROPERTY_GROUP,
                         SEQUENCE_NO;

      CURSOR LQFRAMESINGLEPROPERTY(
         LNREVISION                          IAPITYPE.FRAMEREVISION_TYPE )
      IS
         SELECT DISTINCT *
                    FROM FRAME_PROP
                   WHERE FRAME_NO = ASTARGETFRAMENO
                     AND REVISION = LNREVISION
                     AND OWNER = ANOWNER
                     AND PROPERTY_GROUP = 0
                ORDER BY SECTION_ID,
                         SUB_SECTION_ID,
                         SEQUENCE_NO;

      CURSOR LQFRAMETEXT(
         LNREVISION                          IAPITYPE.FRAMEREVISION_TYPE )
      IS
         SELECT SECTION_ID,
                SUB_SECTION_ID,
                REF_ID TEXT_TYPE
           FROM FRAME_SECTION
          WHERE FRAME_NO = ASTARGETFRAMENO
            AND REVISION = LNREVISION
            AND OWNER = ANOWNER
            AND TYPE = 5
         MINUS
         SELECT SECTION_ID,
                SUB_SECTION_ID,
                TEXT_TYPE
           FROM FRAME_TEXT
          WHERE FRAME_NO = ASTARGETFRAMENO
            AND REVISION = LNREVISION
            AND OWNER = ANOWNER;

      CURSOR LQFRAMEINSTEXT(
         LNREVISION                          IAPITYPE.FRAMEREVISION_TYPE,
         LSTEXTTYPE                          IAPITYPE.TEXTTYPE_TYPE,
         LNSECTIONID                         IAPITYPE.ID_TYPE,
         LNSUBSECTIONID                      IAPITYPE.ID_TYPE )
      IS
         SELECT *
           FROM FRAME_TEXT
          WHERE FRAME_NO = ASTARGETFRAMENO
            AND REVISION = LNREVISION
            AND OWNER = ANOWNER
            AND SECTION_ID = LNSECTIONID
            AND SUB_SECTION_ID = LNSUBSECTIONID
            AND TEXT_TYPE = LSTEXTTYPE;

      
      FUNCTION FINDSECTION(
         ANSECTIONID                         IAPITYPE.ID_TYPE,
         ANSUBSECTIONID                      IAPITYPE.ID_TYPE,
         ANREVISION                          IAPITYPE.FRAMEREVISION_TYPE )
         RETURN IAPITYPE.NUMVAL_TYPE
      IS
         LNSEQUENCENO                  IAPITYPE.NUMVAL_TYPE;
      BEGIN
         
         
         
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Body of FUNCTION',
                              IAPICONSTANT.INFOLEVEL_3 );
         LNSEQUENCENO := 0;

         SELECT MAX( SECTION_SEQUENCE_NO )
           INTO LNSEQUENCENO
           FROM FRAME_SECTION
          WHERE FRAME_NO = ASTARGETFRAMENO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND OWNER = ANOWNER;

         RETURN LNSEQUENCENO;
      END;

      
      FUNCTION FINDSECTIONREF(
         ANSECTIONID                         IAPITYPE.ID_TYPE,
         ANSUBSECTIONID                      IAPITYPE.ID_TYPE,
         ANREVISION                          IAPITYPE.FRAMEREVISION_TYPE,
         LNREFID                             IAPITYPE.ID_TYPE )
         RETURN IAPITYPE.NUMVAL_TYPE
      IS
         LNSEQUENCENO                  IAPITYPE.NUMVAL_TYPE;
      BEGIN
         
         
         
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Body of FUNCTION',
                              IAPICONSTANT.INFOLEVEL_3 );
         LNSEQUENCENO := 0;

         SELECT MAX( SECTION_SEQUENCE_NO )
           INTO LNSEQUENCENO
           FROM FRAME_SECTION
          WHERE FRAME_NO = ASTARGETFRAMENO
            AND REVISION = ANREVISION
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND REF_ID = LNREFID
            AND OWNER = ANOWNER;

         RETURN LNSEQUENCENO;
      END;

      
      FUNCTION FINDPROPERTYGROUP(
         ANSECTIONID                         IAPITYPE.ID_TYPE,
         ANSUBSECTIONID                      IAPITYPE.ID_TYPE,
         ANREVISION                          IAPITYPE.FRAMEREVISION_TYPE,
         ANPROPERTYGROUP                     IAPITYPE.FRAMEPROPERTYGROUP_TYPE,
         ANPROPERTY                          IAPITYPE.ID_TYPE )
         RETURN IAPITYPE.NUMVAL_TYPE
      IS
         LNSEQUENCENO                  IAPITYPE.NUMVAL_TYPE;
      BEGIN
         
         
         
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Body of FUNCTION',
                              IAPICONSTANT.INFOLEVEL_3 );
         LNSEQUENCENO := 0;

         SELECT MAX( SEQUENCE_NO )
           INTO LNSEQUENCENO
           FROM FRAME_PROP
          WHERE FRAME_NO = ASTARGETFRAMENO
            AND REVISION = ANREVISION
            AND OWNER = ANOWNER
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND PROPERTY_GROUP = ANPROPERTYGROUP
            AND PROPERTY = ANPROPERTY;

         RETURN LNSEQUENCENO;
      END;

      
      FUNCTION FINDPROPERTYGROUPREF(
         ANSECTIONID                         IAPITYPE.ID_TYPE,
         ANSUBSECTIONID                      IAPITYPE.ID_TYPE,
         ANREVISION                          IAPITYPE.FRAMEREVISION_TYPE,
         ANPROPERTYGROUP                     IAPITYPE.FRAMEPROPERTYGROUP_TYPE,
         ANPROPERTY                          IAPITYPE.ID_TYPE,
         A_ATTRIBUTE                         IAPITYPE.ID_TYPE )
         RETURN IAPITYPE.NUMVAL_TYPE
      IS
         LNSEQUENCENO                  IAPITYPE.NUMVAL_TYPE;
      BEGIN
         
         
         
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Body of FUNCTION',
                              IAPICONSTANT.INFOLEVEL_3 );
         LNSEQUENCENO := 0;

         SELECT MAX( SEQUENCE_NO )
           INTO LNSEQUENCENO
           FROM FRAME_PROP
          WHERE FRAME_NO = ASTARGETFRAMENO
            AND REVISION = ANREVISION
            AND OWNER = ANOWNER
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND PROPERTY_GROUP = ANPROPERTYGROUP
            AND PROPERTY = ANPROPERTY
            AND ATTRIBUTE = A_ATTRIBUTE;

         RETURN LNSEQUENCENO;
      END;

      
      FUNCTION FINDSINGLEPROPERTY(
         ANSECTIONID                         IAPITYPE.ID_TYPE,
         ANSUBSECTIONID                      IAPITYPE.ID_TYPE,
         ANREVISION                          IAPITYPE.FRAMEREVISION_TYPE,
         ANPROPERTY                          IAPITYPE.ID_TYPE )
         RETURN IAPITYPE.NUMVAL_TYPE
      IS
         LNSEQUENCENO                  IAPITYPE.NUMVAL_TYPE;
      BEGIN
         
         
         
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Body of FUNCTION',
                              IAPICONSTANT.INFOLEVEL_3 );
         LNSEQUENCENO := 0;

         SELECT MAX( SEQUENCE_NO )
           INTO LNSEQUENCENO
           FROM FRAME_PROP
          WHERE FRAME_NO = ASTARGETFRAMENO
            AND REVISION = ANREVISION
            AND OWNER = ANOWNER
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND PROPERTY_GROUP = 0
            AND PROPERTY = ANPROPERTY;

         RETURN LNSEQUENCENO;
      END;
   
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ASSOURCEFRAMENO <> ASTARGETFRAMENO
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_FRAMESYNCDIFFERENTID );
      END IF;

      
      SELECT LAST_MODIFIED_BY
        INTO LSCREATEDBY
        FROM FRAME_HEADER
       WHERE FRAME_NO = ASTARGETFRAMENO
         AND REVISION = ANTARGETREVISION
         AND OWNER = ANOWNER;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              ASTARGETFRAMENO
                           || '  '
                           || LSCREATEDBY,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      SELECT MAX( REVISION )
        INTO LNREVISION
        FROM FRAME_HEADER
       WHERE FRAME_NO = ASSOURCEFRAMENO
         AND OWNER = ANOWNER;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              ASSOURCEFRAMENO
                           || '  new revision '
                           || LNREVISION,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      FOR LNRECSECTION IN LQFRAMESECTION( ANTARGETREVISION )
      LOOP
         IF LNRECSECTION.INTL = '0'
         THEN
            LNSEQUENCENO := FINDSECTION( LNRECSECTION.SECTION_ID,
                                         LNRECSECTION.SUB_SECTION_ID,
                                         LNREVISION );

            IF    LNSEQUENCENO = 0
               OR LNSEQUENCENO IS NULL
            THEN
               
               LNSEQUENCENO := FINDSECTION( LNPREVSECTIONID,
                                            LNPREVSUBSECTIONID,
                                            LNREVISION );

               IF    LNSEQUENCENO = 0
                  OR LNSEQUENCENO IS NULL
               THEN
                  
                  LNSEQUENCENO :=   LNRECSECTION.SECTION_SEQUENCE_NO
                                  + 10000;
               ELSE
                  LNSEQUENCENO :=   LNSEQUENCENO
                                  + 1;
               END IF;
            ELSE
               LNSEQUENCENO :=   LNSEQUENCENO
                               + 1;
            END IF;

            
            LNCHECK := FINDSECTIONREF( LNRECSECTION.SECTION_ID,
                                       LNRECSECTION.SUB_SECTION_ID,
                                       LNREVISION,
                                       LNRECSECTION.REF_ID );

            IF    LNCHECK = 0
               OR LNCHECK IS NULL
            THEN
               BEGIN
                  INSERT INTO FRAME_SECTION
                              ( FRAME_NO,
                                REVISION,
                                OWNER,
                                SECTION_ID,
                                SUB_SECTION_ID,
                                TYPE,
                                REF_ID,
                                SEQUENCE_NO,
                                HEADER,
                                MANDATORY,
                                SECTION_SEQUENCE_NO,
                                REF_VER,
                                REF_INFO,
                                REF_OWNER,
                                DISPLAY_FORMAT,
                                ASSOCIATION,
                                INTL,
                                SC_EXT,
                                REF_EXT )
                       VALUES ( ASSOURCEFRAMENO,
                                LNREVISION,
                                LNRECSECTION.OWNER,
                                LNRECSECTION.SECTION_ID,
                                LNRECSECTION.SUB_SECTION_ID,
                                LNRECSECTION.TYPE,
                                LNRECSECTION.REF_ID,
                                  LNRECSECTION.SEQUENCE_NO
                                + 10,
                                LNRECSECTION.HEADER,
                                LNRECSECTION.MANDATORY,
                                LNSEQUENCENO,
                                DECODE( LNRECSECTION.TYPE,
                                        4, 0,
                                        DECODE( LNRECSECTION.TYPE,
                                                1, 0,
                                                LNRECSECTION.REF_VER ) ),
                                LNRECSECTION.REF_INFO,
                                LNRECSECTION.REF_OWNER,
                                LNRECSECTION.DISPLAY_FORMAT,
                                LNRECSECTION.ASSOCIATION,
                                LNRECSECTION.INTL,
                                LNRECSECTION.SC_EXT,
                                LNRECSECTION.REF_EXT );
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     IAPIGENERAL.LOGERROR( GSSOURCE,
                                           LSMETHOD,
                                           SQLERRM );
                     RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
               END;
            ELSE
               NULL;
            END IF;
         END IF;

         LNPREVSECTIONID := LNRECSECTION.SECTION_ID;
         LNPREVSUBSECTIONID := LNRECSECTION.SUB_SECTION_ID;
      END LOOP;

      LNSEQUENCENO := 0;

      FOR LNRECSECTION IN LQFRAMESECTION( LNREVISION )
      LOOP
         LNSEQUENCENO :=   LNSEQUENCENO
                         + 100;

         BEGIN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    LNRECSECTION.SECTION_SEQUENCE_NO
                                 || '   '
                                 || LNSEQUENCENO,
                                 IAPICONSTANT.INFOLEVEL_3 );

            UPDATE FRAME_SECTION
               SET SECTION_SEQUENCE_NO = LNSEQUENCENO
             WHERE FRAME_NO = LNRECSECTION.FRAME_NO
               AND REVISION = LNRECSECTION.REVISION
               AND OWNER = LNRECSECTION.OWNER
               AND SECTION_ID = LNRECSECTION.SECTION_ID
               AND SUB_SECTION_ID = LNRECSECTION.SUB_SECTION_ID
               AND TYPE = LNRECSECTION.TYPE
               AND REF_ID = LNRECSECTION.REF_ID
               AND SECTION_SEQUENCE_NO = LNRECSECTION.SECTION_SEQUENCE_NO;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      END LOOP;

      
      FOR LNRECPROPERTYGROUP IN LQFRAMEPROPERTYGROUP( ANTARGETREVISION )
      LOOP
         IF LNRECPROPERTYGROUP.INTL = '0'
         THEN
            LNSEQUENCENO :=
               FINDPROPERTYGROUP( LNRECPROPERTYGROUP.SECTION_ID,
                                  LNRECPROPERTYGROUP.SUB_SECTION_ID,
                                  LNREVISION,
                                  LNRECPROPERTYGROUP.PROPERTY_GROUP,
                                  LNRECPROPERTYGROUP.PROPERTY );

            IF    LNSEQUENCENO = 0
               OR LNSEQUENCENO IS NULL
            THEN
               
               LNSEQUENCENO :=
                        FINDPROPERTYGROUP( LNPREVSECTIONID,
                                           LNPREVSUBSECTIONID,
                                           LNREVISION,
                                           LNRECPROPERTYGROUP.PROPERTY_GROUP,
                                           LNPREVSINGLEPROPERTY );

               IF    LNSEQUENCENO = 0
                  OR LNSEQUENCENO IS NULL
               THEN
                  
                  LNSEQUENCENO :=   LNRECPROPERTYGROUP.SEQUENCE_NO
                                  + 10000;
               ELSE
                  LNSEQUENCENO :=   LNSEQUENCENO
                                  + 1;
               END IF;
            ELSE
               LNSEQUENCENO :=   LNSEQUENCENO
                               + 1;
            END IF;

            LNCHECK :=
               FINDPROPERTYGROUPREF( LNRECPROPERTYGROUP.SECTION_ID,
                                     LNRECPROPERTYGROUP.SUB_SECTION_ID,
                                     LNREVISION,
                                     LNRECPROPERTYGROUP.PROPERTY_GROUP,
                                     LNRECPROPERTYGROUP.PROPERTY,
                                     LNRECPROPERTYGROUP.ATTRIBUTE );

            IF    LNCHECK = 0
               OR LNCHECK IS NULL
            THEN
               BEGIN
                  INSERT INTO FRAME_PROP
                              ( FRAME_NO,
                                REVISION,
                                OWNER,
                                SECTION_ID,
                                SUB_SECTION_ID,
                                PROPERTY_GROUP,
                                PROPERTY,
                                ATTRIBUTE,
                                MANDATORY,
                                ASSOCIATION,
                                UOM_ID,
                                TEST_METHOD,
                                SEQUENCE_NO,
                                CHARACTERISTIC,
                                INTL,
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
                                BOOLEAN_1,
                                BOOLEAN_2,
                                BOOLEAN_3,
                                BOOLEAN_4,
                                DATE_1,
                                DATE_2,
                                CH_2,
                                CH_3,
                                AS_2,
                                AS_3 )
                       VALUES ( ASSOURCEFRAMENO,
                                LNREVISION,
                                LNRECPROPERTYGROUP.OWNER,
                                LNRECPROPERTYGROUP.SECTION_ID,
                                LNRECPROPERTYGROUP.SUB_SECTION_ID,
                                LNRECPROPERTYGROUP.PROPERTY_GROUP,
                                LNRECPROPERTYGROUP.PROPERTY,
                                LNRECPROPERTYGROUP.ATTRIBUTE,
                                LNRECPROPERTYGROUP.MANDATORY,
                                LNRECPROPERTYGROUP.ASSOCIATION,
                                LNRECPROPERTYGROUP.UOM_ID,
                                LNRECPROPERTYGROUP.TEST_METHOD,
                                LNSEQUENCENO,
                                LNRECPROPERTYGROUP.CHARACTERISTIC,
                                LNRECPROPERTYGROUP.INTL,
                                LNRECPROPERTYGROUP.NUM_1,
                                LNRECPROPERTYGROUP.NUM_2,
                                LNRECPROPERTYGROUP.NUM_3,
                                LNRECPROPERTYGROUP.NUM_4,
                                LNRECPROPERTYGROUP.NUM_5,
                                LNRECPROPERTYGROUP.NUM_6,
                                LNRECPROPERTYGROUP.NUM_7,
                                LNRECPROPERTYGROUP.NUM_8,
                                LNRECPROPERTYGROUP.NUM_9,
                                LNRECPROPERTYGROUP.NUM_10,
                                LNRECPROPERTYGROUP.CHAR_1,
                                LNRECPROPERTYGROUP.CHAR_2,
                                LNRECPROPERTYGROUP.CHAR_3,
                                LNRECPROPERTYGROUP.CHAR_4,
                                LNRECPROPERTYGROUP.CHAR_5,
                                LNRECPROPERTYGROUP.CHAR_6,
                                LNRECPROPERTYGROUP.BOOLEAN_1,
                                LNRECPROPERTYGROUP.BOOLEAN_2,
                                LNRECPROPERTYGROUP.BOOLEAN_3,
                                LNRECPROPERTYGROUP.BOOLEAN_4,
                                LNRECPROPERTYGROUP.DATE_1,
                                LNRECPROPERTYGROUP.DATE_2,
                                LNRECPROPERTYGROUP.CH_2,
                                LNRECPROPERTYGROUP.CH_3,
                                LNRECPROPERTYGROUP.AS_2,
                                LNRECPROPERTYGROUP.AS_3 );
               EXCEPTION
                  WHEN DUP_VAL_ON_INDEX
                  THEN
                     NULL;
                  WHEN OTHERS
                  THEN
                     IAPIGENERAL.LOGERROR( GSSOURCE,
                                           LSMETHOD,
                                           SQLERRM );
                     RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
               END;
            END IF;
         END IF;

         LNPREVSECTIONID := LNRECPROPERTYGROUP.SECTION_ID;
         LNPREVSUBSECTIONID := LNRECPROPERTYGROUP.SUB_SECTION_ID;
         LNPREVSINGLEPROPERTY := LNRECPROPERTYGROUP.PROPERTY;
      END LOOP;

      LNSEQUENCENO := 0;
      LNPREVSECTIONID := 0;
      LNPREVSUBSECTIONID := 0;
      LNPREVPROPERTYGROUP := 0;

      FOR LNRECPROPERTYGROUP IN LQFRAMEPROPERTYGROUP( LNREVISION )
      LOOP
         IF    LNRECPROPERTYGROUP.SECTION_ID <> LNPREVSECTIONID
            OR LNRECPROPERTYGROUP.SUB_SECTION_ID <> LNPREVSUBSECTIONID
            OR LNRECPROPERTYGROUP.PROPERTY_GROUP <> LNPREVPROPERTYGROUP
         THEN
            LNSEQUENCENO := 0;
         END IF;

         LNSEQUENCENO :=   LNSEQUENCENO
                         + 100;

         UPDATE FRAME_PROP
            SET SEQUENCE_NO = LNSEQUENCENO
          WHERE FRAME_NO = LNRECPROPERTYGROUP.FRAME_NO
            AND REVISION = LNRECPROPERTYGROUP.REVISION
            AND OWNER = LNRECPROPERTYGROUP.OWNER
            AND SECTION_ID = LNRECPROPERTYGROUP.SECTION_ID
            AND SUB_SECTION_ID = LNRECPROPERTYGROUP.SUB_SECTION_ID
            AND PROPERTY_GROUP = LNRECPROPERTYGROUP.PROPERTY_GROUP
            AND PROPERTY = LNRECPROPERTYGROUP.PROPERTY;

         LNPREVSECTIONID := LNRECPROPERTYGROUP.SECTION_ID;
         LNPREVSUBSECTIONID := LNRECPROPERTYGROUP.SUB_SECTION_ID;
         LNPREVPROPERTYGROUP := LNRECPROPERTYGROUP.PROPERTY_GROUP;
      END LOOP;

      
      FOR LNRECSINGLEPROPERTY IN LQFRAMESINGLEPROPERTY( ANTARGETREVISION )
      LOOP
         IF LNRECSINGLEPROPERTY.INTL = '0'
         THEN
            LNSEQUENCENO :=
                   FINDSINGLEPROPERTY( LNRECSINGLEPROPERTY.SECTION_ID,
                                       LNRECSINGLEPROPERTY.SUB_SECTION_ID,
                                       LNREVISION,
                                       LNRECSINGLEPROPERTY.PROPERTY );

            IF    LNSEQUENCENO = 0
               OR LNSEQUENCENO IS NULL
            THEN
               
               LNSEQUENCENO := FINDSINGLEPROPERTY( LNPREVSECTIONID,
                                                   LNPREVSUBSECTIONID,
                                                   LNREVISION,
                                                   LNPREVSINGLEPROPERTY );

               IF    LNSEQUENCENO = 0
                  OR LNSEQUENCENO IS NULL
               THEN
                  
                  LNSEQUENCENO :=   LNRECSINGLEPROPERTY.SEQUENCE_NO
                                  + 10000;
               ELSE
                  LNSEQUENCENO :=   LNSEQUENCENO
                                  + 1;
               END IF;
            ELSE
               LNSEQUENCENO :=   LNSEQUENCENO
                               + 1;
            END IF;

            BEGIN
               INSERT INTO FRAME_PROP
                           ( FRAME_NO,
                             REVISION,
                             OWNER,
                             SECTION_ID,
                             SUB_SECTION_ID,
                             PROPERTY_GROUP,
                             PROPERTY,
                             ATTRIBUTE,
                             MANDATORY,
                             ASSOCIATION,
                             UOM_ID,
                             TEST_METHOD,
                             SEQUENCE_NO,
                             CHARACTERISTIC,
                             INTL,
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
                             BOOLEAN_1,
                             BOOLEAN_2,
                             BOOLEAN_3,
                             BOOLEAN_4,
                             DATE_1,
                             DATE_2,
                             CH_2,
                             CH_3,
                             AS_2,
                             AS_3 )
                    VALUES ( ASSOURCEFRAMENO,
                             LNREVISION,
                             LNRECSINGLEPROPERTY.OWNER,
                             LNRECSINGLEPROPERTY.SECTION_ID,
                             LNRECSINGLEPROPERTY.SUB_SECTION_ID,
                             LNRECSINGLEPROPERTY.PROPERTY_GROUP,
                             LNRECSINGLEPROPERTY.PROPERTY,
                             LNRECSINGLEPROPERTY.ATTRIBUTE,
                             LNRECSINGLEPROPERTY.MANDATORY,
                             LNRECSINGLEPROPERTY.ASSOCIATION,
                             LNRECSINGLEPROPERTY.UOM_ID,
                             LNRECSINGLEPROPERTY.TEST_METHOD,
                             LNSEQUENCENO,
                             LNRECSINGLEPROPERTY.CHARACTERISTIC,
                             LNRECSINGLEPROPERTY.INTL,
                             LNRECSINGLEPROPERTY.NUM_1,
                             LNRECSINGLEPROPERTY.NUM_2,
                             LNRECSINGLEPROPERTY.NUM_3,
                             LNRECSINGLEPROPERTY.NUM_4,
                             LNRECSINGLEPROPERTY.NUM_5,
                             LNRECSINGLEPROPERTY.NUM_6,
                             LNRECSINGLEPROPERTY.NUM_7,
                             LNRECSINGLEPROPERTY.NUM_8,
                             LNRECSINGLEPROPERTY.NUM_9,
                             LNRECSINGLEPROPERTY.NUM_10,
                             LNRECSINGLEPROPERTY.CHAR_1,
                             LNRECSINGLEPROPERTY.CHAR_2,
                             LNRECSINGLEPROPERTY.CHAR_3,
                             LNRECSINGLEPROPERTY.CHAR_4,
                             LNRECSINGLEPROPERTY.CHAR_5,
                             LNRECSINGLEPROPERTY.CHAR_6,
                             LNRECSINGLEPROPERTY.BOOLEAN_1,
                             LNRECSINGLEPROPERTY.BOOLEAN_2,
                             LNRECSINGLEPROPERTY.BOOLEAN_3,
                             LNRECSINGLEPROPERTY.BOOLEAN_4,
                             LNRECSINGLEPROPERTY.DATE_1,
                             LNRECSINGLEPROPERTY.DATE_2,
                             LNRECSINGLEPROPERTY.CH_2,
                             LNRECSINGLEPROPERTY.CH_3,
                             LNRECSINGLEPROPERTY.AS_2,
                             LNRECSINGLEPROPERTY.AS_3 );
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX
               THEN
                  NULL;
               WHEN OTHERS
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        SQLERRM );
                  RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
            END;
         END IF;

         LNPREVSECTIONID := LNRECSINGLEPROPERTY.SECTION_ID;
         LNPREVSUBSECTIONID := LNRECSINGLEPROPERTY.SUB_SECTION_ID;
         LNPREVSINGLEPROPERTY := LNRECSINGLEPROPERTY.PROPERTY;
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 LNPREVSECTIONID
                              || ' (2) lnRecSingleProperty.section_id '
                              || LNRECSINGLEPROPERTY.SECTION_ID,
                              IAPICONSTANT.INFOLEVEL_3 );
      END LOOP;

      LNSEQUENCENO := 0;
      LNPREVSECTIONID := 0;
      LNPREVSUBSECTIONID := 0;
      LNPREVPROPERTYGROUP := 0;
      LNPREVSINGLEPROPERTY := 0;

      FOR LNRECSINGLEPROPERTY IN LQFRAMESINGLEPROPERTY( LNREVISION )
      LOOP
         IF    LNRECSINGLEPROPERTY.SECTION_ID <> LNPREVSECTIONID
            OR LNRECSINGLEPROPERTY.SUB_SECTION_ID <> LNPREVSUBSECTIONID
            OR LNRECSINGLEPROPERTY.PROPERTY_GROUP <> LNPREVPROPERTYGROUP
            OR LNRECSINGLEPROPERTY.PROPERTY <> LNPREVSINGLEPROPERTY
            OR LNRECSINGLEPROPERTY.ATTRIBUTE <> LNPREVATTRIBUTE
         THEN
            LNSEQUENCENO := 0;
         END IF;

         LNSEQUENCENO :=   LNSEQUENCENO
                         + 100;

         UPDATE FRAME_PROP
            SET SEQUENCE_NO = LNSEQUENCENO
          WHERE FRAME_NO = LNRECSINGLEPROPERTY.FRAME_NO
            AND REVISION = LNRECSINGLEPROPERTY.REVISION
            AND OWNER = LNRECSINGLEPROPERTY.OWNER
            AND SECTION_ID = LNRECSINGLEPROPERTY.SECTION_ID
            AND SUB_SECTION_ID = LNRECSINGLEPROPERTY.SUB_SECTION_ID
            AND PROPERTY_GROUP = LNRECSINGLEPROPERTY.PROPERTY_GROUP
            AND PROPERTY = LNRECSINGLEPROPERTY.PROPERTY
            AND ATTRIBUTE = LNRECSINGLEPROPERTY.ATTRIBUTE;

         LNPREVSECTIONID := LNRECSINGLEPROPERTY.SECTION_ID;
         LNPREVSUBSECTIONID := LNRECSINGLEPROPERTY.SUB_SECTION_ID;
         LNPREVPROPERTYGROUP := LNRECSINGLEPROPERTY.PROPERTY_GROUP;
         LNPREVSINGLEPROPERTY := LNRECSINGLEPROPERTY.PROPERTY;
         LNPREVATTRIBUTE := LNRECSINGLEPROPERTY.ATTRIBUTE;
      END LOOP;

      FOR LNRECTEXT IN LQFRAMETEXT( LNREVISION )
      LOOP
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'text :'
                              || LNRECTEXT.TEXT_TYPE,
                              IAPICONSTANT.INFOLEVEL_3 );

         BEGIN
            FOR REC_INS_TEXT IN LQFRAMEINSTEXT( ANTARGETREVISION,
                                                LNRECTEXT.TEXT_TYPE,
                                                LNRECTEXT.SECTION_ID,
                                                LNRECTEXT.SUB_SECTION_ID )
            LOOP
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                       'ins text :'
                                    || REC_INS_TEXT.SECTION_ID
                                    || ' data : '
                                    || REC_INS_TEXT.TEXT,
                                    IAPICONSTANT.INFOLEVEL_3 );

               INSERT INTO FRAME_TEXT
                           ( FRAME_NO,
                             REVISION,
                             OWNER,
                             SECTION_ID,
                             SUB_SECTION_ID,
                             TEXT_TYPE,
                             TEXT )
                    VALUES ( ASSOURCEFRAMENO,
                             LNREVISION,
                             REC_INS_TEXT.OWNER,
                             REC_INS_TEXT.SECTION_ID,
                             REC_INS_TEXT.SUB_SECTION_ID,
                             REC_INS_TEXT.TEXT_TYPE,
                             REC_INS_TEXT.TEXT );
            END LOOP;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      END LOOP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SYNCHRONISEFRAME;


   FUNCTION CREATEFILTER(
      ANFILTERID                 IN OUT   IAPITYPE.FILTERID_TYPE,
      ANARRAY                    IN       IAPITYPE.NUMVAL_TYPE,
      ASCOLUMN                   IN       IAPITYPE.STRING_TYPE,
      ASOPERATOR                 IN       IAPITYPE.STRING_TYPE,
      ASVALCHAR                  IN       IAPITYPE.STRING_TYPE,
      ASVALDATE                  IN       IAPITYPE.STRING_TYPE,
      ASSORTDESC                 IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASCOMMENT                  IN       IAPITYPE.FILTERDESCRIPTION_TYPE,
      ABOVERWRITE                IN       IAPITYPE.BOOLEAN_TYPE,
      ANOPTIONS                  IN       IAPITYPE.NUMVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      

      
      
      
      

      
      
      
      

      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CreateFilter (2)';
      LNCURSOR                      IAPITYPE.NUMVAL_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LXCOLUMN                      SYS.XMLTYPE;
      LXOPERATOR                    SYS.XMLTYPE;
      LXVALUECHAR                   SYS.XMLTYPE;
      LXVALUEDATE                   SYS.XMLTYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LXCOLUMN := XMLTYPE.CREATEXML( ASCOLUMN );
      LXOPERATOR := XMLTYPE.CREATEXML( ASOPERATOR );
      LXVALUECHAR := XMLTYPE.CREATEXML( ASVALCHAR );
      LXVALUEDATE := XMLTYPE.CREATEXML( ASVALDATE );
      LNRETVAL := CREATEFILTER( ANFILTERID,
                                ANARRAY,
                                LXCOLUMN,
                                LXOPERATOR,
                                LXVALUECHAR,
                                LXVALUEDATE,
                                ASSORTDESC,
                                ASCOMMENT,
                                ABOVERWRITE,
                                ANOPTIONS );

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
   END CREATEFILTER;


   FUNCTION CREATEFILTER(
      ANFILTERID                 IN OUT   IAPITYPE.FILTERID_TYPE,
      ANARRAY                    IN       IAPITYPE.NUMVAL_TYPE,
      AXCOLUMN                   IN       IAPITYPE.XMLTYPE_TYPE,
      AXOPERATOR                 IN       IAPITYPE.XMLTYPE_TYPE,
      AXVALCHAR                  IN       IAPITYPE.XMLTYPE_TYPE,
      AXVALDATE                  IN       IAPITYPE.XMLTYPE_TYPE,
      ASSORTDESC                 IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASCOMMENT                  IN       IAPITYPE.FILTERDESCRIPTION_TYPE,
      ABOVERWRITE                IN       IAPITYPE.BOOLEAN_TYPE,
      ANOPTIONS                  IN       IAPITYPE.NUMVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      

      
      
      
      

      
      
      
      

      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CreateFilter (1)';
      LNCURSOR                      IAPITYPE.NUMVAL_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LXPATHLISTCOLUMN              IAPITYPE.STRING_TYPE := '/columns/columnname';
      LXPATHLISTOPERATOR            IAPITYPE.STRING_TYPE := '/operators/operator';
      LXPATHLISTVALUECHAR           IAPITYPE.STRING_TYPE := '/valuechar/stopword';
      LXPATHLISTVALUEDATE           IAPITYPE.STRING_TYPE := '/valuedate/stopword';
      LTCOLUMN                      IAPITYPE.CHARTAB_TYPE;
      LTOPERATOR                    IAPITYPE.CHARTAB_TYPE;
      LTVALUECHAR                   IAPITYPE.CHARTAB_TYPE;
      LTVALUEDATE                   IAPITYPE.DATETAB_TYPE;
      LSVALUEDATE                   IAPITYPE.STRING_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      
      SELECT COUNT( * )
        INTO LNCURSOR
        FROM ( SELECT VALUE( T ) REPORT
                FROM TABLE( XMLSEQUENCE( EXTRACT( AXCOLUMN,
                                                  LXPATHLISTCOLUMN ) ) ) T ) R;

      FOR INDX IN 1 .. LNCURSOR
      LOOP
         SELECT EXTRACTVALUE( R.REPORT,
                                 LOWER( LXPATHLISTCOLUMN )
                              || '['
                              || INDX
                              || ']' )
           INTO LTCOLUMN( INDX )
           FROM ( SELECT VALUE( T ) REPORT
                   FROM TABLE( XMLSEQUENCE( EXTRACT( AXCOLUMN,
                                                     '/' ) ) ) T ) R;
      END LOOP;

      
      
      
      SELECT COUNT( * )
        INTO LNCURSOR
        FROM ( SELECT VALUE( T ) REPORT
                FROM TABLE( XMLSEQUENCE( EXTRACT( AXOPERATOR,
                                                  LXPATHLISTOPERATOR ) ) ) T ) R;

      FOR INDX IN 1 .. LNCURSOR
      LOOP
         SELECT EXTRACTVALUE( R.REPORT,
                                 LOWER( LXPATHLISTOPERATOR )
                              || '['
                              || INDX
                              || ']' )
           INTO LTOPERATOR( INDX )
           FROM ( SELECT VALUE( T ) REPORT
                   FROM TABLE( XMLSEQUENCE( EXTRACT( AXOPERATOR,
                                                     '/' ) ) ) T ) R;
      END LOOP;

      
      
      
      SELECT COUNT( * )
        INTO LNCURSOR
        FROM ( SELECT VALUE( T ) REPORT
                FROM TABLE( XMLSEQUENCE( EXTRACT( AXVALCHAR,
                                                  LXPATHLISTVALUECHAR ) ) ) T ) R;

      FOR INDX IN 1 .. LNCURSOR
      LOOP
         SELECT EXTRACTVALUE( R.REPORT,
                                 LOWER( LXPATHLISTVALUECHAR )
                              || '['
                              || INDX
                              || ']' )
           INTO LTVALUECHAR( INDX )
           FROM ( SELECT VALUE( T ) REPORT
                   FROM TABLE( XMLSEQUENCE( EXTRACT( AXVALCHAR,
                                                     '/' ) ) ) T ) R;
      END LOOP;

      
      
      
      SELECT COUNT( * )
        INTO LNCURSOR
        FROM ( SELECT VALUE( T ) REPORT
                FROM TABLE( XMLSEQUENCE( EXTRACT( AXVALDATE,
                                                  LXPATHLISTVALUEDATE ) ) ) T ) R;

      FOR INDX IN 1 .. LNCURSOR
      LOOP
         SELECT EXTRACTVALUE( R.REPORT,
                                 LOWER( LXPATHLISTVALUEDATE )
                              || '['
                              || INDX
                              || ']' )
           INTO LSVALUEDATE
           FROM ( SELECT VALUE( T ) REPORT
                   FROM TABLE( XMLSEQUENCE( EXTRACT( AXVALDATE,
                                                     '/' ) ) ) T ) R;

         LTVALUEDATE( INDX ) := TO_DATE( LSVALUEDATE,
                                         'YYYYMMDD' );
      END LOOP;

      LNRETVAL := CREATEFILTER( ANFILTERID,
                                ANARRAY,
                                LTCOLUMN,
                                LTOPERATOR,
                                LTVALUECHAR,
                                LTVALUEDATE,
                                ASSORTDESC,
                                ASCOMMENT,
                                ABOVERWRITE,
                                ANOPTIONS );

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
   END CREATEFILTER;

   
   FUNCTION CREATEFILTER(
      ANFILTERID                 IN OUT   IAPITYPE.FILTERID_TYPE,
      ANARRAY                    IN       IAPITYPE.NUMVAL_TYPE,
      ATCOLUMN                   IN       IAPITYPE.CHARTAB_TYPE,
      ATOPERATOR                 IN       IAPITYPE.CHARTAB_TYPE,
      ATVALCHAR                  IN       IAPITYPE.CHARTAB_TYPE,
      ATVALDATE                  IN       IAPITYPE.DATETAB_TYPE,
      ASSORTDESC                 IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASCOMMENT                  IN       IAPITYPE.FILTERDESCRIPTION_TYPE,
      ABOVERWRITE                IN       IAPITYPE.BOOLEAN_TYPE,
      ANOPTIONS                  IN       IAPITYPE.NUMVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CreateFilter';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LICURSOR                      INTEGER;
      LSSQLSTRING                   IAPITYPE.BUFFER_TYPE;
      LIRESULT                      INTEGER;
      LICOUNTER                     INTEGER := 0;
      LIROW                         INTEGER;
      LNFILTERID                    IAPITYPE.FILTERID_TYPE;

      CURSOR LQCOLUMNCURSOR
      IS
         SELECT COLUMN_NAME
           FROM DBA_TAB_COLUMNS
          WHERE TABLE_NAME = 'ITFRMFLT';

      CURSOR LQOPERATORCURSOR
      IS
         SELECT COLUMN_NAME
           FROM DBA_TAB_COLUMNS
          WHERE TABLE_NAME = 'ITFRMFLTOP';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNFILTERID := ANFILTERID;

      IF ABOVERWRITE = 1
      THEN
         BEGIN
            UPDATE ITFRMFLTD
               SET SORT_DESC = ASSORTDESC,
                   DESCRIPTION = ASCOMMENT,
                   OPTIONS = ANOPTIONS
             WHERE FILTER_ID = LNFILTERID;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      ELSE
         BEGIN
            SELECT SHFLT_SEQ.NEXTVAL
              INTO LNFILTERID
              FROM DUAL;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;

         ANFILTERID := LNFILTERID;

         BEGIN
            INSERT INTO ITFRMFLTD
                        ( FILTER_ID,
                          USER_ID,
                          SORT_DESC,
                          DESCRIPTION,
                          OPTIONS )
                 VALUES ( LNFILTERID,
                          USER,
                          ASSORTDESC,
                          ASCOMMENT,
                          ANOPTIONS );

            INSERT INTO ITFRMFLT
                        ( FILTER_ID )
                 VALUES ( LNFILTERID );

            INSERT INTO ITFRMFLTOP
                        ( FILTER_ID )
                 VALUES ( LNFILTERID );
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      END IF;

      LICURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR LIROW IN LQCOLUMNCURSOR
      LOOP
         IF LIROW.COLUMN_NAME <> 'FILTER_ID'
         THEN
            LSSQLSTRING :=    'UPDATE itfrmflt SET '
                           || LIROW.COLUMN_NAME
                           || ' = NULL WHERE filter_id = '
                           || LNFILTERID;

            BEGIN
               DBMS_SQL.PARSE( LICURSOR,
                               LSSQLSTRING,
                               DBMS_SQL.V7 );
               LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
            EXCEPTION
               WHEN OTHERS
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        SQLERRM );
                  RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
            END;

            DBMS_SQL.PARSE( LICURSOR,
                            LSSQLSTRING,
                            DBMS_SQL.V7 );
            LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
         END IF;
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      LICURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR LIROW IN LQOPERATORCURSOR
      LOOP
         IF LIROW.COLUMN_NAME <> 'FILTER_ID'
         THEN
            LSSQLSTRING :=    'UPDATE itfrmfltop SET '
                           || LIROW.COLUMN_NAME
                           || ' = NULL WHERE filter_id = '
                           || LNFILTERID;

            BEGIN
               DBMS_SQL.PARSE( LICURSOR,
                               LSSQLSTRING,
                               DBMS_SQL.V7 );
               LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
            EXCEPTION
               WHEN OTHERS
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        SQLERRM );
                  RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
            END;

            DBMS_SQL.PARSE( LICURSOR,
                            LSSQLSTRING,
                            DBMS_SQL.V7 );
            LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
         END IF;
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      LICURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR LICOUNTER IN 1 .. ANARRAY
      LOOP
         IF ATCOLUMN( LICOUNTER ) IN
               ( 'PHASE_IN_DATE', 'PLANNED_EFFECTIVE_DATE', 'ISSUED_DATE', 'OBSOLESCENCE_DATE', 'CHANGED_DATE', 'STATUS_CHANGE_DATE',
                 'LAST_MODIFIED_ON', 'CREATED_ON' )
         THEN
            LSSQLSTRING :=
                             'UPDATE itfrmflt SET '
                          || ATCOLUMN( LICOUNTER )
                          || ' = '''
                          || ATVALDATE( LICOUNTER )
                          || ''' WHERE filter_id = '
                          || LNFILTERID;
         ELSE
            LSSQLSTRING :=
                             'UPDATE itfrmflt SET '
                          || ATCOLUMN( LICOUNTER )
                          || ' = '''
                          || ATVALCHAR( LICOUNTER )
                          || ''' WHERE filter_id = '
                          || LNFILTERID;
         END IF;

         BEGIN
            DBMS_SQL.PARSE( LICURSOR,
                            LSSQLSTRING,
                            DBMS_SQL.V7 );
            LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                        LSSQLSTRING
                                     || '  error : '
                                     || SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      LICURSOR := DBMS_SQL.OPEN_CURSOR;

      FOR LICOUNTER IN 1 .. ANARRAY
      LOOP
         LSSQLSTRING :=
               'UPDATE itfrmfltop SET LOG_'
            || ATCOLUMN( LICOUNTER )
            || ' = Lower('''
            || ATOPERATOR( LICOUNTER )
            || ''') WHERE filter_id = '
            || LNFILTERID;

         BEGIN
            DBMS_SQL.PARSE( LICURSOR,
                            LSSQLSTRING,
                            DBMS_SQL.V7 );
            LIRESULT := DBMS_SQL.EXECUTE( LICURSOR );
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                        LSSQLSTRING
                                     || '  error : '
                                     || SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
         END;
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LICURSOR );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         IF DBMS_SQL.IS_OPEN( LICURSOR )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LICURSOR );
         END IF;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CREATEFILTER;

   
   FUNCTION STATUSCHANGE(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ANCURRENTSTATUS            IN       IAPITYPE.STATUSID_TYPE,
      ANNEXTSTATUS               IN       IAPITYPE.STATUSID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LECURRENTSTATUSISNULL         EXCEPTION;
      LENEXTSTATUSISNULL            EXCEPTION;
      LEFRAMEISNULL                 EXCEPTION;
      LEREVISIONISNULL              EXCEPTION;
      LEOWNERISNULL                 EXCEPTION;
      LEFRAMEINDEV                  EXCEPTION;
      LSINTL                        IAPITYPE.INTL_TYPE;
      LNEXPORTED                    IAPITYPE.NUMVAL_TYPE;
      LNPREVREV                     IAPITYPE.REVISION_TYPE;
      LNPREVSUBREV                  IAPITYPE.REVISION_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'StatusChange';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ASFRAMENO IS NULL
      THEN
         RAISE LEFRAMEISNULL;
      ELSIF ANREVISION IS NULL
      THEN
         RAISE LEREVISIONISNULL;
      ELSIF ANOWNER IS NULL
      THEN
         RAISE LEOWNERISNULL;
      ELSIF ANCURRENTSTATUS IS NULL
      THEN
         RAISE LECURRENTSTATUSISNULL;
      ELSIF ANNEXTSTATUS IS NULL
      THEN
         RAISE LENEXTSTATUSISNULL;
      END IF;

      IF (     ANCURRENTSTATUS = 1
           AND ANNEXTSTATUS = 2 )
      THEN

         SP_SET_FRAME_CURRENT( ASFRAMENO,
                               ANREVISION,
                               ANOWNER );
         LNRETVAL := UPDATELAYOUT( ASFRAMENO,
                                   ANREVISION,
                                   ANOWNER );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         SELECT INTL
           INTO LSINTL
           FROM FRAME_HEADER
          WHERE FRAME_NO = ASFRAMENO
            AND REVISION = ANREVISION
            AND OWNER = ANOWNER;

         IF LSINTL = '1'
         THEN
            IF MOD(   ANREVISION
                    * 100,
                    100 ) > 0
            THEN
               SELECT MAX( REVISION )
                 INTO LNPREVREV
                 FROM FRAME_HEADER
                WHERE FRAME_NO = ASFRAMENO
                  AND OWNER = ANOWNER
                  AND REVISION = TRUNC( ANREVISION );


               UPDATE FRAME_HEADER
                  SET STATUS = 3,
                      STATUS_CHANGE_DATE = SYSDATE
                WHERE FRAME_NO = ASFRAMENO
                  AND OWNER = ANOWNER
                  AND REVISION <> LNPREVREV
                  AND STATUS = 7;





               UPDATE FRAME_HEADER
                  SET STATUS = 7,
                      STATUS_CHANGE_DATE = SYSDATE
                WHERE FRAME_NO = ASFRAMENO
                  AND REVISION = LNPREVREV
                  AND OWNER = ANOWNER
                  AND STATUS <> 3;


               BEGIN
                  SELECT MAX( REVISION )
                    INTO LNPREVSUBREV
                    FROM FRAME_HEADER
                   WHERE FRAME_NO = ASFRAMENO
                     AND OWNER = ANOWNER
                     AND REVISION < ANREVISION
                     AND STATUS = 2;

                  UPDATE FRAME_HEADER
                     SET STATUS = 3,
                         STATUS_CHANGE_DATE = SYSDATE
                   WHERE FRAME_NO = ASFRAMENO
                     AND REVISION = LNPREVSUBREV
                     AND OWNER = ANOWNER;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN

                     NULL;
               END;


               UPDATE FRAME_HEADER
                  SET STATUS = 2,
                      STATUS_CHANGE_DATE = SYSDATE
                WHERE FRAME_NO = ASFRAMENO
                  AND REVISION = ANREVISION
                  AND OWNER = ANOWNER;
            ELSIF MOD(   ANREVISION
                       * 100,
                       100 ) = 0
            THEN


               BEGIN
                  SELECT REVISION
                    INTO LNPREVREV
                    FROM FRAME_HEADER
                   WHERE FRAME_NO = ASFRAMENO
                     AND OWNER = ANOWNER
                     AND MOD(   REVISION
                              * 100,
                              100 ) > 0
                     AND STATUS = 2;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     LNPREVREV := 0;
               END;

               IF LNPREVREV > 0
               THEN

                  UPDATE FRAME_HEADER
                     SET STATUS = 7,
                         STATUS_CHANGE_DATE = SYSDATE
                   WHERE FRAME_NO = ASFRAMENO
                     AND REVISION = ANREVISION
                     AND OWNER = ANOWNER
                     AND STATUS IN( 1, 2 );


                  UPDATE FRAME_HEADER
                     SET STATUS = 3,
                         STATUS_CHANGE_DATE = SYSDATE
                   WHERE FRAME_NO = ASFRAMENO
                     AND OWNER = ANOWNER
                     AND REVISION < ANREVISION
                     AND STATUS = 7;
               ELSE

                  UPDATE FRAME_HEADER
                     SET STATUS = 3,
                         STATUS_CHANGE_DATE = SYSDATE
                   WHERE FRAME_NO = ASFRAMENO
                     AND REVISION = TRUNC(   ANREVISION
                                           - 1 )
                     AND OWNER = ANOWNER
                     AND STATUS IN( 2, 7 );


                  UPDATE FRAME_HEADER
                     SET STATUS = 2,
                         STATUS_CHANGE_DATE = SYSDATE
                   WHERE FRAME_NO = ASFRAMENO
                     AND REVISION = ANREVISION
                     AND OWNER = ANOWNER;
               END IF;
            END IF;
         ELSE
            BEGIN
               SELECT REVISION
                 INTO LNPREVREV
                 FROM FRAME_HEADER
                WHERE FRAME_NO = ASFRAMENO
                  AND OWNER = ANOWNER
                  AND REVISION =   ANREVISION
                                 - 1;

            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  LNPREVREV := 0;
            END;

            IF LNPREVREV > 0
            THEN
               UPDATE FRAME_HEADER
                  SET STATUS = 3,
                      STATUS_CHANGE_DATE = SYSDATE
                WHERE FRAME_NO = ASFRAMENO
                  AND REVISION = LNPREVREV
                  AND OWNER = ANOWNER
                  AND STATUS = 2;
            END IF;


            UPDATE FRAME_HEADER
               SET STATUS = 2,
                   STATUS_CHANGE_DATE = SYSDATE
             WHERE FRAME_NO = ASFRAMENO
               AND REVISION = ANREVISION
               AND OWNER = ANOWNER;
         END IF;
      ELSIF(     ANCURRENTSTATUS = 6
             AND ANNEXTSTATUS = 2 )
      THEN


         BEGIN
            SELECT REVISION
              INTO LNPREVREV
              FROM FRAME_HEADER
             WHERE FRAME_NO = ASFRAMENO
               AND OWNER = ANOWNER
               AND MOD(   REVISION
                        * 100,
                        100 ) > 0
               AND STATUS = 1;

            RAISE LEFRAMEINDEV;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN

               NULL;
         END;



         UPDATE FRAME_HEADER
            SET STATUS = 3,
                STATUS_CHANGE_DATE = SYSDATE
          WHERE FRAME_NO = ASFRAMENO
            AND OWNER = ANOWNER
            AND (    STATUS = 2
                  OR STATUS = 7 );

         UPDATE FRAME_HEADER
            SET STATUS = ANNEXTSTATUS,
                STATUS_CHANGE_DATE = SYSDATE
          WHERE FRAME_NO = ASFRAMENO
            AND REVISION = ANREVISION
            AND OWNER = ANOWNER;
      ELSIF     ANCURRENTSTATUS = 2
            AND (    ANNEXTSTATUS = 3
                  OR ANNEXTSTATUS = 4 )
            AND MOD(   ANREVISION
                     * 100,
                     100 ) > 0
      THEN


         UPDATE FRAME_HEADER
            SET STATUS = 2,
                STATUS_CHANGE_DATE = SYSDATE
          WHERE FRAME_NO = ASFRAMENO
            AND OWNER = ANOWNER
            AND STATUS = 7;

         UPDATE FRAME_HEADER
            SET STATUS = ANNEXTSTATUS,
                STATUS_CHANGE_DATE = SYSDATE
          WHERE FRAME_NO = ASFRAMENO
            AND REVISION = ANREVISION
            AND OWNER = ANOWNER;
      ELSE
         UPDATE FRAME_HEADER
            SET STATUS = ANNEXTSTATUS,
                STATUS_CHANGE_DATE = SYSDATE
          WHERE FRAME_NO = ASFRAMENO
            AND REVISION = ANREVISION
            AND OWNER = ANOWNER;
      END IF;

      BEGIN
         IF ANNEXTSTATUS = 2
         THEN
            INSERT INTO FRAMEDATA_SERVER
                        ( FRAME_NO,
                          REVISION,
                          OWNER )
                 VALUES ( ASFRAMENO,
                          ANREVISION,
                          ANOWNER );
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN LEFRAMEISNULL
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                               'Frame No' );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      WHEN LEREVISIONISNULL
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                               'Frame Revision' );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      WHEN LEOWNERISNULL
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                               'Frame Owner' );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      WHEN LENEXTSTATUSISNULL
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                               'Next Status' );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      WHEN LECURRENTSTATUSISNULL
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                               'Current Status' );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      WHEN LEFRAMEINDEV
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_FRAMEINDEVALREADYEXIST,
                                               ASFRAMENO,
                                               ANOWNER );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END STATUSCHANGE;

   
   FUNCTION SYNCHRONISEMASKS(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SynchroniseMasks';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;

      CURSOR LQFRAMEMASKS
      IS
         SELECT VIEW_ID
           FROM ITFRMV
          WHERE FRAME_NO = ASFRAMENO
            AND REVISION = ANREVISION
            AND OWNER = ANOWNER;

      CURSOR LQFRAMEMASKSSECTION
      IS
         SELECT *
           FROM ITFRMVSC
          WHERE FRAME_NO = ASFRAMENO
            AND REVISION = ANREVISION
            AND OWNER = ANOWNER;

      LNSEQUENCE                    IAPITYPE.NUMVAL_TYPE;
      LNFRAMEMASKSSECTION           IAPITYPE.NUMVAL_TYPE;
      LNFRAMEMASKS                  IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR LNFRAMEMASKSSECTION IN LQFRAMEMASKSSECTION
      LOOP
         BEGIN
            SELECT SECTION_SEQUENCE_NO
              INTO LNSEQUENCE
              FROM FRAME_SECTION
             WHERE FRAME_NO = ASFRAMENO
               AND REVISION = ANREVISION
               AND OWNER = ANOWNER
               AND SECTION_ID = LNFRAMEMASKSSECTION.SECTION_ID
               AND SUB_SECTION_ID = LNFRAMEMASKSSECTION.SUB_SECTION_ID
               AND REF_ID = LNFRAMEMASKSSECTION.REF_ID
               AND TYPE = LNFRAMEMASKSSECTION.TYPE;
         EXCEPTION
            WHEN OTHERS
            THEN
               LNSEQUENCE := 0;
         END;

         UPDATE ITFRMVSC
            SET SECTION_SEQUENCE_NO = LNSEQUENCE
          WHERE FRAME_NO = ASFRAMENO
            AND REVISION = ANREVISION
            AND OWNER = ANOWNER
            AND SECTION_ID = LNFRAMEMASKSSECTION.SECTION_ID
            AND SUB_SECTION_ID = LNFRAMEMASKSSECTION.SUB_SECTION_ID
            AND REF_ID = LNFRAMEMASKSSECTION.REF_ID
            AND TYPE = LNFRAMEMASKSSECTION.TYPE;
      END LOOP;

      FOR LNFRAMEMASKS IN LQFRAMEMASKS
      LOOP
         DELETE FROM ITFRMVSC
               WHERE ( SECTION_ID, SUB_SECTION_ID, TYPE, REF_ID, SECTION_SEQUENCE_NO ) IN(
                        SELECT SECTION_ID,
                               SUB_SECTION_ID,
                               TYPE,
                               REF_ID,
                               SECTION_SEQUENCE_NO
                          FROM ITFRMVSC
                         WHERE VIEW_ID = LNFRAMEMASKS.VIEW_ID
                           AND FRAME_NO = ASFRAMENO
                           AND REVISION = ANREVISION
                           AND OWNER = ANOWNER
                        MINUS
                        SELECT SECTION_ID,
                               SUB_SECTION_ID,
                               TYPE,
                               REF_ID,
                               SECTION_SEQUENCE_NO
                          FROM FRAME_SECTION
                         WHERE FRAME_NO = ASFRAMENO
                           AND REVISION = ANREVISION
                           AND OWNER = ANOWNER
                           AND MANDATORY = 'N' )
                 AND VIEW_ID = LNFRAMEMASKS.VIEW_ID;

         DELETE FROM ITFRMVPG
               WHERE ( SECTION_ID, SUB_SECTION_ID, PROPERTY_GROUP, PROPERTY, ATTRIBUTE ) IN(
                        SELECT SECTION_ID,
                               SUB_SECTION_ID,
                               PROPERTY_GROUP,
                               PROPERTY,
                               ATTRIBUTE
                          FROM ITFRMVPG
                         WHERE VIEW_ID = LNFRAMEMASKS.VIEW_ID
                           AND FRAME_NO = ASFRAMENO
                           AND REVISION = ANREVISION
                           AND OWNER = ANOWNER
                        MINUS
                        SELECT SECTION_ID,
                               SUB_SECTION_ID,
                               PROPERTY_GROUP,
                               PROPERTY,
                               ATTRIBUTE
                          FROM FRAME_PROP
                         WHERE FRAME_NO = ASFRAMENO
                           AND REVISION = ANREVISION
                           AND OWNER = ANOWNER
                           AND MANDATORY = 'N' )
                 AND VIEW_ID = LNFRAMEMASKS.VIEW_ID;
      END LOOP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END SYNCHRONISEMASKS;

   
   FUNCTION COPYMASKS(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ASOLDFRAMENO               IN       IAPITYPE.FRAMENO_TYPE,
      ANOLDREVISION              IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOLDOWNER                 IN       IAPITYPE.OWNER_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LNVIEWID                      IAPITYPE.ID_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CopyMasks';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      INSERT INTO ITFRMV
                  ( FRAME_NO,
                    REVISION,
                    OWNER,
                    VIEW_ID,
                    DESCRIPTION,
                    LAST_MODIFIED_ON,
                    LAST_MODIFIED_BY,
                    STATUS )
         SELECT ASFRAMENO,
                ANREVISION,
                ANOWNER,
                VIEW_ID,
                DESCRIPTION,
                SYSDATE,
                USER,
                STATUS
           FROM ITFRMV
          WHERE FRAME_NO = ASOLDFRAMENO
            AND REVISION = ANOLDREVISION
            AND OWNER = ANOLDOWNER;

      INSERT INTO ITFRMVSC
                  ( VIEW_ID,
                    FRAME_NO,
                    REVISION,
                    OWNER,
                    SECTION_ID,
                    SUB_SECTION_ID,
                    TYPE,
                    REF_ID,
                    SECTION_SEQUENCE_NO,
                    MANDATORY )
         SELECT VIEW_ID,
                ASFRAMENO,
                ANREVISION,
                ANOWNER,
                SECTION_ID,
                SUB_SECTION_ID,
                TYPE,
                REF_ID,
                SECTION_SEQUENCE_NO,
                MANDATORY
           FROM ITFRMVSC
          WHERE FRAME_NO = ASOLDFRAMENO
            AND REVISION = ANOLDREVISION
            AND OWNER = ANOLDOWNER;

      INSERT INTO ITFRMVPG
                  ( VIEW_ID,
                    FRAME_NO,
                    REVISION,
                    OWNER,
                    SECTION_ID,
                    SUB_SECTION_ID,
                    PROPERTY_GROUP,
                    PROPERTY,
                    ATTRIBUTE,
                    MANDATORY )
         SELECT VIEW_ID,
                ASFRAMENO,
                ANREVISION,
                ANOWNER,
                SECTION_ID,
                SUB_SECTION_ID,
                PROPERTY_GROUP,
                PROPERTY,
                ATTRIBUTE,
                MANDATORY
           FROM ITFRMVPG
          WHERE FRAME_NO = ASOLDFRAMENO
            AND REVISION = ANOLDREVISION
            AND OWNER = ANOLDOWNER;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END COPYMASKS;

   
   FUNCTION COPYVALIDATION(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE,
      ASOLDFRAMENO               IN       IAPITYPE.FRAMENO_TYPE,
      ANOLDREVISION              IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOLDOWNER                 IN       IAPITYPE.OWNER_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CopyValidation';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNNEWVALID                    IAPITYPE.ID_TYPE;
      LNFRAMEVALIDATION             IAPITYPE.NUMVAL_TYPE;

      CURSOR LQFRAMEVALIDATION
      IS
         SELECT VAL_ID,
                MASK_ID
           FROM ITFRMVAL
          WHERE FRAME_NO = ASOLDFRAMENO
            AND REVISION = ANOLDREVISION
            AND OWNER = ANOLDOWNER;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      FOR LNFRAMEVALIDATION IN LQFRAMEVALIDATION
      LOOP
         LNRETVAL := IAPISEQUENCE.GETNEXTVALUE( '0',
                                                'itfrmval',
                                                LNNEWVALID );

         INSERT INTO ITFRMVAL
                     ( FRAME_NO,
                       REVISION,
                       OWNER,
                       VAL_ID,
                       MASK_ID,
                       LAST_MODIFIED_ON,
                       LAST_MODIFIED_BY,
                       STATUS )
              VALUES ( ASFRAMENO,
                       ANREVISION,
                       ANOWNER,
                       LNNEWVALID,
                       LNFRAMEVALIDATION.MASK_ID,
                       SYSDATE,
                       USER,
                       0 );

         INSERT INTO ITFRMVALD
                     ( VAL_ID,
                       VAL_SEQ,
                       TYPE,
                       SECTION_ID,
                       SUB_SECTION_ID,
                       PROPERTY_GROUP,
                       PROPERTY,
                       ATTRIBUTE,
                       HEADER_ID,
                       REF_ID,
                       REF_OWNER )
            SELECT LNNEWVALID,
                   VAL_SEQ,
                   TYPE,
                   SECTION_ID,
                   SUB_SECTION_ID,
                   PROPERTY_GROUP,
                   PROPERTY,
                   ATTRIBUTE,
                   HEADER_ID,
                   REF_ID,
                   REF_OWNER
              FROM ITFRMVALD
             WHERE VAL_ID = LNFRAMEVALIDATION.VAL_ID;
      END LOOP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         
         NULL;
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END COPYVALIDATION;

   
   FUNCTION EXISTMASKID(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANVIEWID                   IN       IAPITYPE.ID_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE DEFAULT 1 )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistMaskId';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNVIEWID                      IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNRETVAL := IAPIFRAME.EXISTID( ASFRAMENO,
                                     ANREVISION,
                                     ANOWNER );

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

      SELECT VIEW_ID
        INTO LNVIEWID
        FROM ITFRMV
       WHERE FRAME_NO = ASFRAMENO
         AND REVISION = ANREVISION
         AND OWNER = ANOWNER
         AND VIEW_ID = ANVIEWID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_MASKNOTFOUND,
                                                     
                                                     
                                                     F_GET_MASK(ASFRAMENO, ANREVISION, ANOWNER, ANVIEWID),  
                                                     
                                                     ASFRAMENO,
                                                     ANREVISION,
                                                     ANOWNER ) );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTMASKID;

   
   FUNCTION EXISTMASKINFRAME(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE DEFAULT 1 )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistMaskInFrame';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM ITFRMV
       WHERE FRAME_NO = ASFRAMENO
         AND REVISION = ANREVISION
         AND OWNER = ANOWNER
         AND STATUS = 0;

      IF LNCOUNT > 0
      THEN
         RETURN 1;
      END IF;

      RETURN 0;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 0;
   END EXISTMASKINFRAME;
   
   FUNCTION ASSOCIATEICON(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE DEFAULT 1,
      ASICON                     IN       IAPITYPE.ICON_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AssociateIcon';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LNCOUNT1                       IAPITYPE.NUMVAL_TYPE;

   BEGIN
      
      
      

      
      
      

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM FRAME_HEADER
       WHERE FRAME_NO = ASFRAMENO
         AND REVISION = ANREVISION
         AND OWNER = ANOWNER;

      SELECT COUNT( * )
        INTO LNCOUNT1
        FROM UTDCGKICON
       WHERE ICON = ASICON;

      IF LNCOUNT > 0
      THEN
        IF LNCOUNT1 > 0 THEN
          BEGIN
              INSERT INTO FRAME_ICON (FRAME_NO, REVISION, OWNER, ICON)
                VALUES (ASFRAMENO, ANREVISION, ANOWNER, ASICON);

            EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
              UPDATE FRAME_ICON SET ICON = ASICON
                WHERE FRAME_NO = ASFRAMENO
                  AND REVISION = ANREVISION
                  AND OWNER = ANOWNER;
          END;
          RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
        END IF;
              IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      ELSE
              IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     SQLERRM );
               RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;
      EXCEPTION
       WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );

   END ASSOCIATEICON;

   FUNCTION REMOVEICON(
      ASFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.FRAMEREVISION_TYPE,
      ANOWNER                    IN       IAPITYPE.OWNER_TYPE DEFAULT 1 )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveIcon';
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

      DELETE FROM FRAME_ICON
            WHERE FRAME_NO = ASFRAMENO
              AND REVISION = ANREVISION
              AND OWNER = ANOWNER;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_FRAMEIDNOTFOUND,
                                                    ASFRAMENO );
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Delete Icon associate to frame <'
                           || ASFRAMENO
                           ||'.'
                           || ANREVISION
                           || '.'
                           || ANOWNER
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

   END REMOVEICON;


END IAPIFRAME;
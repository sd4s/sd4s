CREATE OR REPLACE PACKAGE BODY iapiSpecificationBom
AS















   
   FUNCTION GETPACKAGEVERSION
      RETURN IAPITYPE.STRING_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPackageVersion';
   BEGIN



        RETURN(    IAPIGENERAL.GETVERSION
              || ' ($Revision: 6.7.0.11 (06.07.00.11-00.00) $)' );

   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   END GETPACKAGEVERSION;











   FUNCTION CALCUOMCONVFACTOR(
      ASUOMDESCIPTION            IN       IAPITYPE.DESCRIPTION_TYPE,
      ASUOMDESCIPTION1           IN       IAPITYPE.DESCRIPTION_TYPE)
    RETURN IAPITYPE.FLOAT_TYPE
   IS
       
       
       
       
       
       
       
       
       
       
       
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNUOMID                       IAPITYPE.ID_TYPE;
      LNUOMGROUP                    IAPITYPE.ID_TYPE;
      LNUOMID1                      IAPITYPE.ID_TYPE;
      LNUOMGROUP1                   IAPITYPE.ID_TYPE;
      LNCONVFACTOR                  IAPITYPE.FLOAT_TYPE;

   BEGIN
     LNRETVAL := 1;

     BEGIN
         SELECT
         UOM.UOM_ID, UOM_UOM_GROUP.UOM_GROUP
         INTO LNUOMID, LNUOMGROUP
         FROM UOM, UOM_UOM_GROUP
         WHERE DESCRIPTION = ASUOMDESCIPTION
         AND UOM.UOM_ID = UOM_UOM_GROUP.UOM_ID(+);
     EXCEPTION WHEN OTHERS THEN
       RETURN LNRETVAL; 
     END;

     BEGIN
         SELECT
         UOM.UOM_ID, UOM_UOM_GROUP.UOM_GROUP
         INTO LNUOMID1, LNUOMGROUP1
         FROM UOM, UOM_UOM_GROUP
         WHERE DESCRIPTION = ASUOMDESCIPTION1
         AND UOM.UOM_ID = UOM_UOM_GROUP.UOM_ID(+);
     EXCEPTION WHEN OTHERS THEN
       RETURN LNRETVAL; 
     END;

     IF LNUOMGROUP IS NOT NULL AND LNUOMGROUP1 IS NOT NULL
     THEN
        IF LNUOMGROUP = LNUOMGROUP1
        THEN
           BEGIN
             SELECT CONV_FACTOR
               INTO LNCONVFACTOR
               FROM UOMC
               WHERE UOM_ID = LNUOMID
               AND UOM_ALT_ID = LNUOMID1;
           EXCEPTION WHEN OTHERS
           THEN
             LNCONVFACTOR := NULL;
           END;

           IF LNCONVFACTOR IS NULL
           THEN
                 BEGIN
                    SELECT CONV_FACTOR
                    INTO LNCONVFACTOR
                    FROM UOMC
                    WHERE UOM_ID = LNUOMID1
                    AND UOM_ALT_ID = LNUOMID;
                 EXCEPTION WHEN OTHERS
                 THEN
                   RETURN LNRETVAL;
                 END;

                 IF LNCONVFACTOR IS NULL
                 THEN
                    LNRETVAL := 1;
                 ELSE
                    LNRETVAL := 1 / LNCONVFACTOR;
                 END IF;
            ELSE
                LNRETVAL := LNCONVFACTOR;
            END IF;
        END IF;
     END IF;

     RETURN LNRETVAL;

   END CALCUOMCONVFACTOR;



   FUNCTION CHECKVIEWACCESS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LNACCESSLEVEL                 IAPITYPE.ID_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckViewAccess';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNACCESSLEVEL := 0;

      IF F_CHECK_ITEM_ACCESS( ASPARTNO,
                              ANREVISION,
                              NULL,
                              NULL,
                              IAPICONSTANT.SECTIONTYPE_BOM,
                              0,
                              0,
                              0,
                              0,
                              LNACCESSLEVEL ) = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOVIEWSECTIONACCESS,
                                                    ASPARTNO,
                                                    ANREVISION,
                                                    '',
                                                    '',
                                                    'BOM' );
      END IF;

      
      LNACCESSLEVEL := 2;

      IF F_CHECK_ITEM_ACCESS( ASPARTNO,
                              ANREVISION,
                              NULL,
                              NULL,
                              IAPICONSTANT.SECTIONTYPE_BOM,
                              0,
                              0,
                              0,
                              0,
                              LNACCESSLEVEL ) = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOVIEWSECTIONACCESS,
                                                    ASPARTNO,
                                                    ANREVISION,
                                                    '',
                                                    '',
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
   END CHECKVIEWACCESS;


   FUNCTION EXISTSEC(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                OUT      IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             OUT      IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
       
       
       
       
       
       
       
       
       
      
       
      CURSOR LQSEC
      IS
         SELECT SECTION_ID,
                SUB_SECTION_ID
           FROM SPECIFICATION_SECTION
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND TYPE = IAPICONSTANT.SECTIONTYPE_BOM;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistSec';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN LQSEC;

      FETCH LQSEC
       INTO ANSECTIONID,
            ANSUBSECTIONID;

      IF LQSEC%NOTFOUND
      THEN
         BEGIN
            SELECT SECTION_ID,
                   SUB_SECTION_ID
              INTO ANSECTIONID,
                   ANSUBSECTIONID
              FROM FRAME_SECTION
             WHERE ( FRAME_NO, REVISION, OWNER ) = ( SELECT FRAME_ID,
                                                            FRAME_REV,
                                                            FRAME_OWNER
                                                      FROM SPECIFICATION_HEADER
                                                     WHERE PART_NO = ASPARTNO
                                                       AND REVISION = ANREVISION )
               AND TYPE = IAPICONSTANT.SECTIONTYPE_BOM;
         EXCEPTION
            WHEN OTHERS
            THEN
               CLOSE LQSEC;

               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_SPSECTIONNOTFOUND,
                                                           ASPARTNO,
                                                           ANREVISION,
                                                           
                                                           
                                                           
                                                           F_SCH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSECTIONID, 0),
                                                           F_SBH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANSUBSECTIONID, 0) ));
                                                           
         END;
      END IF;

      CLOSE LQSEC;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTSEC;


   FUNCTION CHECKEDITACCESS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LNACCESSLEVEL                 IAPITYPE.ID_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckEditAccess';
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNACCESSLEVEL := 1;

      





      






      IF F_CHECK_ITEM_ACCESS( ASPARTNO,
                              ANREVISION,
                              LNSECTIONID,
                              LNSUBSECTIONID,
                              IAPICONSTANT.SECTIONTYPE_BOM,
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
                                                    '',
                                                    '',
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
   END CHECKEDITACCESS;


   FUNCTION GETDOMINANTUOM(
      LNBOMEXPNO                 IN       IAPITYPE.SEQUENCE_TYPE,
      LSDOMINANTUOM              OUT      IAPITYPE.DESCRIPTION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LSINGUOM                      PART.BASE_UOM%TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetDominantUom';

      CURSOR LCGETUOM(
         CNBOMEXPNO                          IAPITYPE.SEQUENCE_TYPE )
      IS
         SELECT   UOM,
                  SUM( TYPE_UOM ) TOTAL_TYPE_UOM,
                  SUM( TYPE_TO_UNIT ) TOTAL_TYPE_TO_UNIT,
                    SUM( TYPE_UOM )
                  + SUM( TYPE_TO_UNIT ) TOTAL
             FROM ( SELECT  UOM,
                            SUM( TYPE_UOM ) TYPE_UOM,
                            SUM( TYPE_TO_UNIT ) TYPE_TO_UNIT
                       FROM ( SELECT UOM,
                                     1 TYPE_UOM,
                                     0 TYPE_TO_UNIT
                               FROM ITBOMEXPLOSION
                              WHERE BOM_EXP_NO = LNBOMEXPNO
                                AND INGREDIENT <> 2
                                AND F_IS_LOWESTLEVEL( BOM_EXP_NO,
                                                      MOP_SEQUENCE_NO,
                                                      SEQUENCE_NO ) = 1
                                AND UOM IS NOT NULL )
                   GROUP BY UOM
                   UNION
                   SELECT   UOM,
                            SUM( TYPE_UOM ) TYPE_UOM,
                            SUM( TYPE_TO_UNIT ) TYPE_TO_UNIT
                       FROM ( SELECT TO_UNIT UOM,
                                     0 TYPE_UOM,
                                     1 TYPE_TO_UNIT
                               FROM ITBOMEXPLOSION
                              WHERE BOM_EXP_NO = LNBOMEXPNO
                                AND INGREDIENT <> 2
                                AND F_IS_LOWESTLEVEL( BOM_EXP_NO,
                                                      MOP_SEQUENCE_NO,
                                                      SEQUENCE_NO ) = 1
                                AND TO_UNIT IS NOT NULL )
                   GROUP BY UOM )
         GROUP BY UOM
         ORDER BY 4 DESC;

      CURSOR LCGETSEQUENCE(
         CNBOMEXPNO                          IAPITYPE.SEQUENCE_TYPE,
         CSUOM                               IAPITYPE.DESCRIPTION_TYPE )
      IS
         SELECT MIN( SEQUENCE_NO ) SEQUENCE_NO
           FROM ITBOMEXPLOSION
          WHERE BOM_EXP_NO = CNBOMEXPNO
            AND UOM = CSUOM
            AND SEQUENCE_NO IN( SELECT ROUND( SEQUENCE_NO,
                                              0 )
                                 FROM ITBOMEXPLOSION
                                WHERE BOM_EXP_NO = CNBOMEXPNO
                                  AND INGREDIENT <> 2
                                  AND F_IS_LOWESTLEVEL( BOM_EXP_NO,
                                                        MOP_SEQUENCE_NO,
                                                        SEQUENCE_NO ) = 1 );

      LSUOM                         ITBOMEXPLOSION.UOM%TYPE := NULL;
      LNTOTALTYPEUOM                IAPITYPE.NUMVAL_TYPE;
      LNTOTALTYPETOUOM              IAPITYPE.NUMVAL_TYPE;
      LNTOTAL                       IAPITYPE.NUMVAL_TYPE;
      LNUOM1SEQUENCENO              IAPITYPE.SEQUENCE_TYPE;
      LNUOM2SEQUENCENO              IAPITYPE.SEQUENCE_TYPE;
   BEGIN
      FOR LCGETUOM_REC IN LCGETUOM( LNBOMEXPNO )
      LOOP
         IF LSUOM IS NULL
         THEN
            LSUOM := LCGETUOM_REC.UOM;
            LNTOTALTYPEUOM := LCGETUOM_REC.TOTAL_TYPE_UOM;
            LNTOTALTYPETOUOM := LCGETUOM_REC.TOTAL_TYPE_TO_UNIT;
            LNTOTAL := LCGETUOM_REC.TOTAL;
         ELSE
            IF LNTOTAL = LCGETUOM_REC.TOTAL
            THEN
               IF LNTOTALTYPEUOM < LCGETUOM_REC.TOTAL_TYPE_UOM
               THEN
                  LSUOM := LCGETUOM_REC.UOM;
                  LNTOTALTYPEUOM := LCGETUOM_REC.TOTAL_TYPE_UOM;
                  LNTOTALTYPETOUOM := LCGETUOM_REC.TOTAL_TYPE_TO_UNIT;
                  LNTOTAL := LCGETUOM_REC.TOTAL;
               ELSIF LNTOTALTYPEUOM = LCGETUOM_REC.TOTAL_TYPE_UOM
               THEN
                  LNUOM1SEQUENCENO := -1;

                  
                  FOR LCGETSEQUENCE_REC IN LCGETSEQUENCE( LNBOMEXPNO,
                                                          LSUOM )
                  LOOP
                     LNUOM1SEQUENCENO := LCGETSEQUENCE_REC.SEQUENCE_NO;
                  END LOOP;

                  
                  LNUOM2SEQUENCENO := -1;

                  FOR LCGETSEQUENCE_REC IN LCGETSEQUENCE( LNBOMEXPNO,
                                                          LCGETUOM_REC.UOM )
                  LOOP
                     LNUOM2SEQUENCENO := LCGETSEQUENCE_REC.SEQUENCE_NO;
                  END LOOP;

                  IF LNUOM1SEQUENCENO > LNUOM2SEQUENCENO
                  THEN
                     LSUOM := LCGETUOM_REC.UOM;
                     LNTOTALTYPEUOM := LCGETUOM_REC.TOTAL_TYPE_UOM;
                     LNTOTALTYPETOUOM := LCGETUOM_REC.TOTAL_TYPE_TO_UNIT;
                     LNTOTAL := LCGETUOM_REC.TOTAL;
                  END IF;
               END IF;
            ELSE
               EXIT;
            END IF;
         END IF;
      END LOOP;

      IF NOT LSUOM IS NULL
      THEN
         LSDOMINANTUOM := LSUOM;
      ELSE
         SELECT UOM
           INTO LSINGUOM
           FROM ITBOMEXPLOSION
          WHERE BOM_EXP_NO = LNBOMEXPNO
            AND BOM_LEVEL = 0;

         LSDOMINANTUOM := LSINGUOM;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETDOMINANTUOM;


   FUNCTION RECURSIVECALCQTY(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS









      LSPATH                        IAPITYPE.STRING_TYPE;
      LFCALC_QTY                    IAPITYPE.FLOAT_TYPE;
      LSUOM                         IAPITYPE.DESCRIPTION_TYPE;
      LSTOUNIT                      IAPITYPE.DESCRIPTION_TYPE;
      LNCONVFACTOR                  IAPITYPE.BOMCONVFACTOR_TYPE;
      LSDOMINANTUOM                 IAPITYPE.DESCRIPTION_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RecursiveCalcQty';
      
      LSPLANT                       IAPITYPE.PLANT_TYPE;

      CURSOR LCRECURSIVEPARTS
      IS
         SELECT   SEQUENCE_NO,
                  PATH,
                  COMPONENT_PART,
                  REV,
                  DECODE( LSDOMINANTUOM,
                          TO_UNIT, CALC_QTY
                           * CONV_FACTOR,
                          CALC_QTY ) CALC_QTY
                  
                  , PLANT
             FROM IVBOMEXPLOSION
            WHERE RECURSIVE_STOP = 1
         ORDER BY BOM_LEVEL DESC,
                  SEQUENCE_NO ASC;

      CURSOR LCLOWESTCHILDS(
         ASPATH                              IAPITYPE.STRING_TYPE,
         AFPARENTQTY                         IAPITYPE.FLOAT_TYPE,
         AFRECURSIVEQTY                      IAPITYPE.FLOAT_TYPE )
      IS
         SELECT A.SEQUENCE_NO,
                  A.CALC_QTY
                * AFPARENTQTY
                / ( DECODE(  (   AFPARENTQTY
                               - AFRECURSIVEQTY ),
                            0, NULL,
                            (   AFPARENTQTY
                              - AFRECURSIVEQTY ) ) ) RECALQTY
           FROM IVBOMEXPLOSION A
          WHERE INSTR( PATH,
                       ASPATH ) > 0
            AND RECURSIVE_STOP = 0
            AND F_IS_LOWESTLEVEL( BOM_EXP_NO,
                                  MOP_SEQUENCE_NO,
                                  SEQUENCE_NO ) = 1;

    
    CURSOR LCPARENTSEQUENCES
    IS
        SELECT DISTINCT PSEQUENCE_NO
        FROM IVBOMEXPLOSION
        WHERE PSEQUENCE_NO IS NOT NULL
        ORDER BY 1 DESC;
    

      LSINSERTSQL                   VARCHAR2( 1000 );

      
      LNPARENTCQTY              IAPITYPE.FLOAT_TYPE;
      LNCHILDRENCQTY            IAPITYPE.FLOAT_TYPE;
   BEGIN
      DBMS_SESSION.SET_CONTEXT( 'IACBOMEXP',
                                'BOM_EXP_NO',
                                ANUNIQUEID );
      DBMS_SESSION.SET_CONTEXT( 'IACBOMEXP',
                                'MOP_SEQUENCE_NO',
                                ANMOPSEQUENCENO );

      DELETE FROM ITBOMEXPTEMP
            WHERE BOM_EXP_NO = ANUNIQUEID
              AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO;

      LSINSERTSQL :=
            ' INSERT INTO itbomExpTemp '
         || ' ( SELECT BOM_EXP_NO, '
         || ' MOP_SEQUENCE_NO, '
         || ' sequence_no, '
         || ' ( SELECT MAX( sequence_no ) '
         || '    FROM itbomexplosion itexp2 '
         || '   WHERE BOM_EXP_NO = :anUniqueId '
         || '     AND MOP_SEQUENCE_NO = :anMopSequenceNo '
         || '     AND itexp2.BOM_LEVEL =   itexp1.bom_level - 1 '
         || '     AND itexp2.sequence_no < itexp1.sequence_no ) pSeq '
         || ' FROM itbomexplosion itexp1 '
         || ' WHERE BOM_EXP_NO = :anUniqueId '
         || ' AND MOP_SEQUENCE_NO = :anMopSequenceNo ) ';

      EXECUTE IMMEDIATE LSINSERTSQL
                  USING ANUNIQUEID,
                        ANMOPSEQUENCENO,
                        ANUNIQUEID,
                        ANMOPSEQUENCENO;

      SELECT IAPISPECIFICATIONBOM.GETINGREDIENTEXPLOSIONUOM( ANUNIQUEID,
                                                             ANMOPSEQUENCENO )
        INTO LSDOMINANTUOM
        FROM DUAL;

      FOR LRRECURPARTS IN LCRECURSIVEPARTS
      LOOP
         SELECT PATH,
                DECODE( LSDOMINANTUOM,
                        TO_UNIT, CALC_QTY
                         * CONV_FACTOR,
                        CALC_QTY ) CALC_QTY
           INTO LSPATH,
                LFCALC_QTY
           FROM IVBOMEXPLOSION
          WHERE COMPONENT_PART = LRRECURPARTS.COMPONENT_PART
            AND REV = LRRECURPARTS.REV
            AND INSTR( LRRECURPARTS.PATH,
                       PATH ) > 0
            
            AND PLANT = LRRECURPARTS.PLANT
            AND RECURSIVE_STOP = 0;

         FOR LRCHILDS IN LCLOWESTCHILDS( LSPATH,
                                         LFCALC_QTY,
                                         LRRECURPARTS.CALC_QTY )
         LOOP
            UPDATE ITBOMEXPLOSION
               SET CALC_QTY = NVL( LRCHILDS.RECALQTY,
                                   0 )
             WHERE BOM_EXP_NO = ANUNIQUEID
               AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
               AND SEQUENCE_NO = LRCHILDS.SEQUENCE_NO;
         END LOOP;

         DELETE FROM ITBOMEXPLOSION
               WHERE BOM_EXP_NO = ANUNIQUEID
                 AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                 AND SEQUENCE_NO = LRRECURPARTS.SEQUENCE_NO;
    
     FOR LRPARENTSEQ IN LCPARENTSEQUENCES
     LOOP
            SELECT CALC_QTY
            INTO LNPARENTCQTY
            FROM IVBOMEXPLOSION
            WHERE SEQUENCE_NO = LRPARENTSEQ.PSEQUENCE_NO;

            SELECT SUM(CALC_QTY)
            INTO LNCHILDRENCQTY
            FROM IVBOMEXPLOSION
            WHERE PSEQUENCE_NO = LRPARENTSEQ.PSEQUENCE_NO;

            IF (LNPARENTCQTY <> LNCHILDRENCQTY)
            THEN
                UPDATE ITBOMEXPLOSION
                   SET CALC_QTY = NVL( LNCHILDRENCQTY,0 )
                 WHERE BOM_EXP_NO = ANUNIQUEID
                   AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                   AND SEQUENCE_NO = LRPARENTSEQ.PSEQUENCE_NO;
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
   END RECURSIVECALCQTY;


   FUNCTION ISRECURSIVEIMP(
      ANUNIQUEID                 IN       IAPITYPE.ID_TYPE,
      ANMOPCOUNT                 IN       IAPITYPE.ID_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE )
      RETURN IAPITYPE.BOOLEAN_TYPE







   IS
      CURSOR LCITEMS
      IS
         SELECT   PARENT_PART,
                  PARENT_REVISION,
                  PLANT,
                  BOM_LEVEL,
                  SEQUENCE_NO
             FROM ITBOMIMPLOSION
            WHERE BOM_IMP_NO = ANUNIQUEID
              AND MOP_SEQUENCE_NO = ANMOPCOUNT
         ORDER BY SEQUENCE_NO DESC;

      LNPREVLEVEL                   PLS_INTEGER;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsRecursiveImp';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      BEGIN
         SELECT BOM_LEVEL
           INTO LNPREVLEVEL
           FROM ITBOMIMPLOSION
          WHERE BOM_IMP_NO = ANUNIQUEID
            AND MOP_SEQUENCE_NO = ANMOPCOUNT
            AND SEQUENCE_NO = ( SELECT MAX( SEQUENCE_NO )
                                 FROM ITBOMIMPLOSION
                                WHERE BOM_IMP_NO = ANUNIQUEID
                                  AND MOP_SEQUENCE_NO = ANMOPCOUNT );
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;   
      END;

      FOR LREC IN LCITEMS
      LOOP
         IF LREC.BOM_LEVEL =   LNPREVLEVEL
                             - 1
         THEN
            LNPREVLEVEL := LREC.BOM_LEVEL;

            IF     LREC.PARENT_PART = ASPARTNO
               AND LREC.PARENT_REVISION = ANREVISION
               AND LREC.PLANT = ASPLANT
            THEN
               RETURN 1;
            END IF;
         END IF;
      END LOOP;

      RETURN 0;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
         RAISE_APPLICATION_ERROR( -20000,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
   END ISRECURSIVEIMP;


   FUNCTION PREITEMCHANGED(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASMETHOD                   IN       IAPITYPE.METHOD_TYPE,
      AQERRORS                   IN OUT   IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'PreItemChanged';
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
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
         RETURN( LNRETVAL );
      END IF;

      IF LNACCESS = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOUPDATEACCESS,
                                                    ASPARTNO,
                                                    ANREVISION );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Pre-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := EXISTSEC( ASPARTNO,
                            ANREVISION,
                            LNSECTIONID,
                            LNSUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LNRETVAL := IAPISPECIFICATIONACCESS.GETMODIFIABLEACCESS( ASPARTNO,
                                                               ANREVISION,
                                                               LNSECTIONID,
                                                               LNSUBSECTIONID,
                                                               LNACCESS );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     ASMETHOD,
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

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END PREITEMCHANGED;


   FUNCTION POSTITEMCHANGED(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASMETHOD                   IN       IAPITYPE.METHOD_TYPE,
      ABLOGCHANGES               IN       BOOLEAN DEFAULT TRUE,
      AQERRORS                   IN OUT   IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'PostItemChanged';
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := EXISTSEC( ASPARTNO,
                            ANREVISION,
                            LNSECTIONID,
                            LNSUBSECTIONID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF ABLOGCHANGES
      THEN
         
         LNRETVAL := IAPISPECIFICATIONSECTION.LOGHISTORY( ASPARTNO,
                                                          ANREVISION,
                                                          LNSECTIONID,
                                                          LNSUBSECTIONID );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         
         LNRETVAL := IAPISPECIFICATION.LOGCHANGES( ASPARTNO,
                                                   ANREVISION );

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
                           'Call CUSTOM Post-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     ASMETHOD,
                                                     'POST',
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

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END POSTITEMCHANGED;

   
   FUNCTION SETEXPORTTOERP(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LNWFG                         IAPITYPE.ID_TYPE;
      LNSTATUS                      IAPITYPE.ID_TYPE;
      LNCOUNTEXPORTERP              PLS_INTEGER;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExportToErp';
   BEGIN
      SELECT WORKFLOW_GROUP_ID,
             STATUS
        INTO LNWFG,
             LNSTATUS
        FROM SPECIFICATION_HEADER
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION;

      SELECT COUNT( EXPORT_ERP )
        INTO LNCOUNTEXPORTERP
        FROM WORKFLOW_GROUP WFG,
             WORK_FLOW WF
       WHERE WFG.WORKFLOW_GROUP_ID = LNWFG
         AND WFG.WORK_FLOW_ID = WF.WORK_FLOW_ID
         AND WF.NEXT_STATUS = LNSTATUS
         AND WF.EXPORT_ERP = 1;

      IF LNCOUNTEXPORTERP > 0
      THEN
         UPDATE PART
            SET CHANGED_DATE = SYSDATE
          WHERE PART_NO = ASPARTNO;
      END IF;

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SETEXPORTTOERP;


   FUNCTION CHECKBOMHEADER(
      LRBOMHEADER                         IAPITYPE.BOMHEADERREC_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckBomHeader';
      LNHARMONIZED                  PLS_INTEGER;
      LNCOUNT                       PLS_INTEGER;
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM PART_PLANT
       WHERE PART_NO = LRBOMHEADER.PARTNO
         AND PLANT = LRBOMHEADER.PLANT
         AND OBSOLETE = 0;

      IF ( LNCOUNT = 0 )
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOPARTPLANT,
                                                    LRBOMHEADER.PARTNO,
                                                    LRBOMHEADER.PLANT );
      END IF;

      LNRETVAL := IAPISPECIFICATION.ISLOCALIZED( LRBOMHEADER.PARTNO,
                                                 LRBOMHEADER.REVISION,
                                                 LNHARMONIZED );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN LNRETVAL;
      END IF;

      
      IF     LNHARMONIZED = 1
         AND LRBOMHEADER.PLANT = IAPICONSTANT.PLANT_INTERNATIONAL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_HARMINTLBOM,
                                                    LRBOMHEADER.PARTNO,
                                                    LRBOMHEADER.REVISION );
      END IF;

      LNRETVAL :=
                IAPISPECIFICATION.VALIDATEPLANTPED( LRBOMHEADER.PARTNO,
                                                    LRBOMHEADER.REVISION,
                                                    LRBOMHEADER.PLANT,
                                                    LRBOMHEADER.PLANNEDEFFECTIVEDATE,
                                                    1 );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         IF LNRETVAL = IAPICONSTANTDBERROR.DBERR_SPECINPEDGROUP
         THEN
            LNRETVAL :=
               IAPIGENERAL.ADDERRORTOLIST( IAPICONSTANTDBERROR.DBERR_SPECINPEDGROUP,
                                           IAPIGENERAL.GETLASTERRORTEXT( ),
                                           GTERRORS,
                                           IAPICONSTANT.ERRORMESSAGE_WARNING );
         ELSE
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_INVALIDPED );
         END IF;
      END IF;

      IF    ( LRBOMHEADER.MINIMUMQUANTITY > LRBOMHEADER.QUANTITY )
         OR (      ( NOT( LRBOMHEADER.MAXIMUMQUANTITY IS NULL ) )
              AND ( LRBOMHEADER.MINIMUMQUANTITY > LRBOMHEADER.MAXIMUMQUANTITY ) )
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_INVALIDMINMAXQTY );
      END IF;

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CHECKBOMHEADER;


   FUNCTION ISRECURSIVE(
      ANUNIQUEID                 IN       IAPITYPE.ID_TYPE,
      ANMOPCOUNT                 IN       IAPITYPE.ID_TYPE,
      ANCURRENTSEQUENCE          IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.BOOLEAN_TYPE







   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsRecursive';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCHILDSEQUENCE               IAPITYPE.ID_TYPE;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LSPLANT                       IAPITYPE.PLANT_TYPE;
      LSPARENTPARTNO                IAPITYPE.PARTNO_TYPE;
      LNPARENTREVISION              IAPITYPE.REVISION_TYPE;
      LSPARENTPLANT                 IAPITYPE.PLANT_TYPE;
      LNPARENTSEQUENCE              IAPITYPE.ID_TYPE;
      LNRECURSIVE                   IAPITYPE.BOOLEAN_TYPE DEFAULT 0;
      LSSELECTSQL                   VARCHAR2( 1000 );
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ANCURRENTSEQUENCE = 10
      THEN
         RETURN 0;
      ELSE
         LSSELECTSQL :=
               ' SELECT COMPONENT_PART, '
            || ' component_revision rev, '
            || ' plant, '
            || ' ( SELECT MAX( sequence_no ) '
            || '    FROM itbomexplosion itexp2 '
            || '   WHERE BOM_EXP_NO = :anUniqueId '
            || '     AND MOP_SEQUENCE_NO = :anMopCount '
            || '     AND itexp2.BOM_LEVEL =   itexp1.bom_level - 1 '
            || '     AND itexp2.sequence_no < itexp1.sequence_no ) pSeq '
            || ' FROM itbomexplosion itexp1 '
            || ' WHERE BOM_EXP_NO = :anUniqueId  '
            || ' AND MOP_SEQUENCE_NO = :anMopCount '
            || ' AND SEQUENCE_NO = :anCurrentSequence ';

         EXECUTE IMMEDIATE LSSELECTSQL
                      INTO LSPARTNO,
                           LNREVISION,
                           LSPLANT,
                           LNPARENTSEQUENCE
                     USING ANUNIQUEID,
                           ANMOPCOUNT,
                           ANUNIQUEID,
                           ANMOPCOUNT,
                           ANCURRENTSEQUENCE;
      END IF;

      LOOP
         LNCHILDSEQUENCE := LNPARENTSEQUENCE;
         LSSELECTSQL :=
               ' SELECT COMPONENT_PART, '
            || ' component_revision rev, '
            || ' plant, '
            || ' ( SELECT MAX( sequence_no ) '
            || '    FROM itbomexplosion itexp2 '
            || '   WHERE BOM_EXP_NO = :anUniqueId '
            || '     AND MOP_SEQUENCE_NO = :anMopCount '
            || '     AND itexp2.BOM_LEVEL =   itexp1.bom_level - 1 '
            || '     AND itexp2.sequence_no < itexp1.sequence_no ) pSeq '
            || ' FROM itbomexplosion itexp1 '
            || ' WHERE BOM_EXP_NO = :anUniqueId '
            || ' AND MOP_SEQUENCE_NO = :anMopCount '
            || ' AND SEQUENCE_NO = :lnChildSequence ';

         EXECUTE IMMEDIATE LSSELECTSQL
                      INTO LSPARENTPARTNO,
                           LNPARENTREVISION,
                           LSPARENTPLANT,
                           LNPARENTSEQUENCE
                     USING ANUNIQUEID,
                           ANMOPCOUNT,
                           ANUNIQUEID,
                           ANMOPCOUNT,
                           LNCHILDSEQUENCE;

         IF     LSPARTNO = LSPARENTPARTNO
            AND LNREVISION = LNPARENTREVISION
            AND LSPLANT = LSPARENTPLANT
         THEN
            LNRECURSIVE := 1;
            EXIT;
         END IF;

         IF LNPARENTSEQUENCE IS NULL
         THEN
            EXIT;
         END IF;
      END LOOP;

      RETURN LNRECURSIVE;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
         RAISE_APPLICATION_ERROR( -20000,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
   END ISRECURSIVE;


   FUNCTION EXPLODENUTRITIONAL(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      AQERRORS                   IN OUT   IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExplodeNutritional';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSUOM                         IAPITYPE.DESCRIPTION_TYPE;
      LNUOMMISMATCH                 IAPITYPE.NUMVAL_TYPE;
      LNBOMLEVELCURRENT             IAPITYPE.SEQUENCE_TYPE;
      LBADDALLOWED                  BOOLEAN;

      CURSOR C_NUT(
         ANUNIQUEID                 IN       NUMBER )
      IS
         SELECT   BOM_EXP_NO,
                  MOP_SEQUENCE_NO,
                  SEQUENCE_NO,
                  COMPONENT_PART,
                  COMPONENT_REVISION,
                  CALC_QTY,
                  UOM,
                  CONV_FACTOR,
                  TO_UNIT,
                  CALC_QTY_WITH_SCRAP,
                  BOM_LEVEL,
                  ACCESS_STOP,
                  RECURSIVE_STOP,
                  INGREDIENT
             FROM ITBOMEXPLOSION
            WHERE BOM_EXP_NO = ANUNIQUEID
         ORDER BY MOP_SEQUENCE_NO,
                  SEQUENCE_NO;
   BEGIN
      LNRETVAL := GETDOMINANTUOM( ANUNIQUEID,
                                  LSUOM );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LBADDALLOWED := TRUE;
      LNBOMLEVELCURRENT := 0;

      FOR L_ROW IN C_NUT( ANUNIQUEID )
      LOOP
         IF NOT LBADDALLOWED
         THEN
            IF L_ROW.BOM_LEVEL <= LNBOMLEVELCURRENT
            THEN
               LBADDALLOWED := TRUE;
               LNBOMLEVELCURRENT := L_ROW.BOM_LEVEL;
            END IF;
         END IF;

         IF LBADDALLOWED
         THEN
            IF L_ROW.INGREDIENT = 2
            THEN
               LBADDALLOWED := FALSE;
               LNBOMLEVELCURRENT := L_ROW.BOM_LEVEL;
            END IF;
         END IF;

         IF LBADDALLOWED
         THEN
            INSERT INTO ITNUTPATH
                        ( BOM_EXP_NO,
                          MOP_SEQUENCE_NO,
                          SEQUENCE_NO,
                          PART_NO,
                          REVISION,
                          DISPLAY_NAME,
                          BASE_QTY,
                          UOM,
                          CONV_FACTOR,
                          TO_UNIT,
                          CALC_QTY_WITH_SCRAP,
                          BOM_LEVEL,
                          ACCESS_STOP,
                          RECURSIVE_STOP,
                          USE )
                 VALUES ( L_ROW.BOM_EXP_NO,
                          L_ROW.MOP_SEQUENCE_NO,
                          L_ROW.SEQUENCE_NO,
                          L_ROW.COMPONENT_PART,
                          L_ROW.COMPONENT_REVISION,
                             L_ROW.COMPONENT_PART
                          || ' ['
                          || L_ROW.COMPONENT_REVISION
                          || ']',
                          L_ROW.CALC_QTY,
                          L_ROW.UOM,
                          L_ROW.CONV_FACTOR,
                          L_ROW.TO_UNIT,
                          L_ROW.CALC_QTY_WITH_SCRAP,
                          L_ROW.BOM_LEVEL,
                          L_ROW.ACCESS_STOP,
                          L_ROW.RECURSIVE_STOP,
                          F_IS_LOWESTLEVEL( L_ROW.BOM_EXP_NO,
                                            L_ROW.MOP_SEQUENCE_NO,
                                            L_ROW.SEQUENCE_NO ) );
         END IF;
      END LOOP;

      
      
      
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXPLODENUTRITIONAL;

   
   FUNCTION GETINGREDIENTTYPE(
      ASPARTNO                            IAPITYPE.PARTNO_TYPE,
      ANREVISION                          IAPITYPE.REVISION_TYPE,
      ANEXPLOSIONTYPE                     PLS_INTEGER )
      RETURN PLS_INTEGER












   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetIngredientType';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       PLS_INTEGER := 0;

      LNREVISION                    IAPITYPE.REVISION_TYPE;

   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      LNREVISION := ANREVISION;

      
      IF    LNREVISION IS NULL
         OR LNREVISION = 0
      THEN
         SELECT MAX( REVISION )
           INTO LNREVISION
           FROM SPECIFICATION_HEADER
          WHERE PART_NO = ASPARTNO;
      END IF;


      IF ANEXPLOSIONTYPE IN( IAPICONSTANT.EXPLOSION_INGREDIENT, IAPICONSTANT.EXPLOSION_INGREDIENTMIX )
      THEN
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM SPECIFICATION_SECTION
          WHERE PART_NO = ASPARTNO

            AND REVISION = LNREVISION


            AND TYPE = IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST;
      END IF;

      IF LNCOUNT > 0
      THEN
         RETURN 1;
      ELSE
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM SPECIFICATION_HEADER
          WHERE PART_NO = ASPARTNO

            AND REVISION = LNREVISION


            AND CLASS3_ID IN( SELECT CLASS
                               FROM CLASS3
                              WHERE TYPE = IAPICONSTANT.SPECTYPEGROUP_INGREDIENT );
      END IF;

      IF LNCOUNT > 0
      THEN
         RETURN 1;
      ELSE
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM SPECIFICATION_HEADER
          WHERE PART_NO = ASPARTNO

            AND REVISION = LNREVISION


            AND CLASS3_ID IN( SELECT CLASS
                               FROM CLASS3

                             WHERE  TYPE IN( IAPICONSTANT.SPECTYPEGROUP_PACKAGING, IAPICONSTANT.SPECTYPEGROUP_ARTWORK ) );



         IF LNCOUNT > 0
         THEN
            RETURN 2;
         ELSE
            RETURN 0;
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
         RAISE_APPLICATION_ERROR( -20000,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
   END GETINGREDIENTTYPE;


   FUNCTION EXPLODEATTACHEDSPEC(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ANSEQUENCENO               IN OUT   IAPITYPE.SEQUENCE_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ADEXPLOSIONDATE            IN       IAPITYPE.DATE_TYPE,
      ANINCLUDEINDEVELOPMENT     IN       IAPITYPE.BOOLEAN_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      CURSOR LR_ATT
      IS
         SELECT ATTACHED_PART_NO,
                GETCOMPONENTREVISION( ATTACHED_PART_NO,
                                      DECODE( ATTACHED_REVISION,
                                              0, NULL,
                                              ATTACHED_REVISION ),
                                      NULL,   
                                      ADEXPLOSIONDATE,
                                      ANINCLUDEINDEVELOPMENT ) REVISION
           FROM ATTACHED_SPECIFICATION ATT
          WHERE ATT.PART_NO = ASPARTNO
            AND ATT.REVISION = ANREVISION;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExplodeAttachedSpec';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      FOR LC_ATT IN LR_ATT
      LOOP
         ANSEQUENCENO :=   ANSEQUENCENO
                         + 10;

         INSERT INTO ITATTEXPLOSION
                     ( BOM_EXP_NO,
                       MOP_SEQUENCE_NO,
                       SEQUENCE_NO,
                       ATT_PART,
                       ATT_REVISION,
                       DESCRIPTION,
                       PARENT_PART,
                       PARENT_REVISION,
                       PLANT,
                       ALTERNATIVE,
                       USAGE )
              VALUES ( ANUNIQUEID,
                       ANMOPSEQUENCENO,
                       ANSEQUENCENO,
                       LC_ATT.ATTACHED_PART_NO,
                       LC_ATT.REVISION,
                       F_SH_DESCR( 1,
                                   LC_ATT.ATTACHED_PART_NO,
                                   LC_ATT.REVISION ),
                       ASPARTNO,
                       ANREVISION,
                       ASPLANT,
                       ANALTERNATIVE,
                       ANUSAGE );
      END LOOP;

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXPLODEATTACHEDSPEC;

   FUNCTION EXPLODEATTACHEDSPECS(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ADEXPLOSIONDATE            IN       IAPITYPE.DATE_TYPE,
      ANINCLUDEINDEVELOPMENT     IN       IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      CURSOR LC_BOM
      IS
         SELECT   SEQUENCE_NO,
                  MOP_SEQUENCE_NO,
                  COMPONENT_PART,
                  COMPONENT_REVISION,
                  PLANT,
                  ALTERNATIVE,
                  USAGE,
                  ACCESS_STOP
             FROM ITBOMEXPLOSION
            WHERE BOM_EXP_NO = ANUNIQUEID
         ORDER BY MOP_SEQUENCE_NO,
                  SEQUENCE_NO;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExplodeAttachedSpecs';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       NUMBER;
      LNSEQUENCE                    IAPITYPE.SEQUENCE_TYPE := 0;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
   BEGIN
      
      
      
      
      
      
      
      
      FOR LR_ITEM IN LC_BOM
      LOOP
         LNRETVAL :=
            EXPLODEATTACHEDSPEC( ANUNIQUEID,
                                 LR_ITEM.MOP_SEQUENCE_NO,
                                 LNSEQUENCE,
                                 LR_ITEM.COMPONENT_PART,
                                 LR_ITEM.COMPONENT_REVISION,
                                 ADEXPLOSIONDATE,
                                 ANINCLUDEINDEVELOPMENT,
                                 LR_ITEM.PLANT,
                                 LR_ITEM.ALTERNATIVE,
                                 LR_ITEM.USAGE );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( LNRETVAL );
         END IF;
      END LOOP;

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM ITBOMEXPLOSION
       WHERE BOM_EXP_NO = ANUNIQUEID
         AND COMPONENT_REVISION IS NULL;

      
      
      IF LNCOUNT = 0
      THEN
         
         
         











         
         NULL;
         
      ELSE
         BEGIN
            SELECT COMPONENT_PART,
                   COMPONENT_REVISION
              INTO LSPARTNO,
                   LNREVISION
              FROM ITBOMEXPLOSION
             WHERE BOM_EXP_NO = ANUNIQUEID
               AND BOM_LEVEL = 0;

            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_EXPLOSIONINCOMPLETE,
                                                       LSPARTNO,
                                                       LNREVISION );
         EXCEPTION
            WHEN TOO_MANY_ROWS
            THEN
               RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                          LSMETHOD,
                                                          IAPICONSTANTDBERROR.DBERR_MOLEXPLOSIONINCOMPLETE );
         END;
      END IF;

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXPLODEATTACHEDSPECS;


   FUNCTION EXPLODEINGREDIENT(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ANSEQUENCENO               IN       IAPITYPE.SEQUENCE_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExplodeIngredient';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSINGREDIENTDESCRIPTION       IAPITYPE.STRING_TYPE;
      
      
      
      LNQUANTITY                    IAPITYPE.BOMQUANTITY_TYPE;
      
      LSINGREDIENTLEVEL             IAPITYPE.INGREDIENTLEVEL_TYPE;
      LSINGREDIENTCOMMENT           IAPITYPE.INGREDIENTCOMMENT_TYPE;
      LSSYNONYM                     IAPITYPE.STRING_TYPE;
      LNACTIVEINGREDIENT            IAPITYPE.BOOLEAN_TYPE;
      LNINGREDIENT                  IAPITYPE.ID_TYPE;
      LNINGREDIENTREVISION          IAPITYPE.REVISION_TYPE;
      LNRECFAC                      IAPITYPE.RECONSTITUTIONFACTOR_TYPE;
      LNPID                         IAPITYPE.ID_TYPE;
      LNSYNONYM                     IAPITYPE.ID_TYPE;
      LNSYNONYMREVISION             IAPITYPE.REVISION_TYPE;
      LNINGREDIENTSEQUENCENO        IAPITYPE.SEQUENCE_TYPE DEFAULT 0;
      LNHIERLEVEL                   PLS_INTEGER;
      LNDECLARE                     IAPITYPE.BOOLEAN_TYPE;

      CURSOR LREC_ING_LIST
      IS
         SELECT F_ING_DESCR( 1,
                             INGREDIENT,
                             INGREDIENT_REV ) ING_DESCRIPTION,
                QUANTITY,
                ING_LEVEL,
                ING_COMMENT,
                ACTIV_IND,
                F_SYN_DESCR( 1,
                             ING_SYNONYM,
                             ING_SYNONYM_REV ),
                INGREDIENT,
                INGREDIENT_REV,
                RECFAC,
                PID,
                HIER_LEVEL,
                ING_SYNONYM,
                ING_SYNONYM_REV,
                INGDECLARE
           FROM SPECIFICATION_ING
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PID = 0;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      OPEN LREC_ING_LIST;

      FETCH LREC_ING_LIST
       INTO LSINGREDIENTDESCRIPTION,
            LNQUANTITY,
            LSINGREDIENTLEVEL,
            LSINGREDIENTCOMMENT,
            LNACTIVEINGREDIENT,
            LSSYNONYM,
            LNINGREDIENT,
            LNINGREDIENTREVISION,
            LNRECFAC,
            LNPID,
            LNHIERLEVEL,
            LNSYNONYM,
            LNSYNONYMREVISION,
            LNDECLARE;

      IF LREC_ING_LIST%FOUND
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 ASPARTNO
                              || ' has an ingredient list',
                              IAPICONSTANT.INFOLEVEL_1 );

         WHILE LREC_ING_LIST%FOUND
         LOOP
            LNINGREDIENTSEQUENCENO :=   LNINGREDIENTSEQUENCENO
                                      + 10;

            
            INSERT INTO ITINGEXPLOSION
                        ( BOM_EXP_NO,
                          MOP_SEQUENCE_NO,
                          SEQUENCE_NO,
                          ING_SEQUENCE_NO,
                          BOM_LEVEL,
                          INGREDIENT,
                          REVISION,
                          DESCRIPTION,
                          ING_QTY,
                          ING_LEVEL,
                          ING_COMMENT,
                          PID,
                          HIER_LEVEL,
                          RECFAC,
                          ING_SYNONYM,
                          ING_SYNONYM_REV,
                          ACTIVE,
                          COMPONENT_PART_NO,
                          COMPONENT_REVISION,
                          COMPONENT_DESCRIPTION,
                          COMPONENT_PLANT,
                          COMPONENT_ALTERNATIVE,
                          COMPONENT_USAGE,
                          COMPONENT_CALC_QTY,
                          COMPONENT_UOM,
                          COMPONENT_CONV_FACTOR,
                          COMPONENT_TO_UNIT,
                          INGDECLARE )
               SELECT BOM_EXP_NO,
                      MOP_SEQUENCE_NO,
                      SEQUENCE_NO,
                      LNINGREDIENTSEQUENCENO,
                      BOM_LEVEL,
                      LNINGREDIENT,
                      LNINGREDIENTREVISION,
                      LSINGREDIENTDESCRIPTION,
                      LNQUANTITY,
                      LSINGREDIENTLEVEL,
                      LSINGREDIENTCOMMENT,
                      LNPID,
                      LNHIERLEVEL,
                      LNRECFAC,
                      LNSYNONYM,
                      LNSYNONYMREVISION,
                      LNACTIVEINGREDIENT,
                      ASPARTNO,
                      ANREVISION,
                      DESCRIPTION,
                      PLANT,
                      ALTERNATIVE,
                      USAGE,
                      CALC_QTY,
                      UOM,
                      CONV_FACTOR,
                      TO_UNIT,
                      LNDECLARE
                 FROM ITBOMEXPLOSION
                WHERE BOM_EXP_NO = ANUNIQUEID
                  AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                  AND SEQUENCE_NO = ANSEQUENCENO;

            
            FETCH LREC_ING_LIST
             INTO LSINGREDIENTDESCRIPTION,
                  LNQUANTITY,
                  LSINGREDIENTLEVEL,
                  LSINGREDIENTCOMMENT,
                  LNACTIVEINGREDIENT,
                  LSSYNONYM,
                  LNINGREDIENT,
                  LNINGREDIENTREVISION,
                  LNRECFAC,
                  LNPID,
                  LNHIERLEVEL,
                  LNSYNONYM,
                  LNSYNONYMREVISION,
                  LNDECLARE;
         END LOOP;
      ELSE
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 ASPARTNO
                              || ' does not have an ingredient list',
                              IAPICONSTANT.INFOLEVEL_1 );
         LNINGREDIENTSEQUENCENO :=   LNINGREDIENTSEQUENCENO
                                   + 10;

         
         INSERT INTO ITINGEXPLOSION
                     ( BOM_EXP_NO,
                       MOP_SEQUENCE_NO,
                       SEQUENCE_NO,
                       ING_SEQUENCE_NO,
                       BOM_LEVEL,
                       INGREDIENT,
                       REVISION,
                       DESCRIPTION,
                       ING_QTY,
                       ING_LEVEL,
                       ING_COMMENT,
                       PID,
                       HIER_LEVEL,
                       RECFAC,
                       ING_SYNONYM,
                       ING_SYNONYM_REV,
                       ACTIVE,
                       COMPONENT_PART_NO,
                       COMPONENT_REVISION,
                       COMPONENT_DESCRIPTION,
                       COMPONENT_PLANT,
                       COMPONENT_ALTERNATIVE,
                       COMPONENT_USAGE,
                       COMPONENT_CALC_QTY,
                       COMPONENT_UOM,
                       COMPONENT_CONV_FACTOR,
                       COMPONENT_TO_UNIT,
                       INGDECLARE )
            SELECT BOM_EXP_NO,
                   MOP_SEQUENCE_NO,
                   SEQUENCE_NO,
                   LNINGREDIENTSEQUENCENO,
                   BOM_LEVEL,
                   -SEQUENCE_NO,   
                   -1,   
                   DESCRIPTION,   
                   100,   
                   LSINGREDIENTLEVEL,
                   LSINGREDIENTCOMMENT,
                   LNPID,
                   LNHIERLEVEL,
                   LNRECFAC,
                   LNSYNONYM,
                   LNSYNONYMREVISION,
                   0,   
                   ASPARTNO,
                   ANREVISION,
                   DESCRIPTION,
                   PLANT,
                   ALTERNATIVE,
                   USAGE,
                   CALC_QTY,
                   UOM,
                   CONV_FACTOR,
                   TO_UNIT,
                   LNDECLARE
              FROM ITBOMEXPLOSION
             WHERE BOM_EXP_NO = ANUNIQUEID
               AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
               AND SEQUENCE_NO = ANSEQUENCENO;
      END IF;

      
      CLOSE LREC_ING_LIST;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         IF LREC_ING_LIST%ISOPEN
         THEN
            CLOSE LREC_ING_LIST;
         END IF;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXPLODEINGREDIENT;

   
   FUNCTION EXPLODEINGREDIENTS(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LNBOMLEVELCURRENT             IAPITYPE.SEQUENCE_TYPE;
      LSCOMPONENTPARTCURRENT        IAPITYPE.PARTNO_TYPE;
      LNCOMPONENTREVISIONCURRENT    IAPITYPE.REVISION_TYPE;
      LNMOPSEQUENCENOCURRENT        IAPITYPE.SEQUENCE_TYPE;
      LNSEQUENCENOCURRENT           IAPITYPE.SEQUENCE_TYPE;
      LNSPECTYPEGROUPCURRENT        CLASS3.TYPE%TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExplodeIngredients';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       PLS_INTEGER;
      LBINGREDIENT                  IAPITYPE.BOOLEAN_TYPE;

      CURSOR C_LOWEST(
         ANUNIQUEID                 IN       NUMBER )
      IS
         SELECT   BOM_LEVEL BOM_LEVEL_NEXT,
                  COMPONENT_PART COMPONENT_PART_NEXT,
                  COMPONENT_REVISION COMPONENT_REVISION_NEXT,
                  SEQUENCE_NO SEQUENCE_NO_NEXT,
                  MOP_SEQUENCE_NO MOP_SEQUENCE_NO_NEXT,
                  TYPE PART_TYPE,
                  ACCESS_STOP,
                  INGREDIENT ISINGREDIENT
             FROM ITBOMEXPLOSION,
                  CLASS3
            WHERE BOM_EXP_NO = ANUNIQUEID
              AND CLASS(+) = PART_TYPE
              AND ACCESS_STOP = 0
         ORDER BY MOP_SEQUENCE_NO,
                  SEQUENCE_NO;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNBOMLEVELCURRENT := 0;

      
      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM ITBOMEXPLOSION
       WHERE BOM_EXP_NO = ANUNIQUEID
         AND COMPONENT_REVISION IS NULL;

      IF LNCOUNT > 0
      THEN
         BEGIN
            SELECT COMPONENT_PART,
                   COMPONENT_REVISION
              INTO LSPARTNO,
                   LNREVISION
              FROM ITBOMEXPLOSION
             WHERE BOM_EXP_NO = ANUNIQUEID
               AND BOM_LEVEL = 0;

            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_EXPLOSIONINCOMPLETE,
                                                       LSPARTNO,
                                                       LNREVISION );
         EXCEPTION
            WHEN TOO_MANY_ROWS
            THEN
               RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                          LSMETHOD,
                                                          IAPICONSTANTDBERROR.DBERR_MOLEXPLOSIONINCOMPLETE );
         END;
      END IF;

      FOR L_ROW IN C_LOWEST( ANUNIQUEID )
      LOOP
         
         
         

         IF L_ROW.BOM_LEVEL_NEXT <= LNBOMLEVELCURRENT
         THEN
            
            IF    ( LNSPECTYPEGROUPCURRENT = IAPICONSTANT.SPECTYPEGROUP_INGREDIENT )
               OR ( LBINGREDIENT = 1 )
            THEN
               LNRETVAL :=
                     EXPLODEINGREDIENT( ANUNIQUEID,
                                        LNMOPSEQUENCENOCURRENT,
                                        LNSEQUENCENOCURRENT,
                                        LSCOMPONENTPARTCURRENT,
                                        LNCOMPONENTREVISIONCURRENT );

               IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
               THEN
                  RETURN LNRETVAL;
               END IF;
            END IF;
         END IF;

         
         
         LBINGREDIENT := L_ROW.ISINGREDIENT;
         
         LNBOMLEVELCURRENT := L_ROW.BOM_LEVEL_NEXT;
         LNMOPSEQUENCENOCURRENT := L_ROW.MOP_SEQUENCE_NO_NEXT;
         LNSEQUENCENOCURRENT := L_ROW.SEQUENCE_NO_NEXT;
         LSCOMPONENTPARTCURRENT := L_ROW.COMPONENT_PART_NEXT;
         LNCOMPONENTREVISIONCURRENT := L_ROW.COMPONENT_REVISION_NEXT;
         LNSPECTYPEGROUPCURRENT := L_ROW.PART_TYPE;
      END LOOP;

      IF    ( LNSPECTYPEGROUPCURRENT = IAPICONSTANT.SPECTYPEGROUP_INGREDIENT )
         OR ( LBINGREDIENT = 1 )
      THEN
         LNRETVAL := EXPLODEINGREDIENT( ANUNIQUEID,
                                        LNMOPSEQUENCENOCURRENT,
                                        LNSEQUENCENOCURRENT,
                                        LSCOMPONENTPARTCURRENT,
                                        LNCOMPONENTREVISIONCURRENT );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( LNRETVAL );
         END IF;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXPLODEINGREDIENTS;


   FUNCTION GETUOMBASE(
      ANUOMID                    IN       IAPITYPE.ID_TYPE,
      ABSAMETYPE                 IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1 )
      RETURN IAPITYPE.ID_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUomBase';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNUOMBASEID                   IAPITYPE.ID_TYPE;
   BEGIN
      IF ( 1 = ABSAMETYPE )
      THEN
         LNRETVAL := IAPIUOMGROUPS.GETUOMBASEGROUPSAMETYPE( ANUOMID,
                                                            LNUOMBASEID );
      ELSE
         LNRETVAL := IAPIUOMGROUPS.GETUOMBASEGROUPOTHERTYPE( ANUOMID,
                                                             LNUOMBASEID );
      END IF;

      IF LNRETVAL <>( IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         LNUOMBASEID := NULL;
      END IF;

      RETURN LNUOMBASEID;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( NULL );
   END GETUOMBASE;


   PROCEDURE APPLYAUTOCALC(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE )
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ApplyAutoCalc';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      
      LNCALCQUANTITY                IAPITYPE.BOMQUANTITY_TYPE;
      LNCALCCONVFACTOR              IAPITYPE.BOMCONVFACTOR_TYPE;
   BEGIN
      
      APPLYAUTOCALC( ASPARTNO,
                     ANREVISION,
                     ASPLANT,
                     ANUSAGE,
                     ANALTERNATIVE,
                     LNCALCQUANTITY,
                     LNCALCCONVFACTOR );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
         RAISE_APPLICATION_ERROR( -20000,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
   END APPLYAUTOCALC;


   PROCEDURE APPLYAUTOCALC(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANCALCQUANTITY             OUT      IAPITYPE.BOMQUANTITY_TYPE,
      ANCALCCONVFACTOR           OUT      IAPITYPE.BOMCONVFACTOR_TYPE )
   IS
      CURSOR LQBOMHEADER
      IS
         SELECT CALC_FLAG,
                BASE_QUANTITY,
                CONV_FACTOR,
                TO_UNIT
           FROM BOM_HEADER
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PLANT = ASPLANT
            AND ALTERNATIVE = ANALTERNATIVE
            AND BOM_USAGE = ANUSAGE;

      CURSOR LQPART
      IS
         SELECT BASE_UOM
           FROM PART
          WHERE PART_NO = ASPARTNO;

      CURSOR LQSUMQTYQ(
         ASBASEUOM                  IN       IAPITYPE.BASEUOM_TYPE )
      IS
         SELECT SUM(    (   F_CONVERT_BASE( A.QUANTITY,
                                            IAPIUOMGROUPS.GETUOMID( A.UOM ),
                                            IAPIUOMGROUPS.GETUOMID( ASBASEUOM ) )   
                          * NVL( A.YIELD,
                                 1 ) )
                     / 100 ) QUANTITY
           FROM BOM_ITEM A,
                BOM_HEADER B
          WHERE A.PART_NO = ASPARTNO
            AND A.REVISION = ANREVISION
            AND A.PLANT = ASPLANT
            AND A.BOM_USAGE = ANUSAGE
            AND A.ALTERNATIVE = ANALTERNATIVE
            AND A.PART_NO = B.PART_NO
            AND A.REVISION = B.REVISION
            AND A.PLANT = B.PLANT
            AND A.ALTERNATIVE = B.ALTERNATIVE
            AND A.BOM_USAGE = B.BOM_USAGE
            AND GETUOMDESCRIPTION( A.COMPONENT_PART,
                                   A.COMPONENT_REVISION,
                                   A.COMPONENT_PLANT,
                                   IAPISPECIFICATIONBOM.GETUOMBASE( IAPIUOMGROUPS.GETUOMID( A.UOM ) ),
                                   A.PART_NO,
                                   A.REVISION ) =
                   GETUOMDESCRIPTION
                      ( A.COMPONENT_PART,
                        A.COMPONENT_REVISION,
                        A.COMPONENT_PLANT,
                        IAPISPECIFICATIONBOM.GETUOMBASE( IAPIUOMGROUPS.GETUOMID( ASBASEUOM ) ),
                        A.PART_NO,
                        A.REVISION )   
            AND A.CALC_FLAG IN( 'B', 'Q' );

      CURSOR LQSUMQTYC
      IS
         SELECT SUM(    (   A.QUANTITY
                          * NVL( A.YIELD,
                                 1 ) )
                     / 100 ) QUANTITY
           FROM BOM_ITEM A,
                BOM_HEADER B
          WHERE A.PART_NO = ASPARTNO
            AND A.REVISION = ANREVISION
            AND A.PLANT = ASPLANT
            AND A.BOM_USAGE = ANUSAGE
            AND A.ALTERNATIVE = ANALTERNATIVE
            AND A.PART_NO = B.PART_NO
            AND A.REVISION = B.REVISION
            AND A.PLANT = B.PLANT
            AND A.ALTERNATIVE = B.ALTERNATIVE
            AND A.BOM_USAGE = B.BOM_USAGE
            AND A.UOM = NVL( B.TO_UNIT,
                             '-1' )
            AND A.CALC_FLAG IN( 'B', 'C' );

      CURSOR LQSUMCONVQTYQ(
         ASBASEUOM                  IN       IAPITYPE.BASEUOM_TYPE )
      IS
         SELECT SUM(    (    (   A.QUANTITY
                               * NVL( A.CONV_FACTOR,
                                      1 ) )
                          * NVL( A.YIELD,
                                 1 ) )
                     / 100 ) QUANTITY
           FROM BOM_ITEM A,
                BOM_HEADER B
          WHERE A.PART_NO = ASPARTNO
            AND A.REVISION = ANREVISION
            AND A.PLANT = ASPLANT
            AND A.BOM_USAGE = ANUSAGE
            AND A.ALTERNATIVE = ANALTERNATIVE
            AND A.PART_NO = B.PART_NO
            AND A.REVISION = B.REVISION
            AND A.PLANT = B.PLANT
            AND A.ALTERNATIVE = B.ALTERNATIVE
            AND A.BOM_USAGE = B.BOM_USAGE
            AND NVL( A.TO_UNIT,
                     '-1' ) = ASBASEUOM
            AND A.CALC_FLAG IN( 'B', 'Q' );

      CURSOR LQSUMCONVQTYC
      IS
         SELECT SUM(    (    (   A.QUANTITY
                               * NVL( A.CONV_FACTOR,
                                      1 ) )
                          * NVL( A.YIELD,
                                 1 ) )
                     / 100 ) QUANTITY
           FROM BOM_ITEM A,
                BOM_HEADER B
          WHERE A.PART_NO = ASPARTNO
            AND A.REVISION = ANREVISION
            AND A.PLANT = ASPLANT
            AND A.BOM_USAGE = ANUSAGE
            AND A.ALTERNATIVE = ANALTERNATIVE
            AND A.PART_NO = B.PART_NO
            AND A.REVISION = B.REVISION
            AND A.PLANT = B.PLANT
            AND A.ALTERNATIVE = B.ALTERNATIVE
            AND A.BOM_USAGE = B.BOM_USAGE
            AND NVL( A.TO_UNIT,
                     '-1' ) = NVL( B.TO_UNIT,
                                   '-1' )
            AND A.CALC_FLAG IN( 'B', 'C' );

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ApplyAutoCalc';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNQUANTITY                    IAPITYPE.BOMQUANTITY_TYPE;
      LNCONVQUANTITY                IAPITYPE.BOMQUANTITY_TYPE;
      LSCALCFLAG                    IAPITYPE.BOMITEMCALCFLAG_TYPE;
      LNCALCQUANTITY                IAPITYPE.BOMQUANTITY_TYPE;
      LNCALCCONVFACTOR              IAPITYPE.BOMCONVFACTOR_TYPE;
      LNORGQUANTITY                 IAPITYPE.BOMQUANTITY_TYPE;
      LNORGCONVFACTOR               IAPITYPE.BOMCONVFACTOR_TYPE;
      LSCONVUOM                     IAPITYPE.BASEUOM_TYPE;
      LNCALCCONVQUNATITY            IAPITYPE.BOMQUANTITY_TYPE;
      LSBASEUOM                     IAPITYPE.BASEUOM_TYPE;
      LNCONVFACTOR                  IAPITYPE.BOMCONVFACTOR_TYPE;
      LEDONOTHING                   EXCEPTION;
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN LQBOMHEADER;

      FETCH LQBOMHEADER
       INTO LSCALCFLAG,
            LNORGQUANTITY,
            LNORGCONVFACTOR,
            LSCONVUOM;

      CLOSE LQBOMHEADER;

      OPEN LQPART;

      FETCH LQPART
       INTO LSBASEUOM;

      CLOSE LQPART;

      IF LSCALCFLAG = 'N'
      THEN
         
         RAISE LEDONOTHING;
      ELSIF LSCALCFLAG = 'Q'   
      THEN
         OPEN LQSUMQTYQ( LSBASEUOM );

         FETCH LQSUMQTYQ
          INTO LNQUANTITY;

         CLOSE LQSUMQTYQ;

         
         OPEN LQSUMCONVQTYQ( LSBASEUOM );

         FETCH LQSUMCONVQTYQ
          INTO LNCONVQUANTITY;

         CLOSE LQSUMCONVQTYQ;

         
         
         LNCALCQUANTITY :=   NVL( LNQUANTITY,
                                  0 )
                           + NVL( LNCONVQUANTITY,
                                  0 );
         
         LNCALCCONVQUNATITY :=   LNORGQUANTITY
                               * NVL( LNORGCONVFACTOR,
                                      1 );

         IF ( LNCALCQUANTITY = 0 )
         THEN
            LNCALCQUANTITY := 1;
         END IF;

         
         LNCALCCONVFACTOR :=   LNCALCCONVQUNATITY
                             / LNCALCQUANTITY;
      ELSIF LSCALCFLAG = 'C'
      THEN
         
         
         LNCALCQUANTITY := LNORGQUANTITY;

         
         OPEN LQSUMCONVQTYC;

         FETCH LQSUMCONVQTYC
          INTO LNCONVQUANTITY;

         CLOSE LQSUMCONVQTYC;

         
         OPEN LQSUMQTYC;

         FETCH LQSUMQTYC
          INTO LNQUANTITY;

         CLOSE LQSUMQTYC;

         
         LNCALCCONVQUNATITY :=   NVL( LNQUANTITY,
                                      0 )
                               + NVL( LNCONVQUANTITY,
                                      0 );

         
         IF ( LNCALCQUANTITY = 0 )
         THEN
            LNCALCQUANTITY := 1;
         END IF;

         LNCALCCONVFACTOR :=   LNCALCCONVQUNATITY
                             / LNCALCQUANTITY;
      
      ELSIF LSCALCFLAG = 'B'
      THEN
         
         OPEN LQSUMQTYQ( LSBASEUOM );

         FETCH LQSUMQTYQ
          INTO LNQUANTITY;

         CLOSE LQSUMQTYQ;

         
         OPEN LQSUMCONVQTYQ( LSBASEUOM );

         FETCH LQSUMCONVQTYQ
          INTO LNCONVQUANTITY;

         CLOSE LQSUMCONVQTYQ;

         
         LNCALCQUANTITY :=   NVL( LNQUANTITY,
                                  0 )
                           + NVL( LNCONVQUANTITY,
                                  0 );

         

         
         OPEN LQSUMCONVQTYC;

         FETCH LQSUMCONVQTYC
          INTO LNCONVQUANTITY;

         CLOSE LQSUMCONVQTYC;

         
         OPEN LQSUMQTYC;

         FETCH LQSUMQTYC
          INTO LNQUANTITY;

         CLOSE LQSUMQTYC;

         
         LNCALCCONVQUNATITY :=   NVL( LNQUANTITY,
                                      0 )
                               + NVL( LNCONVQUANTITY,
                                      0 );

         
         IF ( LNCALCQUANTITY = 0 )
         THEN
            LNCALCQUANTITY := 1;
         END IF;

         LNCALCCONVFACTOR :=   LNCALCCONVQUNATITY
                             / LNCALCQUANTITY;
      
      ELSE
         RAISE LEDONOTHING;
      END IF;

      

      
      UPDATE BOM_HEADER
         SET BASE_QUANTITY = NVL( LNCALCQUANTITY,
                                  1 ),   
             CONV_FACTOR = NULL
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANT
         AND ALTERNATIVE = ANALTERNATIVE
         AND BOM_USAGE = ANUSAGE;

      UPDATE BOM_HEADER
         SET CONV_FACTOR = LNCALCCONVFACTOR
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANT
         AND ALTERNATIVE = ANALTERNATIVE
         AND BOM_USAGE = ANUSAGE
         AND TO_UNIT IS NOT NULL;

      ANCALCQUANTITY := LNCALCQUANTITY;
      ANCALCCONVFACTOR := LNCALCCONVFACTOR;
   EXCEPTION
      WHEN LEDONOTHING
      THEN
         NULL;
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
         RAISE_APPLICATION_ERROR( -20000,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
   END APPLYAUTOCALC;

   FUNCTION GETFIRSTINTERNALBOMITEM(
      AQBOMITEM                  OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS









      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetFirstInternalBomItem';
      LTGETBOMITEM                  BOMITEMTABLE_TYPE := BOMITEMTABLE_TYPE( );
      LRBOMITEM                     IAPITYPE.BOMITEMREC_TYPE;
      LRGETBOMITEM                  BOMITEMRECORD_TYPE
         := BOMITEMRECORD_TYPE( NULL,
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
   BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Begin',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( GTBOMITEMS.COUNT > 0 )
      THEN
         LTGETBOMITEM.DELETE;
         LRBOMITEM := GTBOMITEMS( 0 );
         LRGETBOMITEM.PARTNO := LRBOMITEM.PARTNO;
         LRGETBOMITEM.REVISION := LRBOMITEM.REVISION;
         LRGETBOMITEM.PLANT := LRBOMITEM.PLANT;
         LRGETBOMITEM.ALTERNATIVE := LRBOMITEM.ALTERNATIVE;
         LRGETBOMITEM.BOMUSAGE := LRBOMITEM.BOMUSAGE;
         LRGETBOMITEM.ITEMNUMBER := LRBOMITEM.ITEMNUMBER;
         LRGETBOMITEM.ALTERNATIVEGROUP := LRBOMITEM.ALTERNATIVEGROUP;
         LRGETBOMITEM.ALTERNATIVEPRIORITY := LRBOMITEM.ALTERNATIVEPRIORITY;
         LRGETBOMITEM.COMPONENTPARTNO := LRBOMITEM.COMPONENTPARTNO;
         LRGETBOMITEM.COMPONENTREVISION := LRBOMITEM.COMPONENTREVISION;
         LRGETBOMITEM.COMPONENTDESCRIPTION := LRBOMITEM.COMPONENTDESCRIPTION;
         LRGETBOMITEM.COMPONENTPLANT := LRBOMITEM.COMPONENTPLANT;
         LRGETBOMITEM.PARTSOURCE := LRBOMITEM.PARTSOURCE;
         LRGETBOMITEM.PARTTYPEGROUP := LRBOMITEM.PARTTYPEGROUP;
         LRGETBOMITEM.QUANTITY := LRBOMITEM.QUANTITY;
         LRGETBOMITEM.UOM := LRBOMITEM.UOM;
         LRGETBOMITEM.CONVERSIONFACTOR := LRBOMITEM.CONVERSIONFACTOR;
         LRGETBOMITEM.CONVERTEDUOM := LRBOMITEM.CONVERTEDUOM;
         LRGETBOMITEM.YIELD := LRBOMITEM.YIELD;
         LRGETBOMITEM.ASSEMBLYSCRAP := LRBOMITEM.ASSEMBLYSCRAP;
         LRGETBOMITEM.COMPONENTSCRAP := LRBOMITEM.COMPONENTSCRAP;
         LRGETBOMITEM.LEADTIMEOFFSET := LRBOMITEM.LEADTIMEOFFSET;
         LRGETBOMITEM.RELEVANCYTOCOSTING := LRBOMITEM.RELEVANCYTOCOSTING;
         LRGETBOMITEM.BULKMATERIAL := LRBOMITEM.BULKMATERIAL;
         LRGETBOMITEM.ITEMCATEGORY := LRBOMITEM.ITEMCATEGORY;
         LRGETBOMITEM.ISSUELOCATION := LRBOMITEM.ISSUELOCATION;
         LRGETBOMITEM.CALCULATIONMODE := LRBOMITEM.CALCULATIONMODE;
         LRGETBOMITEM.BOMITEMTYPE := LRBOMITEM.BOMITEMTYPE;
         LRGETBOMITEM.OPERATIONALSTEP := LRBOMITEM.OPERATIONALSTEP;
         LRGETBOMITEM.MINIMUMQUANTITY := LRBOMITEM.MINIMUMQUANTITY;
         LRGETBOMITEM.MAXIMUMQUANTITY := LRBOMITEM.MAXIMUMQUANTITY;
         LRGETBOMITEM.FIXEDQUANTITY := LRBOMITEM.FIXEDQUANTITY;
         LRGETBOMITEM.CODE := LRBOMITEM.CODE;
         LRGETBOMITEM.TEXT1 := LRBOMITEM.TEXT1;
         LRGETBOMITEM.TEXT2 := LRBOMITEM.TEXT2;
         LRGETBOMITEM.TEXT3 := LRBOMITEM.TEXT3;
         LRGETBOMITEM.TEXT4 := LRBOMITEM.TEXT4;
         LRGETBOMITEM.TEXT5 := LRBOMITEM.TEXT5;
         LRGETBOMITEM.NUMERIC1 := LRBOMITEM.NUMERIC1;
         LRGETBOMITEM.NUMERIC2 := LRBOMITEM.NUMERIC2;
         LRGETBOMITEM.NUMERIC3 := LRBOMITEM.NUMERIC3;
         LRGETBOMITEM.NUMERIC4 := LRBOMITEM.NUMERIC4;
         LRGETBOMITEM.NUMERIC5 := LRBOMITEM.NUMERIC5;
         LRGETBOMITEM.BOOLEAN1 := LRBOMITEM.BOOLEAN1;
         LRGETBOMITEM.BOOLEAN2 := LRBOMITEM.BOOLEAN2;
         LRGETBOMITEM.BOOLEAN3 := LRBOMITEM.BOOLEAN3;
         LRGETBOMITEM.BOOLEAN4 := LRBOMITEM.BOOLEAN4;
         LRGETBOMITEM.DATE1 := LRBOMITEM.DATE1;
         LRGETBOMITEM.DATE2 := LRBOMITEM.DATE2;
         LRGETBOMITEM.CHARACTERISTIC1 := LRBOMITEM.CHARACTERISTIC1;
         LRGETBOMITEM.CHARACTERISTIC1REVISION := LRBOMITEM.CHARACTERISTIC1REVISION;
         LRGETBOMITEM.CHARACTERISTIC2 := LRBOMITEM.CHARACTERISTIC2;
         LRGETBOMITEM.CHARACTERISTIC2REVISION := LRBOMITEM.CHARACTERISTIC2REVISION;
         LRGETBOMITEM.CHARACTERISTIC3 := LRBOMITEM.CHARACTERISTIC3;
         LRGETBOMITEM.CHARACTERISTIC3REVISION := LRBOMITEM.CHARACTERISTIC3REVISION;
         LRGETBOMITEM.CHARACTERISTIC1DESCRIPTION := LRBOMITEM.CHARACTERISTIC1DESCRIPTION;
         LRGETBOMITEM.CHARACTERISTIC2DESCRIPTION := LRBOMITEM.CHARACTERISTIC2DESCRIPTION;
         LRGETBOMITEM.CHARACTERISTIC3DESCRIPTION := LRBOMITEM.CHARACTERISTIC3DESCRIPTION;
         LRGETBOMITEM.MAKEUP := LRBOMITEM.MAKEUP;
         LRGETBOMITEM.INTERNATIONALEQUIVALENT := LRBOMITEM.INTERNATIONALEQUIVALENT;
         LRGETBOMITEM.VIEWBOMACCESS := LRBOMITEM.VIEWBOMACCESS;
         LTGETBOMITEM.EXTEND;
         LTGETBOMITEM( LTGETBOMITEM.COUNT ) := LRGETBOMITEM;
      END IF;

      OPEN AQBOMITEM FOR
         SELECT *
           FROM TABLE( CAST( LTGETBOMITEM AS BOMITEMTABLE_TYPE ) );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   END GETFIRSTINTERNALBOMITEM;





   FUNCTION GETHEADERS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      AQHEADERS                  OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetHeaders';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LRBOMHEADER                   IAPITYPE.BOMHEADERREC_TYPE;
      LRGETBOMHEADER                BOMHEADERRECORD_TYPE
         := BOMHEADERRECORD_TYPE( NULL,
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
      LSSQL                         VARCHAR2( 8192 );
   BEGIN
      LSSQL :=
            'SELECT   BOM_HEADER.PART_NO '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', BOM_HEADER.Revision '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', F_SH_DESCR(1, BOM_HEADER.PART_NO,BOM_HEADER.REVISION) '
         || IAPICONSTANTCOLUMN.SPECIFICATIONDESCRIPTIONCOL
         || ', BOM_HEADER.PLANT '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', BOM_HEADER.ALTERNATIVE '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', BOM_HEADER.BOM_USAGE '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', BOM_HEADER.DESCRIPTION '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ', PLANT.DESCRIPTION '
         || IAPICONSTANTCOLUMN.PLANTDESCRIPTIONCOL
         || ', ITBU.DESCR '
         || IAPICONSTANTCOLUMN.BOMUSAGEDESCRIPTIONCOL
         || ', BOM_HEADER.BASE_QUANTITY '
         || IAPICONSTANTCOLUMN.BASEQUANTITYCOL
         || ', PART.BASE_UOM '
         || IAPICONSTANTCOLUMN.BASEUOMCOL
         || ', ROUND(BOM_HEADER.CONV_FACTOR,10) '
         || IAPICONSTANTCOLUMN.CONVERSIONFACTORCOL
         || ', BOM_HEADER.TO_UNIT '
         || IAPICONSTANTCOLUMN.BASETOUNITCOL
         || ', ROUND(BOM_HEADER.BASE_QUANTITY * BOM_HEADER.CONV_FACTOR,10)  '
         || IAPICONSTANTCOLUMN.CALCULATEDQUANTITYCOL
         || ', BOM_HEADER.MIN_QTY '
         || IAPICONSTANTCOLUMN.MINIMUMQUANTITYCOL
         || ', BOM_HEADER.MAX_QTY '
         || IAPICONSTANTCOLUMN.MAXIMUMQUANTITYCOL
         || ', BOM_HEADER.YIELD '
         || IAPICONSTANTCOLUMN.YIELDCOL
         || ', BOM_HEADER.CALC_FLAG '
         || IAPICONSTANTCOLUMN.CALCULATIONMODECOL
         || ', BOM_HEADER.BOM_TYPE '
         || IAPICONSTANTCOLUMN.BOMTYPECOL
         || ', BOM_HEADER.PLANT_EFFECTIVE_DATE '
         || IAPICONSTANTCOLUMN.PLANNEDEFFECTIVEDATECOL
         || ', BOM_HEADER.PREFERRED '
         || IAPICONSTANTCOLUMN.PREFERREDCOL
         || ', DECODE((SELECT COUNT(*) FROM BOM_ITEM WHERE BOM_ITEM.PART_NO = BOM_HEADER.PART_NO AND BOM_ITEM.REVISION = BOM_HEADER.REVISION AND BOM_ITEM.PLANT = BOM_HEADER.PLANT AND BOM_ITEM.ALTERNATIVE = BOM_HEADER.ALTERNATIVE AND BOM_ITEM.BOM_USAGE = BOM_HEADER.BOM_USAGE), 0, 0, 1) '
         || IAPICONSTANTCOLUMN.HASITEMSCOL
         || ' FROM BOM_HEADER,PART,PLANT,PART_PLANT,ITBU'
         || ' WHERE BOM_HEADER.PART_NO = PART.PART_NO'
         || ' AND BOM_HEADER.PLANT = PLANT.PLANT'
         || ' AND BOM_HEADER.PART_NO = PART_PLANT.PART_NO'
         || ' AND BOM_HEADER.PLANT = PART_PLANT.PLANT'
         || ' AND ITBU.BOM_USAGE = BOM_HEADER.BOM_USAGE'
         || ' AND BOM_HEADER.PART_NO = :asPartNo'
         || ' AND BOM_HEADER.Revision = :anRevision';

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
      THEN   
         LSSQL :=    LSSQL
                  || ' AND PART_PLANT.PLANT_ACCESS = ''Y'''
                  || ' AND BOM_HEADER.PLANT IN(SELECT PLANT FROM ITUP WHERE USER_ID = :lsUser)';
      ELSE
         LSSQL :=    LSSQL
                  || ' AND DECODE (:lsUser, NULL, 0, 0) = 0';
      END IF;

      
      IF ( AQHEADERS%ISOPEN )
      THEN
         CLOSE AQHEADERS;
      END IF;

      OPEN AQHEADERS FOR LSSQL USING '',
      0,
      '';

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      GTBOMHEADERS.DELETE;
      LRBOMHEADER.PARTNO := ASPARTNO;
      LRBOMHEADER.REVISION := ANREVISION;
      GTBOMHEADERS( 0 ) := LRBOMHEADER;
       
      
      
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




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPISPECIFICATIONACCESS.GETVIEWACCESS( ASPARTNO,
                                                         ANREVISION,
                                                         LNACCESS );

      IF LNRETVAL <>( IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN LNRETVAL;
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

      
      LSSQL :=    LSSQL
               || ' AND F_CHECK_ITEM_ACCESS(BOM_HEADER.PART_NO, BOM_HEADER.REVISION, 0, 0, :SectionType) = 1 ';
      LSSQL :=    LSSQL
               || ' ORDER BY BOM_HEADER.PLANT, BOM_HEADER.ALTERNATIVE, BOM_HEADER.BOM_USAGE';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      
      IF ( AQHEADERS%ISOPEN )
      THEN
         CLOSE AQHEADERS;
      END IF;

      OPEN AQHEADERS FOR LSSQL USING ASPARTNO,
      ANREVISION,
      IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
      IAPICONSTANT.SECTIONTYPE_BOM;

      
      
      
      GTGETBOMHEADERS.DELETE;

      LOOP
         LRBOMHEADER := NULL;

         FETCH AQHEADERS
          INTO LRBOMHEADER;

         EXIT WHEN AQHEADERS%NOTFOUND;
         LRGETBOMHEADER.PARTNO := LRBOMHEADER.PARTNO;
         LRGETBOMHEADER.REVISION := LRBOMHEADER.REVISION;
         LRGETBOMHEADER.PLANT := LRBOMHEADER.PLANT;
         LRGETBOMHEADER.ALTERNATIVE := LRBOMHEADER.ALTERNATIVE;
         LRGETBOMHEADER.BOMUSAGE := LRBOMHEADER.BOMUSAGE;
         LRGETBOMHEADER.DESCRIPTION := LRBOMHEADER.DESCRIPTION;
         LRGETBOMHEADER.PLANTDESCRIPTION := LRBOMHEADER.PLANTDESCRIPTION;
         LRGETBOMHEADER.USAGEDESCRIPTION := LRBOMHEADER.USAGEDESCRIPTION;
         LRGETBOMHEADER.QUANTITY := LRBOMHEADER.QUANTITY;
         LRGETBOMHEADER.UOM := LRBOMHEADER.UOM;
         LRGETBOMHEADER.CONVERSIONFACTOR := LRBOMHEADER.CONVERSIONFACTOR;
         LRGETBOMHEADER.CONVERTEDUOM := LRBOMHEADER.CONVERTEDUOM;
         LRGETBOMHEADER.CONVERTEDQUANTITY := LRBOMHEADER.CONVERTEDQUANTITY;
         LRGETBOMHEADER.MINIMUMQUANTITY := LRBOMHEADER.MINIMUMQUANTITY;
         LRGETBOMHEADER.MAXIMUMQUANTITY := LRBOMHEADER.MAXIMUMQUANTITY;
         LRGETBOMHEADER.YIELD := LRBOMHEADER.YIELD;
         LRGETBOMHEADER.CALCULATIONMODE := LRBOMHEADER.CALCULATIONMODE;
         LRGETBOMHEADER.BOMITEMTYPE := LRBOMHEADER.BOMITEMTYPE;
         LRGETBOMHEADER.PLANNEDEFFECTIVEDATE := LRBOMHEADER.PLANNEDEFFECTIVEDATE;
         LRGETBOMHEADER.PREFERRED := LRBOMHEADER.PREFERRED;
         LRGETBOMHEADER.HASITEMS := LRBOMHEADER.HASITEMS;
         LRGETBOMHEADER.SPECIFICATIONDESCRIPTION := LRBOMHEADER.SPECIFICATIONDESCRIPTION;
         GTGETBOMHEADERS.EXTEND;
         GTGETBOMHEADERS( GTGETBOMHEADERS.COUNT ) := LRGETBOMHEADER;
      END LOOP;

      CLOSE AQHEADERS;

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      OPEN AQHEADERS FOR LSSQL USING '',
      0,
      '',
      0;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Post-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     LSMETHOD,
                                                     'POST',
                                                     GTERRORS );
      LSSQL :=
            'PartNo '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', Revision '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', SpecificationDescription '
         || IAPICONSTANTCOLUMN.SPECIFICATIONDESCRIPTIONCOL
         || ', Plant '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', Alternative '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', BomUsage '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', Description '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ', PlantDescription '
         || IAPICONSTANTCOLUMN.PLANTDESCRIPTIONCOL
         || ', UsageDescription '
         || IAPICONSTANTCOLUMN.BOMUSAGEDESCRIPTIONCOL
         || ', Quantity '
         || IAPICONSTANTCOLUMN.BASEQUANTITYCOL
         || ', Uom '
         || IAPICONSTANTCOLUMN.BASEUOMCOL
         || ', ConversionFactor '
         || IAPICONSTANTCOLUMN.CONVERSIONFACTORCOL
         || ', ConvertedUom '
         || IAPICONSTANTCOLUMN.BASETOUNITCOL
         || ', ConvertedQuantity  '
         || IAPICONSTANTCOLUMN.CALCULATEDQUANTITYCOL
         || ', MinimumQuantity '
         || IAPICONSTANTCOLUMN.MINIMUMQUANTITYCOL
         || ', MaximumQuantity '
         || IAPICONSTANTCOLUMN.MAXIMUMQUANTITYCOL
         || ', Yield '
         || IAPICONSTANTCOLUMN.YIELDCOL
         || ', CalculationMode '
         || IAPICONSTANTCOLUMN.CALCULATIONMODECOL
         || ', BomItemType '
         || IAPICONSTANTCOLUMN.BOMTYPECOL
         || ', PlannedEffectiveDate '
         || IAPICONSTANTCOLUMN.PLANNEDEFFECTIVEDATECOL
         || ', Preferred '
         || IAPICONSTANTCOLUMN.PREFERREDCOL
         || ', HasItems '
         || IAPICONSTANTCOLUMN.HASITEMSCOL;
      LSSQL :=    'SELECT '
               || LSSQL
               || ' FROM TABLE( CAST( :gtGetBomHeaders AS BomHeaderTable_Type ) ) ';

      
      IF ( AQHEADERS%ISOPEN )
      THEN
         CLOSE AQHEADERS;
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQHEADERS FOR LSSQL USING GTGETBOMHEADERS;

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

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETHEADERS;


   FUNCTION GETEXPLOSIONHEADERS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ADEXPLOSIONDATE            IN       IAPITYPE.DATE_TYPE DEFAULT SYSDATE,
      ANINCLUDEINDEVELOPMENT     IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      AQHEADERS                  OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetExplosionHeaders';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      
      LSSELECTFROM                  VARCHAR2( 4096 );
      LNCOUNT                       NUMBER;
   BEGIN
      
      
      LSSELECTFROM :=
      
            'SELECT H.PART_NO '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', H.Revision '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', F_SH_DESCR(1, H.PART_NO, H.REVISION) '
         || IAPICONSTANTCOLUMN.SPECIFICATIONDESCRIPTIONCOL
         || ', H.PLANT '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', H.ALTERNATIVE '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', H.BOM_USAGE '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', H.DESCRIPTION '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ', PL.DESCRIPTION '
         || IAPICONSTANTCOLUMN.PLANTDESCRIPTIONCOL
         || ', ITBU.DESCR '
         || IAPICONSTANTCOLUMN.BOMUSAGEDESCRIPTIONCOL
         || ', H.BASE_QUANTITY '
         || IAPICONSTANTCOLUMN.BASEQUANTITYCOL
         || ', P.BASE_UOM '
         || IAPICONSTANTCOLUMN.BASEUOMCOL
         || ', ROUND(H.CONV_FACTOR,10) '
         || IAPICONSTANTCOLUMN.CONVERSIONFACTORCOL
         || ', H.TO_UNIT '
         || IAPICONSTANTCOLUMN.BASETOUNITCOL
         || ', ROUND(H.BASE_QUANTITY * H.CONV_FACTOR,10) '
         || IAPICONSTANTCOLUMN.CALCULATEDQUANTITYCOL
         || ', H.MIN_QTY '
         || IAPICONSTANTCOLUMN.MINIMUMQUANTITYCOL
         || ', H.MAX_QTY '
         || IAPICONSTANTCOLUMN.MAXIMUMQUANTITYCOL
         || ', H.YIELD '
         || IAPICONSTANTCOLUMN.YIELDCOL
         || ', H.CALC_FLAG '
         || IAPICONSTANTCOLUMN.CALCULATIONMODECOL
         || ', H.BOM_TYPE '
         || IAPICONSTANTCOLUMN.BOMTYPECOL
         || ', H.PLANT_EFFECTIVE_DATE '
         || IAPICONSTANTCOLUMN.PLANNEDEFFECTIVEDATECOL
         || ', H.PREFERRED '
         || IAPICONSTANTCOLUMN.PREFERREDCOL
         || ', DECODE((SELECT COUNT(*) FROM BOM_ITEM WHERE BOM_ITEM.PART_NO = H.PART_NO AND BOM_ITEM.REVISION = H.REVISION AND BOM_ITEM.PLANT = H.PLANT AND BOM_ITEM.ALTERNATIVE = H.ALTERNATIVE AND BOM_ITEM.BOM_USAGE = H.BOM_USAGE), 0, 0, 1) '
         || IAPICONSTANTCOLUMN.HASITEMSCOL
         
         
         || ' FROM BOM_HEADER H, PLANT PL, PART P, PART_PLANT PP, ITBU';
         

       
       
       
        


























































         
  

         
         LSSQL := LSSELECTFROM
         
         || ' WHERE (H.PART_NO, H.REVISION, H.PLANT, H.ALTERNATIVE, H.BOM_USAGE)'
         || ' IN (SELECT PART_NO, REVISION, PLANT, ALTERNATIVE, BOM_USAGE FROM'
         
         || ' ('
         
         || ' (SELECT H.PART_NO, H.REVISION, H.PLANT, H.ALTERNATIVE, H.BOM_USAGE'
         || ' FROM BOM_HEADER H, SPECIFICATION_HEADER SH, STATUS SS'
         || ' WHERE TRUNC(PLANT_EFFECTIVE_DATE) <= :adExplosionDate'
         || ' AND H.PART_NO = :asPartNo'
         || ' AND H.PART_NO = SH.PART_NO'
         || ' AND H.REVISION = SH.REVISION'
         || ' AND SH.STATUS = SS.STATUS'
         || ' AND SS.STATUS_TYPE <> DECODE(:anIncludeInDevelopment, 1, ''-'', '''
         || IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         
         
         
         || ''') AND INSTR(decode(:historic_only, 1, '''
         || IAPICONSTANT.STATUSTYPE_CURRENT
         || ', '
         || IAPICONSTANT.STATUSTYPE_APPROVED
         || ', '
         || IAPICONSTANT.STATUSTYPE_HISTORIC
         
         || ''', (decode(:approved_only, 1, '''
         || IAPICONSTANT.STATUSTYPE_CURRENT
         || ', '
         || IAPICONSTANT.STATUSTYPE_APPROVED
         
         
         
         
         
         
         
         || ''', (decode(:current_only, 1, '''
         || IAPICONSTANT.STATUSTYPE_CURRENT
         
         || ''', '''
         || IAPICONSTANT.STATUSTYPE_CURRENT
         || ', '
         || IAPICONSTANT.STATUSTYPE_APPROVED
         || ', '
         || IAPICONSTANT.STATUSTYPE_HISTORIC
         || ', '
         || IAPICONSTANT.STATUSTYPE_OBSOLETE
         || '''))))),ss.status_type) > 0'
         
         
         || ' MINUS '
         || '  SELECT H.PART_NO, H.REVISION, H.PLANT, H.ALTERNATIVE, H.BOM_USAGE '
         || '  FROM BOM_HEADER H, SPECIFICATION_HEADER SH, STATUS SS'
         
         
         || '  WHERE ( ((TRUNC(PLANT_EFFECTIVE_DATE) <= :adExplosionDate) AND (ISSUED_DATE IS NULL)) '
         || '          OR ((TRUNC(PLANT_EFFECTIVE_DATE) > :adExplosionDate) ' 
         
         
         || ') )'
         
         || '  AND H.PART_NO = :asPartNo'
         || '  AND H.PART_NO = SH.PART_NO'
         || '  AND H.REVISION = SH.REVISION'
         || '  AND SH.STATUS = SS.STATUS'
         || '  AND SS.STATUS_TYPE <> DECODE(:anIncludeInDevelopment, 1, ''-'', '''
         || IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         || ''')'
         
         
         
         || '  AND INSTR(decode(:historic_only, 1, '''
         || IAPICONSTANT.STATUSTYPE_CURRENT
         || ', '
         || IAPICONSTANT.STATUSTYPE_APPROVED
         || ', '
         ||IAPICONSTANT.STATUSTYPE_HISTORIC
         
         || ''','
         || ' (decode(:approved_only, 1, '''
         || IAPICONSTANT.STATUSTYPE_CURRENT
         || ', '
         ||IAPICONSTANT.STATUSTYPE_APPROVED
         
         
         
         
         
         
         
         || ''', (decode(:current_only, 1, '''
         || IAPICONSTANT.STATUSTYPE_CURRENT
         
         || ''', '''
         || IAPICONSTANT.STATUSTYPE_CURRENT
         || ', '
         || IAPICONSTANT.STATUSTYPE_APPROVED
         || ', '
         || IAPICONSTANT.STATUSTYPE_HISTORIC
         || ', '
         || IAPICONSTANT.STATUSTYPE_OBSOLETE
         || ''')'
         || ' )))),ss.status_type) > 0'
         || ' AND  SS.STATUS_TYPE in ('''
         || IAPICONSTANT.STATUSTYPE_HISTORIC
         || ''', '''
         || IAPICONSTANT.STATUSTYPE_OBSOLETE
         ||''')'
         
         
         || ' )'
         
          
         
         || ' UNION '
         || '( '
         || ' SELECT H.PART_NO, H.REVISION, H.PLANT, H.ALTERNATIVE, H.BOM_USAGE'
         
         || ' FROM BOM_HEADER H, SPECIFICATION_HEADER SH, STATUS SS'
         
         
         || ' WHERE TRUNC(PLANT_EFFECTIVE_DATE) <= :adExplosionDate'  
         
         
         
         || ' AND H.PART_NO = :asPartNo'
         || ' AND H.PART_NO = SH.PART_NO'
         || ' AND H.REVISION = SH.REVISION'
         || ' AND SH.STATUS = SS.STATUS'
         || ' AND SS.STATUS_TYPE <> DECODE(:anIncludeInDevelopment, 1, ''-'', '''
         || IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         || ''') AND INSTR(DECODE(:current_only, 1, ''-'', (DECODE(:approved_only, 1, ''-'',(DECODE(:historic_only, 1, ''-'','''
         || IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         || ', '
         || IAPICONSTANT.STATUSTYPE_SUBMIT
         || ', '
         || IAPICONSTANT.STATUSTYPE_REJECT
         || '''))))),SS.STATUS_TYPE) > 0'
         
         
         || ' AND :anIncludeInDevelopment = 1'
         || ' MINUS'
         || '   SELECT H.PART_NO, H.REVISION, H.PLANT, H.ALTERNATIVE, H.BOM_USAGE'
         || ' FROM BOM_HEADER H, SPECIFICATION_HEADER SH, STATUS SS'
         
         
         || '  WHERE ( ((TRUNC(PLANT_EFFECTIVE_DATE) <= :adExplosionDate) AND (ISSUED_DATE IS NULL)) '
         || '          OR ((TRUNC(PLANT_EFFECTIVE_DATE) > :adExplosionDate) ' 
         
         
         || ') )'
         
         || ' AND H.PART_NO = :asPartNo'
         || ' AND H.PART_NO = SH.PART_NO'
         || ' AND H.REVISION = SH.REVISION'
         || ' AND SH.STATUS = SS.STATUS'
         || ' AND SS.STATUS_TYPE <> DECODE(:anIncludeInDevelopment, 1, ''-'', '''
         || IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         || ''')'
         || ' AND INSTR(DECODE(:current_only, 1, ''-'','
         || ' (DECODE(:approved_only, 1, ''-'',(DECODE(:historic_only, 1, ''-'','''
         || IAPICONSTANT.STATUSTYPE_DEVELOPMENT || ',' || IAPICONSTANT.STATUSTYPE_SUBMIT || ',' || IAPICONSTANT.STATUSTYPE_REJECT
         || '''))))),SS.STATUS_TYPE) > 0'
         || ' AND :anIncludeInDevelopment = 1'
         || ' AND  SS.STATUS_TYPE in (''' || IAPICONSTANT.STATUSTYPE_HISTORIC || ''', ''' || IAPICONSTANT.STATUSTYPE_OBSOLETE || ''')'
         
         
         || ' ))'
         
         || ' )'
         || ' AND (PLANT_EFFECTIVE_DATE, H.PLANT)'
         || ' IN (select max(ped), plant from '
         || ' (SELECT MAX(H.PLANT_EFFECTIVE_DATE) ped, H.plant'
         || ' FROM BOM_HEADER H, SPECIFICATION_HEADER SH, STATUS SS'
         || ' WHERE TRUNC(PLANT_EFFECTIVE_DATE) <= :adExplosionDate'
         || ' AND H.PART_NO = :asPartNo'
         || ' AND H.PART_NO = SH.PART_NO'
         || ' AND H.REVISION = SH.REVISION'
         || ' AND SH.STATUS = SS.STATUS'
         || ' AND SS.STATUS_TYPE <> DECODE(:anIncludeInDevelopment, 1, ''-'', '''
         || IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         
         
         || ''')' 
         
         
         || ' AND h.revision in ('
         || ' select max(revision) FROM (SELECT h.revision'
         || ' from BOM_HEADER H, SPECIFICATION_HEADER SH, STATUS SS'
         
         || '  WHERE TRUNC(PLANT_EFFECTIVE_DATE) <= :adExplosionDate'
         || ' AND H.PART_NO = :asPartNo AND H.PART_NO = SH.PART_NO AND H.REVISION = SH.REVISION AND SH.STATUS = SS.STATUS'
         || ' AND SS.STATUS_TYPE <> DECODE(:anIncludeInDevelopment, 1, ''-'', '''
         || IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         
         
         || ''')'
         
         
         || ' AND INSTR(decode(:historic_only, 1, '''       || IAPICONSTANT.STATUSTYPE_CURRENT          || ', '           || IAPICONSTANT.STATUSTYPE_APPROVED         || ', '          || IAPICONSTANT.STATUSTYPE_HISTORIC
         || ''', (decode(:approved_only, 1, '''                 || IAPICONSTANT.STATUSTYPE_CURRENT         || ', '          || IAPICONSTANT.STATUSTYPE_APPROVED
         || ''', (decode(:current_only, 1, '''                    || IAPICONSTANT.STATUSTYPE_CURRENT         || ''', '''         || IAPICONSTANT.STATUSTYPE_CURRENT         || ', '          || IAPICONSTANT.STATUSTYPE_APPROVED       || ', '
         || IAPICONSTANT.STATUSTYPE_HISTORIC        || ', '          || IAPICONSTANT.STATUSTYPE_OBSOLETE        || '''))))),ss.status_type) > 0  '         
         
         || '  MINUS'
         || '  select h.revision'
         || '  from BOM_HEADER H, SPECIFICATION_HEADER SH, STATUS SS'
         
         
         || '  WHERE ( ((TRUNC(PLANT_EFFECTIVE_DATE) <= :adExplosionDate) AND (ISSUED_DATE IS NULL)) '
         || '          OR ((TRUNC(PLANT_EFFECTIVE_DATE) > :adExplosionDate) ' 
         
         
         || ') )'
         
         || '  AND H.PART_NO = :asPartNo AND H.PART_NO = SH.PART_NO'
         || '  AND H.REVISION = SH.REVISION AND SH.STATUS = SS.STATUS'
         || '  AND SS.STATUS_TYPE <> DECODE(:anIncludeInDevelopment, 1, ''-'', ''' || IAPICONSTANT.STATUSTYPE_DEVELOPMENT || ''')'
         || '  AND  SS.STATUS_TYPE in (''' || IAPICONSTANT.STATUSTYPE_HISTORIC || ''', ''' || IAPICONSTANT.STATUSTYPE_OBSOLETE || ''')'
         
         
         
         
         
         
         
         
         
         || ' AND INSTR(decode(:historic_only, 1, '''  
         
         || IAPICONSTANT.STATUSTYPE_CURRENT
         || ', '
         || IAPICONSTANT.STATUSTYPE_APPROVED
         || ', '
         || IAPICONSTANT.STATUSTYPE_HISTORIC
         
         || ''', (decode(:approved_only, 1, '''
         || IAPICONSTANT.STATUSTYPE_CURRENT
         || ', '
         || IAPICONSTANT.STATUSTYPE_APPROVED
         
         
         
         
         
         
         
         || ''', (decode(:current_only, 1, '''
         || IAPICONSTANT.STATUSTYPE_CURRENT
         
         || ''', '''
         || IAPICONSTANT.STATUSTYPE_CURRENT
         || ', '
         || IAPICONSTANT.STATUSTYPE_APPROVED
         || ', '
         || IAPICONSTANT.STATUSTYPE_HISTORIC
         || ', '
         || IAPICONSTANT.STATUSTYPE_OBSOLETE

         || '''))))),ss.status_type) > 0  '
         
         || ' ))'         
         || ' group by plant'
         || ' UNION ALL SELECT MAX(H.PLANT_EFFECTIVE_DATE) ped, H.plant'
         || ' FROM BOM_HEADER H, SPECIFICATION_HEADER SH, STATUS SS'
         
         
         || ' WHERE TRUNC(PLANT_EFFECTIVE_DATE) <= :adExplosionDate'  
         
         
         
         || ' AND H.PART_NO = :asPartNo'
         || ' AND H.PART_NO = SH.PART_NO'
         || ' AND H.REVISION = SH.REVISION'
         || ' AND SH.STATUS = SS.STATUS'
         || ' AND SS.STATUS_TYPE <> DECODE(:anIncludeInDevelopment, 1, ''-'', '''
         || IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         
         
         || ''')'   
         || ' AND h.revision in (select max(h.revision) from BOM_HEADER H, SPECIFICATION_HEADER SH, STATUS SS'
         
         
         || '  WHERE TRUNC(PLANT_EFFECTIVE_DATE) <= :adExplosionDate'  
         
         
         
         || ' AND H.PART_NO = :asPartNo AND H.PART_NO = SH.PART_NO AND H.REVISION = SH.REVISION AND SH.STATUS = SS.STATUS'
         || ' AND SS.STATUS_TYPE <> DECODE(:anIncludeInDevelopment, 1, ''-'', '''
         || IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         || ''') '
         
         
         || ' AND INSTR(DECODE(:current_only, 1, ''-'', (DECODE(:approved_only, 1, ''-'', (DECODE(:historic_only, 1, ''-'','''  
         
         || IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         || ', '
         || IAPICONSTANT.STATUSTYPE_SUBMIT
         || ', '
         || IAPICONSTANT.STATUSTYPE_REJECT
         || '''))))),SS.STATUS_TYPE) > 0'
         
         || ')'         
         || ' AND :anIncludeInDevelopment = 1 group by plant) group by plant)'
         || ' AND PP.PLANT   = H.PLANT'
         || ' AND PP.PART_NO = H.PART_NO'
         || ' AND PL.PLANT = H.PLANT'
         || ' AND P.PART_NO = H.PART_NO'
         || ' AND ITBU.BOM_USAGE = H.BOM_USAGE'
         || ' AND F_CHECK_BOM_HEADER(H.PART_NO, H.REVISION, H.PLANT, H.ALTERNATIVE, H.BOM_USAGE, :adExplosionDate, :anIncludeInDevelopment) <> 0';   


      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      OPEN AQHEADERS FOR LSSQL USING
      SYSDATE,
      '',
      0,
      0,
      0,
      0,
      
      SYSDATE,
      
      SYSDATE,
      
      
      
      '',
      0,
      0,
      0,
      0,
      
      SYSDATE,
      '',
      0,
      0,
      0,
      0,
      0,
      
      SYSDATE,
      
      SYSDATE,
      
      
      
      '',
      0,
      0,
      0,
      0,
      0,
      
      SYSDATE,
      '',
      0,
      
      SYSDATE,
      '',
      0,
      
      
      0,
      0,
      0,
      
      
      SYSDATE,
      
      SYSDATE,
      
      
      
      '',
      0,
      
      0,
      0,
      0,
      SYSDATE,
      '',
      0,
      
      SYSDATE,
      '',
      0,
      
      0,
      0,
      0,
      0,
      SYSDATE,
      0;
         
      IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
      THEN   
         LSSQL :=    LSSQL
                  || ' AND PP.PLANT_ACCESS = ''Y'''
                  || ' AND H.PLANT IN(SELECT PLANT FROM ITUP WHERE USER_ID = :lsUser)';
      ELSE
         LSSQL :=    LSSQL
                  || ' AND F_CHECK_ACCESS(H.PART_NO, H.REVISION) > 0';
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.VIEWBOMALLOWED = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOVIEWBOMACCESS,
                                                    IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );
      END IF;
         
      
      LSSQL :=    LSSQL
               || ' AND F_CHECK_ITEM_ACCESS(H.PART_NO, H.REVISION, 0, 0, :SECTIONTYPE_BOM) = 1 ';
      LSSQL :=    LSSQL
               || ' ORDER BY H.PLANT ASC, H.ALTERNATIVE ASC, H.BOM_USAGE ASC';
           
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );
  
      IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
      THEN   
         OPEN AQHEADERS FOR LSSQL
         USING ADEXPLOSIONDATE,
               ASPARTNO,
               ANINCLUDEINDEVELOPMENT,
               
               
               
               
               IAPIGENERAL.SESSION.APPLICATIONUSER.HISTORICONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.APPROVEDONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.CURRENTONLYACCESS,
               
               
               ADEXPLOSIONDATE,
               
               ADEXPLOSIONDATE,
               
               
               
               ASPARTNO,
               ANINCLUDEINDEVELOPMENT,
               
               
               
               
               IAPIGENERAL.SESSION.APPLICATIONUSER.HISTORICONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.APPROVEDONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.CURRENTONLYACCESS,
               
               
               ADEXPLOSIONDATE,
               ASPARTNO,
               ANINCLUDEINDEVELOPMENT,
               IAPIGENERAL.SESSION.APPLICATIONUSER.CURRENTONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.APPROVEDONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.HISTORICONLYACCESS,
               ANINCLUDEINDEVELOPMENT,
               
               ADEXPLOSIONDATE,
               
               ADEXPLOSIONDATE,
               
               
               
               ASPARTNO,
               ANINCLUDEINDEVELOPMENT,
               IAPIGENERAL.SESSION.APPLICATIONUSER.CURRENTONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.APPROVEDONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.HISTORICONLYACCESS,
               ANINCLUDEINDEVELOPMENT,
               
               ADEXPLOSIONDATE,
               ASPARTNO,
               ANINCLUDEINDEVELOPMENT,
               
               ADEXPLOSIONDATE,
               ASPARTNO,
               ANINCLUDEINDEVELOPMENT,
               
               
               IAPIGENERAL.SESSION.APPLICATIONUSER.HISTORICONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.APPROVEDONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.CURRENTONLYACCESS,
               
               
               ADEXPLOSIONDATE,
               
               ADEXPLOSIONDATE,
               
               
               
               ASPARTNO,
               ANINCLUDEINDEVELOPMENT,
               
               
               
               
               
               IAPIGENERAL.SESSION.APPLICATIONUSER.HISTORICONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.APPROVEDONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.CURRENTONLYACCESS,
               
               ADEXPLOSIONDATE,
               ASPARTNO,
               ANINCLUDEINDEVELOPMENT,
               
               ADEXPLOSIONDATE,
               ASPARTNO,
               ANINCLUDEINDEVELOPMENT,
               
               IAPIGENERAL.SESSION.APPLICATIONUSER.CURRENTONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.APPROVEDONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.HISTORICONLYACCESS,
               ANINCLUDEINDEVELOPMENT,
               ADEXPLOSIONDATE,
               ANINCLUDEINDEVELOPMENT,
               IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
               IAPICONSTANT.SECTIONTYPE_BOM;
      ELSE
         OPEN AQHEADERS FOR LSSQL
         USING ADEXPLOSIONDATE,
               ASPARTNO,
               ANINCLUDEINDEVELOPMENT,
               
               
               
               
               IAPIGENERAL.SESSION.APPLICATIONUSER.HISTORICONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.APPROVEDONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.CURRENTONLYACCESS,
               
               
               ADEXPLOSIONDATE,
               
               ADEXPLOSIONDATE,
               
               
               
               ASPARTNO,
               ANINCLUDEINDEVELOPMENT,
               
               
               
               
               IAPIGENERAL.SESSION.APPLICATIONUSER.HISTORICONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.APPROVEDONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.CURRENTONLYACCESS,
               
               
               ADEXPLOSIONDATE,
               ASPARTNO,
               ANINCLUDEINDEVELOPMENT,
               IAPIGENERAL.SESSION.APPLICATIONUSER.CURRENTONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.APPROVEDONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.HISTORICONLYACCESS,
               ANINCLUDEINDEVELOPMENT,
               
               ADEXPLOSIONDATE,
               
               ADEXPLOSIONDATE,
               
               
               
               ASPARTNO,
               ANINCLUDEINDEVELOPMENT,
               IAPIGENERAL.SESSION.APPLICATIONUSER.CURRENTONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.APPROVEDONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.HISTORICONLYACCESS,
               ANINCLUDEINDEVELOPMENT,
               
               ADEXPLOSIONDATE,
               ASPARTNO,
               ANINCLUDEINDEVELOPMENT,
               
               ADEXPLOSIONDATE,
               ASPARTNO,
               ANINCLUDEINDEVELOPMENT,
               
               
               IAPIGENERAL.SESSION.APPLICATIONUSER.HISTORICONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.APPROVEDONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.CURRENTONLYACCESS,  
               
               
               ADEXPLOSIONDATE,
               
               ADEXPLOSIONDATE,
               
               
               
               ASPARTNO,
               ANINCLUDEINDEVELOPMENT,
               
               
               
               
               
               IAPIGENERAL.SESSION.APPLICATIONUSER.HISTORICONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.APPROVEDONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.CURRENTONLYACCESS,
               
               ADEXPLOSIONDATE,
               ASPARTNO,
               ANINCLUDEINDEVELOPMENT,
               
               ADEXPLOSIONDATE,
               ASPARTNO,
               ANINCLUDEINDEVELOPMENT,
               
               IAPIGENERAL.SESSION.APPLICATIONUSER.CURRENTONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.APPROVEDONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.HISTORICONLYACCESS,
               ANINCLUDEINDEVELOPMENT,
               ADEXPLOSIONDATE,
               ANINCLUDEINDEVELOPMENT,
               IAPICONSTANT.SECTIONTYPE_BOM;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETEXPLOSIONHEADERS;





   FUNCTION GETEXPLOSIONHEADERS2(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ADEXPLOSIONDATE            IN       IAPITYPE.DATE_TYPE DEFAULT SYSDATE,
      ANINCLUDEINDEVELOPMENT     IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      AQHEADERS                  OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS












      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetExplosionHeaders2';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      
      LSSELECTFROM                  VARCHAR2( 4096 );
      LNCOUNT                       NUMBER;
   BEGIN
      
      
      LSSELECTFROM :=
      
            'SELECT H.PART_NO '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', H.Revision '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', F_SH_DESCR(1, H.PART_NO, H.REVISION) '
         || IAPICONSTANTCOLUMN.SPECIFICATIONDESCRIPTIONCOL
         || ', H.PLANT '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', H.ALTERNATIVE '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', H.BOM_USAGE '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', H.DESCRIPTION '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ', PL.DESCRIPTION '
         || IAPICONSTANTCOLUMN.PLANTDESCRIPTIONCOL
         || ', ITBU.DESCR '
         || IAPICONSTANTCOLUMN.BOMUSAGEDESCRIPTIONCOL
         || ', H.BASE_QUANTITY '
         || IAPICONSTANTCOLUMN.BASEQUANTITYCOL
         || ', P.BASE_UOM '
         || IAPICONSTANTCOLUMN.BASEUOMCOL
         || ', ROUND(H.CONV_FACTOR,10) '
         || IAPICONSTANTCOLUMN.CONVERSIONFACTORCOL
         || ', H.TO_UNIT '
         || IAPICONSTANTCOLUMN.BASETOUNITCOL
         || ', ROUND(H.BASE_QUANTITY * H.CONV_FACTOR,10) '
         || IAPICONSTANTCOLUMN.CALCULATEDQUANTITYCOL
         || ', H.MIN_QTY '
         || IAPICONSTANTCOLUMN.MINIMUMQUANTITYCOL
         || ', H.MAX_QTY '
         || IAPICONSTANTCOLUMN.MAXIMUMQUANTITYCOL
         || ', H.YIELD '
         || IAPICONSTANTCOLUMN.YIELDCOL
         || ', H.CALC_FLAG '
         || IAPICONSTANTCOLUMN.CALCULATIONMODECOL
         || ', H.BOM_TYPE '
         || IAPICONSTANTCOLUMN.BOMTYPECOL
         || ', H.PLANT_EFFECTIVE_DATE '
         || IAPICONSTANTCOLUMN.PLANNEDEFFECTIVEDATECOL
         || ', H.PREFERRED '
         || IAPICONSTANTCOLUMN.PREFERREDCOL
         || ', DECODE((SELECT COUNT(*) FROM BOM_ITEM WHERE BOM_ITEM.PART_NO = H.PART_NO AND BOM_ITEM.REVISION = H.REVISION AND BOM_ITEM.PLANT = H.PLANT AND BOM_ITEM.ALTERNATIVE = H.ALTERNATIVE AND BOM_ITEM.BOM_USAGE = H.BOM_USAGE), 0, 0, 1) '
         || IAPICONSTANTCOLUMN.HASITEMSCOL
         
         
         || ' FROM BOM_HEADER H, PLANT PL, PART P, PART_PLANT PP, ITBU';
         


        
        
        
        
        
          IF ANINCLUDEINDEVELOPMENT = 1 THEN
           SELECT COUNT(*)
                INTO LNCOUNT
            FROM BOM_HEADER H, SPECIFICATION_HEADER SH, STATUS SS
             WHERE TRUNC(PLANNED_EFFECTIVE_DATE) <= ADEXPLOSIONDATE
                AND ADEXPLOSIONDATE <
                     (SELECT MIN(TRUNC(PLANT_EFFECTIVE_DATE)) FROM BOM_HEADER H, SPECIFICATION_HEADER SH, STATUS SS
                                     WHERE H.PART_NO = ASPARTNO
                                           
                                           AND H.REVISION = ANREVISION
                                           AND H.PART_NO = SH.PART_NO
                                           AND H.REVISION = SH.REVISION
                                           AND SH.STATUS = SS.STATUS
                                           AND SS.STATUS_TYPE = 'DEVELOPMENT')
                AND TRUNC(PLANT_EFFECTIVE_DATE) - TRUNC(PLANNED_EFFECTIVE_DATE) > 1
                AND SS.STATUS_TYPE = 'DEVELOPMENT'
                AND H.PART_NO = ASPARTNO
                
                AND H.REVISION = ANREVISION
                
                AND H.PART_NO = SH.PART_NO
                AND H.REVISION = SH.REVISION
                AND SH.STATUS = SS.STATUS;
           ELSE
          SELECT COUNT(*)
                INTO LNCOUNT
            FROM BOM_HEADER H, SPECIFICATION_HEADER SH, STATUS SS
            WHERE TRUNC(PLANNED_EFFECTIVE_DATE) <= ADEXPLOSIONDATE
                AND ADEXPLOSIONDATE <
                                (SELECT MIN(TRUNC(PLANT_EFFECTIVE_DATE)) FROM BOM_HEADER H, SPECIFICATION_HEADER SH, STATUS SS
                                     WHERE H.PART_NO = ASPARTNO
                                           
                                           AND H.REVISION = ANREVISION
                                           AND H.PART_NO = SH.PART_NO
                                           AND H.REVISION = SH.REVISION
                                           AND SH.STATUS = SS.STATUS
                                           AND SS.STATUS_TYPE = 'CURRENT')
                AND TRUNC(PLANT_EFFECTIVE_DATE) - TRUNC(PLANNED_EFFECTIVE_DATE) > 1
                AND SS.STATUS_TYPE = 'CURRENT'
                AND H.PART_NO = ASPARTNO
                
                AND H.REVISION = ANREVISION
                AND H.PART_NO = SH.PART_NO
                AND H.REVISION = SH.REVISION
                AND SH.STATUS = SS.STATUS;
           END IF;

           IF (LNCOUNT > 0)
           THEN
             LSSQL := LSSELECTFROM
                      || ' WHERE PP.PLANT   = H.PLANT'
                      || ' AND PP.PART_NO = H.PART_NO'
                      || ' AND PL.PLANT = H.PLANT'
                      || ' AND P.PART_NO = H.PART_NO'
                      || ' AND ITBU.BOM_USAGE = H.BOM_USAGE'
                      || ' AND H.part_no is null';

                OPEN AQHEADERS FOR LSSQL;

                RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
           END IF;
         

         
         LSSQL := LSSELECTFROM
         
         || ' WHERE (H.PART_NO, H.REVISION, H.PLANT, H.ALTERNATIVE, H.BOM_USAGE)'
         || ' IN (SELECT PART_NO, REVISION, PLANT, ALTERNATIVE, BOM_USAGE FROM'
         || ' (SELECT H.PART_NO, H.REVISION, H.PLANT, H.ALTERNATIVE, H.BOM_USAGE'
         || ' FROM BOM_HEADER H, SPECIFICATION_HEADER SH, STATUS SS'
         || ' WHERE TRUNC(PLANT_EFFECTIVE_DATE) <= :adExplosionDate'
         || ' AND H.PART_NO = :asPartNo'
         
         || ' AND H.REVISION = :anRevision'
         || ' AND H.PART_NO = SH.PART_NO'
         || ' AND H.REVISION = SH.REVISION'
         || ' AND SH.STATUS = SS.STATUS'
         || ' AND SS.STATUS_TYPE <> DECODE(:anIncludeInDevelopment, 1, ''-'', '''
         || IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         
         
         
         || ''') AND INSTR(decode(:historic_only, 1, '''
         || IAPICONSTANT.STATUSTYPE_CURRENT
         || ', '
         || IAPICONSTANT.STATUSTYPE_APPROVED
         || ', '
         || IAPICONSTANT.STATUSTYPE_HISTORIC
         
         || ''', (decode(:approved_only, 1, '''
         || IAPICONSTANT.STATUSTYPE_CURRENT
         || ', '
         || IAPICONSTANT.STATUSTYPE_APPROVED
         
         
         
         
         
         
         
         || ''', (decode(:current_only, 1, '''
         || IAPICONSTANT.STATUSTYPE_CURRENT
         
         || ''', '''
         || IAPICONSTANT.STATUSTYPE_CURRENT
         || ', '
         || IAPICONSTANT.STATUSTYPE_APPROVED
         || ', '
         || IAPICONSTANT.STATUSTYPE_HISTORIC
         || ', '
         || IAPICONSTANT.STATUSTYPE_OBSOLETE
         || '''))))),ss.status_type) > 0'
         || ' UNION SELECT H.PART_NO, H.REVISION, H.PLANT, H.ALTERNATIVE, H.BOM_USAGE'
         || ' FROM BOM_HEADER H, SPECIFICATION_HEADER SH, STATUS SS'
         || ' WHERE TRUNC(PLANT_EFFECTIVE_DATE) <= :adExplosionDate'
         || ' AND H.PART_NO = :asPartNo'
         
         || ' AND H.REVISION = :anRevision'
         || ' AND H.PART_NO = SH.PART_NO'
         || ' AND H.REVISION = SH.REVISION'
         || ' AND SH.STATUS = SS.STATUS'
         || ' AND SS.STATUS_TYPE <> DECODE(:anIncludeInDevelopment, 1, ''-'', '''
         || IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         || ''') AND INSTR(DECODE(:current_only, 1, ''-'', (DECODE(:approved_only, 1, ''-'',(DECODE(:historic_only, 1, ''-'','''
         || IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         || ', '
         || IAPICONSTANT.STATUSTYPE_SUBMIT
         || ', '
         || IAPICONSTANT.STATUSTYPE_REJECT
         || '''))))),SS.STATUS_TYPE) > 0'
         || ' AND :anIncludeInDevelopment = 1)'
         || ' )'
         || ' AND (PLANT_EFFECTIVE_DATE, H.PLANT)'
         || ' IN (select max(ped), plant from '
         || ' (SELECT MAX(H.PLANT_EFFECTIVE_DATE) ped, H.plant'
         || ' FROM BOM_HEADER H, SPECIFICATION_HEADER SH, STATUS SS'
         || ' WHERE TRUNC(PLANT_EFFECTIVE_DATE) <= :adExplosionDate'
         || ' AND H.PART_NO = :asPartNo'
         
         || ' AND H.REVISION = :anRevision'
         || ' AND H.PART_NO = SH.PART_NO'
         || ' AND H.REVISION = SH.REVISION'
         || ' AND SH.STATUS = SS.STATUS'
         || ' AND SS.STATUS_TYPE <> DECODE(:anIncludeInDevelopment, 1, ''-'', '''
         || IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         
         
         || ''')' 
         || ' AND h.revision in (select max(h.revision) from BOM_HEADER H, SPECIFICATION_HEADER SH, STATUS SS'
         || '  WHERE TRUNC(PLANT_EFFECTIVE_DATE) <= :adExplosionDate'
         
         
         || ' AND H.PART_NO = :asPartNo AND H.REVISION = :anRevision AND H.PART_NO = SH.PART_NO AND H.REVISION = SH.REVISION AND SH.STATUS = SS.STATUS'
         || ' AND SS.STATUS_TYPE <> DECODE(:anIncludeInDevelopment, 1, ''-'', '''
         || IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         || ''') )'
         
         
         
         
         || ' AND INSTR(decode(:historic_only, 1, '''  
         
         || IAPICONSTANT.STATUSTYPE_CURRENT
         || ', '
         || IAPICONSTANT.STATUSTYPE_APPROVED
         || ', '
         || IAPICONSTANT.STATUSTYPE_HISTORIC
         
         || ''', (decode(:approved_only, 1, '''
         || IAPICONSTANT.STATUSTYPE_CURRENT
         || ', '
         || IAPICONSTANT.STATUSTYPE_APPROVED
         
         
         
         
         
         
         
         || ''', (decode(:current_only, 1, '''
         || IAPICONSTANT.STATUSTYPE_CURRENT
         
         || ''', '''
         || IAPICONSTANT.STATUSTYPE_CURRENT
         || ', '
         || IAPICONSTANT.STATUSTYPE_APPROVED
         || ', '
         || IAPICONSTANT.STATUSTYPE_HISTORIC
         || ', '
         || IAPICONSTANT.STATUSTYPE_OBSOLETE

         || '''))))),ss.status_type) > 0  group by plant'
         || ' UNION ALL SELECT MAX(H.PLANT_EFFECTIVE_DATE) ped, H.plant'
         || ' FROM BOM_HEADER H, SPECIFICATION_HEADER SH, STATUS SS'
         || ' WHERE TRUNC(PLANT_EFFECTIVE_DATE) <= :adExplosionDate'
         || ' AND H.PART_NO = :asPartNo'
         
         || ' AND H.REVISION = :anRevision'
         || ' AND H.PART_NO = SH.PART_NO'
         || ' AND H.REVISION = SH.REVISION'
         || ' AND SH.STATUS = SS.STATUS'
         || ' AND SS.STATUS_TYPE <> DECODE(:anIncludeInDevelopment, 1, ''-'', '''
         || IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         
         
         || ''')'   
         || ' AND h.revision in (select max(h.revision) from BOM_HEADER H, SPECIFICATION_HEADER SH, STATUS SS'
         || '  WHERE TRUNC(PLANT_EFFECTIVE_DATE) <= :adExplosionDate'
         
         
         || ' AND H.PART_NO = :asPartNo AND H.REVISION = :anRevision AND H.PART_NO = SH.PART_NO AND H.REVISION = SH.REVISION AND SH.STATUS = SS.STATUS'
         || ' AND SS.STATUS_TYPE <> DECODE(:anIncludeInDevelopment, 1, ''-'', '''
         || IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         || ''') )'
         || ' AND INSTR(DECODE(:current_only, 1, ''-'', (DECODE(:approved_only, 1, ''-'', (DECODE(:historic_only, 1, ''-'','''  
         
         || IAPICONSTANT.STATUSTYPE_DEVELOPMENT
         || ', '
         || IAPICONSTANT.STATUSTYPE_SUBMIT
         || ', '
         || IAPICONSTANT.STATUSTYPE_REJECT
         || '''))))),SS.STATUS_TYPE) > 0'
         || ' AND :anIncludeInDevelopment = 1 group by plant) group by plant)'
         || ' AND PP.PLANT   = H.PLANT'
         || ' AND PP.PART_NO = H.PART_NO'
         || ' AND PL.PLANT = H.PLANT'
         || ' AND P.PART_NO = H.PART_NO'
         || ' AND ITBU.BOM_USAGE = H.BOM_USAGE'
         
         
         || '';

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      OPEN AQHEADERS FOR LSSQL USING
      SYSDATE,
      '',
      
      0,
      0,
      0,
      0,
      0,
      SYSDATE,
      '',
      
      0,
      0,
      0,
      0,
      0,
      0,
      SYSDATE,
      '',
      
      0,
      0,
      
      SYSDATE,
      '',
      
      0,
      0,
      
      0,
      0,
      0,
      SYSDATE,
      '',
      
      0,
      0,
      
      SYSDATE,
      '',
      
      0,
      0,
      
      0,
      0,
      0,
      
      0;
      
      
      

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
      THEN   
         LSSQL :=    LSSQL
                  || ' AND PP.PLANT_ACCESS = ''Y'''
                  || ' AND H.PLANT IN(SELECT PLANT FROM ITUP WHERE USER_ID = :lsUser)';
      ELSE
         LSSQL :=    LSSQL
                  || ' AND F_CHECK_ACCESS(H.PART_NO, H.REVISION) > 0';
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.VIEWBOMALLOWED = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOVIEWBOMACCESS,
                                                    IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );
      END IF;

      
      LSSQL :=    LSSQL
               || ' AND F_CHECK_ITEM_ACCESS(H.PART_NO, H.REVISION, 0, 0, :SECTIONTYPE_BOM) = 1 ';
      LSSQL :=    LSSQL
               || ' ORDER BY H.PLANT ASC, H.ALTERNATIVE ASC, H.BOM_USAGE ASC';

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
      THEN   
         OPEN AQHEADERS FOR LSSQL
         USING ADEXPLOSIONDATE,
               ASPARTNO,
               
               ANREVISION,
               ANINCLUDEINDEVELOPMENT,
               
               
               
               
               IAPIGENERAL.SESSION.APPLICATIONUSER.HISTORICONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.APPROVEDONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.CURRENTONLYACCESS,
               
               ADEXPLOSIONDATE,
               ASPARTNO,
               
               ANREVISION,
               ANINCLUDEINDEVELOPMENT,
               IAPIGENERAL.SESSION.APPLICATIONUSER.CURRENTONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.APPROVEDONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.HISTORICONLYACCESS,
               ANINCLUDEINDEVELOPMENT,
               ADEXPLOSIONDATE,
               ASPARTNO,
               
               ANREVISION,
               ANINCLUDEINDEVELOPMENT,
               
               ADEXPLOSIONDATE,
               ASPARTNO,
               
               ANREVISION,
               
               
               
               
               
               
               IAPIGENERAL.SESSION.APPLICATIONUSER.HISTORICONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.APPROVEDONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.CURRENTONLYACCESS,
               
               ADEXPLOSIONDATE,
               ASPARTNO,
               
               ANREVISION,
               ANINCLUDEINDEVELOPMENT,
               
               ADEXPLOSIONDATE,
               ASPARTNO,
               
               ANREVISION,
               ANINCLUDEINDEVELOPMENT,
               
               IAPIGENERAL.SESSION.APPLICATIONUSER.CURRENTONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.APPROVEDONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.HISTORICONLYACCESS,
               ANINCLUDEINDEVELOPMENT,
               
               
               
               IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
               IAPICONSTANT.SECTIONTYPE_BOM;
      ELSE
         OPEN AQHEADERS FOR LSSQL
         USING ADEXPLOSIONDATE,
               ASPARTNO,
               
               ANREVISION,
               ANINCLUDEINDEVELOPMENT,
               
               
               
               
               IAPIGENERAL.SESSION.APPLICATIONUSER.HISTORICONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.APPROVEDONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.CURRENTONLYACCESS,
               
               ADEXPLOSIONDATE,
               ASPARTNO,
               
               ANREVISION,
               ANINCLUDEINDEVELOPMENT,
               IAPIGENERAL.SESSION.APPLICATIONUSER.CURRENTONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.APPROVEDONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.HISTORICONLYACCESS,
               ANINCLUDEINDEVELOPMENT,
               ADEXPLOSIONDATE,
               ASPARTNO,
               
               ANREVISION,
               ANINCLUDEINDEVELOPMENT,
               
               ADEXPLOSIONDATE,
               ASPARTNO,
               
               ANREVISION,
               ANINCLUDEINDEVELOPMENT,
               
               
               
               
               
               IAPIGENERAL.SESSION.APPLICATIONUSER.HISTORICONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.APPROVEDONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.CURRENTONLYACCESS,
               
               ADEXPLOSIONDATE,
               ASPARTNO,
               
               ANREVISION,
               ANINCLUDEINDEVELOPMENT,
               
               ADEXPLOSIONDATE,
               ASPARTNO,
               
               ANREVISION,
               ANINCLUDEINDEVELOPMENT,
               
               IAPIGENERAL.SESSION.APPLICATIONUSER.CURRENTONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.APPROVEDONLYACCESS,
               IAPIGENERAL.SESSION.APPLICATIONUSER.HISTORICONLYACCESS,
               ANINCLUDEINDEVELOPMENT,
               
               
               
               IAPICONSTANT.SECTIONTYPE_BOM;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETEXPLOSIONHEADERS2;



   FUNCTION GETITEMS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE DEFAULT NULL,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE DEFAULT NULL,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE DEFAULT NULL,
      ANINCLUDEALTERNATIVES      IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      AQITEMS                    OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetItems';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      
      
      LRBOMITEM                     IAPITYPE.BOMITEMREC_TYPE;
      
      LRGETBOMITEM                  BOMITEMRECORD_TYPE
         := BOMITEMRECORD_TYPE( NULL,
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
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      
      
      GTBOMITEMS.DELETE;
      
      LRBOMITEM.PARTNO := ASPARTNO;
      LRBOMITEM.REVISION := ANREVISION;
      LRBOMITEM.PLANT := ASPLANT;
      LRBOMITEM.ALTERNATIVE := ANALTERNATIVE;
      LRBOMITEM.BOMUSAGE := ANUSAGE;
      
      
      GTBOMITEMS( 0 ) := LRBOMITEM;
      

      
      
      
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

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=
            'SELECT a.PART_NO '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', a.Revision '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', a.PLANT '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', a.ALTERNATIVE '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', a.BOM_USAGE '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', a.item_number '
         || IAPICONSTANTCOLUMN.ITEMNUMBERCOL
         || ', a.alt_group '
         || IAPICONSTANTCOLUMN.BOMALTGROUPCOL
         || ', a.alt_priority '
         || IAPICONSTANTCOLUMN.BOMALTPRIORITYCOL
         || ', a.component_part '
         || IAPICONSTANTCOLUMN.COMPONENTPARTNOCOL
         || ', a.component_Revision '
         || IAPICONSTANTCOLUMN.COMPONENTREVISIONCOL
         || ', f_sh_descr( 1, a.component_part, a.component_revision) '
         || IAPICONSTANTCOLUMN.COMPONENTDESCRIPTIONCOL
         || ', a.component_plant '
         || IAPICONSTANTCOLUMN.COMPONENTPLANTCOL
         
         
         
         
         || ', f_part_source(a.component_part) '
         || IAPICONSTANTCOLUMN.PARTSOURCECOL
         || ', f_part_Type_grp(a.component_part) '
         || IAPICONSTANTCOLUMN.SPECIFICATIONTYPEGROUPCOL
         || ', f_convert_base(a.quantity, iapiUomGroups.GetUomId(a.uom), iapiUomGroups.GetUomId(iapiSpecificationBom.GetUomDescription(a.component_part, a.component_revision, a.component_plant, iapiUomGroups.GetUomId(a.uom), a.Part_No, a.Revision ))  )'   
         || IAPICONSTANTCOLUMN.QUANTITYCOL
         || ', iapiSpecificationBom.GetUomDescription(a.component_part, a.component_revision, a.component_plant, iapiUomGroups.GetUomId(a.uom), a.Part_No, a.Revision ) '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ', round(a.conv_factor,10) '
         || IAPICONSTANTCOLUMN.CONVERSIONFACTORCOL
         || ', a.to_unit '
         || IAPICONSTANTCOLUMN.TOUNITCOL
         || ', a.yield '
         || IAPICONSTANTCOLUMN.YIELDCOL
         || ', a.assembly_scrap '
         || IAPICONSTANTCOLUMN.ASSEMBLYSCRAPCOL
         || ', a.component_scrap '
         || IAPICONSTANTCOLUMN.COMPONENTSCRAPCOL
         || ', a.lead_time_offset '
         || IAPICONSTANTCOLUMN.LEADTIMEOFFSETCOL
         || ', a.relevency_to_costing '
         || IAPICONSTANTCOLUMN.RELEVANCYTOCOSTINGCOL
         || ', a.bulk_material '
         || IAPICONSTANTCOLUMN.BULKMATERIALCOL
         || ', a.item_category '
         || IAPICONSTANTCOLUMN.ITEMCATEGORYCOL
         || ', f_item_category_desc(a.item_category, f_part_source(a.PART_NO))'
         || IAPICONSTANTCOLUMN.ITEMCATEGORYDESCRCOL
         || ', a.issue_location '
         || IAPICONSTANTCOLUMN.ISSUELOCATIONCOL
         || ', a.calc_flag '
         || IAPICONSTANTCOLUMN.CALCULATIONMODECOL
         || ', a.bom_item_Type '
         || IAPICONSTANTCOLUMN.BOMTYPECOL
         || ', a.operational_step '
         || IAPICONSTANTCOLUMN.OPERATIONALSTEPCOL
         || ', a.min_qty '
         || IAPICONSTANTCOLUMN.MINIMUMQUANTITYCOL
         || ', a.max_qty '
         || IAPICONSTANTCOLUMN.MAXIMUMQUANTITYCOL
         || ', a.fixed_qty '
         || IAPICONSTANTCOLUMN.FIXEDQUANTITYCOL
         || ', a.code '
         || IAPICONSTANTCOLUMN.CODECOL
         || ', a.CHAR_1 '
         || IAPICONSTANTCOLUMN.STRING1COL
         || ', a.CHAR_2 '
         || IAPICONSTANTCOLUMN.STRING2COL
         || ', a.CHAR_3 '
         || IAPICONSTANTCOLUMN.STRING3COL
         || ', a.CHAR_4 '
         || IAPICONSTANTCOLUMN.STRING4COL
         || ', a.CHAR_5 '
         || IAPICONSTANTCOLUMN.STRING5COL
         || ', round(a.NUM_1,10) '
         || IAPICONSTANTCOLUMN.NUMERIC1COL
         || ', round(a.NUM_2,10) '
         || IAPICONSTANTCOLUMN.NUMERIC2COL
         || ', round(a.NUM_3,10) '
         || IAPICONSTANTCOLUMN.NUMERIC3COL
         || ', round(a.NUM_4,10) '
         || IAPICONSTANTCOLUMN.NUMERIC4COL
         || ', round(a.NUM_5,10) '
         || IAPICONSTANTCOLUMN.NUMERIC5COL
         || ', a.Boolean_1 '
         || IAPICONSTANTCOLUMN.BOOLEAN1COL
         || ', a.Boolean_2 '
         || IAPICONSTANTCOLUMN.BOOLEAN2COL
         || ', a.Boolean_3 '
         || IAPICONSTANTCOLUMN.BOOLEAN3COL
         || ', a.Boolean_4 '
         || IAPICONSTANTCOLUMN.BOOLEAN4COL
         || ', a.DATE_1 '
         || IAPICONSTANTCOLUMN.DATE1COL
         || ', a.DATE_2 '
         || IAPICONSTANTCOLUMN.DATE2COL
         || ', a.CH_1 '
         || IAPICONSTANTCOLUMN.CHARACTERISTICID1COL
         || ', 0 '
         || IAPICONSTANTCOLUMN.CHARACTERISTICREVISION1COL
         || ', a.CH_2 '
         || IAPICONSTANTCOLUMN.CHARACTERISTICID2COL
         || ', 0 '
         || IAPICONSTANTCOLUMN.CHARACTERISTICREVISION2COL
         || ', a.CH_3 '
         || IAPICONSTANTCOLUMN.CHARACTERISTICID3COL
         || ', 0 '
         || IAPICONSTANTCOLUMN.CHARACTERISTICREVISION3COL
         || ', f_chh_descr(0,a.CH_1,NVL(a.CH_REV_1,0)) '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION1COL
         || ', f_chh_descr(0,a.CH_2,NVL(a.CH_REV_2,0)) '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION2COL
         || ', f_chh_descr(0,a.CH_3,NVL(a.CH_REV_3,0)) '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION3COL
         || ', a.MAKE_UP '
         || IAPICONSTANTCOLUMN.MAKEUPCOL
         || ', a.INTL_EQUIVALENT '
         || IAPICONSTANTCOLUMN.INTERNATIONALEQUIVALENTCOL
         || ', CASE f_check_access(a.component_part,a.component_Revision) '
         || ' WHEN 1 THEN 1 '
         || ' ELSE 0 '
         || ' END '
         || IAPICONSTANTCOLUMN.VIEWBOMACCESSCOL
         || ', a.component_scrap_sync '
         || IAPICONSTANTCOLUMN.COMPONENTSCRAPSYNCCOL
         || ', f_get_spec_owner(a.component_part, DECODE( a.component_Revision, NULL, 0, a.component_Revision )) '
         || IAPICONSTANTCOLUMN.OWNERCOL;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
      THEN   
         LSSQL :=
               LSSQL
            || ' FROM BOM_ITEM a, PART_PLANT, PLANT'
            || ' WHERE a.PART_NO = :asPartNo'
            || ' AND a.PLANT = PLANT.PLANT'
            || ' AND a.PART_NO = PART_PLANT.PART_NO'
            || ' AND a.PLANT = PART_PLANT.PLANT'
            || ' AND PART_PLANT.PLANT_ACCESS = ''Y'''
            || ' AND a.PLANT IN(SELECT PLANT FROM ITUP WHERE USER_ID =  :lsUser)';
      ELSE   
         LSSQL :=    LSSQL
                  || ' FROM BOM_ITEM a'
                  || ' WHERE a.PART_NO = :asPartNo'
                  || ' AND DECODE (:lsUser, NULL, 0, 0) = 0';
      END IF;

      LSSQL :=
            LSSQL
         || ' AND a.Revision = :anRevision'
         || ' AND a.plant = NVL(:asPlant,a.plant) '
         || ' AND a.alternative = NVL(:anAlternative, a.alternative)'
         || ' AND a.bom_usage = NVL(:anUsage, a.bom_usage)'
         || ' AND a.alt_priority < DECODE( :anIncludeAlternatives, 1, 100, 2)';
      
      LSSQL :=    LSSQL
               || ' AND F_CHECK_ITEM_ACCESS(a.part_no, a.revision, 0, 0, :SectionType) = 1 ';
      LSSQL :=    LSSQL
               || ' ORDER BY a.ITEM_NUMBER';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );
      LNRETVAL := IAPISPECIFICATIONACCESS.GETVIEWACCESS( ASPARTNO,
                                                         ANREVISION,
                                                         LNACCESS );

      IF    LNRETVAL <>( IAPICONSTANTDBERROR.DBERR_SUCCESS )
         OR LNACCESS = 0
         OR IAPIGENERAL.SESSION.APPLICATIONUSER.VIEWBOMALLOWED = 0
      THEN
         OPEN AQITEMS FOR LSSQL USING '',
         '',
         0,
         '',
         0,
         0,
         0,
         0;
      END IF;

      IF LNRETVAL <>( IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN LNRETVAL;
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

      OPEN AQITEMS FOR LSSQL
      USING ASPARTNO,
            IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
            ANREVISION,
            ASPLANT,
            ANALTERNATIVE,
            ANUSAGE,
            ANINCLUDEALTERNATIVES,
            IAPICONSTANT.SECTIONTYPE_BOM;
      
      
      
      GTGETBOMITEMS.DELETE;

      LOOP
         LRBOMITEM := NULL;

         FETCH AQITEMS
          INTO LRBOMITEM;

         EXIT WHEN AQITEMS%NOTFOUND;
         LRGETBOMITEM.PARTNO := LRBOMITEM.PARTNO;
         LRGETBOMITEM.REVISION := LRBOMITEM.REVISION;
         LRGETBOMITEM.PLANT := LRBOMITEM.PLANT;
         LRGETBOMITEM.ALTERNATIVE := LRBOMITEM.ALTERNATIVE;
         LRGETBOMITEM.BOMUSAGE := LRBOMITEM.BOMUSAGE;
         LRGETBOMITEM.ITEMNUMBER := LRBOMITEM.ITEMNUMBER;
         LRGETBOMITEM.ALTERNATIVEGROUP := LRBOMITEM.ALTERNATIVEGROUP;
         LRGETBOMITEM.ALTERNATIVEPRIORITY := LRBOMITEM.ALTERNATIVEPRIORITY;
         LRGETBOMITEM.COMPONENTPARTNO := LRBOMITEM.COMPONENTPARTNO;
         LRGETBOMITEM.COMPONENTREVISION := LRBOMITEM.COMPONENTREVISION;
         LRGETBOMITEM.COMPONENTDESCRIPTION := LRBOMITEM.COMPONENTDESCRIPTION;
         LRGETBOMITEM.COMPONENTPLANT := LRBOMITEM.COMPONENTPLANT;
         LRGETBOMITEM.PARTSOURCE := LRBOMITEM.PARTSOURCE;
         LRGETBOMITEM.PARTTYPEGROUP := LRBOMITEM.PARTTYPEGROUP;
         LRGETBOMITEM.QUANTITY := LRBOMITEM.QUANTITY;
         LRGETBOMITEM.UOM := LRBOMITEM.UOM;
         LRGETBOMITEM.CONVERSIONFACTOR := LRBOMITEM.CONVERSIONFACTOR;
         LRGETBOMITEM.CONVERTEDUOM := LRBOMITEM.CONVERTEDUOM;
         LRGETBOMITEM.YIELD := LRBOMITEM.YIELD;
         LRGETBOMITEM.ASSEMBLYSCRAP := LRBOMITEM.ASSEMBLYSCRAP;
         LRGETBOMITEM.COMPONENTSCRAP := LRBOMITEM.COMPONENTSCRAP;
         LRGETBOMITEM.LEADTIMEOFFSET := LRBOMITEM.LEADTIMEOFFSET;
         LRGETBOMITEM.RELEVANCYTOCOSTING := LRBOMITEM.RELEVANCYTOCOSTING;
         LRGETBOMITEM.BULKMATERIAL := LRBOMITEM.BULKMATERIAL;
         LRGETBOMITEM.ITEMCATEGORY := LRBOMITEM.ITEMCATEGORY;
         LRGETBOMITEM.ITEMCATEGORYDESCR := LRBOMITEM.ITEMCATEGORYDESCR;
         LRGETBOMITEM.ISSUELOCATION := LRBOMITEM.ISSUELOCATION;
         LRGETBOMITEM.CALCULATIONMODE := LRBOMITEM.CALCULATIONMODE;
         LRGETBOMITEM.BOMITEMTYPE := LRBOMITEM.BOMITEMTYPE;
         LRGETBOMITEM.OPERATIONALSTEP := LRBOMITEM.OPERATIONALSTEP;
         LRGETBOMITEM.MINIMUMQUANTITY := LRBOMITEM.MINIMUMQUANTITY;
         LRGETBOMITEM.MAXIMUMQUANTITY := LRBOMITEM.MAXIMUMQUANTITY;
         LRGETBOMITEM.FIXEDQUANTITY := LRBOMITEM.FIXEDQUANTITY;
         LRGETBOMITEM.CODE := LRBOMITEM.CODE;
         LRGETBOMITEM.TEXT1 := LRBOMITEM.TEXT1;
         LRGETBOMITEM.TEXT2 := LRBOMITEM.TEXT2;
         LRGETBOMITEM.TEXT3 := LRBOMITEM.TEXT3;
         LRGETBOMITEM.TEXT4 := LRBOMITEM.TEXT4;
         LRGETBOMITEM.TEXT5 := LRBOMITEM.TEXT5;
         LRGETBOMITEM.NUMERIC1 := LRBOMITEM.NUMERIC1;
         LRGETBOMITEM.NUMERIC2 := LRBOMITEM.NUMERIC2;
         LRGETBOMITEM.NUMERIC3 := LRBOMITEM.NUMERIC3;
         LRGETBOMITEM.NUMERIC4 := LRBOMITEM.NUMERIC4;
         LRGETBOMITEM.NUMERIC5 := LRBOMITEM.NUMERIC5;
         LRGETBOMITEM.BOOLEAN1 := LRBOMITEM.BOOLEAN1;
         LRGETBOMITEM.BOOLEAN2 := LRBOMITEM.BOOLEAN2;
         LRGETBOMITEM.BOOLEAN3 := LRBOMITEM.BOOLEAN3;
         LRGETBOMITEM.BOOLEAN4 := LRBOMITEM.BOOLEAN4;
         LRGETBOMITEM.DATE1 := LRBOMITEM.DATE1;
         LRGETBOMITEM.DATE2 := LRBOMITEM.DATE2;
         LRGETBOMITEM.CHARACTERISTIC1 := LRBOMITEM.CHARACTERISTIC1;
         LRGETBOMITEM.CHARACTERISTIC1REVISION := LRBOMITEM.CHARACTERISTIC1REVISION;
         LRGETBOMITEM.CHARACTERISTIC2 := LRBOMITEM.CHARACTERISTIC2;
         LRGETBOMITEM.CHARACTERISTIC2REVISION := LRBOMITEM.CHARACTERISTIC2REVISION;
         LRGETBOMITEM.CHARACTERISTIC3 := LRBOMITEM.CHARACTERISTIC3;
         LRGETBOMITEM.CHARACTERISTIC3REVISION := LRBOMITEM.CHARACTERISTIC3REVISION;
         LRGETBOMITEM.CHARACTERISTIC1DESCRIPTION := LRBOMITEM.CHARACTERISTIC1DESCRIPTION;
         LRGETBOMITEM.CHARACTERISTIC2DESCRIPTION := LRBOMITEM.CHARACTERISTIC2DESCRIPTION;
         LRGETBOMITEM.CHARACTERISTIC3DESCRIPTION := LRBOMITEM.CHARACTERISTIC3DESCRIPTION;
         LRGETBOMITEM.MAKEUP := LRBOMITEM.MAKEUP;
         LRGETBOMITEM.INTERNATIONALEQUIVALENT := LRBOMITEM.INTERNATIONALEQUIVALENT;
         LRGETBOMITEM.VIEWBOMACCESS := LRBOMITEM.VIEWBOMACCESS;
         LRGETBOMITEM.COMPONENTSCRAPSYNC := LRBOMITEM.COMPONENTSCRAPSYNC;
         LRGETBOMITEM.OWNER := LRBOMITEM.OWNER;
         GTGETBOMITEMS.EXTEND;
         GTGETBOMITEMS( GTGETBOMITEMS.COUNT ) := LRGETBOMITEM;
      END LOOP;

      CLOSE AQITEMS;

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      OPEN AQITEMS FOR LSSQL USING '',
      '',
      0,
      '',
      0,
      0,
      0,
      0;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Post-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     LSMETHOD,
                                                     'POST',
                                                     GTERRORS );
      LSSQL :=
            'PartNo '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', Revision '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', Plant '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', Alternative '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', BomUsage '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', ItemNumber '
         || IAPICONSTANTCOLUMN.ITEMNUMBERCOL
         || ', AlternativeGroup '
         || IAPICONSTANTCOLUMN.BOMALTGROUPCOL
         || ', AlternativePriority '
         || IAPICONSTANTCOLUMN.BOMALTPRIORITYCOL
         || ', ComponentPartNo '
         || IAPICONSTANTCOLUMN.COMPONENTPARTNOCOL
         || ', ComponentRevision '
         || IAPICONSTANTCOLUMN.COMPONENTREVISIONCOL
         || ', ComponentDescription '
         || IAPICONSTANTCOLUMN.COMPONENTDESCRIPTIONCOL
         || ', ComponentPlant '
         || IAPICONSTANTCOLUMN.COMPONENTPLANTCOL
         || ', PartSource '
         || IAPICONSTANTCOLUMN.PARTSOURCECOL
         || ', PartTypeGroup '
         || IAPICONSTANTCOLUMN.SPECIFICATIONTYPEGROUPCOL
         || ', Quantity '
         || IAPICONSTANTCOLUMN.QUANTITYCOL
         || ', Uom '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ', ConversionFactor '
         || IAPICONSTANTCOLUMN.CONVERSIONFACTORCOL
         || ', ConvertedUom '
         || IAPICONSTANTCOLUMN.TOUNITCOL
         || ', Yield '
         || IAPICONSTANTCOLUMN.YIELDCOL
         || ', AssemblyScrap '
         || IAPICONSTANTCOLUMN.ASSEMBLYSCRAPCOL
         || ', ComponentScrap '
         || IAPICONSTANTCOLUMN.COMPONENTSCRAPCOL
         || ', LeadTimeOffset '
         || IAPICONSTANTCOLUMN.LEADTIMEOFFSETCOL
         || ', RelevancyToCosting '
         || IAPICONSTANTCOLUMN.RELEVANCYTOCOSTINGCOL
         || ', BulkMaterial '
         || IAPICONSTANTCOLUMN.BULKMATERIALCOL
         || ', ItemCategory '
         || IAPICONSTANTCOLUMN.ITEMCATEGORYCOL
         || ', ItemCategoryDescr '
         || IAPICONSTANTCOLUMN.ITEMCATEGORYDESCRCOL
         || ', IssueLocation '
         || IAPICONSTANTCOLUMN.ISSUELOCATIONCOL
         || ', CalculationMode '
         || IAPICONSTANTCOLUMN.CALCULATIONMODECOL
         || ', BomItemType '
         || IAPICONSTANTCOLUMN.BOMTYPECOL
         || ', OperationalStep '
         || IAPICONSTANTCOLUMN.OPERATIONALSTEPCOL
         || ', MinimumQuantity '
         || IAPICONSTANTCOLUMN.MINIMUMQUANTITYCOL
         || ', MaximumQuantity '
         || IAPICONSTANTCOLUMN.MAXIMUMQUANTITYCOL
         || ', FixedQuantity '
         || IAPICONSTANTCOLUMN.FIXEDQUANTITYCOL
         || ', Code '
         || IAPICONSTANTCOLUMN.CODECOL
         || ', Text1 '
         || IAPICONSTANTCOLUMN.STRING1COL
         || ', Text2 '
         || IAPICONSTANTCOLUMN.STRING2COL
         || ', Text3 '
         || IAPICONSTANTCOLUMN.STRING3COL
         || ', Text4 '
         || IAPICONSTANTCOLUMN.STRING4COL
         || ', Text5 '
         || IAPICONSTANTCOLUMN.STRING5COL
         || ', round(Numeric1,10) '
         || IAPICONSTANTCOLUMN.NUMERIC1COL
         || ', round(Numeric2,10) '
         || IAPICONSTANTCOLUMN.NUMERIC2COL
         || ', round(Numeric3,10) '
         || IAPICONSTANTCOLUMN.NUMERIC3COL
         || ', round(Numeric4,10) '
         || IAPICONSTANTCOLUMN.NUMERIC4COL
         || ', round(Numeric5,10) '
         || IAPICONSTANTCOLUMN.NUMERIC5COL
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
         || ', Characteristic1 '
         || IAPICONSTANTCOLUMN.CHARACTERISTICID1COL
         || ', 0 '
         || IAPICONSTANTCOLUMN.CHARACTERISTICREVISION1COL
         || ', Characteristic2 '
         || IAPICONSTANTCOLUMN.CHARACTERISTICID2COL
         || ', 0 '
         || IAPICONSTANTCOLUMN.CHARACTERISTICREVISION2COL
         || ', Characteristic3 '
         || IAPICONSTANTCOLUMN.CHARACTERISTICID3COL
         || ', 0 '
         || IAPICONSTANTCOLUMN.CHARACTERISTICREVISION3COL
         || ', Characteristic1Description '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION1COL
         || ', Characteristic2Description '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION2COL
         || ', Characteristic3Description '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION3COL
         || ', MakeUp '
         || IAPICONSTANTCOLUMN.MAKEUPCOL
         || ', InternationalEquivalent '
         || IAPICONSTANTCOLUMN.INTERNATIONALEQUIVALENTCOL
         || ', ViewBomAccess '
         || IAPICONSTANTCOLUMN.VIEWBOMACCESSCOL
         || ', ComponentScrapSync '
         || IAPICONSTANTCOLUMN.COMPONENTSCRAPSYNCCOL
         || ', Owner '
         || IAPICONSTANTCOLUMN.OWNERCOL;
      LSSQL :=    'SELECT '
               || LSSQL
               || ' FROM TABLE( CAST( :gtGetBomItems AS BomItemTable_Type ) ) ';

      
      IF ( AQITEMS%ISOPEN )
      THEN
         CLOSE AQITEMS;
      END IF;

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQITEMS FOR LSSQL USING GTGETBOMITEMS;

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

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         OPEN AQITEMS FOR LSSQL USING '',
         '',
         '',
         0,
         '',
         0,
         0,
         0,
         0;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETITEMS;

   FUNCTION GETUOMDESCRIPTION(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE DEFAULT NULL,
      ANUOMID                    IN       IAPITYPE.ID_TYPE,
      ASPARTNOPARENT             IN       IAPITYPE.PARTNO_TYPE,
      ANREVISIONPARENT           IN       IAPITYPE.REVISION_TYPE )
      
      
   RETURN IAPITYPE.DESCRIPTION_TYPE
   IS
       
       
       
       
      
       
       
       
       
       
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUomDescription';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNUOMID                       IAPITYPE.ID_TYPE;
      LSDESCRIPTION                 IAPITYPE.DESCRIPTION_TYPE;
      LNUOMTYPE                     IAPITYPE.BOOLEAN_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LBENABLEBOM                   IAPITYPE.BOOLEAN_TYPE := 1;
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
      LNSTATUS                      IAPITYPE.STATUSID_TYPE;
      LNACCESSGROUP                 IAPITYPE.ID_TYPE;
      LNWORKFLOWGROUP               IAPITYPE.ID_TYPE;
      LNTYPE                        IAPITYPE.SPECIFICATIONSECTIONTYPE_TYPE;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LQPART                        IAPITYPE.REF_TYPE;
      LQERRORS                      IAPITYPE.REF_TYPE;
      LTPART                        IAPITYPE.PARTTAB_TYPE;
   
   
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPIUOMGROUPS.GETTYPEUOM( ANUOMID,
                                            LNUOMTYPE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNUOMID := ANUOMID;

      

      
      
      
      IF ( NOT IAPIUOMGROUPS.ISSAMEMODETYPE( LNUOMTYPE ) )
      THEN
         
         LNRETVAL := IAPIUOMGROUPS.GETALTERNATIVEUOMBASE( ANUOMID,
                                                          LNUOMID );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END IF;

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

      IF ( LNACCESS = 0 )
      THEN
         
         IF ( NOT IAPIUOMGROUPS.ISSAMEMODETYPE( LNUOMTYPE ) )
         THEN
            
            LNRETVAL := IAPIUOMGROUPS.GETALTERNATIVEUOMBASE( ANUOMID,
                                                             LNUOMID );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    IAPIGENERAL.GETLASTERRORTEXT( ) );
               RETURN( LNRETVAL );
            END IF;
         ELSE
            LNUOMID := ANUOMID;
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
                  AND LANG_ID = IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID
                  AND MAX_REV = 1;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  SELECT DESCRIPTION
                    INTO LSDESCRIPTION
                    FROM UOM_H
                   WHERE UOM_ID = LNUOMID
                     AND MAX_REV = 1
                     AND LANG_ID = 1;
            END;
         END IF;
      END IF;

      RETURN( LSDESCRIPTION );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( NULL );
   END GETUOMDESCRIPTION;


   FUNCTION GETMRPITEMS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE DEFAULT NULL,
      ANSPECTYPE                 IN       IAPITYPE.ID_TYPE DEFAULT 0,
      AQITEMS                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetMRPItems';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSSQL                         VARCHAR2( 20000 );
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=
            'SELECT distinct BOM_ITEM.PART_NO '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', BOM_ITEM.REVISION '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', F_SH_DESCR(1, BOM_ITEM.PART_NO, BOM_ITEM.REVISION) '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ', F_PART_SOURCE(BOM_ITEM.PART_NO) '
         || IAPICONSTANTCOLUMN.PARTSOURCECOL
         || ', BOM_ITEM.PLANT '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', BOM_ITEM.ALTERNATIVE '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', BOM_ITEM.BOM_USAGE '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', STATUS.SORT_DESC '
         || IAPICONSTANTCOLUMN.STATUSNAMECOL
         || ', BOM_ITEM.ITEM_NUMBER '
         || IAPICONSTANTCOLUMN.ITEMNUMBERCOL
         || ', BOM_ITEM.ALT_GROUP '
         || IAPICONSTANTCOLUMN.BOMALTGROUPCOL
         || ', BOM_ITEM.ALT_PRIORITY '
         || IAPICONSTANTCOLUMN.BOMALTPRIORITYCOL
         || ', BOM_ITEM.COMPONENT_PART '
         || IAPICONSTANTCOLUMN.COMPONENTPARTNOCOL
         || ', BOM_ITEM.COMPONENT_REVISION '
         || IAPICONSTANTCOLUMN.COMPONENTREVISIONCOL
         || ', BOM_ITEM.COMPONENT_PLANT '
         || IAPICONSTANTCOLUMN.COMPONENTPLANTCOL
         || ', BOM_ITEM.QUANTITY '
         || IAPICONSTANTCOLUMN.QUANTITYCOL
         || ', BOM_ITEM.UOM '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ', round(BOM_ITEM.CONV_FACTOR,10) '
         || IAPICONSTANTCOLUMN.CONVERSIONFACTORCOL
         || ', BOM_ITEM.TO_UNIT '
         || IAPICONSTANTCOLUMN.TOUNITCOL
         || ', BOM_ITEM.YIELD '
         || IAPICONSTANTCOLUMN.YIELDCOL
         || ', BOM_ITEM.ASSEMBLY_SCRAP '
         || IAPICONSTANTCOLUMN.ASSEMBLYSCRAPCOL
         || ', BOM_ITEM.COMPONENT_SCRAP '
         || IAPICONSTANTCOLUMN.COMPONENTSCRAPCOL
         || ', BOM_ITEM.LEAD_TIME_OFFSET '
         || IAPICONSTANTCOLUMN.LEADTIMEOFFSETCOL
         || ', BOM_ITEM.RELEVENCY_TO_COSTING '
         || IAPICONSTANTCOLUMN.RELEVANCYTOCOSTINGCOL
         || ', BOM_ITEM.BULK_MATERIAL '
         || IAPICONSTANTCOLUMN.BULKMATERIALCOL
         || ', BOM_ITEM.ITEM_CATEGORY '
         || IAPICONSTANTCOLUMN.ITEMCATEGORYCOL
         || ', F_ITEM_CATEGORY_DESC(BOM_ITEM.ITEM_CATEGORY, F_PART_SOURCE(BOM_ITEM.PART_NO))'
         || IAPICONSTANTCOLUMN.ITEMCATEGORYDESCRCOL
         || ', BOM_ITEM.ISSUE_LOCATION '
         || IAPICONSTANTCOLUMN.ISSUELOCATIONCOL
         || ', BOM_ITEM.CALC_FLAG '
         || IAPICONSTANTCOLUMN.CALCULATIONMODECOL
         || ', BOM_ITEM.BOM_ITEM_TYPE '
         || IAPICONSTANTCOLUMN.BOMTYPECOL
         || ', BOM_ITEM.OPERATIONAL_STEP '
         || IAPICONSTANTCOLUMN.OPERATIONALSTEPCOL
         || ', BOM_ITEM.MIN_QTY '
         || IAPICONSTANTCOLUMN.MINIMUMQUANTITYCOL
         || ', BOM_ITEM.MAX_QTY '
         || IAPICONSTANTCOLUMN.MAXIMUMQUANTITYCOL
         || ', BOM_ITEM.FIXED_QTY '
         || IAPICONSTANTCOLUMN.FIXEDQUANTITYCOL
         || ', BOM_ITEM.CODE '
         || IAPICONSTANTCOLUMN.CODECOL
         || ', BOM_ITEM.CHAR_1 '
         || IAPICONSTANTCOLUMN.STRING1COL
         || ', BOM_ITEM.CHAR_2 '
         || IAPICONSTANTCOLUMN.STRING2COL
         || ', BOM_ITEM.CHAR_3 '
         || IAPICONSTANTCOLUMN.STRING3COL
         || ', BOM_ITEM.CHAR_4 '
         || IAPICONSTANTCOLUMN.STRING4COL
         || ', BOM_ITEM.CHAR_5 '
         || IAPICONSTANTCOLUMN.STRING5COL
         || ', round(BOM_ITEM.NUM_1,10) '
         || IAPICONSTANTCOLUMN.NUMERIC1COL
         || ', round(BOM_ITEM.NUM_2,10) '
         || IAPICONSTANTCOLUMN.NUMERIC2COL
         || ', round(BOM_ITEM.NUM_3,10) '
         || IAPICONSTANTCOLUMN.NUMERIC3COL
         || ', round(BOM_ITEM.NUM_4,10) '
         || IAPICONSTANTCOLUMN.NUMERIC4COL
         || ', round(BOM_ITEM.NUM_5,10) '
         || IAPICONSTANTCOLUMN.NUMERIC5COL
         || ', BOM_ITEM.BOOLEAN_1 '
         || IAPICONSTANTCOLUMN.BOOLEAN1COL
         || ', BOM_ITEM.BOOLEAN_2 '
         || IAPICONSTANTCOLUMN.BOOLEAN2COL
         || ', BOM_ITEM.BOOLEAN_3 '
         || IAPICONSTANTCOLUMN.BOOLEAN3COL
         || ', BOM_ITEM.BOOLEAN_4 '
         || IAPICONSTANTCOLUMN.BOOLEAN4COL
         || ', BOM_ITEM.DATE_1 '
         || IAPICONSTANTCOLUMN.DATE1COL
         || ', BOM_ITEM.DATE_2 '
         || IAPICONSTANTCOLUMN.DATE2COL
         || ', BOM_ITEM.CH_1 '
         || IAPICONSTANTCOLUMN.CHARACTERISTICID1COL
         || ', BOM_ITEM.CH_2 '
         || IAPICONSTANTCOLUMN.CHARACTERISTICID2COL
         || ', BOM_ITEM.CH_3 '
         || IAPICONSTANTCOLUMN.CHARACTERISTICID3COL
         || ', F_CHH_DESCR(0,BOM_ITEM.CH_1, NVL(BOM_ITEM.CH_REV_1, 0)) '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION1COL
         || ', F_CHH_DESCR(0,BOM_ITEM.CH_2, NVL(BOM_ITEM.CH_REV_2, 0)) '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION2COL
         || ', F_CHH_DESCR(0,BOM_ITEM.CH_3, NVL(BOM_ITEM.CH_REV_3, 0)) '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION3COL
         || ', MAKE_UP '
         || IAPICONSTANTCOLUMN.MAKEUPCOL
         || ', BOM_ITEM.INTL_EQUIVALENT '
         || IAPICONSTANTCOLUMN.INTERNATIONALEQUIVALENTCOL
         || ', BOM_ITEM.COMPONENT_SCRAP_SYNC '
         || IAPICONSTANTCOLUMN.COMPONENTSCRAPSYNCCOL
         || ', F_GET_SPEC_OWNER(BOM_ITEM.COMPONENT_PART, DECODE( BOM_ITEM.COMPONENT_REVISION , NULL, 0, BOM_ITEM.COMPONENT_REVISION  )) '
         || IAPICONSTANTCOLUMN.OWNERCOL
         || ' FROM BOM_ITEM, SPECIFICATION_HEADER, STATUS, USER_GROUP, USER_GROUP_LIST, USER_ACCESS_GROUP'
         || ' WHERE BOM_ITEM.COMPONENT_PART = :asPartNo'
         || ' AND SPECIFICATION_HEADER.PART_NO = BOM_ITEM.PART_NO'
         || ' AND SPECIFICATION_HEADER.REVISION = BOM_ITEM.REVISION'
         || ' AND STATUS.STATUS_TYPE NOT IN (''HISTORIC'', ''OBSOLETE'')'
         || ' AND SPECIFICATION_HEADER.STATUS = STATUS.STATUS'
         || ' AND USER_GROUP.USER_GROUP_ID = USER_GROUP_LIST.USER_GROUP_ID'
         || ' AND USER_GROUP.USER_GROUP_ID = USER_ACCESS_GROUP.USER_GROUP_ID'
         || ' AND SPECIFICATION_HEADER.ACCESS_GROUP = USER_ACCESS_GROUP.ACCESS_GROUP'
         || ' AND USER_GROUP_LIST.USER_ID = :lsUser'
         || ' AND USER_ACCESS_GROUP.MRP_UPDATE = ''Y''';

      IF    ASPLANT IS NULL
         OR ASPLANT = ''
      THEN
         LSSQL :=    LSSQL
                  || ' AND DECODE(:asPlant, NULL, 0, 0) = 0';
      ELSE
         LSSQL :=    LSSQL
                  || ' AND BOM_ITEM.COMPONENT_PLANT = :asPlant';
      END IF;

      IF    ANSPECTYPE IS NULL
         OR ANSPECTYPE = 0
      THEN
         LSSQL :=    LSSQL
                  || ' AND DECODE(:anSpecType, NULL, 0, 0) = 0';
      ELSE
         LSSQL :=    LSSQL
                  || ' AND specification_header.class3_id = :anSpecType';
      END IF;

      LSSQL :=
            LSSQL
         || ' ORDER BY F_PART_SOURCE(BOM_ITEM.PART_NO), BOM_ITEM.PART_NO, BOM_ITEM.REVISION, BOM_ITEM.PLANT, BOM_ITEM.ALTERNATIVE, BOM_ITEM.BOM_USAGE, BOM_ITEM.ITEM_NUMBER';
      LNRETVAL := IAPISPECIFICATIONACCESS.GETVIEWACCESS( ASPARTNO,
                                                         0,
                                                         LNACCESS );

      IF LNRETVAL <>( IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         OPEN AQITEMS FOR LSSQL USING '',
         '',
         '',
         0;

         RETURN LNRETVAL;
      END IF;

      IF LNACCESS = 0
      THEN
         OPEN AQITEMS FOR LSSQL USING '',
         '',
         '',
         0;

         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOVIEWACCESS,
                                                    ASPARTNO );
      END IF;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.VIEWBOMALLOWED = 0
      THEN
         OPEN AQITEMS FOR LSSQL USING '',
         '',
         '',
         0;

         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOVIEWBOMACCESS,
                                                    IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );
      END IF;

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      OPEN AQITEMS FOR LSSQL USING ASPARTNO,
      IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
      ASPLANT,
      ANSPECTYPE;

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         OPEN AQITEMS FOR LSSQL USING '',
         '',
         '',
         0;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETMRPITEMS;


   FUNCTION ADDITEM(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE,
      ANITEMNUMBER               IN       IAPITYPE.BOMITEMNUMBER_TYPE,
      ASALTERNATIVEGROUP         IN       IAPITYPE.BOMITEMALTGROUP_TYPE,
      ANALTERNATIVEPRIORITY      IN       IAPITYPE.BOMITEMALTPRIORITY_TYPE,
      ASCOMPONENTPARTNO          IN       IAPITYPE.PARTNO_TYPE,
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
      ANRELEVANCYTOCOSTING       IN       IAPITYPE.BOOLEAN_TYPE,
      ANBULKMATERIAL             IN       IAPITYPE.BOOLEAN_TYPE,
      ASITEMCATEGORY             IN       IAPITYPE.BOMITEMCATEGORY_TYPE,
      ASISSUELOCATION            IN       IAPITYPE.BOMISSUELOCATION_TYPE,
      ASCALCULATIONMODE          IN       IAPITYPE.BOMITEMCALCFLAG_TYPE,
      ASBOMITEMTYPE              IN       IAPITYPE.BOMITEMTYPE_TYPE,
      ANOPERATIONALSTEP          IN       IAPITYPE.BOMOPERATIONALSTEP_TYPE,
      ANMINIMUMQUANTITY          IN       IAPITYPE.BOMQUANTITY_TYPE,
      ANMAXIMUMQUANTITY          IN       IAPITYPE.BOMQUANTITY_TYPE,
      ANFIXEDQUANTITY            IN       IAPITYPE.BOOLEAN_TYPE,
      ASCODE                     IN       IAPITYPE.BOMITEMCODE_TYPE,
      ASTEXT1                    IN       IAPITYPE.BOMITEMLONGCHARACTER_TYPE,
      ASTEXT2                    IN       IAPITYPE.BOMITEMLONGCHARACTER_TYPE,
      ASTEXT3                    IN       IAPITYPE.BOMITEMCHARACTER_TYPE,
      ASTEXT4                    IN       IAPITYPE.BOMITEMCHARACTER_TYPE,
      ASTEXT5                    IN       IAPITYPE.BOMITEMCHARACTER_TYPE,
      ANNUMERIC1                 IN       IAPITYPE.BOMITEMNUMERIC_TYPE,
      ANNUMERIC2                 IN       IAPITYPE.BOMITEMNUMERIC_TYPE,
      ANNUMERIC3                 IN       IAPITYPE.BOMITEMNUMERIC_TYPE,
      ANNUMERIC4                 IN       IAPITYPE.BOMITEMNUMERIC_TYPE,
      ANNUMERIC5                 IN       IAPITYPE.BOMITEMNUMERIC_TYPE,
      ANBOOLEAN1                 IN       IAPITYPE.BOOLEAN_TYPE,
      ANBOOLEAN2                 IN       IAPITYPE.BOOLEAN_TYPE,
      ANBOOLEAN3                 IN       IAPITYPE.BOOLEAN_TYPE,
      ANBOOLEAN4                 IN       IAPITYPE.BOOLEAN_TYPE,
      ADDATE1                    IN       IAPITYPE.DATE_TYPE,
      ADDATE2                    IN       IAPITYPE.DATE_TYPE,
      ANCHARACTERISTIC1          IN       IAPITYPE.ID_TYPE,
      ANCHARACTERISTIC2          IN       IAPITYPE.ID_TYPE,
      ANCHARACTERISTIC3          IN       IAPITYPE.ID_TYPE,
      ANMAKEUP                   IN       IAPITYPE.BOOLEAN_TYPE,
      ASINTERNATIONALEQUIVALENT  IN       IAPITYPE.PARTNO_TYPE DEFAULT NULL,
      ANIGNOREPARTPLANTRELATION  IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANCOMPONENTSCRAPSYNC       IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddItem';
      LNCOUNT                       PLS_INTEGER;
      LNHARMONIZED                  PLS_INTEGER;
      LNPARTOBSOLETE                IAPITYPE.BOOLEAN_TYPE;
      LSPARTTYPE                    IAPITYPE.DESCRIPTION_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
      LRBOMITEM                     IAPITYPE.BOMITEMREC_TYPE;
      LIPRIORITY                    PLS_INTEGER;
      LNRECURSIVEBOM                IAPITYPE.BOOLEAN_TYPE;
      LSINTL                        VARCHAR2( 1 );
      LSBASEUOM                     IAPITYPE.DESCRIPTION_TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LSSQLINFO                     IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
      
      
      
      
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
                              'Key: '
                           || ASPARTNO
                           || ' - '
                           || ANREVISION
                           || ' - '
                           || ASPLANT
                           || ' - '
                           || ANALTERNATIVE
                           || ' - '
                           || ANUSAGE
                           || ' - '
                           || ANITEMNUMBER );
      GTBOMITEMS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LNRETVAL := CHECKEDITACCESS( ASPARTNO,
                                   ANREVISION );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         RETURN LNRETVAL;
      END IF;

      LRBOMITEM.PARTNO := ASPARTNO;
      LRBOMITEM.REVISION := ANREVISION;
      LRBOMITEM.PLANT := ASPLANT;
      LRBOMITEM.ALTERNATIVE := ANALTERNATIVE;
      LRBOMITEM.BOMUSAGE := ANUSAGE;
      LRBOMITEM.ITEMNUMBER := ANITEMNUMBER;
      LRBOMITEM.ALTERNATIVEPRIORITY := ANALTERNATIVEPRIORITY;
      LRBOMITEM.ALTERNATIVEGROUP := ASALTERNATIVEGROUP;
      LRBOMITEM.COMPONENTPARTNO := ASCOMPONENTPARTNO;
      LRBOMITEM.COMPONENTREVISION := ANCOMPONENTREVISION;
      LRBOMITEM.COMPONENTPLANT := ASCOMPONENTPLANT;
      LRBOMITEM.QUANTITY := ANQUANTITY;
      LRBOMITEM.UOM := ASUOM;
      LRBOMITEM.CONVERSIONFACTOR := ANCONVERSIONFACTOR;
      LRBOMITEM.CONVERTEDUOM := ASCONVERTEDUOM;
      LRBOMITEM.YIELD := ANYIELD;
      LRBOMITEM.ASSEMBLYSCRAP := ANASSEMBLYSCRAP;
      LRBOMITEM.COMPONENTSCRAP := ANCOMPONENTSCRAP;
      LRBOMITEM.LEADTIMEOFFSET := ANLEADTIMEOFFSET;
      LRBOMITEM.RELEVANCYTOCOSTING := ANRELEVANCYTOCOSTING;
      LRBOMITEM.BULKMATERIAL := ANBULKMATERIAL;
      LRBOMITEM.ITEMCATEGORY := ASITEMCATEGORY;
      LRBOMITEM.ISSUELOCATION := ASISSUELOCATION;
      LRBOMITEM.CALCULATIONMODE := ASCALCULATIONMODE;
      LRBOMITEM.BOMITEMTYPE := ASBOMITEMTYPE;
      LRBOMITEM.OPERATIONALSTEP := ANOPERATIONALSTEP;
      LRBOMITEM.MINIMUMQUANTITY := ANMINIMUMQUANTITY;
      LRBOMITEM.MAXIMUMQUANTITY := ANMAXIMUMQUANTITY;
      LRBOMITEM.FIXEDQUANTITY := ANFIXEDQUANTITY;
      LRBOMITEM.CODE := ASCODE;
      LRBOMITEM.TEXT1 := ASTEXT1;
      LRBOMITEM.TEXT2 := ASTEXT2;
      LRBOMITEM.TEXT3 := ASTEXT3;
      LRBOMITEM.TEXT4 := ASTEXT4;
      LRBOMITEM.TEXT5 := ASTEXT5;
      LRBOMITEM.NUMERIC1 := ANNUMERIC1;
      LRBOMITEM.NUMERIC2 := ANNUMERIC2;
      LRBOMITEM.NUMERIC3 := ANNUMERIC3;
      LRBOMITEM.NUMERIC4 := ANNUMERIC4;
      LRBOMITEM.NUMERIC5 := ANNUMERIC5;
      LRBOMITEM.BOOLEAN1 := ANBOOLEAN1;
      LRBOMITEM.BOOLEAN2 := ANBOOLEAN2;
      LRBOMITEM.BOOLEAN3 := ANBOOLEAN3;
      LRBOMITEM.BOOLEAN4 := ANBOOLEAN4;
      LRBOMITEM.DATE1 := ADDATE1;
      LRBOMITEM.DATE2 := ADDATE2;
      LRBOMITEM.CHARACTERISTIC1 := ANCHARACTERISTIC1;
      LRBOMITEM.CHARACTERISTIC2 := ANCHARACTERISTIC2;
      LRBOMITEM.CHARACTERISTIC3 := ANCHARACTERISTIC3;
      LRBOMITEM.MAKEUP := ANMAKEUP;
      LRBOMITEM.INTERNATIONALEQUIVALENT := ASINTERNATIONALEQUIVALENT;
      LRBOMITEM.COMPONENTSCRAPSYNC := ANCOMPONENTSCRAPSYNC;
      GTBOMITEMS( 0 ) := LRBOMITEM;

      GTINFO( 0 ) := LRINFO;

      
      
      
      
      
      LNRETVAL := PREITEMCHANGED( ASPARTNO,
                                  ANREVISION,
                                  LSMETHOD,
                                  AQERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;
      
      
      
      

      
      LRINFO := GTINFO( 0 );
      
      
      LRBOMITEM := GTBOMITEMS( 0 );
      
      LRBOMITEM.PARTNO := ASPARTNO;
      LRBOMITEM.REVISION := ANREVISION;
      LRBOMITEM.PLANT := ASPLANT;
      LRBOMITEM.ALTERNATIVE := ANALTERNATIVE;
      LRBOMITEM.BOMUSAGE := ANUSAGE;
      LRBOMITEM.ITEMNUMBER := ANITEMNUMBER;



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( LRBOMITEM.COMPONENTPARTNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'ComponentPartNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asComponentPartNo',
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

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM SPECIFICATION_HEADER
       WHERE PART_NO = LRBOMITEM.COMPONENTPARTNO;

      
      IF LNCOUNT = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_INVALIDPART,
                                                    LRBOMITEM.COMPONENTPARTNO,
                                                    LRBOMITEM.COMPONENTREVISION );
      END IF;

      IF ANCOMPONENTREVISION > 0
      THEN
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM SPECIFICATION_HEADER
          WHERE PART_NO = LRBOMITEM.COMPONENTPARTNO
            AND REVISION = LRBOMITEM.COMPONENTREVISION;

         
         IF LNCOUNT = 0
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_SPECIFICATIONNOTFOUND,
                                                       LRBOMITEM.COMPONENTPARTNO,
                                                       LRBOMITEM.COMPONENTREVISION );
         END IF;

         
         SELECT STATUS_TYPE
           INTO LSSTATUSTYPE
           FROM SPECIFICATION_HEADER A,
                STATUS B
          WHERE A.PART_NO = LRBOMITEM.COMPONENTPARTNO
            AND A.REVISION = LRBOMITEM.COMPONENTREVISION
            AND A.STATUS = B.STATUS;

         IF LSSTATUSTYPE IN( IAPICONSTANT.STATUSTYPE_HISTORIC, IAPICONSTANT.STATUSTYPE_OBSOLETE )
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_BOMITEMHISTORICOBSOLETE,
                                                       LRBOMITEM.COMPONENTPARTNO,
                                                       LRBOMITEM.COMPONENTREVISION );
         END IF;
      END IF;

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM BOM_HEADER
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANT
         AND ALTERNATIVE = ANALTERNATIVE
         AND BOM_USAGE = ANUSAGE;

      
      IF LNCOUNT <> 1
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOBOMHEADER,
                                                    ASPARTNO,
                                                    ANREVISION,
                                                    ASPLANT,
                                                    ANALTERNATIVE,
                                                    ANUSAGE );
      END IF;

      IF    ANCOMPONENTSCRAP < 0
      
      
      
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_INVALIDSCRAP );
      END IF;

      
      SELECT INTL
        INTO LSINTL
        FROM SPECIFICATION_HEADER
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION;

      
      LNRETVAL := IAPISPECIFICATION.ISLOCALIZED( ASPARTNO,
                                                 ANREVISION,
                                                 LNHARMONIZED );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN LNRETVAL;
      END IF;

      SELECT C.TYPE,
             P.OBSOLETE
        INTO LSPARTTYPE,
             LNPARTOBSOLETE
        FROM PART P,
             CLASS3 C
       WHERE P.PART_NO = LRBOMITEM.COMPONENTPARTNO
         AND P.PART_TYPE = C.CLASS;

      IF     LSPARTTYPE <> IAPICONSTANT.SPECTYPEGROUP_PHASE
         AND LRBOMITEM.QUANTITY IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_INVALIDQUANTITY );
      END IF;

       
      
      IF     ASPLANT <> IAPICONSTANT.PLANT_DEVELOPMENT
         AND NOT(     ANIGNOREPARTPLANTRELATION = 1
                  AND LNHARMONIZED = 1 )
      THEN
         
         IF LSPARTTYPE <> IAPICONSTANT.SPECTYPEGROUP_PHASE
         THEN
            
            IF LNPARTOBSOLETE = 1
            THEN
               RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                          LSMETHOD,
                                                          IAPICONSTANTDBERROR.DBERR_PARTOBSOLETE,
                                                          LRBOMITEM.COMPONENTPARTNO );
            END IF;

            SELECT COUNT( * )
              INTO LNCOUNT
              FROM PART_PLANT
             WHERE PART_NO = LRBOMITEM.COMPONENTPARTNO
               AND PLANT = ASPLANT
               AND OBSOLETE = 0;

            
            IF LNCOUNT = 0
            THEN
               RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                          LSMETHOD,
                                                          IAPICONSTANTDBERROR.DBERR_NOPARTPLANT,
                                                          LRBOMITEM.COMPONENTPARTNO,
                                                          ASPLANT );
            END IF;

            SELECT COUNT( * )
              INTO LNCOUNT
              FROM PART_PLANT
             WHERE PART_NO = LRBOMITEM.COMPONENTPARTNO
               AND PLANT = ASCOMPONENTPLANT
               AND OBSOLETE = 0;

            
            IF LNCOUNT = 0
            THEN
               RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                          LSMETHOD,
                                                          IAPICONSTANTDBERROR.DBERR_NOPARTPLANT,
                                                          LRBOMITEM.COMPONENTPARTNO,
                                                          ASCOMPONENTPLANT );
            END IF;
         END IF;
      END IF;

      
      IF ASPARTNO = LRBOMITEM.COMPONENTPARTNO
      THEN
         LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( 'allow_recursive_bom',
                                                          IAPICONSTANT.CFG_SECTION_STANDARD,
                                                          LNRECURSIVEBOM );

         IF LNRECURSIVEBOM = 0
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_PARTSAMEPARENT );
         END IF;
      END IF;

      
      IF     LNHARMONIZED = 1
         AND ASPLANT = IAPICONSTANT.PLANT_INTERNATIONAL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_HARMINTLBOM );
      END IF;

      
      IF (     NVL( ANALTERNATIVEPRIORITY,
                    0 ) <> 1
           AND NVL( ASCALCULATIONMODE,
                    '#' ) <> 'N' )
      THEN
         LRBOMITEM.CALCULATIONMODE := 'N';
      END IF;

      SELECT BASE_UOM
        INTO LSBASEUOM
        FROM PART
       WHERE PART_NO = ASPARTNO;

      
      IF (     NVL( ANALTERNATIVEPRIORITY,
                    0 ) <> 1
           AND NVL( ANMAKEUP,
                    0 ) <> 0 )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_INVALIDMARKUPFORALTITEM );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      
      




      
      IF (     NVL( ANMAKEUP,
                    0 ) = 1
           AND LSBASEUOM <> ASUOM
           AND IAPIUOMGROUPS.ISUOMSSAMEGROUP( ASUOM,
                                              LSBASEUOM ) = 0 )

      
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_INVALIDMARKUPANDUOM );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      IF (     NVL( ANMAKEUP,
                    0 ) = 1
           AND NVL( LRBOMITEM.CALCULATIONMODE,
                    '#' ) NOT IN( 'Q', 'B' ) )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_INVALIDMARKUPANDCALCMODE );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      IF LRBOMITEM.ALTERNATIVEPRIORITY < 1
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_ALTPRIORITYLESSTHANONE ) );
      END IF;

      IF LRBOMITEM.ALTERNATIVEPRIORITY > 1
      THEN
         IF LRBOMITEM.ALTERNATIVEGROUP IS NULL
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_INVALIDALTGROUP ) );
         END IF;

         SELECT MAX( ALT_PRIORITY )
           INTO LIPRIORITY
           FROM BOM_ITEM
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PLANT = ASPLANT
            AND ALTERNATIVE = ANALTERNATIVE
            AND BOM_USAGE = ANUSAGE
            AND ALT_GROUP = LRBOMITEM.ALTERNATIVEGROUP;
      ELSE
         LIPRIORITY := 1000;
      END IF;

      IF    ( LRBOMITEM.ALTERNATIVEPRIORITY < 0 )
         OR ( LRBOMITEM.ALTERNATIVEPRIORITY >   LIPRIORITY
                                              + 1 )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_INVALIDALTPRIORITY ) );
      END IF;

      IF     LRBOMITEM.RELEVANCYTOCOSTING = 1
         AND LRBOMITEM.BULKMATERIAL = 1
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_BOMITEMCOSTBULKMUTEXCL ) );
      END IF;

      IF NOT( LRBOMITEM.INTERNATIONALEQUIVALENT IS NULL )
      THEN
         IF NOT(    LNHARMONIZED = 1
                 OR LSINTL = '1' )
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_INVALIDHARMBOMEQ );
         END IF;
      END IF;

      
      
      IF LRBOMITEM.COMPONENTSCRAPSYNC = 1
      THEN
         SELECT COMPONENT_SCRAP
           INTO LRBOMITEM.COMPONENTSCRAP
           FROM PART_PLANT
          WHERE PART_NO = LRBOMITEM.COMPONENTPARTNO
            AND PLANT = LRBOMITEM.COMPONENTPLANT
            AND OBSOLETE = 0;
      END IF;

      
      INSERT INTO BOM_ITEM
                  ( PART_NO,
                    REVISION,
                    PLANT,
                    ALTERNATIVE,
                    BOM_USAGE,
                    ITEM_NUMBER,
                    ALT_PRIORITY,
                    ALT_GROUP,
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
                    RELEVENCY_TO_COSTING,
                    BULK_MATERIAL,
                    ITEM_CATEGORY,
                    ISSUE_LOCATION,
                    CALC_FLAG,
                    BOM_ITEM_TYPE,
                    OPERATIONAL_STEP,
                    MIN_QTY,
                    MAX_QTY,
                    FIXED_QTY,
                    CODE,
                    CHAR_1,
                    CHAR_2,
                    CHAR_3,
                    CHAR_4,
                    CHAR_5,
                    NUM_1,
                    NUM_2,
                    NUM_3,
                    NUM_4,
                    NUM_5,
                    BOOLEAN_1,
                    BOOLEAN_2,
                    BOOLEAN_3,
                    BOOLEAN_4,
                    DATE_1,
                    DATE_2,
                    CH_1,
                    CH_2,
                    CH_3,
                    MAKE_UP,
                    INTL_EQUIVALENT,
                    COMPONENT_SCRAP_SYNC )
           VALUES ( ASPARTNO,
                    ANREVISION,
                    ASPLANT,
                    ANALTERNATIVE,
                    ANUSAGE,
                    ANITEMNUMBER,
                    LRBOMITEM.ALTERNATIVEPRIORITY,
                    LRBOMITEM.ALTERNATIVEGROUP,
                    LRBOMITEM.COMPONENTPARTNO,
                    LRBOMITEM.COMPONENTREVISION,
                    LRBOMITEM.COMPONENTPLANT,
                    LRBOMITEM.QUANTITY,
                    LRBOMITEM.UOM,
                    LRBOMITEM.CONVERSIONFACTOR,
                    LRBOMITEM.CONVERTEDUOM,
                    LRBOMITEM.YIELD,
                    LRBOMITEM.ASSEMBLYSCRAP,
                    LRBOMITEM.COMPONENTSCRAP,
                    LRBOMITEM.LEADTIMEOFFSET,
                    LRBOMITEM.RELEVANCYTOCOSTING,
                    LRBOMITEM.BULKMATERIAL,
                    LRBOMITEM.ITEMCATEGORY,
                    LRBOMITEM.ISSUELOCATION,
                    LRBOMITEM.CALCULATIONMODE,
                    LRBOMITEM.BOMITEMTYPE,
                    LRBOMITEM.OPERATIONALSTEP,
                    LRBOMITEM.MINIMUMQUANTITY,
                    LRBOMITEM.MAXIMUMQUANTITY,
                    LRBOMITEM.FIXEDQUANTITY,
                    LRBOMITEM.CODE,
                    LRBOMITEM.TEXT1,
                    LRBOMITEM.TEXT2,
                    LRBOMITEM.TEXT3,
                    LRBOMITEM.TEXT4,
                    LRBOMITEM.TEXT5,
                    LRBOMITEM.NUMERIC1,
                    LRBOMITEM.NUMERIC2,
                    LRBOMITEM.NUMERIC3,
                    LRBOMITEM.NUMERIC4,
                    LRBOMITEM.NUMERIC5,
                    LRBOMITEM.BOOLEAN1,
                    LRBOMITEM.BOOLEAN2,
                    LRBOMITEM.BOOLEAN3,
                    LRBOMITEM.BOOLEAN4,
                    LRBOMITEM.DATE1,
                    LRBOMITEM.DATE2,
                    LRBOMITEM.CHARACTERISTIC1,
                    LRBOMITEM.CHARACTERISTIC2,
                    LRBOMITEM.CHARACTERISTIC3,
                    LRBOMITEM.MAKEUP,
                    LRBOMITEM.INTERNATIONALEQUIVALENT,
                    LRBOMITEM.COMPONENTSCRAPSYNC );

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

      
      
      
      
      
      LNRETVAL := POSTITEMCHANGED( ASPARTNO,
                                   ANREVISION,
                                   LSMETHOD,
                                   TRUE,
                                   AQERRORS );
      
      
      
      

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


      RETURN LNRETVAL;
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_DUPVALONINDEX,
                                                    ASPARTNO,
                                                    ANREVISION );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDITEM;


   
   
   FUNCTION ADDITEM_MOP(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE,
      ANITEMNUMBER               IN       IAPITYPE.BOMITEMNUMBER_TYPE,
      ASCOMPONENTPARTNO          IN       IAPITYPE.PARTNO_TYPE,
      ASCOMPONENTPLANT           IN       IAPITYPE.PLANT_TYPE,
      ANQUANTITY                 IN       IAPITYPE.BOMQUANTITY_TYPE,
      ASUOM                      IN       IAPITYPE.DESCRIPTION_TYPE,
      ANCONVERSIONFACTOR         IN       IAPITYPE.BOMCONVFACTOR_TYPE,
      ASCONVERTEDUOM             IN       IAPITYPE.DESCRIPTION_TYPE,
      ANYIELD                    IN       IAPITYPE.BOMYIELD_TYPE,
      ANASSEMBLYSCRAP            IN       IAPITYPE.SCRAP_TYPE,
      ANCOMPONENTSCRAP           IN       IAPITYPE.SCRAP_TYPE,
      ANLEADTIMEOFFSET           IN       IAPITYPE.BOMLEADTIMEOFFSET_TYPE,
      ANRELEVANCYTOCOSTING       IN       IAPITYPE.BOOLEAN_TYPE,
      ANBULKMATERIAL             IN       IAPITYPE.BOOLEAN_TYPE,
      ASITEMCATEGORY             IN       IAPITYPE.BOMITEMCATEGORY_TYPE,
      ASISSUELOCATION            IN       IAPITYPE.BOMISSUELOCATION_TYPE,
      ASCALCULATIONMODE          IN       IAPITYPE.BOMITEMCALCFLAG_TYPE)
      RETURN IAPITYPE.ERRORNUM_TYPE
    IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddItem_BoM';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRBOMITEM                     IAPITYPE.BOMITEMREC_TYPE;
      LSBASEUOM                     IAPITYPE.DESCRIPTION_TYPE;
      LQERRORS                      IAPITYPE.REF_TYPE;
   BEGIN




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Key: '
                           || ASPARTNO
                           || ' - '
                           || ANREVISION
                           || ' - '
                           || ASPLANT
                           || ' - '
                           || ANALTERNATIVE
                           || ' - '
                           || ANUSAGE
                           || ' - '
                           || ANITEMNUMBER );
      GTBOMITEMS.DELETE;









      LRBOMITEM.PARTNO := ASPARTNO;
      LRBOMITEM.REVISION := ANREVISION;
      LRBOMITEM.PLANT := ASPLANT;
      LRBOMITEM.ALTERNATIVE := ANALTERNATIVE;
      LRBOMITEM.BOMUSAGE := ANUSAGE;
      LRBOMITEM.ITEMNUMBER := ANITEMNUMBER;
      LRBOMITEM.COMPONENTPARTNO := ASCOMPONENTPARTNO;
      LRBOMITEM.COMPONENTPLANT := ASCOMPONENTPLANT;
      LRBOMITEM.QUANTITY := ANQUANTITY;
      LRBOMITEM.UOM := ASUOM;
      LRBOMITEM.CONVERSIONFACTOR := ANCONVERSIONFACTOR;
      LRBOMITEM.CONVERTEDUOM := ASCONVERTEDUOM;
      LRBOMITEM.YIELD := ANYIELD;
      LRBOMITEM.ASSEMBLYSCRAP := ANASSEMBLYSCRAP;
      LRBOMITEM.COMPONENTSCRAP := ANCOMPONENTSCRAP;
      LRBOMITEM.LEADTIMEOFFSET := ANLEADTIMEOFFSET;
      LRBOMITEM.RELEVANCYTOCOSTING := ANRELEVANCYTOCOSTING;
      LRBOMITEM.BULKMATERIAL := ANBULKMATERIAL;
      LRBOMITEM.ITEMCATEGORY := ASITEMCATEGORY;
      LRBOMITEM.ISSUELOCATION := ASISSUELOCATION;
      LRBOMITEM.CALCULATIONMODE := ASCALCULATIONMODE;
      GTBOMITEMS( 0 ) := LRBOMITEM;

      
      
      
      LNRETVAL := PREITEMCHANGED( ASPARTNO,
                                  ANREVISION,
                                  'AddItem',
                                  LQERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      
      
      LRBOMITEM := GTBOMITEMS( 0 );
      
      LRBOMITEM.PARTNO := ASPARTNO;
      LRBOMITEM.REVISION := ANREVISION;
      LRBOMITEM.PLANT := ASPLANT;
      LRBOMITEM.ALTERNATIVE := ANALTERNATIVE;
      LRBOMITEM.BOMUSAGE := ANUSAGE;
      LRBOMITEM.ITEMNUMBER := ANITEMNUMBER;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

    
    INSERT INTO BOM_ITEM
             ( PART_NO,
               REVISION,
               PLANT,
               ALTERNATIVE,
               COMPONENT_PART,
               COMPONENT_PLANT,
               QUANTITY,
               UOM,
               CONV_FACTOR,
               TO_UNIT,
               YIELD,
               RELEVENCY_TO_COSTING,
               BULK_MATERIAL,
               ITEM_CATEGORY,
               ISSUE_LOCATION,
               CALC_FLAG,
               BOM_USAGE,
               ASSEMBLY_SCRAP,
               COMPONENT_SCRAP,
               LEAD_TIME_OFFSET,
               ITEM_NUMBER )
      VALUES ( ASPARTNO,
               ANREVISION,
               ASPLANT,
               ANALTERNATIVE,
               LRBOMITEM.COMPONENTPARTNO,
               LRBOMITEM.COMPONENTPLANT,
               LRBOMITEM.QUANTITY,
               LRBOMITEM.UOM,
               LRBOMITEM.CONVERSIONFACTOR,
               LRBOMITEM.CONVERTEDUOM,
               LRBOMITEM.YIELD,
               LRBOMITEM.RELEVANCYTOCOSTING,
               LRBOMITEM.BULKMATERIAL,
               LRBOMITEM.ITEMCATEGORY,
               LRBOMITEM.ISSUELOCATION,
               LRBOMITEM.CALCULATIONMODE,
               ANUSAGE,
               LRBOMITEM.ASSEMBLYSCRAP,
               LRBOMITEM.COMPONENTSCRAP,
               LRBOMITEM.LEADTIMEOFFSET,
               ANITEMNUMBER );

      
      
      
        LNRETVAL := POSTITEMCHANGED( ASPARTNO,
                                     ANREVISION,
                                     'AddItem',
                                     TRUE,
                                     LQERRORS );
    RETURN LNRETVAL;
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_DUPVALONINDEX,
                                                    ASPARTNO,
                                                    ANREVISION );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDITEM_MOP;
   


   FUNCTION SAVEITEM(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE,
      ANITEMNUMBER               IN       IAPITYPE.BOMITEMNUMBER_TYPE,
      ANNEWITEMNUMBER            IN       IAPITYPE.BOMITEMNUMBER_TYPE DEFAULT NULL,
      ASALTERNATIVEGROUP         IN       IAPITYPE.BOMITEMALTGROUP_TYPE,
      ANALTERNATIVEPRIORITY      IN       IAPITYPE.BOMITEMALTPRIORITY_TYPE,
      ASCOMPONENTPARTNO          IN       IAPITYPE.PARTNO_TYPE,
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
      ANRELEVANCYTOCOSTING       IN       IAPITYPE.BOOLEAN_TYPE,
      ANBULKMATERIAL             IN       IAPITYPE.BOOLEAN_TYPE,
      ASITEMCATEGORY             IN       IAPITYPE.BOMITEMCATEGORY_TYPE,
      ASISSUELOCATION            IN       IAPITYPE.BOMISSUELOCATION_TYPE,
      ASCALCULATIONMODE          IN       IAPITYPE.BOMITEMCALCFLAG_TYPE,
      ASBOMITEMTYPE              IN       IAPITYPE.BOMITEMTYPE_TYPE,
      ANOPERATIONALSTEP          IN       IAPITYPE.BOMOPERATIONALSTEP_TYPE,
      ANMINIMUMQUANTITY          IN       IAPITYPE.BOMQUANTITY_TYPE,
      ANMAXIMUMQUANTITY          IN       IAPITYPE.BOMQUANTITY_TYPE,
      ANFIXEDQUANTITY            IN       IAPITYPE.BOOLEAN_TYPE,
      ASCODE                     IN       IAPITYPE.BOMITEMCODE_TYPE,
      ASTEXT1                    IN       IAPITYPE.BOMITEMLONGCHARACTER_TYPE,
      ASTEXT2                    IN       IAPITYPE.BOMITEMLONGCHARACTER_TYPE,
      ASTEXT3                    IN       IAPITYPE.BOMITEMCHARACTER_TYPE,
      ASTEXT4                    IN       IAPITYPE.BOMITEMCHARACTER_TYPE,
      ASTEXT5                    IN       IAPITYPE.BOMITEMCHARACTER_TYPE,
      ANNUMERIC1                 IN       IAPITYPE.BOMITEMNUMERIC_TYPE,
      ANNUMERIC2                 IN       IAPITYPE.BOMITEMNUMERIC_TYPE,
      ANNUMERIC3                 IN       IAPITYPE.BOMITEMNUMERIC_TYPE,
      ANNUMERIC4                 IN       IAPITYPE.BOMITEMNUMERIC_TYPE,
      ANNUMERIC5                 IN       IAPITYPE.BOMITEMNUMERIC_TYPE,
      ANBOOLEAN1                 IN       IAPITYPE.BOOLEAN_TYPE,
      ANBOOLEAN2                 IN       IAPITYPE.BOOLEAN_TYPE,
      ANBOOLEAN3                 IN       IAPITYPE.BOOLEAN_TYPE,
      ANBOOLEAN4                 IN       IAPITYPE.BOOLEAN_TYPE,
      ADDATE1                    IN       IAPITYPE.DATE_TYPE,
      ADDATE2                    IN       IAPITYPE.DATE_TYPE,
      ANCHARACTERISTIC1          IN       IAPITYPE.ID_TYPE,
      ANCHARACTERISTIC2          IN       IAPITYPE.ID_TYPE,
      ANCHARACTERISTIC3          IN       IAPITYPE.ID_TYPE,
      ANMAKEUP                   IN       IAPITYPE.BOOLEAN_TYPE,
      ASINTERNATIONALEQUIVALENT  IN       IAPITYPE.PARTNO_TYPE DEFAULT NULL,
      ANCOMPONENTSCRAPSYNC       IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LNCOUNT                       PLS_INTEGER;
      LIPRIORITY                    PLS_INTEGER;
      LNHARMONIZED                  PLS_INTEGER;
      LSINTL                        VARCHAR2( 1 );
      LNPARTOBSOLETE                IAPITYPE.BOOLEAN_TYPE;
      LSPARTTYPE                    IAPITYPE.DESCRIPTION_TYPE;
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
      LSSTATUSTYPECOMPONENT         IAPITYPE.STATUSTYPE_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveItem';
      LRBOMITEM                     IAPITYPE.BOMITEMREC_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNITEMNUMBER                  IAPITYPE.BOMITEMNUMBER_TYPE;
      LSVALUENEW                    VARCHAR2( 255 );
      LSVALUEOLD                    VARCHAR2( 255 );
      LBMRPFIELDSCHANGED            BOOLEAN := FALSE;
      LNACCESS                      PLS_INTEGER;
      LBPLANNINGMRPACCESS           BOOLEAN;
      LBPRODUCTIONMRPACCESS         BOOLEAN;
      LBPHASEMRPACCESS              BOOLEAN;
      LBNOEDITACCESS                BOOLEAN;
      LBDISPLAYFORMATAVAILABLE      BOOLEAN := FALSE;
      LNRECURSIVEBOM                IAPITYPE.BOOLEAN_TYPE;
      LSBASEUOM                     IAPITYPE.DESCRIPTION_TYPE;
      LBDOINSERT                    BOOLEAN;
      LBCONVERT                     BOOLEAN;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LSSQLINFO                     IAPITYPE.SQLSTRING_TYPE;

      CURSOR CUR_MRP_FIELDS
      IS
         SELECT FIELD_ID,
                PHASE_MRP,
                PLANNING_MRP,
                PRODUCTION_MRP,
                HEADER_ID
           FROM ITBOMLYITEM
          WHERE ( LAYOUT_ID, REVISION ) IN( SELECT DISPLAY_FORMAT,
                                                   DISPLAY_FORMAT_REV
                                             FROM SPECIFICATION_SECTION
                                            WHERE TYPE = IAPICONSTANT.SECTIONTYPE_BOM
                                              AND PART_NO = ASPARTNO
                                              AND REVISION = ANREVISION );
   BEGIN
      
      
      
      
      
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
                              'Key: '
                           || ASPARTNO
                           || ' - '
                           || ANREVISION
                           || ' - '
                           || ASPLANT
                           || ' - '
                           || ANALTERNATIVE
                           || ' - '
                           || ANUSAGE
                           || ' - '
                           || ANITEMNUMBER );
      GTBOMITEMS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LNRETVAL := CHECKEDITACCESS( ASPARTNO,
                                   ANREVISION );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         RETURN LNRETVAL;
      END IF;

      LRBOMITEM.PARTNO := ASPARTNO;
      LRBOMITEM.REVISION := ANREVISION;
      LRBOMITEM.PLANT := ASPLANT;
      LRBOMITEM.ALTERNATIVE := ANALTERNATIVE;
      LRBOMITEM.BOMUSAGE := ANUSAGE;
      LRBOMITEM.ITEMNUMBER := ANITEMNUMBER;
      LRBOMITEM.ALTERNATIVEPRIORITY := ANALTERNATIVEPRIORITY;
      LRBOMITEM.ALTERNATIVEGROUP := ASALTERNATIVEGROUP;
      LRBOMITEM.COMPONENTPARTNO := ASCOMPONENTPARTNO;
      LRBOMITEM.COMPONENTREVISION := ANCOMPONENTREVISION;
      LRBOMITEM.COMPONENTPLANT := ASCOMPONENTPLANT;
      LRBOMITEM.QUANTITY := ANQUANTITY;
      LRBOMITEM.UOM := ASUOM ;
      LRBOMITEM.CONVERSIONFACTOR := ANCONVERSIONFACTOR;
      LRBOMITEM.CONVERTEDUOM := ASCONVERTEDUOM;
      LRBOMITEM.YIELD := ANYIELD;
      LRBOMITEM.ASSEMBLYSCRAP := ANASSEMBLYSCRAP;
      LRBOMITEM.COMPONENTSCRAP := ANCOMPONENTSCRAP;
      LRBOMITEM.LEADTIMEOFFSET := ANLEADTIMEOFFSET;
      LRBOMITEM.RELEVANCYTOCOSTING := ANRELEVANCYTOCOSTING;
      LRBOMITEM.BULKMATERIAL := ANBULKMATERIAL;
      LRBOMITEM.ITEMCATEGORY := ASITEMCATEGORY;
      LRBOMITEM.ISSUELOCATION := ASISSUELOCATION;
      LRBOMITEM.CALCULATIONMODE := ASCALCULATIONMODE;
      LRBOMITEM.BOMITEMTYPE := ASBOMITEMTYPE;
      LRBOMITEM.OPERATIONALSTEP := ANOPERATIONALSTEP;
      LRBOMITEM.MINIMUMQUANTITY := ANMINIMUMQUANTITY;
      LRBOMITEM.MAXIMUMQUANTITY := ANMAXIMUMQUANTITY;
      LRBOMITEM.FIXEDQUANTITY := ANFIXEDQUANTITY;
      LRBOMITEM.CODE := ASCODE;
      LRBOMITEM.TEXT1 := ASTEXT1;
      LRBOMITEM.TEXT2 := ASTEXT2;
      LRBOMITEM.TEXT3 := ASTEXT3;
      LRBOMITEM.TEXT4 := ASTEXT4;
      LRBOMITEM.TEXT5 := ASTEXT5;
      LRBOMITEM.NUMERIC1 := ANNUMERIC1;
      LRBOMITEM.NUMERIC2 := ANNUMERIC2;
      LRBOMITEM.NUMERIC3 := ANNUMERIC3;
      LRBOMITEM.NUMERIC4 := ANNUMERIC4;
      LRBOMITEM.NUMERIC5 := ANNUMERIC5;
      LRBOMITEM.BOOLEAN1 := ANBOOLEAN1;
      LRBOMITEM.BOOLEAN2 := ANBOOLEAN2;
      LRBOMITEM.BOOLEAN3 := ANBOOLEAN3;
      LRBOMITEM.BOOLEAN4 := ANBOOLEAN4;
      LRBOMITEM.DATE1 := ADDATE1;
      LRBOMITEM.DATE2 := ADDATE2;
      LRBOMITEM.CHARACTERISTIC1 := ANCHARACTERISTIC1;
      LRBOMITEM.CHARACTERISTIC2 := ANCHARACTERISTIC2;
      LRBOMITEM.CHARACTERISTIC3 := ANCHARACTERISTIC3;
      LRBOMITEM.MAKEUP := ANMAKEUP;
      LRBOMITEM.INTERNATIONALEQUIVALENT := ASINTERNATIONALEQUIVALENT;
      LRBOMITEM.COMPONENTSCRAPSYNC := ANCOMPONENTSCRAPSYNC;
      GTBOMITEMS( 0 ) := LRBOMITEM;

      GTINFO( 0 ) := LRINFO;

      LNRETVAL := PREITEMCHANGED( ASPARTNO,
                                  ANREVISION,
                                  LSMETHOD,
                                  AQERRORS );

      
      IF (     LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
           AND LNRETVAL <> IAPICONSTANTDBERROR.DBERR_NOUPDATEACCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      
      LRINFO := GTINFO( 0 );
      
      
      LRBOMITEM := GTBOMITEMS( 0 );
      
      LRBOMITEM.PARTNO := ASPARTNO;
      LRBOMITEM.REVISION := ANREVISION;
      LRBOMITEM.PLANT := ASPLANT;
      LRBOMITEM.ALTERNATIVE := ANALTERNATIVE;
      LRBOMITEM.BOMUSAGE := ANUSAGE;
      LRBOMITEM.ITEMNUMBER := ANITEMNUMBER;



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( LRBOMITEM.COMPONENTPARTNO IS NULL )
      THEN
         LNRETVAL :=
               IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                   IAPICONSTANTCOLUMN.COMPONENTPARTNOCOL );
         RETURN LNRETVAL;
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

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM SPECIFICATION_HEADER
       WHERE PART_NO = LRBOMITEM.COMPONENTPARTNO;

      
      IF LNCOUNT = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_SPECIFICATIONNOTFOUND,
                                                    LRBOMITEM.COMPONENTPARTNO,
                                                    LRBOMITEM.COMPONENTREVISION );
      END IF;

      SELECT C.TYPE,
             P.OBSOLETE
        INTO LSPARTTYPE,
             LNPARTOBSOLETE
        FROM PART P,
             CLASS3 C
       WHERE P.PART_NO = LRBOMITEM.COMPONENTPARTNO
         AND P.PART_TYPE = C.CLASS;

      IF     LSPARTTYPE <> IAPICONSTANT.SPECTYPEGROUP_PHASE
         AND LRBOMITEM.QUANTITY IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_INVALIDQUANTITY );
      END IF;

      
      IF ASPLANT <> IAPICONSTANT.PLANT_DEVELOPMENT
      THEN
         
         IF LSPARTTYPE <> IAPICONSTANT.SPECTYPEGROUP_PHASE
         THEN
            
            IF LNPARTOBSOLETE = 1
            THEN
               RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                          LSMETHOD,
                                                          IAPICONSTANTDBERROR.DBERR_PARTOBSOLETE,
                                                          LRBOMITEM.COMPONENTPARTNO );
            END IF;

            SELECT COUNT( * )
              INTO LNCOUNT
              FROM PART_PLANT
             WHERE PART_NO = LRBOMITEM.COMPONENTPARTNO
               AND PLANT = ASPLANT
               AND OBSOLETE = 0;

            
            IF LNCOUNT = 0
            THEN
               RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                          LSMETHOD,
                                                          IAPICONSTANTDBERROR.DBERR_NOPARTPLANT,
                                                          LRBOMITEM.COMPONENTPARTNO,
                                                          ASPLANT );
            END IF;

            SELECT COUNT( * )
              INTO LNCOUNT
              FROM PART_PLANT
             WHERE PART_NO = LRBOMITEM.COMPONENTPARTNO
               AND PLANT = ASCOMPONENTPLANT
               AND OBSOLETE = 0;

            
            IF LNCOUNT = 0
            THEN
               RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                          LSMETHOD,
                                                          IAPICONSTANTDBERROR.DBERR_NOPARTPLANT,
                                                          LRBOMITEM.COMPONENTPARTNO,
                                                          ASCOMPONENTPLANT );
            END IF;
         END IF;
      END IF;

      
      IF ASPARTNO = LRBOMITEM.COMPONENTPARTNO
      THEN
         LNRETVAL := IAPIGENERAL.GETCONFIGURATIONSETTING( 'allow_recursive_bom',
                                                          IAPICONSTANT.CFG_SECTION_STANDARD,
                                                          LNRECURSIVEBOM );

         IF LNRECURSIVEBOM = 0
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_PARTSAMEPARENT );
         END IF;
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Loading Status',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPISPECIFICATION.ISLOCALIZED( ASPARTNO,
                                                 ANREVISION,
                                                 LNHARMONIZED );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN LNRETVAL;
      END IF;

      SELECT STATUS_TYPE,
             INTL
        INTO LSSTATUSTYPE,
             LSINTL
        FROM SPECIFICATION_HEADER A,
             STATUS B
       WHERE A.STATUS = B.STATUS
         AND PART_NO = ASPARTNO
         AND REVISION = ANREVISION;

      
      IF     LNHARMONIZED = 1
         AND ASPLANT = IAPICONSTANT.PLANT_INTERNATIONAL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_HARMINTLBOM );
      END IF;

      IF NOT( LRBOMITEM.INTERNATIONALEQUIVALENT IS NULL )
      THEN
         IF NOT(    LNHARMONIZED = 1
                 OR LSINTL = '1' )
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_INVALIDHARMBOMEQ );
         END IF;
      END IF;

      IF    ANCOMPONENTSCRAP < 0
      
      
      
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_INVALIDSCRAP );
      END IF;

      IF LRBOMITEM.COMPONENTREVISION > 0
      THEN
         SELECT STATUS
           INTO LNCOUNT
           FROM SPECIFICATION_HEADER
          WHERE PART_NO = LRBOMITEM.COMPONENTPARTNO
            AND REVISION = LRBOMITEM.COMPONENTREVISION;

         
         IF LNCOUNT = 0
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_SPECIFICATIONNOTFOUND,
                                                       LRBOMITEM.COMPONENTPARTNO,
                                                       LRBOMITEM.COMPONENTREVISION );
         END IF;

         
         SELECT STATUS_TYPE
           INTO LSSTATUSTYPECOMPONENT
           FROM SPECIFICATION_HEADER A,
                STATUS B
          WHERE A.PART_NO = LRBOMITEM.COMPONENTPARTNO
            AND A.REVISION = LRBOMITEM.COMPONENTREVISION
            AND A.STATUS = B.STATUS;

         IF LSSTATUSTYPECOMPONENT IN( IAPICONSTANT.STATUSTYPE_HISTORIC, IAPICONSTANT.STATUSTYPE_OBSOLETE )
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_BOMITEMHISTORICOBSOLETE );
         END IF;
      END IF;

      
      IF (     ANNEWITEMNUMBER IS NOT NULL
           AND ANITEMNUMBER <> ANNEWITEMNUMBER )
      THEN
         
         
         UPDATE BOM_ITEM
            SET ITEM_NUMBER = ANNEWITEMNUMBER
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PLANT = ASPLANT
            AND ALTERNATIVE = ANALTERNATIVE
            AND BOM_USAGE = ANUSAGE
            AND ITEM_NUMBER = ANITEMNUMBER;

         LNITEMNUMBER := ANNEWITEMNUMBER;
      ELSE
         LNITEMNUMBER := ANITEMNUMBER;
      END IF;

      LBNOEDITACCESS := FALSE;

      IF LSSTATUSTYPE = IAPICONSTANT.STATUSTYPE_DEVELOPMENT
      THEN
         LNRETVAL := IAPISPECIFICATIONACCESS.GETMODIFIABLEACCESS( ASPARTNO,
                                                                  ANREVISION,
                                                                  LNACCESS );

         IF LNACCESS = 0
         THEN
            LBNOEDITACCESS := TRUE;
         END IF;
      ELSE
         LBNOEDITACCESS := TRUE;
      END IF;

      IF LBNOEDITACCESS
      THEN
         LNRETVAL := IAPISPECIFICATIONACCESS.GETPHASEMRPACCESS( ASPARTNO,
                                                                ANREVISION,
                                                                LNACCESS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         LBPHASEMRPACCESS :=( LNACCESS = 1 );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Phase MRP Access : '
                              || TO_CHAR( LNACCESS ),
                              IAPICONSTANT.INFOLEVEL_3 );
         LNRETVAL := IAPISPECIFICATIONACCESS.GETPLANNINGMRPACCESS( ASPARTNO,
                                                                   ANREVISION,
                                                                   LNACCESS );
         LBPLANNINGMRPACCESS :=( LNACCESS = 1 );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Planning MRP Access : '
                              || TO_CHAR( LNACCESS ),
                              IAPICONSTANT.INFOLEVEL_3 );
         LNRETVAL := IAPISPECIFICATIONACCESS.GETPRODUCTIONMRPACCESS( ASPARTNO,
                                                                     ANREVISION,
                                                                     LNACCESS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         LBPRODUCTIONMRPACCESS :=( LNACCESS = 1 );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Production MRP Access : '
                              || TO_CHAR( LNACCESS ),
                              IAPICONSTANT.INFOLEVEL_3 );
      END IF;

      
      IF (     NVL( ANALTERNATIVEPRIORITY,
                    0 ) <> 1
           AND NVL( ASCALCULATIONMODE,
                    '#' ) <> 'N' )
      THEN
         LRBOMITEM.CALCULATIONMODE := 'N';
      END IF;

      SELECT BASE_UOM
        INTO LSBASEUOM
        FROM PART
       WHERE PART_NO = ASPARTNO;

      
      IF (     NVL( ANALTERNATIVEPRIORITY,
                    0 ) <> 1
           AND NVL( ANMAKEUP,
                    0 ) <> 0 )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_INVALIDMARKUPFORALTITEM );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;


      
      




      
      IF ( ( NVL( ANMAKEUP,
                 0 ) = 1 )
           AND LSBASEUOM <> ASUOM
           AND (IAPIUOMGROUPS.ISUOMSSAMEGROUP( ASUOM,
                                              LSBASEUOM ) = 0 ) )
      
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_INVALIDMARKUPANDUOM );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      IF (     NVL( ANMAKEUP,
                    0 ) = 1
           AND NVL( LRBOMITEM.CALCULATIONMODE,
                    '#' ) NOT IN( 'Q', 'B' ) )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_INVALIDMARKUPANDCALCMODE );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      
      FOR REC_MRP_FIELDS IN CUR_MRP_FIELDS
      LOOP
         LBDISPLAYFORMATAVAILABLE := TRUE;

         SELECT CASE REC_MRP_FIELDS.FIELD_ID
                   WHEN 1
                      THEN COMPONENT_PART
                   WHEN 3
                      THEN COMPONENT_PLANT
                   WHEN 4
                      THEN TO_CHAR( QUANTITY )
                   WHEN 5
                      THEN UOM
                   WHEN 6
                      THEN TO_UNIT
                   WHEN 7
                      THEN TO_CHAR( CONV_FACTOR )
                   WHEN 8
                      THEN TO_CHAR( YIELD )
                   WHEN 9
                      THEN TO_CHAR( ASSEMBLY_SCRAP )
                   WHEN 10
                      THEN TO_CHAR( COMPONENT_SCRAP )
                   WHEN 11
                      THEN TO_CHAR( LEAD_TIME_OFFSET )
                   WHEN 12
                      THEN TO_CHAR( RELEVENCY_TO_COSTING )
                   WHEN 13
                      THEN TO_CHAR( BULK_MATERIAL )
                   WHEN 14
                      THEN ITEM_CATEGORY
                   WHEN 15
                      THEN ISSUE_LOCATION
                   WHEN 16
                      THEN CALC_FLAG
                   WHEN 17
                      THEN BOM_ITEM_TYPE
                   WHEN 18
                      THEN TO_CHAR( OPERATIONAL_STEP )
                   WHEN 19
                      THEN TO_CHAR( MIN_QTY )
                   WHEN 20
                      THEN TO_CHAR( MAX_QTY )
                   WHEN 21
                      THEN TO_CHAR( FIXED_QTY )
                   WHEN 22
                      THEN TO_CHAR( COMPONENT_REVISION )
                   WHEN 23
                      THEN TO_CHAR( ITEM_NUMBER )
                   WHEN 25
                      THEN CHAR_1
                   WHEN 26
                      THEN CHAR_2
                   WHEN 27
                      THEN CODE
                   WHEN 30
                      THEN TO_CHAR( NUM_1 )
                   WHEN 31
                      THEN TO_CHAR( NUM_2 )
                   WHEN 32
                      THEN TO_CHAR( NUM_3 )
                   WHEN 33
                      THEN TO_CHAR( NUM_4 )
                   WHEN 34
                      THEN TO_CHAR( NUM_5 )
                   WHEN 40
                      THEN CHAR_3
                   WHEN 41
                      THEN CHAR_4
                   WHEN 42
                      THEN CHAR_5
                   WHEN 50
                      THEN TO_CHAR( BOOLEAN_1 )
                   WHEN 51
                      THEN TO_CHAR( BOOLEAN_2 )
                   WHEN 52
                      THEN TO_CHAR( BOOLEAN_3 )
                   WHEN 53
                      THEN TO_CHAR( BOOLEAN_4 )
                   WHEN 60
                      THEN TO_CHAR( DATE_1,   
                                    'dd-mm-yyyy' )   
                   WHEN 61
                      THEN TO_CHAR( DATE_2,   
                                    'dd-mm-yyyy' )   
                   WHEN 70
                      THEN TO_CHAR( CH_1 )
                   WHEN 71
                      THEN TO_CHAR( CH_2 )
                   WHEN 72
                      THEN TO_CHAR( CH_3 )
                   ELSE NULL
                END,
                CASE REC_MRP_FIELDS.FIELD_ID   
                   WHEN 1
                      THEN ASCOMPONENTPARTNO
                   WHEN 3
                      THEN ASCOMPONENTPLANT
                   WHEN 4
                      THEN TO_CHAR( ANQUANTITY )
                   WHEN 5
                      THEN ASUOM
                   WHEN 6
                      THEN ASCONVERTEDUOM
                   WHEN 7
                      THEN TO_CHAR( ANCONVERSIONFACTOR )
                   WHEN 8
                      THEN TO_CHAR( ANYIELD )
                   WHEN 9
                      THEN TO_CHAR( ANASSEMBLYSCRAP )
                   WHEN 10
                      THEN TO_CHAR( ANCOMPONENTSCRAP )
                   WHEN 11
                      THEN TO_CHAR( ANLEADTIMEOFFSET )
                   WHEN 12
                      THEN TO_CHAR( ANRELEVANCYTOCOSTING )
                   WHEN 13
                      THEN TO_CHAR( ANBULKMATERIAL )
                   WHEN 14
                      THEN ASITEMCATEGORY
                   WHEN 15
                      THEN ASISSUELOCATION
                   WHEN 16
                      THEN LRBOMITEM.CALCULATIONMODE
                   WHEN 17
                      THEN ASBOMITEMTYPE
                   WHEN 18
                      THEN TO_CHAR( ANOPERATIONALSTEP )
                   WHEN 19
                      THEN TO_CHAR( ANMINIMUMQUANTITY )
                   WHEN 20
                      THEN TO_CHAR( ANMAXIMUMQUANTITY )
                   WHEN 21
                      THEN TO_CHAR( ANFIXEDQUANTITY )
                   WHEN 22
                      THEN TO_CHAR( ANCOMPONENTREVISION )
                   WHEN 23
                      THEN TO_CHAR( ANITEMNUMBER )
                   WHEN 25
                      THEN ASTEXT1
                   WHEN 26
                      THEN ASTEXT2
                   WHEN 27
                      THEN ASCODE
                   WHEN 30
                      THEN TO_CHAR( ANNUMERIC1 )
                   WHEN 31
                      THEN TO_CHAR( ANNUMERIC2 )
                   WHEN 32
                      THEN TO_CHAR( ANNUMERIC3 )
                   WHEN 33
                      THEN TO_CHAR( ANNUMERIC4 )
                   WHEN 34
                      THEN TO_CHAR( ANNUMERIC5 )
                   WHEN 40
                      THEN ASTEXT3
                   WHEN 41
                      THEN ASTEXT4
                   WHEN 42
                      THEN ASTEXT5
                   WHEN 50
                      THEN TO_CHAR( ANBOOLEAN1 )
                   WHEN 51
                      THEN TO_CHAR( ANBOOLEAN2 )
                   WHEN 52
                      THEN TO_CHAR( ANBOOLEAN3 )
                   WHEN 53
                      THEN TO_CHAR( ANBOOLEAN4 )
                   WHEN 60
                      THEN TO_CHAR( ADDATE1,
                                    'dd-mm-yyyy' )
                   WHEN 61
                      THEN TO_CHAR( ADDATE2,
                                    'dd-mm-yyyy' )
                   WHEN 70
                      THEN TO_CHAR( ANCHARACTERISTIC1 )
                   WHEN 71
                      THEN TO_CHAR( ANCHARACTERISTIC2 )
                   WHEN 72
                      THEN TO_CHAR( ANCHARACTERISTIC3 )
                   ELSE NULL
                END
           INTO LSVALUEOLD,
                LSVALUENEW
           FROM BOM_ITEM
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PLANT = ASPLANT
            AND ALTERNATIVE = ANALTERNATIVE
            AND BOM_USAGE = ANUSAGE
            AND ITEM_NUMBER = LNITEMNUMBER;   


         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Update of a not IN DEV BOM (MRP) column <'
                              || REC_MRP_FIELDS.FIELD_ID
                              || '> Old value: '
                              || LSVALUEOLD
                              || ' - New Value: '
                              || LSVALUENEW,
                              IAPICONSTANT.INFOLEVEL_3 );

         IF ( LSSTATUSTYPE <> IAPICONSTANT.STATUSTYPE_DEVELOPMENT )
         THEN
            IF ( IAPIGENERAL.COMPARESTRING( LSVALUEOLD,
                                            LSVALUENEW ) <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    'OldValue <> NewValue',
                                    IAPICONSTANT.INFOLEVEL_3 );
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                       'PhaseMRP: '
                                    || TO_CHAR( REC_MRP_FIELDS.PHASE_MRP ),
                                    IAPICONSTANT.INFOLEVEL_3 );
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                       'PlanningMRP: '
                                    || TO_CHAR( REC_MRP_FIELDS.PLANNING_MRP ),
                                    IAPICONSTANT.INFOLEVEL_3 );
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                       'ProductionMRP: '
                                    || TO_CHAR( REC_MRP_FIELDS.PRODUCTION_MRP ),
                                    IAPICONSTANT.INFOLEVEL_3 );

               IF    (     REC_MRP_FIELDS.PHASE_MRP = 1
                       AND LBPHASEMRPACCESS )
                  OR (     REC_MRP_FIELDS.PLANNING_MRP = 1
                       AND LBPLANNINGMRPACCESS )
                  OR (     REC_MRP_FIELDS.PRODUCTION_MRP = 1
                       AND LBPRODUCTIONMRPACCESS )
               THEN
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                       'MRP Update',
                                       IAPICONSTANT.INFOLEVEL_3 );
                  LBMRPFIELDSCHANGED := TRUE;
                  LBDOINSERT := TRUE;
                  
                  
                  
                  
                  
                  
                  
                  
                  
                  
                  LBCONVERT := FALSE;

                  IF ( REC_MRP_FIELDS.FIELD_ID = 10 )
                  THEN   
                     LSVALUENEW := TO_CHAR( ROUND( ANCOMPONENTSCRAP,
                                                   2 ) );
                     LBCONVERT := TRUE;
                  ELSIF( REC_MRP_FIELDS.FIELD_ID = 9 )
                  THEN
                     
                     LSVALUENEW := TO_CHAR( ROUND( ANASSEMBLYSCRAP,
                                                   2 ) );
                     LBCONVERT := TRUE;
                  END IF;

                  IF ( LBCONVERT = TRUE )
                  THEN
                     IAPIGENERAL.LOGINFO( GSSOURCE,
                                          LSMETHOD,
                                             'Special check for component/assembly scrap; lsValueNew became: '
                                          || LSVALUENEW,
                                          IAPICONSTANT.INFOLEVEL_3 );

                     IF ( IAPIGENERAL.COMPARESTRING( LSVALUEOLD,
                                                     LSVALUENEW ) = IAPICONSTANTDBERROR.DBERR_SUCCESS )
                     THEN
                        LBDOINSERT := FALSE;
                        IAPIGENERAL.LOGINFO( GSSOURCE,
                                             LSMETHOD,
                                             'Special check for component/assembly scrap; no journal required',
                                             IAPICONSTANT.INFOLEVEL_3 );
                     END IF;
                  END IF;

                  
                  IF ( LBDOINSERT = TRUE )
                  THEN
                     INSERT INTO ITBOMJRNL
                                 ( PART_NO,
                                   REVISION,
                                   PLANT,
                                   ALTERNATIVE,
                                   BOM_USAGE,
                                   ITEM_NUMBER,
                                   USER_ID,
                                   TIMESTAMP,
                                   FORENAME,
                                   LAST_NAME,
                                   HEADER_ID,
                                   FIELD_ID,
                                   OLD_VALUE,
                                   NEW_VALUE )
                          VALUES ( ASPARTNO,
                                   ANREVISION,
                                   ASPLANT,
                                   ANALTERNATIVE,
                                   ANUSAGE,
                                   ANITEMNUMBER,
                                   IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                                   SYSDATE,
                                   IAPIGENERAL.SESSION.APPLICATIONUSER.FORENAME,
                                   IAPIGENERAL.SESSION.APPLICATIONUSER.LASTNAME,
                                   REC_MRP_FIELDS.HEADER_ID,
                                   REC_MRP_FIELDS.FIELD_ID,
                                   LSVALUEOLD,
                                   LSVALUENEW );

                     
                     IAPIGENERAL.LOGINFO( GSSOURCE,
                                          LSMETHOD,
                                             'Update of BOM MRP column <'
                                          || REC_MRP_FIELDS.FIELD_ID
                                          || '> of non-in dev. specification '
                                          || ASPARTNO
                                          || '['
                                          || ANREVISION
                                          || '] success',
                                          IAPICONSTANT.INFOLEVEL_3 );
                  END IF;
               ELSE
                  
                  RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                             LSMETHOD,
                                                             IAPICONSTANTDBERROR.DBERR_NOMRPACCESS,
                                                             ASPARTNO,
                                                             ANREVISION,
                                                             REC_MRP_FIELDS.FIELD_ID );
               END IF;
            END IF;
         END IF;
      END LOOP;

      
      IF LBDISPLAYFORMATAVAILABLE
      THEN
         IAPIGENERAL.LOGWARNING( GSSOURCE,
                                 LSMETHOD,
                                    'No BOM display format available in specification_section for specification '
                                 || ASPARTNO
                                 || ' ['
                                 || ANREVISION
                                 || ']' );
      END IF;

      IF LRBOMITEM.ALTERNATIVEPRIORITY < 1
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_ALTPRIORITYLESSTHANONE ) );
      END IF;

      IF LRBOMITEM.ALTERNATIVEPRIORITY > 1
      THEN
         IF LRBOMITEM.ALTERNATIVEGROUP IS NULL
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_INVALIDALTGROUP ) );
         END IF;

         SELECT MAX( ALT_PRIORITY )
           INTO LIPRIORITY
           FROM BOM_ITEM
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PLANT = ASPLANT
            AND ALTERNATIVE = ANALTERNATIVE
            AND BOM_USAGE = ANUSAGE
            AND ALT_GROUP = LRBOMITEM.ALTERNATIVEGROUP;
      ELSE
         LIPRIORITY := 1000;
      END IF;

      IF    ( LRBOMITEM.ALTERNATIVEPRIORITY < 0 )
         OR ( LRBOMITEM.ALTERNATIVEPRIORITY >   LIPRIORITY
                                              + 1 )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_INVALIDALTPRIORITY ) );
      END IF;

      IF     LRBOMITEM.RELEVANCYTOCOSTING = 1
         AND LRBOMITEM.BULKMATERIAL = 1
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_BOMITEMCOSTBULKMUTEXCL ) );
      END IF;

      
      
      IF LRBOMITEM.COMPONENTSCRAPSYNC = 1
      THEN
         SELECT COMPONENT_SCRAP
           INTO LRBOMITEM.COMPONENTSCRAP
           FROM PART_PLANT
          WHERE PART_NO = LRBOMITEM.COMPONENTPARTNO
            AND PLANT = LRBOMITEM.COMPONENTPLANT
            AND OBSOLETE = 0;
      END IF;

      
      UPDATE BOM_ITEM
         SET COMPONENT_PART = LRBOMITEM.COMPONENTPARTNO,
             COMPONENT_REVISION = LRBOMITEM.COMPONENTREVISION,
             COMPONENT_PLANT = LRBOMITEM.COMPONENTPLANT,
             ALT_PRIORITY = LRBOMITEM.ALTERNATIVEPRIORITY,
             ALT_GROUP = LRBOMITEM.ALTERNATIVEGROUP,
             QUANTITY = LRBOMITEM.QUANTITY,
             UOM = LRBOMITEM.UOM,
             CONV_FACTOR = LRBOMITEM.CONVERSIONFACTOR,
             TO_UNIT = LRBOMITEM.CONVERTEDUOM,
             YIELD = LRBOMITEM.YIELD,
             ASSEMBLY_SCRAP = LRBOMITEM.ASSEMBLYSCRAP,
             COMPONENT_SCRAP = LRBOMITEM.COMPONENTSCRAP,
             LEAD_TIME_OFFSET = LRBOMITEM.LEADTIMEOFFSET,
             RELEVENCY_TO_COSTING = LRBOMITEM.RELEVANCYTOCOSTING,
             BULK_MATERIAL = LRBOMITEM.BULKMATERIAL,
             ITEM_CATEGORY = LRBOMITEM.ITEMCATEGORY,
             ISSUE_LOCATION = LRBOMITEM.ISSUELOCATION,
             CALC_FLAG = LRBOMITEM.CALCULATIONMODE,
             BOM_ITEM_TYPE = LRBOMITEM.BOMITEMTYPE,
             OPERATIONAL_STEP = LRBOMITEM.OPERATIONALSTEP,
             MIN_QTY = LRBOMITEM.MINIMUMQUANTITY,
             MAX_QTY = LRBOMITEM.MAXIMUMQUANTITY,
             FIXED_QTY = LRBOMITEM.FIXEDQUANTITY,
             CODE = LRBOMITEM.CODE,
             CHAR_1 = LRBOMITEM.TEXT1,
             CHAR_2 = LRBOMITEM.TEXT2,
             CHAR_3 = LRBOMITEM.TEXT3,
             CHAR_4 = LRBOMITEM.TEXT4,
             CHAR_5 = LRBOMITEM.TEXT5,
             NUM_1 = LRBOMITEM.NUMERIC1,
             NUM_2 = LRBOMITEM.NUMERIC2,
             NUM_3 = LRBOMITEM.NUMERIC3,
             NUM_4 = LRBOMITEM.NUMERIC4,
             NUM_5 = LRBOMITEM.NUMERIC5,
             BOOLEAN_1 = LRBOMITEM.BOOLEAN1,
             BOOLEAN_2 = LRBOMITEM.BOOLEAN2,
             BOOLEAN_3 = LRBOMITEM.BOOLEAN3,
             BOOLEAN_4 = LRBOMITEM.BOOLEAN4,
             DATE_1 = LRBOMITEM.DATE1,
             DATE_2 = LRBOMITEM.DATE2,
             CH_1 = LRBOMITEM.CHARACTERISTIC1,
             CH_2 = LRBOMITEM.CHARACTERISTIC2,
             CH_3 = LRBOMITEM.CHARACTERISTIC3,
             MAKE_UP = LRBOMITEM.MAKEUP,
             INTL_EQUIVALENT = LRBOMITEM.INTERNATIONALEQUIVALENT,
             COMPONENT_SCRAP_SYNC = LRBOMITEM.COMPONENTSCRAPSYNC
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANT
         AND ALTERNATIVE = ANALTERNATIVE
         AND BOM_USAGE = ANUSAGE
         AND ITEM_NUMBER = LNITEMNUMBER;

      IF LBMRPFIELDSCHANGED
      THEN
         LNRETVAL := SETEXPORTTOERP( ASPARTNO,
                                     ANREVISION );

         IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
         THEN
            RETURN LNRETVAL;
         END IF;
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

      LNRETVAL := POSTITEMCHANGED( ASPARTNO,
                                   ANREVISION,
                                   LSMETHOD,
                                   TRUE,
                                   AQERRORS );

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


      RETURN LNRETVAL;
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_DUPVALONINDEX );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEITEM;

   
   
   FUNCTION SAVEITEM_MOP(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE,
      ASFROMCOMPONENTPARTNO      IN       IAPITYPE.PARTNO_TYPE,
      ASTOCOMPONENTPARTNO        IN       IAPITYPE.PARTNO_TYPE,
      ASUOM                      IN       IAPITYPE.DESCRIPTION_TYPE,
      ANCONVERSIONFACTOR         IN       IAPITYPE.BOMCONVFACTOR_TYPE,
      ASCONVERTEDUOM             IN       IAPITYPE.DESCRIPTION_TYPE,
      ASCURRENTCOMPONENTUOM      IN       IAPITYPE.DESCRIPTION_TYPE,
      ANCOMPONENTSCRAP           IN       IAPITYPE.SCRAP_TYPE,
      ANLEADTIMEOFFSET           IN       IAPITYPE.BOMLEADTIMEOFFSET_TYPE,
      ANRELEVANCYTOCOSTING       IN       IAPITYPE.BOOLEAN_TYPE,
      ANBULKMATERIAL             IN       IAPITYPE.BOOLEAN_TYPE,
      ASITEMCATEGORY             IN       IAPITYPE.BOMITEMCATEGORY_TYPE,
      ASISSUELOCATION            IN       IAPITYPE.BOMISSUELOCATION_TYPE,
      ANOPERATIONALSTEP          IN       IAPITYPE.BOMOPERATIONALSTEP_TYPE,
      ANCOMPONENTSCRAPSYNC       IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0)
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveItem';
      LRBOMITEM                     IAPITYPE.BOMITEMREC_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LQERRORS                      IAPITYPE.REF_TYPE;
   BEGIN
      
      
      
      
      




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Key: '
                           || ASPARTNO
                           || ' - '
                           || ANREVISION
                           || ' - '
                           || ASPLANT
                           || ' - '
                           || ANALTERNATIVE
                           || ' - '
                           || ANUSAGE);
      GTBOMITEMS.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             LQERRORS );
      LNRETVAL := CHECKEDITACCESS( ASPARTNO,
                                   ANREVISION );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         RETURN LNRETVAL;
      END IF;

      LRBOMITEM.PARTNO := ASPARTNO;
      LRBOMITEM.REVISION := ANREVISION;
      LRBOMITEM.PLANT := ASPLANT;
      LRBOMITEM.ALTERNATIVE := ANALTERNATIVE;
      LRBOMITEM.BOMUSAGE := ANUSAGE;
      
      
      
      LRBOMITEM.COMPONENTPARTNO := ASTOCOMPONENTPARTNO; 
      LRBOMITEM.UOM := ASUOM;
      LRBOMITEM.CONVERSIONFACTOR := ANCONVERSIONFACTOR;
      LRBOMITEM.CONVERTEDUOM := ASCONVERTEDUOM;
      LRBOMITEM.COMPONENTSCRAP := ANCOMPONENTSCRAP;
      LRBOMITEM.LEADTIMEOFFSET := ANLEADTIMEOFFSET;
      LRBOMITEM.RELEVANCYTOCOSTING := ANRELEVANCYTOCOSTING;
      LRBOMITEM.BULKMATERIAL := ANBULKMATERIAL;
      LRBOMITEM.ITEMCATEGORY := ASITEMCATEGORY;
      LRBOMITEM.ISSUELOCATION := ASISSUELOCATION;
      LRBOMITEM.OPERATIONALSTEP := ANOPERATIONALSTEP;
      LRBOMITEM.COMPONENTSCRAPSYNC := ANCOMPONENTSCRAPSYNC;
      GTBOMITEMS( 0 ) := LRBOMITEM;

      
      
      
      LNRETVAL := PREITEMCHANGED( ASPARTNO,
                                  ANREVISION,
                                  LSMETHOD,
                                  LQERRORS );

      
      IF (     LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
           AND LNRETVAL <> IAPICONSTANTDBERROR.DBERR_NOUPDATEACCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      
      
      LRBOMITEM := GTBOMITEMS( 0 );
      
      LRBOMITEM.PARTNO := ASPARTNO;
      LRBOMITEM.REVISION := ANREVISION;
      LRBOMITEM.PLANT := ASPLANT;
      LRBOMITEM.ALTERNATIVE := ANALTERNATIVE;
      LRBOMITEM.BOMUSAGE := ANUSAGE;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

     
     UPDATE BOM_ITEM
     SET    COMPONENT_PART = LRBOMITEM.COMPONENTPARTNO,
            UOM = LRBOMITEM.UOM,
            TO_UNIT = LRBOMITEM.CONVERTEDUOM,
           
            
            CONV_FACTOR = LRBOMITEM.CONVERSIONFACTOR,
            ITEM_CATEGORY = LRBOMITEM.ITEMCATEGORY,
            RELEVENCY_TO_COSTING = LRBOMITEM.RELEVANCYTOCOSTING,
            BULK_MATERIAL = LRBOMITEM.BULKMATERIAL,
            COMPONENT_SCRAP = LRBOMITEM.COMPONENTSCRAP,
            COMPONENT_SCRAP_SYNC = LRBOMITEM.COMPONENTSCRAPSYNC,
            ISSUE_LOCATION = LRBOMITEM.ISSUELOCATION,
            LEAD_TIME_OFFSET = LRBOMITEM.LEADTIMEOFFSET,
            OPERATIONAL_STEP = LRBOMITEM.OPERATIONALSTEP
           
      WHERE PART_NO = LRBOMITEM.PARTNO
        AND REVISION = LRBOMITEM.REVISION
        AND PLANT = LRBOMITEM.PLANT
        AND ALTERNATIVE = LRBOMITEM.ALTERNATIVE
        AND BOM_USAGE = LRBOMITEM.BOMUSAGE
        
        
        AND COMPONENT_PART = ASFROMCOMPONENTPARTNO
        
        AND ROWNUM = 1;

     IF ASCURRENTCOMPONENTUOM <> LRBOMITEM.UOM
     THEN
        UPDATE BOM_ITEM
           SET CALC_FLAG = 'N'
         WHERE PART_NO = LRBOMITEM.PARTNO
           AND REVISION = LRBOMITEM.REVISION
           AND PLANT = LRBOMITEM.PLANT
           AND ALTERNATIVE = LRBOMITEM.ALTERNATIVE
           AND BOM_USAGE = LRBOMITEM.BOMUSAGE
           AND COMPONENT_PART = LRBOMITEM.COMPONENTPARTNO;







     END IF;

      
      
      
      LNRETVAL := POSTITEMCHANGED( ASPARTNO,
                                   ANREVISION,
                                   LSMETHOD,
                                   TRUE,
                                   LQERRORS );
      RETURN LNRETVAL;

   EXCEPTION
      WHEN DUP_VAL_ON_INDEX
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_DUPVALONINDEX );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEITEM_MOP;
   


   FUNCTION REMOVEITEM(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE,
      ANITEMNUMBER               IN       IAPITYPE.BOMITEMNUMBER_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveItem';
      LBHARMONISEDBOM               BOOLEAN;
      LNHARMONIZED                  PLS_INTEGER;
      LNCOUNT                       PLS_INTEGER;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRBOMITEM                     IAPITYPE.BOMITEMREC_TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LSSQLINFO                     IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
      
      
      
      
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
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );



      GTBOMITEMS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LNRETVAL := CHECKEDITACCESS( ASPARTNO,
                                   ANREVISION );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         RETURN LNRETVAL;
      END IF;

      LRBOMITEM.PARTNO := ASPARTNO;
      LRBOMITEM.REVISION := ANREVISION;
      LRBOMITEM.PLANT := ASPLANT;
      LRBOMITEM.ALTERNATIVE := ANALTERNATIVE;
      LRBOMITEM.BOMUSAGE := ANUSAGE;
      LRBOMITEM.ITEMNUMBER := ANITEMNUMBER;
      GTBOMITEMS( 0 ) := LRBOMITEM;

      GTINFO( 0 ) := LRINFO;

      LNRETVAL := PREITEMCHANGED( ASPARTNO,
                                  ANREVISION,
                                  LSMETHOD,
                                  AQERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      
      LRINFO := GTINFO( 0 );
      
      
      LRBOMITEM := GTBOMITEMS( 0 );
      LNRETVAL := IAPISPECIFICATION.ISLOCALIZED( ASPARTNO,
                                                 ANREVISION,
                                                 LNHARMONIZED );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN LNRETVAL;
      END IF;

      
      IF     LNHARMONIZED = 1
         AND ASPLANT = IAPICONSTANT.PLANT_INTERNATIONAL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_HARMINTLBOM,
                                                    ASPARTNO,
                                                    ANREVISION );
      END IF;

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM BOM_ITEM
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANT
         AND ALTERNATIVE = ANALTERNATIVE
         AND BOM_USAGE = ANUSAGE
         AND ITEM_NUMBER = ANITEMNUMBER;

      IF ( LNCOUNT = 0 )
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOBOMITEM,
                                                    ASPARTNO,
                                                    ANREVISION,
                                                    ASPLANT,
                                                    ANALTERNATIVE,
                                                    ANUSAGE,
                                                    ANITEMNUMBER );
      END IF;

      
      DELETE FROM BOM_ITEM
            WHERE PART_NO = ASPARTNO
              AND REVISION = ANREVISION
              AND PLANT = ASPLANT
              AND ALTERNATIVE = ANALTERNATIVE
              AND BOM_USAGE = ANUSAGE
              AND ITEM_NUMBER = ANITEMNUMBER;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Deleted Bom Item '
                           || ASPARTNO
                           || ' ['
                           || ANREVISION
                           || '] '
                           || ASPLANT
                           || '-'
                           || ANALTERNATIVE
                           || '-'
                           || ANUSAGE
                           || '-'
                           || ANITEMNUMBER );

      
      
      
      
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
      LNRETVAL := POSTITEMCHANGED( ASPARTNO,
                                   ANREVISION,
                                   LSMETHOD,
                                   TRUE,
                                   AQERRORS );
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

      RETURN LNRETVAL;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEITEM;

   

   FUNCTION REMOVEITEM_MOP(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ASCOMPONENTPARTNO          IN       IAPITYPE.PARTNO_TYPE,
      ASCOMPONENTPLANT           IN       IAPITYPE.PLANT_TYPE)
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveItem';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRBOMITEM                     IAPITYPE.BOMITEMREC_TYPE;
      LQERRORS                      IAPITYPE.REF_TYPE;

   BEGIN
      
      
      
      
      

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      GTBOMITEMS.DELETE;
      GTERRORS.DELETE;

      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             LQERRORS );
      LNRETVAL := CHECKEDITACCESS( ASPARTNO,
                                   ANREVISION );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         RETURN LNRETVAL;
      END IF;

      LRBOMITEM.PARTNO := ASPARTNO;
      LRBOMITEM.REVISION := ANREVISION;
      LRBOMITEM.PLANT := ASPLANT;
      LRBOMITEM.COMPONENTPARTNO := ASCOMPONENTPARTNO;
      LRBOMITEM.COMPONENTPLANT := ASCOMPONENTPLANT;
      GTBOMITEMS( 0 ) := LRBOMITEM;

      
      
      
      LNRETVAL := PREITEMCHANGED( ASPARTNO,
                                  ANREVISION,
                                  LSMETHOD,
                                  LQERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      
      
      LRBOMITEM.PARTNO := ASPARTNO;
      LRBOMITEM.REVISION := ANREVISION;
      LRBOMITEM.PLANT := ASPLANT;
      

      
      
      LRBOMITEM := GTBOMITEMS( 0 );


      
      IF LRBOMITEM.COMPONENTPLANT IS NULL
      THEN
         DELETE FROM BOM_ITEM
               WHERE PART_NO = LRBOMITEM.PARTNO
                 AND REVISION = LRBOMITEM.REVISION
                 AND COMPONENT_PART = LRBOMITEM.COMPONENTPARTNO
                 AND ALT_GROUP IS NULL;

         FOR J IN ( SELECT PLANT,
                           ALTERNATIVE,
                           BOM_USAGE,
                           ALT_GROUP,
                           ALT_PRIORITY
                     FROM BOM_ITEM
                    WHERE PART_NO = LRBOMITEM.PARTNO
                      AND REVISION = LRBOMITEM.REVISION
                      AND COMPONENT_PART = LRBOMITEM.COMPONENTPARTNO
                      AND ALT_GROUP IS NOT NULL )
         LOOP
            DELETE FROM BOM_ITEM
                  WHERE PART_NO = LRBOMITEM.PARTNO
                    AND REVISION = LRBOMITEM.REVISION
                    AND PLANT = J.PLANT
                    AND ALTERNATIVE = J.ALTERNATIVE
                    AND BOM_USAGE = J.BOM_USAGE
                    AND ALT_GROUP = J.ALT_GROUP
                    AND ALT_PRIORITY >= J.ALT_PRIORITY;
         END LOOP;
      ELSE
         DELETE FROM BOM_ITEM
               WHERE PART_NO = LRBOMITEM.PARTNO
                 AND REVISION = LRBOMITEM.REVISION
                 AND COMPONENT_PART = LRBOMITEM.COMPONENTPARTNO
                 AND BOM_ITEM.PLANT = LRBOMITEM.PLANT
                 AND ALT_GROUP IS NULL;

         FOR J IN ( SELECT PLANT,
                           ALTERNATIVE,
                           BOM_USAGE,
                           ALT_GROUP,
                           ALT_PRIORITY
                     FROM BOM_ITEM
                    WHERE PART_NO = LRBOMITEM.PARTNO
                      AND REVISION = LRBOMITEM.REVISION
                      AND COMPONENT_PART = LRBOMITEM.COMPONENTPARTNO
                      AND BOM_ITEM.PLANT = LRBOMITEM.PLANT
                      AND ALT_GROUP IS NOT NULL )
         LOOP
            DELETE FROM BOM_ITEM
                  WHERE PART_NO = LRBOMITEM.PARTNO
                    AND REVISION = LRBOMITEM.REVISION
                    AND PLANT = J.PLANT
                    AND ALTERNATIVE = J.ALTERNATIVE
                    AND BOM_USAGE = J.BOM_USAGE
                    AND ALT_GROUP = J.ALT_GROUP
                    AND ALT_PRIORITY >= J.ALT_PRIORITY;
         END LOOP;
      END IF;

      
      
      
      LNRETVAL := POSTITEMCHANGED( ASPARTNO,
                                   ANREVISION,
                                   LSMETHOD,
                                   TRUE,
                                   LQERRORS );
      RETURN LNRETVAL;

   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEITEM_MOP;
  


   FUNCTION REMOVEHEADER(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE DEFAULT NULL,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE DEFAULT NULL,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveHeader';
      LNCOUNT                       PLS_INTEGER;
      LNHARMONIZED                  IAPITYPE.BOOLEAN_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRBOMHEADER                   IAPITYPE.BOMHEADERREC_TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LSSQLINFO                     IAPITYPE.SQLSTRING_TYPE;
      LNOPTIONAL                    IAPITYPE.BOOLEAN_TYPE;
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
  
      LNEXIST                       IAPITYPE.NUMVAL_TYPE;

 BEGIN
      
      
      
      
      
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
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );



      GTBOMITEMS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LNRETVAL := CHECKEDITACCESS( ASPARTNO,
                                   ANREVISION );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         RETURN LNRETVAL;
      END IF;

      LRBOMHEADER.PARTNO := ASPARTNO;
      LRBOMHEADER.REVISION := ANREVISION;
      LRBOMHEADER.PLANT := ASPLANT;
      LRBOMHEADER.ALTERNATIVE := ANALTERNATIVE;
      LRBOMHEADER.BOMUSAGE := ANUSAGE;
      GTBOMHEADERS( 0 ) := LRBOMHEADER;
      GTINFO( 0 ) := LRINFO;

      LNRETVAL := PREITEMCHANGED( ASPARTNO,
                                  ANREVISION,
                                  LSMETHOD,
                                  AQERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      
      
      LRINFO := GTINFO( 0 );
      
      LRBOMHEADER := GTBOMHEADERS( 0 );

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM BOM_HEADER
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANT
         AND ALTERNATIVE = ANALTERNATIVE
         AND BOM_USAGE = ANUSAGE;

      
      IF LNCOUNT <> 1
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOBOMHEADER,
                                                    ASPARTNO,
                                                    ANREVISION,
                                                    ASPLANT,
                                                    ANALTERNATIVE,
                                                    ANUSAGE );
      END IF;

      LNRETVAL := IAPISPECIFICATION.ISLOCALIZED( ASPARTNO,
                                                 ANREVISION,
                                                 LNHARMONIZED );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN LNRETVAL;
      END IF;

      
      IF LNHARMONIZED = 1
      THEN
         IF ASPLANT = IAPICONSTANT.PLANT_INTERNATIONAL
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_HARMINTLBOM,
                                                       ASPARTNO,
                                                       ANREVISION );
         ELSIF ASPLANT IS NULL
         THEN
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM BOM_HEADER
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND PLANT = IAPICONSTANT.PLANT_INTERNATIONAL;

            IF LNCOUNT > 0
            THEN
               RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                          LSMETHOD,
                                                          IAPICONSTANTDBERROR.DBERR_HARMINTLBOM,
                                                          ASPARTNO,
                                                          ANREVISION );
            END IF;
         END IF;
      END IF;

      
      DELETE FROM BOM_ITEM
            WHERE PART_NO = ASPARTNO
              AND REVISION = ANREVISION
              AND PLANT = NVL( ASPLANT,
                               PLANT )
              AND ALTERNATIVE = NVL( ANALTERNATIVE,
                                     ALTERNATIVE )
              AND BOM_USAGE = NVL( ANUSAGE,
                                   BOM_USAGE );

      DELETE FROM BOM_HEADER
            WHERE PART_NO = ASPARTNO
              AND REVISION = ANREVISION
              AND PLANT = NVL( ASPLANT,
                               PLANT )
              AND ALTERNATIVE = NVL( ANALTERNATIVE,
                                     ALTERNATIVE )
              AND BOM_USAGE = NVL( ANUSAGE,
                                   BOM_USAGE );

      BEGIN
       SELECT COUNT(1) INTO LNEXIST FROM SYS.USER_TABLES  WHERE TABLE_NAME = 'RNDTBOMHEADER';
       IF LNEXIST > 0 THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Execute <'
                              || 'f_delbom_rndtbomheader'
                              || '>',
                              IAPICONSTANT.INFOLEVEL_3 );
        LNRETVAL := F_DELBOM_RNDTBOMHEADER( ASPARTNO, ANREVISION, ASPLANT, ANALTERNATIVE, ANUSAGE );
    END IF;
   END;
    

      
      
      
      

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

      LNRETVAL := POSTITEMCHANGED( ASPARTNO,
                                   ANREVISION,
                                   LSMETHOD,
                                   TRUE,
                                   AQERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM BOM_HEADER
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION;

      IF ( LNCOUNT = 0 )
      THEN
         SELECT DECODE( MANDATORY,
                        'Y', 0,
                        1 ),
                SECTION_ID,
                SUB_SECTION_ID
           INTO LNOPTIONAL,
                LNSECTIONID,
                LNSUBSECTIONID
           FROM FRAME_SECTION
          WHERE ( FRAME_NO, REVISION, OWNER ) = ( SELECT FRAME_ID,
                                                         FRAME_REV,
                                                         FRAME_OWNER
                                                   FROM SPECIFICATION_HEADER
                                                  WHERE PART_NO = ASPARTNO
                                                    AND REVISION = ANREVISION )
            AND TYPE = IAPICONSTANT.SECTIONTYPE_BOM;

         IF ( LNOPTIONAL = 1 )
         THEN
            LNRETVAL :=
               IAPISPECIFICATIONSECTION.REMOVESECTIONITEM( ASPARTNO,
                                                           ANREVISION,
                                                           LNSECTIONID,
                                                           LNSUBSECTIONID,
                                                           IAPICONSTANT.SECTIONTYPE_BOM,
                                                           0,
                                                           NULL,
                                                           NULL,
                                                           NULL );
         END IF;
      END IF;

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

      RETURN LNRETVAL;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEHEADER;

   
   FUNCTION ADDHEADER(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ANQUANTITY                 IN       IAPITYPE.BOMQUANTITY_TYPE,
      ANCONVERSIONFACTOR         IN       IAPITYPE.BOMCONVFACTOR_TYPE,
      ASCONVERTEDUOM             IN       IAPITYPE.DESCRIPTION_TYPE,
      ANYIELD                    IN       IAPITYPE.BOMYIELD_TYPE,
      ASCALCULATIONMODE          IN       IAPITYPE.BOMITEMCALCFLAG_TYPE,
      ASBOMTYPE                  IN       IAPITYPE.BOMITEMTYPE_TYPE,
      ANMINIMUMQUANTITY          IN       IAPITYPE.BOMQUANTITY_TYPE,
      ANMAXIMUMQUANTITY          IN       IAPITYPE.BOMQUANTITY_TYPE,
      ADPLANNEDEFFECTIVEDATE     IN       IAPITYPE.DATE_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddHeader';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRBOMHEADER                   IAPITYPE.BOMHEADERREC_TYPE;
      LNSC                          IAPITYPE.ID_TYPE;
      LNSB                          IAPITYPE.ID_TYPE;
      LSFRAMENO                     IAPITYPE.FRAMENO_TYPE;
      LNFRAMEREVISION               IAPITYPE.FRAMEREVISION_TYPE;
      LNFRAMEOWNER                  IAPITYPE.OWNER_TYPE;
      LNHARMONIZED                  PLS_INTEGER;
      LNCOUNT                       PLS_INTEGER;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LSSQLINFO                     IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
      
      
      
      
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
                              'Key: '
                           || ASPARTNO
                           || ' - '
                           || ANREVISION
                           || ' - '
                           || ASPLANT
                           || ' - '
                           || ANALTERNATIVE
                           || ' - '
                           || ANUSAGE );
      GTBOMHEADERS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LNRETVAL := CHECKEDITACCESS( ASPARTNO,
                                   ANREVISION );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         RETURN LNRETVAL;
      END IF;

      LRBOMHEADER.PARTNO := ASPARTNO;
      LRBOMHEADER.REVISION := ANREVISION;
      LRBOMHEADER.PLANT := ASPLANT;
      LRBOMHEADER.ALTERNATIVE := ANALTERNATIVE;
      LRBOMHEADER.BOMUSAGE := ANUSAGE;
      LRBOMHEADER.DESCRIPTION := ASDESCRIPTION;
      LRBOMHEADER.QUANTITY := ANQUANTITY;
      LRBOMHEADER.CONVERSIONFACTOR := ANCONVERSIONFACTOR;
      LRBOMHEADER.CONVERTEDUOM := ASCONVERTEDUOM;
      LRBOMHEADER.YIELD := ANYIELD;
      LRBOMHEADER.CALCULATIONMODE := ASCALCULATIONMODE;
      LRBOMHEADER.BOMITEMTYPE := ASBOMTYPE;
      LRBOMHEADER.MINIMUMQUANTITY := ANMINIMUMQUANTITY;
      LRBOMHEADER.MAXIMUMQUANTITY := ANMAXIMUMQUANTITY;
      LRBOMHEADER.PLANNEDEFFECTIVEDATE := ADPLANNEDEFFECTIVEDATE;
      LRBOMHEADER.PREFERRED := 0;
      GTBOMHEADERS( 0 ) := LRBOMHEADER;

      GTINFO( 0 ) := LRINFO;

      
      
      
      
      
      LNRETVAL := PREITEMCHANGED( ASPARTNO,
                                  ANREVISION,
                                  LSMETHOD,
                                  AQERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      
      
      
      

      
      LRINFO := GTINFO( 0 );
      
      LRBOMHEADER := GTBOMHEADERS( 0 );
      
      LRBOMHEADER.PARTNO := ASPARTNO;
      LRBOMHEADER.REVISION := ANREVISION;
      LRBOMHEADER.PLANT := ASPLANT;
      LRBOMHEADER.ALTERNATIVE := ANALTERNATIVE;
      LRBOMHEADER.BOMUSAGE := ANUSAGE;

      
      IF ( LRBOMHEADER.PLANNEDEFFECTIVEDATE IS NULL )
      THEN
         LNRETVAL :=
            IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                IAPICONSTANTCOLUMN.PLANNEDEFFECTIVEDATECOL );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( IAPICONSTANTCOLUMN.PLANNEDEFFECTIVEDATECOL,
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( LRBOMHEADER.QUANTITY IS NULL )
      THEN
         LNRETVAL :=
                  IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                      LSMETHOD,
                                                      IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                      IAPICONSTANTCOLUMN.BASEQUANTITYCOL );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( IAPICONSTANTCOLUMN.BASEQUANTITYCOL,
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

      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM ITBU
       WHERE BOM_USAGE = ANUSAGE;

      IF ( LNCOUNT <> 1 )
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_INVALIDBOMUSAGE );
      END IF;

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM BOM_HEADER
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANT
         AND ALTERNATIVE = ANALTERNATIVE
         AND BOM_USAGE = ANUSAGE;

      
      IF LNCOUNT > 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_DUPVALONINDEX );
      END IF;

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM BOM_HEADER
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANT
         AND BOM_USAGE = ANUSAGE;

      
      IF LNCOUNT = 0
      THEN
         LRBOMHEADER.PREFERRED := 1;
      END IF;

      LNRETVAL := CHECKBOMHEADER( LRBOMHEADER );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM SPECIFICATION_SECTION
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND TYPE = IAPICONSTANT.SECTIONTYPE_BOM;

      IF LNCOUNT = 0
      THEN
         SELECT FRAME_ID,
                FRAME_REV,
                FRAME_OWNER
           INTO LSFRAMENO,
                LNFRAMEREVISION,
                LNFRAMEOWNER
           FROM SPECIFICATION_HEADER
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION;

         SELECT SECTION_ID,
                SUB_SECTION_ID
           INTO LNSC,
                LNSB
           FROM FRAME_SECTION
          WHERE FRAME_NO = LSFRAMENO
            AND REVISION = LNFRAMEREVISION
            AND OWNER = LNFRAMEOWNER
            AND TYPE = IAPICONSTANT.SECTIONTYPE_BOM;

         LNRETVAL :=
            IAPISPECIFICATIONSECTION.EDITSECTION( ASPARTNO,
                                                  ANREVISION,
                                                  LSFRAMENO,
                                                  LNFRAMEREVISION,
                                                  LNFRAMEOWNER,
                                                  LNSC,
                                                  LNSB,
                                                  IAPICONSTANT.SECTIONTYPE_BOM,
                                                  0,
                                                  'add' );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      END IF;

      
      INSERT INTO BOM_HEADER
                  ( PART_NO,
                    REVISION,
                    PLANT,
                    ALTERNATIVE,
                    BOM_USAGE,
                    BASE_QUANTITY,
                    DESCRIPTION,
                    YIELD,
                    CONV_FACTOR,
                    TO_UNIT,
                    CALC_FLAG,
                    BOM_TYPE,
                    MIN_QTY,
                    MAX_QTY,
                    PLANT_EFFECTIVE_DATE,
                    PREFERRED )
           VALUES ( ASPARTNO,
                    ANREVISION,
                    ASPLANT,
                    ANALTERNATIVE,
                    ANUSAGE,
                    LRBOMHEADER.QUANTITY,
                    LRBOMHEADER.DESCRIPTION,
                    LRBOMHEADER.YIELD,
                    LRBOMHEADER.CONVERSIONFACTOR,
                    LRBOMHEADER.CONVERTEDUOM,
                    LRBOMHEADER.CALCULATIONMODE,
                    LRBOMHEADER.BOMITEMTYPE,
                    LRBOMHEADER.MINIMUMQUANTITY,
                    LRBOMHEADER.MAXIMUMQUANTITY,
                    LRBOMHEADER.PLANNEDEFFECTIVEDATE,
                    LRBOMHEADER.PREFERRED );

      
       
       
       
      UPDATE PART_PLANT
         SET PLANT_ACCESS = 'Y'
       WHERE PART_NO = ASPARTNO
         AND PLANT = ASPLANT;


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

      
      
      
      
      
         LNRETVAL := POSTITEMCHANGED( ASPARTNO,
                                      ANREVISION,
                                      LSMETHOD,
                                      TRUE,
                                      AQERRORS );
      
      
      
      

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


      IF ( GTERRORS.COUNT > 0 )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Errors : '
                              || GTERRORS.COUNT );
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );

         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
         ELSE
            RETURN( LNRETVAL );
         END IF;
      ELSE
         RETURN LNRETVAL;
      END IF;
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_DUPVALONINDEX,
                                                    ASPARTNO,
                                                    ANREVISION );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDHEADER;

   
   FUNCTION ADDDEVHEADER(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddDevHeader';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LDPED                         IAPITYPE.DATE_TYPE;
      LNCOUNT                       PLS_INTEGER;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LRINFO1                       IAPITYPE.INFOREC_TYPE;
      LTINFO                        IAPITYPE.INFOTAB_TYPE;
      LSSQLINFO                     IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
      
      
      
      
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
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := CHECKEDITACCESS( ASPARTNO,
                                   ANREVISION );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         RETURN LNRETVAL;
      END IF;

      GTINFO.DELETE;
      GTINFO( 0 ) := LRINFO;
      LNRETVAL := PREITEMCHANGED( ASPARTNO,
                                  ANREVISION,
                                  LSMETHOD,
                                  AQERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      
      LRINFO := GTINFO( 0 );

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM PART_PLANT
       WHERE PART_NO = ASPARTNO
         AND PLANT = IAPICONSTANT.PLANT_DEVELOPMENT;

      IF LNCOUNT = 0
      THEN
         INSERT INTO PART_PLANT
                     ( PART_NO,
                       PLANT )
              VALUES ( ASPARTNO,
                       IAPICONSTANT.PLANT_DEVELOPMENT );

         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'DEV plant was added to part '
                              || ASPARTNO,
                              IAPICONSTANT.INFOLEVEL_1 );
      END IF;

      SELECT PLANNED_EFFECTIVE_DATE
        INTO LDPED
        FROM SPECIFICATION_HEADER
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION;

      LNRETVAL :=
         ADDHEADER( ASPARTNO,
                    ANREVISION,
                    IAPICONSTANT.PLANT_DEVELOPMENT,
                    1,
                    1,
                    NULL,
                    100,
                    NULL,
                    NULL,
                    100,
                    'B',
                    NULL,
                    NULL,
                    NULL,
                    LDPED,
                    AQINFO,
                    AQERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
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
      LNRETVAL := POSTITEMCHANGED( ASPARTNO,
                                   ANREVISION,
                                   LSMETHOD,
                                   FALSE,
                                   AQERRORS );
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

      RETURN LNRETVAL;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDDEVHEADER;

   
   FUNCTION SAVEHEADER(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ANQUANTITY                 IN       IAPITYPE.BOMQUANTITY_TYPE,
      ANCONVERSIONFACTOR         IN       IAPITYPE.BOMCONVFACTOR_TYPE,
      ASCONVERTEDUOM             IN       IAPITYPE.DESCRIPTION_TYPE,
      ANYIELD                    IN       IAPITYPE.BOMYIELD_TYPE,
      ASCALCULATIONMODE          IN       IAPITYPE.BOMITEMCALCFLAG_TYPE,
      ASBOMTYPE                  IN       IAPITYPE.BOMITEMTYPE_TYPE,
      ANMINIMUMQUANTITY          IN       IAPITYPE.BOMQUANTITY_TYPE,
      ANMAXIMUMQUANTITY          IN       IAPITYPE.BOMQUANTITY_TYPE,
      ADPLANNEDEFFECTIVEDATE     IN       IAPITYPE.DATE_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS












      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveHeader';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRBOMHEADER                   IAPITYPE.BOMHEADERREC_TYPE;
      LDOLDPLANNEDEFFECTIVEDATE     IAPITYPE.DATE_TYPE;
      ASOLDCALCULATIONMODE          IAPITYPE.BOMITEMCALCFLAG_TYPE;
      ASNEWITEMCALCULATIONMODE      IAPITYPE.BOMITEMCALCFLAG_TYPE;
      LBITEMCHANGE                  BOOLEAN DEFAULT FALSE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LSSQLINFO                     IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
      
      
      
      
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
                              'Key: '
                           || ASPARTNO
                           || ' - '
                           || ANREVISION
                           || ' - '
                           || ASPLANT
                           || ' - '
                           || ANALTERNATIVE
                           || ' - '
                           || ANUSAGE );
      GTBOMHEADERS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LNRETVAL := CHECKEDITACCESS( ASPARTNO,
                                   ANREVISION );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         RETURN LNRETVAL;
      END IF;

      LRBOMHEADER.PARTNO := ASPARTNO;
      LRBOMHEADER.REVISION := ANREVISION;
      LRBOMHEADER.PLANT := ASPLANT;
      LRBOMHEADER.ALTERNATIVE := ANALTERNATIVE;
      LRBOMHEADER.BOMUSAGE := ANUSAGE;
      LRBOMHEADER.DESCRIPTION := ASDESCRIPTION;
      LRBOMHEADER.QUANTITY := ANQUANTITY;
      LRBOMHEADER.CONVERSIONFACTOR := ANCONVERSIONFACTOR;
      LRBOMHEADER.CONVERTEDUOM := ASCONVERTEDUOM;
      LRBOMHEADER.YIELD := ANYIELD;
      LRBOMHEADER.CALCULATIONMODE := ASCALCULATIONMODE;
      LRBOMHEADER.BOMITEMTYPE := ASBOMTYPE;
      LRBOMHEADER.MINIMUMQUANTITY := ANMINIMUMQUANTITY;
      LRBOMHEADER.MAXIMUMQUANTITY := ANMAXIMUMQUANTITY;
      LRBOMHEADER.PLANNEDEFFECTIVEDATE := ADPLANNEDEFFECTIVEDATE;
      GTBOMHEADERS( 0 ) := LRBOMHEADER;

      GTINFO( 0 ) := LRINFO;

      LNRETVAL := PREITEMCHANGED( ASPARTNO,
                                  ANREVISION,
                                  LSMETHOD,
                                  AQERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      
      LRINFO := GTINFO( 0 );
      
      
      LRBOMHEADER := GTBOMHEADERS( 0 );
      
      LRBOMHEADER.PARTNO := ASPARTNO;
      LRBOMHEADER.REVISION := ANREVISION;
      LRBOMHEADER.PLANT := ASPLANT;
      LRBOMHEADER.ALTERNATIVE := ANALTERNATIVE;
      LRBOMHEADER.BOMUSAGE := ANUSAGE;

      
      IF ( LRBOMHEADER.PLANNEDEFFECTIVEDATE IS NULL )
      THEN
         LNRETVAL :=
            IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                IAPICONSTANTCOLUMN.PLANNEDEFFECTIVEDATECOL );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( IAPICONSTANTCOLUMN.PLANNEDEFFECTIVEDATECOL,
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( LRBOMHEADER.QUANTITY IS NULL )
      THEN
         LNRETVAL :=
                  IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                      LSMETHOD,
                                                      IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                      IAPICONSTANTCOLUMN.BASEQUANTITYCOL );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( IAPICONSTANTCOLUMN.BASEQUANTITYCOL,
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

      LNRETVAL := CHECKBOMHEADER( LRBOMHEADER );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      BEGIN
         SELECT PLANT_EFFECTIVE_DATE,
                CALC_FLAG
           INTO LDOLDPLANNEDEFFECTIVEDATE,
                ASOLDCALCULATIONMODE
           FROM BOM_HEADER
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PLANT = ASPLANT
            AND ALTERNATIVE = ANALTERNATIVE
            AND BOM_USAGE = ANUSAGE;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_NOBOMHEADER,
                                                       ASPARTNO,
                                                       ANREVISION,
                                                       ASPLANT,
                                                       ANALTERNATIVE,
                                                       ANUSAGE );
      END;

      
      UPDATE BOM_HEADER
         SET BASE_QUANTITY = LRBOMHEADER.QUANTITY,
             DESCRIPTION = LRBOMHEADER.DESCRIPTION,
             YIELD = LRBOMHEADER.YIELD,
             CONV_FACTOR = LRBOMHEADER.CONVERSIONFACTOR,
             TO_UNIT = LRBOMHEADER.CONVERTEDUOM,
             CALC_FLAG = LRBOMHEADER.CALCULATIONMODE,
             BOM_TYPE = LRBOMHEADER.BOMITEMTYPE,
             MIN_QTY = LRBOMHEADER.MINIMUMQUANTITY,
             MAX_QTY = LRBOMHEADER.MAXIMUMQUANTITY,
             PLANT_EFFECTIVE_DATE = LRBOMHEADER.PLANNEDEFFECTIVEDATE
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANT
         AND ALTERNATIVE = ANALTERNATIVE
         AND BOM_USAGE = ANUSAGE;

      
      UPDATE BOM_HEADER
         SET PLANT_EFFECTIVE_DATE = LRBOMHEADER.PLANNEDEFFECTIVEDATE
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANT
         AND (    ALTERNATIVE <> ANALTERNATIVE
               OR BOM_USAGE <> ANUSAGE );

      FOR I IN ( SELECT ITEM_NUMBER,
                        CALC_FLAG
                  FROM BOM_ITEM
                 WHERE PART_NO = ASPARTNO
                   AND REVISION = ANREVISION
                   AND PLANT = ASPLANT
                   AND ALTERNATIVE = ANALTERNATIVE
                   AND BOM_USAGE = ANUSAGE )
      LOOP
         LBITEMCHANGE := FALSE;

         IF     ASOLDCALCULATIONMODE = 'B'
            AND LRBOMHEADER.CALCULATIONMODE = 'C'
         THEN
            CASE I.CALC_FLAG
               WHEN 'B'
               THEN
                  ASNEWITEMCALCULATIONMODE := 'C';
                  LBITEMCHANGE := TRUE;
               WHEN 'Q'
               THEN
                  ASNEWITEMCALCULATIONMODE := 'N';
                  LBITEMCHANGE := TRUE;
               ELSE
                  NULL;
            END CASE;
         ELSIF     ASOLDCALCULATIONMODE = 'B'
               AND LRBOMHEADER.CALCULATIONMODE = 'Q'
         THEN
            CASE I.CALC_FLAG
               WHEN 'B'
               THEN
                  ASNEWITEMCALCULATIONMODE := 'Q';
                  LBITEMCHANGE := TRUE;
               WHEN 'C'
               THEN
                  ASNEWITEMCALCULATIONMODE := 'N';
                  LBITEMCHANGE := TRUE;
               ELSE
                  NULL;
            END CASE;
         ELSIF(     (     ASOLDCALCULATIONMODE = 'B'
                      AND LRBOMHEADER.CALCULATIONMODE = 'N' )
                OR (     ASOLDCALCULATIONMODE = 'Q'
                     AND LRBOMHEADER.CALCULATIONMODE = 'N' )
                OR (     ASOLDCALCULATIONMODE = 'C'
                     AND LRBOMHEADER.CALCULATIONMODE = 'N' )
                OR (     ASOLDCALCULATIONMODE = 'Q'
                     AND LRBOMHEADER.CALCULATIONMODE = 'C' )
                OR (     ASOLDCALCULATIONMODE = 'C'
                     AND LRBOMHEADER.CALCULATIONMODE = 'Q' ) )
         THEN
            ASNEWITEMCALCULATIONMODE := 'N';
            LBITEMCHANGE := TRUE;
         END IF;

         IF LBITEMCHANGE
         THEN
            UPDATE BOM_ITEM
               SET CALC_FLAG = ASNEWITEMCALCULATIONMODE
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND PLANT = ASPLANT
               AND ALTERNATIVE = ANALTERNATIVE
               AND BOM_USAGE = ANUSAGE
               AND ITEM_NUMBER = I.ITEM_NUMBER;
         END IF;
      END LOOP;

      IF LDOLDPLANNEDEFFECTIVEDATE <> LRBOMHEADER.PLANNEDEFFECTIVEDATE
      THEN
         LNRETVAL := SETEXPORTTOERP( ASPARTNO,
                                     ANREVISION );

         IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
         THEN
            RETURN LNRETVAL;
         END IF;

         INSERT INTO JRNL_SPECIFICATION_HEADER
                     ( PART_NO,
                       REVISION,
                       USER_ID,
                       TIMESTAMP,
                       OLD_PLANNED_EFFECTIVE_DATE,
                       NEW_PLANNED_EFFECTIVE_DATE,
                       FORENAME,
                       LAST_NAME,
                       PLANT )
              VALUES ( ASPARTNO,
                       ANREVISION,
                       IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                       SYSDATE,
                       LDOLDPLANNEDEFFECTIVEDATE,
                       LRBOMHEADER.PLANNEDEFFECTIVEDATE,
                       IAPIGENERAL.SESSION.APPLICATIONUSER.FORENAME,
                       IAPIGENERAL.SESSION.APPLICATIONUSER.LASTNAME,
                       ASPLANT );
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

      LNRETVAL := POSTITEMCHANGED( ASPARTNO,
                                   ANREVISION,
                                   LSMETHOD,
                                   TRUE,
                                   AQERRORS );
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


      RETURN LNRETVAL;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEHEADER;

   
   FUNCTION SAVEPLANNEDEFFECTIVEDATE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ADPLANNEDEFFECTIVEDATE     IN       IAPITYPE.DATE_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SavePlannedEffectiveDate';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRBOMHEADER                   IAPITYPE.BOMHEADERREC_TYPE;
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
      GTBOMHEADERS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LNRETVAL := CHECKEDITACCESS( ASPARTNO,
                                   ANREVISION );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         RETURN LNRETVAL;
      END IF;

      LRBOMHEADER.PARTNO := ASPARTNO;
      LRBOMHEADER.REVISION := ANREVISION;
      LRBOMHEADER.PLANT := ASPLANT;
      LRBOMHEADER.PLANNEDEFFECTIVEDATE := ADPLANNEDEFFECTIVEDATE;
      GTBOMHEADERS( 0 ) := LRBOMHEADER;

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
      
      
      LRBOMHEADER := GTBOMHEADERS( 0 );
      
      LRBOMHEADER.PARTNO := ASPARTNO;
      LRBOMHEADER.REVISION := ANREVISION;
      LRBOMHEADER.PLANT := ASPLANT;

      
      IF ( LRBOMHEADER.PLANNEDEFFECTIVEDATE IS NULL )
      THEN
         LNRETVAL :=
            IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                IAPICONSTANTCOLUMN.PLANNEDEFFECTIVEDATECOL );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( IAPICONSTANTCOLUMN.PLANNEDEFFECTIVEDATECOL,
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

      LNRETVAL := CHECKBOMHEADER( LRBOMHEADER );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      
      UPDATE BOM_HEADER
         SET PLANT_EFFECTIVE_DATE = LRBOMHEADER.PLANNEDEFFECTIVEDATE
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANT;

      
      
      
      
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


      RETURN LNRETVAL;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEPLANNEDEFFECTIVEDATE;

   
   FUNCTION COPYBOM(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASFROMPLANT                IN       IAPITYPE.PLANT_TYPE,
      ANFROMALTERNATIVE          IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANFROMUSAGE                IN       IAPITYPE.BOMUSAGE_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ANQUANTITY                 IN       IAPITYPE.BOMQUANTITY_TYPE,
      ANMINIMUMQUANTITY          IN       IAPITYPE.BOMQUANTITY_TYPE,
      ANMAXIMUMQUANTITY          IN       IAPITYPE.BOMQUANTITY_TYPE,
      ANCOPY                     IN       IAPITYPE.BOOLEAN_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS





















      CURSOR CUR_BOM_ITEM
      IS
         SELECT   PART_NO,
                  REVISION,
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
                  CALC_FLAG,
                  FIXED_QTY,
                  BOOLEAN_1,
                  BOOLEAN_2,
                  BOOLEAN_3,
                  BOOLEAN_4,
                  MAKE_UP,
                  INTL_EQUIVALENT,
                  COMPONENT_SCRAP_SYNC
             FROM BOM_ITEM
            WHERE PART_NO = ASPARTNO
              AND REVISION = ANREVISION
              AND PLANT = ASFROMPLANT
              AND ALTERNATIVE = ANFROMALTERNATIVE
              AND BOM_USAGE = ANFROMUSAGE
         ORDER BY ALT_GROUP,
                  ALT_PRIORITY;

      LSPLANT                       IAPITYPE.PLANT_TYPE;
      LNQUANTITY                    IAPITYPE.BOMQUANTITY_TYPE;
      LNCONVERSION                  NUMBER := 1;
      LSCOMPONENT                   IAPITYPE.PARTNO_TYPE;
      LSCOMPONENT2                  IAPITYPE.PARTNO_TYPE;
      LSINTLEQUIVALENT              IAPITYPE.PARTNO_TYPE;
      LSINTL                        SPECIFICATION_SECTION.INTL%TYPE;
      LSINTL2                       SPECIFICATION_HEADER.INTL%TYPE;
      LSPARTNOINTL                  SPECIFICATION_HEADER.INTL%TYPE;
      LSPLANTCHECK                  IAPITYPE.PLANT_TYPE;
      LSUOM                         IAPITYPE.DESCRIPTION_TYPE;
      LNHARMONIZED                  PLS_INTEGER;
      LSBASEUOM                     IAPITYPE.DESCRIPTION_TYPE;
      LSCALCFLAG                    IAPITYPE.BOMITEMCALCFLAG_TYPE;
      LBAUTOCALCHEADER              BOOLEAN := TRUE;
      LNCOUNT                       PLS_INTEGER;
      LNSTACKCOUNT                  PLS_INTEGER;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CopyBom';
      LSCOMPTABLE                   IAPITYPE.PARTNOTAB_TYPE;
      LTMESSAGE                     ERRORDATATABLE_TYPE := ERRORDATATABLE_TYPE( );
      LRMESSAGE                     ERRORRECORD_TYPE := ERRORRECORD_TYPE( NULL,
                                                                          NULL,
                                                                          NULL );
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      
      
      LNORGINALCONVFACTOR           IAPITYPE.BOMCONVFACTOR_TYPE;
      LSORIGINALTOUNIT              IAPITYPE.DESCRIPTION_TYPE;
      LNORIGINALYIELD               IAPITYPE.BOMYIELD_TYPE;
      LSORIGINALCALCMODE            IAPITYPE.BOMITEMCALCFLAG_TYPE;
      LSORIGINALBOMTYPE             IAPITYPE.BOMITEMTYPE_TYPE;
      LDORIGINALPED                 IAPITYPE.DATE_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNIGNOREPARTPLANTRELATION     IAPITYPE.BOOLEAN_TYPE;
      LBWARNING                     BOOLEAN := FALSE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LSSQLINFO                     IAPITYPE.SQLSTRING_TYPE;
      LNCALCQUANTITY                IAPITYPE.BOMQUANTITY_TYPE := 0;
      LNCALCCONVFACTOR              IAPITYPE.BOMCONVFACTOR_TYPE := 0;
      LRINFO1                       IAPITYPE.INFOREC_TYPE;
      LTINFO                        IAPITYPE.INFOTAB_TYPE;
      
      LSPLANTTOUSE             IAPITYPE.PLANT_TYPE;
  
      LNEXIST                       IAPITYPE.NUMVAL_TYPE;

   BEGIN
      
      
      
      
      
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




      GTBOMITEMS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      GTINFO( 0 ) := LRINFO;



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := CHECKEDITACCESS( ASPARTNO,
                                   ANREVISION );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         RETURN LNRETVAL;
      END IF;

      LNSTACKCOUNT := 0;
      
      LTMESSAGE.DELETE;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'From:'
                           || ASPARTNO
                           || '['
                           || ANREVISION
                           || '] Plant <'
                           || ASFROMPLANT
                           || '> Alt <'
                           || ANFROMALTERNATIVE
                           || '> Usage <'
                           || ANFROMUSAGE
                           || '> To: '
                           || 'Plant <'
                           || ASPLANT
                           || '> Alt <'
                           || ANALTERNATIVE
                           || '> Usage <'
                           || ANUSAGE
                           || '>',
                           IAPICONSTANT.INFOLEVEL_2 );

      
      IF ANCOPY = 1
      THEN
         LNRETVAL := PREITEMCHANGED( ASPARTNO,
                                     ANREVISION,
                                     LSMETHOD,
                                     
                                     
                                     AQERRORS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( LNRETVAL );
         END IF;

         
         LRINFO := GTINFO( 0 );

         BEGIN
            SELECT CONV_FACTOR,
                   TO_UNIT,
                   YIELD,
                   CALC_FLAG,
                   BOM_TYPE,
                   PLANT_EFFECTIVE_DATE
              INTO LNORGINALCONVFACTOR,
                   LSORIGINALTOUNIT,
                   LNORIGINALYIELD,
                   LSORIGINALCALCMODE,
                   LSORIGINALBOMTYPE,
                   LDORIGINALPED
              FROM BOM_HEADER
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND PLANT = ASFROMPLANT
               AND ALTERNATIVE = ANFROMALTERNATIVE
               AND BOM_USAGE = ANFROMUSAGE;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               
               RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                          LSMETHOD,
                                                          IAPICONSTANTDBERROR.DBERR_NOBOMHEADER,
                                                          ASPARTNO,
                                                          ANREVISION,
                                                          ASPLANT,
                                                          ANALTERNATIVE,
                                                          ANUSAGE );
         END;

         
         
         

         LNRETVAL :=
            ADDHEADER( ASPARTNO,
                       ANREVISION,
                       ASPLANT,
                       ANALTERNATIVE,
                       ANUSAGE,
                       ASDESCRIPTION,
                       ANQUANTITY,
                       LNORGINALCONVFACTOR,
                       LSORIGINALTOUNIT,
                       LNORIGINALYIELD,
                       LSORIGINALCALCMODE,
                       LSORIGINALBOMTYPE,
                       ANMINIMUMQUANTITY,
                       ANMAXIMUMQUANTITY,
                       LDORIGINALPED,
                       AQINFO,
                       
                       
                       AQERRORS );

         
         
         

         
         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( LNRETVAL );
         END IF;

      BEGIN
       SELECT COUNT(1) INTO LNEXIST FROM SYS.USER_TABLES  WHERE TABLE_NAME = 'RNDTBOMHEADER';
       IF LNEXIST > 0 THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Execute <'
                              || 'f_copybom_rndtbomheader'
                              || '>',
                              IAPICONSTANT.INFOLEVEL_3 );
        LNRETVAL := F_COPYBOM_RNDTBOMHEADER( ASPARTNO, ANREVISION, ASFROMPLANT, ANFROMALTERNATIVE,
                    ANFROMUSAGE, ASPLANT, ANALTERNATIVE, ANUSAGE );
    END IF;
   END;
    

         
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

         BEGIN
            SELECT BASE_QUANTITY
              INTO LNQUANTITY
              FROM BOM_HEADER
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND PLANT = ASFROMPLANT
               AND ALTERNATIVE = ANFROMALTERNATIVE
               AND BOM_USAGE = ANFROMUSAGE;
         EXCEPTION
            WHEN OTHERS
            THEN
               LNQUANTITY := 1;
         END;

         IF LNQUANTITY > 0
         THEN
            LNCONVERSION :=   ANQUANTITY
                            / LNQUANTITY;
         END IF;
      ELSE   
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
      END IF;

      SELECT INTL
        INTO LSINTL2
        FROM SPECIFICATION_SECTION
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND TYPE = IAPICONSTANT.SECTIONTYPE_BOM;

      BEGIN
         SELECT INTL
           INTO LSINTL
           FROM SPECIFICATION_SECTION
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND TYPE = IAPICONSTANT.SECTIONTYPE_BOM;

         LNRETVAL := IAPISPECIFICATION.ISLOCALIZED( ASPARTNO,
                                                    ANREVISION,
                                                    LNHARMONIZED );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN LNRETVAL;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            LNHARMONIZED := 0;
      END;

      
      IF     LNHARMONIZED = 1
         AND LSINTL = 2
         AND ASFROMPLANT = IAPICONSTANT.PLANT_INTERNATIONAL
      THEN
         LNIGNOREPARTPLANTRELATION := 1;
      ELSE
         LNIGNOREPARTPLANTRELATION := 0;
      END IF;

      SELECT BASE_UOM
        INTO LSBASEUOM
        FROM PART
       WHERE PART_NO = ASPARTNO;

      
      FOR REC_ITEM IN CUR_BOM_ITEM
      LOOP
         LSCALCFLAG := REC_ITEM.CALC_FLAG;
         LSUOM := REC_ITEM.UOM;
         

         LSCOMPONENT := REC_ITEM.COMPONENT_PART;

         IF     LSINTL = 2
            AND LNHARMONIZED = 1
         THEN
            
            
            
            
            
            
            
            LSCOMPONENT2 := NULL;

            BEGIN
               SELECT DISTINCT SH.PART_NO
                          INTO LSCOMPONENT2
                          FROM PART_PLANT PP,
                               SPECIFICATION_HEADER SH
                         WHERE SH.PART_NO = PP.PART_NO
                           AND SH.INT_PART_NO = REC_ITEM.COMPONENT_PART
                           AND PP.PLANT = ASPLANT;

               LBWARNING := FALSE;
            EXCEPTION
               WHEN OTHERS
               THEN
                  
                  LNSTACKCOUNT :=   LNSTACKCOUNT
                                  + 1;
                  LNRETVAL :=
                     IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_NOORMORELOCVERSIONSFOUND,
                                                         REC_ITEM.COMPONENT_PART );
                  LRMESSAGE.MESSAGETYPE := IAPICONSTANT.ERRORMESSAGE_WARNING;
                  LRMESSAGE.PARAMETERID := IAPICONSTANTDBERROR.DBERR_NOORMORELOCVERSIONSFOUND;
                  LRMESSAGE.ERRORTEXT := IAPIGENERAL.GETLASTERRORTEXT( );
                  LTMESSAGE.EXTEND;
                  LTMESSAGE( LNSTACKCOUNT ) := LRMESSAGE;
                  LBWARNING := TRUE;
                  LSCOMPONENT2 := NULL;
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                       LRMESSAGE.ERRORTEXT,
                                       IAPICONSTANT.INFOLEVEL_2 );
            END;

            IF LSCOMPONENT2 IS NULL
            THEN
               
               
               BEGIN
                  SELECT PLANT
                    INTO LSPLANTCHECK
                    FROM PART_PLANT
                   WHERE PART_NO = REC_ITEM.COMPONENT_PART
                     AND PLANT = ASPLANT
                     AND OBSOLETE = 0;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     
                     
                     
                     
                     
                     IF NOT LBWARNING
                     THEN
                        LNSTACKCOUNT :=   LNSTACKCOUNT
                                        + 1;
                        LNRETVAL :=
                           IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                               LSMETHOD,
                                                               IAPICONSTANTDBERROR.DBERR_NOPARTPLANTFORHARBOMITEM,
                                                               REC_ITEM.COMPONENT_PART );
                        LRMESSAGE.MESSAGETYPE := IAPICONSTANT.ERRORMESSAGE_WARNING;
                        LRMESSAGE.PARAMETERID := IAPICONSTANTDBERROR.DBERR_NOPARTPLANTFORHARBOMITEM;
                        LRMESSAGE.ERRORTEXT := IAPIGENERAL.GETLASTERRORTEXT( );
                        LTMESSAGE.EXTEND;
                        LTMESSAGE( LNSTACKCOUNT ) := LRMESSAGE;
                        IAPIGENERAL.LOGINFO( GSSOURCE,
                                             LSMETHOD,
                                             LRMESSAGE.ERRORTEXT,
                                             IAPICONSTANT.INFOLEVEL_2 );
                     END IF;
               
               END;

               LSCOMPONENT := REC_ITEM.COMPONENT_PART;
            ELSE
               LSCOMPONENT := LSCOMPONENT2;
            END IF;

            


            SELECT BASE_UOM
              INTO LSUOM
              FROM PART
             WHERE PART_NO = LSCOMPONENT;

            IF LSCALCFLAG <> 'N'
            THEN
               IF    REC_ITEM.UOM <> LSUOM
                  OR LSUOM <> LSBASEUOM
               THEN
                  LSCALCFLAG := 'N';
                  
                  LBAUTOCALCHEADER := FALSE;
               END IF;
            END IF;
         END IF;

         LSPLANT := NULL;

         
         
         
         
         
         
         SELECT MAX( INTL )
           INTO LSPARTNOINTL
           FROM SPECIFICATION_HEADER
          WHERE PART_NO = REC_ITEM.COMPONENT_PART;

         IF    ASPLANT = IAPICONSTANT.PLANT_DEVELOPMENT
            OR (     LNHARMONIZED = 1
                 AND LSPARTNOINTL = '1' )
         THEN
            LSPLANT := ASPLANT;
         ELSE
            
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM PART
             WHERE PART_NO = REC_ITEM.COMPONENT_PART
               AND OBSOLETE = 1;

            IF LNCOUNT > 0
            THEN
               LNSTACKCOUNT :=   LNSTACKCOUNT
                               + 1;
               LSPLANT := NULL;
               LNRETVAL :=
                          IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_OBSOLETEBOMITEM,
                                                              REC_ITEM.COMPONENT_PART );
               LRMESSAGE.MESSAGETYPE := IAPICONSTANT.ERRORMESSAGE_WARNING;
               LRMESSAGE.PARAMETERID := IAPICONSTANTDBERROR.DBERR_OBSOLETEBOMITEM;
               LRMESSAGE.ERRORTEXT := IAPIGENERAL.GETLASTERRORTEXT( );
               LTMESSAGE.EXTEND;
               LTMESSAGE( LNSTACKCOUNT ) := LRMESSAGE;
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    LRMESSAGE.ERRORTEXT,
                                    IAPICONSTANT.INFOLEVEL_2 );
            ELSE
               BEGIN
                  SELECT PLANT
                    INTO LSPLANT
                    FROM PART_PLANT
                   WHERE PART_NO = REC_ITEM.COMPONENT_PART
                     AND PLANT = ASPLANT
                     AND OBSOLETE = 0;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     LNSTACKCOUNT :=   LNSTACKCOUNT
                                     + 1;
                     LSPLANT := NULL;
                     LNRETVAL :=
                        IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_NOPARTPLANTFORBOMITEM,
                                                            REC_ITEM.COMPONENT_PART );
                     LRMESSAGE.MESSAGETYPE := IAPICONSTANT.ERRORMESSAGE_WARNING;
                     LRMESSAGE.PARAMETERID := IAPICONSTANTDBERROR.DBERR_NOPARTPLANTFORBOMITEM;
                     LRMESSAGE.ERRORTEXT := IAPIGENERAL.GETLASTERRORTEXT( );
                     LTMESSAGE.EXTEND;
                     LTMESSAGE( LNSTACKCOUNT ) := LRMESSAGE;
                     IAPIGENERAL.LOGINFO( GSSOURCE,
                                          LSMETHOD,
                                          LRMESSAGE.ERRORTEXT,
                                          IAPICONSTANT.INFOLEVEL_2 );
               END;
            END IF;
         END IF;

         
         IF LSINTL2 = '1'
         THEN
            LSINTLEQUIVALENT := REC_ITEM.INTL_EQUIVALENT;
         ELSE
            
            
            IF LNHARMONIZED = 1
            THEN
               LSINTLEQUIVALENT := REC_ITEM.INTL_EQUIVALENT;
            ELSE
               LSINTLEQUIVALENT := NULL;
            END IF;
         END IF;

         IF     LSPLANT IS NOT NULL
            AND ANCOPY = 1
         THEN
            
            
            

            
            LSPLANTTOUSE := LSPLANT;

            
            
						
            IF ((ASPLANT = ASFROMPLANT) OR (ANALTERNATIVE <> ANFROMALTERNATIVE))
            THEN
                LSPLANTTOUSE := REC_ITEM.COMPONENT_PLANT;
            END IF;
            

            LNRETVAL :=
               ADDITEM( ASPARTNO,
                        ANREVISION,
                        ASPLANT,
                        ANALTERNATIVE,
                        ANUSAGE,
                        REC_ITEM.ITEM_NUMBER,
                        REC_ITEM.ALT_GROUP,
                        REC_ITEM.ALT_PRIORITY,
                        LSCOMPONENT,
                        REC_ITEM.COMPONENT_REVISION,
                        
                        
                        
                        
                        LSPLANTTOUSE,
                        
                        
                          LNCONVERSION
                        * REC_ITEM.QUANTITY,
                        LSUOM,
                        REC_ITEM.CONV_FACTOR,
                        REC_ITEM.TO_UNIT,
                        REC_ITEM.YIELD,
                        REC_ITEM.ASSEMBLY_SCRAP,
                        REC_ITEM.COMPONENT_SCRAP,
                        REC_ITEM.LEAD_TIME_OFFSET,
                        REC_ITEM.RELEVENCY_TO_COSTING,
                        REC_ITEM.BULK_MATERIAL,
                        REC_ITEM.ITEM_CATEGORY,
                        REC_ITEM.ISSUE_LOCATION,
                        LSCALCFLAG,
                        REC_ITEM.BOM_ITEM_TYPE,
                        REC_ITEM.OPERATIONAL_STEP,
                        
                        
                        
                        LNCONVERSION * REC_ITEM.MIN_QTY,
                        LNCONVERSION * REC_ITEM.MAX_QTY,
                        
                        REC_ITEM.FIXED_QTY,
                        REC_ITEM.CODE,
                        REC_ITEM.CHAR_1,
                        REC_ITEM.CHAR_2,
                        REC_ITEM.CHAR_3,
                        REC_ITEM.CHAR_4,
                        REC_ITEM.CHAR_5,
                        REC_ITEM.NUM_1,
                        REC_ITEM.NUM_2,
                        REC_ITEM.NUM_3,
                        REC_ITEM.NUM_4,
                        REC_ITEM.NUM_5,
                        REC_ITEM.BOOLEAN_1,
                        REC_ITEM.BOOLEAN_2,
                        REC_ITEM.BOOLEAN_3,
                        REC_ITEM.BOOLEAN_4,
                        REC_ITEM.DATE_1,
                        REC_ITEM.DATE_2,
                        REC_ITEM.CH_1,
                        REC_ITEM.CH_2,
                        REC_ITEM.CH_3,
                        REC_ITEM.MAKE_UP,
                        LSINTLEQUIVALENT,
                        LNIGNOREPARTPLANTRELATION,
                        REC_ITEM.COMPONENT_SCRAP_SYNC,
                        AQINFO,
                        
                        
                        AQERRORS );

            
            
            

            
            IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               RETURN LNRETVAL;
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
      END LOOP;

      IF     NOT LBAUTOCALCHEADER
         AND ANCOPY = 1
      THEN
         
         UPDATE BOM_HEADER
            SET CALC_FLAG = 'N'
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PLANT = ASPLANT
            AND ALTERNATIVE = ANALTERNATIVE
            AND BOM_USAGE = ANUSAGE;

         UPDATE BOM_ITEM
            SET CALC_FLAG = 'N'
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PLANT = ASPLANT
            AND ALTERNATIVE = ANALTERNATIVE
            AND BOM_USAGE = ANUSAGE;
      END IF;

      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( LTMESSAGE,
                                                             AQERRORS );
      APPLYAUTOCALC( ASPARTNO,
                     ANREVISION,
                     ASPLANT,
                     ANUSAGE,
                     ANALTERNATIVE,
                     LNCALCQUANTITY,
                     LNCALCCONVFACTOR );

      IF ANCOPY = 1
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

         LNRETVAL := POSTITEMCHANGED( ASPARTNO,
                                      ANREVISION,
                                      LSMETHOD,
                                      FALSE,
                                      
                                      
                                      AQERRORS );
         LRINFO := GTINFO( 0 );

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


         RETURN LNRETVAL;
      END IF;

      IF LNSTACKCOUNT > 0
      THEN
         RETURN IAPICONSTANTDBERROR.DBERR_ERRORLIST;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END COPYBOM;


   FUNCTION SETPREFERREDHEADER(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      









      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SetPreferredHeader';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       PLS_INTEGER;
      LNHARMONIZED                  PLS_INTEGER;
   BEGIN
   


      GTBOMITEMS.DELETE;
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Key: '
                           || ASPARTNO
                           || ' - '
                           || ANREVISION
                           || ' - '
                           || ASPLANT
                           || ' - '
                           || ANALTERNATIVE
                           || ' - '
                           || ANUSAGE );
      LNRETVAL := CHECKEDITACCESS( ASPARTNO,
                                   ANREVISION );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         RETURN LNRETVAL;
      END IF;

      LNRETVAL := PREITEMCHANGED( ASPARTNO,
                                  ANREVISION,
                                  LSMETHOD,
                                  AQERRORS );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM BOM_HEADER
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANT
         AND ALTERNATIVE = ANALTERNATIVE
         AND BOM_USAGE = ANUSAGE;

      
      IF LNCOUNT <> 1
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOBOMHEADER,
                                                    ASPARTNO,
                                                    ANREVISION,
                                                    ASPLANT,
                                                    ANALTERNATIVE,
                                                    ANUSAGE );
      END IF;

      LNRETVAL := IAPISPECIFICATION.ISLOCALIZED( ASPARTNO,
                                                 ANREVISION,
                                                 LNHARMONIZED );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN LNRETVAL;
      END IF;

      
      IF     LNHARMONIZED = 1
         AND ASPLANT = IAPICONSTANT.PLANT_INTERNATIONAL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_HARMINTLBOM,
                                                    ASPARTNO,
                                                    ANREVISION );
      END IF;

      UPDATE BOM_HEADER
         SET PREFERRED = 0
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANT
         AND BOM_USAGE = ANUSAGE;

      UPDATE BOM_HEADER
         SET PREFERRED = 1
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANT
         AND ALTERNATIVE = ANALTERNATIVE
         AND BOM_USAGE = ANUSAGE;

      LNRETVAL := POSTITEMCHANGED( ASPARTNO,
                                   ANREVISION,
                                   LSMETHOD,
                                   TRUE,
                                   AQERRORS );
      RETURN LNRETVAL;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SETPREFERREDHEADER;

   
   FUNCTION CHANGEHEADER(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE,
      ASNEWPLANT                 IN       IAPITYPE.PLANT_TYPE,
      ANNEWALTERNATIVE           IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANNEWUSAGE                 IN       IAPITYPE.BOMUSAGE_TYPE,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS














      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ChangeHeader';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       PLS_INTEGER;
      LNHARMONIZED                  PLS_INTEGER;
      LRBOMHEADER                   IAPITYPE.BOMHEADERREC_TYPE;
      LNMINALTERNATIVE              IAPITYPE.BOMALTERNATIVE_TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LSSQLINFO                     IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
      
      
      
      
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




      GTBOMHEADERS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LNRETVAL := CHECKEDITACCESS( ASPARTNO,
                                   ANREVISION );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         RETURN LNRETVAL;
      END IF;

      LRBOMHEADER.PARTNO := ASPARTNO;
      LRBOMHEADER.REVISION := ANREVISION;
      LRBOMHEADER.PLANT := ASNEWPLANT;
      LRBOMHEADER.ALTERNATIVE := ANNEWALTERNATIVE;
      LRBOMHEADER.BOMUSAGE := ANNEWUSAGE;
      GTBOMHEADERS( 0 ) := LRBOMHEADER;

      GTINFO( 0 ) := LRINFO;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Key: '
                           || ASPARTNO
                           || ' - '
                           || ANREVISION
                           || ' - '
                           || ASPLANT
                           || ' - '
                           || ANALTERNATIVE
                           || ' - '
                           || ANUSAGE
                           || ' changing to: '
                           || ASNEWPLANT
                           || ' - '
                           || ANNEWALTERNATIVE
                           || ' - '
                           || ANNEWUSAGE );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := PREITEMCHANGED( ASPARTNO,
                                  ANREVISION,
                                  LSMETHOD,
                                  AQERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      
      LRINFO := GTINFO( 0 );

      BEGIN
         SELECT PLANT_EFFECTIVE_DATE,
                BASE_QUANTITY,
                MIN_QTY,
                MAX_QTY
           INTO LRBOMHEADER.PLANNEDEFFECTIVEDATE,
                LRBOMHEADER.QUANTITY,
                LRBOMHEADER.MINIMUMQUANTITY,
                LRBOMHEADER.MAXIMUMQUANTITY
           FROM BOM_HEADER
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PLANT = ASPLANT
            AND ALTERNATIVE = ANALTERNATIVE
            AND BOM_USAGE = ANUSAGE;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_NOBOMHEADER,
                                                       ASPARTNO,
                                                       ANREVISION,
                                                       ASPLANT,
                                                       ANALTERNATIVE,
                                                       ANUSAGE );
      END;

      LNRETVAL := CHECKBOMHEADER( LRBOMHEADER );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( LNRETVAL );
      END IF;

      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM BOM_ITEM
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANT
         AND ALTERNATIVE = ANALTERNATIVE
         AND BOM_USAGE = ANUSAGE;

      IF LNCOUNT > 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_BOMITEMSEXIST );
      END IF;

      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM BOM_HEADER
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASNEWPLANT
         AND ALTERNATIVE = ANNEWALTERNATIVE
         AND BOM_USAGE = ANNEWUSAGE;

      IF LNCOUNT > 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_DUPVALONINDEX );
      END IF;

      LNRETVAL := IAPISPECIFICATION.ISLOCALIZED( ASPARTNO,
                                                 ANREVISION,
                                                 LNHARMONIZED );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN LNRETVAL;
      END IF;

      
      IF     LNHARMONIZED = 1
         AND ASPLANT = IAPICONSTANT.PLANT_INTERNATIONAL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_HARMINTLBOM,
                                                    LRBOMHEADER.PARTNO,
                                                    LRBOMHEADER.REVISION );
      END IF;

      UPDATE BOM_HEADER
         SET PLANT = ASNEWPLANT,
             ALTERNATIVE = ANNEWALTERNATIVE,
             BOM_USAGE = ANNEWUSAGE
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION
         AND PLANT = ASPLANT
         AND ALTERNATIVE = ANALTERNATIVE
         AND BOM_USAGE = ANUSAGE;

      
      IF    ASPLANT <> ASNEWPLANT
         OR ANUSAGE <> ANNEWUSAGE
      THEN
         
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM BOM_HEADER
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PLANT = ASPLANT
            AND BOM_USAGE = ANUSAGE
            AND PREFERRED = 1;

         IF LNCOUNT = 0
         THEN
            SELECT MIN( ALTERNATIVE )
              INTO LNMINALTERNATIVE
              FROM BOM_HEADER
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND PLANT = ASPLANT;

            UPDATE BOM_HEADER
               SET PREFERRED = 1
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND PLANT = ASPLANT
               AND ALTERNATIVE = LNMINALTERNATIVE
               AND BOM_USAGE = ANUSAGE;
         END IF;

         
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM BOM_HEADER
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PLANT = ASNEWPLANT
            AND BOM_USAGE = ANNEWUSAGE
            AND PREFERRED = 1;

         IF LNCOUNT = 0
         THEN
            UPDATE BOM_HEADER
               SET PREFERRED = 1
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND PLANT = ASNEWPLANT
               AND ALTERNATIVE = ANNEWALTERNATIVE
               AND BOM_USAGE = ANNEWUSAGE;
         ELSIF LNCOUNT > 1
         THEN
            UPDATE BOM_HEADER
               SET PREFERRED = 0
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND PLANT = ASNEWPLANT
               AND ALTERNATIVE = ANNEWALTERNATIVE
               AND BOM_USAGE = ANNEWUSAGE;
         END IF;
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
      LNRETVAL := POSTITEMCHANGED( ASPARTNO,
                                   ANREVISION,
                                   LSMETHOD,
                                   TRUE,
                                   AQERRORS );
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


      RETURN LNRETVAL;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CHANGEHEADER;


   FUNCTION GETBOMPATHS(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      AQPATHS                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetBomPaths';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 1024 );
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=
            'SELECT SEQ_NO '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ', PARENT_PART_NO '
         || IAPICONSTANTCOLUMN.PARENTPARTNOCOL
         || ', PARENT_REVISION '
         || IAPICONSTANTCOLUMN.PARENTREVISIONCOL
         || ', F_SH_DESCR( 1, PARENT_PART_NO, PARENT_REVISION) '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ', PART_NO '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', REVISION  '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', PLANT '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', ALTERNATIVE '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', BOM_USAGE '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', ALT_GROUP '
         || IAPICONSTANTCOLUMN.BOMALTGROUPCOL
         || ', ALT_PRIORITY '
         || IAPICONSTANTCOLUMN.BOMALTPRIORITYCOL
         || ', BOM_LEVEL '
         || IAPICONSTANTCOLUMN.BOMLEVELCOL
         || ' FROM ITBOMPATH '
         || ' WHERE BOM_EXP_NO = :anExpNo'
         || ' ORDER BY SEQ_NO';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      
      IF ( AQPATHS%ISOPEN )
      THEN
         CLOSE AQPATHS;
      END IF;

      OPEN AQPATHS FOR LSSQL USING ANUNIQUEID;

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         
         IF ( AQPATHS%ISOPEN )
         THEN
            CLOSE AQPATHS;
         END IF;

         OPEN AQPATHS FOR LSSQL USING -1;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETBOMPATHS;

   
   FUNCTION GETBOMPATHITEMS(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE,
      ANINCLUDEINDEVELOPMENT     IN       IAPITYPE.BOOLEAN_TYPE,
      ADEXPLOSIONDATE            IN       IAPITYPE.DATE_TYPE,
      AQBOMPATH                  OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetBomPathItems';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSSQL                         VARCHAR2( 8192 );
      LDDATE                        IAPITYPE.DATE_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=
            'SELECT DISTINCT BOM_ITEM.PART_NO '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', BOM_ITEM.REVISION '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', COMPONENT_PART '
         || IAPICONSTANTCOLUMN.COMPONENTPARTNOCOL
         || ', iapiSpecificationBom.GetComponentRevision(COMPONENT_PART, COMPONENT_REVISION, COMPONENT_PLANT, :adExplosionDate, :anIncludeInDevelopment) '
         || IAPICONSTANTCOLUMN.COMPONENTREVISIONCOL
         || ', F_SH_DESCR(1, COMPONENT_PART, COMPONENT_REVISION)  '
         || IAPICONSTANTCOLUMN.COMPONENTDESCRIPTIONCOL
         || ', BOM_ITEM.PLANT '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', BOM_ITEM.ALTERNATIVE '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', BOM_ITEM.BOM_USAGE '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', ITBU.DESCR '
         || IAPICONSTANTCOLUMN.BOMUSAGEDESCRIPTIONCOL
         || ', BOM_HEADER.DESCRIPTION '
         || IAPICONSTANTCOLUMN.BOMHEADERDESCRIPTIONCOL
         || ', NVL(BOM_HEADER.PREFERRED, 0) '
         || IAPICONSTANTCOLUMN.PREFERREDCOL
         || ', BOM_ITEM.ALT_GROUP '
         || IAPICONSTANTCOLUMN.BOMALTGROUPCOL
         || ', BOM_ITEM.ALT_PRIORITY '
         || IAPICONSTANTCOLUMN.BOMALTPRIORITYCOL
         || ' FROM BOM_ITEM, BOM_HEADER, ITBU, CLASS3, SPECIFICATION_HEADER'
         || ' WHERE BOM_ITEM.PART_NO = :asPartNo'
         || ' AND BOM_ITEM.REVISION = :anRevision'
         || ' AND SPECIFICATION_HEADER.PART_NO = BOM_ITEM.COMPONENT_PART'
         || ' AND SPECIFICATION_HEADER.Revision = iapiSpecificationBom.GetComponentRevision(COMPONENT_PART, COMPONENT_REVISION, COMPONENT_PLANT, :adExplosionDate, :anIncludeInDevelopment)'
         || ' AND BOM_ITEM.PLANT = :asPlant'
         || ' AND BOM_ITEM.ALTERNATIVE = :anAlternative'
         || ' AND BOM_ITEM.BOM_USAGE = :anUsage'
         || ' AND ITBU.BOM_USAGE(+) = BOM_HEADER.BOM_USAGE'
         || ' AND BOM_HEADER.PART_NO(+) = BOM_ITEM.COMPONENT_PART'
         || ' AND BOM_HEADER.REVISION(+) = iapiSpecificationBom.GetComponentRevision(COMPONENT_PART, COMPONENT_REVISION, COMPONENT_PLANT, :adExplosionDate, :anIncludeInDevelopment)'
         || ' AND BOM_HEADER.PLANT(+) = BOM_ITEM.PLANT '
         || ' AND BOM_HEADER.ALTERNATIVE(+) = BOM_ITEM.ALTERNATIVE'
         || ' AND BOM_HEADER.BOM_USAGE(+) = BOM_ITEM.BOM_USAGE'
         || ' AND CLASS3.CLASS = SPECIFICATION_HEADER.CLASS3_ID'
         || ' AND CLASS3.TYPE <> ''PHS''';

      
      IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
      THEN   
         LSSQL :=
               LSSQL
            || ' AND BOM_ITEM.PLANT IN(SELECT PLANT FROM ITUP WHERE USER_ID = :lsUser)'
            || ' AND BOM_HEADER.PLANT IN(SELECT PLANT FROM ITUP WHERE USER_ID = :lsUser)';
      ELSE
         LSSQL :=    LSSQL
                  || ' AND :lsUser = :lsUser';
      END IF;

      
      LSSQL :=    LSSQL
               || ' AND F_CHECK_ITEM_ACCESS(BOM_ITEM.PART_NO, BOM_ITEM.Revision, 0, 0, :SectionType) = 1 ';
      LSSQL :=    LSSQL
               || ' ORDER BY BOM_ITEM.ALT_GROUP, BOM_ITEM.ALT_PRIORITY ASC';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      
      IF ( AQBOMPATH%ISOPEN )
      THEN
         CLOSE AQBOMPATH;
      END IF;

      OPEN AQBOMPATH FOR LSSQL USING SYSDATE,
      0,
      '',
      0,
      SYSDATE,
      0,
      '',
      0,
      0,
      SYSDATE,
      0,
      '',
      '',
      0;

      LNRETVAL := IAPISPECIFICATIONACCESS.GETVIEWACCESS( ASPARTNO,
                                                         ANREVISION,
                                                         LNACCESS );

      IF LNRETVAL <>( IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN LNRETVAL;
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

      
      SELECT   ADEXPLOSIONDATE
             + 1
             - (   1
                 / 86400 )
        INTO LDDATE
        FROM DUAL;

      
      IF ( AQBOMPATH%ISOPEN )
      THEN
         CLOSE AQBOMPATH;
      END IF;

      OPEN AQBOMPATH FOR LSSQL
      USING LDDATE,
            ANINCLUDEINDEVELOPMENT,
            ASPARTNO,
            ANREVISION,
            LDDATE,
            ANINCLUDEINDEVELOPMENT,
            ASPLANT,
            ANALTERNATIVE,
            ANUSAGE,
            LDDATE,
            ANINCLUDEINDEVELOPMENT,
            IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
            IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
            IAPICONSTANT.SECTIONTYPE_BOM;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETBOMPATHITEMS;


   FUNCTION GETBOMPATHHEADERS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPARENTPLANT              IN       IAPITYPE.PLANT_TYPE,
      ANPARENTUSAGE              IN       IAPITYPE.BOMUSAGE_TYPE,
      AQHEADERS                  OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS













      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetBomPathHeaders';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSSQL                         VARCHAR2( 8192 );
   BEGIN
      LSSQL :=
            'SELECT DISTINCT BOM_HEADER.PART_NO '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', BOM_HEADER.Revision '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', F_SH_DESCR(1, BOM_HEADER.PART_NO,BOM_HEADER.REVISION) '
         || IAPICONSTANTCOLUMN.SPECIFICATIONDESCRIPTIONCOL
         || ', BOM_HEADER.PLANT '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', BOM_HEADER.ALTERNATIVE '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', BOM_HEADER.BOM_USAGE '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', BOM_HEADER.DESCRIPTION '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ', PLANT.DESCRIPTION '
         || IAPICONSTANTCOLUMN.PLANTDESCRIPTIONCOL
         || ', ITBU.DESCR '
         || IAPICONSTANTCOLUMN.BOMUSAGEDESCRIPTIONCOL
         || ', DECODE(BOM_HEADER.PLANT, :asParentPlant, decode(BOM_HEADER.BOM_USAGE, :anParentUsage, BOM_HEADER.PREFERRED, 0), 0) '
         || IAPICONSTANTCOLUMN.PREFERREDCOL
         || ' FROM BOM_HEADER,PART,PLANT,PART_PLANT,ITBU'
         || ' WHERE BOM_HEADER.PART_NO = PART.PART_NO'
         || ' AND BOM_HEADER.PLANT = PLANT.PLANT'
         || ' AND BOM_HEADER.PART_NO = PART_PLANT.PART_NO'
         || ' AND BOM_HEADER.PLANT = PART_PLANT.PLANT'
         || ' AND ITBU.BOM_USAGE = BOM_HEADER.BOM_USAGE'
         || ' AND BOM_HEADER.PART_NO = :asPartNo'
         || ' AND BOM_HEADER.Revision = :anRevision'
         || ' AND DECODE((SELECT COUNT(*) FROM BOM_ITEM WHERE BOM_ITEM.PART_NO = BOM_HEADER.PART_NO AND BOM_ITEM.REVISION = BOM_HEADER.REVISION AND BOM_ITEM.PLANT = BOM_HEADER.PLANT AND BOM_ITEM.ALTERNATIVE = BOM_HEADER.ALTERNATIVE AND BOM_ITEM.BOM_USAGE = BOM_HEADER.BOM_USAGE), 0, 0, 1) = 1';

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.PLANTACCESS = 1
      THEN   
         LSSQL :=    LSSQL
                  || ' AND PART_PLANT.PLANT_ACCESS = ''Y'''
                  || ' AND BOM_HEADER.PLANT IN(SELECT PLANT FROM ITUP WHERE USER_ID = :lsUser)';
      ELSE
         LSSQL :=    LSSQL
                  || ' AND DECODE (:lsUser, NULL, 0, 0) = 0';
      END IF;

      
      IF ( AQHEADERS%ISOPEN )
      THEN
         CLOSE AQHEADERS;
      END IF;

      OPEN AQHEADERS FOR LSSQL USING '',
      0,
      '',
      0,
      '';

      
      LSSQL :=    LSSQL
               || ' AND F_CHECK_ITEM_ACCESS(BOM_HEADER.PART_NO, BOM_HEADER.Revision, 0, 0, :SectionType) = 1 ';
      LSSQL :=    LSSQL
               || ' ORDER BY BOM_HEADER.PART_NO, BOM_HEADER.REVISION, BOM_HEADER.PLANT, BOM_HEADER.ALTERNATIVE, BOM_HEADER.BOM_USAGE';
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPISPECIFICATIONACCESS.GETVIEWACCESS( ASPARTNO,
                                                         ANREVISION,
                                                         LNACCESS );

      IF LNRETVAL <>( IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN LNRETVAL;
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

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      
      IF ( AQHEADERS%ISOPEN )
      THEN
         CLOSE AQHEADERS;
      END IF;

      OPEN AQHEADERS FOR LSSQL
      USING ASPARENTPLANT,
            ANPARENTUSAGE,
            ASPARTNO,
            ANREVISION,
            IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
            IAPICONSTANT.SECTIONTYPE_BOM;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETBOMPATHHEADERS;

   
   FUNCTION RESETBOMPATH(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS









      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ResetBomPath';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       PLS_INTEGER;
      LNSEQUENCE                    PLS_INTEGER := 0;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      DELETE FROM ITBOMPATH
            WHERE BOM_EXP_NO = ANUNIQUEID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END RESETBOMPATH;

   
   FUNCTION ADDBOMPATH(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ASPARENTPARTNO             IN       IAPITYPE.PARTNO_TYPE,
      ANPARENTREVISION           IN       IAPITYPE.REVISION_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE,
      ASALTERNATIVEGROUP         IN       IAPITYPE.BOMITEMALTGROUP_TYPE,
      ANALTERNATIVEPRIORITY      IN       IAPITYPE.BOMITEMALTPRIORITY_TYPE,
      ANISHEADER                 IN       IAPITYPE.BOOLEAN_TYPE,
      ANLEVEL                    IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddBomPath';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       PLS_INTEGER;
      LNSEQUENCE                    PLS_INTEGER := 0;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPISPECIFICATIONACCESS.GETVIEWACCESS( ASPARENTPARTNO,
                                                         ANPARENTREVISION,
                                                         LNACCESS );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         RETURN LNRETVAL;
      END IF;

      IF LNACCESS = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOVIEWACCESS,
                                                    ASPARTNO,
                                                    ANREVISION );
      END IF;

      IF ASALTERNATIVEGROUP IS NOT NULL
      THEN
         IF    ( ANALTERNATIVEPRIORITY IS NULL )
            OR ( ANALTERNATIVEPRIORITY < 1 )
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_INVALIDALTPRIORITY ) );
         END IF;
      END IF;

      IF ANALTERNATIVEPRIORITY IS NOT NULL
      THEN
         IF ASALTERNATIVEGROUP IS NULL
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_INVALIDALTGROUP ) );
         END IF;
      END IF;

      
      IF ASALTERNATIVEGROUP IS NULL
      THEN   
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM BOM_HEADER
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PLANT = ASPLANT
            AND ALTERNATIVE = ANALTERNATIVE
            AND BOM_USAGE = ANUSAGE;

         IF ( LNCOUNT <> 1 )
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_NOBOMHEADER,
                                                       ASPARTNO,
                                                       ANREVISION,
                                                       ASPLANT,
                                                       ANALTERNATIVE,
                                                       ANUSAGE );
         END IF;
      ELSE   
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM BOM_ITEM
          WHERE PART_NO = ASPARENTPARTNO
            AND REVISION = ANPARENTREVISION
            AND PLANT = ASPLANT
            AND ALTERNATIVE = ANALTERNATIVE
            AND BOM_USAGE = ANUSAGE
            AND ALT_GROUP = ASALTERNATIVEGROUP
            AND ALT_PRIORITY = ANALTERNATIVEPRIORITY;

         IF ( LNCOUNT = 0 )
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_NOBOMITEMGROUPPRIO,
                                                       ASPARTNO,
                                                       ANREVISION,
                                                       ASPLANT,
                                                       ANALTERNATIVE,
                                                       ANUSAGE,
                                                       ASALTERNATIVEGROUP,
                                                       ANALTERNATIVEPRIORITY );
         END IF;
      END IF;

      LNRETVAL :=
         REMOVEBOMPATH( ANUNIQUEID,
                        ASPARENTPARTNO,
                        ANPARENTREVISION,
                        ASPARTNO,
                        ANREVISION,
                        ASALTERNATIVEGROUP,
                        ANALTERNATIVEPRIORITY,
                        ANISHEADER,
                        ANLEVEL );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         RETURN LNRETVAL;
      END IF;

      IF ANISHEADER = 1
      THEN
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM ITBOMPATH
          WHERE BOM_EXP_NO = ANUNIQUEID
            AND PARENT_PART_NO = ASPARENTPARTNO
            AND PARENT_REVISION = ANPARENTREVISION
            AND PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PLANT = ASPLANT
            AND ALTERNATIVE = ANALTERNATIVE
            AND BOM_USAGE = ANUSAGE
            AND BOM_LEVEL = ANLEVEL;

         IF LNCOUNT > 0
         THEN
            RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
         END IF;
      ELSE
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM ITBOMPATH
          WHERE BOM_EXP_NO = ANUNIQUEID
            AND PARENT_PART_NO = ASPARENTPARTNO
            AND PARENT_REVISION = ANPARENTREVISION
            AND PART_NO = ASPARTNO
            AND REVISION = ANREVISION
            AND PLANT = ASPLANT
            AND ALTERNATIVE = ANALTERNATIVE
            AND BOM_USAGE = ANUSAGE
            AND ALT_GROUP = ASALTERNATIVEGROUP
            AND ALT_PRIORITY = ANALTERNATIVEPRIORITY
            AND BOM_LEVEL = ANLEVEL;

         IF LNCOUNT > 0
         THEN
            RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
         END IF;
      END IF;

      SELECT   NVL( MAX( SEQ_NO ),
                    0 )
             + 1
        INTO LNSEQUENCE
        FROM ITBOMPATH
       WHERE BOM_EXP_NO = ANUNIQUEID;

      INSERT INTO ITBOMPATH
                  ( BOM_EXP_NO,
                    SEQ_NO,
                    PARENT_PART_NO,
                    PARENT_REVISION,
                    PART_NO,
                    REVISION,
                    PLANT,
                    ALTERNATIVE,
                    BOM_USAGE,
                    ALT_GROUP,
                    ALT_PRIORITY,
                    BOM_LEVEL )
           VALUES ( ANUNIQUEID,
                    LNSEQUENCE,
                    ASPARENTPARTNO,
                    ANPARENTREVISION,
                    ASPARTNO,
                    ANREVISION,
                    ASPLANT,
                    ANALTERNATIVE,
                    ANUSAGE,
                    ASALTERNATIVEGROUP,
                    ANALTERNATIVEPRIORITY,
                    ANLEVEL );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_DUPVALONINDEX,
                                                    ASPARTNO,
                                                    ANREVISION );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDBOMPATH;

   
   FUNCTION REMOVEBOMPATH(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ASPARENTPARTNO             IN       IAPITYPE.PARTNO_TYPE,
      ANPARENTREVISION           IN       IAPITYPE.REVISION_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASALTERNATIVEGROUP         IN       IAPITYPE.BOMITEMALTGROUP_TYPE,
      ANALTERNATIVEPRIORITY      IN       IAPITYPE.BOMITEMALTPRIORITY_TYPE,
      ANISHEADER                 IN       IAPITYPE.BOOLEAN_TYPE,
      ANLEVEL                    IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS









      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveBomPath';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;

      CURSOR LCREMOVEITEM(
         CSPARENTPARTNO                      IAPITYPE.PARTNO_TYPE,
         CNPARENTREVISION                    IAPITYPE.REVISION_TYPE,
         CSPARTNO                            IAPITYPE.PARTNO_TYPE,
         CNREVISION                          IAPITYPE.REVISION_TYPE,
         CNUNIQUEID                          IAPITYPE.SEQUENCE_TYPE,
         CNLEVEL                             IAPITYPE.ID_TYPE )
      IS
         SELECT *
           FROM ITBOMPATH
          WHERE PARENT_PART_NO = CSPARENTPARTNO
            AND PARENT_REVISION = CNPARENTREVISION
            AND PART_NO = CSPARTNO
            AND REVISION = CNREVISION
            AND ALT_GROUP IS NULL
            AND BOM_EXP_NO = CNUNIQUEID
            AND BOM_LEVEL IN(   CNLEVEL
                              + 1 );

      CURSOR LCREMOVEHEADER(
         CSPARTNO                            IAPITYPE.PARTNO_TYPE,
         CNREVISION                          IAPITYPE.SEQUENCE_TYPE,
         CNUNIQUEID                          IAPITYPE.SEQUENCE_TYPE,
         CNLEVEL                             IAPITYPE.ID_TYPE )
      IS
         SELECT *
           FROM ITBOMPATH
          WHERE PARENT_PART_NO = CSPARTNO
            AND PARENT_REVISION = CNREVISION
            AND BOM_EXP_NO = CNUNIQUEID
            AND BOM_LEVEL IN( CNLEVEL );
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ANISHEADER <> 1
      THEN
         DELETE FROM ITBOMPATH
               WHERE PARENT_PART_NO = ASPARENTPARTNO
                 AND PARENT_REVISION = ANPARENTREVISION
                 AND ALT_GROUP = ASALTERNATIVEGROUP
                 AND ALT_PRIORITY <> ANALTERNATIVEPRIORITY
                 AND BOM_EXP_NO = ANUNIQUEID
                 AND BOM_LEVEL = ANLEVEL;

         FOR I IN LCREMOVEITEM( ASPARENTPARTNO,
                                ANPARENTREVISION,
                                ASPARTNO,
                                ANREVISION,
                                ANUNIQUEID,
                                ANLEVEL )
         LOOP
            LNRETVAL :=
               REMOVEBOMPATH( I.BOM_EXP_NO,
                              I.PARENT_PART_NO,
                              I.PARENT_REVISION,
                              I.PART_NO,
                              I.REVISION,
                              I.ALT_GROUP,
                              I.ALT_PRIORITY,
                              ANISHEADER,
                              I.BOM_LEVEL );
         END LOOP;

         DELETE FROM ITBOMPATH
               WHERE PARENT_PART_NO = ASPARENTPARTNO
                 AND PARENT_REVISION = ANPARENTREVISION
                 AND PART_NO = ASPARTNO
                 AND REVISION = ANREVISION
                 AND ALT_GROUP IS NULL
                 AND BOM_EXP_NO = ANUNIQUEID
                 AND BOM_LEVEL IN(   ANLEVEL
                                   + 1 );
      ELSE
         DELETE FROM ITBOMPATH
               WHERE PARENT_PART_NO = ASPARENTPARTNO
                 AND PARENT_REVISION = ANPARENTREVISION
                 AND PART_NO = ASPARTNO
                 AND REVISION = ANREVISION
                 AND ALT_GROUP IS NULL
                 AND BOM_EXP_NO = ANUNIQUEID
                 AND BOM_LEVEL IN( ANLEVEL );

         FOR I IN LCREMOVEHEADER( ASPARTNO,
                                  ANREVISION,
                                  ANUNIQUEID,
                                  ANLEVEL )
         LOOP
            LNRETVAL :=
               REMOVEBOMPATH( I.BOM_EXP_NO,
                              I.PARENT_PART_NO,
                              I.PARENT_REVISION,
                              I.PART_NO,
                              I.REVISION,
                              I.ALT_GROUP,
                              I.ALT_PRIORITY,
                              ANISHEADER,
                              I.BOM_LEVEL );
         END LOOP;

         DELETE FROM ITBOMPATH
               WHERE PARENT_PART_NO = ASPARTNO
                 AND PARENT_REVISION = ANREVISION
                 AND BOM_EXP_NO = ANUNIQUEID
                 AND BOM_LEVEL IN( ANLEVEL );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEBOMPATH;

   
   FUNCTION SAVEBOMITEMBULK(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE,
      ANACTION                   IN       IAPITYPE.NUMVAL_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveBomItemBulk';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRBOMITEM                     IAPITYPE.BOMITEMREC_TYPE;
      LNMARKEDFOREDITING            IAPITYPE.BOOLEAN_TYPE;
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
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
      GTBOMITEMS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LNRETVAL := CHECKEDITACCESS( ASPARTNO,
                                   ANREVISION );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         RETURN LNRETVAL;
      END IF;

      LRBOMITEM.PARTNO := ASPARTNO;
      LRBOMITEM.REVISION := ANREVISION;
      LRBOMITEM.PLANT := ASPLANT;
      LRBOMITEM.ALTERNATIVE := ANALTERNATIVE;
      LRBOMITEM.BOMUSAGE := ANUSAGE;
      GTBOMITEMS( 0 ) := LRBOMITEM;

      GTINFO( 0 ) := LRINFO;


      
      IF ( AFHANDLE IS NOT NULL )
      THEN
         
         LNRETVAL := EXISTSEC( ASPARTNO,
                               ANREVISION,
                               LNSECTIONID,
                               LNSUBSECTIONID );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         LNRETVAL := IAPISPECIFICATIONSECTION.ISMARKEDFOREDITING( ASPARTNO,
                                                                  ANREVISION,
                                                                  LNSECTIONID,
                                                                  LNSUBSECTIONID,
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
                                      LNSECTIONID,
                                      0 )
                      || DECODE( LNSUBSECTIONID,
                                 0, NULL,
                                    ' - '
                                 || F_SCH_DESCR( IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,
                                                 LNSUBSECTIONID,
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
   END SAVEBOMITEMBULK;


   FUNCTION SAVEBOMHEADERBULK(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANACTION                   IN       IAPITYPE.NUMVAL_TYPE,
      AFHANDLE                   IN       IAPITYPE.FLOAT_TYPE DEFAULT NULL,
      AQINFO                     OUT      IAPITYPE.REF_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveBomHeaderBulk';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRBOMHEADER                   IAPITYPE.BOMHEADERREC_TYPE;
      LNMARKEDFOREDITING            IAPITYPE.BOOLEAN_TYPE;
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
      LSSECTION                     IAPITYPE.STRING_TYPE;
      LRINFO                        IAPITYPE.INFOREC_TYPE;
      LSSQLINFO                     IAPITYPE.SQLSTRING_TYPE;
      LBLOGERROR                    BOOLEAN := FALSE;
      LSLOGERRORMESSAGE             IAPITYPE.CLOB_TYPE;
      LRFRAME                       IAPITYPE.FRAMEREC_TYPE;
      LNOPTIONAL                    IAPITYPE.BOOLEAN_TYPE;
      LBSKIPCHECK                   BOOLEAN := FALSE;
   BEGIN
      
      
      
      
      
      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
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

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTBOMITEMS.DELETE;
      GTINFO.DELETE;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LNRETVAL := CHECKEDITACCESS( ASPARTNO,
                                   ANREVISION );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         RETURN LNRETVAL;
      END IF;

      LRBOMHEADER.PARTNO := ASPARTNO;
      LRBOMHEADER.REVISION := ANREVISION;
      GTBOMHEADERS( 0 ) := LRBOMHEADER;

      GTINFO( 0 ) := LRINFO;

      
      IF ( AFHANDLE IS NOT NULL )
      THEN
         
         
         
         
         
         
         
         
         
         

         
         LNRETVAL := EXISTSEC( ASPARTNO,
                               ANREVISION,
                               LNSECTIONID,
                               LNSUBSECTIONID );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SPSECTIONNOTFOUND )
            THEN
               LSLOGERRORMESSAGE := IAPIGENERAL.GETLASTERRORTEXT( );

               
               SELECT DECODE( MANDATORY,
                              'Y', 0,
                              1 ),
                      SECTION_ID,
                      SUB_SECTION_ID
                 INTO LNOPTIONAL,
                      LNSECTIONID,
                      LNSUBSECTIONID
                 FROM FRAME_SECTION
                WHERE ( FRAME_NO, REVISION, OWNER ) = ( SELECT FRAME_ID,
                                                               FRAME_REV,
                                                               FRAME_OWNER
                                                         FROM SPECIFICATION_HEADER
                                                        WHERE PART_NO = ASPARTNO
                                                          AND REVISION = ANREVISION )
                  AND TYPE = IAPICONSTANT.SECTIONTYPE_BOM;

               IF (     ANACTION IN( IAPICONSTANT.ACTIONPRE, IAPICONSTANT.ACTIONPOST )
                    AND LNOPTIONAL = 1 )
               THEN
                  LBLOGERROR := FALSE;
                  LBSKIPCHECK := TRUE;
               ELSE
                  LBLOGERROR := TRUE;
               END IF;
            ELSE
               LBLOGERROR := TRUE;
            END IF;
         END IF;

         IF ( LBLOGERROR = TRUE )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 LSLOGERRORMESSAGE );
            RETURN( LNRETVAL );
         END IF;

         IF ( LBSKIPCHECK = FALSE )
         THEN
            LNRETVAL :=
                       IAPISPECIFICATIONSECTION.ISMARKEDFOREDITING( ASPARTNO,
                                                                    ANREVISION,
                                                                    LNSECTIONID,
                                                                    LNSUBSECTIONID,
                                                                    AFHANDLE,
                                                                    LNMARKEDFOREDITING );

            IF (     LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
                 AND LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SPSECTIONNOTFOUND )
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
                                         LNSECTIONID,
                                         0 )
                         || DECODE( LNSUBSECTIONID,
                                    0, NULL,
                                       ' - '
                                    || F_SCH_DESCR( IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,
                                                    LNSUBSECTIONID,
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
      END IF;

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
   END SAVEBOMHEADERBULK;


   FUNCTION GETCOMPONENTREVISION(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ADDRILLDOWNDATE            IN       IAPITYPE.DATE_TYPE,
      ABINDEVELOPMENT            IN       IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   
   
   
   
   
   
   
   
   
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetComponentRevision';
      LSINDEV                       VARCHAR2( 1 ) := 'N';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      IF ABINDEVELOPMENT = 1
      THEN
         LSINDEV := 'Y';
      END IF;

      RETURN TO_NUMBER( SUBSTR( F_FIND_PSEUDO_ALL( ASPARTNO,
                                                   ANREVISION,
                                                   ASPLANT,
                                                   ADDRILLDOWNDATE,
                                                   LSINDEV,
                                                   NULL ),
                                2,
                                5 ) );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
         RETURN IAPICONSTANTDBERROR.DBERR_GENFAIL;
         RAISE_APPLICATION_ERROR( -20000,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
   END GETCOMPONENTREVISION;

   
   FUNCTION EXPLODENEXTLEVEL(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE,
      ANMULTILEVEL               IN       IAPITYPE.BOOLEAN_TYPE,
      ADEXPLOSIONDATE            IN       IAPITYPE.DATE_TYPE,
      ANLEVEL                    IN       PLS_INTEGER,
      ANSEQUENCE                 IN OUT   NUMBER,
      ANCALCULATEDQUANTITY       IN       IAPITYPE.BOMQUANTITY_TYPE,
      ANCALCULATEDQUANTITYWITHSCRAP IN    IAPITYPE.BOMQUANTITY_TYPE,
      ANINCLUDEINDEVELOPMENT     IN       IAPITYPE.BOOLEAN_TYPE,
      ANEXPLOSIONTYPE            IN       PLS_INTEGER,
      ANUSEBOMPATH               IN       IAPITYPE.BOOLEAN_TYPE,
      ASPARENTPARTNO             IN       IAPITYPE.PARTNO_TYPE,
      ANPARENTREVISION           IN       IAPITYPE.REVISION_TYPE,
      ASPRICETYPE                IN       IAPITYPE.PRICETYPE_TYPE DEFAULT NULL,
      ASPERIOD                   IN       IAPITYPE.PERIOD_TYPE DEFAULT NULL,
      ASALTERNATIVEPRICETYPE     IN       IAPITYPE.PRICETYPE_TYPE DEFAULT NULL,
      ASALTERNATIVEPERIOD        IN       IAPITYPE.PERIOD_TYPE DEFAULT NULL,
      ANMOPCOUNT                 IN       PLS_INTEGER DEFAULT 1,
      ANPREVIOUSLEVEL            IN OUT   PLS_INTEGER,
      
      
      ASBASEUOM                  IN       VARCHAR2,
      ANPARENTCONVFACTOR         IN       FLOAT DEFAULT 1,
      
      ANINCLUDEALTERNATIVES     IN      IAPITYPE.BOOLEAN_TYPE DEFAULT 0 )
      
      RETURN IAPITYPE.ERRORNUM_TYPE









   IS
      
      
      
      
      CURSOR LCBOMITEMS(
         C_PART_NO                           IAPITYPE.PARTNO_TYPE,
         C_REVISION                          IAPITYPE.REVISION_TYPE,
         C_PLANT                             IAPITYPE.PLANT_TYPE,
         C_ALTERNATIVE                       IAPITYPE.BOMALTERNATIVE_TYPE,
         LC_BOM_USAGE                        IAPITYPE.BOMUSAGE_TYPE,
         C_DATE                              IAPITYPE.DATE_TYPE,
         C_EXPLOSIONTYPE                     PLS_INTEGER )
      IS
         SELECT   BOM_HEADER.BASE_QUANTITY,
                  COMPONENT_PART,
                  BOM_ITEM.COMPONENT_PLANT,
                  BOM_ITEM.ALTERNATIVE,
                  BOM_ITEM.BOM_USAGE,
                  COMPONENT_REVISION,
                  DECODE( C_EXPLOSIONTYPE,
                          IAPICONSTANT.EXPLOSION_ASSOLD, QUANTITY
                           * (   NVL( BOM_ITEM.YIELD,
                                      100 )
                               / 100 ),
                          IAPICONSTANT.EXPLOSION_NUTRITIONAL, QUANTITY
                           * (   NVL( BOM_ITEM.YIELD,
                                      100 )
                               / 100 ),
                          QUANTITY ) QUANTITY,
                  F_PART_SOURCE( COMPONENT_PART ) PART_SOURCE,
                  F_FIND_PSEUDO_ALL( COMPONENT_PART,
                                     COMPONENT_REVISION,
                                     COMPONENT_PLANT,
                                     ADEXPLOSIONDATE,
                                     DECODE( ANINCLUDEINDEVELOPMENT,
                                             1, 'Y',
                                             'N' ),
                                     NULL ) COMP_FLAG,
                  BOM_ITEM.TO_UNIT,
                  BOM_ITEM.CONV_FACTOR,
                  F_PART_TYPE( COMPONENT_PART ) PART_TYPE,
                  BOM_ITEM.FIXED_QTY,
                  ALT_PRIORITY,
                  ALT_GROUP,
                  UOM,
                  
                  PART.BASE_UOM,
                  
                  BOM_ITEM.YIELD,
                  ASSEMBLY_SCRAP,
                  COMPONENT_SCRAP,
                  LEAD_TIME_OFFSET,
                  RELEVENCY_TO_COSTING,
                  BULK_MATERIAL,
                  ITEM_CATEGORY,
                  ISSUE_LOCATION,
                  BOM_ITEM_TYPE,
                  OPERATIONAL_STEP,
                  BOM_ITEM.MIN_QTY,
                  BOM_ITEM.MAX_QTY,
                  CODE,
                  CHAR_1,
                  CHAR_2,
                  CHAR_3,
                  CHAR_4,
                  CHAR_5,
                  NUM_1,
                  NUM_2,
                  NUM_3,
                  NUM_4,
                  NUM_5,
                  BOOLEAN_1,
                  BOOLEAN_2,
                  BOOLEAN_3,
                  BOOLEAN_4,
                  DATE_1,
                  DATE_2,
                  CH_1,
                  CH_REV_1,
                  CH_2,
                  CH_REV_2,
                  CH_3,
                  CH_REV_3
             FROM BOM_HEADER,
                  
                  
                  BOM_ITEM,
                  PART
                  
            WHERE BOM_HEADER.PART_NO = C_PART_NO
              AND BOM_HEADER.REVISION = C_REVISION
              AND BOM_HEADER.PLANT = C_PLANT
              AND BOM_HEADER.ALTERNATIVE = C_ALTERNATIVE
              AND BOM_HEADER.BOM_USAGE = LC_BOM_USAGE
              
              AND BOM_ITEM.COMPONENT_PART = PART.PART_NO
              
              AND BOM_ITEM.PART_NO = BOM_HEADER.PART_NO
              AND BOM_ITEM.REVISION = BOM_HEADER.REVISION
              AND BOM_ITEM.PLANT = BOM_HEADER.PLANT
              AND BOM_ITEM.ALTERNATIVE = BOM_HEADER.ALTERNATIVE
              AND BOM_ITEM.BOM_USAGE = BOM_HEADER.BOM_USAGE
              AND (    BOM_ITEM.ALT_GROUP IS NULL
                    
                    OR
                    (   BOM_ITEM.ALT_GROUP IS NOT NULL
                        AND BOM_ITEM.ALT_PRIORITY > 1
                        AND ANUSEBOMPATH = 0
                        AND BOM_ITEM.ALT_PRIORITY < DECODE( ANINCLUDEALTERNATIVES, 1, 100,2 )    )
                     
                    OR (      ( COMPONENT_PART,
                                GETCOMPONENTREVISION( COMPONENT_PART,
                                                      COMPONENT_REVISION,
                                                      COMPONENT_PLANT,
                                                      ADEXPLOSIONDATE,
                                                      ANINCLUDEINDEVELOPMENT ),
                                BOM_HEADER.PLANT,
                                BOM_HEADER.ALTERNATIVE,
                                BOM_HEADER.BOM_USAGE,
                                ALT_GROUP,
                                ALT_PRIORITY ) IN(
                                 SELECT PART_NO,
                                        REVISION,
                                        PLANT,
                                        ALTERNATIVE,
                                        BOM_USAGE,
                                        ALT_GROUP,
                                        ALT_PRIORITY
                                   FROM ITBOMPATH
                                  WHERE BOM_EXP_NO = ANUNIQUEID
                                    AND PARENT_PART_NO = C_PART_NO
                                    AND PARENT_REVISION = C_REVISION
                                    AND BOM_LEVEL = ANLEVEL )
                         AND ANUSEBOMPATH = 1 )
                    OR (      ( COMPONENT_PART,
                                GETCOMPONENTREVISION( COMPONENT_PART,
                                                      COMPONENT_REVISION,
                                                      COMPONENT_PLANT,
                                                      ADEXPLOSIONDATE,
                                                      ANINCLUDEINDEVELOPMENT ),
                                BOM_HEADER.PLANT,
                                BOM_HEADER.ALTERNATIVE,
                                BOM_HEADER.BOM_USAGE,
                                ALT_GROUP ) NOT IN(
                                 SELECT PART_NO,
                                        REVISION,
                                        PLANT,
                                        ALTERNATIVE,
                                        BOM_USAGE,
                                        ALT_GROUP
                                   FROM ITBOMPATH
                                  WHERE BOM_EXP_NO = ANUNIQUEID
                                    AND PARENT_PART_NO = C_PART_NO
                                    AND PARENT_REVISION = C_REVISION
                                    AND BOM_LEVEL = ANLEVEL )
                         AND ALT_PRIORITY = 1
                         AND (    ALT_GROUP NOT IN(
                                     SELECT ALT_GROUP
                                       FROM ITBOMPATH
                                      WHERE BOM_EXP_NO = ANUNIQUEID
                                        AND PARENT_PART_NO = C_PART_NO
                                        AND PARENT_REVISION = C_REVISION
                                        AND BOM_LEVEL = ANLEVEL )
                               OR ANUSEBOMPATH = 0 ) ) )
         ORDER BY ITEM_NUMBER;

      LSBOMEXISTS                   VARCHAR2( 1 );
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LNACCESSSTOP                  IAPITYPE.BOOLEAN_TYPE;
      LNLEVEL                       PLS_INTEGER;
      LNCALCULATEDQUANTITY          IAPITYPE.BOMQUANTITY_TYPE;
      LNCALCULATEDQUANTITYWITHSCRAP IAPITYPE.BOMQUANTITY_TYPE;
      LSPLANT                       IAPITYPE.PLANT_TYPE;
      LNALTERNATIVE                 IAPITYPE.BOMALTERNATIVE_TYPE;
      LNBOMUSAGE                    IAPITYPE.BOMUSAGE_TYPE;
      LNUPDLEVEL                    INTEGER := 0;
      LNINGREDIENT                  PLS_INTEGER;
      LNMAXLEVEL                    PLS_INTEGER;
      LNEXPLOSIONTYPE               PLS_INTEGER;
      LNCOUNT                       PLS_INTEGER DEFAULT 0;
      LNCOUNT1                      PLS_INTEGER DEFAULT 0;
      LNRECURSIVECHECK              PLS_INTEGER;
      LNPRICECHECK                  PLS_INTEGER := 0;
      LSPRICETYPE                   IAPITYPE.PRICETYPE_TYPE;
      LNUSEBOMPATH                  IAPITYPE.BOOLEAN_TYPE;
      LSSPECTYPEGROUP               CLASS3.TYPE%TYPE;
      LSDESCRIPTION                 IAPITYPE.DESCRIPTION_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExplodeNextLevel';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSBASEUOM                     IAPITYPE.DESCRIPTION_TYPE;
      LNTOTAL                       FLOAT;
      LNTOTALWITHSCRAP              FLOAT;
      LNTOTALCALCULATED             FLOAT;
      LNTOTALCALCULATEDWITHSCRAP    FLOAT;
      LNPRICE                       FLOAT;
      LNPRICEWITHSCRAP              FLOAT;
      LNCALCULATEDPRICE             FLOAT;
      LNCALCULATEDPRICEWITHSCRAP    FLOAT;
      
      LNCHILDBOMITEMS               NUMBER;
      LNPARENTCONVFACTOR            FLOAT;
      LNCALCULATEDCONVFACTOR        FLOAT;
      LNAPPLYPARENTCONVFACTOR       NUMBER := 0;
      
      
      LNCALCULATEDQUANTITY1         FLOAT;
      LNCALCULATEDQUANTITYWITHSCRAP1 FLOAT;
      

      CURSOR LCPRICE
      IS
         SELECT *
           FROM ITBOMEXPLOSION
          WHERE BOM_EXP_NO = ANUNIQUEID
            AND MOP_SEQUENCE_NO = ANMOPCOUNT;

      CURSOR LCLEVEL(
         ANLEVEL                    IN       PLS_INTEGER )
      IS
         SELECT   *
             FROM ITBOMEXPLOSION
            WHERE BOM_EXP_NO = ANUNIQUEID
              AND BOM_LEVEL <= ANLEVEL
              AND MOP_SEQUENCE_NO = ANMOPCOUNT
         ORDER BY SEQUENCE_NO DESC;
   BEGIN
   


      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      LNUSEBOMPATH := ANUSEBOMPATH;
      LNLEVEL :=   ANLEVEL
                 + 1;

      
      LNPARENTCONVFACTOR := ANPARENTCONVFACTOR;

      


      

      IF ANEXPLOSIONTYPE IN
            ( IAPICONSTANT.EXPLOSION_INGREDIENT,
              IAPICONSTANT.EXPLOSION_INGREDIENTMIX,
              IAPICONSTANT.EXPLOSION_NUTRITIONAL,
              IAPICONSTANT.EXPLOSION_CLAIMS )
      THEN
         LNEXPLOSIONTYPE := IAPICONSTANT.EXPLOSION_ASSOLD;
      ELSE
         LNEXPLOSIONTYPE := ANEXPLOSIONTYPE;
      END IF;

      







      FOR BOM_COMPS IN LCBOMITEMS( ASPARTNO,
                                   ANREVISION,
                                   ASPLANT,
                                   ANALTERNATIVE,
                                   ANUSAGE,
                                   ADEXPLOSIONDATE,
                                   LNEXPLOSIONTYPE )
      LOOP
         
         IF NOT(     BOM_COMPS.QUANTITY < 0
                 AND ANEXPLOSIONTYPE = IAPICONSTANT.EXPLOSION_ASBOUGHT )
         THEN
            
            IF BOM_COMPS.FIXED_QTY = 1
            THEN
               BEGIN
                  LNCALCULATEDQUANTITY := BOM_COMPS.QUANTITY;
                  LNCALCULATEDQUANTITYWITHSCRAP :=   BOM_COMPS.QUANTITY
                                                   * (   1
                                                       + (   NVL( BOM_COMPS.COMPONENT_SCRAP,
                                                                  0 )
                                                           / 100 ) );
                
                LNCALCULATEDQUANTITY1 := LNCALCULATEDQUANTITY;
                LNCALCULATEDQUANTITYWITHSCRAP1 :=   LNCALCULATEDQUANTITYWITHSCRAP;
                
               EXCEPTION
                  WHEN VALUE_ERROR
                  THEN
                     RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                LSMETHOD,
                                                                IAPICONSTANTDBERROR.DBERR_INVALIDCALCQUANTITY );
               END;
            ELSE
               IF BOM_COMPS.BASE_QUANTITY = 0
               THEN
                  
                  RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                             LSMETHOD,
                                                             IAPICONSTANTDBERROR.DBERR_NOBASEQUANTITY,
                                                             ASPARTNO,
                                                             ANREVISION,
                                                             ASPLANT,
                                                             ANALTERNATIVE,
                                                             F_BU_DESCR( ANUSAGE ) );
               END IF;

               BEGIN
                  
                  SELECT BASE_UOM
                  INTO LSBASEUOM
                  FROM PART
                  WHERE PART_NO = BOM_COMPS.COMPONENT_PART;

                  SELECT COUNT(*)
                  INTO LNCHILDBOMITEMS
                  FROM BOM_ITEM
                  WHERE PART_NO = BOM_COMPS.COMPONENT_PART
                  AND REVISION = GETCOMPONENTREVISION( BOM_COMPS.COMPONENT_PART,
                                                       BOM_COMPS.COMPONENT_REVISION,
                                                       BOM_COMPS.COMPONENT_PLANT,
                                                       ADEXPLOSIONDATE,
                                                       ANINCLUDEINDEVELOPMENT )
                  AND PLANT = ASPLANT
                  AND ALTERNATIVE = ANALTERNATIVE
                  AND BOM_USAGE = ANUSAGE;

                  IF LSBASEUOM IS NOT NULL
                  THEN
                     IF LSBASEUOM <> BOM_COMPS.UOM
                            AND LNCHILDBOMITEMS > 0
                     THEN
                        LNCALCULATEDCONVFACTOR := CALCUOMCONVFACTOR(BOM_COMPS.UOM, LSBASEUOM);
                        LNPARENTCONVFACTOR := ANPARENTCONVFACTOR * LNCALCULATEDCONVFACTOR;
                        LNAPPLYPARENTCONVFACTOR := 0; 
                     ELSE
                        LNPARENTCONVFACTOR := ANPARENTCONVFACTOR;
                        LNAPPLYPARENTCONVFACTOR := 1;
                     END IF;
                  END IF;
                  

                  
                  
                  LNCALCULATEDQUANTITY :=   (   ANCALCULATEDQUANTITY * LNPARENTCONVFACTOR
                  

                                              / BOM_COMPS.BASE_QUANTITY )
                                          * BOM_COMPS.QUANTITY;


                  LNCALCULATEDQUANTITYWITHSCRAP :=
                       
                       
                       (   ANCALCULATEDQUANTITYWITHSCRAP * LNPARENTCONVFACTOR

                       
                         / BOM_COMPS.BASE_QUANTITY )
                     * (   BOM_COMPS.QUANTITY
                         * (   1
                             + (   NVL( BOM_COMPS.COMPONENT_SCRAP,
                                        0 )
                                 / 100 ) ) );

                  
                  IF LNAPPLYPARENTCONVFACTOR = 0
                  THEN
                        LNCALCULATEDQUANTITY1 := LNCALCULATEDQUANTITY / LNCALCULATEDCONVFACTOR;
                        LNCALCULATEDQUANTITYWITHSCRAP1 := LNCALCULATEDQUANTITYWITHSCRAP / LNCALCULATEDCONVFACTOR;
                  ELSE
                        LNCALCULATEDQUANTITY1 := LNCALCULATEDQUANTITY;
                        LNCALCULATEDQUANTITYWITHSCRAP1 := LNCALCULATEDQUANTITYWITHSCRAP;
                  END IF;
                

               EXCEPTION
                  WHEN VALUE_ERROR
                  THEN
                     RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                LSMETHOD,
                                                                IAPICONSTANTDBERROR.DBERR_INVALIDCALCQUANTITY );
               END;
            END IF;

            
            IF SUBSTR( BOM_COMPS.COMP_FLAG,
                       2,
                       3 ) IS NULL
            THEN
               LNREVISION := '';
            ELSE
               LNREVISION := TO_NUMBER( SUBSTR( BOM_COMPS.COMP_FLAG,
                                                2,
                                                3 ) );
            END IF;

            LSBOMEXISTS := SUBSTR( BOM_COMPS.COMP_FLAG,
                                   1,
                                   1 );
            
            LNUSEBOMPATH := ANUSEBOMPATH;

            IF ANUSEBOMPATH = 1
            THEN
               BEGIN
                  SELECT DISTINCT PLANT,
                                  ALTERNATIVE,
                                  BOM_USAGE
                             INTO LSPLANT,
                                  LNALTERNATIVE,
                                  LNBOMUSAGE
                             FROM ITBOMPATH
                            WHERE BOM_EXP_NO = ANUNIQUEID
                              AND PARENT_PART_NO = ASPARTNO
                              AND PARENT_REVISION = ANREVISION
                              AND PART_NO = BOM_COMPS.COMPONENT_PART
                              AND REVISION = LNREVISION
                              AND ALT_GROUP IS NULL
                              AND BOM_LEVEL = LNLEVEL;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     
                     LNUSEBOMPATH := 0;
               END;
            END IF;

            IF LNUSEBOMPATH = 0
            THEN
               
               
               
               LSPLANT := BOM_COMPS.COMPONENT_PLANT;

               LNBOMUSAGE := ANUSAGE;

               

               IF LSPLANT = IAPICONSTANT.PLANT_DEVELOPMENT
               THEN
                  BEGIN
                     SELECT PLANT
                       INTO LSPLANT
                       FROM BOM_HEADER
                      WHERE PART_NO = BOM_COMPS.COMPONENT_PART
                        AND REVISION = LNREVISION
                        AND PLANT = BOM_COMPS.COMPONENT_PLANT   
                        AND BOM_USAGE = LNBOMUSAGE;
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        SELECT MIN( PLANT )
                          INTO LSPLANT
                          FROM BOM_HEADER
                         WHERE PART_NO = BOM_COMPS.COMPONENT_PART
                           AND REVISION = LNREVISION
                           AND BOM_USAGE = LNBOMUSAGE;

                        IF LSPLANT IS NULL   
                        THEN
                           SELECT MIN( PLANT )
                             INTO LSPLANT
                             FROM BOM_HEADER
                            WHERE PART_NO = BOM_COMPS.COMPONENT_PART
                              AND REVISION = LNREVISION;

                           IF NOT LSPLANT IS NULL   
                           THEN
                              SELECT MIN( BOM_USAGE )
                                INTO LNBOMUSAGE
                                FROM BOM_HEADER
                               WHERE PART_NO = BOM_COMPS.COMPONENT_PART
                                 AND REVISION = LNREVISION
                                 AND PLANT = BOM_COMPS.COMPONENT_PLANT;   

                              LSBOMEXISTS := 'Y';
                           END IF;
                        ELSE
                           LSBOMEXISTS := 'Y';
                        END IF;
                  END;
               END IF;   

               




               BEGIN
                  SELECT COUNT( * )
                    INTO LNCOUNT1
                    FROM BOM_HEADER
                   WHERE PART_NO = BOM_COMPS.COMPONENT_PART
                     AND REVISION = LNREVISION
                     
                     
                     AND PLANT = LSPLANT
                     
                     AND BOM_USAGE = LNBOMUSAGE
                     AND PREFERRED = 1;   

                  IF LNCOUNT1 > 0
                  THEN
                     SELECT ALTERNATIVE
                       INTO LNALTERNATIVE
                       FROM BOM_HEADER
                      WHERE PART_NO = BOM_COMPS.COMPONENT_PART
                        AND REVISION = LNREVISION
                        
                        
                        AND PLANT = LSPLANT
                        
                        AND BOM_USAGE = LNBOMUSAGE
                        AND PREFERRED = 1;   
                  ELSE
                     LNALTERNATIVE := -1;
                     LNBOMUSAGE := -1;
                     LSBOMEXISTS := 'N';
                  END IF;
               END;
            ELSE
               LSBOMEXISTS := 'Y';
            END IF;

            LSDESCRIPTION := F_SH_DESCR( 1,
                                         BOM_COMPS.COMPONENT_PART,
                                         LNREVISION );

            BEGIN
               SELECT TYPE
                 INTO LSSPECTYPEGROUP
                 FROM CLASS3
                WHERE CLASS = BOM_COMPS.PART_TYPE;
            EXCEPTION
               WHEN OTHERS
               THEN
                  LSSPECTYPEGROUP := IAPICONSTANT.SPECTYPEGROUP_OTHER;
            END;

            




            IF ANEXPLOSIONTYPE = IAPICONSTANT.EXPLOSION_INGREDIENTMIX
            THEN
               BEGIN
                  SELECT COUNT( * )
                    INTO LNCOUNT
                    FROM SPECIFICATION_SECTION
                   WHERE PART_NO = BOM_COMPS.COMPONENT_PART
                     AND REVISION = LNREVISION
                     AND TYPE = IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     LNCOUNT := 0;
               END;
            ELSE
               LNCOUNT := 0;
            END IF;

            IF LSSPECTYPEGROUP <> IAPICONSTANT.SPECTYPEGROUP_PHASE
            THEN
               LNINGREDIENT := GETINGREDIENTTYPE( BOM_COMPS.COMPONENT_PART,
                                                  LNREVISION,
                                                  ANEXPLOSIONTYPE );

               IF LSDESCRIPTION = ' - '
               THEN
                  LNREVISION := 1;
               END IF;

               IF F_CHECK_ACCESS( BOM_COMPS.COMPONENT_PART,
                                  LNREVISION ) > 0
               THEN
                  LNACCESSSTOP := 0;
               ELSE
                  LNACCESSSTOP := 1;
               END IF;

               


               IF     LNCOUNT > 0
                  AND ANEXPLOSIONTYPE = IAPICONSTANT.EXPLOSION_INGREDIENTMIX
                  AND LNACCESSSTOP = 0   
               THEN
                  LSBOMEXISTS := 'N';
               END IF;

               ANSEQUENCE :=   ANSEQUENCE
                             + 10;

               INSERT INTO ITBOMEXPLOSION
                           ( BOM_EXP_NO,
                             MOP_SEQUENCE_NO,
                             SEQUENCE_NO,
                             BOM_LEVEL,
                             COMPONENT_PART,
                             COMPONENT_REVISION,
                             DESCRIPTION,
                             PLANT,
                             UOM,
                             QTY,
                             SCRAP,
                             CALC_QTY,
                             CALC_QTY_WITH_SCRAP,
                             PART_SOURCE,
                             TO_UNIT,
                             CONV_FACTOR,
                             PHANTOM,
                             INGREDIENT,
                             PART_TYPE,
                             ALTERNATIVE,
                             USAGE,
                             ASSEMBLY_SCRAP,
                             COMPONENT_SCRAP,
                             LEAD_TIME_OFFSET,
                             ITEM_CATEGORY,
                             ISSUE_LOCATION,
                             BOM_ITEM_TYPE,
                             OPERATIONAL_STEP,
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
                             CH_REV_1,
                             CH_2,
                             CH_REV_2,
                             CH_3,
                             CH_REV_3,
                             RELEVENCY_TO_COSTING,
                             BULK_MATERIAL,
                             BOOLEAN_1,
                             BOOLEAN_2,
                             BOOLEAN_3,
                             BOOLEAN_4,
                             RECURSIVE_STOP,
                             ACCESS_STOP,
                             COST,
                             COST_WITH_SCRAP )
                    VALUES ( ANUNIQUEID,
                             ANMOPCOUNT,
                             ANSEQUENCE,
                             LNLEVEL,
                             BOM_COMPS.COMPONENT_PART,
                             LNREVISION,
                             LSDESCRIPTION,
                             BOM_COMPS.COMPONENT_PLANT,
                             BOM_COMPS.UOM,
                             
                             
                             
                             DECODE ( BOM_COMPS.ALT_GROUP, NULL, BOM_COMPS.QUANTITY, DECODE( BOM_COMPS.ALT_PRIORITY, NULL, BOM_COMPS.QUANTITY, 1, BOM_COMPS.QUANTITY, 0)),
                             
                             BOM_COMPS.COMPONENT_SCRAP,
                             
                             
                             
                             
                             
                             
                              DECODE (BOM_COMPS.ALT_GROUP, NULL, LNCALCULATEDQUANTITY1, DECODE(BOM_COMPS.ALT_PRIORITY, NULL, LNCALCULATEDQUANTITY1, 1, LNCALCULATEDQUANTITY1, 0)),
                             
                             LNCALCULATEDQUANTITYWITHSCRAP1,
                             
                             BOM_COMPS.PART_SOURCE,
                             BOM_COMPS.TO_UNIT,
                             BOM_COMPS.CONV_FACTOR,
                             DECODE( BOM_COMPS.COMPONENT_REVISION,
                                     NULL, 1,
                                     0 ),
                             LNINGREDIENT,
                             BOM_COMPS.PART_TYPE,
                             ANALTERNATIVE,
                             ANUSAGE,
                             BOM_COMPS.ASSEMBLY_SCRAP,
                             BOM_COMPS.COMPONENT_SCRAP,
                             BOM_COMPS.LEAD_TIME_OFFSET,
                             BOM_COMPS.ITEM_CATEGORY,
                             BOM_COMPS.ISSUE_LOCATION,
                             BOM_COMPS.BOM_ITEM_TYPE,
                             BOM_COMPS.OPERATIONAL_STEP,
                             BOM_COMPS.MIN_QTY,
                             BOM_COMPS.MAX_QTY,
                             BOM_COMPS.CHAR_1,
                             BOM_COMPS.CHAR_2,
                             BOM_COMPS.CODE,
                             BOM_COMPS.ALT_GROUP,
                             BOM_COMPS.ALT_PRIORITY,
                             BOM_COMPS.NUM_1,
                             BOM_COMPS.NUM_2,
                             BOM_COMPS.NUM_3,
                             BOM_COMPS.NUM_4,
                             BOM_COMPS.NUM_5,
                             BOM_COMPS.CHAR_3,
                             BOM_COMPS.CHAR_4,
                             BOM_COMPS.CHAR_5,
                             BOM_COMPS.DATE_1,
                             BOM_COMPS.DATE_2,
                             BOM_COMPS.CH_1,
                             BOM_COMPS.CH_REV_1,
                             BOM_COMPS.CH_2,
                             BOM_COMPS.CH_REV_2,
                             BOM_COMPS.CH_3,
                             BOM_COMPS.CH_REV_3,
                             BOM_COMPS.RELEVENCY_TO_COSTING,
                             BOM_COMPS.BULK_MATERIAL,
                             BOM_COMPS.BOOLEAN_1,
                             BOM_COMPS.BOOLEAN_2,
                             BOM_COMPS.BOOLEAN_3,
                             BOM_COMPS.BOOLEAN_4,
                             0,
                             LNACCESSSTOP,
                             0,
                             0 );

               LNRECURSIVECHECK := ISRECURSIVE( ANUNIQUEID,
                                                ANMOPCOUNT,
                                                ANSEQUENCE );

               IF LNRECURSIVECHECK = 1
               THEN
                  UPDATE ITBOMEXPLOSION
                     SET RECURSIVE_STOP = 1
                   WHERE BOM_EXP_NO = ANUNIQUEID
                     AND MOP_SEQUENCE_NO = ANMOPCOUNT
                     AND SEQUENCE_NO = ANSEQUENCE;
               END IF;

               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                       ASPARTNO
                                    || '->'
                                    || BOM_COMPS.COMPONENT_PART
                                    || ' Recursive ='
                                    || LNRECURSIVECHECK );





               IF     LSBOMEXISTS = 'Y'
                  AND ANMULTILEVEL = 1
                  AND LNRECURSIVECHECK = 0
                  AND LNACCESSSTOP = 0
               THEN




                  SELECT BASE_UOM
                    INTO LSBASEUOM
                    FROM PART
                   WHERE PART_NO = BOM_COMPS.COMPONENT_PART;

                  IF LSBASEUOM = BOM_COMPS.TO_UNIT
                  THEN
                     BEGIN
                        LNCALCULATEDQUANTITY :=   LNCALCULATEDQUANTITY
                                                * BOM_COMPS.CONV_FACTOR;
                        LNCALCULATEDQUANTITYWITHSCRAP :=   LNCALCULATEDQUANTITYWITHSCRAP
                                                         * BOM_COMPS.CONV_FACTOR;
                     EXCEPTION
                        WHEN VALUE_ERROR
                        THEN
                           RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                      LSMETHOD,
                                                                      IAPICONSTANTDBERROR.DBERR_INVALIDCALCQUANTITY );
                     END;
                  END IF;

                  LNRETVAL :=
                     EXPLODENEXTLEVEL( ANUNIQUEID,
                                       BOM_COMPS.COMPONENT_PART,
                                       LNREVISION,
                                       LSPLANT,   
                                       LNALTERNATIVE,
                                       LNBOMUSAGE,
                                       ANMULTILEVEL,
                                       ADEXPLOSIONDATE,
                                       LNLEVEL,
                                       ANSEQUENCE,
                                       LNCALCULATEDQUANTITY,
                                       LNCALCULATEDQUANTITYWITHSCRAP,
                                       ANINCLUDEINDEVELOPMENT,
                                       ANEXPLOSIONTYPE,
                                       ANUSEBOMPATH,
                                       
                                       
                                       
                                       ASPARTNO, 
                                       LNREVISION, 
                                       
                                       ASPRICETYPE,
                                       ASPERIOD,
                                       ASALTERNATIVEPRICETYPE,
                                       ASALTERNATIVEPERIOD,
                                       ANMOPCOUNT,
                                       ANPREVIOUSLEVEL,
                                       
                                       
                                       ASBASEUOM,
                                       ANPARENTCONVFACTOR,
                                       
                                        ANINCLUDEALTERNATIVES );
                                       

                  IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                  THEN
                     RETURN LNRETVAL;
                  END IF;
               END IF;
            END IF;
         END IF;
      END LOOP;

      
       
      
      IF NOT ASPRICETYPE IS NULL
      THEN
         SELECT COUNT( * )
           INTO LNPRICECHECK
           FROM PRICE_TYPE
          WHERE PRICE_TYPE = ASPRICETYPE;

         IF LNPRICECHECK = 0
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_INVALIDPRICETYPE,
                                                       ASPRICETYPE );
         END IF;

         FOR LREXPLOSIONROW IN LCPRICE
         LOOP
            BEGIN
               BEGIN
                  SELECT A.PRICE
                    INTO LNPRICE
                    FROM PART_COST A
                   WHERE A.PART_NO = LREXPLOSIONROW.COMPONENT_PART
                     AND A.PRICE_TYPE = ASPRICETYPE
                     AND A.PERIOD = ASPERIOD
                     AND A.PLANT = LREXPLOSIONROW.PLANT;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     LNPRICE := NULL;
               END;

               IF LNPRICE IS NULL
               THEN
                  SELECT NVL( A.PRICE,
                              0 )
                    INTO LNPRICE
                    FROM PART_COST A
                   WHERE A.PART_NO = LREXPLOSIONROW.COMPONENT_PART
                     AND A.PRICE_TYPE = ASALTERNATIVEPRICETYPE
                     AND A.PERIOD = ASALTERNATIVEPERIOD
                     AND A.PLANT = LREXPLOSIONROW.PLANT;

                  LSPRICETYPE := ASALTERNATIVEPRICETYPE;
               ELSE
                  LSPRICETYPE := ASPRICETYPE;
               END IF;

               UPDATE ITBOMEXPLOSION
                  SET COST = NVL(  (   LREXPLOSIONROW.CALC_QTY
                                     * LNPRICE ),
                                  0 ),
                      COST_WITH_SCRAP = NVL(  (   LREXPLOSIONROW.CALC_QTY_WITH_SCRAP
                                                * LNPRICE ),
                                             0 ),
                      ALT_PRICE_TYPE = DECODE( LSPRICETYPE,
                                               ASALTERNATIVEPRICETYPE, 1,
                                               0 )   
                WHERE BOM_EXP_NO = LREXPLOSIONROW.BOM_EXP_NO
                  AND MOP_SEQUENCE_NO = LREXPLOSIONROW.MOP_SEQUENCE_NO
                  AND SEQUENCE_NO = LREXPLOSIONROW.SEQUENCE_NO;
            EXCEPTION
               WHEN OTHERS
               THEN
                  
                  NULL;   
            END;
         END LOOP;

         SELECT MAX( BOM_LEVEL )
           INTO LNMAXLEVEL
           FROM ITBOMEXPLOSION
          WHERE BOM_EXP_NO = ANUNIQUEID
            AND MOP_SEQUENCE_NO = ANMOPCOUNT;

         UPDATE ITBOMEXPLOSION
            SET CALC_COST = NVL( COST,
                                 0 ),
                CALC_COST_WITH_SCRAP = NVL( COST_WITH_SCRAP,
                                            0 ),
                CALCULATED = 1
          WHERE BOM_EXP_NO = ANUNIQUEID
            AND BOM_LEVEL = LNMAXLEVEL
            AND MOP_SEQUENCE_NO = ANMOPCOUNT;

         WHILE LNMAXLEVEL > 1
         LOOP
            LNTOTAL := 0;
            LNTOTALWITHSCRAP := 0;
            LNTOTALCALCULATED := 0;
            LNTOTALCALCULATEDWITHSCRAP := 0;

            FOR LREXPLOSIONROW IN LCLEVEL( LNMAXLEVEL )
            LOOP
               IF LREXPLOSIONROW.BOM_LEVEL = LNMAXLEVEL
               THEN
                  
                  BEGIN
                     SELECT LREXPLOSIONROW.COST,
                            LREXPLOSIONROW.COST_WITH_SCRAP,
                            LREXPLOSIONROW.CALC_COST,
                            LREXPLOSIONROW.CALC_COST_WITH_SCRAP
                       INTO LNPRICE,
                            LNPRICEWITHSCRAP,
                            LNCALCULATEDPRICE,
                            LNCALCULATEDPRICEWITHSCRAP
                       FROM ITBOMEXPLOSION
                      WHERE BOM_EXP_NO = ANUNIQUEID
                        AND MOP_SEQUENCE_NO = LREXPLOSIONROW.MOP_SEQUENCE_NO
                        AND SEQUENCE_NO = LREXPLOSIONROW.SEQUENCE_NO;
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        LNPRICE := NULL;
                        LNPRICEWITHSCRAP := NULL;
                        LNCALCULATEDPRICE := NULL;
                        LNCALCULATEDPRICEWITHSCRAP := NULL;
                  END;

                  LNTOTAL :=   LNTOTAL
                             + NVL( LNPRICE,
                                    0 );
                  LNTOTALWITHSCRAP :=   LNTOTALWITHSCRAP
                                      + NVL( LNPRICEWITHSCRAP,
                                             0 );
                  LNTOTALCALCULATED :=   LNTOTALCALCULATED
                                       + NVL( LNCALCULATEDPRICE,
                                              0 );
                  LNTOTALCALCULATEDWITHSCRAP :=   LNTOTALCALCULATEDWITHSCRAP
                                                + NVL( LNCALCULATEDPRICEWITHSCRAP,
                                                       0 );
               ELSIF LREXPLOSIONROW.BOM_LEVEL < LNMAXLEVEL
               THEN
                  
                  
                  BEGIN
                     SELECT BOM_LEVEL
                       INTO LNUPDLEVEL
                       FROM ITBOMEXPLOSION
                      WHERE BOM_EXP_NO = ANUNIQUEID
                        AND MOP_SEQUENCE_NO = LREXPLOSIONROW.MOP_SEQUENCE_NO
                        AND SEQUENCE_NO =   LREXPLOSIONROW.SEQUENCE_NO
                                          + 10;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        LNUPDLEVEL := 0;
                  END;

                  IF LNUPDLEVEL > LREXPLOSIONROW.BOM_LEVEL
                  THEN
                     UPDATE ITBOMEXPLOSION
                        SET CALC_COST = NVL( LNTOTALCALCULATED,
                                             0 ),
                            CALC_COST_WITH_SCRAP = NVL( LNTOTALCALCULATEDWITHSCRAP,
                                                        0 )
                      WHERE BOM_EXP_NO = ANUNIQUEID
                        AND MOP_SEQUENCE_NO = LREXPLOSIONROW.MOP_SEQUENCE_NO
                        AND SEQUENCE_NO = LREXPLOSIONROW.SEQUENCE_NO;
                  ELSE
                     UPDATE ITBOMEXPLOSION
                        SET CALC_COST = NVL( COST,
                                             0 ),
                            CALC_COST_WITH_SCRAP = NVL( COST_WITH_SCRAP,
                                                        0 )
                      WHERE BOM_EXP_NO = ANUNIQUEID
                        AND MOP_SEQUENCE_NO = LREXPLOSIONROW.MOP_SEQUENCE_NO
                        AND SEQUENCE_NO = LREXPLOSIONROW.SEQUENCE_NO;

                     UPDATE ITBOMEXPLOSION
                        SET CALCULATED = 1
                      WHERE BOM_EXP_NO = ANUNIQUEID
                        AND MOP_SEQUENCE_NO = LREXPLOSIONROW.MOP_SEQUENCE_NO
                        AND SEQUENCE_NO = LREXPLOSIONROW.SEQUENCE_NO;
                  END IF;

                  IF LREXPLOSIONROW.ALT_PRICE_TYPE IS NULL
                  THEN
                     UPDATE ITBOMEXPLOSION
                        SET COST = NVL( LNTOTAL,
                                        0 ),
                            COST_WITH_SCRAP = NVL( LNTOTALWITHSCRAP,
                                                   0 )
                      WHERE BOM_EXP_NO = ANUNIQUEID
                        AND MOP_SEQUENCE_NO = LREXPLOSIONROW.MOP_SEQUENCE_NO
                        AND SEQUENCE_NO = LREXPLOSIONROW.SEQUENCE_NO;

                     UPDATE ITBOMEXPLOSION
                        SET CALCULATED = 1
                      WHERE BOM_EXP_NO = ANUNIQUEID
                        AND MOP_SEQUENCE_NO = LREXPLOSIONROW.MOP_SEQUENCE_NO
                        AND SEQUENCE_NO = LREXPLOSIONROW.SEQUENCE_NO;
                  END IF;

                  LNTOTAL := 0;
                  LNTOTALWITHSCRAP := 0;
                  LNTOTALCALCULATED := 0;
                  LNTOTALCALCULATEDWITHSCRAP := 0;
               END IF;
            
            END LOOP;

            LNMAXLEVEL :=   LNMAXLEVEL
                          - 1;
         END LOOP;
      END IF;

      ANPREVIOUSLEVEL := LNLEVEL;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXPLODENEXTLEVEL;

   
   FUNCTION EXPLODE(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE,
      ANMULTILEVEL               IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1,
      ADEXPLOSIONDATE            IN       IAPITYPE.DATE_TYPE DEFAULT SYSDATE,
      ANBATCHQUANTITY            IN       IAPITYPE.BOMQUANTITY_TYPE DEFAULT 100,
      ANINCLUDEINDEVELOPMENT     IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANUSEMOP                   IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANUSEBOMPATH               IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANEXPLOSIONTYPE            IN       IAPITYPE.NUMVAL_TYPE DEFAULT IAPICONSTANT.EXPLOSION_STANDARD,
      ASPRICETYPE                IN       IAPITYPE.PRICETYPE_TYPE DEFAULT NULL,
      ASPERIOD                   IN       IAPITYPE.PERIOD_TYPE DEFAULT NULL,
      ASALTERNATIVEPRICETYPE     IN       IAPITYPE.PRICETYPE_TYPE DEFAULT NULL,
      ASALTERNATIVEPERIOD        IN       IAPITYPE.PERIOD_TYPE DEFAULT NULL,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE,
      
      ANINCLUDEALTERNATIVES     IN      IAPITYPE.BOOLEAN_TYPE DEFAULT 0)
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS





































      LDDATE                        IAPITYPE.DATE_TYPE;
      LNPREVIOUSLEVEL               PLS_INTEGER := 0;
      LNMULTILEVEL                  IAPITYPE.BOOLEAN_TYPE;
      LSINDEV                       VARCHAR2( 1 );
      LSDESCRIPTION                 IAPITYPE.DESCRIPTION_TYPE;
      LNPARTSOURCE                  IAPITYPE.PARTSOURCE_TYPE;
      LSUOM                         IAPITYPE.BASEUOM_TYPE;
      LNPARTTYPE                    IAPITYPE.ID_TYPE;
      LNSEQUENCE                    IAPITYPE.SEQUENCE_TYPE DEFAULT 10;
      LNMOPREVISION                 IAPITYPE.REVISION_TYPE;
      LDDATE1                       IAPITYPE.DATE_TYPE;
      LDDATE2                       IAPITYPE.DATE_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Explode';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNMOPCOUNT                    PLS_INTEGER DEFAULT 0;
      LNCOUNT                       PLS_INTEGER DEFAULT 0;
      LNCONVFACTOR                  IAPITYPE.NUMVAL_TYPE;
      LSTOUNIT                      IAPITYPE.DESCRIPTION_TYPE;
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LSPLANT                       IAPITYPE.PLANT_TYPE;
      LNALTERNATIVE                 IAPITYPE.BOMALTERNATIVE_TYPE;
      LNUSAGE                       IAPITYPE.BOMUSAGE_TYPE;
      LNBATCHQUANTITY               IAPITYPE.BOMQUANTITY_TYPE DEFAULT 100;
      
      LNPLANTCHECK                  NUMBER(3);
      
      LNPARENTCONVFACTOR            FLOAT DEFAULT 1;
      
      LNBOMSEQNO                    IAPITYPE.SEQUENCENR_TYPE;
      
      CURSOR LCMOP
      IS
         SELECT DISTINCT Q.PART_NO,
                         Q.REVISION,
                         HD.PLANT,
                         HD.ALTERNATIVE,
                         HD.BASE_QUANTITY BATCH_QTY,
                         HD.BOM_USAGE,
                         HD.CONV_FACTOR,
                         HD.TO_UNIT
                    FROM ITSHQ Q,
                         BOM_HEADER HD
                   WHERE Q.USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
                     AND Q.PART_NO = HD.PART_NO
                     AND Q.REVISION = HD.REVISION;
   BEGIN
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.VIEWBOMALLOWED = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOVIEWBOMACCESS,
                                                    IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Pre-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
       
      GRBOMEXPLOSION.BOMEXPLOSIONNO := ANUNIQUEID;
      
      GRBOMEXPLOSION.PARTNO := ASPARTNO;
      GRBOMEXPLOSION.REVISION := ANREVISION;
    
    GRBOMEXPLOSION.MULTILEVEL := ANMULTILEVEL;
    GRBOMEXPLOSION.EXPLOSIONDATE := ADEXPLOSIONDATE;
    GRBOMEXPLOSION.INCLUDEINDEVELOPMENT := ANINCLUDEINDEVELOPMENT;
    GRBOMEXPLOSION.USEMOP := ANUSEMOP;
    GRBOMEXPLOSION.USEBOMPATH := ANUSEBOMPATH;
    GRBOMEXPLOSION.EXPLOSIONTYPE := ANEXPLOSIONTYPE;
    GRBOMEXPLOSION.PRICETYPE := ASPRICETYPE;
    GRBOMEXPLOSION.PERIOD := ASPERIOD;
    GRBOMEXPLOSION.ALTERNATIVEPRICETYPE := ASALTERNATIVEPRICETYPE;
    GRBOMEXPLOSION.ALTERNATIVEPERIODE := ASALTERNATIVEPERIOD;
    
      GRBOMEXPLOSION.PLANT := ASPLANT;
      GRBOMEXPLOSION.ALTERNATIVE := ANALTERNATIVE;
      GRBOMEXPLOSION.BOMUSAGE := ANUSAGE;
      GRBOMEXPLOSION.QUANTITY := ANBATCHQUANTITY;
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
      
      LNBOMSEQNO := GRBOMEXPLOSION.BOMEXPLOSIONNO;
      
      LSPARTNO := GRBOMEXPLOSION.PARTNO;
      LNREVISION := GRBOMEXPLOSION.REVISION;
      LSPLANT := GRBOMEXPLOSION.PLANT;
      LNALTERNATIVE := GRBOMEXPLOSION.ALTERNATIVE;
      LNUSAGE := GRBOMEXPLOSION.BOMUSAGE;
      LNBATCHQUANTITY := GRBOMEXPLOSION.QUANTITY;

      IF     LSPARTNO IS NOT NULL
         AND LNREVISION IS NOT NULL
      THEN
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM SPECIFICATION_HEADER
          WHERE PART_NO = LSPARTNO
            AND REVISION = LNREVISION;

         
         IF LNCOUNT = 0
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_SPECIFICATIONNOTFOUND,
                                                       LSPARTNO,
                                                       LNREVISION );
         END IF;


         LNRETVAL := CHECKVIEWACCESS( LSPARTNO,
                                      LNREVISION );

         IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
         THEN
            RETURN LNRETVAL;
         END IF;
      END IF;

      LNMULTILEVEL := ANMULTILEVEL;

      IF NOT ASPRICETYPE IS NULL
      THEN
         LNMULTILEVEL := 1;
      END IF;

      IF ANINCLUDEINDEVELOPMENT = 1
      THEN
         LSINDEV := 'Y';
      ELSE
         LSINDEV := 'N';
      END IF;

      
      DELETE FROM ITBOMEXPLOSION
            WHERE BOM_EXP_NO = ANUNIQUEID;

      DELETE FROM ITATTEXPLOSION
            WHERE BOM_EXP_NO = ANUNIQUEID;

      DELETE FROM ITINGEXPLOSION
            WHERE BOM_EXP_NO = ANUNIQUEID;

      DELETE FROM ITNUTPATH
            WHERE BOM_EXP_NO = ANUNIQUEID;

      DELETE FROM ITNUTEXPLOSION
            WHERE BOM_EXP_NO = ANUNIQUEID;

      DELETE FROM ITNUTRESULT
            WHERE BOM_EXP_NO = ANUNIQUEID;

      DELETE FROM ITNUTRESULTDETAIL
            WHERE BOM_EXP_NO = ANUNIQUEID;

      
      SELECT   ADEXPLOSIONDATE
             + 1
             - (   1
                 / 86400 )
        INTO LDDATE
        FROM DUAL;

      LNPREVIOUSLEVEL := 0;

      IF ANUSEMOP = 1
      THEN
         
         FOR LRMOP IN LCMOP
         LOOP
            SELECT NVL( F_SH_DESCR( 1,
                                    LRMOP.PART_NO,
                                    LRMOP.REVISION ),
                        ' - ' ),
                   PART_SOURCE,
                   BASE_UOM,
                   PART_TYPE,
                   BASE_CONV_FACTOR,
                   BASE_TO_UNIT
              INTO LSDESCRIPTION,
                   LNPARTSOURCE,
                   LSUOM,
                   LNPARTTYPE,
                   LNCONVFACTOR,
                   LSTOUNIT
              FROM PART
             WHERE PART_NO = LRMOP.PART_NO;

            IF LSPLANT IS NOT NULL
            THEN   
               LNCONVFACTOR := LRMOP.CONV_FACTOR;
               LSTOUNIT := LRMOP.TO_UNIT;
            END IF;

            
            IF LDDATE < SYSDATE
            THEN
               LNMOPREVISION := F_RETURN_REV( LRMOP.PART_NO,
                                              
                                              
                                              
                                              999,
                                              
                                              'p',
                                              LDDATE,
                                              LDDATE1,
                                              LDDATE2,
                                              LSINDEV );
            ELSE
               LNMOPREVISION := F_RETURN_REV( LRMOP.PART_NO,
                                              0,
                                              'n',
                                              LDDATE,
                                              LDDATE1,
                                              LDDATE2,
                                              LSINDEV );
            END IF;

            IF LNMOPREVISION = -1
            THEN
               LNMOPREVISION := LRMOP.REVISION;
            END IF;

            
            
            SELECT COUNT(*)
            INTO LNPLANTCHECK
            FROM BOM_HEADER
            WHERE PART_NO = LRMOP.PART_NO
                AND REVISION = LNMOPREVISION
                AND PLANT = LRMOP.PLANT;

            IF LNPLANTCHECK <> 0
            THEN
                

                IAPIGENERAL.LOGINFO( GSSOURCE,
                                     LSMETHOD,
                                        'Exploded MOP: '
                                     || LRMOP.PART_NO
                                     || ' ['
                                     || LNMOPREVISION
                                     || '] '
                                     || LRMOP.PLANT
                                     || '-'
                                     || LRMOP.ALTERNATIVE
                                     || '-'
                                     || LRMOP.BOM_USAGE );
                LNSEQUENCE := 10;
                LNMOPCOUNT :=   LNMOPCOUNT
                              + 1;

                
                INSERT INTO ITBOMEXPLOSION
                            ( BOM_EXP_NO,
                              MOP_SEQUENCE_NO,
                              SEQUENCE_NO,
                              BOM_LEVEL,
                              COMPONENT_PART,
                              COMPONENT_REVISION,
                              DESCRIPTION,
                              PLANT,
                              ALTERNATIVE,
                              USAGE,
                              UOM,
                              QTY,
                              SCRAP,
                              CALC_QTY,
                              CALC_QTY_WITH_SCRAP,
                              ISSUE_LOCATION,
                              PART_SOURCE,
                              TO_UNIT,
                              CONV_FACTOR,
                              PHANTOM,
                              INGREDIENT,
                              PART_TYPE,
                              COST,
                              COST_WITH_SCRAP )
                     VALUES ( ANUNIQUEID,
                              LNMOPCOUNT,
                              LNSEQUENCE,
                              0,
                              LRMOP.PART_NO,
                              LNMOPREVISION,
                              LSDESCRIPTION,
                              LRMOP.PLANT,
                              LRMOP.ALTERNATIVE,
                              LRMOP.BOM_USAGE,
                              LSUOM,
                              LRMOP.BATCH_QTY,
                              0,
                              LRMOP.BATCH_QTY,
                              LRMOP.BATCH_QTY,
                              NULL,
                              LNPARTSOURCE,
                              LSTOUNIT,
                              LNCONVFACTOR,
                              1,
                              0,
                              LNPARTTYPE,
                              0,
                              0 );

                
                
                
                
                LNPARENTCONVFACTOR := 1;
                
                

                LNRETVAL :=
                   EXPLODENEXTLEVEL( ANUNIQUEID,
                                     LRMOP.PART_NO,
                                     LNMOPREVISION,
                                     LRMOP.PLANT,
                                     LRMOP.ALTERNATIVE,
                                     LRMOP.BOM_USAGE,
                                     LNMULTILEVEL,
                                     LDDATE,
                                     0,
                                     LNSEQUENCE,
                                     LRMOP.BATCH_QTY,
                                     LRMOP.BATCH_QTY,
                                     ANINCLUDEINDEVELOPMENT,
                                     ANEXPLOSIONTYPE,
                                     ANUSEBOMPATH,
                                     LSPARTNO,
                                     LNREVISION,
                                     ASPRICETYPE,
                                     ASPERIOD,
                                     ASALTERNATIVEPRICETYPE,
                                     ASALTERNATIVEPERIOD,
                                     LNMOPCOUNT,
                                     LNPREVIOUSLEVEL,
                                     
                                     
                                     LSUOM,
                                     LNPARENTCONVFACTOR,
                                       
                                      ANINCLUDEALTERNATIVES);
                                     

                IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                THEN
                   RETURN LNRETVAL;
                END IF;

            
            END IF;
            

         END LOOP;
      
      ELSE   
         
         IF LNBATCHQUANTITY IS NULL
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                            'Quantity ' );
            RETURN LNRETVAL;
         END IF;

         SELECT LENGTH( TRUNC( ROUND( LNBATCHQUANTITY,
                                      6 ) ) )
           INTO LNCOUNT
           FROM DUAL;

         IF LNCOUNT > 10
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_INVALIDCALCQUANTITY );
         END IF;

         LNRETVAL := IAPISPECIFICATIONACCESS.GETVIEWACCESS( LSPARTNO,
                                                            LNREVISION,
                                                            LNACCESS );

         IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
         THEN
            RETURN LNRETVAL;
         END IF;

         IF LNACCESS = 0
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_NOVIEWACCESS,
                                                       ASPARTNO,
                                                       LNREVISION );
         END IF;

         IF IAPIGENERAL.SESSION.APPLICATIONUSER.VIEWBOMALLOWED = 0
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_NOVIEWBOMACCESS,
                                                       IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );
         END IF;

         
         BEGIN
            SELECT SECTION_ID,
                   SUB_SECTION_ID
              INTO LNSECTIONID,
                   LNSUBSECTIONID
              FROM SPECIFICATION_SECTION
             WHERE PART_NO = LSPARTNO
               AND REVISION = LNREVISION
               AND TYPE = IAPICONSTANT.SECTIONTYPE_BOM;

            IF F_CHECK_ITEM_ACCESS( LSPARTNO,
                                    LNREVISION,
                                    LNSECTIONID,
                                    LNSUBSECTIONID,
                                    IAPICONSTANT.SECTIONTYPE_BOM ) = 0
            THEN
               
               
               
               
               
               
               
               
               
               
               
               
               
               
                
               LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                               LSMETHOD,
                                                               IAPICONSTANTDBERROR.DBERR_NOVIEWSECTIONACCESS,
                                                               LSPARTNO,
                                                               LNREVISION,
                                                               F_SCH_DESCR( NULL,
                                                                            LNSECTIONID,
                                                                            0 ),
                                                               F_SBH_DESCR( NULL,
                                                                            LNSUBSECTIONID,
                                                                            0 ),
                                                              'BOM' );

               LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'BOM',
                                                       IAPIGENERAL.GETLASTERRORTEXT( ),
                                                       GTERRORS );

               
               LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                      AQERRORS );
               RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
               

            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         
         SELECT NVL( F_SH_DESCR( 1,
                                 LSPARTNO,
                                 LNREVISION ),
                     ' - ' ),
                PART_SOURCE,
                BASE_UOM,
                PART_TYPE,
                BASE_CONV_FACTOR,
                BASE_TO_UNIT
           INTO LSDESCRIPTION,
                LNPARTSOURCE,
                LSUOM,
                LNPARTTYPE,
                LNCONVFACTOR,
                LSTOUNIT
           FROM PART
          WHERE PART_NO = LSPARTNO;

         IF LSPLANT IS NOT NULL
         THEN   
            BEGIN
               SELECT CONV_FACTOR,
                      TO_UNIT
                 INTO LNCONVFACTOR,
                      LSTOUNIT
                 FROM BOM_HEADER
                WHERE PART_NO = LSPARTNO
                  AND REVISION = LNREVISION
                  AND PLANT = LSPLANT
                  AND ALTERNATIVE = LNALTERNATIVE
                  AND BOM_USAGE = LNUSAGE;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  LNCONVFACTOR := NULL;
                  LSTOUNIT := NULL;
            END;
         END IF;

        
        IF LDDATE < SYSDATE
        THEN
           LNMOPREVISION := F_RETURN_REV( LSPARTNO,
                                          
                                          
                                          999,
                                          
                                          'p',
                                          LDDATE,
                                          LDDATE1,
                                          LDDATE2,
                                          LSINDEV );
        ELSE
           LNMOPREVISION := F_RETURN_REV( LSPARTNO,
                                          0,
                                          'n',
                                          LDDATE,
                                          LDDATE1,
                                          LDDATE2,
                                          LSINDEV );
        END IF;

        
        
        
        
        
        
        
        
        
        IF LNMOPREVISION = 0
        THEN
           LNREVISION := 0;
        END IF;
        

        
        IF LNMOPREVISION = -1
        THEN
           
           LNREVISION := 0;
        END IF;
        

        

         
         INSERT INTO ITBOMEXPLOSION
                     ( BOM_EXP_NO,
                       SEQUENCE_NO,
                       BOM_LEVEL,
                       COMPONENT_PART,
                       COMPONENT_REVISION,
                       DESCRIPTION,
                       PLANT,
                       ALTERNATIVE,
                       USAGE,
                       UOM,
                       QTY,
                       SCRAP,
                       CALC_QTY,
                       CALC_QTY_WITH_SCRAP,
                       ISSUE_LOCATION,
                       PART_SOURCE,
                       TO_UNIT,
                       CONV_FACTOR,
                       PHANTOM,
                       INGREDIENT,
                       PART_TYPE,
                       COST,
                       COST_WITH_SCRAP )
              VALUES ( ANUNIQUEID,
                       LNSEQUENCE,
                       0,
                       LSPARTNO,
                       LNREVISION,
                       LSDESCRIPTION,
                       LSPLANT,
                       LNALTERNATIVE,
                       LNUSAGE,
                       LSUOM,
                       LNBATCHQUANTITY,
                       0,
                       LNBATCHQUANTITY,
                       LNBATCHQUANTITY,
                       NULL,
                       LNPARTSOURCE,
                       LSTOUNIT,
                       LNCONVFACTOR,
                       1,
                       0,
                       LNPARTTYPE,
                       0,
                       0 );


         
         
         
         
         LNPARENTCONVFACTOR := 1;
         
         

         
         

         LNRETVAL :=
            EXPLODENEXTLEVEL( ANUNIQUEID,
                              LSPARTNO,
                              LNREVISION,
                              LSPLANT,
                              LNALTERNATIVE,
                              LNUSAGE,
                              LNMULTILEVEL,
                              LDDATE,
                              0,
                              LNSEQUENCE,
                              LNBATCHQUANTITY,
                              LNBATCHQUANTITY,
                              ANINCLUDEINDEVELOPMENT,
                              ANEXPLOSIONTYPE,
                              ANUSEBOMPATH,
                              LSPARTNO,
                              LNREVISION,
                              ASPRICETYPE,
                              ASPERIOD,
                              ASALTERNATIVEPRICETYPE,
                              ASALTERNATIVEPERIOD,
                              1,
                              LNPREVIOUSLEVEL,
                              
                              
                              LSUOM,
                              LNPARENTCONVFACTOR,
                               
                                ANINCLUDEALTERNATIVES);
                              


         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN LNRETVAL;
         END IF;
      END IF;

      IF ANEXPLOSIONTYPE IN
            ( IAPICONSTANT.EXPLOSION_INGREDIENT,
              IAPICONSTANT.EXPLOSION_INGREDIENTMIX,
              IAPICONSTANT.EXPLOSION_NUTRITIONAL,
              IAPICONSTANT.EXPLOSION_CLAIMS,
              IAPICONSTANT.EXPLOSION_ASSOLD,
              IAPICONSTANT.EXPLOSION_ASBOUGHT )
      THEN
         FOR I IN ( SELECT DISTINCT MOP_SEQUENCE_NO
                              FROM ITBOMEXPLOSION
                             WHERE BOM_EXP_NO = ANUNIQUEID )
         LOOP
            LNRETVAL := IAPISPECIFICATIONBOM.RECURSIVECALCQTY( ANUNIQUEID,
                                                               I.MOP_SEQUENCE_NO );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
               RETURN LNRETVAL;
            END IF;
         END LOOP;
      END IF;

      
      IF ANEXPLOSIONTYPE = IAPICONSTANT.EXPLOSION_ATTACHED
      THEN
         LNRETVAL := EXPLODEATTACHEDSPECS( ANUNIQUEID,
                                           LDDATE,
                                           ANINCLUDEINDEVELOPMENT );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN LNRETVAL;
         END IF;
      END IF;

      
      IF ANEXPLOSIONTYPE = IAPICONSTANT.EXPLOSION_NUTRITIONAL
      THEN
         LNRETVAL := EXPLODENUTRITIONAL( ANUNIQUEID,
                                         AQERRORS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN LNRETVAL;
         END IF;
      END IF;

      IF ANEXPLOSIONTYPE IN( IAPICONSTANT.EXPLOSION_INGREDIENT, IAPICONSTANT.EXPLOSION_INGREDIENTMIX )
      THEN
         LNRETVAL := EXPLODEINGREDIENTS( ANUNIQUEID );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN LNRETVAL;
         END IF;

         SELECT COUNT( * )
           INTO LNCOUNT
           FROM ITBOMEXPLOSION
          WHERE BOM_EXP_NO = ANUNIQUEID
            AND ACCESS_STOP = 1;

         IF LNCOUNT > 0
         THEN
             
            
            LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_EXPLOSIONNOACCESS,
                                                  LSPARTNO,
                                                  LNREVISION );
            LNRETVAL :=
               IAPIGENERAL.ADDERRORTOLIST( IAPICONSTANTDBERROR.DBERR_EXPLOSIONNOACCESS,
                                           IAPIGENERAL.GETLASTERRORTEXT( ),
                                           GTERRORS,
                                           IAPICONSTANT.ERRORMESSAGE_WARNING );
            LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                   AQERRORS );
         END IF;
      END IF;
      
      GRBOMEXPLOSION.BOMEXPLOSIONNO := LNBOMSEQNO;
      
      GRBOMEXPLOSION.PARTNO := LSPARTNO;
      GRBOMEXPLOSION.REVISION := LNREVISION;
      
      GRBOMEXPLOSION.MULTILEVEL := ANMULTILEVEL;
      GRBOMEXPLOSION.EXPLOSIONDATE := ADEXPLOSIONDATE;
      GRBOMEXPLOSION.INCLUDEINDEVELOPMENT := ANINCLUDEINDEVELOPMENT;
      GRBOMEXPLOSION.USEMOP := ANUSEMOP;
      GRBOMEXPLOSION.USEBOMPATH := ANUSEBOMPATH;
      GRBOMEXPLOSION.EXPLOSIONTYPE := ANEXPLOSIONTYPE;
      GRBOMEXPLOSION.PRICETYPE := ASPRICETYPE;
      GRBOMEXPLOSION.PERIOD := ASPERIOD;
      GRBOMEXPLOSION.ALTERNATIVEPRICETYPE := ASALTERNATIVEPRICETYPE;
      GRBOMEXPLOSION.ALTERNATIVEPERIODE := ASALTERNATIVEPERIOD;
      
      GRBOMEXPLOSION.PLANT := LSPLANT;
      GRBOMEXPLOSION.ALTERNATIVE := LNALTERNATIVE;
      GRBOMEXPLOSION.BOMUSAGE := LNUSAGE;
      GRBOMEXPLOSION.QUANTITY := LNBATCHQUANTITY;
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Call CUSTOM Pre-Action',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.EXECUTECUSTOMFUNCTION( GSSOURCE,
                                                     LSMETHOD,
                                                     'POST',
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

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXPLODE;


   FUNCTION GETEXPLOSION(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      AQITEMS                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetExplosion';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSSQL                         VARCHAR2( 8192 );
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=
            'SELECT B.MOP_SEQUENCE_NO '
         || IAPICONSTANTCOLUMN.MOPSEQUENCECOL
         || ', B.SEQUENCE_NO '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ', B.BOM_LEVEL '
         || IAPICONSTANTCOLUMN.BOMLEVELCOL
         || ', B.COMPONENT_PART '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', B.COMPONENT_REVISION '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', B.DESCRIPTION '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ', B.PLANT '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', B.UOM '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ', B.QTY '
         || IAPICONSTANTCOLUMN.QUANTITYCOL
         || ', B.SCRAP '
         || IAPICONSTANTCOLUMN.SCRAPCOL
         || ', B.CALC_QTY '
         || IAPICONSTANTCOLUMN.CALCULATEDQUANTITYCOL
         || ', B.CALC_QTY_WITH_SCRAP '
         || IAPICONSTANTCOLUMN.CALCULATEDQUANTITYWITHSCRAPCOL
         || ', round(B.COST,10) '
         || IAPICONSTANTCOLUMN.COSTCOL
         || ', round(B.COST_WITH_SCRAP,10) '
         || IAPICONSTANTCOLUMN.COSTWITHSCRAPCOL
         || ', round(B.CALC_COST,10) '
         || IAPICONSTANTCOLUMN.CALCULATEDCOSTCOL
         || ', round(B.CALC_COST_WITH_SCRAP,10) '
         || IAPICONSTANTCOLUMN.CALCULATEDCOSTWITHSCRAPCOL
         || ', B.PART_SOURCE '
         || IAPICONSTANTCOLUMN.PARTSOURCECOL
         || ', B.TO_UNIT '
         || IAPICONSTANTCOLUMN.TOUNITCOL
         || ', round(B.CONV_FACTOR,10) '
         || IAPICONSTANTCOLUMN.CONVERSIONFACTORCOL
         || ', B.PHANTOM '
         || IAPICONSTANTCOLUMN.PHANTOMCOL
         || ', B.INGREDIENT '
         || IAPICONSTANTCOLUMN.INGREDIENTCOL
         || ', NVL(B.ALT_PRICE_TYPE, 0) '
         || IAPICONSTANTCOLUMN.ALTERNATIVEPRICECOL
         || ', B.PART_TYPE '
         || IAPICONSTANTCOLUMN.PARTTYPEIDCOL
         || ', C.DESCRIPTION '
         || IAPICONSTANTCOLUMN.PARTTYPECOL
         || ', B.ALTERNATIVE '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', B.USAGE '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', B.ASSEMBLY_SCRAP '
         || IAPICONSTANTCOLUMN.ASSEMBLYSCRAPCOL
         || ', B.COMPONENT_SCRAP '
         || IAPICONSTANTCOLUMN.COMPONENTSCRAPCOL
         || ', B.LEAD_TIME_OFFSET '
         || IAPICONSTANTCOLUMN.LEADTIMEOFFSETCOL
         || ', B.ITEM_CATEGORY '
         || IAPICONSTANTCOLUMN.ITEMCATEGORYCOL
         || ', B.ISSUE_LOCATION '
         || IAPICONSTANTCOLUMN.ISSUELOCATIONCOL
         || ', B.BOM_ITEM_TYPE '
         || IAPICONSTANTCOLUMN.BOMTYPECOL
         || ', B.OPERATIONAL_STEP '
         || IAPICONSTANTCOLUMN.OPERATIONALSTEPCOL
         || ', B.MIN_QTY '
         || IAPICONSTANTCOLUMN.MINIMUMQUANTITYCOL
         || ', B.MAX_QTY '
         || IAPICONSTANTCOLUMN.MAXIMUMQUANTITYCOL
         || ', B.CODE '
         || IAPICONSTANTCOLUMN.CODECOL
         || ', B.ALT_GROUP '
         || IAPICONSTANTCOLUMN.BOMALTGROUPCOL
         || ', B.ALT_PRIORITY '
         || IAPICONSTANTCOLUMN.BOMALTPRIORITYCOL
         || ', B.CHAR_1 '
         || IAPICONSTANTCOLUMN.STRING1COL
         || ', B.CHAR_2 '
         || IAPICONSTANTCOLUMN.STRING2COL
         || ', B.CHAR_3 '
         || IAPICONSTANTCOLUMN.STRING3COL
         || ', B.CHAR_4 '
         || IAPICONSTANTCOLUMN.STRING4COL
         || ', B.CHAR_5 '
         || IAPICONSTANTCOLUMN.STRING5COL
         || ', round(B.NUM_1,10) '
         || IAPICONSTANTCOLUMN.NUMERIC1COL
         || ', round(B.NUM_2,10) '
         || IAPICONSTANTCOLUMN.NUMERIC2COL
         || ', round(B.NUM_3,10) '
         || IAPICONSTANTCOLUMN.NUMERIC3COL
         || ', round(B.NUM_4,10) '
         || IAPICONSTANTCOLUMN.NUMERIC4COL
         || ', round(B.NUM_5,10) '
         || IAPICONSTANTCOLUMN.NUMERIC5COL
         || ', B.Boolean_1 '
         || IAPICONSTANTCOLUMN.BOOLEAN1COL
         || ', B.Boolean_2 '
         || IAPICONSTANTCOLUMN.BOOLEAN2COL
         || ', B.Boolean_3 '
         || IAPICONSTANTCOLUMN.BOOLEAN3COL
         || ', B.Boolean_4 '
         || IAPICONSTANTCOLUMN.BOOLEAN4COL
         || ', B.DATE_1 '
         || IAPICONSTANTCOLUMN.DATE1COL
         || ', B.DATE_2 '
         || IAPICONSTANTCOLUMN.DATE2COL
         || ', f_chh_descr(0,B.CH_1, B.CH_REV_1) '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION1COL
         || ', f_chh_descr(0,B.CH_2, B.CH_REV_2) '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION2COL
         || ', f_chh_descr(0,B.CH_3, B.CH_REV_3) '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION3COL
         || ', B.RELEVENCY_TO_COSTING '
         || IAPICONSTANTCOLUMN.RELEVANCYTOCOSTINGCOL
         || ', B.BULK_MATERIAL '
         || IAPICONSTANTCOLUMN.BULKMATERIALCOL
         || ', B.RECURSIVE_STOP '
         || IAPICONSTANTCOLUMN.RECURSIVESTOPCOL
         || ', B.ACCESS_STOP '
         || IAPICONSTANTCOLUMN.ACCESSSTOPCOL
         || ' FROM ITBOMEXPLOSION B, CLASS3 C'
         || ' WHERE B.BOM_EXP_NO = :anUniqueId'
         || ' AND C.CLASS = B.PART_TYPE'
         || ' ORDER BY B.MOP_SEQUENCE_NO, B.SEQUENCE_NO';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      OPEN AQITEMS FOR LSSQL USING ANUNIQUEID;

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         OPEN AQITEMS FOR LSSQL USING -1;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETEXPLOSION;

   




   FUNCTION GETEXPLOSIONEXT(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      AQITEMS                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetExplosionExt';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSSQL                         VARCHAR2( 8192 );
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=
            'SELECT B.MOP_SEQUENCE_NO '
         || IAPICONSTANTCOLUMN.MOPSEQUENCECOL
         || ', B.SEQUENCE_NO '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ', B.BOM_LEVEL '
         || IAPICONSTANTCOLUMN.BOMLEVELCOL
         || ', B.COMPONENT_PART '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', B.COMPONENT_REVISION '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', B.DESCRIPTION '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ', B.PLANT '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', B.UOM '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ', B.QTY '
         || IAPICONSTANTCOLUMN.QUANTITYCOL
         || ', B.SCRAP '
         || IAPICONSTANTCOLUMN.SCRAPCOL
         || ', B.CALC_QTY '
         || IAPICONSTANTCOLUMN.CALCULATEDQUANTITYCOL
         || ', B.CALC_QTY_WITH_SCRAP '
         || IAPICONSTANTCOLUMN.CALCULATEDQUANTITYWITHSCRAPCOL
         || ', round(B.COST,10) '
         || IAPICONSTANTCOLUMN.COSTCOL
         || ', round(B.COST_WITH_SCRAP,10) '
         || IAPICONSTANTCOLUMN.COSTWITHSCRAPCOL
         || ', round(B.CALC_COST,10) '
         || IAPICONSTANTCOLUMN.CALCULATEDCOSTCOL
         || ', round(B.CALC_COST_WITH_SCRAP,10) '
         || IAPICONSTANTCOLUMN.CALCULATEDCOSTWITHSCRAPCOL
         || ', B.PART_SOURCE '
         || IAPICONSTANTCOLUMN.PARTSOURCECOL
         || ', B.TO_UNIT '
         || IAPICONSTANTCOLUMN.TOUNITCOL
         || ', round(B.CONV_FACTOR,10) '
         || IAPICONSTANTCOLUMN.CONVERSIONFACTORCOL
         || ', B.PHANTOM '
         || IAPICONSTANTCOLUMN.PHANTOMCOL
         || ', B.INGREDIENT '
         || IAPICONSTANTCOLUMN.INGREDIENTCOL
         || ', NVL(B.ALT_PRICE_TYPE, 0) '
         || IAPICONSTANTCOLUMN.ALTERNATIVEPRICECOL
         || ', B.PART_TYPE '
         || IAPICONSTANTCOLUMN.PARTTYPEIDCOL
         || ', C.DESCRIPTION '
         || IAPICONSTANTCOLUMN.PARTTYPECOL
         || ', B.ALTERNATIVE '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', B.USAGE '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', B.ASSEMBLY_SCRAP '
         || IAPICONSTANTCOLUMN.ASSEMBLYSCRAPCOL
         || ', B.COMPONENT_SCRAP '
         || IAPICONSTANTCOLUMN.COMPONENTSCRAPCOL
         || ', B.LEAD_TIME_OFFSET '
         || IAPICONSTANTCOLUMN.LEADTIMEOFFSETCOL
         || ', B.ITEM_CATEGORY '
         || IAPICONSTANTCOLUMN.ITEMCATEGORYCOL
         || ', B.ISSUE_LOCATION '
         || IAPICONSTANTCOLUMN.ISSUELOCATIONCOL
         || ', B.BOM_ITEM_TYPE '
         || IAPICONSTANTCOLUMN.BOMTYPECOL
         || ', B.OPERATIONAL_STEP '
         || IAPICONSTANTCOLUMN.OPERATIONALSTEPCOL
         || ', B.MIN_QTY '
         || IAPICONSTANTCOLUMN.MINIMUMQUANTITYCOL
         || ', B.MAX_QTY '
         || IAPICONSTANTCOLUMN.MAXIMUMQUANTITYCOL
         || ', B.CODE '
         || IAPICONSTANTCOLUMN.CODECOL
         || ', B.ALT_GROUP '
         || IAPICONSTANTCOLUMN.BOMALTGROUPCOL
         || ', B.ALT_PRIORITY '
         || IAPICONSTANTCOLUMN.BOMALTPRIORITYCOL
         || ', B.CHAR_1 '
         || IAPICONSTANTCOLUMN.STRING1COL
         || ', B.CHAR_2 '
         || IAPICONSTANTCOLUMN.STRING2COL
         || ', B.CHAR_3 '
         || IAPICONSTANTCOLUMN.STRING3COL
         || ', B.CHAR_4 '
         || IAPICONSTANTCOLUMN.STRING4COL
         || ', B.CHAR_5 '
         || IAPICONSTANTCOLUMN.STRING5COL
         || ', round(B.NUM_1,10) '
         || IAPICONSTANTCOLUMN.NUMERIC1COL
         || ', round(B.NUM_2,10) '
         || IAPICONSTANTCOLUMN.NUMERIC2COL
         || ', round(B.NUM_3,10) '
         || IAPICONSTANTCOLUMN.NUMERIC3COL
         || ', round(B.NUM_4,10) '
         || IAPICONSTANTCOLUMN.NUMERIC4COL
         || ', round(B.NUM_5,10) '
         || IAPICONSTANTCOLUMN.NUMERIC5COL
         || ', B.Boolean_1 '
         || IAPICONSTANTCOLUMN.BOOLEAN1COL
         || ', B.Boolean_2 '
         || IAPICONSTANTCOLUMN.BOOLEAN2COL
         || ', B.Boolean_3 '
         || IAPICONSTANTCOLUMN.BOOLEAN3COL
         || ', B.Boolean_4 '
         || IAPICONSTANTCOLUMN.BOOLEAN4COL
         || ', B.DATE_1 '
         || IAPICONSTANTCOLUMN.DATE1COL
         || ', B.DATE_2 '
         || IAPICONSTANTCOLUMN.DATE2COL
         || ', f_chh_descr(0,B.CH_1, B.CH_REV_1) '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION1COL
         || ', f_chh_descr(0,B.CH_2, B.CH_REV_2) '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION2COL
         || ', f_chh_descr(0,B.CH_3, B.CH_REV_3) '
         || IAPICONSTANTCOLUMN.CHARACTERISTICDESCRIPTION3COL
         || ', B.RELEVENCY_TO_COSTING '
         || IAPICONSTANTCOLUMN.RELEVANCYTOCOSTINGCOL
         || ', B.BULK_MATERIAL '
         || IAPICONSTANTCOLUMN.BULKMATERIALCOL
         || ', B.RECURSIVE_STOP '
         || IAPICONSTANTCOLUMN.RECURSIVESTOPCOL
         || ', B.ACCESS_STOP '
         || IAPICONSTANTCOLUMN.ACCESSSTOPCOL
































         || ', '
         || ' decode( '
         || '  (decode(c.type, ' || ''''  || IAPICONSTANT.SPECTYPEGROUP_INGREDIENT  || ''''  || ', 1, 0)) '
         || ' + '
         || '  decode('
         || '    (select count(*)  from specification_header SH, frame_section FS '
         || '    where SH.FRAME_ID = FS.FRAME_NO and SH.frame_rev = FS.revision '
         || '   and SH.PART_NO = B.component_part '

         || '   and SH.revision = DECODE(B.component_revision, 0, f_rev_part_phantom(B.component_part, 0),NULL, f_rev_part_phantom(B.component_part, 0), B.component_revision) '
         
         || '   and FS.type = ' || IAPICONSTANT.SECTIONTYPE_BOM || ') '
         || '    ,0,0,1) '
         || ' + '
         || '  decode('
         || '    (select count(*)  from specification_header SH, frame_section FS '
         || '    where SH.FRAME_ID = FS.FRAME_NO and SH.frame_rev = FS.revision '
         || '   and SH.PART_NO = B.component_part '

         || '   and SH.revision = DECODE(B.component_revision, 0, f_rev_part_phantom(B.component_part, 0),NULL, f_rev_part_phantom(B.component_part, 0), B.component_revision) '
         
         || '   and FS.type = ' || IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST || ') '
         || '    ,0,0,1) '
         || ' + '
         || '  decode(( select count(*) from bom_item BI '
         || '   where BI.part_no = B.component_part '
         || '   and BI.revision = B.component_revision '
         || '   and BI.plant = B.plant '

         

         || '   and BI.bom_usage = B.usage ) '
         || '   ,0,0,1) '
         || ' , 0, 0, 1) '
         || IAPICONSTANTCOLUMN.HASTOBEPRESENTCOL


         || ' FROM ITBOMEXPLOSION B, CLASS3 C'
         || ' WHERE B.BOM_EXP_NO = :anUniqueId'
         || ' AND C.CLASS = B.PART_TYPE'
         || ' ORDER BY B.MOP_SEQUENCE_NO, B.SEQUENCE_NO';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      OPEN AQITEMS FOR LSSQL USING ANUNIQUEID;

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         OPEN AQITEMS FOR LSSQL USING -1;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETEXPLOSIONEXT;


   FUNCTION GETEXPLOSIONASBOUGHTSOLD(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      AQITEMS                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetExplosionAsBoughtSold';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSSQL                         VARCHAR2( 8192 );
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=
            'SELECT B.COMPONENT_PART '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', B.COMPONENT_REVISION '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', B.DESCRIPTION '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ', B.UOM '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ', sum(CALC_QTY) '
         || IAPICONSTANTCOLUMN.CALCULATEDQUANTITYCOL
         || ', sum(CALC_QTY_WITH_SCRAP) '
         || IAPICONSTANTCOLUMN.CALCULATEDQUANTITYWITHSCRAPCOL
         || ', round(sum(COST),10) '
         || IAPICONSTANTCOLUMN.COSTCOL
         || ', round(sum(COST_WITH_SCRAP),10) '
         || IAPICONSTANTCOLUMN.COSTWITHSCRAPCOL
         || ', round(sum(CALC_COST),10) '
         || IAPICONSTANTCOLUMN.CALCULATEDCOSTCOL
         || ', round(sum(CALC_COST_WITH_SCRAP),10) '
         || IAPICONSTANTCOLUMN.CALCULATEDCOSTWITHSCRAPCOL
         || ', max(RECURSIVE_STOP) '
         || IAPICONSTANTCOLUMN.RECURSIVESTOPCOL
         || ', max(ACCESS_STOP) '
         || IAPICONSTANTCOLUMN.ACCESSSTOPCOL
         || ', max(B.PART_TYPE) '
         || IAPICONSTANTCOLUMN.PARTTYPEIDCOL
         || ', max(C.SORT_DESC) '
         || IAPICONSTANTCOLUMN.PARTTYPECOL
         || ', max(C.DESCRIPTION) '
         || IAPICONSTANTCOLUMN.PARTTYPEDESCRIPTIONCOL
         || ' FROM (SELECT * FROM ITBOMEXPLOSION WHERE F_Is_LowestLevel(BOM_EXP_NO,MOP_SEQUENCE_NO,SEQUENCE_NO) = 1) B, CLASS3 C'
         || ' WHERE B.BOM_EXP_NO = :anUniqueId'
         || ' AND C.CLASS = B.PART_TYPE'
         || ' GROUP BY COMPONENT_PART, COMPONENT_REVISION, B.DESCRIPTION, UOM'
         || ' ORDER BY COMPONENT_PART, COMPONENT_REVISION, B.DESCRIPTION, UOM';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      OPEN AQITEMS FOR LSSQL USING ANUNIQUEID;

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         OPEN AQITEMS FOR LSSQL USING -1;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETEXPLOSIONASBOUGHTSOLD;

   
   FUNCTION GETATTACHEDEXPLOSION(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      AQITEMS                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetAttachedExplosion';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSSQL                         VARCHAR2( 8192 );
   BEGIN
      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.VIEWBOMALLOWED = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOVIEWBOMACCESS,
                                                    IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=
            'SELECT MOP_SEQUENCE_NO '
         || IAPICONSTANTCOLUMN.MOPSEQUENCECOL
         || ', SEQUENCE_NO '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ', ATT_PART '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', ATT_REVISION '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', DESCRIPTION '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ', PARENT_PART '
         || IAPICONSTANTCOLUMN.PARENTPARTNOCOL
         || ', PARENT_REVISION '
         || IAPICONSTANTCOLUMN.PARENTREVISIONCOL
         || ', PLANT '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', ALTERNATIVE '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', USAGE '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ' FROM ITATTEXPLOSION'
         || ' WHERE BOM_EXP_NO = :anUniqueId'
         || ' ORDER BY MOP_SEQUENCE_NO, SEQUENCE_NO';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      OPEN AQITEMS FOR LSSQL USING ANUNIQUEID;

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         OPEN AQITEMS FOR LSSQL USING -1;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETATTACHEDEXPLOSION;

   
   FUNCTION GETINGREDIENTEXPLOSION(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      AQITEMS                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetIngredientExplosion';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSSQL                         VARCHAR2( 8192 );
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=
            'SELECT MOP_SEQUENCE_NO '
         || IAPICONSTANTCOLUMN.MOPSEQUENCECOL
         || ', SEQUENCE_NO '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ', ING_SEQUENCE_NO '
         || IAPICONSTANTCOLUMN.INGREDIENTSEQUENCECOL
         || ', BOM_LEVEL '
         || IAPICONSTANTCOLUMN.BOMLEVELCOL
         || ', INGREDIENT '
         || IAPICONSTANTCOLUMN.INGREDIENTCOL
         || ', REVISION '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', DESCRIPTION '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ', ING_QTY '
         || IAPICONSTANTCOLUMN.QUANTITYCOL
         || ', ING_LEVEL '
         || IAPICONSTANTCOLUMN.INGREDIENTLEVELCOL
         || ', ING_COMMENT '
         || IAPICONSTANTCOLUMN.INGREDIENTCOMMENTCOL
         || ', PID '
         || IAPICONSTANTCOLUMN.INGREDIENTPARENTCOL
         || ', HIER_LEVEL '
         || IAPICONSTANTCOLUMN.HIERARCHICALLEVELCOL
         || ', RECFAC '
         || IAPICONSTANTCOLUMN.RECONSTITUTIONFACTORCOL
         || ', ING_SYNONYM '
         || IAPICONSTANTCOLUMN.SYNONYMIDCOL
         || ', ING_SYNONYM_REV '
         || IAPICONSTANTCOLUMN.SYNONYMREVISIONCOL
         || ', ACTIVE '
         || IAPICONSTANTCOLUMN.ACTIVECOL
         || ', COMPONENT_PART_NO '
         || IAPICONSTANTCOLUMN.COMPONENTPARTNOCOL
         || ', COMPONENT_REVISION '
         || IAPICONSTANTCOLUMN.COMPONENTREVISIONCOL
         || ', COMPONENT_DESCRIPTION '
         || IAPICONSTANTCOLUMN.COMPONENTDESCRIPTIONCOL
         || ', COMPONENT_PLANT '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', COMPONENT_ALTERNATIVE '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', COMPONENT_USAGE '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', COMPONENT_CALC_QTY '
         || IAPICONSTANTCOLUMN.CALCULATEDQUANTITYCOL
         || ', COMPONENT_UOM '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ', round(COMPONENT_CONV_FACTOR,10) '
         || IAPICONSTANTCOLUMN.CONVERSIONFACTORCOL
         || ', COMPONENT_TO_UNIT '
         || IAPICONSTANTCOLUMN.TOUNITCOL
         || ', INGDECLARE '
         || IAPICONSTANTCOLUMN.DECLARECOL
         || ' FROM ITINGEXPLOSION'
         || ' WHERE BOM_EXP_NO = :anUniqueId'
         || ' ORDER BY MOP_SEQUENCE_NO, SEQUENCE_NO';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      OPEN AQITEMS FOR LSSQL USING ANUNIQUEID;

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         OPEN AQITEMS FOR LSSQL USING -1;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETINGREDIENTEXPLOSION;


   FUNCTION CHECKPLANTAVAILABILITY(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE









   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckPlantAvailability';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       PLS_INTEGER;

      CURSOR CUR_ITEMS
      IS
         SELECT DISTINCT COMPONENT_PART
                    FROM ITBOMEXPLOSION
                   WHERE BOM_EXP_NO = ANUNIQUEID;
   BEGIN
      FOR REC_ITEM IN CUR_ITEMS
      LOOP
         
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM PART_PLANT
          WHERE PART_NO = REC_ITEM.COMPONENT_PART
            AND PLANT = ASPLANT;

         IF LNCOUNT > 0
         THEN
            
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM PART_PLANT
             WHERE PART_NO = REC_ITEM.COMPONENT_PART
               AND PLANT = ASPLANT
               AND OBSOLETE = 1;

            IF LNCOUNT > 0
            THEN
               UPDATE ITBOMEXPLOSION
                  SET PLANT = 'OBSOLETE'
                WHERE BOM_EXP_NO = ANUNIQUEID
                  AND COMPONENT_PART = REC_ITEM.COMPONENT_PART;
            ELSE
               UPDATE ITBOMEXPLOSION
                  SET PLANT = ASPLANT
                WHERE BOM_EXP_NO = ANUNIQUEID
                  AND COMPONENT_PART = REC_ITEM.COMPONENT_PART;
            END IF;
         ELSE
            UPDATE ITBOMEXPLOSION
               SET PLANT = 'N/A'
             WHERE BOM_EXP_NO = ANUNIQUEID
               AND COMPONENT_PART = REC_ITEM.COMPONENT_PART;
         END IF;
      END LOOP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CHECKPLANTAVAILABILITY;


   FUNCTION IMPLODENEXTLEVEL(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCE              IN       IAPITYPE.SEQUENCE_TYPE,
      ASMOPPARTNO                IN       IAPITYPE.PARTNO_TYPE,
      ANSEQUENCE                 IN OUT   IAPITYPE.SEQUENCE_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE DEFAULT NULL,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE,
      ADEXPLOSIONDATE            IN       IAPITYPE.DATE_TYPE,
      ANLEVEL                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANINCLUDEINDEVELOPMENT     IN       IAPITYPE.BOOLEAN_TYPE,
      ANLEVELFILTER              IN       IAPITYPE.LEVEL_TYPE,
      ANINCLUDEALTERNATIVES      IN       IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      CURSOR C_REV(
         C_PART_NO                           IAPITYPE.PARTNO_TYPE,
         C_PLANT                             IAPITYPE.PLANT_TYPE,
         C_DATE                              IAPITYPE.DATE_TYPE,
         C_REV                               IAPITYPE.REVISION_TYPE )
      IS
         SELECT DISTINCT BOM_ITEM.PART_NO,
                         BOM_ITEM.REVISION,
                         BOM_ITEM.PLANT,
                         BOM_ITEM.ALTERNATIVE,
                         BOM_ITEM.BOM_USAGE,
                         PART.DESCRIPTION,
                         SPECIFICATION_HEADER.CLASS3_ID,
                         NVL( BOM_ITEM.COMPONENT_REVISION,
                              9999 ) COMP_REV,
                         BOM_ITEM.ALT_GROUP,
                         BOM_ITEM.ALT_PRIORITY,
                         BOM_ITEM.QUANTITY,
                         BOM_ITEM.UOM,
                         BOM_ITEM.CONV_FACTOR,
                         BOM_ITEM.TO_UNIT
                    FROM BOM_ITEM,
                         PART,
                         
                         
                         INTERSPC.SPECIFICATION_HEADER SPECIFICATION_HEADER,
                         SPEC_ACCESS
                         
                   
                   
                   
                   
                   
                   
                   
                   
                   WHERE (SPEC_ACCESS.ACCESS_GROUP = SPECIFICATION_HEADER.ACCESS_GROUP)
                   
                     AND BOM_ITEM.COMPONENT_PART = C_PART_NO
                   
                     AND BOM_ITEM.COMPONENT_PLANT = C_PLANT
                     AND (     (     BOM_ITEM.BOM_USAGE = ANUSAGE
                                 AND ANUSAGE IS NOT NULL )
                           OR ( ANUSAGE IS NULL ) )
                     AND SPECIFICATION_HEADER.PART_NO = BOM_ITEM.PART_NO
                     AND SPECIFICATION_HEADER.REVISION = BOM_ITEM.REVISION
                     AND BOM_ITEM.PART_NO = PART.PART_NO
                     AND NVL( BOM_ITEM.COMPONENT_REVISION,
                              9999 ) >= C_REV
                     AND BOM_ITEM.ALT_PRIORITY < DECODE( ANINCLUDEALTERNATIVES,
                                                         1, 100,
                    
                                                         
                                                         2 )
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    ;
                    
                    


      CURSOR C_REV_NO_PLANT(
         C_PART_NO                           IAPITYPE.PARTNO_TYPE,
         C_DATE                              IAPITYPE.DATE_TYPE,
         C_REV                               IAPITYPE.REVISION_TYPE )
      IS
         SELECT DISTINCT BOM_ITEM.PART_NO,
                         BOM_ITEM.REVISION,
                         BOM_ITEM.PLANT,
                         BOM_ITEM.ALTERNATIVE,
                         BOM_ITEM.BOM_USAGE,
                         PART.DESCRIPTION,
                         SPECIFICATION_HEADER.CLASS3_ID,
                         NVL( BOM_ITEM.COMPONENT_REVISION,
                              9999 ) COMP_REV,
                         BOM_ITEM.ALT_GROUP,
                         BOM_ITEM.ALT_PRIORITY,
                         BOM_ITEM.QUANTITY,
                         BOM_ITEM.UOM,
                         BOM_ITEM.CONV_FACTOR,
                         BOM_ITEM.TO_UNIT
                    FROM BOM_ITEM,
                         PART,
                         
                         
                         INTERSPC.SPECIFICATION_HEADER SPECIFICATION_HEADER,
                         SPEC_ACCESS
                   
                   
                   
                   
                   
                   
                   
                   WHERE (SPEC_ACCESS.ACCESS_GROUP = SPECIFICATION_HEADER.ACCESS_GROUP)
                   
                     AND BOM_ITEM.COMPONENT_PART = C_PART_NO
                  

                     AND (     (     BOM_ITEM.BOM_USAGE = ANUSAGE
                                 AND ANUSAGE IS NOT NULL )
                           OR ( ANUSAGE IS NULL ) )
                     AND SPECIFICATION_HEADER.PART_NO = BOM_ITEM.PART_NO
                     AND SPECIFICATION_HEADER.REVISION = BOM_ITEM.REVISION
                     AND BOM_ITEM.PART_NO = PART.PART_NO
                     AND NVL( BOM_ITEM.COMPONENT_REVISION,
                              9999 ) >= C_REV
                     AND BOM_ITEM.ALT_PRIORITY < DECODE( ANINCLUDEALTERNATIVES,
                                                         1, 100,
                    
                                                         
                                                         2 )
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    ;
                    
                    


      LNOLDSEQUENCE                 IAPITYPE.ID_TYPE;
      LNLEVEL                       IAPITYPE.ID_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNCOUNTPRESENT                PLS_INTEGER;
      LNCHECKREVISION               IAPITYPE.REVISION_TYPE;
      LSPREVIOUSPART                IAPITYPE.PARTNO_TYPE := '';
      LDDATE                        IAPITYPE.DATE_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ImplodeNextLevel';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNRECURSIVECHECK              PLS_INTEGER;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNLEVEL :=   ANLEVEL
                 + 1;
      LNCHECKREVISION := 0;

      IF ASPLANT IS NULL
      THEN
         
         FOR R_REV IN C_REV_NO_PLANT( ASPARTNO,
                                      LDDATE,
                                      ANREVISION )
         LOOP
            IF R_REV.PART_NO <> NVL( LSPREVIOUSPART,
                                     ' ' )
            THEN
               LNCHECKREVISION := GETCOMPONENTREVISION( R_REV.PART_NO,
                                                        '',
                                                        R_REV.PLANT,
                                                        ADEXPLOSIONDATE,
                                                        ANINCLUDEINDEVELOPMENT );
            END IF;

            LSPREVIOUSPART := R_REV.PART_NO;

            IF LNCHECKREVISION = R_REV.REVISION
            THEN
               LNRETVAL := IAPISPECIFICATIONACCESS.GETVIEWACCESS( R_REV.PART_NO,
                                                                  LNCHECKREVISION,
                                                                  LNACCESS );

               IF LNRETVAL <>( IAPICONSTANTDBERROR.DBERR_SUCCESS )
               THEN
                  RETURN LNRETVAL;
               END IF;

               ANSEQUENCE :=   ANSEQUENCE
                             + 10;
               LNRECURSIVECHECK := ISRECURSIVEIMP( ANUNIQUEID,
                                                   ANMOPSEQUENCE,
                                                   R_REV.PART_NO,
                                                   R_REV.REVISION,
                                                   R_REV.REVISION );

               INSERT INTO ITBOMIMPLOSION
                           ( BOM_IMP_NO,
                             MOP_SEQUENCE_NO,
                             MOP_PART,
                             SEQUENCE_NO,
                             BOM_LEVEL,
                             PARENT_PART,
                             PARENT_REVISION,
                             DESCRIPTION,
                             PLANT,
                             SPEC_TYPE,
                             TOP_LEVEL,
                             ALTERNATIVE,
                             USAGE,
                             ACCESS_STOP,
                             RECURSIVE_STOP,
                             ALT_GROUP,
                             ALT_PRIORITY,
                             QUANTITY,
                             UOM,
                             CONV_FACTOR,
                             TO_UNIT )
                    VALUES ( ANUNIQUEID,
                             ANMOPSEQUENCE,
                             ASMOPPARTNO,
                             ANSEQUENCE,
                             LNLEVEL,
                             R_REV.PART_NO,
                             R_REV.REVISION,
                             R_REV.DESCRIPTION,
                             R_REV.PLANT,
                             R_REV.CLASS3_ID,
                             0,
                             R_REV.ALTERNATIVE,
                             R_REV.BOM_USAGE,
                             DECODE( LNACCESS,
                                     0, 1,
                                     0 ),
                             LNRECURSIVECHECK,
                             R_REV.ALT_GROUP,
                             R_REV.ALT_PRIORITY,
                             R_REV.QUANTITY,
                             R_REV.UOM,
                             R_REV.CONV_FACTOR,
                             R_REV.TO_UNIT );

               LNOLDSEQUENCE := ANSEQUENCE;

               IF     ANLEVELFILTER <> IAPICONSTANT.IMPLOSION_FIRST
                  
                  
                  
                  AND LNRECURSIVECHECK = 0
               THEN
                  LNRETVAL :=
                     IMPLODENEXTLEVEL( ANUNIQUEID,
                                       ANMOPSEQUENCE,
                                       ASMOPPARTNO,
                                       ANSEQUENCE,
                                       R_REV.PART_NO,
                                       R_REV.PLANT,
                                       ANUSAGE,
                                       ADEXPLOSIONDATE,
                                       LNLEVEL,
                                       R_REV.COMP_REV,
                                       ANINCLUDEINDEVELOPMENT,
                                       ANLEVELFILTER,
                                       ANINCLUDEALTERNATIVES );

                  IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                  THEN
                     RETURN LNRETVAL;
                  END IF;
               END IF;

               IF ANSEQUENCE = LNOLDSEQUENCE
               THEN
                  UPDATE ITBOMIMPLOSION
                     SET TOP_LEVEL = 1
                   WHERE BOM_IMP_NO = ANUNIQUEID
                     AND MOP_SEQUENCE_NO = ANMOPSEQUENCE
                     AND SEQUENCE_NO = ANSEQUENCE;
               END IF;
            END IF;
         END LOOP;
      ELSE
         FOR R_REV IN C_REV( ASPARTNO,
                             ASPLANT,
                             LDDATE,
                             ANREVISION )
         LOOP
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    ASPARTNO
                                 || ' '
                                 || ASPLANT
                                 || ' '
                                 || LDDATE
                                 || ' '
                                 || ANREVISION
                                 || ' '
                                 || R_REV.PART_NO );

            IF R_REV.PART_NO <> NVL( LSPREVIOUSPART,
                                     ' ' )
            THEN
               LNCHECKREVISION := GETCOMPONENTREVISION( R_REV.PART_NO,
                                                        '',
                                                        R_REV.PLANT,
                                                        ADEXPLOSIONDATE,
                                                        ANINCLUDEINDEVELOPMENT );
            END IF;

            LSPREVIOUSPART := R_REV.PART_NO;

            IF LNCHECKREVISION = R_REV.REVISION
            THEN
               LNRETVAL := IAPISPECIFICATIONACCESS.GETVIEWACCESS( R_REV.PART_NO,
                                                                  LNCHECKREVISION,
                                                                  LNACCESS );

               IF LNRETVAL <>( IAPICONSTANTDBERROR.DBERR_SUCCESS )
               THEN
                  RETURN LNRETVAL;
               END IF;

               BEGIN
                  ANSEQUENCE :=   ANSEQUENCE
                                + 10;
                  LNRECURSIVECHECK := ISRECURSIVEIMP( ANUNIQUEID,
                                                      ANMOPSEQUENCE,
                                                      R_REV.PART_NO,
                                                      R_REV.REVISION,
                                                      R_REV.PLANT );
                  INSERT INTO ITBOMIMPLOSION
                              ( BOM_IMP_NO,
                                MOP_SEQUENCE_NO,
                                MOP_PART,
                                SEQUENCE_NO,
                                BOM_LEVEL,
                                PARENT_PART,
                                PARENT_REVISION,
                                DESCRIPTION,
                                PLANT,
                                SPEC_TYPE,
                                TOP_LEVEL,
                                ALTERNATIVE,
                                USAGE,
                                ACCESS_STOP,
                                RECURSIVE_STOP,
                                ALT_GROUP,
                                ALT_PRIORITY,
                                QUANTITY,
                                UOM,
                                CONV_FACTOR,
                                TO_UNIT )
                       VALUES ( ANUNIQUEID,
                                ANMOPSEQUENCE,
                                ASMOPPARTNO,
                                ANSEQUENCE,
                                LNLEVEL,
                                R_REV.PART_NO,
                                R_REV.REVISION,
                                R_REV.DESCRIPTION,
                                R_REV.PLANT,
                                R_REV.CLASS3_ID,
                                0,
                                R_REV.ALTERNATIVE,
                                R_REV.BOM_USAGE,
                                DECODE( LNACCESS,
                                        0, 1,
                                        0 ),
                                LNRECURSIVECHECK,
                                R_REV.ALT_GROUP,
                                R_REV.ALT_PRIORITY,
                                R_REV.QUANTITY,
                                R_REV.UOM,
                                R_REV.CONV_FACTOR,
                                R_REV.TO_UNIT );
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     IAPIGENERAL.LOGERROR( GSSOURCE,
                                           LSMETHOD,
                                           SQLERRM );
                     RETURN IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
               END;

               LNOLDSEQUENCE := ANSEQUENCE;

               IF     ANLEVELFILTER <> IAPICONSTANT.IMPLOSION_FIRST
                  
                  
                  
                  AND LNRECURSIVECHECK = 0
               THEN
                  LNRETVAL :=
                     IMPLODENEXTLEVEL( ANUNIQUEID,
                                       ANMOPSEQUENCE,
                                       ASMOPPARTNO,
                                       ANSEQUENCE,
                                       R_REV.PART_NO,
                                       R_REV.PLANT,
                                       ANUSAGE,
                                       ADEXPLOSIONDATE,
                                       LNLEVEL,
                                       R_REV.COMP_REV,
                                       ANINCLUDEINDEVELOPMENT,
                                       ANLEVELFILTER,
                                       ANINCLUDEALTERNATIVES );

                  IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                  THEN
                     RETURN LNRETVAL;
                  END IF;
               END IF;

               IF ANSEQUENCE = LNOLDSEQUENCE
               THEN
                  UPDATE ITBOMIMPLOSION
                     SET TOP_LEVEL = 1
                   WHERE BOM_IMP_NO = ANUNIQUEID
                     AND MOP_SEQUENCE_NO = ANMOPSEQUENCE
                     AND SEQUENCE_NO = ANSEQUENCE;
               END IF;
            END IF;
         END LOOP;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
   END IMPLODENEXTLEVEL;

   
   FUNCTION IMPLODE(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE,
      ADEXPLOSIONDATE            IN       IAPITYPE.DATE_TYPE DEFAULT SYSDATE,
      ANINCLUDEINDEVELOPMENT     IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANLEVEL                    IN       IAPITYPE.LEVEL_TYPE DEFAULT IAPICONSTANT.IMPLOSION_ALL,
      ANUSEMOP                   IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANINCLUDEALTERNATIVES      IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0 )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS




















      CURSOR LCMOP
      IS
         SELECT DISTINCT PART_NO
                    FROM ITSHQ
                   WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

      LDDATE                        IAPITYPE.DATE_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Implode';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LNMOPCOUNT                    NUMBER := 0;
      LNSEQUENCE                    NUMBER := 0;
      LRBOMHEADER                   IAPITYPE.BOMHEADERREC_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.VIEWBOMALLOWED = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOVIEWBOMACCESS,
                                                    IAPIGENERAL.SESSION.APPLICATIONUSER.USERID );
      END IF;

      
      SELECT   ADEXPLOSIONDATE
             + 1
             - (   1
                 / 86400 )
        INTO LDDATE
        FROM DUAL;

      IF ANUSEMOP = 0
      THEN
         LNREVISION := GETCOMPONENTREVISION( ASPARTNO,
                                             '',
                                             ASPLANT,
                                             LDDATE,
                                             ANINCLUDEINDEVELOPMENT );
         LNRETVAL := IAPISPECIFICATIONACCESS.GETVIEWACCESS( ASPARTNO,
                                                            LNREVISION,
                                                            LNACCESS );

         IF LNRETVAL <>( IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN LNRETVAL;
         END IF;

         IF LNACCESS = 0
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_NOVIEWACCESS,
                                                       ASPARTNO,
                                                       LNREVISION );
         END IF;
      END IF;

      DELETE FROM ITBOMIMPLOSION
            WHERE BOM_IMP_NO = ANUNIQUEID;

      IF ANUSEMOP = 1
      THEN
         FOR LRMOP IN LCMOP
         LOOP
            LNMOPCOUNT :=   LNMOPCOUNT
                          + 1;
            LNSEQUENCE := 0;
            
            LNRETVAL :=
               IMPLODENEXTLEVEL( ANUNIQUEID,
                                 LNMOPCOUNT,
                                 LRMOP.PART_NO,
                                 LNSEQUENCE,
                                 LRMOP.PART_NO,
                                 ASPLANT,
                                 ANUSAGE,
                                 LDDATE,
                                 0,
                                 9999,
                                 ANINCLUDEINDEVELOPMENT,
                                 ANLEVEL,
                                 ANINCLUDEALTERNATIVES );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               RETURN LNRETVAL;
            END IF;
         END LOOP;
      ELSE
         
         LNRETVAL :=
            IMPLODENEXTLEVEL( ANUNIQUEID,
                              1,
                              ASPARTNO,
                              LNSEQUENCE,
                              ASPARTNO,
                              ASPLANT,
                              ANUSAGE,
                              LDDATE,
                              0,
                              9999,
                              ANINCLUDEINDEVELOPMENT,
                              ANLEVEL,
                              ANINCLUDEALTERNATIVES );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN LNRETVAL;
         END IF;
      END IF;

      IF ANLEVEL = IAPICONSTANT.IMPLOSION_TOP
      THEN   
         DELETE FROM ITBOMIMPLOSION
               WHERE BOM_IMP_NO = ANUNIQUEID
                 AND TOP_LEVEL <> 1;

      ELSIF ANLEVEL = IAPICONSTANT.IMPLOSION_FIRST
      THEN   
         DELETE FROM ITBOMIMPLOSION
               WHERE BOM_IMP_NO = ANUNIQUEID
                 AND BOM_LEVEL <> 1;

      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END IMPLODE;


   FUNCTION GETIMPLOSION(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      AXFILTEROPTIONS            IN       IAPITYPE.XMLTYPE_TYPE,
      AQITEMS                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS












      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetImplosion';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTFILTEROPTIONS               IAPITYPE.FILTERTAB_TYPE;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
   BEGIN
      
      
      
      
      
      IF ( AQITEMS%ISOPEN )
      THEN
         CLOSE AQITEMS;
      END IF;

      LSSQLNULL :=
            'SELECT BI.BOM_LEVEL '
         || IAPICONSTANTCOLUMN.BOMLEVELCOL
         || ', BI.MOP_PART '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', BI.PARENT_PART '
         || IAPICONSTANTCOLUMN.PARENTPARTNOCOL
         || ', BI.PARENT_REVISION '
         || IAPICONSTANTCOLUMN.PARENTREVISIONCOL
         || ', BI.DESCRIPTION '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ', BI.PLANT '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', BI.ALTERNATIVE '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', BI.USAGE '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', ITBU.DESCR '
         || IAPICONSTANTCOLUMN.BOMUSAGEDESCRIPTIONCOL
         || ', BI.SPEC_TYPE '
         || IAPICONSTANTCOLUMN.SPECIFICATIONTYPECOL
         || ', BI.TOP_LEVEL '
         || IAPICONSTANTCOLUMN.TOPLEVELCOL
         || ', BI.RECURSIVE_STOP '
         || IAPICONSTANTCOLUMN.RECURSIVESTOPCOL
         || ', BI.ACCESS_STOP '
         || IAPICONSTANTCOLUMN.ACCESSSTOPCOL
         || ', BI.ALT_GROUP '
         || IAPICONSTANTCOLUMN.ALTERNATIVEGROUPCOL
         || ', BI.ALT_PRIORITY '
         || IAPICONSTANTCOLUMN.ALTERNATIVEPRIORITYCOL
         || ' FROM ITBOMIMPLOSION BI, ITBU'
         || ' WHERE BI.BOM_IMP_NO = -1';

      OPEN AQITEMS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.APPENDXMLFILTER( AXFILTEROPTIONS,
                                               LTFILTEROPTIONS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LNRETVAL := IAPISPECIFICATIONBOM.GETIMPLOSION( ANUNIQUEID,
                                                     LTFILTEROPTIONS,
                                                     AQITEMS );

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

         OPEN AQITEMS FOR LSSQLNULL;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETIMPLOSION;


   FUNCTION GETIMPLOSION(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ATFILTEROPTIONS            IN       IAPITYPE.FILTERTAB_TYPE,
      AQITEMS                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS












      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetImplosion';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE;
      LRFILTER                      IAPITYPE.FILTERREC_TYPE;
      LRFILTER1                     IAPITYPE.FILTERREC_TYPE;
      LSFILTER                      IAPITYPE.SQLSTRING_TYPE := NULL;
      LSFILTERTOADD                 IAPITYPE.STRING_TYPE := NULL;
      LSFILTER1                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSFILTERTOADD1                IAPITYPE.STRING_TYPE := NULL;
      LSQUANTITY                    IAPITYPE.STRING_TYPE := NULL;
      LSQUANTITYOPERATOR            IAPITYPE.STRING_TYPE := NULL;
      
      
      LSQUANTITYSQL                 IAPITYPE.SQLSTRING_TYPE := NULL;
      LSCONVERTEDQUANTITYSQL        IAPITYPE.SQLSTRING_TYPE := NULL;
      LSUOM                         IAPITYPE.STRING_TYPE := NULL;
      LSUOMOPERATOR                 IAPITYPE.STRING_TYPE := NULL;
      LNUOMVALUE                    IAPITYPE.STRING_TYPE := NULL;
      LSUSEMOPLIST                  IAPITYPE.STRING_TYPE := NULL;
      LSUSEMOPLISTOPERATOR          IAPITYPE.STRING_TYPE := NULL;
      LNUSEMOPLISTVALUE             IAPITYPE.STRING_TYPE := NULL;
      LNFILTERMOP                   IAPITYPE.BOOLEAN_TYPE DEFAULT 0;
      LSUSECLASS3ID                 IAPITYPE.STRING_TYPE := NULL;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=
            'SELECT BI.BOM_LEVEL '
         || IAPICONSTANTCOLUMN.BOMLEVELCOL
         || ', BI.MOP_PART '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', BI.PARENT_PART '
         || IAPICONSTANTCOLUMN.PARENTPARTNOCOL
         || ', BI.PARENT_REVISION '
         || IAPICONSTANTCOLUMN.PARENTREVISIONCOL
         || ', BI.DESCRIPTION '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ', BI.PLANT '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', BI.ALTERNATIVE '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', BI.USAGE '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', ITBU.DESCR '
         || IAPICONSTANTCOLUMN.BOMUSAGEDESCRIPTIONCOL
         || ', BI.SPEC_TYPE '
         || IAPICONSTANTCOLUMN.SPECIFICATIONTYPECOL
         || ', BI.TOP_LEVEL '
         || IAPICONSTANTCOLUMN.TOPLEVELCOL
         || ', BI.RECURSIVE_STOP '
         || IAPICONSTANTCOLUMN.RECURSIVESTOPCOL
         || ', BI.ACCESS_STOP '
         || IAPICONSTANTCOLUMN.ACCESSSTOPCOL
         || ', BI.ALT_GROUP '
         || IAPICONSTANTCOLUMN.ALTERNATIVEGROUPCOL
         || ', BI.ALT_PRIORITY '
         || IAPICONSTANTCOLUMN.ALTERNATIVEPRIORITYCOL;
      LSSQLNULL :=    LSSQL
                   || ' FROM ITBOMIMPLOSION BI, ITBU'
                   || ' WHERE BI.BOM_IMP_NO = -1';
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Number of items in DefaultFilter <'
                           || ATFILTEROPTIONS.COUNT
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR I IN 0 ..   ATFILTEROPTIONS.COUNT
                    - 1
      LOOP
         LRFILTER := ATFILTEROPTIONS( I );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'FilterOptions ('
                              || I
                              || ') <'
                              || LRFILTER.LEFTOPERAND
                              || '> <'
                              || LRFILTER.OPERATOR
                              || '> <'
                              || LRFILTER.RIGHTOPERAND
                              || '>',
                              IAPICONSTANT.INFOLEVEL_3 );

         
         CASE LRFILTER.LEFTOPERAND
            WHEN IAPICONSTANTCOLUMN.QUANTITYCOL
            THEN
               LRFILTER.LEFTOPERAND := 'BI.QUANTITY';
               LRFILTER1.LEFTOPERAND := '(BI.QUANTITY * BI.CONV_FACTOR)';
               LRFILTER1.OPERATOR := LRFILTER.OPERATOR;
               LRFILTER1.RIGHTOPERAND := LRFILTER.RIGHTOPERAND;

               IF ( I > 0 )
               THEN
                  LSFILTER :=    LSFILTER
                              || ' AND ';
                  LSFILTER1 :=    LSFILTER1
                               || ' AND ';
               END IF;

               LSFILTERTOADD :=    LRFILTER.LEFTOPERAND
                                || ' '
                                || LRFILTER.OPERATOR
                                || ' '
                                || LRFILTER.RIGHTOPERAND
                                || ' ';
               LSFILTERTOADD1 :=    LRFILTER1.LEFTOPERAND
                                 || ' '
                                 || LRFILTER1.OPERATOR
                                 || ' '
                                 || LRFILTER1.RIGHTOPERAND
                                 || ' ';
               LSFILTER :=    LSFILTER
                           || LSFILTERTOADD;
               LSFILTER1 :=    LSFILTER1
                            || LSFILTERTOADD1;
            WHEN IAPICONSTANTCOLUMN.UOMCOL
            THEN
               LRFILTER.LEFTOPERAND := 'BI.UOM';
               LRFILTER1.LEFTOPERAND := 'BI.TO_UNIT';
               LRFILTER1.OPERATOR := LRFILTER.OPERATOR;
               LRFILTER1.RIGHTOPERAND := LRFILTER.RIGHTOPERAND;
               LRFILTER.RIGHTOPERAND := IAPIGENERAL.ESCQUOTE( LRFILTER.RIGHTOPERAND );
               LRFILTER1.RIGHTOPERAND := IAPIGENERAL.ESCQUOTE( LRFILTER1.RIGHTOPERAND );

               IF ( I > 0 )
               THEN
                  LSFILTER :=    LSFILTER
                              || ' AND ';
                  LSFILTER1 :=    LSFILTER1
                               || ' AND ';
               END IF;

               LNRETVAL := IAPIGENERAL.TRANSFORMFILTERRECORD( LRFILTER,
                                                              LSFILTERTOADD );

               IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
               THEN
                  LSFILTER :=    LSFILTER
                              || LSFILTERTOADD;
               ELSE
                  RETURN( LNRETVAL );
               END IF;

               LNRETVAL := IAPIGENERAL.TRANSFORMFILTERRECORD( LRFILTER1,
                                                              LSFILTERTOADD1 );

               IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
               THEN
                  LSFILTER1 :=    LSFILTER1
                               || LSFILTERTOADD1;
               ELSE
                  RETURN( LNRETVAL );
               END IF;
            WHEN IAPICONSTANTCOLUMN.USEMOPLISTCOL
            THEN
               IF LRFILTER.OPERATOR <> '='
               THEN
                  LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                  LSMETHOD,
                                                                  IAPICONSTANTDBERROR.DBERR_INVALIDFILTER,
                                                                  LRFILTER.LEFTOPERAND );
                  RETURN( LNRETVAL );
               END IF;

               CASE LRFILTER.RIGHTOPERAND
                  WHEN 'FALSE'
                  THEN
                     LNFILTERMOP := 0;
                  WHEN 'TRUE'
                  THEN
                     LNFILTERMOP := 1;
                  ELSE
                     LNRETVAL :=
                              IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                  LSMETHOD,
                                                                  IAPICONSTANTDBERROR.DBERR_INVALIDFILTER,
                                                                  LRFILTER.LEFTOPERAND );
                     RETURN( LNRETVAL );
               END CASE;
            WHEN IAPICONSTANTCOLUMN.CLASSIDCOL
            THEN
               IF LRFILTER.OPERATOR <> '='
               THEN
                  LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                  LSMETHOD,
                                                                  IAPICONSTANTDBERROR.DBERR_INVALIDFILTER,
                                                                  LRFILTER.LEFTOPERAND );
                  RETURN( LNRETVAL );
               END IF;

               LNRETVAL := IAPIGENERAL.ISNUMERIC( LRFILTER.RIGHTOPERAND );

               IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
               THEN
                  LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                  LSMETHOD,
                                                                  IAPICONSTANTDBERROR.DBERR_INVALIDFILTER,
                                                                  LRFILTER.LEFTOPERAND );
                  RETURN( LNRETVAL );
               END IF;

               LSUSECLASS3ID :=    ' AND BI.SPEC_TYPE = '
                                || LRFILTER.RIGHTOPERAND;
            ELSE
               LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                               LSMETHOD,
                                                               IAPICONSTANTDBERROR.DBERR_INVALIDFILTER,
                                                               LRFILTER.LEFTOPERAND );
               RETURN( LNRETVAL );
         END CASE;
      END LOOP;

      IF LNFILTERMOP = 1
      THEN
         LSSQL :=
               LSSQL
            || ' FROM ITBOMIMPLOSION BI, ITBU, ITSHQ'
            || ' WHERE BI.BOM_IMP_NO = :anUniqueId'
            || ' AND ITSHQ.USER_ID = :lsUser'
            || ' AND ITSHQ.PART_NO = BI.PARENT_PART'
            || ' AND ITSHQ.REVISION = BI.PARENT_REVISION';
      ELSE
         LSSQL :=    LSSQL
                  || ' FROM ITBOMIMPLOSION BI, ITBU'
                  || ' WHERE BI.BOM_IMP_NO = :anUniqueId'
                  || ' AND :lsUser IS NOT NULL';
      END IF;

      IF ( LSFILTER IS NOT NULL )
      THEN
         IF LSFILTER IS NOT NULL
         THEN
            LSSQL :=    LSSQL
                     || ' AND '
                     || '(('
                     || LSFILTER
                     || ') OR '
                     || '('
                     || LSFILTER1
                     || '))';
         ELSE
            LSSQL :=    LSSQL
                     || ' AND '
                     || '('
                     || LSFILTER
                     || ')';
         END IF;
      END IF;

      LSSQL :=    LSSQL
               || ' AND BI.USAGE = ITBU.BOM_USAGE';
      LSSQL :=    LSSQL
               || LSUSECLASS3ID;
      LSSQL :=    LSSQL
               || ' ORDER BY MOP_SEQUENCE_NO, SEQUENCE_NO';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      OPEN AQITEMS FOR LSSQL USING ANUNIQUEID,
      IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         OPEN AQITEMS FOR LSSQLNULL;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETIMPLOSION;


   FUNCTION GETIMPLOSIONPB(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      AXDEFAULTFILTER            IN       IAPITYPE.XMLSTRING_TYPE,
      AQITEMS                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS












      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetImplosionPb';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LXDEFAULTFILTER               IAPITYPE.XMLTYPE_TYPE;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
   BEGIN
      
      
      
      
      
      IF ( AQITEMS%ISOPEN )
      THEN
         CLOSE AQITEMS;
      END IF;

      LSSQLNULL :=
            'SELECT BI.BOM_LEVEL '
         || IAPICONSTANTCOLUMN.BOMLEVELCOL
         || ', BI.MOP_PART '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ', BI.PARENT_PART '
         || IAPICONSTANTCOLUMN.PARENTPARTNOCOL
         || ', BI.PARENT_REVISION '
         || IAPICONSTANTCOLUMN.PARENTREVISIONCOL
         || ', BI.DESCRIPTION '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ', BI.PLANT '
         || IAPICONSTANTCOLUMN.PLANTNOCOL
         || ', BI.ALTERNATIVE '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ', BI.USAGE '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', ITBU.DESCR '
         || IAPICONSTANTCOLUMN.BOMUSAGEDESCRIPTIONCOL
         || ', BI.SPEC_TYPE '
         || IAPICONSTANTCOLUMN.SPECIFICATIONTYPECOL
         || ', BI.TOP_LEVEL '
         || IAPICONSTANTCOLUMN.TOPLEVELCOL
         || ', BI.RECURSIVE_STOP '
         || IAPICONSTANTCOLUMN.RECURSIVESTOPCOL
         || ', BI.ACCESS_STOP '
         || IAPICONSTANTCOLUMN.ACCESSSTOPCOL
         || ', BI.ALT_GROUP '
         || IAPICONSTANTCOLUMN.ALTERNATIVEGROUPCOL
         || ', BI.ALT_PRIORITY '
         || IAPICONSTANTCOLUMN.ALTERNATIVEPRIORITYCOL
         || ' FROM ITBOMIMPLOSION BI, ITBU'
         || ' WHERE BI.BOM_IMP_NO = -1';

      OPEN AQITEMS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LXDEFAULTFILTER := XMLTYPE( AXDEFAULTFILTER );
      LNRETVAL := IAPISPECIFICATIONBOM.GETIMPLOSION( ANUNIQUEID,
                                                     LXDEFAULTFILTER,
                                                     AQITEMS );

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

         OPEN AQITEMS FOR LSSQLNULL;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETIMPLOSIONPB;

   
   FUNCTION GETINGREDIENTEXPLOSIONUOM(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE DEFAULT 1 )
      RETURN IAPITYPE.DESCRIPTION_TYPE
   
   
   
   
   
   
   
   
   
   
   
   
   
   IS
      CURSOR LCUR_GET_UOM
      IS
         SELECT   UOM,
                  SUM( TYPE_UOM ) TOTAL_TYPE_UOM,
                  SUM( TYPE_TO_UNIT ) TOTAL_TYPE_TO_UNIT,
                    SUM( TYPE_UOM )
                  + SUM( TYPE_TO_UNIT ) TOTAL
             FROM ( SELECT  UOM,
                            SUM( TYPE_UOM ) TYPE_UOM,
                            SUM( TYPE_TO_UNIT ) TYPE_TO_UNIT
                       FROM ( SELECT UOM,
                                     1 TYPE_UOM,
                                     0 TYPE_TO_UNIT
                               FROM ITBOMEXPLOSION
                              WHERE BOM_EXP_NO = ANUNIQUEID
                                AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                                AND SEQUENCE_NO IN( SELECT ROUND( SEQUENCE_NO )
                                                     FROM ITINGEXPLOSION
                                                    WHERE BOM_EXP_NO = ANUNIQUEID
                                                      AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO )
                                AND UOM IS NOT NULL )
                   GROUP BY UOM
                   UNION
                   SELECT   UOM,
                            SUM( TYPE_UOM ) TYPE_UOM,
                            SUM( TYPE_TO_UNIT ) TYPE_TO_UNIT
                       FROM ( SELECT TO_UNIT UOM,
                                     0 TYPE_UOM,
                                     1 TYPE_TO_UNIT
                               FROM ITBOMEXPLOSION
                              WHERE BOM_EXP_NO = ANUNIQUEID
                                AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                                AND SEQUENCE_NO IN( SELECT SEQUENCE_NO
                                                     FROM ITINGEXPLOSION
                                                    WHERE BOM_EXP_NO = ANUNIQUEID
                                                      AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO )
                                AND TO_UNIT IS NOT NULL )
                   GROUP BY UOM )
         GROUP BY UOM
         ORDER BY 4 DESC;

      CURSOR LCUR_GET_SEQUENCE(
         ASUOM                               ITBOMEXPLOSION.UOM%TYPE )
      IS
         SELECT MIN( SEQUENCE_NO ) SEQUENCE_NO
           FROM ITINGEXPLOSION
          WHERE BOM_EXP_NO = ANUNIQUEID
            AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
            AND COMPONENT_UOM = ASUOM;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetIngredientExplosionUom';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSUOM                         IAPITYPE.DESCRIPTION_TYPE;
      LNTOTALTYPEUOM                NUMBER;
      LNTOTALTYPETOUNIT             NUMBER;
      LNTOTAL                       NUMBER;
      LNUOM1SEQUENCENO              IAPITYPE.SEQUENCE_TYPE;
      LNUOM2SEQUENCENO              IAPITYPE.SEQUENCE_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR LCUR_GET_UOM_REC IN LCUR_GET_UOM
      LOOP
         IF LSUOM IS NULL
         THEN
            LSUOM := LCUR_GET_UOM_REC.UOM;
            LNTOTALTYPEUOM := LCUR_GET_UOM_REC.TOTAL_TYPE_UOM;
            LNTOTALTYPETOUNIT := LCUR_GET_UOM_REC.TOTAL_TYPE_TO_UNIT;
            LNTOTAL := LCUR_GET_UOM_REC.TOTAL;
         ELSE
            IF LNTOTAL = LCUR_GET_UOM_REC.TOTAL
            THEN
               IF LNTOTALTYPEUOM < LCUR_GET_UOM_REC.TOTAL_TYPE_UOM
               THEN
                  LSUOM := LCUR_GET_UOM_REC.UOM;
                  LNTOTALTYPEUOM := LCUR_GET_UOM_REC.TOTAL_TYPE_UOM;
                  LNTOTALTYPETOUNIT := LCUR_GET_UOM_REC.TOTAL_TYPE_TO_UNIT;
                  LNTOTAL := LCUR_GET_UOM_REC.TOTAL;
               ELSIF LNTOTALTYPEUOM = LCUR_GET_UOM_REC.TOTAL_TYPE_UOM
               THEN
                  LNUOM1SEQUENCENO := -1;

                  
                  FOR LCUR_GET_SEQUENCE_REC IN LCUR_GET_SEQUENCE( LSUOM )
                  LOOP
                     LNUOM1SEQUENCENO := LCUR_GET_SEQUENCE_REC.SEQUENCE_NO;
                  END LOOP;

                  
                  LNUOM2SEQUENCENO := -1;

                  FOR LCUR_GET_SEQUENCE_REC IN LCUR_GET_SEQUENCE( LCUR_GET_UOM_REC.UOM )
                  LOOP
                     LNUOM2SEQUENCENO := LCUR_GET_SEQUENCE_REC.SEQUENCE_NO;
                  END LOOP;

                  IF LNUOM1SEQUENCENO > LNUOM2SEQUENCENO
                  THEN
                     LSUOM := LCUR_GET_UOM_REC.UOM;
                     LNTOTALTYPEUOM := LCUR_GET_UOM_REC.TOTAL_TYPE_UOM;
                     LNTOTALTYPETOUNIT := LCUR_GET_UOM_REC.TOTAL_TYPE_TO_UNIT;
                     LNTOTAL := LCUR_GET_UOM_REC.TOTAL;
                  END IF;
               END IF;
            ELSE
               EXIT;
            END IF;
         END IF;
      END LOOP;

      IF LSUOM IS NULL
      THEN
         SELECT UOM
           INTO LSUOM
           FROM ITBOMEXPLOSION
          WHERE BOM_EXP_NO = ANUNIQUEID
            AND BOM_LEVEL = 0
            AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO;
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              '<'
                           || LSUOM
                           || '> will be used as uom for ingredient component calculation',
                           IAPICONSTANT.INFOLEVEL_1 );
      RETURN LSUOM;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'No Data Found in Ingredient Explosion for ID <'
                              || ANUNIQUEID
                              || '> and MOP Sequence<'
                              || ANMOPSEQUENCENO
                              || '>' );
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
         RAISE_APPLICATION_ERROR( -20000,
                                     'No Data Found in Ingredient Explosion for ID <'
                                  || ANUNIQUEID
                                  || '> and MOP Sequence<'
                                  || ANMOPSEQUENCENO
                                  || '>' );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
         RAISE_APPLICATION_ERROR( -20000,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
   END GETINGREDIENTEXPLOSIONUOM;

   
   FUNCTION BOMRECORDSMATCH(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
   
   
   
   
   
   
   
   
   
   








      CURSOR C_BOM_HEADER(
         ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
         ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
      IS
         SELECT PART_NO,
                REVISION,
                PLANT,
                ALTERNATIVE,
                BOM_USAGE
           FROM BOM_HEADER
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION;

      LSTEMP                        IAPITYPE.STRING_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'BomRecordsMatch';
   BEGIN
      FOR CBH IN C_BOM_HEADER( ASPARTNO,
                               ANREVISION )
      LOOP
         
         
         BEGIN
            SELECT 'Y'
              INTO LSTEMP
              FROM BOM_ITEM
             WHERE PART_NO = CBH.PART_NO
               AND REVISION = CBH.REVISION
               AND PLANT = CBH.PLANT
               AND ALTERNATIVE = CBH.ALTERNATIVE
               AND BOM_USAGE = CBH.BOM_USAGE;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_BOMITEMDONTMATCHHEADER,
                                                           ASPARTNO,
                                                           ANREVISION ) );
            WHEN TOO_MANY_ROWS
            THEN
               NULL;   
            WHEN OTHERS
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_ERRMATCHBOMITEMANDHEADER,
                                                           ASPARTNO,
                                                           ANREVISION ) );
         END;
      END LOOP;

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   END BOMRECORDSMATCH;
END IAPISPECIFICATIONBOM;
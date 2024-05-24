CREATE OR REPLACE PACKAGE BODY iapiNutritionalCalculation
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





   


   FUNCTION CREATETABLEFROMSQL(
      ASSQL                      IN       IAPITYPE.SQLSTRING_TYPE,
      ASTABLENAME                OUT      IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LNRESULT                      PLS_INTEGER;
      LNCURSOR                      PLS_INTEGER;
      
      
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CreateTableFromSql';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      ASTABLENAME :=    'ITNUTTMP_'
                     || USERENV( 'sessionid' );
      
      
      
      
      
      LSSQL :=    'DROP TABLE '
               || ASTABLENAME;
      

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );
      LNCURSOR := DBMS_SQL.OPEN_CURSOR;

      BEGIN
         DBMS_SQL.PARSE( LNCURSOR,
                         LSSQL,
                         DBMS_SQL.V7 );
         LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      LSSQL :=    'DROP PUBLIC SYNONYM '
               || ASTABLENAME;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );

      BEGIN
         DBMS_SQL.PARSE( LNCURSOR,
                         LSSQL,
                         DBMS_SQL.V7 );
         LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      
      LSSQL :=
            'CREATE TABLE '
         || ASTABLENAME
         || ' ( COLID        NUMBER(8), '
         || ' HEADER         VARCHAR2(60), '
         || ' ROW_ID         NUMBER(8), '
         || ' DATATYPE       NUMBER(1), '
         || ' DISPLAYNAME    VARCHAR2(60), '
         || ' DESCRIPTION    VARCHAR2(60), '
	 
         || ' CALCQTY        NUMBER(17,7), '
         || ' TEXT           VARCHAR2(255), '
         

         || ' VALUE          VARCHAR2(60)) '
         || ' TABLESPACE SPECD ';
         
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );

      BEGIN
         DBMS_SQL.PARSE( LNCURSOR,
                         LSSQL,
                         DBMS_SQL.V7 );
         LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
      EXCEPTION
         WHEN OTHERS
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_GENFAIL,
                                                        SQLERRM ) );
      END;

      
      LSSQL :=    'GRANT SELECT ON '
               || ASTABLENAME
               || ' TO APPROVER';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );
      DBMS_SQL.PARSE( LNCURSOR,
                      LSSQL,
                      DBMS_SQL.V7 );
      LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
      LSSQL :=    'GRANT SELECT ON '
               || ASTABLENAME
               || ' TO MRP';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );
      DBMS_SQL.PARSE( LNCURSOR,
                      LSSQL,
                      DBMS_SQL.V7 );
      LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
      LSSQL :=    'GRANT SELECT ON '
               || ASTABLENAME
               || ' TO VIEW_ONLY';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );
      DBMS_SQL.PARSE( LNCURSOR,
                      LSSQL,
                      DBMS_SQL.V7 );
      LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
      LSSQL :=    'GRANT SELECT, INSERT, DELETE, UPDATE ON '
               || ASTABLENAME
               || ' TO CONFIGURATOR';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );
      DBMS_SQL.PARSE( LNCURSOR,
                      LSSQL,
                      DBMS_SQL.V7 );
      LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
      LSSQL :=    'GRANT SELECT, INSERT, DELETE, UPDATE ON '
               || ASTABLENAME
               || ' TO DEV_MGR';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );
      DBMS_SQL.PARSE( LNCURSOR,
                      LSSQL,
                      DBMS_SQL.V7 );
      LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
      LSSQL :=    'GRANT SELECT, INSERT, DELETE, UPDATE ON '
               || ASTABLENAME
               || ' TO FRAME_BUILDER';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );
      DBMS_SQL.PARSE( LNCURSOR,
                      LSSQL,
                      DBMS_SQL.V7 );
      LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
      
      LSSQL :=    'CREATE PUBLIC SYNONYM '
               || ASTABLENAME
               || ' FOR '
               || ASTABLENAME;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );
      DBMS_SQL.PARSE( LNCURSOR,
                      LSSQL,
                      DBMS_SQL.V7 );
      LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
      DBMS_SQL.CLOSE_CURSOR( LNCURSOR );
      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CREATETABLEFROMSQL;


   FUNCTION DROPTEMPTABLE(
      ASTABLENAME                IN      IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LNRESULT                      PLS_INTEGER;
      LNCURSOR                      PLS_INTEGER;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'DropTempTable';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      LSSQL :=    'DROP TABLE '
               || ASTABLENAME;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );
      LNCURSOR := DBMS_SQL.OPEN_CURSOR;

      BEGIN
         DBMS_SQL.PARSE( LNCURSOR,
                         LSSQL,
                         DBMS_SQL.V7 );
         LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      LSSQL :=    'DROP PUBLIC SYNONYM '
               || ASTABLENAME;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL );

      BEGIN
         DBMS_SQL.PARSE( LNCURSOR,
                         LSSQL,
                         DBMS_SQL.V7 );
         LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      DBMS_SQL.CLOSE_CURSOR( LNCURSOR );

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END DROPTEMPTABLE;



   FUNCTION GETDOMINANTUOM(
      LNBOMEXPNO                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
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
                                AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
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
                                AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
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
            AND SEQUENCE_NO IN(
                   SELECT ROUND( SEQUENCE_NO,
                                 0 )
                     FROM ITBOMEXPLOSION
                    WHERE BOM_EXP_NO = CNBOMEXPNO
                      AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
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
            AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
            AND BOM_LEVEL = 0;

         LSDOMINANTUOM := LSINGUOM;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( IAPINUTRITIONALCALCULATION.GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETDOMINANTUOM;








FUNCTION GETDOMINANTUOM_NUTRITIONAL(
      LNBOMEXPNO                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      LSDOMINANTUOM              OUT      IAPITYPE.DESCRIPTION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LSINGUOM                      PART.BASE_UOM%TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetDominantUom_Nutritional';

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
                               
                               FROM ITNUTPATH
                              WHERE BOM_EXP_NO = LNBOMEXPNO
                                AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                                
                                
                                
                                
                                
                                
                                AND USE IN (1, 2)
                                
                                AND UOM IS NOT NULL )
                   GROUP BY UOM
                   UNION
                   SELECT   UOM,
                            SUM( TYPE_UOM ) TYPE_UOM,
                            SUM( TYPE_TO_UNIT ) TYPE_TO_UNIT
                       FROM ( SELECT TO_UNIT UOM,
                                     0 TYPE_UOM,
                                     1 TYPE_TO_UNIT
                               
                               FROM ITNUTPATH
                              WHERE BOM_EXP_NO = LNBOMEXPNO
                                AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                                
                                
                                
                                
                                
                                
                                AND USE IN (1, 2)
                                
                                AND TO_UNIT IS NOT NULL )
                   GROUP BY UOM )
         GROUP BY UOM
         ORDER BY 4 DESC;

      CURSOR LCGETSEQUENCE(
         CNBOMEXPNO                          IAPITYPE.SEQUENCE_TYPE,
         CSUOM                               IAPITYPE.DESCRIPTION_TYPE )
      IS
         SELECT MIN( SEQUENCE_NO ) SEQUENCE_NO
           
           FROM ITNUTPATH
          WHERE BOM_EXP_NO = CNBOMEXPNO
            AND UOM = CSUOM
            AND SEQUENCE_NO IN(
                   SELECT ROUND( SEQUENCE_NO,
                                 0 )
                     
                     FROM ITNUTPATH
                    WHERE BOM_EXP_NO = CNBOMEXPNO
                      AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                      
                      
                      
                       
                       
                       
                       AND USE IN (1, 2));
                       

      
      LSUOM                         ITNUTPATH.UOM%TYPE := NULL;
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
         BEGIN
             SELECT UOM
               INTO LSINGUOM
               
               FROM ITNUTPATH
              WHERE BOM_EXP_NO = LNBOMEXPNO
                AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                AND BOM_LEVEL = 0;

             LSDOMINANTUOM := LSINGUOM;
        EXCEPTION
              WHEN NO_DATA_FOUND
              THEN
                     SELECT UOM
                       INTO LSINGUOM
                       FROM ITBOMEXPLOSION
                      WHERE BOM_EXP_NO = LNBOMEXPNO
                        AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                        AND BOM_LEVEL = 0;

                     LSDOMINANTUOM := LSINGUOM;
        END;

      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( IAPINUTRITIONALCALCULATION.GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETDOMINANTUOM_NUTRITIONAL;
   
   FUNCTION GETLOWESTUSABLELEVEL(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ASUOM                               IAPITYPE.DESCRIPTION_TYPE )
      RETURN IAPITYPE.BOMLEVEL_TYPE
   IS
      LNLOWESTLEVEL                 IAPITYPE.BOMLEVEL_TYPE;
      LNPREVIOUSLEVEL               IAPITYPE.BOMLEVEL_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      FOR I IN ( SELECT DISTINCT BOM_LEVEL BOM_LEVEL
                           FROM ITNUTPATH
                          WHERE BOM_EXP_NO = ANUNIQUEID
                            AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                            AND (    USE = 1
                                  OR BOM_LEVEL = 0 )
                       ORDER BY 1 DESC )
      LOOP
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM ITNUTPATH
          WHERE BOM_EXP_NO = ANUNIQUEID
            AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
            AND BOM_LEVEL = I.BOM_LEVEL
            AND ASUOM NOT IN( NVL( UOM,
                                   ' ' ), NVL( TO_UNIT,
                                               ' ' ) );

         IF LNCOUNT > 0
         THEN
            LNLOWESTLEVEL := LNPREVIOUSLEVEL;
            EXIT;
         ELSE
            LNPREVIOUSLEVEL := I.BOM_LEVEL;
         END IF;
      END LOOP;

      RETURN NVL( LNLOWESTLEVEL,
                  0 );
   END;


   FUNCTION GETCOLUMNSNUTRITIONALLOG(
      ASALIAS                    IN       IAPITYPE.STRING_TYPE DEFAULT '' )
      RETURN IAPITYPE.BASECOLUMNS_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetColumnsNutritionalLog';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LCBASECOLUMNS                 IAPITYPE.BASECOLUMNS_TYPE := NULL;
      LSALIAS                       IAPITYPE.STRING_TYPE := NULL;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( ASALIAS != '' )
      THEN
         NULL;
      ELSE
         LSALIAS :=    ASALIAS
                    || '.';
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSALIAS,
                           IAPICONSTANT.INFOLEVEL_3 );
      LCBASECOLUMNS :=
            LSALIAS
         || 'Log_id '
         || IAPICONSTANTCOLUMN.LOGIDCOL
         || ','
         || LSALIAS
         || 'Log_Name '
         || IAPICONSTANTCOLUMN.LOGNAMECOL
         || ','
         || LSALIAS
         || 'Status '
         || IAPICONSTANTCOLUMN.STATUSIDCOL
         || ', f_rdStatus_descr( n.Status ) '
         || IAPICONSTANTCOLUMN.STATUSCOL
         || ','
         || LSALIAS
         || 'part_no '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         
         






         
         || ','
         || LSALIAS
         || 'Revision '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', f_shh_descr( 1, n.part_no ) '
         || IAPICONSTANTCOLUMN.SPECIFICATIONDESCRIPTIONCOL
         || ','
         || LSALIAS
         || 'Plant '
         || IAPICONSTANTCOLUMN.PLANTCOL
         || ','
         || LSALIAS
         || 'Alternative '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ','
         || LSALIAS
         || 'Bom_Usage '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', f_bu_descr( n.Bom_Usage ) '
         || IAPICONSTANTCOLUMN.BOMUSAGEDESCRIPTIONCOL
         || ','
         || LSALIAS
         || 'Explosion_Date '
         || IAPICONSTANTCOLUMN.EXPLOSIONDATECOL
         || ','
         || LSALIAS
         || 'ref_spec '
         || IAPICONSTANTCOLUMN.REFERENCESPECIDCOL
         || ','
         || LSALIAS
         || 'ref_rev '
         || IAPICONSTANTCOLUMN.REFERENCESPECREVCOL
         || ', f_shh_descr( 1, n.ref_spec ) '
         || IAPICONSTANTCOLUMN.REFERENCESPECCOL
         || ','
         || LSALIAS
         || 'Layout_id '
         || IAPICONSTANTCOLUMN.LAYOUTIDCOL
         || ','
         || LSALIAS
         || 'Layout_rev '
         || IAPICONSTANTCOLUMN.LAYOUTREVISIONCOL
         || ', f_nly_descr( 1, n.Layout_id, n.Layout_rev ) '
         || IAPICONSTANTCOLUMN.LAYOUTNAMECOL
         || ','
         || LSALIAS
         || 'created_by '
         || IAPICONSTANTCOLUMN.CREATEDBYCOL
         || ','
         || LSALIAS
         || 'created_on '
         || IAPICONSTANTCOLUMN.CREATEDONCOL
         || ','
         || LSALIAS
         || 'LoggingXml '
         || IAPICONSTANTCOLUMN.LOGGINGXMLCOL
         || ','
         || LSALIAS
         || 'Serving_size_id '
         || IAPICONSTANTCOLUMN.SERVINGSIZEIDCOL
         || ', F_SERVSIZE_REFWeight_DESCR( n.ref_spec, n.Serving_size_id, n.Result_Weight ) '
         || IAPICONSTANTCOLUMN.SERVINGSIZECOL
         || ','
         || LSALIAS
         || 'Dec_Sep '
         || IAPICONSTANTCOLUMN.DECSEPCOL;
      RETURN( LCBASECOLUMNS );
   END GETCOLUMNSNUTRITIONALLOG;


   FUNCTION GETCOLUMNSNUTLOGRESULT(
      ASALIAS                    IN       IAPITYPE.STRING_TYPE DEFAULT '' )
      RETURN IAPITYPE.BASECOLUMNS_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetColumnsNutLogResult';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LCBASECOLUMNS                 IAPITYPE.BASECOLUMNS_TYPE := NULL;
      LSALIAS                       IAPITYPE.STRING_TYPE := NULL;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( ASALIAS != '' )
      THEN
         NULL;
      ELSE
         LSALIAS :=    ASALIAS
                    || '.';
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSALIAS,
                           IAPICONSTANT.INFOLEVEL_3 );
      LCBASECOLUMNS :=
            LSALIAS
         || 'Log_id '
         || IAPICONSTANTCOLUMN.LOGIDCOL
         || ','
         || LSALIAS
         || 'Col_id '
         || IAPICONSTANTCOLUMN.COLUMNIDCOL
         || ','
         || LSALIAS
         || 'row_id '
         || IAPICONSTANTCOLUMN.ROWIDCOL
         || ','
         || LSALIAS
         || 'Value '
         || IAPICONSTANTCOLUMN.VALUECOL
         || ','
         || LSALIAS
         || 'Property '
         || IAPICONSTANTCOLUMN.PROPERTYIDCOL
         || ','
         || LSALIAS
         || 'Property_rev '
         || IAPICONSTANTCOLUMN.PROPERTYREVISIONCOL
         || ', f_sph_descr( 1, nlr.Property, nlr.Property_rev ) '
         || IAPICONSTANTCOLUMN.PROPERTYCOL
         || ','
         || LSALIAS
         || 'Attribute '
         || IAPICONSTANTCOLUMN.ATTRIBUTEIDCOL
         || ','
         || LSALIAS
         || 'Attribute_rev '
         || IAPICONSTANTCOLUMN.ATTRIBUTEREVISIONCOL
         || ', f_ath_descr( 1, nlr.Attribute, nlr.Attribute_rev ) '
         || IAPICONSTANTCOLUMN.ATTRIBUTECOL;
      RETURN( LCBASECOLUMNS );
   END GETCOLUMNSNUTLOGRESULT;


   FUNCTION GETCOLSNUTLOGRESULTDETAIL(
      ASALIAS                    IN       IAPITYPE.STRING_TYPE DEFAULT '' )
      RETURN IAPITYPE.BASECOLUMNS_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetColsNutLogResultDetail';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LCBASECOLUMNS                 IAPITYPE.BASECOLUMNS_TYPE := NULL;
      LSALIAS                       IAPITYPE.STRING_TYPE := NULL;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( ASALIAS != '' )
      THEN
         NULL;
      ELSE
         LSALIAS :=    ASALIAS
                    || '.';
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSALIAS,
                           IAPICONSTANT.INFOLEVEL_3 );
      LCBASECOLUMNS :=
            LSALIAS
         || 'Log_id '
         || IAPICONSTANTCOLUMN.LOGIDCOL
         || ','
         || LSALIAS
         || 'Col_id '
         || IAPICONSTANTCOLUMN.COLUMNIDCOL
         || ','
         || LSALIAS
         || 'row_id '
         || IAPICONSTANTCOLUMN.ROWIDCOL
         || ','
         || LSALIAS
         || 'seq_no '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ','
         || LSALIAS
         || 'part_no '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ','
         || LSALIAS
         || 'Revision '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', f_shh_descr( 1, nlrd.part_no ) '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ','
         || LSALIAS
         || 'Display_Name '
         || IAPICONSTANTCOLUMN.DISPLAYNAMECOL
         || ','
         || LSALIAS
         || 'Value '
         || IAPICONSTANTCOLUMN.VALUECOL;
      RETURN( LCBASECOLUMNS );
   END GETCOLSNUTLOGRESULTDETAIL;





   FUNCTION GETREFERENCESPECIFICATIONS(
      AQREFSPECIFICATIONS        OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetReferenceSpecifications';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' nrt.Part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', sh.Revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', Ref_Type '
            || IAPICONSTANTCOLUMN.REFTYPECOL
            || ', Name '
            || IAPICONSTANTCOLUMN.NAMECOL
            || ', F_Pgh_Descr(1, basic_Weight_Property_group, 0) '
            || IAPICONSTANTCOLUMN.NUTRBASICWEIGHTPGCOL
            || ', basic_Weight_Property_group '
            || IAPICONSTANTCOLUMN.NUTRBASICWEIGHTPGIDCOL
            || ', F_Sph_Descr(1, basic_Weight_Property, 0) '
            || IAPICONSTANTCOLUMN.NUTRBASICWEIGHTPROPERTYCOL
            || ', basic_Weight_Property '
            || IAPICONSTANTCOLUMN.NUTRBASICWEIGHTPROPERTYIDCOL
            || ', basic_Weight_Value_Col '
            || IAPICONSTANTCOLUMN.NUTRBASICWEIGHTVALUEIDCOL
            || ', F_Sch_Descr(1, Section_ID, 0) || ''['' || F_Sbh_Descr(1, sub_Section_ID, 0) || '']'' '
            || IAPICONSTANTCOLUMN.NUTRSECTSUBSECTCOL
            || ', Section_id '
            || IAPICONSTANTCOLUMN.SECTIONCOL
            || ', sub_Section_id '
            || IAPICONSTANTCOLUMN.SUBSECTIONCOL
            || ', F_Pgh_Descr(1, Property_group, 0) '
            || IAPICONSTANTCOLUMN.PROPERTYGROUPCOL
            || ', Property_group '
            || IAPICONSTANTCOLUMN.PROPERTYGROUPIDCOL
            || ', Value_Col '
            || IAPICONSTANTCOLUMN.HEADERIDCOL
            || ', note '
            || IAPICONSTANTCOLUMN.NUTRNOTEIDCOL
            || ', F_Sch_Descr(1, round_Section_ID, 0) || ''['' || F_Sbh_Descr(1, round_sub_Section_ID, 0) || '']'' '
            || IAPICONSTANTCOLUMN.NUTRROUNDINGSECTSUBSECTCOL
            || ', round_Section_id '
            || IAPICONSTANTCOLUMN.NUTRROUNDINGSECTIONCOL
            || ', round_sub_Section_id '
            || IAPICONSTANTCOLUMN.NUTRROUNDINGSUBSECTIONCOL
            || ', F_Pgh_Descr(1, round_Property_group, 0) '
            || IAPICONSTANTCOLUMN.NUTRROUNDINGPGCOL
            || ', round_Property_group '
            || IAPICONSTANTCOLUMN.NUTRROUNDINGPGIDCOL
            || ', round_Value_Col '
            || IAPICONSTANTCOLUMN.NUTRROUNDINGVALUEIDCOL
            || ', round_rda_Col '
            || IAPICONSTANTCOLUMN.NUTRROUNDINGRDAIDCOL
            || ', F_Sch_Descr(1, energy_Section_ID, 0) || ''['' || F_Sbh_Descr(1, energy_sub_Section_ID, 0) || '']'' '
            || IAPICONSTANTCOLUMN.NUTRENERGYSECTSUBSECTCOL
            || ', energy_Section_id '
            || IAPICONSTANTCOLUMN.NUTRENERGYSECTIONCOL
            || ', energy_sub_Section_id '
            || IAPICONSTANTCOLUMN.NUTRENERGYSUBSECTIONCOL
            || ', F_Pgh_Descr(1, energy_Property_group, 0) '
            || IAPICONSTANTCOLUMN.NUTRENERGYPGCOL
            || ', energy_Property_group '
            || IAPICONSTANTCOLUMN.NUTRENERGYPGIDCOL
            || ', F_Sph_Descr(1, energy_Kcal_Property, 0) '
            || IAPICONSTANTCOLUMN.NUTRENERGYPROPERTYKCALCOL
            || ', energy_Kcal_Property '
            || IAPICONSTANTCOLUMN.NUTRENERGYPROPERTYKCALIDCOL
            || ', F_Sph_Descr(1, energy_Kj_Property, 0) '
            || IAPICONSTANTCOLUMN.NUTRENERGYPROPERTYKJCOL
            || ', energy_Kj_Property '
            || IAPICONSTANTCOLUMN.NUTRENERGYPROPERTYKJIDCOL
            || ', F_Ath_Descr(1, energy_Kcal_Attribute, 0) '
            || IAPICONSTANTCOLUMN.NUTRENERGYATTRIBUTEKCALCOL
            || ', energy_Kcal_Attribute '
            || IAPICONSTANTCOLUMN.NUTRENERGYATTRIBUTEKCALIDCOL
            || ', F_Ath_Descr(1, energy_Kj_Attribute, 0) '
            || IAPICONSTANTCOLUMN.NUTRENERGYATTRIBUTEKJCOL
            || ', energy_Kj_Attribute '
            || IAPICONSTANTCOLUMN.NUTRENERGYATTRIBUTEKJIDCOL
            || ', energy_Kcal_Col '
            || IAPICONSTANTCOLUMN.NUTRENERGYKCALVALUEIDCOL
            || ', energy_Kj_Col '
            || IAPICONSTANTCOLUMN.NUTRENERGYKJVALUEIDCOL
            || ', F_Sch_Descr(1, Serving_Section_ID, 0) || ''['' || F_Sbh_Descr(1, Serving_sub_Section_ID, 0) || '']'' '
            || IAPICONSTANTCOLUMN.NUTRSERVINGSECTSUBSECTCOL
            || ', Serving_Section_id '
            || IAPICONSTANTCOLUMN.NUTRSERVINGSECTIONCOL
            || ', Serving_sub_Section_id '
            || IAPICONSTANTCOLUMN.NUTRSERVINGSUBSECTIONCOL
            || ', F_Pgh_Descr(1, Serving_Property_group, 0) '
            || IAPICONSTANTCOLUMN.NUTRSERVINGPGCOL
            || ', Serving_Property_group '
            || IAPICONSTANTCOLUMN.NUTRSERVINGPGIDCOL
            || ', Serving_Value_Col '
            || IAPICONSTANTCOLUMN.NUTRSERVINGVALUECOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM Specification_Header sh,  itNutRefType nrt, Status st ';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE
         :=    ' WHERE  sh.Part_NO = nrt.Part_No '


            || ' AND	   f_Check_Access_nutr(sh.Part_No,sh.Revision) > 0 '

            || ' AND	   st.Status = sh.Status '
            || ' AND st.Status_Type = ''CURRENT'' ';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      
      
      LSORDERBY                     IAPITYPE.SQLSTRING_TYPE := ' ORDER BY  ' || IAPICONSTANTCOLUMN.REFTYPECOL;
   BEGIN





      LSSQL :=    'Select '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || ' AND 1=2 ';

      OPEN AQREFSPECIFICATIONS FOR LSSQL;

      
      
      




      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               
               
               || LSWHERE
               || LSORDERBY;
               

      IF ( AQREFSPECIFICATIONS%ISOPEN )
      THEN
         CLOSE AQREFSPECIFICATIONS;
      END IF;

      OPEN AQREFSPECIFICATIONS FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'Select '
                  || LSSELECT
                  || LSFROM
                  || LSWHERE
                  || ' AND 1=2 ';

         IF AQREFSPECIFICATIONS%ISOPEN
         THEN
            CLOSE AQREFSPECIFICATIONS;
         END IF;

         OPEN AQREFSPECIFICATIONS FOR LSSQL;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETREFERENCESPECIFICATIONS;


   FUNCTION ADDREFERENCESPECIFICATION(
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      ASNAME                     IN       IAPITYPE.NAME_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANBASICWEIGHTPROPERTYGROUPID IN     IAPITYPE.ID_TYPE,
      ANBASICWEIGHTPROPERTYID    IN       IAPITYPE.ID_TYPE,
      ANBASICWEIGHTVALUEID       IN       IAPITYPE.ID_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPID          IN       IAPITYPE.ID_TYPE,
      ANHEADERID                 IN       IAPITYPE.ID_TYPE,
      ANNOTEID                   IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANROUNDINGSECTIONID        IN       IAPITYPE.ID_TYPE,
      ANROUNDINGSUBSECTIONID     IN       IAPITYPE.ID_TYPE,
      ANROUNDINGPROPERTYGROUPID  IN       IAPITYPE.ID_TYPE,
      ANROUNDINGVALUEID          IN       IAPITYPE.ID_TYPE,
      ANROUNDINGRDAID            IN       IAPITYPE.ID_TYPE,
      ANENERGYSECTIONID          IN       IAPITYPE.ID_TYPE,
      ANENERGYSUBSECTIONID       IN       IAPITYPE.ID_TYPE,
      ANENERGYPROPERTYGROUPID    IN       IAPITYPE.ID_TYPE,
      ANENERGYPROPERTYKCAL       IN       IAPITYPE.ID_TYPE,
      ANENERGYPROPERTYKJ         IN       IAPITYPE.ID_TYPE,
      ANENERGYATTRIBUTEKCAL      IN       IAPITYPE.ID_TYPE,
      ANENERGYATTRIBUTEKJ        IN       IAPITYPE.ID_TYPE,
      ANENERGYKCALVALUEID        IN       IAPITYPE.ID_TYPE,
      ANENERGYKJVALUEID          IN       IAPITYPE.ID_TYPE,
      ANSERVINGSECTIONID         IN       IAPITYPE.ID_TYPE,
      ANSERVINGSUBSECTIONID      IN       IAPITYPE.ID_TYPE,
      ANSERVINGPROPERTYGROUPID   IN       IAPITYPE.ID_TYPE,
      ANSERVINGCOLID             IN       IAPITYPE.ID_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddReferenceSpecification';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN





      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ASNUTREFTYPE IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Nutritional Ref Type' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asNutRefType ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ASNAME IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Nutritional Name' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asName ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ASPARTNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PartNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartNo ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANSECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Section' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSectionId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANSUBSECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SubSection' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSubSectionId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANPROPERTYGROUPID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PropertyGroup' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anPropertyGroupId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANHEADERID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'NumericValue' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anHeaderId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANROUNDINGSECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'RoundingSection' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRoundingSectionId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANROUNDINGSUBSECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'RoundingSubSection' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRoundingSubSectionId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANROUNDINGPROPERTYGROUPID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'RoundingPropertyGroup' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRoundingPropertyGroupId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANROUNDINGVALUEID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'RoundingValue' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRoundingValueId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANROUNDINGRDAID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'RoundingRDA' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRoundingRdaId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANENERGYPROPERTYKCAL IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'EnergyPropertyKcal' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anEnergyPropertyKcal ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANENERGYPROPERTYKJ IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'EnergyPropertyKj' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anEnergyPropertyKj ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANENERGYATTRIBUTEKCAL IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'EnergyAttributeKcal' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anEnergyAttributeKcal ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANENERGYATTRIBUTEKJ IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'EnergyAttributeKj' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anEnergyAttributeKj ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANENERGYKCALVALUEID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'EnergyKcalValue' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anEnergyKcalValueId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANENERGYKJVALUEID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'EnergyKjValue' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anEnergyKjValueId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANSERVINGSECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'ServingSection' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anServingSectionId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANSERVINGSUBSECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'ServingSubSection' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anServingSubSectionId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANSERVINGPROPERTYGROUPID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'ServingPropertyGroup' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anServingPropertyGroupId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANSERVINGCOLID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'ServingCol' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anServingColId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );
         RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
      END IF;

      
      LNRETVAL := EXISTREFERENCESPECIFICATION( ASNUTREFTYPE );

      IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NUTREFSPECALREADYEXIST );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN( IAPICONSTANTDBERROR.DBERR_NUTREFSPECALREADYEXIST );
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      INSERT INTO ITNUTREFTYPE
                  ( REF_TYPE,
                    PART_NO,
                    NAME,
                    BASIC_WEIGHT_PROPERTY_GROUP,
                    BASIC_WEIGHT_PROPERTY,
                    BASIC_WEIGHT_VALUE_COL,
                    SECTION_ID,
                    SUB_SECTION_ID,
                    PROPERTY_GROUP,
                    VALUE_COL,
                    NOTE,
                    ROUND_SECTION_ID,
                    ROUND_SUB_SECTION_ID,
                    ROUND_PROPERTY_GROUP,
                    ROUND_VALUE_COL,
                    ROUND_RDA_COL,
                    ENERGY_SECTION_ID,
                    ENERGY_SUB_SECTION_ID,
                    ENERGY_PROPERTY_GROUP,
                    ENERGY_KCAL_PROPERTY,
                    ENERGY_KJ_PROPERTY,
                    ENERGY_KCAL_ATTRIBUTE,
                    ENERGY_KJ_ATTRIBUTE,
                    ENERGY_KCAL_COL,
                    ENERGY_KJ_COL,
                    SERVING_SECTION_ID,
                    SERVING_SUB_SECTION_ID,
                    SERVING_PROPERTY_GROUP,
                    SERVING_VALUE_COL )
           VALUES ( ASNUTREFTYPE,
                    ASPARTNO,
                    ASNAME,
                    ANBASICWEIGHTPROPERTYGROUPID,
                    ANBASICWEIGHTPROPERTYID,
                    ANBASICWEIGHTVALUEID,
                    ANSECTIONID,
                    ANSUBSECTIONID,
                    ANPROPERTYGROUPID,
                    ANHEADERID,
                    ANNOTEID,
                    ANROUNDINGSECTIONID,
                    ANROUNDINGSUBSECTIONID,
                    ANROUNDINGPROPERTYGROUPID,
                    ANROUNDINGVALUEID,
                    ANROUNDINGRDAID,
                    ANENERGYSECTIONID,
                    ANENERGYSUBSECTIONID,
                    ANENERGYPROPERTYGROUPID,
                    ANENERGYPROPERTYKCAL,
                    ANENERGYPROPERTYKJ,
                    ANENERGYATTRIBUTEKCAL,
                    ANENERGYATTRIBUTEKJ,
                    ANENERGYKCALVALUEID,
                    ANENERGYKJVALUEID,
                    ANSERVINGSECTIONID,
                    ANSERVINGSUBSECTIONID,
                    ANSERVINGPROPERTYGROUPID,
                    ANSERVINGCOLID );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDREFERENCESPECIFICATION;


   FUNCTION SAVEREFERENCESPECIFICATION(
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      ASNAME                     IN       IAPITYPE.NAME_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANBASICWEIGHTPROPERTYGROUPID IN     IAPITYPE.ID_TYPE,
      ANBASICWEIGHTPROPERTYID    IN       IAPITYPE.ID_TYPE,
      ANBASICWEIGHTVALUEID       IN       IAPITYPE.ID_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPID          IN       IAPITYPE.ID_TYPE,
      ANHEADERID                 IN       IAPITYPE.ID_TYPE,
      ANNOTEID                   IN       IAPITYPE.ID_TYPE DEFAULT NULL,
      ANROUNDINGSECTIONID        IN       IAPITYPE.ID_TYPE,
      ANROUNDINGSUBSECTIONID     IN       IAPITYPE.ID_TYPE,
      ANROUNDINGPROPERTYGROUPID  IN       IAPITYPE.ID_TYPE,
      ANROUNDINGVALUEID          IN       IAPITYPE.ID_TYPE,
      ANROUNDINGRDAID            IN       IAPITYPE.ID_TYPE,
      ANENERGYSECTIONID          IN       IAPITYPE.ID_TYPE,
      ANENERGYSUBSECTIONID       IN       IAPITYPE.ID_TYPE,
      ANENERGYPROPERTYGROUPID    IN       IAPITYPE.ID_TYPE,
      ANENERGYPROPERTYKCAL       IN       IAPITYPE.ID_TYPE,
      ANENERGYPROPERTYKJ         IN       IAPITYPE.ID_TYPE,
      ANENERGYATTRIBUTEKCAL      IN       IAPITYPE.ID_TYPE,
      ANENERGYATTRIBUTEKJ        IN       IAPITYPE.ID_TYPE,
      ANENERGYKCALVALUEID        IN       IAPITYPE.ID_TYPE,
      ANENERGYKJVALUEID          IN       IAPITYPE.ID_TYPE,
      ANSERVINGSECTIONID         IN       IAPITYPE.ID_TYPE,
      ANSERVINGSUBSECTIONID      IN       IAPITYPE.ID_TYPE,
      ANSERVINGPROPERTYGROUPID   IN       IAPITYPE.ID_TYPE,
      ANSERVINGCOLID             IN       IAPITYPE.ID_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveReferenceSpecification';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
    




      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ASNUTREFTYPE IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Nutritional Ref Type' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asNutRefType ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ASNAME IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Nutritional Name' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asName ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ASPARTNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PartNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartNo ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANSECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Section' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSectionId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANSUBSECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SubSection' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSubSectionId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANPROPERTYGROUPID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PropertyGroup' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anPropertyGroupId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANHEADERID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'NumericValue' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anHeaderId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANROUNDINGSECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'RoundingSection' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRoundingSectionId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANROUNDINGSUBSECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'RoundingSubSection' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRoundingSubSectionId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANROUNDINGPROPERTYGROUPID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'RoundingPropertyGroup' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRoundingPropertyGroupId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANROUNDINGVALUEID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'RoundingValue' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRoundingValueId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANROUNDINGRDAID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'RoundingRDA' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRoundingRdaId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANENERGYPROPERTYKCAL IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'EnergyPropertyKcal' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anEnergyPropertyKcal ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANENERGYPROPERTYKJ IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'EnergyPropertyKj' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anEnergyPropertyKj ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANENERGYATTRIBUTEKCAL IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'EnergyAttributeKcal' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anEnergyAttributeKcal ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANENERGYATTRIBUTEKJ IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'EnergyAttributeKj' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anEnergyAttributeKj ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANENERGYPROPERTYKCAL IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'EnergyPropertyKcal' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anEnergyPropertyKcal ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANENERGYPROPERTYKJ IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'EnergyPropertyKj' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anEnergyPropertyKj ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANENERGYKCALVALUEID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'EnergyKcalValue' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anEnergyKcalValueId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANENERGYKJVALUEID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'EnergyKjValue' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anEnergyKjValueId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANSERVINGSECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'ServingSection' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anServingSectionId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANSERVINGSUBSECTIONID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'ServingSubSection' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anServingSubSectionId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANSERVINGPROPERTYGROUPID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'ServingPropertyGroup' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anServingPropertyGroupId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANSERVINGCOLID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'ServingCol' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anServingColId ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );
         RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
      END IF;

      
      LNRETVAL := EXISTREFERENCESPECIFICATION( ASNUTREFTYPE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     LNRETVAL,
                                                     ASNUTREFTYPE ) );
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      UPDATE ITNUTREFTYPE
         SET PART_NO = ASPARTNO,
             NAME = ASNAME,
             BASIC_WEIGHT_PROPERTY_GROUP = ANBASICWEIGHTPROPERTYGROUPID,
             BASIC_WEIGHT_PROPERTY = ANBASICWEIGHTPROPERTYID,
             BASIC_WEIGHT_VALUE_COL = ANBASICWEIGHTVALUEID,
             SECTION_ID = ANSECTIONID,
             SUB_SECTION_ID = ANSUBSECTIONID,
             PROPERTY_GROUP = ANPROPERTYGROUPID,
             VALUE_COL = ANHEADERID,
             NOTE = ANNOTEID,
             ROUND_SECTION_ID = ANROUNDINGSECTIONID,
             ROUND_SUB_SECTION_ID = ANROUNDINGSUBSECTIONID,
             ROUND_PROPERTY_GROUP = ANROUNDINGPROPERTYGROUPID,
             ROUND_VALUE_COL = ANROUNDINGVALUEID,
             ROUND_RDA_COL = ANROUNDINGRDAID,
             ENERGY_SECTION_ID = ANENERGYSECTIONID,
             ENERGY_SUB_SECTION_ID = ANENERGYSUBSECTIONID,
             ENERGY_PROPERTY_GROUP = ANENERGYPROPERTYGROUPID,
             ENERGY_KCAL_PROPERTY = ANENERGYPROPERTYKCAL,
             ENERGY_KJ_PROPERTY = ANENERGYPROPERTYKJ,
             ENERGY_KCAL_ATTRIBUTE = ANENERGYATTRIBUTEKCAL,
             ENERGY_KJ_ATTRIBUTE = ANENERGYATTRIBUTEKJ,
             ENERGY_KCAL_COL = ANENERGYKCALVALUEID,
             ENERGY_KJ_COL = ANENERGYKJVALUEID,
             SERVING_SECTION_ID = ANSERVINGSECTIONID,
             SERVING_SUB_SECTION_ID = ANSERVINGSUBSECTIONID,
             SERVING_PROPERTY_GROUP = ANSERVINGPROPERTYGROUPID,
             SERVING_VALUE_COL = ANSERVINGCOLID
       WHERE REF_TYPE = ASNUTREFTYPE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEREFERENCESPECIFICATION;


   FUNCTION REMOVEREFERENCESPECIFICATION(
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveReferenceSpecification';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN








      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ASNUTREFTYPE IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Nutritional Ref Type' );
      END IF;

       
      

      


      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := EXISTREFERENCESPECIFICATION( ASNUTREFTYPE );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     LNRETVAL,
                                                     ASNUTREFTYPE ) );
      END IF;

      DELETE FROM ITNUTREFTYPE
            WHERE REF_TYPE = ASNUTREFTYPE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEREFERENCESPECIFICATION;


   FUNCTION EXISTREFERENCESPECIFICATION(
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistReferenceSpecification';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSNUTREFTYPE                  IAPITYPE.NUTREFTYPE_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT REF_TYPE
        INTO LSNUTREFTYPE
        FROM ITNUTREFTYPE
       WHERE REF_TYPE = ASNUTREFTYPE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NUTREFSPECNOTFOUND,
                                                    ASNUTREFTYPE );
      
      
      
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTREFERENCESPECIFICATION;


   FUNCTION EXISTFILTER(
      ANID                       IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistFilter';
      LNID                          IAPITYPE.ID_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT ID
        INTO LNID
        FROM ITNUTFILTER
       WHERE ID = ANID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NUTFILTERNOTFOUND,
                                                    ANID );
      
      
      
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTFILTER;


   FUNCTION EXISTFILTERNAME(
      ASNAME                     IN       IAPITYPE.NAME_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistFilterName';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNID                          IAPITYPE.ID_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT ID
        INTO LNID
        FROM ITNUTFILTER
       WHERE NAME = UPPER( ASNAME );

      RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                 LSMETHOD,
                                                 IAPICONSTANTDBERROR.DBERR_NUTFILTERNAMEFOUND,
                                                 ASNAME,
                                                 LNID );
   
   
   
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTFILTERNAME;


   FUNCTION GETALLFILTERS(
      AQFILTERS                  OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetAllFilters';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' ID '
            || IAPICONSTANTCOLUMN.IDCOL
            || ' ,Name '
            || IAPICONSTANTCOLUMN.NAMECOL
            || ' ,Description '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ' ,Created_On '
            || IAPICONSTANTCOLUMN.CREATEDONCOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM itnutFilter ';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN





      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || ' WHERE 1=2 ';

      OPEN AQFILTERS FOR LSSQL;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || ' ORDER BY 2 ';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      IF AQFILTERS%ISOPEN
      THEN
         CLOSE AQFILTERS;
      END IF;

      OPEN AQFILTERS FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'SELECT '
                  || LSSELECT
                  || LSFROM
                  || ' WHERE 1=2 ';

         IF AQFILTERS%ISOPEN
         THEN
            CLOSE AQFILTERS;
         END IF;

         OPEN AQFILTERS FOR LSSQL;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETALLFILTERS;


   FUNCTION ADDFILTER(
      ASNAME                     IN       IAPITYPE.NAME_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ATFILTERDETAILS            IN       IAPITYPE.NUTFILTERDETAILSTAB_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddFilters';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNFILTERID                    IAPITYPE.ID_TYPE;
      LSROWID                       IAPITYPE.STRING_TYPE;
   BEGIN
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      LNRETVAL := EXISTFILTERNAME( ASNAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT NUTFILTER_ID_SEQ.NEXTVAL
        INTO LNFILTERID
        FROM DUAL;

      INSERT INTO ITNUTFILTER
                  ( ID,
                    NAME,
                    DESCRIPTION,
                    CREATED_ON )
           VALUES ( LNFILTERID,
                    UPPER( ASNAME ),
                    ASDESCRIPTION,
                    SYSDATE );

      IF ATFILTERDETAILS.COUNT > 0
      THEN
         FOR I IN ATFILTERDETAILS.FIRST .. ATFILTERDETAILS.LAST
         LOOP
            LSROWID :=    'ROW='
                       || ( I );
            LNRETVAL := IAPIPROPERTY.EXISTPROPERTY( ATFILTERDETAILS( I ).PROPERTYID,
                                                    ATFILTERDETAILS( I ).PROPERTYREVISION );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    IAPIGENERAL.GETLASTERRORTEXT( ) );
               LNRETVAL :=
                  IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                              || ' <'
                                              || IAPICONSTANTCOLUMN.PROPERTYCOL
                                              || ','
                                              || IAPICONSTANTCOLUMN.PROPERTYREVISIONCOL
                                              || '>',
                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                              GTERRORS );
            END IF;

            LNRETVAL := IAPIATTRIBUTE.EXISTATTRIBUTE( ATFILTERDETAILS( I ).ATTRIBUTEID,
                                                      ATFILTERDETAILS( I ).ATTRIBUTEREVISION );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    IAPIGENERAL.GETLASTERRORTEXT( ) );
               LNRETVAL :=
                  IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                              || ' <'
                                              || IAPICONSTANTCOLUMN.ATTRIBUTECOL
                                              || ','
                                              || IAPICONSTANTCOLUMN.ATTRIBUTEREVISIONCOL
                                              || '>',
                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                              GTERRORS );
            END IF;

            INSERT INTO ITNUTFILTERDETAILS
                        ( ID,
                          SEQ,
                          PROPERTY_ID,
                          PROPERTY_REV,
                          ATTRIBUTE_ID,
                          ATTRIBUTE_REV,
                          VISIBLE )
                 VALUES ( LNFILTERID,
                          ATFILTERDETAILS( I ).SEQUENCE,
                          ATFILTERDETAILS( I ).PROPERTYID,
                          ATFILTERDETAILS( I ).PROPERTYREVISION,
                          ATFILTERDETAILS( I ).ATTRIBUTEID,
                          ATFILTERDETAILS( I ).ATTRIBUTEREVISION,
                          ATFILTERDETAILS( I ).VISIBLE );
         END LOOP;
      END IF;

      IF GTERRORS.COUNT = 0
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      ELSIF GTERRORS.COUNT > 0
      THEN
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_ERRORLIST );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDFILTER;


   FUNCTION ADDFILTER(
      ASNAME                     IN       IAPITYPE.NAME_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      AXFILTERDETAILS            IN       IAPITYPE.XMLTYPE_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddFilters';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTFILTERDETAILS               IAPITYPE.NUTFILTERDETAILSTAB_TYPE;
   BEGIN
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := TRANSFORMXMLNUTFILTER( AXFILTERDETAILS,
                                         LTFILTERDETAILS,
                                         AQERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LNRETVAL := ADDFILTER( ASNAME,
                             ASDESCRIPTION,
                             LTFILTERDETAILS,
                             AQERRORS );

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
   END ADDFILTER;


   FUNCTION SAVEFILTER(
      ANID                       IN       IAPITYPE.ID_TYPE,
      ASNAME                     IN       IAPITYPE.NAME_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ATFILTERDETAILS            IN       IAPITYPE.NUTFILTERDETAILSTAB_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveFilters';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSROWID                       IAPITYPE.STRING_TYPE;
      LNFILTERID                    IAPITYPE.ID_TYPE;
   BEGIN
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      BEGIN
         SELECT ID
           INTO LNFILTERID
           FROM ITNUTFILTER
          WHERE NAME = UPPER( ASNAME );

         UPDATE ITNUTFILTER
            SET DESCRIPTION = ASDESCRIPTION
          WHERE ID = LNFILTERID;

         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'UpDate ItnutFilter for ID <'
                              || LNFILTERID
                              || '>',
                              IAPICONSTANT.INFOLEVEL_3 );
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            SELECT NUTFILTER_ID_SEQ.NEXTVAL
              INTO LNFILTERID
              FROM DUAL;

            INSERT INTO ITNUTFILTER
                        ( ID,
                          NAME,
                          DESCRIPTION,
                          CREATED_ON )
                 VALUES ( LNFILTERID,
                          UPPER( ASNAME ),
                          ASDESCRIPTION,
                          SYSDATE );
      END;

      DELETE FROM ITNUTFILTERDETAILS
            WHERE ID = LNFILTERID;

      IF ATFILTERDETAILS.COUNT > 0
      THEN
         FOR I IN ATFILTERDETAILS.FIRST .. ATFILTERDETAILS.LAST
         LOOP
            LSROWID :=    'ROW='
                       || ( I );
            LNRETVAL := IAPIPROPERTY.EXISTPROPERTY( ATFILTERDETAILS( I ).PROPERTYID,
                                                    ATFILTERDETAILS( I ).PROPERTYREVISION );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    IAPIGENERAL.GETLASTERRORTEXT( ) );
               LNRETVAL :=
                  IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                              || ' <'
                                              || IAPICONSTANTCOLUMN.PROPERTYCOL
                                              || ','
                                              || IAPICONSTANTCOLUMN.PROPERTYREVISIONCOL
                                              || '>',
                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                              GTERRORS );
            END IF;

            LNRETVAL := IAPIATTRIBUTE.EXISTATTRIBUTE( ATFILTERDETAILS( I ).ATTRIBUTEID,
                                                      ATFILTERDETAILS( I ).ATTRIBUTEREVISION );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    IAPIGENERAL.GETLASTERRORTEXT( ) );
               LNRETVAL :=
                  IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                              || ' <'
                                              || IAPICONSTANTCOLUMN.ATTRIBUTECOL
                                              || ','
                                              || IAPICONSTANTCOLUMN.ATTRIBUTEREVISIONCOL
                                              || '>',
                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                              GTERRORS );
            END IF;

            INSERT INTO ITNUTFILTERDETAILS
                        ( ID,
                          SEQ,
                          PROPERTY_ID,
                          PROPERTY_REV,
                          ATTRIBUTE_ID,
                          ATTRIBUTE_REV,
                          VISIBLE )
                 VALUES ( LNFILTERID,
                          ATFILTERDETAILS( I ).SEQUENCE,
                          ATFILTERDETAILS( I ).PROPERTYID,
                          ATFILTERDETAILS( I ).PROPERTYREVISION,
                          ATFILTERDETAILS( I ).ATTRIBUTEID,
                          ATFILTERDETAILS( I ).ATTRIBUTEREVISION,
                          ATFILTERDETAILS( I ).VISIBLE );
         END LOOP;
      END IF;

      IF GTERRORS.COUNT = 0
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      ELSIF GTERRORS.COUNT > 0
      THEN
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_ERRORLIST );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEFILTER;


   FUNCTION SAVEFILTER(
      ANID                       IN       IAPITYPE.ID_TYPE,
      ASNAME                     IN       IAPITYPE.NAME_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      AXFILTERDETAILS            IN       IAPITYPE.XMLTYPE_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveFilters';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTFILTERDETAILS    IAPITYPE.NUTFILTERDETAILSTAB_TYPE;
   BEGIN
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := TRANSFORMXMLNUTFILTER( AXFILTERDETAILS,
                                         LTFILTERDETAILS,
                                         AQERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LNRETVAL := SAVEFILTER( ANID,
                              ASNAME,
                              ASDESCRIPTION,
                              LTFILTERDETAILS,
                              AQERRORS );

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
   END SAVEFILTER;


   FUNCTION GETFILTERDETAILS(
      ANID                       IN       IAPITYPE.ID_TYPE,
      AQFILTERDETAILS            OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetFilterDetails';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' ID '
            || IAPICONSTANTCOLUMN.IDCOL
            || ' ,Seq '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ' ,Property_Id '
            || IAPICONSTANTCOLUMN.PROPERTYCOL
            || ' ,Property_Rev '
            || IAPICONSTANTCOLUMN.PROPERTYREVISIONCOL
            || ' ,Attribute_Id '
            || IAPICONSTANTCOLUMN.ATTRIBUTECOL
            || ' ,Attribute_Rev '
            || IAPICONSTANTCOLUMN.ATTRIBUTEREVISIONCOL
            || ' ,CASE Attribute_id '
            || ' WHEN 0 THEN f_sph_Descr(1,Property_Id,Property_Rev) '
            || ' ELSE f_sph_Descr(1,Property_Id,Property_Rev)||'' ''||f_ath_descr(1,Attribute_Id,Attribute_Rev) '
            || ' END '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ' ,Visible '
            || IAPICONSTANTCOLUMN.VISIBLECOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM itNutFilterDetails ';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE := ' WHERE ID = :anId ';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN





      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || ' AND 1=2 '
               || ' ORDER BY 2 ';

      OPEN AQFILTERDETAILS FOR LSSQL USING ANID;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
       
       
      
      LNRETVAL := EXISTFILTER( ANID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || ' ORDER BY 2 ';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      IF AQFILTERDETAILS%ISOPEN
      THEN
         CLOSE AQFILTERDETAILS;
      END IF;

      OPEN AQFILTERDETAILS FOR LSSQL USING ANID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'SELECT '
                  || LSSELECT
                  || LSFROM
                  || LSWHERE
                  || ' AND 1=2 '
                  || ' ORDER BY 2 ';

         IF AQFILTERDETAILS%ISOPEN
         THEN
            CLOSE AQFILTERDETAILS;
         END IF;

         OPEN AQFILTERDETAILS FOR LSSQL USING ANID;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETFILTERDETAILS;


   FUNCTION REMOVEFILTER(
      ANID                       IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveFilters';
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

      DELETE FROM ITNUTFILTER
            WHERE ID = ANID;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NUTFILTERNOTFOUND,
                                                    ANID );
      
      
      
      END IF;

      DELETE FROM ITNUTFILTERDETAILS
            WHERE ID = ANID;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Delete Nutritional Filter - ID <'
                           || ANID
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
   END REMOVEFILTER;


   FUNCTION GETDEFAULTFILTER(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPID          IN       IAPITYPE.ID_TYPE,
      AQDEFAULTFILTERS           OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetDefaultFilter';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' 0 '
            || IAPICONSTANTCOLUMN.IDCOL
            || ' ,Sequence_no '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ' ,Property '
            || IAPICONSTANTCOLUMN.PROPERTYCOL
            || ' ,Property_Rev '
            || IAPICONSTANTCOLUMN.PROPERTYREVISIONCOL
            || ' ,Attribute '
            || IAPICONSTANTCOLUMN.ATTRIBUTECOL
            || ' ,Attribute_Rev '
            || IAPICONSTANTCOLUMN.ATTRIBUTEREVISIONCOL
            || ' ,CASE Attribute '
            || ' WHEN 0 THEN f_sph_Descr(1,Property,Property_Rev) '
            || ' ELSE f_sph_Descr(1,Property,Property_Rev)||'' ''||f_ath_descr(1,Attribute,Attribute_Rev) '
            || ' END '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM  specification_prop ';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE
         :=    ' WHERE part_no = :asPartNo '
            || ' AND Revision	  = :anRevision '
            || ' AND section_id = :anSectionId '
            || ' AND sub_section_id = :anSubSectionId '
            || ' AND Property_group = :anPropertyGroupId ';
      LSORDERBY                     IAPITYPE.SQLSTRING_TYPE := ' ORDER BY Sequence_no ';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN





      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || ' AND 1=2 '
               || LSORDERBY;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQDEFAULTFILTERS FOR LSSQL USING ASPARTNO,
      ANREVISION,
      ANSECTIONID,
      ANSUBSECTIONID,
      ANPROPERTYGROUPID;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      


      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || LSORDERBY;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      IF AQDEFAULTFILTERS%ISOPEN
      THEN
         CLOSE AQDEFAULTFILTERS;
      END IF;

      OPEN AQDEFAULTFILTERS FOR LSSQL USING ASPARTNO,
      ANREVISION,
      ANSECTIONID,
      ANSUBSECTIONID,
      ANPROPERTYGROUPID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETDEFAULTFILTER;


   FUNCTION GETSERVINGSIZES(
      ASREFTYPE                  IN       IAPITYPE.NUTREFTYPE_TYPE,
      AQSERVINGSIZES             OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetServingSizes';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNNUTRSERVINGCOL              IAPITYPE.ID_TYPE;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LNNUTRSERVINGSECTION          IAPITYPE.SEQUENCE_TYPE;
      LNNUTRSERVINGSUBSECTION       IAPITYPE.SEQUENCE_TYPE;
      LNNUTRSERVINGPG               IAPITYPE.SEQUENCE_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM Specification_prop sp ';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE
         :=    ' WHERE sp.Part_no = :lsPartNo '
            || ' AND sp.Revision =  :lnRevision '
            || ' AND sp.Section_Id	=  :lnNutrServingSection '
            || ' AND sp.Sub_Section_Id = :lnNutrServingSubSection '
            || ' AND sp.Property_group = :lnNutrServingPg ';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      LSSELECT :=
            ' sp.Property '
         || IAPICONSTANTCOLUMN.PROPERTYCOL
         || ' ,sp.Boolean_1 '
         || IAPICONSTANTCOLUMN.BOOLEAN1COL
         || ' ,sp.Num_1 '
         || IAPICONSTANTCOLUMN.NUMERICVALUECOL
         || ' ,f_sph_descr(1,sp.Property,sp.Property_rev) '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || ' AND 1=2 ';

      OPEN AQSERVINGSIZES FOR LSSQL USING LSPARTNO,
      LNREVISION,
      LNNUTRSERVINGSECTION,
      LNNUTRSERVINGSUBSECTION,
      LNNUTRSERVINGPG;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      BEGIN
         SELECT A.PART_NO,
                A.REVISION,
                C.SERVING_VALUE_COL,
                C.SERVING_SECTION_ID,
                C.SERVING_SUB_SECTION_ID,
                C.SERVING_PROPERTY_GROUP
           INTO LSPARTNO,
                LNREVISION,
                LNNUTRSERVINGCOL,
                LNNUTRSERVINGSECTION,
                LNNUTRSERVINGSUBSECTION,
                LNNUTRSERVINGPG
           FROM SPECIFICATION_HEADER A,
                STATUS B,
                ITNUTREFTYPE C
          WHERE C.REF_TYPE = ASREFTYPE
            AND A.STATUS = B.STATUS
            AND A.PART_NO = C.PART_NO
            AND STATUS_TYPE = IAPICONSTANT.STATUSTYPE_CURRENT;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_CURRENTREVISIONNOTFOUND,
                                                       ASREFTYPE );
      
      
      
      END;

      LSSELECT :=
            ' sp.Property '
         || IAPICONSTANTCOLUMN.PROPERTYCOL
         || ' ,sp.Boolean_1 '
         || IAPICONSTANTCOLUMN.BOOLEAN1COL
         || ' ,sp.Num_'
         || NVL( LNNUTRSERVINGCOL,
                 1 )
         || ' '
         || IAPICONSTANTCOLUMN.NUMERICVALUECOL
         || ' ,f_sph_descr(1,sp.Property,sp.Property_rev) '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
      LSWHERE :=    LSWHERE
                 || ' AND NVL(sp.Num_'
                 || NVL( LNNUTRSERVINGCOL,
                         1 )
                 || ' , 0) > 0 ';
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      IF AQSERVINGSIZES%ISOPEN
      THEN
         CLOSE AQSERVINGSIZES;
      END IF;

      OPEN AQSERVINGSIZES FOR LSSQL USING LSPARTNO,
      LNREVISION,
      LNNUTRSERVINGSECTION,
      LNNUTRSERVINGSUBSECTION,
      LNNUTRSERVINGPG;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'SELECT '
                  || LSSELECT
                  || LSFROM
                  || LSWHERE
                  || ' AND 1=2 ';

         IF AQSERVINGSIZES%ISOPEN
         THEN
            CLOSE AQSERVINGSIZES;
         END IF;

         OPEN AQSERVINGSIZES FOR LSSQL USING LSPARTNO,
         LNREVISION,
         LNNUTRSERVINGSECTION,
         LNNUTRSERVINGSUBSECTION,
         LNNUTRSERVINGPG;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETSERVINGSIZES;


   FUNCTION SETREFERENCES(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SetReferences';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSECTIONID                   IAPITYPE.SEQUENCE_TYPE;
      LNSUBSECTIONID                IAPITYPE.SEQUENCE_TYPE;
      LNPROPERTYGROUP               IAPITYPE.SEQUENCE_TYPE;
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

      SELECT SECTION_ID,
             SUB_SECTION_ID,
             PROPERTY_GROUP
        INTO LNSECTIONID,
             LNSUBSECTIONID,
             LNPROPERTYGROUP
        FROM ITNUTREFTYPE
       WHERE REF_TYPE = ASNUTREFTYPE;

      UPDATE ITNUTPATH
         SET SECTION_ID = LNSECTIONID,
             SUB_SECTION_ID = LNSUBSECTIONID,
             PROPERTY_GROUP = LNPROPERTYGROUP
       WHERE BOM_EXP_NO = ANUNIQUEID;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NUTPATHNOTFOUND,
                                                    ANUNIQUEID );
      
      
      
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SETREFERENCES;



   FUNCTION CALCULATEREVERSEVALUE(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      ANCOLID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANLOGID                    IN       IAPITYPE.LOGID_TYPE,
      ANROWID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANOUTVAL                   OUT      IAPITYPE.NUMVAL_TYPE)
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CalculateReverseValue';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LQNUTLY                       IAPITYPE.REF_TYPE;
      LNLAYOUTID                    IAPITYPE.SEQUENCE_TYPE;
      LSLAYOUTDESCRIPTION           IAPITYPE.DESCRIPTION_TYPE;
      LNLAYOUTREVISION              IAPITYPE.REVISION_TYPE;
      LSCALCMETHODNAME              ITNUTLYITEM.CALC_METHOD%TYPE;
      LSNUTRESULTCALC               IAPITYPE.SQLSTRING_TYPE;
      LSCALCVALUE                   IAPITYPE.CLOB_TYPE;
  BEGIN
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      LNRETVAL := GETCURRENTNUTLY( LQNUTLY );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );

         CLOSE LQNUTLY;

         RETURN( LNRETVAL );
      END IF;

      FETCH LQNUTLY
       INTO LNLAYOUTID,
            LNLAYOUTREVISION,
            LSLAYOUTDESCRIPTION;

      IF LNLAYOUTID IS NULL
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_NUTLYNOTFOUND,
                                               LNLAYOUTID,
                                               LNLAYOUTREVISION );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

     
     BEGIN
         SELECT CALC_METHOD
         INTO LSCALCMETHODNAME
         FROM ITNUTLYITEM
         WHERE LAYOUT_ID = LNLAYOUTID
           AND REVISION = LNLAYOUTREVISION
           AND SEQ_NO = ANCOLID;
      EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            NULL;
    END;

    IF LSCALCMETHODNAME IS NOT NULL
    THEN
       BEGIN
          LSNUTRESULTCALC :=
                'BEGIN '
             || ':lnRetVal := '
             || LSCALCMETHODNAME || 'RV'
             || '('
             || ':asNutRefType,'
             || ':anRowId,'
             || ':anColId,'
             || ':anLogId,'
             || ':lsCalcValue);'
             || ' end;';

          EXECUTE IMMEDIATE LSNUTRESULTCALC
                      USING OUT LNRETVAL,
                            ASNUTREFTYPE,
                            ANROWID,
                            ANCOLID,
                            ANLOGID,
                            OUT LSCALCVALUE;

          IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
          THEN
             IAPIGENERAL.LOGERROR( GSSOURCE,
                                   LSMETHOD,
                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
             RETURN( LNRETVAL );
          END IF;

          ANOUTVAL := TO_NUMBER( LSCALCVALUE );
       EXCEPTION
          WHEN OTHERS
          THEN
             IF SQLCODE = -6550
             THEN
                LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_FUNCTIONNOTFOUND,
                                                      
                                                      
                                                      LSCALCMETHODNAME || 'RV',
                                                      
                                                      LSLAYOUTDESCRIPTION );
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
    END IF;

   RETURN (IAPICONSTANTDBERROR.DBERR_SUCCESS);

  EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
END CALCULATEREVERSEVALUE;


   FUNCTION EXPLODE(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      ATFILTERDETAILS            IN OUT   IAPITYPE.NUTFILTERDETAILSTAB_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Explode';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNNUTSEQUENCENO               IAPITYPE.SEQUENCE_TYPE := 0;
      LTNUTPATH                     IAPITYPE.NUTXMLTAB_TYPE;
      LRNUTEXPLOSION                IAPITYPE.NUTEXPLOSION_TYPE;
      LNSEQUENCE                    IAPITYPE.SEQUENCE_TYPE;
      
      
      
      LSUOM                         IAPITYPE.DESCRIPTION_TYPE;
      LNUOMMISMATCH                 IAPITYPE.NUMVAL_TYPE;
      
      LNTOTALBOMBASEQTY                 IAPITYPE.BOMQUANTITY_TYPE;
      LNTOTALNUTBASEQTY                 IAPITYPE.BOMQUANTITY_TYPE;
      
      

      
      LNCALCULATEDREVVALUE          IAPITYPE.FLOAT_TYPE;
      LNVALUECOL                    IAPITYPE.ID_TYPE;

      CURSOR LQSPECPROP(
         ASPARTNO                            IAPITYPE.PARTNO_TYPE,
         ANREVISION                          IAPITYPE.REVISION_TYPE,
         ANSECTIONID                         IAPITYPE.ID_TYPE,
         ANSUBSECTIONID                      IAPITYPE.ID_TYPE,
         ANPROPERTYGROUP                     IAPITYPE.ID_TYPE,
         ASALTPARTNO                         IAPITYPE.PARTNO_TYPE,
         ANALTREVISION                       IAPITYPE.REVISION_TYPE )
      IS
         SELECT *
           FROM SPECIFICATION_PROP
          WHERE PART_NO = NVL( ASALTPARTNO,
                               ASPARTNO )
            AND REVISION = NVL( ANALTREVISION,
                                ANREVISION )
            AND SECTION_ID = ANSECTIONID
            AND SUB_SECTION_ID = ANSUBSECTIONID
            AND PROPERTY_GROUP = ANPROPERTYGROUP;

      
      CURSOR LQNUTLOGRESULT(
         ANLOGID                            IAPITYPE.LOGID_TYPE,
         ANCOLID                            ITNUTLYITEM.SEQ_NO%TYPE)
      IS
        SELECT *
        FROM ITNUTLOGRESULT
        WHERE LOG_ID = ANLOGID
            AND COL_ID = ANCOLID;
      

      FUNCTION F_IS_IN_FILTER(
         ANPROPERTY                 IN       IAPITYPE.SEQUENCE_TYPE,
         ANATTRIBUTEID              IN       IAPITYPE.SEQUENCE_TYPE,
         ANSEQUENCE                 OUT      IAPITYPE.SEQUENCE_TYPE )
         RETURN IAPITYPE.ERRORNUM_TYPE
      IS
      BEGIN
         ANSEQUENCE := 0;

         IF ATFILTERDETAILS.COUNT > 0
         THEN
            FOR I IN ATFILTERDETAILS.FIRST .. ATFILTERDETAILS.LAST
            LOOP
               IF     ATFILTERDETAILS( I ).PROPERTYID = ANPROPERTY
                  AND ATFILTERDETAILS( I ).ATTRIBUTEID = ANATTRIBUTEID
               THEN
                  ATFILTERDETAILS( I ).USE := 1;
                  ANSEQUENCE := ATFILTERDETAILS( I ).SEQUENCE;
                  EXIT;
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
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      FUNCTION F_ADD_UNUSED_FILTER
         RETURN IAPITYPE.ERRORNUM_TYPE
      IS
         LNSEQUENCE                    IAPITYPE.SEQUENCE_TYPE DEFAULT 0;
         LNNUTRSEQUENCE                IAPITYPE.SEQUENCE_TYPE DEFAULT 0;
         LRNUTEXPLOSION                IAPITYPE.NUTEXPLOSION_TYPE DEFAULT NULL;
      BEGIN
         IF ATFILTERDETAILS.COUNT > 0
         THEN
            SELECT   NVL( MAX( SEQUENCE_NO ),
                          0 )
                   + 10
              INTO LNSEQUENCE
              FROM ITNUTEXPLOSION
             WHERE BOM_EXP_NO = ANUNIQUEID
               AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO;

            LRNUTEXPLOSION.BOM_EXP_NO := ANUNIQUEID;
            LRNUTEXPLOSION.MOP_SEQUENCE_NO := ANMOPSEQUENCENO;
            LRNUTEXPLOSION.SEQUENCE_NO := LNSEQUENCE;

            FOR I IN ATFILTERDETAILS.FIRST .. ATFILTERDETAILS.LAST
            LOOP
               IF NVL( ATFILTERDETAILS( I ).USE,
                       0 ) = 0
               THEN
                  LNNUTRSEQUENCE :=   LNNUTRSEQUENCE
                                    + 10;
                  LRNUTEXPLOSION.NUT_SEQUENCE_NO := LNNUTRSEQUENCE;
                  LRNUTEXPLOSION.PROPERTY := ATFILTERDETAILS( I ).PROPERTYID;
                  LRNUTEXPLOSION.PROPERTY_REV := ATFILTERDETAILS( I ).PROPERTYREVISION;
                  LRNUTEXPLOSION.ATTRIBUTE := ATFILTERDETAILS( I ).ATTRIBUTEID;
                  LRNUTEXPLOSION.ATTRIBUTE_REV := ATFILTERDETAILS( I ).ATTRIBUTEREVISION;
                  LRNUTEXPLOSION.ROW_ID := ATFILTERDETAILS( I ).SEQUENCE;

                  INSERT INTO ITNUTEXPLOSION
                              ( BOM_EXP_NO,
                                MOP_SEQUENCE_NO,
                                SEQUENCE_NO,
                                PART_NO,
                                REVISION,
                                PROPERTY_GROUP,
                                PROPERTY,
                                PROPERTY_REV,
                                ATTRIBUTE,
                                ATTRIBUTE_REV,
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
                                INFO,
                                BOOLEAN_1,
                                BOOLEAN_2,
                                BOOLEAN_3,
                                BOOLEAN_4,
                                DATE_1,
                                DATE_2,
                                CHARACTERISTIC_1,
                                CHARACTERISTIC_REV_1,
                                CHARACTERISTIC_2,
                                CHARACTERISTIC_REV_2,
                                CHARACTERISTIC_3,
                                CHARACTERISTIC_REV_3,
                                ASSOCIATION_1,
                                ASSOCIATION_REV_1,
                                ASSOCIATION_2,
                                ASSOCIATION_REV_2,
                                ASSOCIATION_3,
                                ASSOCIATION_REV_3,
                                TEST_METHOD,
                                TEST_METHOD_REV,
                                CALC_QTY,
                                UOM_ID,
                                UOM_REV,
                                PG_TYPE,
                                NUT_SEQUENCE_NO,
                                DISPLAY_NAME,
                                ROW_ID )
                       VALUES ( LRNUTEXPLOSION.BOM_EXP_NO,
                                LRNUTEXPLOSION.MOP_SEQUENCE_NO,
                                LRNUTEXPLOSION.SEQUENCE_NO,
                                LRNUTEXPLOSION.PART_NO,
                                LRNUTEXPLOSION.REVISION,
                                LRNUTEXPLOSION.PROPERTY_GROUP,
                                LRNUTEXPLOSION.PROPERTY,
                                LRNUTEXPLOSION.PROPERTY_REV,
                                LRNUTEXPLOSION.ATTRIBUTE,
                                LRNUTEXPLOSION.ATTRIBUTE_REV,
                                LRNUTEXPLOSION.NUM_1,
                                LRNUTEXPLOSION.NUM_2,
                                LRNUTEXPLOSION.NUM_3,
                                LRNUTEXPLOSION.NUM_4,
                                LRNUTEXPLOSION.NUM_5,
                                LRNUTEXPLOSION.NUM_6,
                                LRNUTEXPLOSION.NUM_7,
                                LRNUTEXPLOSION.NUM_8,
                                LRNUTEXPLOSION.NUM_9,
                                LRNUTEXPLOSION.NUM_10,
                                LRNUTEXPLOSION.CHAR_1,
                                LRNUTEXPLOSION.CHAR_2,
                                LRNUTEXPLOSION.CHAR_3,
                                LRNUTEXPLOSION.CHAR_4,
                                LRNUTEXPLOSION.CHAR_5,
                                LRNUTEXPLOSION.CHAR_6,
                                LRNUTEXPLOSION.INFO,
                                LRNUTEXPLOSION.BOOLEAN_1,
                                LRNUTEXPLOSION.BOOLEAN_2,
                                LRNUTEXPLOSION.BOOLEAN_3,
                                LRNUTEXPLOSION.BOOLEAN_4,
                                LRNUTEXPLOSION.DATE_1,
                                LRNUTEXPLOSION.DATE_2,
                                LRNUTEXPLOSION.CHARACTERISTIC_1,
                                LRNUTEXPLOSION.CHARACTERISTIC_REV_1,
                                LRNUTEXPLOSION.CHARACTERISTIC_2,
                                LRNUTEXPLOSION.CHARACTERISTIC_REV_2,
                                LRNUTEXPLOSION.CHARACTERISTIC_3,
                                LRNUTEXPLOSION.CHARACTERISTIC_REV_3,
                                LRNUTEXPLOSION.ASSOCIATION_1,
                                LRNUTEXPLOSION.ASSOCIATION_REV_1,
                                LRNUTEXPLOSION.ASSOCIATION_2,
                                LRNUTEXPLOSION.ASSOCIATION_REV_2,
                                LRNUTEXPLOSION.ASSOCIATION_3,
                                LRNUTEXPLOSION.ASSOCIATION_REV_3,
                                LRNUTEXPLOSION.TEST_METHOD,
                                LRNUTEXPLOSION.TEST_METHOD_REV,
                                LRNUTEXPLOSION.CALC_QTY,
                                LRNUTEXPLOSION.UOM_ID,
                                LRNUTEXPLOSION.UOM_REV,
                                LRNUTEXPLOSION.PG_TYPE,
                                LRNUTEXPLOSION.NUT_SEQUENCE_NO,
                                LRNUTEXPLOSION.DISPLAY_NAME,
                                LRNUTEXPLOSION.ROW_ID );
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
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;
   BEGIN
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );



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

      DELETE FROM ITNUTEXPLOSION
            WHERE BOM_EXP_NO = ANUNIQUEID
              AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO;

      DELETE FROM ITNUTRESULT
            WHERE BOM_EXP_NO = ANUNIQUEID
              AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO;

      DELETE FROM ITNUTRESULTDETAIL
            WHERE BOM_EXP_NO = ANUNIQUEID
              AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO;

      
      
      


      
      
      LNRETVAL := GETDOMINANTUOM_NUTRITIONAL( ANUNIQUEID,
      
                                  ANMOPSEQUENCENO,
                                  LSUOM );

      SELECT COUNT( * )
        INTO LNUOMMISMATCH
        FROM ITNUTPATH
       WHERE BOM_EXP_NO = ANUNIQUEID
         AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
         
         
         AND USE IN (1, 2)
         
         AND (    LSUOM NOT IN( NVL( UOM,
                                     ' ' ), NVL( TO_UNIT,
                                                 ' ' ) )
               OR (     UOM <> LSUOM
                    AND CONV_FACTOR IS NULL ) );

      IF LNUOMMISMATCH > 0
      THEN
         FOR I IN ( SELECT UOM,
                           TO_UNIT,
                           PART_NO,
                           REVISION
                          
                          , SEQUENCE_NO
                          
                     FROM ITNUTPATH
                    WHERE BOM_EXP_NO = ANUNIQUEID
                      AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                      
                      
                      AND USE IN (1, 2)
                      
                      AND (    LSUOM NOT IN( NVL( UOM,
                                                  ' ' ), NVL( TO_UNIT,
                                                              ' ' ) )
                            OR (     UOM <> LSUOM
                                 AND CONV_FACTOR IS NULL ) ) )
         LOOP


            LNRETVAL :=
               IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPICONSTANTDBERROR.DBERR_UOMMISMATCH2,
                                                   I.UOM,
                                                   I.TO_UNIT,
                                                   I.PART_NO,
                                                   I.REVISION,
                                                   LSUOM );
            
            
            
            
            
            
            

             
             
             UPDATE ITNUTPATH
                SET USE = 0
             WHERE BOM_EXP_NO = ANUNIQUEID
                AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                AND SEQUENCE_NO = I.SEQUENCE_NO;
             

         END LOOP;

         
         
         
         
         
         
         
         
         

         LNRETVAL := IAPICONSTANTDBERROR.DBERR_SUCCESS;
         

      END IF;

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

    



































      

      















































      

      SELECT QTY
        INTO LNTOTALBOMBASEQTY
        FROM ITBOMEXPLOSION
       WHERE BOM_EXP_NO = ANUNIQUEID
         AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
         AND BOM_LEVEL = 0;

      SELECT SUM( DECODE( UOM,
                          LSUOM, BASE_QTY,
                            BASE_QTY
                          * NVL( CONV_FACTOR,
                                 1 ) ) )

        INTO LNTOTALNUTBASEQTY
        FROM ITNUTPATH
       WHERE BOM_EXP_NO = ANUNIQUEID
         AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
         
         
         AND USE IN (1, 2)
         
         AND NUT_XML IS NULL;


      UPDATE ITNUTPATH
         SET CALC_QTY =   DECODE( UOM,
                                  LSUOM, BASE_QTY,
                                    BASE_QTY
                                  * NVL( CONV_FACTOR,
                                         1 ) )
                        * LNTOTALBOMBASEQTY
                        / LNTOTALNUTBASEQTY
       WHERE BOM_EXP_NO = ANUNIQUEID
         AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
         
         
         AND USE IN (1, 2)
         
         AND NUT_XML IS NULL;


      
      
      UPDATE ITNUTPATH
         SET CALC_QTY = DECODE( UOM,
                                LSUOM, BASE_QTY,
                                  BASE_QTY
                                * NVL( CONV_FACTOR,
                                       1 ) )
       WHERE BOM_EXP_NO = ANUNIQUEID
         AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
         
         
         AND USE IN (1, 2)
         
         AND NUT_XML IS NOT NULL;

      

      
      
      
      
      FOR NP1 IN ( SELECT *
                    FROM ITNUTPATH
                   WHERE BOM_EXP_NO = ANUNIQUEID
                     AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                     AND USE = 1
                     AND NUT_XML IS NULL )
      LOOP
         LNNUTSEQUENCENO := 0;

         FOR SP IN LQSPECPROP( NP1.PART_NO,
                               NP1.REVISION,
                               NP1.SECTION_ID,
                               NP1.SUB_SECTION_ID,
                               NP1.PROPERTY_GROUP,
                               NP1.ALT_PART_NO,
                               NP1.ALT_REVISION )
         LOOP
            LNRETVAL := F_IS_IN_FILTER( SP.PROPERTY,
                                        SP.ATTRIBUTE,
                                        LNSEQUENCE );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT );
               RETURN LNRETVAL;
            END IF;

            IF LNSEQUENCE != 0
            THEN
               LNNUTSEQUENCENO :=   LNNUTSEQUENCENO
                                  + 10;
               LRNUTEXPLOSION := NULL;
               LRNUTEXPLOSION.BOM_EXP_NO := NP1.BOM_EXP_NO;
               LRNUTEXPLOSION.MOP_SEQUENCE_NO := NP1.MOP_SEQUENCE_NO;
               LRNUTEXPLOSION.SEQUENCE_NO := NP1.SEQUENCE_NO;
               LRNUTEXPLOSION.NUT_SEQUENCE_NO := LNNUTSEQUENCENO;
               LRNUTEXPLOSION.PART_NO := SP.PART_NO;
               LRNUTEXPLOSION.REVISION := SP.REVISION;
               LRNUTEXPLOSION.PROPERTY_GROUP := SP.PROPERTY_GROUP;
               LRNUTEXPLOSION.PROPERTY := SP.PROPERTY;
               LRNUTEXPLOSION.PROPERTY_REV := SP.PROPERTY_REV;
               LRNUTEXPLOSION.ATTRIBUTE := SP.ATTRIBUTE;
               LRNUTEXPLOSION.ATTRIBUTE_REV := SP.ATTRIBUTE_REV;
               LRNUTEXPLOSION.NUM_1 := SP.NUM_1;
               LRNUTEXPLOSION.NUM_2 := SP.NUM_2;
               LRNUTEXPLOSION.NUM_3 := SP.NUM_3;
               LRNUTEXPLOSION.NUM_4 := SP.NUM_4;
               LRNUTEXPLOSION.NUM_5 := SP.NUM_5;
               LRNUTEXPLOSION.NUM_6 := SP.NUM_6;
               LRNUTEXPLOSION.NUM_7 := SP.NUM_7;
               LRNUTEXPLOSION.NUM_8 := SP.NUM_8;
               LRNUTEXPLOSION.NUM_9 := SP.NUM_9;
               LRNUTEXPLOSION.NUM_10 := SP.NUM_10;
               LRNUTEXPLOSION.CHAR_1 := SP.CHAR_1;
               LRNUTEXPLOSION.CHAR_2 := SP.CHAR_2;
               LRNUTEXPLOSION.CHAR_3 := SP.CHAR_3;
               LRNUTEXPLOSION.CHAR_4 := SP.CHAR_4;
               LRNUTEXPLOSION.CHAR_5 := SP.CHAR_5;
               LRNUTEXPLOSION.CHAR_6 := SP.CHAR_6;
               LRNUTEXPLOSION.INFO := SP.INFO;

               IF SP.BOOLEAN_1 IN( 'Y', '1' )
               THEN
                  LRNUTEXPLOSION.BOOLEAN_1 := 1;
               ELSE
                  LRNUTEXPLOSION.BOOLEAN_1 := 0;
               END IF;

               IF SP.BOOLEAN_2 IN( 'Y', '1' )
               THEN
                  LRNUTEXPLOSION.BOOLEAN_2 := 1;
               ELSE
                  LRNUTEXPLOSION.BOOLEAN_2 := 0;
               END IF;

               IF SP.BOOLEAN_3 IN( 'Y', '1' )
               THEN
                  LRNUTEXPLOSION.BOOLEAN_3 := 1;
               ELSE
                  LRNUTEXPLOSION.BOOLEAN_3 := 0;
               END IF;

               IF SP.BOOLEAN_4 IN( 'Y', '1' )
               THEN
                  LRNUTEXPLOSION.BOOLEAN_4 := 1;
               ELSE
                  LRNUTEXPLOSION.BOOLEAN_4 := 0;
               END IF;

               LRNUTEXPLOSION.DATE_1 := SP.DATE_1;
               LRNUTEXPLOSION.DATE_2 := SP.DATE_2;
               LRNUTEXPLOSION.CHARACTERISTIC_1 := SP.CHARACTERISTIC;
               LRNUTEXPLOSION.CHARACTERISTIC_REV_1 := SP.CHARACTERISTIC_REV;
               LRNUTEXPLOSION.CHARACTERISTIC_2 := SP.CH_2;
               LRNUTEXPLOSION.CHARACTERISTIC_REV_2 := SP.CH_REV_2;
               LRNUTEXPLOSION.CHARACTERISTIC_3 := SP.CH_3;
               LRNUTEXPLOSION.CHARACTERISTIC_REV_3 := SP.CH_REV_3;
               LRNUTEXPLOSION.ASSOCIATION_1 := SP.ASSOCIATION;
               LRNUTEXPLOSION.ASSOCIATION_REV_1 := SP.ASSOCIATION_REV;
               LRNUTEXPLOSION.ASSOCIATION_2 := SP.AS_2;
               LRNUTEXPLOSION.ASSOCIATION_REV_2 := SP.AS_REV_2;
               LRNUTEXPLOSION.ASSOCIATION_3 := SP.AS_3;
               LRNUTEXPLOSION.ASSOCIATION_REV_3 := SP.AS_REV_3;
               LRNUTEXPLOSION.TEST_METHOD := SP.TEST_METHOD;
               LRNUTEXPLOSION.TEST_METHOD_REV := SP.TEST_METHOD_REV;
               LRNUTEXPLOSION.DISPLAY_NAME := NP1.DISPLAY_NAME;
               LRNUTEXPLOSION.ROW_ID := LNSEQUENCE;
               LRNUTEXPLOSION.CALC_QTY := NP1.CALC_QTY;
               LRNUTEXPLOSION.UOM_ID := SP.UOM_ID;
               LRNUTEXPLOSION.UOM_REV := SP.UOM_REV;

               SELECT PG_TYPE
                 INTO LRNUTEXPLOSION.PG_TYPE
                 FROM PROPERTY_GROUP PG
                WHERE PG.PROPERTY_GROUP = SP.PROPERTY_GROUP;

               INSERT INTO ITNUTEXPLOSION
                           ( BOM_EXP_NO,
                             MOP_SEQUENCE_NO,
                             SEQUENCE_NO,
                             PART_NO,
                             REVISION,
                             PROPERTY_GROUP,
                             PROPERTY,
                             PROPERTY_REV,
                             ATTRIBUTE,
                             ATTRIBUTE_REV,
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
                             INFO,
                             BOOLEAN_1,
                             BOOLEAN_2,
                             BOOLEAN_3,
                             BOOLEAN_4,
                             DATE_1,
                             DATE_2,
                             CHARACTERISTIC_1,
                             CHARACTERISTIC_REV_1,
                             CHARACTERISTIC_2,
                             CHARACTERISTIC_REV_2,
                             CHARACTERISTIC_3,
                             CHARACTERISTIC_REV_3,
                             ASSOCIATION_1,
                             ASSOCIATION_REV_1,
                             ASSOCIATION_2,
                             ASSOCIATION_REV_2,
                             ASSOCIATION_3,
                             ASSOCIATION_REV_3,
                             TEST_METHOD,
                             TEST_METHOD_REV,
                             CALC_QTY,
                             UOM_ID,
                             UOM_REV,
                             PG_TYPE,
                             NUT_SEQUENCE_NO,
                             DISPLAY_NAME,
                             ROW_ID )
                    VALUES ( LRNUTEXPLOSION.BOM_EXP_NO,
                             LRNUTEXPLOSION.MOP_SEQUENCE_NO,
                             LRNUTEXPLOSION.SEQUENCE_NO,
                             LRNUTEXPLOSION.PART_NO,
                             LRNUTEXPLOSION.REVISION,
                             LRNUTEXPLOSION.PROPERTY_GROUP,
                             LRNUTEXPLOSION.PROPERTY,
                             LRNUTEXPLOSION.PROPERTY_REV,
                             LRNUTEXPLOSION.ATTRIBUTE,
                             LRNUTEXPLOSION.ATTRIBUTE_REV,
                             LRNUTEXPLOSION.NUM_1,
                             LRNUTEXPLOSION.NUM_2,
                             LRNUTEXPLOSION.NUM_3,
                             LRNUTEXPLOSION.NUM_4,
                             LRNUTEXPLOSION.NUM_5,
                             LRNUTEXPLOSION.NUM_6,
                             LRNUTEXPLOSION.NUM_7,
                             LRNUTEXPLOSION.NUM_8,
                             LRNUTEXPLOSION.NUM_9,
                             LRNUTEXPLOSION.NUM_10,
                             LRNUTEXPLOSION.CHAR_1,
                             LRNUTEXPLOSION.CHAR_2,
                             LRNUTEXPLOSION.CHAR_3,
                             LRNUTEXPLOSION.CHAR_4,
                             LRNUTEXPLOSION.CHAR_5,
                             LRNUTEXPLOSION.CHAR_6,
                             LRNUTEXPLOSION.INFO,
                             LRNUTEXPLOSION.BOOLEAN_1,
                             LRNUTEXPLOSION.BOOLEAN_2,
                             LRNUTEXPLOSION.BOOLEAN_3,
                             LRNUTEXPLOSION.BOOLEAN_4,
                             LRNUTEXPLOSION.DATE_1,
                             LRNUTEXPLOSION.DATE_2,
                             LRNUTEXPLOSION.CHARACTERISTIC_1,
                             LRNUTEXPLOSION.CHARACTERISTIC_REV_1,
                             LRNUTEXPLOSION.CHARACTERISTIC_2,
                             LRNUTEXPLOSION.CHARACTERISTIC_REV_2,
                             LRNUTEXPLOSION.CHARACTERISTIC_3,
                             LRNUTEXPLOSION.CHARACTERISTIC_REV_3,
                             LRNUTEXPLOSION.ASSOCIATION_1,
                             LRNUTEXPLOSION.ASSOCIATION_REV_1,
                             LRNUTEXPLOSION.ASSOCIATION_2,
                             LRNUTEXPLOSION.ASSOCIATION_REV_2,
                             LRNUTEXPLOSION.ASSOCIATION_3,
                             LRNUTEXPLOSION.ASSOCIATION_REV_3,
                             LRNUTEXPLOSION.TEST_METHOD,
                             LRNUTEXPLOSION.TEST_METHOD_REV,
                             LRNUTEXPLOSION.CALC_QTY,
                             LRNUTEXPLOSION.UOM_ID,
                             LRNUTEXPLOSION.UOM_REV,
                             LRNUTEXPLOSION.PG_TYPE,
                             LRNUTEXPLOSION.NUT_SEQUENCE_NO,
                             LRNUTEXPLOSION.DISPLAY_NAME,
                             LRNUTEXPLOSION.ROW_ID );
            END IF;
         END LOOP;
      END LOOP;

      
      
      
      
      FOR NP2 IN ( SELECT *
                    FROM ITNUTPATH
                   WHERE BOM_EXP_NO = ANUNIQUEID
                     AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                     AND USE = 1
                     AND NUT_XML IS NOT NULL )
      LOOP
         LNNUTSEQUENCENO := 0;
         LNRETVAL := TRANSFORMXMLNUTPATH( NP2.NUT_XML,
                                          LTNUTPATH );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         IF LTNUTPATH.COUNT > 0
         THEN
            FOR I IN LTNUTPATH.FIRST .. LTNUTPATH.LAST
            LOOP
               LNRETVAL := F_IS_IN_FILTER( LTNUTPATH( I ).PROPERTY,
                                           LTNUTPATH( I ).ATTRIBUTE,
                                           LNSEQUENCE );

               IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        IAPIGENERAL.GETLASTERRORTEXT );
                  RETURN LNRETVAL;
               END IF;

               IF LNSEQUENCE != 0
               THEN
                  LNNUTSEQUENCENO :=   LNNUTSEQUENCENO
                                     + 10;
                  LRNUTEXPLOSION := NULL;
                  LRNUTEXPLOSION.BOM_EXP_NO := NP2.BOM_EXP_NO;
                  LRNUTEXPLOSION.MOP_SEQUENCE_NO := NP2.MOP_SEQUENCE_NO;
                  LRNUTEXPLOSION.SEQUENCE_NO := NP2.SEQUENCE_NO;
                  LRNUTEXPLOSION.NUT_SEQUENCE_NO := LNNUTSEQUENCENO;
                  LRNUTEXPLOSION.PROPERTY := LTNUTPATH( I ).PROPERTY;
                  LRNUTEXPLOSION.PROPERTY_REV := LTNUTPATH( I ).PROPERTYREVISION;
                  LRNUTEXPLOSION.ATTRIBUTE := LTNUTPATH( I ).ATTRIBUTE;
                  LRNUTEXPLOSION.ATTRIBUTE_REV := LTNUTPATH( I ).ATTRIBUTEREVISION;
                  LRNUTEXPLOSION.NUM_1 := LTNUTPATH( I ).NUMERIC1;
                  LRNUTEXPLOSION.NUM_2 := LTNUTPATH( I ).NUMERIC2;
                  LRNUTEXPLOSION.NUM_3 := LTNUTPATH( I ).NUMERIC3;
                  LRNUTEXPLOSION.NUM_4 := LTNUTPATH( I ).NUMERIC4;
                  LRNUTEXPLOSION.NUM_5 := LTNUTPATH( I ).NUMERIC5;
                  LRNUTEXPLOSION.NUM_6 := LTNUTPATH( I ).NUMERIC6;
                  LRNUTEXPLOSION.NUM_7 := LTNUTPATH( I ).NUMERIC7;
                  LRNUTEXPLOSION.NUM_8 := LTNUTPATH( I ).NUMERIC8;
                  LRNUTEXPLOSION.NUM_9 := LTNUTPATH( I ).NUMERIC9;
                  LRNUTEXPLOSION.NUM_10 := LTNUTPATH( I ).NUMERIC10;
                  LRNUTEXPLOSION.CHAR_1 := LTNUTPATH( I ).STRING1;
                  LRNUTEXPLOSION.CHAR_2 := LTNUTPATH( I ).STRING2;
                  LRNUTEXPLOSION.CHAR_3 := LTNUTPATH( I ).STRING3;
                  LRNUTEXPLOSION.CHAR_4 := LTNUTPATH( I ).STRING4;
                  LRNUTEXPLOSION.CHAR_5 := LTNUTPATH( I ).STRING5;
                  LRNUTEXPLOSION.CHAR_6 := LTNUTPATH( I ).STRING6;
                  LRNUTEXPLOSION.INFO := LTNUTPATH( I ).INFO;
                  LRNUTEXPLOSION.BOOLEAN_1 := LTNUTPATH( I ).BOOLEAN1;
                  LRNUTEXPLOSION.BOOLEAN_2 := LTNUTPATH( I ).BOOLEAN2;
                  LRNUTEXPLOSION.BOOLEAN_3 := LTNUTPATH( I ).BOOLEAN3;
                  LRNUTEXPLOSION.BOOLEAN_4 := LTNUTPATH( I ).BOOLEAN4;
                  LRNUTEXPLOSION.DATE_1 := LTNUTPATH( I ).DATE1;
                  LRNUTEXPLOSION.DATE_2 := LTNUTPATH( I ).DATE2;
                  LRNUTEXPLOSION.DISPLAY_NAME := NP2.DISPLAY_NAME;
                  LRNUTEXPLOSION.ROW_ID := LNSEQUENCE;
                  LRNUTEXPLOSION.CALC_QTY := NP2.CALC_QTY;

                  INSERT INTO ITNUTEXPLOSION
                              ( BOM_EXP_NO,
                                MOP_SEQUENCE_NO,
                                SEQUENCE_NO,
                                PART_NO,
                                REVISION,
                                PROPERTY_GROUP,
                                PROPERTY,
                                PROPERTY_REV,
                                ATTRIBUTE,
                                ATTRIBUTE_REV,
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
                                INFO,
                                BOOLEAN_1,
                                BOOLEAN_2,
                                BOOLEAN_3,
                                BOOLEAN_4,
                                DATE_1,
                                DATE_2,
                                CHARACTERISTIC_1,
                                CHARACTERISTIC_REV_1,
                                CHARACTERISTIC_2,
                                CHARACTERISTIC_REV_2,
                                CHARACTERISTIC_3,
                                CHARACTERISTIC_REV_3,
                                ASSOCIATION_1,
                                ASSOCIATION_REV_1,
                                ASSOCIATION_2,
                                ASSOCIATION_REV_2,
                                ASSOCIATION_3,
                                ASSOCIATION_REV_3,
                                TEST_METHOD,
                                TEST_METHOD_REV,
                                CALC_QTY,
                                UOM_ID,
                                UOM_REV,
                                PG_TYPE,
                                NUT_SEQUENCE_NO,
                                DISPLAY_NAME,
                                ROW_ID )
                       VALUES ( LRNUTEXPLOSION.BOM_EXP_NO,
                                LRNUTEXPLOSION.MOP_SEQUENCE_NO,
                                LRNUTEXPLOSION.SEQUENCE_NO,
                                LRNUTEXPLOSION.PART_NO,
                                LRNUTEXPLOSION.REVISION,
                                LRNUTEXPLOSION.PROPERTY_GROUP,
                                LRNUTEXPLOSION.PROPERTY,
                                LRNUTEXPLOSION.PROPERTY_REV,
                                LRNUTEXPLOSION.ATTRIBUTE,
                                LRNUTEXPLOSION.ATTRIBUTE_REV,
                                LRNUTEXPLOSION.NUM_1,
                                LRNUTEXPLOSION.NUM_2,
                                LRNUTEXPLOSION.NUM_3,
                                LRNUTEXPLOSION.NUM_4,
                                LRNUTEXPLOSION.NUM_5,
                                LRNUTEXPLOSION.NUM_6,
                                LRNUTEXPLOSION.NUM_7,
                                LRNUTEXPLOSION.NUM_8,
                                LRNUTEXPLOSION.NUM_9,
                                LRNUTEXPLOSION.NUM_10,
                                LRNUTEXPLOSION.CHAR_1,
                                LRNUTEXPLOSION.CHAR_2,
                                LRNUTEXPLOSION.CHAR_3,
                                LRNUTEXPLOSION.CHAR_4,
                                LRNUTEXPLOSION.CHAR_5,
                                LRNUTEXPLOSION.CHAR_6,
                                LRNUTEXPLOSION.INFO,
                                LRNUTEXPLOSION.BOOLEAN_1,
                                LRNUTEXPLOSION.BOOLEAN_2,
                                LRNUTEXPLOSION.BOOLEAN_3,
                                LRNUTEXPLOSION.BOOLEAN_4,
                                LRNUTEXPLOSION.DATE_1,
                                LRNUTEXPLOSION.DATE_2,
                                LRNUTEXPLOSION.CHARACTERISTIC_1,
                                LRNUTEXPLOSION.CHARACTERISTIC_REV_1,
                                LRNUTEXPLOSION.CHARACTERISTIC_2,
                                LRNUTEXPLOSION.CHARACTERISTIC_REV_2,
                                LRNUTEXPLOSION.CHARACTERISTIC_3,
                                LRNUTEXPLOSION.CHARACTERISTIC_REV_3,
                                LRNUTEXPLOSION.ASSOCIATION_1,
                                LRNUTEXPLOSION.ASSOCIATION_REV_1,
                                LRNUTEXPLOSION.ASSOCIATION_2,
                                LRNUTEXPLOSION.ASSOCIATION_REV_2,
                                LRNUTEXPLOSION.ASSOCIATION_3,
                                LRNUTEXPLOSION.ASSOCIATION_REV_3,
                                LRNUTEXPLOSION.TEST_METHOD,
                                LRNUTEXPLOSION.TEST_METHOD_REV,
                                LRNUTEXPLOSION.CALC_QTY,
                                LRNUTEXPLOSION.UOM_ID,
                                LRNUTEXPLOSION.UOM_REV,
                                LRNUTEXPLOSION.PG_TYPE,
                                LRNUTEXPLOSION.NUT_SEQUENCE_NO,
                                LRNUTEXPLOSION.DISPLAY_NAME,
                                LRNUTEXPLOSION.ROW_ID );
               END IF;
            END LOOP;
         END IF;
      END LOOP;




      IF (1 = 1)
      THEN
      
      
      
      
      
     
      BEGIN
         SELECT VALUE_COL
           INTO LNVALUECOL
           FROM ITNUTREFTYPE
          WHERE REF_TYPE = ASNUTREFTYPE;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                          LSMETHOD,
                                                          IAPICONSTANTDBERROR.DBERR_NUTREFSPECNOTFOUND,
                                                          ASNUTREFTYPE );
            END IF;
      END;
      

      FOR NP3 IN ( SELECT *
                    FROM ITNUTPATH
                   WHERE BOM_EXP_NO = ANUNIQUEID
                     AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                     AND USE = 2
                     
                     )
      LOOP
          
          
          
          
          

        LNNUTSEQUENCENO := 0;

        

        
        
        

        
        
        
        
        
        
        
        
        

        
        
        
        FOR NLR IN LQNUTLOGRESULT( NP3.LOG_ID, NP3.COL_ID)
        
        LOOP
           

           LNRETVAL := F_IS_IN_FILTER( NLR.PROPERTY,
                                       NLR.ATTRIBUTE,
                                       LNSEQUENCE );

           IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
           THEN
              IAPIGENERAL.LOGERROR( GSSOURCE,
                                    LSMETHOD,
                                    IAPIGENERAL.GETLASTERRORTEXT );
              RETURN LNRETVAL;
           END IF;

            IF LNSEQUENCE != 0
            THEN
               LNNUTSEQUENCENO :=   LNNUTSEQUENCENO
                                  + 10;
               LRNUTEXPLOSION := NULL;
               LRNUTEXPLOSION.BOM_EXP_NO := NP3.BOM_EXP_NO;
               LRNUTEXPLOSION.MOP_SEQUENCE_NO := NP3.MOP_SEQUENCE_NO;
               LRNUTEXPLOSION.SEQUENCE_NO := NP3.SEQUENCE_NO;

               LRNUTEXPLOSION.NUT_SEQUENCE_NO := LNNUTSEQUENCENO;

               LRNUTEXPLOSION.PART_NO := NP3.PART_NO;
               LRNUTEXPLOSION.REVISION := NP3.REVISION;
               LRNUTEXPLOSION.PROPERTY_GROUP := NP3.PROPERTY_GROUP;

               LRNUTEXPLOSION.PROPERTY := NLR.PROPERTY;
               LRNUTEXPLOSION.PROPERTY_REV := NLR.PROPERTY_REV;
               LRNUTEXPLOSION.ATTRIBUTE := NLR.ATTRIBUTE;
               LRNUTEXPLOSION.ATTRIBUTE_REV := NLR.ATTRIBUTE_REV;

               BEGIN
                    
                    
                    
                    
                    
                    

                    LNRETVAL := CALCULATEREVERSEVALUE(ANUNIQUEID,ANMOPSEQUENCENO,ASNUTREFTYPE, NP3.COL_ID, NP3.LOG_ID, LNSEQUENCE, LNCALCULATEDREVVALUE);
                    CASE LNVALUECOL
                    WHEN 1
                        THEN LRNUTEXPLOSION.NUM_1 := LNCALCULATEDREVVALUE;
                    WHEN 2
                        THEN LRNUTEXPLOSION.NUM_2 := LNCALCULATEDREVVALUE;
                    WHEN 3
                        THEN LRNUTEXPLOSION.NUM_3 := LNCALCULATEDREVVALUE;
                    WHEN 4
                        THEN LRNUTEXPLOSION.NUM_4 := LNCALCULATEDREVVALUE;
                    WHEN 5
                        THEN LRNUTEXPLOSION.NUM_5 := LNCALCULATEDREVVALUE;
                    WHEN 6
                        THEN LRNUTEXPLOSION.NUM_6 := LNCALCULATEDREVVALUE;
                    WHEN 7
                        THEN LRNUTEXPLOSION.NUM_7 := LNCALCULATEDREVVALUE;
                    WHEN 8
                        THEN LRNUTEXPLOSION.NUM_8 := LNCALCULATEDREVVALUE;
                    WHEN 9
                        THEN LRNUTEXPLOSION.NUM_9 := LNCALCULATEDREVVALUE;
                    WHEN 10
                        THEN LRNUTEXPLOSION.NUM_10 := LNCALCULATEDREVVALUE;
                    END CASE;
                    
                    
               EXCEPTION
                   WHEN OTHERS
                   THEN
                            NULL;
               END;

































































               LRNUTEXPLOSION.DISPLAY_NAME := NP3.DISPLAY_NAME;

               LRNUTEXPLOSION.ROW_ID := LNSEQUENCE;

               LRNUTEXPLOSION.CALC_QTY := NP3.CALC_QTY;


               
               
               LNRETVAL := F_UMH_ID(NP3.UOM, IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, LRNUTEXPLOSION.UOM_ID, LRNUTEXPLOSION.UOM_REV);

               
               SELECT PG_TYPE
                 INTO LRNUTEXPLOSION.PG_TYPE
                 FROM PROPERTY_GROUP PG
                WHERE PG.PROPERTY_GROUP = NP3.PROPERTY_GROUP;

               INSERT INTO ITNUTEXPLOSION
                           ( BOM_EXP_NO,
                             MOP_SEQUENCE_NO,
                             SEQUENCE_NO,
                             PART_NO,
                             REVISION,
                             PROPERTY_GROUP,
                             PROPERTY,
                             PROPERTY_REV,
                             ATTRIBUTE,
                             ATTRIBUTE_REV,
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
                             



























                             CALC_QTY,
                             UOM_ID,
                             UOM_REV,
                             PG_TYPE,
                             NUT_SEQUENCE_NO,
                             DISPLAY_NAME,
                             ROW_ID )
                    VALUES ( LRNUTEXPLOSION.BOM_EXP_NO,
                             LRNUTEXPLOSION.MOP_SEQUENCE_NO,
                             LRNUTEXPLOSION.SEQUENCE_NO,
                             LRNUTEXPLOSION.PART_NO,
                             LRNUTEXPLOSION.REVISION,
                             LRNUTEXPLOSION.PROPERTY_GROUP,
                             LRNUTEXPLOSION.PROPERTY,
                             LRNUTEXPLOSION.PROPERTY_REV,
                             LRNUTEXPLOSION.ATTRIBUTE,
                             LRNUTEXPLOSION.ATTRIBUTE_REV,
                             LRNUTEXPLOSION.NUM_1,
                             
                             
                             LRNUTEXPLOSION.NUM_2,
                             LRNUTEXPLOSION.NUM_3,
                             LRNUTEXPLOSION.NUM_4,
                             LRNUTEXPLOSION.NUM_5,
                             LRNUTEXPLOSION.NUM_6,
                             LRNUTEXPLOSION.NUM_7,
                             LRNUTEXPLOSION.NUM_8,
                             LRNUTEXPLOSION.NUM_9,
                             LRNUTEXPLOSION.NUM_10,
                             



























                             LRNUTEXPLOSION.CALC_QTY,
                             LRNUTEXPLOSION.UOM_ID,
                             LRNUTEXPLOSION.UOM_REV,
                             LRNUTEXPLOSION.PG_TYPE,
                             LRNUTEXPLOSION.NUT_SEQUENCE_NO,
                             LRNUTEXPLOSION.DISPLAY_NAME,
                             LRNUTEXPLOSION.ROW_ID );
            END IF;

         END LOOP;
        END LOOP;
      
      END IF;

      
      
      
      LNRETVAL := F_ADD_UNUSED_FILTER;

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
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


   FUNCTION EXPLODE(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      AXFILTERDETAILS            IN       IAPITYPE.XMLTYPE_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Explode';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTFILTERDETAILS               IAPITYPE.NUTFILTERDETAILSTAB_TYPE;
   BEGIN





      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := TRANSFORMXMLNUTFILTER( AXFILTERDETAILS,
                                         LTFILTERDETAILS,
                                         AQERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LNRETVAL := EXPLODE( ANUNIQUEID,
                           ANMOPSEQUENCENO,
                           ASNUTREFTYPE,
                           LTFILTERDETAILS,
                           AQERRORS );

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
   END EXPLODE;


   FUNCTION GETEXPORTEDPANELS(
      ANLOGID                    IN       IAPITYPE.ID_TYPE,
      AQEXPORTEDPANELS           OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetExportedPanels';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' Log_ID '
            || IAPICONSTANTCOLUMN.IDCOL
            || ', Sequence_NO '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ', PART_NO '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', Revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', CREATED_ON '
            || IAPICONSTANTCOLUMN.CREATEDONCOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM itnutExportedPanels ';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE := ' WHERE Log_id = :anLogId ';
      LSORDERBY                     IAPITYPE.SQLSTRING_TYPE := ' ORDER BY Sequence_no ';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN





      LSSQL :=    ' SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || ' AND 1=2 '
               || LSORDERBY;

      IF AQEXPORTEDPANELS%ISOPEN
      THEN
         CLOSE AQEXPORTEDPANELS;
      END IF;

      OPEN AQEXPORTEDPANELS FOR LSSQL USING ANLOGID;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    ' SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || LSORDERBY;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      IF AQEXPORTEDPANELS%ISOPEN
      THEN
         CLOSE AQEXPORTEDPANELS;
      END IF;

      OPEN AQEXPORTEDPANELS FOR LSSQL USING ANLOGID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    ' SELECT '
                  || LSSELECT
                  || LSFROM
                  || LSWHERE
                  || ' AND 1=2 '
                  || LSORDERBY;

         IF AQEXPORTEDPANELS%ISOPEN
         THEN
            CLOSE AQEXPORTEDPANELS;
         END IF;

         OPEN AQEXPORTEDPANELS FOR LSSQL USING ANLOGID;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETEXPORTEDPANELS;


   FUNCTION ADDEXPORTEDPANELS(
      ANLOGID                    IN       IAPITYPE.ID_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ADCREATEDON                IN       IAPITYPE.DATE_TYPE DEFAULT SYSDATE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddExportedPanels';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNNUTEXPORTEDPANELSEQ         IAPITYPE.ID_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT   NVL( MAX( SEQUENCE_NO ),
                    0 )
             + 10
        INTO LNNUTEXPORTEDPANELSEQ
        FROM ITNUTEXPORTEDPANELS
       WHERE LOG_ID = ANLOGID;

      INSERT INTO ITNUTEXPORTEDPANELS
                  ( LOG_ID,
                    SEQUENCE_NO,
                    PART_NO,
                    REVISION,
                    CREATED_ON )
           VALUES ( ANLOGID,
                    LNNUTEXPORTEDPANELSEQ,
                    ASPARTNO,
                    ANREVISION,
                    ADCREATEDON );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDEXPORTEDPANELS;


   FUNCTION SAVEEXPORTEDPANELS(
      ANLOGID                    IN       IAPITYPE.ID_TYPE,
      ANSEQUENCENO               IN       IAPITYPE.SEQUENCE_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ADCREATEDON                IN       IAPITYPE.DATE_TYPE DEFAULT SYSDATE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveExportedPanels';
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

      UPDATE ITNUTEXPORTEDPANELS
         SET PART_NO = ASPARTNO,
             REVISION = ANREVISION
       WHERE LOG_ID = ANLOGID
         AND SEQUENCE_NO = ANSEQUENCENO;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NUTEXPPANNOTFOUND,
                                                    ANLOGID,
                                                    ANSEQUENCENO );
      
      
      
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEEXPORTEDPANELS;


   FUNCTION REMOVEEXPORTEDPANELS(
      ANLOGID                    IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveExportedPanels';
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

      DELETE FROM ITNUTEXPORTEDPANELS
            WHERE LOG_ID = ANLOGID;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NUTEXPPANNOTFOUND2,
                                                    ANLOGID );
      
      
      
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEEXPORTEDPANELS;


   FUNCTION ADDNUTPATH(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPID          IN       IAPITYPE.ID_TYPE,
      ASALTERNATIVEPARTNO        IN       IAPITYPE.PARTNO_TYPE,
      ANALTERNATIVEREVISION      IN       IAPITYPE.REVISION_TYPE,
      AXNUTXML                   IN       IAPITYPE.XMLTYPE_TYPE,
      ANBASEQTY                  IN       IAPITYPE.BOMQUANTITY_TYPE,
      ANSERVINGCONVFACTOR        IN       IAPITYPE.SERVINGCONVFACTOR_TYPE,
      ANSERVINGVOL               IN       IAPITYPE.SERVINGCONVFACTOR_TYPE,
      ASUOM                      IN       IAPITYPE.DESCRIPTION_TYPE,
      ANCONVERSIONFACTOR         IN       IAPITYPE.BOMCONVFACTOR_TYPE,
      ASTOUNIT                   IN       IAPITYPE.DESCRIPTION_TYPE,
      ANCALCQTYWITHSCRAP         IN       IAPITYPE.BOMQUANTITY_TYPE,
      ANBOMLEVEL                 IN       IAPITYPE.BOMLEVEL_TYPE,
      ANACCESSSTOP               IN       IAPITYPE.BOOLEAN_TYPE,
      ANRECURSIVESTOP            IN       IAPITYPE.BOOLEAN_TYPE,
      ANUSE                      IN       IAPITYPE.BOOLEAN_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddNutPath';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSUOM                         IAPITYPE.DESCRIPTION_TYPE;
      LNNUTSEQUENCENO               IAPITYPE.ID_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      LNRETVAL := ISVALIDNUTPATHXML( AXNUTXML,
                                     AQERRORS );

      IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IF ANUSE = 1
         THEN


            LNRETVAL := GETDOMINANTUOM( ANUNIQUEID,
                                        ANMOPSEQUENCENO,
                                        LSUOM );

            IF LSUOM != NVL( ASUOM,
                             '#' )
            THEN
               LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_UOMMISMATCH,
                                                     LSUOM );
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    IAPIGENERAL.GETLASTERRORTEXT );
               RETURN LNRETVAL;
            END IF;
         END IF;

         SELECT   NVL( MAX( SEQUENCE_NO ),
                       0 )
                + 10
           INTO LNNUTSEQUENCENO
           FROM ITNUTPATH
          WHERE BOM_EXP_NO = ANUNIQUEID
            AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO;

         
         INSERT INTO ITNUTPATH
                     ( BOM_EXP_NO,
                       MOP_SEQUENCE_NO,
                       SEQUENCE_NO,
                       PART_NO,
                       REVISION,
                       SECTION_ID,
                       SUB_SECTION_ID,
                       PROPERTY_GROUP,
                       ALT_PART_NO,
                       ALT_REVISION,
                       NUT_XML,
                       DISPLAY_NAME,
                       BASE_QTY,
                       SERV_CONV_FACTOR,
                       SERV_VOL,
                       UOM,
                       CONV_FACTOR,
                       TO_UNIT,
                       CALC_QTY_WITH_SCRAP,
                       BOM_LEVEL,
                       ACCESS_STOP,
                       RECURSIVE_STOP,
                       USE )
              VALUES ( ANUNIQUEID,
                       ANMOPSEQUENCENO,
                       LNNUTSEQUENCENO,
                       ASPARTNO,
                       ANREVISION,
                       ANSECTIONID,
                       ANSUBSECTIONID,
                       ANPROPERTYGROUPID,
                       ASALTERNATIVEPARTNO,
                       ANALTERNATIVEREVISION,
                       AXNUTXML,
                          ASPARTNO
                       || ' ['
                       || ANREVISION
                       || ']',
                       ANBASEQTY,
                       ANSERVINGCONVFACTOR,
                       ANSERVINGVOL,
                       ASUOM,
                       ANCONVERSIONFACTOR,
                       ASTOUNIT,
                       ANCALCQTYWITHSCRAP,
                       ANBOMLEVEL,
                       ANACCESSSTOP,
                       ANRECURSIVESTOP,
                       ANUSE );

         RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
      ELSE
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    LNRETVAL );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDNUTPATH;


   FUNCTION SAVENUTPATH(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ANSEQUENCENO               IN       IAPITYPE.SEQUENCE_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPID          IN       IAPITYPE.ID_TYPE,
      ASALTERNATIVEPARTNO        IN       IAPITYPE.PARTNO_TYPE,
      ANALTERNATIVEREVISION      IN       IAPITYPE.REVISION_TYPE,
      AXNUTXML                   IN       IAPITYPE.XMLTYPE_TYPE,
      ANBASEQTY                  IN       IAPITYPE.BOMQUANTITY_TYPE,
      ANSERVINGCONVFACTOR        IN       IAPITYPE.SERVINGCONVFACTOR_TYPE,
      ANSERVINGVOL               IN       IAPITYPE.SERVINGCONVFACTOR_TYPE,
      ASUOM                      IN       IAPITYPE.DESCRIPTION_TYPE,
      ANCONVERSIONFACTOR         IN       IAPITYPE.BOMCONVFACTOR_TYPE,
      ASTOUNIT                   IN       IAPITYPE.DESCRIPTION_TYPE,
      ANCALCQTYWITHSCRAP         IN       IAPITYPE.BOMQUANTITY_TYPE,
      ANBOMLEVEL                 IN       IAPITYPE.BOMLEVEL_TYPE,
      ANACCESSSTOP               IN       IAPITYPE.BOOLEAN_TYPE,
      ANRECURSIVESTOP            IN       IAPITYPE.BOOLEAN_TYPE,
      ANUSE                      IN       IAPITYPE.BOOLEAN_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveNutPath';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSUOM                         IAPITYPE.DESCRIPTION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
          
         
      LNRETVAL := ISVALIDNUTPATHXML( AXNUTXML,
                                     AQERRORS );

      IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IF ANUSE = 1
         THEN


            LNRETVAL := GETDOMINANTUOM( ANUNIQUEID,
                                        ANMOPSEQUENCENO,
                                        LSUOM );

            IF LSUOM != NVL( ASUOM,
                             '#' )
            THEN
               LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_UOMMISMATCH,
                                                     LSUOM );
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    IAPIGENERAL.GETLASTERRORTEXT );
               RETURN LNRETVAL;
            END IF;
         END IF;

         
         UPDATE ITNUTPATH
            SET PART_NO = ASPARTNO,
                REVISION = ANREVISION,
                SECTION_ID = ANSECTIONID,
                SUB_SECTION_ID = ANSUBSECTIONID,
                PROPERTY_GROUP = ANPROPERTYGROUPID,
                ALT_PART_NO = ASALTERNATIVEPARTNO,
                ALT_REVISION = ANALTERNATIVEREVISION,
                NUT_XML = AXNUTXML,
                BASE_QTY = ANBASEQTY,
                SERV_CONV_FACTOR = ANSERVINGCONVFACTOR,
                SERV_VOL = ANSERVINGVOL,
                UOM = ASUOM,
                CONV_FACTOR = ANCONVERSIONFACTOR,
                TO_UNIT = ASTOUNIT,
                CALC_QTY_WITH_SCRAP = ANCALCQTYWITHSCRAP,
                BOM_LEVEL = ANBOMLEVEL,
                ACCESS_STOP = ANACCESSSTOP,
                RECURSIVE_STOP = ANRECURSIVESTOP,
                USE = ANUSE,
                DISPLAY_NAME =    ASPARTNO
                               || ' ['
                               || ANREVISION
                               || ']'
          WHERE BOM_EXP_NO = ANUNIQUEID
            AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
            AND SEQUENCE_NO = ANSEQUENCENO;

         IF SQL%ROWCOUNT = 0
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_NUTPATHNOTFOUND2,
                                                       ANUNIQUEID,
                                                       ANMOPSEQUENCENO,
                                                       ANSEQUENCENO );
         END IF;

         RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
      ELSE
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    LNRETVAL );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVENUTPATH;


   FUNCTION REMOVENUTPATH(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ANSEQUENCENO               IN       IAPITYPE.SEQUENCE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveNutPath';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      DELETE FROM ITNUTPATH
            WHERE BOM_EXP_NO = ANUNIQUEID
              AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
              AND SEQUENCE_NO = ANSEQUENCENO;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NUTPATHNOTFOUND2,
                                                    ANUNIQUEID,
                                                    ANMOPSEQUENCENO,
                                                    ANSEQUENCENO );
      END IF;




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
   END REMOVENUTPATH;


   FUNCTION GETNUTPATH(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      AQNUTPATHS                 OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetNutPath';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' Bom_EXP_NO '
            || IAPICONSTANTCOLUMN.UNIQUEIDCOL
            || ', Mop_Sequence_NO '
            || IAPICONSTANTCOLUMN.MOPSEQUENCECOL
            || ', Sequence_NO '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ', PART_NO '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', Revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', Section_ID '
            || IAPICONSTANTCOLUMN.SECTIONIDCOL
            || ', SUB_Section_ID '
            || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
            || ', Property_GROUP '
            || IAPICONSTANTCOLUMN.PROPERTYGROUPCOL
            || ', ALT_PART_NO '
            || IAPICONSTANTCOLUMN.ALTERNATIVEPARTNOCOL
            || ', ALT_Revision '
            || IAPICONSTANTCOLUMN.ALTERNATIVEREVISIONCOL
            || ', Xmltype.GetClobVal( NUT_Xml ) '
            || IAPICONSTANTCOLUMN.NUTRITIONALXMLCOL
            || ', Display_Name '
            || IAPICONSTANTCOLUMN.NAMECOL
            || ', f_part_descr(:lnLangID,PART_NO) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', BASE_QTY '
            || IAPICONSTANTCOLUMN.BASEQUANTITYCOL
            || ', SERV_CONV_Factor '
            || IAPICONSTANTCOLUMN.SERVINGCONVERSIONFACTORCOL
            || ', SERV_VOL '
            || IAPICONSTANTCOLUMN.SERVINGVOLUMECOL
            || ', UOM '
            || IAPICONSTANTCOLUMN.UOMCOL
            || ', round(CONV_Factor,7) '
            || IAPICONSTANTCOLUMN.CONVERSIONFACTORCOL
            || ', TO_UNIT '
            || IAPICONSTANTCOLUMN.TOUNITCOL
            || ', CALC_QTY_WITH_SCRAP '
            || IAPICONSTANTCOLUMN.CALCULATEDQUANTITYWITHSCRAPCOL
            || ', Bom_LEVEL '
            || IAPICONSTANTCOLUMN.BOMLEVELCOL
            || ', ACCESS_STOP '
            || IAPICONSTANTCOLUMN.ACCESSSTOPCOL
            || ', RECURSIVE_STOP '
            || IAPICONSTANTCOLUMN.RECURSIVESTOPCOL
            || ', Use '
            || IAPICONSTANTCOLUMN.USECOL

            || ', Col_id '
            || IAPICONSTANTCOLUMN.COLIDCOL

            || ', (select count(*) from specification_prop '
            || ' where PART_NO = itNutPath.PART_NO '
            || ' and Revision = 	itNutPath.Revision '
            || ' and  Section_ID =  itNutPath.Section_ID '
            || ' and  SUB_Section_ID = itNutPath.SUB_Section_ID '
            || ' and  Property_GROUP	 =itNutPath.Property_GROUP) '
            || IAPICONSTANTCOLUMN.CHILDCOUNTCOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM itNutPath ';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE := ' WHERE Bom_EXP_NO = :anUniqueId ';
      LSORDERBY                     IAPITYPE.SQLSTRING_TYPE := ' ORDER BY 1,2,3 ';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN





      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || ' AND 1=2 '
               || LSORDERBY;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQNUTPATHS FOR LSSQL USING IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,
      ANUNIQUEID;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || LSORDERBY;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      IF AQNUTPATHS%ISOPEN
      THEN
         CLOSE AQNUTPATHS;
      END IF;

      OPEN AQNUTPATHS FOR LSSQL USING IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,
      ANUNIQUEID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'SELECT '
                  || LSSELECT
                  || LSFROM
                  || LSWHERE
                  || ' AND 1=2 '
                  || LSORDERBY;

         IF AQNUTPATHS%ISOPEN
         THEN
            CLOSE AQNUTPATHS;
         END IF;

         OPEN AQNUTPATHS FOR LSSQL USING IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,
         ANUNIQUEID;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETNUTPATH;


   FUNCTION GETFILTERDETAILSBYNAME(
      ASNAME                     IN       IAPITYPE.NAME_TYPE,
      AQFILTERDETAILS            OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetFilterDetailsByName';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' NFD.ID '
            || IAPICONSTANTCOLUMN.IDCOL
            || ' ,NFD.Seq '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ' ,NFD.Property_Id '
            || IAPICONSTANTCOLUMN.PROPERTYCOL
            || ' ,NFD.Property_Rev '
            || IAPICONSTANTCOLUMN.PROPERTYREVISIONCOL
            || ' ,NFD.Attribute_Id '
            || IAPICONSTANTCOLUMN.ATTRIBUTECOL
            || ' ,NFD.Attribute_Rev '
            || IAPICONSTANTCOLUMN.ATTRIBUTEREVISIONCOL
            || ' ,CASE NFD.Attribute_id '
            || ' WHEN 0 THEN f_sph_Descr(1,Property_Id,Property_Rev) '
            || ' ELSE f_sph_Descr(1,Property_Id,Property_Rev)||'' ''||f_ath_descr(1,Attribute_Id,Attribute_Rev) '
            || ' END '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ' ,Visible '
            || IAPICONSTANTCOLUMN.VISIBLECOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM itNutFilterDetails  NFD, itnutFilter NF ';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE := ' WHERE NFD.ID = NF.ID AND NF.Name= :asName ';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN





      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || ' AND 1=2 '
               || ' ORDER BY 2 ';

      OPEN AQFILTERDETAILS FOR LSSQL USING ASNAME;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || ' ORDER BY 2 ';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      IF AQFILTERDETAILS%ISOPEN
      THEN
         CLOSE AQFILTERDETAILS;
      END IF;

      OPEN AQFILTERDETAILS FOR LSSQL USING ASNAME;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'SELECT '
                  || LSSELECT
                  || LSFROM
                  || LSWHERE
                  || ' AND 1=2 '
                  || ' ORDER BY 2 ';

         IF AQFILTERDETAILS%ISOPEN
         THEN
            CLOSE AQFILTERDETAILS;
         END IF;

         OPEN AQFILTERDETAILS FOR LSSQL USING ASNAME;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETFILTERDETAILSBYNAME;


   FUNCTION ADDADDITIONALXML(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ASNAME                     IN       IAPITYPE.NAME_TYPE,
      ANBASEQTY                  IN       IAPITYPE.BOMQUANTITY_TYPE,
      ANSERVCONVFACTOR           IN       IAPITYPE.BOMQUANTITY_TYPE,
      ANSERVVOLUME               IN       IAPITYPE.BOMQUANTITY_TYPE,
      AXNUTXML                   IN       IAPITYPE.XMLTYPE_TYPE,
      ANSEQUENCENO               OUT      IAPITYPE.SEQUENCE_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE,
      ANBOMLEVEL                 IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1,
      ANACCESSSTOP               IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANRECURSIVESTOP            IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0,
      ANUSE                      IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1 )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddAdditionalXml';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSUOM                         IAPITYPE.DESCRIPTION_TYPE;
   BEGIN





      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
       
      
      IF AXNUTXML IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_INVALIDNUTXML );
      END IF;

      LNRETVAL := ISVALIDNUTPATHXML( AXNUTXML,
                                     AQERRORS );
      ANSEQUENCENO := 0;

      IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN


         LNRETVAL := GETDOMINANTUOM( ANUNIQUEID,
                                     ANMOPSEQUENCENO,
                                     LSUOM );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         
         SELECT   NVL( MAX( SEQUENCE_NO ),
                       0 )
                + 10
           INTO ANSEQUENCENO
           FROM ITNUTPATH
          WHERE BOM_EXP_NO = ANUNIQUEID
            AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO;

         INSERT INTO ITNUTPATH
                     ( BOM_EXP_NO,
                       MOP_SEQUENCE_NO,
                       SEQUENCE_NO,
                       NUT_XML,
                       DISPLAY_NAME,
                       BASE_QTY,
                       SERV_CONV_FACTOR,
                       SERV_VOL,
                       BOM_LEVEL,
                       ACCESS_STOP,
                       RECURSIVE_STOP,
                       USE,
                       CALC_QTY_WITH_SCRAP,
                       UOM )
              VALUES ( ANUNIQUEID,
                       ANMOPSEQUENCENO,
                       ANSEQUENCENO,
                       AXNUTXML,
                       NVL( ASNAME,
                            '-' ),
                       ANBASEQTY,
                       ANSERVCONVFACTOR,
                       ANSERVVOLUME,
                       ANBOMLEVEL,
                       ANACCESSSTOP,
                       ANRECURSIVESTOP,
                       ANUSE,
                       (   NVL( ANSERVVOLUME,
                                100 )
                         * ANSERVCONVFACTOR ),
                       LSUOM );

         RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
      ELSE
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    LNRETVAL );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDADDITIONALXML;


   FUNCTION SAVEADDITIONALXML(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ANSEQUENCENO               IN       IAPITYPE.SEQUENCE_TYPE,
      ASNAME                     IN       IAPITYPE.NAME_TYPE,
      AXNUTXML                   IN       IAPITYPE.XMLTYPE_TYPE,
      ANBASEQTY                  IN       IAPITYPE.BOMQUANTITY_TYPE,
      ANSERVINGCONVFACTOR        IN       IAPITYPE.SERVINGCONVFACTOR_TYPE,
      ANSERVINGVOL               IN       IAPITYPE.SERVINGCONVFACTOR_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveAdditionalXml';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSUOM                         IAPITYPE.DESCRIPTION_TYPE;
   BEGIN
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
          
         
      IF AXNUTXML IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_INVALIDNUTXML );
      END IF;

      LNRETVAL := ISVALIDNUTPATHXML( AXNUTXML,
                                     AQERRORS );

      IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         
         UPDATE ITNUTPATH
            SET DISPLAY_NAME = NVL( ASNAME,
                                    '-' ),
                NUT_XML = AXNUTXML,
                BASE_QTY = ANBASEQTY,
                SERV_CONV_FACTOR = ANSERVINGCONVFACTOR,
                SERV_VOL = ANSERVINGVOL,
                CALC_QTY_WITH_SCRAP =(   NVL( ANSERVINGVOL,
                                              100 )
                                       * ANSERVINGCONVFACTOR )
          WHERE BOM_EXP_NO = ANUNIQUEID
            AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
            AND SEQUENCE_NO = ANSEQUENCENO;

         IF SQL%ROWCOUNT = 0
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_NUTPATHNOTFOUND2,
                                                       ANUNIQUEID,
                                                       ANMOPSEQUENCENO,
                                                       ANSEQUENCENO );
         END IF;

         RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
      ELSE
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    LNRETVAL );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEADDITIONALXML;




   FUNCTION DELETEALLADDITIONALXML(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'DeleteAllAdditionalXml';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

     DELETE FROM ITNUTPATH
      WHERE BOM_EXP_NO = ANUNIQUEID
        AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
        AND NUT_XML IS NOT NULL;

    RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END DELETEALLADDITIONALXML;



   FUNCTION ISVALIDNUTPATHXML(
      AXNUTXML                   IN       IAPITYPE.XMLTYPE_TYPE,
      AQERRORS                   IN OUT NOCOPY IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsValidNutPathXml';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSROWID                       IAPITYPE.STRING_TYPE;
      LXPARSER                      XMLPARSER.PARSER;
      LXDOMDOCUMENT                 XMLDOM.DOMDOCUMENT;
      LXROOTELEMENT                 XMLDOM.DOMELEMENT;
      LXIMPORTDATAROWNODELIST       XMLDOM.DOMNODELIST;
      LXIMPORTDATAROWNODE           XMLDOM.DOMNODE;
      LXIMPORTDATAROWITEMSNODELIST  XMLDOM.DOMNODELIST;
      LXIMPORTDATAROWITEMSNODE      XMLDOM.DOMNODE;
      LXNODE                        XMLDOM.DOMNODE;
   BEGIN








      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      


      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      LXPARSER := XMLPARSER.NEWPARSER;
      XMLPARSER.SETVALIDATIONMODE( LXPARSER,
                                   FALSE );
      XMLPARSER.PARSECLOB( LXPARSER,
                           AXNUTXML.GETCLOBVAL );
      LXDOMDOCUMENT := XMLPARSER.GETDOCUMENT( LXPARSER );

      
      
      
      IF ( NOT XMLDOM.ISNULL( LXDOMDOCUMENT ) )
      THEN
         
         LXIMPORTDATAROWNODELIST := XMLDOM.GETELEMENTSBYTAGNAME( LXDOMDOCUMENT,
                                                                 'ImportDataRow' );

         IF XMLDOM.GETLENGTH( LXIMPORTDATAROWNODELIST ) = 0
         THEN
            
            XMLDOM.FREEDOCUMENT( LXDOMDOCUMENT );
            XMLPARSER.FREEPARSER( LXPARSER );
            LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_ELEMENTNOTFOUNDINXML,
                                                  'ImportDataRow' );
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT );
            RETURN LNRETVAL;
            
         
         
         END IF;

         FOR I IN 0 ..(   XMLDOM.GETLENGTH( LXIMPORTDATAROWNODELIST )
                        - 1 )
         LOOP
            
            LXIMPORTDATAROWNODE := XMLDOM.ITEM( LXIMPORTDATAROWNODELIST,
                                                I );
            
            LXIMPORTDATAROWITEMSNODELIST := XMLDOM.GETCHILDNODES( LXIMPORTDATAROWNODE );
            LSROWID :=    'ROW='
                       || (   I
                            + 1 );

            FOR J IN 0 ..(   XMLDOM.GETLENGTH( LXIMPORTDATAROWITEMSNODELIST )
                           - 1 )
            LOOP
               
               LXIMPORTDATAROWITEMSNODE := XMLDOM.ITEM( LXIMPORTDATAROWITEMSNODELIST,
                                                        J );
               
               LXNODE := XMLDOM.GETFIRSTCHILD( LXIMPORTDATAROWITEMSNODE );

               
               
               
               IF NOT XMLDOM.ISNULL( LXNODE )
               THEN
                  IF XMLDOM.GETNODETYPE( LXNODE ) = XMLDOM.TEXT_NODE
                  THEN
                     CASE UPPER( XMLDOM.GETNODENAME( LXIMPORTDATAROWITEMSNODE ) )
                        WHEN 'SP'
                        THEN
                           LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                           IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
                           THEN
                              LNRETVAL := IAPIPROPERTY.EXISTPROPERTY( XMLDOM.GETNODEVALUE( LXNODE ) );

                              IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                              THEN
                                 IAPIGENERAL.LOGINFO( GSSOURCE,
                                                      LSMETHOD,
                                                      IAPIGENERAL.GETLASTERRORTEXT( ) );
                                 LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                         || ' <SP>',
                                                                         IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                         GTERRORS );
                              END IF;
                           ELSE
                              IAPIGENERAL.LOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
                              LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                      || ' <SP>',
                                                                      IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                      GTERRORS );
                           END IF;
                        WHEN 'AT'
                        THEN
                           LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                           IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
                           THEN
                              LNRETVAL := IAPIATTRIBUTE.EXISTATTRIBUTE( XMLDOM.GETNODEVALUE( LXNODE ) );

                              IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                              THEN
                                 IAPIGENERAL.LOGINFO( GSSOURCE,
                                                      LSMETHOD,
                                                      IAPIGENERAL.GETLASTERRORTEXT( ) );
                                 LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                         || ' <AT>',
                                                                         IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                         GTERRORS );
                              END IF;
                           ELSE
                              IAPIGENERAL.LOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
                              LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                      || ' <AT>',
                                                                      IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                      GTERRORS );
                           END IF;
                        WHEN 'N1'
                        THEN
                           LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                           IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                           THEN
                              IAPIGENERAL.LOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
                              LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                      || ' <N1>',
                                                                      IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                      GTERRORS );
                           END IF;
                        WHEN 'N2'
                        THEN
                           LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                           IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                           THEN
                              IAPIGENERAL.LOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
                              LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                      || ' <N2>',
                                                                      IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                      GTERRORS );
                           END IF;
                        WHEN 'N3'
                        THEN
                           LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                           IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                           THEN
                              IAPIGENERAL.LOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
                              LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                      || ' <N3>',
                                                                      IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                      GTERRORS );
                           END IF;
                        WHEN 'N4'
                        THEN
                           LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                           IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                           THEN
                              IAPIGENERAL.LOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
                              LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                      || ' <N4>',
                                                                      IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                      GTERRORS );
                           END IF;
                        WHEN 'N5'
                        THEN
                           LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                           IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                           THEN
                              IAPIGENERAL.LOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
                              LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                      || ' <N5>',
                                                                      IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                      GTERRORS );
                           END IF;
                        WHEN 'N6'
                        THEN
                           LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                           IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                           THEN
                              IAPIGENERAL.LOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
                              LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                      || ' <N6>',
                                                                      IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                      GTERRORS );
                           END IF;
                        WHEN 'N7'
                        THEN
                           LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                           IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                           THEN
                              IAPIGENERAL.LOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
                              LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                      || ' <N7>',
                                                                      IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                      GTERRORS );
                           END IF;
                        WHEN 'N8'
                        THEN
                           LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                           IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                           THEN
                              IAPIGENERAL.LOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
                              LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                      || ' <N8>',
                                                                      IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                      GTERRORS );
                           END IF;
                        WHEN 'N9'
                        THEN
                           LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                           IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                           THEN
                              IAPIGENERAL.LOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
                              LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                      || ' <N9>',
                                                                      IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                      GTERRORS );
                           END IF;
                        WHEN 'N10'
                        THEN
                           LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                           IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                           THEN
                              IAPIGENERAL.LOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
                              LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                      || ' <N10>',
                                                                      IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                      GTERRORS );
                           END IF;
                        WHEN 'D1'
                        THEN
                           LNRETVAL := IAPIGENERAL.ISDATE( XMLDOM.GETNODEVALUE( LXNODE ),
                                                           'MM/DD/YYYY' );

                           IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                           THEN
                              IAPIGENERAL.LOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
                              LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                      || ' <D1>',
                                                                      IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                      GTERRORS );
                           END IF;
                        WHEN 'D2'
                        THEN
                           LNRETVAL := IAPIGENERAL.ISDATE( XMLDOM.GETNODEVALUE( LXNODE ),
                                                           'MM/DD/YYYY' );

                           IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                           THEN
                              IAPIGENERAL.LOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
                              LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                      || ' <D2>',
                                                                      IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                      GTERRORS );
                           END IF;
                        WHEN 'S1'
                        THEN
                           LNRETVAL := IAPIGENERAL.ISVALIDSTRING( XMLDOM.GETNODEVALUE( LXNODE ),
                                                                  40 );

                           IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                           THEN
                              IAPIGENERAL.LOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
                              LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                      || ' <S1>',
                                                                      IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                      GTERRORS );
                           END IF;
                        WHEN 'S2'
                        THEN
                           LNRETVAL := IAPIGENERAL.ISVALIDSTRING( XMLDOM.GETNODEVALUE( LXNODE ),
                                                                  40 );

                           IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                           THEN
                              IAPIGENERAL.LOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
                              LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                      || ' <S2>',
                                                                      IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                      GTERRORS );
                           END IF;
                        WHEN 'S3'
                        THEN
                           LNRETVAL := IAPIGENERAL.ISVALIDSTRING( XMLDOM.GETNODEVALUE( LXNODE ),
                                                                  40 );

                           IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                           THEN
                              IAPIGENERAL.LOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
                              LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                      || ' <S3>',
                                                                      IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                      GTERRORS );
                           END IF;
                        WHEN 'S4'
                        THEN
                           LNRETVAL := IAPIGENERAL.ISVALIDSTRING( XMLDOM.GETNODEVALUE( LXNODE ),
                                                                  40 );

                           IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                           THEN
                              IAPIGENERAL.LOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
                              LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                      || ' <S4>',
                                                                      IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                      GTERRORS );
                           END IF;
                        WHEN 'S5'
                        THEN
                           LNRETVAL := IAPIGENERAL.ISVALIDSTRING( XMLDOM.GETNODEVALUE( LXNODE ),
                                                                  40 );

                           IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                           THEN
                              IAPIGENERAL.LOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
                              LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                      || ' <S5>',
                                                                      IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                      GTERRORS );
                           END IF;
                        WHEN 'S6'
                        THEN
                           LNRETVAL := IAPIGENERAL.ISVALIDSTRING( XMLDOM.GETNODEVALUE( LXNODE ),
                                                                  120 );

                           IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                           THEN
                              IAPIGENERAL.LOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
                              LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                      || ' <S6>',
                                                                      IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                      GTERRORS );
                           END IF;
                        WHEN 'B1'
                        THEN
                           LNRETVAL := IAPIGENERAL.ISBOOLEAN( XMLDOM.GETNODEVALUE( LXNODE ) );

                           IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                           THEN
                              IAPIGENERAL.LOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
                              LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                      || ' <B1>',
                                                                      IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                      GTERRORS );
                           END IF;
                        WHEN 'B2'
                        THEN
                           LNRETVAL := IAPIGENERAL.ISBOOLEAN( XMLDOM.GETNODEVALUE( LXNODE ) );

                           IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                           THEN
                              IAPIGENERAL.LOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
                              LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                      || ' <B2>',
                                                                      IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                      GTERRORS );
                           END IF;
                        WHEN 'B3'
                        THEN
                           LNRETVAL := IAPIGENERAL.ISBOOLEAN( XMLDOM.GETNODEVALUE( LXNODE ) );

                           IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                           THEN
                              IAPIGENERAL.LOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
                              LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                      || ' <B3>',
                                                                      IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                      GTERRORS );
                           END IF;
                        WHEN 'B4'
                        THEN
                           LNRETVAL := IAPIGENERAL.ISBOOLEAN( XMLDOM.GETNODEVALUE( LXNODE ) );

                           IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                           THEN
                              IAPIGENERAL.LOGINFO( GSSOURCE,
                                                   LSMETHOD,
                                                   IAPIGENERAL.GETLASTERRORTEXT( ) );
                              LNRETVAL := IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                                      || ' <B4>',
                                                                      IAPIGENERAL.GETLASTERRORTEXT( ),
                                                                      GTERRORS );
                           END IF;
                        WHEN 'INF'
                        THEN
                           NULL;
                        ELSE
                           NULL;
                     END CASE;
                  END IF;
               END IF;
            END LOOP;
         END LOOP;
      END IF;

      
      XMLDOM.FREEDOCUMENT( LXDOMDOCUMENT );
      XMLPARSER.FREEPARSER( LXPARSER );

      IF GTERRORS.COUNT = 0
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      ELSIF GTERRORS.COUNT > 0
      THEN
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_ERRORLIST );
      END IF;
   EXCEPTION
      WHEN SELF_IS_NULL
      THEN
         
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ISVALIDNUTPATHXML;


   FUNCTION TRANSFORMXMLNUTPATH(
      AXNUTXML                   IN       IAPITYPE.XMLTYPE_TYPE,
      ATNUTPATH                  OUT      IAPITYPE.NUTXMLTAB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'TransformXmlNutPath';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRNUTPATH                     IAPITYPE.NUTXMLREC_TYPE;
      LXPARSER                      XMLPARSER.PARSER;
      LXDOMDOCUMENT                 XMLDOM.DOMDOCUMENT;
      LXROOTELEMENT                 XMLDOM.DOMELEMENT;
      LXIMPORTDATAROWNODELIST       XMLDOM.DOMNODELIST;
      LXIMPORTDATAROWNODE           XMLDOM.DOMNODE;
      LXIMPORTDATAROWITEMSNODELIST  XMLDOM.DOMNODELIST;
      LXIMPORTDATAROWITEMSNODE      XMLDOM.DOMNODE;
      LXNODE                        XMLDOM.DOMNODE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      


      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LXPARSER := XMLPARSER.NEWPARSER;
      XMLPARSER.SETVALIDATIONMODE( LXPARSER,
                                   FALSE );
      XMLPARSER.PARSECLOB( LXPARSER,
                           AXNUTXML.GETCLOBVAL );
      LXDOMDOCUMENT := XMLPARSER.GETDOCUMENT( LXPARSER );

      
      
      
      IF ( NOT XMLDOM.ISNULL( LXDOMDOCUMENT ) )
      THEN
         
         LXIMPORTDATAROWNODELIST := XMLDOM.GETELEMENTSBYTAGNAME( LXDOMDOCUMENT,
                                                                 'ImportDataRow' );

         FOR I IN 0 ..(   XMLDOM.GETLENGTH( LXIMPORTDATAROWNODELIST )
                        - 1 )
         LOOP
            
            LXIMPORTDATAROWNODE := XMLDOM.ITEM( LXIMPORTDATAROWNODELIST,
                                                I );
            
            LXIMPORTDATAROWITEMSNODELIST := XMLDOM.GETCHILDNODES( LXIMPORTDATAROWNODE );
            LRNUTPATH := NULL;

            FOR J IN 0 ..(   XMLDOM.GETLENGTH( LXIMPORTDATAROWITEMSNODELIST )
                           - 1 )
            LOOP
               
               LXIMPORTDATAROWITEMSNODE := XMLDOM.ITEM( LXIMPORTDATAROWITEMSNODELIST,
                                                        J );
               
               LXNODE := XMLDOM.GETFIRSTCHILD( LXIMPORTDATAROWITEMSNODE );

               
               
               
               IF NOT XMLDOM.ISNULL( LXNODE )
               THEN
                  IF XMLDOM.GETNODETYPE( LXNODE ) = XMLDOM.TEXT_NODE
                  THEN
                     CASE UPPER( XMLDOM.GETNODENAME( LXIMPORTDATAROWITEMSNODE ) )
                        WHEN 'SP'
                        THEN
                           LRNUTPATH.PROPERTY := XMLDOM.GETNODEVALUE( LXNODE );

                           SELECT MAX( REVISION )
                             INTO LRNUTPATH.PROPERTYREVISION
                             FROM PROPERTY_H
                            WHERE PROPERTY = LRNUTPATH.PROPERTY
                             AND LANG_ID = NVL( IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,
                                                 1 );


                           IF LRNUTPATH.PROPERTYREVISION IS NULL
                           THEN
                              RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                         LSMETHOD,
                                                                         IAPICONSTANTDBERROR.DBERR_PROPERTYNOTFOUND,
                                                                         LRNUTPATH.PROPERTY,
                                                                         LRNUTPATH.PROPERTYREVISION );
                           END IF;
                        WHEN 'AT'
                        THEN
                           LRNUTPATH.ATTRIBUTE := XMLDOM.GETNODEVALUE( LXNODE );

                           SELECT MAX( REVISION )
                             INTO LRNUTPATH.ATTRIBUTEREVISION
                             FROM ATTRIBUTE_H
                            WHERE ATTRIBUTE = LRNUTPATH.ATTRIBUTE
                             AND LANG_ID = NVL( IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,
                                                 1 );


                           IF LRNUTPATH.ATTRIBUTEREVISION IS NULL
                           THEN
                              RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                         LSMETHOD,
                                                                         IAPICONSTANTDBERROR.DBERR_ATTRIBUTENOTFOUND,
                                                                         LRNUTPATH.ATTRIBUTE,
                                                                         LRNUTPATH.ATTRIBUTEREVISION );
                           END IF;
                        WHEN 'N1'
                        THEN
                           LRNUTPATH.NUMERIC1 := XMLDOM.GETNODEVALUE( LXNODE );
                        WHEN 'N2'
                        THEN
                           LRNUTPATH.NUMERIC2 := XMLDOM.GETNODEVALUE( LXNODE );
                        WHEN 'N3'
                        THEN
                           LRNUTPATH.NUMERIC3 := XMLDOM.GETNODEVALUE( LXNODE );
                        WHEN 'N4'
                        THEN
                           LRNUTPATH.NUMERIC4 := XMLDOM.GETNODEVALUE( LXNODE );
                        WHEN 'N5'
                        THEN
                           LRNUTPATH.NUMERIC5 := XMLDOM.GETNODEVALUE( LXNODE );
                        WHEN 'N6'
                        THEN
                           LRNUTPATH.NUMERIC6 := XMLDOM.GETNODEVALUE( LXNODE );
                        WHEN 'N7'
                        THEN
                           LRNUTPATH.NUMERIC7 := XMLDOM.GETNODEVALUE( LXNODE );
                        WHEN 'N8'
                        THEN
                           LRNUTPATH.NUMERIC8 := XMLDOM.GETNODEVALUE( LXNODE );
                        WHEN 'N9'
                        THEN
                           LRNUTPATH.NUMERIC9 := XMLDOM.GETNODEVALUE( LXNODE );
                        WHEN 'N10'
                        THEN
                           LRNUTPATH.NUMERIC10 := XMLDOM.GETNODEVALUE( LXNODE );
                        WHEN 'D1'
                        THEN
                           LRNUTPATH.DATE1 := TO_DATE( XMLDOM.GETNODEVALUE( LXNODE ),
                                                       'MM/DD/YYYY' );
                        WHEN 'D2'
                        THEN
                           LRNUTPATH.DATE2 := TO_DATE( XMLDOM.GETNODEVALUE( LXNODE ),
                                                       'MM/DD/YYYY' );
                        WHEN 'S1'
                        THEN
                           LRNUTPATH.STRING1 := XMLDOM.GETNODEVALUE( LXNODE );
                        WHEN 'S2'
                        THEN
                           LRNUTPATH.STRING2 := XMLDOM.GETNODEVALUE( LXNODE );
                        WHEN 'S3'
                        THEN
                           LRNUTPATH.STRING3 := XMLDOM.GETNODEVALUE( LXNODE );
                        WHEN 'S4'
                        THEN
                           LRNUTPATH.STRING4 := XMLDOM.GETNODEVALUE( LXNODE );
                        WHEN 'S5'
                        THEN
                           LRNUTPATH.STRING5 := XMLDOM.GETNODEVALUE( LXNODE );
                        WHEN 'S6'
                        THEN
                           LRNUTPATH.STRING6 := XMLDOM.GETNODEVALUE( LXNODE );
                        WHEN 'B1'
                        THEN
                           LRNUTPATH.BOOLEAN1 := XMLDOM.GETNODEVALUE( LXNODE );
                        WHEN 'B2'
                        THEN
                           LRNUTPATH.BOOLEAN2 := XMLDOM.GETNODEVALUE( LXNODE );
                        WHEN 'B3'
                        THEN
                           LRNUTPATH.BOOLEAN3 := XMLDOM.GETNODEVALUE( LXNODE );
                        WHEN 'B4'
                        THEN
                           LRNUTPATH.BOOLEAN4 := XMLDOM.GETNODEVALUE( LXNODE );
                        WHEN 'INF'
                        THEN
                           LRNUTPATH.INFO := XMLDOM.GETNODEVALUE( LXNODE );
                        ELSE
                           NULL;
                     END CASE;
                  END IF;
               END IF;
            END LOOP;

            ATNUTPATH( ATNUTPATH.COUNT ) := LRNUTPATH;
         END LOOP;
      END IF;

      
      XMLDOM.FREEDOCUMENT( LXDOMDOCUMENT );
      XMLPARSER.FREEPARSER( LXPARSER );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN SELF_IS_NULL
      THEN
         
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END TRANSFORMXMLNUTPATH;


   FUNCTION EXISTNUTLAYOUT(
      ANLAYOUTID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistNutLayout';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNLAYOUTID                    IAPITYPE.SEQUENCE_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT ANLAYOUTID
        INTO LNLAYOUTID
        FROM ITNUTLY
       WHERE LAYOUT_ID = ANLAYOUTID
         AND REVISION = ANREVISION;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_NUTLYNOTFOUND,
                                               ANLAYOUTID,
                                               ANREVISION );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;



      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTNUTLAYOUT;


   FUNCTION SAVENUTUSAGE(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ANSEQUENCENO               IN       IAPITYPE.SEQUENCE_TYPE,
      
      
      ANUSE                      IN       IAPITYPE.BOOLEAN_TYPE, 
      ANLOGID                    IN       IAPITYPE.LOGID_TYPE DEFAULT NULL,
      ANCOLID                    IN       IAPITYPE.COLID_TYPE DEFAULT NULL)
      
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS













      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveNutUsage';
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

     
     
     IF (ANUSE = 2)
     THEN
        IF (ANLOGID = NULL)
        THEN



            LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_INVALIDNUTPROFILEID);
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN (IAPICONSTANTDBERROR.DBERR_GENFAIL);
        END IF;

        IF (ANCOLID = NULL)
        THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_INVALIDNUTCOLID);
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
                    RETURN (IAPICONSTANTDBERROR.DBERR_GENFAIL);
        END IF;

     END IF;
     


      
      UPDATE ITNUTPATH
         SET USE = ANUSE
       WHERE BOM_EXP_NO = ANUNIQUEID
         AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
         AND SEQUENCE_NO = ANSEQUENCENO;


      
      
      
      
      IF (ANUSE = 2)
      THEN
         
         UPDATE   ITNUTPATH
            SET   LOG_ID = ANLOGID,
                  COL_ID = ANCOLID
          WHERE       BOM_EXP_NO = ANUNIQUEID
                  AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                  AND SEQUENCE_NO = ANSEQUENCENO;

         
         



      END IF;
      

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVENUTUSAGE;



























































































   
   
   
   
















































































































































































































   FUNCTION GETNUTLYITEMS(
      ANLAYOUTID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      AQNUTLYITEMS               OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetNutLyItems';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' Layout_id '
            || IAPICONSTANTCOLUMN.LAYOUTIDCOL
            || ', Revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', f_hdh_descr(1,header_id,header_rev) '
            || IAPICONSTANTCOLUMN.HEADERCOL
            || ', data_Type '
            || IAPICONSTANTCOLUMN.DATATYPECOL
            || ', nvl(modifiable,0) '
            || IAPICONSTANTCOLUMN.MODIFIABLECOL
            || ', length '
            || IAPICONSTANTCOLUMN.LENGTHCOL
            || ', Col_Type '
            || IAPICONSTANTCOLUMN.COLUMNTYPECOL
            || ', seq_no '
            || IAPICONSTANTCOLUMN.SEQUENCECOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM itNutLyitem ';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE :=    ' WHERE Layout_id = :anLayoutId '
                                                               || ' AND Revision = :anRevision ';
      LSORDERBY                     IAPITYPE.SQLSTRING_TYPE := ' ORDER BY seq_no ';
   BEGIN





      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || ' AND 1=2 '
               || LSORDERBY;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQNUTLYITEMS FOR LSSQL USING ANLAYOUTID,
      ANREVISION;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNRETVAL := EXISTNUTLAYOUT( ANLAYOUTID,
                                  ANREVISION );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || LSORDERBY;

      IF AQNUTLYITEMS%ISOPEN
      THEN
         CLOSE AQNUTLYITEMS;
      END IF;

      OPEN AQNUTLYITEMS FOR LSSQL USING ANLAYOUTID,
      ANREVISION;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETNUTLYITEMS;


   FUNCTION TRANSFORMXMLNUTFILTER(
      AXFILTERDETAILS            IN       IAPITYPE.XMLTYPE_TYPE,
      ATFILTERDETAILS            OUT      IAPITYPE.NUTFILTERDETAILSTAB_TYPE,
      AQERRORS                   IN OUT NOCOPY IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'TransformXmlNutFilter';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSROWID                       IAPITYPE.STRING_TYPE;
      LXPARSER                      XMLPARSER.PARSER;
      LBPARSERCREATED               BOOLEAN;
      LXDOMDOCUMENT                 XMLDOM.DOMDOCUMENT;
      LXROOTELEMENT                 XMLDOM.DOMELEMENT;
      LXFILTERNODESLIST             XMLDOM.DOMNODELIST;
      LXFILTERNODE                  XMLDOM.DOMNODE;
      LXFILTERITEMNODE              XMLDOM.DOMNODE;
      LXFILTERITEMNODESLIST         XMLDOM.DOMNODELIST;
      LXELEMENT                     XMLDOM.DOMELEMENT;
      LXNODE                        XMLDOM.DOMNODE;
      LRNUTFILTERDETAILS            IAPITYPE.NUTFILTERDETAILSREC_TYPE;
   BEGIN
      GTERRORS.DELETE;



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LXPARSER := XMLPARSER.NEWPARSER;
      LBPARSERCREATED := TRUE;
      XMLPARSER.SETVALIDATIONMODE( LXPARSER,
                                   FALSE );
      XMLPARSER.PARSECLOB( LXPARSER,
                           AXFILTERDETAILS.GETCLOBVAL( ) );
      LXDOMDOCUMENT := XMLPARSER.GETDOCUMENT( LXPARSER );

      IF ( NOT XMLDOM.ISNULL( LXDOMDOCUMENT ) )
      THEN
         
         LXROOTELEMENT := XMLDOM.GETDOCUMENTELEMENT( LXDOMDOCUMENT );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'ROOT element <'
                              || XMLDOM.GETLOCALNAME( LXROOTELEMENT )
                              || '>' );
         
         LXFILTERNODESLIST := XMLDOM.GETELEMENTSBYTAGNAME( LXROOTELEMENT,
                                                           'Filter' );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Number of Filters <'
                              || XMLDOM.GETLENGTH( LXFILTERNODESLIST )
                              || '>' );

         
         FOR I IN 0 ..   XMLDOM.GETLENGTH( LXFILTERNODESLIST )
                       - 1
         LOOP
            LXFILTERNODE := XMLDOM.ITEM( LXFILTERNODESLIST,
                                         I );







            LRNUTFILTERDETAILS := NULL;
            LXFILTERITEMNODESLIST := XMLDOM.GETCHILDNODES( LXFILTERNODE );
            LSROWID :=    'ROW='
                       || (   I
                            + 1 );

            FOR J IN 0 ..   XMLDOM.GETLENGTH( LXFILTERITEMNODESLIST )
                          - 1
            LOOP
               LXFILTERITEMNODE := XMLDOM.ITEM( LXFILTERITEMNODESLIST,
                                                J );
               
               LXNODE := XMLDOM.GETFIRSTCHILD( LXFILTERITEMNODE );

               IF ( XMLDOM.GETNODETYPE( LXNODE ) = XMLDOM.TEXT_NODE )
               THEN









                  CASE UPPER( XMLDOM.GETNODENAME( LXFILTERITEMNODE ) )
                     WHEN IAPICONSTANTCOLUMN.SEQUENCECOL   
                     THEN
                        LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IAPIGENERAL.LOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                IAPIGENERAL.GETLASTERRORTEXT( ) );
                           LNRETVAL :=
                              IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                          || ' <'
                                                          || IAPICONSTANTCOLUMN.SEQUENCECOL
                                                          || '>',
                                                          IAPIGENERAL.GETLASTERRORTEXT( ),
                                                          GTERRORS );
                        ELSE
                           LRNUTFILTERDETAILS.SEQUENCE := XMLDOM.GETNODEVALUE( LXNODE );
                        END IF;
                     WHEN IAPICONSTANTCOLUMN.PROPERTYCOL
                     THEN
                        LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IAPIGENERAL.LOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                IAPIGENERAL.GETLASTERRORTEXT( ) );
                           LNRETVAL :=
                              IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                          || ' <'
                                                          || IAPICONSTANTCOLUMN.PROPERTYCOL
                                                          || '>',
                                                          IAPIGENERAL.GETLASTERRORTEXT( ),
                                                          GTERRORS );
                        ELSE
                           LRNUTFILTERDETAILS.PROPERTYID := XMLDOM.GETNODEVALUE( LXNODE );
                        END IF;
                     WHEN IAPICONSTANTCOLUMN.PROPERTYREVISIONCOL
                     THEN
                        LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IAPIGENERAL.LOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                IAPIGENERAL.GETLASTERRORTEXT( ) );
                           LNRETVAL :=
                              IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                          || ' <'
                                                          || IAPICONSTANTCOLUMN.PROPERTYREVISIONCOL
                                                          || '>',
                                                          IAPIGENERAL.GETLASTERRORTEXT( ),
                                                          GTERRORS );
                        ELSE
                           LRNUTFILTERDETAILS.PROPERTYREVISION := XMLDOM.GETNODEVALUE( LXNODE );
                        END IF;
                     WHEN IAPICONSTANTCOLUMN.ATTRIBUTECOL
                     THEN
                        LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IAPIGENERAL.LOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                IAPIGENERAL.GETLASTERRORTEXT( ) );
                           LNRETVAL :=
                              IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                          || ' <'
                                                          || IAPICONSTANTCOLUMN.ATTRIBUTECOL
                                                          || '>',
                                                          IAPIGENERAL.GETLASTERRORTEXT( ),
                                                          GTERRORS );
                        ELSE
                           LRNUTFILTERDETAILS.ATTRIBUTEID := XMLDOM.GETNODEVALUE( LXNODE );
                        END IF;
                     WHEN IAPICONSTANTCOLUMN.ATTRIBUTEREVISIONCOL
                     THEN
                        LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IAPIGENERAL.LOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                IAPIGENERAL.GETLASTERRORTEXT( ) );
                           LNRETVAL :=
                              IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                          || ' <'
                                                          || IAPICONSTANTCOLUMN.ATTRIBUTEREVISIONCOL
                                                          || '>',
                                                          IAPIGENERAL.GETLASTERRORTEXT( ),
                                                          GTERRORS );
                        ELSE
                           LRNUTFILTERDETAILS.ATTRIBUTEREVISION := XMLDOM.GETNODEVALUE( LXNODE );
                        END IF;
                     WHEN IAPICONSTANTCOLUMN.VISIBLECOL
                     THEN
                        LNRETVAL := IAPIGENERAL.ISBOOLEAN( XMLDOM.GETNODEVALUE( LXNODE ) );

                        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IAPIGENERAL.LOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                IAPIGENERAL.GETLASTERRORTEXT( ) );
                           LNRETVAL :=
                              IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                          || ' <'
                                                          || IAPICONSTANTCOLUMN.VISIBLECOL
                                                          || '>',
                                                          IAPIGENERAL.GETLASTERRORTEXT( ),
                                                          GTERRORS );
                        ELSE
                           LRNUTFILTERDETAILS.VISIBLE := XMLDOM.GETNODEVALUE( LXNODE );
                        END IF;
                     ELSE
                        NULL;
                  END CASE;
               END IF;
            END LOOP;

            IF     LRNUTFILTERDETAILS.PROPERTYID IS NOT NULL
               AND LRNUTFILTERDETAILS.PROPERTYREVISION IS NOT NULL
            THEN
               LNRETVAL := IAPIPROPERTY.EXISTPROPERTY( LRNUTFILTERDETAILS.PROPERTYID,
                                                       LRNUTFILTERDETAILS.PROPERTYREVISION );

               IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
               THEN
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                       IAPIGENERAL.GETLASTERRORTEXT( ) );
                  LNRETVAL :=
                     IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                 || ' <'
                                                 || IAPICONSTANTCOLUMN.PROPERTYCOL
                                                 || ','
                                                 || IAPICONSTANTCOLUMN.PROPERTYREVISIONCOL
                                                 || '>',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
               END IF;
            END IF;

            IF     LRNUTFILTERDETAILS.ATTRIBUTEID IS NOT NULL
               AND LRNUTFILTERDETAILS.ATTRIBUTEREVISION IS NOT NULL
            THEN
               LNRETVAL := IAPIATTRIBUTE.EXISTATTRIBUTE( LRNUTFILTERDETAILS.ATTRIBUTEID,
                                                         LRNUTFILTERDETAILS.ATTRIBUTEREVISION );

               IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
               THEN
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                       IAPIGENERAL.GETLASTERRORTEXT( ) );
                  LNRETVAL :=
                     IAPIGENERAL.ADDERRORTOLIST(    LSROWID
                                                 || ' <'
                                                 || IAPICONSTANTCOLUMN.ATTRIBUTECOL
                                                 || ','
                                                 || IAPICONSTANTCOLUMN.ATTRIBUTEREVISIONCOL
                                                 || '>',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
               END IF;
            END IF;

            ATFILTERDETAILS( ATFILTERDETAILS.COUNT ) := LRNUTFILTERDETAILS;
         END LOOP;
      END IF;

      
      XMLDOM.FREEDOCUMENT( LXDOMDOCUMENT );
      
      XMLPARSER.FREEPARSER( LXPARSER );

      IF GTERRORS.COUNT = 0
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      ELSIF GTERRORS.COUNT > 0
      THEN
         ATFILTERDETAILS.DELETE;
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_ERRORLIST );
      END IF;
   EXCEPTION
      WHEN SELF_IS_NULL
      THEN
         
         ATFILTERDETAILS.DELETE;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END TRANSFORMXMLNUTFILTER;


   FUNCTION GETNUTRESULT(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      AQNUTRESULTS               OUT      IAPITYPE.REF_TYPE,
      ASDECIMALSEPERATOR         IN       IAPITYPE.DECIMALSEPERATOR_TYPE DEFAULT IAPIGENERAL.GETDBDECIMALSEPERATOR )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetNutResult';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQLNUTRESULT                IAPITYPE.SQLSTRING_TYPE;
      LTNUTCOL                      IAPITYPE.NUTCOLTAB_TYPE;
      LSDBDECIMALSEPERATOR          IAPITYPE.DECIMALSEPERATOR_TYPE DEFAULT IAPIGENERAL.GETDBDECIMALSEPERATOR;
   BEGIN





      LSSQLNUTRESULT :=    'SELECT null FROM DUAL '
                        || 'WHERE 1=2 ';

      
      IF ( AQNUTRESULTS%ISOPEN )
      THEN
         CLOSE AQNUTRESULTS;
      END IF;

      OPEN AQNUTRESULTS FOR TO_CHAR( LSSQLNUTRESULT );




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT DISTINCT COL_ID,
                         'ColId'
                      || COL_ID,
                      DATA_TYPE
      BULK COLLECT INTO LTNUTCOL
                 FROM ITNUTRESULT A,
                      ITNUTLYITEM B
                WHERE A.BOM_EXP_NO = ANUNIQUEID
                  AND A.MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                  AND A.LAYOUT_ID = B.LAYOUT_ID
                  AND A.LAYOUT_REVISION = B.REVISION
                  AND A.COL_ID = B.SEQ_NO
             ORDER BY COL_ID;

      LSSQLNUTRESULT :=
            'select row_id '
         || IAPICONSTANTCOLUMN.ROWIDCOL
         || ',max(Property) '
         || IAPICONSTANTCOLUMN.PROPERTYIDCOL
         || ',max(Property_rev) '
         || IAPICONSTANTCOLUMN.PROPERTYREVISIONCOL
         || ',max(f_sph_descr( 1,Property,Property_rev )) '
         || IAPICONSTANTCOLUMN.PROPERTYCOL
         || ',max(Attribute) '
         || IAPICONSTANTCOLUMN.ATTRIBUTEIDCOL
         || ',max(Attribute_rev) '
         || IAPICONSTANTCOLUMN.ATTRIBUTEREVISIONCOL
         || ',max(f_ath_descr( 1,Attribute,Attribute_rev )) '
         || IAPICONSTANTCOLUMN.ATTRIBUTECOL
         || ' ';

      IF LTNUTCOL.COUNT > 0
      THEN
         FOR I IN LTNUTCOL.FIRST .. LTNUTCOL.LAST
         LOOP
            LSSQLNUTRESULT :=
                  LSSQLNUTRESULT
               || ', F_Get_Nut_Optional_Column( '
               || ANUNIQUEID
               || ' , '
               || ANMOPSEQUENCENO
               || ' , row_id '
               || ' , '
               || I
               || ' , '
               || LTNUTCOL( I ).DATATYPE
               || ' , '
               || ''''
               || ASDECIMALSEPERATOR
               || ''''
               || ' ) ';
            LSSQLNUTRESULT :=    LSSQLNUTRESULT
                              || SUBSTR( LTNUTCOL( I ).HEADER,
                                         1,
                                         30 );
         END LOOP;
      END IF;

      LSSQLNUTRESULT :=
            LSSQLNUTRESULT
         || ' FROM itNutResult '
         || ' WHERE Bom_exp_no = :anUniqueId '
         || ' AND Mop_Sequence_no = :anMopSequenceNo '
         || ' GROUP BY row_ID '
         || ' ORDER BY row_ID ';

      
      IF ( AQNUTRESULTS%ISOPEN )
      THEN
         CLOSE AQNUTRESULTS;
      END IF;

      OPEN AQNUTRESULTS FOR TO_CHAR( LSSQLNUTRESULT ) USING ANUNIQUEID,
      ANMOPSEQUENCENO;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQLNUTRESULT :=    'SELECT null FROM DUAL '
                           || 'WHERE 1=2 ';

         
         IF ( AQNUTRESULTS%ISOPEN )
         THEN
            CLOSE AQNUTRESULTS;
         END IF;

         OPEN AQNUTRESULTS FOR TO_CHAR( LSSQLNUTRESULT );

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETNUTRESULT;


   FUNCTION REMOVENUTRESULT(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveNutResult';
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

      DELETE FROM ITNUTRESULT
            WHERE BOM_EXP_NO = ANUNIQUEID
              AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NUTRESULTNOTFOUND,
                                                    ANUNIQUEID,
                                                    ANMOPSEQUENCENO );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVENUTRESULT;


   FUNCTION ADDNUTRESULT(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ANROWID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANCOLID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANNUMVAL                   IN       IAPITYPE.BOMQUANTITY_TYPE,
      ASSTRVAL                   IN       IAPITYPE.CLOB_TYPE,
      ADDATEVAL                  IN       IAPITYPE.DATE_TYPE,
      ANBOOLEAN                  IN       IAPITYPE.BOOLEAN_TYPE,
      ANPROPERTY                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANPROPERTYREVISION         IN       IAPITYPE.REVISION_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.SEQUENCE_TYPE,
      ANATTRIBUTEREVISION        IN       IAPITYPE.REVISION_TYPE,
      ASDISPLAYNAME              IN       IAPITYPE.STRING_TYPE,
      ANLAYOUTID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTREVISION           IN       IAPITYPE.REVISION_TYPE,
      ASDECSEP                   IN       IAPITYPE.DECIMALSEPERATOR_TYPE DEFAULT IAPIGENERAL.GETDBDECIMALSEPERATOR )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddNutResult';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRNUTRESULT                   IAPITYPE.NUTRESULT_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      


      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LRNUTRESULT := NULL;
      LRNUTRESULT.BOM_EXP_NO := ANUNIQUEID;
      LRNUTRESULT.MOP_SEQUENCE_NO := ANMOPSEQUENCENO;
      LRNUTRESULT.ROW_ID := ANROWID;
      LRNUTRESULT.COL_ID := ANCOLID;
      LRNUTRESULT.NUM_VAL := ANNUMVAL;
      LRNUTRESULT.STR_VAL := ASSTRVAL;
      LRNUTRESULT.DATE_VAL := ADDATEVAL;
      LRNUTRESULT.BOOLEAN_VAL := ANBOOLEAN;
      LRNUTRESULT.PROPERTY := ANPROPERTY;
      LRNUTRESULT.PROPERTY_REV := ANPROPERTYREVISION;
      LRNUTRESULT.ATTRIBUTE := ANATTRIBUTEID;
      LRNUTRESULT.ATTRIBUTE_REV := ANATTRIBUTEREVISION;
      LRNUTRESULT.DISPLAY_NAME := ASDISPLAYNAME;
      LRNUTRESULT.LAYOUT_ID := ANLAYOUTID;
      LRNUTRESULT.LAYOUT_REVISION := ANLAYOUTREVISION;
      LRNUTRESULT.DEC_SEP := ASDECSEP;

      INSERT INTO ITNUTRESULT
                  ( BOM_EXP_NO,
                    COL_ID,
                    NUM_VAL,
                    STR_VAL,
                    PROPERTY,
                    PROPERTY_REV,
                    ATTRIBUTE,
                    ATTRIBUTE_REV,
                    DATE_VAL,
                    BOOLEAN_VAL,
                    LAYOUT_ID,
                    LAYOUT_REVISION,
                    MOP_SEQUENCE_NO,
                    ROW_ID,
                    DISPLAY_NAME,
                    DEC_SEP )
           VALUES ( LRNUTRESULT.BOM_EXP_NO,
                    LRNUTRESULT.COL_ID,
                    LRNUTRESULT.NUM_VAL,
                    LRNUTRESULT.STR_VAL,
                    LRNUTRESULT.PROPERTY,
                    LRNUTRESULT.PROPERTY_REV,
                    LRNUTRESULT.ATTRIBUTE,
                    LRNUTRESULT.ATTRIBUTE_REV,
                    LRNUTRESULT.DATE_VAL,
                    LRNUTRESULT.BOOLEAN_VAL,
                    LRNUTRESULT.LAYOUT_ID,
                    LRNUTRESULT.LAYOUT_REVISION,
                    LRNUTRESULT.MOP_SEQUENCE_NO,
                    LRNUTRESULT.ROW_ID,
                    LRNUTRESULT.DISPLAY_NAME,
                    LRNUTRESULT.DEC_SEP );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDNUTRESULT;


   FUNCTION SAVENUTRESULT(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ANROWID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANCOLID                    IN       IAPITYPE.SEQUENCE_TYPE,
      ANNUMVAL                   IN       IAPITYPE.BOMQUANTITY_TYPE,
      ASSTRVAL                   IN       IAPITYPE.CLOB_TYPE,
      ADDATEVAL                  IN       IAPITYPE.DATE_TYPE,
      ANBOOLEAN                  IN       IAPITYPE.BOOLEAN_TYPE,
      ANPROPERTY                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANPROPERTYREVISION         IN       IAPITYPE.REVISION_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.SEQUENCE_TYPE,
      ANATTRIBUTEREVISION        IN       IAPITYPE.REVISION_TYPE,
      ASDISPLAYNAME              IN       IAPITYPE.STRING_TYPE,
      ANLAYOUTID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTREVISION           IN       IAPITYPE.REVISION_TYPE,
      ASDECSEP                   IN       IAPITYPE.DECIMALSEPERATOR_TYPE DEFAULT IAPIGENERAL.GETDBDECIMALSEPERATOR )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveNutResult';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRNUTRESULT                   IAPITYPE.NUTRESULT_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      


      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LRNUTRESULT := NULL;
      LRNUTRESULT.BOM_EXP_NO := ANUNIQUEID;
      LRNUTRESULT.MOP_SEQUENCE_NO := ANMOPSEQUENCENO;
      LRNUTRESULT.ROW_ID := ANROWID;
      LRNUTRESULT.COL_ID := ANCOLID;
      LRNUTRESULT.NUM_VAL := ANNUMVAL;
      LRNUTRESULT.STR_VAL := ASSTRVAL;
      LRNUTRESULT.DATE_VAL := ADDATEVAL;
      LRNUTRESULT.BOOLEAN_VAL := ANBOOLEAN;
      LRNUTRESULT.PROPERTY := ANPROPERTY;
      LRNUTRESULT.PROPERTY_REV := ANPROPERTYREVISION;
      LRNUTRESULT.ATTRIBUTE := ANATTRIBUTEID;
      LRNUTRESULT.ATTRIBUTE_REV := ANATTRIBUTEREVISION;
      LRNUTRESULT.DISPLAY_NAME := ASDISPLAYNAME;
      LRNUTRESULT.LAYOUT_ID := ANLAYOUTID;
      LRNUTRESULT.LAYOUT_REVISION := ANLAYOUTREVISION;
      LRNUTRESULT.DEC_SEP := ASDECSEP;

      UPDATE ITNUTRESULT
         SET ROW = LRNUTRESULT
       WHERE BOM_EXP_NO = ANUNIQUEID
         AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
         AND ROW_ID = ANROWID
         AND COL_ID = ANCOLID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVENUTRESULT;


   FUNCTION GETCURRENTNUTLY(
      AQNUTLY                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetCurrentNutLy';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' ly.Layout_id '
            || IAPICONSTANTCOLUMN.LAYOUTIDCOL
            || ', ly.Revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', ly.description '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM itNutLy ly  ';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE := ' WHERE ly.Status = 2 ';
   BEGIN





      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || ' AND 1=2 ';

      OPEN AQNUTLY FOR LSSQL;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE;

      IF ( AQNUTLY%ISOPEN )
      THEN
         CLOSE AQNUTLY;
      END IF;

      OPEN AQNUTLY FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'SELECT '
                  || LSSELECT
                  || LSFROM
                  || LSWHERE
                  || ' AND 1=2 ';

         IF ( AQNUTLY%ISOPEN )
         THEN
            CLOSE AQNUTLY;
         END IF;

         OPEN AQNUTLY FOR LSSQL;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETCURRENTNUTLY;


   FUNCTION CALCULATE(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE,
      ANSERVINGWEIGHT            IN       IAPITYPE.NUMVAL_TYPE DEFAULT 100,
      ASDECSEP                   IN       IAPITYPE.DECIMALSEPERATOR_TYPE DEFAULT IAPIGENERAL.GETDBDECIMALSEPERATOR )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Calculate';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LQNUTLY                       IAPITYPE.REF_TYPE;
      LNLAYOUTID                    IAPITYPE.SEQUENCE_TYPE;
      LSLAYOUTDESCRIPTION           IAPITYPE.DESCRIPTION_TYPE;
      LNLAYOUTREVISION              IAPITYPE.REVISION_TYPE;
      LSNUTRESULTCALC               IAPITYPE.SQLSTRING_TYPE;
      LSCALCVALUE                   IAPITYPE.CLOB_TYPE;
      LRNUTRESULT                   IAPITYPE.NUTRESULT_TYPE;
      LRNUTRESULTDETAIL             IAPITYPE.NUTRESULTDETAIL_TYPE;
      LNNUTRESULTDETAILROWID        IAPITYPE.ID_TYPE;
      LNVALUECOL                    IAPITYPE.ID_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LNNOTETYPE                    IAPITYPE.ID_TYPE;
      LNSECTION                     IAPITYPE.ID_TYPE;
      LNSUBSECTION                  IAPITYPE.ID_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LSSQLALTER                    IAPITYPE.SQLSTRING_TYPE;
      
      LNSEQUENCE_NO                 IAPITYPE.SEQUENCENR_TYPE;
      LNSERVVOL                    IAPITYPE.SERVINGVOL_TYPE;
      

    
     CURSOR LNUTPATH_CURSOR(
          ANBOM_EXP_NO          IN      ITNUTPATH.BOM_EXP_NO%TYPE,
          ANMOP_SEQUENCE_NO     IN      ITNUTPATH.MOP_SEQUENCE_NO%TYPE)
       IS
          SELECT SEQUENCE_NO, SERV_VOL
            FROM ITNUTPATH
           WHERE     BOM_EXP_NO = ANBOM_EXP_NO
                 AND MOP_SEQUENCE_NO = ANMOP_SEQUENCE_NO
                 AND NUT_XML IS NOT NULL;
    

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

      IF ASDECSEP <> IAPIGENERAL.GETDBDECIMALSEPERATOR
      THEN
         LSSQLALTER :=    'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = '''
                       || ASDECSEP
                       || ' ''';

         EXECUTE IMMEDIATE LSSQLALTER;
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      DELETE FROM ITNUTRESULT
            WHERE BOM_EXP_NO = ANUNIQUEID
              AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO;

      DELETE FROM ITNUTRESULTDETAIL
            WHERE BOM_EXP_NO = ANUNIQUEID
              AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO;

      LNRETVAL := GETCURRENTNUTLY( LQNUTLY );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );

         CLOSE LQNUTLY;

         RETURN( LNRETVAL );
      END IF;

      FETCH LQNUTLY
       INTO LNLAYOUTID,
            LNLAYOUTREVISION,
            LSLAYOUTDESCRIPTION;

      IF LNLAYOUTID IS NULL
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_NUTLYNOTFOUND,
                                               LNLAYOUTID,
                                               LNLAYOUTREVISION );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      BEGIN
         SELECT VALUE_COL,
                NOTE,
                SECTION_ID,
                SUB_SECTION_ID
           INTO LNVALUECOL,
                LNNOTETYPE,
                LNSECTION,
                LNSUBSECTION
           FROM ITNUTREFTYPE
          WHERE REF_TYPE = ASNUTREFTYPE;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                          LSMETHOD,
                                                          IAPICONSTANTDBERROR.DBERR_NUTREFSPECNOTFOUND,
                                                          ASNUTREFTYPE );
               RETURN( LNRETVAL );
            END IF;
      END;

      
      
















       

      

      
      UPDATE ITNUTPATH
         SET CALC_QTY =   CALC_QTY
                        * (   NVL( ANSERVINGWEIGHT,
                                   100 )
                            / 100 )
       WHERE BOM_EXP_NO = ANUNIQUEID
         AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
         AND  NUT_XML IS NULL;


      UPDATE ITNUTEXPLOSION TBL
         SET CALC_QTY =   CALC_QTY
                        * (   NVL( ANSERVINGWEIGHT,
                                   100 )
                            / 100 )
       WHERE BOM_EXP_NO = ANUNIQUEID
         AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
         AND EXISTS (SELECT *
                     FROM ITNUTPATH BB
                     WHERE  BB.BOM_EXP_NO = TBL.BOM_EXP_NO
                        AND BB.MOP_SEQUENCE_NO = TBL.MOP_SEQUENCE_NO
                        AND BB.SEQUENCE_NO = TBL.SEQUENCE_NO
                        AND BB.NUT_XML IS NULL);


      
      UPDATE ITNUTPATH
         SET CALC_QTY =   CALC_QTY
                        * (   NVL( SERV_VOL,
                                   100 )
                            / 100 )
       WHERE BOM_EXP_NO = ANUNIQUEID
         AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
         AND  NUT_XML IS NOT NULL;


      OPEN LNUTPATH_CURSOR( ANUNIQUEID, ANMOPSEQUENCENO);

      LOOP
          FETCH LNUTPATH_CURSOR
           INTO LNSEQUENCE_NO, LNSERVVOL;

            EXIT WHEN LNUTPATH_CURSOR%NOTFOUND;

            UPDATE ITNUTEXPLOSION
            SET CALC_QTY =   CALC_QTY
                    * (   NVL( LNSERVVOL,
                               100 )
                        / 100 )
            WHERE BOM_EXP_NO = ANUNIQUEID
            AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
            AND SEQUENCE_NO = LNSEQUENCE_NO;
      END LOOP;

      CLOSE LNUTPATH_CURSOR;
      

      
      
      

      
      
      FOR NE1 IN ( SELECT  ROW_ID,
                           MAX( PROPERTY ) PROPERTY,
                           MAX( PROPERTY_REV ) PROPERTY_REV,
                           MAX( ATTRIBUTE ) ATTRIBUTE,
                           MAX( ATTRIBUTE_REV ) ATTRIBUTE_REV
                      FROM ITNUTEXPLOSION
                     WHERE BOM_EXP_NO = ANUNIQUEID
                       AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                  GROUP BY ROW_ID
                  ORDER BY ROW_ID )
      LOOP
         LNNUTRESULTDETAILROWID := 0;

         
         FOR NP IN ( SELECT  DISPLAY_NAME,
                             PART_NO,
                             REVISION,
                             SUM( CALC_QTY ) TOTAL_DISPLAY_QTY
                        FROM ITNUTPATH
                       WHERE BOM_EXP_NO = ANUNIQUEID
                         AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                         
                         
                         
                         AND USE IN (1, 2)
                         
                    GROUP BY DISPLAY_NAME,
                             PART_NO,
                             REVISION
                    ORDER BY 1 )
         LOOP
            LRNUTRESULTDETAIL := NULL;
            LRNUTRESULTDETAIL.BOM_EXP_NO := ANUNIQUEID;
            LRNUTRESULTDETAIL.MOP_SEQUENCE_NO := ANMOPSEQUENCENO;
            LRNUTRESULTDETAIL.LAYOUT_ID := LNLAYOUTID;
            LRNUTRESULTDETAIL.LAYOUT_REVISION := LNLAYOUTREVISION;
            LRNUTRESULTDETAIL.COL_ID := NE1.ROW_ID;
            LNNUTRESULTDETAILROWID :=   LNNUTRESULTDETAILROWID
                                      + 1;
            LRNUTRESULTDETAIL.ROW_ID := LNNUTRESULTDETAILROWID;
            LRNUTRESULTDETAIL.PROPERTY := NE1.PROPERTY;
            LRNUTRESULTDETAIL.PROPERTY_REV := NE1.PROPERTY_REV;
            LRNUTRESULTDETAIL.ATTRIBUTE := NE1.ATTRIBUTE;
            LRNUTRESULTDETAIL.ATTRIBUTE_REV := NE1.ATTRIBUTE_REV;
            LRNUTRESULTDETAIL.DISPLAY_NAME := NP.DISPLAY_NAME;
            LRNUTRESULTDETAIL.PART_NO := NP.PART_NO;
            LRNUTRESULTDETAIL.PART_REVISION := NP.REVISION;
            LRNUTRESULTDETAIL.CALC_QTY := NP.TOTAL_DISPLAY_QTY;

            BEGIN
               IF LRNUTRESULTDETAIL.PART_NO IS NOT NULL
               THEN
                  SELECT TEXT
                    INTO LRNUTRESULTDETAIL.NOTE
                    FROM SPECIFICATION_TEXT
                   WHERE PART_NO = LRNUTRESULTDETAIL.PART_NO
                     AND REVISION = LRNUTRESULTDETAIL.PART_REVISION
                     AND TEXT_TYPE = LNNOTETYPE
                     AND SECTION_ID = LNSECTION
                     AND SUB_SECTION_ID = LNSUBSECTION
                     AND LANG_ID = NVL( IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,
                                        1 );
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  LRNUTRESULTDETAIL.NOTE := NULL;
            END;

            LSSQL :=
                  'SELECT SUM(num_'
               || LNVALUECOL
               || '  * calc_qty ) '
               || ' FROM itnutExplosion '
               || ' WHERE Bom_exp_no = :anUniqueId '
               || ' AND Mop_Sequence_no = :anMopSequenceNo '
               || ' AND row_id = :Col_Id '
               || ' AND Display_Name = :Display_Name ';

            EXECUTE IMMEDIATE LSSQL
                         INTO LRNUTRESULTDETAIL.NUM_VAL
                        USING ANUNIQUEID,
                              ANMOPSEQUENCENO,
                              LRNUTRESULTDETAIL.COL_ID,
                              LRNUTRESULTDETAIL.DISPLAY_NAME;

            
               
            LRNUTRESULTDETAIL.NUM_VAL :=
                 (   LRNUTRESULTDETAIL.NUM_VAL
                   / 100 )
               * GETNUTBASICCONVERSTIONFACTOR( LRNUTRESULTDETAIL.PART_NO,
                                               LRNUTRESULTDETAIL.PART_REVISION,
                                               ASNUTREFTYPE );

            
            IF LRNUTRESULTDETAIL.NUM_VAL IS NULL
            THEN
               SELECT COUNT( * )
                 INTO LNCOUNT
                 FROM ITNUTEXPLOSION
                WHERE BOM_EXP_NO = ANUNIQUEID
                  AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                  AND DISPLAY_NAME = LRNUTRESULTDETAIL.DISPLAY_NAME
                  AND PROPERTY = LRNUTRESULTDETAIL.PROPERTY
                  AND ATTRIBUTE = LRNUTRESULTDETAIL.ATTRIBUTE;

               IF LNCOUNT = 0
               THEN
                  LRNUTRESULTDETAIL.NOT_AVAILABLE := 1;
               ELSE
                  LRNUTRESULTDETAIL.NOT_AVAILABLE := 0;
               END IF;
            ELSE
               LRNUTRESULTDETAIL.NOT_AVAILABLE := 0;
            END IF;

            INSERT INTO ITNUTRESULTDETAIL
                        ( BOM_EXP_NO,
                          MOP_SEQUENCE_NO,
                          ROW_ID,
                          COL_ID,
                          NUM_VAL,
                          STR_VAL,
                          DATE_VAL,
                          BOOLEAN_VAL,
                          PROPERTY,
                          PROPERTY_REV,
                          ATTRIBUTE,
                          ATTRIBUTE_REV,
                          LAYOUT_ID,
                          LAYOUT_REVISION,
                          DISPLAY_NAME,
                          PART_NO,
                          PART_REVISION,
                          CALC_QTY,
                          NOTE,
                          NOT_AVAILABLE )
                 VALUES ( LRNUTRESULTDETAIL.BOM_EXP_NO,
                          LRNUTRESULTDETAIL.MOP_SEQUENCE_NO,
                          LRNUTRESULTDETAIL.ROW_ID,
                          LRNUTRESULTDETAIL.COL_ID,
                          LRNUTRESULTDETAIL.NUM_VAL,
                          LRNUTRESULTDETAIL.STR_VAL,
                          LRNUTRESULTDETAIL.DATE_VAL,
                          LRNUTRESULTDETAIL.BOOLEAN_VAL,
                          LRNUTRESULTDETAIL.PROPERTY,
                          LRNUTRESULTDETAIL.PROPERTY_REV,
                          LRNUTRESULTDETAIL.ATTRIBUTE,
                          LRNUTRESULTDETAIL.ATTRIBUTE_REV,
                          LRNUTRESULTDETAIL.LAYOUT_ID,
                          LRNUTRESULTDETAIL.LAYOUT_REVISION,
                          LRNUTRESULTDETAIL.DISPLAY_NAME,
                          LRNUTRESULTDETAIL.PART_NO,
                          LRNUTRESULTDETAIL.PART_REVISION,
                          LRNUTRESULTDETAIL.CALC_QTY,
                          LRNUTRESULTDETAIL.NOTE,
                          LRNUTRESULTDETAIL.NOT_AVAILABLE );
         END LOOP;
      END LOOP;

      
      
      
       
      FOR NL IN ( SELECT  *
                     FROM ITNUTLYITEM
                    WHERE LAYOUT_ID = LNLAYOUTID
                      AND REVISION = LNLAYOUTREVISION
                 ORDER BY CALC_SEQ )
      LOOP
         
         
         FOR NE2 IN ( SELECT  ROW_ID,
                              MAX( PROPERTY ) PROPERTY,
                              MAX( PROPERTY_REV ) PROPERTY_REV,
                              MAX( ATTRIBUTE ) ATTRIBUTE,
                              MAX( ATTRIBUTE_REV ) ATTRIBUTE_REV
                         FROM ITNUTEXPLOSION
                        WHERE BOM_EXP_NO = ANUNIQUEID
                          AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
                     GROUP BY ROW_ID
                     ORDER BY ROW_ID )
         LOOP
            LRNUTRESULT := NULL;
            LRNUTRESULT.BOM_EXP_NO := ANUNIQUEID;
            LRNUTRESULT.MOP_SEQUENCE_NO := ANMOPSEQUENCENO;
            LRNUTRESULT.COL_ID := NL.SEQ_NO;
            LRNUTRESULT.ROW_ID := NE2.ROW_ID;
            LRNUTRESULT.PROPERTY := NE2.PROPERTY;
            LRNUTRESULT.PROPERTY_REV := NE2.PROPERTY_REV;
            LRNUTRESULT.ATTRIBUTE := NE2.ATTRIBUTE;
            LRNUTRESULT.ATTRIBUTE_REV := NE2.ATTRIBUTE_REV;
            LRNUTRESULT.LAYOUT_ID := LNLAYOUTID;
            LRNUTRESULT.LAYOUT_REVISION := LNLAYOUTREVISION;
            LRNUTRESULT.DEC_SEP := ASDECSEP;

            IF NL.CALC_METHOD IS NOT NULL
            THEN
               BEGIN
                  LSNUTRESULTCALC :=
                        'BEGIN '
                     || ':lnRetVal := '
                     || NL.CALC_METHOD
                     || '('
                     || ':asNutRefType,'
                     || ':anUniqueId,'
                     || ':anMopSequenceNo,'
                     || ':anRowId,'
                     || ':anLayoutId,'
                     || ':anLayoutRevision,'
                     || ':anColId,'
                     || ':lsCalcValue);'
                     || ' end;';

                  EXECUTE IMMEDIATE LSNUTRESULTCALC
                              USING OUT LNRETVAL,
                                    ASNUTREFTYPE,
                                    ANUNIQUEID,
                                    ANMOPSEQUENCENO,
                                    NE2.ROW_ID,
                                    NL.LAYOUT_ID,
                                    NL.REVISION,
                                    NL.SEQ_NO,
                                    OUT LSCALCVALUE;

                  IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                  THEN
                     IAPIGENERAL.LOGERROR( GSSOURCE,
                                           LSMETHOD,
                                           IAPIGENERAL.GETLASTERRORTEXT( ) );
                     RETURN( LNRETVAL );
                  END IF;

                  
                  
                  
                  
                  
                  IF NL.DATA_TYPE = 0
                  THEN

                    
                     IF (LSCALCVALUE = 'No declaration')
                        OR (LSCALCVALUE = 'Less than 5')
                        OR (LSCALCVALUE = 'Less than 1')
                     THEN
                        LRNUTRESULT.STR_VAL := LSCALCVALUE;
                     ELSE
                        LRNUTRESULT.NUM_VAL := TO_NUMBER( LSCALCVALUE );
                     END IF;


                  ELSIF NL.DATA_TYPE = 1
                  THEN
                     LRNUTRESULT.STR_VAL := LSCALCVALUE;
                  ELSIF NL.DATA_TYPE = 2
                  THEN
                     LRNUTRESULT.DATE_VAL := TO_DATE( LSCALCVALUE,
                                                      'dd-mm-yyyy' );
                  ELSIF NL.DATA_TYPE = 3
                  THEN
                     LRNUTRESULT.BOOLEAN_VAL := TO_NUMBER( LSCALCVALUE );
                  END IF;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     IF SQLCODE = -6550
                     THEN
                        LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_FUNCTIONNOTFOUND,
                                                              NL.CALC_METHOD,
                                                              LSLAYOUTDESCRIPTION );
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
            END IF;

            INSERT INTO ITNUTRESULT
                        ( BOM_EXP_NO,
                          COL_ID,
                          NUM_VAL,
                          STR_VAL,
                          PROPERTY,
                          PROPERTY_REV,
                          ATTRIBUTE,
                          ATTRIBUTE_REV,
                          DATE_VAL,
                          BOOLEAN_VAL,
                          LAYOUT_ID,
                          LAYOUT_REVISION,
                          MOP_SEQUENCE_NO,
                          ROW_ID,
                          DISPLAY_NAME,
                          DEC_SEP )
                 VALUES ( LRNUTRESULT.BOM_EXP_NO,
                          LRNUTRESULT.COL_ID,
                          LRNUTRESULT.NUM_VAL,
                          LRNUTRESULT.STR_VAL,
                          LRNUTRESULT.PROPERTY,
                          LRNUTRESULT.PROPERTY_REV,
                          LRNUTRESULT.ATTRIBUTE,
                          LRNUTRESULT.ATTRIBUTE_REV,
                          LRNUTRESULT.DATE_VAL,
                          LRNUTRESULT.BOOLEAN_VAL,
                          LRNUTRESULT.LAYOUT_ID,
                          LRNUTRESULT.LAYOUT_REVISION,
                          LRNUTRESULT.MOP_SEQUENCE_NO,
                          LRNUTRESULT.ROW_ID,
                          LRNUTRESULT.DISPLAY_NAME,
                          LRNUTRESULT.DEC_SEP );
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
   END CALCULATE;


   FUNCTION GETNUTRESULTDETAIL(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      AQNUTRESULTDETAILS         OUT      IAPITYPE.REF_TYPE,
      
      
      ASDECIMALSEPERATOR         IN       IAPITYPE.DECIMALSEPERATOR_TYPE DEFAULT IAPIGENERAL.GETDBDECIMALSEPERATOR,
      ASTABLENAME                OUT      IAPITYPE.STRING_TYPE)
      
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetNutResultDetail';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQLHEADER                   IAPITYPE.SQLSTRING_TYPE;
      LSSQLFROM                     IAPITYPE.SQLSTRING_TYPE;
      LSSQLWHERE                    IAPITYPE.SQLSTRING_TYPE;
      LSWHEREAND                    IAPITYPE.SQLSTRING_TYPE := ' WHERE ';
      LSSQLALIAST                   IAPITYPE.SQLSTRING_TYPE := 't1';
      LSSQLALIASTT                  IAPITYPE.SQLSTRING_TYPE := 'tt1';
      LSSQLNUTRESULTDETAIL          IAPITYPE.SQLSTRING_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LNMOD                         IAPITYPE.NUMVAL_TYPE;
      LNROWID                       IAPITYPE.NUMVAL_TYPE;
      LNROWIDOLD                    IAPITYPE.NUMVAL_TYPE := 0;
      LTNUTCOL                      IAPITYPE.NUTRESULTDETAILTAB_TYPE;
      LSDBDECIMALSEPERATOR          IAPITYPE.DECIMALSEPERATOR_TYPE DEFAULT IAPIGENERAL.GETDBDECIMALSEPERATOR;
      LSTABLENAME1                  IAPITYPE.STRING_TYPE;
      
      
      
      
      
   BEGIN





      LSSQLNUTRESULTDETAIL :=    'SELECT null FROM DUAL '
                              || 'WHERE 1=2 ';

      
      IF ( AQNUTRESULTDETAILS%ISOPEN )
      THEN
         CLOSE AQNUTRESULTDETAILS;
      END IF;

      OPEN AQNUTRESULTDETAILS FOR TO_CHAR( LSSQLNUTRESULTDETAIL );




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      

      


      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      LNRETVAL := CREATETABLEFROMSQL( LSSQL,
                                      LSTABLENAME1 );

      
      IF (LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS)
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT() );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;
      

     SELECT   COL_ID,
                  'Rowid'
               || ROW_ID
               || 'ColId'
               || COL_ID,
               ROW_ID,
               0,
               DISPLAY_NAME,
               F_PART_DESCR( 0,
                             PART_NO ),
               CALC_QTY,
               TO_CHAR( NOTE ),
               DECODE( NVL( NOT_AVAILABLE,
                            0 ),
                       0, DECODE( SUBSTR( REPLACE( TO_CHAR( NUM_VAL ),
                                                   LSDBDECIMALSEPERATOR,
                                                   ASDECIMALSEPERATOR ),
                                          1,
                                          1 ),
                                  ASDECIMALSEPERATOR, '0'
                                   || REPLACE( TO_CHAR( NUM_VAL ),
                                               LSDBDECIMALSEPERATOR,
                                               ASDECIMALSEPERATOR ),
                                  REPLACE( TO_CHAR( NUM_VAL ),
                                           LSDBDECIMALSEPERATOR,
                                           ASDECIMALSEPERATOR ) ),
                       'NOT AVAILABLE' )
      BULK COLLECT INTO LTNUTCOL
          FROM ITNUTRESULTDETAIL
         WHERE BOM_EXP_NO = ANUNIQUEID
           AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
      ORDER BY ROW_ID,
               COL_ID;

      IF LTNUTCOL.COUNT > 0
      THEN
         FOR I IN LTNUTCOL.FIRST .. LTNUTCOL.LAST
         LOOP
            LSSQL :=
                  'INSERT INTO '
               || LSTABLENAME1
               || '  ( COLID, HEADER, ROW_ID, DATATYPE, DISPLAYNAME, DESCRIPTION, CALCQTY, TEXT, VALUE ) '
               || ' VALUES ( '
               || LTNUTCOL( I ).COLID
               || ' , '
               || ''''
               || LTNUTCOL( I ).HEADER
               || ''''
               || ' , '
               || LTNUTCOL( I ).ROW_ID
               || ' , '
               || LTNUTCOL( I ).DATATYPE
               || ' , '
               || ''''
               || LTNUTCOL( I ).DISPLAYNAME
               || ''''
               || ' , '
               || ''''
               
               
               || REPLACE(LTNUTCOL( I ).DESCRIPTION, '''', '''''')
               
               || ''''
               || ' , '
               || ' to_number( '
               || ''''
               || LTNUTCOL( I ).CALCQTY
               || ''''
               || ' )'
               || ' , '
               || ''''
               || LTNUTCOL( I ).TEXT
               || ''''
               || ' , '
               || ''''
               || LTNUTCOL( I ).VALUE
               || ''''
               || ' ) ';

            EXECUTE IMMEDIATE LSSQL;

            COMMIT;
         END LOOP;
      END IF;

      LSSQLHEADER :=
            'SELECT '
         || LSSQLALIASTT
         || '.row_id '
         || IAPICONSTANTCOLUMN.ROWIDCOL
         || ','
         || LSSQLALIASTT
         || '.DisplayName '
         || IAPICONSTANTCOLUMN.DISPLAYNAMECOL
         || ','
         || LSSQLALIASTT
         || '.description '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ','
         || LSSQLALIASTT
         || '.CalculatedQuantity '
         || IAPICONSTANTCOLUMN.CALCULATEDQUANTITYCOL
         || ','
         || LSSQLALIASTT
         || '.text '
         || IAPICONSTANTCOLUMN.TEXTCOL
         || ' ';
      LSSQLFROM :=
            '      FROM ( SELECT  '
         || LSSQLALIAST
         || '.row_id '
         || IAPICONSTANTCOLUMN.ROWIDCOL
         || ' ,MAX( '
         || LSSQLALIAST
         || '.DisplayName ) '
         || IAPICONSTANTCOLUMN.DISPLAYNAMECOL
         || ' ,MAX( '
         || LSSQLALIAST
         || '.description ) '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ' ,MAX( '
         || LSSQLALIAST
         || '.CalcQty ) '
         || IAPICONSTANTCOLUMN.CALCULATEDQUANTITYCOL
         || ' ,MAX( '
         || LSSQLALIAST
         || '.text ) '
         || IAPICONSTANTCOLUMN.TEXTCOL;

      IF LTNUTCOL.COUNT > 0
      THEN
         FOR I IN LTNUTCOL.FIRST .. LTNUTCOL.LAST
         LOOP
            LNROWID := LTNUTCOL( I ).ROW_ID;

            IF LNROWIDOLD = 0
            THEN
               LNROWIDOLD := LNROWID;
            END IF;

            EXIT WHEN LNROWID <> LNROWIDOLD;
            LNMOD := MOD( I,
                          10 );

            IF LNMOD = 0
            THEN
               LSSQLFROM :=
                     LSSQLFROM
                  || ' FROM '
                  || LSTABLENAME1
                  || ' '
                  || LSSQLALIAST
                  || ' GROUP BY '
                  || LSSQLALIAST
                  || '.row_id '
                  || ' ORDER BY '
                  || LSSQLALIAST
                  || '.row_id ) '
                  || LSSQLALIASTT;
               LSSQLALIAST :=    't'
                              || TO_NUMBER(   FLOOR(   I
                                                     / 10 )
                                            + 1 );
               LSSQLALIASTT :=    't'
                               || LSSQLALIAST;
               LSSQLFROM :=    LSSQLFROM
                            || ', ( SELECT  '
                            || LSSQLALIAST
                            || '.row_id '
                            || IAPICONSTANTCOLUMN.ROWIDCOL;
               LSSQLWHERE :=    LSSQLWHERE
                             || LSWHEREAND
                             || LSSQLALIASTT
                             || '.row_id = tt1.row_id ';
               LSWHEREAND := ' AND ';
            END IF;

            LSSQLHEADER :=    LSSQLHEADER
                           || ','
                           || LSSQLALIASTT
                           || '.'
                           || LTNUTCOL( I ).HEADER;
            LSSQLFROM :=
                  LSSQLFROM
               || ' ,MAX( DECODE( '
               || LSSQLALIAST
               || '.Colid, '
               || LTNUTCOL( I ).COLID
               || ', '
               || LSSQLALIAST
               || '.VALUE ) ) '
               || LTNUTCOL( I ).HEADER
               || ' ';
         END LOOP;

         LSSQLFROM :=
               LSSQLFROM
            || ' '
            || 'FROM '
            || LSTABLENAME1
            || ' '
            || LSSQLALIAST
            || ' GROUP BY '
            || LSSQLALIAST
            || '.row_id '
            || ' ORDER BY '
            || LSSQLALIAST
            || '.row_id ) '
            || LSSQLALIASTT;

         
         IF ( AQNUTRESULTDETAILS%ISOPEN )
         THEN
            CLOSE AQNUTRESULTDETAILS;
         END IF;

         OPEN AQNUTRESULTDETAILS FOR    LSSQLHEADER
                                     || LSSQLFROM
                                     || LSSQLWHERE;
      ELSE
         LSSQLNUTRESULTDETAIL :=    'SELECT null FROM DUAL '
                                 || 'WHERE 1=2 ';

         
         IF ( AQNUTRESULTDETAILS%ISOPEN )
         THEN
            CLOSE AQNUTRESULTDETAILS;
         END IF;

         OPEN AQNUTRESULTDETAILS FOR TO_CHAR( LSSQLNUTRESULTDETAIL );
      END IF;

      
      
      
      
      
      
      
      
      
      
      
      ASTABLENAME := LSTABLENAME1;
      

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQLNUTRESULTDETAIL :=    'SELECT null FROM DUAL '
                                 || 'WHERE 1=2 ';

         
         IF ( AQNUTRESULTDETAILS%ISOPEN )
         THEN
            CLOSE AQNUTRESULTDETAILS;
         END IF;

         OPEN AQNUTRESULTDETAILS FOR TO_CHAR( LSSQLNUTRESULTDETAIL );

      
      
      LNRETVAL := DROPTEMPTABLE( LSTABLENAME1 );
      

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETNUTRESULTDETAIL;


   FUNCTION GETNUTRITIONALLOGS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      AQNUTLOGS                  OUT      IAPITYPE.REF_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE DEFAULT NULL,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE DEFAULT NULL,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE DEFAULT NULL )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetNutritionalLogs';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETCOLUMNSNUTRITIONALLOG( 'n' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'itNutLog n';
      LSFILTER                      IAPITYPE.CLOB_TYPE := NULL;
      
			NROFREV                       NUMBER;
      CURSOR REVISIONCURSOR
       IS
         SELECT REVISION FROM SPECIFICATION_HEADER WHERE PART_NO = ASPARTNO;
      

   BEGIN





      IF ( AQNUTLOGS%ISOPEN )
      THEN
         CLOSE AQNUTLOGS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE n.Log_id = NULL';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQNUTLOGS FOR LSSQLNULL;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM;
      DBMS_SESSION.SET_CONTEXT( 'IACNutLog',
                                'asPartNo',
                                ASPARTNO );
      LSSQL :=    LSSQL
               || ' WHERE part_no = '
               || ' sys_context(''IACNutLog'',''asPartNo'')'

      
               || ' AND ( ' ;

      SELECT COUNT(REVISION) INTO NROFREV FROM SPECIFICATION_HEADER WHERE PART_NO = ASPARTNO;
      FOR ANREVISION IN REVISIONCURSOR
      LOOP
          IF NROFREV <> 0
          THEN
            IF F_CHECK_ACCESS(ASPARTNO,ANREVISION.REVISION) = 1
              THEN
                   NROFREV := NROFREV -1;                                           
                   LSSQL :=    LSSQL
                            || ' revision = '
                            || ANREVISION.REVISION 
                            || ' OR ' ;
                   
            ELSE
                   NROFREV := NROFREV -1; 
            END IF;
          END IF;
      END LOOP;
      LSSQL :=    LSSQL
               || '  1 = 0 ) '; 
      

      
       
       
      

      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      

      IF ASPLANT IS NOT NULL
      THEN
         DBMS_SESSION.SET_CONTEXT( 'IACNutLog',
                                   'asPlant',
                                   ASPLANT );
         LSSQL :=    LSSQL
                  || ' AND Plant = '
                  || ' sys_context(''IACNutLog'',''ASPlant'')';
      END IF;

      IF ANALTERNATIVE IS NOT NULL
      THEN
         DBMS_SESSION.SET_CONTEXT( 'IACNutLog',
                                   'anAlternative',
                                   ANALTERNATIVE );
         LSSQL :=    LSSQL
                  || ' AND Alternative = '
                  || ' sys_context(''IACNutLog'',''ANAlternative'')';
      END IF;

      IF ANUSAGE IS NOT NULL
      THEN
         DBMS_SESSION.SET_CONTEXT( 'IACNutLog',
                                   'anUsage',
                                   ANUSAGE );
         LSSQL :=    LSSQL
                  || ' AND Bom_Usage = '
                  || ' sys_context(''IACNutLog'',''ANUsage'')';
      END IF;

      LSSQL :=    LSSQL
               
               
               || ' ORDER BY n.Explosion_Date DESC, n.Log_Name';
               

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQNUTLOGS%ISOPEN )
      THEN
         CLOSE AQNUTLOGS;
      END IF;

      OPEN AQNUTLOGS FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETNUTRITIONALLOGS;


   FUNCTION ADDNUTRITIONALLOG(
      ASLOGNAME                  IN       IAPITYPE.DESCRIPTION_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANBOMUSAGE                 IN       IAPITYPE.BOMUSAGE_TYPE,
      ADEXPLOSIONDATE            IN       IAPITYPE.DATE_TYPE,
      ANSERVINGSIZEID            IN       IAPITYPE.ID_TYPE,
      ANSERVINGWEIGHT            IN       IAPITYPE.QUANTITY_TYPE,
      ANRESULTWEIGHT             IN       IAPITYPE.QUANTITY_TYPE,
      ASREFSPEC                  IN       IAPITYPE.PARTNO_TYPE,
      ANREFREV                   IN       IAPITYPE.REVISION_TYPE,
      ANLAYOUTID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTREVISION           IN       IAPITYPE.REVISION_TYPE,
      ALLOGGINGXML               IN       IAPITYPE.CLOB_TYPE,
      ASDECSEP                   IN       IAPITYPE.DECIMALSEPERATOR_TYPE DEFAULT IAPIGENERAL.GETDBDECIMALSEPERATOR,
      ANLOGID                    OUT      IAPITYPE.LOGID_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddNutritionalLog';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN








      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ASLOGNAME IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'LogName' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asLogName',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANSTATUS IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Status' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anStatus',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ASPARTNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PartNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asPartNo',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANREVISION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Revision' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRevision',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ASREFSPEC IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'RefSpec' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asRefSpec',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANREFREV IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'RefRev' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRefRev',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANLAYOUTID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'LayoutId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anLayoutId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANLAYOUTREVISION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'LayoutRev' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anLayoutRevision',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ALLOGGINGXML IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'LoggingXml' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'axLoggingXml',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( LNRETVAL );
         END IF;
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      INSERT INTO ITNUTLOG
                  ( LOG_ID,
                    LOG_NAME,
                    STATUS,
                    PART_NO,
                    REVISION,
                    PLANT,
                    ALTERNATIVE,
                    BOM_USAGE,
                    EXPLOSION_DATE,
                    REF_SPEC,
                    REF_REV,
                    LAYOUT_ID,
                    LAYOUT_REV,
                    CREATED_BY,
                    CREATED_ON,
                    LOGGINGXML,
                    SERVING_SIZE_ID,
                    SERVING_WEIGHT,
                    RESULT_WEIGHT,
                    DEC_SEP )
           VALUES ( RDLOG_SEQ.NEXTVAL,
                    ASLOGNAME,
                    ANSTATUS,
                    ASPARTNO,
                    ANREVISION,
                    ASPLANT,
                    ANALTERNATIVE,
                    ANBOMUSAGE,
                    ADEXPLOSIONDATE,
                    ASREFSPEC,
                    ANREFREV,
                    ANLAYOUTID,
                    ANLAYOUTREVISION,
                    USER,
                    SYSDATE,
                    ALLOGGINGXML,
                    ANSERVINGSIZEID,
                    ANSERVINGWEIGHT,
                    ANRESULTWEIGHT,
                    ASDECSEP );

      
      SELECT RDLOG_SEQ.CURRVAL
        INTO ANLOGID
        FROM DUAL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDNUTRITIONALLOG;


   FUNCTION SAVENUTRITIONALLOG(
      ANLOGID                    IN       IAPITYPE.LOGID_TYPE,
      ASLOGNAME                  IN       IAPITYPE.DESCRIPTION_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveNutritionalLog';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN








      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ASLOGNAME IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'LogName' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asLogName',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANSTATUS IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Status' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anStatus',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( LNRETVAL );
         END IF;
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      UPDATE ITNUTLOG
         SET LOG_NAME = ASLOGNAME,
             STATUS = ANSTATUS
       WHERE LOG_ID = ANLOGID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVENUTRITIONALLOG;


   FUNCTION GETNUTRITIONALLOGRESULTS(
      ANLOGID                    IN       IAPITYPE.LOGID_TYPE,
      AQNUTRITIONALLOGRESULTS    OUT      IAPITYPE.REF_TYPE,
      ASDECIMALSEPERATOR         IN       IAPITYPE.DECIMALSEPERATOR_TYPE DEFAULT IAPIGENERAL.GETDBDECIMALSEPERATOR )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetNutritionalLogResults';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LTNUTCOL                      IAPITYPE.NUTCOLTAB_TYPE;
      LSDBDECIMALSEPERATOR          IAPITYPE.DECIMALSEPERATOR_TYPE DEFAULT IAPIGENERAL.GETDBDECIMALSEPERATOR;
   BEGIN





      IF ( AQNUTRITIONALLOGRESULTS%ISOPEN )
      THEN
         CLOSE AQNUTRITIONALLOGRESULTS;
      END IF;

      LSSQL :=    'SELECT null FROM DUAL '
               || 'WHERE 1=2 ';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQNUTRITIONALLOGRESULTS FOR LSSQL;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      SELECT DISTINCT COL_ID,
                         'ColId'
                      || COL_ID,
                      0
      BULK COLLECT INTO LTNUTCOL
                 FROM ITNUTLOGRESULT
                WHERE LOG_ID = ANLOGID
             ORDER BY COL_ID;

      LSSQL :=
            'select row_id '
         || IAPICONSTANTCOLUMN.ROWIDCOL
         || ',max(Property) '
         || IAPICONSTANTCOLUMN.PROPERTYIDCOL
         || ',max(Property_rev) '
         || IAPICONSTANTCOLUMN.PROPERTYREVISIONCOL
         || ',max(f_sph_descr( 1,Property,Property_rev )) '
         || IAPICONSTANTCOLUMN.PROPERTYCOL
         || ',max(Attribute) '
         || IAPICONSTANTCOLUMN.ATTRIBUTEIDCOL
         || ',max(Attribute_rev) '
         || IAPICONSTANTCOLUMN.ATTRIBUTEREVISIONCOL
         || ',max(f_ath_descr( 1,Attribute,Attribute_rev )) '
         || IAPICONSTANTCOLUMN.ATTRIBUTECOL
         || ' ';

      IF LTNUTCOL.COUNT > 0
      THEN
         FOR I IN LTNUTCOL.FIRST .. LTNUTCOL.LAST
         LOOP
            LSSQL :=
                  LSSQL
               || ', F_Get_NutLogResult_Value( '
               || ANLOGID
               || ' , row_id '
               || ' , '
               || I
               || ' , '
               || ''''
               || ASDECIMALSEPERATOR
               || ''''
               || ' ) '
               || SUBSTR( LTNUTCOL( I ).HEADER,
                          1,
                          30 );
         END LOOP;
      END IF;

      LSSQL :=    LSSQL
               || ' FROM itNutLogResult '
               || ' WHERE Log_id = :anLogId '
               || ' GROUP BY row_ID '
               || ' ORDER BY row_ID ';

      
      IF ( AQNUTRITIONALLOGRESULTS%ISOPEN )
      THEN
         CLOSE AQNUTRITIONALLOGRESULTS;
      END IF;

      OPEN AQNUTRITIONALLOGRESULTS FOR LSSQL USING ANLOGID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF ( AQNUTRITIONALLOGRESULTS%ISOPEN )
         THEN
            CLOSE AQNUTRITIONALLOGRESULTS;
         END IF;

         LSSQL :=    'SELECT null FROM DUAL '
                  || 'WHERE 1=2 ';
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              LSSQL,
                              IAPICONSTANT.INFOLEVEL_3 );

         OPEN AQNUTRITIONALLOGRESULTS FOR LSSQL;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETNUTRITIONALLOGRESULTS;


   FUNCTION GETNUTRITIONALLOGRESULTS_CS(
      ANLOGID                    IN       IAPITYPE.LOGID_TYPE,
      AQNUTLOGRESULT             OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetNutritionalLogResults_cs';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETCOLUMNSNUTLOGRESULT( 'nlr' );
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := 'itNutLogResult nlr';
      LSDBDECIMALSEPERATOR          IAPITYPE.DECIMALSEPERATOR_TYPE DEFAULT IAPIGENERAL.GETDBDECIMALSEPERATOR;
      ASDECIMALSEPERATOR            IAPITYPE.DECIMALSEPERATOR_TYPE := ',';
   BEGIN





      IF ( AQNUTLOGRESULT%ISOPEN )
      THEN
         CLOSE AQNUTLOGRESULT;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE nlr.Log_id = NULL';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQNUTLOGRESULT FOR LSSQLNULL;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM
               || ' WHERE nlr.Log_id = :LogId';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQNUTLOGRESULT%ISOPEN )
      THEN
         CLOSE AQNUTLOGRESULT;
      END IF;

      OPEN AQNUTLOGRESULT FOR LSSQL USING ANLOGID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETNUTRITIONALLOGRESULTS_CS;


   FUNCTION ADDNUTITIONALLOGRESULT(
      ANLOGID                    IN       IAPITYPE.ID_TYPE,
      ANCOLID                    IN       IAPITYPE.ID_TYPE,
      ANROWID                    IN       IAPITYPE.ID_TYPE,
      ALVALUE                    IN       IAPITYPE.CLOB_TYPE,
      ANPROPERTY                 IN       IAPITYPE.ID_TYPE,
      ANPROPERTYREVISION         IN       IAPITYPE.REVISION_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTEREVISION        IN       IAPITYPE.REVISION_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddNutitionalLogResult';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN








      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ANLOGID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'LogId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anLogId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANCOLID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'ColId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anColId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANROWID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'RowId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRowId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANPROPERTY IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Property' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anProperty',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANPROPERTYREVISION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'PropertyRevision' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anPropertyRevision',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANATTRIBUTEID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Attribute' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anAttributeId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANATTRIBUTEREVISION IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'AttributeRevision' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anAttributeRevision',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( LNRETVAL );
         END IF;
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      BEGIN
         INSERT INTO ITNUTLOGRESULT
                     ( LOG_ID,
                       COL_ID,
                       ROW_ID,
                       VALUE,
                       PROPERTY,
                       PROPERTY_REV,
                       ATTRIBUTE,
                       ATTRIBUTE_REV )
              VALUES ( ANLOGID,
                       ANCOLID,
                       ANROWID,
                       ALVALUE,
                       ANPROPERTY,
                       ANPROPERTYREVISION,
                       ANATTRIBUTEID,
                       ANATTRIBUTEREVISION );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_NUTLOGRESALREADYEXISTS,
                                                        ANLOGID,
                                                        ANPROPERTY,
                                                        ANATTRIBUTEID ) );
      END;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDNUTITIONALLOGRESULT;


   FUNCTION GETNUTLOGRESULTDETAILS(
      ANLOGID                    IN       IAPITYPE.ID_TYPE,
      AQNUTLOGRESULTDETAILS      OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetNutLogResultDetails';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETCOLSNUTLOGRESULTDETAIL( 'nlrd' );
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := 'itNutLogResultDetails nlrd';
   BEGIN





      IF ( AQNUTLOGRESULTDETAILS%ISOPEN )
      THEN
         CLOSE AQNUTLOGRESULTDETAILS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE nlrd.Log_id = NULL';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQNUTLOGRESULTDETAILS FOR LSSQLNULL;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM
               || ' WHERE nlrd.Log_id = :LogId';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQNUTLOGRESULTDETAILS%ISOPEN )
      THEN
         CLOSE AQNUTLOGRESULTDETAILS;
      END IF;

      OPEN AQNUTLOGRESULTDETAILS FOR LSSQL USING ANLOGID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETNUTLOGRESULTDETAILS;


   FUNCTION ADDNUTLOGRESULTDETAILS(
      ANLOGID                    IN       IAPITYPE.ID_TYPE,
      ANCOLID                    IN       IAPITYPE.ID_TYPE,
      ANROWID                    IN       IAPITYPE.ID_TYPE,
      ANSEQNO                    IN       IAPITYPE.ID_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASDISPLAYNAME              IN       IAPITYPE.DESCRIPTION_TYPE,
      ALVALUE                    IN       IAPITYPE.CLOB_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddNutLogResultDetails';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN








      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ANLOGID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'LogId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anLogId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANCOLID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'ColId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anColId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANROWID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'RowId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anRowId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANSEQNO IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SeqNo' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSeqNo',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ASDISPLAYNAME IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'DisplayName' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asDisplayName',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      IF ( GTERRORS.COUNT > 0 )
      THEN
         
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( LNRETVAL );
         END IF;
      END IF;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      BEGIN
         INSERT INTO ITNUTLOGRESULTDETAILS
                     ( LOG_ID,
                       COL_ID,
                       ROW_ID,
                       SEQ_NO,
                       PART_NO,
                       REVISION,
                       DISPLAY_NAME,
                       VALUE )
              VALUES ( ANLOGID,
                       ANCOLID,
                       ANROWID,
                       ANSEQNO,
                       ASPARTNO,
                       ANREVISION,
                       ASDISPLAYNAME,
                       ALVALUE );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_NUTLOGRESDETALREADYEXIST,
                                                        ANLOGID,
                                                        ANCOLID,
                                                        ANROWID,
                                                        ANSEQNO ) );
      END;




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
   END ADDNUTLOGRESULTDETAILS;


   FUNCTION ADDNUTRITIONALPANEL(
      ANBOMEXPNO                 IN       IAPITYPE.ID_TYPE,
      ANMOPSEQNO                 IN       IAPITYPE.ID_TYPE,
      ASLOGNAME                  IN       IAPITYPE.DESCRIPTION_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANBOMUSAGE                 IN       IAPITYPE.BOMUSAGE_TYPE,
      ADEXPLOSIONDATE            IN       IAPITYPE.DATE_TYPE,
      ANSERVINGSIZEID            IN       IAPITYPE.ID_TYPE,
      ANSERVINGWEIGHT            IN       IAPITYPE.QUANTITY_TYPE,
      ANRESULTWEIGHT             IN       IAPITYPE.QUANTITY_TYPE,
      ASREFSPEC                  IN       IAPITYPE.PARTNO_TYPE,
      ANREFREV                   IN       IAPITYPE.REVISION_TYPE,
      ANLAYOUTID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANLAYOUTREVISION           IN       IAPITYPE.REVISION_TYPE,
      ALLOGGINGXML               IN       IAPITYPE.CLOB_TYPE,
      ASDECSEP                   IN       IAPITYPE.DECIMALSEPERATOR_TYPE DEFAULT IAPIGENERAL.GETDBDECIMALSEPERATOR,
      ANLOGID                    OUT      IAPITYPE.LOGID_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      CURSOR LQNUTRESULT
      IS
         SELECT *
           FROM ITNUTRESULT
          WHERE BOM_EXP_NO = ANBOMEXPNO
            AND MOP_SEQUENCE_NO = ANMOPSEQNO;

      CURSOR LQNUTRESULTDETAIL
      IS
         SELECT *
           FROM ITNUTRESULTDETAIL
          WHERE BOM_EXP_NO = ANBOMEXPNO
            AND MOP_SEQUENCE_NO = ANMOPSEQNO;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddNutritionalPanel';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNLOGID                       IAPITYPE.ID_TYPE;
   BEGIN








      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      
      LNRETVAL :=
         IAPINUTRITIONALCALCULATION.ADDNUTRITIONALLOG( ASLOGNAME,
                                                       ANSTATUS,
                                                       ASPARTNO,
                                                       ANREVISION,
                                                       ASPLANT,
                                                       ANALTERNATIVE,
                                                       ANBOMUSAGE,
                                                       ADEXPLOSIONDATE,
                                                       ANSERVINGSIZEID,
                                                       ANSERVINGWEIGHT,
                                                       ANRESULTWEIGHT,
                                                       ASREFSPEC,
                                                       ANREFREV,
                                                       ANLAYOUTID,
                                                       ANLAYOUTREVISION,
                                                       ALLOGGINGXML,
                                                       ASDECSEP,
                                                       LNLOGID,
                                                       AQERRORS );

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

      ANLOGID := LNLOGID;

      
      FOR LRNUTRESULT IN LQNUTRESULT
      LOOP
         LNRETVAL :=
            IAPINUTRITIONALCALCULATION.ADDNUTITIONALLOGRESULT( LNLOGID,
                                                               LRNUTRESULT.COL_ID,
                                                               LRNUTRESULT.ROW_ID,
                                                               NVL( LRNUTRESULT.STR_VAL,
                                                                    TO_CHAR( LRNUTRESULT.NUM_VAL ) ),
                                                               LRNUTRESULT.PROPERTY,
                                                               LRNUTRESULT.PROPERTY_REV,
                                                               LRNUTRESULT.ATTRIBUTE,
                                                               LRNUTRESULT.ATTRIBUTE_REV,
                                                               AQERRORS );

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
      END LOOP;

      
      FOR LRNUTRESULTDETAIL IN LQNUTRESULTDETAIL
      LOOP
         LNRETVAL :=
            IAPINUTRITIONALCALCULATION.ADDNUTLOGRESULTDETAILS( LNLOGID,
                                                               LRNUTRESULTDETAIL.COL_ID,
                                                               LRNUTRESULTDETAIL.ROW_ID,
                                                               LRNUTRESULTDETAIL.MOP_SEQUENCE_NO,
                                                               LRNUTRESULTDETAIL.PART_NO,
                                                               LRNUTRESULTDETAIL.PART_REVISION,
                                                               LRNUTRESULTDETAIL.DISPLAY_NAME,
                                                               LRNUTRESULTDETAIL.STR_VAL,
                                                               AQERRORS );

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
      END LOOP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDNUTRITIONALPANEL;


   FUNCTION GETNUTBASICCONVERSTIONFACTOR(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASNUTREFTYPE               IN       IAPITYPE.NUTREFTYPE_TYPE )
      RETURN IAPITYPE.FLOAT_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetNutBasicConverstionFactor';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRNUTREFTYPE                  IAPITYPE.NUTREFROWTYPE_TYPE;
      AFCONVERSTIONFACTOR           IAPITYPE.FLOAT_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      

      


      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT *
        INTO LRNUTREFTYPE
        FROM ITNUTREFTYPE
       WHERE REF_TYPE = ASNUTREFTYPE;

      
      IF (LRNUTREFTYPE.BASIC_WEIGHT_PROPERTY_GROUP IS NULL
          AND LRNUTREFTYPE.BASIC_WEIGHT_PROPERTY IS NULL)
      THEN
            RETURN 1;
      END IF;
      

      LSSQL :=
            'SELECT   100/ NVL( num_'
         || LRNUTREFTYPE.BASIC_WEIGHT_VALUE_COL
         || ',100 ) '
         || ' FROM SPECIFICATION_PROP '
         || ' WHERE part_no = :asPartNo '
         || ' AND Revision = :anRevision '
         || ' AND Property_GROUP = :BASIC_Weight_Property_GROUP '
         || ' AND Property = :BASIC_Weight_Property ';

      EXECUTE IMMEDIATE LSSQL
                   INTO AFCONVERSTIONFACTOR
                  USING ASPARTNO,
                        ANREVISION,
                        LRNUTREFTYPE.BASIC_WEIGHT_PROPERTY_GROUP,
                        LRNUTREFTYPE.BASIC_WEIGHT_PROPERTY;

      RETURN NVL( AFCONVERSTIONFACTOR,
                  1 );
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 1;
   END GETNUTBASICCONVERSTIONFACTOR;


   FUNCTION ISBASEDONPARTLYEMPTYFIELDS(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANMOPSEQUENCENO            IN       IAPITYPE.SEQUENCE_TYPE,
      ANPARTLYEMPTYFIELDS        OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS











      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsBasedOnPartlyEmptyFields';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNRDCHECKTYPE                 IAPITYPE.NUMVAL_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT TO_NUMBER( PARAMETER_DATA )
        INTO LNRDCHECKTYPE
        FROM INTERSPC_CFG
       WHERE SECTION = 'interspec'
         AND PARAMETER = 'RD_Check_Type';

      CASE LNRDCHECKTYPE
         WHEN 0
         THEN
            SELECT DECODE( COUNT( * ),
                           0, 0,
                           1 )
              INTO ANPARTLYEMPTYFIELDS
              FROM ITNUTRESULTDETAIL
             WHERE BOM_EXP_NO = ANUNIQUEID
               AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
               AND NOT_AVAILABLE = 0
               AND NUM_VAL IS NULL;
         WHEN 1
         THEN
            SELECT DECODE( COUNT( * ),
                           0, 0,
                           1 )
              INTO ANPARTLYEMPTYFIELDS
              FROM ITNUTRESULTDETAIL
             WHERE BOM_EXP_NO = ANUNIQUEID
               AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
               AND NUM_VAL IS NULL;
         ELSE
            NULL;
      END CASE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ISBASEDONPARTLYEMPTYFIELDS;
END IAPINUTRITIONALCALCULATION;
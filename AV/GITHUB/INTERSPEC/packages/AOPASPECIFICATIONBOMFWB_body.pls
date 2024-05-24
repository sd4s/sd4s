CREATE OR REPLACE PACKAGE BODY aopaSpecificationBomFWB
AS



   
   
   
   
   
   
   
   
   


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

         || ' FROM rndtfwbbomexplosion B, CLASS3 C'
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
                               FROM RNDTFWBBOMEXPLOSION
                              WHERE BOM_EXP_NO = LNBOMEXPNO
                                AND INGREDIENT <> 2
                                AND AOPASPECIFICATIONBOMFWB.IS_LOWESTLEVEL( BOM_EXP_NO,
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
                               FROM RNDTFWBBOMEXPLOSION
                              WHERE BOM_EXP_NO = LNBOMEXPNO
                                AND INGREDIENT <> 2
                                AND AOPASPECIFICATIONBOMFWB.IS_LOWESTLEVEL( BOM_EXP_NO,
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
           FROM RNDTFWBBOMEXPLOSION
          WHERE BOM_EXP_NO = CNBOMEXPNO
            AND UOM = CSUOM
            AND SEQUENCE_NO IN( SELECT ROUND( SEQUENCE_NO,
                                              0 )
                                 FROM RNDTFWBBOMEXPLOSION
                                WHERE BOM_EXP_NO = CNBOMEXPNO
                                  AND INGREDIENT <> 2
                                  AND AOPASPECIFICATIONBOMFWB.IS_LOWESTLEVEL( BOM_EXP_NO,
                                                        MOP_SEQUENCE_NO,
                                                        SEQUENCE_NO ) = 1 );

      LSUOM                         RNDTFWBBOMEXPLOSION.UOM%TYPE := NULL;
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
           FROM RNDTFWBBOMEXPLOSION
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

  FUNCTION IS_LOWESTLEVEL(
   ANBOMEXPNO             IN             IAPITYPE.NUMVAL_TYPE,
   ANMOPSEQUENCENO        IN             IAPITYPE.SEQUENCE_TYPE,
   ANSEQUENCE              IN            IAPITYPE.SEQUENCE_TYPE )
   RETURN IAPITYPE.BOOLEAN_TYPE
IS
   LNHIGHERNODE                  IAPITYPE.BOOLEAN_TYPE := 0;
   LNBOMLEVEL1                   IAPITYPE.BOMLEVEL_TYPE;
   LNBOMLEVEL2                   IAPITYPE.BOMLEVEL_TYPE;
BEGIN
   SELECT BOM_LEVEL
     INTO LNBOMLEVEL1
     FROM RNDTFWBBOMEXPLOSION
    WHERE BOM_EXP_NO = ANBOMEXPNO
      AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
      AND SEQUENCE_NO =   ANSEQUENCE
                        + 10;

   SELECT BOM_LEVEL
     INTO LNBOMLEVEL2
     FROM RNDTFWBBOMEXPLOSION
    WHERE BOM_EXP_NO = ANBOMEXPNO
      AND MOP_SEQUENCE_NO = ANMOPSEQUENCENO
      AND SEQUENCE_NO = ANSEQUENCE;

   SELECT NVL(  (    ( LNBOMLEVEL1 )
                  - ( LNBOMLEVEL2 ) ),
               0 )
     INTO LNHIGHERNODE
     FROM DUAL;

   IF LNHIGHERNODE > 0
   THEN
      RETURN 0;
   ELSE
      RETURN 1;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN 1;
END IS_LOWESTLEVEL;

 FUNCTION GETINGREDIENTS(
      AREQID                 IN       IAPITYPE.SEQUENCE_TYPE,
      APARTNO                 IN       IAPITYPE.PARTNO_TYPE,
      AREVISION                 IN       IAPITYPE.REVISION_TYPE,
      INGREDIENTS                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetIngredients';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNACCESS                      IAPITYPE.BOOLEAN_TYPE;
      LSSQL                         VARCHAR2( 8192 );
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=
        ' SELECT F.INGREDIENT, '
                  ||' F.QUANTITY, '
                  ||' F.SEQUENCE, '
                  ||' F.HIERARCHICALLEVEL, '
                  ||' F.PARENTSEQUENCE, '
                  ||' F.RECONSTITUTIONFACTOR, '
                  ||'F.STANDARDOFIDENTITY, '
                  ||' F.ALLERGENID, '
                  ||' F.ALLERGEN, '
                  ||' F.DESCRIPTION, '
                  ||' F.SYNONYMNAME, '
                  ||' F.DECLAREFLAG, '
                  ||' F.ORIGINALINGREDIENT, '
                   ||'F.ORIGINALINGREDIENTDESC, '
                   ||'F.RECONSTITUTIONINGREDIENT, '
                  ||' F.RECONSTITUTIONINGREDDESC, '
                  ||' F.ACTIVEINGREDIENT '
        ||'FROM   rndtfwbingredientsnew F '
        ||'WHERE  F.REQ_ID = :aReqId '
               ||'AND F.PARTNO = :aPartNo '
               ||'AND F.REVISION = :aRevision '
        ||'ORDER  BY F.SEQUENCE';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL );

      OPEN INGREDIENTS FOR LSSQL USING AREQID, APARTNO, AREVISION;

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETINGREDIENTS;


   

   FUNCTION GETINGREDIENTLIST(
      ANUNIQUEID                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANSYNONYMTYPE              IN       IAPITYPE.ID_TYPE,
      AQITEMS                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetIngredientList';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=  'partno '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', ing1.ingredient '
            || IAPICONSTANTCOLUMN.INGREDIENTCOL
            || ', ing1.quantity '
            || IAPICONSTANTCOLUMN.QUANTITYCOL
            || ', ing1.sequence '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ', ing1.hierarchicallevel '
            || IAPICONSTANTCOLUMN.HIERARCHICALLEVELCOL
            || ', ing1.parentsequence '
            || IAPICONSTANTCOLUMN.PARENTSEQUENCECOL
            || ', ing1.reconstitutionfactor '
            || IAPICONSTANTCOLUMN.RECONSTITUTIONFACTORCOL
            || ', decode(ing3.soi,''Y'',1,0) '
            || IAPICONSTANTCOLUMN.STANDARDOFIDENTITYCOL
            || ', nvl(ing3.allergen,0) '
            || IAPICONSTANTCOLUMN.ALLERGENIDCOL
            || ', nvl(f_ingcfg_descr(1, 7, ing3.allergen, 0),'''') '
            || IAPICONSTANTCOLUMN.ALLERGENCOL
            || ', f_ing_descr(1, ing1.ingredient, 0) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', f_ing_syn( 1, :ansynonymtype, ing1.ingredient, NULL) '
            || IAPICONSTANTCOLUMN.SYNONYMNAMECOL
            || ', ing1.declareflag '
            || IAPICONSTANTCOLUMN.DECLARECOL
            || ', nvl(ing3.org_ing,0) '
            || IAPICONSTANTCOLUMN.ORIGINALINGREDIENTCOL
            || ', nvl(f_ing_descr(1, ing3.org_ing, 0),'''') '
            || IAPICONSTANTCOLUMN.ORIGINALINGREDIENTDESCCOL
            || ', nvl(ing3.rec_ing,0) '
            || IAPICONSTANTCOLUMN.RECONSTITUTIONINGREDIENTCOL
            || ', nvl(f_ing_descr(1, ing3.rec_ing, 0),'''') '
            || IAPICONSTANTCOLUMN.RECONSTITUTIONINGREDDESCCOL
            || ', ACTIVEINGREDIENT '
            || IAPICONSTANTCOLUMN.ACTIVEINGREDIENTCOL
            
            || ', aopaspecificationbomfwb.getingredientcomment(ing1.partno,
                                                          ing1.revision,
                                                          ing1.ingredient,
                                                          ing1.hierarchicallevel) as INGREDIENTCOMMENT';
            
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM RNDTFWBINGREDIENTSNEW ing1 ,iting ing3 ';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE
                                       :=    ' WHERE ing1.ingredient = ing3.ingredient '
                                          || ' AND req_id = :anUniqueId '
                                          || ' AND (partno, revision) IN '
                                          || '    (SELECT component_part, component_revision '
                                          || '       FROM RNDTFWBBOMEXPLOSION B, CLASS3 C '
                                          || '       WHERE B.BOM_EXP_NO = :anUniqueId '
                                          || '       AND C.CLASS = B.PART_TYPE )';

      LSORDERBY                     IAPITYPE.SQLSTRING_TYPE := ' ORDER BY partno, revision, sequence ';
   BEGIN
      
      
      
      
      
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || ' AND 1=2 ';

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      IF AQITEMS%ISOPEN
      THEN
         CLOSE AQITEMS;
      END IF;

      OPEN AQITEMS FOR LSSQL USING ANSYNONYMTYPE,
                                              ANUNIQUEID,
                                                    ANUNIQUEID;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      LSSQL :=    'SELECT DISTINCT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || LSORDERBY;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      IF AQITEMS%ISOPEN
      THEN
         CLOSE AQITEMS;
      END IF;

      OPEN AQITEMS FOR LSSQL USING ANSYNONYMTYPE,
                                              ANUNIQUEID,
                                                    ANUNIQUEID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'SELECT '
                  || LSSELECT
                  || LSFROM
                  || LSWHERE
                  || ' AND 1=2 ';

         OPEN AQITEMS FOR LSSQL USING ANSYNONYMTYPE,
                                                       ANUNIQUEID,
                                                       ANUNIQUEID;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETINGREDIENTLIST;
   



   FUNCTION GETINGREDIENTCOMMENT(
      ASPARTNO                     IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                   IN       IAPITYPE.REVISION_TYPE,
      ANINGREDIENT                 IN       IAPITYPE.INGREDIENT_TYPE,
      ASHIERLEVEL                  IN       IAPITYPE.HIERLEVEL_TYPE)
      RETURN IAPITYPE.INGREDIENTCOMMENT_TYPE
   IS
      
      
      
      
      
      
      
      
      
   LN_INGREDIENTCOMMENT IAPITYPE.INGREDIENTCOMMENT_TYPE;
   LN_SEQ_SPCING        IAPITYPE.SEQUENCENR_TYPE;
   LN_SEQ_RNDING        IAPITYPE.SEQUENCENR_TYPE;
   LN_SPCING_TREE        NVARCHAR2(4000);
   LN_RNDING_TREE        NVARCHAR2(4000);
	 
	 LN_CURSORSEQING         IAPITYPE.REF_TYPE;
	 LN_CURSORSEQ_RNDING     IAPITYPE.REF_TYPE;
	 
   
   BEGIN
     IF ASPARTNO IS NULL
       OR ANREVISION IS NULL
          OR ANINGREDIENT IS NULL
     THEN
       RETURN '';
     ELSE











      IF LN_CURSORSEQING%ISOPEN
      THEN
         CLOSE LN_CURSORSEQING;
      END IF;
			
      OPEN LN_CURSORSEQING FOR 
			     SELECT SI.SEQ_NO
					 FROM SPECIFICATION_ING SI
					 WHERE
										SI.PART_NO = ASPARTNO
								AND SI.REVISION = ANREVISION
								AND SI.INGREDIENT = ANINGREDIENT
								AND SI.HIER_LEVEL = ASHIERLEVEL;












      IF LN_CURSORSEQ_RNDING%ISOPEN
      THEN
         CLOSE LN_CURSORSEQ_RNDING;
      END IF;
			
      OPEN LN_CURSORSEQ_RNDING FOR
			   SELECT SI.SEQUENCE
         FROM RNDTFWBINGREDIENTSNEW SI
         WHERE
                  SI.PARTNO = ASPARTNO
              AND SI.REVISION = ANREVISION
              AND SI.INGREDIENT = ANINGREDIENT
              AND SI.HIERARCHICALLEVEL = ASHIERLEVEL
              AND SI.REQ_ID = (SELECT MAX(RNDI.REQ_ID)
                            FROM RNDTFWBINGREDIENTSNEW RNDI);

			 FETCH LN_CURSORSEQING INTO LN_SEQ_SPCING;
			 FETCH LN_CURSORSEQ_RNDING INTO LN_SEQ_RNDING;

				 
				                 
       LN_SPCING_TREE := AOPASPECIFICATIONBOMFWB.GETPIDLISTIS(ASPARTNO,ANREVISION,LN_SEQ_SPCING);
       
       LN_RNDING_TREE := AOPASPECIFICATIONBOMFWB.GETPIDLISTFWB(ASPARTNO,ANREVISION,LN_SEQ_RNDING);                      
       
       IF (LN_SPCING_TREE = LN_RNDING_TREE)
          THEN
            BEGIN                            
               SELECT ING_COMMENT INTO LN_INGREDIENTCOMMENT
               FROM SPECIFICATION_ING SI
               WHERE
                        SI.PART_NO = ASPARTNO
                    AND SI.REVISION = ANREVISION
                    AND SI.INGREDIENT = ANINGREDIENT
                    AND SI.HIER_LEVEL = ASHIERLEVEL
                    AND SI.SEQ_NO = LN_SEQ_SPCING;
            END;
       END IF;

       IF  LN_INGREDIENTCOMMENT IS NULL
         THEN
           RETURN '';
       ELSE
         RETURN LN_INGREDIENTCOMMENT;
       END IF;

       CLOSE LN_CURSORSEQING;
			 CLOSE LN_CURSORSEQ_RNDING;

    END IF;
   END GETINGREDIENTCOMMENT;



  FUNCTION GETPIDLISTIS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSEQUENCE                 IN       IAPITYPE.SEQUENCE_TYPE )
      RETURN VARCHAR2
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPidList';
      LSPIDLIST                     VARCHAR2( 2048 ) := NULL;
      LNLASTLEVEL                   NUMBER := -1;

      CURSOR LQTREE(
         ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
         ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
         ANSEQUENCE                 IN       IAPITYPE.SEQUENCE_TYPE )
      IS
         SELECT   *
             FROM SPECIFICATION_ING I
            WHERE I.PART_NO = ASPARTNO
              AND I.REVISION = ANREVISION
              AND I.SEQ_NO <= ANSEQUENCE
         ORDER BY I.SEQ_NO DESC;
   BEGIN
      FOR RINGREDIENT IN LQTREE( ASPARTNO,
                                 ANREVISION,
                                 ANSEQUENCE )
      LOOP
         IF ( RINGREDIENT.HIER_LEVEL = 1 )
         THEN
            IF ( LSPIDLIST IS NULL )
            THEN
               LSPIDLIST :=    RINGREDIENT.INGREDIENT
                            || '|'
                            || RINGREDIENT.PID;
            ELSE
               LSPIDLIST :=    LSPIDLIST
                            || '|'
                            || RINGREDIENT.PID;
            END IF;

            EXIT;
         ELSE
            IF (     ( RINGREDIENT.HIER_LEVEL < LNLASTLEVEL )
                 OR ( LNLASTLEVEL = -1 ) )
            THEN
               LNLASTLEVEL := RINGREDIENT.HIER_LEVEL;

               IF ( LSPIDLIST IS NULL )
               THEN
                  LSPIDLIST :=    RINGREDIENT.INGREDIENT
                               || '|'
                               || RINGREDIENT.PID;
               ELSE
                  LSPIDLIST :=    LSPIDLIST
                               || '|'
                               || RINGREDIENT.PID;
               END IF;
            END IF;
         END IF;
      END LOOP;

      RETURN LSPIDLIST;
   END GETPIDLISTIS;
   


  FUNCTION GETPIDLISTFWB(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSEQUENCE                 IN       IAPITYPE.SEQUENCE_TYPE )
      RETURN VARCHAR2
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPidList';
      LSPIDLIST                     VARCHAR2( 2048 ) := NULL;
      LNLASTLEVEL                   NUMBER := -1;

      CURSOR LQTREE(
         ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
         ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
         ANSEQUENCE                 IN       IAPITYPE.SEQUENCE_TYPE )
      IS
         SELECT   *
             FROM RNDTFWBINGREDIENTSNEW I
            WHERE I.PARTNO = ASPARTNO
              AND I.REVISION = ANREVISION
              AND I.SEQUENCE <= ANSEQUENCE
              AND I.REQ_ID = (SELECT MAX(I.REQ_ID) 
                                FROM RNDTFWBINGREDIENTSNEW I
                                WHERE I.PARTNO = ASPARTNO
                                  AND I.REVISION = ANREVISION) 
         ORDER BY I.SEQUENCE DESC;
   BEGIN
      FOR RINGREDIENT IN LQTREE( ASPARTNO,
                                 ANREVISION,
                                 ANSEQUENCE )
      LOOP
         IF ( RINGREDIENT.HIERARCHICALLEVEL = 1 )
         THEN
            IF ( LSPIDLIST IS NULL )
            THEN
               LSPIDLIST :=    RINGREDIENT.INGREDIENT
                            || '|'
                            || GETPIDINGREDIENTFWB(RINGREDIENT.PARTNO,RINGREDIENT.REVISION,RINGREDIENT.PARENTSEQUENCE,
                                                   RINGREDIENT.REQ_ID);
            ELSE
               LSPIDLIST :=    LSPIDLIST
                            || '|'
                            || GETPIDINGREDIENTFWB(RINGREDIENT.PARTNO,RINGREDIENT.REVISION,RINGREDIENT.PARENTSEQUENCE,
                                                   RINGREDIENT.REQ_ID);
            END IF;
            EXIT;
         ELSE
            IF (     ( RINGREDIENT.HIERARCHICALLEVEL < LNLASTLEVEL )
                 OR ( LNLASTLEVEL = -1 ) )
            THEN
               LNLASTLEVEL := RINGREDIENT.HIERARCHICALLEVEL;

               IF ( LSPIDLIST IS NULL )
               THEN
                  LSPIDLIST :=    RINGREDIENT.INGREDIENT
                               || '|'
                            || GETPIDINGREDIENTFWB(RINGREDIENT.PARTNO,RINGREDIENT.REVISION,RINGREDIENT.PARENTSEQUENCE,
                                                   RINGREDIENT.REQ_ID);
               ELSE
                  LSPIDLIST :=    LSPIDLIST
                               || '|'
                            || GETPIDINGREDIENTFWB(RINGREDIENT.PARTNO,RINGREDIENT.REVISION,RINGREDIENT.PARENTSEQUENCE,
                                                   RINGREDIENT.REQ_ID);
               END IF;
            END IF;
         END IF;
      END LOOP;

      RETURN LSPIDLIST;
   END GETPIDLISTFWB;  



  FUNCTION GETPIDINGREDIENTFWB(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANPARENTSEQUENCE                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANREQ_ID                         IN       IAPITYPE.REQID_TYPE )
      RETURN IAPITYPE.INGREDIENT_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LNPARENT                  IAPITYPE.INGREDIENT_TYPE;

   BEGIN

     IF ASPARTNO IS NULL
       OR ANREVISION IS NULL
         OR ANPARENTSEQUENCE IS NULL
            OR ANREQ_ID IS NULL
     THEN
       RETURN 1;
     ELSE
        IF ANPARENTSEQUENCE <> 0
          THEN                     
                SELECT I.INGREDIENT INTO LNPARENT FROM RNDTFWBINGREDIENTSNEW I
                WHERE I.PARTNO = ASPARTNO
                      AND I.REVISION = ANREVISION
                      AND I.SEQUENCE = ANPARENTSEQUENCE
                      AND I.REQ_ID = ANREQ_ID;
                RETURN LNPARENT;
        ELSE
          RETURN LNPARENT||'0';
        END IF;
    END IF;
   END GETPIDINGREDIENTFWB;  

 END AOPASPECIFICATIONBOMFWB;
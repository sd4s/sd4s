CREATE OR REPLACE PACKAGE BODY iapiLabel
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

   
   
   
   FUNCTION MANIPULATETEXT(
      ALTEXT                     IN       IAPITYPE.CLOB_TYPE )
      RETURN IAPITYPE.CLOB_TYPE
   IS
       
       
       
      
       
       
       
       
       
       
      LLSTRINGOLD                   IAPITYPE.CLOB_TYPE := NULL;
      LLSTRINGNEW                   IAPITYPE.CLOB_TYPE := NULL;
      LNPOSITION                    NUMBER( 10 );
   BEGIN
      LLSTRINGOLD := ALTEXT;

      IF LENGTH( LLSTRINGOLD ) > 0
      THEN
         LOOP
            EXIT WHEN LENGTH( LLSTRINGOLD ) = 0;
            LNPOSITION := INSTR( LLSTRINGOLD,
                                 CHR( 10 ) );

            IF LNPOSITION = 0
            THEN
               LLSTRINGNEW :=    LLSTRINGNEW
                              || LLSTRINGOLD;
               EXIT;
            ELSIF     INSTR( LLSTRINGOLD,
                                CHR( 13 )
                             || CHR( 10 ),
                             1 ) > 0
                  AND INSTR( LLSTRINGOLD,
                                CHR( 13 )
                             || CHR( 10 ),
                             1 ) =   LNPOSITION
                                   - 1
            THEN
               LLSTRINGNEW :=    LLSTRINGNEW
                              || SUBSTR( LLSTRINGOLD,
                                         1,
                                         LNPOSITION );
               LLSTRINGOLD := SUBSTR( LLSTRINGOLD,
                                        LNPOSITION
                                      + 1 );
            ELSE
               LLSTRINGNEW :=    LLSTRINGNEW
                              || REPLACE( SUBSTR( LLSTRINGOLD,
                                                  1,
                                                  LNPOSITION ),
                                          CHR( 10 ),
                                             CHR( 13 )
                                          || CHR( 10 ) );
               LLSTRINGOLD := SUBSTR( LLSTRINGOLD,
                                        LNPOSITION
                                      + 1 );
            END IF;
         END LOOP;
      END IF;

      RETURN LLSTRINGNEW;
   END MANIPULATETEXT;

   
   
   
   FUNCTION GETCOLUMNSLABELLOG(
      
      
      ASALIAS                    IN       IAPITYPE.STRING_TYPE DEFAULT '',
      ANINCLUDELABELXML          IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1 )
      
      RETURN IAPITYPE.BASECOLUMNS_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetColumnsLabelLog';
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
         || 'log_id '
         || IAPICONSTANTCOLUMN.LOGIDCOL
         || ','
         || LSALIAS
         || 'log_name '
         || IAPICONSTANTCOLUMN.LOGNAMECOL
         || ','
         || LSALIAS
         || 'status '
         || IAPICONSTANTCOLUMN.STATUSIDCOL
         || ', f_rdstatus_descr( l.status ) '
         || IAPICONSTANTCOLUMN.STATUSCOL
         || ','
         || LSALIAS
         || 'part_no '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ','
         || LSALIAS
         || 'revision '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', f_shh_descr( 1, l.part_no ) '
         || IAPICONSTANTCOLUMN.SPECIFICATIONDESCRIPTIONCOL
         || ','
         || LSALIAS
         || 'Plant '
         || IAPICONSTANTCOLUMN.PLANTCOL
         || ','
         || LSALIAS
         || 'alternative '
         || IAPICONSTANTCOLUMN.ALTERNATIVECOL
         || ','
         || LSALIAS
         || 'bom_usage '
         || IAPICONSTANTCOLUMN.BOMUSAGEIDCOL
         || ', f_bu_descr( l.bom_usage ) '
         || IAPICONSTANTCOLUMN.BOMUSAGEDESCRIPTIONCOL
         || ','
         || LSALIAS
         || 'explosion_date '
         || IAPICONSTANTCOLUMN.EXPLOSIONDATECOL
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
         || 'label '
         || IAPICONSTANTCOLUMN.LABELCOL
         || ','
         || LSALIAS
         || 'soi '
         || IAPICONSTANTCOLUMN.SOICOL
         || ','
         || LSALIAS
         || 'language_id '
         || IAPICONSTANTCOLUMN.LANGUAGEIDCOL
         || ', f_lang_descr( language_id ) '
         || IAPICONSTANTCOLUMN.LANGUAGECOL
         || ','
         || LSALIAS
         || 'synonym_type '
         || IAPICONSTANTCOLUMN.SYNONYMTYPEIDCOL
         || ', f_ingcfg_descr(1,6,l.synonym_type,0) '
         || IAPICONSTANTCOLUMN.SYNONYMTYPENAMECOL
         || ','
         || LSALIAS
         || 'loggingxml '
         || IAPICONSTANTCOLUMN.LOGGINGXMLCOL
         || ','
         || LSALIAS
         || 'labeltype '
         || IAPICONSTANTCOLUMN.LABELTYPECOL

         
         
         
         
         
         || ',';
         IF (ANINCLUDELABELXML = 1)
         THEN
               LCBASECOLUMNS :=       LCBASECOLUMNS
         || LSALIAS
         || 'labelXml ';
         ELSE
               LCBASECOLUMNS :=       LCBASECOLUMNS
         || 'null ';
         END IF;
         LCBASECOLUMNS :=       LCBASECOLUMNS

         || IAPICONSTANTCOLUMN.LABELXMLCOL
         || ','
         || LSALIAS
         || 'labelRTF '
         || IAPICONSTANTCOLUMN.LABELRTFCOL;
      RETURN( LCBASECOLUMNS );
   END GETCOLUMNSLABELLOG;

   
   FUNCTION HASLABEL(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
      RETURN IAPITYPE.BOOLEAN_TYPE
   IS
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM ITLABELLOG
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION;

      IF LNCOUNT > 0
      THEN
         RETURN 1;
      ELSE
         RETURN 0;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 0;
   END HASLABEL;

   
   FUNCTION HASNUTRITION(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
      RETURN IAPITYPE.BOOLEAN_TYPE
   IS
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM ITNUTLOG
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION;

      IF LNCOUNT > 0
      THEN
         RETURN 1;
      ELSE
         RETURN 0;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 0;
   END HASNUTRITION;

   
   
   
   
   FUNCTION GETINGREDIENTLIST(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSYNONYMTYPE              IN       IAPITYPE.ID_TYPE,
      AQITEMS                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetIngredientList';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' ing1.ingredient '
            || IAPICONSTANTCOLUMN.INGREDIENTCOL
            || ', ing1.quantity '
            || IAPICONSTANTCOLUMN.QUANTITYCOL
            || ', ing1.seq_no '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ', ing1.hier_level '
            || IAPICONSTANTCOLUMN.HIERARCHICALLEVELCOL
            || ', TO_NUMBER(CASE '
            || ' WHEN nvl(ing1.pid,0) > 0 THEN '
            || ' (SELECT max(ing2.seq_no) '
            || ' FROM specification_ing ing2 '
            || ' WHERE ing2.part_no = ing1.part_no '
            || ' AND ing2.revision = ing1.revision  '
            || ' AND ing2.ingredient = ing1.pid '
            || ' AND ing2.seq_no < ing1.seq_no '
            || ' AND ing2.hier_level = (ing1.hier_level - 1) ) '
            || ' ELSE 0 '
            || ' END) '
            || IAPICONSTANTCOLUMN.PARENTSEQUENCECOL
            || ', ing1.recfac '
            || IAPICONSTANTCOLUMN.RECONSTITUTIONFACTORCOL
            || ', decode(ing3.soi,''Y'',1,0) '
            || IAPICONSTANTCOLUMN.STANDARDOFIDENTITYCOL
            || ', nvl(ing3.allergen,0) '
            || IAPICONSTANTCOLUMN.ALLERGENIDCOL
            || ', nvl(f_ingcfg_descr(1, 7, ing3.allergen, 0),'''') '
            || IAPICONSTANTCOLUMN.ALLERGENCOL
            || ', f_ing_descr(1, ing1.ingredient, ing1.ingredient_rev) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', f_ing_syn( 1, :ansynonymtype, ing1.ingredient, ing1.ingredient_rev) '
            || IAPICONSTANTCOLUMN.SYNONYMNAMECOL
            || ', ing1.ingdeclare '
            || IAPICONSTANTCOLUMN.DECLARECOL
            || ', nvl(ing3.org_ing,0) '
            || IAPICONSTANTCOLUMN.ORIGINALINGREDIENTCOL
            || ', nvl(f_ing_descr(1, ing3.org_ing, 0),'''') '
            || IAPICONSTANTCOLUMN.ORIGINALINGREDIENTDESCCOL
            || ', nvl(ing3.rec_ing,0) '
            || IAPICONSTANTCOLUMN.RECONSTITUTIONINGREDIENTCOL
            || ', nvl(f_ing_descr(1, ing3.rec_ing, 0),'''') '
            || IAPICONSTANTCOLUMN.RECONSTITUTIONINGREDDESCCOL
            || ', ACTIV_IND '
            || IAPICONSTANTCOLUMN.ACTIVEINGREDIENTCOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM specification_ing ing1 ,iting ing3 ';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE
                                       :=    ' WHERE ing1.ingredient = ing3.ingredient '
                                          || ' AND part_no = :asPartNo '
                                          || ' AND revision = :anrevision ';
      LSORDERBY                     IAPITYPE.SQLSTRING_TYPE := ' ORDER BY seq_no ';
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
      ASPARTNO,
      ANREVISION;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      LNRETVAL := IAPISPECIFICATION.EXISTID( ASPARTNO,
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

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      IF AQITEMS%ISOPEN
      THEN
         CLOSE AQITEMS;
      END IF;

      OPEN AQITEMS FOR LSSQL USING ANSYNONYMTYPE,
      ASPARTNO,
      ANREVISION;

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
         ASPARTNO,
         ANREVISION;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETINGREDIENTLIST;

   

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
         :=  'part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', ing1.ingredient '
            || IAPICONSTANTCOLUMN.INGREDIENTCOL
            || ', ing1.quantity '
            || IAPICONSTANTCOLUMN.QUANTITYCOL
            || ', ing1.seq_no '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ', ing1.hier_level '
            || IAPICONSTANTCOLUMN.HIERARCHICALLEVELCOL
            || ', TO_NUMBER(CASE '
            || ' WHEN nvl(ing1.pid,0) > 0 THEN '
            || ' (SELECT max(ing2.seq_no) '
            || ' FROM specification_ing ing2 '
            || ' WHERE ing2.part_no = ing1.part_no '
            || ' AND ing2.revision = ing1.revision  '
            || ' AND ing2.ingredient = ing1.pid '
            || ' AND ing2.seq_no < ing1.seq_no '
            || ' AND ing2.hier_level = (ing1.hier_level - 1) ) '
            || ' ELSE 0 '
            || ' END) '
            || IAPICONSTANTCOLUMN.PARENTSEQUENCECOL
            
            || ', ing1.ING_COMMENT INGREDIENTCOMMENT '
            
            || ', ing1.recfac '
            || IAPICONSTANTCOLUMN.RECONSTITUTIONFACTORCOL
            || ', decode(ing3.soi,''Y'',1,0) '
            || IAPICONSTANTCOLUMN.STANDARDOFIDENTITYCOL
            || ', nvl(ing3.allergen,0) '
            || IAPICONSTANTCOLUMN.ALLERGENIDCOL
            || ', nvl(f_ingcfg_descr(1, 7, ing3.allergen, 0),'''') '
            || IAPICONSTANTCOLUMN.ALLERGENCOL
            || ', f_ing_descr(1, ing1.ingredient, ing1.ingredient_rev) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', f_ing_syn( 1, :ansynonymtype, ing1.ingredient, ing1.ingredient_rev) '
            || IAPICONSTANTCOLUMN.SYNONYMNAMECOL
            || ', ing1.ingdeclare '
            || IAPICONSTANTCOLUMN.DECLARECOL
            || ', nvl(ing3.org_ing,0) '
            || IAPICONSTANTCOLUMN.ORIGINALINGREDIENTCOL
            || ', nvl(f_ing_descr(1, ing3.org_ing, 0),'''') '
            || IAPICONSTANTCOLUMN.ORIGINALINGREDIENTDESCCOL
            || ', nvl(ing3.rec_ing,0) '
            || IAPICONSTANTCOLUMN.RECONSTITUTIONINGREDIENTCOL
            || ', nvl(f_ing_descr(1, ing3.rec_ing, 0),'''') '
            || IAPICONSTANTCOLUMN.RECONSTITUTIONINGREDDESCCOL
            || ', ACTIV_IND '
            || IAPICONSTANTCOLUMN.ACTIVEINGREDIENTCOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM specification_ing ing1 ,iting ing3 ';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE
                                       :=    ' WHERE ing1.ingredient = ing3.ingredient '
                                          || ' AND (part_no, revision) IN '
                                          || '    (SELECT component_part, component_revision '
                                          || '       FROM ITBOMEXPLOSION B, CLASS3 C '
                                          || '       WHERE B.BOM_EXP_NO = :anUniqueId '
                                          || '       AND C.CLASS = B.PART_TYPE )';

      LSORDERBY                     IAPITYPE.SQLSTRING_TYPE := ' ORDER BY part_no, revision, seq_no ';
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

      IF AQITEMS%ISOPEN
      THEN
         CLOSE AQITEMS;
      END IF;

      OPEN AQITEMS FOR LSSQL USING ANSYNONYMTYPE,
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
                                      ANUNIQUEID;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETINGREDIENTLIST;
   

   
   FUNCTION GETLABELLOGS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      AQLABELLOGS                OUT      IAPITYPE.REF_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE DEFAULT NULL,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE DEFAULT NULL,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE DEFAULT NULL,
     
      ABSHOWHISTORICLABELS  IN       IAPITYPE.BOOLEAN_TYPE DEFAULT NULL)
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetLabelLogs';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETCOLUMNSLABELLOG( 'l' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'itlabellog l';
      LSFILTER                      IAPITYPE.CLOB_TYPE := NULL;
      
      NROFREV                       NUMBER;
      CURSOR REVISIONCURSOR
       IS
             SELECT REVISION FROM SPECIFICATION_HEADER WHERE PART_NO = ASPARTNO;
      

   BEGIN

      
      
      
      
      
      IF ( AQLABELLOGS%ISOPEN )
      THEN
         CLOSE AQLABELLOGS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE l.log_id = NULL';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQLABELLOGS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM;
      DBMS_SESSION.SET_CONTEXT( 'IACLABELLOG',
                                'ASPARTNO',
                                ASPARTNO );
      LSSQL :=    LSSQL
               || ' WHERE part_no = '
               || ' sys_context(''IACLABELLOG'',''ASPARTNO'')'

      
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
               || ' 1 = 0 ) ';
      

    IF ASPLANT IS NOT NULL
    THEN
       DBMS_SESSION.SET_CONTEXT( 'IACLABELLOG',
                                 'asPlant',
                                 ASPLANT );
       LSSQL :=    LSSQL
                || ' AND plant = '
                || ' sys_context(''IACLABELLOG'',''ASPLANT'')';
    END IF;

    IF ANALTERNATIVE IS NOT NULL
    THEN
       DBMS_SESSION.SET_CONTEXT( 'IACLABELLOG',
                                 'anAlternative',
                                 ANALTERNATIVE );
       LSSQL :=    LSSQL
                || ' AND alternative = '
                || ' sys_context(''IACLABELLOG'',''ANALTERNATIVE'')';
    END IF;

    IF ANUSAGE IS NOT NULL
    THEN
       DBMS_SESSION.SET_CONTEXT( 'IACLABELLOG',
                                 'anUsage',
                                 ANUSAGE );
       LSSQL :=    LSSQL
                || ' AND bom_usage = '
                || ' sys_context(''IACLABELLOG'',''ANUSAGE'')';
    END IF;

   
   
   IF (ABSHOWHISTORICLABELS IS NOT NULL) AND (ABSHOWHISTORICLABELS = 0)
   THEN
       LSSQL :=  LSSQL
                || ' AND status NOT IN ( SELECT status FROM status WHERE status_type IN (''' || IAPICONSTANT.STATUSTYPE_HISTORIC || ''', ''' || IAPICONSTANT.STATUSTYPE_OBSOLETE || '''))';
   END IF;
   

    LSSQL :=    LSSQL
             || ' ORDER BY l.log_name';
    IAPIGENERAL.LOGINFO( GSSOURCE,
                         LSMETHOD,
                         LSSQL,
                         IAPICONSTANT.INFOLEVEL_3 );

    
    IF ( AQLABELLOGS%ISOPEN )
    THEN
       CLOSE AQLABELLOGS;
    END IF;

    
    OPEN AQLABELLOGS FOR LSSQL;


   RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );

   RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETLABELLOGS;



   
   FUNCTION GETLABELLOGSPB(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      AQLABELLOGS                OUT      IAPITYPE.REF_TYPE)
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetLabelLogsPB';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 ) := GETCOLUMNSLABELLOG( 'l', 0 );
      LSFROM                        IAPITYPE.STRING_TYPE := 'itlabellog l';
      LSFILTER                      IAPITYPE.CLOB_TYPE := NULL;
      
      ANREVISION                    IAPITYPE.REF_TYPE;
      NROFREV                       NUMBER;
      CURSOR REVISIONCURSOR
       IS
         SELECT REVISION FROM SPECIFICATION_HEADER WHERE PART_NO = ASPARTNO;
      
   BEGIN
      
      
      
      
      

      IF ( AQLABELLOGS%ISOPEN )
      THEN
         CLOSE AQLABELLOGS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE l.log_id = NULL';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQLABELLOGS FOR LSSQLNULL;

      
      
      



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM;
      DBMS_SESSION.SET_CONTEXT( 'IACLABELLOG',
                                'ASPARTNO',
                                ASPARTNO );
      LSSQL :=    LSSQL
               || ' WHERE part_no = '
               || ' sys_context(''IACLABELLOG'',''ASPARTNO'')'

      
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
               || '  1 = 0 ) ' 
      
               || ' ORDER BY l.log_name';

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQLABELLOGS%ISOPEN )
      THEN
         CLOSE AQLABELLOGS;
      END IF;

      
      OPEN AQLABELLOGS FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ));
   END GETLABELLOGSPB;

   
   
   FUNCTION ADDLABELLOG(
      ASLOGNAME                  IN       IAPITYPE.DESCRIPTION_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE,
      ANBOMUSAGE                 IN       IAPITYPE.BOMUSAGE_TYPE,
      ADEXPLOSIONDATE            IN       IAPITYPE.DATE_TYPE,
      ALLABEL                    IN       IAPITYPE.CLOB_TYPE,
      ANSOI                      IN       IAPITYPE.BOOLEAN_TYPE,
      ANLANGUAGEID               IN       IAPITYPE.LANGUAGEID_TYPE,
      ANSYNONYMTYPE              IN       IAPITYPE.ID_TYPE,
      ALLOGGINGXML               IN       IAPITYPE.CLOB_TYPE,
      ANLABELTYPE                IN       IAPITYPE.LABELTYPE_TYPE,
      ALLABELXML                 IN       IAPITYPE.CLOB_TYPE,
      AOLABELRTF                 IN       IAPITYPE.BLOB_TYPE,
      ANLOGID                    OUT      IAPITYPE.LOGID_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddLabelLog';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LLLABEL                       IAPITYPE.CLOB_TYPE := NULL;
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

      
      IF ( ANSOI IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Soi' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSoi',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANLANGUAGEID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'LanguageId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anLanguageId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANSYNONYMTYPE IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'SynonymType' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSynonymType',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ALLOGGINGXML IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'LoggingXml' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'alLoggingXml',
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
      LLLABEL := MANIPULATETEXT( ALLABEL );

      INSERT INTO ITLABELLOG
                  ( LOG_ID,
                    LOG_NAME,
                    STATUS,
                    PART_NO,
                    REVISION,
                    PLANT,
                    ALTERNATIVE,
                    BOM_USAGE,
                    EXPLOSION_DATE,
                    CREATED_BY,
                    CREATED_ON,
                    LABEL,
                    SOI,
                    LANGUAGE_ID,
                    SYNONYM_TYPE,
                    LOGGINGXML,
                    LABELTYPE,
                    LABELXML,
                    LABELRTF )
           VALUES ( RDLOG_SEQ.NEXTVAL,
                    ASLOGNAME,
                    ANSTATUS,
                    ASPARTNO,
                    ANREVISION,
                    ASPLANT,
                    ANALTERNATIVE,
                    ANBOMUSAGE,
                    ADEXPLOSIONDATE,
                    USER,
                    SYSDATE,
                    LLLABEL,
                    ANSOI,
                    ANLANGUAGEID,
                    ANSYNONYMTYPE,
                    ALLOGGINGXML,
                    ANLABELTYPE,
                    ALLABELXML,
                    AOLABELRTF );

      
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
   END ADDLABELLOG;

   
   FUNCTION SAVELABELLOG(
      ANLOGID                    IN       IAPITYPE.LOGID_TYPE,
      ASLOGNAME                  IN       IAPITYPE.DESCRIPTION_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      ANSOI                      IN       IAPITYPE.ID_TYPE,
      ALLABEL                    IN       IAPITYPE.CLOB_TYPE,
      AOLABELRTF                 IN       IAPITYPE.BLOB_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveLabelLog';
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

      
      IF ( ANSOI IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Soi' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anSoi',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ALLABEL IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Label' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'alLabel',
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

      UPDATE ITLABELLOG
         SET LOG_NAME = ASLOGNAME,
             STATUS = ANSTATUS,
             SOI = ANSOI,
             LABEL = ALLABEL,
             LABELRTF = AOLABELRTF
       WHERE LOG_ID = ANLOGID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVELABELLOG;

   
   FUNCTION GETINGREDIENTS(
      ANGROUPID                  IN       IAPITYPE.ID_TYPE,
      AQINGREDIENTS              OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetIngredients';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    'i.ingredient '
            || IAPICONSTANTCOLUMN.INGREDIENTIDCOL
            || ','
            || 'f_ing_descr(1, i.ingredient, 0) '
            || IAPICONSTANTCOLUMN.INGREDIENTCOL
            || ','
            || 'f_ing_allergen(i.ingredient) '
            || IAPICONSTANTCOLUMN.ALLERGENIDCOL
            || ','
            || 'f_ingcfg_descr(1, 7, f_ing_allergen(i.ingredient), 0) '
            || IAPICONSTANTCOLUMN.ALLERGENCOL
            || ','
            || 'f_ing_soi(i.ingredient) '
            || IAPICONSTANTCOLUMN.STANDARDOFIDENTITYCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'itingd i';
      
      LNANYING                      ITINGCFG.ANYING%TYPE;
      LSFROM2                       IAPITYPE.STRING_TYPE := 'iting i';

   BEGIN
      
      
      
      
      
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      SELECT ANYING
      INTO LNANYING
      FROM ITINGCFG
      WHERE CID = ANGROUPID;
      

      
      
      IF (LNANYING = 0)
      THEN
      
          LSSQL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE i.pid = 1 AND i.cid = :GroupId';
      
      ELSE
          LSSQL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM2
                   || ' WHERE ing_type IN (''I'', ''B'')'
                   || ' AND status = 0';

          IF (IAPIGENERAL.SESSION.SETTINGS.INTERNATIONAL)
          THEN
            LSSQL :=    LSSQL
                     || ' AND intl = 1';
          END IF;

      END IF;
      

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQINGREDIENTS%ISOPEN )
      THEN
         CLOSE AQINGREDIENTS;
      END IF;

      
      
      IF (LNANYING = 0)
      THEN
      
        OPEN AQINGREDIENTS FOR LSSQL USING ANGROUPID;
      
      ELSE
        OPEN AQINGREDIENTS FOR LSSQL;
      END IF;
      

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETINGREDIENTS;

   
   FUNCTION GETLABELLOGRESULTDETAILS(
      ANLOGID                    IN       IAPITYPE.LOGID_TYPE,
      AQLABELLOGRESULTDETAILS    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'getLabelLogResultDetails';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    'log_id '
            || IAPICONSTANTCOLUMN.LOGIDCOL
            || ' ,sequence_no '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ' ,parent_sequence_no '
            || IAPICONSTANTCOLUMN.PARENTSEQUENCECOL
            || ' ,bom_level '
            || IAPICONSTANTCOLUMN.BOMLEVELCOL
            || ' ,ingredient '
            || IAPICONSTANTCOLUMN.INGREDIENTIDCOL
            || ' ,is_in_group '
            || IAPICONSTANTCOLUMN.ISINGROUPCOL
            || ' ,is_in_function '
            || IAPICONSTANTCOLUMN.ISINFUNCTIONCOL
            || ' ,description '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ' ,quantity '
            || IAPICONSTANTCOLUMN.QUANTITYCOL
            || ' ,note '
            || IAPICONSTANTCOLUMN.NOTECOL
            || ' ,rec_from_id '
            || IAPICONSTANTCOLUMN.RECFROMIDCOL
            || ' ,rec_from_description '
            || IAPICONSTANTCOLUMN.RECFROMDESCRIPTIONCOL
            || ' ,rec_with_id '
            || IAPICONSTANTCOLUMN.RECWITHIDCOL
            || ' ,rec_with_description '
            || IAPICONSTANTCOLUMN.RECWITHDESCRIPTIONCOL
            || ' ,show_rec '
            || IAPICONSTANTCOLUMN.SHOWRECONSTITUTESCOL
            || ' ,active_ingredient '
            || IAPICONSTANTCOLUMN.ACTIVEINGREDIENTCOL
            || ' ,quid '
            || IAPICONSTANTCOLUMN.QUIDCOL
            || ' ,use_perc '
            || IAPICONSTANTCOLUMN.USEPERCENTAGECOL
            || ' ,show_items '
            || IAPICONSTANTCOLUMN.SHOWITEMSCOL
            || ' ,use_perc_rel '
            || IAPICONSTANTCOLUMN.USEPERCRELCOL
            || ' ,use_perc_abs '
            || IAPICONSTANTCOLUMN.USEPERCABSCOL
            || ' ,use_brackets '
            || IAPICONSTANTCOLUMN.USEBRACKETSCOL
            || ' ,allergen '
            || IAPICONSTANTCOLUMN.ALLERGENCOL
            || ' ,soi '
            || IAPICONSTANTCOLUMN.SOICOL
            || ' ,complex_label_log_id '
            || IAPICONSTANTCOLUMN.COMPLEXLABELLOGIDCOL
            || ' ,paragraph '
            || IAPICONSTANTCOLUMN.PARAGRAPHCOL
            || ' ,sort_sequence_no '
            || IAPICONSTANTCOLUMN.SORTSEQUENCECOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM itlabellogresultdetails';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE := ' WHERE log_id = :anLogId';
      LSORDERBY                     IAPITYPE.SQLSTRING_TYPE := ' ORDER BY sequence_no';
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

      IF AQLABELLOGRESULTDETAILS%ISOPEN
      THEN
         CLOSE AQLABELLOGRESULTDETAILS;
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQLABELLOGRESULTDETAILS FOR LSSQL USING ANLOGID;

      
      
      
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

      IF AQLABELLOGRESULTDETAILS%ISOPEN
      THEN
         CLOSE AQLABELLOGRESULTDETAILS;
      END IF;

      OPEN AQLABELLOGRESULTDETAILS FOR LSSQL USING ANLOGID;

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
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              LSSQL,
                              IAPICONSTANT.INFOLEVEL_3 );

         IF AQLABELLOGRESULTDETAILS%ISOPEN
         THEN
            CLOSE AQLABELLOGRESULTDETAILS;
         END IF;

         OPEN AQLABELLOGRESULTDETAILS FOR LSSQL USING ANLOGID;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETLABELLOGRESULTDETAILS;

   
   FUNCTION ADDLABELLOGRESULTDETAILS(
      ANLOGID                    IN       IAPITYPE.ID_TYPE,
      ANSEQUENCENO               IN       IAPITYPE.SEQUENCE_TYPE,
      ANPARENTSEQUENCENO         IN       IAPITYPE.SEQUENCE_TYPE,
      ANBOMLEVEL                 IN       IAPITYPE.BOMLEVEL_TYPE,
      ANINGREDIENT               IN       IAPITYPE.ID_TYPE,
      ANISINGROUP                IN       IAPITYPE.BOOLEAN_TYPE,
      ANISINFUNCTION             IN       IAPITYPE.BOOLEAN_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.STRING_TYPE,
      ANQUANTITY                 IN       IAPITYPE.BOMQUANTITY_TYPE,
      ASNOTE                     IN       IAPITYPE.CLOB_TYPE,
      ANRECFROMID                IN       IAPITYPE.ID_TYPE,
      ASRECFROMDESCRIPTION       IN       IAPITYPE.DESCRIPTION_TYPE,
      ANRECWITHID                IN       IAPITYPE.ID_TYPE,
      ASRECWITHDESCRIPTION       IN       IAPITYPE.DESCRIPTION_TYPE,
      ANSHOWREC                  IN       IAPITYPE.BOOLEAN_TYPE,
      ANACTIVEINGREDIENT         IN       IAPITYPE.BOOLEAN_TYPE,
      ANQUID                     IN       IAPITYPE.BOOLEAN_TYPE,
      ANUSEPERC                  IN       IAPITYPE.BOOLEAN_TYPE,
      ANSHOWITEMS                IN       IAPITYPE.BOOLEAN_TYPE,
      ANUSEPERCREL               IN       IAPITYPE.BOOLEAN_TYPE,
      ANUSEPERCABS               IN       IAPITYPE.BOOLEAN_TYPE,
      ANUSEBRACKETS              IN       IAPITYPE.BOOLEAN_TYPE,
      ANALLERGEN                 IN       IAPITYPE.ID_TYPE,
      ANSOI                      IN       IAPITYPE.BOOLEAN_TYPE,
      ANCOMPLEXLABELLOGID        IN       IAPITYPE.ID_TYPE,
      ANPARAGRAPH                IN       IAPITYPE.BOOLEAN_TYPE,
      ANSORTSEQUENCENO           IN       IAPITYPE.SEQUENCE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddLabelLogResultDetails';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRLABELLOGRESULTDETAILS       IAPITYPE.LABELLOGRESULTDETAILSROW_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LRLABELLOGRESULTDETAILS.LOG_ID := ANLOGID;
      LRLABELLOGRESULTDETAILS.SEQUENCE_NO := ANSEQUENCENO;
      LRLABELLOGRESULTDETAILS.PARENT_SEQUENCE_NO := ANPARENTSEQUENCENO;
      LRLABELLOGRESULTDETAILS.BOM_LEVEL := ANBOMLEVEL;
      LRLABELLOGRESULTDETAILS.INGREDIENT := ANINGREDIENT;
      LRLABELLOGRESULTDETAILS.IS_IN_GROUP := ANISINGROUP;
      LRLABELLOGRESULTDETAILS.IS_IN_FUNCTION := ANISINFUNCTION;
      LRLABELLOGRESULTDETAILS.DESCRIPTION := ASDESCRIPTION;
      LRLABELLOGRESULTDETAILS.QUANTITY := ANQUANTITY;
      LRLABELLOGRESULTDETAILS.NOTE := ASNOTE;
      LRLABELLOGRESULTDETAILS.REC_FROM_ID := ANRECFROMID;
      LRLABELLOGRESULTDETAILS.REC_FROM_DESCRIPTION := ASRECFROMDESCRIPTION;
      LRLABELLOGRESULTDETAILS.REC_WITH_ID := ANRECWITHID;
      LRLABELLOGRESULTDETAILS.REC_WITH_DESCRIPTION := ASRECWITHDESCRIPTION;
      LRLABELLOGRESULTDETAILS.SHOW_REC := ANSHOWREC;
      LRLABELLOGRESULTDETAILS.ACTIVE_INGREDIENT := ANACTIVEINGREDIENT;
      LRLABELLOGRESULTDETAILS.QUID := ANQUID;
      LRLABELLOGRESULTDETAILS.USE_PERC := ANUSEPERC;
      LRLABELLOGRESULTDETAILS.SHOW_ITEMS := ANSHOWITEMS;
      LRLABELLOGRESULTDETAILS.USE_PERC_REL := ANUSEPERCREL;
      LRLABELLOGRESULTDETAILS.USE_PERC_ABS := ANUSEPERCABS;
      LRLABELLOGRESULTDETAILS.USE_BRACKETS := ANUSEBRACKETS;
      LRLABELLOGRESULTDETAILS.ALLERGEN := ANALLERGEN;
      LRLABELLOGRESULTDETAILS.SOI := ANSOI;
      LRLABELLOGRESULTDETAILS.COMPLEX_LABEL_LOG_ID := ANCOMPLEXLABELLOGID;
      LRLABELLOGRESULTDETAILS.PARAGRAPH := ANPARAGRAPH;
      LRLABELLOGRESULTDETAILS.SORT_SEQUENCE_NO := ANSORTSEQUENCENO;

      INSERT INTO ITLABELLOGRESULTDETAILS
                  ( LOG_ID,
                    SEQUENCE_NO,
                    PARENT_SEQUENCE_NO,
                    BOM_LEVEL,
                    INGREDIENT,
                    IS_IN_GROUP,
                    IS_IN_FUNCTION,
                    DESCRIPTION,
                    QUANTITY,
                    NOTE,
                    REC_FROM_ID,
                    REC_FROM_DESCRIPTION,
                    REC_WITH_ID,
                    REC_WITH_DESCRIPTION,
                    SHOW_REC,
                    ACTIVE_INGREDIENT,
                    QUID,
                    USE_PERC,
                    SHOW_ITEMS,
                    USE_PERC_REL,
                    USE_PERC_ABS,
                    USE_BRACKETS,
                    ALLERGEN,
                    SOI,
                    COMPLEX_LABEL_LOG_ID,
                    PARAGRAPH,
                    SORT_SEQUENCE_NO )
           VALUES ( LRLABELLOGRESULTDETAILS.LOG_ID,
                    LRLABELLOGRESULTDETAILS.SEQUENCE_NO,
                    LRLABELLOGRESULTDETAILS.PARENT_SEQUENCE_NO,
                    LRLABELLOGRESULTDETAILS.BOM_LEVEL,
                    LRLABELLOGRESULTDETAILS.INGREDIENT,
                    LRLABELLOGRESULTDETAILS.IS_IN_GROUP,
                    LRLABELLOGRESULTDETAILS.IS_IN_FUNCTION,
                    LRLABELLOGRESULTDETAILS.DESCRIPTION,
                    LRLABELLOGRESULTDETAILS.QUANTITY,
                    LRLABELLOGRESULTDETAILS.NOTE,
                    LRLABELLOGRESULTDETAILS.REC_FROM_ID,
                    LRLABELLOGRESULTDETAILS.REC_FROM_DESCRIPTION,
                    LRLABELLOGRESULTDETAILS.REC_WITH_ID,
                    LRLABELLOGRESULTDETAILS.REC_WITH_DESCRIPTION,
                    LRLABELLOGRESULTDETAILS.SHOW_REC,
                    LRLABELLOGRESULTDETAILS.ACTIVE_INGREDIENT,
                    LRLABELLOGRESULTDETAILS.QUID,
                    LRLABELLOGRESULTDETAILS.USE_PERC,
                    LRLABELLOGRESULTDETAILS.SHOW_ITEMS,
                    LRLABELLOGRESULTDETAILS.USE_PERC_REL,
                    LRLABELLOGRESULTDETAILS.USE_PERC_ABS,
                    LRLABELLOGRESULTDETAILS.USE_BRACKETS,
                    LRLABELLOGRESULTDETAILS.ALLERGEN,
                    LRLABELLOGRESULTDETAILS.SOI,
                    LRLABELLOGRESULTDETAILS.COMPLEX_LABEL_LOG_ID,
                    LRLABELLOGRESULTDETAILS.PARAGRAPH,
                    LRLABELLOGRESULTDETAILS.SORT_SEQUENCE_NO );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDLABELLOGRESULTDETAILS;

   
   FUNCTION GETLANGUAGEINFO(
      AQLANGUAGEINFO             OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetLanguageInfo';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    'l.Lang_Id '
            || IAPICONSTANTCOLUMN.LANGUAGEIDCOL
            || ','
            || 'l.Description '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ','
            || 'm.Culture_Id Culture';
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM itlang l, itculturemapping m';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE := ' WHERE m.Lang_Id (+) = l.Lang_Id';
   BEGIN
      
      
      
      
      
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQLANGUAGEINFO%ISOPEN )
      THEN
         CLOSE AQLANGUAGEINFO;
      END IF;

      
      OPEN AQLANGUAGEINFO FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETLANGUAGEINFO;

   
   FUNCTION CHECKLABEL(
      ANUNIQUEID                 IN       IAPITYPE.ID_TYPE,
      ADEXPLOSIONDATE            IN       IAPITYPE.DATE_TYPE DEFAULT SYSDATE,
      ANINCLUDEINDEVELOPMENT     IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 0 )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      CURSOR CUR_MOP
      IS
         SELECT Q.PART_NO,
                Q.REVISION
           FROM ITSHQ Q
          WHERE Q.USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;

      CURSOR CUR_BOM(
         C_EXP_NO                            IAPITYPE.SEQUENCE_TYPE )
      IS
         SELECT MOP_SEQUENCE_NO,
                SEQUENCE_NO,
                COMPONENT_PART PART_NO,
                COMPONENT_REVISION REV
           FROM ITBOMEXPLOSION
          WHERE BOM_EXP_NO = C_EXP_NO;

      LNUNIQUEID                    IAPITYPE.ID_TYPE;
      LNMAX                         IAPITYPE.ID_TYPE;
      LSPLANT                       IAPITYPE.PLANT_TYPE;
      LNBASEQUANTITY                IAPITYPE.BOMQUANTITY_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNHASING                      IAPITYPE.BOOLEAN_TYPE;
      LNHASNUT                      IAPITYPE.BOOLEAN_TYPE;
      LQERRORS                      IAPITYPE.REF_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckLabel';
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

      DELETE FROM ITBOMEXPLOSION
            WHERE BOM_EXP_NO = ANUNIQUEID;

      SELECT BOM_EXPLOSION_SEQ.NEXTVAL
        INTO LNUNIQUEID
        FROM DUAL;

      FOR REC_MOP IN CUR_MOP
      LOOP
         BEGIN
            SELECT MIN( PLANT )
              INTO LSPLANT
              FROM BOM_HEADER
             WHERE PART_NO = REC_MOP.PART_NO
               AND REVISION = REC_MOP.REVISION;
         EXCEPTION
            WHEN OTHERS
            THEN
               LSPLANT := NULL;
         END;

         IF LSPLANT IS NOT NULL
         THEN
            
            BEGIN
               SELECT BASE_QUANTITY
                 INTO LNBASEQUANTITY
                 FROM BOM_HEADER
                WHERE PART_NO = REC_MOP.PART_NO
                  AND REVISION = REC_MOP.REVISION
                  AND PLANT = LSPLANT
                  AND ALTERNATIVE = 1   
                  AND BOM_USAGE = 1;   
            EXCEPTION
               WHEN OTHERS
               THEN
                  LNBASEQUANTITY := 100;
            END;

            
            LNRETVAL :=
               IAPISPECIFICATIONBOM.EXPLODE( LNUNIQUEID,
                                             REC_MOP.PART_NO,
                                             REC_MOP.REVISION,
                                             LSPLANT,
                                             1,
                                             1,
                                             1,
                                             ADEXPLOSIONDATE,
                                             LNBASEQUANTITY,
                                             ANINCLUDEINDEVELOPMENT,
                                             0,
                                             0,
                                             IAPICONSTANT.EXPLOSION_ASSOLD,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             LQERRORS );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               RETURN( LNRETVAL );
            END IF;

            FOR REC_BOM IN CUR_BOM( LNUNIQUEID )
            LOOP
               
               LNHASING := HASLABEL( REC_BOM.PART_NO,
                                     REC_BOM.REV );
               
               LNHASNUT := HASNUTRITION( REC_BOM.PART_NO,
                                         REC_BOM.REV );

               UPDATE ITBOMEXPLOSION
                  SET INGREDIENT = LNHASING,
                      PHANTOM = LNHASNUT
                WHERE BOM_EXP_NO = LNUNIQUEID
                  AND MOP_SEQUENCE_NO = REC_BOM.MOP_SEQUENCE_NO
                  AND SEQUENCE_NO = REC_BOM.SEQUENCE_NO;
            END LOOP;

            
            SELECT   MAX( SEQUENCE_NO )
                   + 1
              INTO LNMAX
              FROM ITBOMEXPLOSION
             WHERE BOM_EXP_NO = ANUNIQUEID;

            IF LNMAX IS NULL
            THEN
               LNMAX := 0;
            END IF;

            UPDATE ITBOMEXPLOSION
               SET BOM_EXP_NO = ANUNIQUEID,
                   SEQUENCE_NO =(   LNMAX
                                  + SEQUENCE_NO )
             WHERE BOM_EXP_NO = LNUNIQUEID;
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
   END CHECKLABEL;
END IAPILABEL;
CREATE OR REPLACE PACKAGE BODY iapiFoodClaims
AS
   
   
   
   
   
   
   
   
   FUNCTION FINDDECIMALS(
      ASSTRING                   IN       IAPITYPE.STRINGVAL_TYPE,
      ASDECSEP                   IN       IAPITYPE.DECIMALSEPERATOR_TYPE DEFAULT NULL,
      ANINDEX                    OUT      IAPITYPE.NUMVAL_TYPE )
      RETURN IAPITYPE.BOOLEAN_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FindDecimals';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSDECSEP                      IAPITYPE.DECIMALSEPERATOR_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ASDECSEP IS NULL
      THEN
         LSDECSEP := IAPIGENERAL.GETDBDECIMALSEPERATOR;
      ELSE
         LSDECSEP := ASDECSEP;
      END IF;

      SELECT   LENGTH( ASSTRING )
             - INSTR( ASSTRING,
                      LSDECSEP,
                      1 )
        INTO ANINDEX
        FROM DUAL;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'anIndex = '
                           || ANINDEX,
                           IAPICONSTANT.INFOLEVEL_3 );
      RETURN ANINDEX;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 0;
   END FINDDECIMALS;

   FUNCTION MULTIPLYVALUE(
      ANVALUE                    IN       IAPITYPE.NUMVAL_TYPE,
      ANINDEX                    IN       IAPITYPE.NUMVAL_TYPE )
      RETURN IAPITYPE.NUMVAL_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'MultiplyValue';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNRETURN                      IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETURN := ANVALUE;

      FOR I IN 1 .. ANINDEX
      LOOP
         LNRETURN :=   LNRETURN
                     * 10;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'lnReturn = '
                           || LNRETURN,
                           IAPICONSTANT.INFOLEVEL_3 );
      RETURN LNRETURN;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 0;
   END MULTIPLYVALUE;

   FUNCTION DIVIDEVALUE(
      ANVALUE                    IN       IAPITYPE.NUMVAL_TYPE,
      ANINDEX                    IN       IAPITYPE.NUMVAL_TYPE )
      RETURN IAPITYPE.NUMVAL_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'DivideValue';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNRETURN                      IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETURN := ANVALUE;

      FOR I IN 1 .. ANINDEX
      LOOP
         LNRETURN :=   LNRETURN
                     / 10;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'lnReturn = '
                           || LNRETURN,
                           IAPICONSTANT.INFOLEVEL_3 );
      RETURN LNRETURN;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 0;
   END DIVIDEVALUE;

   
   
   
   
   FUNCTION ISRECURSIVE(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANLOGID                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANPARENTFOODCLAIMID        IN       IAPITYPE.SEQUENCENR_TYPE,
      ANCURRENTFOODCLAIMID       IN       IAPITYPE.SEQUENCENR_TYPE,
      ANHIERLEVEL                IN       IAPITYPE.HIERLEVEL_TYPE,
      ANCURRENTSEQUENCE          IN       IAPITYPE.SEQUENCENR_TYPE,
      ABNOTCLAIM                 IN       IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.BOOLEAN_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsRecursive';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCHILDSEQUENCE               IAPITYPE.SEQUENCENR_TYPE;
      LNRECURSIVE                   IAPITYPE.BOOLEAN_TYPE DEFAULT 0;
      LNLOGID                       IAPITYPE.SEQUENCENR_TYPE;
      LNFOODCLAIMID                 IAPITYPE.SEQUENCENR_TYPE;
      LNRULETYPE                    IAPITYPE.SEQUENCENR_TYPE;
      LNRULEID                      IAPITYPE.SEQUENCENR_TYPE;
      LNPARENTLOGID                 IAPITYPE.SEQUENCENR_TYPE;
      LNPARENTFOODCLAIMID           IAPITYPE.SEQUENCENR_TYPE;
      LNPARENTRULETYPE              IAPITYPE.SEQUENCENR_TYPE;
      LNPARENTRULEID                IAPITYPE.SEQUENCENR_TYPE;
      LNPARENTSEQUENCE              IAPITYPE.SEQUENCENR_TYPE;
      LNPARENTHIERLEVEL             IAPITYPE.HIERLEVEL_TYPE;
      LNCOUNT                       IAPITYPE.SEQUENCENR_TYPE;
      LSSELECTSQL                   IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ANCURRENTSEQUENCE = 10
      THEN
         RETURN 0;
      ELSE
         LNCHILDSEQUENCE := ANCURRENTSEQUENCE;
         LNPARENTHIERLEVEL := ANHIERLEVEL;

         LOOP
            LNPARENTHIERLEVEL :=   LNPARENTHIERLEVEL
                                 - 1;
            LSSELECTSQL :=
                  'SELECT Rule_Id, seq_No'
               || '  FROM itFoodClaimResultDetail rd1 '
               || ' WHERE Req_Id = :anWebRq '
               || '   AND Seq_No IN( '
               || '          SELECT MAX( Seq_No ) '
               || '            FROM itFoodClaimResultDetail rd2 '
               || '           WHERE rd2.Req_Id = :anWebRq '
               || '             AND rd2.Hier_Level =  :anHierLevel '
               || '             AND rd2.Seq_No < :anCurrentSequence '
               || '             AND rd2.Rule_Type = 2 '
               || '             AND rd2.Log_Id = :anLogId '
               || '             AND rd2.Food_Claim_Id = :anParentFoodClaimId '
               || '             AND rd2.Not_Claim = :abNotClaim )'
               || '   AND Rule_Type = 2 '
               || '   AND Hier_Level = :anHierLevel '
               || '   AND Log_Id = :anLogId '
               || '   AND Food_Claim_Id = :anParentFoodClaimId '
               || '   AND Not_Claim = :abNotClaim ';

            EXECUTE IMMEDIATE LSSELECTSQL
                         INTO LNPARENTRULEID,
                              LNPARENTSEQUENCE
                        USING ANWEBRQ,
                              ANWEBRQ,
                              LNPARENTHIERLEVEL,
                              LNCHILDSEQUENCE,
                              ANLOGID,
                              ANPARENTFOODCLAIMID,
                              ABNOTCLAIM,
                              LNPARENTHIERLEVEL,
                              ANLOGID,
                              ANPARENTFOODCLAIMID,
                              ABNOTCLAIM;

            IF LNPARENTRULEID = ANCURRENTFOODCLAIMID
            THEN
               LNRECURSIVE := 1;
               EXIT;
            END IF;

            LNCHILDSEQUENCE := LNPARENTSEQUENCE;
         END LOOP;
      END IF;

      RETURN LNRECURSIVE;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         LNRECURSIVE := 0;
         RETURN LNRECURSIVE;
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL );
         RAISE_APPLICATION_ERROR( -20000,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
   END ISRECURSIVE;

   
   FUNCTION GETSERVINGSIZE(
      ANLOGID                    IN       IAPITYPE.SEQUENCENR_TYPE )
      RETURN IAPITYPE.NUMVAL_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetServingSize';
      LSRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSERVINGSIZE                 IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT RESULT_WEIGHT
        INTO LNSERVINGSIZE
        FROM ITNUTLOG
       WHERE LOG_ID = ANLOGID;

      RETURN( LNSERVINGSIZE );
   END GETSERVINGSIZE;

   
   FUNCTION GETREFERENCEAMOUNT(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE )
      RETURN IAPITYPE.NUMVAL_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetReferenceAmount';
      LSRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNREFERENCEAMOUNT             IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT TO_NUMBER( KEY_VALUE )
        INTO LNREFERENCEAMOUNT
        FROM ITFOODCLAIMRUNCRIT
       WHERE REQ_ID = ANWEBRQ
         AND KEY_TYPE = IAPICONSTANT.KEYTYPE_REFAMOUNT;

      RETURN( LNREFERENCEAMOUNT );
   END GETREFERENCEAMOUNT;


   FUNCTION GETCOLUMNSFOODCLAIMLOG(
      ASALIAS                    IN       IAPITYPE.STRING_TYPE DEFAULT '' )
      RETURN IAPITYPE.BASECOLUMNS_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetColumnsFoodClaimLog';
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
         || ', f_rdstatus_descr( '
         || LSALIAS
         || 'status ) '
         || IAPICONSTANTCOLUMN.STATUSCOL
         || ','
         || LSALIAS
         || 'part_no '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ','
         || LSALIAS
         || 'revision '
         || IAPICONSTANTCOLUMN.REVISIONCOL
         || ', f_shh_descr( 1, '
         || LSALIAS
         || 'part_no ) '
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
         || ', f_bu_descr( '
         || LSALIAS
         || 'bom_usage ) '
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
         || 'Language_Id '
         || IAPICONSTANTCOLUMN.LANGUAGEIDCOL
         || ','
         || ' f_lang_descr( '
         || LSALIAS
         || 'language_id ) '
         || IAPICONSTANTCOLUMN.LANGUAGECOL
         || ','
         || LSALIAS
         || 'Reference_Amount '
         || IAPICONSTANTCOLUMN.REFERENCEAMOUNTCOL
         || ','
         || LSALIAS
         || 'loggingxml '
         || IAPICONSTANTCOLUMN.LOGGINGXMLCOL;
      RETURN( LCBASECOLUMNS );
   END GETCOLUMNSFOODCLAIMLOG;


   FUNCTION GETCOLUMNSFOODCLAIMLOGRESULT(
      ASALIAS                    IN       IAPITYPE.STRING_TYPE DEFAULT '' )
      RETURN IAPITYPE.BASECOLUMNS_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetColumnsFoodClaimLogResult';
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
         || 'LOG_ID '
         || IAPICONSTANTCOLUMN.LOGIDCOL
         || ','
         || LSALIAS
         || 'FOOD_CLAIM_ID '
         || IAPICONSTANTCOLUMN.FOODCLAIMIDCOL
         || ', f_foodclaim_descr('
         || LSALIAS
         || 'Food_Claim_Id, 0) '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ','
         || LSALIAS
         || 'NUT_LOG_ID '
         || IAPICONSTANTCOLUMN.NUTLOGIDCOL
         || ','
         || LSALIAS
         || 'RESULT '
         || IAPICONSTANTCOLUMN.RESULTCOL
         || ','
         || LSALIAS
         || 'COMP_LOG_ID '
         || IAPICONSTANTCOLUMN.COMPLOGIDCOL
         || ','
         || LSALIAS
         || 'COMP_GROUP_ID '
         || IAPICONSTANTCOLUMN.COMPGROUPIDCOL;
      RETURN( LCBASECOLUMNS );
   END GETCOLUMNSFOODCLAIMLOGRESULT;


   FUNCTION GETCOLUMNSFOODCLAIMLOGRESULTD(
      ASALIAS                    IN       IAPITYPE.STRING_TYPE DEFAULT '' )
      RETURN IAPITYPE.BASECOLUMNS_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetColumnsFoodClaimLogResultD';
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
         || 'LOG_ID '
         || IAPICONSTANTCOLUMN.LOGIDCOL
         || ','
         || LSALIAS
         || 'FOOD_CLAIM_ID '
         || IAPICONSTANTCOLUMN.FOODCLAIMIDCOL
         || ','
         || LSALIAS
         || 'FOOD_CLAIM_CRIT_RULE_CD_ID '
         || IAPICONSTANTCOLUMN.FOODCLAIMCRITRULECDIDCOL
         || ','
         || LSALIAS
         || 'HIER_LEVEL '
         || IAPICONSTANTCOLUMN.HIERARCHICALLEVELCOL
         || ','
         || LSALIAS
         || 'NUT_LOG_ID '
         || IAPICONSTANTCOLUMN.NUTLOGIDCOL
         || ','
         || LSALIAS
         || 'SEQ_NO '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ','
         || LSALIAS
         || 'Ref_Type '
         || IAPICONSTANTCOLUMN.REFTYPECOL
         || ','
         || LSALIAS
         || 'REF_ID '
         || IAPICONSTANTCOLUMN.REFIDCOL
         || ', f_FoodClaim_ResRule_Descr('
         || LSALIAS
         || 'Ref_Id, '
         || LSALIAS
         || 'Ref_Type) '
         || IAPICONSTANTCOLUMN.RULEDESCRIPTIONCOL
         || ','
         || LSALIAS
         || 'AND_OR '
         || IAPICONSTANTCOLUMN.ANDORCOL
         || ','
         || LSALIAS
         || 'RULE_TYPE '
         || IAPICONSTANTCOLUMN.RULETYPECOL
         || ','
         || LSALIAS
         || 'RULE_ID '
         || IAPICONSTANTCOLUMN.RULEIDCOL
         || ', f_FoodClaim_ResCondition_Descr('
         || LSALIAS
         || 'Rule_Id, '
         || LSALIAS
         || 'Attribute_Id, '
         || LSALIAS
         || 'Rule_Type) '
         || IAPICONSTANTCOLUMN.CONDITIONDESCRIPTIONCOL
         || ','
         || LSALIAS
         || 'RULE_OPERATOR '
         || IAPICONSTANTCOLUMN.RULEOPERATORCOL
         || ','
         || LSALIAS

         || ', F_FOODCLAIM_CONDVALUE_DESC(d.Rule_Value_1) '
         || IAPICONSTANTCOLUMN.RULEVALUE1COL
         || ','
         || LSALIAS
         || 'RULE_VALUE_2 '
         || IAPICONSTANTCOLUMN.RULEVALUE2COL
         || ','
         || LSALIAS
         || 'SERVING_SIZE '
         || IAPICONSTANTCOLUMN.SERVINGSIZECOL
         || ','
         || LSALIAS
         || 'VALUE_TYPE '
         || IAPICONSTANTCOLUMN.VALUETYPECOL
         || ','
         || LSALIAS
         || 'RELATIVE_PERC '
         || IAPICONSTANTCOLUMN.RELATIVEPERCCOL
         || ','
         || LSALIAS
         || 'RELATIVE_COMP '
         || IAPICONSTANTCOLUMN.RELATIVECOMPCOL
         || ','
         || LSALIAS
         || 'ACTUAL_VALUE '
         || IAPICONSTANTCOLUMN.ACTUALVALUECOL
         || ','
         || LSALIAS
         || 'RESULT '
         || IAPICONSTANTCOLUMN.RESULTCOL
         || ','
         || LSALIAS
         || 'PARENT_FOOD_CLAIM_ID '
         || IAPICONSTANTCOLUMN.PARENTFOODCLAIMIDCOL
         || ','
         || LSALIAS
         || 'PARENT_SEQ_NO '
         || IAPICONSTANTCOLUMN.PARENTSEQUENCECOL
         || ','
         || LSALIAS
         || 'ERROR_CODE '
         || IAPICONSTANTCOLUMN.ERRORCODECOL
         || ','
         || LSALIAS
         || 'ATTRIBUTE_ID '
         || IAPICONSTANTCOLUMN.ATTRIBUTEIDCOL;
      RETURN( LCBASECOLUMNS );
   END GETCOLUMNSFOODCLAIMLOGRESULTD;

   
   
   
   
   
   
   
   
   
   FUNCTION CHECKEXISTINGRESULTS(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANLOGID                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANFOODCLAIMID              IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQUENCENR               IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ANHIERLEVEL                IN       IAPITYPE.SEQUENCENR_TYPE )
      RETURN IAPITYPE.BOOLEAN_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CheckExistingResults';
      LBCOPIEDEXISTING              IAPITYPE.BOOLEAN_TYPE DEFAULT 0;
      LNEXISTINGSEQUENCENR          IAPITYPE.SEQUENCENR_TYPE DEFAULT 0;
      LNEXISTINGHIERLEVEL           IAPITYPE.SEQUENCENR_TYPE DEFAULT 0;
      LNDIFFSEQUENCENR              IAPITYPE.SEQUENCENR_TYPE;
      LNDIFFHIERLEVEL               IAPITYPE.SEQUENCENR_TYPE;

      
      
      CURSOR LCEXISTS(
         CNWEBRQ                             IAPITYPE.SEQUENCENR_TYPE,
         CNLOGID                             IAPITYPE.SEQUENCENR_TYPE,
         CNFOODCLAIMID                       IAPITYPE.SEQUENCENR_TYPE,
         CNSEQUENCENR                        IAPITYPE.SEQUENCENR_TYPE )
      IS
         SELECT SEQ_NO,
                HIER_LEVEL
           FROM ITFOODCLAIMRESULTDETAIL
          WHERE REQ_ID = CNWEBRQ
            AND LOG_ID = CNLOGID
            AND RULE_ID = CNFOODCLAIMID
            AND RULE_TYPE = 2
            AND SEQ_NO <> CNSEQUENCENR;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN LCEXISTS( ANWEBRQ,
                     ANLOGID,
                     ANFOODCLAIMID,
                     ANSEQUENCENR );

      FETCH LCEXISTS
       INTO LNEXISTINGSEQUENCENR,
            LNEXISTINGHIERLEVEL;

      CLOSE LCEXISTS;

      IF LNEXISTINGSEQUENCENR > 0
      THEN
         
         LNDIFFHIERLEVEL :=   ANHIERLEVEL
                            - LNEXISTINGHIERLEVEL;
         LNDIFFSEQUENCENR :=   ANSEQUENCENR
                             - LNEXISTINGSEQUENCENR;

         INSERT INTO ITFOODCLAIMRESULTDETAIL
                     ( LOG_ID,
                       REQ_ID,
                       FOOD_CLAIM_ID,
                       FOOD_CLAIM_CRIT_RULE_CD_ID,
                       HIER_LEVEL,
                       SEQ_NO,
                       REF_TYPE,
                       REF_ID,
                       AND_OR,
                       RULE_TYPE,
                       RULE_ID,
                       RULE_OPERATOR,
                       RULE_VALUE_1,
                       RULE_VALUE_2,
                       SERVING_SIZE,
                       VALUE_TYPE,
                       RELATIVE_PERC,
                       RELATIVE_COMP,
                       ACTUAL_VALUE,
                       RESULT,
                       PARENT_FOOD_CLAIM_ID,
                       PARENT_SEQ_NO,
                       ERROR_CODE )
            SELECT     LOG_ID,
                       REQ_ID,
                       FOOD_CLAIM_ID,
                       FOOD_CLAIM_CRIT_RULE_CD_ID,
                         HIER_LEVEL
                       + LNDIFFHIERLEVEL,
                         SEQ_NO
                       + LNDIFFSEQUENCENR,
                       REF_TYPE,
                       REF_ID,
                       AND_OR,
                       RULE_TYPE,
                       RULE_ID,
                       RULE_OPERATOR,
                       RULE_VALUE_1,
                       RULE_VALUE_2,
                       SERVING_SIZE,
                       VALUE_TYPE,
                       RELATIVE_PERC,
                       RELATIVE_COMP,
                       ACTUAL_VALUE,
                       RESULT,
                       PARENT_FOOD_CLAIM_ID,
                         PARENT_SEQ_NO
                       + LNDIFFSEQUENCENR,
                       ERROR_CODE
                  FROM ITFOODCLAIMRESULTDETAIL
            START WITH SEQ_NO = LNEXISTINGSEQUENCENR
            CONNECT BY PRIOR SEQ_NO = PARENT_SEQ_NO;

          
         
         LBCOPIEDEXISTING := 1;

         SELECT MAX( SEQ_NO )
           INTO ANSEQUENCENR
           FROM ITFOODCLAIMRESULTDETAIL
          WHERE REQ_ID = ANWEBRQ;
      END IF;

      RETURN LBCOPIEDEXISTING;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CHECKEXISTINGRESULTS;

   
   FUNCTION ADDFOODCLAIMRESULT(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANPROFILELOGID             IN       IAPITYPE.SEQUENCENR_TYPE,
      ANFOODCLAIMID              IN       IAPITYPE.SEQUENCENR_TYPE,
      ANRESULT                   IN       IAPITYPE.CLAIMSRESULTTYPE_TYPE,
      ANRUNLOGID                 IN       IAPITYPE.SEQUENCENR_TYPE,
      ANGROUPID                  IN       IAPITYPE.SEQUENCENR_TYPE,
      ANERRORCODE                IN       IAPITYPE.ERRORNUM_TYPE,
      ASDECSEP                   IN       IAPITYPE.DECIMALSEPERATOR_TYPE DEFAULT NULL )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddFoodClaimResult';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSDECSEP                      IAPITYPE.DECIMALSEPERATOR_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ASDECSEP IS NULL
      THEN
         LSDECSEP := IAPIGENERAL.GETDBDECIMALSEPERATOR;
      ELSE
         LSDECSEP := ASDECSEP;
      END IF;
      
      INSERT INTO ITFOODCLAIMRESULT
                  ( REQ_ID,
                    LOG_ID,
                    FOOD_CLAIM_ID,
                    RESULT,
                    COMP_LOG_ID,
                    COMP_GROUP_ID,
                    DEC_SEP )
           VALUES ( ANWEBRQ,
                    ANPROFILELOGID,
                    ANFOODCLAIMID,
                    ANRESULT,
                    ANRUNLOGID,
                    ANGROUPID,
                    LSDECSEP );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDFOODCLAIMRESULT;

   
   FUNCTION ADDFOODCLAIMRESULTDETAIL(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANLOGID                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANFOODCLAIMID              IN       IAPITYPE.SEQUENCENR_TYPE,
      ANFOODCLAIMCRITRULECDID    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANHIERLEVEL                IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQNO                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANREFTYPE                  IN       IAPITYPE.SEQUENCENR_TYPE,
      ANREFID                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ASANDOR                    IN       IAPITYPE.CLAIMRESULTDANDOR_TYPE,
      ANRULETYPE                 IN       IAPITYPE.CLAIMRESULTDRULETYPE_TYPE,
      ANRULEID                   IN       IAPITYPE.SEQUENCENR_TYPE,
      ASRULEOPERATOR             IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASRULEVALUE1               IN       IAPITYPE.DESCRIPTION_TYPE,
      ASRULEVALUE2               IN       IAPITYPE.DESCRIPTION_TYPE,
      ASSERVINGSIZE              IN       IAPITYPE.DESCRIPTION_TYPE,
      ANVALUETYPE                IN       IAPITYPE.CLAIMRESULTDVALUETYPE_TYPE,
      ANRELATIVEPERC             IN       IAPITYPE.CLAIMRESULTDRELATIVEPERC_TYPE,
      ANRELATIVECOMP             IN       IAPITYPE.CLAIMRESULTDRELATIVECOMP_TYPE,
      ASACTUALVALUE              IN       IAPITYPE.DESCRIPTION_TYPE,
      ANRESULT                   IN       IAPITYPE.CLAIMSRESULTTYPE_TYPE,
      ANPARENTFOODCLAIMID        IN       IAPITYPE.SEQUENCENR_TYPE,
      ANPARENTSEQNO              IN       IAPITYPE.SEQUENCENR_TYPE,
      ANERRORCODE                IN       IAPITYPE.ERRORNUM_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.SEQUENCENR_TYPE,
      ABNOTCLAIM                 IN       IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddFoodClaimResultDetail';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      INSERT INTO ITFOODCLAIMRESULTDETAIL
                  ( REQ_ID,
                    LOG_ID,
                    FOOD_CLAIM_ID,
                    FOOD_CLAIM_CRIT_RULE_CD_ID,
                    HIER_LEVEL,
                    SEQ_NO,
                    REF_TYPE,
                    REF_ID,
                    AND_OR,
                    RULE_TYPE,
                    RULE_ID,
                    RULE_OPERATOR,
                    RULE_VALUE_1,
                    RULE_VALUE_2,
                    SERVING_SIZE,
                    VALUE_TYPE,
                    RELATIVE_PERC,
                    RELATIVE_COMP,
                    ACTUAL_VALUE,
                    RESULT,
                    PARENT_FOOD_CLAIM_ID,
                    PARENT_SEQ_NO,
                    ERROR_CODE,
                    ATTRIBUTE_ID,
                    NOT_CLAIM )
           VALUES ( ANWEBRQ,
                    ANLOGID,
                    ANFOODCLAIMID,
                    ANFOODCLAIMCRITRULECDID,
                    ANHIERLEVEL,
                    ANSEQNO,
                    ANREFTYPE,
                    ANREFID,
                    ASANDOR,
                    ANRULETYPE,
                    ANRULEID,
                    ASRULEOPERATOR,
                    ASRULEVALUE1,
                    ASRULEVALUE2,
                    ASSERVINGSIZE,
                    ANVALUETYPE,
                    ANRELATIVEPERC,
                    ANRELATIVECOMP,
                    ASACTUALVALUE,
                    ANRESULT,
                    ANPARENTFOODCLAIMID,
                    ANPARENTSEQNO,
                    ANERRORCODE,
                    ANATTRIBUTEID,
                    ABNOTCLAIM );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDFOODCLAIMRESULTDETAIL;

   
   FUNCTION SAVEFOODCLAIMRESULTDETAIL(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANLOGID                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANFOODCLAIMID              IN       IAPITYPE.SEQUENCENR_TYPE,
      ANFOODCLAIMCRITRULECDID    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANHIERLEVEL                IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQNO                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANREFTYPE                  IN       IAPITYPE.SEQUENCENR_TYPE,
      ANREFID                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ASANDOR                    IN       IAPITYPE.CLAIMRESULTDANDOR_TYPE,
      ANRULETYPE                 IN       IAPITYPE.CLAIMRESULTDRULETYPE_TYPE,
      ANRULEID                   IN       IAPITYPE.SEQUENCENR_TYPE,
      ASRULEOPERATOR             IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASRULEVALUE1               IN       IAPITYPE.DESCRIPTION_TYPE,
      ASRULEVALUE2               IN       IAPITYPE.DESCRIPTION_TYPE,
      ASSERVINGSIZE              IN       IAPITYPE.DESCRIPTION_TYPE,
      ANVALUETYPE                IN       IAPITYPE.CLAIMRESULTDVALUETYPE_TYPE,
      ANRELATIVEPERC             IN       IAPITYPE.CLAIMRESULTDRELATIVEPERC_TYPE,
      ANRELATIVECOMP             IN       IAPITYPE.CLAIMRESULTDRELATIVECOMP_TYPE,
      ASACTUALVALUE              IN       IAPITYPE.DESCRIPTION_TYPE,
      ANRESULT                   IN       IAPITYPE.CLAIMSRESULTTYPE_TYPE,
      ANPARENTFOODCLAIMID        IN       IAPITYPE.SEQUENCENR_TYPE,
      ANPARENTSEQNO              IN       IAPITYPE.SEQUENCENR_TYPE,
      ANERRORCODE                IN       IAPITYPE.ERRORNUM_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.SEQUENCENR_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveFoodClaimResultDetail';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      UPDATE ITFOODCLAIMRESULTDETAIL
         SET HIER_LEVEL = ANHIERLEVEL,
             REF_TYPE = ANREFTYPE,
             REF_ID = ANREFID,
             AND_OR = ASANDOR,
             RULE_TYPE = ANRULETYPE,
             RULE_ID = ANRULEID,
             RULE_OPERATOR = ASRULEOPERATOR,
             RULE_VALUE_1 = ASRULEVALUE1,
             RULE_VALUE_2 = ASRULEVALUE2,
             SERVING_SIZE = ASSERVINGSIZE,
             VALUE_TYPE = ANVALUETYPE,
             RELATIVE_PERC = ANRELATIVEPERC,
             RELATIVE_COMP = ANRELATIVECOMP,
             ACTUAL_VALUE = ASACTUALVALUE,
             RESULT = ANRESULT,
             PARENT_SEQ_NO = ANPARENTSEQNO,
             ERROR_CODE = ANERRORCODE,
             ATTRIBUTE_ID = ANATTRIBUTEID
       WHERE REQ_ID = ANWEBRQ
         AND LOG_ID = ANLOGID
         AND FOOD_CLAIM_ID = ANFOODCLAIMID
         AND SEQ_NO = ANSEQNO
         AND FOOD_CLAIM_CRIT_RULE_CD_ID = ANFOODCLAIMCRITRULECDID
         AND PARENT_FOOD_CLAIM_ID = ANPARENTFOODCLAIMID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEFOODCLAIMRESULTDETAIL;

   
   FUNCTION GETNUTRITIONALVALUE(
      ANLOGID                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANGROUPID                  IN       IAPITYPE.SEQUENCENR_TYPE,
      ANVALUETYPE                IN       IAPITYPE.SEQUENCENR_TYPE,
      ANPROPERTY                 IN       IAPITYPE.SEQUENCENR_TYPE,
      ANATTRIBUTE                IN       IAPITYPE.SEQUENCENR_TYPE,
      ASVALUE                    OUT      IAPITYPE.DESCRIPTION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetNutritionalValue';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSVALUE                       IAPITYPE.DESCRIPTION_TYPE := '';
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM ITNUTLOGRESULT R,
             ITNUTLOG L,
             ITNUTLYITEM LAY
       WHERE L.LOG_ID = ANLOGID
         AND R.LOG_ID = L.LOG_ID
         AND LAY.LAYOUT_ID = L.LAYOUT_ID
         AND LAY.REVISION = L.LAYOUT_REV
         AND LAY.GROUPING_ID = ANGROUPID
         AND LAY.COL_TYPE = ANVALUETYPE
         AND R.COL_ID = LAY.SEQ_NO
         AND R.PROPERTY = ANPROPERTY
         AND R.ATTRIBUTE = ANATTRIBUTE;

      IF LNCOUNT = 0
      THEN
         LNRETVAL :=
            IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                IAPICONSTANTDBERROR.DBERR_NUTRIENTNOTFOUND,
                                                ANLOGID,
                                                
                                                
                                                
                                                
                                                
                                                F_PGH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANGROUPID, 0),
                                                ANVALUETYPE,                                            
                                                F_SPH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANPROPERTY, 0),                                            
                                                F_ATH_DESCR(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID, ANATTRIBUTE, 0));
                                                
                                                
         RETURN( IAPICONSTANTDBERROR.DBERR_NUTRIENTNOTFOUND );
      END IF;

      SELECT TO_CHAR( F_CONVERT_VALUE_DECSEP( TO_CHAR( R.VALUE ),
                                              L.DEC_SEP ) )
        INTO ASVALUE
        FROM ITNUTLOGRESULT R,
             ITNUTLOG L,
             ITNUTLYITEM LAY
       WHERE L.LOG_ID = ANLOGID
         AND R.LOG_ID = L.LOG_ID
         AND LAY.LAYOUT_ID = L.LAYOUT_ID
         AND LAY.REVISION = L.LAYOUT_REV
         AND LAY.GROUPING_ID = ANGROUPID
         AND LAY.COL_TYPE = ANVALUETYPE
         AND R.COL_ID = LAY.SEQ_NO
         AND R.PROPERTY = ANPROPERTY
         AND R.ATTRIBUTE = ANATTRIBUTE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETNUTRITIONALVALUE;

   
   FUNCTION SCALENUTRIENT(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANLOGID                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ARCONDITIONS               IN       IAPITYPE.FOODCLAIMSCONDITIONSREC_TYPE,
      ASVALUE                    IN OUT   IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ScaleNutrient';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSERVINGSIZE                 IAPITYPE.NUMVAL_TYPE;
      LNREFERENCEAMOUNT             IAPITYPE.NUMVAL_TYPE;
      LNCONVFACTOR                  IAPITYPE.NUMVAL_TYPE;
      LNVALUE                       IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
                           
      LNVALUE := TO_NUMBER( ASVALUE );
      LNSERVINGSIZE := GETSERVINGSIZE( ANLOGID );

      IF UPPER( ARCONDITIONS.SERVINGSIZE ) = UPPER( IAPICONSTANT.FOOD_REFERENCEAMOUNT )
      THEN
         LNREFERENCEAMOUNT := GETREFERENCEAMOUNT( ANWEBRQ );
         LNCONVFACTOR :=   LNREFERENCEAMOUNT
                         / LNSERVINGSIZE;
         LNVALUE :=   LNVALUE
                    * LNCONVFACTOR;
      ELSIF IAPIGENERAL.ISNUMERIC( ARCONDITIONS.SERVINGSIZE ) = IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         LNREFERENCEAMOUNT := TO_NUMBER( ARCONDITIONS.SERVINGSIZE );
         LNCONVFACTOR :=   LNREFERENCEAMOUNT
                         / LNSERVINGSIZE;
         LNVALUE :=   LNVALUE
                    * LNCONVFACTOR;
      END IF;

      ASVALUE := TO_CHAR( LNVALUE );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SCALENUTRIENT;

   
   FUNCTION ANALYZENUTRIENT(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ASVALUEIN                  IN       IAPITYPE.STRING_TYPE,
      ANLOGID                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANGROUPID                  IN       IAPITYPE.SEQUENCENR_TYPE,
      ARCONDITIONS               IN       IAPITYPE.FOODCLAIMSCONDITIONSREC_TYPE,
      ASVALUEOUT                 OUT      IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AnalyzeNutrient';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSPARAMETER                   IAPITYPE.STRING_TYPE := '';
      LNNUTRIENTID                  IAPITYPE.SEQUENCENR_TYPE;
      LNATTRIBUTEID                 IAPITYPE.SEQUENCENR_TYPE;
      LNPARAMETERVALUE              IAPITYPE.NUMVAL_TYPE;
      LSPARAMETERVALUE              IAPITYPE.STRING_TYPE;
      LNOPENBRACKETPOS              IAPITYPE.NUMVAL_TYPE;
      LNCLOSEBRACKETPOS             IAPITYPE.NUMVAL_TYPE;
      LNCOMMAPOS                    IAPITYPE.NUMVAL_TYPE;
      LSVALUEIN                     IAPITYPE.STRING_TYPE;
      LNVALUEOUT                    IAPITYPE.NUMVAL_TYPE;
      LSSQLSTRING                   IAPITYPE.SQLSTRING_TYPE;
      
      LSVALUEIN2                    IAPITYPE.STRING_TYPE;            
   BEGIN   
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSVALUEIN := ASVALUEIN;

    
    LSVALUEIN := F_EVAL_NUTR_EXPR(LSVALUEIN);
    

      BEGIN
         DECLARE
         BEGIN
            LNOPENBRACKETPOS := INSTR( LSVALUEIN,
                                       '{' );

            WHILE LNOPENBRACKETPOS > 0
            LOOP
               
               LNCLOSEBRACKETPOS := INSTR( LSVALUEIN,
                                           '}',
                                           LNOPENBRACKETPOS );

               IF ( LNCLOSEBRACKETPOS > 0 )
               THEN
                  LSPARAMETER := SUBSTR( LSVALUEIN,
                                           LNOPENBRACKETPOS
                                         + 1,
                                           LNCLOSEBRACKETPOS
                                         - LNOPENBRACKETPOS
                                         - 1 );
                  LNCOMMAPOS := INSTR( LSPARAMETER,
                                       ',' );

                  IF ( LNCOMMAPOS > 0 )
                  THEN
                     LNNUTRIENTID := TO_NUMBER( SUBSTR( LSPARAMETER,
                                                        1,
                                                          LNCOMMAPOS
                                                        - 1 ) );
                     LNATTRIBUTEID := TO_NUMBER( SUBSTR( LSPARAMETER,
                                                           LNCOMMAPOS
                                                         + 1,
                                                           LENGTH( LSPARAMETER )
                                                         - LNCOMMAPOS ) );
                     LNRETVAL := GETNUTRITIONALVALUE( ANLOGID,
                                                      ANGROUPID,
                                                      ARCONDITIONS.VALUETYPE,
                                                      LNNUTRIENTID,
                                                      LNATTRIBUTEID,
                                                      LSPARAMETERVALUE );

                     IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                     THEN
                        RETURN( LNRETVAL );
                     END IF;

                     LNRETVAL := SCALENUTRIENT( ANWEBRQ,
                                                ANLOGID,
                                                ARCONDITIONS,
                                                LSPARAMETERVALUE );
                     LSPARAMETERVALUE := TO_CHAR( MULTIPLYVALUE( TO_NUMBER( LSPARAMETERVALUE ),
                                                                 10 ) );

                     IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                     THEN
                        RETURN( LNRETVAL );
                     END IF;

                     LSVALUEIN := REPLACE( LSVALUEIN,
                                              '{'
                                           || LSPARAMETER
                                           || '}',
                                           LSPARAMETERVALUE );
                  END IF;

                  LNOPENBRACKETPOS := INSTR( LSVALUEIN,
                                             '{' );
               ELSE
                  LNOPENBRACKETPOS := 0;
               END IF;
            END LOOP;
         END;
      END;

      
      
      BEGIN
          EXECUTE IMMEDIATE 'SELECT ' || LSVALUEIN || ' FROM DUAL' INTO  LSVALUEIN;
      EXCEPTION                                                                              
          WHEN OTHERS
          THEN
            NULL;            
      END;       
      
      
      
      
      LSVALUEIN2 := TO_CHAR( DIVIDEVALUE( TO_NUMBER( LSVALUEIN ),
                                              10 ) );
                                               
      
      IF ( LSVALUEIN2 = ASVALUEIN )
      
      
      THEN
         LNRETVAL := GETNUTRITIONALVALUE( ANLOGID,
                                          ANGROUPID,
                                          ARCONDITIONS.VALUETYPE,
                                          ARCONDITIONS.RULEID,
                                          ARCONDITIONS.ATTRIBUTEID,
                                          LSVALUEIN );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( LNRETVAL );
         END IF;

         LNRETVAL := SCALENUTRIENT( ANWEBRQ,
                                    ANLOGID,
                                    ARCONDITIONS,
                                    LSVALUEIN );
         LSVALUEIN := TO_CHAR( MULTIPLYVALUE( TO_NUMBER( LSVALUEIN ),
                                              10 ) );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            RETURN( LNRETVAL );
         END IF;
      END IF;
 
      LSSQLSTRING :=    'select '
                     || LSVALUEIN
                     || ' from dual ';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQLSTRING,
                                   IAPICONSTANT.INFOLEVEL_3 );

      EXECUTE IMMEDIATE LSSQLSTRING
                   INTO LNVALUEOUT;

      ASVALUEOUT := TO_CHAR( DIVIDEVALUE( LNVALUEOUT,
                                          10 ) );
                                          
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         ASVALUEOUT := ASVALUEIN;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
   END ANALYZENUTRIENT;

   
   FUNCTION EVALUATENUTRIENT(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ARPROFILES                 IN       IAPITYPE.FOODCLAIMPROFILEREC_TYPE,
      ARRUN                      IN       IAPITYPE.FOODCLAIMRUNREC_TYPE,
      ARCONDITIONS               IN       IAPITYPE.FOODCLAIMSCONDITIONSREC_TYPE,
      ASNUTVALUE                 IN OUT   IAPITYPE.STRING_TYPE,
      ABRESULT                   IN OUT   IAPITYPE.BOOLEAN_TYPE,
      ANERRORCODE                IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASDECSEP                   IN       IAPITYPE.DECIMALSEPERATOR_TYPE DEFAULT NULL )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
 
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'EvaluateNutrient';
      LSSQLSTRING                   IAPITYPE.SQLSTRING_TYPE;
      LSSQLOPERATOR                 IAPITYPE.SQLSTRING_TYPE;
      LSSQLWHERE                    IAPITYPE.SQLSTRING_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNRETBOOLEAN                  IAPITYPE.BOOLEAN_TYPE DEFAULT 0;
      LNSERVINGSIZE                 IAPITYPE.NUMVAL_TYPE;
      LNREFERENCEAMOUNT             IAPITYPE.NUMVAL_TYPE;
      LNCONVFACTOR                  IAPITYPE.NUMVAL_TYPE;
      LNNUTVALUE                    IAPITYPE.NUMVAL_TYPE;
      LNNUTVALUECOMP                IAPITYPE.NUMVAL_TYPE;
      LSRULEVALUE1                  IAPITYPE.STRING_TYPE DEFAULT ' ';
      LSVALUE1                      IAPITYPE.STRING_TYPE DEFAULT ' ';
      LSVALUE2                      IAPITYPE.STRING_TYPE DEFAULT ' ';
      LSBETWEENOPERATOR             IAPITYPE.STRING_TYPE DEFAULT ' ';
      LSNUTVALUE                    IAPITYPE.STRING_TYPE;
      LSNUTVALUECOMP                IAPITYPE.STRING_TYPE;
      LSDECSEP                      IAPITYPE.DECIMALSEPERATOR_TYPE;
      
      LNCOMPLOGID                   IAPITYPE.SEQUENCENR_TYPE;            
      
      LNPOS                         IAPITYPE.NUMVAL_TYPE;      
      LNISRELATIVECL                IAPITYPE.BOOLEAN_TYPE;      

      
      FUNCTION GETTHEVALUE(A_LOGID IN IAPITYPE.SEQUENCENR_TYPE                                 
                           , A_GROUPINGID IN IAPITYPE.SEQUENCENR_TYPE)                           
      RETURN IAPITYPE.ERRORNUM_TYPE      
      IS
      BEGIN
      
         
         LNRETVAL := ANALYZENUTRIENT( ANWEBRQ,
                                      ARCONDITIONS.RULEVALUE1,    
                                      
                                      
                                      
                                      
                                      
                                      
                                      A_LOGID,                                                                                                              
                                      
                                      A_GROUPINGID,
                                      
                                      ARCONDITIONS,
                                      LSNUTVALUECOMP );
                                      
         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            
            
            ABRESULT := 0;
            ANERRORCODE := IAPICONSTANTDBERROR.DBERR_NUTRIENTCONDNOTSATISFIED;
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_NUTRIENTCONDNOTSATISFIED );
         END IF;

         LSNUTVALUECOMP := F_CONVERT_VALUE_DECSEP( LSNUTVALUECOMP,
                                                   LSDECSEP );

         IF IAPIGENERAL.ISNUMERIC( LSNUTVALUECOMP ) = IAPICONSTANTDBERROR.DBERR_SUCCESS
         THEN
            LNNUTVALUECOMP := TO_NUMBER( LSNUTVALUECOMP );

            IF ARCONDITIONS.RELATIVEPERC = 1
            THEN
               LNNUTVALUECOMP :=   LNNUTVALUECOMP
                                 * TO_NUMBER( LSRULEVALUE1 )
                                 / 100;
            
            

                LNNUTVALUECOMP := MULTIPLYVALUE( LNNUTVALUECOMP,
                                                 10 );
                LSVALUE1 := TO_CHAR( LNNUTVALUECOMP );

                
                IAPIGENERAL.LOGINFO(GSSOURCE, LSMETHOD, 'Value (%) from comparison profile is <'||LSVALUE1||'>');
            ELSE
               
               











               
               
                LNNUTVALUECOMP := MULTIPLYVALUE( LNNUTVALUECOMP,
                                                10 );                
                LSVALUE1 := TO_CHAR( LNNUTVALUECOMP );
               
               IAPIGENERAL.LOGINFO(GSSOURCE, LSMETHOD, 'Value from comparison profile is <'||LSVALUE1||'>');
               
            END IF;           
           
    
         ELSE
            LSVALUE1 :=    ''''
                        || LSNUTVALUECOMP
                        || '''';
         END IF;
         
         RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
      END;
      

   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ASDECSEP IS NULL
      THEN
         LSDECSEP := IAPIGENERAL.GETDBDECIMALSEPERATOR;
      ELSE
         LSDECSEP := ASDECSEP;
      END IF;

      IF ASNUTVALUE IS NULL
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_NUTRIENTNOTFOUND,
                                                         0,
                                                         0,
                                                         0,
                                                         0,
                                                         0 );
         ABRESULT := 0;
         ANERRORCODE := IAPICONSTANTDBERROR.DBERR_NUTRIENTNOTFOUND;
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NUTRIENTNOTFOUND );
      END IF;

      LSSQLOPERATOR := ARCONDITIONS.RULEOPERATOR;
      LSNUTVALUE := F_CONVERT_VALUE_DECSEP( ASNUTVALUE,
                                            LSDECSEP );
      LSRULEVALUE1 := ARCONDITIONS.RULEVALUE1;
      
      
      
      
      
      BEGIN
        EXECUTE IMMEDIATE 'SELECT ' || LSRULEVALUE1 || ' FROM DUAL' INTO  LSRULEVALUE1;
      EXCEPTION                                                                              
          WHEN OTHERS
          THEN
            NULL;
      END;   
     
      
      IF IAPIGENERAL.ISNUMERIC( LSNUTVALUE ) = IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
         LNRETVAL := SCALENUTRIENT( ANWEBRQ,
                                    ARPROFILES.LOGID,
                                    ARCONDITIONS,
                                    LSNUTVALUE );
         ASNUTVALUE := LSNUTVALUE;
         LSNUTVALUE := TO_CHAR( MULTIPLYVALUE( TO_NUMBER( LSNUTVALUE ),
                                               10 ) );
      ELSE
         LSNUTVALUE :=    ''''
                       || LSNUTVALUE
                       || '''';
         ASNUTVALUE := LSNUTVALUE;
      END IF;

      
      IAPIGENERAL.LOGINFO(GSSOURCE, LSMETHOD,'Configuration of condition: RelativeComp <'||ARCONDITIONS.RELATIVECOMP||'>, RelativePerc <'||ARCONDITIONS.RELATIVEPERC||'>');

      IF ARCONDITIONS.RELATIVECOMP = 1
      THEN   
         
         LNPOS := INSTR( ARCONDITIONS.RULEVALUE1 , '{' );
         
         IF (LNPOS > 0)
         THEN
         
            
            BEGIN
                SELECT COMP_LOG_ID
                INTO LNCOMPLOGID
                FROM ITFOODCLAIMRESULT
                WHERE REQ_ID = ANWEBRQ
                AND LOG_ID = ARPROFILES.LOGID
                AND FOOD_CLAIM_ID = ARRUN.FOODCLAIMID;     
                                                 
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    
                    
                    LNCOMPLOGID := ARPROFILES.LOGID;     
                    
            END;
             
            
            
            
            
            
            
            
            
                               
            
            LNRETVAL := GETTHEVALUE(LNCOMPLOGID, ARRUN.GROUPID);
                     
            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN         
               RETURN LNRETVAL;
            END IF;
         
         ELSE
             LSRULEVALUE1 := F_CONVERT_VALUE_DECSEP( LSRULEVALUE1,
                                                     LSDECSEP );

             IF IAPIGENERAL.ISNUMERIC( LSRULEVALUE1 ) = IAPICONSTANTDBERROR.DBERR_SUCCESS
             THEN
                LSVALUE1 := TO_CHAR( MULTIPLYVALUE( TO_NUMBER( LSRULEVALUE1 ),
                                                    10 ) );
             ELSE
                LSVALUE1 :=    ''''
                            || LSRULEVALUE1
                            || '''';
             END IF;
            
         END IF;         
         
                      
         
         












































































         
         
         
      ELSE
         
         
         
         LNPOS := INSTR( ARCONDITIONS.RULEVALUE1 , '{' );
         
         IF (LNPOS > 0)
         THEN         
             
             SELECT RELATIVE
             INTO LNISRELATIVECL
             FROM ITFOODCLAIMRUN CR, ITFOODCLAIM CL
             WHERE CR.FOOD_CLAIM_ID = CL.FOOD_CLAIM_ID             
             AND CR.REQ_ID = ANWEBRQ
             AND CR.FOOD_CLAIM_ID = ARRUN.FOODCLAIMID;                        
                        
             IF (LNISRELATIVECL = 0)
             THEN                 
                 
                 
                 LNRETVAL := GETTHEVALUE(ARPROFILES.LOGID, ARPROFILES.GROUPID);                     
             ELSE                                  
                 
                 
                 
                 LNRETVAL := GETTHEVALUE(ARPROFILES.LOGID, ARPROFILES.GROUPID);
             END IF;   
                                     
             IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
             THEN         
                RETURN LNRETVAL;
             END IF;
                      
         ELSE 
         
      
             LSRULEVALUE1 := F_CONVERT_VALUE_DECSEP( LSRULEVALUE1,
                                                     LSDECSEP );

             IF IAPIGENERAL.ISNUMERIC( LSRULEVALUE1 ) = IAPICONSTANTDBERROR.DBERR_SUCCESS
             THEN
                LSVALUE1 := TO_CHAR( MULTIPLYVALUE( TO_NUMBER( LSRULEVALUE1 ),
                                                    10 ) );
             ELSE
                LSVALUE1 :=    ''''
                            || LSRULEVALUE1
                            || '''';
             END IF;
         
         END IF;   
         
      END IF;

      IF UPPER( LSSQLOPERATOR ) = UPPER( IAPICONSTANT.OPERATOR_BETWEEN )
      THEN
         LSBETWEENOPERATOR := ' AND ';

         IF ARCONDITIONS.RULEVALUE2 IS NOT NULL
         THEN
            LSVALUE2 := ARCONDITIONS.RULEVALUE2;
            LSVALUE2 := F_CONVERT_VALUE_DECSEP( LSVALUE2,
                                                LSDECSEP );

            IF IAPIGENERAL.ISNUMERIC( LSVALUE2 ) <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               LSVALUE2 :=    ''''
                           || LSVALUE2
                           || '''';
            ELSE
               LSVALUE2 := TO_CHAR( MULTIPLYVALUE( TO_NUMBER( LSVALUE2 ),
                                                   10 ) );
            END IF;
         END IF;
      END IF;

      
      IF IAPIGENERAL.ISNUMERIC( LSNUTVALUE ) = IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
          LSSQLWHERE :=  'TO_NUMBER(''' || 
                          LSNUTVALUE
                        ||''')' 
                        || ' '
                        || LSSQLOPERATOR
                        || ' '
                        || 'TO_NUMBER(''' 
                        || LSVALUE1
                        ||''')'; 
                                   
          IF (LENGTH(TRIM(LSBETWEENOPERATOR)) > 0)
          THEN                    
            LSSQLWHERE := LSSQLWHERE
                        || ' '
                        || LSBETWEENOPERATOR
                        || ' '
                        || 'TO_NUMBER(''' 
                        || LSVALUE2
                        ||''')'; 
          END IF;   
      ELSE
      
          LSSQLWHERE :=    LSNUTVALUE
                        || ' '
                        || LSSQLOPERATOR
                        || ' '
                        || LSVALUE1
                        || LSBETWEENOPERATOR
                        || LSVALUE2;                       
      
      END IF;
      
                                                      
      LSSQLSTRING :=    'SELECT 1 '
                     || ' FROM DUAL '
                     || ' WHERE '
                     || LSSQLWHERE;

      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
      
                                   LSMETHOD,
                                   LSSQLSTRING,
                                   IAPICONSTANT.INFOLEVEL_3 );

      EXECUTE IMMEDIATE LSSQLSTRING
                   INTO LNRETBOOLEAN;

      IF LNRETBOOLEAN = 1
      THEN
         ABRESULT := 1;
         ANERRORCODE := IAPICONSTANTDBERROR.DBERR_SUCCESS;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      ELSE
         ABRESULT := 0;
         ANERRORCODE := IAPICONSTANTDBERROR.DBERR_NUTRIENTCONDNOTSATISFIED;
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NUTRIENTCONDNOTSATISFIED );
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         ABRESULT := 0;
         ANERRORCODE := IAPICONSTANTDBERROR.DBERR_NUTRIENTCONDNOTSATISFIED;
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NUTRIENTCONDNOTSATISFIED );
      WHEN OTHERS
      THEN
         ABRESULT := 0;
         ANERRORCODE := IAPICONSTANTDBERROR.DBERR_GENFAIL;
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EVALUATENUTRIENT;

    
   
   FUNCTION EVALUATEPERCCONDITION(    
      ARCONDITIONS               IN       IAPITYPE.FOODCLAIMSCONDITIONSREC_TYPE,
      ASNUTVALUE                 IN       IAPITYPE.STRING_TYPE,
      ABRESULT                   IN OUT   IAPITYPE.BOOLEAN_TYPE,
      ANERRORCODE                IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASDECSEP                   IN       IAPITYPE.DECIMALSEPERATOR_TYPE DEFAULT NULL )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
 
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'EvaluatePercCondition';
      LSSQLSTRING                   IAPITYPE.SQLSTRING_TYPE;
      LSSQLOPERATOR                 IAPITYPE.SQLSTRING_TYPE;
      LSSQLWHERE                    IAPITYPE.SQLSTRING_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNRETBOOLEAN                  IAPITYPE.BOOLEAN_TYPE DEFAULT 0;
      LSRULEVALUE1                  IAPITYPE.STRING_TYPE DEFAULT ' ';
      LSVALUE1                      IAPITYPE.STRING_TYPE DEFAULT ' ';
      LSVALUE2                      IAPITYPE.STRING_TYPE DEFAULT ' ';
      LSBETWEENOPERATOR             IAPITYPE.STRING_TYPE DEFAULT ' ';
      LSNUTVALUE                    IAPITYPE.STRING_TYPE;
      LSNUTVALUECOMP                IAPITYPE.STRING_TYPE;
      LSDECSEP                      IAPITYPE.DECIMALSEPERATOR_TYPE;

   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ASDECSEP IS NULL
      THEN
         LSDECSEP := IAPIGENERAL.GETDBDECIMALSEPERATOR;
      ELSE
         LSDECSEP := ASDECSEP;
      END IF;

      IF ASNUTVALUE IS NULL
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_NUTRIENTNOTFOUND,
                                                         0,
                                                         0,
                                                         0,
                                                         0,
                                                         0 );
         ABRESULT := 0;
         ANERRORCODE := IAPICONSTANTDBERROR.DBERR_NUTRIENTNOTFOUND;
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NUTRIENTNOTFOUND );
      END IF;

      LSSQLOPERATOR := ARCONDITIONS.RULEOPERATOR;
      
      LSNUTVALUE := F_CONVERT_VALUE_DECSEP( ASNUTVALUE,
                                            LSDECSEP );

      LSRULEVALUE1 := ARCONDITIONS.RULEVALUE1;

      LSVALUE1 := F_CONVERT_VALUE_DECSEP( LSRULEVALUE1,
                                              LSDECSEP );

                       
     IF IAPIGENERAL.ISNUMERIC( LSNUTVALUE ) <> IAPICONSTANTDBERROR.DBERR_SUCCESS
     THEN
        LSNUTVALUE :=    ''''
                    || LSNUTVALUE
                    || '''';
     END IF;
     
     IF IAPIGENERAL.ISNUMERIC( LSVALUE1 ) <> IAPICONSTANTDBERROR.DBERR_SUCCESS
     THEN
        LSVALUE1 :=    ''''
                    || LSVALUE1
                    || '''';
     END IF;
                     

      IF UPPER( LSSQLOPERATOR ) = UPPER( IAPICONSTANT.OPERATOR_BETWEEN )
      THEN
         LSBETWEENOPERATOR := ' AND ';

         IF ARCONDITIONS.RULEVALUE2 IS NOT NULL
         THEN
            LSVALUE2 := ARCONDITIONS.RULEVALUE2;
            
            LSVALUE2 := F_CONVERT_VALUE_DECSEP( LSVALUE2,
                                                LSDECSEP );

            IF IAPIGENERAL.ISNUMERIC( LSVALUE2 ) <> IAPICONSTANTDBERROR.DBERR_SUCCESS
            THEN
               LSVALUE2 :=    ''''
                           || LSVALUE2
                           || '''';
            END IF;
         END IF;
      END IF;

      
      IF IAPIGENERAL.ISNUMERIC( LSNUTVALUE ) = IAPICONSTANTDBERROR.DBERR_SUCCESS
      THEN
          LSSQLWHERE :=  'TO_NUMBER(''' || 
                          LSNUTVALUE
                        ||''')' 
                        || ' '
                        || LSSQLOPERATOR
                        || ' '
                        || 'TO_NUMBER(''' 
                        || LSVALUE1
                        ||''')'; 
                                   
          IF (LENGTH(TRIM(LSBETWEENOPERATOR)) > 0)
          THEN                    
            LSSQLWHERE := LSSQLWHERE
                        || ' '
                        || LSBETWEENOPERATOR
                        || ' '
                        || 'TO_NUMBER(''' 
                        || LSVALUE2
                        ||''')'; 
          END IF;   
      ELSE
      
          LSSQLWHERE :=    LSNUTVALUE
                        || ' '
                        || LSSQLOPERATOR
                        || ' '
                        || LSVALUE1
                        || LSBETWEENOPERATOR
                        || LSVALUE2;                       
      
      END IF;
      
                                                        
      LSSQLSTRING :=    'SELECT 1 '
                     || ' FROM DUAL '
                     || ' WHERE '
                     || LSSQLWHERE;

      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
      
                                   LSMETHOD,
                                   LSSQLSTRING,
                                   IAPICONSTANT.INFOLEVEL_3 );

      EXECUTE IMMEDIATE LSSQLSTRING
                   INTO LNRETBOOLEAN;

      IF LNRETBOOLEAN = 1
      THEN
         ABRESULT := 1;
         ANERRORCODE := IAPICONSTANTDBERROR.DBERR_SUCCESS;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      ELSE
         ABRESULT := 0;
         ANERRORCODE := IAPICONSTANTDBERROR.DBERR_NUTRIENTCONDNOTSATISFIED;
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NUTRIENTCONDNOTSATISFIED );
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         ABRESULT := 0;
         ANERRORCODE := IAPICONSTANTDBERROR.DBERR_NUTRIENTCONDNOTSATISFIED;
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NUTRIENTCONDNOTSATISFIED );
      WHEN OTHERS
      THEN
         ABRESULT := 0;
         ANERRORCODE := IAPICONSTANTDBERROR.DBERR_GENFAIL;
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EVALUATEPERCCONDITION;
  

   
   FUNCTION EVALUATEFOODCLAIM(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ARPROFILES                 IN       IAPITYPE.FOODCLAIMPROFILEREC_TYPE,
      ARRUN                      IN       IAPITYPE.FOODCLAIMRUNREC_TYPE,
      ARCONDITIONS               IN       IAPITYPE.FOODCLAIMSCONDITIONSREC_TYPE,
      ANPARENTFOODCLAIMID        IN       IAPITYPE.SEQUENCENR_TYPE,
      ANPARENTLOGID              IN       IAPITYPE.SEQUENCENR_TYPE,
      ANPARENTSEQNO              IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ABRESULT                   IN OUT   IAPITYPE.BOOLEAN_TYPE,
      ANHIERLEVEL                IN OUT   IAPITYPE.HIERLEVEL_TYPE,
      ANERRORCODE                IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ABNOTCLAIM                 IN       IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.BOOLEAN_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'EvaluateFoodClaim';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL :=
         GETFOODCLAIM( ANWEBRQ,
                       ANPARENTFOODCLAIMID,
                       ANPARENTLOGID,
                       ANPARENTSEQNO,
                       ARCONDITIONS.RULEID,
                       ARRUN,
                       ARPROFILES,
                       ABRESULT,
                       ANHIERLEVEL,
                       ANERRORCODE,
                       ABNOTCLAIM );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN IAPIGENERAL.GETLASTERRORTEXT( );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EVALUATEFOODCLAIM;

   
   FUNCTION EVALUATEMANUALCONDITION(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ARPROFILES                 IN       IAPITYPE.FOODCLAIMPROFILEREC_TYPE,
      ANPARENTFOODCLAIMID        IN       IAPITYPE.SEQUENCENR_TYPE,
      ANPARENTSEQNO              IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ARCONDITIONS               IN       IAPITYPE.FOODCLAIMSCONDITIONSREC_TYPE,
      ABRESULT                   IN OUT   IAPITYPE.BOOLEAN_TYPE,
      ABACTUALVALUE              IN OUT   IAPITYPE.BOOLEAN_TYPE,
      ANERRORCODE                IN OUT   IAPITYPE.SEQUENCENR_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'EvaluateManualCondition';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNRESULT                      IAPITYPE.BOOLEAN_TYPE;
      LNRETBOOLEAN                  IAPITYPE.BOOLEAN_TYPE DEFAULT 0;
      LSSQLSTRING                   IAPITYPE.SQLSTRING_TYPE;
      LSVALUE                       IAPITYPE.STRING_TYPE DEFAULT ' ';
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         ABRESULT := 0;
         ANERRORCODE := LNRETVAL;
         RETURN( LNRETVAL );
      END IF;

      BEGIN
         SELECT RESULT
           INTO ABACTUALVALUE
           FROM ITFOODCLAIMRUNCD
          WHERE REQ_ID = ANWEBRQ
            AND FOOD_CLAIM_ID = ANPARENTFOODCLAIMID
            AND REF_ID = ARCONDITIONS.RULEID
            AND REF_TYPE = IAPICONSTANT.REFTYPE_MANUALCOND;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            ABRESULT := 0;
            ABACTUALVALUE := NULL;
            ANERRORCODE := IAPICONSTANTDBERROR.DBERR_MANUALCONDNOTFOUND;
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_MANUALCONDNOTFOUND );
      END;

      LSSQLSTRING :=    'SELECT 1 '
                     || ' FROM DUAL '
                     || ' WHERE '
                     || ABACTUALVALUE
                     || ' '
                     || ARCONDITIONS.RULEOPERATOR
                     || ' '
                     || ARCONDITIONS.RULEVALUE1;
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQLSTRING,
                                   IAPICONSTANT.INFOLEVEL_3 );

      EXECUTE IMMEDIATE LSSQLSTRING
                   INTO LNRETBOOLEAN;

      IF LNRETBOOLEAN = 1
      THEN
         ABRESULT := 1;
         ANERRORCODE := IAPICONSTANTDBERROR.DBERR_SUCCESS;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      ELSE
         ABRESULT := 0;
         ANERRORCODE := IAPICONSTANTDBERROR.DBERR_MANUALCONDNOTSATISFIED;
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_MANUALCONDNOTSATISFIED );
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         ABRESULT := 0;
         ANERRORCODE := IAPICONSTANTDBERROR.DBERR_MANUALCONDNOTSATISFIED;
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_MANUALCONDNOTSATISFIED );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ABRESULT := 0;
         ANERRORCODE := IAPICONSTANTDBERROR.DBERR_GENFAIL;
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EVALUATEMANUALCONDITION;

   
   
   
   FUNCTION EVALUATECONDITION(
      ASCONDITION                IN       IAPITYPE.STRING_TYPE,
      ABRESULT                   IN OUT   IAPITYPE.BOOLEAN_TYPE,
      ANERRORCODE                IN OUT   IAPITYPE.SEQUENCENR_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'EvaluateCondition';
      LSSQL                         IAPITYPE.STRING_TYPE;
      LSRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
       
       
       
       
       
       
       
       
       
       
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'SELECT 1 FROM DUAL WHERE '
               || ASCONDITION;
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      EXECUTE IMMEDIATE LSSQL
                   INTO ABRESULT;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         ABRESULT := 0;
         ANERRORCODE := IAPICONSTANTDBERROR.DBERR_FOODCLAIMNOTSATISFIED;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      WHEN OTHERS
      THEN
         ABRESULT := 0;
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EVALUATECONDITION;

   
   
   
   
   FUNCTION EVALUATECRITERIA(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANCRITID                   IN       IAPITYPE.SEQUENCENR_TYPE,
      ABRESULT                   IN OUT   IAPITYPE.BOOLEAN_TYPE,
      ANERRORCODE                IN OUT   IAPITYPE.SEQUENCENR_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      CURSOR LCKEYS(
         CNKEY                               IAPITYPE.SEQUENCENR_TYPE )
      IS
         SELECT     LEVEL,
                       LPAD( ' ',
                               8
                             * (   LEVEL
                                 - 1 ) )
                    || K.DESCRIPTION DESCRIPTION,
                    K.FOOD_CLAIM_CRIT_KEY_ID,
                    D.SEQ_NO,
                    D.REF_TYPE,
                    D.REF_ID,
                    D.AND_OR
               FROM ITFOODCLAIMCRITKEY K,
                    ITFOODCLAIMCRITKEYD D
              WHERE D.FOOD_CLAIM_CRIT_KEY_ID = K.FOOD_CLAIM_CRIT_KEY_ID
                AND K.STATUS = IAPICONSTANT.FOODCLAIMS_STATUSNONHISTORIC
         CONNECT BY (     PRIOR D.REF_ID = K.FOOD_CLAIM_CRIT_KEY_ID
                      AND PRIOR D.REF_TYPE = IAPICONSTANT.REFTYPE_MANUALCOND )
         START WITH K.FOOD_CLAIM_CRIT_KEY_ID = CNKEY
           ORDER BY LEVEL,
                    D.SEQ_NO;

      
      TYPE LTKEYSTABLE IS TABLE OF LCKEYS%ROWTYPE
         INDEX BY BINARY_INTEGER;

      
      CURSOR LCRUNKEYS(
         CNWEBRQ                             IAPITYPE.SEQUENCENR_TYPE,
         CNKEYID                             IAPITYPE.SEQUENCENR_TYPE )
      IS
         SELECT KEY_ID,
                KEY_OPERATOR,
                KEY_VALUE
           FROM ITFOODCLAIMRUNCRIT RK
          WHERE KEY_TYPE = IAPICONSTANT.KEYTYPE_KEYWORD
            AND KEY_ID = CNKEYID
            AND RK.REQ_ID = CNWEBRQ;

      
      TYPE LTRUNKEYSTABLE IS TABLE OF LCRUNKEYS%ROWTYPE
         INDEX BY BINARY_INTEGER;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'EvaluateCriteria';
      LTKEYS                        LTKEYSTABLE;
      LTRUNKEYS                     LTRUNKEYSTABLE;
      LSKEYSCONDITIONS              IAPITYPE.STRING_TYPE := '';
      LSCONDITION                   IAPITYPE.STRING_TYPE := '';
      LSREFERENCEAMOUNT             IAPITYPE.STRING_TYPE := '';
      LSREFERENCEAMOUNTUOM          IAPITYPE.STRING_TYPE := '';
      LSFOODTYPEID                  IAPITYPE.SEQUENCENR_TYPE;
      LNLEVEL                       IAPITYPE.SEQUENCENR_TYPE;
      LTCONDITIONS                  ITFOODCLAIMCRITKEYCD%ROWTYPE;
      LTKW                          ITKW%ROWTYPE;
      LNCONDITIONPASSED             IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      OPEN LCKEYS( ANCRITID );

      FETCH LCKEYS
      BULK COLLECT INTO LTKEYS;

      CLOSE LCKEYS;

      IF ( LTKEYS.COUNT > 0 )
      THEN
         
         LNLEVEL := 1;

         FOR ICON IN LTKEYS.FIRST .. LTKEYS.LAST
         LOOP
            
            FOR IBRACKET IN LNLEVEL ..(   LTKEYS( ICON ).LEVEL
                                        - 1 )
            LOOP
               LSKEYSCONDITIONS :=    LSKEYSCONDITIONS
                                   || '(';
            END LOOP;

            
            FOR IBRACKET IN LTKEYS( ICON ).LEVEL ..(   LNLEVEL
                                                     - 1 )
            LOOP
               LSKEYSCONDITIONS :=    LSKEYSCONDITIONS
                                   || ')';
            END LOOP;

            LNLEVEL := LTKEYS( ICON ).LEVEL;
            
            LSKEYSCONDITIONS :=    LSKEYSCONDITIONS
                                || ' '
                                || LTKEYS( ICON ).AND_OR
                                || ' ';

            
            IF LTKEYS( ICON ).REF_TYPE = IAPICONSTANT.REFTYPE_CRITRULES
            THEN
               
               SELECT CD.FOOD_CLAIM_CRIT_KEY_CD_ID,
                      CD.DESCRIPTION,
                      CD.KEY_TYPE,
                      CD.KEY_ID,
                      CD.KEY_OPERATOR,
                      CD.KEY_VALUE,
                      CD.KEY_UOM,
                      CD.INTL,
                      CD.STATUS,
                      KW.KW_ID,
                      KW.DESCRIPTION,
                      KW.KW_TYPE,
                      KW.INTL,
                      KW.STATUS,
                      KW.KW_USAGE
                 INTO LTCONDITIONS.FOOD_CLAIM_CRIT_KEY_CD_ID,
                      LTCONDITIONS.DESCRIPTION,
                      LTCONDITIONS.KEY_TYPE,
                      LTCONDITIONS.KEY_ID,
                      LTCONDITIONS.KEY_OPERATOR,
                      LTCONDITIONS.KEY_VALUE,
                      LTCONDITIONS.KEY_UOM,
                      LTCONDITIONS.INTL,
                      LTCONDITIONS.STATUS,
                      LTKW.KW_ID,
                      LTKW.DESCRIPTION,
                      LTKW.KW_TYPE,
                      LTKW.INTL,
                      LTKW.STATUS,
                      LTKW.KW_USAGE
                 FROM ITFOODCLAIMCRITKEYCD CD,
                      ITKW KW
                WHERE LTKEYS( ICON ).REF_ID = CD.FOOD_CLAIM_CRIT_KEY_CD_ID
                  AND CD.KEY_ID = KW.KW_ID(+)
                  AND CD.STATUS = IAPICONSTANT.FOODCLAIMS_STATUSNONHISTORIC;

               LNCONDITIONPASSED := IAPICONSTANTDBERROR.DBERR_GENFAIL;

               
               CASE LTCONDITIONS.KEY_TYPE
                  
               WHEN IAPICONSTANT.KEYTYPE_FOODTYPE
                  THEN
                     BEGIN
                        IAPIGENERAL.LOGINFO( GSSOURCE,
                                             LSMETHOD,
                                             'Food Type check',
                                             IAPICONSTANT.INFOLEVEL_3 );

                        
                        SELECT KEY_ID
                          INTO LSFOODTYPEID
                          FROM ITFOODCLAIMRUNCRIT
                         WHERE ( KEY_TYPE = 1 )
                           AND ( REQ_ID = ANWEBRQ );

                        LSCONDITION :=    '('
                                       || LSFOODTYPEID
                                       || ' = '
                                       || LTCONDITIONS.KEY_VALUE
                                       || ')';
                        LNCONDITIONPASSED := EVALUATECONDITION( LSCONDITION,
                                                                ABRESULT,
                                                                ANERRORCODE );
                        IAPIGENERAL.LOGINFO( GSSOURCE,
                                             LSMETHOD,
                                                'Food Type check result = '
                                             || ABRESULT,
                                             IAPICONSTANT.INFOLEVEL_3 );

                        IF ( LNCONDITIONPASSED = IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IF ABRESULT = 1
                           THEN
                              LSKEYSCONDITIONS :=    LSKEYSCONDITIONS
                                                  || '(1 = 1)';
                           ELSE
                              LSKEYSCONDITIONS :=    LSKEYSCONDITIONS
                                                  || '(1 = 0)';
                           END IF;
                        ELSE
                           LSKEYSCONDITIONS :=    LSKEYSCONDITIONS
                                               || '(1 = 0)';
                        END IF;
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           IAPIGENERAL.LOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                'Food Type NOT SPECIFIED',
                                                IAPICONSTANT.INFOLEVEL_3 );
                           LSKEYSCONDITIONS :=    LSKEYSCONDITIONS
                                               || '(1 = 0)';
                     END;
                  
               WHEN IAPICONSTANT.KEYTYPE_REFAMOUNT
                  THEN
                     BEGIN
                        IAPIGENERAL.LOGINFO( GSSOURCE,
                                             LSMETHOD,
                                             'Refernce Amount check',
                                             IAPICONSTANT.INFOLEVEL_3 );

                        
                        SELECT KEY_VALUE,
                               KEY_UOM
                          INTO LSREFERENCEAMOUNT,
                               LSREFERENCEAMOUNTUOM
                          FROM ITFOODCLAIMRUNCRIT
                         WHERE ( KEY_TYPE = 2 )
                           AND ( REQ_ID = ANWEBRQ );

                        LSCONDITION :=
                              '(('
                           || LSREFERENCEAMOUNT
                           || ' '
                           || LTCONDITIONS.KEY_OPERATOR
                           || ' '
                           || LTCONDITIONS.KEY_VALUE
                           || ') AND ('''
                           || LSREFERENCEAMOUNTUOM
                           || ''' = '''
                           || LTCONDITIONS.KEY_UOM
                           || ''')) ';
                        LNCONDITIONPASSED := EVALUATECONDITION( LSCONDITION,
                                                                ABRESULT,
                                                                ANERRORCODE );
                        IAPIGENERAL.LOGINFO( GSSOURCE,
                                             LSMETHOD,
                                                'Reference Amount result = '
                                             || ABRESULT,
                                             IAPICONSTANT.INFOLEVEL_3 );

                        IF ( LNCONDITIONPASSED = IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IF ABRESULT = 1
                           THEN
                              LSKEYSCONDITIONS :=    LSKEYSCONDITIONS
                                                  || '(1 = 1)';
                           ELSE
                              LSKEYSCONDITIONS :=    LSKEYSCONDITIONS
                                                  || '(1 = 0)';
                           END IF;
                        ELSE
                           LSKEYSCONDITIONS :=    LSKEYSCONDITIONS
                                               || '(1 = 0)';
                        END IF;
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           IAPIGENERAL.LOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                'Refernce Amount NOT SPECIFIED',
                                                IAPICONSTANT.INFOLEVEL_3 );
                           LSKEYSCONDITIONS :=    LSKEYSCONDITIONS
                                               || '(1 = 0)';
                     END;
                  
               WHEN IAPICONSTANT.KEYTYPE_KEYWORD
                  THEN
                     BEGIN
                        IAPIGENERAL.LOGINFO( GSSOURCE,
                                             LSMETHOD,
                                                'Keyword check (ID = '
                                             || LTCONDITIONS.KEY_ID
                                             || ', VALUE = '
                                             || LTCONDITIONS.KEY_VALUE
                                             || ')',
                                             IAPICONSTANT.INFOLEVEL_3 );

                        
                        OPEN LCRUNKEYS( ANWEBRQ,
                                        LTCONDITIONS.KEY_ID );

                        FETCH LCRUNKEYS
                        BULK COLLECT INTO LTRUNKEYS;

                        CLOSE LCRUNKEYS;

                        IAPIGENERAL.LOGINFO( GSSOURCE,
                                             LSMETHOD,
                                                'ltRunKeys.COUNT = '
                                             || LTRUNKEYS.COUNT,
                                             IAPICONSTANT.INFOLEVEL_3 );

                        IF ( LTRUNKEYS.COUNT > 0 )
                        THEN
                           
                           FOR IRUNKEY IN LTRUNKEYS.FIRST .. LTRUNKEYS.LAST
                           LOOP
                              IF ( LTKW.KW_TYPE = 1 )
                              THEN
                                 LSCONDITION :=    '('
                                                || LTRUNKEYS( IRUNKEY ).KEY_VALUE
                                                || ' = '
                                                || LTCONDITIONS.KEY_VALUE
                                                || ')';
                              ELSE
                                 LSCONDITION :=    '('''
                                                || LTRUNKEYS( IRUNKEY ).KEY_VALUE
                                                || ''' = '''
                                                || LTCONDITIONS.KEY_VALUE
                                                || ''')';
                              END IF;

                              LNCONDITIONPASSED := EVALUATECONDITION( LSCONDITION,
                                                                      ABRESULT,
                                                                      ANERRORCODE );
                              EXIT WHEN( ABRESULT = 1 );
                           END LOOP;

                           IAPIGENERAL.LOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                   'Keyword check (ID = '
                                                || LTCONDITIONS.KEY_ID
                                                || ', VALUE = '
                                                || LTCONDITIONS.KEY_VALUE
                                                || ') result = '
                                                || ABRESULT,
                                                IAPICONSTANT.INFOLEVEL_3 );

                           IF ( LNCONDITIONPASSED = IAPICONSTANTDBERROR.DBERR_SUCCESS )
                           THEN
                              IF ABRESULT = 1
                              THEN
                                 LSKEYSCONDITIONS :=    LSKEYSCONDITIONS
                                                     || '(1 = 1)';
                              ELSE
                                 LSKEYSCONDITIONS :=    LSKEYSCONDITIONS
                                                     || '(1 = 0)';
                              END IF;
                           ELSE
                              LSKEYSCONDITIONS :=    LSKEYSCONDITIONS
                                                  || '(1 = 0)';
                           END IF;
                        ELSE
                           IAPIGENERAL.LOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                   'Keyword (ID = '
                                                || LTCONDITIONS.KEY_ID
                                                || ') NOT SPECIFIED',
                                                IAPICONSTANT.INFOLEVEL_3 );
                           LSKEYSCONDITIONS :=    LSKEYSCONDITIONS
                                               || '(1 = 0)';
                        END IF;
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           IAPIGENERAL.LOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                   'Keyword (ID = '
                                                || LTCONDITIONS.KEY_ID
                                                || ') NOT SPECIFIED',
                                                IAPICONSTANT.INFOLEVEL_3 );
                           LSKEYSCONDITIONS :=    LSKEYSCONDITIONS
                                               || '(1 = 0)';
                     END;
               END CASE;
            END IF;
         END LOOP;

         
         FOR IBRACKET IN 1 ..   LNLEVEL
                              - 1
         LOOP
            LSKEYSCONDITIONS :=    LSKEYSCONDITIONS
                                || ')';
         END LOOP;

         
         RETURN EVALUATECONDITION( LSKEYSCONDITIONS,
                                   ABRESULT,
                                   ANERRORCODE );
      ELSE
         
         ABRESULT := 1;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ABRESULT := 0;
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EVALUATECRITERIA;

   
   
   
   FUNCTION EVALUATEDETAIL(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANLOGID                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANFOODCLAIMID              IN       IAPITYPE.SEQUENCENR_TYPE,
      ARRUN                      IN       IAPITYPE.FOODCLAIMRUNREC_TYPE,
      ARPROFILES                 IN       IAPITYPE.FOODCLAIMPROFILEREC_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      CURSOR LCDETAILS(
         CNFOODCLAIMID                       IAPITYPE.ID_TYPE )
      IS
         SELECT *
           FROM ITFOODCLAIMD
          WHERE FOOD_CLAIM_ID = CNFOODCLAIMID
            AND (     ( REF_TYPE = IAPICONSTANT.REFTYPE_LABELS )
                  OR ( REF_TYPE = IAPICONSTANT.REFTYPE_NOTES )
                  OR ( REF_TYPE = IAPICONSTANT.REFTYPE_ALERTS ) );

      
      TYPE LTDETAILSTABLE IS TABLE OF LCDETAILS%ROWTYPE
         INDEX BY BINARY_INTEGER;

      CURSOR LCCLAIMSCRIT(
         ANFOODCLAIMCRITID                   IAPITYPE.SEQUENCENR_TYPE )
      IS
         SELECT   C.FOOD_CLAIM_CRIT_KEY_ID,
                  C.FOOD_CLAIM_CRIT_RULE_ID
             FROM ITFOODCLAIMCRIT C
            WHERE C.FOOD_CLAIM_CRIT_ID = ANFOODCLAIMCRITID
              AND C.STATUS = IAPICONSTANT.FOODCLAIMS_STATUSNONHISTORIC
         ORDER BY C.FOOD_CLAIM_CRIT_ID;

      
      TYPE LTCLAIMSTABLECRIT IS TABLE OF LCCLAIMSCRIT%ROWTYPE
         INDEX BY BINARY_INTEGER;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'EvaluateDetail';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRRUN                         IAPITYPE.FOODCLAIMRUNREC_TYPE;
      LRPROFILES                    IAPITYPE.FOODCLAIMPROFILEREC_TYPE;
      LNPARENTSEQUENCENO            IAPITYPE.SEQUENCENR_TYPE := 0;
      LTCLAIMSCRIT                  LTCLAIMSTABLECRIT;
      LTDETAILS                     LTDETAILSTABLE;
      LBCRITERIARESULT              IAPITYPE.BOOLEAN_TYPE;
      LBRULERESULT                  IAPITYPE.BOOLEAN_TYPE;
      LBNOTCLAIM                    IAPITYPE.BOOLEAN_TYPE DEFAULT 1;
      LNERRORCODE                   IAPITYPE.ERRORNUM_TYPE;
      LNDETAILALREADYPASSED         IAPITYPE.NUMVAL_TYPE;
      LSCONDITIONS                  IAPITYPE.STRING_TYPE := '';
      LNHIERLEVEL                   IAPITYPE.HIERLEVEL_TYPE DEFAULT 0;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LRRUN := ARRUN;
      LRPROFILES := ARPROFILES;

      
      OPEN LCDETAILS( ANFOODCLAIMID );

      FETCH LCDETAILS
      BULK COLLECT INTO LTDETAILS;

      CLOSE LCDETAILS;

      IF ( LTDETAILS.COUNT > 0 )
      THEN
         FOR ICON IN LTDETAILS.FIRST .. LTDETAILS.LAST
         LOOP
            LBCRITERIARESULT := 0;
            LBRULERESULT := 0;

            
            SELECT COUNT( REF_ID )
              INTO LNDETAILALREADYPASSED
              FROM ITFOODCLAIMRUNCD
             WHERE FOOD_CLAIM_ID = ANFOODCLAIMID
               AND REQ_ID = ANWEBRQ
               AND REF_TYPE = LTDETAILS( ICON ).REF_TYPE
               AND REF_ID = LTDETAILS( ICON ).REF_ID
               AND LOG_ID = ANLOGID;

            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    'Evaluating Ref_Type = '
                                 || LTDETAILS( ICON ).REF_TYPE
                                 || ', Ref_Id = '
                                 || LTDETAILS( ICON ).REF_ID
                                 || ': count = '
                                 || LNDETAILALREADYPASSED,
                                 IAPICONSTANT.INFOLEVEL_3 );

            IF LNDETAILALREADYPASSED = 0
            THEN
               
               IF LTDETAILS( ICON ).FOOD_CLAIM_CRIT_ID IS NOT NULL
               THEN
                  
                  OPEN LCCLAIMSCRIT( LTDETAILS( ICON ).FOOD_CLAIM_CRIT_ID );

                  FETCH LCCLAIMSCRIT
                  BULK COLLECT INTO LTCLAIMSCRIT;

                  CLOSE LCCLAIMSCRIT;

                  IF ( LTCLAIMSCRIT.COUNT > 0 )
                  THEN
                     FOR ICONCRIT IN LTCLAIMSCRIT.FIRST .. LTCLAIMSCRIT.LAST
                     LOOP
                        IF LTCLAIMSCRIT( ICONCRIT ).FOOD_CLAIM_CRIT_KEY_ID IS NOT NULL
                        THEN
                           
                           LNRETVAL := EVALUATECRITERIA( ANWEBRQ,
                                                         LTCLAIMSCRIT( ICONCRIT ).FOOD_CLAIM_CRIT_KEY_ID,
                                                         LBCRITERIARESULT,
                                                         LNERRORCODE );
                           IAPIGENERAL.LOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                   'EvaluateCriteria = '
                                                || LBCRITERIARESULT
                                                || ' [Error =  '
                                                || LNERRORCODE
                                                || ']',
                                                IAPICONSTANT.INFOLEVEL_3 );
                        ELSE
                           LBCRITERIARESULT := 1;
                        END IF;

                        IF     ( LBCRITERIARESULT = 1 )
                           AND ( LTCLAIMSCRIT( ICONCRIT ).FOOD_CLAIM_CRIT_RULE_ID IS NOT NULL )
                        THEN
                           
                           LRRUN.FOODCLAIMCRITRULEID := LTCLAIMSCRIT( ICONCRIT ).FOOD_CLAIM_CRIT_RULE_ID;
                           LSCONDITIONS := '';
                           LNRETVAL :=
                              EXECUTERUNDETAIL( ANWEBRQ,
                                                LRRUN,
                                                LRPROFILES,
                                                LRRUN.FOODCLAIMID,
                                                ANLOGID,
                                                LNPARENTSEQUENCENO,
                                                LSCONDITIONS,
                                                LBRULERESULT,
                                                LNHIERLEVEL,
                                                LNERRORCODE,
                                                LBNOTCLAIM );

                           
                           DELETE FROM ITFOODCLAIMRESULTDETAIL
                                 WHERE NOT_CLAIM = LBNOTCLAIM;
                        ELSE
                           LBRULERESULT := 1;
                        END IF;
                     END LOOP;
                  ELSE
                     
                     LBCRITERIARESULT := 1;
                     LBRULERESULT := 1;
                  END IF;
               ELSE
                  
                  LBCRITERIARESULT := 1;
                  LBRULERESULT := 1;
               END IF;
            END IF;

            IF     LBCRITERIARESULT = 1
               AND LBRULERESULT = 1
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                       'Inserting Ref_Type = '
                                    || LTDETAILS( ICON ).REF_TYPE
                                    || ', Ref_Id = '
                                    || LTDETAILS( ICON ).REF_ID,
                                    IAPICONSTANT.INFOLEVEL_3 );

               
               INSERT INTO ITFOODCLAIMRUNCD
                           ( FOOD_CLAIM_ID,
                             REQ_ID,
                             REF_TYPE,
                             REF_ID,
                             LOG_ID )
                    VALUES ( ANFOODCLAIMID,
                             ANWEBRQ,
                             LTDETAILS( ICON ).REF_TYPE,
                             LTDETAILS( ICON ).REF_ID,
                             ANLOGID );
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
   END EVALUATEDETAIL;

   
   
   
   FUNCTION GETFOODCLAIMCOLUMNS(
      ASALIAS                    IN       IAPITYPE.STRING_TYPE DEFAULT '' )
      RETURN IAPITYPE.STRINGVAL_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetFoodClaimColumns';
      LCCOLUMNS                     IAPITYPE.SQLSTRING_TYPE := NULL;
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
      LCCOLUMNS :=
            LSALIAS
         || 'Food_Claim_Id '
         || IAPICONSTANTCOLUMN.FOODCLAIMIDCOL
         || ', '
         || 'f_foodclaim_descr('
         || LSALIAS
         || 'Food_Claim_Id, 0) '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ', '
         || LSALIAS
         || 'Relative '
         || IAPICONSTANTCOLUMN.RELATIVECOL
         || ', '
         || LSALIAS
         || 'Mandatory '
         || IAPICONSTANTCOLUMN.MANDATORYCOL
         || ', '
         || LSALIAS
         || 'Intl '
         || IAPICONSTANTCOLUMN.INTLCOL
         || ', '
         || LSALIAS
         || 'Status '
         || IAPICONSTANTCOLUMN.STATUSCOL;
      RETURN( LCCOLUMNS );
   END GETFOODCLAIMCOLUMNS;





   
   
   
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

   
   
   
   
   
   
   
   FUNCTION GETNUTLYGROUPS(
      AQGROUPS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetNutLyGroups';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
                                         :=    'SELECT '
                                            || '  Id '
                                            || IAPICONSTANTCOLUMN.IDCOL
                                            || ', Description '
                                            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM itNutLyGroup ';
      LSWHERENULL                   IAPITYPE.SQLSTRING_TYPE := ' WHERE 1 = 2';
      LSORDER                       IAPITYPE.SQLSTRING_TYPE := ' ORDER BY Description ASC ';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQGROUPS%ISOPEN )
      THEN
         CLOSE AQGROUPS;
      END IF;

      
      LSSQL :=    LSSELECT
               || LSFROM
               || LSWHERENULL;
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQGROUPS FOR LSSQL;

      
      IF ( AQGROUPS%ISOPEN )
      THEN
         CLOSE AQGROUPS;
      END IF;

      LSSQL :=    LSSELECT
               || LSFROM
               || LSORDER;
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQGROUPS FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF AQGROUPS%ISOPEN
         THEN
            CLOSE AQGROUPS;
         END IF;

         LSSQL :=    LSSELECT
                  || LSFROM
                  || LSWHERENULL;
         IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                      LSMETHOD,
                                      LSSQL,
                                      IAPICONSTANT.INFOLEVEL_3 );

         OPEN AQGROUPS FOR LSSQL;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETNUTLYGROUPS;

   
   
   
   FUNCTION GETKEYWORDS(
      AQKEYWORDS                 OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetKeyWords';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    'SELECT '
            || '  k.Kw_Id '
            || IAPICONSTANTCOLUMN.KEYWORDIDCOL
            || ', k.Description '
            || IAPICONSTANTCOLUMN.KEYWORDCOL
            || ', k.Kw_Type '
            || IAPICONSTANTCOLUMN.KEYWORDTYPECOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM itKw k ';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE := ' WHERE k.Kw_Usage = 6';
      LSWHERENULL                   IAPITYPE.SQLSTRING_TYPE := ' WHERE k.Kw_Usage IS NULL';
      LSORDER                       IAPITYPE.SQLSTRING_TYPE := ' ORDER BY k.Description ASC ';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQKEYWORDS%ISOPEN )
      THEN
         CLOSE AQKEYWORDS;
      END IF;

      
      LSSQL :=    LSSELECT
               || LSFROM
               || LSWHERENULL;
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQKEYWORDS FOR LSSQL;

      
      IF ( AQKEYWORDS%ISOPEN )
      THEN
         CLOSE AQKEYWORDS;
      END IF;

      LSSQL :=    LSSELECT
               || LSFROM
               || LSWHERE
               || LSORDER;
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQKEYWORDS FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF AQKEYWORDS%ISOPEN
         THEN
            CLOSE AQKEYWORDS;
         END IF;

         LSSQL :=    LSSELECT
                  || LSFROM
                  || LSWHERENULL;
         IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                      LSMETHOD,
                                      LSSQL,
                                      IAPICONSTANT.INFOLEVEL_3 );

         OPEN AQKEYWORDS FOR LSSQL;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETKEYWORDS;

   
   
   
   FUNCTION GETKEYWORDASSOCIATIONS(
      AQVALUES                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetKeyWordAssociations';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    'SELECT '
            || '  k.Kw_Id '
            || IAPICONSTANTCOLUMN.KEYWORDIDCOL
            || ', c.Ch_Id '
            || IAPICONSTANTCOLUMN.CHILDIDCOL
            || ', c.Description '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM itKw k, itKwAs a, itKwCh c ';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE :=    ' WHERE c.ch_id = a.ch_id '
                                                               || '   AND a.kw_id = k.kw_id '
                                                               || '   AND k.kw_usage = 6 ';
      LSWHERENULL                   IAPITYPE.SQLSTRING_TYPE := ' WHERE k.Kw_Usage IS NULL';
      LSORDER                       IAPITYPE.SQLSTRING_TYPE := ' ORDER BY k.kw_id, c.Description ASC ';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQVALUES%ISOPEN )
      THEN
         CLOSE AQVALUES;
      END IF;

      
      LSSQL :=    LSSELECT
               || LSFROM
               || LSWHERENULL;
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQVALUES FOR LSSQL;

      
      IF ( AQVALUES%ISOPEN )
      THEN
         CLOSE AQVALUES;
      END IF;

      LSSQL :=    LSSELECT
               || LSFROM
               || LSWHERE
               || LSORDER;
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQVALUES FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF AQVALUES%ISOPEN
         THEN
            CLOSE AQVALUES;
         END IF;

         LSSQL :=    LSSELECT
                  || LSFROM
                  || LSWHERENULL;

         OPEN AQVALUES FOR LSSQL;

         IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                      LSMETHOD,
                                      LSSQL,
                                      IAPICONSTANT.INFOLEVEL_3 );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETKEYWORDASSOCIATIONS;

   
   FUNCTION GETFOODCLAIM(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANPARENTFOODCLAIMID        IN       IAPITYPE.SEQUENCENR_TYPE,
      ANPARENTLOGID              IN       IAPITYPE.SEQUENCENR_TYPE,
      ANPARENTSEQNO              IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ANFOODCLAIMID              IN       IAPITYPE.SEQUENCENR_TYPE,
      ARRUN                      IN       IAPITYPE.FOODCLAIMRUNREC_TYPE,
      ARPROFILES                 IN       IAPITYPE.FOODCLAIMPROFILEREC_TYPE,
      ABRESULT                   IN OUT   IAPITYPE.BOOLEAN_TYPE,
      ANHIERLEVEL                IN OUT   IAPITYPE.HIERLEVEL_TYPE,
      ANERRORCODE                IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ABNOTCLAIM                 IN       IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetFoodClaim';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRRUN                         IAPITYPE.FOODCLAIMRUNREC_TYPE;
      LNINDEX                       IAPITYPE.NUMVAL_TYPE;
      LSCONDITIONS                  IAPITYPE.STRING_TYPE;
      LBFIRSTCOND                   IAPITYPE.LOGICAL_TYPE DEFAULT FALSE;

      CURSOR LCCLAIMS(
         ANFOODCLAIMID                       IAPITYPE.ID_TYPE )
      IS
         SELECT   FC.FOOD_CLAIM_ID,
                  D.REF_ID,
                  D.FOOD_CLAIM_CRIT_ID
             FROM ITFOODCLAIM FC,
                  ITFOODCLAIMD D
            WHERE FC.FOOD_CLAIM_ID = ANFOODCLAIMID
              AND FC.FOOD_CLAIM_ID = D.FOOD_CLAIM_ID
              AND FC.STATUS = IAPICONSTANT.FOODCLAIMS_STATUSNONHISTORIC
              AND D.REF_TYPE = IAPICONSTANT.REFTYPE_CRITRULES
         ORDER BY FC.FOOD_CLAIM_ID;

      
      TYPE LTCLAIMSTABLE IS TABLE OF LCCLAIMS%ROWTYPE
         INDEX BY BINARY_INTEGER;

      LTCLAIMS                      LTCLAIMSTABLE;

      CURSOR LCCLAIMSCRIT(
         ANFOODCLAIMCRITID                   IAPITYPE.SEQUENCENR_TYPE )
      IS
         SELECT   C.FOOD_CLAIM_CRIT_KEY_ID
             FROM ITFOODCLAIMCRIT C
            WHERE C.FOOD_CLAIM_CRIT_ID = ANFOODCLAIMCRITID
              AND C.STATUS = IAPICONSTANT.FOODCLAIMS_STATUSNONHISTORIC
         ORDER BY C.FOOD_CLAIM_CRIT_ID;

      
      TYPE LTCLAIMSTABLECRIT IS TABLE OF LCCLAIMSCRIT%ROWTYPE
         INDEX BY BINARY_INTEGER;

      LTCLAIMSCRIT                  LTCLAIMSTABLECRIT;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LRRUN := ARRUN;

      OPEN LCCLAIMS( ANFOODCLAIMID );

      FETCH LCCLAIMS
      BULK COLLECT INTO LTCLAIMS;

      CLOSE LCCLAIMS;

      IF ( LTCLAIMS.COUNT > 0 )
      THEN
         
         FOR ICON IN LTCLAIMS.FIRST .. LTCLAIMS.LAST
         LOOP
            OPEN LCCLAIMSCRIT( LTCLAIMS( ICON ).FOOD_CLAIM_CRIT_ID );

            FETCH LCCLAIMSCRIT
            BULK COLLECT INTO LTCLAIMSCRIT;

            CLOSE LCCLAIMSCRIT;

            IF ( LTCLAIMSCRIT.COUNT = 0 )
            THEN
               IF NOT LBFIRSTCOND
               THEN
                  LBFIRSTCOND := TRUE;
                  LNINDEX := ICON;
               ELSE
                  ABRESULT := 0;
                  ANERRORCODE := IAPICONSTANTDBERROR.DBERR_FOODCLAIMMULTRULESFOUND;
                  RETURN( IAPICONSTANTDBERROR.DBERR_FOODCLAIMMULTRULESFOUND );
               END IF;
            ELSE
               IF ( LTCLAIMSCRIT.COUNT > 0 )
               THEN
                  FOR ICONCRIT IN LTCLAIMSCRIT.FIRST .. LTCLAIMSCRIT.LAST
                  LOOP
                     IF LTCLAIMSCRIT( ICONCRIT ).FOOD_CLAIM_CRIT_KEY_ID IS NOT NULL
                     THEN
                        
                        LNRETVAL := EVALUATECRITERIA( ANWEBRQ,
                                                      LTCLAIMSCRIT( ICONCRIT ).FOOD_CLAIM_CRIT_KEY_ID,
                                                      ABRESULT,
                                                      ANERRORCODE );

                        IF LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS
                        THEN
                           IF ABRESULT = 1
                           THEN
                              IF NOT LBFIRSTCOND
                              THEN
                                 LBFIRSTCOND := TRUE;
                                 LNINDEX := ICON;
                              ELSE
                                 ABRESULT := 0;
                                 ANERRORCODE := IAPICONSTANTDBERROR.DBERR_FOODCLAIMMULTRULESFOUND;
                                 RETURN( IAPICONSTANTDBERROR.DBERR_FOODCLAIMMULTRULESFOUND );
                              END IF;
                           END IF;
                        ELSE
                           ABRESULT := 0;
                           ANERRORCODE := LNRETVAL;
                           RETURN( LNRETVAL );
                        END IF;
                     ELSE
                        IF NOT LBFIRSTCOND
                        THEN
                           LBFIRSTCOND := TRUE;
                           LNINDEX := ICON;
                        ELSE
                           ABRESULT := 0;
                           ANERRORCODE := IAPICONSTANTDBERROR.DBERR_FOODCLAIMMULTRULESFOUND;
                           RETURN( IAPICONSTANTDBERROR.DBERR_FOODCLAIMMULTRULESFOUND );
                        END IF;
                     END IF;
                  END LOOP;
               END IF;
            END IF;
         END LOOP;
      ELSE
         ABRESULT := 0;
         ANERRORCODE := IAPICONSTANTDBERROR.DBERR_FOODCLAIMNORULESFOUND;
         RETURN( IAPICONSTANTDBERROR.DBERR_FOODCLAIMNORULESFOUND );
      END IF;

      IF NOT LBFIRSTCOND
      THEN
         ABRESULT := 0;
         ANERRORCODE := IAPICONSTANTDBERROR.DBERR_FOODCLAIMNORULESFOUND;
         RETURN( IAPICONSTANTDBERROR.DBERR_FOODCLAIMNORULESFOUND );
      END IF;

      ABRESULT := 0;
      ANERRORCODE := 0;
      LRRUN.FOODCLAIMID := LTCLAIMS( LNINDEX ).FOOD_CLAIM_ID;
      LRRUN.REQUESTID := ANWEBRQ;
      LRRUN.INCLUDE := 1;
      LRRUN.ERRORCODE := 0;
      LRRUN.FOODCLAIMCRITRULEID := LTCLAIMS( LNINDEX ).REF_ID;
      LNRETVAL :=
         EXECUTERUNDETAIL( ANWEBRQ,
                           LRRUN,
                           ARPROFILES,
                           ANPARENTFOODCLAIMID,
                           ANPARENTLOGID,
                           ANPARENTSEQNO,
                           LSCONDITIONS,
                           ABRESULT,
                           ANHIERLEVEL,
                           ANERRORCODE,
                           ABNOTCLAIM );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETFOODCLAIM;

   
   
   
   
   
   FUNCTION GETFOODCLAIMS(
      AQFOODCLAIMS               OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetFoodClaims';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETFOODCLAIMCOLUMNS( 'f' );
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM ITFOODCLAIM f ';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE :=    ' WHERE status = '
                                                               || IAPICONSTANT.FOODCLAIMS_STATUSNONHISTORIC;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'Select '
               || LSSELECT
               || LSFROM
               || ' WHERE 1=2 ';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQFOODCLAIMS FOR LSSQL;

      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE;
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      IF ( AQFOODCLAIMS%ISOPEN )
      THEN
         CLOSE AQFOODCLAIMS;
      END IF;

      OPEN AQFOODCLAIMS FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'Select '
                  || LSSELECT
                  || LSFROM
                  || ' WHERE 1=2 ';
         IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                      LSMETHOD,
                                      LSSQL,
                                      IAPICONSTANT.INFOLEVEL_3 );

         IF AQFOODCLAIMS%ISOPEN
         THEN
            CLOSE AQFOODCLAIMS;
         END IF;

         OPEN AQFOODCLAIMS FOR LSSQL;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETFOODCLAIMS;

   
   
   
   
   
   
   
   FUNCTION GETFOODCLAIMS(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ATKEYWORDFILTER            IN       IAPITYPE.FOODCLAIMRUNCRITTAB_TYPE,
      AQFOODCLAIMS               OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetFoodClaims';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRFILTER                      IAPITYPE.FOODCLAIMRUNCRITREC_TYPE;
      LSFILTERKEYWORD               IAPITYPE.CLOB_TYPE;
      LSFILTERTOADD                 IAPITYPE.STRING_TYPE := NULL;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETFOODCLAIMCOLUMNS( 'f' );
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM itFoodClaim f, itFoodClaimRun r ';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE
         :=    ' WHERE f.Food_Claim_Id = r.Food_Claim_Id '
            || ' AND f.status = '
            || IAPICONSTANT.FOODCLAIMS_STATUSNONHISTORIC
            || ' AND r.Include = 1 '
            || ' AND r.Req_Id = '
            || ANWEBRQ;
      LSINSERT                      IAPITYPE.SQLSTRING_TYPE
         :=    'INSERT INTO itFoodClaimRun (Food_Claim_Id, '
            || ' Req_Id, Include, Food_Claim_Crit_Rule_Id) SELECT f.Food_Claim_Id, '
            || ANWEBRQ
            || ', 1, fd.ref_id FROM itFoodClaim f, itfoodclaimd fd ';
      LNCLAIMCRITPASSED             IAPITYPE.ID_TYPE;
      LBRESULT                      IAPITYPE.BOOLEAN_TYPE;
      LNERRORCODE                   IAPITYPE.ERRORNUM_TYPE;

      CURSOR LCCLAIMS
      IS
         SELECT   FC.FOOD_CLAIM_ID,
                  FC.MANDATORY
             FROM ITFOODCLAIM FC
            WHERE FC.STATUS = IAPICONSTANT.FOODCLAIMS_STATUSNONHISTORIC
         ORDER BY FC.FOOD_CLAIM_ID;

      
      TYPE LTCLAIMSTABLE IS TABLE OF LCCLAIMS%ROWTYPE
         INDEX BY BINARY_INTEGER;

      LTCLAIMS                      LTCLAIMSTABLE;

      CURSOR LCCLAIMSD(
         ANFOODCLAIMID                       IAPITYPE.SEQUENCENR_TYPE )
      IS
         SELECT   D.REF_ID,
                  D.FOOD_CLAIM_CRIT_ID
             FROM ITFOODCLAIMD D
            WHERE D.FOOD_CLAIM_ID = ANFOODCLAIMID
              AND D.REF_TYPE = IAPICONSTANT.REFTYPE_CRITRULES
         ORDER BY D.FOOD_CLAIM_ID;

      TYPE LTCLAIMSTABLED IS TABLE OF LCCLAIMSD%ROWTYPE
         INDEX BY BINARY_INTEGER;

      LTCLAIMSD                     LTCLAIMSTABLED;

      CURSOR LCCLAIMSCRIT(
         ANFOODCLAIMCRITID                   IAPITYPE.SEQUENCENR_TYPE )
      IS
         SELECT   C.FOOD_CLAIM_CRIT_KEY_ID
             FROM ITFOODCLAIMCRIT C
            WHERE C.FOOD_CLAIM_CRIT_ID = ANFOODCLAIMCRITID
              AND C.STATUS = IAPICONSTANT.FOODCLAIMS_STATUSNONHISTORIC
         ORDER BY C.FOOD_CLAIM_CRIT_ID;

      
      TYPE LTCLAIMSTABLECRIT IS TABLE OF LCCLAIMSCRIT%ROWTYPE
         INDEX BY BINARY_INTEGER;

      LTCLAIMSCRIT                  LTCLAIMSTABLECRIT;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      DELETE FROM ITFOODCLAIMRUN
            WHERE REQ_ID = ANWEBRQ;

      DELETE FROM ITFOODCLAIMRUNCRIT
            WHERE REQ_ID = ANWEBRQ;

      
      IF ( AQFOODCLAIMS%ISOPEN )
      THEN
         CLOSE AQFOODCLAIMS;
      END IF;

      LSSELECT :=
            'f.Food_Claim_Id '
         || IAPICONSTANTCOLUMN.FOODCLAIMIDCOL
         || ', '
         || 'f_foodclaim_descr('
         || 'f.Food_Claim_Id, 0) '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ', '
         || 'f.Relative '
         || IAPICONSTANTCOLUMN.RELATIVECOL
         || ', '
         || 'f.Mandatory '
         || IAPICONSTANTCOLUMN.MANDATORYCOL
         || ', '
         || 'f.Intl '
         || IAPICONSTANTCOLUMN.INTLCOL
         || ', '
         || 'f.Status '
         || IAPICONSTANTCOLUMN.STATUSCOL
         || ', '
         || 'r.ERROR_CODE '
         || IAPICONSTANTCOLUMN.ERRORCODECOL;
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || ' WHERE 1=2 ';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQFOODCLAIMS FOR LSSQL;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Copy keyowrds to runtime data',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      FOR I IN 0 ..   ATKEYWORDFILTER.COUNT
                    - 1
      LOOP
         LRFILTER := ATKEYWORDFILTER( I );

          
         
         INSERT INTO ITFOODCLAIMRUNCRIT
                     ( REQ_ID,
                       KEY_TYPE,
                       KEY_ID,
                       KEY_OPERATOR,
                       KEY_VALUE,
                       KEY_UOM )
              VALUES ( ANWEBRQ,
                       LRFILTER.KEYTYPE,
                       LRFILTER.KEYID,
                       LRFILTER.KEYOPERATOR,
                       LRFILTER.KEYVALUE,
                       LRFILTER.KEYUOM );
      END LOOP;

      
      OPEN LCCLAIMS;

      FETCH LCCLAIMS
      BULK COLLECT INTO LTCLAIMS;

      CLOSE LCCLAIMS;

      IF ( LTCLAIMS.COUNT > 0 )
      THEN
         
         FOR ICON IN LTCLAIMS.FIRST .. LTCLAIMS.LAST
         LOOP
            OPEN LCCLAIMSD( LTCLAIMS( ICON ).FOOD_CLAIM_ID );

            FETCH LCCLAIMSD
            BULK COLLECT INTO LTCLAIMSD;

            CLOSE LCCLAIMSD;

            IF ( LTCLAIMSD.COUNT > 0 )
            THEN
               
               FOR ICOND IN LTCLAIMSD.FIRST .. LTCLAIMSD.LAST
               LOOP
                  
                  SELECT COUNT( FOOD_CLAIM_ID )
                    INTO LNCLAIMCRITPASSED
                    FROM ITFOODCLAIMRUN
                   WHERE FOOD_CLAIM_ID = LTCLAIMS( ICON ).FOOD_CLAIM_ID
                     AND REQ_ID = ANWEBRQ;

                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                          'Evaluate claim ID = '
                                       || LTCLAIMS( ICON ).FOOD_CLAIM_ID,
                                       IAPICONSTANT.INFOLEVEL_3 );

                  OPEN LCCLAIMSCRIT( LTCLAIMSD( ICOND ).FOOD_CLAIM_CRIT_ID );

                  FETCH LCCLAIMSCRIT
                  BULK COLLECT INTO LTCLAIMSCRIT;

                  CLOSE LCCLAIMSCRIT;

                  IF ( LTCLAIMSCRIT.COUNT = 0 )
                  THEN
                     IF ( LNCLAIMCRITPASSED = 0 )   
                     THEN
                        INSERT INTO ITFOODCLAIMRUN
                                    ( FOOD_CLAIM_ID,
                                      REQ_ID,
                                      INCLUDE,
                                      FOOD_CLAIM_CRIT_RULE_ID )
                             VALUES ( LTCLAIMS( ICON ).FOOD_CLAIM_ID,
                                      ANWEBRQ,
                                      1,
                                      LTCLAIMSD( ICOND ).REF_ID );
                     ELSE   
                        UPDATE ITFOODCLAIMRUN
                           SET ERROR_CODE = IAPICONSTANTDBERROR.DBERR_MORETHANONECRITERIAFOUND
                         WHERE FOOD_CLAIM_ID = LTCLAIMS( ICON ).FOOD_CLAIM_ID
                           AND REQ_ID = ANWEBRQ;
                     END IF;
                  ELSE
                     IF ( LTCLAIMSCRIT.COUNT > 0 )
                     THEN
                        FOR ICONCRIT IN LTCLAIMSCRIT.FIRST .. LTCLAIMSCRIT.LAST
                        LOOP
                           IF LTCLAIMSCRIT( ICONCRIT ).FOOD_CLAIM_CRIT_KEY_ID IS NOT NULL
                           THEN
                              
                              LNRETVAL := EVALUATECRITERIA( ANWEBRQ,
                                                            LTCLAIMSCRIT( ICONCRIT ).FOOD_CLAIM_CRIT_KEY_ID,
                                                            LBRESULT,
                                                            LNERRORCODE );

                              IF LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS
                              THEN
                                 IF LBRESULT = 1
                                 THEN
                                    IAPIGENERAL.LOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                            'Insert claim ID = '
                                                         || LTCLAIMS( ICON ).FOOD_CLAIM_ID
                                                         || ' into ITFOODCLAIMRUN',
                                                         IAPICONSTANT.INFOLEVEL_3 );

                                    IF ( LNCLAIMCRITPASSED = 0 )   
                                    THEN
                                       INSERT INTO ITFOODCLAIMRUN
                                                   ( FOOD_CLAIM_ID,
                                                     REQ_ID,
                                                     INCLUDE,
                                                     FOOD_CLAIM_CRIT_RULE_ID )
                                            VALUES ( LTCLAIMS( ICON ).FOOD_CLAIM_ID,
                                                     ANWEBRQ,
                                                     1,
                                                     LTCLAIMSD( ICOND ).REF_ID );
                                    ELSE   
                                       UPDATE ITFOODCLAIMRUN
                                          SET ERROR_CODE = IAPICONSTANTDBERROR.DBERR_MORETHANONECRITERIAFOUND
                                        WHERE FOOD_CLAIM_ID = LTCLAIMS( ICON ).FOOD_CLAIM_ID
                                          AND REQ_ID = ANWEBRQ;
                                    END IF;
                                 END IF;
                              ELSE   
                                 LBRESULT := 0;
                                 LNERRORCODE := LNRETVAL;
                                 RETURN( LNRETVAL );
                              END IF;
                           ELSE   
                              IF ( LNCLAIMCRITPASSED = 0 )   
                              THEN
                                 INSERT INTO ITFOODCLAIMRUN
                                             ( FOOD_CLAIM_ID,
                                               REQ_ID,
                                               INCLUDE,
                                               FOOD_CLAIM_CRIT_RULE_ID )
                                      VALUES ( LTCLAIMS( ICON ).FOOD_CLAIM_ID,
                                               ANWEBRQ,
                                               1,
                                               LTCLAIMSD( ICOND ).REF_ID );
                              ELSE   
                                 UPDATE ITFOODCLAIMRUN
                                    SET ERROR_CODE = IAPICONSTANTDBERROR.DBERR_MORETHANONECRITERIAFOUND
                                  WHERE FOOD_CLAIM_ID = LTCLAIMS( ICON ).FOOD_CLAIM_ID
                                    AND REQ_ID = ANWEBRQ;
                              END IF;
                           END IF;
                        END LOOP;
                     END IF;
                  END IF;
               END LOOP;

               
               IF LTCLAIMS( ICON ).MANDATORY = 1
               THEN
                  SELECT COUNT( FOOD_CLAIM_ID )
                    INTO LNCLAIMCRITPASSED
                    FROM ITFOODCLAIMRUN
                   WHERE FOOD_CLAIM_ID = LTCLAIMS( ICON ).FOOD_CLAIM_ID;

                  IF ( LNCLAIMCRITPASSED = 0 )   
                  THEN
                     INSERT INTO ITFOODCLAIMRUN
                                 ( FOOD_CLAIM_ID,
                                   REQ_ID,
                                   INCLUDE,
                                   FOOD_CLAIM_CRIT_RULE_ID,
                                   ERROR_CODE )
                          VALUES ( LTCLAIMS( ICON ).FOOD_CLAIM_ID,
                                   ANWEBRQ,
                                   1,
                                   NULL,
                                   IAPICONSTANTDBERROR.DBERR_NOCRITERIAFOUND );
                  END IF;
               END IF;
            ELSE
               IF LTCLAIMS( ICON ).MANDATORY = 1
               THEN
                  INSERT INTO ITFOODCLAIMRUN
                              ( FOOD_CLAIM_ID,
                                REQ_ID,
                                INCLUDE,
                                FOOD_CLAIM_CRIT_RULE_ID,
                                ERROR_CODE )
                       VALUES ( LTCLAIMS( ICON ).FOOD_CLAIM_ID,
                                ANWEBRQ,
                                1,
                                NULL,
                                IAPICONSTANTDBERROR.DBERR_NOCRITERIAFOUND );
               END IF;
            END IF;
         END LOOP;
      END IF;

      
      IF ( AQFOODCLAIMS%ISOPEN )
      THEN
         CLOSE AQFOODCLAIMS;
      END IF;

      
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE
               || ' order by '
               || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQFOODCLAIMS FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF ( AQFOODCLAIMS%ISOPEN )
         THEN
            CLOSE AQFOODCLAIMS;
         END IF;

         LSSQL :=    'Select '
                  || LSSELECT
                  || LSFROM
                  || ' WHERE 1=2 ';
         IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                      LSMETHOD,
                                      LSSQL,
                                      IAPICONSTANT.INFOLEVEL_3 );

         OPEN AQFOODCLAIMS FOR LSSQL;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETFOODCLAIMS;

   
   
   
   
   
   
   
   FUNCTION GETFOODCLAIMS(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      AXKEYWORDFILTER            IN       IAPITYPE.XMLTYPE_TYPE,
      AQFOODCLAIMS               OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetFoodClaims';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTFILTER                      IAPITYPE.FOODCLAIMRUNCRITTAB_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETFOODCLAIMCOLUMNS( 'f' );
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM ITFOODCLAIM f ';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LQERRORS                      IAPITYPE.REF_TYPE;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( AQFOODCLAIMS%ISOPEN )
      THEN
         CLOSE AQFOODCLAIMS;
      END IF;

      LSSQL :=    'Select '
               || LSSELECT
               || LSFROM
               || ' WHERE 1=2 ';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQFOODCLAIMS FOR LSSQL;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := TRANSFORMXMLRUNKEYWORDS( AXKEYWORDFILTER,
                                           LTFILTER,
                                           LQERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := GETFOODCLAIMS( ANWEBRQ,
                                 LTFILTER,
                                 AQFOODCLAIMS );

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
         IF AQFOODCLAIMS%ISOPEN
         THEN
            CLOSE AQFOODCLAIMS;
         END IF;

         LSSQL :=    'Select '
                  || LSSELECT
                  || LSFROM
                  || ' WHERE 1=2 ';
         IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                      LSMETHOD,
                                      LSSQL,
                                      IAPICONSTANT.INFOLEVEL_3 );

         OPEN AQFOODCLAIMS FOR LSSQL;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETFOODCLAIMS;

   
   
   
   FUNCTION TRANSFORMXMLRUNKEYWORDS(
      AXRUNKEYWORDS              IN       IAPITYPE.XMLTYPE_TYPE,
      ATRUNKEYWORDS              OUT      IAPITYPE.FOODCLAIMRUNCRITTAB_TYPE,
      AQERRORS                   IN OUT NOCOPY IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'TransformXmlRunKeywords';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LXPARSER                      XMLPARSER.PARSER;
      LBPARSERCREATED               IAPITYPE.LOGICAL_TYPE;
      LXDOMDOCUMENT                 XMLDOM.DOMDOCUMENT;
      LXROOTELEMENT                 XMLDOM.DOMELEMENT;
      LXNODESLIST                   XMLDOM.DOMNODELIST;
      LXCDNODE                      XMLDOM.DOMNODE;
      LXITEMNODE                    XMLDOM.DOMNODE;
      LXITEMNODESLIST               XMLDOM.DOMNODELIST;
      LXELEMENT                     XMLDOM.DOMELEMENT;
      LXNODE                        XMLDOM.DOMNODE;
      LRRUNKEYWORD                  IAPITYPE.FOODCLAIMRUNCRITREC_TYPE;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      
      LXPARSER := XMLPARSER.NEWPARSER;
      LBPARSERCREATED := TRUE;
      XMLPARSER.SETVALIDATIONMODE( LXPARSER,
                                   FALSE );
      XMLPARSER.PARSECLOB( LXPARSER,
                           AXRUNKEYWORDS.GETCLOBVAL( ) );
      LXDOMDOCUMENT := XMLPARSER.GETDOCUMENT( LXPARSER );

      IF ( NOT XMLDOM.ISNULL( LXDOMDOCUMENT ) )
      THEN
         
         LXROOTELEMENT := XMLDOM.GETDOCUMENTELEMENT( LXDOMDOCUMENT );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'ROOT element <'
                              || XMLDOM.GETLOCALNAME( LXROOTELEMENT )
                              || '>' );
         
         LXNODESLIST := XMLDOM.GETELEMENTSBYTAGNAME( LXROOTELEMENT,
                                                     'Keyword' );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Number of filters <'
                              || XMLDOM.GETLENGTH( LXNODESLIST )
                              || '>' );

         
         FOR I IN 0 ..   XMLDOM.GETLENGTH( LXNODESLIST )
                       - 1
         LOOP
            LXCDNODE := XMLDOM.ITEM( LXNODESLIST,
                                     I );
            LRRUNKEYWORD := NULL;
            
            LXITEMNODESLIST := XMLDOM.GETCHILDNODES( LXCDNODE );

            FOR J IN 0 ..   XMLDOM.GETLENGTH( LXITEMNODESLIST )
                          - 1
            LOOP
               LXITEMNODE := XMLDOM.ITEM( LXITEMNODESLIST,
                                          J );
               
               LXNODE := XMLDOM.GETFIRSTCHILD( LXITEMNODE );

               IF ( XMLDOM.GETNODETYPE( LXNODE ) = XMLDOM.TEXT_NODE )
               THEN
                  CASE UPPER( XMLDOM.GETNODENAME( LXITEMNODE ) )
                     WHEN IAPICONSTANTCOLUMN.REQUESTIDCOL
                     THEN
                        LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                 LSMETHOD,
                                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
                           LNRETVAL :=
                              IAPIGENERAL.ADDERRORTOLIST(    ' <'
                                                          || IAPICONSTANTCOLUMN.REQUESTIDCOL
                                                          || '>',
                                                          IAPIGENERAL.GETLASTERRORTEXT( ),
                                                          GTERRORS );
                        ELSE
                           LRRUNKEYWORD.REQUESTID := XMLDOM.GETNODEVALUE( LXNODE );
                        END IF;
                     WHEN IAPICONSTANTCOLUMN.KEYTYPECOL
                     THEN
                        LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                 LSMETHOD,
                                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
                           LNRETVAL :=
                                IAPIGENERAL.ADDERRORTOLIST(    ' <'
                                                            || IAPICONSTANTCOLUMN.KEYTYPECOL
                                                            || '>',
                                                            IAPIGENERAL.GETLASTERRORTEXT( ),
                                                            GTERRORS );
                        ELSE
                           LRRUNKEYWORD.KEYTYPE := XMLDOM.GETNODEVALUE( LXNODE );
                        END IF;
                     WHEN IAPICONSTANTCOLUMN.KEYIDCOL
                     THEN
                        LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                 LSMETHOD,
                                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
                           LNRETVAL :=
                                  IAPIGENERAL.ADDERRORTOLIST(    ' <'
                                                              || IAPICONSTANTCOLUMN.KEYIDCOL
                                                              || '>',
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              GTERRORS );
                        ELSE
                           LRRUNKEYWORD.KEYID := XMLDOM.GETNODEVALUE( LXNODE );
                        END IF;
                     WHEN IAPICONSTANTCOLUMN.KEYOPERATORCOL
                     THEN
                        LNRETVAL := IAPIGENERAL.ISVALIDSTRING( XMLDOM.GETNODEVALUE( LXNODE ),
                                                               20 );

                        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                 LSMETHOD,
                                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
                           LNRETVAL :=
                              IAPIGENERAL.ADDERRORTOLIST(    ' <'
                                                          || IAPICONSTANTCOLUMN.KEYOPERATORCOL
                                                          || '>',
                                                          IAPIGENERAL.GETLASTERRORTEXT( ),
                                                          GTERRORS );
                        ELSE
                           LRRUNKEYWORD.KEYOPERATOR := XMLDOM.GETNODEVALUE( LXNODE );
                        END IF;
                     WHEN IAPICONSTANTCOLUMN.KEYVALUECOL
                     THEN
                        LNRETVAL := IAPIGENERAL.ISVALIDSTRING( XMLDOM.GETNODEVALUE( LXNODE ),
                                                               60 );

                        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                 LSMETHOD,
                                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
                           LNRETVAL :=
                               IAPIGENERAL.ADDERRORTOLIST(    ' <'
                                                           || IAPICONSTANTCOLUMN.KEYVALUECOL
                                                           || '>',
                                                           IAPIGENERAL.GETLASTERRORTEXT( ),
                                                           GTERRORS );
                        ELSE
                           LRRUNKEYWORD.KEYVALUE := XMLDOM.GETNODEVALUE( LXNODE );
                        END IF;
                     WHEN IAPICONSTANTCOLUMN.KEYUOMCOL
                     THEN
                        LNRETVAL := IAPIGENERAL.ISVALIDSTRING( XMLDOM.GETNODEVALUE( LXNODE ),
                                                               60 );

                        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                 LSMETHOD,
                                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
                           LNRETVAL :=
                                 IAPIGENERAL.ADDERRORTOLIST(    ' <'
                                                             || IAPICONSTANTCOLUMN.KEYUOMCOL
                                                             || '>',
                                                             IAPIGENERAL.GETLASTERRORTEXT( ),
                                                             GTERRORS );
                        ELSE
                           LRRUNKEYWORD.KEYUOM := XMLDOM.GETNODEVALUE( LXNODE );
                        END IF;
                     ELSE
                        NULL;
                  END CASE;
               END IF;
            END LOOP;

            ATRUNKEYWORDS( ATRUNKEYWORDS.COUNT ) := LRRUNKEYWORD;
         END LOOP;
      END IF;

      
      XMLDOM.FREEDOCUMENT( LXDOMDOCUMENT );
      
      XMLPARSER.FREEPARSER( LXPARSER );

      IF GTERRORS.COUNT = 0
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      ELSIF GTERRORS.COUNT > 0
      THEN
         ATRUNKEYWORDS.DELETE;
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_ERRORLIST );
      END IF;
   EXCEPTION
      WHEN SELF_IS_NULL
      THEN
         
         ATRUNKEYWORDS.DELETE;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END TRANSFORMXMLRUNKEYWORDS;

   
   
   
   FUNCTION GETNOTES(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANLOGID                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANFOODCLAIMID                       IAPITYPE.SEQUENCENR_TYPE,
      AQNOTES                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetNotes';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    'rd.Food_Claim_Id '
            || IAPICONSTANTCOLUMN.FOODCLAIMIDCOL
            || ', n.Food_Claim_Note_Id '
            || IAPICONSTANTCOLUMN.FOODCLAIMNOTEIDCOL
            || ', f_foodclaimnote_descr( n.Food_Claim_Note_Id, 0 ) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', f_foodclaimnote_long_descr( n.Food_Claim_Note_Id, 0 ) '
            || IAPICONSTANTCOLUMN.LONGDESCRIPTIONCOL
            || ', n.Intl '
            || IAPICONSTANTCOLUMN.INTLCOL
            || ', n.Status '
            || IAPICONSTANTCOLUMN.STATUSCOL
            || ', rd.Log_Id '
            || IAPICONSTANTCOLUMN.LOGIDCOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE :=    ' FROM ITFOODCLAIMNOTE n, '
                                                               || ' ItFoodClaimRunCd rd';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE
         :=    ' WHERE rd.Ref_Type = '
            || IAPICONSTANT.REFTYPE_NOTES
            || ' '
            || ' AND n.Food_Claim_Note_Id = rd.Ref_Id '
            || ' and n.status = '
            || IAPICONSTANT.FOODCLAIMS_STATUSNONHISTORIC
            || ' AND rd.Food_Claim_Id = '
            || ANFOODCLAIMID
            || ' AND rd.Log_Id = '
            || ANLOGID
            || ' AND rd.Req_Id = '
            || ANWEBRQ;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'Select '
               || LSSELECT
               || LSFROM
               || ' WHERE 1=2 ';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQNOTES FOR LSSQL;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE;
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      IF ( AQNOTES%ISOPEN )
      THEN
         CLOSE AQNOTES;
      END IF;

      OPEN AQNOTES FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'Select '
                  || LSSELECT
                  || LSFROM
                  || ' WHERE 1=2 ';
         IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                      LSMETHOD,
                                      LSSQL,
                                      IAPICONSTANT.INFOLEVEL_3 );

         IF AQNOTES%ISOPEN
         THEN
            CLOSE AQNOTES;
         END IF;

         OPEN AQNOTES FOR LSSQL;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETNOTES;

   
   
   
   FUNCTION GETALERTS(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANLOGID                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANFOODCLAIMID              IN       IAPITYPE.SEQUENCENR_TYPE,
      AQALERTS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetAlerts';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    'rd.Food_Claim_Id '
            || IAPICONSTANTCOLUMN.FOODCLAIMIDCOL
            || ', a.Food_Claim_Alert_Id '
            || IAPICONSTANTCOLUMN.FOODCLAIMALERTIDCOL
            || ', f_foodclaimalert_descr( a.Food_Claim_Alert_Id, 0 ) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', f_foodclaimalert_long_descr( a.Food_Claim_Alert_Id, 0 ) '
            || IAPICONSTANTCOLUMN.ALERTCOL
            || ', a.Intl '
            || IAPICONSTANTCOLUMN.INTLCOL
            || ', a.Status '
            || IAPICONSTANTCOLUMN.STATUSCOL
            || ', rd.Log_Id '
            || IAPICONSTANTCOLUMN.LOGIDCOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE :=    ' FROM ITFOODCLAIMALERT a, '
                                                               || ' ItFoodClaimRunCd rd';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE
         :=    ' WHERE rd.Ref_Type = '
            || IAPICONSTANT.REFTYPE_ALERTS
            || ' '
            || ' AND a.Food_Claim_Alert_Id = rd.Ref_Id '
            || ' AND a.status = '
            || IAPICONSTANT.FOODCLAIMS_STATUSNONHISTORIC
            || ' AND rd.Food_Claim_Id = '
            || ANFOODCLAIMID
            || ' AND rd.Log_Id = '
            || ANLOGID
            || ' AND rd.Req_Id = '
            || ANWEBRQ;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'Select '
               || LSSELECT
               || LSFROM
               || ' WHERE 1=2 ';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQALERTS FOR LSSQL;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE;
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      IF ( AQALERTS%ISOPEN )
      THEN
         CLOSE AQALERTS;
      END IF;

      OPEN AQALERTS FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'Select '
                  || LSSELECT
                  || LSFROM
                  || ' WHERE 1=2 ';
         IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                      LSMETHOD,
                                      LSSQL,
                                      IAPICONSTANT.INFOLEVEL_3 );

         IF AQALERTS%ISOPEN
         THEN
            CLOSE AQALERTS;
         END IF;

         OPEN AQALERTS FOR LSSQL;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETALERTS;

   
   
   
   FUNCTION GETLABELS(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANLOGID                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANFOODCLAIMID                       IAPITYPE.SEQUENCENR_TYPE,
      AQLABELS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetLabels';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    'rd.Food_Claim_Id '
            || IAPICONSTANTCOLUMN.FOODCLAIMIDCOL
            || ', l.Food_Claim_Label_Id '
            || IAPICONSTANTCOLUMN.FOODCLAIMLABELIDCOL
            || ', f_foodclaimlabel_descr( l.Food_Claim_Label_Id, 0 ) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', f_foodclaimlabel_long_descr( l.Food_Claim_Label_id, 0 ) '
            || IAPICONSTANTCOLUMN.LABELCOL
            || ', l.Intl '
            || IAPICONSTANTCOLUMN.INTLCOL
            || ', l.Status '
            || IAPICONSTANTCOLUMN.STATUSCOL
            || ', rd.Log_Id '
            || IAPICONSTANTCOLUMN.LOGIDCOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE :=    ' FROM ITFOODCLAIMLABEL l, '
                                                               || ' ItFoodClaimRunCd rd';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE
         :=    ' WHERE rd.Ref_Type = '
            || IAPICONSTANT.REFTYPE_LABELS
            || ' '
            || ' AND l.Food_Claim_label_Id = rd.Ref_Id '
            || ' AND l.status = '
            || IAPICONSTANT.FOODCLAIMS_STATUSNONHISTORIC
            || ' AND rd.Food_Claim_Id = '
            || ANFOODCLAIMID
            || ' AND rd.Log_Id = '
            || ANLOGID
            || ' AND rd.Req_Id = '
            || ANWEBRQ;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'Select '
               || LSSELECT
               || LSFROM
               || ' WHERE 1=2 ';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQLABELS FOR LSSQL;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE;
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      IF ( AQLABELS%ISOPEN )
      THEN
         CLOSE AQLABELS;
      END IF;

      OPEN AQLABELS FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'Select '
                  || LSSELECT
                  || LSFROM
                  || ' WHERE 1=2 ';
         IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                      LSMETHOD,
                                      LSSQL,
                                      IAPICONSTANT.INFOLEVEL_3 );

         IF AQLABELS%ISOPEN
         THEN
            CLOSE AQLABELS;
         END IF;

         OPEN AQLABELS FOR LSSQL;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETLABELS;

   
   
   
   FUNCTION GETMANUALCONDITIONS(
      ANID                       IN       IAPITYPE.SEQUENCENR_TYPE,
      AQMANCOND                  OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetManualConditions';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' d.Food_Claim_Id '
            || IAPICONSTANTCOLUMN.FOODCLAIMIDCOL
            || ', c.Food_Claim_Cd_Id '
            || IAPICONSTANTCOLUMN.FOODCLAIMCDIDCOL
            || ', f_foodclaimcd_descr( c.Food_Claim_Cd_Id, 0 ) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', f_foodclaimcd_long_descr( c.Food_Claim_Cd_Id, 0 ) '
            || IAPICONSTANTCOLUMN.LONGDESCRIPTIONCOL
            || ', c.Intl '
            || IAPICONSTANTCOLUMN.INTLCOL
            || ', c.Status '
            || IAPICONSTANTCOLUMN.STATUSCOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE :=    ' FROM ITFOODCLAIMCD c, '
                                                               || ' ITFOODCLAIMRUN r, '
                                                               || ' ITFOODCLAIMD d';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE
         :=    ' WHERE d.Ref_Type = '
            || IAPICONSTANT.REFTYPE_MANUALCOND
            || ' AND c.Food_Claim_Cd_Id = d.Ref_Id  '
            || ' AND c.Status = '
            || IAPICONSTANT.FOODCLAIMS_STATUSNONHISTORIC
            || ' AND d.Food_Claim_Id = r.Food_Claim_Id  '
            || ' AND r.Include = 1  '
            || ' AND r.Req_Id = '
            || ANID;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'Select '
               || LSSELECT
               || LSFROM
               || ' WHERE 1=2 ';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQMANCOND FOR LSSQL;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE;
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      IF ( AQMANCOND%ISOPEN )
      THEN
         CLOSE AQMANCOND;
      END IF;

      OPEN AQMANCOND FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'Select '
                  || LSSELECT
                  || LSFROM
                  || ' WHERE 1=2 ';
         IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                      LSMETHOD,
                                      LSSQL,
                                      IAPICONSTANT.INFOLEVEL_3 );

         IF AQMANCOND%ISOPEN
         THEN
            CLOSE AQMANCOND;
         END IF;

         OPEN AQMANCOND FOR LSSQL;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETMANUALCONDITIONS;

   
   
   
   FUNCTION GETSYNONYMS(
      ANID                       IN       IAPITYPE.SEQUENCENR_TYPE,
      AQSYNONYMS                 OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetSynonyms';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    'd.Food_Claim_Id '
            || IAPICONSTANTCOLUMN.FOODCLAIMIDCOL
            || ', s.Food_Claim_Syn_Id '
            || IAPICONSTANTCOLUMN.FOODCLAIMSYNIDCOL
            || ', f_foodclaimsyn_descr( s.Food_Claim_Syn_Id, 0 ) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', s.Intl '
            || IAPICONSTANTCOLUMN.INTLCOL
            || ', s.Status '
            || IAPICONSTANTCOLUMN.STATUSCOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE :=    ' FROM ITFOODCLAIMSYN s, '
                                                               || ' ITFOODCLAIMRUN r, '
                                                               || ' ITFOODCLAIMD d';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE
         :=    ' WHERE d.Ref_Type = '
            || IAPICONSTANT.REFTYPE_SYNONYMS
            || ' AND s.Food_Claim_Syn_Id = d.Ref_Id '
            || ' AND s.status = '
            || IAPICONSTANT.FOODCLAIMS_STATUSNONHISTORIC
            || ' AND d.Food_Claim_Id = r.Food_Claim_Id '
            || ' AND r.Include = 1 '
            || ' AND r.Req_Id = '
            || ANID;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'Select '
               || LSSELECT
               || LSFROM
               || ' WHERE 1=2 ';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQSYNONYMS FOR LSSQL;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || LSWHERE;
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      IF ( AQSYNONYMS%ISOPEN )
      THEN
         CLOSE AQSYNONYMS;
      END IF;

      OPEN AQSYNONYMS FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'Select '
                  || LSSELECT
                  || LSFROM
                  || ' WHERE 1=2 ';
         IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                      LSMETHOD,
                                      LSSQL,
                                      IAPICONSTANT.INFOLEVEL_3 );

         IF AQSYNONYMS%ISOPEN
         THEN
            CLOSE AQSYNONYMS;
         END IF;

         OPEN AQSYNONYMS FOR LSSQL;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETSYNONYMS;

   
   
   
   FUNCTION GETFOODTYPES(
      AQFOODTYPES                OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetFoodTypes';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' Food_Type_Id '
            || IAPICONSTANTCOLUMN.FOODTYPEIDCOL
            || ', f_foodtype_descr( Food_Type_Id, 0 ) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', Intl '
            || IAPICONSTANTCOLUMN.INTLCOL
            || ', Status '
            || IAPICONSTANTCOLUMN.STATUSCOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM ITFOODTYPE';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
   BEGIN              
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'Select '
               || LSSELECT
               || LSFROM
               || ' WHERE 1=2 ';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQFOODTYPES FOR LSSQL;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LSSQL :=    'SELECT '
               || LSSELECT
               || LSFROM
               || ' where status = '
               || IAPICONSTANT.FOODCLAIMS_STATUSNONHISTORIC
               || ' order by 2 asc';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      IF ( AQFOODTYPES%ISOPEN )
      THEN
         CLOSE AQFOODTYPES;
      END IF;

      OPEN AQFOODTYPES FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'Select '
                  || LSSELECT
                  || LSFROM
                  || ' WHERE 1=2 ';
         IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                      LSMETHOD,
                                      LSSQL,
                                      IAPICONSTANT.INFOLEVEL_3 );

         IF AQFOODTYPES%ISOPEN
         THEN
            CLOSE AQFOODTYPES;
         END IF;

         OPEN AQFOODTYPES FOR LSSQL;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETFOODTYPES;

   
   
   
   
   FUNCTION SYNCHRONIZERUN(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      AXRUN                      IN       IAPITYPE.XMLTYPE_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SynchronizeRun';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTRUN                         IAPITYPE.FOODCLAIMRUNTAB_TYPE;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LNRETVAL := TRANSFORMXMLRUN( AXRUN,
                                   LTRUN,
                                   AQERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LNRETVAL := SYNCHRONIZERUN( ANWEBRQ,
                                  LTRUN,
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
   END SYNCHRONIZERUN;

   
   
   
   
   FUNCTION SYNCHRONIZERUN(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ATRUN                      IN       IAPITYPE.FOODCLAIMRUNTAB_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SynchronizeRun';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );

      
      IF ATRUN.COUNT > 0
      THEN
         FOR I IN ATRUN.FIRST .. ATRUN.LAST
         LOOP
            UPDATE ITFOODCLAIMRUN
               SET INCLUDE = ATRUN( I ).INCLUDE,
                   LOG_ID = ATRUN( I ).LOGID,
                   GROUP_ID = ATRUN( I ).GROUPID
             WHERE FOOD_CLAIM_ID = ATRUN( I ).FOODCLAIMID
               AND REQ_ID = ATRUN( I ).REQUESTID;
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
   END SYNCHRONIZERUN;

   
   
   
   FUNCTION TRANSFORMXMLRUN(
      AXRUN                      IN       IAPITYPE.XMLTYPE_TYPE,
      ATRUN                      OUT      IAPITYPE.FOODCLAIMRUNTAB_TYPE,
      AQERRORS                   IN OUT NOCOPY IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'TransformXmlRun';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LXPARSER                      XMLPARSER.PARSER;
      LBPARSERCREATED               IAPITYPE.LOGICAL_TYPE;
      LXDOMDOCUMENT                 XMLDOM.DOMDOCUMENT;
      LXROOTELEMENT                 XMLDOM.DOMELEMENT;
      LXNODESLIST                   XMLDOM.DOMNODELIST;
      LXRUNNODE                     XMLDOM.DOMNODE;
      LXITEMNODE                    XMLDOM.DOMNODE;
      LXITEMNODESLIST               XMLDOM.DOMNODELIST;
      LXELEMENT                     XMLDOM.DOMELEMENT;
      LXNODE                        XMLDOM.DOMNODE;
      LRRUN                         IAPITYPE.FOODCLAIMRUNREC_TYPE;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      
      LXPARSER := XMLPARSER.NEWPARSER;
      LBPARSERCREATED := TRUE;
      XMLPARSER.SETVALIDATIONMODE( LXPARSER,
                                   FALSE );
      XMLPARSER.PARSECLOB( LXPARSER,
                           AXRUN.GETCLOBVAL( ) );
      LXDOMDOCUMENT := XMLPARSER.GETDOCUMENT( LXPARSER );

      IF ( NOT XMLDOM.ISNULL( LXDOMDOCUMENT ) )
      THEN
         
         LXROOTELEMENT := XMLDOM.GETDOCUMENTELEMENT( LXDOMDOCUMENT );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'ROOT element <'
                              || XMLDOM.GETLOCALNAME( LXROOTELEMENT )
                              || '>' );
         
         LXNODESLIST := XMLDOM.GETELEMENTSBYTAGNAME( LXROOTELEMENT,
                                                     'Run' );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Number of filters <'
                              || XMLDOM.GETLENGTH( LXNODESLIST )
                              || '>' );

         
         FOR I IN 0 ..   XMLDOM.GETLENGTH( LXNODESLIST )
                       - 1
         LOOP
            LXRUNNODE := XMLDOM.ITEM( LXNODESLIST,
                                      I );
            LRRUN := NULL;
            
            LXITEMNODESLIST := XMLDOM.GETCHILDNODES( LXRUNNODE );

            FOR J IN 0 ..   XMLDOM.GETLENGTH( LXITEMNODESLIST )
                          - 1
            LOOP
               LXITEMNODE := XMLDOM.ITEM( LXITEMNODESLIST,
                                          J );
               
               LXNODE := XMLDOM.GETFIRSTCHILD( LXITEMNODE );

               IF ( XMLDOM.GETNODETYPE( LXNODE ) = XMLDOM.TEXT_NODE )
               THEN
                  CASE UPPER( XMLDOM.GETNODENAME( LXITEMNODE ) )
                     WHEN IAPICONSTANTCOLUMN.REQUESTIDCOL
                     THEN
                        LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                 LSMETHOD,
                                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
                           LNRETVAL :=
                              IAPIGENERAL.ADDERRORTOLIST(    ' <'
                                                          || IAPICONSTANTCOLUMN.REQUESTIDCOL
                                                          || '>',
                                                          IAPIGENERAL.GETLASTERRORTEXT( ),
                                                          GTERRORS );
                        ELSE
                           LRRUN.REQUESTID := XMLDOM.GETNODEVALUE( LXNODE );
                        END IF;
                     WHEN IAPICONSTANTCOLUMN.LOGIDCOL
                     THEN
                        LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                 LSMETHOD,
                                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
                           LNRETVAL :=
                                  IAPIGENERAL.ADDERRORTOLIST(    ' <'
                                                              || IAPICONSTANTCOLUMN.LOGIDCOL
                                                              || '>',
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              GTERRORS );
                        ELSE
                           LRRUN.LOGID := XMLDOM.GETNODEVALUE( LXNODE );
                        END IF;
                     WHEN IAPICONSTANTCOLUMN.GROUPIDCOL
                     THEN
                        LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                 LSMETHOD,
                                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
                           LNRETVAL :=
                                IAPIGENERAL.ADDERRORTOLIST(    ' <'
                                                            || IAPICONSTANTCOLUMN.GROUPIDCOL
                                                            || '>',
                                                            IAPIGENERAL.GETLASTERRORTEXT( ),
                                                            GTERRORS );
                        ELSE
                           LRRUN.GROUPID := XMLDOM.GETNODEVALUE( LXNODE );
                        END IF;
                     WHEN IAPICONSTANTCOLUMN.FOODCLAIMIDCOL
                     THEN
                        LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                 LSMETHOD,
                                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
                           LNRETVAL :=
                              IAPIGENERAL.ADDERRORTOLIST(    ' <'
                                                          || IAPICONSTANTCOLUMN.FOODCLAIMIDCOL
                                                          || '>',
                                                          IAPIGENERAL.GETLASTERRORTEXT( ),
                                                          GTERRORS );
                        ELSE
                           LRRUN.FOODCLAIMID := XMLDOM.GETNODEVALUE( LXNODE );
                        END IF;
                     WHEN IAPICONSTANTCOLUMN.INCLUDECOL
                     THEN
                        LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                 LSMETHOD,
                                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
                           LNRETVAL :=
                                IAPIGENERAL.ADDERRORTOLIST(    ' <'
                                                            || IAPICONSTANTCOLUMN.INCLUDECOL
                                                            || '>',
                                                            IAPIGENERAL.GETLASTERRORTEXT( ),
                                                            GTERRORS );
                        ELSE
                           LRRUN.INCLUDE := XMLDOM.GETNODEVALUE( LXNODE );
                        END IF;
                     ELSE
                        NULL;
                  END CASE;
               END IF;
            END LOOP;

            ATRUN( ATRUN.COUNT ) := LRRUN;
         END LOOP;
      END IF;

      
      XMLDOM.FREEDOCUMENT( LXDOMDOCUMENT );
      
      XMLPARSER.FREEPARSER( LXPARSER );

      IF GTERRORS.COUNT = 0
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      ELSIF GTERRORS.COUNT > 0
      THEN
         ATRUN.DELETE;
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_ERRORLIST );
      END IF;
   EXCEPTION
      WHEN SELF_IS_NULL
      THEN
         
         ATRUN.DELETE;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END TRANSFORMXMLRUN;

   
   
   
   
   FUNCTION SAVEPROFILE(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      AXPROFILE                  IN       IAPITYPE.XMLTYPE_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveProfile';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTPROFILE                     IAPITYPE.FOODCLAIMPROFILETAB_TYPE;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LNRETVAL := TRANSFORMXMLPROFILE( AXPROFILE,
                                       LTPROFILE,
                                       AQERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LNRETVAL := SAVEPROFILE( ANWEBRQ,
                               LTPROFILE,
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
   END SAVEPROFILE;

   
   
   
   
   FUNCTION SAVEPROFILE(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ATPROFILE                  IN       IAPITYPE.FOODCLAIMPROFILETAB_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveProfile';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );

      
      DELETE FROM ITFOODCLAIMPROFILE
            WHERE REQ_ID = ANWEBRQ;

      
      IF ATPROFILE.COUNT > 0
      THEN
         FOR I IN ATPROFILE.FIRST .. ATPROFILE.LAST
         LOOP
            INSERT INTO ITFOODCLAIMPROFILE
                        ( REQ_ID,
                          LOG_ID,
                          GROUP_ID )
                 VALUES ( ATPROFILE( I ).REQUESTID,
                          ATPROFILE( I ).LOGID,
                          ATPROFILE( I ).GROUPID );
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
   END SAVEPROFILE;

   
   
   
   FUNCTION TRANSFORMXMLPROFILE(
      AXPROFILE                  IN       IAPITYPE.XMLTYPE_TYPE,
      ATPROFILE                  OUT      IAPITYPE.FOODCLAIMPROFILETAB_TYPE,
      AQERRORS                   IN OUT NOCOPY IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'TransformXmlProfile';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LXPARSER                      XMLPARSER.PARSER;
      LBPARSERCREATED               IAPITYPE.LOGICAL_TYPE;
      LXDOMDOCUMENT                 XMLDOM.DOMDOCUMENT;
      LXROOTELEMENT                 XMLDOM.DOMELEMENT;
      LXNODESLIST                   XMLDOM.DOMNODELIST;
      LXPROFILENODE                 XMLDOM.DOMNODE;
      LXITEMNODE                    XMLDOM.DOMNODE;
      LXITEMNODESLIST               XMLDOM.DOMNODELIST;
      LXELEMENT                     XMLDOM.DOMELEMENT;
      LXNODE                        XMLDOM.DOMNODE;
      LRPROFILE                     IAPITYPE.FOODCLAIMPROFILEREC_TYPE;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      
      LXPARSER := XMLPARSER.NEWPARSER;
      LBPARSERCREATED := TRUE;
      XMLPARSER.SETVALIDATIONMODE( LXPARSER,
                                   FALSE );
      XMLPARSER.PARSECLOB( LXPARSER,
                           AXPROFILE.GETCLOBVAL( ) );
      LXDOMDOCUMENT := XMLPARSER.GETDOCUMENT( LXPARSER );

      IF ( NOT XMLDOM.ISNULL( LXDOMDOCUMENT ) )
      THEN
         
         LXROOTELEMENT := XMLDOM.GETDOCUMENTELEMENT( LXDOMDOCUMENT );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'ROOT element <'
                              || XMLDOM.GETLOCALNAME( LXROOTELEMENT )
                              || '>' );
         
         LXNODESLIST := XMLDOM.GETELEMENTSBYTAGNAME( LXROOTELEMENT,
                                                     'Profile' );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Number of filters <'
                              || XMLDOM.GETLENGTH( LXNODESLIST )
                              || '>' );

         
         FOR I IN 0 ..   XMLDOM.GETLENGTH( LXNODESLIST )
                       - 1
         LOOP
            LXPROFILENODE := XMLDOM.ITEM( LXNODESLIST,
                                          I );
            LRPROFILE := NULL;
            
            LXITEMNODESLIST := XMLDOM.GETCHILDNODES( LXPROFILENODE );

            FOR J IN 0 ..   XMLDOM.GETLENGTH( LXITEMNODESLIST )
                          - 1
            LOOP
               LXITEMNODE := XMLDOM.ITEM( LXITEMNODESLIST,
                                          J );
               
               LXNODE := XMLDOM.GETFIRSTCHILD( LXITEMNODE );

               IF ( XMLDOM.GETNODETYPE( LXNODE ) = XMLDOM.TEXT_NODE )
               THEN
                  CASE UPPER( XMLDOM.GETNODENAME( LXITEMNODE ) )
                     WHEN IAPICONSTANTCOLUMN.REQUESTIDCOL
                     THEN
                        LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                 LSMETHOD,
                                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
                           LNRETVAL :=
                              IAPIGENERAL.ADDERRORTOLIST(    ' <'
                                                          || IAPICONSTANTCOLUMN.REQUESTIDCOL
                                                          || '>',
                                                          IAPIGENERAL.GETLASTERRORTEXT( ),
                                                          GTERRORS );
                        ELSE
                           LRPROFILE.REQUESTID := XMLDOM.GETNODEVALUE( LXNODE );
                        END IF;
                     WHEN IAPICONSTANTCOLUMN.LOGIDCOL
                     THEN
                        LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                 LSMETHOD,
                                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
                           LNRETVAL :=
                                  IAPIGENERAL.ADDERRORTOLIST(    ' <'
                                                              || IAPICONSTANTCOLUMN.LOGIDCOL
                                                              || '>',
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              GTERRORS );
                        ELSE
                           LRPROFILE.LOGID := XMLDOM.GETNODEVALUE( LXNODE );
                        END IF;
                     WHEN IAPICONSTANTCOLUMN.GROUPIDCOL
                     THEN
                        LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                 LSMETHOD,
                                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
                           LNRETVAL :=
                                IAPIGENERAL.ADDERRORTOLIST(    ' <'
                                                            || IAPICONSTANTCOLUMN.GROUPIDCOL
                                                            || '>',
                                                            IAPIGENERAL.GETLASTERRORTEXT( ),
                                                            GTERRORS );
                        ELSE
                           LRPROFILE.GROUPID := XMLDOM.GETNODEVALUE( LXNODE );
                        END IF;
                     ELSE
                        NULL;
                  END CASE;
               END IF;
            END LOOP;

            ATPROFILE( ATPROFILE.COUNT ) := LRPROFILE;
         END LOOP;
      END IF;

      
      XMLDOM.FREEDOCUMENT( LXDOMDOCUMENT );
      
      XMLPARSER.FREEPARSER( LXPARSER );

      IF GTERRORS.COUNT = 0
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      ELSIF GTERRORS.COUNT > 0
      THEN
         ATPROFILE.DELETE;
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_ERRORLIST );
      END IF;
   EXCEPTION
      WHEN SELF_IS_NULL
      THEN
         
         ATPROFILE.DELETE;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END TRANSFORMXMLPROFILE;

   
   
   
   
   
   FUNCTION SYNCHRONIZERUNCONDITIONS(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ATMANUALCONDITIONS         IN       IAPITYPE.FOODCLAIMRUNCDTAB_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SynchronizeRunConditions';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );

      
      DELETE FROM ITFOODCLAIMRUNCD
            WHERE REQ_ID = ANWEBRQ;

      
      IF ATMANUALCONDITIONS.COUNT > 0
      THEN
         FOR I IN ATMANUALCONDITIONS.FIRST .. ATMANUALCONDITIONS.LAST
         LOOP
            INSERT INTO ITFOODCLAIMRUNCD
                        ( FOOD_CLAIM_ID,
                          REQ_ID,
                          REF_TYPE,
                          REF_ID,
                          RESULT )
                 VALUES ( ATMANUALCONDITIONS( I ).FOODCLAIMID,
                          ATMANUALCONDITIONS( I ).REQUESTID,
                          IAPICONSTANT.REFTYPE_MANUALCOND,
                          ATMANUALCONDITIONS( I ).REFID,
                          ATMANUALCONDITIONS( I ).RESULT );
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
   END SYNCHRONIZERUNCONDITIONS;

   
   
   
   
   
   FUNCTION SYNCHRONIZERUNCONDITIONS(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      AXMANUALCONDITIONS         IN       IAPITYPE.XMLTYPE_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SynchronizeRunConditions';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTCONDITIONS                  IAPITYPE.FOODCLAIMRUNCDTAB_TYPE;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      LNRETVAL := TRANSFORMXMLMANUALCONDITIONS( AXMANUALCONDITIONS,
                                                LTCONDITIONS,
                                                AQERRORS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LNRETVAL := SYNCHRONIZERUNCONDITIONS( ANWEBRQ,
                                            LTCONDITIONS,
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
   END SYNCHRONIZERUNCONDITIONS;

   
   
   
   FUNCTION TRANSFORMXMLMANUALCONDITIONS(
      AXMANUALCONDITIONS         IN       IAPITYPE.XMLTYPE_TYPE,
      ATMANUALCONDITIONS         OUT      IAPITYPE.FOODCLAIMRUNCDTAB_TYPE,
      AQERRORS                   IN OUT NOCOPY IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'TransformXmlManualConditions';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LXPARSER                      XMLPARSER.PARSER;
      LBPARSERCREATED               IAPITYPE.LOGICAL_TYPE;
      LXDOMDOCUMENT                 XMLDOM.DOMDOCUMENT;
      LXROOTELEMENT                 XMLDOM.DOMELEMENT;
      LXNODESLIST                   XMLDOM.DOMNODELIST;
      LXCDNODE                      XMLDOM.DOMNODE;
      LXITEMNODE                    XMLDOM.DOMNODE;
      LXITEMNODESLIST               XMLDOM.DOMNODELIST;
      LXELEMENT                     XMLDOM.DOMELEMENT;
      LXNODE                        XMLDOM.DOMNODE;
      LRCONDITION                   IAPITYPE.FOODCLAIMRUNCDREC_TYPE;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      
      LXPARSER := XMLPARSER.NEWPARSER;
      LBPARSERCREATED := TRUE;
      XMLPARSER.SETVALIDATIONMODE( LXPARSER,
                                   FALSE );
      XMLPARSER.PARSECLOB( LXPARSER,
                           AXMANUALCONDITIONS.GETCLOBVAL( ) );
      LXDOMDOCUMENT := XMLPARSER.GETDOCUMENT( LXPARSER );

      IF ( NOT XMLDOM.ISNULL( LXDOMDOCUMENT ) )
      THEN
         
         LXROOTELEMENT := XMLDOM.GETDOCUMENTELEMENT( LXDOMDOCUMENT );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'ROOT element <'
                              || XMLDOM.GETLOCALNAME( LXROOTELEMENT )
                              || '>' );
         
         LXNODESLIST := XMLDOM.GETELEMENTSBYTAGNAME( LXROOTELEMENT,
                                                     'Run' );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Number of filters <'
                              || XMLDOM.GETLENGTH( LXNODESLIST )
                              || '>' );

         
         FOR I IN 0 ..   XMLDOM.GETLENGTH( LXNODESLIST )
                       - 1
         LOOP
            LXCDNODE := XMLDOM.ITEM( LXNODESLIST,
                                     I );
            LRCONDITION := NULL;
            
            LXITEMNODESLIST := XMLDOM.GETCHILDNODES( LXCDNODE );

            FOR J IN 0 ..   XMLDOM.GETLENGTH( LXITEMNODESLIST )
                          - 1
            LOOP
               LXITEMNODE := XMLDOM.ITEM( LXITEMNODESLIST,
                                          J );
               
               LXNODE := XMLDOM.GETFIRSTCHILD( LXITEMNODE );

               IF ( XMLDOM.GETNODETYPE( LXNODE ) = XMLDOM.TEXT_NODE )
               THEN
                  CASE UPPER( XMLDOM.GETNODENAME( LXITEMNODE ) )
                     WHEN IAPICONSTANTCOLUMN.REQUESTIDCOL
                     THEN
                        LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                 LSMETHOD,
                                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
                           LNRETVAL :=
                              IAPIGENERAL.ADDERRORTOLIST(    ' <'
                                                          || IAPICONSTANTCOLUMN.REQUESTIDCOL
                                                          || '>',
                                                          IAPIGENERAL.GETLASTERRORTEXT( ),
                                                          GTERRORS );
                        ELSE
                           LRCONDITION.REQUESTID := XMLDOM.GETNODEVALUE( LXNODE );
                        END IF;
                     WHEN IAPICONSTANTCOLUMN.FOODCLAIMIDCOL
                     THEN
                        LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                 LSMETHOD,
                                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
                           LNRETVAL :=
                              IAPIGENERAL.ADDERRORTOLIST(    ' <'
                                                          || IAPICONSTANTCOLUMN.FOODCLAIMIDCOL
                                                          || '>',
                                                          IAPIGENERAL.GETLASTERRORTEXT( ),
                                                          GTERRORS );
                        ELSE
                           LRCONDITION.FOODCLAIMID := XMLDOM.GETNODEVALUE( LXNODE );
                        END IF;
                     WHEN IAPICONSTANTCOLUMN.REFIDCOL
                     THEN
                        LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                 LSMETHOD,
                                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
                           LNRETVAL :=
                                  IAPIGENERAL.ADDERRORTOLIST(    ' <'
                                                              || IAPICONSTANTCOLUMN.REFIDCOL
                                                              || '>',
                                                              IAPIGENERAL.GETLASTERRORTEXT( ),
                                                              GTERRORS );
                        ELSE
                           LRCONDITION.REFID := XMLDOM.GETNODEVALUE( LXNODE );
                        END IF;
                     WHEN IAPICONSTANTCOLUMN.RESULTCOL
                     THEN
                        LNRETVAL := IAPIGENERAL.ISNUMERIC( XMLDOM.GETNODEVALUE( LXNODE ) );

                        IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                        THEN
                           IAPIGENERAL.LOGERROR( GSSOURCE,
                                                 LSMETHOD,
                                                 IAPIGENERAL.GETLASTERRORTEXT( ) );
                           LNRETVAL :=
                                 IAPIGENERAL.ADDERRORTOLIST(    ' <'
                                                             || IAPICONSTANTCOLUMN.RESULTCOL
                                                             || '>',
                                                             IAPIGENERAL.GETLASTERRORTEXT( ),
                                                             GTERRORS );
                        ELSE
                           LRCONDITION.RESULT := XMLDOM.GETNODEVALUE( LXNODE );
                        END IF;
                     ELSE
                        NULL;
                  END CASE;
               END IF;
            END LOOP;

            ATMANUALCONDITIONS( ATMANUALCONDITIONS.COUNT ) := LRCONDITION;
         END LOOP;
      END IF;

      
      XMLDOM.FREEDOCUMENT( LXDOMDOCUMENT );
      
      XMLPARSER.FREEPARSER( LXPARSER );

      IF GTERRORS.COUNT = 0
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      ELSIF GTERRORS.COUNT > 0
      THEN
         ATMANUALCONDITIONS.DELETE;
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_ERRORLIST );
      END IF;
   EXCEPTION
      WHEN SELF_IS_NULL
      THEN
         
         ATMANUALCONDITIONS.DELETE;
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END TRANSFORMXMLMANUALCONDITIONS;

   
   FUNCTION EXECUTERUN(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ASDECSEP                   IN       IAPITYPE.DECIMALSEPERATOR_TYPE DEFAULT NULL,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
       
       
       
       
       
       
       
       
       
       
      
       
       
       
       
      LNSEQUENCENR                  IAPITYPE.SEQUENCENR_TYPE DEFAULT 0;
      LNDUMMYRETVAL                 IAPITYPE.ERRORNUM_TYPE;
      LRCONDITIONS                  IAPITYPE.FOODCLAIMSCONDITIONSREC_TYPE;
      LTCONDITIONS                  IAPITYPE.FOODCLAIMSCONDITIONSTAB_TYPE;
      LRPROFILES                    IAPITYPE.FOODCLAIMPROFILEREC_TYPE;
      LTPROFILES                    IAPITYPE.FOODCLAIMPROFILETAB_TYPE;
      LRRUN                         IAPITYPE.FOODCLAIMRUNREC_TYPE;
      LTRUN                         IAPITYPE.FOODCLAIMRUNTAB_TYPE;
      LNHIERLEVEL                   IAPITYPE.HIERLEVEL_TYPE DEFAULT 0;




      
      CURSOR LQRUN
      IS
         SELECT FOOD_CLAIM_ID,
                REQ_ID,
                LOG_ID,
                GROUP_ID,
                INCLUDE,
                FOOD_CLAIM_CRIT_RULE_ID,
                ERROR_CODE
           FROM ITFOODCLAIMRUN
          WHERE REQ_ID = ANWEBRQ
            AND INCLUDE = 1;

      
      CURSOR LQPROFILES
      IS
         SELECT REQ_ID,
                LOG_ID,
                GROUP_ID
           FROM ITFOODCLAIMPROFILE
          WHERE REQ_ID = ANWEBRQ;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExecuteRun';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNPARENTSEQUENCE              IAPITYPE.SEQUENCENR_TYPE;
      LNPARENTFOODCLAIMID           IAPITYPE.SEQUENCENR_TYPE;
      LBPARENTRESULT                IAPITYPE.BOOLEAN_TYPE := 1;
      LNPARENTERRORCODE             IAPITYPE.ERRORNUM_TYPE := 0;
      LNPARENTSEQUENCENO            IAPITYPE.SEQUENCENR_TYPE := 0;
      LBDETAILRESULT                IAPITYPE.BOOLEAN_TYPE;
      LNDETAILERRORCODE             IAPITYPE.SEQUENCENR_TYPE;
      LBISRECURSIVE                 IAPITYPE.BOOLEAN_TYPE;
      LBCOPIEDEXISTING              IAPITYPE.BOOLEAN_TYPE;
      LSNUTVALUE                    IAPITYPE.DESCRIPTION_TYPE;
      LSCONDITIONS                  IAPITYPE.STRING_TYPE := '';
      LBNOTCLAIM                    IAPITYPE.BOOLEAN_TYPE DEFAULT 0;
      LSDECSEP                      IAPITYPE.DECIMALSEPERATOR_TYPE;
   
   
   
   BEGIN
         
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ASDECSEP IS NULL
      THEN
         LSDECSEP := IAPIGENERAL.GETDBDECIMALSEPERATOR;
      ELSE
         LSDECSEP := ASDECSEP;
      END IF;
           
      
      DELETE FROM ITFOODCLAIMRESULTDETAIL
            WHERE REQ_ID = ANWEBRQ;

      DELETE FROM ITFOODCLAIMRESULT
            WHERE REQ_ID = ANWEBRQ;

      
      OPEN LQRUN;

      FETCH LQRUN
      BULK COLLECT INTO LTRUN;

      CLOSE LQRUN;

      OPEN LQPROFILES;

      FETCH LQPROFILES
      BULK COLLECT INTO LTPROFILES;

      CLOSE LQPROFILES;

      
      FOR IRUN IN LTRUN.FIRST .. LTRUN.LAST
      LOOP
         LRRUN := LTRUN( IRUN );

         
         FOR IPROFILE IN LTPROFILES.FIRST .. LTPROFILES.LAST
         LOOP
            LRPROFILES := LTPROFILES( IPROFILE );
            
            LBPARENTRESULT := 1;
            LNPARENTERRORCODE := 0;
            LSCONDITIONS := '';
            
            LNRETVAL :=
               ADDFOODCLAIMRESULT( ANWEBRQ,
                                   LRPROFILES.LOGID,
                                   LRRUN.FOODCLAIMID,
                                   LBPARENTRESULT,
                                   LRRUN.LOGID,
                                   LRRUN.GROUPID,
                                   LNPARENTERRORCODE,
                                   LSDECSEP );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
            END IF;

            LNRETVAL :=
               EXECUTERUNDETAIL( ANWEBRQ,
                                 LRRUN,
                                 LRPROFILES,
                                 LRRUN.FOODCLAIMID,
                                 LRPROFILES.LOGID,
                                 LNPARENTSEQUENCENO,
                                 LSCONDITIONS,
                                 LBPARENTRESULT,
                                 LNHIERLEVEL,
                                 LNPARENTERRORCODE,
                                 LBNOTCLAIM,
                                 LSDECSEP );
            LNRETVAL := EVALUATEDETAIL( ANWEBRQ,
                                        LRPROFILES.LOGID,
                                        LRRUN.FOODCLAIMID,
                                        LRRUN,
                                        LRPROFILES );

            
            UPDATE ITFOODCLAIMRESULT
               SET RESULT = LBPARENTRESULT
             WHERE LOG_ID = LRPROFILES.LOGID
               AND FOOD_CLAIM_ID = LRRUN.FOODCLAIMID
               AND REQ_ID = ANWEBRQ;
         END LOOP;   
      END LOOP;   

      RETURN IAPICONSTANTDBERROR.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXECUTERUN;

   
   FUNCTION EXECUTERUNDETAIL(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ARRUN                      IN       IAPITYPE.FOODCLAIMRUNREC_TYPE,
      ARPROFILES                 IN       IAPITYPE.FOODCLAIMPROFILEREC_TYPE,
      ANPARENTFOODCLAIMID        IN       IAPITYPE.SEQUENCENR_TYPE,
      ANPARENTLOGID              IN       IAPITYPE.SEQUENCENR_TYPE,
      ANPARENTSEQNO              IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ASCONDITIONS               IN OUT   IAPITYPE.STRING_TYPE,
      ABRESULT                   IN OUT   IAPITYPE.BOOLEAN_TYPE,
      ANHIERLEVEL                IN OUT   IAPITYPE.HIERLEVEL_TYPE,
      ANERRORCODE                IN OUT   IAPITYPE.SEQUENCENR_TYPE,
      ABNOTCLAIM                 IN       IAPITYPE.BOOLEAN_TYPE,
      ASDECSEP                   IN       IAPITYPE.DECIMALSEPERATOR_TYPE DEFAULT NULL )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
      
       
       
       
       
      LNDUMMYRETVAL                 IAPITYPE.ERRORNUM_TYPE;
      LRCONDITIONS                  IAPITYPE.FOODCLAIMSCONDITIONSREC_TYPE;
      LTCONDITIONS                  IAPITYPE.FOODCLAIMSCONDITIONSTAB_TYPE;
      LNLEVEL                       IAPITYPE.SEQUENCENR_TYPE;
      LNCONDLEVEL                   IAPITYPE.SEQUENCENR_TYPE;
      LNPARENTSEQNO                 IAPITYPE.SEQUENCENR_TYPE;
      LRPROFILES                    IAPITYPE.FOODCLAIMPROFILEREC_TYPE;

      
      CURSOR LQCONDITIONS(
         ANRULEID                            IAPITYPE.SEQUENCENR_TYPE )
      IS
         SELECT     LEVEL,
                    P.FOOD_CLAIM_CRIT_RULE_ID,
                    P.SEQ_NO,
                    P.REF_TYPE,
                    P.REF_ID,
                       LPAD( ' ',
                               8
                             * (   LEVEL
                                 - 1 ) )
                    || F_FOODCLAIM_RESRULE_DESCR( P.REF_ID,
                                                  P.REF_TYPE ) RULEDESCRIPTION,
                    P.AND_OR,
                    '',
                    '',
                    '',
                    '',
                    '',
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0
               FROM ITFOODCLAIMCRITRULED P,
                    ITFOODCLAIMCRITRULE R
              WHERE R.FOOD_CLAIM_CRIT_RULE_ID = P.FOOD_CLAIM_CRIT_RULE_ID
                AND R.STATUS = IAPICONSTANT.FOODCLAIMS_STATUSNONHISTORIC
         START WITH R.FOOD_CLAIM_CRIT_RULE_ID = ANRULEID
         CONNECT BY PRIOR P.REF_ID = P.FOOD_CLAIM_CRIT_RULE_ID
                AND PRIOR P.REF_TYPE = IAPICONSTANT.REFTYPE_MANUALCOND
           ORDER SIBLINGS BY P.SEQ_NO ASC;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExecuteRunDetail';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNPARENTSEQUENCE              IAPITYPE.SEQUENCENR_TYPE;
      LNPARENTFOODCLAIMID           IAPITYPE.SEQUENCENR_TYPE;
      LNPARENTLOGID                 IAPITYPE.SEQUENCENR_TYPE;
      LBPARENTRESULT                IAPITYPE.BOOLEAN_TYPE;
      LNPARENTERRORCODE             IAPITYPE.SEQUENCENR_TYPE;
      LBDETAILRESULT                IAPITYPE.BOOLEAN_TYPE;
      LNDETAILERRORCODE             IAPITYPE.SEQUENCENR_TYPE;
      LBISRECURSIVE                 IAPITYPE.BOOLEAN_TYPE;
      LBCOPIEDEXISTING              IAPITYPE.BOOLEAN_TYPE;
      LSNUTVALUE                    IAPITYPE.DESCRIPTION_TYPE;
      LBACTUALVALUE                 IAPITYPE.BOOLEAN_TYPE DEFAULT 0;
      LNHIERLEVEL                   IAPITYPE.HIERLEVEL_TYPE;
      LSDECSEP                      IAPITYPE.DECIMALSEPERATOR_TYPE;      
      LNCOUNT                       IAPITYPE.SEQUENCENR_TYPE;   
      
      LSPERCENTAGEVALUE             IAPITYPE.DESCRIPTION_TYPE;
      LNCOMPLOGID                   IAPITYPE.SEQUENCENR_TYPE;
      LSCOMPNUTVALUE                IAPITYPE.DESCRIPTION_TYPE;
      LBNUTRFOUND                   IAPITYPE.BOOLEAN_TYPE;
      
      LNISRELATIVECL                IAPITYPE.BOOLEAN_TYPE;

   
   
   
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ASDECSEP IS NULL
      THEN
         LSDECSEP := IAPIGENERAL.GETDBDECIMALSEPERATOR;
      ELSE
         LSDECSEP := ASDECSEP;
      END IF;
     
      OPEN LQCONDITIONS( ARRUN.FOODCLAIMCRITRULEID );

      FETCH LQCONDITIONS
      BULK COLLECT INTO LTCONDITIONS;

      CLOSE LQCONDITIONS;

      
      
      FOR ICON IN LTCONDITIONS.FIRST .. LTCONDITIONS.LAST
      LOOP
            LRCONDITIONS := LTCONDITIONS( ICON );
            
            
            IF (LRCONDITIONS.REFTYPE = 2)
            THEN
                SELECT COUNT(*)
                INTO LNCOUNT 
                FROM ITFOODCLAIMCRITRULED
                WHERE FOOD_CLAIM_CRIT_RULE_ID = LRCONDITIONS.REFID;
                
                IF (LNCOUNT = 0)
                THEN
                   IAPIGENERAL.LOGERROR( GSSOURCE,
                                         LSMETHOD,
                                         'This Rule is not configured: ' || F_FOODCLAIMCRITRULE_DESCR (LRCONDITIONS.REFID, 0));                                         
                END IF;
                                
            END IF;    
      END LOOP;
      
    
      
      LNLEVEL := 1;

      FOR ICON IN LTCONDITIONS.FIRST .. LTCONDITIONS.LAST
      LOOP
         LBNUTRFOUND := 1;
         
         
         LNCONDLEVEL := LTCONDITIONS( ICON ).LEVEL;
         LNHIERLEVEL :=   ANHIERLEVEL
                        + LNCONDLEVEL;
         LRCONDITIONS := LTCONDITIONS( ICON );

         FOR IBRACKET IN LNLEVEL ..(   LNCONDLEVEL
                                     - 1 )
         LOOP
            ASCONDITIONS :=    ASCONDITIONS
                            || '(';
         END LOOP;

         
         FOR IBRACKET IN LNCONDLEVEL ..(   LNLEVEL
                                         - 1 )
         LOOP
            ASCONDITIONS :=    ASCONDITIONS
                            || ')';
         END LOOP;

         LNLEVEL := LNCONDLEVEL;
         
         ASCONDITIONS :=    ASCONDITIONS
                         || ' '
                         || LRCONDITIONS.ANDOR
                         || ' ';

         IF LRCONDITIONS.REFTYPE = 1
         THEN
            
            SELECT F_FOODCLAIM_RESCONDITION_DESCR( C.RULE_ID,
                                                   C.ATTRIBUTE_ID,
                                                   C.RULE_TYPE ) CONDITIONDESCRIPTION,
                   C.RULE_OPERATOR,
                   C.RULE_VALUE_1,
                   C.RULE_VALUE_2,
                   C.SERVING_SIZE,
                   C.VALUE_TYPE,
                   C.RELATIVE_PERC,
                   C.RELATIVE_COMP,
                   C.RULE_TYPE,
                   C.RULE_ID,
                   C.ATTRIBUTE_ID,
                   C.FOOD_CLAIM_CRIT_RULE_CD_ID
              INTO LRCONDITIONS.CONDITIONDESCRIPTION,
                   LRCONDITIONS.RULEOPERATOR,
                   LRCONDITIONS.RULEVALUE1,
                   LRCONDITIONS.RULEVALUE2,
                   LRCONDITIONS.SERVINGSIZE,
                   LRCONDITIONS.VALUETYPE,
                   LRCONDITIONS.RELATIVEPERC,
                   LRCONDITIONS.RELATIVECOMP,
                   LRCONDITIONS.RULETYPE,
                   LRCONDITIONS.RULEID,
                   LRCONDITIONS.ATTRIBUTEID,
                   LRCONDITIONS.FOODCLAIMCRITRULECDID
              FROM ITFOODCLAIMCRITRULECD C
             WHERE LRCONDITIONS.REFID = C.FOOD_CLAIM_CRIT_RULE_CD_ID
               AND C.STATUS = IAPICONSTANT.FOODCLAIMS_STATUSNONHISTORIC;

            
            ANPARENTSEQNO :=   ANPARENTSEQNO
                             + 10;
            LBDETAILRESULT := 1;
            LNDETAILERRORCODE := 0;
            LBISRECURSIVE := 0;
            LBCOPIEDEXISTING := 0;
            LSNUTVALUE := '';
            
            LNRETVAL :=
               ADDFOODCLAIMRESULTDETAIL( ANWEBRQ,
                                         ANPARENTLOGID,
                                         ANPARENTFOODCLAIMID,
                                         LRCONDITIONS.FOODCLAIMCRITRULECDID,
                                         LNHIERLEVEL,
                                         ANPARENTSEQNO,
                                         LRCONDITIONS.REFTYPE,
                                         LRCONDITIONS.REFID,
                                         LRCONDITIONS.ANDOR,
                                         LRCONDITIONS.RULETYPE,
                                         LRCONDITIONS.RULEID,
                                         LRCONDITIONS.RULEOPERATOR,
                                         LRCONDITIONS.RULEVALUE1,
                                         LRCONDITIONS.RULEVALUE2,
                                         LRCONDITIONS.SERVINGSIZE,
                                         LRCONDITIONS.VALUETYPE,
                                         LRCONDITIONS.RELATIVEPERC,
                                         LRCONDITIONS.RELATIVECOMP,
                                         0   
                                          ,
                                         ABRESULT,
                                         ARRUN.FOODCLAIMID,
                                         0   
                                          ,
                                         ANERRORCODE,
                                         LRCONDITIONS.ATTRIBUTEID,
                                         ABNOTCLAIM );

            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
            END IF;

            
            
            
            
            
            
            IF 
               (LRCONDITIONS.RELATIVEPERC = 1)
            
               AND (LRCONDITIONS.RELATIVECOMP = 1)
            THEN
                
          
                
                LNRETVAL :=
                   ADDFOODCLAIMRESULTDETAIL( ANWEBRQ,
                                             ANPARENTLOGID,
                                             ANPARENTFOODCLAIMID,
                                             LRCONDITIONS.FOODCLAIMCRITRULECDID,
                                             LNHIERLEVEL,
                                             ANPARENTSEQNO + 10, 
                                             LRCONDITIONS.REFTYPE,
                                             LRCONDITIONS.REFID,
                                             NULL, 
                                             LRCONDITIONS.RULETYPE,
                                             LRCONDITIONS.RULEID,
                                             LRCONDITIONS.RULEOPERATOR,
                                             0, 
                                             LRCONDITIONS.RULEVALUE2,
                                             LRCONDITIONS.SERVINGSIZE,
                                             LRCONDITIONS.VALUETYPE,
                                             LRCONDITIONS.RELATIVEPERC,
                                             LRCONDITIONS.RELATIVECOMP,
                                             0,                                              
                                             ABRESULT,
                                             ARRUN.FOODCLAIMID,
                                             0,
                                             ANERRORCODE,
                                             LRCONDITIONS.ATTRIBUTEID,
                                             ABNOTCLAIM );

                IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                THEN
                   IAPIGENERAL.LOGERROR( GSSOURCE,
                                         LSMETHOD,
                                         IAPIGENERAL.GETLASTERRORTEXT( ) );
                END IF;                
            END IF; 
            


            CASE LRCONDITIONS.RULETYPE
               WHEN 1
               THEN
                  

                  
                  
                  
                  IF ((LRCONDITIONS.RELATIVECOMP = 1)
                     
                     AND (LRCONDITIONS.RELATIVEPERC <> 1)
                     
                     AND (INSTR(LRCONDITIONS.RULEVALUE1, '}') = 0))
                  THEN
                        BEGIN
                            SELECT COMP_LOG_ID
                            INTO LNCOMPLOGID
                            FROM ITFOODCLAIMRESULT
                            WHERE REQ_ID = ANWEBRQ
                            AND LOG_ID = ARPROFILES.LOGID
                            AND FOOD_CLAIM_ID = ARRUN.FOODCLAIMID;             
                        EXCEPTION
                            WHEN NO_DATA_FOUND
                            THEN                                               
                                LNCOMPLOGID := ARPROFILES.LOGID;
                        END;
                  
                       LNRETVAL :=
                         GETNUTRITIONALVALUE( LNCOMPLOGID,
                                              ARPROFILES.GROUPID,
                                              LRCONDITIONS.VALUETYPE,
                                              LRCONDITIONS.RULEID,
                                              LRCONDITIONS.ATTRIBUTEID,
                                              LSNUTVALUE );                                            
                  ELSE
                  
                  
                  
                  
                  
                  LNRETVAL :=
                     GETNUTRITIONALVALUE( ARPROFILES.LOGID,
                                          ARPROFILES.GROUPID,
                                          LRCONDITIONS.VALUETYPE,
                                          LRCONDITIONS.RULEID,
                                          LRCONDITIONS.ATTRIBUTEID,
                                          LSNUTVALUE );
                  
                  END IF;
                  
                  
                  IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                  THEN
                     IAPIGENERAL.LOGERROR( GSSOURCE,
                                           LSMETHOD,
                                           IAPIGENERAL.GETLASTERRORTEXT( ) );
                     
                     
                     ABRESULT := 0;
                     ANERRORCODE := LNRETVAL;                     
                     ASCONDITIONS :=    ASCONDITIONS
                                     || '(1 = 0)';
                                     
                     LBNUTRFOUND := 0;                
                  ELSE
                      
                      
                      IF LRCONDITIONS.RELATIVECOMP = 1
                      THEN     
                                                                             
                            BEGIN
                                SELECT COMP_LOG_ID
                                INTO LNCOMPLOGID
                                FROM ITFOODCLAIMRESULT
                                WHERE REQ_ID = ANWEBRQ
                                AND LOG_ID = ARPROFILES.LOGID
                                AND FOOD_CLAIM_ID = ARRUN.FOODCLAIMID;             
                            EXCEPTION
                                WHEN NO_DATA_FOUND
                                THEN
                                    
                                    LNCOMPLOGID := ARPROFILES.LOGID;
                            END;
                            
                            
                            
                            
                            
                            
                            
                      
                      ELSE
                        
                        SELECT RELATIVE
                        INTO LNISRELATIVECL
                        FROM ITFOODCLAIMRUN CR, ITFOODCLAIM CL
                        WHERE CR.FOOD_CLAIM_ID = CL.FOOD_CLAIM_ID                        
                        AND CR.REQ_ID = ANWEBRQ
                        AND CR.FOOD_CLAIM_ID = ARRUN.FOODCLAIMID;                        
                        
                        IF (LNISRELATIVECL = 0)
                        THEN                                                
                            LNCOMPLOGID := ARPROFILES.LOGID;
                        END IF;    
                      
                      END IF;
                  
                      LNRETVAL :=
                         GETNUTRITIONALVALUE( LNCOMPLOGID,
                                              ARPROFILES.GROUPID,
                                              LRCONDITIONS.VALUETYPE,
                                              LRCONDITIONS.RULEID,
                                              LRCONDITIONS.ATTRIBUTEID,
                                              LSCOMPNUTVALUE );    
                                              
                      
                      
                      
                      LNRETVAL := SCALENUTRIENT( ANWEBRQ,
                                                 LNCOMPLOGID,
                                                 LRCONDITIONS,
                                                 LSCOMPNUTVALUE);
                      
                      
                  
                     
                     LNRETVAL := EVALUATENUTRIENT( ANWEBRQ,                     
                                                   ARPROFILES,
                                                   ARRUN,
                                                   LRCONDITIONS,
                                                   LSNUTVALUE,
                                                   ABRESULT,
                                                   ANERRORCODE,
                                                   LSDECSEP );

                    
                    
                    
                    
                    
                    
                    
                    
                    IF  
                       (LRCONDITIONS.RELATIVEPERC <> 1)                    
                    
                       OR (LRCONDITIONS.RELATIVECOMP <> 1)
                    THEN
                    
                         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
                         THEN
                            IF ABRESULT = 1
                            THEN
                               ASCONDITIONS :=    ASCONDITIONS
                                               || '(1 = 1)';
                            ELSE
                               ASCONDITIONS :=    ASCONDITIONS
                                               || '(1 = 0)';
                            END IF;
                         ELSE
                            ASCONDITIONS :=    ASCONDITIONS
                                            || '(1 = 0)';
                         END IF;
                    
                    END IF;
                    
                  END IF;
               WHEN 2
               THEN   
                   
                  
                  
                  LRPROFILES := ARPROFILES;

                  IF LRCONDITIONS.RELATIVECOMP = 1
                  THEN
                     LRPROFILES.LOGID := ARRUN.LOGID;
                     LRPROFILES.GROUPID := ARRUN.GROUPID;
                  END IF;

                  LNPARENTSEQNO := ANPARENTSEQNO;
                  LBISRECURSIVE :=
                              ISRECURSIVE( ANWEBRQ,
                                           LRPROFILES.LOGID,
                                           ANPARENTFOODCLAIMID,
                                           ARRUN.FOODCLAIMID,
                                           LNHIERLEVEL,
                                           LNPARENTSEQNO,
                                           ABNOTCLAIM );

                  IF LBISRECURSIVE = 0
                  THEN
                   
                  
                  






                     

                     
                     LNRETVAL :=
                        EVALUATEFOODCLAIM( ANWEBRQ,
                                           LRPROFILES,
                                           ARRUN,
                                           LRCONDITIONS,
                                           ANPARENTFOODCLAIMID,
                                           ANPARENTLOGID,
                                           LNPARENTSEQNO,
                                           ABRESULT,
                                           LNHIERLEVEL,
                                           ANERRORCODE,
                                           ABNOTCLAIM );
                     LSNUTVALUE := ABRESULT;

                     IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
                     THEN
                        IF TO_CHAR( ABRESULT ) = LRCONDITIONS.RULEVALUE1
                        THEN
                           ABRESULT := 1;
                           ASCONDITIONS :=    ASCONDITIONS
                                           || '(1 = 1)';
                        ELSE
                           ABRESULT := 0;
                           ASCONDITIONS :=    ASCONDITIONS
                                           || '(1 = 0)';
                        END IF;
                     ELSE
                        ABRESULT := 0;
                        ASCONDITIONS :=    ASCONDITIONS
                                        || '(1 = 0)';
                     END IF;
                  ELSE
                     ASCONDITIONS :=    ASCONDITIONS
                                     || '(1 = 0)';
                     ABRESULT := 0;
                     ANERRORCODE := IAPICONSTANTDBERROR.DBERR_FOODCLAIMRECURSIVE;
                     LSNUTVALUE := ABRESULT;
                  END IF;
               WHEN 3
               THEN   
                   
                  
                  
                  
                  LBDETAILRESULT := 0;
                  LNRETVAL :=
                     EVALUATEMANUALCONDITION( ANWEBRQ,
                                              ARPROFILES,
                                              ANPARENTFOODCLAIMID,
                                              ANPARENTSEQNO,
                                              LRCONDITIONS,
                                              ABRESULT,
                                              LBACTUALVALUE,
                                              ANERRORCODE );

                  IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
                  THEN
                     IF ABRESULT = 1
                     THEN
                        ASCONDITIONS :=    ASCONDITIONS
                                        || '(1 = 1)';
                     ELSE
                        ASCONDITIONS :=    ASCONDITIONS
                                        || '(1 = 0)';
                     END IF;
                  ELSE
                     ASCONDITIONS :=    ASCONDITIONS
                                     || '(1 = 0)';
                  END IF;

                  LSNUTVALUE := LBACTUALVALUE;
            END CASE;   


            
            
            
            
            
            
            IF  
                (LRCONDITIONS.RELATIVEPERC <> 1)               
            
               OR (LRCONDITIONS.RELATIVECOMP <> 1)
            THEN
            
              
              LNRETVAL :=
                 SAVEFOODCLAIMRESULTDETAIL( ANWEBRQ,
                                          ANPARENTLOGID,
                                          ANPARENTFOODCLAIMID,
                                          LRCONDITIONS.FOODCLAIMCRITRULECDID,
                                          LNHIERLEVEL,
                                          ANPARENTSEQNO,
                                          LRCONDITIONS.REFTYPE,
                                          LRCONDITIONS.REFID,
                                          LRCONDITIONS.ANDOR,
                                          LRCONDITIONS.RULETYPE,
                                          LRCONDITIONS.RULEID,
                                          LRCONDITIONS.RULEOPERATOR,                                          
                                          LRCONDITIONS.RULEVALUE1,
                                          LRCONDITIONS.RULEVALUE2,
                                          LRCONDITIONS.SERVINGSIZE,
                                          LRCONDITIONS.VALUETYPE,                                                                                    
                                          LRCONDITIONS.RELATIVEPERC,
                                          LRCONDITIONS.RELATIVECOMP,
                                          LSNUTVALUE,
                                          ABRESULT,
                                          ARRUN.FOODCLAIMID,
                                          0,   
                                          ANERRORCODE,
                                          LRCONDITIONS.ATTRIBUTEID );               
            
            ELSE                        
              
              
              LNRETVAL :=
                 SAVEFOODCLAIMRESULTDETAIL( ANWEBRQ,
                                          ANPARENTLOGID,
                                          ANPARENTFOODCLAIMID,
                                          LRCONDITIONS.FOODCLAIMCRITRULECDID,
                                          LNHIERLEVEL,
                                          ANPARENTSEQNO,
                                          LRCONDITIONS.REFTYPE,
                                          LRCONDITIONS.REFID,
                                          LRCONDITIONS.ANDOR,
                                          LRCONDITIONS.RULETYPE,
                                          LRCONDITIONS.RULEID,
                                          LRCONDITIONS.RULEOPERATOR,
                                          
                                          
                                          LSCOMPNUTVALUE,
                                          
                                          LRCONDITIONS.RULEVALUE2,
                                          LRCONDITIONS.SERVINGSIZE,
                                          LRCONDITIONS.VALUETYPE,                                          
                                          
                                          
                                          0,
                                          
                                          LRCONDITIONS.RELATIVECOMP,
                                          LSNUTVALUE, 
                                          NULL, 
                                          ARRUN.FOODCLAIMID,
                                          0,   
                                          NULL, 
                                          LRCONDITIONS.ATTRIBUTEID );         
            END IF;
            
                                          
            IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT( ) );
            END IF;
            
            
            
            
            
            
            IF  
               (LRCONDITIONS.RELATIVEPERC = 1)                
            
               AND (LRCONDITIONS.RELATIVECOMP = 1)
            THEN
               ANPARENTSEQNO :=   ANPARENTSEQNO + 10;  
          
               LSPERCENTAGEVALUE := (LSNUTVALUE * 100) / LSCOMPNUTVALUE;

              
              
                LNRETVAL :=
                SAVEFOODCLAIMRESULTDETAIL( ANWEBRQ,
                                          ANPARENTLOGID,
                                          ANPARENTFOODCLAIMID,
                                          LRCONDITIONS.FOODCLAIMCRITRULECDID,
                                          LNHIERLEVEL,
                                          ANPARENTSEQNO,  
                                          LRCONDITIONS.REFTYPE,
                                          LRCONDITIONS.REFID,
                                          NULL, 
                                          LRCONDITIONS.RULETYPE,
                                          LRCONDITIONS.RULEID,
                                          LRCONDITIONS.RULEOPERATOR,
                                          LRCONDITIONS.RULEVALUE1, 
                                          LRCONDITIONS.RULEVALUE2,
                                          LRCONDITIONS.SERVINGSIZE,
                                          LRCONDITIONS.VALUETYPE,
                                          LRCONDITIONS.RELATIVEPERC,
                                          LRCONDITIONS.RELATIVECOMP,
                                          LSPERCENTAGEVALUE, 
                                          ABRESULT, 
                                          ARRUN.FOODCLAIMID,
                                          0,   
                                          ANERRORCODE, 
                                          LRCONDITIONS.ATTRIBUTEID );

                IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                THEN
                   IAPIGENERAL.LOGERROR( GSSOURCE,
                                         LSMETHOD,
                                         IAPIGENERAL.GETLASTERRORTEXT( ) );
                END IF;        
                                
                
                IF (LBNUTRFOUND = 1)
                THEN                
                    
                    LNRETVAL := EVALUATEPERCCONDITION(LRCONDITIONS, 
                                                      LSPERCENTAGEVALUE, 
                                                      ABRESULT, 
                                                      ANERRORCODE, 
                                                      LSDECSEP);

                     IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
                     THEN
                        IF ABRESULT = 1
                        THEN
                           ASCONDITIONS :=    ASCONDITIONS
                                           || '(1 = 1)';
                        ELSE
                           ASCONDITIONS :=    ASCONDITIONS
                                           || '(1 = 0)';
                        END IF;
                     ELSE
                        ASCONDITIONS :=    ASCONDITIONS
                                        || '(1 = 0)';
                     END IF;
                     
                    
                    LNRETVAL :=
                    SAVEFOODCLAIMRESULTDETAIL( ANWEBRQ,
                                              ANPARENTLOGID,
                                              ANPARENTFOODCLAIMID,
                                              LRCONDITIONS.FOODCLAIMCRITRULECDID,
                                              LNHIERLEVEL,
                                              ANPARENTSEQNO,  
                                              LRCONDITIONS.REFTYPE,
                                              LRCONDITIONS.REFID,
                                              NULL, 
                                              LRCONDITIONS.RULETYPE,
                                              LRCONDITIONS.RULEID,
                                              LRCONDITIONS.RULEOPERATOR,
                                              LRCONDITIONS.RULEVALUE1, 
                                              LRCONDITIONS.RULEVALUE2,
                                              LRCONDITIONS.SERVINGSIZE,
                                              LRCONDITIONS.VALUETYPE,
                                              LRCONDITIONS.RELATIVEPERC,
                                              LRCONDITIONS.RELATIVECOMP,
                                              LSPERCENTAGEVALUE, 
                                              ABRESULT, 
                                              ARRUN.FOODCLAIMID,
                                              0,   
                                              ANERRORCODE, 
                                              LRCONDITIONS.ATTRIBUTEID );

                    IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                    THEN
                       IAPIGENERAL.LOGERROR( GSSOURCE,
                                             LSMETHOD,
                                             IAPIGENERAL.GETLASTERRORTEXT( ) );
                    END IF;                                      
                END IF;                    
                
                
                LNRETVAL :=
                 SAVEFOODCLAIMRESULTDETAIL( ANWEBRQ,
                                          ANPARENTLOGID,
                                          ANPARENTFOODCLAIMID,
                                          LRCONDITIONS.FOODCLAIMCRITRULECDID,
                                          LNHIERLEVEL,
                                          ANPARENTSEQNO - 10, 
                                          LRCONDITIONS.REFTYPE,
                                          LRCONDITIONS.REFID,
                                          LRCONDITIONS.ANDOR,
                                          LRCONDITIONS.RULETYPE,
                                          LRCONDITIONS.RULEID,
                                          LRCONDITIONS.RULEOPERATOR,
                                          
                                          
                                          LSCOMPNUTVALUE,
                                          
                                          LRCONDITIONS.RULEVALUE2,
                                          LRCONDITIONS.SERVINGSIZE,
                                          LRCONDITIONS.VALUETYPE,                                          
                                          
                                          
                                          0,
                                          
                                          LRCONDITIONS.RELATIVECOMP,
                                          LSNUTVALUE, 
                                          NULL, 
                                          ARRUN.FOODCLAIMID,
                                          0,   
                                          NULL, 
                                          LRCONDITIONS.ATTRIBUTEID );         

                IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
                THEN
                   IAPIGENERAL.LOGERROR( GSSOURCE,
                                         LSMETHOD,
                                         IAPIGENERAL.GETLASTERRORTEXT( ) );
                END IF;                    
                                        
            END IF; 
            
            
         END IF;
      END LOOP;   

      
      FOR IBRACKET IN 1 ..   LNLEVEL
                           - 1
      LOOP
         ASCONDITIONS :=    ASCONDITIONS
                         || ')';
      END LOOP;

      RETURN EVALUATECONDITION( ASCONDITIONS,
                                ABRESULT,
                                ANERRORCODE );
   EXCEPTION
      WHEN OTHERS
      THEN
         ABRESULT := 0;
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXECUTERUNDETAIL;

   
   
   
   FUNCTION GETRESULTS(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      AQRESULTS                  OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetResults';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    'SELECT '
            || '  r.Req_Id '
            || IAPICONSTANTCOLUMN.REQUESTIDCOL
            || ', r.Log_Id '
            || IAPICONSTANTCOLUMN.LOGIDCOL
            || ', l.Log_Name '
            || IAPICONSTANTCOLUMN.LOGNAMECOL
            || ', r.Food_Claim_Id '
            || IAPICONSTANTCOLUMN.FOODCLAIMIDCOL
            || ', f_foodclaim_descr(r.Food_Claim_Id, 0) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', r.Result '
            || IAPICONSTANTCOLUMN.RESULTCOL
            || ', r.Comp_Log_Id '
            || IAPICONSTANTCOLUMN.COMPARISONPROFILECOL
            || ', c.Log_Name '
            || IAPICONSTANTCOLUMN.COMPARISONPROFILEDESCRCOL
            || ', c.Part_No '
            || IAPICONSTANTCOLUMN.COMPARISONPRODUCTCOL
            || ', f_part_descr(1, c.Part_No) '
            || IAPICONSTANTCOLUMN.COMPARISONPRODUCTDESCRCOL
            || ', r.Dec_Sep '
            || IAPICONSTANTCOLUMN.DECSEPCOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE
                                               :=    ' FROM itFoodClaimResult r, '
                                                  || '      itNutLog l, '
                                                  || ' 	  itNutLog c, '
                                                  || ' 	  itNutLyGroup g ';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE
         :=    ' WHERE r.Req_Id = '
            || ANWEBRQ
            || '   AND l.Log_id = r.Log_Id '
            || '   AND c.Log_id (+)= r.Comp_Log_Id '
            || '   AND g.Id (+)= r.Comp_Group_Id ';
      LSWHERENULL                   IAPITYPE.SQLSTRING_TYPE := ' WHERE 1 = 2';
      LSORDER                       IAPITYPE.SQLSTRING_TYPE :=    ' ORDER BY l.Log_Name, '
                                                               || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
                                                               || ' ASC ';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQRESULTS%ISOPEN )
      THEN
         CLOSE AQRESULTS;
      END IF;

      
      LSSQL :=    LSSELECT
               || LSFROM
               || LSWHERENULL;
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQRESULTS FOR LSSQL;

      
      IF ( AQRESULTS%ISOPEN )
      THEN
         CLOSE AQRESULTS;
      END IF;

      LSSQL :=    LSSELECT
               || LSFROM
               || LSWHERE
               || LSORDER;
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQRESULTS FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF AQRESULTS%ISOPEN
         THEN
            CLOSE AQRESULTS;
         END IF;

         LSSQL :=    LSSELECT
                  || LSFROM
                  || LSWHERENULL;
         IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                      LSMETHOD,
                                      LSSQL,
                                      IAPICONSTANT.INFOLEVEL_3 );

         OPEN AQRESULTS FOR LSSQL;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETRESULTS;

   
   
   
   FUNCTION GETRESULTDETAILS(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANLOGID                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANFOODCLAIMID              IN       IAPITYPE.SEQUENCENR_TYPE,
      ANCONDITIONFOODCLAIMID     IN       IAPITYPE.SEQUENCENR_TYPE,
      AQDETAILS                  OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetResultDetails';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    'SELECT '
            || '  d.Req_Id '
            || IAPICONSTANTCOLUMN.REQUESTIDCOL
            || ', d.Log_id '
            || IAPICONSTANTCOLUMN.LOGIDCOL
            || ', d.Food_Claim_Id '
            || IAPICONSTANTCOLUMN.FOODCLAIMIDCOL
            || ', d.Food_Claim_Crit_Rule_Cd_Id '
            || IAPICONSTANTCOLUMN.FOODCLAIMCRITRULECDIDCOL
            || ', d.Hier_Level '
            || IAPICONSTANTCOLUMN.HIERARCHICALLEVELCOL
            || ', d.Seq_No '
            || IAPICONSTANTCOLUMN.SEQUENCECOL
            || ', d.Ref_Type '
            || IAPICONSTANTCOLUMN.REFTYPECOL
            || ', d.Ref_Id '
            || IAPICONSTANTCOLUMN.REFIDCOL
            || ', f_FoodClaim_ResRule_Descr(d.Ref_Id, d.Ref_Type) '
            || IAPICONSTANTCOLUMN.RULEDESCRIPTIONCOL
            || ', d.And_Or '
            || IAPICONSTANTCOLUMN.ANDORCOL
            || ', d.Rule_Type '
            || IAPICONSTANTCOLUMN.RULETYPECOL
            || ', d.Rule_Id '
            || IAPICONSTANTCOLUMN.RULEIDCOL
            || ', f_FoodClaim_ResCondition_Descr(d.Rule_Id, d.Attribute_id, d.Rule_Type) '
            || IAPICONSTANTCOLUMN.CONDITIONDESCRIPTIONCOL
            || ', d.Rule_Operator '
            || IAPICONSTANTCOLUMN.RULEOPERATORCOL

            || ', F_FOODCLAIM_CONDVALUE_DESC(d.Rule_Value_1) '
            || IAPICONSTANTCOLUMN.RULEVALUE1COL
            || ', d.Rule_Value_2 '
            || IAPICONSTANTCOLUMN.RULEVALUE2COL
            || ', d.Serving_Size '
            || IAPICONSTANTCOLUMN.SERVINGSIZECOL
            || ', n.Description '
            || IAPICONSTANTCOLUMN.VALUETYPECOL
            || ', d.Relative_Perc '
            || IAPICONSTANTCOLUMN.RELATIVEPERCCOL
            || ', d.Relative_Comp '
            || IAPICONSTANTCOLUMN.RELATIVECOMPCOL
            || ', d.Actual_Value '
            || IAPICONSTANTCOLUMN.ACTUALVALUECOL
            || ', d.Result '
            || IAPICONSTANTCOLUMN.RESULTCOL
            || ', d.Parent_Food_Claim_Id '
            || IAPICONSTANTCOLUMN.PARENTFOODCLAIMIDCOL
            || ', d.Parent_Seq_No '
            || IAPICONSTANTCOLUMN.PARENTSEQUENCECOL
            || ', d.Error_Code '
            || IAPICONSTANTCOLUMN.ERRORCODECOL
            || ', d.Attribute_id '
            || IAPICONSTANTCOLUMN.ATTRIBUTEIDCOL;
      LSFROM                        IAPITYPE.SQLSTRING_TYPE := ' FROM itFoodClaimResultDetail d, itNutLyType n ';
      LSWHERE                       IAPITYPE.SQLSTRING_TYPE
         :=    ' WHERE d.Req_Id = '
            || ANWEBRQ
            || 'AND d.Log_Id = '
            || ANLOGID
            || 'AND d.Food_Claim_Id = '
            || ANFOODCLAIMID
            || 'AND d.Parent_Food_Claim_Id = '
            || ANCONDITIONFOODCLAIMID
            || 'AND n.Id(+) = d.Value_Type';
      LSWHERENULL                   IAPITYPE.SQLSTRING_TYPE := ' WHERE 1 = 2';
      LSORDER                       IAPITYPE.SQLSTRING_TYPE := ' ORDER BY d.Food_Claim_Id, d.Seq_No ';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
   BEGIN
      
       
       
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQDETAILS%ISOPEN )
      THEN
         CLOSE AQDETAILS;
      END IF;

      
      LSSQL :=    LSSELECT
               || LSFROM
               || LSWHERENULL;
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQDETAILS FOR LSSQL;

      
      IF ( AQDETAILS%ISOPEN )
      THEN
         CLOSE AQDETAILS;
      END IF;

      LSSQL :=    LSSELECT
               || LSFROM
               || LSWHERE
               || LSORDER;
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQDETAILS FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF AQDETAILS%ISOPEN
         THEN
            CLOSE AQDETAILS;
         END IF;

         LSSQL :=    LSSELECT
                  || LSFROM
                  || LSWHERENULL;
         IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                      LSMETHOD,
                                      LSSQL,
                                      IAPICONSTANT.INFOLEVEL_3 );

         OPEN AQDETAILS FOR LSSQL;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETRESULTDETAILS;


   FUNCTION GETFOODCLAIMLOGLABEL(
      ANLOGID                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ALLOGLABEL                 OUT      IAPITYPE.CLOB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetFoodClaimLogLabel';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT COUNT( * )
        INTO LNCOUNT
        FROM ITFOODCLAIMLOG
       WHERE LOG_ID = ANLOGID;

      IF LNCOUNT > 0
      THEN
         SELECT LABEL
           INTO ALLOGLABEL
           FROM ITFOODCLAIMLOG
          WHERE LOG_ID = ANLOGID;
      ELSE
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_LABELNOTFOUND,
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
   END GETFOODCLAIMLOGLABEL;


   FUNCTION GETFOODCLAIMLOG(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      AQFOODCLAIMLOG             OUT      IAPITYPE.REF_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE DEFAULT NULL,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE DEFAULT NULL,
      ANUSAGE                    IN       IAPITYPE.BOMUSAGE_TYPE DEFAULT NULL )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetFoodClaimLog';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETCOLUMNSFOODCLAIMLOG( 'fc' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'ITFOODCLAIMLOG fc';
   BEGIN





      IF ( AQFOODCLAIMLOG%ISOPEN )
      THEN
         CLOSE AQFOODCLAIMLOG;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE fc.log_id = NULL';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQLNULL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQFOODCLAIMLOG FOR LSSQLNULL;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM;
      LSSQL :=    LSSQL
               || ' WHERE part_no = '
               || ''''
               || ASPARTNO
               || '''';

      
       
       
      
      IF ANREVISION IS NOT NULL
      THEN
         LSSQL :=    LSSQL
                  || ' AND revision = '
                  || ANREVISION;
      END IF;

      IF ASPLANT IS NOT NULL
      THEN
         LSSQL :=    LSSQL
                  || ' AND plant = '
                  || ''''
                  || ASPLANT
                  || '''';
      END IF;

      IF ANALTERNATIVE IS NOT NULL
      THEN
         LSSQL :=    LSSQL
                  || ' AND alternative = '
                  || ANALTERNATIVE;
      END IF;

      IF ANUSAGE IS NOT NULL
      THEN
         LSSQL :=    LSSQL
                  || ' AND bom_usage = '
                  || ANUSAGE;
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY fc.log_name';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQFOODCLAIMLOG%ISOPEN )
      THEN
         CLOSE AQFOODCLAIMLOG;
      END IF;

      OPEN AQFOODCLAIMLOG FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETFOODCLAIMLOG;


   FUNCTION GETFOODCLAIMLOGRESULT(
      ANLOGID                    IN       IAPITYPE.SEQUENCENR_TYPE,
      AQFOODCLAIMLOGRESULT       OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetFoodClaimLogResult';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
   BEGIN





      IF ( AQFOODCLAIMLOGRESULT%ISOPEN )
      THEN
         CLOSE AQFOODCLAIMLOGRESULT;
      END IF;

      LSSQLNULL :=
            'SELECT '
         || '  r.Log_Id '
         || IAPICONSTANTCOLUMN.LOGIDCOL
         || ', l.Log_Name '
         || IAPICONSTANTCOLUMN.LOGNAMECOL
         || ', r.Nut_Log_Id '
         || IAPICONSTANTCOLUMN.NUTLOGIDCOL
         || ', r.Food_Claim_Id '
         || IAPICONSTANTCOLUMN.FOODCLAIMIDCOL
         || ', r.food_claim_description '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ', r.Result '
         || IAPICONSTANTCOLUMN.RESULTCOL
         || ', r.Comp_Log_Id '
         || IAPICONSTANTCOLUMN.COMPARISONPROFILECOL
         || ', f_foodclaim_descr(r.Food_Claim_Id, 0) '
         || IAPICONSTANTCOLUMN.FOODCLAIMDESCRIPTIONCOL
         || ', c.Log_Name '
         || IAPICONSTANTCOLUMN.COMPARISONPROFILEDESCRCOL
         || ', c.Part_No '
         || IAPICONSTANTCOLUMN.COMPARISONPRODUCTCOL
         || ', f_part_descr(1, c.Part_No) '
         || IAPICONSTANTCOLUMN.COMPARISONPRODUCTDESCRCOL
         || ', F_SERVSIZE_REFWeight_DESCR( c.ref_spec, c.Serving_size_id, c.Result_Weight ) '
         || IAPICONSTANTCOLUMN.COMPARISONSERVINGSIZECOL
         || ', r.Dec_Sep '
         || IAPICONSTANTCOLUMN.DECSEPCOL
         || '  FROM itFoodClaimLogResult r, '
         || '       itNutLog l, '
         || '       itNutLog c, '
         || '       itNutLyGroup g '
         || ' WHERE r.log_id = NULL';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQLNULL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQFOODCLAIMLOGRESULT FOR LSSQLNULL;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=
            'SELECT '
         || '  r.Log_Id '
         || IAPICONSTANTCOLUMN.LOGIDCOL
         || ', l.Log_Name '
         || IAPICONSTANTCOLUMN.LOGNAMECOL
         || ', r.Nut_Log_Id '
         || IAPICONSTANTCOLUMN.NUTLOGIDCOL
         || ', r.Food_Claim_Id '
         || IAPICONSTANTCOLUMN.FOODCLAIMIDCOL
         || ', r.food_claim_description '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ', r.Result '
         || IAPICONSTANTCOLUMN.RESULTCOL
         || ', r.Comp_Log_Id '
         || IAPICONSTANTCOLUMN.COMPARISONPROFILECOL
         || ', f_foodclaim_descr(r.Food_Claim_Id, 0) '
         || IAPICONSTANTCOLUMN.FOODCLAIMDESCRIPTIONCOL
         || ', c.Log_Name '
         || IAPICONSTANTCOLUMN.COMPARISONPROFILEDESCRCOL
         || ', c.Part_No '
         || IAPICONSTANTCOLUMN.COMPARISONPRODUCTCOL
         || ', f_part_descr(1, c.Part_No) '
         || IAPICONSTANTCOLUMN.COMPARISONPRODUCTDESCRCOL
         || ', F_SERVSIZE_REFWeight_DESCR( c.ref_spec, c.Serving_size_id, c.Result_Weight ) '
         || IAPICONSTANTCOLUMN.COMPARISONSERVINGSIZECOL
         || ', r.Dec_Sep '
         || IAPICONSTANTCOLUMN.DECSEPCOL
         || '  FROM itFoodClaimLogResult r, '
         || '       itNutLog l, '
         || '       itNutLog c, '
         || '       itNutLyGroup g '
         || ' WHERE r.Log_Id = '
         || ANLOGID
         || '   AND l.Log_id = r.Nut_Log_Id '
         || '   AND c.Log_id (+)= r.Comp_Log_Id '
         || '   AND g.Id (+)= r.Comp_Group_Id '
         || ' ORDER BY l.Log_Name, '
         || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
         || ' ASC ';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQFOODCLAIMLOGRESULT%ISOPEN )
      THEN
         CLOSE AQFOODCLAIMLOGRESULT;
      END IF;

      OPEN AQFOODCLAIMLOGRESULT FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETFOODCLAIMLOGRESULT;


   FUNCTION GETFOODCLAIMLOGRESULTDETAIL(
      ANLOGID                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANNUTLOGID                 IN       IAPITYPE.SEQUENCENR_TYPE,
      ANFOODCLAIMID              IN       IAPITYPE.SEQUENCENR_TYPE,
      ANCONDITIONFOODCLAIMID     IN       IAPITYPE.SEQUENCENR_TYPE,
      AQFOODCLAIMLOGRESULTDETAILS OUT     IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetFoodClaimLogResultDetail';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETCOLUMNSFOODCLAIMLOGRESULTD( 'fc' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'ITFOODCLAIMLOGRESULTDETAILS fc';
   BEGIN





      IF ( AQFOODCLAIMLOGRESULTDETAILS%ISOPEN )
      THEN
         CLOSE AQFOODCLAIMLOGRESULTDETAILS;
      END IF;

      LSSQLNULL :=
            'SELECT '
         || ' d.Log_id '
         || IAPICONSTANTCOLUMN.LOGIDCOL
         || ', d.Food_Claim_Id '
         || IAPICONSTANTCOLUMN.FOODCLAIMIDCOL
         || ', d.Nut_Log_Id '
         || IAPICONSTANTCOLUMN.NUTLOGIDCOL
         || ', d.Food_Claim_Crit_Rule_Cd_Id '
         || IAPICONSTANTCOLUMN.FOODCLAIMCRITRULECDIDCOL
         || ', d.Hier_Level '
         || IAPICONSTANTCOLUMN.HIERARCHICALLEVELCOL
         || ', d.Seq_No '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ', d.Ref_Type '
         || IAPICONSTANTCOLUMN.REFTYPECOL
         || ', d.Ref_Id '
         || IAPICONSTANTCOLUMN.REFIDCOL
         || ', f_FoodClaim_ResRule_Descr(d.Ref_Id, d.Ref_Type) '
         || IAPICONSTANTCOLUMN.RULEDESCRIPTIONCOL
         || ', d.And_Or '
         || IAPICONSTANTCOLUMN.ANDORCOL
         || ', d.Rule_Type '
         || IAPICONSTANTCOLUMN.RULETYPECOL
         || ', d.Rule_Id '
         || IAPICONSTANTCOLUMN.RULEIDCOL
         || ', f_FoodClaim_ResCondition_Descr(d.Rule_Id, d.Attribute_Id, d.Rule_Type) '
         || IAPICONSTANTCOLUMN.CONDITIONDESCRIPTIONCOL
         || ', d.Rule_Operator '
         || IAPICONSTANTCOLUMN.RULEOPERATORCOL

         || ', F_FOODCLAIM_CONDVALUE_DESC(d.Rule_Value_1) '
         || IAPICONSTANTCOLUMN.RULEVALUE1COL
         || ', d.Rule_Value_2 '
         || IAPICONSTANTCOLUMN.RULEVALUE2COL
         || ', d.Serving_Size '
         || IAPICONSTANTCOLUMN.SERVINGSIZECOL
         || ', n.Description '
         || IAPICONSTANTCOLUMN.VALUETYPECOL
         || ', d.Relative_Perc '
         || IAPICONSTANTCOLUMN.RELATIVEPERCCOL
         || ', d.Relative_Comp '
         || IAPICONSTANTCOLUMN.RELATIVECOMPCOL
         || ', d.Actual_Value '
         || IAPICONSTANTCOLUMN.ACTUALVALUECOL
         || ', d.Result '
         || IAPICONSTANTCOLUMN.RESULTCOL
         || ', d.Parent_Food_Claim_Id '
         || IAPICONSTANTCOLUMN.PARENTFOODCLAIMIDCOL
         || ', d.Parent_Seq_No '
         || IAPICONSTANTCOLUMN.PARENTSEQUENCECOL
         || ', d.Error_Code '
         || IAPICONSTANTCOLUMN.ERRORCODECOL
         || ', d.Attribute_Id '
         || IAPICONSTANTCOLUMN.ATTRIBUTEIDCOL
         || ' FROM ITFOODCLAIMLOGRESULTDETAILS D, ITNUTLYTYPE N '
         || ' WHERE d.log_id = NULL'
         || ' and d.value_Type = n.id(+)';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQLNULL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQFOODCLAIMLOGRESULTDETAILS FOR LSSQLNULL;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=
            'SELECT '
         || ' d.Log_id '
         || IAPICONSTANTCOLUMN.LOGIDCOL
         || ', d.Food_Claim_Id '
         || IAPICONSTANTCOLUMN.FOODCLAIMIDCOL
         || ', d.Nut_Log_Id '
         || IAPICONSTANTCOLUMN.NUTLOGIDCOL
         || ', d.Food_Claim_Crit_Rule_Cd_Id '
         || IAPICONSTANTCOLUMN.FOODCLAIMCRITRULECDIDCOL
         || ', d.Hier_Level '
         || IAPICONSTANTCOLUMN.HIERARCHICALLEVELCOL
         || ', d.Seq_No '
         || IAPICONSTANTCOLUMN.SEQUENCECOL
         || ', d.Ref_Type '
         || IAPICONSTANTCOLUMN.REFTYPECOL
         || ', d.Ref_Id '
         || IAPICONSTANTCOLUMN.REFIDCOL
         || ', f_FoodClaim_ResRule_Descr(d.Ref_Id, d.Ref_Type) '
         || IAPICONSTANTCOLUMN.RULEDESCRIPTIONCOL
         || ', d.And_Or '
         || IAPICONSTANTCOLUMN.ANDORCOL
         || ', d.Rule_Type '
         || IAPICONSTANTCOLUMN.RULETYPECOL
         || ', d.Rule_Id '
         || IAPICONSTANTCOLUMN.RULEIDCOL
         || ', f_FoodClaim_ResCondition_Descr(d.Rule_Id, d.Attribute_Id, d.Rule_Type) '
         || IAPICONSTANTCOLUMN.CONDITIONDESCRIPTIONCOL
         || ', d.Rule_Operator '
         || IAPICONSTANTCOLUMN.RULEOPERATORCOL

         || ', F_FOODCLAIM_CONDVALUE_DESC(d.Rule_Value_1) '
         || IAPICONSTANTCOLUMN.RULEVALUE1COL
         || ', d.Rule_Value_2 '
         || IAPICONSTANTCOLUMN.RULEVALUE2COL
         || ', d.Serving_Size '
         || IAPICONSTANTCOLUMN.SERVINGSIZECOL
         || ', n.description '
         || IAPICONSTANTCOLUMN.VALUETYPECOL
         || ', d.Relative_Perc '
         || IAPICONSTANTCOLUMN.RELATIVEPERCCOL
         || ', d.Relative_Comp '
         || IAPICONSTANTCOLUMN.RELATIVECOMPCOL
         || ', d.Actual_Value '
         || IAPICONSTANTCOLUMN.ACTUALVALUECOL
         || ', d.Result '
         || IAPICONSTANTCOLUMN.RESULTCOL
         || ', d.Parent_Food_Claim_Id '
         || IAPICONSTANTCOLUMN.PARENTFOODCLAIMIDCOL
         || ', d.Parent_Seq_No '
         || IAPICONSTANTCOLUMN.PARENTSEQUENCECOL
         || ', d.Error_Code '
         || IAPICONSTANTCOLUMN.ERRORCODECOL
         || ', d.Attribute_Id '
         || IAPICONSTANTCOLUMN.ATTRIBUTEIDCOL
         || ' FROM ITFOODCLAIMLOGRESULTDETAILS D, itnutlytype n '
         || ' WHERE d.Log_Id = '
         || ANLOGID
         || ' AND d.Nut_Log_Id = '
         || ANNUTLOGID
         || ' AND d.Food_Claim_Id = '
         || ANFOODCLAIMID
         || ' AND d.Parent_Food_Claim_Id = '
         || ANCONDITIONFOODCLAIMID
         || ' and d.value_Type = n.id(+)'
         || ' ORDER BY d.Food_Claim_Id, d.Seq_No ';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQFOODCLAIMLOGRESULTDETAILS%ISOPEN )
      THEN
         CLOSE AQFOODCLAIMLOGRESULTDETAILS;
      END IF;

      OPEN AQFOODCLAIMLOGRESULTDETAILS FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETFOODCLAIMLOGRESULTDETAIL;


   FUNCTION GETLOGPROFILES(
      ANLOGID                    IN       IAPITYPE.SEQUENCENR_TYPE,
      AQLOGPROFILES              OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetLogProfiles';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
   BEGIN





      IF ( AQLOGPROFILES%ISOPEN )
      THEN
         CLOSE AQLOGPROFILES;
      END IF;

      LSSQLNULL :=
            'SELECT DISTINCT r.Nut_Log_Id '
         || IAPICONSTANTCOLUMN.LOGIDCOL
         || ', l.Log_Name '
         || IAPICONSTANTCOLUMN.LOGNAMECOL
         || ', F_SERVSIZE_REFWeight_DESCR( l.ref_spec, l.Serving_size_id, l.Result_Weight ) '
         || IAPICONSTANTCOLUMN.SERVINGSIZECOL
         || '           FROM itFoodClaimLogResult r, '
         || '                itNutLog l '
         || '          WHERE r.Log_Id = NULL'
         || '            AND l.Log_id = r.Nut_Log_Id '
         || '       ORDER BY l.Log_Name ASC ';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQLNULL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQLOGPROFILES FOR LSSQLNULL;




      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=
            'SELECT DISTINCT r.Nut_Log_Id '
         || IAPICONSTANTCOLUMN.LOGIDCOL
         || ', l.Log_Name '
         || IAPICONSTANTCOLUMN.LOGNAMECOL
         || ', F_SERVSIZE_REFWeight_DESCR( l.ref_spec, l.Serving_size_id, l.Result_Weight ) '
         || IAPICONSTANTCOLUMN.SERVINGSIZECOL
         || '           FROM itFoodClaimLogResult r, '
         || '                itNutLog l '
         || '          WHERE r.Log_Id = :Log_Id'
         || '            AND l.Log_id = r.Nut_Log_Id '
         || '       ORDER BY l.Log_Name ASC ';
      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   LSSQL,
                                   IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQLOGPROFILES%ISOPEN )
      THEN
         CLOSE AQLOGPROFILES;
      END IF;

      OPEN AQLOGPROFILES FOR LSSQL USING ANLOGID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETLOGPROFILES;


   FUNCTION SAVEFOODCLAIMLOG(
      ANLOGID                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ASLOGNAME                  IN       IAPITYPE.DESCRIPTION_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveFoodClaimLog';
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

      UPDATE ITFOODCLAIMLOG
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
   END SAVEFOODCLAIMLOG;


   FUNCTION ADDFOODCLAIMLOG(
      ASLOGNAME                  IN       IAPITYPE.DESCRIPTION_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE DEFAULT 0,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE DEFAULT NULL,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE DEFAULT NULL,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE DEFAULT NULL,
      ANBOMUSAGE                 IN       IAPITYPE.BOMUSAGE_TYPE DEFAULT NULL,
      ADEXPLOSIONDATE            IN       IAPITYPE.DATE_TYPE DEFAULT NULL,
      ASCREATEDBY                IN       IAPITYPE.USERID_TYPE DEFAULT NULL,
      ADCREATEDON                IN       IAPITYPE.DATE_TYPE DEFAULT SYSDATE,
      ALLABEL                    IN       IAPITYPE.CLOB_TYPE DEFAULT NULL,
      ANLANGUAGEID               IN       IAPITYPE.LANGUAGEID_TYPE,
      ANREFERENCEAMOUNT          IN       IAPITYPE.NUMVAL_TYPE,
      ALLOGGINGXML               IN       IAPITYPE.CLOB_TYPE,
      ANLOGID                    OUT      IAPITYPE.SEQUENCENR_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddFoodClaimLog';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSCREATEDBY                   IAPITYPE.USERID_TYPE;
   BEGIN








      IF ASCREATEDBY IS NULL
      THEN
         LSCREATEDBY := IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
      ELSE
         LSCREATEDBY := ASCREATEDBY;
      END IF;

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

      
      IF ( ANLANGUAGEID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Language' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anLanguage',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANREFERENCEAMOUNT IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Reference Amount' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anReferenceAmount',
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

      INSERT INTO ITFOODCLAIMLOG
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
                    LANGUAGE_ID,
                    REFERENCE_AMOUNT,
                    LOGGINGXML )
           VALUES ( ITFOODCLAIMLOG_SEQ.NEXTVAL,
                    ASLOGNAME,
                    ANSTATUS,
                    ASPARTNO,
                    ANREVISION,
                    ASPLANT,
                    ANALTERNATIVE,
                    ANBOMUSAGE,
                    ADEXPLOSIONDATE,
                    ASCREATEDBY,
                    ADCREATEDON,
                    ALLABEL,
                    ANLANGUAGEID,
                    ANREFERENCEAMOUNT,
                    ALLOGGINGXML );

      
      SELECT ITFOODCLAIMLOG_SEQ.CURRVAL
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
   END ADDFOODCLAIMLOG;


   FUNCTION SAVEFOODCLAIMRESULTDESCRIPTION(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANLOGID                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANFOODCLAIMID              IN       IAPITYPE.SEQUENCENR_TYPE,
      ANFOODCLAIMDESCRIPTION     IN       IAPITYPE.DESCRIPTION_TYPE DEFAULT NULL,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveFoodClaimResultDescription';
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
                                                         'WebRq' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'WebRq',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
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

      
      IF ( ANFOODCLAIMID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'FoodClaimId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anFoodClaimId',
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

      UPDATE ITFOODCLAIMRESULT
         SET FOOD_CLAIM_DESCRIPTION = ANFOODCLAIMDESCRIPTION
       WHERE REQ_ID = ANWEBRQ
         AND LOG_ID = ANLOGID
         AND FOOD_CLAIM_ID = ANFOODCLAIMID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEFOODCLAIMRESULTDESCRIPTION;


   FUNCTION ADDFOODCLAIMLOGRESULT(
      ANLOGID                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANFOODCLAIMID              IN       IAPITYPE.SEQUENCENR_TYPE,
      ANNUTLOGID                 IN       IAPITYPE.SEQUENCENR_TYPE,
      ANRESULT                   IN       IAPITYPE.CLAIMSRESULTTYPE_TYPE,
      ANCOMPLOGID                IN       IAPITYPE.SEQUENCENR_TYPE DEFAULT NULL,
      ANCOMPGROUPID              IN       IAPITYPE.SEQUENCENR_TYPE DEFAULT NULL,
      ANFOODCLAIMDESCRIPTION     IN       IAPITYPE.DESCRIPTION_TYPE DEFAULT NULL,
      ASDECSEP                   IN       IAPITYPE.DECIMALSEPERATOR_TYPE DEFAULT NULL,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddFoodClaimLogResult';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSDECSEP                      IAPITYPE.DECIMALSEPERATOR_TYPE;
   BEGIN








      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ASDECSEP IS NULL
      THEN
         LSDECSEP := IAPIGENERAL.GETDBDECIMALSEPERATOR;
      ELSE
         LSDECSEP := ASDECSEP;
      END IF;

      
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

      
      IF ( ANFOODCLAIMID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'FoodClaimId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anFoodClaimId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANNUTLOGID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'NutLogId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anNutLogId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANRESULT IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'Result' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anResult',
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

      INSERT INTO ITFOODCLAIMLOGRESULT
                  ( LOG_ID,
                    FOOD_CLAIM_ID,
                    NUT_LOG_ID,
                    RESULT,
                    COMP_LOG_ID,
                    COMP_GROUP_ID,
                    FOOD_CLAIM_DESCRIPTION,
                    DEC_SEP )
           VALUES ( ANLOGID,
                    ANFOODCLAIMID,
                    ANNUTLOGID,
                    ANRESULT,
                    ANCOMPLOGID,
                    ANCOMPGROUPID,
                    ANFOODCLAIMDESCRIPTION,
                    LSDECSEP );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_FOODCLAIMLOGRESULTEXISTS,
                                                     ANLOGID,
                                                     ANFOODCLAIMID,
                                                     ANNUTLOGID ) );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDFOODCLAIMLOGRESULT;


   FUNCTION ADDFOODCLAIMLOGRESULTDETAILS(
      ANLOGID                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANFOODCLAIMID              IN       IAPITYPE.SEQUENCENR_TYPE,
      ANFOODCLAIMCRITRULECDID    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANHIERLEVEL                IN       IAPITYPE.SEQUENCENR_TYPE,
      ANNUTLOGID                 IN       IAPITYPE.SEQUENCENR_TYPE,
      ANSEQNO                    IN       IAPITYPE.SEQUENCENR_TYPE DEFAULT NULL,
      ANREFTYPE                  IN       IAPITYPE.CLAIMRESULTDREFTYPE_TYPE DEFAULT NULL,
      ANREFID                    IN       IAPITYPE.SEQUENCENR_TYPE DEFAULT NULL,
      ASANDOR                    IN       IAPITYPE.CLAIMRESULTDANDOR_TYPE DEFAULT NULL,
      ANRULETYPE                 IN       IAPITYPE.CLAIMRESULTDRULETYPE_TYPE DEFAULT NULL,
      ANRULEID                   IN       IAPITYPE.SEQUENCENR_TYPE DEFAULT NULL,
      ASRULEOPERATOR             IN       IAPITYPE.SHORTDESCRIPTION_TYPE DEFAULT NULL,
      ASRULEVALUE1               IN       IAPITYPE.DESCRIPTION_TYPE DEFAULT NULL,
      ASRULEVALUE2               IN       IAPITYPE.DESCRIPTION_TYPE DEFAULT NULL,
      ASSERVINGSIZE              IN       IAPITYPE.DESCRIPTION_TYPE DEFAULT NULL,
      ANVALUETYPE                IN       IAPITYPE.CLAIMRESULTDVALUETYPE_TYPE DEFAULT NULL,
      ANRELATIVEPERC             IN       IAPITYPE.CLAIMRESULTDRELATIVEPERC_TYPE DEFAULT NULL,
      ANRELATIVECOMP             IN       IAPITYPE.CLAIMRESULTDRELATIVECOMP_TYPE DEFAULT NULL,
      ASACTUALVALUE              IN       IAPITYPE.SHORTDESCRIPTION_TYPE DEFAULT NULL,
      ANRESULT                   IN       IAPITYPE.CLAIMSRESULTTYPE_TYPE DEFAULT NULL,
      ANPARENTFOODCLAIMID        IN       IAPITYPE.SEQUENCENR_TYPE,
      ANPARENTSEQNO              IN       IAPITYPE.SEQUENCENR_TYPE,
      ANERRORCODE                IN       IAPITYPE.ERRORNUM_TYPE DEFAULT 0,
      ANATTRIBUTEID              IN       IAPITYPE.SEQUENCENR_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddFoodClaimLogResultDetails';
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

      
      IF ( ANFOODCLAIMID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'FoodClaimId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anFoodClaimId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANFOODCLAIMCRITRULECDID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'FoodClaimCritRuleCdId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anFoodClaimCritRuleCdId',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANHIERLEVEL IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'HierLevel' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anHierLevel',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
      END IF;

      
      IF ( ANNUTLOGID IS NULL )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                         'NutLogId' );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'anNutLogId',
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

      INSERT INTO ITFOODCLAIMLOGRESULTDETAILS
                  ( LOG_ID,
                    FOOD_CLAIM_ID,
                    FOOD_CLAIM_CRIT_RULE_CD_ID,
                    HIER_LEVEL,
                    NUT_LOG_ID,
                    SEQ_NO,
                    REF_TYPE,
                    REF_ID,
                    AND_OR,
                    RULE_TYPE,
                    RULE_ID,
                    RULE_OPERATOR,
                    RULE_VALUE_1,
                    RULE_VALUE_2,
                    SERVING_SIZE,
                    VALUE_TYPE,
                    RELATIVE_PERC,
                    RELATIVE_COMP,
                    ACTUAL_VALUE,
                    PARENT_FOOD_CLAIM_ID,
                    PARENT_SEQ_NO,
                    ERROR_CODE,
                    RESULT,
                    ATTRIBUTE_ID )
           VALUES ( ANLOGID,
                    ANFOODCLAIMID,
                    ANFOODCLAIMCRITRULECDID,
                    ANHIERLEVEL,
                    ANNUTLOGID,
                    ANSEQNO,
                    ANREFTYPE,
                    ANREFID,
                    ASANDOR,
                    ANRULETYPE,
                    ANRULEID,
                    ASRULEOPERATOR,
                    ASRULEVALUE1,
                    ASRULEVALUE2,
                    ASSERVINGSIZE,
                    ANVALUETYPE,
                    ANRELATIVEPERC,
                    ANRELATIVECOMP,
                    ASACTUALVALUE,
                    ANPARENTFOODCLAIMID,
                    ANPARENTSEQNO,
                    ANERRORCODE,
                    ANRESULT,
                    ANATTRIBUTEID );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_FOODCLAIMLOGRESDETEXISTS,
                                                     ANLOGID,
                                                     ANFOODCLAIMID,
                                                     ANFOODCLAIMCRITRULECDID,
                                                     ANHIERLEVEL,
                                                     ANNUTLOGID ) );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDFOODCLAIMLOGRESULTDETAILS;


   FUNCTION ADDFOODCLAIMPANEL(
      ANWEBRQ                    IN       IAPITYPE.SEQUENCENR_TYPE,
      ANNUTLOGID                 IN       IAPITYPE.SEQUENCENR_TYPE,
      ASLOGNAME                  IN       IAPITYPE.DESCRIPTION_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE DEFAULT 0,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE DEFAULT NULL,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE DEFAULT NULL,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE DEFAULT NULL,
      ANALTERNATIVE              IN       IAPITYPE.BOMALTERNATIVE_TYPE DEFAULT NULL,
      ANBOMUSAGE                 IN       IAPITYPE.BOMUSAGE_TYPE DEFAULT NULL,
      ADEXPLOSIONDATE            IN       IAPITYPE.DATE_TYPE DEFAULT NULL,
      ASCREATEDBY                IN       IAPITYPE.USERID_TYPE DEFAULT NULL,
      ADCREATEDON                IN       IAPITYPE.DATE_TYPE DEFAULT SYSDATE,
      ALLABEL                    IN       IAPITYPE.CLOB_TYPE DEFAULT NULL,
      ANLANGUAGEID               IN       IAPITYPE.LANGUAGEID_TYPE,
      ANRESULT                   IN       IAPITYPE.CLAIMSRESULTTYPE_TYPE,
      ALLOGGINGXML               IN       IAPITYPE.CLOB_TYPE,
      ASDECSEP                   IN       IAPITYPE.DECIMALSEPERATOR_TYPE DEFAULT NULL,
      ANLOGID                    OUT      IAPITYPE.SEQUENCENR_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      CURSOR LQFOODCLAIMRESULT
      IS
         SELECT *
           FROM ITFOODCLAIMRESULT
          WHERE REQ_ID = ANWEBRQ
            AND LOG_ID = ANNUTLOGID;

      CURSOR LQFOODCLAIMRESULTDETAIL
      IS
         SELECT *
           FROM ITFOODCLAIMRESULTDETAIL
          WHERE REQ_ID = ANWEBRQ
            AND LOG_ID = ANNUTLOGID;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddFoodClaimPanel';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNLOGID                       IAPITYPE.SEQUENCENR_TYPE;
      LSCREATEDBY                   IAPITYPE.USERID_TYPE;
      LSDECSEP                      IAPITYPE.DECIMALSEPERATOR_TYPE;
   BEGIN








     
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ASDECSEP IS NULL
      THEN
         LSDECSEP := IAPIGENERAL.GETDBDECIMALSEPERATOR;
      ELSE
         LSDECSEP := ASDECSEP;
      END IF;

      IF ASCREATEDBY IS NULL
      THEN
         LSCREATEDBY := IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
      ELSE
         LSCREATEDBY := ASCREATEDBY;
      END IF;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      
      LNRETVAL :=
         IAPIFOODCLAIMS.ADDFOODCLAIMLOG( ASLOGNAME,
                                         ANSTATUS,
                                         ASPARTNO,
                                         ANREVISION,
                                         ASPLANT,
                                         ANALTERNATIVE,
                                         ANBOMUSAGE,
                                         ADEXPLOSIONDATE,
                                         LSCREATEDBY,
                                         ADCREATEDON,
                                         ALLABEL,
                                         ANLANGUAGEID,
                                         GETREFERENCEAMOUNT( ANWEBRQ ),
                                         ALLOGGINGXML,
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

      
      FOR LRFOODCLAIMRESULT IN LQFOODCLAIMRESULT
      LOOP
         LNRETVAL :=
            IAPIFOODCLAIMS.ADDFOODCLAIMLOGRESULT( ANLOGID,
                                                  LRFOODCLAIMRESULT.FOOD_CLAIM_ID,
                                                  LRFOODCLAIMRESULT.LOG_ID,
                                                  LRFOODCLAIMRESULT.RESULT,
                                                  LRFOODCLAIMRESULT.COMP_LOG_ID,
                                                  LRFOODCLAIMRESULT.COMP_GROUP_ID,
                                                  LRFOODCLAIMRESULT.FOOD_CLAIM_DESCRIPTION,
                                                  LRFOODCLAIMRESULT.DEC_SEP,
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

      
      FOR LRFOODCLAIMRESULTDETAIL IN LQFOODCLAIMRESULTDETAIL
      LOOP
         LNRETVAL :=
            IAPIFOODCLAIMS.ADDFOODCLAIMLOGRESULTDETAILS( ANLOGID,
                                                         LRFOODCLAIMRESULTDETAIL.FOOD_CLAIM_ID,
                                                         LRFOODCLAIMRESULTDETAIL.FOOD_CLAIM_CRIT_RULE_CD_ID,
                                                         LRFOODCLAIMRESULTDETAIL.HIER_LEVEL,
                                                         LRFOODCLAIMRESULTDETAIL.LOG_ID,
                                                         LRFOODCLAIMRESULTDETAIL.SEQ_NO,
                                                         LRFOODCLAIMRESULTDETAIL.REF_TYPE,
                                                         LRFOODCLAIMRESULTDETAIL.REF_ID,
                                                         LRFOODCLAIMRESULTDETAIL.AND_OR,
                                                         LRFOODCLAIMRESULTDETAIL.RULE_TYPE,
                                                         LRFOODCLAIMRESULTDETAIL.RULE_ID,
                                                         LRFOODCLAIMRESULTDETAIL.RULE_OPERATOR,
                                                         LRFOODCLAIMRESULTDETAIL.RULE_VALUE_1,
                                                         LRFOODCLAIMRESULTDETAIL.RULE_VALUE_2,
                                                         LRFOODCLAIMRESULTDETAIL.SERVING_SIZE,
                                                         LRFOODCLAIMRESULTDETAIL.VALUE_TYPE,
                                                         LRFOODCLAIMRESULTDETAIL.RELATIVE_PERC,
                                                         LRFOODCLAIMRESULTDETAIL.RELATIVE_COMP,
                                                         LRFOODCLAIMRESULTDETAIL.ACTUAL_VALUE,
                                                         LRFOODCLAIMRESULTDETAIL.RESULT,
                                                         LRFOODCLAIMRESULTDETAIL.PARENT_FOOD_CLAIM_ID,
                                                         LRFOODCLAIMRESULTDETAIL.PARENT_SEQ_NO,
                                                         LRFOODCLAIMRESULTDETAIL.ERROR_CODE,
                                                         LRFOODCLAIMRESULTDETAIL.ATTRIBUTE_ID,
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
   END ADDFOODCLAIMPANEL;
END IAPIFOODCLAIMS;
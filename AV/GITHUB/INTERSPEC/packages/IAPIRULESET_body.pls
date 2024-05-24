CREATE OR REPLACE PACKAGE BODY iapiRuleSet
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





   



   FUNCTION GETRULESET(
      ANRULEID                   IN       IAPITYPE.SEQUENCE_TYPE,
      AQRULESETS                 OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetRuleSets';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' a.RULE_ID '
            || IAPICONSTANTCOLUMN.RULEIDCOL
            || ', a.NAME '
            || IAPICONSTANTCOLUMN.NAMECOL
            || ', a.DESCRIPTION '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', a.CREATED_ON '
            || IAPICONSTANTCOLUMN.CREATEDONCOL
            || ', a.RULE_TYPE '
            || IAPICONSTANTCOLUMN.RULETYPECOL
            || ', xmltype.GETCLOBVAL( a.RuleSet ) '
            || IAPICONSTANTCOLUMN.RULESETCOL
            || ', a.FRAME_NO '
            || IAPICONSTANTCOLUMN.FRAMENOCOL
            || ', a.REVISION '
            || IAPICONSTANTCOLUMN.FRAMEREVISIONCOL
            || ', a.IS_DEFAULT '
            || IAPICONSTANTCOLUMN.ISDEFAULT;

      LSFROM                        IAPITYPE.STRING_TYPE := ' FROM itruleset a';
      LSWHERE                       IAPITYPE.STRING_TYPE := ' WHERE  RULE_ID = :anRuleId ';
   BEGIN      
      LSSQL :=    'Select '
               || LSSELECT
               || LSFROM
               || LSWHERE;


      
      IF ( AQRULESETS%ISOPEN )
      THEN
         CLOSE AQRULESETS;
      END IF;

      OPEN AQRULESETS FOR LSSQL USING 0;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
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

      
      IF ( AQRULESETS%ISOPEN )
      THEN
         CLOSE AQRULESETS;
      END IF;

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                      'anRuleId='
                                   || ANRULEID
                                   || '  lssql=  '
                                   || LSSQL );


      OPEN AQRULESETS FOR LSSQL USING ANRULEID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'Select '
                  || LSSELECT
                  || LSFROM
                  || LSWHERE;

         
         IF ( AQRULESETS%ISOPEN )
         THEN
            CLOSE AQRULESETS;
         END IF;

         OPEN AQRULESETS FOR LSSQL USING ANRULEID;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETRULESET;


   FUNCTION REMOVERULESET(
      ANRULEID                   IN       IAPITYPE.SEQUENCE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveRuleSets';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      DELETE FROM ITRULESET
            WHERE RULE_ID = ANRULEID;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_RULESETNOTFOUND,
                                                    ANRULEID );
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Delete RuleId <'
                           || ANRULEID
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
   END REMOVERULESET;
   
   FUNCTION SAVERULESET(
      ANRULEID                   IN       IAPITYPE.SEQUENCE_TYPE,
      ASNAME                     IN       IAPITYPE.NAME_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ADCREATEDON                IN       IAPITYPE.DATE_TYPE,
      ANRULETYPE                 IN       IAPITYPE.SEQUENCE_TYPE,
      AXRULESET                  IN       IAPITYPE.XMLTYPE_TYPE,
      ANFRAMNO                   IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANISDEFAULT                IN       IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveRuleSets';
      LNCOUNTER                     IAPITYPE.NUMVAL_TYPE;

   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

        SELECT COUNT( * )
          INTO LNCOUNTER
            FROM ITRULESET 
             WHERE RULE_TYPE = ANRULETYPE
               AND FRAME_NO = ANFRAMNO
               AND IS_DEFAULT = 1;
      
        IF LNCOUNTER > 0 AND ANISDEFAULT = 1
           THEN 
             UPDATE ITRULESET 
                SET IS_DEFAULT = 0
               WHERE RULE_TYPE = ANRULETYPE
                 AND FRAME_NO = ANFRAMNO;           
        END IF;
      
        UPDATE ITRULESET
           SET NAME = ASNAME,
               DESCRIPTION = ASDESCRIPTION,
               CREATED_ON = ADCREATEDON,
               RULE_TYPE = ANRULETYPE,
               RULESET = AXRULESET,
               FRAME_NO = ANFRAMNO,
               REVISION = ANREVISION,
               IS_DEFAULT = ANISDEFAULT
         WHERE RULE_ID = ANRULEID;

        IF SQL%ROWCOUNT = 0
        THEN
           RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                      LSMETHOD,
                                                      IAPICONSTANTDBERROR.DBERR_RULESETNOTFOUND,
                                                      ANRULEID );
        END IF;

        IAPIGENERAL.LOGINFO( GSSOURCE,
                             LSMETHOD,
                                'Update RuleId <'
                             || ANRULEID
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
   END SAVERULESET;

   FUNCTION EXISTNAME(
      ASNAME                     IN       IAPITYPE.NAME_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistName';
      LNRULEID                      IAPITYPE.SEQUENCE_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT RULE_ID
        INTO LNRULEID
        FROM ITRULESET
       WHERE NAME = ASNAME;

      RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                 LSMETHOD,
                                                 IAPICONSTANTDBERROR.DBERR_RULESETNAMEFOUND,
                                                 ASNAME,
                                                 LNRULEID );
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
   END EXISTNAME;

   
   
   
   
   
   
   
   
   
   
   FUNCTION GETIDBYNAME(
      ASNAME                     IN       IAPITYPE.NAME_TYPE,
      ANRULEID                   OUT      IAPITYPE.SEQUENCE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetIdByName';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      ANRULEID := 0;

      SELECT RULE_ID
        INTO ANRULEID
        FROM ITRULESET
       WHERE NAME = ASNAME;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
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
   END GETIDBYNAME;

   FUNCTION EXISTRULETYPE(
      ANRULETYPE                 IN       IAPITYPE.SEQUENCE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExistRuleType';
      LNRULETYPE                    IAPITYPE.SEQUENCE_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT RULE_TYPE
        INTO LNRULETYPE
        FROM ITRULETYPE
       WHERE RULE_TYPE = ANRULETYPE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_RULETYPENOTFOUND,
                                                    ANRULETYPE );
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXISTRULETYPE;
   
   FUNCTION ADDRULESET(
      ANRULEID                   IN OUT   IAPITYPE.SEQUENCE_TYPE,
      ASNAME                     IN       IAPITYPE.NAME_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ADCREATEDON                IN       IAPITYPE.DATE_TYPE,
      ANRULETYPE                 IN       IAPITYPE.SEQUENCE_TYPE,
      AXRULESET                  IN       IAPITYPE.XMLTYPE_TYPE,
      ANFRAMNO                   IN       IAPITYPE.FRAMENO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANISDEFAULT                IN       IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LNCOUNTER                     IAPITYPE.NUMVAL_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddRuleSets';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      LNRETVAL := EXISTNAME( ASNAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      
      
      LNRETVAL := IAPIRULESET.EXISTRULETYPE( ANRULETYPE );

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
      
      
      
      
      
      IF IAPICONSTANTDBERROR.DBERR_SUCCESS = 0 THEN
          SELECT COUNT( * )
            INTO LNCOUNTER
            FROM ITRULESET 
           WHERE RULE_TYPE = ANRULETYPE
             AND FRAME_NO = ANFRAMNO
             AND IS_DEFAULT = 1;

                    
          IF LNCOUNTER > 0 AND ANISDEFAULT = 1
            THEN 
               UPDATE ITRULESET 
                  SET IS_DEFAULT = 0
                WHERE RULE_TYPE = ANRULETYPE
                  AND FRAME_NO = ANFRAMNO;           
          END IF;
         

          SELECT NVL( ANRULEID,
                      RULE_ID_SEQ.NEXTVAL )
            INTO ANRULEID
            FROM DUAL;

          INSERT INTO ITRULESET
                      ( RULE_ID,
                        NAME,
                        DESCRIPTION,
                        CREATED_ON,
                        RULE_TYPE,
                        RULESET,
                        FRAME_NO,
                        REVISION,
                        IS_DEFAULT )
               VALUES ( ANRULEID,
                        ASNAME,
                        ASDESCRIPTION,
                        ADCREATEDON,
                        ANRULETYPE,
                        AXRULESET,

                        ANFRAMNO,
                        ANREVISION,
                        ANISDEFAULT );

          RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;
      EXCEPTION
       WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      
   END ADDRULESET;

   FUNCTION GETRULESETS(
      ANRULETYPE                 IN       IAPITYPE.SEQUENCE_TYPE,
      AQRULESETS                 OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetRuleSets';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' a.RULE_ID '
            || IAPICONSTANTCOLUMN.RULEIDCOL
            || ', a.NAME '
            || IAPICONSTANTCOLUMN.NAMECOL
            || ', a.DESCRIPTION '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', a.CREATED_ON '
            || IAPICONSTANTCOLUMN.CREATEDONCOL
            || ', a.RULE_TYPE '
            || IAPICONSTANTCOLUMN.RULETYPECOL
            || ', xmltype.GETCLOBVAL( a.RuleSet ) '
            || IAPICONSTANTCOLUMN.RULESETCOL
            || ', a.FRAME_NO '
            || IAPICONSTANTCOLUMN.FRAMENOCOL
            || ', a.REVISION '
            || IAPICONSTANTCOLUMN.FRAMEREVISIONCOL
            || ', a.IS_DEFAULT '
            || IAPICONSTANTCOLUMN.ISDEFAULT;

      LSFROM                        IAPITYPE.STRING_TYPE := ' FROM itruleset a';
   BEGIN
      LSSQL :=    'Select '
               || LSSELECT
               || LSFROM
               || ' WHERE a.rule_type = :RuleType '
               || ' ORDER BY 7 ';

     
      IF ( AQRULESETS%ISOPEN )
      THEN
         CLOSE AQRULESETS;
      END IF;

      OPEN AQRULESETS FOR LSSQL USING 0; 

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      LNRETVAL := IAPIRULESET.EXISTRULETYPE( ANRULETYPE );

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

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      IF ( AQRULESETS%ISOPEN )
      THEN
         CLOSE AQRULESETS;
      END IF;

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                      ' anRuleType= '
                                   || ANRULETYPE
                                   || '  lssql=  '
                                   || LSSQL );

      OPEN AQRULESETS FOR LSSQL USING ANRULETYPE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'Select '
                  || LSSELECT
                  || LSFROM
                  || ' WHERE a.rule_type = :RuleType'
                  || ' ORDER BY 7 ';

         
         IF ( AQRULESETS%ISOPEN )
         THEN
            CLOSE AQRULESETS;
         END IF;

         OPEN AQRULESETS FOR LSSQL USING ANRULETYPE;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETRULESETS;
   
    
   FUNCTION GETRULESETSDISTFRAME(
      ANRULETYPE                 IN       IAPITYPE.SEQUENCE_TYPE,
      AQRULESETS                 OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
     IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetRuleSetsDistFrame';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' a.RULE_ID '
            || IAPICONSTANTCOLUMN.RULEIDCOL
            || ', a.NAME '
            || IAPICONSTANTCOLUMN.NAMECOL
            || ', a.DESCRIPTION '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', a.FRAME_NO '
            || IAPICONSTANTCOLUMN.FRAMEREVISIONCOL
            || ', f_get_frame_description( a.frame_no, a.revision) '
            || IAPICONSTANTCOLUMN.FRAMEDESCRIPTIONCOL
            || ', a.IS_DEFAULT '
            || IAPICONSTANTCOLUMN.ISDEFAULT;

      LSSELECT1                      IAPITYPE.SQLSTRING_TYPE
         :=    ' NULL '
            || IAPICONSTANTCOLUMN.RULEIDCOL
            || ', NULL '
            || IAPICONSTANTCOLUMN.NAMECOL
            || ', NULL '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', a.FRAME_NO '
            || IAPICONSTANTCOLUMN.FRAMEREVISIONCOL
            || ', NULL '
            || IAPICONSTANTCOLUMN.FRAMEDESCRIPTIONCOL
            || ', a.IS_DEFAULT '
            || IAPICONSTANTCOLUMN.ISDEFAULT;


      LSFROM                        IAPITYPE.STRING_TYPE := ' FROM itruleset a';
   BEGIN 
      LSSQL :=    '(Select '
               || LSSELECT
               || LSFROM
               || ' WHERE a.rule_type = :RuleType '
               || ' AND a.is_default = 1 ) '
               || ' UNION '
               || '(Select '
               || LSSELECT1
               || LSFROM
               || ' WHERE not exists (select 1 from itruleset b where b.frame_no = a.frame_no '
               || ' and b.rule_type = :RuleType '
               || ' and b.is_default = 1)) ';

               


     
      IF ( AQRULESETS%ISOPEN )
      THEN
         CLOSE AQRULESETS;
      END IF;

      OPEN AQRULESETS FOR LSSQL USING 0, 0; 

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      LNRETVAL := IAPIRULESET.EXISTRULETYPE( ANRULETYPE );

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

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      IF ( AQRULESETS%ISOPEN )
      THEN
         CLOSE AQRULESETS;
      END IF;

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                      ' anRuleType= '
                                   || ANRULETYPE
                                   || '  lssql=  '
                                   || LSSQL );

      OPEN AQRULESETS FOR LSSQL USING ANRULETYPE, ANRULETYPE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
      LSSQL :=    '(Select '
               || LSSELECT
               || LSFROM
               || ' WHERE a.rule_type = :RuleType '
               || ' AND a.is_default = 1 ) '
               || ' UNION '
               || '(Select '
               || LSSELECT1
               || LSFROM
               || ' WHERE not exists (select 1 from itruleset b where b.frame_no = a.frame_no '
               || ' and b.rule_type = :RuleType '
               || ' and b.is_default = 1)) ';



         
         IF ( AQRULESETS%ISOPEN )
         THEN
            CLOSE AQRULESETS;
         END IF;

         OPEN AQRULESETS FOR LSSQL USING ANRULETYPE, ANRULETYPE ;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETRULESETSDISTFRAME;

   FUNCTION GETRULESETSFORFRAME(
      ANRULETYPE                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANFRAMENO                  IN       IAPITYPE.FRAMENO_TYPE,
      AQRULESETS                 OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetRuleSets';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' a.RULE_ID '
            || IAPICONSTANTCOLUMN.RULEIDCOL
            || ', a.NAME '
            || IAPICONSTANTCOLUMN.NAMECOL
            || ', a.DESCRIPTION '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', a.CREATED_ON '
            || IAPICONSTANTCOLUMN.CREATEDONCOL
            || ', a.RULE_TYPE '
            || IAPICONSTANTCOLUMN.RULETYPECOL
            || ', xmltype.GETCLOBVAL( a.RuleSet ) '
            || IAPICONSTANTCOLUMN.RULESETCOL
            || ', a.FRAME_NO '
            || IAPICONSTANTCOLUMN.FRAMENOCOL
            || ', f_get_frame_description( a.frame_no, a.revision) '
            || IAPICONSTANTCOLUMN.FRAMEDESCRIPTIONCOL
            || ', a.REVISION '
            || IAPICONSTANTCOLUMN.FRAMEREVISIONCOL
            || ', a.IS_DEFAULT '
            || IAPICONSTANTCOLUMN.ISDEFAULT;

      LSFROM                        IAPITYPE.STRING_TYPE := ' FROM itruleset a';
   BEGIN
      LSSQL :=    'Select '
               || LSSELECT
               || LSFROM
               || ' WHERE a.rule_type = :RuleType '
               || ' AND a.frame_no = :FrameNo' 
               || ' ORDER BY 7 ';

     
      IF ( AQRULESETS%ISOPEN )
      THEN
         CLOSE AQRULESETS;
      END IF;

      OPEN AQRULESETS FOR LSSQL USING 0, 0;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      LNRETVAL := IAPIRULESET.EXISTRULETYPE( ANRULETYPE );

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

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      IF ( AQRULESETS%ISOPEN )
      THEN
         CLOSE AQRULESETS;
      END IF;

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                      ' anRuleType= '
                                   || ANRULETYPE
                                   || ' anFrameNo= '
                                   || ANFRAMENO
                                   || '  lssql=  '
                                   || LSSQL );

      OPEN AQRULESETS FOR LSSQL USING ANRULETYPE, ANFRAMENO;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'Select '
                  || LSSELECT
                  || LSFROM
                  || ' WHERE a.rule_type = :RuleType'
                  || ' AND a.frame_no = :FrameNo' 
                  || ' ORDER BY 7 ';

         
         IF ( AQRULESETS%ISOPEN )
         THEN
            CLOSE AQRULESETS;
         END IF;

         OPEN AQRULESETS FOR LSSQL USING ANRULETYPE;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETRULESETSFORFRAME;


   FUNCTION SAVERULESETDISTFRAME(
      ANRULEID                   IN       IAPITYPE.SEQUENCE_TYPE,
      ANRULETYPE                 IN       IAPITYPE.SEQUENCE_TYPE,
      ANFRAMNO                   IN       IAPITYPE.FRAMENO_TYPE)
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveRuleSetsDistFrame';
      LNCOUNTER                     IAPITYPE.NUMVAL_TYPE;
      LNCOUNTER1                     IAPITYPE.NUMVAL_TYPE;

   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ANRULEID <> 0 THEN
       BEGIN
         SELECT 1 INTO LNCOUNTER1 FROM ITRULESET 
           WHERE RULE_TYPE = ANRULETYPE
                  AND FRAME_NO = ANFRAMNO AND RULE_ID = ANRULEID; 
       END;
       IF NVL(LNCOUNTER1,0) = 1 THEN
        SELECT COUNT( * )
           INTO LNCOUNTER
             FROM ITRULESET 
              WHERE RULE_TYPE = ANRULETYPE
                AND FRAME_NO = ANFRAMNO
                AND IS_DEFAULT = 1;
         IF LNCOUNTER > 0
            THEN 
              UPDATE ITRULESET 
                 SET IS_DEFAULT = 0
                WHERE RULE_TYPE = ANRULETYPE
                  AND FRAME_NO = ANFRAMNO;           
         END IF;
         UPDATE ITRULESET
            SET IS_DEFAULT = 1
          WHERE RULE_ID = ANRULEID;
       END IF;
        ELSE
         UPDATE ITRULESET 
            SET IS_DEFAULT = 0
          WHERE RULE_TYPE = ANRULETYPE
            AND FRAME_NO = ANFRAMNO;             
      END IF;
      IF SQL%ROWCOUNT = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_RULESETNOTFOUND,
                                                    ANRULEID );
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Update RuleId <'
                           || ANRULEID
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
   END SAVERULESETDISTFRAME;
    
   FUNCTION GETDEFRULESETSFRAME(
      AQRULESETS                 OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
     IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetDefRuleSetsFrame';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' a.RULE_ID '
            || IAPICONSTANTCOLUMN.RULEIDCOL
            || ', a.NAME '
            || IAPICONSTANTCOLUMN.NAMECOL
            || ', a.DESCRIPTION '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', a.RULE_TYPE '
            || IAPICONSTANTCOLUMN.RULETYPECOL
            || ', a.FRAME_NO '
            || IAPICONSTANTCOLUMN.FRAMEREVISIONCOL
            || ', f_get_frame_description( a.frame_no, a.revision) '
            || IAPICONSTANTCOLUMN.FRAMEDESCRIPTIONCOL
            || ', a.IS_DEFAULT '
            || IAPICONSTANTCOLUMN.ISDEFAULT;

      LSSELECT1                      IAPITYPE.SQLSTRING_TYPE
         :=    ' NULL '
            || IAPICONSTANTCOLUMN.RULEIDCOL
            || ', NULL '
            || IAPICONSTANTCOLUMN.NAMECOL
            || ', NULL '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', a.RULE_TYPE '
            || IAPICONSTANTCOLUMN.RULETYPECOL
            || ', a.FRAME_NO '
            || IAPICONSTANTCOLUMN.FRAMEREVISIONCOL
            || ', NULL '
            || IAPICONSTANTCOLUMN.FRAMEDESCRIPTIONCOL
            || ', a.IS_DEFAULT '
            || IAPICONSTANTCOLUMN.ISDEFAULT;


      LSFROM                        IAPITYPE.STRING_TYPE := ' FROM itruleset a';
   BEGIN
      LSSQL :=    '(Select '
               || LSSELECT
               || LSFROM
               || ' WHERE (a.rule_type, a.frame_no) in '
               || ' (select distinct rule_type, frame_no from itruleset) '
               || ' AND a.is_default = 1 ) '
               || ' UNION '
               || '(Select '
               || LSSELECT1
               || LSFROM
               || ' WHERE (a.rule_type, a.frame_no) in '
               || ' (select distinct rule_type, frame_no from itruleset b '
               || ' where not exists (select 1 from itruleset where rule_type = b.rule_type '
               || ' and frame_no = a.frame_no '
               || ' and is_default = 1))) ';

               

























     
      IF ( AQRULESETS%ISOPEN )
      THEN
         CLOSE AQRULESETS;
      END IF;

      OPEN AQRULESETS FOR LSSQL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      
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

      
      IF ( AQRULESETS%ISOPEN )
      THEN
         CLOSE AQRULESETS;
      END IF;

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                      ' lssql=  '
                                   || LSSQL );

      OPEN AQRULESETS FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
       LSSQL :=    '(Select '
               || LSSELECT
               || LSFROM
               || ' WHERE (a.rule_type, a.frame_no) in '
               || ' (select distinct rule_type, frame_no from itruleset) '
               || ' AND a.is_default = 1 ) '
               || ' UNION '
               || '(Select '
               || LSSELECT1
               || LSFROM
               || ' WHERE (a.rule_type, a.frame_no) in '
               || ' (select distinct rule_type, frame_no from itruleset b '
               || ' where not exists (select 1 from itruleset where rule_type = b.rule_type '
               || ' and frame_no = a.frame_no '
               || ' and is_default = 1))) ';

         
         IF ( AQRULESETS%ISOPEN )
         THEN
            CLOSE AQRULESETS;
         END IF;

         OPEN AQRULESETS FOR LSSQL;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETDEFRULESETSFRAME;

END IAPIRULESET;
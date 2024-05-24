CREATE OR REPLACE PACKAGE BODY iapiSpecificationValidation
AS

   
   
   
   

   FUNCTION GETPACKAGEVERSION
      RETURN IAPITYPE.STRING_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPackageVersion';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      RETURN(    IAPIGENERAL.GETVERSION
              || ' ($Revision: 6.7.0.10 (06.07.00.10-00.00) $)' );

   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   END GETPACKAGEVERSION;








   FUNCTION ISVALUEENTERED(
      ANFIELDID                  IN       IAPITYPE.ID_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPID          IN       IAPITYPE.ID_TYPE,
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE )
      RETURN BOOLEAN
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsValueEntered';
      LNNUMERIC1                    IAPITYPE.FLOAT_TYPE;
      LNNUMERIC2                    IAPITYPE.FLOAT_TYPE;
      LNNUMERIC3                    IAPITYPE.FLOAT_TYPE;
      LNNUMERIC4                    IAPITYPE.FLOAT_TYPE;
      LNNUMERIC5                    IAPITYPE.FLOAT_TYPE;
      LNNUMERIC6                    IAPITYPE.FLOAT_TYPE;
      LNNUMERIC7                    IAPITYPE.FLOAT_TYPE;
      LNNUMERIC8                    IAPITYPE.FLOAT_TYPE;
      LNNUMERIC9                    IAPITYPE.FLOAT_TYPE;
      LNNUMERIC10                   IAPITYPE.FLOAT_TYPE;
      LSCHARACTER1                  IAPITYPE.PROPERTYSHORTSTRING_TYPE;
      LSCHARACTER2                  IAPITYPE.PROPERTYSHORTSTRING_TYPE;
      LSCHARACTER3                  IAPITYPE.PROPERTYSHORTSTRING_TYPE;
      LSCHARACTER4                  IAPITYPE.PROPERTYSHORTSTRING_TYPE;
      LSCHARACTER5                  IAPITYPE.PROPERTYSHORTSTRING_TYPE;
      LSCHARACTER6                  IAPITYPE.PROPERTYLONGSTRING_TYPE;
      LNBOOLEAN1                    IAPITYPE.PROPERTYBOOLEAN_TYPE;
      LNBOOLEAN2                    IAPITYPE.PROPERTYBOOLEAN_TYPE;
      LNBOOLEAN3                    IAPITYPE.PROPERTYBOOLEAN_TYPE;
      LNBOOLEAN4                    IAPITYPE.PROPERTYBOOLEAN_TYPE;
      LDDATE1                       IAPITYPE.DATE_TYPE;
      LDDATE2                       IAPITYPE.DATE_TYPE;
      LNASSOCIATION1                IAPITYPE.ID_TYPE;
      LNASSOCIATION2                IAPITYPE.ID_TYPE;
      LNASSOCIATION3                IAPITYPE.ID_TYPE;
      LSVALUE                       IAPITYPE.BUFFER_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      SELECT NUM_1,
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
             DECODE( CHARACTERISTIC,
                     0, NULL,
                     CHARACTERISTIC ),
             DECODE( CH_2,
                     0, NULL,
                     CH_2 ),
             DECODE( CH_3,
                     0, NULL,
                     CH_3 )
        INTO LNNUMERIC1,
             LNNUMERIC2,
             LNNUMERIC3,
             LNNUMERIC4,
             LNNUMERIC5,
             LNNUMERIC6,
             LNNUMERIC7,
             LNNUMERIC8,
             LNNUMERIC9,
             LNNUMERIC10,
             LSCHARACTER1,
             LSCHARACTER2,
             LSCHARACTER3,
             LSCHARACTER4,
             LSCHARACTER5,
             LSCHARACTER6,
             LNBOOLEAN1,
             LNBOOLEAN2,
             LNBOOLEAN3,
             LNBOOLEAN4,
             LDDATE1,
             LDDATE2,
             LNASSOCIATION1,
             LNASSOCIATION2,
             LNASSOCIATION3
        FROM SPECIFICATION_PROP
       WHERE PART_NO = GSPARTNO
         AND REVISION = GNREVISION
         AND SECTION_ID = ANSECTIONID
         AND SUB_SECTION_ID = ANSUBSECTIONID
         AND PROPERTY_GROUP = ANPROPERTYGROUPID
         AND PROPERTY = ANPROPERTYID
         AND ATTRIBUTE = ANATTRIBUTEID;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'anFieldId: '
                           || ANFIELDID,
                           IAPICONSTANT.INFOLEVEL_3 );
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'lsCharacter1: '
                           || LSCHARACTER1,
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT DECODE( ANFIELDID,
                     1, TO_CHAR( LNNUMERIC1 ),
                     2, TO_CHAR( LNNUMERIC2 ),
                     3, TO_CHAR( LNNUMERIC3 ),
                     4, TO_CHAR( LNNUMERIC4 ),
                     5, TO_CHAR( LNNUMERIC5 ),
                     6, TO_CHAR( LNNUMERIC6 ),
                     7, TO_CHAR( LNNUMERIC7 ),
                     8, TO_CHAR( LNNUMERIC8 ),
                     9, TO_CHAR( LNNUMERIC9 ),
                     10, TO_CHAR( LNNUMERIC10 ),
                     11, LSCHARACTER1,
                     12, LSCHARACTER2,
                     13, LSCHARACTER3,
                     14, LSCHARACTER4,
                     15, LSCHARACTER5,
                     16, LSCHARACTER6,
                     17, LNBOOLEAN1,
                     18, LNBOOLEAN2,
                     19, LNBOOLEAN3,
                     20, LNBOOLEAN4,
                     21, TO_CHAR( LDDATE1 ),
                     22, TO_CHAR( LDDATE2 ),
                     26, TO_CHAR( LNASSOCIATION1 ),
                     30, TO_CHAR( LNASSOCIATION2 ),
                     31, TO_CHAR( LNASSOCIATION3 ),
                     '0' )
        INTO LSVALUE
        FROM DUAL;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'value of field '
                           || ANFIELDID
                           || ' = '
                           || LSVALUE,
                           IAPICONSTANT.INFOLEVEL_3 );

      IF LSVALUE IS NULL
      THEN
         RETURN FALSE;
      ELSE
         RETURN TRUE;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN FALSE;
   END ISVALUEENTERED;


   FUNCTION EXECUTEVALRULESWARNINGPRIVATE(
      ANCURRENTSTATUS            IN       IAPITYPE.STATUSID_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANNEXTSTATUS               IN       IAPITYPE.STATUSID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LNRESULT                      IAPITYPE.NUMVAL_TYPE;
      LNWORKFLOWGROUPID             IAPITYPE.ID_TYPE;
      LSSTATUSTYPEFROM              IAPITYPE.STATUSTYPE_TYPE;
      LSSTATUSTYPETO                IAPITYPE.STATUSTYPE_TYPE;
      LNCURSOR                      IAPITYPE.NUMVAL_TYPE;
      LSSQLSTRING                   IAPITYPE.STRING_TYPE;
      LNERRORNO                     IAPITYPE.NUMVAL_TYPE;
      LSERRORCODE                   IAPITYPE.MESSAGEID_TYPE;
      LSCULTUREID                   IAPITYPE.CULTURE_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExecuteValRulesWarningPrivate';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSERRORTEXT                   IAPITYPE.ERRORTEXT_TYPE;

      
      CURSOR LQSTATUSWARNINGRULE(
         LSSTATUSTYPEFROM                    IAPITYPE.STATUSTYPE_TYPE,
         LSSTATUSTYPETO                      IAPITYPE.STATUSTYPE_TYPE,
         LSSSFROM                            IAPITYPE.STATUSTYPE_TYPE,
         LSSSTO                              IAPITYPE.STATUSTYPE_TYPE,
         LNWORKFLOWGROUPID                   IAPITYPE.ID_TYPE )
      IS
         SELECT ITSSCF.*,
                DECODE( ITCF.CUSTOM,
                        0,  'iapiSpecificationValidation.'
                         || ITCF.PROCEDURE_NAME,
                        1,  'aopa_validate_ss.'
                         || ITCF.PROCEDURE_NAME,
                        2,  'aopa_r_validate_ss.'
                         || ITCF.PROCEDURE_NAME,
                        3,  'aopa_g_validate_ss.'
                         || ITCF.PROCEDURE_NAME ) PROCEDURE_NAME
           FROM ITSSCF,
                ITCF
          WHERE S_FROM = LSSTATUSTYPEFROM
            AND S_TO = LSSTATUSTYPETO
            AND WORKFLOW_GROUP_ID = -1
            AND ITSSCF.CF_ID = ITCF.CF_ID
            AND ITSSCF.STATUS_TYPE = 1
            AND ITCF.CF_TYPE = 'W'
         UNION
         SELECT ITSSCF.*,
                DECODE( ITCF.CUSTOM,
                        0,  'iapiSpecificationValidation.'
                         || ITCF.PROCEDURE_NAME,
                        1,  'aopa_validate_ss.'
                         || ITCF.PROCEDURE_NAME,
                        2,  'aopa_r_validate_ss.'
                         || ITCF.PROCEDURE_NAME,
                        3,  'aopa_g_validate_ss.'
                         || ITCF.PROCEDURE_NAME ) PROCEDURE_NAME
           FROM ITSSCF,
                ITCF
          WHERE S_FROM = LSSTATUSTYPEFROM
            AND S_TO = LSSTATUSTYPETO
            AND WORKFLOW_GROUP_ID = LNWORKFLOWGROUPID
            AND ITSSCF.CF_ID = ITCF.CF_ID
            AND ITSSCF.STATUS_TYPE = 1
            AND ITCF.CF_TYPE = 'W'
         UNION
         SELECT ITSSCF.*,
                DECODE( ITCF.CUSTOM,
                        0,  'iapiSpecificationValidation.'
                         || ITCF.PROCEDURE_NAME,
                        1,  'aopa_validate_ss.'
                         || ITCF.PROCEDURE_NAME,
                        2,  'aopa_r_validate_ss.'
                         || ITCF.PROCEDURE_NAME,
                        3,  'aopa_g_validate_ss.'
                         || ITCF.PROCEDURE_NAME ) PROCEDURE_NAME
           FROM ITSSCF,
                ITCF
          WHERE S_FROM = LSSSFROM
            AND S_TO = LSSSTO
            AND WORKFLOW_GROUP_ID = -1
            AND ITSSCF.CF_ID = ITCF.CF_ID
            AND ITSSCF.STATUS_TYPE = 0
            AND ITCF.CF_TYPE = 'W'
         UNION
         SELECT ITSSCF.*,
                DECODE( ITCF.CUSTOM,
                        0,  'iapiSpecificationValidation.'
                         || ITCF.PROCEDURE_NAME,
                        1,  'aopa_validate_ss.'
                         || ITCF.PROCEDURE_NAME,
                        2,  'aopa_r_validate_ss.'
                         || ITCF.PROCEDURE_NAME,
                        3,  'aopa_g_validate_ss.'
                         || ITCF.PROCEDURE_NAME ) PROCEDURE_NAME
           FROM ITSSCF,
                ITCF
          WHERE S_FROM = LSSSFROM
            AND S_TO = LSSSTO
            AND WORKFLOW_GROUP_ID = LNWORKFLOWGROUPID
            AND ITSSCF.CF_ID = ITCF.CF_ID
            AND ITSSCF.STATUS_TYPE = 0
            AND ITCF.CF_TYPE = 'W';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT STATUS_TYPE
        INTO LSSTATUSTYPEFROM
        FROM STATUS
       WHERE STATUS = ANCURRENTSTATUS;

      SELECT STATUS_TYPE
        INTO LSSTATUSTYPETO
        FROM STATUS
       WHERE STATUS = ANNEXTSTATUS;

      SELECT WORKFLOW_GROUP_ID
        INTO LNWORKFLOWGROUPID
        FROM SPECIFICATION_HEADER
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION;

      GSPARTNO := ASPARTNO;
      GNREVISION := ANREVISION;
      GNNEXTSTATUS := ANNEXTSTATUS;
      GNERRORNO := -20000;
      



      

      

      
      LNCURSOR := DBMS_SQL.OPEN_CURSOR;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Before fetch cursor'
                           || LSSTATUSTYPEFROM
                           || LSSTATUSTYPETO
                           || LNWORKFLOWGROUPID,
                           IAPICONSTANT.INFOLEVEL_1 );

      FOR LRROW IN LQSTATUSWARNINGRULE( LSSTATUSTYPEFROM,
                                        LSSTATUSTYPETO,
                                        ANCURRENTSTATUS,
                                        ANNEXTSTATUS,
                                        LNWORKFLOWGROUPID )
      LOOP
         GNERRORNO := IAPICONSTANTDBERROR.DBERR_SUCCESS;
         LSSQLSTRING :=    'BEGIN iapiSpecificationValidation.gnErrorNo:='
                        || LRROW.PROCEDURE_NAME
                        || '; END;';
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              LSSQLSTRING,
                              IAPICONSTANT.INFOLEVEL_1 );
         DBMS_SQL.PARSE( LNCURSOR,
                         LSSQLSTRING,
                         DBMS_SQL.V7 );
         LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );

         IF GNERRORNO <> IAPICONSTANTDBERROR.DBERR_SUCCESS
         THEN
             
             LSERRORTEXT := IAPIGENERAL.GETLASTERRORTEXT( );

             LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( LRROW.PROCEDURE_NAME,
                                                     LSERRORTEXT,
                                                     IAPISPECIFICATIONVALIDATION.GTERRORS,
                                                     IAPICONSTANT.INFOLEVEL_1 );

            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
         END IF;
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LNCURSOR );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );

         IF ( DBMS_SQL.IS_OPEN( LNCURSOR ) )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LNCURSOR );
         END IF;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXECUTEVALRULESWARNINGPRIVATE;

   
   
   
   
   
   FUNCTION EXECUTEVALRULESERROR(
      ANCURRENTSTATUS            IN       IAPITYPE.STATUSID_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANNEXTSTATUS               IN       IAPITYPE.STATUSID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LNRESULT                      IAPITYPE.NUMVAL_TYPE;
      LNWORKFLOWGROUPID             IAPITYPE.ID_TYPE;
      LSSTATUSTYPEFROM              IAPITYPE.STATUSTYPE_TYPE;
      LSSTATUSTYPETO                IAPITYPE.STATUSTYPE_TYPE;
      LNCURSOR                      IAPITYPE.NUMVAL_TYPE;
      LSSQLSTRING                   IAPITYPE.STRING_TYPE;
      LNERRORNO                     IAPITYPE.NUMVAL_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExecuteValRulesError';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;

      
      CURSOR LQSTATUSVALIDATIONRULE(
         LSSTATUSTYPEFROM                    IAPITYPE.STATUSTYPE_TYPE,
         LSSTATUSTYPETO                      IAPITYPE.STATUSTYPE_TYPE,
         LSSSFROM                            IAPITYPE.STATUSTYPE_TYPE,
         LSSSTO                              IAPITYPE.STATUSTYPE_TYPE,
         LNWORKFLOWGROUPID                   IAPITYPE.ID_TYPE )
      IS
         SELECT ITSSCF.*,
                DECODE( ITCF.CUSTOM,
                        0,  'iapiSpecificationValidation.'
                         || ITCF.PROCEDURE_NAME,
                        1,  'aopa_validate_ss.'
                         || ITCF.PROCEDURE_NAME,
                        2,  'aopa_r_validate_ss.'
                         || ITCF.PROCEDURE_NAME,
                        3,  'aopa_g_validate_ss.'
                         || ITCF.PROCEDURE_NAME ) PROCEDURE_NAME
           FROM ITSSCF,
                ITCF
          WHERE S_FROM = LSSTATUSTYPEFROM
            AND S_TO = LSSTATUSTYPETO
            AND WORKFLOW_GROUP_ID = -1
            AND ITSSCF.CF_ID = ITCF.CF_ID
            AND ITSSCF.STATUS_TYPE = 1
            AND ITCF.CF_TYPE = 'V'
         UNION
         SELECT ITSSCF.*,
                DECODE( ITCF.CUSTOM,
                        0,  'iapiSpecificationValidation.'
                         || ITCF.PROCEDURE_NAME,
                        1,  'aopa_validate_ss.'
                         || ITCF.PROCEDURE_NAME,
                        2,  'aopa_r_validate_ss.'
                         || ITCF.PROCEDURE_NAME,
                        3,  'aopa_g_validate_ss.'
                         || ITCF.PROCEDURE_NAME ) PROCEDURE_NAME
           FROM ITSSCF,
                ITCF
          WHERE S_FROM = LSSTATUSTYPEFROM
            AND S_TO = LSSTATUSTYPETO
            AND WORKFLOW_GROUP_ID = LNWORKFLOWGROUPID
            AND ITSSCF.CF_ID = ITCF.CF_ID
            AND ITSSCF.STATUS_TYPE = 1
            AND ITCF.CF_TYPE = 'V'
         UNION
         SELECT ITSSCF.*,
                DECODE( ITCF.CUSTOM,
                        0,  'iapiSpecificationValidation.'
                         || ITCF.PROCEDURE_NAME,
                        1,  'aopa_validate_ss.'
                         || ITCF.PROCEDURE_NAME,
                        2,  'aopa_r_validate_ss.'
                         || ITCF.PROCEDURE_NAME,
                        3,  'aopa_g_validate_ss.'
                         || ITCF.PROCEDURE_NAME ) PROCEDURE_NAME
           FROM ITSSCF,
                ITCF
          WHERE S_FROM = LSSSFROM
            AND S_TO = LSSSTO
            AND WORKFLOW_GROUP_ID = -1
            AND ITSSCF.CF_ID = ITCF.CF_ID
            AND ITSSCF.STATUS_TYPE = 0
            AND ITCF.CF_TYPE = 'V'
         UNION
         SELECT ITSSCF.*,
                DECODE( ITCF.CUSTOM,
                        0,  'iapiSpecificationValidation.'
                         || ITCF.PROCEDURE_NAME,
                        1,  'aopa_validate_ss.'
                         || ITCF.PROCEDURE_NAME,
                        2,  'aopa_r_validate_ss.'
                         || ITCF.PROCEDURE_NAME,
                        3,  'aopa_g_validate_ss.'
                         || ITCF.PROCEDURE_NAME ) PROCEDURE_NAME
           FROM ITSSCF,
                ITCF
          WHERE S_FROM = LSSSFROM
            AND S_TO = LSSSTO
            AND WORKFLOW_GROUP_ID = LNWORKFLOWGROUPID
            AND ITSSCF.CF_ID = ITCF.CF_ID
            AND ITSSCF.STATUS_TYPE = 0
            AND ITCF.CF_TYPE = 'V'
;
   BEGIN
     IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asUser ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );

         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      SELECT STATUS_TYPE
        INTO LSSTATUSTYPEFROM
        FROM STATUS
       WHERE STATUS = ANCURRENTSTATUS;

      SELECT STATUS_TYPE
        INTO LSSTATUSTYPETO
        FROM STATUS
       WHERE STATUS = ANNEXTSTATUS;

      SELECT WORKFLOW_GROUP_ID
        INTO LNWORKFLOWGROUPID
        FROM SPECIFICATION_HEADER
       WHERE PART_NO = ASPARTNO
         AND REVISION = ANREVISION;

      GSPARTNO := ASPARTNO;
      GNREVISION := ANREVISION;
      GNNEXTSTATUS := ANNEXTSTATUS;
      
      LNCURSOR := DBMS_SQL.OPEN_CURSOR;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Before fetch cursor'
                           || LSSTATUSTYPEFROM
                           || ' '
                           || LSSTATUSTYPETO
                           || ' '
                           || ANCURRENTSTATUS
                           || ' '
                           || ANNEXTSTATUS,
                           IAPICONSTANT.INFOLEVEL_1 );
      GNERRORNO := IAPICONSTANTDBERROR.DBERR_SUCCESS;

      FOR LRROW IN LQSTATUSVALIDATIONRULE( LSSTATUSTYPEFROM,
                                           LSSTATUSTYPETO,
                                           ANCURRENTSTATUS,
                                           ANNEXTSTATUS,
                                           LNWORKFLOWGROUPID )
      LOOP
         LSSQLSTRING :=    'BEGIN iapiSpecificationValidation.gnErrorNo:='
                        || LRROW.PROCEDURE_NAME
                        || '; END;';
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              LSSQLSTRING,
                              IAPICONSTANT.INFOLEVEL_1 );
         DBMS_SQL.PARSE( LNCURSOR,
                         LSSQLSTRING,
                         DBMS_SQL.V7 );
         LNRESULT := DBMS_SQL.EXECUTE( LNCURSOR );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 LRROW.PROCEDURE_NAME
                              || ' Return:'
                              || LNRESULT,
                              IAPICONSTANT.INFOLEVEL_1 );

         IF GNERRORNO <> IAPICONSTANTDBERROR.DBERR_SUCCESS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( GNERRORNO );
         END IF;
      END LOOP;

      DBMS_SQL.CLOSE_CURSOR( LNCURSOR );

      
      

      




      

      
      
      
     IF LSSTATUSTYPETO = IAPICONSTANT.STATUSTYPE_SUBMIT
     THEN
        LNRETVAL := VALIDATEREASONFORISSUE;
     ELSE IF LSSTATUSTYPETO = IAPICONSTANT.STATUSTYPE_DEVELOPMENT
          THEN
            LNRETVAL := VALIDATEREASONFORSTATUSCHANGE;
          END IF;
     END IF;

    
    


      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
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

         IF ( DBMS_SQL.IS_OPEN( LNCURSOR ) )
         THEN
            DBMS_SQL.CLOSE_CURSOR( LNCURSOR );
         END IF;

         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXECUTEVALRULESERROR;


   FUNCTION EXECUTEVALRULESWARNING(
      ANCURRENTSTATUS            IN       IAPITYPE.STATUSID_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANNEXTSTATUS               IN       IAPITYPE.STATUSID_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ExecuteValRulesWarning';
   BEGIN
      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asUser ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := EXECUTEVALRULESWARNINGPRIVATE( ANCURRENTSTATUS,
                                                 ANREVISION,
                                                 ASPARTNO,
                                                 ANNEXTSTATUS );

      
      IF ( GTERRORS.COUNT > 0 )
      THEN
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );
         RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'ExecuteValRulesWarning',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END EXECUTEVALRULESWARNING;


   FUNCTION VALIDATEBOM
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateBom';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPISPECIFICATIONBOM.BOMRECORDSMATCH( GSPARTNO,
                                                        GNREVISION );

      IF LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS
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
   END VALIDATEBOM;


   FUNCTION VALIDATEHISTORICOBSOLETE
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
      LSNEXTSTATUSTYPE              IAPITYPE.STATUSTYPE_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateHistoricObsolete';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;

      CURSOR LQBOMITEM(
         ASPARTNO                            IAPITYPE.PARTNO_TYPE,
         ANREVISION                          IAPITYPE.REVISION_TYPE )
      IS
         SELECT PART_NO,
                REVISION
           FROM BOM_ITEM
          WHERE COMPONENT_PART = ASPARTNO
            AND COMPONENT_REVISION = ANREVISION;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      SELECT STATUS_TYPE
        INTO LSNEXTSTATUSTYPE
        FROM STATUS
       WHERE STATUS = GNNEXTSTATUS;

      FOR LRBOMITEM IN LQBOMITEM( GSPARTNO,
                                  GNREVISION )
      LOOP
         SELECT STATUS_TYPE
           INTO LSSTATUSTYPE
           FROM STATUS
          WHERE STATUS = ( SELECT STATUS
                            FROM SPECIFICATION_HEADER
                           WHERE PART_NO = LRBOMITEM.PART_NO
                             AND REVISION = LRBOMITEM.REVISION );

         IF LSSTATUSTYPE IN( IAPICONSTANT.STATUSTYPE_CURRENT, IAPICONSTANT.STATUSTYPE_APPROVED )
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_BOMITEMSSTATUSEQCURRENT,
                                                        GSPARTNO,
                                                        GNREVISION ) );
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
   END VALIDATEHISTORICOBSOLETE;


   FUNCTION VALIDATEMFG
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQBOMHEADER(
         ASPARTNO                            IAPITYPE.PARTNO_TYPE,
         ANREVISION                          IAPITYPE.REVISION_TYPE )
      IS
         SELECT PART_NO,
                REVISION,
                PLANT,
                ALTERNATIVE,
                BOM_USAGE,
                BOM_TYPE
           FROM BOM_HEADER
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION;

      LSPARTSOURCE                  IAPITYPE.PARTSOURCE_TYPE;
      LNQUANTITY                    IAPITYPE.NUMVAL_TYPE;
      LSUOM                         IAPITYPE.DESCRIPTION_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateMfg';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      SELECT PART_SOURCE
        INTO LSPARTSOURCE
        FROM PART
       WHERE PART_NO = GSPARTNO;

      IF LSPARTSOURCE = 'MFG'
      THEN
         FOR LRROW IN LQBOMHEADER( GSPARTNO,
                                   GNREVISION )
         LOOP
            IF LRROW.BOM_TYPE = 'FP'
            THEN
               
               BEGIN
                  SELECT SUM( QUANTITY )
                    INTO LNQUANTITY
                    FROM BOM_ITEM
                   WHERE PART_NO = GSPARTNO
                     AND REVISION = GNREVISION
                     AND PLANT = LRROW.PLANT
                     AND ALTERNATIVE = LRROW.ALTERNATIVE
                     AND BOM_USAGE = LRROW.BOM_USAGE;

                  IF LNQUANTITY <> 100
                  THEN
                     RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                 LSMETHOD,
                                                                 IAPICONSTANTDBERROR.DBERR_FPBOMITEMSUMNOT100,
                                                                 GSPARTNO,
                                                                 GNREVISION ) );
                  END IF;

                  SELECT BASE_QUANTITY
                    INTO LNQUANTITY
                    FROM BOM_HEADER
                   WHERE PART_NO = GSPARTNO
                     AND REVISION = GNREVISION
                     AND PLANT = LRROW.PLANT
                     AND ALTERNATIVE = LRROW.ALTERNATIVE
                     AND BOM_USAGE = LRROW.BOM_USAGE;

                  IF LNQUANTITY <> 100
                  THEN
                     RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                 LSMETHOD,
                                                                 IAPICONSTANTDBERROR.DBERR_FPBOMHEADERSUMNOT100,
                                                                 GSPARTNO,
                                                                 GNREVISION ) );
                  END IF;

                  
                  SELECT   UOM,
                           COUNT( UOM )
                      INTO LSUOM,
                           LNCOUNT
                      FROM BOM_ITEM
                     WHERE PART_NO = GSPARTNO
                       AND REVISION = GNREVISION
                  GROUP BY UOM;
               EXCEPTION
                  WHEN TOO_MANY_ROWS
                  THEN
                     RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                 LSMETHOD,
                                                                 IAPICONSTANTDBERROR.DBERR_FPBOMITEMSUOMNOTALLEQ,
                                                                 GSPARTNO,
                                                                 GNREVISION ) );
               END;
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
   END VALIDATEMFG;


   FUNCTION VALIDATEINDEVBOM
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQBOMITEM(
         ASPARTNO                            IAPITYPE.PARTNO_TYPE,
         ANREVISION                          IAPITYPE.REVISION_TYPE )
      IS
         SELECT PART_NO,
                REVISION,
                COMPONENT_PART,
                COMPONENT_REVISION
           FROM BOM_ITEM
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION;

      CURSOR LQSTATUSTYPE(
         ASPARTNO                            IAPITYPE.PARTNO_TYPE )
      IS
         SELECT STATUS_TYPE
           FROM STATUS A,
                SPECIFICATION_HEADER B
          WHERE A.STATUS = B.STATUS
            AND B.PART_NO = ASPARTNO;

      LSINDEVBOMPART                IAPITYPE.PARAMETERDATA_TYPE;
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
      LNBOMOK                       IAPITYPE.BOOLEAN_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateInDevBom';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT PARAMETER_DATA
        INTO LSINDEVBOMPART
        FROM INTERSPC_CFG
       WHERE PARAMETER = 'in_dev_bom_part';

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'in_dev_bom_part:'
                           || LSINDEVBOMPART,
                           IAPICONSTANT.INFOLEVEL_2 );

      IF LSINDEVBOMPART = '0'
      THEN
         FOR LRBOMITEM IN LQBOMITEM( GSPARTNO,
                                     GNREVISION )
         LOOP
            IF LRBOMITEM.COMPONENT_REVISION IS NOT NULL
            THEN   
               SELECT STATUS_TYPE
                 INTO LSSTATUSTYPE
                 FROM STATUS
                WHERE STATUS = ( SELECT STATUS
                                  FROM SPECIFICATION_HEADER
                                 WHERE PART_NO = LRBOMITEM.COMPONENT_PART
                                   AND REVISION = LRBOMITEM.COMPONENT_REVISION );

               IF     LSSTATUSTYPE <> IAPICONSTANT.STATUSTYPE_CURRENT
                  AND LSSTATUSTYPE <> IAPICONSTANT.STATUSTYPE_APPROVED
               THEN
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_COMPWITHOUTSPECAPPROVED,
                                                              LRBOMITEM.COMPONENT_PART,
                                                              LRBOMITEM.COMPONENT_REVISION ) );
               END IF;
            ELSE   
               LNBOMOK := 0;

               FOR LSSTATUSTYPE IN LQSTATUSTYPE( LRBOMITEM.COMPONENT_PART )
               LOOP
                  IF    LSSTATUSTYPE.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_CURRENT
                     OR LSSTATUSTYPE.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_APPROVED
                  THEN
                     LNBOMOK := 1;
                  END IF;
               END LOOP;

               IF LNBOMOK = 0
               THEN

                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        'Some components in the bom which is not APPROVED or CURRENT : '
                                     || LRBOMITEM.COMPONENT_PART
																		 );


                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_SOMECOMPWITHOUTSPECAPP ) );
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
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END VALIDATEINDEVBOM;


   FUNCTION VALIDATECLASSIFICATION
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LSCLASSIFICATIONMANDATORY     IAPITYPE.PARAMETERDATA_TYPE;
      LSEXTRACHECK                  IAPITYPE.PARAMETERDATA_TYPE;
      LSSPECTYPEGROUP               IAPITYPE.CLASS3PARTTYPE_TYPE;
      LSNEXTSTATUSTYPE              IAPITYPE.STATUSTYPE_TYPE;
      LSSTATUSTYPENOW               IAPITYPE.STATUSTYPE_TYPE;
      LNID                          IAPITYPE.ID_TYPE;
      LNATTRIBUTECOUNT              IAPITYPE.NUMVAL_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LNCOUNTTYPE                   IAPITYPE.NUMVAL_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateClassification';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;

      CURSOR LQAT(
         ANID                                IAPITYPE.NUMVAL_TYPE )
      IS
         SELECT CODE
           FROM ITCLAT
          WHERE TREE_ID = ANID;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT PARAMETER_DATA
        INTO LSCLASSIFICATIONMANDATORY
        FROM INTERSPC_CFG
       WHERE PARAMETER = 'classification_mand';

      IF LSCLASSIFICATIONMANDATORY = '1'
      THEN
         SELECT COUNT( * )
           INTO LNCOUNTTYPE
           FROM CLASS3 C3,
                SPECIFICATION_HEADER SH,
                INTERSPC_CFG CFG
          WHERE SH.CLASS3_ID = C3.CLASS
            AND PART_NO = GSPARTNO
            AND REVISION = GNREVISION
            AND CFG.PARAMETER = 'mand_classif_type'
            AND CFG.SECTION = 'interspec'
            AND INSTR( CFG.PARAMETER_DATA,
                       TYPE ) > 0;

         SELECT STATUS_TYPE
           INTO LSSTATUSTYPENOW
           FROM STATUS
          WHERE STATUS = ( SELECT STATUS
                            FROM SPECIFICATION_HEADER
                           WHERE PART_NO = GSPARTNO
                             AND REVISION = GNREVISION );

         SELECT STATUS_TYPE
           INTO LSNEXTSTATUSTYPE
           FROM STATUS
          WHERE STATUS = GNNEXTSTATUS;

         
         
         
         IF     LNCOUNTTYPE > 0
            AND LSSTATUSTYPENOW <> LSNEXTSTATUSTYPE
         THEN
            
            SELECT COUNT( PART_NO )
              INTO LNCOUNT
              FROM ITPRCL
             WHERE PART_NO = GSPARTNO;

            IF LNCOUNT < 1
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_CLASSIFICATIONNOTFOUND,
                                                           GSPARTNO ) );
            END IF;

            BEGIN
               SELECT PARAMETER_DATA
                 INTO LSEXTRACHECK
                 FROM INTERSPC_CFG
                WHERE SECTION = 'interspec'
                  AND PARAMETER = 'class_att_mand';
            EXCEPTION
               WHEN OTHERS
               THEN
                  LSEXTRACHECK := '0';
            END;

            IF LSEXTRACHECK = '1'
            THEN
               
               BEGIN
                  SELECT TYPE
                    INTO LSSPECTYPEGROUP
                    FROM PART P,
                         CLASS3 C
                   WHERE C.CLASS = P.PART_TYPE
                     AND P.PART_NO = GSPARTNO;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     SELECT CLASS3_ID
                       INTO LSSPECTYPEGROUP
                       FROM SPECIFICATION_HEADER
                      WHERE PART_NO = GSPARTNO
                        AND REVISION = GNREVISION;
               END;

               SELECT ID
                 INTO LNID
                 FROM ITCLD
                WHERE SPEC_GROUP = LSSPECTYPEGROUP;

               
               FOR LRAT IN LQAT( LNID )
               LOOP
                  SELECT COUNT( * )
                    INTO LNATTRIBUTECOUNT
                    FROM ITPRCL
                   WHERE PART_NO = GSPARTNO
                     AND TYPE = LRAT.CODE;

                  IF LNATTRIBUTECOUNT = 0
                  THEN
                     RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                                 LSMETHOD,
                                                                 IAPICONSTANTDBERROR.DBERR_PARTNOTCORRECTLYCLASS,
                                                                 GSPARTNO ) );
                  END IF;
               END LOOP;
            END IF;
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
   END VALIDATECLASSIFICATION;


   FUNCTION VALIDATECURRENT
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSPHASEINSTATUS               IAPITYPE.PROPERTYBOOLEAN_TYPE;
      LSPHASEIN                     IAPITYPE.PROPERTYBOOLEAN_TYPE;
      LSSTATUSTYPE                  IAPITYPE.STATUSTYPE_TYPE;
      LNPREVIOUSREVISION            IAPITYPE.REVISION_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateCurrent';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT PHASE_IN_STATUS
        INTO LSPHASEINSTATUS
        FROM STATUS
       WHERE STATUS = ( SELECT STATUS
                         FROM SPECIFICATION_HEADER
                        WHERE PART_NO = GSPARTNO
                          AND REVISION = GNREVISION );

      IF LSPHASEINSTATUS = 'N'
      THEN
         
         BEGIN
            
            SELECT MAX( REVISION )
              INTO LNPREVIOUSREVISION
              FROM SPECIFICATION_HEADER
             WHERE PART_NO = GSPARTNO
               AND REVISION < GNREVISION;

            IF LNPREVIOUSREVISION IS NOT NULL
            THEN   
               
               SELECT A.STATUS_TYPE,
                      A.PHASE_IN_STATUS
                 INTO LSSTATUSTYPE,
                      LSPHASEIN
                 FROM STATUS A,
                      SPECIFICATION_HEADER B
                WHERE PART_NO = GSPARTNO
                  AND REVISION = LNPREVIOUSREVISION
                  AND A.STATUS = B.STATUS;

               IF    LSSTATUSTYPE IN
                        ( IAPICONSTANT.STATUSTYPE_APPROVED,
                          IAPICONSTANT.STATUSTYPE_DEVELOPMENT,
                          IAPICONSTANT.STATUSTYPE_SUBMIT,
                          IAPICONSTANT.STATUSTYPE_REJECT )
                  OR (     LSSTATUSTYPE = IAPICONSTANT.STATUSTYPE_CURRENT
                       AND LSPHASEIN = 'Y' )
               THEN
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PREVREVISIONISNOTCURRENT ) );
               END IF;
            END IF;
         END;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END VALIDATECURRENT;


   FUNCTION VALIDATEACCESSTOCURRENT
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LNCHECKMRPACCESS              IAPITYPE.NUMVAL_TYPE;
      LNACCESSGROUP                 IAPITYPE.ID_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateAccessToCurrent';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT ACCESS_GROUP
        INTO LNACCESSGROUP
        FROM SPECIFICATION_HEADER
       WHERE PART_NO = GSPARTNO
         AND REVISION = GNREVISION;

      BEGIN
         SELECT MAX( DECODE( MRP_UPDATE,
                             'Y', DECODE( PLAN_ACCESS,
                                          'Y', 1,
                                          0 ),
                             0 ) )
           INTO LNCHECKMRPACCESS
           FROM SPEC_ACCESS
          WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
            AND ACCESS_GROUP = LNACCESSGROUP;

         IF LNCHECKMRPACCESS <> 1
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_NOMRPACCESS ) );
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_NOMRPACCESS ) );
      END;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END VALIDATEACCESSTOCURRENT;


   FUNCTION VALIDATEREASONFORISSUE
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMANDATORY                   IAPITYPE.MANDATORY_TYPE;
      LSREASON                      IAPITYPE.BUFFER_TYPE;
      LNMAXID                       IAPITYPE.ID_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateReasonForIssue';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT REASON_MANDATORY
        INTO LSMANDATORY
        FROM STATUS
       WHERE STATUS = GNNEXTSTATUS;

      IF LSMANDATORY = 1
      THEN
         SELECT MAX( ID )
           INTO LNMAXID
           FROM REASON
          WHERE PART_NO = GSPARTNO
            AND REVISION = GNREVISION
            AND STATUS_TYPE = IAPICONSTANT.STATUSTYPE_REASONFORISSUE;

         SELECT RTRIM( LTRIM( TEXT ) )
           INTO LSREASON
           FROM REASON
          WHERE PART_NO = GSPARTNO
            AND REVISION = GNREVISION
            AND ID = LNMAXID;

         IF    LSREASON IS NULL
            OR LENGTH( LSREASON ) = 0
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_REASONFORISSUEMANDATORY ) );
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
   END VALIDATEREASONFORISSUE;






   FUNCTION VALIDATEREASONFORSTATUSCHANGE
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMANDATORY                   IAPITYPE.MANDATORY_TYPE;
      LSREASON                      IAPITYPE.BUFFER_TYPE;
      LNMAXID                       IAPITYPE.ID_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateReasonForStatusChange';
      
      LSNEXTSTATUSTYPE              IAPITYPE.STATUSTYPE_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT REASON_MANDATORY
        INTO LSMANDATORY
        FROM STATUS
       WHERE STATUS = GNNEXTSTATUS;

      IF LSMANDATORY = 1
      THEN
         SELECT MAX( ID )
           INTO LNMAXID
           FROM REASON
          WHERE PART_NO = GSPARTNO
            AND REVISION = GNREVISION
            AND STATUS_TYPE = IAPICONSTANT.STATUSTYPE_REASONFORSTATUSCHNG;

         
         
         
         
         
         
         
         
         IF LNMAXID IS NULL
         THEN
            
            
            
            
            
            SELECT STATUS_TYPE
                INTO LSNEXTSTATUSTYPE
            FROM STATUS
            WHERE STATUS = GNNEXTSTATUS;

            IF LSNEXTSTATUSTYPE = IAPICONSTANT.STATUSTYPE_DEVELOPMENT
            THEN
                
                RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                            LSMETHOD,
                                                            IAPICONSTANTDBERROR.DBERR_REASONFORSTCHMANDATORY ) );
            ELSE
                
                
                RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
            END IF;

         END IF;
         

         SELECT RTRIM( LTRIM( TEXT ) )
           INTO LSREASON
           FROM REASON
          WHERE PART_NO = GSPARTNO
            AND REVISION = GNREVISION
            AND ID = LNMAXID;

         IF    LSREASON IS NULL
            OR LENGTH( LSREASON ) = 0
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_REASONFORSTCHMANDATORY ) );
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
   END VALIDATEREASONFORSTATUSCHANGE;





   FUNCTION VALIDATEATTACHEDSPECCURRENT
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQATTACHEMENTS
      IS
         SELECT ATTACHED_PART_NO,
                ATTACHED_REVISION
           FROM ATTACHED_SPECIFICATION
          WHERE PART_NO = GSPARTNO
            AND REVISION = GNREVISION;

      LNCURRENTCOUNT                IAPITYPE.NUMVAL_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateAttachedSpecCurrent';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR LRROW IN LQATTACHEMENTS
      LOOP
         IF LRROW.ATTACHED_REVISION = 0
         THEN
            
            SELECT COUNT( * )
              INTO LNCURRENTCOUNT
              FROM SPECIFICATION_HEADER SH,
                   STATUS SS
             WHERE SH.STATUS = SS.STATUS
               AND SH.PART_NO = LRROW.ATTACHED_PART_NO
               AND STATUS_TYPE = IAPICONSTANT.STATUSTYPE_CURRENT
               AND PHASE_IN_STATUS = 'N';
         ELSE
            
            SELECT COUNT( * )
              INTO LNCURRENTCOUNT
              FROM SPECIFICATION_HEADER SH,
                   STATUS SS
             WHERE SH.STATUS = SS.STATUS
               AND SH.PART_NO = LRROW.ATTACHED_PART_NO
               AND SH.REVISION = LRROW.ATTACHED_REVISION
               AND STATUS_TYPE = IAPICONSTANT.STATUSTYPE_CURRENT
               AND PHASE_IN_STATUS = 'N';
         END IF;

         IF LNCURRENTCOUNT = 0
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_ATTACHEDSPECISNOTCURRENT ) );
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
   END VALIDATEATTACHEDSPECCURRENT;


   FUNCTION VALIDATEATTACHEDSPECAPPROVED
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQATTACHEMENTS
      IS
         SELECT ATTACHED_PART_NO,
                ATTACHED_REVISION
           FROM ATTACHED_SPECIFICATION
          WHERE PART_NO = GSPARTNO
            AND REVISION = GNREVISION;

      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateAttachedSpecApproved';
      LNCURRENTCOUNT                IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR LRROW IN LQATTACHEMENTS
      LOOP
         IF LRROW.ATTACHED_REVISION = 0
         THEN
            
            SELECT COUNT( * )
              INTO LNCURRENTCOUNT
              FROM SPECIFICATION_HEADER SH,
                   STATUS SS
             WHERE SH.STATUS = SS.STATUS
               AND SH.PART_NO = LRROW.ATTACHED_PART_NO
               AND STATUS_TYPE = IAPICONSTANT.STATUSTYPE_CURRENT
               AND PHASE_IN_STATUS = 'N';

            IF LNCURRENTCOUNT = 0
            THEN
               
               SELECT COUNT( * )
                 INTO LNCURRENTCOUNT
                 FROM SPECIFICATION_HEADER SH,
                      STATUS SS
                WHERE SH.STATUS = SS.STATUS
                  AND SH.PART_NO = LRROW.ATTACHED_PART_NO
                  AND STATUS_TYPE = IAPICONSTANT.STATUSTYPE_APPROVED;
            END IF;
         ELSE
            
            SELECT COUNT( * )
              INTO LNCURRENTCOUNT
              FROM SPECIFICATION_HEADER SH,
                   STATUS SS
             WHERE SH.STATUS = SS.STATUS
               AND SH.PART_NO = LRROW.ATTACHED_PART_NO
               AND SH.REVISION = LRROW.ATTACHED_REVISION
               AND STATUS_TYPE = IAPICONSTANT.STATUSTYPE_CURRENT
               AND PHASE_IN_STATUS = 'N';

            IF LNCURRENTCOUNT = 0
            THEN
               
               SELECT COUNT( * )
                 INTO LNCURRENTCOUNT
                 FROM SPECIFICATION_HEADER SH,
                      STATUS SS
                WHERE SH.STATUS = SS.STATUS
                  AND SH.PART_NO = LRROW.ATTACHED_PART_NO
                  AND SH.REVISION = LRROW.ATTACHED_REVISION
                  AND STATUS_TYPE = IAPICONSTANT.STATUSTYPE_APPROVED;
            END IF;
         END IF;

         IF LNCURRENTCOUNT = 0
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_ATTACHEDSPECISNOTCURRENT ) );
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
   END VALIDATEATTACHEDSPECAPPROVED;


   FUNCTION VALIDATEOBJECT
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQOBJECT
      IS
         SELECT REF_ID,
                REF_VER,
                REF_OWNER
           FROM SPECIFICATION_SECTION
          WHERE PART_NO = GSPARTNO
            AND REVISION = GNREVISION
            AND TYPE = IAPICONSTANT.SECTIONTYPE_OBJECT
            AND REF_ID <> 0;

      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateObject';
      LNOBJECTCOUNT                 IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR LRROW IN LQOBJECT
      LOOP
         LNOBJECTCOUNT := 0;

         IF LRROW.REF_VER = 0
         THEN
            SELECT COUNT( OBJECT_ID )
              INTO LNOBJECTCOUNT
              FROM ITOID
             WHERE OBJECT_ID = LRROW.REF_ID
               AND OWNER = LRROW.REF_OWNER
               AND STATUS = 2;
         ELSE
            SELECT COUNT( OBJECT_ID )
              INTO LNOBJECTCOUNT
              FROM ITOID
             WHERE OBJECT_ID = LRROW.REF_ID
               AND REVISION = LRROW.REF_VER
               AND OWNER = LRROW.REF_OWNER
               AND STATUS = 2;
         END IF;

         IF LNOBJECTCOUNT = 0
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_ATTACHEDOBJISNOTCURRENT ) );
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
   END VALIDATEOBJECT;


   FUNCTION VALIDATEREFERENCETEXT
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQTEXT
      IS
         SELECT REF_ID,
                REF_VER,
                REF_OWNER
           FROM SPECIFICATION_SECTION
          WHERE PART_NO = GSPARTNO
            AND REVISION = GNREVISION
            AND TYPE = IAPICONSTANT.SECTIONTYPE_REFERENCETEXT
            AND REF_ID <> 0;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateReferenceText';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNTEXTCOUNT                   IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR LRROW IN LQTEXT
      LOOP
         LNTEXTCOUNT := 0;

         SELECT COUNT( REF_TEXT_TYPE )
           INTO LNTEXTCOUNT
           FROM REFERENCE_TEXT
          WHERE REF_TEXT_TYPE = LRROW.REF_ID
            AND TEXT_REVISION = LRROW.REF_VER
            AND OWNER = LRROW.REF_OWNER
            AND STATUS = IAPICONSTANT.SECTIONTYPE_REFERENCETEXT;

         IF LNTEXTCOUNT = 0
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_ATTREFTEXTISNOTCURRENT ) );
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
   END VALIDATEREFERENCETEXT;


   FUNCTION VALIDATEUOM
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQBOM
      IS
         SELECT DISTINCT COMPONENT_PART,
                         UOM
                    FROM BOM_ITEM
                   WHERE PART_NO = GSPARTNO
                     AND REVISION = GNREVISION
         MINUS
         SELECT PART.PART_NO,
                BASE_UOM
           FROM PART,
                BOM_ITEM
          WHERE BOM_ITEM.PART_NO = GSPARTNO
            AND BOM_ITEM.REVISION = GNREVISION
            AND BOM_ITEM.COMPONENT_PART = PART.PART_NO;

      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateUom';
      LNBOMCOUNT                    IAPITYPE.NUMVAL_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      LNBOMCOUNT := 0;

      FOR LRROW IN LQBOM
      LOOP
         LNBOMCOUNT :=   LNBOMCOUNT
                       + 1;
      END LOOP;

      IF LNBOMCOUNT > 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_BOMITEMUOMDIFFFROMPART ) );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END VALIDATEUOM;


   FUNCTION VALIDATECLEARANCENO
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      LNCLEARANCENOCOUNT            IAPITYPE.NUMVAL_TYPE := 0;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateClearanceNo';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT COUNT( 'Y' )
        INTO LNCLEARANCENOCOUNT
        FROM ITPRMFC
       WHERE PART_NO = GSPARTNO
         AND (    CLEARANCE_NO IS NOT NULL
               OR RTRIM( LTRIM( CLEARANCE_NO ) ) <> '' );

      IF LNCLEARANCENOCOUNT > 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_INGHEADERCLEARNRNOTALLOW ) );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END VALIDATECLEARANCENO;


   FUNCTION VALIDATEHARMONISEDBOM
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LSINTLPARTNO                  IAPITYPE.PARTNO_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateHarmonisedBom';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;

      CURSOR LQBOM
      IS
         SELECT *
           FROM BOM_ITEM BI
          WHERE BI.PART_NO = GSPARTNO
            AND BI.REVISION = GNREVISION
            AND BI.PLANT <> IAPICONSTANT.PLANT_INTERNATIONAL;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT INT_PART_NO
        INTO LSINTLPARTNO
        FROM SPECIFICATION_HEADER
       WHERE PART_NO = GSPARTNO
         AND REVISION = GNREVISION;

      IF LSINTLPARTNO IS NOT NULL
      THEN
         FOR LRBOM IN LQBOM
         LOOP
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM PART_PLANT
             WHERE PART_NO = LRBOM.COMPONENT_PART
               AND PLANT = LRBOM.PLANT;

            IF LNCOUNT = 0
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_INTLPARTHARMBOM,
                                                           LRBOM.COMPONENT_PART ) );
            END IF;

            
            IF NOT( LRBOM.INTL_EQUIVALENT IS NULL )
            THEN
               SELECT INT_PART_NO
                 INTO LSINTLPARTNO
                 FROM SPECIFICATION_HEADER
                WHERE PART_NO = LRBOM.COMPONENT_PART
                  AND REVISION = ( SELECT MAX( REVISION )
                                    FROM SPECIFICATION_HEADER
                                   WHERE PART_NO = LRBOM.COMPONENT_PART );

               IF    LSINTLPARTNO IS NULL
                  OR LSINTLPARTNO <> LRBOM.INTL_EQUIVALENT
               THEN
                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_INTLPARTHARMBOMEQ,
                                                              LRBOM.COMPONENT_PART ) );
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
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END VALIDATEHARMONISEDBOM;


   FUNCTION VALIDATELOCALISED
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSINTLPARTNO                  IAPITYPE.PARTNO_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LNMAXREVISION                 IAPITYPE.REVISION_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateLocalised';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT INT_PART_NO,
             INT_PART_REV
        INTO LSINTLPARTNO,
             LNREVISION
        FROM SPECIFICATION_HEADER
       WHERE PART_NO = GSPARTNO
         AND REVISION = GNREVISION;

      IF LSINTLPARTNO IS NOT NULL
      THEN
         SELECT MAX( SH.REVISION )
           INTO LNMAXREVISION
           FROM SPECIFICATION_HEADER SH,
                STATUS SS
          WHERE SH.PART_NO = LSINTLPARTNO
            AND SH.STATUS = SS.STATUS
            AND SS.STATUS_TYPE = IAPICONSTANT.STATUSTYPE_CURRENT;

         IF LNMAXREVISION <> LNREVISION
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_HARMBOMHIGHERVERSION,
                                                        GSPARTNO,
                                                        GNREVISION ) );
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
   END VALIDATELOCALISED;


   FUNCTION VALIDATIONRULES
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQVALIDATIONRULES
      IS
         SELECT *
           FROM ITSHVALD
          WHERE PART_NO = GSPARTNO
            AND REVISION = GNREVISION;

      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LNFIELDID                     IAPITYPE.ID_TYPE;
      LNDISPLAYFORMAT               IAPITYPE.ID_TYPE;
      LNDISPLAYFORMATREVISION       IAPITYPE.REVISION_TYPE;
      LSTEXT                        IAPITYPE.SPECTEXTTEXT_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidationRules';

   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR LRVALIDATIONRULES IN LQVALIDATIONRULES
      LOOP
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Validation rule type: '
                              || LRVALIDATIONRULES.TYPE,
                              IAPICONSTANT.INFOLEVEL_3 );

         IF LRVALIDATIONRULES.TYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP
         THEN
            BEGIN
               

               
               SELECT DISPLAY_FORMAT,
                      DISPLAY_FORMAT_REV
                 INTO LNDISPLAYFORMAT,
                      LNDISPLAYFORMATREVISION
                 FROM SPECIFICATION_SECTION
                WHERE PART_NO = GSPARTNO
                  AND REVISION = GNREVISION
                  AND SECTION_ID = LRVALIDATIONRULES.SECTION_ID
                  AND SUB_SECTION_ID = LRVALIDATIONRULES.SUB_SECTION_ID
                  
                  
                  AND TYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP
                  
                  AND REF_ID = LRVALIDATIONRULES.PROPERTY_GROUP;

               SELECT FIELD_ID
                 INTO LNFIELDID
                 FROM PROPERTY_LAYOUT
                WHERE LAYOUT_ID = LNDISPLAYFORMAT
                  AND REVISION = LNDISPLAYFORMATREVISION
                  AND HEADER_ID = LRVALIDATIONRULES.HEADER_ID;

              
              
              SELECT COUNT(*)
              INTO LNCOUNT
               FROM SPECIFICATION_PROP
               WHERE PART_NO = GSPARTNO
                 AND REVISION = GNREVISION
                 AND SECTION_ID = LRVALIDATIONRULES.SECTION_ID
                 AND SUB_SECTION_ID = LRVALIDATIONRULES.SUB_SECTION_ID
                 AND PROPERTY_GROUP = LRVALIDATIONRULES.PROPERTY_GROUP
                 AND PROPERTY = LRVALIDATIONRULES.PROPERTY
                 AND ATTRIBUTE = LRVALIDATIONRULES.ATTRIBUTE;
              

               
               
               
               IF ((LNCOUNT > 0) AND (NOT ISVALUEENTERED( LNFIELDID,
               
                                      LRVALIDATIONRULES.SECTION_ID,
                                      LRVALIDATIONRULES.SUB_SECTION_ID,
                                      LRVALIDATIONRULES.PROPERTY_GROUP,
                                      LRVALIDATIONRULES.PROPERTY,
                                      LRVALIDATIONRULES.ATTRIBUTE )))
               THEN


                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        'Part_no/Section/SubSection/PropertyGroup/Property/Attribute: '
                                     || GSPARTNO
                                     || ' '
                                     || LRVALIDATIONRULES.SECTION_ID
                                     || ' '
                                     || LRVALIDATIONRULES.SUB_SECTION_ID
                                     || ' '
                                     || LRVALIDATIONRULES.PROPERTY_GROUP
                                     || ' '
                                     || LRVALIDATIONRULES.PROPERTY
                                     || ' '
                                     || LRVALIDATIONRULES.ATTRIBUTE
																		 );

                 RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PROPERTYGROUPNOTFILLED ) );

               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;
         ELSIF LRVALIDATIONRULES.TYPE = IAPICONSTANT.SECTIONTYPE_REFERENCETEXT
         THEN
            
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM SPECIFICATION_SECTION
             WHERE PART_NO = GSPARTNO
               AND REVISION = GNREVISION
               AND SECTION_ID = LRVALIDATIONRULES.SECTION_ID
               AND SUB_SECTION_ID = LRVALIDATIONRULES.SUB_SECTION_ID
               AND TYPE = IAPICONSTANT.SECTIONTYPE_REFERENCETEXT
               AND REF_ID = LRVALIDATIONRULES.REF_ID
               AND REF_OWNER = LRVALIDATIONRULES.REF_OWNER;

            IF LNCOUNT = 0
            THEN

               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_REFERENCETEXTNOTFOUND ) );
            END IF;
         ELSIF LRVALIDATIONRULES.TYPE = IAPICONSTANT.SECTIONTYPE_BOM
         THEN
            
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM BOM_HEADER
             WHERE PART_NO = GSPARTNO
               AND REVISION = GNREVISION;

            IF LNCOUNT = 0
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_BOMHEADERNOTFOUND ) );
            END IF;
         ELSIF LRVALIDATIONRULES.TYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY
         THEN
            BEGIN
               

               
               SELECT DISPLAY_FORMAT,
                      DISPLAY_FORMAT_REV
                 INTO LNDISPLAYFORMAT,
                      LNDISPLAYFORMATREVISION
                 FROM SPECIFICATION_SECTION
                WHERE PART_NO = GSPARTNO
                  AND REVISION = GNREVISION
                  AND SECTION_ID = LRVALIDATIONRULES.SECTION_ID
                  AND SUB_SECTION_ID = LRVALIDATIONRULES.SUB_SECTION_ID
                  AND TYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY
                  AND REF_ID = LRVALIDATIONRULES.PROPERTY;

               SELECT FIELD_ID
                 INTO LNFIELDID
                 FROM PROPERTY_LAYOUT
                WHERE LAYOUT_ID = LNDISPLAYFORMAT
                  AND REVISION = LNDISPLAYFORMATREVISION
                  AND HEADER_ID = LRVALIDATIONRULES.HEADER_ID;

              
              
              SELECT COUNT(*)
              INTO LNCOUNT
               FROM SPECIFICATION_PROP
               WHERE PART_NO = GSPARTNO
                 AND REVISION = GNREVISION
                 AND SECTION_ID = LRVALIDATIONRULES.SECTION_ID
                 AND SUB_SECTION_ID = LRVALIDATIONRULES.SUB_SECTION_ID
                 AND PROPERTY_GROUP = LRVALIDATIONRULES.PROPERTY_GROUP
                 AND PROPERTY = LRVALIDATIONRULES.PROPERTY
                 AND ATTRIBUTE = LRVALIDATIONRULES.ATTRIBUTE;
              

               
               
               
               IF ((LNCOUNT > 0) AND (NOT ISVALUEENTERED( LNFIELDID,
               
                                      LRVALIDATIONRULES.SECTION_ID,
                                      LRVALIDATIONRULES.SUB_SECTION_ID,
                                      LRVALIDATIONRULES.PROPERTY_GROUP,
                                      LRVALIDATIONRULES.PROPERTY,
                                      LRVALIDATIONRULES.ATTRIBUTE )))
               THEN

                  IAPIGENERAL.LOGERROR( GSSOURCE,
                              LSMETHOD,
                              'Part_No/Section/SubSection/PropertyGroup/Property/Attribute: '
                           || GSPARTNO
                           || ' '
                           || LRVALIDATIONRULES.SECTION_ID
                           || ' '
                           || LRVALIDATIONRULES.SUB_SECTION_ID
                           || ' '
                           || LRVALIDATIONRULES.PROPERTY_GROUP
                           || ' '
                           || LRVALIDATIONRULES.PROPERTY
                           || ' '
                           || LRVALIDATIONRULES.ATTRIBUTE
													 );


                  RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_SINGLEPROPNOTFILLEDIN ) );
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;
         ELSIF LRVALIDATIONRULES.TYPE = IAPICONSTANT.SECTIONTYPE_FREETEXT
         THEN
            
            LSTEXT := NULL;

            BEGIN
               SELECT TEXT
                 INTO LSTEXT
                 FROM SPECIFICATION_TEXT
                WHERE PART_NO = GSPARTNO
                  AND REVISION = GNREVISION
                  AND SECTION_ID = LRVALIDATIONRULES.SECTION_ID
                  AND SUB_SECTION_ID = LRVALIDATIONRULES.SUB_SECTION_ID
                  AND TEXT_TYPE = LRVALIDATIONRULES.PROPERTY_GROUP;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            IF    LSTEXT IS NULL
               OR LSTEXT = ''
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_FREETEXTNOTFILLEDIN ) );
            END IF;
         ELSIF LRVALIDATIONRULES.TYPE = IAPICONSTANT.SECTIONTYPE_OBJECT
         THEN
            
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM SPECIFICATION_SECTION
             WHERE PART_NO = GSPARTNO
               AND REVISION = GNREVISION
               AND TYPE = IAPICONSTANT.SECTIONTYPE_OBJECT
               AND SECTION_ID = LRVALIDATIONRULES.SECTION_ID
               AND SUB_SECTION_ID = LRVALIDATIONRULES.SUB_SECTION_ID
               AND REF_ID = LRVALIDATIONRULES.REF_ID
               AND REF_OWNER = LRVALIDATIONRULES.REF_OWNER;

            IF LNCOUNT = 0
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_OBJECTNOTFOUND ) );
            END IF;
         ELSIF LRVALIDATIONRULES.TYPE = IAPICONSTANT.SECTIONTYPE_PROCESSDATA
         THEN
            
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM SPECIFICATION_LINE_PROP
             WHERE PART_NO = GSPARTNO
               AND REVISION = GNREVISION;

            IF LNCOUNT = 0
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PROCESSDATANOTFOUND ) );
            END IF;
         ELSIF LRVALIDATIONRULES.TYPE = IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC
         THEN
            
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM ATTACHED_SPECIFICATION
             WHERE PART_NO = GSPARTNO
               AND REVISION = GNREVISION
               AND SECTION_ID = LRVALIDATIONRULES.SECTION_ID
               AND SUB_SECTION_ID = LRVALIDATIONRULES.SUB_SECTION_ID;

            IF LNCOUNT = 0
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_ATTACHEDSPECNOTFOUND ) );
            END IF;
         ELSIF LRVALIDATIONRULES.TYPE = IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST
         THEN
            
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM SPECIFICATION_ING
             WHERE PART_NO = GSPARTNO
               AND REVISION = GNREVISION;

            IF LNCOUNT = 0
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_INGCOMPLISTNOTFOUND ) );
            END IF;
         ELSIF LRVALIDATIONRULES.TYPE = IAPICONSTANT.SECTIONTYPE_BASENAME
         THEN
            
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM ITSHBN
             WHERE PART_NO = GSPARTNO
               AND REVISION = GNREVISION
               AND SECTION_ID = LRVALIDATIONRULES.SECTION_ID
               AND SUB_SECTION_ID = LRVALIDATIONRULES.SUB_SECTION_ID;

            IF LNCOUNT = 0
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_BASENAMENOTFOUND ) );
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
   END VALIDATIONRULES;


   FUNCTION VALIDATEOBSOLETEBOM
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
       
       
      
       
       
       
       
       
       
       
       
       
       
       
       
      CURSOR LQHEADER
      IS
         SELECT DISTINCT PLANT
                    FROM BOM_HEADER
                   WHERE PART_NO = GSPARTNO
                     AND REVISION = GNREVISION;

      CURSOR LQITEMS
      IS
         SELECT DISTINCT COMPONENT_PART,
                         PLANT
                    FROM BOM_ITEM
                   WHERE PART_NO = GSPARTNO
                     AND REVISION = GNREVISION;

      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidateObsoleteBom';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      SELECT COUNT( * )
        INTO LNCOUNT
        FROM PART
       WHERE PART_NO = GSPARTNO
         AND OBSOLETE = 1;

      IF LNCOUNT > 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_OBSOLETEPARTFORSPEC,
                                                     GSPARTNO,
                                                     GNREVISION ) );
      END IF;

      
      FOR LRHEADER IN LQHEADER
      LOOP
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM PART_PLANT
          WHERE PART_NO = GSPARTNO
            AND PLANT = LRHEADER.PLANT
            AND OBSOLETE = 1;

         IF LNCOUNT > 0
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_OBSPARTPLANTFORSPEC,
                                                        GSPARTNO,
                                                    
                                                        
                                                        GNREVISION,
                                                        LRHEADER.PLANT ) );
                                                    
         END IF;
      END LOOP;

      FOR LRITEMS IN LQITEMS
      LOOP
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM PART
          WHERE PART_NO = LRITEMS.COMPONENT_PART
            AND OBSOLETE = 1;

         IF LNCOUNT = 0
         THEN
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM PART_PLANT
             WHERE PART_NO = LRITEMS.COMPONENT_PART
               AND PLANT = LRITEMS.PLANT
               AND OBSOLETE = 1;

            IF LNCOUNT > 0
            THEN
               RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_OBSPARTPLANTITEMSFORSPEC,
                                                           GSPARTNO,
                                                        
                                                           
                                                           GNREVISION,
                                                           LRITEMS.PLANT,
                                                           LRITEMS.COMPONENT_PART  ) );
                                                        
            END IF;
         ELSE
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_OBSPARTITEMSFORSPEC,
                                                        GSPARTNO,
                                                        
                                                        
                                                        GNREVISION,
                                                        LRITEMS.COMPONENT_PART ) );
                                                        
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
   END VALIDATEOBSOLETEBOM;

   FUNCTION VALIDATIONRULESERRORLIST
     (ANCURRENTSTATUS            IN       IAPITYPE.STATUSID_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANNEXTSTATUS               IN       IAPITYPE.STATUSID_TYPE,
      AQERRORS                   IN OUT   IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      CURSOR LQVALIDATIONRULES
      IS
         SELECT *
           FROM ITSHVALD
          WHERE PART_NO = ASPARTNO
            AND REVISION = ANREVISION;

      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LNFIELDID                     IAPITYPE.ID_TYPE;
      LNDISPLAYFORMAT               IAPITYPE.ID_TYPE;
      LNDISPLAYFORMATREVISION       IAPITYPE.REVISION_TYPE;
      LSTEXT                        IAPITYPE.SPECTEXTTEXT_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ValidationRulesErrorList';
      LSREFTEXTDESCRIPTION          IAPITYPE.REFERENCETEXTTYPEDESCR_TYPE;
      LSTEXTDESCRIPTION             IAPITYPE.DESCRIPTION_TYPE;
      LSOBJSHORTDESC                VARCHAR2(20);
      LNEXISTS                      NUMBER;
      LNWORKFLOWGROUPID             IAPITYPE.ID_TYPE;
      LSSTATUSTYPEFROM              IAPITYPE.STATUSTYPE_TYPE;
      LSSTATUSTYPETO                IAPITYPE.STATUSTYPE_TYPE;

   BEGIN
      
      
      
      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;

      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );

     IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                         LSMETHOD,
                                                         IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
         LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'asUser ',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );

         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      SELECT STATUS_TYPE
        INTO LSSTATUSTYPEFROM
        FROM STATUS
       WHERE STATUS = ANCURRENTSTATUS;

      SELECT STATUS_TYPE
        INTO LSSTATUSTYPETO
        FROM STATUS
       WHERE STATUS = ANNEXTSTATUS;

      GSPARTNO := ASPARTNO;
      GNREVISION := ANREVISION;
      GNNEXTSTATUS := ANNEXTSTATUS;

         SELECT COUNT(*) INTO LNEXISTS
           FROM ITSSCF, ITCF
          WHERE S_FROM = LSSTATUSTYPEFROM
            AND S_TO = LSSTATUSTYPETO
            AND WORKFLOW_GROUP_ID = -1
            AND ITSSCF.CF_ID = ITCF.CF_ID
            AND ITSSCF.STATUS_TYPE = 1
            AND ITCF.CF_TYPE = 'V'
            AND UPPER(ITCF.PROCEDURE_NAME) = 'VALIDATIONRULES' ;

      IF LNEXISTS > 0  THEN

      FOR LRVALIDATIONRULES IN LQVALIDATIONRULES
      LOOP
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Validation rule type: '
                              || LRVALIDATIONRULES.TYPE,
                              IAPICONSTANT.INFOLEVEL_3 );

         IF LRVALIDATIONRULES.TYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP
         THEN
            BEGIN
               

               
               SELECT DISPLAY_FORMAT,
                      DISPLAY_FORMAT_REV
                 INTO LNDISPLAYFORMAT,
                      LNDISPLAYFORMATREVISION
                 FROM SPECIFICATION_SECTION
                WHERE PART_NO = ASPARTNO
                  AND REVISION = ANREVISION
                  AND SECTION_ID = LRVALIDATIONRULES.SECTION_ID
                  AND SUB_SECTION_ID = LRVALIDATIONRULES.SUB_SECTION_ID
                  AND TYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP
                  AND REF_ID = LRVALIDATIONRULES.PROPERTY_GROUP;

               SELECT FIELD_ID
                 INTO LNFIELDID
                 FROM PROPERTY_LAYOUT
                WHERE LAYOUT_ID = LNDISPLAYFORMAT
                  AND REVISION = LNDISPLAYFORMATREVISION
                  AND HEADER_ID = LRVALIDATIONRULES.HEADER_ID;

              
              SELECT COUNT(*)
              INTO LNCOUNT
               FROM SPECIFICATION_PROP
               WHERE PART_NO = ASPARTNO
                 AND REVISION = ANREVISION
                 AND SECTION_ID = LRVALIDATIONRULES.SECTION_ID
                 AND SUB_SECTION_ID = LRVALIDATIONRULES.SUB_SECTION_ID
                 AND PROPERTY_GROUP = LRVALIDATIONRULES.PROPERTY_GROUP
                 AND PROPERTY = LRVALIDATIONRULES.PROPERTY
                 AND ATTRIBUTE = LRVALIDATIONRULES.ATTRIBUTE;
               
               IF ((LNCOUNT > 0) AND (NOT ISVALUEENTERED( LNFIELDID,
                                      LRVALIDATIONRULES.SECTION_ID,
                                      LRVALIDATIONRULES.SUB_SECTION_ID,
                                      LRVALIDATIONRULES.PROPERTY_GROUP,
                                      LRVALIDATIONRULES.PROPERTY,
                                      LRVALIDATIONRULES.ATTRIBUTE )))
               THEN
                 LNRETVAL := ( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_PROPERTYGROUPNOTFILLEDT,
                                                              ASPARTNO,
                                                              F_SCH_DESCR(NVL(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,1), LRVALIDATIONRULES.SECTION_ID, 0),
                                                              F_SBH_DESCR(NVL(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,1), LRVALIDATIONRULES.SUB_SECTION_ID, 0),
                                                              F_PGH_DESCR(NVL(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,1), LRVALIDATIONRULES.PROPERTY_GROUP, 0),
                                                              F_SPH_DESCR(NVL(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,1), LRVALIDATIONRULES.PROPERTY, 0),
                                                              F_ATH_DESCR(NVL(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,1), LRVALIDATIONRULES.ATTRIBUTE, 0),
                                                              F_HDH_DESCR(NVL(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,1), LRVALIDATIONRULES.HEADER_ID, 0)
                                                              ) );

                 LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'Property Group Validation',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
								 
								 NULL;


















            END;
         ELSIF LRVALIDATIONRULES.TYPE = IAPICONSTANT.SECTIONTYPE_REFERENCETEXT
         THEN
            
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM SPECIFICATION_SECTION
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND SECTION_ID = LRVALIDATIONRULES.SECTION_ID
               AND SUB_SECTION_ID = LRVALIDATIONRULES.SUB_SECTION_ID
               AND TYPE = IAPICONSTANT.SECTIONTYPE_REFERENCETEXT
               AND REF_ID = LRVALIDATIONRULES.REF_ID
               AND REF_OWNER = LRVALIDATIONRULES.REF_OWNER;

            IF LNCOUNT = 0
            THEN
                 SELECT DESCRIPTION INTO LSREFTEXTDESCRIPTION FROM REF_TEXT_TYPE
                        WHERE REF_TEXT_TYPE = LRVALIDATIONRULES.REF_ID;
                 LNRETVAL := ( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_REFERENCETEXTNOTFOUNDT,
                                                              ASPARTNO,
                                                              F_SCH_DESCR(NVL(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,1), LRVALIDATIONRULES.SECTION_ID, 0),
                                                              F_SBH_DESCR(NVL(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,1), LRVALIDATIONRULES.SUB_SECTION_ID, 0),
                                                              LSREFTEXTDESCRIPTION
                                                              
                                                              ) );

                 LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'Reference Text Validation',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
            END IF;
         ELSIF LRVALIDATIONRULES.TYPE = IAPICONSTANT.SECTIONTYPE_BOM
         THEN
            
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM BOM_HEADER
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION;

            IF LNCOUNT = 0
            THEN
               LNRETVAL := ( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_BOMHEADERNOTFOUND ) );
               LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'BOM Header Validation',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
            END IF;
         ELSIF LRVALIDATIONRULES.TYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY
         THEN
            BEGIN
               

               
               SELECT DISPLAY_FORMAT,
                      DISPLAY_FORMAT_REV
                 INTO LNDISPLAYFORMAT,
                      LNDISPLAYFORMATREVISION
                 FROM SPECIFICATION_SECTION
                WHERE PART_NO = ASPARTNO
                  AND REVISION = ANREVISION
                  AND SECTION_ID = LRVALIDATIONRULES.SECTION_ID
                  AND SUB_SECTION_ID = LRVALIDATIONRULES.SUB_SECTION_ID
                  AND TYPE = IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY
                  AND REF_ID = LRVALIDATIONRULES.PROPERTY;

               SELECT FIELD_ID
                 INTO LNFIELDID
                 FROM PROPERTY_LAYOUT
                WHERE LAYOUT_ID = LNDISPLAYFORMAT
                  AND REVISION = LNDISPLAYFORMATREVISION
                  AND HEADER_ID = LRVALIDATIONRULES.HEADER_ID;

              
              SELECT COUNT(*)
              INTO LNCOUNT
               FROM SPECIFICATION_PROP
               WHERE PART_NO = ASPARTNO
                 AND REVISION = ANREVISION
                 AND SECTION_ID = LRVALIDATIONRULES.SECTION_ID
                 AND SUB_SECTION_ID = LRVALIDATIONRULES.SUB_SECTION_ID
                 AND PROPERTY_GROUP = LRVALIDATIONRULES.PROPERTY_GROUP
                 AND PROPERTY = LRVALIDATIONRULES.PROPERTY
                 AND ATTRIBUTE = LRVALIDATIONRULES.ATTRIBUTE;

               
               IF ((LNCOUNT > 0) AND (NOT ISVALUEENTERED( LNFIELDID,
                                      LRVALIDATIONRULES.SECTION_ID,
                                      LRVALIDATIONRULES.SUB_SECTION_ID,
                                      LRVALIDATIONRULES.PROPERTY_GROUP,
                                      LRVALIDATIONRULES.PROPERTY,
                                      LRVALIDATIONRULES.ATTRIBUTE )))
               THEN
                 LNRETVAL := ( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_SINGLEPROPNOTFILLEDINT,
                                                              ASPARTNO,
                                                              F_SCH_DESCR(NVL(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,1), LRVALIDATIONRULES.SECTION_ID, 0),
                                                              F_SBH_DESCR(NVL(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,1), LRVALIDATIONRULES.SUB_SECTION_ID, 0),
                                                              F_PGH_DESCR(NVL(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,1), LRVALIDATIONRULES.PROPERTY_GROUP, 0),
                                                              F_SPH_DESCR(NVL(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,1), LRVALIDATIONRULES.PROPERTY, 0),
                                                              F_ATH_DESCR(NVL(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,1), LRVALIDATIONRULES.ATTRIBUTE, 0),
                                                              F_HDH_DESCR(NVL(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,1), LRVALIDATIONRULES.HEADER_ID, 0)
                                                              ) );

                 LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'Single Property Validation',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                 
                 NULL;


















            END;
         ELSIF LRVALIDATIONRULES.TYPE = IAPICONSTANT.SECTIONTYPE_FREETEXT
         THEN
            
            LSTEXT := NULL;

            BEGIN
               SELECT TEXT
                 INTO LSTEXT
                 FROM SPECIFICATION_TEXT
                WHERE PART_NO = ASPARTNO
                  AND REVISION = ANREVISION
                  AND SECTION_ID = LRVALIDATIONRULES.SECTION_ID
                  AND SUB_SECTION_ID = LRVALIDATIONRULES.SUB_SECTION_ID
                  AND TEXT_TYPE = LRVALIDATIONRULES.PROPERTY_GROUP;

                SELECT DESCRIPTION INTO LSTEXTDESCRIPTION FROM TEXT_TYPE
                        WHERE TEXT_TYPE = LRVALIDATIONRULES.PROPERTY_GROUP;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            IF    LSTEXT IS NULL
               OR LSTEXT = ''
            THEN
                SELECT DESCRIPTION INTO LSTEXTDESCRIPTION FROM TEXT_TYPE
                        WHERE TEXT_TYPE = LRVALIDATIONRULES.PROPERTY_GROUP;
                 
                 LNRETVAL := ( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_FREETEXTNOTFILLEDINT,
                                                              ASPARTNO,
                                                              F_SCH_DESCR(NVL(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,1), LRVALIDATIONRULES.SECTION_ID, 0),
                                                              F_SBH_DESCR(NVL(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,1), LRVALIDATIONRULES.SUB_SECTION_ID, 0),
                                                              LSTEXTDESCRIPTION,
                                                              'Missing Free text'
                                                              ) );

                 LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'Free Text Validation',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
            END IF;
         ELSIF LRVALIDATIONRULES.TYPE = IAPICONSTANT.SECTIONTYPE_OBJECT
         THEN
            
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM SPECIFICATION_SECTION
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND TYPE = IAPICONSTANT.SECTIONTYPE_OBJECT
               AND SECTION_ID = LRVALIDATIONRULES.SECTION_ID
               AND SUB_SECTION_ID = LRVALIDATIONRULES.SUB_SECTION_ID
               AND REF_ID = LRVALIDATIONRULES.REF_ID
               AND REF_OWNER = LRVALIDATIONRULES.REF_OWNER;

            IF LNCOUNT = 0
            THEN
               SELECT SORT_DESC INTO LSOBJSHORTDESC FROM ITOIH
                        WHERE OBJECT_ID = LRVALIDATIONRULES.REF_ID;

               LNRETVAL := ( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_OBJECTNOTFOUNDT,
                                                              ASPARTNO,
                                                              F_SCH_DESCR(NVL(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,1), LRVALIDATIONRULES.SECTION_ID, 0),
                                                              F_SBH_DESCR(NVL(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,1), LRVALIDATIONRULES.SUB_SECTION_ID, 0),
                                                              LSOBJSHORTDESC,
                                                              'Missing Object'
                                                              ) );

               LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'Object Validation',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
            END IF;
         ELSIF LRVALIDATIONRULES.TYPE = IAPICONSTANT.SECTIONTYPE_PROCESSDATA
         THEN
            
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM SPECIFICATION_LINE_PROP
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION;

            IF LNCOUNT = 0
            THEN
               LNRETVAL := ( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_PROCESSDATANOTFOUND ) );
               LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'Process Data Validation',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
            END IF;
         ELSIF LRVALIDATIONRULES.TYPE = IAPICONSTANT.SECTIONTYPE_ATTACHEDSPEC
         THEN
            
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM ATTACHED_SPECIFICATION
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND SECTION_ID = LRVALIDATIONRULES.SECTION_ID
               AND SUB_SECTION_ID = LRVALIDATIONRULES.SUB_SECTION_ID;

            IF LNCOUNT = 0
            THEN
               LNRETVAL := ( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                              LSMETHOD,
                                                              IAPICONSTANTDBERROR.DBERR_ATTACHEDSPECNOTFOUNDT,
                                                              ASPARTNO,
                                                              F_SCH_DESCR(NVL(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,1), LRVALIDATIONRULES.SECTION_ID, 0),
                                                              F_SBH_DESCR(NVL(IAPIGENERAL.SESSION.SETTINGS.LANGUAGEID,1), LRVALIDATIONRULES.SUB_SECTION_ID, 0),
                                                              'Missing Attached Specification'
                                                              ) );

               LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'Attached Specification Validation',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
            END IF;
         ELSIF LRVALIDATIONRULES.TYPE = IAPICONSTANT.SECTIONTYPE_INGREDIENTLIST
         THEN
            
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM SPECIFICATION_ING
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION;

            IF LNCOUNT = 0
            THEN
               LNRETVAL := ( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_INGCOMPLISTNOTFOUND ) );
               LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'Ingredient List Validation',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
            END IF;
         ELSIF LRVALIDATIONRULES.TYPE = IAPICONSTANT.SECTIONTYPE_BASENAME
         THEN
            
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM ITSHBN
             WHERE PART_NO = ASPARTNO
               AND REVISION = ANREVISION
               AND SECTION_ID = LRVALIDATIONRULES.SECTION_ID
               AND SUB_SECTION_ID = LRVALIDATIONRULES.SUB_SECTION_ID;

            IF LNCOUNT = 0
            THEN
               LNRETVAL := ( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                           LSMETHOD,
                                                           IAPICONSTANTDBERROR.DBERR_BASENAMENOTFOUND ) );
               LNRETVAL := IAPIGENERAL.ADDERRORTOLIST( 'Base Name Validation',
                                                 IAPIGENERAL.GETLASTERRORTEXT( ),
                                                 GTERRORS );
            END IF;
         END IF;
      END LOOP;

      
      IF ( GTERRORS.COUNT > 0 )
      THEN
         LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                                AQERRORS );
         RETURN( IAPICONSTANTDBERROR.DBERR_ERRORLIST );
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
   END VALIDATIONRULESERRORLIST;


END IAPISPECIFICATIONVALIDATION;
CREATE OR REPLACE PACKAGE BODY iapiTranslateL
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





   FUNCTION GETSTATUSL(
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      AQSTATUS                  OUT       IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetStatusL';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' a.STATUS '
            || IAPICONSTANTCOLUMN.STATUSCOL
            || ', a.SORT_DESC '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL 
            || ', a.DESCRIPTION '
            || IAPICONSTANTCOLUMN.LONGDESCRIPTIONCOL
            || ', a.EMAIL_TITLE '
            || IAPICONSTANTCOLUMN.EMAILTITLECOL
            || ', LANG_ID '
            || IAPICONSTANTCOLUMN.LANGUAGEIDCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := ' FROM STATUS_L a';
      LSWHERE                       IAPITYPE.STRING_TYPE := ' WHERE  STATUS = :anStatus ' ;
   BEGIN
      LSSQL :=    'Select '
               || LSSELECT
               || LSFROM
               || LSWHERE;


      
      IF ( AQSTATUS%ISOPEN )
      THEN
         CLOSE AQSTATUS;
      END IF;

      OPEN AQSTATUS FOR LSSQL USING 0;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );








      
      IF ( AQSTATUS%ISOPEN )
      THEN
         CLOSE AQSTATUS;
      END IF;

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   'anStatus ='
                                   || ANSTATUS
                                   || '  lssql=  '
                                   || LSSQL );

      OPEN AQSTATUS FOR LSSQL USING ANSTATUS;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'Select '
                  || LSSELECT
                  || LSFROM
                  || LSWHERE;

         
         IF ( AQSTATUS%ISOPEN )
         THEN
            CLOSE AQSTATUS;
         END IF;

         OPEN AQSTATUS FOR LSSQL USING ANSTATUS;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETSTATUSL;


   FUNCTION REMOVESTATUSL(
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      ANLANGID                   IN       IAPITYPE.LANGUAGEID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveFromStatusL';
   BEGIN

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      DELETE FROM STATUS_L
             WHERE STATUS = ANSTATUS
               AND LANG_ID = ANLANGID;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_GENFAIL,
                                                    ANSTATUS );
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Delete STATUSL <'
                           || ANSTATUS
                           || '  '
                           || ANLANGID
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVESTATUSL;
   
   FUNCTION SAVESTATUSL(
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      ASSORTDESC                 IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ASEMAILTITLE               IN       IAPITYPE.EMAILSUBJECT_TYPE,
      ANLANGID                   IN       IAPITYPE.LANGUAGEID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveStatusL';
      LNCOUNTER                     IAPITYPE.NUMVAL_TYPE;
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

        SELECT COUNT( * )
          INTO LNCOUNTER
            FROM STATUS_L
             WHERE STATUS = ANSTATUS
               AND LANG_ID = ANLANGID;

       IF LNCOUNTER > 0 
          THEN
             UPDATE STATUS_L
                SET SORT_DESC = ASSORTDESC,
                    DESCRIPTION = ASDESCRIPTION,
                    EMAIL_TITLE = ASEMAILTITLE
               WHERE STATUS = ANSTATUS
                 AND LANG_ID = ANLANGID;
             IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS ) 
               THEN
                IAPIGENERAL.LOGINFO( GSSOURCE,
                                     LSMETHOD,
                                     'Update STATUSL <'
                                     || ANSTATUS
                                     || '   '
                                     || ANLANGID
                                     || '>',
                                     IAPICONSTANT.INFOLEVEL_3 );
             END IF;
          ELSE
             SELECT COUNT(*) INTO LNCOUNTER FROM STATUS WHERE STATUS = ANSTATUS;
             IF LNCOUNTER = 0 
                THEN
                   IAPIGENERAL.LOGINFO( GSSOURCE,
                                        LSMETHOD,
                                        'Inexistent StatusID <'
                                        || ANSTATUS
                                        || '>',
                                        IAPICONSTANT.INFOLEVEL_3 );
                    RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
                ELSE
                   SELECT COUNT(*) INTO LNCOUNTER FROM ITLANG WHERE LANG_ID = ANLANGID;
                   IF LNCOUNTER = 0 
                      THEN
                          IAPIGENERAL.LOGINFO( GSSOURCE,
                                               LSMETHOD,
                                               'Inexistent LangID <'
                                               || ANLANGID
                                               || '>',
                                               IAPICONSTANT.INFOLEVEL_3 );
                          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
                      ELSE
                                INSERT INTO STATUS_L
                                      (STATUS,
                                      SORT_DESC,
                                      DESCRIPTION,
                                       EMAIL_TITLE,
                                      LANG_ID)
                                   VALUES
                                      (ANSTATUS,
                                       ASSORTDESC,
                                       ASDESCRIPTION,
                                       ASEMAILTITLE,
                                       ANLANGID);
                             
                             IAPIGENERAL.LOGINFO( GSSOURCE,
                                               LSMETHOD,
                                               'Insert into STATUSL <'
                                               || ANSTATUS
                                               || '   '
                                               || ANLANGID
                                               || '>',
                                               IAPICONSTANT.INFOLEVEL_3 );                   
                        
                   END IF;
             END IF;
       END IF;
       COMMIT;
       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
    EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVESTATUSL;





   FUNCTION GETITADDONL(
      ANADDONID                   IN       IAPITYPE.ID_TYPE,
      AQADDON                    OUT       IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetITAddonL';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' a.ADDON_ID '
            || IAPICONSTANTCOLUMN.IDCOL
            || ', a.DESCRIPTION '
            || IAPICONSTANTCOLUMN.LONGDESCRIPTIONCOL
            || ', LANG_ID '
            || IAPICONSTANTCOLUMN.LANGUAGEIDCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := ' FROM ITADDON_L a';
      LSWHERE                       IAPITYPE.STRING_TYPE := ' WHERE  ADDON_ID = :anAddonID ' ;
   BEGIN
      LSSQL :=    'Select '
               || LSSELECT
               || LSFROM
               || LSWHERE;


      
      IF ( AQADDON%ISOPEN )
      THEN
         CLOSE AQADDON;
      END IF;

      OPEN AQADDON FOR LSSQL USING 0;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );








      
      IF ( AQADDON%ISOPEN )
      THEN
         CLOSE AQADDON;
      END IF;

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   'anAddon ='
                                   || ANADDONID
                                   || '  lssql=  '
                                   || LSSQL );

      OPEN AQADDON FOR LSSQL USING ANADDONID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'Select '
                  || LSSELECT
                  || LSFROM
                  || LSWHERE;

         
         IF ( AQADDON%ISOPEN )
         THEN
            CLOSE AQADDON;
         END IF;

         OPEN AQADDON FOR LSSQL USING ANADDONID;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETITADDONL;


   FUNCTION REMOVEITADDONL(
      ANADDONID                  IN       IAPITYPE.ID_TYPE,
      ANLANGID                   IN       IAPITYPE.LANGUAGEID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveFromITAddonL';
   BEGIN

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      DELETE FROM ITADDON_L
             WHERE ADDON_ID = ANADDONID
               AND LANG_ID = ANLANGID;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_GENFAIL,
                                                    ANADDONID );
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Delete ITAddonL <'
                           || ANADDONID
                           || '  '
                           || ANLANGID
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEITADDONL;
   
   FUNCTION SAVEITADDONL(
      ANADDONID                  IN       IAPITYPE.ID_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ANLANGID                   IN       IAPITYPE.LANGUAGEID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveITAddonL';
      LNCOUNTER                     IAPITYPE.NUMVAL_TYPE;
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

        SELECT COUNT( * )
          INTO LNCOUNTER
            FROM ITADDON_L
             WHERE ADDON_ID = ANADDONID
               AND LANG_ID = ANLANGID;

       IF LNCOUNTER > 0 
          THEN
             UPDATE ITADDON_L
                SET DESCRIPTION = ASDESCRIPTION
               WHERE ADDON_ID = ANADDONID
                 AND LANG_ID = ANLANGID;
             IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS ) 
               THEN
                IAPIGENERAL.LOGINFO( GSSOURCE,
                                     LSMETHOD,
                                     'Update ITAddonL <'
                                     || ANADDONID
                                     || '   '
                                     || ANLANGID
                                     || '>',
                                     IAPICONSTANT.INFOLEVEL_3 );
             END IF;
          ELSE
             SELECT COUNT(*) INTO LNCOUNTER FROM ITADDON WHERE ADDON_ID = ANADDONID;
             IF LNCOUNTER = 0 
                THEN
                   IAPIGENERAL.LOGINFO( GSSOURCE,
                                        LSMETHOD,
                                        'Inexistent ITAddonID <'
                                        || ANADDONID
                                        || '>',
                                        IAPICONSTANT.INFOLEVEL_3 );
                    RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
                ELSE
                   SELECT COUNT(*) INTO LNCOUNTER FROM ITLANG WHERE LANG_ID = ANLANGID;
                   IF LNCOUNTER = 0 
                      THEN
                          IAPIGENERAL.LOGINFO( GSSOURCE,
                                               LSMETHOD,
                                               'Inexistent LangID <'
                                               || ANLANGID
                                               || '>',
                                               IAPICONSTANT.INFOLEVEL_3 );
                          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
                      ELSE
                         INSERT INTO ITADDON_L ( ADDON_ID,
                                                DESCRIPTION,
                                                LANG_ID)
                                           VALUES
                                              ( ANADDONID,
                                                ASDESCRIPTION,
                                                ANLANGID);
                          IAPIGENERAL.LOGINFO( GSSOURCE,
                                               LSMETHOD,
                                               'Insert into ITAddonL <'
                                               || ANADDONID
                                               || '   '
                                               || ANLANGID
                                               || '>',
                                              IAPICONSTANT.INFOLEVEL_3 );                   
                                              
                   END IF;
             END IF;                         
       END IF;
       COMMIT;
   
       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
    EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEITADDONL;



   FUNCTION GETWORKFLOWGL(
      ANWORKFLOWGROUPID                   IN       IAPITYPE.ID_TYPE,
      AQWORKFLOWG                        OUT       IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetWorkflowGL';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' a.WORKFLOW_GROUP_ID'
            || IAPICONSTANTCOLUMN.IDCOL
            || ', a.SORT_DESC '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL 
            || ', a.DESCRIPTION '
            || IAPICONSTANTCOLUMN.LONGDESCRIPTIONCOL
            || ', LANG_ID '
            || IAPICONSTANTCOLUMN.LANGUAGEIDCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := ' FROM WORKFLOW_GROUP_L a';
      LSWHERE                       IAPITYPE.STRING_TYPE := ' WHERE  WORKFLOW_GROUP_ID = :anWorkflowGroupID' ;
   BEGIN
      LSSQL :=    'Select '
               || LSSELECT
               || LSFROM
               || LSWHERE;


      
      IF ( AQWORKFLOWG%ISOPEN )
      THEN
         CLOSE AQWORKFLOWG;
      END IF;

      OPEN AQWORKFLOWG FOR LSSQL USING 0;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );








      
      IF ( AQWORKFLOWG%ISOPEN )
      THEN
         CLOSE AQWORKFLOWG;
      END IF;

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   'anWorkflowGroupID ='
                                   || ANWORKFLOWGROUPID
                                   || '  lssql=  '
                                   || LSSQL );

      OPEN AQWORKFLOWG FOR LSSQL USING ANWORKFLOWGROUPID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'Select '
                  || LSSELECT
                  || LSFROM
                  || LSWHERE;

         
         IF ( AQWORKFLOWG%ISOPEN )
         THEN
            CLOSE AQWORKFLOWG;
         END IF;

         OPEN AQWORKFLOWG FOR LSSQL USING ANWORKFLOWGROUPID;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETWORKFLOWGL;


   FUNCTION REMOVEWORKFLOWGL(
      ANWORKFLOWGROUPID            IN       IAPITYPE.ID_TYPE,
      ANLANGID                   IN       IAPITYPE.LANGUAGEID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveFromWorkflowGL';
   BEGIN

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      DELETE FROM WORKFLOW_GROUP_L
             WHERE WORKFLOW_GROUP_ID = ANWORKFLOWGROUPID
               AND LANG_ID = ANLANGID;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_GENFAIL,
                                                    ANWORKFLOWGROUPID );
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Delete WORKFLOW_GROUP_L <'
                           || ANWORKFLOWGROUPID
                           || '  '
                           || ANLANGID
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEWORKFLOWGL;
   
   FUNCTION SAVEWORKFLOWGL(
      ANWORKFLOWGID              IN       IAPITYPE.ID_TYPE,
      ASSORTDESC                 IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ANLANGID                   IN       IAPITYPE.LANGUAGEID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveWorkflowGL';
      LNCOUNTER                     IAPITYPE.NUMVAL_TYPE;
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

        SELECT COUNT( * )
          INTO LNCOUNTER
            FROM WORKFLOW_GROUP_L
             WHERE WORKFLOW_GROUP_ID = ANWORKFLOWGID
               AND LANG_ID = ANLANGID;

       IF LNCOUNTER > 0 
          THEN
             UPDATE WORKFLOW_GROUP_L
                SET SORT_DESC = ASSORTDESC,
                    DESCRIPTION = ASDESCRIPTION
               WHERE WORKFLOW_GROUP_ID = ANWORKFLOWGID
                 AND LANG_ID = ANLANGID;
             IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS ) 
               THEN
                IAPIGENERAL.LOGINFO( GSSOURCE,
                                     LSMETHOD,
                                     'Update WORKFLOWGL <'
                                     || ANWORKFLOWGID
                                     || '   '
                                     || ANLANGID
                                     || '>',
                                     IAPICONSTANT.INFOLEVEL_3 );
             END IF;
          ELSE
             SELECT COUNT(*) INTO LNCOUNTER FROM WORKFLOW_GROUP WHERE WORKFLOW_GROUP_ID = ANWORKFLOWGID;
             IF LNCOUNTER = 0 
                THEN
                   IAPIGENERAL.LOGINFO( GSSOURCE,
                                        LSMETHOD,
                                        'Inexistent WorkflowGID <'
                                        || ANWORKFLOWGID
                                        || '>',
                                        IAPICONSTANT.INFOLEVEL_3 );
                    RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
                ELSE
                   SELECT COUNT(*) INTO LNCOUNTER FROM ITLANG WHERE LANG_ID = ANLANGID;
                   IF LNCOUNTER = 0 
                      THEN
                          IAPIGENERAL.LOGINFO( GSSOURCE,
                                               LSMETHOD,
                                               'Inexistent LangID <'
                                               || ANLANGID
                                               || '>',
                                               IAPICONSTANT.INFOLEVEL_3 );
                          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
                      ELSE
                          INSERT INTO WORKFLOW_GROUP_L
                                      (WORKFLOW_GROUP_ID,
                                      SORT_DESC,
                                      DESCRIPTION,
                                      LANG_ID)
                                   VALUES
                                      (ANWORKFLOWGID,
                                       ASSORTDESC,
                                       ASDESCRIPTION,
                                       ANLANGID);
                             IAPIGENERAL.LOGINFO( GSSOURCE,
                                               LSMETHOD,
                                               'Insert into WORKFLOWGL <'
                                               || ANWORKFLOWGID
                                               || '   '
                                               || ANLANGID
                                               || '>',
                                               IAPICONSTANT.INFOLEVEL_3 );                   
                        END IF;
                   END IF;
       END IF;
       COMMIT;

       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
    EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEWORKFLOWGL;




   FUNCTION GETITKWL(
      ANKWID                   IN       IAPITYPE.ID_TYPE,
      AQKW                    OUT       IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetITKWL';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' a.KW_ID '
            || IAPICONSTANTCOLUMN.IDCOL
            || ', a.DESCRIPTION '
            || IAPICONSTANTCOLUMN.LONGDESCRIPTIONCOL
            || ', LANG_ID '
            || IAPICONSTANTCOLUMN.LANGUAGEIDCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := ' FROM ITKW_L a';
      LSWHERE                       IAPITYPE.STRING_TYPE := ' WHERE  KW_ID = :anKWID ' ;
   BEGIN
      LSSQL :=    'Select '
               || LSSELECT
               || LSFROM
               || LSWHERE;


      
      IF ( AQKW%ISOPEN )
      THEN
         CLOSE AQKW;
      END IF;

      OPEN AQKW FOR LSSQL USING 0;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );








      
      IF ( AQKW%ISOPEN )
      THEN
         CLOSE AQKW;
      END IF;

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   'anKW ='
                                   || ANKWID
                                   || '  lssql=  '
                                   || LSSQL );

      OPEN AQKW FOR LSSQL USING ANKWID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'Select '
                  || LSSELECT
                  || LSFROM
                  || LSWHERE;

         
         IF ( AQKW%ISOPEN )
         THEN
            CLOSE AQKW;
         END IF;

         OPEN AQKW FOR LSSQL USING ANKWID;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETITKWL;


   FUNCTION REMOVEITKWL(
      ANKWID                  IN       IAPITYPE.ID_TYPE,
      ANLANGID                   IN       IAPITYPE.LANGUAGEID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveFromITKWL';
   BEGIN

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      DELETE FROM ITKW_L
             WHERE KW_ID = ANKWID
               AND LANG_ID = ANLANGID;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_GENFAIL,
                                                    ANKWID );
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Delete ITKWL <'
                           || ANKWID
                           || '  '
                           || ANLANGID
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEITKWL;
   
   FUNCTION SAVEITKWL(
      ANKWID                  IN       IAPITYPE.ID_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ANLANGID                   IN       IAPITYPE.LANGUAGEID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveITKWL';
      LNCOUNTER                     IAPITYPE.NUMVAL_TYPE;
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

        SELECT COUNT( * )
          INTO LNCOUNTER
            FROM ITKW_L
             WHERE KW_ID = ANKWID
               AND LANG_ID = ANLANGID;

       IF LNCOUNTER > 0 
          THEN
             UPDATE ITKW_L
                SET DESCRIPTION = ASDESCRIPTION
               WHERE KW_ID = ANKWID
                 AND LANG_ID = ANLANGID;
             IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS ) 
               THEN
                IAPIGENERAL.LOGINFO( GSSOURCE,
                                     LSMETHOD,
                                     'Update ITKWL <'
                                     || ANKWID
                                     || '   '
                                     || ANLANGID
                                     || '>',
                                     IAPICONSTANT.INFOLEVEL_3 );
             END IF;
          ELSE
             SELECT COUNT(*) INTO LNCOUNTER FROM ITKW WHERE KW_ID = ANKWID;
             IF LNCOUNTER = 0 
                THEN
                   IAPIGENERAL.LOGINFO( GSSOURCE,
                                        LSMETHOD,
                                        'Inexistent ITKWID <'
                                        || ANKWID
                                        || '>',
                                        IAPICONSTANT.INFOLEVEL_3 );
                    RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
                ELSE
                   SELECT COUNT(*) INTO LNCOUNTER FROM ITLANG WHERE LANG_ID = ANLANGID;
                   IF LNCOUNTER = 0 
                      THEN
                          IAPIGENERAL.LOGINFO( GSSOURCE,
                                               LSMETHOD,
                                               'Inexistent LangID <'
                                               || ANLANGID
                                               || '>',
                                               IAPICONSTANT.INFOLEVEL_3 );
                          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
                      ELSE
                         INSERT INTO ITKW_L ( KW_ID,
                                              DESCRIPTION,
                                              LANG_ID)
                                           VALUES
                                              ( ANKWID,
                                                ASDESCRIPTION,
                                                ANLANGID);
                          IAPIGENERAL.LOGINFO( GSSOURCE,
                                               LSMETHOD,
                                               'Insert into ITKWL <'
                                               || ANKWID
                                               || '   '
                                               || ANLANGID
                                               || '>',
                                              IAPICONSTANT.INFOLEVEL_3 );                   
                                              
                   END IF;
             END IF;                         
       END IF;
       COMMIT;
   
       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
    EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEITKWL;




   FUNCTION GETITKWCHL(
      ANKWCHID                   IN       IAPITYPE.ID_TYPE,
      AQKWCH                    OUT       IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetITKWCHL';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' a.CH_ID '
            || IAPICONSTANTCOLUMN.IDCOL
            || ', a.DESCRIPTION '
            || IAPICONSTANTCOLUMN.LONGDESCRIPTIONCOL
            || ', LANG_ID '
            || IAPICONSTANTCOLUMN.LANGUAGEIDCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := ' FROM ITKWCH_L a';
      LSWHERE                       IAPITYPE.STRING_TYPE := ' WHERE  CH_ID = :anKWCHID ' ;
   BEGIN
      LSSQL :=    'Select '
               || LSSELECT
               || LSFROM
               || LSWHERE;


      
      IF ( AQKWCH%ISOPEN )
      THEN
         CLOSE AQKWCH;
      END IF;

      OPEN AQKWCH FOR LSSQL USING 0;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );








      
      IF ( AQKWCH%ISOPEN )
      THEN
         CLOSE AQKWCH;
      END IF;

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   'anKWCH ='
                                   || ANKWCHID
                                   || '  lssql=  '
                                   || LSSQL );

      OPEN AQKWCH FOR LSSQL USING ANKWCHID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'Select '
                  || LSSELECT
                  || LSFROM
                  || LSWHERE;

         
         IF ( AQKWCH%ISOPEN )
         THEN
            CLOSE AQKWCH;
         END IF;

         OPEN AQKWCH FOR LSSQL USING ANKWCHID;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETITKWCHL;


   FUNCTION REMOVEITKWCHL(
      ANKWCHID                  IN       IAPITYPE.ID_TYPE,
      ANLANGID                   IN       IAPITYPE.LANGUAGEID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveFromITKWCHL';
   BEGIN

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      DELETE FROM ITKWCH_L
             WHERE CH_ID = ANKWCHID
               AND LANG_ID = ANLANGID;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_GENFAIL,
                                                    ANKWCHID );
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Delete ITKWCHL <'
                           || ANKWCHID
                           || '  '
                           || ANLANGID
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEITKWCHL;
   
   FUNCTION SAVEITKWCHL(
      ANKWCHID                  IN       IAPITYPE.ID_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ANLANGID                   IN       IAPITYPE.LANGUAGEID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveITKWCHL';
      LNCOUNTER                     IAPITYPE.NUMVAL_TYPE;
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

        SELECT COUNT( * )
          INTO LNCOUNTER
            FROM ITKWCH_L
             WHERE CH_ID = ANKWCHID
               AND LANG_ID = ANLANGID;

       IF LNCOUNTER > 0 
          THEN
             UPDATE ITKWCH_L
                SET DESCRIPTION = ASDESCRIPTION
               WHERE CH_ID = ANKWCHID
                 AND LANG_ID = ANLANGID;
             IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS ) 
               THEN
                IAPIGENERAL.LOGINFO( GSSOURCE,
                                     LSMETHOD,
                                     'Update ITKWCHL <'
                                     || ANKWCHID
                                     || '   '
                                     || ANLANGID
                                     || '>',
                                     IAPICONSTANT.INFOLEVEL_3 );
             END IF;
          ELSE
             SELECT COUNT(*) INTO LNCOUNTER FROM ITKWCH WHERE CH_ID = ANKWCHID;
             IF LNCOUNTER = 0 
                THEN
                   IAPIGENERAL.LOGINFO( GSSOURCE,
                                        LSMETHOD,
                                        'Inexistent ITKWCHID <'
                                        || ANKWCHID
                                        || '>',
                                        IAPICONSTANT.INFOLEVEL_3 );
                    RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
                ELSE
                   SELECT COUNT(*) INTO LNCOUNTER FROM ITLANG WHERE LANG_ID = ANLANGID;
                   IF LNCOUNTER = 0 
                      THEN
                          IAPIGENERAL.LOGINFO( GSSOURCE,
                                               LSMETHOD,
                                               'Inexistent LangID <'
                                               || ANLANGID
                                               || '>',
                                               IAPICONSTANT.INFOLEVEL_3 );
                          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
                      ELSE
                         INSERT INTO ITKWCH_L ( CH_ID,
                                              DESCRIPTION,
                                              LANG_ID)
                                           VALUES
                                              ( ANKWCHID,
                                                ASDESCRIPTION,
                                                ANLANGID);
                          IAPIGENERAL.LOGINFO( GSSOURCE,
                                               LSMETHOD,
                                               'Insert into ITKWCHL <'
                                               || ANKWCHID
                                               || '   '
                                               || ANLANGID
                                               || '>',
                                              IAPICONSTANT.INFOLEVEL_3 );                   
                                              
                   END IF;
             END IF;                         
       END IF;
       COMMIT;
   
       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
    EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEITKWCHL;



   FUNCTION GETACCESSGL(
      ANACCESSGROUP                      IN       IAPITYPE.ID_TYPE,
      AQACCESSG                         OUT       IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetAccessGL';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' a.ACCESS_GROUP'
            || IAPICONSTANTCOLUMN.IDCOL
            || ', a.SORT_DESC '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL 
            || ', a.DESCRIPTION '
            || IAPICONSTANTCOLUMN.LONGDESCRIPTIONCOL
            || ', LANG_ID '
            || IAPICONSTANTCOLUMN.LANGUAGEIDCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := ' FROM ACESS_GROUP_L a';
      LSWHERE                       IAPITYPE.STRING_TYPE := ' WHERE  ACCESS_GROUP = :anAccessGroup' ;
   BEGIN
      LSSQL :=    'Select '
               || LSSELECT
               || LSFROM
               || LSWHERE;


      
      IF ( AQACCESSG%ISOPEN )
      THEN
         CLOSE AQACCESSG;
      END IF;

      OPEN AQACCESSG FOR LSSQL USING 0;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );








      
      IF ( AQACCESSG%ISOPEN )
      THEN
         CLOSE AQACCESSG;
      END IF;

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   'anAccessGroup ='
                                   || ANACCESSGROUP
                                   || '  lssql=  '
                                   || LSSQL );

      OPEN AQACCESSG FOR LSSQL USING ANACCESSGROUP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         LSSQL :=    'Select '
                  || LSSELECT
                  || LSFROM
                  || LSWHERE;

         
         IF ( AQACCESSG%ISOPEN )
         THEN
            CLOSE AQACCESSG;
         END IF;

         OPEN AQACCESSG FOR LSSQL USING ANACCESSGROUP;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETACCESSGL;


   FUNCTION REMOVEACCESSGL(
      ANACCESSGROUPID            IN       IAPITYPE.ID_TYPE,
      ANLANGID                   IN       IAPITYPE.LANGUAGEID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveFromAccessGL';
   BEGIN

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      DELETE FROM ACCESS_GROUP_L
             WHERE ACCESS_GROUP = ANACCESSGROUPID
               AND LANG_ID = ANLANGID;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_GENFAIL,
                                                    ANACCESSGROUPID );
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Delete Access_GROUP_L <'
                           || ANACCESSGROUPID
                           || '  '
                           || ANLANGID
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEACCESSGL;
   
   FUNCTION SAVEACCESSGL(
      ANACCESSGID              IN       IAPITYPE.ID_TYPE,
      ASSORTDESC                 IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,
      ANLANGID                   IN       IAPITYPE.LANGUAGEID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveAccessGL';
      LNCOUNTER                     IAPITYPE.NUMVAL_TYPE;
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

        SELECT COUNT( * )
          INTO LNCOUNTER
            FROM ACCESS_GROUP_L
             WHERE ACCESS_GROUP = ANACCESSGID
               AND LANG_ID = ANLANGID;

       IF LNCOUNTER > 0 
          THEN
             UPDATE ACCESS_GROUP_L
                SET SORT_DESC = ASSORTDESC,
                    DESCRIPTION = ASDESCRIPTION
               WHERE ACCESS_GROUP = ANACCESSGID
                 AND LANG_ID = ANLANGID;
             IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS ) 
               THEN
                IAPIGENERAL.LOGINFO( GSSOURCE,
                                     LSMETHOD,
                                     'Update AccessGL <'
                                     || ANACCESSGID
                                     || '   '
                                     || ANLANGID
                                     || '>',
                                     IAPICONSTANT.INFOLEVEL_3 );
             END IF;
          ELSE
             SELECT COUNT(*) INTO LNCOUNTER FROM ACCESS_GROUP WHERE ACCESS_GROUP = ANACCESSGID;
             IF LNCOUNTER = 0 
                THEN
                   IAPIGENERAL.LOGINFO( GSSOURCE,
                                        LSMETHOD,
                                        'Inexistent AccessG <'
                                        || ANACCESSGID
                                        || '>',
                                        IAPICONSTANT.INFOLEVEL_3 );
                    RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
                ELSE
                   SELECT COUNT(*) INTO LNCOUNTER FROM ITLANG WHERE LANG_ID = ANLANGID;
                   IF LNCOUNTER = 0 
                      THEN
                          IAPIGENERAL.LOGINFO( GSSOURCE,
                                               LSMETHOD,
                                               'Inexistent LangID <'
                                               || ANLANGID
                                               || '>',
                                               IAPICONSTANT.INFOLEVEL_3 );
                          RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
                      ELSE
                          INSERT INTO ACCESS_GROUP_L
                                      (ACCESS_GROUP,
                                      SORT_DESC,
                                      DESCRIPTION,
                                      LANG_ID)
                                   VALUES
                                      (ANACCESSGID,
                                       ASSORTDESC,
                                       ASDESCRIPTION,
                                       ANLANGID);
                             IAPIGENERAL.LOGINFO( GSSOURCE,
                                               LSMETHOD,
                                               'Insert into AccessGL <'
                                               || ANACCESSGID
                                               || '   '
                                               || ANLANGID
                                               || '>',
                                               IAPICONSTANT.INFOLEVEL_3 );                   
                        END IF;
                   END IF;
       END IF;
       COMMIT;

       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
    EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEACCESSGL;


   
 

   FUNCTION GETRDSTATUSL(
      ANSTATUSID                IN       IAPITYPE.STATUSID_TYPE,
      AQSTATUS                  OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetRDStatusL';
      LSSQL                         IAPITYPE.SQLSTRING_TYPE;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE
         :=    ' a.STATUS '
            || IAPICONSTANTCOLUMN.STATUSCOL
            || ', a.SHORT_DESC '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', a.DESCRIPTION '
            || IAPICONSTANTCOLUMN.LONGDESCRIPTIONCOL
            || ', LANG_ID '
            || IAPICONSTANTCOLUMN.LANGUAGEIDCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := ' FROM itRdStatus_l a';
      LSWHERE                       IAPITYPE.STRING_TYPE := ' WHERE  status = :anStatus ';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQSTATUS%ISOPEN )
      THEN
         CLOSE AQSTATUS;
      END IF;

      LSSQL :=    'Select '
               || LSSELECT
               || LSFROM
               || LSWHERE;

      IAPIGENERAL.LOGINFOINCHUNKS( GSSOURCE,
                                   LSMETHOD,
                                   'anStatus = ' || ANSTATUSID ||
                                   ' lsSql=  ' || LSSQL );

      OPEN AQSTATUS FOR LSSQL 
      USING ANSTATUSID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN      
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
                               
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETRDSTATUSL;
   

   

   FUNCTION REMOVERDSTATUSL(
      ANSTATUSID                 IN       IAPITYPE.STATUSID_TYPE,
      ANLANGID                   IN       IAPITYPE.LANGUAGEID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveRDStatusL';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Delete from itRdStatus_l <'
                           || ANSTATUSID
                           || '  '
                           || ANLANGID
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );

      DELETE FROM ITRDSTATUS_L
      WHERE STATUS = ANSTATUSID
        AND LANG_ID = ANLANGID;

      IF SQL%ROWCOUNT = 0
      THEN
      
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               'No data found with statusId <' || ANSTATUSID || '> and langId <' || ANLANGID || '>' );
 
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_GENFAIL );
      END IF;
                           
      COMMIT;
                           
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );      
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVERDSTATUSL;
   
   
   
   
   FUNCTION SAVERDSTATUSL(
      ANSTATUSID                 IN       IAPITYPE.STATUSID_TYPE,
      ASSHORTDESC                IN       IAPITYPE.SHORTDESCRIPTION_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE,      
      ANLANGID                   IN       IAPITYPE.LANGUAGEID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveRDStatusL';
      LNCOUNTER                     IAPITYPE.NUMVAL_TYPE;
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;

   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT COUNT( * )
      INTO LNCOUNTER
      FROM ITRDSTATUS_L
      WHERE STATUS = ANSTATUSID
        AND LANG_ID = ANLANGID;

     IF LNCOUNTER > 0 
     THEN
        IAPIGENERAL.LOGINFO( GSSOURCE,
                             LSMETHOD,
                             'Update itRdStatus_l <'
                             || ANSTATUSID
                             || '   '
                             || ANLANGID
                             || '>',
                             IAPICONSTANT.INFOLEVEL_3 );

        UPDATE ITRDSTATUS_L
        SET SHORT_DESC = ASSHORTDESC,
            DESCRIPTION = ASDESCRIPTION                
        WHERE STATUS = ANSTATUSID
            AND LANG_ID = ANLANGID;
     
     ELSE
        SELECT COUNT(*) 
        INTO LNCOUNTER 
        FROM ITRDSTATUS 
        WHERE STATUS = ANSTATUSID;
                     
        IF LNCOUNTER = 0 
        THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  'Status with ID <' || ANSTATUSID || '> does not exist.');
                                 
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
        END IF;
        
        SELECT COUNT(*) 
        INTO LNCOUNTER 
        FROM ITLANG 
        WHERE LANG_ID = ANLANGID;
            
        IF LNCOUNTER = 0 
        THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  'Language with ID <' || ANLANGID || '> does not exist.');
                               
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
        END IF;

        IAPIGENERAL.LOGINFO( GSSOURCE,
                             LSMETHOD,
                             'Insert into itRdStatus_l <' || ANSTATUSID || ' - ' || ANLANGID|| '>',
                             IAPICONSTANT.INFOLEVEL_3 );                   

        INSERT INTO ITRDSTATUS_L 
            (STATUS,
             SHORT_DESC,
             DESCRIPTION,                                       
             LANG_ID)
        VALUES (ANSTATUSID,
                ASSHORTDESC,
                ASDESCRIPTION,                                       
                ANLANGID);
        
        COMMIT;
                                                                     
        END IF;
               
       RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
    EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
                               
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVERDSTATUSL;
   

END IAPITRANSLATEL;
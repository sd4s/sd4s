CREATE OR REPLACE PACKAGE BODY iapiMop
AS
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   PSMOPJOB                      VARCHAR2( 32 ) := 'iapiQueue.ExecuteQueue';
   PSMOPJOBNAME                  VARCHAR2( 32 ) := 'DB_Q';

   
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

   
   
   

   
   
   
   
   
   
   
   FUNCTION ADDSPECIFICATION(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddSpecification';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      
      LNRETVAL := IAPISPECIFICATION.EXISTID( ASPARTNO,
                                             ANREVISION );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );

      BEGIN
         INSERT INTO ITSHQ
                     ( USER_ID,
                       PART_NO,
                       REVISION )
              VALUES ( ASUSERID,
                       ASPARTNO,
                       ANREVISION );
      EXCEPTION
         
         WHEN DUP_VAL_ON_INDEX
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
   END ADDSPECIFICATION;



   
   FUNCTION SAVESPECIFICATION(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSELECTED                 IN       IAPITYPE.BOOLEAN_TYPE)
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveSpecification';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );


         UPDATE ITSHQ
            SET SELECTED = ANSELECTED
         WHERE USER_ID = ASUSERID
            AND PART_NO = ASPARTNO
            AND REVISION = ANREVISION;

         COMMIT;






      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVESPECIFICATION;



   
   FUNCTION SAVESPECIFICATIONS(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE)
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveSpecifications';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );


         UPDATE ITSHQ
            SET SELECTED = 1
         WHERE USER_ID = ASUSERID;

         COMMIT;






      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVESPECIFICATIONS;

   
   FUNCTION GETLIST(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      AQLIST                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetList';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'i.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', i.revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', f_sh_descr(1, i.part_no, i.revision) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', sh.status '
            || IAPICONSTANTCOLUMN.STATUSIDCOL
            || ', f_ss_descr(sh.status) '
            || IAPICONSTANTCOLUMN.STATUSCOL
            || ', ss.status_type '
            || IAPICONSTANTCOLUMN.STATUSTYPECOL
            || ', f_get_access(i.part_no, i.revision, i.user_id, i.user_intl) '
            || IAPICONSTANTCOLUMN.SPECIFICATIONACCESSCOL
            || ', sh.workflow_group_id '
            || IAPICONSTANTCOLUMN.WORKFLOWGROUPIDCOL
            || ', sh.frame_id '
            || IAPICONSTANTCOLUMN.FRAMENOCOL
            || ', sh.frame_rev '
            || IAPICONSTANTCOLUMN.FRAMEREVISIONCOL
            || ', sh.frame_owner '
            || IAPICONSTANTCOLUMN.FRAMEOWNERCOL
            || ', sh.frame_id||'
            || ''' ['''
            || '||sh.frame_rev||'
            || ''']'' '
            || IAPICONSTANTCOLUMN.FORMATTEDFRAMECOL
            || ', sh.mask_id '
            || IAPICONSTANTCOLUMN.MASKIDCOL
            || ', iv.description '
            || IAPICONSTANTCOLUMN.MASKCOL
            || ', f_wf_descr(sh.workflow_group_id) '
            || IAPICONSTANTCOLUMN.WORKFLOWGROUPCOL
            || ', sh.access_group '
            || IAPICONSTANTCOLUMN.ACCESSGROUPIDCOL
            || ', f_ac_descr(sh.access_group) '
            

            || IAPICONSTANTCOLUMN.ACCESSGROUPCOL
            || ', i.selected '
            
            || IAPICONSTANTCOLUMN.SELECTEDCOL
            
            
            || ', DECODE( ss.STATUS_TYPE, ''' || IAPICONSTANT.STATUSTYPE_DEVELOPMENT || ''', ' 
            || '  ( SELECT TEXT '
            || '    FROM REASON '
            || '    WHERE REASON.PART_NO = i.PART_NO '
            || '    AND REASON.REVISION = i.REVISION '
            || '    AND REASON.STATUS_TYPE = ''' || IAPICONSTANT.STATUSTYPE_REASONFORISSUE || ''' '
            || '    AND REASON.ID = ( SELECT MAX( ID ) '
            || '                      FROM REASON '
            || '                      WHERE REASON.id > 0 ' 
            || '                      AND REASON.PART_NO = i.PART_NO '
            || '                      AND REASON.REVISION = i.REVISION '
            || '                      AND REASON.STATUS_TYPE = ''' || IAPICONSTANT.STATUSTYPE_REASONFORISSUE || ''' ) ), NULL ) '             
            || IAPICONSTANTCOLUMN.REASONFORISSUECOL;
            
            
      LSFROM                        IAPITYPE.STRING_TYPE := 'status ss, itfrmv iv, specification_header sh, itshq i ';
   BEGIN
      
      
      
      
      
      IF ( AQLIST%ISOPEN )
      THEN
         CLOSE AQLIST;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE i.part_no = NULL';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQLIST FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=
            'SELECT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE i.user_id=:id '
         || '   AND i.part_no = sh.part_no AND i.revision = sh.revision AND sh.status = ss.status '
         || '   AND sh.frame_id = iv.frame_no(+) AND sh.frame_rev = iv.revision(+) AND sh.frame_owner = iv.owner(+) AND sh.mask_id = iv.view_id(+) ';
      LSSQL :=    LSSQL
               || ' ORDER BY '
               || IAPICONSTANTCOLUMN.PARTNOCOL
               || ','
               || IAPICONSTANTCOLUMN.REVISIONCOL;
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQLIST%ISOPEN )
      THEN
         CLOSE AQLIST;
      END IF;

      
      OPEN AQLIST FOR LSSQL USING ASUSERID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETLIST;

   
   FUNCTION REMOVEALL(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveAll';
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

      DELETE FROM ITSHQ
            WHERE USER_ID = ASUSERID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEALL;

   
   FUNCTION REMOVESPECIFICATION(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveSpecification';
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

      DELETE FROM ITSHQ
            WHERE USER_ID = ASUSERID
              AND PART_NO = ASPARTNO
              AND REVISION = ANREVISION;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVESPECIFICATION;

   
   FUNCTION GETJOBSTATUS(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      AQLIST                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetJobStatus';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'i.job_descr '
            || IAPICONSTANTCOLUMN.JOBDESCRIPTIONCOL
            || ', au.last_name '
            || IAPICONSTANTCOLUMN.LASTNAMECOL
            || ', au.forename '
            || IAPICONSTANTCOLUMN.FORENAMECOL
            || ', i.status '
            || IAPICONSTANTCOLUMN.JOBSTATUSCOL
            || ', i.progress '
            || IAPICONSTANTCOLUMN.PROGRESSCOL
            || ', i.user_id '
            || IAPICONSTANTCOLUMN.USERIDCOL
            || ', i.start_date '
            || IAPICONSTANTCOLUMN.STARTDATECOL
            || ', i.end_date '
            || IAPICONSTANTCOLUMN.ENDDATECOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'application_user au, itq i ';
   BEGIN
      
      
      
      
      
      IF ( AQLIST%ISOPEN )
      THEN
         CLOSE AQLIST;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE i.user_id = NULL';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQLIST FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=
            'SELECT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE i.user_id = au.user_id '
         || '   AND ( i.status = ''Started'' OR i.user_id = :userid ) ';
      LSSQL :=    LSSQL
               || ' ORDER BY '
               || IAPICONSTANTCOLUMN.STARTDATECOL;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQLIST%ISOPEN )
      THEN
         CLOSE AQLIST;
      END IF;

      
      OPEN AQLIST FOR LSSQL USING ASUSERID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETJOBSTATUS;

   
   FUNCTION GETJOBLOG(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ADLOGDATE                  IN       IAPITYPE.DATE_TYPE,
      AQLIST                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetJobLog';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
                                                    :=    'error_msg '
                                                       || IAPICONSTANTCOLUMN.ERRORTEXTCOL
                                                       || ', logdate '
                                                       || IAPICONSTANTCOLUMN.DATE1COL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'itjobq ';
   BEGIN
      
      
      
      
      
      IF ( AQLIST%ISOPEN )
      THEN
         CLOSE AQLIST;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE user_id = NULL';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQLIST FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM
               || ' WHERE user_id = :userid '
               || '   AND logdate >= :logdate ';
      LSSQL :=    LSSQL
               || ' ORDER BY '
               || IAPICONSTANTCOLUMN.DATE1COL;
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQLIST%ISOPEN )
      THEN
         CLOSE AQLIST;
      END IF;

      
      OPEN AQLIST FOR LSSQL USING ASUSERID,
      ADLOGDATE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETJOBLOG;

   
   FUNCTION GETPARTINBOMLIST(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      AQLIST                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPartInBomList';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'i.user_id '
            || IAPICONSTANTCOLUMN.USERIDCOL
            || ', i.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', i.revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', i.user_intl '
            || IAPICONSTANTCOLUMN.INTERNATIONALCOL
            || ', i.text '
            || IAPICONSTANTCOLUMN.TEXTCOL
            || ', f_sh_descr(1, i.part_no, i.revision) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', bi.conv_factor '
            || IAPICONSTANTCOLUMN.CONVERSIONFACTORCOL
            || ', p.base_conv_factor '
            || IAPICONSTANTCOLUMN.NEWCONVERSIONFACTORCOL
            || ', s.status '
            || IAPICONSTANTCOLUMN.STATUSIDCOL
            || ', f_ss_descr(s.status) '
            || IAPICONSTANTCOLUMN.STATUSCOL
            || ', f_get_access(i.part_no, i.revision, i.user_id, i.user_intl) '
            || IAPICONSTANTCOLUMN.SPECIFICATIONACCESSCOL
            || ', bi.plant '
            || IAPICONSTANTCOLUMN.PLANTNOCOL
            || ', pl.description '
            || IAPICONSTANTCOLUMN.PLANTCOL
            || ', bi.alternative '
            || IAPICONSTANTCOLUMN.ALTERNATIVECOL
            || ', bu.descr '
            || IAPICONSTANTCOLUMN.BOMUSAGEDESCRIPTIONCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'bom_item bi, part p, specification_header s, itbu bu, plant pl, itshq i ';
   BEGIN
      
      
      
      
      
      IF ( AQLIST%ISOPEN )
      THEN
         CLOSE AQLIST;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE user_id = NULL';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQLIST FOR LSSQLNULL;

      
      IF    ( ASPARTNO IS NULL )
         OR ( ASPARTNO = '' )
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      LNRETVAL := IAPIPART.EXISTID( ASPARTNO );

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
      
      LSSQL :=
            'SELECT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE i.user_id=:id '
         || '   AND i.part_no = bi.part_no AND i.revision = bi.revision '
         || '   AND p.part_no = bi.component_part '
         || '   AND bi.component_part = :partno '
         || '   AND i.part_no = s.part_no AND i.revision = s.revision '
         || '   AND bi.bom_usage = bu.bom_usage '
         || '   AND pl.plant = bi.plant ';
      LSSQL :=    LSSQL
               || ' ORDER BY '
               || IAPICONSTANTCOLUMN.PARTNOCOL
               || ','
               || IAPICONSTANTCOLUMN.REVISIONCOL;
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQLIST%ISOPEN )
      THEN
         CLOSE AQLIST;
      END IF;

      
      OPEN AQLIST FOR LSSQL USING ASUSERID,
      ASPARTNO;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPARTINBOMLIST;

   
   FUNCTION GETUSEDSUBSECTIONS(
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ASDESCRIPTIONLIKE          IN       IAPITYPE.DESCRIPTION_TYPE DEFAULT NULL,
      AQUSEDSUBSECTIONS          OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUsedSubSections';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'sbs.sub_section_id '
            || IAPICONSTANTCOLUMN.SUBSECTIONIDCOL
            || ', sbs.intl '
            || IAPICONSTANTCOLUMN.INTERNATIONALCOL
            || ', f_sbh_descr(1, sbs.sub_section_id, 0) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'specification_section sps, sub_section sbs ';
   BEGIN
      
      
      
      
      
      IF ( AQUSEDSUBSECTIONS%ISOPEN )
      THEN
         CLOSE AQUSEDSUBSECTIONS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE sps.sub_section_id = sbs.sub_section_id AND part_no = NULL';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQUSEDSUBSECTIONS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=
            'SELECT DISTINCT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE sps.sub_section_id = sbs.sub_section_id '
         || '   AND sps.section_id = :sectionid ';

      IF NOT( ASDESCRIPTIONLIKE IS NULL )
      THEN
         LSSQL :=    LSSQL
                  || ' AND f_sbh_descr(1, sbs.sub_section_id, 0) LIKE ''%'
                  || ASDESCRIPTIONLIKE
                  || '%''';
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY '
               || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQUSEDSUBSECTIONS%ISOPEN )
      THEN
         CLOSE AQUSEDSUBSECTIONS;
      END IF;

      
      OPEN AQUSEDSUBSECTIONS FOR LSSQL USING ANSECTIONID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUSEDSUBSECTIONS;

   
   FUNCTION GETUSEDPROPERTYGROUPS(
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ASDESCRIPTIONLIKE          IN       IAPITYPE.DESCRIPTION_TYPE DEFAULT NULL,
      AQUSEDPROPERTYGROUPS       OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUsedPropertyGroups';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'p.property_group '
            || IAPICONSTANTCOLUMN.PROPERTYGROUPIDCOL
            || ', p.intl '
            || IAPICONSTANTCOLUMN.INTERNATIONALCOL
            || ', f_pgh_descr(1, p.property_group, 0) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'specification_section s, property_group p ';
   BEGIN
      
      
      
      
      
      IF ( AQUSEDPROPERTYGROUPS%ISOPEN )
      THEN
         CLOSE AQUSEDPROPERTYGROUPS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE s.ref_id = p.property_group AND part_no = NULL';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQUSEDPROPERTYGROUPS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=
            'SELECT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE s.ref_id = p.property_group '
         || '   AND s.section_id = :sectionid '
         || '   AND s.sub_section_id = :subsectionid '
         || '   AND s.type = :type ';

      IF NOT( ASDESCRIPTIONLIKE IS NULL )
      THEN
         LSSQL :=    LSSQL
                  || ' AND f_pgh_descr(1, p.property_group, 0) LIKE ''%'
                  || ASDESCRIPTIONLIKE
                  || '%''';
      END IF;

      LSSQL :=    LSSQL
               || ' UNION '
               || 'SELECT 0, ''0'', ''(none)'' FROM DUAL';
      LSSQL :=    LSSQL
               || ' ORDER BY '
               || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQUSEDPROPERTYGROUPS%ISOPEN )
      THEN
         CLOSE AQUSEDPROPERTYGROUPS;
      END IF;

      
      OPEN AQUSEDPROPERTYGROUPS FOR LSSQL USING ANSECTIONID,
      ANSUBSECTIONID,
      IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUSEDPROPERTYGROUPS;

   
   FUNCTION GETPROPERTIES(
      ANPROPERTYGROUPID          IN       IAPITYPE.ID_TYPE,
      ASDESCRIPTIONLIKE          IN       IAPITYPE.DESCRIPTION_TYPE DEFAULT NULL,
      AQPROPERTIES               OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetProperties';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECTPG                    VARCHAR2( 4096 )
         :=    'p.property '
            || IAPICONSTANTCOLUMN.PROPERTYIDCOL
            || ', p.intl '
            || IAPICONSTANTCOLUMN.INTERNATIONALCOL
            || ', f_sph_descr(1, p.property, 0) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
      LSFROMPG                      IAPITYPE.STRING_TYPE := 'property_group_list p ';
      LSSELECTSP                    VARCHAR2( 4096 )
         :=    'pd.property '
            || IAPICONSTANTCOLUMN.PROPERTYIDCOL
            || ', p.intl '
            || IAPICONSTANTCOLUMN.INTERNATIONALCOL
            || ', f_sph_descr(1, p.property, 0) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
      LSFROMSP                      IAPITYPE.STRING_TYPE := 'property_display pd, property p ';
   BEGIN
      
      
      
      
      
      IF ( AQPROPERTIES%ISOPEN )
      THEN
         CLOSE AQPROPERTIES;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECTPG
                   || ' FROM '
                   || LSFROMPG
                   || ' WHERE p.property_group = NULL';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQPROPERTIES FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( ANPROPERTYGROUPID <> 0 )
      THEN
         LSSQL :=    'SELECT DISTINCT '
                  || LSSELECTPG
                  || ' FROM '
                  || LSFROMPG
                  || ' WHERE p.property_group = :propertygroup ';
      ELSE
         LSSQL :=    'SELECT DISTINCT '
                  || LSSELECTSP
                  || ' FROM '
                  || LSFROMSP
                  || ' WHERE pd.property = p.property ';
      END IF;

      IF NOT( ASDESCRIPTIONLIKE IS NULL )
      THEN
         LSSQL :=    LSSQL
                  || ' AND f_sph_descr(1, p.property, 0) LIKE ''%'
                  || ASDESCRIPTIONLIKE
                  || '%''';
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY '
               || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQPROPERTIES%ISOPEN )
      THEN
         CLOSE AQPROPERTIES;
      END IF;

      
      IF ( ANPROPERTYGROUPID <> 0 )
      THEN
         OPEN AQPROPERTIES FOR LSSQL USING ANPROPERTYGROUPID;
      ELSE
         OPEN AQPROPERTIES FOR LSSQL;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPROPERTIES;

   
   FUNCTION GETATTRIBUTES(
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ASDESCRIPTIONLIKE          IN       IAPITYPE.DESCRIPTION_TYPE DEFAULT NULL,
      AQATTRIBUTES               OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetAttributes';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'ap.property '
            || IAPICONSTANTCOLUMN.PROPERTYIDCOL
            || ', ap.attribute '
            || IAPICONSTANTCOLUMN.ATTRIBUTEIDCOL
            || ', ap.intl '
            || IAPICONSTANTCOLUMN.INTERNATIONALCOL
            || ', f_ath_descr(1, ap.attribute, 0) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'attribute_property ap, attribute a ';
   BEGIN
      
      
      
      
      
      IF ( AQATTRIBUTES%ISOPEN )
      THEN
         CLOSE AQATTRIBUTES;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE ap.property = NULL';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQATTRIBUTES FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM
               || ' WHERE ap.attribute = a.attribute AND ap.property = :property AND a.status = 0 ';

      IF NOT( ASDESCRIPTIONLIKE IS NULL )
      THEN
         LSSQL :=    LSSQL
                  || ' AND f_ath_descr(1, ap.attribute, 0) LIKE ''%'
                  || ASDESCRIPTIONLIKE
                  || '%''';
      END IF;

      LSSQL :=    LSSQL
               || ' UNION '
               || 'SELECT 0, 0, ''1'', '' - '' FROM DUAL';
      LSSQL :=    LSSQL
               || ' ORDER BY '
               || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQATTRIBUTES%ISOPEN )
      THEN
         CLOSE AQATTRIBUTES;
      END IF;

      
      OPEN AQATTRIBUTES FOR LSSQL USING ANPROPERTYID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETATTRIBUTES;

   
   FUNCTION GETHEADERS(
      ANLAYOUTTYPE               IN       IAPITYPE.ID_TYPE,
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ASDESCRIPTIONLIKE          IN       IAPITYPE.DESCRIPTION_TYPE DEFAULT NULL,
      AQHEADERS                  OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetHeaders';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'pl.header_id '
            || IAPICONSTANTCOLUMN.HEADERIDCOL
            || ', f_hdh_descr (1, pl.header_id, 0) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', f_get_field_datatype(pl.field_id) '
            || IAPICONSTANTCOLUMN.FIELDTYPECOL
            || ', pl.header_id + (1000000 * f_get_field_datatype(pl.field_id)) '
            || IAPICONSTANTCOLUMN.FIELDIDCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'property_layout pl, layout l ';
   BEGIN
      
      
      
      
      
      IF ( AQHEADERS%ISOPEN )
      THEN
         CLOSE AQHEADERS;
      END IF;

      LSSQLNULL :=
            'SELECT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE l.layout_id = pl.layout_id '
         || '   AND l.revision = pl.revision '
         || '   AND l.layout_id = NULL';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQHEADERS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=
            'SELECT DISTINCT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE l.layout_id = pl.layout_id '
         || '   AND l.revision = pl.revision '
         || '   AND l.status > 1 '
         || '   AND (pl.field_id < 23 OR pl.field_id IN ( 25, 26, 30, 31 )) '
         || '   AND pl.layout_id IN ';

      IF ( ANLAYOUTTYPE = IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP )
      THEN
         LSSQL :=
               LSSQL
            || '( SELECT i.display_format '
            || '                           FROM itshly i, property_group_list pgl '
            || '                          WHERE i.ly_id = pgl.property_group '
            || '                            AND pgl.property = :property '
            || '                            AND i.ly_type = '
            || ANLAYOUTTYPE
            || ')';
      ELSIF( ANLAYOUTTYPE IN( IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY, IAPICONSTANT.SECTIONTYPE_REFERENCETEXT ) )
      THEN
         LSSQL :=
               LSSQL
            || '( SELECT DISTINCT i.display_format '
            || '                           FROM itshly i '
            || '                          WHERE i.ly_id = :property '
            || '                            AND i.ly_type = '
            || ANLAYOUTTYPE
            || ')';
      END IF;

      IF NOT( ASDESCRIPTIONLIKE IS NULL )
      THEN
         LSSQL :=    LSSQL
                  || ' AND f_hdh_descr (1, pl.header_id, 0) LIKE ''%'
                  || ASDESCRIPTIONLIKE
                  || '%''';
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY '
               || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQHEADERS%ISOPEN )
      THEN
         CLOSE AQHEADERS;
      END IF;

      
      OPEN AQHEADERS FOR LSSQL USING ANPROPERTYID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETHEADERS;

   
   FUNCTION GETSECTIONDATA(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ANFIELDTYPE                IN       IAPITYPE.NUMVAL_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANPROPERTYGROUPID          IN       IAPITYPE.ID_TYPE,
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE,
      ANHEADERID                 IN       IAPITYPE.ID_TYPE,
      AQSECTIONDATA              OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetSectionData';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECTBASE                  VARCHAR2( 4096 )
         :=    'i.user_id '
            || IAPICONSTANTCOLUMN.USERIDCOL
            || ', i.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', i.revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', i.text '
            || IAPICONSTANTCOLUMN.TEXTCOL
            || ', To_NUMBER(i.user_intl) '
            || IAPICONSTANTCOLUMN.INTERNATIONALCOL
            || ', ''X'' '
            || IAPICONSTANTCOLUMN.FIELDTYPECOL
            || ', i.new_value_char '
            || IAPICONSTANTCOLUMN.OLDVALUECHARCOL
            || ', i.new_value_char '
            || IAPICONSTANTCOLUMN.NEWVALUECHARCOL
            || ', i.new_value_num '
            || IAPICONSTANTCOLUMN.OLDVALUENUMCOL
            || ', i.new_value_num '
            || IAPICONSTANTCOLUMN.NEWVALUENUMCOL
            || ', i.new_value_date '
            || IAPICONSTANTCOLUMN.OLDVALUEDATECOL
            || ', i.new_value_date '
            || IAPICONSTANTCOLUMN.NEWVALUEDATECOL
            || ', i.new_value_num '
            || IAPICONSTANTCOLUMN.OLDVALUETMIDCOL
            || ', i.new_value_num '
            || IAPICONSTANTCOLUMN.NEWVALUETMIDCOL
            || ', null '
            || IAPICONSTANTCOLUMN.OLDVALUETMCOL   
            || ', i.new_value_num '
            || IAPICONSTANTCOLUMN.OLDVALUEASSIDCOL
            || ', i.new_value_num '
            || IAPICONSTANTCOLUMN.NEWVALUEASSIDCOL
            || ', null '
            || IAPICONSTANTCOLUMN.OLDVALUEASSCOL;   
      LSFROMBASE                    IAPITYPE.STRING_TYPE := 'itshq i ';
      LRSECTIONDAT                  IAPITYPE.MOPRPVSECTIONDATAREC_TYPE;
      LRSECTIONDATA                 MOPRPVSECTIONDATARECORD_TYPE
         := MOPRPVSECTIONDATARECORD_TYPE( NULL,
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
      LTSECTIONDATA                 MOPRPVSECTIONDATATABLE_TYPE := MOPRPVSECTIONDATATABLE_TYPE( );
      LSTYPE                        VARCHAR2( 16 );
      LSOLDDATA                     VARCHAR2( 4096 );
      LQOLDDATA                     IAPITYPE.REF_TYPE;
      LNCOUNT                       NUMBER;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LNCOUNTOLD                    NUMBER;

      TYPE OLDDATADEFAULTREC_TYPE IS RECORD(
         PARTNO                        IAPITYPE.PARTNO_TYPE,
         REVISION                      IAPITYPE.REVISION_TYPE,
         VALUE                         IAPITYPE.FLOAT_TYPE,
         VALUE_S                       IAPITYPE.STRING_TYPE,
         VALUE_DT                      IAPITYPE.DATE_TYPE
      );

      TYPE LTOLDDATADEFAULT_TYPE IS TABLE OF OLDDATADEFAULTREC_TYPE
         INDEX BY BINARY_INTEGER;

      LTOLDDATADEFAULT              LTOLDDATADEFAULT_TYPE;

      TYPE OLDDATATESTMETHODREC_TYPE IS RECORD(
         PARTNO                        IAPITYPE.PARTNO_TYPE,
         REVISION                      IAPITYPE.REVISION_TYPE,
         TESTMETHODID                  IAPITYPE.ID_TYPE,
         TESTMETHOD                    IAPITYPE.DESCRIPTION_TYPE
      );

      TYPE LTOLDDATATESTMETHOD_TYPE IS TABLE OF OLDDATATESTMETHODREC_TYPE
         INDEX BY BINARY_INTEGER;

      LTOLDDATATESTMETHOD           LTOLDDATATESTMETHOD_TYPE;

      TYPE OLDDATAASSOCIATIONREC_TYPE IS RECORD(
         PARTNO                        IAPITYPE.PARTNO_TYPE,
         REVISION                      IAPITYPE.REVISION_TYPE,
         CHARACTERISTIC1               IAPITYPE.ID_TYPE,
         CHARACTERISTIC1_DESCR         IAPITYPE.DESCRIPTION_TYPE,
         ASSOCIATION1                  IAPITYPE.ID_TYPE,
         ASSOCIATION1_DESCR            IAPITYPE.DESCRIPTION_TYPE,
         CHARACTERISTIC2               IAPITYPE.ID_TYPE,
         CHARACTERISTIC2_DESCR         IAPITYPE.DESCRIPTION_TYPE,
         ASSOCIATION2                  IAPITYPE.ID_TYPE,
         ASSOCIATION2_DESCR            IAPITYPE.DESCRIPTION_TYPE,
         CHARACTERISTIC3               IAPITYPE.ID_TYPE,
         CHARACTERISTIC3_DESCR         IAPITYPE.DESCRIPTION_TYPE,
         ASSOCIATION3                  IAPITYPE.ID_TYPE,
         ASSOCIATION3_DESCR            IAPITYPE.DESCRIPTION_TYPE
      );

      TYPE LTOLDDATAASSOCIATION_TYPE IS TABLE OF OLDDATAASSOCIATIONREC_TYPE
         INDEX BY BINARY_INTEGER;

      LTOLDDATAASSOCIATION          LTOLDDATAASSOCIATION_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQSECTIONDATA%ISOPEN )
      THEN
         CLOSE AQSECTIONDATA;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECTBASE
                   || ' FROM '
                   || LSFROMBASE
                   || ' WHERE i.user_id = NULL';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQSECTIONDATA FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=    'SELECT '
               || LSSELECTBASE
               || ' FROM '
               || LSFROMBASE
               || ' WHERE i.user_id = :userid ';
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQSECTIONDATA%ISOPEN )
      THEN
         CLOSE AQSECTIONDATA;
      END IF;

      
      OPEN AQSECTIONDATA FOR LSSQL USING ASUSERID;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'About to fetch data',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LTSECTIONDATA.DELETE;

      LOOP
         LRSECTIONDAT := NULL;

         FETCH AQSECTIONDATA
          INTO LRSECTIONDAT;

         EXIT WHEN AQSECTIONDATA%NOTFOUND;
         LRSECTIONDATA.ROWINDEX := LRSECTIONDAT.ROWINDEX;
         LRSECTIONDATA.USERID := LRSECTIONDAT.USERID;
         LRSECTIONDATA.PARTNO := LRSECTIONDAT.PARTNO;
         LRSECTIONDATA.REVISION := LRSECTIONDAT.REVISION;
         LRSECTIONDATA.TEXT := LRSECTIONDAT.TEXT;
         LRSECTIONDATA.INTERNATIONAL := LRSECTIONDAT.INTERNATIONAL;
         LRSECTIONDATA.FIELDTYPE := LRSECTIONDAT.FIELDTYPE;
         LRSECTIONDATA.OLDVALUECHAR := LRSECTIONDAT.OLDVALUECHAR;
         LRSECTIONDATA.NEWVALUECHAR := LRSECTIONDAT.NEWVALUECHAR;
         LRSECTIONDATA.OLDVALUENUM := LRSECTIONDAT.OLDVALUENUM;
         LRSECTIONDATA.NEWVALUENUM := LRSECTIONDAT.NEWVALUENUM;
         LRSECTIONDATA.OLDVALUEDATE := LRSECTIONDAT.OLDVALUEDATE;
         LRSECTIONDATA.NEWVALUEDATE := LRSECTIONDAT.NEWVALUEDATE;
         LRSECTIONDATA.OLDVALUETMID := LRSECTIONDAT.OLDVALUETMID;
         LRSECTIONDATA.NEWVALUETMID := LRSECTIONDAT.NEWVALUETMID;
         LRSECTIONDATA.OLDVALUETM := LRSECTIONDAT.OLDVALUETM;
         LRSECTIONDATA.OLDVALUEASSID := LRSECTIONDAT.OLDVALUEASSID;
         LRSECTIONDATA.NEWVALUEASSID := LRSECTIONDAT.NEWVALUEASSID;
         LRSECTIONDATA.OLDVALUEASS := LRSECTIONDAT.OLDVALUEASS;
         LTSECTIONDATA.EXTEND;
         LTSECTIONDATA( LTSECTIONDATA.COUNT ) := LRSECTIONDATA;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Number of items fetched: <'
                           || LTSECTIONDATA.COUNT
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      CASE ANFIELDTYPE
         WHEN 1   
         THEN
            LSTYPE := 'DEFAULT';
         WHEN 4   
         THEN
            LSTYPE := 'DEFAULT';
         WHEN 5   
         THEN
            LSTYPE := 'ASSOCIATION';
         WHEN 6   
         THEN
            LSTYPE := 'TESTMETHOD';
         WHEN 7   
         THEN
            LSTYPE := 'ASSOCIATION';
         WHEN 8   
         THEN
            LSTYPE := 'ASSOCIATION';
         ELSE   
            LSTYPE := 'DEFAULT';
      END CASE;

      
      IF ( LQOLDDATA%ISOPEN )
      THEN
         CLOSE LQOLDDATA;
      END IF;

      
      CASE LSTYPE
         WHEN 'ASSOCIATION'
         THEN
            LSOLDDATA := 'SELECT s.part_no, s.revision, ';
            LSOLDDATA :=    LSOLDDATA
                         || ' s.characteristic, f_chh_descr(1, s.characteristic, s.characteristic_rev), ';
            LSOLDDATA :=    LSOLDDATA
                         || ' s.association, f_ash_descr(1, s.association, s.association_rev), ';
            LSOLDDATA :=    LSOLDDATA
                         || ' s.ch_2, f_chh_descr(1, s.ch_2, s.ch_rev_2), s.as_2, f_ash_descr(1, s.as_2, s.as_rev_2), ';
            LSOLDDATA :=    LSOLDDATA
                         || ' s.ch_3, f_chh_descr(1, s.ch_3, s.ch_rev_3), s.as_3, f_ash_descr(1, s.as_3, s.as_rev_3) ';
            LSOLDDATA :=    LSOLDDATA
                         || ' FROM specification_prop s, itshq i ';
            LSOLDDATA :=    LSOLDDATA
                         || ' WHERE s.part_no = i.part_no ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND s.revision = i.revision ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND i.user_id = :userid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND s.section_id = :sectionid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND s.sub_section_id = :subsectionid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND s.property_group = :propertygroupid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND s.property = :propertyid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND s.attribute = :attributeid ';
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 LSOLDDATA,
                                 IAPICONSTANT.INFOLEVEL_3 );
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    ASUSERID
                                 || '/'
                                 || ANSECTIONID
                                 || '/'
                                 || ANSUBSECTIONID
                                 || '/'
                                 || ANPROPERTYGROUPID
                                 || '/'
                                 || ANPROPERTYID
                                 || '/'
                                 || ANATTRIBUTEID,
                                 IAPICONSTANT.INFOLEVEL_3 );

            OPEN LQOLDDATA FOR LSOLDDATA USING ASUSERID,
            ANSECTIONID,
            ANSUBSECTIONID,
            ANPROPERTYGROUPID,
            ANPROPERTYID,
            ANATTRIBUTEID;

            FETCH LQOLDDATA
            BULK COLLECT INTO LTOLDDATAASSOCIATION;

            CLOSE LQOLDDATA;
         WHEN 'TESTMETHOD'
         THEN
            LSOLDDATA := 'SELECT s.part_no, s.revision, s.test_method, f_tmh_descr(1, s.test_method, s.test_method_rev ) ';
            LSOLDDATA :=    LSOLDDATA
                         || ' FROM specdata s, itshq i ';
            LSOLDDATA :=    LSOLDDATA
                         || ' WHERE s.part_no = i.part_no ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND s.revision = i.revision ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND i.user_id = :userid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND s.section_id = :sectionid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND s.sub_section_id = :subsectionid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND s.property_group = :propertygroupid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND s.property = :propertyid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND s.attribute = :attributeid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND s.test_method <> -1 ';
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 LSOLDDATA,
                                 IAPICONSTANT.INFOLEVEL_3 );
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    ASUSERID
                                 || '/'
                                 || ANSECTIONID
                                 || '/'
                                 || ANSUBSECTIONID
                                 || '/'
                                 || ANPROPERTYGROUPID
                                 || '/'
                                 || ANPROPERTYID
                                 || '/'
                                 || ANATTRIBUTEID,
                                 IAPICONSTANT.INFOLEVEL_3 );

            OPEN LQOLDDATA FOR LSOLDDATA USING ASUSERID,
            ANSECTIONID,
            ANSUBSECTIONID,
            ANPROPERTYGROUPID,
            ANPROPERTYID,
            ANATTRIBUTEID;

            FETCH LQOLDDATA
            BULK COLLECT INTO LTOLDDATATESTMETHOD;

            CLOSE LQOLDDATA;
         ELSE   
            LSOLDDATA := 'SELECT s.part_no, s.revision, s.value, s.value_s, s.value_dt ';
            LSOLDDATA :=    LSOLDDATA
                         || ' FROM specdata s, itshq i ';
            LSOLDDATA :=    LSOLDDATA
                         || ' WHERE s.part_no = i.part_no ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND s.revision = i.revision ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND i.user_id = :userid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND s.section_id = :sectionid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND s.sub_section_id = :subsectionid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND s.property_group = :propertygroupid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND s.property = :propertyid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND s.attribute = :attributeid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND s.header_id = :headerid ';
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 LSOLDDATA,
                                 IAPICONSTANT.INFOLEVEL_3 );
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    ASUSERID
                                 || '/'
                                 || ANSECTIONID
                                 || '/'
                                 || ANSUBSECTIONID
                                 || '/'
                                 || ANPROPERTYGROUPID
                                 || '/'
                                 || ANPROPERTYID
                                 || '/'
                                 || ANATTRIBUTEID
                                 || '/'
                                 || ANHEADERID,
                                 IAPICONSTANT.INFOLEVEL_3 );

            OPEN LQOLDDATA FOR LSOLDDATA USING ASUSERID,
            ANSECTIONID,
            ANSUBSECTIONID,
            ANPROPERTYGROUPID,
            ANPROPERTYID,
            ANATTRIBUTEID,
            ANHEADERID;

            FETCH LQOLDDATA
            BULK COLLECT INTO LTOLDDATADEFAULT;

            CLOSE LQOLDDATA;
      END CASE;

      
      
      IF ( LTSECTIONDATA.COUNT > 0 )
      THEN
         FOR LNCOUNT IN LTSECTIONDATA.FIRST .. LTSECTIONDATA.LAST
         LOOP
            
            LSPARTNO := LTSECTIONDATA( LNCOUNT ).PARTNO;
            LNREVISION := LTSECTIONDATA( LNCOUNT ).REVISION;

            CASE LSTYPE
               WHEN 'ASSOCIATION'
               THEN
                  
                  IF ( LTOLDDATAASSOCIATION.COUNT > 0 )
                  THEN
                     FOR LNCOUNTOLD IN LTOLDDATAASSOCIATION.FIRST .. LTOLDDATAASSOCIATION.LAST
                     LOOP
                        IF (      ( LTOLDDATAASSOCIATION( LNCOUNTOLD ).PARTNO = LSPARTNO )
                             AND ( LTOLDDATAASSOCIATION( LNCOUNTOLD ).REVISION = LNREVISION ) )
                        THEN
                           IAPIGENERAL.LOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                   'Part/revision <'
                                                || LSPARTNO
                                                || ' / '
                                                || LNREVISION
                                                || '> found',
                                                IAPICONSTANT.INFOLEVEL_3 );
                           
                           
                           
                           
                           













































                           

                           
                           IF (ANFIELDTYPE = 5)
                           THEN
                               IAPIGENERAL.LOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                       'ASSOCIATION1 <'
                                                    || LTOLDDATAASSOCIATION( LNCOUNTOLD ).ASSOCIATION1
                                                    || '> with CHARACTERISTIC1 <'
                                                    || LTOLDDATAASSOCIATION( LNCOUNTOLD ).CHARACTERISTIC1
                                                    || ' > description < '
                                                    || LTOLDDATAASSOCIATION( LNCOUNTOLD ).CHARACTERISTIC1_DESCR
                                                    || '> found',
                                                    IAPICONSTANT.INFOLEVEL_3 );
                               
                               LTSECTIONDATA( LNCOUNT ).OLDVALUEASSID := LTOLDDATAASSOCIATION( LNCOUNTOLD ).ASSOCIATION1;
                               LTSECTIONDATA( LNCOUNT ).OLDVALUEASS := LTOLDDATAASSOCIATION( LNCOUNTOLD ).CHARACTERISTIC1_DESCR;
                           ELSE
                               
                               IF (ANFIELDTYPE = 7)
                               THEN
                                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                          'ASSOCIATION2 <'
                                                       || LTOLDDATAASSOCIATION( LNCOUNTOLD ).ASSOCIATION2
                                                       || '> with CHARACTERISTIC2 <'
                                                       || LTOLDDATAASSOCIATION( LNCOUNTOLD ).CHARACTERISTIC2
                                                       || ' > description < '
                                                       || LTOLDDATAASSOCIATION( LNCOUNTOLD ).CHARACTERISTIC2_DESCR
                                                       || '> found',
                                                       IAPICONSTANT.INFOLEVEL_3 );
                                  LTSECTIONDATA( LNCOUNT ).OLDVALUEASSID := LTOLDDATAASSOCIATION( LNCOUNTOLD ).ASSOCIATION2;
                                  LTSECTIONDATA( LNCOUNT ).OLDVALUEASS := LTOLDDATAASSOCIATION( LNCOUNTOLD ).CHARACTERISTIC2_DESCR;
                               
                               
                               ELSE
                                    IAPIGENERAL.LOGINFO( GSSOURCE,
                                                          LSMETHOD,
                                                             'ASSOCIATION3 <'
                                                          || LTOLDDATAASSOCIATION( LNCOUNTOLD ).ASSOCIATION3
                                                          || '> with CHARACTERISTIC3 <'
                                                          || LTOLDDATAASSOCIATION( LNCOUNTOLD ).CHARACTERISTIC3
                                                          || ' > description < '
                                                          || LTOLDDATAASSOCIATION( LNCOUNTOLD ).CHARACTERISTIC3_DESCR
                                                          || '> found',
                                                          IAPICONSTANT.INFOLEVEL_3 );
                                     LTSECTIONDATA( LNCOUNT ).OLDVALUEASSID := LTOLDDATAASSOCIATION( LNCOUNTOLD ).ASSOCIATION3;
                                     LTSECTIONDATA( LNCOUNT ).OLDVALUEASS := LTOLDDATAASSOCIATION( LNCOUNTOLD ).CHARACTERISTIC3_DESCR;
                               END IF;
                           END IF;
                           
                        END IF;
                     END LOOP;
                  END IF;
              WHEN 'TESTMETHOD'
               THEN
                  
                  IF ( LTOLDDATATESTMETHOD.COUNT > 0 )
                  THEN
                     FOR LNCOUNTOLD IN LTOLDDATATESTMETHOD.FIRST .. LTOLDDATATESTMETHOD.LAST
                     LOOP
                        IF (      ( LTOLDDATATESTMETHOD( LNCOUNTOLD ).PARTNO = LSPARTNO )
                             AND ( LTOLDDATATESTMETHOD( LNCOUNTOLD ).REVISION = LNREVISION ) )
                        THEN
                           IAPIGENERAL.LOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                   'Part/revision <'
                                                || LSPARTNO
                                                || ' / '
                                                || LNREVISION
                                                || '> found, tm = '
                                                || LTOLDDATATESTMETHOD( LNCOUNTOLD ).TESTMETHOD,
                                                IAPICONSTANT.INFOLEVEL_3 );
                           LTSECTIONDATA( LNCOUNT ).OLDVALUETMID := LTOLDDATATESTMETHOD( LNCOUNTOLD ).TESTMETHODID;
                           LTSECTIONDATA( LNCOUNT ).OLDVALUETM := LTOLDDATATESTMETHOD( LNCOUNTOLD ).TESTMETHOD;
                        END IF;
                     END LOOP;
                  END IF;
               ELSE
                  
                  IF ( LTOLDDATADEFAULT.COUNT > 0 )
                  THEN
                     FOR LNCOUNTOLD IN LTOLDDATADEFAULT.FIRST .. LTOLDDATADEFAULT.LAST
                     LOOP
                        IF (      ( LTOLDDATADEFAULT( LNCOUNTOLD ).PARTNO = LSPARTNO )
                             AND ( LTOLDDATADEFAULT( LNCOUNTOLD ).REVISION = LNREVISION ) )
                        THEN
                           IAPIGENERAL.LOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                   'Part/revision <'
                                                || LSPARTNO
                                                || ' / '
                                                || LNREVISION
                                                || '> found',
                                                IAPICONSTANT.INFOLEVEL_3 );
                           LTSECTIONDATA( LNCOUNT ).OLDVALUENUM := LTOLDDATADEFAULT( LNCOUNTOLD ).VALUE;
                           LTSECTIONDATA( LNCOUNT ).OLDVALUECHAR := LTOLDDATADEFAULT( LNCOUNTOLD ).VALUE_S;
                           LTSECTIONDATA( LNCOUNT ).OLDVALUEDATE := LTOLDDATADEFAULT( LNCOUNTOLD ).VALUE_DT;
                        END IF;
                     END LOOP;
                  END IF;
            END CASE;
         END LOOP;
      END IF;

      
      IF ( AQSECTIONDATA%ISOPEN )
      THEN
         CLOSE AQSECTIONDATA;
      END IF;

      OPEN AQSECTIONDATA FOR
         SELECT *
           FROM TABLE( CAST( LTSECTIONDATA AS MOPRPVSECTIONDATATABLE_TYPE ) );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETSECTIONDATA;

   
   FUNCTION GETUSEDPLANTINBOM(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASBOMITEM                  IN       IAPITYPE.PARTNO_TYPE,
      ASPLANTNOLIKE              IN       IAPITYPE.DESCRIPTION_TYPE DEFAULT NULL,
      AQUSEDPLANTINBOM           OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUsedPlantInBom';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
                                                  :=    'p.plant '
                                                     || IAPICONSTANTCOLUMN.PLANTNOCOL
                                                     || ', p.description '
                                                     || IAPICONSTANTCOLUMN.PLANTCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'bom_item bi, plant p ';
   BEGIN
      
      
      
      
      
      IF ( AQUSEDPLANTINBOM%ISOPEN )
      THEN
         CLOSE AQUSEDPLANTINBOM;
      END IF;

      LSSQLNULL :=    'SELECT DISTINCT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE bi.plant = p.plant AND p.plant = NULL';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQUSEDPLANTINBOM FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=
            'SELECT DISTINCT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE bi.part_no = :partno '
         || '   AND bi.revision = :revision '
         || '   AND bi.component_part = :bomitem '
         || '   AND bi.plant = p.plant ';

      IF NOT( ASPLANTNOLIKE IS NULL )
      THEN
         LSSQL :=    LSSQL
                  || ' AND p.plant LIKE :plantnolike ';
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY '
               || IAPICONSTANTCOLUMN.PLANTNOCOL;
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQUSEDPLANTINBOM%ISOPEN )
      THEN
         CLOSE AQUSEDPLANTINBOM;
      END IF;

      
      IF NOT( ASPLANTNOLIKE IS NULL )
      THEN
         OPEN AQUSEDPLANTINBOM FOR LSSQL USING ASPARTNO,
         ANREVISION,
         ASBOMITEM,
            '%'
         || ASPLANTNOLIKE
         || '%';
      ELSE
         OPEN AQUSEDPLANTINBOM FOR LSSQL USING ASPARTNO,
         ANREVISION,
         ASBOMITEM;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUSEDPLANTINBOM;

   
   FUNCTION GETUSEDPLANTINBOMMOP(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ASBOMITEM                  IN       IAPITYPE.PARTNO_TYPE,
      AQUSEDPLANTINBOMMOP        OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUsedPlantInBom';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'bi.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', bi.revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', bi.plant '
            || IAPICONSTANTCOLUMN.PLANTNOCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'bom_item bi ';
   BEGIN
      
      
      
      
      
      IF ( AQUSEDPLANTINBOMMOP%ISOPEN )
      THEN
         CLOSE AQUSEDPLANTINBOMMOP;
      END IF;

      LSSQLNULL :=    'SELECT DISTINCT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE bi.part_no = NULL';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQUSEDPLANTINBOMMOP FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=
            'SELECT DISTINCT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE (bi.part_no, bi.revision) IN (SELECT DISTINCT i.part_no, i.revision FROM itshq i WHERE i.user_id = :userid) '
         || '   AND bi.component_part = :bomitem ';
      LSSQL :=
                 LSSQL
              || ' ORDER BY '
              || IAPICONSTANTCOLUMN.PARTNOCOL
              || ', '
              || IAPICONSTANTCOLUMN.REVISIONCOL
              || ', '
              || IAPICONSTANTCOLUMN.PLANTNOCOL;
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQUSEDPLANTINBOMMOP%ISOPEN )
      THEN
         CLOSE AQUSEDPLANTINBOMMOP;
      END IF;

      
      OPEN AQUSEDPLANTINBOMMOP FOR LSSQL USING ASUSERID,
      ASBOMITEM;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUSEDPLANTINBOMMOP;

   
   FUNCTION STOPJOB
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'StopJob';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LIJOB                         BINARY_INTEGER;
      LBJOBSTOPPED                  BOOLEAN;

      CURSOR LQJOB(
         ASJOBNAME                  IN       VARCHAR2 )
      IS
         SELECT JOB
           FROM DBA_JOBS
          WHERE UPPER( WHAT ) LIKE UPPER( ASJOBNAME );

      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN LQJOB(    '%'
                  || PSMOPJOB
                  || '%' );

      LBJOBSTOPPED := FALSE;

      LOOP
         FETCH LQJOB
          INTO LIJOB;

         EXIT WHEN LQJOB%NOTFOUND;
         DBMS_ALERT.SIGNAL( PSMOPJOBNAME,
                            'Q_STOP' );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Signal to stop processing is send',
                              IAPICONSTANT.INFOLEVEL_3 );
         LBJOBSTOPPED := TRUE;
      END LOOP;

      CLOSE LQJOB;

      IF ( LBJOBSTOPPED = FALSE )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_JOBNOTFOUND ) );
      END IF;

      COMMIT;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IF ( LQJOB%ISOPEN )
         THEN
            CLOSE LQJOB;
         END IF;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END STOPJOB;

   
   FUNCTION STARTJOB
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'StartJob';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LIJOB                         BINARY_INTEGER;
      LNISMOPRUNNING                IAPITYPE.BOOLEAN_TYPE;
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := ISMOPRUNNING( LNISMOPRUNNING );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      IF ( LNISMOPRUNNING = 1 )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              'Mop job already started' );
      ELSE
         DBMS_JOB.SUBMIT( LIJOB,
                             PSMOPJOB
                          || ';',
                          SYSDATE,
                          '' );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'Job <'
                              || LIJOB
                              || '> started',
                              IAPICONSTANT.INFOLEVEL_3 );
      END IF;

      COMMIT;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         ROLLBACK;
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END STARTJOB;

   
   FUNCTION ISMOPRUNNING(
      ANISRUNNING                OUT      IAPITYPE.BOOLEAN_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'IsMopRunning';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNJOBS                        NUMBER;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT COUNT( JOB )
        INTO LNJOBS
        FROM DBA_JOBS
       WHERE UPPER( WHAT ) LIKE UPPER(    '%'
                                       || PSMOPJOB
                                       || '%' );

      IF LNJOBS > 0
      THEN
         ANISRUNNING := 1;
      ELSE
         ANISRUNNING := 0;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ISMOPRUNNING;

   
   FUNCTION GETPARTSWITHBOM(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      AQLIST                     OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPartsWithBom';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'i.user_id '
            || IAPICONSTANTCOLUMN.USERIDCOL
            || ', i.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', i.revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', i.user_intl '
            || IAPICONSTANTCOLUMN.INTERNATIONALCOL
            || ', i.text '
            || IAPICONSTANTCOLUMN.TEXTCOL
            || ', f_sh_descr(1, i.part_no, i.revision) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL
            || ', s.status '
            || IAPICONSTANTCOLUMN.STATUSIDCOL
            || ', f_ss_descr(s.status) '
            || IAPICONSTANTCOLUMN.STATUSCOL
            || ', f_get_access(i.part_no, i.revision, i.user_id, i.user_intl) '
            || IAPICONSTANTCOLUMN.SPECIFICATIONACCESSCOL
            || ', i.plant '
            || IAPICONSTANTCOLUMN.PLANTNOCOL
            || ', i.new_value_num '
            || IAPICONSTANTCOLUMN.NEWVALUENUMCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'bom_header bh, specification_header s, itshq i ';
   BEGIN
      
      
      
      
      
      IF ( AQLIST%ISOPEN )
      THEN
         CLOSE AQLIST;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE user_id = NULL';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQLIST FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=
            'SELECT DISTINCT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE i.user_id=:id '
         || '   AND i.part_no = bh.part_no AND i.revision = bh.revision '
         || '   AND i.part_no = s.part_no AND i.revision = s.revision ';
      LSSQL :=    LSSQL
               || ' ORDER BY '
               || IAPICONSTANTCOLUMN.PARTNOCOL
               || ','
               || IAPICONSTANTCOLUMN.REVISIONCOL;
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQLIST%ISOPEN )
      THEN
         CLOSE AQLIST;
      END IF;

      
      OPEN AQLIST FOR LSSQL USING ASUSERID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPARTSWITHBOM;

   
   FUNCTION GETAVAILABLEPLANTINBOM(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASBOMITEM                  IN       IAPITYPE.PARTNO_TYPE,
      ASPLANTNOLIKE              IN       IAPITYPE.DESCRIPTION_TYPE DEFAULT NULL,
      AQAVAILABLEPLANTINBOM      OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetAvailablePlantInBom';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
                                                  :=    'p.plant '
                                                     || IAPICONSTANTCOLUMN.PLANTNOCOL
                                                     || ', p.description '
                                                     || IAPICONSTANTCOLUMN.PLANTCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'bom_header bh, plant p, part_plant pp ';
   BEGIN
      
      
      
      
      
      IF ( AQAVAILABLEPLANTINBOM%ISOPEN )
      THEN
         CLOSE AQAVAILABLEPLANTINBOM;
      END IF;

      LSSQLNULL :=    'SELECT DISTINCT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE bh.plant = p.plant AND p.plant = pp.plant AND pp.plant = NULL';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQAVAILABLEPLANTINBOM FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
       
      
      LNRETVAL := IAPIPART.EXISTID( ASBOMITEM );

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
      
      LSSQL :=
            'SELECT DISTINCT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE bh.part_no = :partno '
         || '   AND bh.revision = :revision '
         || '   AND p.plant = bh.plant '
         || '   AND pp.part_no = :bomitem '
         || '   AND bh.plant = pp.plant '
         || '   AND pp.obsolete = 0';

      IF NOT( ASPLANTNOLIKE IS NULL )
      THEN
         LSSQL :=    LSSQL
                  || ' AND p.plant LIKE :plantnolike ';
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY '
               || IAPICONSTANTCOLUMN.PLANTNOCOL;
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQAVAILABLEPLANTINBOM%ISOPEN )
      THEN
         CLOSE AQAVAILABLEPLANTINBOM;
      END IF;

      
      IF NOT( ASPLANTNOLIKE IS NULL )
      THEN
         OPEN AQAVAILABLEPLANTINBOM FOR LSSQL USING ASPARTNO,
         ANREVISION,
         ASBOMITEM,
            '%'
         || ASPLANTNOLIKE
         || '%';
      ELSE
         OPEN AQAVAILABLEPLANTINBOM FOR LSSQL USING ASPARTNO,
         ANREVISION,
         ASBOMITEM;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETAVAILABLEPLANTINBOM;

   
   FUNCTION GETAVAILABLEPLANTINBOMMOP(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ASBOMITEM                  IN       IAPITYPE.PARTNO_TYPE,
      AQAVAILABLEPLANTINBOMMOP   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetAvailablePlantInBomMop';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'bh.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', bh.revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', bh.plant '
            || IAPICONSTANTCOLUMN.PLANTNOCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'bom_item bh, part_plant pp ';
   BEGIN
      
      
      
      
      
      IF ( AQAVAILABLEPLANTINBOMMOP%ISOPEN )
      THEN
         CLOSE AQAVAILABLEPLANTINBOMMOP;
      END IF;

      LSSQLNULL :=    'SELECT DISTINCT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE bh.part_no = NULL AND bh.plant = pp.plant ';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQAVAILABLEPLANTINBOMMOP FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
       
      
      LNRETVAL := IAPIPART.EXISTID( ASBOMITEM );

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
      
      LSSQL :=
            'SELECT DISTINCT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE (bh.part_no, bh.revision) IN (SELECT DISTINCT i.part_no, i.revision FROM itshq i WHERE i.user_id = :userid) '
         || '   AND pp.part_no = :bomitem '
         || '   AND bh.plant = pp.plant ';
      LSSQL :=
                 LSSQL
              || ' ORDER BY '
              || IAPICONSTANTCOLUMN.PARTNOCOL
              || ', '
              || IAPICONSTANTCOLUMN.REVISIONCOL
              || ', '
              || IAPICONSTANTCOLUMN.PLANTNOCOL;
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQAVAILABLEPLANTINBOMMOP%ISOPEN )
      THEN
         CLOSE AQAVAILABLEPLANTINBOMMOP;
      END IF;

      
      OPEN AQAVAILABLEPLANTINBOMMOP FOR LSSQL USING ASUSERID,
      ASBOMITEM;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETAVAILABLEPLANTINBOMMOP;

   
   FUNCTION GETPROCESSDATA(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ANFIELDTYPE                IN       IAPITYPE.NUMVAL_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      ANSTAGEID                  IN       IAPITYPE.STAGEID_TYPE,
      ANPROPERTYID               IN       IAPITYPE.ID_TYPE,
      ANATTRIBUTEID              IN       IAPITYPE.ID_TYPE,
      ANHEADERID                 IN       IAPITYPE.ID_TYPE,
      AQPROCESSDATA              OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetProcessData';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECTBASE                  VARCHAR2( 4096 )
         :=    'i.user_id '
            || IAPICONSTANTCOLUMN.USERIDCOL
            || ', i.part_no '
            || IAPICONSTANTCOLUMN.PARTNOCOL
            || ', i.revision '
            || IAPICONSTANTCOLUMN.REVISIONCOL
            || ', i.text '
            || IAPICONSTANTCOLUMN.TEXTCOL
            || ', To_NUMBER(i.user_intl) '
            || IAPICONSTANTCOLUMN.INTERNATIONALCOL
            || ', ''X'' '
            || IAPICONSTANTCOLUMN.FIELDTYPECOL
            || ', i.new_value_char '
            || IAPICONSTANTCOLUMN.OLDVALUECHARCOL
            || ', i.new_value_char '
            || IAPICONSTANTCOLUMN.NEWVALUECHARCOL
            || ', i.new_value_num '
            || IAPICONSTANTCOLUMN.OLDVALUENUMCOL
            || ', i.new_value_num '
            || IAPICONSTANTCOLUMN.NEWVALUENUMCOL
            || ', i.new_value_date '
            || IAPICONSTANTCOLUMN.OLDVALUEDATECOL
            || ', i.new_value_date '
            || IAPICONSTANTCOLUMN.NEWVALUEDATECOL
            || ', i.new_value_num '
            || IAPICONSTANTCOLUMN.OLDVALUETMIDCOL
            || ', i.new_value_num '
            || IAPICONSTANTCOLUMN.NEWVALUETMIDCOL
            || ', null '
            || IAPICONSTANTCOLUMN.OLDVALUETMCOL   
            || ', i.new_value_num '
            || IAPICONSTANTCOLUMN.OLDVALUEASSIDCOL
            || ', i.new_value_num '
            || IAPICONSTANTCOLUMN.NEWVALUEASSIDCOL
            || ', null '
            || IAPICONSTANTCOLUMN.OLDVALUEASSCOL;   
      LSFROMBASE                    IAPITYPE.STRING_TYPE := 'itshq i ';
      LRPROCESSDAT                  IAPITYPE.MOPRPVSECTIONDATAREC_TYPE;
      LRPROCESSDATA                 MOPRPVSECTIONDATARECORD_TYPE
         := MOPRPVSECTIONDATARECORD_TYPE( NULL,
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
      LTPROCESSDATA                 MOPRPVSECTIONDATATABLE_TYPE := MOPRPVSECTIONDATATABLE_TYPE( );
      LSTYPE                        VARCHAR2( 16 );
      LSOLDDATA                     VARCHAR2( 4096 );
      LQOLDDATA                     IAPITYPE.REF_TYPE;
      LNCOUNT                       NUMBER;
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LNCOUNTOLD                    NUMBER;

      TYPE OLDDATADEFAULTREC_TYPE IS RECORD(
         PARTNO                        IAPITYPE.PARTNO_TYPE,
         REVISION                      IAPITYPE.REVISION_TYPE,
         VALUE                         IAPITYPE.FLOAT_TYPE,
         VALUE_S                       IAPITYPE.STRING_TYPE,
         VALUE_DT                      IAPITYPE.DATE_TYPE
      );

      TYPE LTOLDDATADEFAULT_TYPE IS TABLE OF OLDDATADEFAULTREC_TYPE
         INDEX BY BINARY_INTEGER;

      LTOLDDATADEFAULT              LTOLDDATADEFAULT_TYPE;

      TYPE OLDDATATESTMETHODREC_TYPE IS RECORD(
         PARTNO                        IAPITYPE.PARTNO_TYPE,
         REVISION                      IAPITYPE.REVISION_TYPE,
         TESTMETHODID                  IAPITYPE.ID_TYPE,
         TESTMETHOD                    IAPITYPE.DESCRIPTION_TYPE
      );

      TYPE LTOLDDATATESTMETHOD_TYPE IS TABLE OF OLDDATATESTMETHODREC_TYPE
         INDEX BY BINARY_INTEGER;

      LTOLDDATATESTMETHOD           LTOLDDATATESTMETHOD_TYPE;

      TYPE OLDDATAASSOCIATIONREC_TYPE IS RECORD(
         PARTNO                        IAPITYPE.PARTNO_TYPE,
         REVISION                      IAPITYPE.REVISION_TYPE,
         CHARACTERISTIC1               IAPITYPE.ID_TYPE,
         ASSOCIATION1                  IAPITYPE.ID_TYPE,
         CHARACTERISTIC2               IAPITYPE.ID_TYPE,
         ASSOCIATION2                  IAPITYPE.ID_TYPE,
         CHARACTERISTIC3               IAPITYPE.ID_TYPE,
         ASSOCIATION3                  IAPITYPE.ID_TYPE
      );

      TYPE LTOLDDATAASSOCIATION_TYPE IS TABLE OF OLDDATAASSOCIATIONREC_TYPE
         INDEX BY BINARY_INTEGER;

      LTOLDDATAASSOCIATION          LTOLDDATAASSOCIATION_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQPROCESSDATA%ISOPEN )
      THEN
         CLOSE AQPROCESSDATA;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECTBASE
                   || ' FROM '
                   || LSFROMBASE
                   || ' WHERE i.user_id = NULL';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQPROCESSDATA FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=    'SELECT '
               || LSSELECTBASE
               || ' FROM '
               || LSFROMBASE
               || ' WHERE i.user_id = :userid ';
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQPROCESSDATA%ISOPEN )
      THEN
         CLOSE AQPROCESSDATA;
      END IF;

      
      OPEN AQPROCESSDATA FOR LSSQL USING ASUSERID;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'About to fetch data',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LTPROCESSDATA.DELETE;

      LOOP
         LRPROCESSDAT := NULL;

         FETCH AQPROCESSDATA
          INTO LRPROCESSDAT;

         EXIT WHEN AQPROCESSDATA%NOTFOUND;
         LRPROCESSDATA.ROWINDEX := LRPROCESSDAT.ROWINDEX;
         LRPROCESSDATA.USERID := LRPROCESSDAT.USERID;
         LRPROCESSDATA.PARTNO := LRPROCESSDAT.PARTNO;
         LRPROCESSDATA.REVISION := LRPROCESSDAT.REVISION;
         LRPROCESSDATA.TEXT := LRPROCESSDAT.TEXT;
         LRPROCESSDATA.INTERNATIONAL := LRPROCESSDAT.INTERNATIONAL;
         LRPROCESSDATA.FIELDTYPE := LRPROCESSDAT.FIELDTYPE;
         LRPROCESSDATA.OLDVALUECHAR := LRPROCESSDAT.OLDVALUECHAR;
         LRPROCESSDATA.NEWVALUECHAR := LRPROCESSDAT.NEWVALUECHAR;
         LRPROCESSDATA.OLDVALUENUM := LRPROCESSDAT.OLDVALUENUM;
         LRPROCESSDATA.NEWVALUENUM := LRPROCESSDAT.NEWVALUENUM;
         LRPROCESSDATA.OLDVALUEDATE := LRPROCESSDAT.OLDVALUEDATE;
         LRPROCESSDATA.NEWVALUEDATE := LRPROCESSDAT.NEWVALUEDATE;
         LRPROCESSDATA.OLDVALUETMID := LRPROCESSDAT.OLDVALUETMID;
         LRPROCESSDATA.NEWVALUETMID := LRPROCESSDAT.NEWVALUETMID;
         LRPROCESSDATA.OLDVALUETM := LRPROCESSDAT.OLDVALUETM;
         LRPROCESSDATA.OLDVALUEASSID := LRPROCESSDAT.OLDVALUEASSID;
         LRPROCESSDATA.NEWVALUEASSID := LRPROCESSDAT.NEWVALUEASSID;
         LRPROCESSDATA.OLDVALUEASS := LRPROCESSDAT.OLDVALUEASS;
         LTPROCESSDATA.EXTEND;
         LTPROCESSDATA( LTPROCESSDATA.COUNT ) := LRPROCESSDATA;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Number of items fetched: <'
                           || LTPROCESSDATA.COUNT
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      CASE ANFIELDTYPE
         WHEN 1   
         THEN
            LSTYPE := 'DEFAULT';
         WHEN 4   
         THEN
            LSTYPE := 'DEFAULT';
         WHEN 5   
         THEN
            LSTYPE := 'ASSOCIATION';
         WHEN 6   
         THEN
            LSTYPE := 'TESTMETHOD';
         WHEN 7   
         THEN
            LSTYPE := 'ASSOCIATION';
         WHEN 8   
         THEN
            LSTYPE := 'ASSOCIATION';
         ELSE   
            LSTYPE := 'DEFAULT';
      END CASE;

      
      IF ( LQOLDDATA%ISOPEN )
      THEN
         CLOSE LQOLDDATA;
      END IF;

      
      CASE LSTYPE
         WHEN 'ASSOCIATION'
         THEN
            LSOLDDATA := 'SELECT slp.part_no, slp.revision, slp.characteristic, slp.association ';
            LSOLDDATA :=    LSOLDDATA
                         || ' FROM specification_line_prop slp, itshq i ';
            LSOLDDATA :=    LSOLDDATA
                         || ' WHERE slp.part_no = i.part_no ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND slp.revision = i.revision ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND i.user_id = :userid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND slp.plant = :plantno ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND slp.line = :line ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND slp.configuration = :configuration ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND slp.stage = :stageid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND slp.property = :propertyid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND slp.attribute = :attributeid ';
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 LSOLDDATA,
                                 IAPICONSTANT.INFOLEVEL_3 );
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    ASUSERID
                                 || '/'
                                 || ASPLANTNO
                                 || '/'
                                 || ASLINE
                                 || '/'
                                 || ANCONFIGURATION
                                 || '/'
                                 || ANSTAGEID
                                 || '/'
                                 || ANPROPERTYID
                                 || '/'
                                 || ANATTRIBUTEID,
                                 IAPICONSTANT.INFOLEVEL_3 );

            OPEN LQOLDDATA FOR LSOLDDATA USING ASUSERID,
            ASPLANTNO,
            ASLINE,
            ANCONFIGURATION,
            ANSTAGEID,
            ANPROPERTYID,
            ANATTRIBUTEID;

            FETCH LQOLDDATA
            BULK COLLECT INTO LTOLDDATAASSOCIATION;

            CLOSE LQOLDDATA;
         WHEN 'TESTMETHOD'
         THEN
            LSOLDDATA := 'SELECT sp.part_no, sp.revision, sp.test_method, f_tmh_descr(1, sp.test_method, sp.test_method_rev ) ';
            LSOLDDATA :=    LSOLDDATA
                         || ' FROM specdata_process s, itshq i ';
            LSOLDDATA :=    LSOLDDATA
                         || ' WHERE sp.part_no = i.part_no ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND sp.revision = i.revision ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND i.user_id = :userid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND sp.plant = :plantno ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND sp.line = :line ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND sp.configuration = :configuration ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND sp.stage = :stageid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND sp.property = :propertyid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND sp.attribute = :attributeid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND sp.test_method <> -1 ';
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 LSOLDDATA,
                                 IAPICONSTANT.INFOLEVEL_3 );
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    ASUSERID
                                 || '/'
                                 || ASPLANTNO
                                 || '/'
                                 || ASLINE
                                 || '/'
                                 || ANCONFIGURATION
                                 || '/'
                                 || ANSTAGEID
                                 || '/'
                                 || ANPROPERTYID
                                 || '/'
                                 || ANATTRIBUTEID,
                                 IAPICONSTANT.INFOLEVEL_3 );

            OPEN LQOLDDATA FOR LSOLDDATA USING ASUSERID,
            ASPLANTNO,
            ASLINE,
            ANCONFIGURATION,
            ANSTAGEID,
            ANPROPERTYID,
            ANATTRIBUTEID;

            FETCH LQOLDDATA
            BULK COLLECT INTO LTOLDDATATESTMETHOD;

            CLOSE LQOLDDATA;
         ELSE   
            LSOLDDATA := 'SELECT sp.part_no, sp.revision, sp.value, sp.value_s, sp.value_dt ';
            LSOLDDATA :=    LSOLDDATA
                         || ' FROM specdata_process sp, itshq i ';
            LSOLDDATA :=    LSOLDDATA
                         || ' WHERE sp.part_no = i.part_no ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND sp.revision = i.revision ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND i.user_id = :userid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND sp.plant = :plantno ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND sp.line = :line ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND sp.configuration = :configuration ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND sp.stage = :stageid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND sp.property = :propertyid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND sp.attribute = :attributeid ';
            LSOLDDATA :=    LSOLDDATA
                         || ' AND sp.header_id = :headerid ';
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                 LSOLDDATA,
                                 IAPICONSTANT.INFOLEVEL_3 );
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    ASUSERID
                                 || '/'
                                 || ASPLANTNO
                                 || '/'
                                 || ASLINE
                                 || '/'
                                 || ANCONFIGURATION
                                 || '/'
                                 || ANSTAGEID
                                 || '/'
                                 || ANPROPERTYID
                                 || '/'
                                 || ANATTRIBUTEID,
                                 IAPICONSTANT.INFOLEVEL_3 );

            OPEN LQOLDDATA FOR LSOLDDATA USING ASUSERID,
            ASPLANTNO,
            ASLINE,
            ANCONFIGURATION,
            ANSTAGEID,
            ANPROPERTYID,
            ANATTRIBUTEID,
            ANHEADERID;

            FETCH LQOLDDATA
            BULK COLLECT INTO LTOLDDATADEFAULT;

            CLOSE LQOLDDATA;
      END CASE;

      
      
      IF ( LTPROCESSDATA.COUNT > 0 )
      THEN
         FOR LNCOUNT IN LTPROCESSDATA.FIRST .. LTPROCESSDATA.LAST
         LOOP
            
            LSPARTNO := LTPROCESSDATA( LNCOUNT ).PARTNO;
            LNREVISION := LTPROCESSDATA( LNCOUNT ).REVISION;

            CASE LSTYPE
               WHEN 'ASSOCIATION'
               THEN
                  
                  IF ( LTOLDDATAASSOCIATION.COUNT > 0 )
                  THEN
                     FOR LNCOUNTOLD IN LTOLDDATAASSOCIATION.FIRST .. LTOLDDATAASSOCIATION.LAST
                     LOOP
                        IF (      ( LTOLDDATAASSOCIATION( LNCOUNTOLD ).PARTNO = LSPARTNO )
                             AND ( LTOLDDATAASSOCIATION( LNCOUNTOLD ).REVISION = LNREVISION ) )
                        THEN
                           IAPIGENERAL.LOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                   'Part/revision <'
                                                || LSPARTNO
                                                || ' / '
                                                || LNREVISION
                                                || '> found',
                                                IAPICONSTANT.INFOLEVEL_3 );
                           LTPROCESSDATA( LNCOUNT ).OLDVALUEASS := LTOLDDATAASSOCIATION( LNCOUNTOLD ).ASSOCIATION1;
                           LTPROCESSDATA( LNCOUNT ).OLDVALUEASS := LTOLDDATAASSOCIATION( LNCOUNTOLD ).ASSOCIATION2;
                           LTPROCESSDATA( LNCOUNT ).OLDVALUEASS := LTOLDDATAASSOCIATION( LNCOUNTOLD ).ASSOCIATION3;
                        END IF;
                     END LOOP;
                  END IF;
               WHEN 'TESTMETHOD'
               THEN
                  
                  IF ( LTOLDDATATESTMETHOD.COUNT > 0 )
                  THEN
                     FOR LNCOUNTOLD IN LTOLDDATATESTMETHOD.FIRST .. LTOLDDATATESTMETHOD.LAST
                     LOOP
                        IF (      ( LTOLDDATATESTMETHOD( LNCOUNTOLD ).PARTNO = LSPARTNO )
                             AND ( LTOLDDATATESTMETHOD( LNCOUNTOLD ).REVISION = LNREVISION ) )
                        THEN
                           IAPIGENERAL.LOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                   'Part/revision <'
                                                || LSPARTNO
                                                || ' / '
                                                || LNREVISION
                                                || '> found, tm = '
                                                || LTOLDDATATESTMETHOD( LNCOUNTOLD ).TESTMETHOD,
                                                IAPICONSTANT.INFOLEVEL_3 );
                           LTPROCESSDATA( LNCOUNT ).OLDVALUETMID := LTOLDDATATESTMETHOD( LNCOUNTOLD ).TESTMETHODID;
                           LTPROCESSDATA( LNCOUNT ).OLDVALUETM := LTOLDDATATESTMETHOD( LNCOUNTOLD ).TESTMETHOD;
                        END IF;
                     END LOOP;
                  END IF;
               ELSE
                  
                  IF ( LTOLDDATADEFAULT.COUNT > 0 )
                  THEN
                     FOR LNCOUNTOLD IN LTOLDDATADEFAULT.FIRST .. LTOLDDATADEFAULT.LAST
                     LOOP
                        IF (      ( LTOLDDATADEFAULT( LNCOUNTOLD ).PARTNO = LSPARTNO )
                             AND ( LTOLDDATADEFAULT( LNCOUNTOLD ).REVISION = LNREVISION ) )
                        THEN
                           IAPIGENERAL.LOGINFO( GSSOURCE,
                                                LSMETHOD,
                                                   'Part/revision <'
                                                || LSPARTNO
                                                || ' / '
                                                || LNREVISION
                                                || '> found',
                                                IAPICONSTANT.INFOLEVEL_3 );
                           LTPROCESSDATA( LNCOUNT ).OLDVALUENUM := LTOLDDATADEFAULT( LNCOUNTOLD ).VALUE;
                           LTPROCESSDATA( LNCOUNT ).OLDVALUECHAR := LTOLDDATADEFAULT( LNCOUNTOLD ).VALUE_S;
                           LTPROCESSDATA( LNCOUNT ).OLDVALUEDATE := LTOLDDATADEFAULT( LNCOUNTOLD ).VALUE_DT;
                        END IF;
                     END LOOP;
                  END IF;
            END CASE;
         END LOOP;
      END IF;

      
      IF ( AQPROCESSDATA%ISOPEN )
      THEN
         CLOSE AQPROCESSDATA;
      END IF;

      OPEN AQPROCESSDATA FOR
         SELECT *
           FROM TABLE( CAST( LTPROCESSDATA AS MOPRPVSECTIONDATATABLE_TYPE ) );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPROCESSDATA;

   
   FUNCTION GETPLANTLINECONFIGURATIONS(
      ASDESCRIPTIONLIKE          IN       IAPITYPE.DESCRIPTION_TYPE DEFAULT NULL,
      AQPLANTLINECONFIGURATIONS  OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPlantLineConfigurations';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'pl.plant '
            || IAPICONSTANTCOLUMN.PLANTNOCOL
            || ', pl.line '
            || IAPICONSTANTCOLUMN.LINECOL
            || ', pl.configuration '
            || IAPICONSTANTCOLUMN.CONFIGURATIONCOL
            || ', pl.description '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'process_line pl, plant p ';
   BEGIN
      
      
      
      
      
      IF ( AQPLANTLINECONFIGURATIONS%ISOPEN )
      THEN
         CLOSE AQPLANTLINECONFIGURATIONS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE pl.plant = NULL';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQPLANTLINECONFIGURATIONS FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=    'SELECT DISTINCT '
               || LSSELECT
               || ' FROM '
               || LSFROM;
      LSSQL :=
                LSSQL
             || ' ORDER BY '
             || IAPICONSTANTCOLUMN.PLANTNOCOL
             || ','
             || IAPICONSTANTCOLUMN.LINECOL
             || ','
             || IAPICONSTANTCOLUMN.CONFIGURATIONCOL;
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQPLANTLINECONFIGURATIONS%ISOPEN )
      THEN
         CLOSE AQPLANTLINECONFIGURATIONS;
      END IF;

      
      OPEN AQPLANTLINECONFIGURATIONS FOR LSSQL;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPLANTLINECONFIGURATIONS;

   
   FUNCTION GETSTAGEPROPERTIES(
      ANSTAGEID                  IN       IAPITYPE.STAGEID_TYPE,
      ASDESCRIPTIONLIKE          IN       IAPITYPE.DESCRIPTION_TYPE DEFAULT NULL,
      AQPROPERTIES               OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetStageProperties';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'sl.property '
            || IAPICONSTANTCOLUMN.PROPERTYIDCOL
            || ', sl.intl '
            || IAPICONSTANTCOLUMN.INTERNATIONALCOL
            || ', f_sph_descr(1, sl.property, 0) '
            || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'stage_list sl ';
   BEGIN
      
      
      
      
      
      IF ( AQPROPERTIES%ISOPEN )
      THEN
         CLOSE AQPROPERTIES;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE sl.stage = NULL';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQPROPERTIES FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=    'SELECT DISTINCT '
               || LSSELECT
               || ' FROM '
               || LSFROM
               || ' WHERE sl.stage = :stageid ';

      IF NOT( ASDESCRIPTIONLIKE IS NULL )
      THEN
         LSSQL :=    LSSQL
                  || ' AND f_sph_descr(1, sl.property, 0) LIKE ''%'
                  || ASDESCRIPTIONLIKE
                  || '%''';
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY '
               || IAPICONSTANTCOLUMN.DESCRIPTIONCOL;
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQPROPERTIES%ISOPEN )
      THEN
         CLOSE AQPROPERTIES;
      END IF;

      
      OPEN AQPROPERTIES FOR LSSQL USING ANSTAGEID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETSTAGEPROPERTIES;

   
   FUNCTION GETSTAGES(
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ASLINE                     IN       IAPITYPE.LINE_TYPE,
      ANCONFIGURATION            IN       IAPITYPE.CONFIGURATION_TYPE,
      ASDESCRIPTIONLIKE          IN       IAPITYPE.DESCRIPTION_TYPE DEFAULT NULL,
      AQSTAGES                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetStages';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSQLNULL                     VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'pls.stage '
            || IAPICONSTANTCOLUMN.STAGEIDCOL
            || ', f_sth_descr(pls.stage) '
            || IAPICONSTANTCOLUMN.STAGECOL
            || ', pls.intl '
            || IAPICONSTANTCOLUMN.INTERNATIONALCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'process_line_stage pls ';
   BEGIN
      
      
      
      
      
      IF ( AQSTAGES%ISOPEN )
      THEN
         CLOSE AQSTAGES;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE pls.plant = NULL';
      LSSQLNULL :=    'SELECT a.*, RowNum '
                   || IAPICONSTANTCOLUMN.ROWINDEXCOL
                   || ' FROM ('
                   || LSSQLNULL
                   || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQSTAGES FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LSSQL :=
            'SELECT DISTINCT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE pls.plant = :plantno '
         || '   AND pls.line = :line '
         || '   AND pls.configuration = :configuration ';

      IF NOT( ASDESCRIPTIONLIKE IS NULL )
      THEN
         LSSQL :=    LSSQL
                  || ' AND f_sth_descr(pls.stage) LIKE ''%'
                  || ASDESCRIPTIONLIKE
                  || '%''';
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY '
               || IAPICONSTANTCOLUMN.STAGECOL;
      LSSQL :=    'SELECT a.*, RowNum '
               || IAPICONSTANTCOLUMN.ROWINDEXCOL
               || ' FROM ('
               || LSSQL
               || ') a';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQSTAGES%ISOPEN )
      THEN
         CLOSE AQSTAGES;
      END IF;

      
      OPEN AQSTAGES FOR LSSQL USING ASPLANTNO,
      ASLINE,
      ANCONFIGURATION;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETSTAGES;

   
   FUNCTION UPDATEPROGRESS(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ANPROGRESS                 IN       IAPITYPE.MOPPROGRESS_TYPE,
      ASSTATUS                   IN       IAPITYPE.MOPSTATUS_TYPE DEFAULT NULL )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'UpdateProgress';
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
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Status <'
                           || ASSTATUS
                           || '> ; Progress <'
                           || ANPROGRESS
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( ASSTATUS = 'FINISHED_TEXT' )
      THEN
         UPDATE ITQ
            SET PROGRESS = ANPROGRESS,
                END_DATE = SYSDATE,
                STATUS = ASSTATUS
          WHERE USER_ID = ASUSERID;
      ELSE
         UPDATE ITQ
            SET PROGRESS = ANPROGRESS
          WHERE USER_ID = ASUSERID;
      END IF;

      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END UPDATEPROGRESS;
END IAPIMOP;
CREATE OR REPLACE PACKAGE BODY iapiReport
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





   
   
   

   
   
   
   FUNCTION GENERATEREQUEST(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ANLANGUAGEID               IN       IAPITYPE.LANGUAGEID_TYPE,
      ANMETRIC                   IN       IAPITYPE.METRICID_TYPE,
      ANREPORTID                 IN       IAPITYPE.ID_TYPE,
      ASCULTURE                  IN       IAPITYPE.CULTURE_TYPE,
      ASGUILANGUAGE              IN       IAPITYPE.GUILANGUAGE_TYPE,
      ANREQUESTID                OUT      IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GenerateRequest';
      LNREQUESTID                   IAPITYPE.ID_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT ITREPRQ_SEQ.NEXTVAL
        INTO ANREQUESTID
        FROM DUAL;

      INSERT INTO ITREPRQ
                  ( REQ_ID,
                    PART_NO,
                    REVISION,
                    USER_ID,
                    REP_ID,
                    LANG_ID,
                    METRIC,
                    CULTURE,
                    GUI_LANG )
           VALUES ( ANREQUESTID,
                    ASPARTNO,
                    ANREVISION,
                    ASUSERID,
                    ANREPORTID,
                    ANLANGUAGEID,
                    ANMETRIC,
                    ASCULTURE,
                    ASGUILANGUAGE );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GENERATEREQUEST;

   
   FUNCTION ADDREQUESTARGUMENT(
      ANREQUESTID                IN       IAPITYPE.ID_TYPE,
      ASARGUMENT                 IN       IAPITYPE.ARGUMENT_TYPE,
      ASVALUE                    IN       IAPITYPE.VALUE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
       
       
       
       
      
      
       
       
       
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddRequestArgument';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      INSERT INTO ITREPRQARG
                  ( REQ_ID,
                    ARG,
                    ARG_VAL )
           VALUES ( ANREQUESTID,
                    ASARGUMENT,
                    ASVALUE );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDREQUESTARGUMENT;

   
   FUNCTION GETREQUESTDETAILS(
      ANREQUESTID                IN       IAPITYPE.ID_TYPE,
      AQREQUESTDETAILS           OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetRequestDetails';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQREQUESTDETAILS FOR
         SELECT *
           FROM ITREPRQ
          WHERE REQ_ID = ANREQUESTID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETREQUESTDETAILS;

   
   FUNCTION GETREQUESTARGUMENTS(
      ANREQUESTID                IN       IAPITYPE.ID_TYPE,
      AQREQUESTARGUMENTS         OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetRequestArguments';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQREQUESTARGUMENTS FOR
         SELECT ARG,
                ARG_VAL
           FROM ITREPRQARG
          WHERE REQ_ID = ANREQUESTID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETREQUESTARGUMENTS;

   
   FUNCTION GETUSERREPORTGROUPREPORTS(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ANREPORTGROUPID            IN       IAPITYPE.ID_TYPE,
      AQREPORTS                  OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
       
       
       
       
      
       
       
       
       
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetUserReportGroupReports';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQREPORTS FOR
         SELECT ITREPD.SORT_DESC,
                ITREPD.DESCRIPTION,
                ITREPD.REP_ID,
                ITREPD.ADDON_ID,
                ITREPD.INFO,
                ITREPD.STATUS,
                ITREPD.REP_TYPE,
                ITREPD.BATCH_ALLOWED,
                ITREPD.WEB_ALLOWED
           FROM ITREPD,
                ITREPL,
                ITREPAC,
                ITREPG
          WHERE ( ITREPD.REP_ID = ITREPL.REP_ID )
            AND ( ITREPL.REP_ID = ITREPAC.REP_ID )
            AND ( ITREPG.REPG_ID = ITREPL.REPG_ID )
            AND ( ITREPD.WEB_ALLOWED = 1 )
            AND ( ITREPAC.ACCESS_TYPE = 'A' )
            AND ( ITREPD.REP_TYPE IN( 100, 200 ) )
            AND ( UPPER( ITREPG.REPG_ID ) = ANREPORTGROUPID )
         UNION
         SELECT ITREPD.SORT_DESC,
                ITREPD.DESCRIPTION,
                ITREPD.REP_ID,
                ITREPD.ADDON_ID,
                ITREPD.INFO,
                ITREPD.STATUS,
                ITREPD.REP_TYPE,
                ITREPD.BATCH_ALLOWED,
                ITREPD.WEB_ALLOWED
           FROM ITREPD,
                ITREPL,
                ITREPAC,
                ITREPG
          WHERE ( ITREPD.REP_ID = ITREPL.REP_ID )
            AND ( ITREPL.REP_ID = ITREPAC.REP_ID )
            AND ( ITREPG.REPG_ID = ITREPL.REPG_ID )
            AND ( ITREPD.WEB_ALLOWED = 1 )
            AND ( ITREPAC.ACCESS_TYPE = 'U' )
            AND ( ITREPD.REP_TYPE IN( 100, 200 ) )
            AND ( UPPER( ITREPAC.USER_ID ) = ASUSERID )
            AND ( UPPER( ITREPG.REPG_ID ) = ANREPORTGROUPID )
         UNION
         SELECT ITREPD.SORT_DESC,
                ITREPD.DESCRIPTION,
                ITREPD.REP_ID,
                ITREPD.ADDON_ID,
                ITREPD.INFO,
                ITREPD.STATUS,
                ITREPD.REP_TYPE,
                ITREPD.BATCH_ALLOWED,
                ITREPD.WEB_ALLOWED
           FROM ITREPD,
                ITREPL,
                ITREPAC,
                ITREPG,
                USER_GROUP_LIST
          WHERE ( ITREPD.REP_ID = ITREPL.REP_ID )
            AND ( ITREPL.REP_ID = ITREPAC.REP_ID )
            AND ( ITREPD.WEB_ALLOWED = 1 )
            AND ( ITREPG.REPG_ID = ITREPL.REPG_ID )
            AND ( ITREPAC.ACCESS_TYPE = 'G' )
            AND ( ITREPD.REP_TYPE IN( 100, 200 ) )
            AND ( ITREPAC.USER_GROUP_ID = USER_GROUP_LIST.USER_GROUP_ID )
            AND ( USER_GROUP_LIST.USER_ID = ASUSERID )
            AND ( UPPER( ITREPG.REPG_ID ) = ANREPORTGROUPID );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETUSERREPORTGROUPREPORTS;

   
   FUNCTION GETGROUPS(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      AQGROUPS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetGroups';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQGROUPS FOR
         SELECT ITREPG.DESCRIPTION DESCRIPTION,
                ITREPG.REPG_ID ID
           FROM ITREPD,
                ITREPL,
                ITREPAC,
                ITREPG
          WHERE ( ITREPD.REP_ID = ITREPL.REP_ID )
            AND ( ITREPL.REP_ID = ITREPAC.REP_ID )
            AND ( ITREPD.WEB_ALLOWED = 1 )
            AND ( ITREPG.REPG_ID = ITREPL.REPG_ID )
            AND ( ITREPD.REP_TYPE IN( 100, 200 ) )
            AND ( ITREPAC.ACCESS_TYPE = 'A' )
         UNION
         SELECT ITREPG.DESCRIPTION DESCRIPTION,
                ITREPG.REPG_ID ID
           FROM ITREPD,
                ITREPL,
                ITREPAC,
                ITREPG
          WHERE ( ITREPD.REP_ID = ITREPL.REP_ID )
            AND ( ITREPD.WEB_ALLOWED = 1 )
            AND ( ITREPL.REP_ID = ITREPAC.REP_ID )
            AND ( ITREPG.REPG_ID = ITREPL.REPG_ID )
            AND ( ITREPD.REP_TYPE IN( 100, 200 ) )
            AND ( ITREPAC.ACCESS_TYPE = 'U' )
            AND ( UPPER( ITREPAC.USER_ID ) = ASUSERID )
         UNION
         SELECT ITREPG.DESCRIPTION DESCRIPTION,
                ITREPG.REPG_ID ID
           FROM ITREPD,
                ITREPL,
                ITREPAC,
                ITREPG,
                USER_GROUP_LIST
          WHERE ( ITREPD.REP_ID = ITREPL.REP_ID )
            AND ( ITREPL.REP_ID = ITREPAC.REP_ID )
            AND ( ITREPD.WEB_ALLOWED = 1 )
            AND ( ITREPD.REP_TYPE IN( 100, 200 ) )
            AND ( ITREPG.REPG_ID = ITREPL.REPG_ID )
            AND ( ITREPAC.ACCESS_TYPE = 'G' )
            AND ( ITREPAC.USER_GROUP_ID = USER_GROUP_LIST.USER_GROUP_ID )
            AND ( USER_GROUP_LIST.USER_ID = ASUSERID );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETGROUPS;

   
   FUNCTION GETREPORTS(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      AQREPORTS                  OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetReports';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQREPORTS FOR
         SELECT ITREPD.SORT_DESC,
                ITREPD.DESCRIPTION,
                ITREPD.REP_ID,
                ITREPD.ADDON_ID,
                ITREPD.INFO,
                ITREPD.STATUS,
                ITREPD.REP_TYPE,
                ITREPD.BATCH_ALLOWED,
                ITREPD.WEB_ALLOWED
           FROM ITREPD,
                ITREPL,
                ITREPAC,
                ITREPG
          WHERE ( ITREPD.REP_ID = ITREPL.REP_ID )
            AND ( ITREPL.REP_ID = ITREPAC.REP_ID )
            AND ( ITREPG.REPG_ID = ITREPL.REPG_ID )
            AND ( ITREPAC.ACCESS_TYPE = 'A' )
            AND ( ITREPD.WEB_ALLOWED = 1 )
            AND ( ITREPD.REP_TYPE IN( 100, 200 ) )
         UNION
         SELECT ITREPD.SORT_DESC,
                ITREPD.DESCRIPTION,
                ITREPD.REP_ID,
                ITREPD.ADDON_ID,
                ITREPD.INFO,
                ITREPD.STATUS,
                ITREPD.REP_TYPE,
                ITREPD.BATCH_ALLOWED,
                ITREPD.WEB_ALLOWED
           FROM ITREPD,
                ITREPL,
                ITREPAC,
                ITREPG
          WHERE ( ITREPD.REP_ID = ITREPL.REP_ID )
            AND ( ITREPD.WEB_ALLOWED = 1 )
            AND ( ITREPL.REP_ID = ITREPAC.REP_ID )
            AND ( ITREPG.REPG_ID = ITREPL.REPG_ID )
            AND ( ITREPAC.ACCESS_TYPE = 'U' )
            AND ( UPPER( ITREPAC.USER_ID ) = ASUSERID )
            AND ( ITREPD.REP_TYPE IN( 100, 200 ) )
         UNION
         SELECT ITREPD.SORT_DESC,
                ITREPD.DESCRIPTION,
                ITREPD.REP_ID,
                ITREPD.ADDON_ID,
                ITREPD.INFO,
                ITREPD.STATUS,
                ITREPD.REP_TYPE,
                ITREPD.BATCH_ALLOWED,
                ITREPD.WEB_ALLOWED
           FROM ITREPD,
                ITREPL,
                ITREPAC,
                ITREPG,
                USER_GROUP_LIST
          WHERE ( ITREPD.REP_ID = ITREPL.REP_ID )
            AND ( ITREPL.REP_ID = ITREPAC.REP_ID )
            AND ( ITREPG.REPG_ID = ITREPL.REPG_ID )
            AND ( ITREPD.WEB_ALLOWED = 1 )
            AND ( ITREPD.REP_TYPE IN( 100, 200 ) )
            AND ( ITREPAC.ACCESS_TYPE = 'G' )
            AND ( ITREPAC.USER_GROUP_ID = USER_GROUP_LIST.USER_GROUP_ID )
            AND ( USER_GROUP_LIST.USER_ID = ASUSERID );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETREPORTS;

   
   FUNCTION GETREPORT(
      ANREPORTID                 IN       IAPITYPE.ID_TYPE,
      AQREPORT                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetReport';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQREPORT FOR
         SELECT REP_ID,
                SORT_DESC,
                DESCRIPTION,
                INFO,
                STATUS,
                REP_TYPE,
                ADDON_ID,
                BATCH_ALLOWED,
                WEB_ALLOWED
           FROM ITREPD
          WHERE REP_ID = ANREPORTID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETREPORT;

   
   FUNCTION GETREPORTDETAILS(
      ANREPORTID                 IN       IAPITYPE.ID_TYPE,
      AQREPORTDETAILS            OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetReportDetails';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQREPORTDETAILS FOR
         SELECT REP_ID,
                NREP_TYPE,
                REF_ID,
                REF_VER,
                REF_OWNER,
                INCLUDE,
                SEQ,
                HEADER,
                HEADER_DESCR,
                DISPLAY_FORMAT,
                DISPLAY_FORMAT_REV,
                INCL_OBJ
           FROM ITREPDATA
          WHERE REP_ID = ANREPORTID
         UNION
         SELECT REP_ID,
                'title',
                0,
                0,
                0,
                '',
                0,
                0,
                DESCRIPTION,
                0,
                0,
                0
           FROM ITREPD
          WHERE REP_ID = ANREPORTID
         UNION
         SELECT REP_ID,
                'conf',
                0,
                0,
                0,
                '',
                0,
                0,
                CONFIDENTIAL_TEXT,
                0,
                0,
                0
           FROM ITREPD
          WHERE REP_ID = ANREPORTID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETREPORTDETAILS;

   
   FUNCTION REMOVEREQUEST(
      ANREQUESTID                IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveRequest';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      BEGIN
         DELETE FROM ITREPRQARG
               WHERE REQ_ID = ANREQUESTID;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      BEGIN
         DELETE FROM ITREPRQ
               WHERE REQ_ID = ANREQUESTID;
      EXCEPTION
         WHEN NO_DATA_FOUND
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
   END REMOVEREQUEST;

   
   FUNCTION GETLASTMODIFIED(
      ANREPORTID                 IN       IAPITYPE.ID_TYPE,
      ADDATE                     OUT      IAPITYPE.DATE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetLastModified';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT MAX( LAST_MODIFIED_ON )
        INTO ADDATE
        FROM ( SELECT LAST_MODIFIED_ON
                FROM ITREPITEMS
               WHERE REP_ID = ANREPORTID
              UNION
              SELECT LAST_MODIFIED_ON
                FROM ITREPITEMTYPE
               WHERE STANDARD = 1
              UNION
              SELECT ITREPTEMPLATE.LAST_MODIFIED_ON
                FROM ITREPITEMS ITREPITEMS,
                     ITREPTEMPLATE ITREPTEMPLATE
               WHERE (  (     ITREPITEMS.TEMPL_ID = ITREPTEMPLATE.TEMPL_ID
                          AND REP_ID = ANREPORTID ) )
              UNION
              SELECT ITREPTEMPLATE.LAST_MODIFIED_ON TPL_MODIFIED_ON
                FROM ITREPTEMPLATE ITREPTEMPLATE,
                     ITREPITEMTYPE ITREPITEMTYPE
               WHERE (      ( ITREPITEMTYPE.DEFAULT_TEMPL_ID = ITREPTEMPLATE.TEMPL_ID )
                       AND ( ITREPITEMTYPE.STANDARD = 1 )
                       AND ITREPTEMPLATE.TYPE NOT IN( SELECT TYPE
                                                       FROM ITREPITEMS
                                                      WHERE REP_ID = ANREPORTID ) ) );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETLASTMODIFIED;

   
   FUNCTION GETOVERRULEDITEMS(
      ANREPORTID                 IN       IAPITYPE.ID_TYPE,
      AQITEMS                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetOverruledItems';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQITEMS FOR
         SELECT ITREPITEMS.REP_ID,
                ITREPTEMPLATE.TYPE,
                ITREPTEMPLATE.TEMPL_ID,
                ITREPTEMPLATE.PDF,
                
                
                ITREPTEMPLATE.LAST_MODIFIED_ON
           FROM ITREPITEMS ITREPITEMS,
                ITREPTEMPLATE ITREPTEMPLATE
          WHERE (  (     ITREPITEMS.TEMPL_ID = ITREPTEMPLATE.TEMPL_ID
                     AND REP_ID = ANREPORTID ) );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETOVERRULEDITEMS;

   
   FUNCTION GETNOTOVERRULEDITEMS(
      ANREPORTID                 IN       IAPITYPE.ID_TYPE,
      AQITEMS                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetNotOverruledItems';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQITEMS FOR
         SELECT ANREPORTID,
                ITREPTEMPLATE.TYPE,
                ITREPTEMPLATE.TEMPL_ID,
                ITREPTEMPLATE.PDF,
                
                
                ITREPITEMTYPE.LAST_MODIFIED_ON
           FROM ITREPTEMPLATE ITREPTEMPLATE,
                ITREPITEMTYPE ITREPITEMTYPE
          WHERE (      ( ITREPITEMTYPE.DEFAULT_TEMPL_ID = ITREPTEMPLATE.TEMPL_ID )
                  AND ( ITREPITEMTYPE.STANDARD = 1 )
                  AND ITREPTEMPLATE.TYPE NOT IN( SELECT TYPE
                                                  FROM ITREPITEMS
                                                 WHERE REP_ID = ANREPORTID ) );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETNOTOVERRULEDITEMS;

   
   FUNCTION GETITEMTYPES(
      AQREPORTITEMTYPES          OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetItemTypes';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQREPORTITEMTYPES FOR
         SELECT TYPE,
                DESCRIPTION,
                STANDARD,
                DEFAULT_TEMPL_ID,
                LAST_MODIFIED_ON,
                LAST_MODIFIED_BY
           FROM ITREPITEMTYPE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETITEMTYPES;

   
   FUNCTION GETDEFAULTTEMPLATE(
      ASTYPE                     IN       IAPITYPE.REPORTITEMTYPE_TYPE,
      AQTEMPLATE                 OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetDefaultTemplate';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQTEMPLATE FOR
         SELECT TPL.TEMPL_ID,
                TPL.TYPE,
                TPL.DESCRIPTION,
                
                
                TPL.PDF,
                TPL.LAST_MODIFIED_ON,
                TPL.LAST_MODIFIED_BY
           FROM ITREPITEMTYPE ITR,
                ITREPTEMPLATE TPL
          WHERE (      ( ITR.DEFAULT_TEMPL_ID = TPL.TEMPL_ID )
                  AND ( TPL.TYPE = ASTYPE ) );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETDEFAULTTEMPLATE;

   
   FUNCTION GETBOMLAYOUT(
      ANREPORTID                 IN       IAPITYPE.ID_TYPE,
      AQLAYOUT                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetBomLayout';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQLAYOUT FOR
         SELECT DISTINCT LAYOUT_ID,
                         REVISION,
                         F_HDH_DESCR( 1,
                                      HEADER_ID,
                                      HEADER_REV ) HDR_DESCR,
                         FIELD_ID,
                         LENGTH,
                         START_POS,
                         BOLD,
                         UNDERLINE,
                         ALIGNMENT,
                         HEADER,
                         
                         DESCRIPTION AS FORMAT_DESCRIPTION
                    FROM ITBOMLYITEM A
                    
                    LEFT JOIN FORMAT ON FORMAT.FORMAT_ID = A.FORMAT_ID
                    WHERE ( A.LAYOUT_ID, A.REVISION ) IN( ( SELECT DISTINCT DISPLAY_FORMAT,
                                                                           DISPLAY_FORMAT_REV
                                                                     FROM ITREPDATA
                                                                     WHERE REP_ID = ANREPORTID
                                                                      AND NREP_TYPE = '3' ) )
                ORDER BY 1,
                         2,
                         6;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETBOMLAYOUT;
END IAPIREPORT;
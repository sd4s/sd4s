CREATE OR REPLACE PACKAGE BODY iapiAddOn
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

   
   
   

   
   
   
   
   
   
   
   FUNCTION ADDREQUEST(
      ASUSERID                   IN       IAPITYPE.USERID_TYPE,
      ANLANGUAGEID               IN       IAPITYPE.LANGUAGEID_TYPE,
      ANMETRIC                   IN       IAPITYPE.METRICID_TYPE,
      ANADDONID                  IN       IAPITYPE.ID_TYPE,
      ANNEXTADDONID              IN       IAPITYPE.ID_TYPE,
      ASCULTURE                  IN       IAPITYPE.CULTURE_TYPE,
      ASGUILANGUAGE              IN       IAPITYPE.GUILANGUAGE_TYPE,
      ANREQUESTID                OUT      IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddRequest';
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

      
      
      IF ( ASUSERID IS NULL )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                     'User' ) );
      END IF;

      
      
      IF ( ANMETRIC IS NULL )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                     'Metric' ) );
      END IF;

      
      
      IF ( ANLANGUAGEID IS NULL )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                     'Language Id' ) );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      SELECT ITADDONRQ_SEQ.NEXTVAL
        INTO ANREQUESTID
        FROM DUAL;

      INSERT INTO ITADDONRQ
                  ( REQ_ID,
                    USER_ID,
                    ADDON_ID,
                    NEXT_ADDON_ID,
                    LANG_ID,
                    METRIC,
                    CULTURE,
                    GUI_LANG )
           VALUES ( ANREQUESTID,
                    ASUSERID,
                    ANADDONID,
                    ANNEXTADDONID,
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
   END ADDREQUEST;

   
   FUNCTION ADDREQUESTARGUMENTS(
      ANREQUESTID                IN       IAPITYPE.ID_TYPE,
      ASARGUMENT                 IN       IAPITYPE.DESCRIPTION_TYPE,
      ASVALUE                    IN       IAPITYPE.DESCRIPTION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddRequestArguments';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      IF ( ANREQUESTID IS NULL )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                     'Request' ) );
      END IF;

      
      
      IF ( ASARGUMENT IS NULL )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                     'Argument' ) );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      INSERT INTO ITADDONRQARG
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
   END ADDREQUESTARGUMENTS;

   
   FUNCTION GETREQUEST(
      ANREQUESTID                IN       IAPITYPE.ID_TYPE,
      AQREQUESTDETAILS           OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetRequest';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( AQREQUESTDETAILS%ISOPEN )
      THEN
         CLOSE AQREQUESTDETAILS;
      END IF;

      OPEN AQREQUESTDETAILS FOR
         SELECT REQ_ID,
                USER_ID,
                ADDON_ID,
                METRIC,
                LANG_ID,
                CULTURE,
                GUI_LANG,
                NEXT_ADDON_ID
           FROM ITADDONRQ
          WHERE REQ_ID = ANREQUESTID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETREQUEST;

   
   FUNCTION GETREQUESTARGUMENTS(
      ANREQUESTID                IN       IAPITYPE.ID_TYPE,
      AQREQUESTARGUMENTS         OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetRequestArguments';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( AQREQUESTARGUMENTS%ISOPEN )
      THEN
         CLOSE AQREQUESTARGUMENTS;
      END IF;

      OPEN AQREQUESTARGUMENTS FOR
         SELECT ARG,
                ARG_VAL
           FROM ITADDONRQARG
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

   
   FUNCTION GETDEFAULTARGUMENTS(
      ANADDONID                  IN       IAPITYPE.ID_TYPE,
      AQDEFAULTARGUMENTS         OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetDefaultArguments';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( AQDEFAULTARGUMENTS%ISOPEN )
      THEN
         CLOSE AQDEFAULTARGUMENTS;
      END IF;

      OPEN AQDEFAULTARGUMENTS FOR
         SELECT ARG
           FROM ITADDONARG
          WHERE ADDON_ID = ANADDONID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETDEFAULTARGUMENTS;

   
   FUNCTION GETADDONS(
      ANTYPEID                   IN       IAPITYPE.ID_TYPE,
      ANACCESSTYPE               IN       IAPITYPE.ADDONACCESS_TYPE,
      AQADDONS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetAddOns';
      LSUSERID                      IAPITYPE.USERID_TYPE := IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
      LSUSERGROUPID                 IAPITYPE.USERGROUPID_TYPE := 0;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( AQADDONS%ISOPEN )
      THEN
         CLOSE AQADDONS;
      END IF;

      OPEN AQADDONS FOR
         SELECT A.ADDON_ID,
                A.NAME,
                A.ASSEMBLY,
                A.DOMAIN,
                A.DESCRIPTION,
                A.CLASS,
                A.ADDONTYPE,
                A.STARTURL,
                A.STARTPARAM
           FROM ITADDON A,
                ITADDONAC B
          WHERE (    ANTYPEID IS NULL
                  OR (     ANTYPEID IS NOT NULL
                       AND A.ADDONTYPE = ANTYPEID ) )
            AND A.ADDON_ID = B.ADDON_ID
            AND B.ACCESS_TYPE = ANACCESSTYPE
            AND (     ( B.ACCESS_TYPE = IAPICONSTANT.ADDONACCESS_ALLUSERS )
                  OR (     B.ACCESS_TYPE = IAPICONSTANT.ADDONACCESS_USERGROUP
                       AND B.USER_GROUP_ID IN( SELECT USER_GROUP_ID
                                                FROM USER_GROUP_LIST
                                               WHERE USER_ID = LSUSERID ) )
                  OR (     B.ACCESS_TYPE = IAPICONSTANT.ADDONACCESS_USER
                       AND B.USER_ID = LSUSERID ) );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETADDONS;

   
   FUNCTION GETADDON(
      ANADDONID                  IN       IAPITYPE.ID_TYPE,
      ANACCESSTYPE               IN       IAPITYPE.ADDONACCESS_TYPE,
      AQADDON                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetAddOn';
      LSUSERID                      IAPITYPE.USERID_TYPE := IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
      LSUSERGROUPID                 IAPITYPE.USERGROUPID_TYPE := 0;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( AQADDON%ISOPEN )
      THEN
         CLOSE AQADDON;
      END IF;

      OPEN AQADDON FOR
         SELECT A.ADDON_ID,
                A.NAME,
                A.ASSEMBLY,
                A.DOMAIN,
                A.DESCRIPTION,
                A.CLASS,
                A.ADDONTYPE,
                A.STARTURL,
                A.STARTPARAM
           FROM ITADDON A,
                ITADDONAC B
          WHERE A.ADDON_ID = ANADDONID
            AND A.ADDON_ID = B.ADDON_ID
            AND B.ACCESS_TYPE = ANACCESSTYPE
            AND (     ( B.ACCESS_TYPE = IAPICONSTANT.ADDONACCESS_ALLUSERS )
                  OR (     B.ACCESS_TYPE = IAPICONSTANT.ADDONACCESS_USERGROUP
                       AND B.USER_GROUP_ID IN( SELECT USER_GROUP_ID
                                                FROM USER_GROUP_LIST
                                               WHERE USER_ID = LSUSERID ) )
                  OR (     B.ACCESS_TYPE = IAPICONSTANT.ADDONACCESS_USER
                       AND B.USER_ID = LSUSERID ) );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETADDON;

   
   FUNCTION GETASSEMBLY(
      ASASSEMBLY                 IN       IAPITYPE.STRING_TYPE,
      ANACCESSTYPE               IN       IAPITYPE.ADDONACCESS_TYPE,
      AQADDON                    OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetAssembly';
      LSUSERID                      IAPITYPE.USERID_TYPE := IAPIGENERAL.SESSION.APPLICATIONUSER.USERID;
      LSUSERGROUPID                 IAPITYPE.USERGROUPID_TYPE := 0;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( AQADDON%ISOPEN )
      THEN
         CLOSE AQADDON;
      END IF;

      OPEN AQADDON FOR
         SELECT A.ADDON_ID,
                A.NAME,
                A.ASSEMBLY,
                A.DOMAIN,
                A.DESCRIPTION,
                A.CLASS,
                A.ADDONTYPE,
                A.STARTURL,
                A.STARTPARAM
           FROM ITADDON A,
                ITADDONAC B
          WHERE A.ASSEMBLY = ASASSEMBLY
            AND A.ADDON_ID = B.ADDON_ID
            AND B.ACCESS_TYPE = ANACCESSTYPE
            AND (     ( B.ACCESS_TYPE = IAPICONSTANT.ADDONACCESS_ALLUSERS )
                  OR (     B.ACCESS_TYPE = IAPICONSTANT.ADDONACCESS_USERGROUP
                       AND B.USER_GROUP_ID IN( SELECT USER_GROUP_ID
                                                FROM USER_GROUP_LIST
                                               WHERE USER_ID = LSUSERID ) )
                  OR (     B.ACCESS_TYPE = IAPICONSTANT.ADDONACCESS_USER
                       AND B.USER_ID = LSUSERID ) );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETASSEMBLY;

   
   FUNCTION GETTYPES(
      AQADDONTYPES               OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetTypes';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( AQADDONTYPES%ISOPEN )
      THEN
         CLOSE AQADDONTYPES;
      END IF;

      OPEN AQADDONTYPES FOR
         SELECT ADDONTYPE_ID,
                DESCRIPTION
           FROM ITADDONTYPE;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETTYPES;

   
   FUNCTION REMOVEREQUEST(
      ANREQUESTID                IN       IAPITYPE.ID_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveRequest';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      IF ( ANREQUESTID IS NULL )
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_ISMANDATORY,
                                                     'Request' ) );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      DELETE FROM ITADDONRQARG
            WHERE REQ_ID = ANREQUESTID;

      DELETE FROM ITADDONRQ
            WHERE REQ_ID = ANREQUESTID;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEREQUEST;

   
   FUNCTION GETARGUMENTS(
      ANADDONID                  IN       IAPITYPE.ID_TYPE,
      AQARGUMENTS                OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetArguments';
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ( AQARGUMENTS%ISOPEN )
      THEN
         CLOSE AQARGUMENTS;
      END IF;

      OPEN AQARGUMENTS FOR
         SELECT ADDON_ID,
                ARG_ID,
                ARG
           FROM ITADDONARG;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETARGUMENTS;
END IAPIADDON;
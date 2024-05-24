CREATE OR REPLACE PACKAGE BODY iapiUtilities
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

   
   
   

   
   
   
   
   
   
   
   PROCEDURE RESETDATABASEOWNER(
      ANOLDOWNERID               IN       IAPITYPE.OWNER_TYPE,
      ANNEWOWNERID               IN       IAPITYPE.OWNER_TYPE )
   IS
      
      
      
      
      
      
      
      
           
      CURSOR LQFRAMEHEADEROWNER
      IS
         SELECT     OWNER
               FROM FRAME_HEADER
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQFRAMESECTIONOWNER
      IS
         SELECT     OWNER
               FROM FRAME_SECTION
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQFRAMESECTIONREFOWNER
      IS
         SELECT     REF_OWNER
               FROM FRAME_SECTION
              WHERE REF_OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQFRAMETEXTOWNER
      IS
         SELECT     *
               FROM FRAME_TEXT
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQFRAMEPROPOWNER
      IS
         SELECT     *
               FROM FRAME_PROP
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQFRAMEDATAOWNER
      IS
         SELECT     *
               FROM FRAMEDATA
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQFRAMEDATAREFOWNER
      IS
         SELECT     *
               FROM FRAMEDATA
              WHERE REF_OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQFRAMEDATASERVEROWNER
      IS
         SELECT     *
               FROM FRAMEDATA_SERVER
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQFRAMEKWOWNER
      IS
         SELECT     *
               FROM FRAME_KW
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQSHFRAMEOWNER
      IS
         
         SELECT     *
               FROM SPECIFICATION_HEADER
              WHERE FRAME_OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQSPECIFICATIONHEADEROWNER
      IS
         SELECT     *
               FROM SPECIFICATION_HEADER
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQSSREFOWNER
      IS
         SELECT     *
               FROM SPECIFICATION_SECTION
              WHERE REF_OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQSPECDATAREFOWNER
      IS
         SELECT     *
               FROM SPECDATA
              WHERE REF_OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQSPECDATAPROCESSREFOWNER
      IS
         SELECT     *
               FROM SPECDATA_PROCESS
              WHERE REF_OWNER = ANOLDOWNERID
         FOR UPDATE;

      
      CURSOR LQREFTEXTTYPEOWNER
      IS
         SELECT     *
               FROM REF_TEXT_TYPE
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQREFERENCETEXTOWNER
      IS
         SELECT     *
               FROM REFERENCE_TEXT
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQREFTEXTKWOWNER
      IS
         SELECT     *
               FROM REF_TEXT_KW
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      
      CURSOR LQSPECPREFIXOWNER
      IS
         SELECT     *
               FROM SPEC_PREFIX
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      
      CURSOR LQITSHFLTOWNER
      IS
         SELECT     OWNER
               FROM ITSHFLT
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITSHFLTFRAMEOWNER
      IS
         SELECT     FRAME_OWNER
               FROM ITSHFLT
              WHERE FRAME_OWNER = ANOLDOWNERID
         FOR UPDATE;

      
      CURSOR LQITOIHOWNER
      IS
         SELECT     OWNER
               FROM ITOIH
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITOIDOWNER
      IS
         SELECT     OWNER
               FROM ITOID
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITOIRAWOWNER
      IS
         SELECT     OBJECT_ID,
                    REVISION,
                    OWNER
               FROM ITOIRAW
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITOIKWOWNER
      IS
         SELECT     OWNER
               FROM ITOIKW
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITFRMHOWNER
      IS
         SELECT     OWNER
               FROM ITFRM_H
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITFRMCLOWNER
      IS
         SELECT     OWNER
               FROM ITFRMCL
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITFRMDELOWNER
      IS
         SELECT     OWNER
               FROM ITFRMDEL
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITFRMFLTOWNER
      IS
         SELECT     OWNER
               FROM ITFRMFLT
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITFRMNOTEOWNER
      IS
         SELECT     OWNER
               FROM ITFRMNOTE
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITFRMVOWNER
      IS
         SELECT     OWNER
               FROM ITFRMV
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITFRMVALOWNER
      IS
         SELECT     OWNER
               FROM ITFRMVAL
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITFRMVALDREFOWNER
      IS
         SELECT     REF_OWNER
               FROM ITFRMVALD
              WHERE REF_OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITFRMVPGOWNER
      IS
         SELECT     OWNER
               FROM ITFRMVPG
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITFRMVSCOWNER
      IS
         SELECT     OWNER
               FROM ITFRMVSC
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITIMPLOGOWNER
      IS
         SELECT     OWNER
               FROM ITIMP_LOG
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITOIHSOWNER
      IS
         SELECT     OWNER
               FROM ITOIHS
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITPROBJOWNER
      IS
         SELECT     OWNER
               FROM ITPROBJ
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITPROBJHOWNER
      IS
         SELECT     OWNER
               FROM ITPROBJ_H
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITREPDATAREFOWNER
      IS
         SELECT     REF_OWNER
               FROM ITREPDATA
              WHERE REF_OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITRTHSOWNER
      IS
         SELECT     OWNER
               FROM ITRTHS
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITSHEXTREFOWNER
      IS
         SELECT     REF_OWNER
               FROM ITSHEXT
              WHERE REF_OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITSHVALDREFOWNER
      IS
         SELECT     REF_OWNER
               FROM ITSHVALD
              WHERE REF_OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQSPECPREFIXDESCROWNER
      IS
         SELECT     OWNER
               FROM SPEC_PREFIX_DESCR
              WHERE OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQFTFRAMESOLDFRAMEOWNER
      IS
         SELECT     OLD_FRAME_OWNER
               FROM FT_FRAMES
              WHERE OLD_FRAME_OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQFTFRAMESNEWFRAMEOWNER
      IS
         SELECT     NEW_FRAME_OWNER
               FROM FT_FRAMES
              WHERE NEW_FRAME_OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQFTFRAMESHOLDFRAMEOWNER
      IS
         SELECT     OLD_FRAME_OWNER
               FROM FT_FRAMES_H
              WHERE OLD_FRAME_OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQFTFRAMESHNEWFRAMEOWNER
      IS
         SELECT     NEW_FRAME_OWNER
               FROM FT_FRAMES_H
              WHERE NEW_FRAME_OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQFTSPECSECTIONREFOWNER
      IS
         SELECT     REF_OWNER
               FROM FT_SPEC_SECTION
              WHERE REF_OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITSHCMPREFOWNER
      IS
         SELECT     REF_OWNER
               FROM ITSHCMP
              WHERE REF_OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITSHCMPREFOWNER2
      IS
         SELECT     REF_OWNER2
               FROM ITSHCMP
              WHERE REF_OWNER2 = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITSHQFRAMEOWNER
      IS
         SELECT     FRAME_OWNER
               FROM ITSHQ
              WHERE FRAME_OWNER = ANOLDOWNERID
         FOR UPDATE;

      CURSOR LQITTSRESULTS
      IS
         SELECT     REF_OWNER
               FROM ITTSRESULTS
              WHERE REF_OWNER = ANOLDOWNERID
         FOR UPDATE;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ResetDatabaseOwner';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSERROR                       VARCHAR2( 255 );
      LNROW                         NUMBER;
      LSOWNERS                      VARCHAR2( 100 );
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPIDATABASE.DISABLECONSTRAINTS( );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RAISE_APPLICATION_ERROR( -20001,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
      END IF;

      LSOWNERS :=    ' NEW OWNER : '
                  || ANNEWOWNERID
                  || ' OLD OWNER : '
                  || ANOLDOWNERID;
      LSERROR :=    'TABLE : FRAME_HEADER - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQFRAMEHEADEROWNER
      LOOP
         UPDATE FRAME_HEADER
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQFRAMEHEADEROWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : FRAME_SECTION - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQFRAMESECTIONOWNER
      LOOP
         UPDATE FRAME_SECTION
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQFRAMESECTIONOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : FRAME_SECTION - Column "REF_OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQFRAMESECTIONREFOWNER
      LOOP
         UPDATE FRAME_SECTION
            SET REF_OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQFRAMESECTIONREFOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE :FRAME_TEXT - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQFRAMETEXTOWNER
      LOOP
         UPDATE FRAME_TEXT
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQFRAMETEXTOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : FRAME_PROP - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQFRAMEPROPOWNER
      LOOP
         UPDATE FRAME_PROP
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQFRAMEPROPOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : FRAMEDATA - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQFRAMEDATAOWNER
      LOOP
         UPDATE FRAMEDATA
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQFRAMEDATAOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : FRAMEDATA - Column "REF_OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQFRAMEDATAREFOWNER
      LOOP
         UPDATE FRAMEDATA
            SET REF_OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQFRAMEDATAREFOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : FRAMEDATA_SERVER - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQFRAMEDATASERVEROWNER
      LOOP
         UPDATE FRAMEDATA_SERVER
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQFRAMEDATASERVEROWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : FRAME_KW - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQFRAMEKWOWNER
      LOOP
         UPDATE FRAME_KW
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQFRAMEKWOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      
      LSERROR :=    'TABLE : SPECIFICATION_HEADER - Column "FRAME_OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQSHFRAMEOWNER
      LOOP
         UPDATE SPECIFICATION_HEADER
            SET FRAME_OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQSHFRAMEOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : SPECIFICATION_HEADER - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQSPECIFICATIONHEADEROWNER
      LOOP
         UPDATE SPECIFICATION_HEADER
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQSPECIFICATIONHEADEROWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : SPECIFICATION_SECTION - Column "REF_OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQSSREFOWNER
      LOOP
         UPDATE SPECIFICATION_SECTION
            SET REF_OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQSSREFOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : SPECDATA - Column "REF_OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQSPECDATAREFOWNER
      LOOP
         UPDATE SPECDATA
            SET REF_OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQSPECDATAREFOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : SPECDATA_PROCESS - Column "REF_OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQSPECDATAPROCESSREFOWNER
      LOOP
         UPDATE SPECDATA_PROCESS
            SET REF_OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQSPECDATAPROCESSREFOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : REF_TEXT_TYPE - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQREFTEXTTYPEOWNER
      LOOP
         UPDATE REF_TEXT_TYPE
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQREFTEXTTYPEOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : REFERENCE_TEXT - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQREFERENCETEXTOWNER
      LOOP
         UPDATE REFERENCE_TEXT
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQREFERENCETEXTOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : REF_TEXT_KW - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQREFTEXTKWOWNER
      LOOP
         UPDATE REF_TEXT_KW
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQREFTEXTKWOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITOIH - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITOIHOWNER
      LOOP
         UPDATE ITOIH
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITOIHOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITOID - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITOIDOWNER
      LOOP
         UPDATE ITOID
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITOIDOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITOIRAW - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITOIRAWOWNER
      LOOP
         UPDATE ITOIRAW
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITOIRAWOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITOIKW - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITOIKWOWNER
      LOOP
         UPDATE ITOIKW
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITOIKWOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : SPEC_PREFIX - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQSPECPREFIXOWNER
      LOOP
         UPDATE SPEC_PREFIX
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQSPECPREFIXOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITSHFLT - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITSHFLTOWNER
      LOOP
         UPDATE ITSHFLT
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITSHFLTOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITSHFLT - Column "FRAME_OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITSHFLTFRAMEOWNER
      LOOP
         UPDATE ITSHFLT
            SET FRAME_OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITSHFLTFRAMEOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITFRM_H - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITFRMHOWNER
      LOOP
         UPDATE ITFRM_H
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITFRMHOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITFRMCL - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITFRMCLOWNER
      LOOP
         UPDATE ITFRMCL
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITFRMCLOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITFRMDEL - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITFRMDELOWNER
      LOOP
         UPDATE ITFRMDEL
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITFRMDELOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITFRMFLT - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITFRMFLTOWNER
      LOOP
         UPDATE ITFRMFLT
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITFRMFLTOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITFRMNOTE - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITFRMNOTEOWNER
      LOOP
         UPDATE ITFRMNOTE
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITFRMNOTEOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITFRMV - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITFRMVOWNER
      LOOP
         UPDATE ITFRMV
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITFRMVOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITFRMVAL - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITFRMVALOWNER
      LOOP
         UPDATE ITFRMVAL
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITFRMVALOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITFRMVALD - Column "REF_OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITFRMVALDREFOWNER
      LOOP
         UPDATE ITFRMVALD
            SET REF_OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITFRMVALDREFOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITFRMVPG - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITFRMVPGOWNER
      LOOP
         UPDATE ITFRMVPG
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITFRMVPGOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITFRMVSC - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITFRMVSCOWNER
      LOOP
         UPDATE ITFRMVSC
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITFRMVSCOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITIMP_LOG - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITIMPLOGOWNER
      LOOP
         UPDATE ITIMP_LOG
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITIMPLOGOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITOIHS - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITOIHSOWNER
      LOOP
         UPDATE ITOIHS
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITOIHSOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITPROBJ - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITPROBJOWNER
      LOOP
         UPDATE ITPROBJ
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITPROBJOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITPROBJ_H - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITPROBJHOWNER
      LOOP
         UPDATE ITPROBJ_H
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITPROBJHOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITREPDATA - Column "REF_OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITREPDATAREFOWNER
      LOOP
         UPDATE ITREPDATA
            SET REF_OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITREPDATAREFOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITRTHS - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITRTHSOWNER
      LOOP
         UPDATE ITRTHS
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITRTHSOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITSHEXT - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITSHEXTREFOWNER
      LOOP
         UPDATE ITSHEXT
            SET REF_OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITSHEXTREFOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITSHVALD - Column "REF_OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITSHVALDREFOWNER
      LOOP
         UPDATE ITSHVALD
            SET REF_OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITSHVALDREFOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : SPEC_PREFIX_DESCR - Column "OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQSPECPREFIXDESCROWNER
      LOOP
         UPDATE SPEC_PREFIX_DESCR
            SET OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQSPECPREFIXDESCROWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : FT_FRAMES - Column "OLD_FRAME_OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQFTFRAMESOLDFRAMEOWNER
      LOOP
         UPDATE FT_FRAMES
            SET OLD_FRAME_OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQFTFRAMESOLDFRAMEOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : FT_FRAMES - Column "NEW_FRAME_OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQFTFRAMESNEWFRAMEOWNER
      LOOP
         UPDATE FT_FRAMES
            SET NEW_FRAME_OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQFTFRAMESNEWFRAMEOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : FT_FRAMES_H - Column "OLD_FRAME_OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQFTFRAMESHOLDFRAMEOWNER
      LOOP
         UPDATE FT_FRAMES_H
            SET OLD_FRAME_OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQFTFRAMESHOLDFRAMEOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : FT_FRAMES_H - Column "NEW_FRAME_OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQFTFRAMESHNEWFRAMEOWNER
      LOOP
         UPDATE FT_FRAMES_H
            SET NEW_FRAME_OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQFTFRAMESHNEWFRAMEOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : FT_SPEC_SECTION - Column "REF_OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQFTSPECSECTIONREFOWNER
      LOOP
         UPDATE FT_SPEC_SECTION
            SET REF_OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQFTSPECSECTIONREFOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITSHCMP - Column "REF_OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITSHCMPREFOWNER
      LOOP
         UPDATE ITSHCMP
            SET REF_OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITSHCMPREFOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITSHCMP - Column "REF_OWNER2"'
                 || LSOWNERS;

      FOR LNROW IN LQITSHCMPREFOWNER2
      LOOP
         UPDATE ITSHCMP
            SET REF_OWNER2 = ANNEWOWNERID
          WHERE CURRENT OF LQITSHCMPREFOWNER2;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITSHQ - Column "FRAME_OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITSHQFRAMEOWNER
      LOOP
         UPDATE ITSHQ
            SET FRAME_OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITSHQFRAMEOWNER;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITTSRESULTS - Column "REF_OWNER"'
                 || LSOWNERS;

      FOR LNROW IN LQITTSRESULTS
      LOOP
         UPDATE ITTSRESULTS
            SET REF_OWNER = ANNEWOWNERID
          WHERE CURRENT OF LQITTSRESULTS;
      END LOOP;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR :=    'TABLE : ITDBPROFILE - Column "OWNER"'
                 || LSOWNERS;

      UPDATE ITDBPROFILE
         SET OWNER = ANNEWOWNERID
       WHERE OWNER = ANOLDOWNERID
         AND NOT EXISTS( SELECT OWNER
                          FROM ITDBPROFILE
                         WHERE OWNER = ANNEWOWNERID );

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      LSERROR :=    'TABLE : ITPRMFC - Column "OBJECT_OWNER"'
                 || LSOWNERS;

      UPDATE ITPRMFC
         SET OBJECT_OWNER = ANNEWOWNERID
       WHERE OBJECT_OWNER = ANOLDOWNERID;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      LSERROR :=    'TABLE : ITPRMFC_H - Column "OBJECT_OWNER"'
                 || LSOWNERS;

      UPDATE ITPRMFC_H
         SET OBJECT_OWNER = ANNEWOWNERID
       WHERE OBJECT_OWNER = ANOLDOWNERID;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      LSERROR :=    'TABLE : IT_TR_JRNL - Column "OWNER"'
                 || LSOWNERS;

      UPDATE IT_TR_JRNL
         SET OWNER = ANNEWOWNERID
       WHERE OWNER = ANOLDOWNERID;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSERROR,
                           IAPICONSTANT.INFOLEVEL_3 );
      COMMIT;
      LSERROR := 'ENABLE CONSTRAINTS';
      
      LNRETVAL := IAPIDATABASE.ENABLECONSTRAINTS( );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RAISE_APPLICATION_ERROR( -20001,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                                  LSERROR
                               || SQLERRM );
         RAISE_APPLICATION_ERROR( -20001,
                                     LSERROR
                                  || SQLERRM );
   END RESETDATABASEOWNER;

   
   PROCEDURE REPLACEPREFIX(
      ASOLDPREFIX                IN       IAPITYPE.PREFIX_TYPE,
      ASNEWPREFIX                IN       IAPITYPE.PREFIX_TYPE,
      ASPADDINGCHARACTER         IN       IAPITYPE.STRINGVAL_TYPE )
   IS
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ReplacePrefix';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;

      CURSOR C1
      IS
         SELECT TABLE_NAME,
                COLUMN_NAME
           FROM USER_TAB_COLUMNS
          WHERE UPPER( COLUMN_NAME ) LIKE '%PART_NO%';

      CURSOR LQSPECPREFIX
      IS
         SELECT 'X'
           FROM SPEC_PREFIX
          WHERE PREFIX = TRIM( ASOLDPREFIX );

      L_OLD_PREF                    SPEC_PREFIX.PREFIX%TYPE;
      L_NEW_PREF                    SPEC_PREFIX.PREFIX%TYPE;

      TYPE PARTLIST IS TABLE OF VARCHAR2( 18 );

      L_PART_NO                     PARTLIST;
      STMT                          VARCHAR2( 2000 );
      STMT1                         VARCHAR2( 2000 );
      STMT2                         VARCHAR2( 200 );
      N_RET                         NUMBER( 2 );
      N_RET_2                       NUMBER( 2 );
      L_NEW_PART_NO                 VARCHAR2( 18 );
      L_OLD_PART_NO                 PARTLIST;
      L_TABLE_NAME                  USER_TAB_COLUMNS.TABLE_NAME%TYPE;
      LSDUMMY                       VARCHAR2( 1 );
      LEDONOTHING                   EXCEPTION;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of PROCEDURE',
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN LQSPECPREFIX;

      FETCH LQSPECPREFIX
       INTO LSDUMMY;

      IF LQSPECPREFIX%NOTFOUND
      THEN
         CLOSE LQSPECPREFIX;

         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                                  'Specification Prefix '
                               || ASOLDPREFIX
                               || ' Not Found.' );
         RAISE LEDONOTHING;
      ELSE
         CLOSE LQSPECPREFIX;
      END IF;

      LNRETVAL := IAPISPECDATASERVER.STOPSPECSERVER;

      UPDATE INTERSPC_CFG
         SET PARAMETER_DATA = 'DISABLED'
       WHERE SECTION = 'Specserver'
         AND PARAMETER = 'STATUS';

      COMMIT;
      DBMS_ALERT.SIGNAL( 'MAIL',
                         '2' );
      COMMIT;
      LNRETVAL := IAPIDATABASE.DISABLETRIGGERS;
      LNRETVAL := IAPIDATABASE.DISABLECONSTRAINTS;

      UPDATE SPEC_PREFIX
         SET PREFIX = TRIM( ASNEWPREFIX )
       WHERE PREFIX = TRIM( ASOLDPREFIX );

      FOR I IN C1
      LOOP
         BEGIN
            STMT :=
                  'SELECT DISTINCT '
               || I.COLUMN_NAME
               || ' FROM '
               || I.TABLE_NAME
               || ' WHERE SUBSTR ( '
               || I.COLUMN_NAME
               || ',1, INSTR( '
               || I.COLUMN_NAME
               || ', TRIM( '''
               || ASPADDINGCHARACTER
               || ''' ),1,1) -1) = TRIM( '''
               || ASOLDPREFIX
               || ''' )';

            EXECUTE IMMEDIATE STMT
            BULK COLLECT INTO L_PART_NO;

            FOR J IN 1 .. L_PART_NO.COUNT
            LOOP
               STMT1 :=
                     'UPDATE '
                  || I.TABLE_NAME
                  || ' SET '
                  || I.COLUMN_NAME
                  || ' = '''
                  || ASNEWPREFIX
                  || ASPADDINGCHARACTER
                  || '''|| SUBSTR ( '
                  || I.COLUMN_NAME
                  || ', INSTR ( '
                  || I.COLUMN_NAME
                  || ','''
                  || ASPADDINGCHARACTER
                  || ''', 1, 1 ) + 1 )'
                  || ' WHERE '
                  || I.COLUMN_NAME
                  || ' = '''
                  || L_PART_NO( J )
                  || '''';
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                    STMT1 );

               EXECUTE IMMEDIATE STMT1;
            END LOOP;
         END;
      END LOOP;

      LNRETVAL := IAPIDATABASE.ENABLETRIGGERS;
      LNRETVAL := IAPIDATABASE.ENABLECONSTRAINTS( );
      LNRETVAL := IAPISPECDATASERVER.STARTSPECSERVER;

      UPDATE INTERSPC_CFG
         SET PARAMETER_DATA = 'ENABLED'
       WHERE SECTION = 'Specserver'
         AND PARAMETER = 'STATUS';

      COMMIT;
   EXCEPTION
      WHEN LEDONOTHING
      THEN
         NULL;
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
   END REPLACEPREFIX;

   
   FUNCTION UPDATESTRING(
      ASOLDVALUE                 IN       IAPITYPE.STRINGVAL_TYPE,
      ASNEWVALUE                 IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      CURSOR C1
      IS
         SELECT   TABLE_NAME,
                  COLUMN_NAME,
                  DATA_TYPE
             FROM USER_TAB_COLUMNS
            WHERE DATA_TYPE IN( 'CHAR', 'VARCHAR2', 'LONG', 'CLOB' )
         ORDER BY TABLE_NAME;

      TYPE STR IS TABLE OF VARCHAR2( 4000 );

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'UpdateString';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      STMT                          VARCHAR2( 200 );
      STMT1                         VARCHAR2( 200 );
      N_RET                         NUMBER( 2 );
      OBJ_STR                       STR;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIDATABASE.DISABLECONSTRAINTS;

      FOR I IN C1
      LOOP
         STMT :=    'SELECT '
                 || I.COLUMN_NAME
                 || ' FROM '
                 || I.TABLE_NAME;

         EXECUTE IMMEDIATE STMT
         BULK COLLECT INTO OBJ_STR;

         FOR J IN 1 .. OBJ_STR.COUNT
         LOOP
            SELECT INSTR( OBJ_STR( J ),
                          ASOLDVALUE,
                          1,
                          1 )
              INTO N_RET
              FROM DUAL;

            IF N_RET != 0
            THEN
               STMT1 :=
                     'UPDATE '
                  || I.TABLE_NAME
                  || ' SET '
                  || I.COLUMN_NAME
                  || '= REPLACE('
                  || I.COLUMN_NAME
                  || ','
                  || ''''
                  || ASOLDVALUE
                  || ''''
                  || ','
                  || ''''
                  || ASNEWVALUE
                  || ''''
                  || ')'
                  || ' WHERE TRIM('
                  || I.COLUMN_NAME
                  || ') ='
                  || ''''
                  || ASOLDVALUE
                  || '''';

               EXECUTE IMMEDIATE STMT1;
            END IF;
         END LOOP;
      END LOOP;

      COMMIT;
      LNRETVAL := IAPIDATABASE.ENABLECONSTRAINTS;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END UPDATESTRING;

   
   FUNCTION CLASSCONFIGCHECK
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ClassConfigCheck';
      LBERROR                       BOOLEAN := FALSE;
      LNCOUNT                       NUMBER;

      CURSOR LQTREE
      IS
         SELECT     PID,
                    CID,
                    CCNT,
                    LEVEL,
                    DESCR
               FROM ITCLTV
         START WITH PID = 0
         CONNECT BY PRIOR CID = PID;

      CURSOR LQNODE
      IS
         SELECT NODE
           FROM ITCLD;

      CURSOR LQTYPE
      IS
         SELECT DISTINCT TYPE
                    FROM ITCLTV
                   WHERE TYPE NOT IN( SELECT NODE
                                       FROM ITCLD );

      CURSOR LQMATCLASSMISSING
      IS
         ( SELECT PID ID,
                  'ITCLTV' TBL,
                  'PID' COL
            FROM ITCLTV
           WHERE PID <> 0
          MINUS
          SELECT IDENTIFIER,
                 'ITCLTV' TBL,
                 'PID' COL
            FROM MATERIAL_CLASS )
         UNION
         ( SELECT CID ID,
                  'ITCLTV' TBL,
                  'CID' COL
            FROM ITCLTV
          MINUS
          SELECT IDENTIFIER,
                 'ITCLTV' TBL,
                 'CID' COL
            FROM MATERIAL_CLASS )
         UNION
         ( SELECT ATTRIBUTE_ID ID,
                  'ITCLAT' TBL,
                  'ATTRIBUTE_ID' COL
            FROM ITCLAT
          MINUS
          SELECT IDENTIFIER,
                 'ITCLAT' TBL,
                 'ATTRIBUTE_ID' COL
            FROM MATERIAL_CLASS )
         UNION
         ( SELECT PID ID,
                  'ITCLCLF' TBL,
                  'PID' COL
            FROM ITCLCLF
           WHERE PID <> 0
          MINUS
          SELECT IDENTIFIER,
                 'ITCLCLF' TBL,
                 'PID' COL
            FROM MATERIAL_CLASS )
         UNION
         ( SELECT CID ID,
                  'ITCLCLF' TBL,
                  'CID' COL
            FROM ITCLCLF
          MINUS
          SELECT IDENTIFIER,
                 'ITCLCLF' TBL,
                 'CID' COL
            FROM MATERIAL_CLASS );

      CURSOR LQMATCLASSNOTUSED
      IS
         SELECT IDENTIFIER ID
           FROM MATERIAL_CLASS
         MINUS
         ( SELECT PID
            FROM ITCLTV
          UNION
          SELECT CID
            FROM ITCLTV
          UNION
          SELECT PID
            FROM ITCLCLF
          UNION
          SELECT CID
            FROM ITCLCLF
          UNION
          SELECT ATTRIBUTE_ID
            FROM ITCLAT );

      CURSOR LQCODE
      IS
         ( SELECT CODE,
                  'ITCLTV' TBL
            FROM ITCLTV
          MINUS
          SELECT CODE,
                 'ITCLTV'
            FROM MATERIAL_CLASS )
         UNION
         ( SELECT CODE,
                  'ITCLAT'
            FROM ITCLAT
          MINUS
          SELECT CODE,
                 'ITCLAT'
            FROM MATERIAL_CLASS );

      CURSOR LQSUBTREE
      IS
         SELECT ATTRIBUTE_ID
           FROM ITCLAT
          WHERE TYPE = 'TV'
         MINUS
         SELECT ID
           FROM ITCLD;

      CURSOR LQATTRIBUTES
      IS
         SELECT ID
           FROM ITCLCLF
         MINUS
         SELECT ATTRIBUTE_ID
           FROM ITCLAT;

      CURSOR LQTREEID
      IS
         SELECT TREE_ID
           FROM ITCLAT
         MINUS
         SELECT ID
           FROM ITCLD;
   BEGIN
      
      FOR LRTREE IN LQTREE
      LOOP
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM ITCLTV
          WHERE PID = LRTREE.CID;

         IF LRTREE.CCNT <> LNCOUNT
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                     'PID '
                                  || LRTREE.PID
                                  || ' - CID '
                                  || LRTREE.CID
                                  || ' ('
                                  || LRTREE.DESCR
                                  || ') has '
                                  || LRTREE.CCNT
                                  || ' childs configured but '
                                  || LNCOUNT
                                  || ' are actually found.' );
            LBERROR := TRUE;
         END IF;
      END LOOP;

      
      FOR LRNODE IN LQNODE
      LOOP
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM ITCLTV
          WHERE TYPE = LRNODE.NODE;

         IF LNCOUNT = 0
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                     'No entry in ITCLTV for base node '
                                  || LRNODE.NODE );
            LBERROR := TRUE;
         END IF;

         SELECT COUNT( * )
           INTO LNCOUNT
           FROM MATERIAL_CLASS
          WHERE CODE = LRNODE.NODE;

         IF LNCOUNT = 0
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                     'No entry in MATERIAL_CLASS for base node '
                                  || LRNODE.NODE );
            LBERROR := TRUE;
         END IF;
      END LOOP;

      
      FOR LRTYPE IN LQTYPE
      LOOP
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                                  'ITCLTV - There is no entry in itcld for node '
                               || LRTYPE.TYPE );
         LBERROR := TRUE;
      END LOOP;

      
      FOR LRMATCLASSMISSING IN LQMATCLASSMISSING
      LOOP
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                                  'value '
                               || LRMATCLASSMISSING.ID
                               || ' in column '
                               || LRMATCLASSMISSING.COL
                               || ' of table '
                               || LRMATCLASSMISSING.TBL
                               || ' not found in MATERIAL_CLASS, column IDENTIFIER' );
      END LOOP;

      
      FOR LRMATCLASSNOTUSED IN LQMATCLASSNOTUSED
      LOOP
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                                  'Identifier '
                               || LRMATCLASSNOTUSED.ID
                               || ' in MATERIAL_CLASS not used.' );
      END LOOP;

      
      FOR LRCODE IN LQCODE
      LOOP
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                                  'Code '
                               || LRCODE.CODE
                               || ' in '
                               || LRCODE.TBL
                               || ' not found in MATERIAL_CLASS, column CODE' );
      END LOOP;

      
      FOR LRSUBTREE IN LQSUBTREE
      LOOP
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                                  'Sub Tree '
                               || LRSUBTREE.ATTRIBUTE_ID
                               || ' defined in ITCLAT not defined as tree in ITCLD' );
      END LOOP;

      
      FOR LRATTRIBUTES IN LQATTRIBUTES
      LOOP
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                                  'ITCLCLF, column ID: '
                               || LRATTRIBUTES.ID
                               || ' is not defined as attribute_id in ITCLAT' );
      END LOOP;

      
      FOR LRTREEID IN LQTREEID
      LOOP
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                                  'Tree ID '
                               || LRTREEID.TREE_ID
                               || ' in ITCLAT is not a valid tree ID' );
      END LOOP;

      IF LBERROR
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      ELSE
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CLASSCONFIGCHECK;

   
   FUNCTION CLASSSPECCHECK
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ClassSpecCheck';
      LSBASENODE                    IAPITYPE.CLASSIFICATIONCODE_TYPE;
      LSTYPE                        VARCHAR2( 2 );
      LNID                          NUMBER;
      LNPID                         NUMBER;
      LNCID                         NUMBER;
      LNTREEID                      NUMBER;
      LNCOUNT                       NUMBER;
      LBERROR                       BOOLEAN := FALSE;

      CURSOR LQPARTS
      IS
         SELECT DISTINCT PART_NO
                    FROM ITPRCL;

      CURSOR LQCL(
         ASPARTNO                            VARCHAR2 )
      IS
         SELECT   HIER_LEVEL,
                  MATL_CLASS_ID
             FROM ITPRCL
            WHERE PART_NO = ASPARTNO
              AND CODE <> TYPE
              AND TYPE NOT IN( SELECT CODE
                                FROM ITCLAT
                               WHERE TYPE = 'TV' )
         ORDER BY HIER_LEVEL;

      CURSOR LQCLTV(
         ASPARTNO                            VARCHAR2,
         ASCODE                              VARCHAR2 )
      IS
         SELECT   HIER_LEVEL,
                  MATL_CLASS_ID
             FROM ITPRCL
            WHERE PART_NO = ASPARTNO
              AND CODE = ASCODE
         ORDER BY HIER_LEVEL;

      CURSOR LQCLAT(
         ASPARTNO                            VARCHAR2 )
      IS
         SELECT CODE,
                MATL_CLASS_ID
           FROM ITPRCL
          WHERE PART_NO = ASPARTNO
            AND CODE = TYPE;
   BEGIN
      
      FOR LRPART IN LQPARTS
      LOOP
         
         BEGIN
            SELECT D.NODE,
                   D.ID
              INTO LSBASENODE,
                   LNTREEID
              FROM PART P,
                   CLASS3 C,
                   ITCLD D
             WHERE C.CLASS = P.PART_TYPE
               AND P.PART_NO = LRPART.PART_NO
               AND D.SPEC_GROUP = C.TYPE;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                        'No classification tree found for classified part number '
                                     || LRPART.PART_NO );
               LBERROR := TRUE;
         END;

         
         LNPID := 0;

         FOR LRCL IN LQCL( LRPART.PART_NO )
         LOOP
            
            SELECT COUNT( * )
              INTO LNCOUNT
              FROM ITCLTV
             WHERE TYPE = LSBASENODE
               AND PID = LNPID
               AND CID = LRCL.MATL_CLASS_ID;

            IF LNCOUNT = 0
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                        'Part '
                                     || LRPART.PART_NO
                                     || ' -> Treeview link PID = '
                                     || LNPID
                                     || ' AND CID = '
                                     || LRCL.MATL_CLASS_ID
                                     || ' does not exist in ITCLTV for treeview '
                                     || LSBASENODE );
               LBERROR := TRUE;
            END IF;

            LNPID := LRCL.MATL_CLASS_ID;
         END LOOP;

         
         SELECT COUNT( * )
           INTO LNCOUNT
           FROM ITCLTV
          WHERE TYPE = LSBASENODE
            AND PID = LNPID;

         IF LNCOUNT > 0
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                     'Part '
                                  || LRPART.PART_NO
                                  || ' not completely classified for tree '
                                  || LSBASENODE );
            LBERROR := TRUE;
         END IF;

         
         LNPID := F_GET_ATT_KEY( LNPID );

         
         FOR LRCLAT IN LQCLAT( LRPART.PART_NO )
         LOOP
            
            BEGIN
               SELECT ATTRIBUTE_ID,
                      TYPE,
                      TREE_ID
                 INTO LNID,
                      LSTYPE,
                      LNTREEID
                 FROM ITCLAT
                WHERE TREE_ID = LNTREEID
                  AND CODE = LRCLAT.CODE;

               IF LSTYPE = 'DD'
               THEN
                  
                  LNCID := LRCLAT.MATL_CLASS_ID;

                  SELECT COUNT( * )
                    INTO LNCOUNT
                    FROM ITCLCLF
                   WHERE ID = LNID
                     AND PID = LNPID
                     AND CID = LNCID;

                  IF LNCOUNT = 0
                  THEN
                     IAPIGENERAL.LOGERROR( GSSOURCE,
                                           LSMETHOD,
                                              'Part '
                                           || LRPART.PART_NO
                                           || ' has invalid descriptor value '
                                           || LNCID
                                           || ' for attribute '
                                           || LNID );
                     LBERROR := TRUE;
                  END IF;
               ELSE
                  
                  BEGIN
                     SELECT NODE
                       INTO LSBASENODE
                       FROM ITCLD
                      WHERE ID = LNTREEID;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        IAPIGENERAL.LOGERROR( GSSOURCE,
                                              LSMETHOD,
                                                 'Part '
                                              || LRPART.PART_NO
                                              || ' -> Classification tree '
                                              || LNTREEID
                                              || ' not found' );
                  END;

                  
                  LNPID := 0;

                  FOR LRCLTV IN LQCLTV( LRPART.PART_NO,
                                        LRCLAT.CODE )
                  LOOP
                     
                     SELECT COUNT( * )
                       INTO LNCOUNT
                       FROM ITCLTV
                      WHERE TYPE = LSBASENODE
                        AND PID = LNPID
                        AND CID = LRCLTV.MATL_CLASS_ID;

                     IF LNCOUNT = 0
                     THEN
                        IAPIGENERAL.LOGERROR( GSSOURCE,
                                              LSMETHOD,
                                                 'Part '
                                              || LRPART.PART_NO
                                              || ' -> Treeview link PID = '
                                              || LNPID
                                              || ' AND CID = '
                                              || LRCLTV.MATL_CLASS_ID
                                              || ' does not exist in ITCLTV for treeview '
                                              || LSBASENODE );
                        LBERROR := TRUE;
                     END IF;

                     LNPID := LRCLTV.MATL_CLASS_ID;
                  END LOOP;

                  
                  SELECT COUNT( * )
                    INTO LNCOUNT
                    FROM ITCLTV
                   WHERE TYPE = LSBASENODE
                     AND PID = LNPID;

                  IF LNCOUNT > 0
                  THEN
                     IAPIGENERAL.LOGERROR( GSSOURCE,
                                           LSMETHOD,
                                              'Part '
                                           || LRPART.PART_NO
                                           || ' not completely classified for tree '
                                           || LSBASENODE );
                     LBERROR := TRUE;
                  END IF;
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                           'Part '
                                        || LRPART.PART_NO
                                        || ' -> Code '
                                        || LRCLAT.CODE
                                        || ' is not defined in ITCLAT' );
                  LBERROR := TRUE;
            END;

            SELECT COUNT( * )
              INTO LNCOUNT
              FROM MATERIAL_CLASS
             WHERE CODE = LRCLAT.CODE;

            IF LNCOUNT = 0
            THEN
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                        'Part '
                                     || LRPART.PART_NO
                                     || ' -> Code '
                                     || LRCLAT.CODE
                                     || ' is not defined in MATERIAL_CLASS' );
               LBERROR := TRUE;
            END IF;
         END LOOP;
      END LOOP;

      IF LBERROR
      THEN
         RETURN( IAPICONSTANTDBERROR.DBERR_GENFAIL );
      ELSE
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CLASSSPECCHECK;

   
   FUNCTION CLASSIFICATIONCHECK(
      ANDATATYPE                 IN       IAPITYPE.NUMVAL_TYPE DEFAULT 1 )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ClassificationCheck';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      
      
      IF ANDATATYPE = 1
      THEN
         LNRETVAL := CLASSCONFIGCHECK( );
      ELSIF ANDATATYPE = 2
      THEN
         LNRETVAL := CLASSSPECCHECK( );
      ELSE
         
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               'Invalid data type' );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END IF;

      RETURN( LNRETVAL );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END CLASSIFICATIONCHECK;

   FUNCTION GETARGUMENTTYPE(
      ASOWNER                    IN       IAPITYPE.STRINGVAL_TYPE,
      ASPACKAGENAME              IN       IAPITYPE.STRINGVAL_TYPE,
      ASFUNCTIONNAME             IN       IAPITYPE.STRINGVAL_TYPE,
      ASARGUMENTNAME             IN       IAPITYPE.STRINGVAL_TYPE,
      ANOVERLOAD                 IN       IAPITYPE.NUMVAL_TYPE DEFAULT 0 )
      RETURN IAPITYPE.STRINGVAL_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      RETVAL                        IAPITYPE.STRING_TYPE;
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetArgumentType';

      CURSOR LCLINES(
         POWNER                              IAPITYPE.STRINGVAL_TYPE,
         PPACKAGENAME                        IAPITYPE.STRINGVAL_TYPE,
         PFUNCTIONNAME                       IAPITYPE.STRINGVAL_TYPE )
      IS
         SELECT LINE
           FROM ALL_SOURCE S
          WHERE OWNER = POWNER
            AND TYPE = 'PACKAGE'
            AND NAME = PPACKAGENAME
            AND TRIM( TEXT ) LIKE 'FUNCTION %'
            AND UPPER( REPLACE( REPLACE( TRIM( REPLACE( TRIM( REPLACE( TRIM( REPLACE( S.TEXT,
                                                                                      'FUNCTION' ) ),
                                                                       'RETURN' ) ),
                                                        CHR( 10 ) ) ),
                                         ';' ),
                                '(' ) ) LIKE    '%'
                                             || PFUNCTIONNAME
                                             || '%';

      TYPE LTLINESTABLE IS TABLE OF LCLINES%ROWTYPE
         INDEX BY BINARY_INTEGER;

      LTLINES                       LTLINESTABLE;
      LOVERLOAD                     IAPITYPE.NUMVAL_TYPE;
      LSTARTLINE                    IAPITYPE.NUMVAL_TYPE;
      LENDLINE                      IAPITYPE.NUMVAL_TYPE;
   BEGIN
      BEGIN
         
         OPEN LCLINES( ASOWNER,
                       ASPACKAGENAME,
                       ASFUNCTIONNAME );

         FETCH LCLINES
         BULK COLLECT INTO LTLINES;

         CLOSE LCLINES;
      EXCEPTION
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    'No Start Line Found for function'
                                 || ASPACKAGENAME
                                 || '.'
                                 || ASFUNCTIONNAME
                                 || '('
                                 || ANOVERLOAD
                                 || ')',
                                 IAPICONSTANT.INFOLEVEL_3 );
            RETURN NULL;
      END;

      LOVERLOAD := NVL( ANOVERLOAD,
                        0 );


      IF ( LTLINES.COUNT > LOVERLOAD )
      THEN
         LSTARTLINE := LTLINES(   LOVERLOAD
                                + 1 ).LINE;
      END IF;

      IF ( LSTARTLINE IS NOT NULL )
      THEN
         
         BEGIN
            SELECT   MIN( LINE )
                INTO LENDLINE
                FROM ALL_SOURCE S
               WHERE OWNER = ASOWNER
                 AND TYPE = 'PACKAGE'
                 AND NAME = ASPACKAGENAME
                 AND UPPER( TEXT ) LIKE '%RETURN%%'
                 AND LINE > LSTARTLINE
            ORDER BY NAME,
                     LINE;
         EXCEPTION
            WHEN OTHERS
            THEN
               IAPIGENERAL.LOGINFO( GSSOURCE,
                                    LSMETHOD,
                                       'No End Line Found for function'
                                    || ASPACKAGENAME
                                    || '.'
                                    || ASFUNCTIONNAME
                                    || '('
                                    || ANOVERLOAD
                                    || ')',
                                    IAPICONSTANT.INFOLEVEL_3 );
               RETURN NULL;
         END;

         IF ( LENDLINE IS NOT NULL )
         THEN
            
            BEGIN
               IF ( ASARGUMENTNAME IS NOT NULL )
               THEN
                  SELECT   TRIM( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( REPLACE( UPPER( TEXT ),
                                                                                                         CHR( 10 ) ),
                                                                                                ASARGUMENTNAME ),
                                                                                       ' IN ' ),
                                                                              ' OUT ' ),
                                                                     ' INOUT ' ),
                                                            ',' ),
                                                   ',' ),
                                          ')' ) )
                      INTO RETVAL
                      FROM ALL_SOURCE S
                     WHERE OWNER = ASOWNER
                       AND TYPE = 'PACKAGE'
                       AND NAME = ASPACKAGENAME
                       AND LINE > LSTARTLINE
                       AND LINE < LENDLINE
                       AND UPPER( TEXT ) LIKE    '% '
                                              || ASARGUMENTNAME
                                              || ' %'
                  ORDER BY NAME,
                           LINE;
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  IAPIGENERAL.LOGINFO( GSSOURCE,
                                       LSMETHOD,
                                          'No declaration Found for argument '
                                       || ASARGUMENTNAME
                                       || ' of function'
                                       || ASPACKAGENAME
                                       || '.'
                                       || ASFUNCTIONNAME
                                       || '('
                                       || ANOVERLOAD
                                       || ')',
                                       IAPICONSTANT.INFOLEVEL_3 );
                  RETURN NULL;
            END;
         ELSE
            IAPIGENERAL.LOGINFO( GSSOURCE,
                                 LSMETHOD,
                                    'No End Line Found for function'
                                 || ASPACKAGENAME
                                 || '.'
                                 || ASFUNCTIONNAME
                                 || '('
                                 || ANOVERLOAD
                                 || ')',
                                 IAPICONSTANT.INFOLEVEL_3 );
            RETURN NULL;
         END IF;
      ELSE
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'No Start Line Found for function'
                              || ASPACKAGENAME
                              || '.'
                              || ASFUNCTIONNAME
                              || '('
                              || ANOVERLOAD
                              || ')',
                              IAPICONSTANT.INFOLEVEL_3 );
         RETURN NULL;
      END IF;

      RETURN RETVAL;
   END GETARGUMENTTYPE;
END IAPIUTILITIES;
CREATE OR REPLACE PACKAGE BODY iapiPartManufacturer
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

   
   
   

   
   
   
   
   FUNCTION GETBASECOLUMNS(
      ASALIAS                    IN       IAPITYPE.STRING_TYPE DEFAULT '' )
      RETURN VARCHAR2
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetBaseColumns';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LCBASECOLUMNS                 IAPITYPE.SQLSTRING_TYPE := NULL;
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
         || 'part_no '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ','
         || LSALIAS
         || 'mfc_id '
         || IAPICONSTANTCOLUMN.MANUFACTURERIDCOL
         || ','
         || 'f_mfh_descr(itprmfc.mfc_id) '
         || IAPICONSTANTCOLUMN.MANUFACTURERCOL
         || ','
         || LSALIAS
         || 'mpl_id '
         || IAPICONSTANTCOLUMN.MANUFACTURERPLANTNOCOL
         || ','
         || 'f_mpl_descr(itprmfc.mpl_id) '
         || IAPICONSTANTCOLUMN.MANUFACTURERPLANTCOL
         || ','
         || LSALIAS
         || 'clearance_no '
         || IAPICONSTANTCOLUMN.CLEARANCENUMBERCOL
         || ','
         || 'trade_name '
         || IAPICONSTANTCOLUMN.TRADENAMECOL
         || ','
         || LSALIAS
         || 'audit_date '
         || IAPICONSTANTCOLUMN.AUDITDATECOL
         || ','
         || LSALIAS
         || 'audit_freq '
         || IAPICONSTANTCOLUMN.AUDITFREQUENCECOL
         || ','
         || LSALIAS
         || 'intl '
         || IAPICONSTANTCOLUMN.INTERNATIONALCOL
         || ','
         || ' itmfc.mtp_id '
         || IAPICONSTANTCOLUMN.MTPIDCOL
         || ','
         || LSALIAS
         || 'product_code '
         || IAPICONSTANTCOLUMN.PRODUCTCODECOL
         || ','
         || LSALIAS
         || 'approval_date '
         || IAPICONSTANTCOLUMN.APPROVALDATECOL
         || ','
         || LSALIAS
         || 'revision '
         || IAPICONSTANTCOLUMN.PARTMANUFACTURERREVISIONCOL
         || ','
         || LSALIAS
         || 'object_id '
         || IAPICONSTANTCOLUMN.OBJECTIDCOL
         || ','
         || LSALIAS
         || 'object_revision '
         || IAPICONSTANTCOLUMN.OBJECTREVISIONCOL
         || ','
         || LSALIAS
         || 'object_owner '
         || IAPICONSTANTCOLUMN.OBJECTOWNERCOL
         || ','
         || ' DECODE(itprmfc.object_id, NULL, NULL, f_oih_descr(1,itprmfc.object_id, itprmfc.object_owner) || '' ['' || itprmfc.object_revision || '']'') '
         || IAPICONSTANTCOLUMN.OBJECTCOL;
      RETURN( LCBASECOLUMNS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETBASECOLUMNS;

   
   
   
   
   FUNCTION GETMANUFACTURERS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      AQMANUFACTURERS            OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetManufacturers';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETBASECOLUMNS( 'itprmfc' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'itprmfc, itmfc';
   BEGIN
      
      
      
      
      
      IF ( AQMANUFACTURERS%ISOPEN )
      THEN
         CLOSE AQMANUFACTURERS;
      END IF;

      LSSQLNULL :=    'SELECT '
                   || LSSELECT
                   || ' FROM '
                   || LSFROM
                   || ' WHERE itprmfc.part_no = null AND itprmfc.mfc_id = itmfc.mfc_id';

      OPEN AQMANUFACTURERS FOR LSSQLNULL;

      
      
      
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

      
      IF ( AQMANUFACTURERS%ISOPEN )
      THEN
         CLOSE AQMANUFACTURERS;
      END IF;

      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM
               || ' WHERE itprmfc.part_no = :PartNo '
               || ' AND itprmfc.mfc_id = itmfc.mfc_id';

      
      IF ( AQMANUFACTURERS%ISOPEN )
      THEN
         CLOSE AQMANUFACTURERS;
      END IF;

      
      OPEN AQMANUFACTURERS FOR LSSQL USING ASPARTNO;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETMANUFACTURERS;

   
   FUNCTION ADDMANUFACTURER(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANMANUFACTURERID           IN       IAPITYPE.ID_TYPE,
      ASMANUFACTURERPLANTNO      IN       IAPITYPE.MANUFACTURERPLANTNO_TYPE,
      ASPRODUCTCODE              IN       IAPITYPE.PRODUCTCODE_TYPE,
      ADAPPROVALDATE             IN       IAPITYPE.DATE_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANOBJECTID                 IN       IAPITYPE.ID_TYPE,
      ANOBJECTREVISION           IN       IAPITYPE.REVISION_TYPE,
      ANOBJECTOWNER              IN       IAPITYPE.OWNER_TYPE,
      ASCLEARANCENO              IN       IAPITYPE.CLEARANCENUMBER_TYPE DEFAULT NULL,
      ASTRADENAME                IN       IAPITYPE.TRADENAME_TYPE DEFAULT NULL,
      ADAUDITDATE                IN       IAPITYPE.DATE_TYPE DEFAULT NULL,
      ANAUDITFREQUENCY           IN       IAPITYPE.AUDITFREQUENCE_TYPE DEFAULT NULL,
      ANINTERNATIONAL            IN       IAPITYPE.INTL_TYPE DEFAULT 0,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'AddManufacturer';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      
      
      
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

      
      
      LNRETVAL := IAPIMANUFACTURER.EXISTID( ANMANUFACTURERID );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                              IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      
      LNRETVAL := IAPIMANUFACTURERPLANT.EXISTID( ASMANUFACTURERPLANTNO,
                                                 ANMANUFACTURERID );

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

      BEGIN
         INSERT INTO ITPRMFC
                     ( PART_NO,
                       MFC_ID,
                       MPL_ID,
                       CLEARANCE_NO,
                       TRADE_NAME,
                       AUDIT_DATE,
                       AUDIT_FREQ,
                       INTL,
                       PRODUCT_CODE,
                       APPROVAL_DATE,
                       REVISION,
                       OBJECT_ID,
                       OBJECT_REVISION,
                       OBJECT_OWNER )
              VALUES ( ASPARTNO,
                       ANMANUFACTURERID,
                       ASMANUFACTURERPLANTNO,
                       ASCLEARANCENO,
                       ASTRADENAME,
                       ADAUDITDATE,
                       ANAUDITFREQUENCY,
                       ANINTERNATIONAL,
                       ASPRODUCTCODE,
                       ADAPPROVALDATE,
                       ANREVISION,
                       ANOBJECTID,
                       ANOBJECTREVISION,
                       ANOBJECTOWNER );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                        LSMETHOD,
                                                        IAPICONSTANTDBERROR.DBERR_DUPLICATEPARTMFC,
                                                        ASPARTNO,
                                                        ANMANUFACTURERID,
                                                        ASMANUFACTURERPLANTNO ) );
         WHEN OTHERS
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  SQLERRM );
            RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
      END;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PostConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ADDMANUFACTURER;

   
   FUNCTION REMOVEMANUFACTURER(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANMANUFACTURERID           IN       IAPITYPE.ID_TYPE,
      ASMANUFACTURERPLANTNO      IN       IAPITYPE.MANUFACTURERPLANTNO_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RemoveManufacturer';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      DELETE FROM ITPRMFC
            WHERE PART_NO = ASPARTNO
              AND MFC_ID = ANMANUFACTURERID
              AND MPL_ID = ASMANUFACTURERPLANTNO;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_PARTMFCNOTFOUND,
                                                     ASPARTNO,
                                                     ANMANUFACTURERID,
                                                     ASMANUFACTURERPLANTNO ) );
      END IF;

      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Delete PartNo <'
                           || ASPARTNO
                           || '> '
                           || 'ManufacturerId <'
                           || ANMANUFACTURERID
                           || '> '
                           || 'ManufacturerPlantNo <'
                           || ASMANUFACTURERPLANTNO
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PostConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END REMOVEMANUFACTURER;

   
   FUNCTION SAVEMANUFACTURER(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANMANUFACTURERID           IN       IAPITYPE.ID_TYPE,
      ASMANUFACTURERPLANTNO      IN       IAPITYPE.MANUFACTURERPLANTNO_TYPE,
      ASPRODUCTCODE              IN       IAPITYPE.PRODUCTCODE_TYPE,
      ADAPPROVALDATE             IN       IAPITYPE.DATE_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANOBJECTID                 IN       IAPITYPE.ID_TYPE,
      ANOBJECTREVISION           IN       IAPITYPE.REVISION_TYPE,
      ANOBJECTOWNER              IN       IAPITYPE.OWNER_TYPE,
      ASCLEARANCENO              IN       IAPITYPE.CLEARANCENUMBER_TYPE DEFAULT NULL,
      ASTRADENAME                IN       IAPITYPE.TRADENAME_TYPE DEFAULT NULL,
      ADAUDITDATE                IN       IAPITYPE.DATE_TYPE DEFAULT NULL,
      ANAUDITFREQUENCY           IN       IAPITYPE.AUDITFREQUENCE_TYPE DEFAULT NULL,
      ANINTERNATIONAL            IN       IAPITYPE.INTL_TYPE DEFAULT 0,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SaveManufacturer';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      
      
      IF ( AQERRORS%ISOPEN )
      THEN
         CLOSE AQERRORS;
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Initialize parameters',
                           IAPICONSTANT.INFOLEVEL_3 );
      GTERRORS.DELETE;
      LNRETVAL := IAPIGENERAL.TRANSFORMERRORLISTTOREFCURSOR( GTERRORS,
                                                             AQERRORS );
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      UPDATE ITPRMFC
         SET CLEARANCE_NO = ASCLEARANCENO,
             TRADE_NAME = ASTRADENAME,
             AUDIT_DATE = ADAUDITDATE,
             AUDIT_FREQ = ANAUDITFREQUENCY,
             INTL = ANINTERNATIONAL,
             PRODUCT_CODE = ASPRODUCTCODE,
             APPROVAL_DATE = ADAPPROVALDATE,
             REVISION = ANREVISION,
             OBJECT_ID = ANOBJECTID,
             OBJECT_REVISION = ANOBJECTREVISION,
             OBJECT_OWNER = ANOBJECTOWNER
       WHERE PART_NO = ASPARTNO
         AND MFC_ID = ANMANUFACTURERID
         AND MPL_ID = ASMANUFACTURERPLANTNO;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_PARTMFCNOTFOUND,
                                                     ASPARTNO,
                                                     ANMANUFACTURERID,
                                                     ASMANUFACTURERPLANTNO ) );
      END IF;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PostConditions',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SAVEMANUFACTURER;
END IAPIPARTMANUFACTURER;
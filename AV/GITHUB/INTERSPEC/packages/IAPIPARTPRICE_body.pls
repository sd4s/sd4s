CREATE OR REPLACE PACKAGE BODY iapiPartPrice
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

      LCBASECOLUMNS :=
            LSALIAS
         || 'part_no '
         || IAPICONSTANTCOLUMN.PARTNOCOL
         || ','
         || LSALIAS
         || 'period '
         || IAPICONSTANTCOLUMN.PERIODCOL
         || ','
         || LSALIAS
         || 'price_type '
         || IAPICONSTANTCOLUMN.PRICETYPECOL
         || ','
         || LSALIAS
         || 'uom '
         || IAPICONSTANTCOLUMN.UOMCOL
         || ','
         || LSALIAS
         || 'price '
         || IAPICONSTANTCOLUMN.PRICECOL
         || ','
         || LSALIAS
         || 'currency '
         || IAPICONSTANTCOLUMN.CURRENCYCOL
         || ','
         || LSALIAS
         || 'plant '
         || IAPICONSTANTCOLUMN.PLANTNOCOL;
      RETURN( LCBASECOLUMNS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETBASECOLUMNS;

   
   
   
   
   FUNCTION GETPRICES(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ATPLANTFILTER              IN       IAPITYPE.FILTERTAB_TYPE,
      AQPRICES                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPrices';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LRFILTER                      IAPITYPE.FILTERREC_TYPE;
      LSFILTER                      IAPITYPE.CLOB_TYPE := NULL;
      LSFILTERTOADD                 IAPITYPE.STRING_TYPE := NULL;
      LSSQL                         IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETBASECOLUMNS( 'pc' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'part_cost pc ';
   BEGIN
      
      
      
      
      
      IF ( AQPRICES%ISOPEN )
      THEN
         CLOSE AQPRICES;
      END IF;

      LSSQLNULL :=    'select '
                   || LSSELECT
                   || ' from '
                   || LSFROM
                   || ' where pc.part_no = null ';

      OPEN AQPRICES FOR LSSQLNULL;

      
      
      
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
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'Number of items in PlantFilter <'
                           || ATPLANTFILTER.COUNT
                           || '>',
                           IAPICONSTANT.INFOLEVEL_3 );

      FOR I IN 0 ..   ATPLANTFILTER.COUNT
                    - 1
      LOOP
         LRFILTER := ATPLANTFILTER( I );
         IAPIGENERAL.LOGINFO( GSSOURCE,
                              LSMETHOD,
                                 'PlantFilter ('
                              || I
                              || ') <'
                              || LRFILTER.LEFTOPERAND
                              || '> <'
                              || LRFILTER.OPERATOR
                              || '> <'
                              || LRFILTER.RIGHTOPERAND
                              || '>',
                              IAPICONSTANT.INFOLEVEL_3 );

         
         CASE LRFILTER.LEFTOPERAND
            WHEN IAPICONSTANTCOLUMN.PLANTNOCOL
            THEN
               LRFILTER.LEFTOPERAND := 'pp.plant';
            WHEN IAPICONSTANTCOLUMN.PLANTOBSOLETECOL
            THEN
               LRFILTER.LEFTOPERAND := 'pp.obsolete';
            ELSE
               LNRETVAL := IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                               LSMETHOD,
                                                               IAPICONSTANTDBERROR.DBERR_INVALIDFILTER,
                                                               LRFILTER.LEFTOPERAND );
               RETURN( LNRETVAL );
         END CASE;

         IF ( I = 0 )
         THEN
            
            LSFROM :=    LSFROM
                      || ', part_plant pp';

            IF ( LSFILTER IS NULL )
            THEN
               
               
               LSFILTER := 'pc.part_no = pp.part_no AND pc.plant = pp.plant AND ';
               
            ELSE
               LSFILTER :=    LSFILTER
                           
                           
                           || ' AND pc.part_no = pp.part_no AND pc.plant = pp.plant AND ';
                           
            END IF;
         ELSE
            LSFILTER :=    LSFILTER
                        || ' AND ';
         END IF;

         LRFILTER.RIGHTOPERAND := IAPIGENERAL.ESCQUOTE( LRFILTER.RIGHTOPERAND );
         LNRETVAL := IAPIGENERAL.TRANSFORMFILTERRECORD( LRFILTER,
                                                        LSFILTERTOADD );


        
        
         LSFILTERTOADD := REPLACE( LSFILTERTOADD,                                 
                                    CHR( 39 )
                                 || CHR( 39 ),
                                 CHR( 39 ) );


         IF ( LNRETVAL = IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            LSFILTER :=    LSFILTER
                        || LSFILTERTOADD;
         ELSE
            RETURN( LNRETVAL );
         END IF;
      END LOOP;

      
      LSSQL :=    'SELECT '
               || LSSELECT
               || ' FROM '
               || LSFROM
               || ' WHERE '
               || ' pc.part_no = :PartNo';

      IF ( LSFILTER IS NOT NULL )
      THEN
         LSSQL :=    LSSQL
                  || ' AND '
                  || LSFILTER;
      END IF;

      LSSQL :=    LSSQL
               || ' ORDER BY pc.part_no ASC';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           LSSQL,
                           IAPICONSTANT.INFOLEVEL_3 );

      
      IF ( AQPRICES%ISOPEN )
      THEN
         CLOSE AQPRICES;
      END IF;

      
      OPEN AQPRICES FOR LSSQL USING ASPARTNO;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETPRICES;

   
   FUNCTION SAVEPRICE(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ASPERIOD                   IN       IAPITYPE.PERIOD_TYPE,
      ASPRICETYPE                IN       IAPITYPE.PRICETYPE_TYPE,
      ASPLANTNO                  IN       IAPITYPE.PLANTNO_TYPE,
      ANPRICE                    IN       IAPITYPE.PRICE_TYPE,
      AQERRORS                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SavePrice';
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

      UPDATE PART_COST
         SET PRICE = ANPRICE
       WHERE PART_NO = ASPARTNO
         AND PERIOD = ASPERIOD
         AND PRICE_TYPE = ASPRICETYPE
         AND PLANT = ASPLANTNO;

      IF SQL%ROWCOUNT = 0
      THEN
         RETURN( IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                     LSMETHOD,
                                                     IAPICONSTANTDBERROR.DBERR_PARTPRICENOTFOUND,
                                                     ASPARTNO,
                                                     ASPERIOD,
                                                     ASPRICETYPE,
                                                     ASPLANTNO ) );
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
   END SAVEPRICE;

   
   FUNCTION GETPRICES(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      AXPLANTFILTER              IN       IAPITYPE.XMLTYPE_TYPE,
      AQPRICES                   OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPrices';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LTPLANTFILTER                 IAPITYPE.FILTERTAB_TYPE;
      LSSQLNULL                     IAPITYPE.SQLSTRING_TYPE := NULL;
      LSSELECT                      IAPITYPE.SQLSTRING_TYPE := GETBASECOLUMNS( 'pc' );
      LSFROM                        IAPITYPE.STRING_TYPE := 'part_cost pc ';
   BEGIN
      
      
      
      
      
      IF ( AQPRICES%ISOPEN )
      THEN
         CLOSE AQPRICES;
      END IF;

      LSSQLNULL :=    'select '
                   || LSSELECT
                   || ' from '
                   || LSFROM
                   || ' where pc.part_no = null ';
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                              'lsSqlNull : '
                           || LSSQLNULL,
                           IAPICONSTANT.INFOLEVEL_3 );

      OPEN AQPRICES FOR LSSQLNULL;

      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNRETVAL := IAPIGENERAL.APPENDXMLFILTER( AXPLANTFILTER,
                                               LTPLANTFILTER );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LNRETVAL := IAPIPARTPRICE.GETPRICES( ASPARTNO,
                                           LTPLANTFILTER,
                                           AQPRICES );

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
   END GETPRICES;
END IAPIPARTPRICE;
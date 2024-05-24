CREATE OR REPLACE PACKAGE BODY Iapidisplayformat
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





   






   FUNCTION COPYDISPLAYFORMAT(
      ASTYPE                     IN       IAPITYPE.STRING_TYPE,
      ANDISPLAYFORMAT            IN       IAPITYPE.ID_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'CopyDisplayFormat';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNSTATUS                      IAPITYPE.STATUSID_TYPE;
      LNNEWREVISION                 IAPITYPE.REVISION_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      

      


      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ASTYPE = TO_CHAR( IAPICONSTANT.SECTIONTYPE_BOM )
      THEN
         BEGIN
            SELECT STATUS
              INTO LNSTATUS
              FROM ITBOMLY
             WHERE LAYOUT_ID = ANDISPLAYFORMAT
               AND REVISION = ANREVISION;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                          LSMETHOD,
                                                          IAPICONSTANTDBERROR.DBERR_BOMDFNOTFOUND,
                                                          ANDISPLAYFORMAT,
                                                          ANREVISION );
         
         
         
         END;

         IF LNSTATUS = 1
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_INVALIDBOMDFSTATUS,
                                                       ANDISPLAYFORMAT,
                                                       ANREVISION );
         
         
         
         END IF;

         SELECT   MAX( REVISION )
                + 1
           INTO LNNEWREVISION
           FROM ITBOMLY
          WHERE LAYOUT_ID = ANDISPLAYFORMAT;

         INSERT INTO ITBOMLY
                     ( LAYOUT_ID,
                       DESCRIPTION,
                       INTL,
                       STATUS,
                       LAST_MODIFIED_BY,
                       LAST_MODIFIED_ON,
                       CREATED_BY,
                       CREATED_ON,
                       REVISION,
                       LAYOUT_TYPE )
            SELECT LAYOUT_ID,
                   DESCRIPTION,
                   INTL,
                   1,
                   IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                   SYSDATE,
                   IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                   SYSDATE,
                   LNNEWREVISION,
                   LAYOUT_TYPE
              FROM ITBOMLY
             WHERE LAYOUT_ID = ANDISPLAYFORMAT
               AND REVISION = ANREVISION;

         INSERT INTO ITBOMLYITEM
                     ( LAYOUT_ID,
                       HEADER_ID,
                       FIELD_ID,
                       INCLUDED,
                       START_POS,
                       LENGTH,
                       ALIGNMENT,
                       FORMAT_ID,
                       HEADER,
                       COLOR,
                       BOLD,
                       UNDERLINE,
                       INTL,
                       REVISION,
                       DEF,
                       FIELD_TYPE,
                       EDITABLE,
                       PHASE_MRP,
                       PLANNING_MRP,
                       PRODUCTION_MRP,
                       ASSOCIATION,
                       CHARACTERISTIC )
            SELECT LAYOUT_ID,
                   HEADER_ID,
                   FIELD_ID,
                   INCLUDED,
                   START_POS,
                   LENGTH,
                   ALIGNMENT,
                   FORMAT_ID,
                   HEADER,
                   COLOR,
                   BOLD,
                   UNDERLINE,
                   INTL,
                   LNNEWREVISION,
                   DEF,
                   FIELD_TYPE,
                   EDITABLE,
                   PHASE_MRP,
                   PLANNING_MRP,
                   PRODUCTION_MRP,
                   ASSOCIATION,
                   CHARACTERISTIC
              FROM ITBOMLYITEM
             WHERE LAYOUT_ID = ANDISPLAYFORMAT
               AND REVISION = ANREVISION;
      ELSIF ASTYPE = IAPICONSTANT.NUTRITIONAL
      THEN
         BEGIN
            SELECT STATUS
              INTO LNSTATUS
              FROM ITNUTLY
             WHERE LAYOUT_ID = ANDISPLAYFORMAT
               AND REVISION = ANREVISION;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                          LSMETHOD,
                                                          IAPICONSTANTDBERROR.DBERR_NUTDFNOTFOUND,
                                                          ANDISPLAYFORMAT,
                                                          ANREVISION );
         
         
         
         END;

         IF LNSTATUS = 1
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_INVALIDNUTDFSTATUS,
                                                       ANDISPLAYFORMAT,
                                                       ANREVISION );
         
         
         
         END IF;

         SELECT   MAX( REVISION )
                + 1
           INTO LNNEWREVISION
           FROM ITNUTLY
          WHERE LAYOUT_ID = ANDISPLAYFORMAT;

         INSERT INTO ITNUTLY
                     ( LAYOUT_ID,
                       DESCRIPTION,
                       INTL,
                       STATUS,
                       LAST_MODIFIED_BY,
                       LAST_MODIFIED_ON,
                       CREATED_BY,
                       CREATED_ON,
                       REVISION )
            SELECT LAYOUT_ID,
                   DESCRIPTION,
                   INTL,
                   1,
                   IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                   SYSDATE,
                   IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                   SYSDATE,
                   LNNEWREVISION
              FROM ITNUTLY
             WHERE LAYOUT_ID = ANDISPLAYFORMAT
               AND REVISION = ANREVISION;

         INSERT INTO ITNUTLYITEM
                     ( LAYOUT_ID,
                       REVISION,
                       SEQ_NO,
                       COL_TYPE,
                       HEADER_ID,
                       DATA_TYPE,
                       CALC_SEQ,
                       CALC_METHOD,
                       MODIFIABLE,
                       LENGTH,
                       GROUPING_ID )
            SELECT LAYOUT_ID,
                   LNNEWREVISION,
                   SEQ_NO,
                   COL_TYPE,
                   HEADER_ID,
                   DATA_TYPE,
                   CALC_SEQ,
                   CALC_METHOD,
                   MODIFIABLE,
                   LENGTH,
                   GROUPING_ID
              FROM ITNUTLYITEM
             WHERE LAYOUT_ID = ANDISPLAYFORMAT
               AND REVISION = ANREVISION;
      ELSIF ASTYPE IN( TO_CHAR( IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP ), TO_CHAR( IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY ) )
      THEN
         BEGIN
            SELECT STATUS
              INTO LNSTATUS
              FROM LAYOUT
             WHERE LAYOUT_ID = ANDISPLAYFORMAT
               AND REVISION = ANREVISION;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                          LSMETHOD,
                                                          IAPICONSTANTDBERROR.DBERR_NODISPLAYFRMTFOUNDLAYOUT,
                                                          ANDISPLAYFORMAT,
                                                          ANREVISION );
         
         
         
         END;

         IF LNSTATUS = 1
         THEN
            RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                       LSMETHOD,
                                                       IAPICONSTANTDBERROR.DBERR_INVALIDDFSTATUS,
                                                       ANDISPLAYFORMAT,
                                                       ANREVISION );
         
         
         
         END IF;

         SELECT   MAX( REVISION )
                + 1
           INTO LNNEWREVISION
           FROM LAYOUT
          WHERE LAYOUT_ID = ANDISPLAYFORMAT;

         INSERT INTO LAYOUT
                     ( LAYOUT_ID,
                       DESCRIPTION,
                       INTL,
                       STATUS,
                       LAST_MODIFIED_BY,
                       LAST_MODIFIED_ON,
                       CREATED_BY,
                       CREATED_ON,
                       REVISION )
            SELECT LAYOUT_ID,
                   DESCRIPTION,
                   INTL,
                   1,
                   IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                   SYSDATE,
                   IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                   SYSDATE,
                   LNNEWREVISION
              FROM LAYOUT
             WHERE LAYOUT_ID = ANDISPLAYFORMAT
               AND REVISION = ANREVISION;

         
         DELETE FROM PROPERTY_LAYOUT
               WHERE LAYOUT_ID = ANDISPLAYFORMAT
                 AND REVISION = LNNEWREVISION;

         DELETE FROM LAYOUT_VALIDATION
               WHERE LAYOUT_ID = ANDISPLAYFORMAT
                 AND REVISION = LNNEWREVISION;

         INSERT INTO PROPERTY_LAYOUT
                     ( LAYOUT_ID,
                       HEADER_ID,
                       FIELD_ID,
                       INCLUDED,
                       START_POS,
                       LENGTH,
                       ALIGNMENT,
                       FORMAT_ID,
                       HEADER,
                       BOLD,
                       UNDERLINE,
                       INTL,
                       REVISION,                       
                       
                       
                       DEF,
                       COLOR,                       
                       HEADER_REV,                        
                       URL,
                       ATTACHED_SPEC,
                       EDIT_ALLOWED)      
                       
            SELECT LAYOUT_ID,
                   HEADER_ID,
                   FIELD_ID,
                   INCLUDED,
                   START_POS,
                   LENGTH,
                   ALIGNMENT,
                   FORMAT_ID,
                   HEADER,
                   BOLD,
                   UNDERLINE,
                   INTL,
                   LNNEWREVISION,                   
                   
                   
                       DEF,
                       COLOR,                       
                       HEADER_REV,                        
                       URL,
                       ATTACHED_SPEC,
                       EDIT_ALLOWED
                   
              FROM PROPERTY_LAYOUT
             WHERE LAYOUT_ID = ANDISPLAYFORMAT
               AND REVISION = ANREVISION;

         INSERT INTO LAYOUT_VALIDATION
                     ( LAYOUT_ID,
                       FUNCTION_ID,
                       ARG1,
                       ARG2,
                       ARG3,
                       ARG4,
                       ARG5,
                       ARG6,
                       ARG7,
                       ARG8,
                       ARG9,
                       ARG10,
                       INTL,
                       REVISION )
            SELECT LAYOUT_ID,
                   FUNCTION_ID,
                   ARG1,
                   ARG2,
                   ARG3,
                   ARG4,
                   ARG5,
                   ARG6,
                   ARG7,
                   ARG8,
                   ARG9,
                   ARG10,
                   INTL,
                   LNNEWREVISION
              FROM LAYOUT_VALIDATION
             WHERE LAYOUT_ID = ANDISPLAYFORMAT
               AND REVISION = ANREVISION;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END COPYDISPLAYFORMAT;


   FUNCTION DUPLICATEDISPLAYFORMAT(
      ASTYPE                     IN       IAPITYPE.STRING_TYPE,
      ANDISPLAYFORMATFROM        IN       IAPITYPE.ID_TYPE,
      ANDISPLAYFORMATREVISIONFROM IN      IAPITYPE.REVISION_TYPE,
      ANDISPLAYFORMATTO          IN       IAPITYPE.ID_TYPE,
      ASDESCRIPTION              IN       IAPITYPE.DESCRIPTION_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS










      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'DuplicateDisplayFormat';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNLAYOUTTYPE                  ITBOMLY.LAYOUT_TYPE%TYPE;
      LSFROMDESCRIPTION             IAPITYPE.DESCRIPTION_TYPE;
      LNDISPLAYFORMAT               IAPITYPE.ID_TYPE;
      LNDISPLAYFORMATREVISION       IAPITYPE.REVISION_TYPE;
      LNCOUNT                       IAPITYPE.NUMVAL_TYPE;
      LNINTERNATIONAL               IAPITYPE.INTL_TYPE;
      LNLAYOUTID                    IAPITYPE.ID_TYPE;
   BEGIN



      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'PreConditions',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF IAPIGENERAL.SESSION.APPLICATIONUSER.USERID IS NULL
      THEN
         RETURN IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                    LSMETHOD,
                                                    IAPICONSTANTDBERROR.DBERR_NOINITSESSION );
      END IF;

      
      

      


      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF IAPIGENERAL.SESSION.SETTINGS.INTERNATIONAL
      THEN
         LNINTERNATIONAL := '1';
      ELSE
         LNINTERNATIONAL := '0';
      END IF;

      IF ASTYPE = TO_CHAR( IAPICONSTANT.SECTIONTYPE_BOM )
      THEN
         BEGIN
            SELECT LAYOUT_TYPE
              INTO LNLAYOUTTYPE
              FROM ITBOMLY
             WHERE LAYOUT_ID = ANDISPLAYFORMATFROM
               AND REVISION = ANDISPLAYFORMATREVISIONFROM;
         EXCEPTION
            WHEN OTHERS
            THEN
               LNLAYOUTTYPE := 1;
               LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_BOMDFNOTFOUND,
                                                     ANDISPLAYFORMATFROM,
                                                     ANDISPLAYFORMATREVISIONFROM );
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT );
               RETURN LNRETVAL;
         
         
         
         END;

         LNDISPLAYFORMAT := NULL;
         LNDISPLAYFORMATREVISION := NULL;

         FOR I IN ( SELECT  LAYOUT_ID,
                            REVISION
                       FROM ITBOMLY
                      WHERE LAYOUT_TYPE = LNLAYOUTTYPE
                        AND UPPER( TRIM( DESCRIPTION ) ) = UPPER( TRIM( ASDESCRIPTION ) )
                   ORDER BY LAYOUT_ID,
                            REVISION DESC )
         LOOP
            LNDISPLAYFORMAT := I.LAYOUT_ID;
            LNDISPLAYFORMATREVISION := I.REVISION;
            EXIT;
         END LOOP;

         IF LNDISPLAYFORMAT IS NOT NULL
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_BOMDFEXIST,
                                                  LNDISPLAYFORMAT,
                                                  LNDISPLAYFORMATREVISION );
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT );
            RETURN LNRETVAL;
         
         
         
         END IF;

         INSERT INTO ITBOMLY
                     ( LAYOUT_ID,
                       DESCRIPTION,
                       INTL,
                       STATUS,
                       LAST_MODIFIED_BY,
                       LAST_MODIFIED_ON,
                       CREATED_BY,
                       CREATED_ON,
                       REVISION,
                       LAYOUT_TYPE )
              VALUES ( ANDISPLAYFORMATTO,
                       ASDESCRIPTION,
                       LNINTERNATIONAL,
                       1,
                       IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                       SYSDATE,
                       IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                       SYSDATE,
                       1,
                       LNLAYOUTTYPE );

         INSERT INTO ITBOMLYITEM
                     ( LAYOUT_ID,
                       HEADER_ID,
                       FIELD_ID,
                       INCLUDED,
                       START_POS,
                       LENGTH,
                       ALIGNMENT,
                       FORMAT_ID,
                       HEADER,
                       BOLD,
                       UNDERLINE,
                       INTL,
                       REVISION,
                       DEF,
                       FIELD_TYPE,
                       EDITABLE,
                       PHASE_MRP,
                       PLANNING_MRP,
                       PRODUCTION_MRP,
                       ASSOCIATION,
                       CHARACTERISTIC )
            SELECT ANDISPLAYFORMATTO,
                   HEADER_ID,
                   FIELD_ID,
                   INCLUDED,
                   START_POS,
                   LENGTH,
                   ALIGNMENT,
                   FORMAT_ID,
                   HEADER,
                   BOLD,
                   UNDERLINE,
                   LNINTERNATIONAL,
                   1,
                   DEF,
                   FIELD_TYPE,
                   EDITABLE,
                   PHASE_MRP,
                   PLANNING_MRP,
                   PRODUCTION_MRP,
                   ASSOCIATION,
                   CHARACTERISTIC
              FROM ITBOMLYITEM
             WHERE LAYOUT_ID = ANDISPLAYFORMATFROM
               AND REVISION = ANDISPLAYFORMATREVISIONFROM;
      ELSIF ASTYPE = IAPICONSTANT.NUTRITIONAL
      THEN
         BEGIN
            SELECT LAYOUT_ID
              INTO LNLAYOUTID
              FROM ITNUTLY
             WHERE LAYOUT_ID = ANDISPLAYFORMATFROM
               AND REVISION = ANDISPLAYFORMATREVISIONFROM;
         EXCEPTION
            WHEN OTHERS
            THEN
               LNLAYOUTID := 1;
               LNRETVAL :=
                  IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,
                                                      LSMETHOD,
                                                      IAPICONSTANTDBERROR.DBERR_NUTDFNOTFOUND,
                                                      ANDISPLAYFORMATFROM,
                                                      ANDISPLAYFORMATREVISIONFROM );
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT );
               RETURN LNRETVAL;
         
         
         
         END;

         LNDISPLAYFORMAT := NULL;
         LNDISPLAYFORMATREVISION := NULL;

         FOR I IN ( SELECT  LAYOUT_ID,
                            REVISION
                       FROM ITNUTLY
                      WHERE UPPER( TRIM( DESCRIPTION ) ) = UPPER( TRIM( ASDESCRIPTION ) )
                   ORDER BY LAYOUT_ID,
                            REVISION DESC )
         LOOP
            LNDISPLAYFORMAT := I.LAYOUT_ID;
            LNDISPLAYFORMATREVISION := I.REVISION;
            EXIT;
         END LOOP;

         IF LNDISPLAYFORMAT IS NOT NULL
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_NUTDFEXIST,
                                                  LNDISPLAYFORMAT,
                                                  LNDISPLAYFORMATREVISION );
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT );
            RETURN LNRETVAL;
         
         
         
         END IF;

         INSERT INTO ITNUTLY
                     ( LAYOUT_ID,
                       DESCRIPTION,
                       INTL,
                       STATUS,
                       LAST_MODIFIED_BY,
                       LAST_MODIFIED_ON,
                       CREATED_BY,
                       CREATED_ON,
                       REVISION )
              VALUES ( ANDISPLAYFORMATTO,
                       ASDESCRIPTION,
                       '0',
                       1,
                       IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                       SYSDATE,
                       IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                       SYSDATE,
                       1 );

         INSERT INTO ITNUTLYITEM
                     ( LAYOUT_ID,
                       REVISION,
                       SEQ_NO,
                       COL_TYPE,
                       HEADER_ID,
                       DATA_TYPE,
                       CALC_SEQ,
                       CALC_METHOD,
                       MODIFIABLE,
                       LENGTH,
                       GROUPING_ID )
            SELECT ANDISPLAYFORMATTO,
                   1,
                   SEQ_NO,
                   COL_TYPE,
                   HEADER_ID,
                   DATA_TYPE,
                   CALC_SEQ,
                   CALC_METHOD,
                   MODIFIABLE,
                   LENGTH,
                   GROUPING_ID
              FROM ITNUTLYITEM
             WHERE LAYOUT_ID = ANDISPLAYFORMATFROM
               AND REVISION = ANDISPLAYFORMATREVISIONFROM;
      ELSIF ASTYPE IN( TO_CHAR( IAPICONSTANT.SECTIONTYPE_PROPERTYGROUP ), TO_CHAR( IAPICONSTANT.SECTIONTYPE_SINGLEPROPERTY ) )
      THEN
         BEGIN
            SELECT DESCRIPTION
              INTO LSFROMDESCRIPTION
              FROM LAYOUT
             WHERE LAYOUT_ID = ANDISPLAYFORMATFROM
               AND REVISION = ANDISPLAYFORMATREVISIONFROM;
         EXCEPTION
            WHEN OTHERS
            THEN
               LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_PROPERTYDFNOTFOUND,
                                                     ANDISPLAYFORMATFROM,
                                                     ANDISPLAYFORMATREVISIONFROM );
               IAPIGENERAL.LOGERROR( GSSOURCE,
                                     LSMETHOD,
                                     IAPIGENERAL.GETLASTERRORTEXT );
               RETURN LNRETVAL;
         
         
         
         END;

         LNDISPLAYFORMAT := NULL;
         LNDISPLAYFORMATREVISION := NULL;

         FOR I IN ( SELECT  LAYOUT_ID,
                            REVISION
                       FROM LAYOUT
                      WHERE UPPER( TRIM( DESCRIPTION ) ) = UPPER( TRIM( ASDESCRIPTION ) )
                   ORDER BY LAYOUT_ID,
                            REVISION DESC )
         LOOP
            LNDISPLAYFORMAT := I.LAYOUT_ID;
            LNDISPLAYFORMATREVISION := I.REVISION;
            EXIT;
         END LOOP;

         IF LNDISPLAYFORMAT IS NOT NULL
         THEN
            LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_PROPERTYDFEXIST,
                                                  LNDISPLAYFORMAT,
                                                  LNDISPLAYFORMATREVISION );
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT );
            RETURN LNRETVAL;
         
         
         
         END IF;

         INSERT INTO LAYOUT
                     ( LAYOUT_ID,
                       DESCRIPTION,
                       INTL,
                       STATUS,
                       LAST_MODIFIED_BY,
                       LAST_MODIFIED_ON,
                       CREATED_BY,
                       CREATED_ON,
                       REVISION )
              VALUES ( ANDISPLAYFORMATTO,
                       ASDESCRIPTION,
                       LNINTERNATIONAL,
                       1,
                       IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                       SYSDATE,
                       IAPIGENERAL.SESSION.APPLICATIONUSER.USERID,
                       SYSDATE,
                       1 );


         DELETE FROM PROPERTY_LAYOUT
               WHERE LAYOUT_ID = ANDISPLAYFORMATTO
                 AND REVISION = 1;

         DELETE FROM LAYOUT_VALIDATION
               WHERE LAYOUT_ID = ANDISPLAYFORMATTO
                 AND REVISION = 1;

         INSERT INTO PROPERTY_LAYOUT
                     ( LAYOUT_ID,
                       HEADER_ID,
                       FIELD_ID,
                       INCLUDED,
                       START_POS,
                       LENGTH,
                       ALIGNMENT,
                       FORMAT_ID,
                       HEADER,
                       BOLD,
                       UNDERLINE,
                       INTL,
                       REVISION,                       
                      
                       
                       DEF,
                       COLOR,                       
                       HEADER_REV,                        
                       URL,
                       ATTACHED_SPEC,
                       EDIT_ALLOWED)
                       
            SELECT ANDISPLAYFORMATTO,
                   HEADER_ID,
                   FIELD_ID,
                   INCLUDED,
                   START_POS,
                   LENGTH,
                   ALIGNMENT,
                   FORMAT_ID,
                   HEADER,
                   BOLD,
                   UNDERLINE,
                   LNINTERNATIONAL,
                   1,                   
                   
                   
                   DEF,
                   COLOR,                       
                   HEADER_REV,                        
                   URL,
                   ATTACHED_SPEC,
                   EDIT_ALLOWED                   
                   
              FROM PROPERTY_LAYOUT
             WHERE LAYOUT_ID = ANDISPLAYFORMATFROM
               AND REVISION = ANDISPLAYFORMATREVISIONFROM;

         INSERT INTO LAYOUT_VALIDATION
                     
                     
         (             LAYOUT_ID,
                       FUNCTION_ID,
                       ARG1,
                       ARG2,
                       ARG3,
                       ARG4,
                       ARG5,
                       ARG6,
                       ARG7,
                       ARG8,
                       ARG9,
                       ARG10,
                       INTL,
                       REVISION )
            SELECT ANDISPLAYFORMATTO,
                   FUNCTION_ID,
                   ARG1,
                   ARG2,
                   ARG3,
                   ARG4,
                   ARG5,
                   ARG6,
                   ARG7,
                   ARG8,
                   ARG9,
                   ARG10,
                   LNINTERNATIONAL,
                   1
              FROM LAYOUT_VALIDATION
             WHERE LAYOUT_ID = ANDISPLAYFORMATFROM
               AND REVISION = ANDISPLAYFORMATREVISIONFROM;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END DUPLICATEDISPLAYFORMAT;

   
   FUNCTION GETHEADERS(
      ASPARTNO                   IN       IAPITYPE.PARTNO_TYPE,
      ANREVISION                 IN       IAPITYPE.REVISION_TYPE,
      ANSECTIONID                IN       IAPITYPE.ID_TYPE,
      ANSUBSECTIONID             IN       IAPITYPE.ID_TYPE,
      ANITEMID                   IN       IAPITYPE.ID_TYPE,
      ANINCLUDEDONLY             IN       IAPITYPE.BOOLEAN_TYPE DEFAULT 1,
      AQHEADERS                  OUT      IAPITYPE.REF_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetHeaders';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LSSQL                         VARCHAR2( 8192 ) := NULL;
      LSSELECT                      VARCHAR2( 4096 )
         :=    'DISTINCT pl.field_id '
            || IAPICONSTANTCOLUMN.FIELDIDCOL
            || ','
            || 'pl.header_id '
            || IAPICONSTANTCOLUMN.HEADERIDCOL
            || ','
            || 'f_hdh_descr(1, pl.header_id, pl.header_rev) '
            || IAPICONSTANTCOLUMN.HEADERCOL;
      LSFROM                        IAPITYPE.STRING_TYPE := 'property_layout pl, specification_section ss';
      LSFROMFRAME                   IAPITYPE.STRING_TYPE := 'property_layout pl, frame_section fs';
      LRFRAME                       IAPITYPE.FRAMEREC_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      
      LNRETVAL := IAPISPECIFICATION.GETFRAME( ASPARTNO,
                                              ANREVISION,
                                              LRFRAME );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LSSQL :=
            'SELECT '
         || LSSELECT
         || ' FROM '
         || LSFROM
         || ' WHERE ss.part_no = :PartNo'
         || ' AND ss.revision = :Revision'
         || ' AND ss.section_id = :SectionId'
         || ' AND ss.sub_section_id = :SubSectionId'
         || ' AND ss.ref_id = :ItemId'
         || ' AND ss.type IN (1, 4)'
         || ' AND ss.display_format = pl.layout_id'
         || ' AND ss.display_format_rev = pl.revision';

      IF ANINCLUDEDONLY = 0
      THEN
         LSSQL :=
               LSSQL
            || ' UNION SELECT '
            || LSSELECT
            || ' FROM '
            || LSFROMFRAME
            || ' WHERE fs.frame_no = :FrameNo'
            || ' AND fs.revision = :FrameRevision'
            || ' AND fs.owner = :FrameOwner'
            || ' AND fs.section_id = :SectionId'
            || ' AND fs.sub_section_id = :SubSectionId'
            || ' AND fs.ref_id = :ItemId'
            || ' AND fs.type IN (1, 4)'
            || ' AND fs.display_format = pl.layout_id'
            || ' AND fs.display_format_rev = pl.revision'
            || ' AND ( pl.field_id, pl.header_id ) NOT IN (SELECT DISTINCT pl.field_id '
            || IAPICONSTANTCOLUMN.FIELDIDCOL
            || ','
            || 'pl.header_id '
            || IAPICONSTANTCOLUMN.HEADERIDCOL
            || ' FROM '
            || LSFROM
            || ' WHERE ss.part_no = :PartNo'
            || ' AND ss.revision = :Revision'
            || ' AND ss.section_id = :SectionId'
            || ' AND ss.sub_section_id = :SubSectionId'
            || ' AND ss.ref_id = :ItemId'
            || ' AND ss.type IN (1, 4)'
            || ' AND ss.display_format = pl.layout_id'
            || ' AND ss.display_format_rev = pl.revision)';
      END IF;

      LSSQL :=    'SELECT a.* '
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

      IF ANINCLUDEDONLY = 1
      THEN
         OPEN AQHEADERS FOR LSSQL USING ASPARTNO,
         ANREVISION,
         ANSECTIONID,
         ANSUBSECTIONID,
         ANITEMID;
      ELSE
         
         OPEN AQHEADERS FOR LSSQL
         USING ASPARTNO,
               ANREVISION,
               ANSECTIONID,
               ANSUBSECTIONID,
               ANITEMID,
               LRFRAME.FRAMENO,
               LRFRAME.REVISION,
               LRFRAME.OWNER,
               ANSECTIONID,
               ANSUBSECTIONID,
               ANITEMID,
               ASPARTNO,
               ANREVISION,
               ANSECTIONID,
               ANSUBSECTIONID,
               ANITEMID;
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETHEADERS;
END IAPIDISPLAYFORMAT;
CREATE OR REPLACE PACKAGE BODY iapiTextSearch
AS

   
   
   
   
   
   
   
   
   
   







   PIOPERATORTYPEAND    CONSTANT INTEGER := 1;
   PIOPERATORTYPEOR     CONSTANT INTEGER := 2;





   


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

   FUNCTION GETSEQUENCE(
      ANTEXTSEARCHNO             OUT      IAPITYPE.SEQUENCE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS






      CURSOR LQSEQUENCE
      IS
         SELECT ITTEXTSEARCH_SEQ.NEXTVAL TEXTSEARCHNO
           FROM DUAL;

      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetSequence';
   BEGIN
      
      FOR LRSEQUENCE IN LQSEQUENCE
      LOOP
         ANTEXTSEARCHNO := LRSEQUENCE.TEXTSEARCHNO;
      END LOOP;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETSEQUENCE;

   FUNCTION PARSERINITIALIZE(
      ASSEARCHTEXT               IN       IAPITYPE.STRINGVAL_TYPE,
      ANCASESENSITIVE            IN       IAPITYPE.BOOLEAN_TYPE,
      AICRITERIANUMBER           OUT      IAPITYPE.ID_TYPE,
      ATCRITERIAOPERATORS        OUT      IAPITYPE.OPERATORSTAB_TYPE,
      ATCRITERIATEXTS            OUT      IAPITYPE.TOKENSTAB_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS







      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ParserInitialize';
      LNLENGTH                      IAPITYPE.NUMVAL_TYPE;
      LIPOS                         IAPITYPE.ID_TYPE;
      LSCHAR                        IAPITYPE.SEARCH_TYPE;
      LSTOKEN                       IAPITYPE.STRING_TYPE;
      LTTOKENS                      IAPITYPE.TOKENSTAB_TYPE;
      LITOKENS                      IAPITYPE.ID_TYPE;
      LBQUOTEDWORD                  BOOLEAN;
      LICRITERIANUMBER              IAPITYPE.ID_TYPE;
      LBOPERATORFOUND               BOOLEAN;
      LIOPERATOR                    IAPITYPE.ID_TYPE;
      LIPOSFRONT                    IAPITYPE.ID_TYPE;
      LIPOSBACK                     IAPITYPE.ID_TYPE;
   BEGIN
      
      LBQUOTEDWORD := FALSE;
      LSTOKEN := NULL;
      LITOKENS := 0;
      LICRITERIANUMBER := 0;
      LBOPERATORFOUND := FALSE;
      
      
      
      LNLENGTH := LENGTH( ASSEARCHTEXT );

      FOR LIPOS IN 1 .. LNLENGTH
      LOOP
         LSCHAR := SUBSTR( ASSEARCHTEXT,
                           LIPOS,
                           1 );

         IF     LSCHAR = ' '
            AND NOT LBQUOTEDWORD
         THEN
            
            IF LSTOKEN IS NOT NULL
            THEN
               
               LITOKENS :=   LITOKENS
                           + 1;
               LTTOKENS( LITOKENS ) := LSTOKEN;
               
               LSTOKEN := NULL;
            END IF;
         ELSIF LSCHAR = '"'
         THEN
            LBQUOTEDWORD := NOT LBQUOTEDWORD;
         ELSE
            
            LSTOKEN :=    LSTOKEN
                       || LSCHAR;
         END IF;
      END LOOP;

      
      IF LSTOKEN IS NOT NULL
      THEN
         
         LITOKENS :=   LITOKENS
                     + 1;
         LTTOKENS( LITOKENS ) := LSTOKEN;
         
         LSTOKEN := NULL;
      END IF;

      
      
      
      FOR LIPOS IN 1 .. LITOKENS
      LOOP
         LSTOKEN := UPPER( LTTOKENS( LIPOS ) );

         IF     (    LSTOKEN = '+'
                  OR LSTOKEN = 'AND' )
            AND NOT LBOPERATORFOUND
         THEN
            
            LIOPERATOR := PIOPERATORTYPEAND;
            LBOPERATORFOUND := TRUE;
         ELSE
            
            IF NOT LBOPERATORFOUND
            THEN
               LIOPERATOR := PIOPERATORTYPEOR;
            END IF;

            
            IF ANCASESENSITIVE = 1
            THEN
               
               LSTOKEN := LTTOKENS( LIPOS );
            END IF;

            
            IF SUBSTR( LSTOKEN,
                       1,
                       1 ) <> '%'
            THEN
               LSTOKEN :=    '%'
                          || LSTOKEN;
            END IF;

            IF SUBSTR( LSTOKEN,
                       LENGTH( LSTOKEN ),
                       1 ) <> '%'
            THEN
               LSTOKEN :=    LSTOKEN
                          || '%';
            END IF;

            
            LICRITERIANUMBER :=   LICRITERIANUMBER
                                + 1;
            ATCRITERIAOPERATORS( LICRITERIANUMBER ) := LIOPERATOR;
            ATCRITERIATEXTS( LICRITERIANUMBER ) := LSTOKEN;
            
            LBOPERATORFOUND := FALSE;
         END IF;
      END LOOP;

      
      
      LIPOSFRONT := 1;
      LIPOSBACK := LICRITERIANUMBER;

      WHILE LIPOSFRONT < LIPOSBACK
      LOOP
         
         IF ATCRITERIAOPERATORS( LIPOSFRONT ) = PIOPERATORTYPEAND
         THEN
            
            LIPOSFRONT :=   LIPOSFRONT
                          + 1;
         ELSE
            
            WHILE LIPOSBACK > LIPOSFRONT
            LOOP
               
               IF ATCRITERIAOPERATORS( LIPOSBACK ) = PIOPERATORTYPEAND
               THEN
                  
                  LIOPERATOR := ATCRITERIAOPERATORS( LIPOSFRONT );
                  LSTOKEN := ATCRITERIATEXTS( LIPOSFRONT );
                  ATCRITERIAOPERATORS( LIPOSFRONT ) := ATCRITERIAOPERATORS( LIPOSBACK );
                  ATCRITERIATEXTS( LIPOSFRONT ) := ATCRITERIATEXTS( LIPOSBACK );
                  ATCRITERIAOPERATORS( LIPOSBACK ) := LIOPERATOR;
                  ATCRITERIATEXTS( LIPOSBACK ) := LSTOKEN;
                  
                  LIPOSFRONT :=   LIPOSFRONT
                                + 1;
                  LIPOSBACK :=   LIPOSBACK
                               - 1;
                  
                  EXIT;
               ELSE
                  
                  LIPOSBACK :=   LIPOSBACK
                               - 1;
               END IF;
            END LOOP;
         END IF;
      END LOOP;

      
      AICRITERIANUMBER := LICRITERIANUMBER;










      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END PARSERINITIALIZE;

   FUNCTION PARSERVALUECHECK(
      ASTEXTVALUE                IN       IAPITYPE.STRINGVAL_TYPE,
      ANCASESENSITIVE            IN       IAPITYPE.BOOLEAN_TYPE,
      AICRITERIANUMBER           IN       IAPITYPE.ID_TYPE,
      ATCRITERIAOPERATORS        IN       IAPITYPE.OPERATORSTAB_TYPE,
      ATCRITERIATEXTS            IN       IAPITYPE.TOKENSTAB_TYPE,
      ABFOUND                    OUT      BOOLEAN )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS












      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ParserValueCheck';
      LSTEXTVALUE                   IAPITYPE.INFO_TYPE;
      LIPOS                         IAPITYPE.ID_TYPE;
   BEGIN
      
      ABFOUND := TRUE;

      
      
      
      IF ANCASESENSITIVE = 0
      THEN
         LSTEXTVALUE := UPPER( ASTEXTVALUE );
      ELSE
         LSTEXTVALUE := ASTEXTVALUE;
      END IF;

      
      
      
      FOR LIPOS IN 1 .. AICRITERIANUMBER
      LOOP
         
         IF ATCRITERIAOPERATORS( LIPOS ) = PIOPERATORTYPEAND
         THEN
            
            IF LSTEXTVALUE LIKE ATCRITERIATEXTS( LIPOS )
            THEN
               
               NULL;
            ELSE
               
               ABFOUND := FALSE;
               RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
            END IF;
         ELSE
            
            
            
            ABFOUND := FALSE;

            
            
            IF LSTEXTVALUE LIKE ATCRITERIATEXTS( LIPOS )
            THEN
               
               
               ABFOUND := TRUE;
               RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
            ELSE
               
               NULL;
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
   END PARSERVALUECHECK;

   FUNCTION SEARCHRESULTINSERT(
      ARSEARCHRESULT             IN       IAPITYPE.SEARCHRESULTSROW_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS





      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SearchResultInsert';
   BEGIN
      INSERT INTO ITTSRESULTS
                  ( TEXT_SEARCH_NO,
                    PART_NO,
                    REVISION,
                    SECTION_ID,
                    SUB_SECTION_ID,
                    REF_TYPE,
                    REF_ID,
                    REF_VER,
                    REF_OWNER,
                    PLANT,
                    ALTERNATIVE,
                    BOM_USAGE,
                    LANG_ID,
                    EXP_DATE,
                    SYN_TYPE,
                    LOG_ID,
                    ROW_ID,
                    COL_ID )
           VALUES ( ARSEARCHRESULT.TEXT_SEARCH_NO,
                    ARSEARCHRESULT.PART_NO,
                    ARSEARCHRESULT.REVISION,
                    ARSEARCHRESULT.SECTION_ID,
                    ARSEARCHRESULT.SUB_SECTION_ID,
                    ARSEARCHRESULT.REF_TYPE,
                    ARSEARCHRESULT.REF_ID,
                    ARSEARCHRESULT.REF_VER,
                    ARSEARCHRESULT.REF_OWNER,
                    ARSEARCHRESULT.PLANT,
                    ARSEARCHRESULT.ALTERNATIVE,
                    ARSEARCHRESULT.BOM_USAGE,
                    ARSEARCHRESULT.LANG_ID,
                    ARSEARCHRESULT.EXP_DATE,
                    ARSEARCHRESULT.SYN_TYPE,
                    ARSEARCHRESULT.LOG_ID,
                    ARSEARCHRESULT.ROW_ID,
                    ARSEARCHRESULT.COL_ID );

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SEARCHRESULTINSERT;

   FUNCTION USERACCESS(
      ASPLANTACCESS              OUT      IAPITYPE.STRING_TYPE,
      ASPLANTS                   OUT      IAPITYPE.STRING_TYPE,
      ASSTATUSTYPE               OUT      IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS








      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'UserAccess';

      
      CURSOR LQCHECKPLANTACCESS(
         LSUSER                     IN       IAPITYPE.USERID_TYPE )
      IS
         SELECT AU.PLANT_ACCESS
           FROM APPLICATION_USER AU
          WHERE AU.USER_ID = LSUSER;

      
      CURSOR LQCHECKHISTORICACCESS(
         LSUSER                     IN       IAPITYPE.USERID_TYPE )
      IS
         SELECT AU.HISTORIC_ONLY
           FROM APPLICATION_USER AU
          WHERE AU.USER_ID = LSUSER;

      
      CURSOR LQCHECKAPPROVEDACCESS(
         LSUSER                     IN       IAPITYPE.USERID_TYPE )
      IS
         SELECT AU.APPROVED_ONLY
           FROM APPLICATION_USER AU
          WHERE AU.USER_ID = LSUSER;

      
      CURSOR LQCHECKCURRENTACCESS(
         LSUSER                     IN       IAPITYPE.USERID_TYPE )
      IS
         SELECT AU.CURRENT_ONLY
           FROM APPLICATION_USER AU
          WHERE AU.USER_ID = LSUSER;

      
      CURSOR LQPLANTACCESS(
         LSUSER                     IN       IAPITYPE.USERID_TYPE )
      IS
         SELECT DISTINCT UP.PLANT
                    FROM ITUP UP
                   WHERE UP.USER_ID = LSUSER;

      LSPLANTACCESS                 IAPITYPE.ACCESS_TYPE;
      LSPLANT                       IAPITYPE.PLANT_TYPE;
      LSPLANTS                      IAPITYPE.STRING_TYPE;
      LSAPPROVEDACCESS              IAPITYPE.ACCESS_TYPE;
      LSCURRENTACCESS               IAPITYPE.ACCESS_TYPE;
      LSHISTORICACCESS              IAPITYPE.ACCESS_TYPE;
      LSSTATUSACCESS                IAPITYPE.STRING_TYPE;
   BEGIN
      LSSTATUSACCESS := NULL;

      
      FOR LRCHECKHISTORICACCESS IN LQCHECKHISTORICACCESS( USER )
      LOOP
         IF LRCHECKHISTORICACCESS.HISTORIC_ONLY = 'Y'
         THEN
            LSSTATUSACCESS := 'HISTORIC, CURRENT, APPROVED';
         END IF;
      END LOOP;

      
      FOR LRCHECKAPPROVEDACCESS IN LQCHECKAPPROVEDACCESS( USER )
      LOOP
         IF LRCHECKAPPROVEDACCESS.APPROVED_ONLY = 'Y'
         THEN
            LSSTATUSACCESS := 'CURRENT, APPROVED';
         END IF;
      END LOOP;

      
      
      FOR LRCHECKCURRENTACCESS IN LQCHECKCURRENTACCESS( USER )
      LOOP
         IF LRCHECKCURRENTACCESS.CURRENT_ONLY = 'Y'
         THEN
            LSSTATUSACCESS := 'CURRENT';
         END IF;
      END LOOP;

      ASSTATUSTYPE := LSSTATUSACCESS;
      
      LSPLANTACCESS := 'N';
      LSPLANTS := '';

      
      FOR LRCHECKPLANTACCESS IN LQCHECKPLANTACCESS( USER )
      LOOP
         LSPLANTACCESS := LRCHECKPLANTACCESS.PLANT_ACCESS;
      END LOOP;

      
      IF LSPLANTACCESS = 'Y'
      THEN
         
         FOR LRPLANTACCESS IN LQPLANTACCESS( USER )
         LOOP
            LSPLANT := LRPLANTACCESS.PLANT;

            IF LSPLANTS IS NULL
            THEN
               LSPLANTS :=    ''''
                           || LSPLANT
                           || '''';
            ELSE
               LSPLANTS :=    LSPLANTS
                           || ','''
                           || LSPLANT
                           || '''';
            END IF;
         END LOOP;
      END IF;





      
      ASPLANTACCESS := LSPLANTACCESS;
      ASPLANTS := LSPLANTS;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END USERACCESS;

   FUNCTION TABLECOLUMNSSTRING1(
      ASSEARCHTYPE               IN       IAPITYPE.SEARCH_TYPE,
      ASCOLUMNSSTRING            OUT      IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS








      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'TableColumnsString1';
   BEGIN
      
      IF ASSEARCHTYPE = 'F'
      THEN
         ASCOLUMNSSTRING :=
               'st.part_no, '
            || 'st.revision, '
            || 'st.section_id, '
            || 'st.sub_section_id, '
            || '5, '
            || 'st.text_type, '
            || 'st.text_type_rev, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'st.lang_id, '
            || 'NULL, '
            || 'NULL, '
            || 'st.text, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL ';
      ELSIF ASSEARCHTYPE = 'R'
      THEN
         ASCOLUMNSSTRING :=
               'ss.part_no, '
            || 'ss.revision, '
            || 'ss.section_id, '
            || 'ss.sub_section_id, '
            || '2, '
            || 'ss.ref_id, '
            || 'ss.ref_ver, '
            || 'ss.ref_owner, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'rt.lang_id, '
            || 'NULL, '
            || 'NULL, '
            || 'to_char(rt.text), '
            || 'NULL, '
            || 'NULL, '
            || 'NULL ';
      ELSIF ASSEARCHTYPE = 'L'
      THEN
         ASCOLUMNSSTRING :=
               'la.part_no, '
            || 'la.revision, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'la.plant, '
            || 'la.alternative, '
            || 'la.bom_usage, '
            || 'la.language_id, '
            || 'la.explosion_date, '
            || 'la.synonym_type, '
            || 'to_char(la.label), '
            || 'NULL, '
            || 'NULL, '
            || 'NULL ';
      ELSIF ASSEARCHTYPE = 'I'
      THEN
         ASCOLUMNSSTRING :=
               're.part_no, '
            || 're.revision, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 're.text, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL ';
      ELSIF ASSEARCHTYPE = 'N'
      THEN
         ASCOLUMNSSTRING :=
               'no.part_no, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL, '
            
						
						|| 'no.text, '
            || 'NULL, '
            || 'NULL, '
            || 'NULL ';
      ELSIF ASSEARCHTYPE = 'C'
      THEN
         ASCOLUMNSSTRING :=
               'nl.part_no, '
            || 'nl.revision, '
            
            
            
            
            
            
            
            
            || 'NULL v1, '
            || 'NULL v2, '
            || 'NULL v3, '
            || 'NULL v4, '
            || 'NULL v5, '
            || 'NULL v6, '            
            
            || 'nl.plant, '
            || 'nl.alternative, '
            || 'nl.bom_usage, '
            
            
            
            
            
            || 'NULL v7, '
            || 'NULL v8, '
            || 'NULL v9, '
            
            
            
            || 'to_char(nlr.value) val1, '
            
            || 'nlr.log_id, '
            || 'nlr.row_id, '
            || 'nlr.col_id ';
      ELSE
         ASCOLUMNSSTRING := '';
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END TABLECOLUMNSSTRING1;

   FUNCTION TABLECOLUMNSSTRING2(
      ASSEARCHTYPE               IN       IAPITYPE.SEARCH_TYPE,
      ASCOLUMNSSTRING            OUT      IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS








      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'TableColumnsString2';
   BEGIN
      
      
      
      
      IF ASSEARCHTYPE IN( 'F', 'R', 'L', 'I' )
      THEN
         ASCOLUMNSSTRING :=    'sh.part_no, '
                            || 'sh.revision ';
      ELSIF ASSEARCHTYPE = 'N'
      THEN
         ASCOLUMNSSTRING := 'sh.part_no ';
      ELSE
         ASCOLUMNSSTRING := '';
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END TABLECOLUMNSSTRING2;

   FUNCTION FROMTABLESSTRING1(
      ASSEARCHTYPE               IN       IAPITYPE.SEARCH_TYPE,
      ASFROMTABLESSTRING         OUT      IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS








      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FromTablesString1';
   BEGIN
      
      IF ASSEARCHTYPE = 'F'
      THEN
         ASFROMTABLESSTRING := 'specification_text st, specification_header sh';
      ELSIF ASSEARCHTYPE = 'R'
      THEN
         ASFROMTABLESSTRING := 'reference_text rt, specification_section ss, specification_header sh';
      ELSIF ASSEARCHTYPE = 'L'
      THEN
         ASFROMTABLESSTRING := 'itlabellog la, specification_header sh';
      ELSIF ASSEARCHTYPE = 'I'
      THEN
         ASFROMTABLESSTRING := 'reason re, specification_header sh';
      ELSIF ASSEARCHTYPE = 'N'
      THEN
         ASFROMTABLESSTRING := 'itprnote no, specification_header sh';
      ELSIF ASSEARCHTYPE = 'C'
      THEN
         
         
         ASFROMTABLESSTRING := 'itnutlog nl ,itnutlogresult nlr, specification_header sh, spec_access sa';
         
      ELSE
         ASFROMTABLESSTRING := '';
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FROMTABLESSTRING1;

   FUNCTION FROMTABLESSTRING2(
      ASSEARCHTYPE               IN       IAPITYPE.SEARCH_TYPE,
      ANUSEMOP                   IN       IAPITYPE.BOOLEAN_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ASPLANTACCESS              IN       IAPITYPE.ACCESS_TYPE,
      ASPLANTS                   IN       IAPITYPE.PLANT_TYPE,
      ASFROMTABLESSTRING         OUT      IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS








      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'FromTablesString2';
   BEGIN
      
      IF ASPLANT IS NOT NULL
      THEN
         ASFROMTABLESSTRING := ', part_plant pp';
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END FROMTABLESSTRING2;

   FUNCTION WHERESEARCHWITHINSTRING(
      ASSEARCHTYPE               IN       IAPITYPE.SEARCH_TYPE,
      ANREFERENCETYPE            IN       IAPITYPE.NUMVAL_TYPE,
      ANREFERENCEID              IN       IAPITYPE.ID_TYPE,
      ANREFERENCEOWNER           IN       IAPITYPE.OWNER_TYPE,
      ASWHERESEARCHWITHINSTRING  OUT      IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS








      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'WhereSearchWithinString';
   BEGIN
      IF ASSEARCHTYPE = 'F'
      THEN
         
         IF     ANREFERENCETYPE = 5
            AND ANREFERENCEID IS NOT NULL
         THEN
            ASWHERESEARCHWITHINSTRING :=    'st.text_type = '
                                         || ANREFERENCEID
                                         || ' AND sh.part_no = st.part_no '
                                         || ' AND sh.revision = st.revision  ';
         ELSE
            ASWHERESEARCHWITHINSTRING :=    ' sh.part_no = st.part_no '
                                         || ' AND sh.revision = st.revision ';
         END IF;
      ELSIF ASSEARCHTYPE = 'R'
      THEN
         ASWHERESEARCHWITHINSTRING :=
                             'rt.ref_text_type = ss.ref_id    AND '
                          || 'rt.owner         = ss.ref_owner AND '
                          || 'rt.text_revision = NVL(ss.ref_ver,1) ';

         
         IF     ANREFERENCETYPE = 2
            AND ANREFERENCEID IS NOT NULL
            AND ANREFERENCEOWNER IS NOT NULL
         THEN
            ASWHERESEARCHWITHINSTRING :=
                          ASWHERESEARCHWITHINSTRING
                       || ' AND '
                       || 'ss.ref_id    = '
                       || ANREFERENCEID
                       || ' AND '
                       || 'ss.ref_owner = '
                       || ANREFERENCEOWNER;
         END IF;

         ASWHERESEARCHWITHINSTRING :=    ASWHERESEARCHWITHINSTRING
                                      || ' AND sh.part_no = ss.part_no '
                                      || ' AND sh.revision = ss.revision  ';
      ELSIF ASSEARCHTYPE = 'L'
      THEN
         ASWHERESEARCHWITHINSTRING :=    ' sh.part_no = la.part_no '
                                      || ' AND sh.revision = la.revision ';
      ELSIF ASSEARCHTYPE = 'I'
      THEN
         ASWHERESEARCHWITHINSTRING :=
               ' sh.part_no = re.part_no '
            || ' AND sh.revision = re.revision '
            || ' AND re.status_type = '''
            || IAPICONSTANT.STATUSTYPE_REASONFORISSUE
            || ''' ';
      ELSIF ASSEARCHTYPE = 'N'
      THEN
         ASWHERESEARCHWITHINSTRING := ' sh.part_no = no.part_no ';
      ELSIF ASSEARCHTYPE = 'C'
      THEN
         
         
         ASWHERESEARCHWITHINSTRING := ' nl.log_id = nlr.log_id '         
                                      || ' AND nl.part_no = sh.part_no '
                                      || ' AND nl.revision = sh.revision ';
         
      ELSE
         ASWHERESEARCHWITHINSTRING := '';
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END WHERESEARCHWITHINSTRING;

   FUNCTION WHEREFILTERSTRING(
      ASSEARCHTYPE               IN       IAPITYPE.STRINGVAL_TYPE,
      ANUSEMOP                   IN       IAPITYPE.BOOLEAN_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANSPECIFICATIONTYPE        IN       IAPITYPE.ID_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      ASPLANTACCESS              IN       IAPITYPE.ACCESS_TYPE,
      ASPLANTS                   IN       IAPITYPE.PLANT_TYPE,
      ASSTATUSACCESS             IN       IAPITYPE.STRINGVAL_TYPE,
      ASWHEREFILTERSTRING        OUT      IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS













      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'WhereFilterString';
   BEGIN
      IF ASPLANTACCESS = 'Y'
      THEN
         
         ASWHEREFILTERSTRING :=
               'AND exists (SELECT part_no FROM part_plant WHERE (plant_access = ''Y'' AND '
            || 'plant||'''' IN ('
            || ASPLANTS
            || ') AND part_no = sh.part_no))';
      ELSE
         
         
         IF (ASSEARCHTYPE = 'C')
         THEN
            ASWHEREFILTERSTRING := 'AND sa.user_id = user AND sa.access_group = sh.access_group '; 
         ELSE
         
            ASWHEREFILTERSTRING := 'AND exists (select user_id, access_group from spec_access where user_id = user AND access_group = sh.access_group)';
         
         END IF;
         
      END IF;

      
      IF ANUSEMOP = 1
      THEN
         ASWHEREFILTERSTRING :=
               ASWHEREFILTERSTRING
            || ' AND exists (select mop.part_no, mop.revision FROM itshq mop WHERE  '
            || 'sh.part_no  = mop.part_no  AND '
            || 'sh.revision = mop.revision AND '
            || 'mop.user_id = USER )';
      END IF;

      
      IF    ANSPECIFICATIONTYPE IS NOT NULL
         OR ANSTATUS IS NOT NULL
      THEN
         IF ANSPECIFICATIONTYPE IS NOT NULL
         THEN
            ASWHEREFILTERSTRING :=    ASWHEREFILTERSTRING
                                   || ' AND '
                                   || 'sh.class3_id = '
                                   || ANSPECIFICATIONTYPE;
         END IF;

         IF ANSTATUS IS NOT NULL
         THEN
            ASWHEREFILTERSTRING :=    ASWHEREFILTERSTRING
                                   || ' AND '
                                   || 'sh.status     = '
                                   || ANSTATUS;
         END IF;
      END IF;

      IF ASSTATUSACCESS = 'HISTORIC, CURRENT, APPROVED'
      THEN
         ASWHEREFILTERSTRING :=
               ASWHEREFILTERSTRING
            || ' AND '
            || 'sh.status IN (SELECT status FROM status '
            || 'WHERE status_type in  (''HISTORIC'', ''CURRENT'', ''APPROVED''))';
      ELSIF ASSTATUSACCESS = 'CURRENT, APPROVED'
      THEN
         ASWHEREFILTERSTRING :=
                    ASWHEREFILTERSTRING
                 || ' AND '
                 || 'sh.status IN (SELECT status FROM status '
                 || 'WHERE status_type in  (''CURRENT'', ''APPROVED''))';
      ELSIF ASSTATUSACCESS = 'CURRENT'
      THEN
         ASWHEREFILTERSTRING :=    ASWHEREFILTERSTRING
                                || ' AND '
                                || 'sh.status IN (SELECT status FROM status '
                                || 'WHERE status_type =  ''CURRENT'')';
      END IF;

      IF ASPLANT IS NOT NULL
      THEN
         
         ASWHEREFILTERSTRING :=    ASWHEREFILTERSTRING
                                || ' AND '
                                || 'pp.plant   = '''
                                || ASPLANT
                                || ''' AND '
                                || 'sh.part_no = pp.part_no';
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END WHEREFILTERSTRING;

   FUNCTION WHERESEARCHTEXTSTRING(
      ASSEARCHTYPE               IN       IAPITYPE.SEARCH_TYPE,
      ASSEARCHTEXT               IN       IAPITYPE.STRINGVAL_TYPE,
      ANCASESENSITIVE            IN       IAPITYPE.BOOLEAN_TYPE,
      ASWHERESEARCHTEXTSTRING    OUT      IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS








      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'WhereSearchTextString';
      LSFIELDNAME                   IAPITYPE.STRING_TYPE;
      LSSEARCHTEXT                  IAPITYPE.STRING_TYPE;
   BEGIN
      
      IF ASSEARCHTYPE = 'F'
      THEN
         LSFIELDNAME := 'st.text';
      ELSIF ASSEARCHTYPE = 'R'
      THEN
         LSFIELDNAME := 'rt.text';
      ELSIF ASSEARCHTYPE = 'L'
      THEN
         LSFIELDNAME := 'la.label';
      ELSIF ASSEARCHTYPE = 'I'
      THEN
         LSFIELDNAME := 're.text';
      ELSIF ASSEARCHTYPE = 'N'
      THEN
         LSFIELDNAME := 'no.text';
      ELSIF ASSEARCHTYPE = 'C'
      THEN
         
         
         LSFIELDNAME := 'val1';
         
      ELSE
         LSFIELDNAME := '';
      END IF;

      
      IF ANCASESENSITIVE = 0
      THEN
         LSFIELDNAME :=    'UPPER('
                        || LSFIELDNAME
                        || ')';
      END IF;

      
      
      
      LSSEARCHTEXT := ASSEARCHTEXT;

      IF ANCASESENSITIVE = 0
      THEN
         LSSEARCHTEXT :=    'UPPER('''
                         
                         || '%'
                         
                         || LSSEARCHTEXT
                         
                         || '%'
                         
                         || ''')';
      
      ELSE
         LSSEARCHTEXT :=    ''''
                         
                         || '%'
                         
                         || LSSEARCHTEXT
                         
                         || '%'
                         
                         || '''';      
      
      END IF;

      
      ASWHERESEARCHTEXTSTRING :=    LSFIELDNAME
                                 || ' LIKE '                                 
                                 || LSSEARCHTEXT;
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END WHERESEARCHTEXTSTRING;

   FUNCTION SEARCHSIMPLE(
      ANTEXTSEARCHNO             IN       IAPITYPE.SEQUENCE_TYPE,
      ASSEARCHTEXT               IN       IAPITYPE.STRINGVAL_TYPE,
      ANCASESENSITIVE            IN       IAPITYPE.BOOLEAN_TYPE,
      ANUSEMOP                   IN       IAPITYPE.BOOLEAN_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANSPECIFICATIONTYPE        IN       IAPITYPE.ID_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      ANREFERENCETYPE            IN       IAPITYPE.NUMVAL_TYPE,
      ANREFERENCEID              IN       IAPITYPE.ID_TYPE,
      ANREFERENCEOWNER           IN       IAPITYPE.OWNER_TYPE,
      ASSEARCHTYPE               IN       IAPITYPE.SEARCH_TYPE,
      AICRITERIANUMBER           IN       IAPITYPE.ID_TYPE,
      ATCRITERIAOPERATORS        IN       IAPITYPE.OPERATORSTAB_TYPE,
      ATCRITERIATEXTS            IN       IAPITYPE.TOKENSTAB_TYPE,
      ASPLANTACCESS              IN       IAPITYPE.ACCESS_TYPE,
      ASPLANTS                   IN       IAPITYPE.PLANT_TYPE,
      ASSTATUSACCESS             IN       IAPITYPE.STRINGVAL_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS



































      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'SearchSimple';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNLENGTH                      IAPITYPE.NUMVAL_TYPE;
      
      LICURSOR                      IAPITYPE.ID_TYPE;
      LIRETURNVALUE                 IAPITYPE.ID_TYPE;
      LSSELECTSTRING                VARCHAR2( 2000 );
      LBREFERENCECOLUMNS            BOOLEAN DEFAULT FALSE;
      LBLABELCOLUMNS                BOOLEAN DEFAULT FALSE;
      
      LSPARTNO                      IAPITYPE.PARTNO_TYPE;
      LNREVISION                    IAPITYPE.REVISION_TYPE;
      LNSECTIONID                   IAPITYPE.ID_TYPE;
      LNSUBSECTIONID                IAPITYPE.ID_TYPE;
      LNREFERENCETYPE               IAPITYPE.NUMVAL_TYPE;
      LNREFERENCEID                 IAPITYPE.ID_TYPE;
      LNREFERENCEVERSION            IAPITYPE.REFERENCEVERSION_TYPE;
      LNREFERENCEOWNER              IAPITYPE.OWNER_TYPE;
      LSPLANT                       IAPITYPE.PLANT_TYPE;
      LNALTERNATIVE                 IAPITYPE.BOMALTERNATIVE_TYPE;
      LNBOMUSAGE                    IAPITYPE.BOMUSAGE_TYPE;
      LNLANGUAGEID                  IAPITYPE.LANGUAGEID_TYPE;
      LDEXPLOSIONDATE               IAPITYPE.DATE_TYPE;
      LNSYNONYMTYPE                 IAPITYPE.ID_TYPE;
      LSCLOBTEXT                    IAPITYPE.CLOB_TYPE;
      LNLOGID                       IAPITYPE.ID_TYPE;
      LNROWID                       IAPITYPE.ID_TYPE;
      LNCOLID                       IAPITYPE.ID_TYPE;
      
      LSTABLECOLUMNSSTRING1         VARCHAR2( 2000 );
      LSTABLECOLUMNSSTRING2         VARCHAR2( 2000 );
      LSFROMTABLESSTRING1           VARCHAR2( 2000 );
      LSFROMTABLESSTRING2           VARCHAR2( 2000 );
      LSWHERESEARCHWITHINSTRING     VARCHAR2( 512 );
      LSWHEREFILTERSTRING           VARCHAR2( 2000 );
      LSWHERESEARCHTEXTSTRING       VARCHAR2( 500 );
      LSTEXT                        VARCHAR2( 4000 );
      LSREASON                      IAPITYPE.TEXT_TYPE;
      LNTEXTLENGTH                  IAPITYPE.NUMVAL_TYPE;
      LBFETCHNEXT                   BOOLEAN;
      LBFOUND                       BOOLEAN;
      LNOFFSET                      IAPITYPE.NUMVAL_TYPE;
      LRSEARCHRESULT                IAPITYPE.SEARCHRESULTSROW_TYPE;
   BEGIN
      
      
      

      
      
      
      
            
      LNRETVAL := TABLECOLUMNSSTRING1( ASSEARCHTYPE,
                                       LSTABLECOLUMNSSTRING1 );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LNRETVAL := TABLECOLUMNSSTRING2( ASSEARCHTYPE,
                                       LSTABLECOLUMNSSTRING2 );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := FROMTABLESSTRING1( ASSEARCHTYPE,
                                     LSFROMTABLESSTRING1 );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      LNRETVAL := FROMTABLESSTRING2( ASSEARCHTYPE,
                                     ANUSEMOP,
                                     ASPLANT,
                                     ASPLANTACCESS,
                                     ASPLANTS,
                                     LSFROMTABLESSTRING2 );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := WHERESEARCHWITHINSTRING( ASSEARCHTYPE,
                                           ANREFERENCETYPE,
                                           ANREFERENCEID,
                                           ANREFERENCEOWNER,
                                           LSWHERESEARCHWITHINSTRING );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL :=
         WHEREFILTERSTRING( ASSEARCHTYPE,
                            ANUSEMOP,
                            ASPLANT,
                            ANSPECIFICATIONTYPE,
                            ANSTATUS,
                            ASPLANTACCESS,
                            ASPLANTS,
                            ASSTATUSACCESS,
                            LSWHEREFILTERSTRING );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      LNRETVAL := WHERESEARCHTEXTSTRING( ASSEARCHTYPE,
                                         ASSEARCHTEXT,
                                         ANCASESENSITIVE,
                                         LSWHERESEARCHTEXTSTRING );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      







      LSSELECTSTRING :=
            'SELECT '
         || LSTABLECOLUMNSSTRING1
         || '  FROM '
         || LSFROMTABLESSTRING1
         || '       '
         || LSFROMTABLESSTRING2
         || ' WHERE '
         || LSWHERESEARCHWITHINSTRING
         || ' '
         || LSWHEREFILTERSTRING
         || '';
        
      
      
      
      IF (ASSEARCHTYPE = 'C')
      THEN
        LSSELECTSTRING := 'SELECT * FROM ('
                          || LSSELECTSTRING
                          || ') WHERE ' 
                          || LSWHERESEARCHTEXTSTRING;
      END IF;
      
            
      
      IF (ASSEARCHTYPE <> 'C')
      THEN
        LSSELECTSTRING := LSSELECTSTRING                           
                          || ' AND ' || LSWHERESEARCHTEXTSTRING;
      END IF;
      

               



      
      
      
       
      LICURSOR := DBMS_SQL.OPEN_CURSOR;
      
      DBMS_SQL.PARSE( LICURSOR,
                      LSSELECTSTRING,
                      DBMS_SQL.NATIVE );
      
      DBMS_SQL.DEFINE_COLUMN( LICURSOR,
                                   1,
                                   LSPARTNO,
                                   18 );
      DBMS_SQL.DEFINE_COLUMN( LICURSOR,
                              2,
                              LNREVISION );
      DBMS_SQL.DEFINE_COLUMN( LICURSOR,
                              3,
                              LNSECTIONID );
      DBMS_SQL.DEFINE_COLUMN( LICURSOR,
                              4,
                              LNSUBSECTIONID );
      DBMS_SQL.DEFINE_COLUMN( LICURSOR,
                              5,
                              LNREFERENCETYPE );
      DBMS_SQL.DEFINE_COLUMN( LICURSOR,
                              6,
                              LNREFERENCEID );
      DBMS_SQL.DEFINE_COLUMN( LICURSOR,
                              7,
                              LNREFERENCEVERSION );
      DBMS_SQL.DEFINE_COLUMN( LICURSOR,
                              8,
                              LNREFERENCEOWNER );
      DBMS_SQL.DEFINE_COLUMN( LICURSOR,
                                   9,
                                   LSPLANT,
                                   8 );
      DBMS_SQL.DEFINE_COLUMN( LICURSOR,
                              10,
                              LNALTERNATIVE );
      DBMS_SQL.DEFINE_COLUMN( LICURSOR,
                              11,
                              LNBOMUSAGE );
      DBMS_SQL.DEFINE_COLUMN( LICURSOR,
                              12,
                              LNLANGUAGEID );
      DBMS_SQL.DEFINE_COLUMN( LICURSOR,
                              13,
                              LDEXPLOSIONDATE );
      DBMS_SQL.DEFINE_COLUMN( LICURSOR,
                              14,
                              LNSYNONYMTYPE );

      IF ASSEARCHTYPE = 'I'
      THEN
         DBMS_SQL.DEFINE_COLUMN( LICURSOR,
                                      15,
                                      LSREASON,
                                      2000 );
      ELSE
         DBMS_SQL.DEFINE_COLUMN( LICURSOR,
                                 15,
                                 LSCLOBTEXT );
      END IF;

      DBMS_SQL.DEFINE_COLUMN( LICURSOR,
                              16,
                              LNLOGID );
      DBMS_SQL.DEFINE_COLUMN( LICURSOR,
                              17,
                              LNROWID );
      DBMS_SQL.DEFINE_COLUMN( LICURSOR,
                              18,
                              LNCOLID );
      
      
      LIRETURNVALUE := DBMS_SQL.EXECUTE( LICURSOR );

      LOOP
         
         LIRETURNVALUE := DBMS_SQL.FETCH_ROWS( LICURSOR );

         IF LIRETURNVALUE > 0
         THEN
            LBFETCHNEXT := TRUE;
            LBFOUND := FALSE;
            LNOFFSET := 1;
            
            DBMS_SQL.COLUMN_VALUE( LICURSOR,
                                        1,
                                        LSPARTNO );
            DBMS_SQL.COLUMN_VALUE( LICURSOR,
                                   2,
                                   LNREVISION );
            DBMS_SQL.COLUMN_VALUE( LICURSOR,
                                   3,
                                   LNSECTIONID );
            DBMS_SQL.COLUMN_VALUE( LICURSOR,
                                   4,
                                   LNSUBSECTIONID );
            DBMS_SQL.COLUMN_VALUE( LICURSOR,
                                   5,
                                   LNREFERENCETYPE );
            DBMS_SQL.COLUMN_VALUE( LICURSOR,
                                   6,
                                   LNREFERENCEID );
            DBMS_SQL.COLUMN_VALUE( LICURSOR,
                                   7,
                                   LNREFERENCEVERSION );
            DBMS_SQL.COLUMN_VALUE( LICURSOR,
                                   8,
                                   LNREFERENCEOWNER );
            DBMS_SQL.COLUMN_VALUE( LICURSOR,
                                        9,
                                        LSPLANT );
            DBMS_SQL.COLUMN_VALUE( LICURSOR,
                                   10,
                                   LNALTERNATIVE );
            DBMS_SQL.COLUMN_VALUE( LICURSOR,
                                   11,
                                   LNBOMUSAGE );
            DBMS_SQL.COLUMN_VALUE( LICURSOR,
                                   12,
                                   LNLANGUAGEID );
            DBMS_SQL.COLUMN_VALUE( LICURSOR,
                                   13,
                                   LDEXPLOSIONDATE );
            DBMS_SQL.COLUMN_VALUE( LICURSOR,
                                   14,
                                   LNSYNONYMTYPE );

            IF ASSEARCHTYPE = 'I'
            THEN
               DBMS_SQL.COLUMN_VALUE( LICURSOR,
                                           15,
                                           LSREASON );
               LSTEXT := RTRIM( LSREASON );
            ELSE
               
               DBMS_SQL.COLUMN_VALUE( LICURSOR,
                                      15,
                                      LSCLOBTEXT );
            END IF;

            DBMS_SQL.COLUMN_VALUE( LICURSOR,
                                   16,
                                   LNLOGID );
            DBMS_SQL.COLUMN_VALUE( LICURSOR,
                                   17,
                                   LNROWID );
            DBMS_SQL.COLUMN_VALUE( LICURSOR,
                                   18,
                                   LNCOLID );

            
            
















































              
              
    
            
            
            IF (1 = 1)
            
            THEN
               
               LSPARTNO := RTRIM( LSPARTNO );
               LSPLANT := RTRIM( LSPLANT );
               
               LRSEARCHRESULT.TEXT_SEARCH_NO := ANTEXTSEARCHNO;
               LRSEARCHRESULT.PART_NO := LSPARTNO;
               LRSEARCHRESULT.REVISION := LNREVISION;
               LRSEARCHRESULT.SECTION_ID := LNSECTIONID;
               LRSEARCHRESULT.SUB_SECTION_ID := LNSUBSECTIONID;
               LRSEARCHRESULT.REF_TYPE := LNREFERENCETYPE;
               LRSEARCHRESULT.REF_ID := LNREFERENCEID;
               LRSEARCHRESULT.REF_VER := LNREFERENCEVERSION;
               LRSEARCHRESULT.REF_OWNER := LNREFERENCEOWNER;
               LRSEARCHRESULT.PLANT := LSPLANT;
               LRSEARCHRESULT.ALTERNATIVE := LNALTERNATIVE;
               LRSEARCHRESULT.BOM_USAGE := LNBOMUSAGE;
               LRSEARCHRESULT.LANG_ID := LNLANGUAGEID;
               LRSEARCHRESULT.EXP_DATE := LDEXPLOSIONDATE;
               LRSEARCHRESULT.SYN_TYPE := LNSYNONYMTYPE;
               LRSEARCHRESULT.LOG_ID := LNLOGID;
               LRSEARCHRESULT.ROW_ID := LNROWID;
               LRSEARCHRESULT.COL_ID := LNCOLID;
               LNRETVAL := SEARCHRESULTINSERT( LRSEARCHRESULT );

               IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
               THEN
                  IAPIGENERAL.LOGERROR( GSSOURCE,
                                        LSMETHOD,
                                        IAPIGENERAL.GETLASTERRORTEXT( ) );
                  RETURN( LNRETVAL );
               END IF;
            END IF;
         ELSE
            
            EXIT;
         END IF;
      END LOOP;

      
      DBMS_SQL.CLOSE_CURSOR( LICURSOR );
            
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END SEARCHSIMPLE;

   FUNCTION SEARCH(
      ANTEXTSEARCHNO             IN OUT   IAPITYPE.SEQUENCE_TYPE,
      ASSEARCHTEXT               IN       IAPITYPE.STRINGVAL_TYPE,
      ANCASESENSITIVE            IN       IAPITYPE.BOOLEAN_TYPE,
      ANUSEMOP                   IN       IAPITYPE.BOOLEAN_TYPE,
      ASPLANT                    IN       IAPITYPE.PLANT_TYPE,
      ANSPECIFICATIONTYPE        IN       IAPITYPE.ID_TYPE,
      ANSTATUS                   IN       IAPITYPE.STATUSID_TYPE,
      ANREFERENCETYPE            IN       IAPITYPE.NUMVAL_TYPE,
      ANREFERENCEID              IN       IAPITYPE.ID_TYPE,
      ANREFERENCEOWNER           IN       IAPITYPE.OWNER_TYPE,
      ASSEARCHTYPE               IN       IAPITYPE.SEARCH_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS

































      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Search';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNTEXTSEARCHNO                IAPITYPE.SEQUENCE_TYPE;
      LICRITERIANUMBER              IAPITYPE.ID_TYPE;
      LTCRITERIAOPERATORS           IAPITYPE.OPERATORSTAB_TYPE;
      LTCRITERIATEXTS               IAPITYPE.TOKENSTAB_TYPE;
      LSPLANTACCESS                 IAPITYPE.ACCESS_TYPE;
      LSPLANTS                      IAPITYPE.STRING_TYPE;
      LSSTATUS                      IAPITYPE.STRING_TYPE;





   BEGIN


























      
      
      
      LNRETVAL := GETSEQUENCE( LNTEXTSEARCHNO );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      ANTEXTSEARCHNO := LNTEXTSEARCHNO;

      
      
      
      DELETE      ITTSRESULTS TR
            WHERE TR.TEXT_SEARCH_NO = LNTEXTSEARCHNO;

      
      
      
      
      IF ANCASESENSITIVE NOT IN( 0, 1 )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_INVALIDCASESENSITIVEPAR,
                                               ANCASESENSITIVE );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      
      IF ANUSEMOP NOT IN( 0, 1 )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_INVALIDMOPPARAMTER,
                                               ANUSEMOP );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      
      IF ASSEARCHTYPE NOT IN( 'F', 'R', 'A', 'L', 'I', 'N', 'C' )
      THEN
         LNRETVAL := IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_INVALIDSEARCHOPTION,
                                               ANUSEMOP );
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT );
         RETURN LNRETVAL;
      END IF;

      
      
      
      LNRETVAL := PARSERINITIALIZE( ASSEARCHTEXT,
                                    ANCASESENSITIVE,
                                    LICRITERIANUMBER,
                                    LTCRITERIAOPERATORS,
                                    LTCRITERIATEXTS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      
      
      LNRETVAL := USERACCESS( LSPLANTACCESS,
                              LSPLANTS,
                              LSSTATUS );

      IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               IAPIGENERAL.GETLASTERRORTEXT( ) );
         RETURN( LNRETVAL );
      END IF;

      
      
      IF     LSPLANTACCESS = 'Y'
         AND LSPLANTS IS NULL
      THEN
         
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
      END IF;

      
      
      
      IF ASSEARCHTYPE = 'A'
      THEN
         LNRETVAL :=
            SEARCHSIMPLE( LNTEXTSEARCHNO,
                          ASSEARCHTEXT,
                          ANCASESENSITIVE,
                          ANUSEMOP,
                          ASPLANT,
                          ANSPECIFICATIONTYPE,
                          ANSTATUS,
                          ANREFERENCETYPE,
                          ANREFERENCEID,
                          ANREFERENCEOWNER,
                          'F',
                          LICRITERIANUMBER,
                          LTCRITERIAOPERATORS,
                          LTCRITERIATEXTS,
                          LSPLANTACCESS,
                          LSPLANTS,
                          LSSTATUS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;

         LNRETVAL :=
            SEARCHSIMPLE( LNTEXTSEARCHNO,
                          ASSEARCHTEXT,
                          ANCASESENSITIVE,
                          ANUSEMOP,
                          ASPLANT,
                          ANSPECIFICATIONTYPE,
                          ANSTATUS,
                          ANREFERENCETYPE,
                          ANREFERENCEID,
                          ANREFERENCEOWNER,
                          'R',
                          LICRITERIANUMBER,
                          LTCRITERIAOPERATORS,
                          LTCRITERIATEXTS,
                          LSPLANTACCESS,
                          LSPLANTS,
                          LSSTATUS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
         END IF;
      ELSE
         LNRETVAL :=
            SEARCHSIMPLE( LNTEXTSEARCHNO,
                          ASSEARCHTEXT,
                          ANCASESENSITIVE,
                          ANUSEMOP,
                          ASPLANT,
                          ANSPECIFICATIONTYPE,
                          ANSTATUS,
                          ANREFERENCETYPE,
                          ANREFERENCEID,
                          ANREFERENCEOWNER,
                          ASSEARCHTYPE,
                          LICRITERIANUMBER,
                          LTCRITERIAOPERATORS,
                          LTCRITERIATEXTS,
                          LSPLANTACCESS,
                          LSPLANTS,
                          LSSTATUS );

         IF ( LNRETVAL <> IAPICONSTANTDBERROR.DBERR_SUCCESS )
         THEN
            IAPIGENERAL.LOGERROR( GSSOURCE,
                                  LSMETHOD,
                                  IAPIGENERAL.GETLASTERRORTEXT( ) );
            RETURN( LNRETVAL );
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
   END SEARCH;
END IAPITEXTSEARCH;
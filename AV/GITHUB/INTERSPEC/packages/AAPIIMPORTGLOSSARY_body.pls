create or replace PACKAGE BODY aapiImportGlossary
AS
 psSource CONSTANT iapiType.Source_Type := 'INTERSPC.aapiImportGlossary';

   PROCEDURE ImportGlossary
   IS
----------------------------------------------------------------------------
--  Abstract: This procedure loops over the table atimportgloss, and creates
--            glossary items, if they don't exist yet (case insensitive)
--            Implemented types are:
--              * SC: section
--              * SB: subsection
--              * PG: property group
--              * SP: property
--              * HD: column heading
--              * AT: Attribute
--              * UM: Unit of measurement
--              * CH: Characteristic
--              * KCH: Keyword Characteristic
--              * AS: Association
--              * FT: free text
--              * DF: Display Format
--              * TM: Test Method
--              * AG: Access Group
--              * UG: User Group
--              * IG: Ingredient
--              * KW: Specification Keyword (description2: Free Data, List, External Data)
--              * PGSP: Property Group / property relationship
--              * PGDF: Property Group / Display Format relationship
--              * SPAT: Property / Attribute relationship
--              * SPAS: Property / Association relationship
--              * SPTM: Property / Test Method relationship
--              * ASCH: Association / Characteristic relationship
--              * KWCH: Key Word / Characteristic relationship
--              * ASUM: Association / UoM relationship
----------------------------------------------------------------------------
      csMethod   CONSTANT iapiType.Method_Type           := 'ImportGlossary';
      
       TYPE table_remarks  IS TABLE OF VARCHAR2(255)       INDEX BY BINARY_INTEGER;
      TYPE table_returncodes   IS TABLE OF NUMBER             INDEX BY BINARY_INTEGER;
      TYPE table_rowid  IS TABLE OF ROWID           INDEX BY BINARY_INTEGER;
      --State variables
      ltb_rowid           table_rowid;
      ltb_remarks         table_remarks;
      ltb_returncodes     table_returncodes;
      lnStackPointer      INTEGER;
      lnStackCounter      INTEGER;
      lsType              atImpGloss.TYPE%TYPE;
      lsDescription       atImpGloss.description%TYPE;
      lsDescription2      atImpGloss.description2%TYPE;
      lsMsg               atImpGloss.remarks%TYPE;
      --Workers
      lnReturnCode        atImpGloss.returncode%TYPE;
      lnCount             NUMBER;
      lnPG                iapiType.Id_Type;
      lnSP                iapiType.Id_Type;
      lnDF                iapiType.Id_Type;
      lnAT                iapiType.Id_Type;
      lnUG                iapiType.UserGroupId_Type;
      lnAG                iapiType.Id_Type;
      lnAS                iapiType.Id_Type;
      lnCH                iapiType.Id_Type;
      lnKW                iapiType.KeywordId_Type;
      lnTM                iapiType.Id_Type;
      lnUM                iapiType.BaseUom_Type;
      lnKeywordType       iapiType.Keyword_Type;

      CURSOR lqGlossary
      IS
         SELECT   description, description2, TYPE, ROWID
             FROM atImpGloss
            WHERE date_processed IS NULL
         ORDER BY LENGTH(TYPE), TYPE, description;
   --so that links are processed after all glossary items
   BEGIN
      aapiTrace.Enter();

      DBMS_OUTPUT.PUT_LINE(iapiGeneral.SetConnection('SIEMENS'));
      lnStackCounter    := 0;

      FOR lrGlossItem IN lqGlossary
      LOOP
         lsMsg                              := NULL;
         lnReturnCode                       := 0;
         lsType                             := UPPER(lrGlossItem.TYPE);
         lsDescription                      := TRIM(lrGlossItem.description);
         lsDescription2                     := TRIM(lrGlossItem.description2);
         lnCount                            := 0;

         CASE
            WHEN lsType = 'SC'
            THEN
               --Section--
               SELECT COUNT(description)
                 INTO lnCount
                 FROM section
                WHERE UPPER(description) = UPPER(lsDescription);

               IF lnCount = 0
               THEN
                  INSERT INTO SECTION
                              (SECTION_ID, DESCRIPTION, INTL,
                               STATUS
                              )
                       VALUES (section_seq_intl.NEXTVAL, lsDescription, '1',
                               0
                              );
               ELSE
                  lsMsg           :=
                           'Section [' || lsDescription || '] already exists';
                  lnReturnCode    := 1;
               END IF;
            WHEN lsType = 'SB'
            THEN
               --Sub Section--
               SELECT COUNT(description)
                 INTO lnCount
                 FROM sub_section
                WHERE UPPER(description) = UPPER(lsDescription);

               IF lnCount = 0
               THEN
                  INSERT INTO SUB_SECTION
                              (SUB_SECTION_ID, DESCRIPTION,
                               INTL, STATUS
                              )
                       VALUES (sub_section_seq_intl.NEXTVAL, lsDescription,
                               '1', 0
                              );
               ELSE
                  lsMsg           :=
                       'Sub-section [' || lsDescription || '] already exists';
                  lnReturnCode    := 1;
               END IF;
            WHEN lsType = 'PG'
            THEN
               --Property Group--
               SELECT COUNT(description)
                 INTO lnCount
                 FROM property_group
                WHERE UPPER(description) = UPPER(lsDescription);

               IF lnCount = 0
               THEN
                  INSERT INTO PROPERTY_GROUP
                              (PROPERTY_GROUP,
                               DESCRIPTION, INTL, STATUS, PG_TYPE
                              )
                       VALUES (property_group_seq_intl.NEXTVAL,
                               lsDescription, '1', 0, 1
                              );
               ELSE
                  lsMsg           :=
                     'Property group [' || lsDescription
                     || '] already exists';
                  lnReturnCode    := 1;
               END IF;
             WHEN lsType = 'DF'
            THEN
               --Property Group--
               SELECT COUNT(description)
                 INTO lnCount
                 FROM layout
                WHERE UPPER(description) = UPPER(lsDescription);

               IF lnCount = 0
               THEN
                  INSERT INTO LAYOUT
                              (LAYOUT_ID, DESCRIPTION, INTL, STATUS, 
                               CREATED_BY, CREATED_ON, LAST_MODIFIED_BY, LAST_MODIFIED_ON, REVISION)
                       VALUES (layout_seq_intl.NEXTVAL, lsDescription, '1', 2, 
                                'INTERSPC', SYSDATE, 'INTERSPC', sysdate,1
                              );
               ELSE
                  lsMsg           :=
                     'Layout [' || lsDescription
                     || '] already exists';
                  lnReturnCode    := 1;
               END IF;
            WHEN lsType = 'SP'
            THEN
               --Single Property--
               SELECT COUNT(description)
                 INTO lnCount
                 FROM property
                WHERE UPPER(description) = UPPER(lsDescription);

               IF lnCount = 0
               THEN
                  INSERT INTO PROPERTY
                              (PROPERTY, DESCRIPTION,
                               INTL, STATUS
                              )
                       VALUES (property_seq_intl.NEXTVAL, lsDescription,
                               '1', 0
                              );
               ELSE
                  lsMsg           :=
                          'Property [' || lsDescription || '] already exists';
                  lnReturnCode    := 1;
               END IF;
            WHEN lsType = 'HD'
            THEN
               --Column Header--
               SELECT COUNT(description)
                 INTO lnCount
                 FROM header
                WHERE UPPER(description) = UPPER(lsDescription);

               IF lnCount = 0
               THEN
                  INSERT INTO HEADER
                              (HEADER_ID, DESCRIPTION, INTL, STATUS
                              )
                       VALUES (header_seq_intl.NEXTVAL, lsDescription, '1', 0
                              );
               ELSE
                  lsMsg           :=
                            'Header [' || lsDescription || '] already exists';
                  lnReturnCode    := 1;
               END IF;
            WHEN lsType = 'AT'
            THEN
               --Attribute--
               SELECT COUNT(description)
                 INTO lnCount
                 FROM ATTRIBUTE
                WHERE UPPER(description) = UPPER(lsDescription);

               IF lnCount = 0
               THEN
                  INSERT INTO ATTRIBUTE
                              (ATTRIBUTE, DESCRIPTION,
                               INTL, STATUS
                              )
                       VALUES (attribute_seq_intl.NEXTVAL, lsDescription,
                               '1', 0
                              );
               ELSE
                  lsMsg           :=
                         'Attribute [' || lsDescription || '] already exists';
                  lnReturnCode    := 1;
               END IF;
            WHEN lsType = 'UM'
            THEN
               --UOM--
               SELECT COUNT(description)
                 INTO lnCount
                 FROM uom
                WHERE UPPER(description) = UPPER(lsDescription);

               IF lnCount = 0
               THEN
                  INSERT INTO UOM
                              (UOM_ID, DESCRIPTION, INTL, STATUS
                              )
                       VALUES (uom_seq_intl.NEXTVAL, lsDescription, '1', 0
                              );
               ELSE
                  lsMsg           :=
                        'Unit of Measurement ['
                     || lsDescription
                     || '] already exists';
                  lnReturnCode    := 1;
               END IF;
            WHEN lsType = 'CH'
            THEN
               --Characteristic--
               SELECT COUNT(description)
                 INTO lnCount
                 FROM characteristic
                WHERE UPPER(description) = UPPER(lsDescription);

               IF lnCount = 0
               THEN
                  INSERT INTO CHARACTERISTIC
                              (CHARACTERISTIC_ID,
                               DESCRIPTION, INTL, STATUS
                              )
                       VALUES (characteristic_seq_intl.NEXTVAL,
                               lsDescription, '1', 0
                              );
               ELSE
                  lsMsg           :=
                     'Characteristic [' || lsDescription
                     || '] already exists';
                  lnReturnCode    := 1;
               END IF;
            WHEN lsType = 'KCH'
            THEN
               --Keyword Characteristic--
               SELECT COUNT(description)
                 INTO lnCount
                 FROM itkwch
                WHERE UPPER(description) = UPPER(lsDescription);

               IF lnCount = 0
               THEN
                  INSERT INTO ITKWCH
                              (CH_ID,
                               DESCRIPTION, INTL, STATUS
                              )
                       VALUES (kwch_seq_intl.NEXTVAL,
                               lsDescription, '1', 0
                              );
               ELSE
                  lsMsg           :=
                     'Keyword Characteristic [' || lsDescription
                     || '] already exists';
                  lnReturnCode    := 1;
               END IF;
            WHEN lsType = 'KC'
            THEN
               --Key Word Characteristic --
               SELECT COUNT(description)
                 INTO lnCount
                 FROM itkwch
                WHERE UPPER(description) = UPPER(lsDescription);

               IF lnCount = 0
               THEN
                  INSERT INTO ITKWCH
                              (CH_ID, DESCRIPTION, INTL, STATUS
                              )
                       VALUES (kwch_seq_intl.NEXTVAL, lsDescription, '1', 0
                              );
               ELSE
                  lsMsg           :=
                        'Keyword Characteristic ['
                     || lsDescription
                     || '] already exists';
                  lnReturnCode    := 1;
               END IF;
            WHEN lsType = 'AS'
            THEN
               --Association--
               SELECT COUNT(description)
                 INTO lnCount
                 FROM association
                WHERE UPPER(description) = UPPER(lsDescription);

               IF lnCount = 0
               THEN
                  INSERT INTO ASSOCIATION
                              (ASSOCIATION, DESCRIPTION,
                               ASSOCIATION_TYPE, INTL, STATUS
                              )
                       VALUES (association_seq_intl.NEXTVAL, lsDescription,
                               'C', '1', 0
                              );
               ELSE
                  lsMsg           :=
                       'Association [' || lsDescription || '] already exists';
                  lnReturnCode    := 1;
               END IF;
            WHEN lsType = 'TM'
            THEN
               --Test Method --
               SELECT COUNT(description)
                 INTO lnCount
                 FROM test_method
                WHERE UPPER(description) = UPPER(lsDescription);

               IF lnCount = 0
               THEN
                  INSERT INTO test_method
                              (TEST_METHOD, DESCRIPTION,
                               INTL, STATUS, LONG_DESCR
                              )
                       VALUES (test_method_seq_intl.NEXTVAL, lsDescription,
                               '1', 0, lsDescription
                              );
               ELSE
                  lsMsg           :=
                       'Test Method [' || lsDescription || '] already exists';
                  lnReturnCode    := 1;
               END IF;
            WHEN lsType = 'FT'
            THEN
               --Free Text--
               SELECT COUNT(description)
                 INTO lnCount
                 FROM text_type
                WHERE UPPER(description) = UPPER(lsDescription);

               IF lnCount = 0
               THEN
                  INSERT INTO TEXT_TYPE
                              (TEXT_TYPE, DESCRIPTION,
                               PROCESS_FLAG, INTL, STATUS
                              )
                       VALUES (text_type_seq_intl.NEXTVAL, lsDescription,
                               'N', '1', 0
                              );
               ELSE
                  lsMsg           :=
                         'Free text [' || lsDescription || '] already exists';
                  lnReturnCode    := 1;
               END IF;
            WHEN lsType = 'UG'
            THEN
               --User Group--
               BEGIN
                  lnUG    := 0;

                  SELECT COUNT(*)
                    INTO lnUG
                    FROM user_group
                   WHERE UPPER(short_desc) = UPPER(lsDescription)
                      OR UPPER(description) = UPPER(lsDescription2);

                  IF lnUG = 0
                  THEN
                     INSERT INTO USER_GROUP
                                 (DESCRIPTION, USER_GROUP_ID,
                                  SHORT_DESC
                                 )
                          VALUES (lsDescription2, user_group_id_seq.NEXTVAL,
                                  lsDescription
                                 );
                  ELSE
                     lsMsg           :=
                        'User group [' || lsDescription || '] already exists';
                     lnReturnCode    := 1;
                  END IF;
               END;
            WHEN lsType = 'AG'
            THEN
               --Access Group--
               BEGIN
                  lnAG    := 0;

                  SELECT COUNT(*)
                    INTO lnAG
                    FROM access_group
                   WHERE UPPER(sort_desc) = UPPER(lsDescription)
                      OR UPPER(description) = UPPER(lsDescription2);

                  IF lnAG = 0
                  THEN
                     INSERT INTO ACCESS_GROUP
                                 (ACCESS_GROUP, SORT_DESC,
                                  DESCRIPTION
                                 )
                          VALUES (access_group_seq.NEXTVAL, lsDescription,
                                  lsDescription2
                                 );
                  ELSE
                     lsMsg           :=
                        'Access group [' || lsDescription
                        || '] already exists';
                     lnReturnCode    := 1;
                  END IF;
               END;
            WHEN lsType = 'IG'
            THEN
               --Ingredient--
               SELECT COUNT(description)
                 INTO lnCount
                 FROM iting
                WHERE UPPER(description) = UPPER(lsDescription);

               IF lnCount = 0
               THEN
                  INSERT INTO ITING
                              (INGREDIENT, DESCRIPTION,
                               INTL, STATUS, ING_TYPE, RECFAC, ALLERGEN, SOI
                              )
                       VALUES (ingredient_seq_intl.NEXTVAL, lsDescription,
                               '1', 0, 'I', NULL, 'N', 'N'
                              );
               ELSE
                  lsMsg           :=
                        'Ingredient [' || lsDescription || '] already exists';
                  lnReturnCode    := 1;
               END IF;
            WHEN lsType = 'KW'
            THEN
               --Specification Keyword--
               SELECT COUNT(description)
                 INTO lnCount
                 FROM itkw
                WHERE UPPER(description) = UPPER(lsDescription);

               IF lnCount = 0
               THEN
                  CASE UPPER(lsDescription2)
                     WHEN 'FREE DATA'
                     THEN
                        lnKeywordType    := 0;
                     WHEN 'LIST'
                     THEN
                        lnKeywordType    := 1;
                     WHEN 'EXTERNAL DATA'
                     THEN
                        lnKeywordType    := 2;
                     ELSE
                        lnKeywordType    := -1;
                  END CASE;

                  IF lnKeywordType >= 0
                  THEN
                     INSERT INTO ITKW
                                 (KW_ID, DESCRIPTION,
                                  KW_TYPE, INTL, STATUS,
                                  KW_USAGE
                                 )
                          VALUES (kw_seq_intl.NEXTVAL, lsDescription,
                                  lnKeywordType, '1', 0,
                                  iapiConstant.KeywordUsage_Specification
                                 );
                  ELSE
                     lsMsg           :=
                            'Invalid keyword type [' || lsDescription2 || ']';
                     lnReturnCode    := 1;
                  END IF;
               ELSE
                  lsMsg           :=
                        'Specification Keyword ['
                     || lsDescription
                     || '] already exists';
                  lnReturnCode    := 1;
               END IF;
            WHEN lsType = 'PGSP'
            THEN
               --Property Group / Property relationship --
               BEGIN
                  lnPG    := 0;
                  lnSP    := 0;

                  SELECT property_group
                    INTO lnPG
                    FROM property_group
                   WHERE UPPER(description) = UPPER(lsDescription)
                     AND status = 0;

                  SELECT property
                    INTO lnSP
                    FROM property
                   WHERE UPPER(description) = UPPER(lsDescription2)
                     AND status = 0;

                  IF lnPG > 0 AND lnSP > 0
                  THEN
                     INSERT INTO PROPERTY_GROUP_LIST
                                 (PROPERTY_GROUP, PROPERTY, MANDATORY, INTL
                                 )
                          VALUES (lnPG, lnSP, 'N', '1'
                                 );
                  ELSE
                     lsMsg           :=
                                       'Property or property group not found';
                     lnReturnCode    := 1;
                  END IF;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     lsMsg           :=
                                       'Property or property group not found';
                     lnReturnCode    := 2;
                  WHEN DUP_VAL_ON_INDEX
                  THEN
                     lsMsg           := 'Relationship already exists';
                     lnReturnCode    := 1;
                  WHEN OTHERS
                  THEN
                     lnReturnCode    := 3;
                     lsMsg           := 'Unable to load';
               END;
            WHEN lsType = 'SPTM'
            THEN
               --Property / Test Method relationship --
               BEGIN
                  lnTM    := 0;
                  lnSP    := 0;

                  SELECT property
                    INTO lnSP
                    FROM property
                   WHERE UPPER(description) = UPPER(lsDescription)
                     AND status = 0;

                  SELECT test_method
                    INTO lnTM
                    FROM test_method
                   WHERE UPPER(description) = UPPER(lsDescription2)
                     AND status = 0;

                  IF lnTM > 0 AND lnSP > 0
                  THEN
                     INSERT INTO PROPERTY_TEST_METHOD
                                 (TEST_METHOD, PROPERTY, INTL
                                 )
                          VALUES (lnTM, lnSP, '1'
                                 );
                  ELSE
                     lsMsg           := 'Property or test_method not found';
                     lnReturnCode    := 1;
                  END IF;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     lsMsg           := 'Property or test_method not found';
                     lnReturnCode    := 2;
                  WHEN DUP_VAL_ON_INDEX
                  THEN
                     lsMsg           := 'Relationship already exists';
                     lnReturnCode    := 1;
                  WHEN OTHERS
                  THEN
                     lnReturnCode    := 3;
                     lsMsg           := 'Unable to load';
               END;
            WHEN lsType = 'SPAS'
            THEN
               --Property / Association relationship --
               BEGIN
                  lnAS    := 0;
                  lnSP    := 0;

                  SELECT property
                    INTO lnSP
                    FROM property
                   WHERE UPPER(description) = UPPER(lsDescription)
                     AND status = 0;

                  SELECT association
                    INTO lnAS
                    FROM association
                   WHERE UPPER(description) = UPPER(lsDescription2)
                     AND status = 0;

                  IF lnAS > 0 AND lnSP > 0
                  THEN
                     INSERT INTO PROPERTY_ASSOCIATION
                                 (PROPERTY, ASSOCIATION, INTL
                                 )
                          VALUES (lnSP, lnAS, '1'
                                 );
                  ELSE
                     lsMsg           := 'Property or Association not found';
                     lnReturnCode    := 1;
                  END IF;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     lsMsg           := 'Property or Assocation not found';
                     lnReturnCode    := 2;
                  WHEN DUP_VAL_ON_INDEX
                  THEN
                     lsMsg           := 'Relationship already exists';
                     lnReturnCode    := 1;
                  WHEN OTHERS
                  THEN
                     lnReturnCode    := 3;
                     lsMsg           := 'Unable to load';
               END;
            WHEN lsType = 'PGDF'
            THEN
               --Property Group / Display Format relationship --
               BEGIN
                  lnPG    := 0;
                  lnDF    := 0;

                  SELECT property_group
                    INTO lnPG
                    FROM property_group
                   WHERE UPPER(description) = UPPER(lsDescription)
                     AND status = 0;

                  SELECT layout_id
                    INTO lnDF
                    FROM layout
                   WHERE UPPER(description) = UPPER(lsDescription2)
                     AND status = 2;

                  IF lnPG > 0 AND lnDF > 0
                  THEN
                     INSERT INTO INTERSPC.PROPERTY_GROUP_DISPLAY
                                 (PROPERTY_GROUP, DISPLAY_FORMAT, INTL
                                 )
                          VALUES (lnPG, lnDF, '1'
                                 );
                  ELSE
                     lsMsg           :=
                                 'Property group or display format not found';
                     lnReturnCode    := 1;
                  END IF;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     lsMsg           :=
                                 'Property group or display format not found';
                     lnReturnCode    := 2;
                  WHEN DUP_VAL_ON_INDEX
                  THEN
                     lsMsg           := 'Relationship already exists';
                     lnReturnCode    := 1;
                  WHEN OTHERS
                  THEN
                     lsMsg           := 'Unable to load';
                     lnReturnCode    := 3;
               END;
            WHEN lsType = 'SPAT'
            THEN
               --Property / Attribute relationship --
               BEGIN
                  lnSP    := 0;
                  lnAT    := 0;

                  SELECT property
                    INTO lnSP
                    FROM property
                   WHERE UPPER(description) = UPPER(lsDescription)
                     AND status = 0;

                  SELECT ATTRIBUTE
                    INTO lnAT
                    FROM ATTRIBUTE
                   WHERE UPPER(description) = UPPER(lsDescription2)
                     AND status = 0;

                  IF lnSP > 0 AND lnAT > 0
                  THEN
                     INSERT INTO INTERSPC.ATTRIBUTE_PROPERTY
                                 (PROPERTY, ATTRIBUTE, INTL
                                 )
                          VALUES (lnSP, lnAT, '1'
                                 );
                  ELSE
                     lsMsg           := 'Property or attribute not found';
                     lnReturnCode    := 1;
                  END IF;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     lsMsg           := 'Property or attribute not found';
                     lnReturnCode    := 2;
                  WHEN DUP_VAL_ON_INDEX
                  THEN
                     lsMsg           := 'Relationship already exists';
                     lnReturnCode    := 1;
                  WHEN OTHERS
                  THEN
                     lsMsg           := 'Unable to load';
                     lnReturnCode    := 3;
               END;
            WHEN lsType = 'ASCH'
            THEN
               --Association / Characteristic relationship --
               BEGIN
                  lnAS    := 0;
                  lnCH    := 0;

                  SELECT association
                    INTO lnAS
                    FROM association
                   WHERE UPPER(description) = UPPER(lsDescription)
                     AND status = 0;

                  SELECT characteristic_id
                    INTO lnCH
                    FROM characteristic
                   WHERE UPPER(description) = UPPER(lsDescription2)
                     AND status = 0;

                  IF lnAS > 0 AND lnCH > 0
                  THEN
                     INSERT INTO INTERSPC.CHARACTERISTIC_ASSOCIATION
                                 (ASSOCIATION, CHARACTERISTIC, INTL
                                 )
                          VALUES (lnAS, lnCH, '1'
                                 );
                  ELSE
                     lsMsg           :=
                                    'Association or characteristic not found';
                     lnReturnCode    := 1;
                  END IF;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     lsMsg           :=
                                    'Association or characteristic not found';
                     lnReturnCode    := 2;
                  WHEN DUP_VAL_ON_INDEX
                  THEN
                     lsMsg           := 'Relationship already exists';
                     lnReturnCode    := 1;
                  WHEN OTHERS
                  THEN
                     lsMsg           := 'Unable to load';
                     lnReturnCode    := 3;
               END;
            WHEN lsType = 'ASUM'
            THEN
               --Association / UOM relationship --
               BEGIN
                  lnAS    := 0;
                  lnUM    := 0;

                  SELECT association
                    INTO lnAS
                    FROM association
                   WHERE UPPER(description) = UPPER(lsDescription)
                     AND status = 0;

                  SELECT UOM_id
                    INTO lnUM
                    FROM uom
                   WHERE UPPER(description) = UPPER(lsDescription2)
                     AND status = 0;

                  IF lnAS > 0 AND lnUM > 0
                  THEN
                     INSERT INTO INTERSPC.UOM_ASSOCIATION
                                 (ASSOCIATION, UOM, LOWER_REJECT,
                                  UPPER_REJECT, INTL
                                 )
                          VALUES (lnAS, lnUM, NULL,
                                  NULL, '1'
                                 );
                  ELSE
                     lsMsg           := 'Association or Uom not found';
                     lnReturnCode    := 1;
                  END IF;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     lsMsg           := 'Association or Uom not found';
                     lnReturnCode    := 2;
                  WHEN DUP_VAL_ON_INDEX
                  THEN
                     lsMsg           := 'Relationship already exists';
                     lnReturnCode    := 1;
                  WHEN OTHERS
                  THEN
                     lsMsg           := 'Unable to load';
                     lnReturnCode    := 3;
               END;
            WHEN lsType = 'KWCH'
            THEN
               --Key Word / Characteristic relationship --
               BEGIN
                  lnKW    := 0;
                  lnCH    := 0;

                  SELECT kw_id
                    INTO lnKW
                    FROM itkw
                   WHERE UPPER(description) = UPPER(lsDescription)
                     AND status = 0
                     AND kw_type = 1;

                  SELECT ch_id
                    INTO lnCH
                    FROM itkwch
                   WHERE UPPER(description) = UPPER(lsDescription2)
                     AND status = 0;

                  IF lnKW > 0 AND lnCH > 0
                  THEN
                     INSERT INTO ITKWAS
                                 (kw_id, ch_id, INTL
                                 )
                          VALUES (lnKW, lnCH, '1'
                                 );
                  ELSE
                     lsMsg           := 'Keyword or characteristic not found';
                     lnReturnCode    := 1;
                  END IF;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     lsMsg           := 'Keyword or characteristic not found';
                     lnReturnCode    := 2;
                  WHEN DUP_VAL_ON_INDEX
                  THEN
                     lsMsg           := 'Relationship already exists';
                     lnReturnCode    := 1;
                  WHEN OTHERS
                  THEN
                     lsMsg           := 'Unable to load';
                     lnReturnCode    := 3;
               END;
            ELSE
               lsMsg    := 'Type not recognized';
         END CASE;

         lnStackCounter                     := lnStackCounter + 1;
         ltb_rowid(lnStackCounter)          := lrGlossItem.ROWID;
         ltb_remarks(lnStackCounter)        := lsMsg;
         ltb_returncodes(lnStackCounter)    := lnReturnCode;
         COMMIT;
      END LOOP;

      FOR lnStackPointer IN 1 .. lnStackCounter
      LOOP
         UPDATE atImpGloss
            SET date_processed = SYSDATE,
                remarks = ltb_remarks(lnStackPointer),
                returncode = ltb_returncodes(lnStackPointer)
          WHERE ROWID = ltb_rowid(lnStackPointer);
      END LOOP;

      COMMIT;
      
      aapiTrace.Exit();
   EXCEPTION
      WHEN OTHERS
      THEN
         IF lqGlossary%ISOPEN
         THEN
            CLOSE lqGlossary;
         END IF;

         iapiGeneral.LogError(asSource       => psSource,
                              asMethod       => csMethod,
                              asMessage      => SQLERRM
                             );
      aapiTrace.Error(SQLERRM);
      aapiTrace.Exit();
   END ImportGlossary;
END aapiImportGlossary;
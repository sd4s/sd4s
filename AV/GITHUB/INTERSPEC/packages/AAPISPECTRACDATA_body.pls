create or replace PACKAGE BODY          aapiSpectracData
AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : aapiSpectracData
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 03/08/2007
--   TARGET : Oracle 10.2.0
--  VERSION : av 1.1
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 03/08/2007 | RS        | Created
-- 16/01/2008 | RS        | Changed all queries, added column applic
-- 30/01/2008 | RS        | Changed GetValue : LogError --> LogInfo
-- 10/03/2011 | RS        | Upgrade V6.3
-- 03/07/2012 | RS        | Changed GetIdFromDescription
-- 04/03/2014 | MVL       | Added more descriptive error logging
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
   /*///////////////////////////////////////////////////
   //                                                 //
   // INFORMATION RETRIEVAL ABOUT SPECIFIC ELEMENTS   //
   //                                                 //
   ///////////////////////////////////////////////////*/
   FUNCTION GetIdFromDescription(
      asDescription    IN   iapiType.Description_Type,
      asGlossaryType   IN   GlossaryType_Type)
      RETURN iapiType.Id_Type
   IS
      lsID   iapiType.Id_Type := NULL;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asDescription', asDescription);
      aapiTrace.Param('asGlossaryType', asGlossaryType);
      
      BEGIN
         CASE asGlossaryType
            WHEN GLOSS_KEYWORD
            THEN
               SELECT kw_id
               INTO   lsID
               FROM   itkw
               WHERE  description = asDescription;
            WHEN GLOSS_SECTION
            THEN
               SELECT section_id
               INTO   lsID
               FROM   section_h -- RS20120703 : use _h to find higher revisions
               WHERE  description = asDescription AND max_rev = 1 AND lang_id = 1;
            WHEN GLOSS_SUBSECTION
            THEN
               SELECT sub_section_id
               INTO   lsID
               FROM   sub_section_h -- RS20120703 : use _h to find higher revisions
               WHERE  description = asDescription AND max_rev = 1 AND lang_id = 1;
            WHEN GLOSS_PROPERTYGROUP
            THEN
               SELECT property_group
               INTO   lsID
               FROM   property_group_h -- RS20120703 : use _h to find higher revisions
               WHERE  description = asDescription AND max_rev = 1 AND lang_id = 1;
            WHEN GLOSS_PROPERTY
            THEN
               --SELECT property
               --INTO   lsID
               --FROM   property_h -- RS20120703 : use _h to find higher revisions
               --WHERE  description = asDescription AND max_rev = 1 AND lang_id = 1;
               
               --Select latest property with name, instead of current. Allow for renaming.
               SELECT property
               INTO lsID
               FROM (
                  SELECT property, MAX(last_modified_on) AS last_modified_on
                  FROM property_h
                  WHERE description = asDescription
                  AND lang_id = 1
                  GROUP BY property
                  ORDER BY last_modified_on DESC
               ) WHERE rownum = 1;
            WHEN GLOSS_CHARACTERISTIC
            THEN
               SELECT characteristic_id
               INTO   lsID
               FROM   characteristic_h -- RS20120703 : use _h to find higher revisions
               WHERE  description = asDescription AND max_rev = 1 AND lang_id = 1;
            ELSE
               lsID := NULL;
         END CASE;
      EXCEPTION
         WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
         THEN
            lsID := NULL;
      END;

      aapiTrace.Exit(lsID);
      RETURN lsID;
   END GetIdFromDescription;

   /*///////////////////////////////////////////
   //                                         //
   // RETRIEVING DATA FROM THE FUNCTIONAL BOM //
   //                                         //
   ///////////////////////////////////////////*/
   FUNCTION GetValue(
      asLevel           IN       iapiType.String_Type,
      asSpecHeader      IN       iapiType.Description_Type,
      asKeyword         IN       iapiType.Description_Type,
      anAttachedSpecs   IN       iapiType.Boolean_Type,
      asSection         IN       iapiType.Description_Type,
      asSubSection      IN       iapiType.Description_Type,
      asPropertyGroup   IN       iapiType.Description_Type,
      asProperty        IN       iapiType.Description_Type,
      anFieldType       IN       iapiType.Id_Type,
      asValue           OUT      iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type   := 'GetValue - DESCRIPTION';
      lnRetVal            iapiType.ErrorNum_Type;
      lsIntLevel          iapiType.String_Type;
      lnKeywordId         iapiType.Id_Type;
      lnSectionId         iapiType.Id_Type;
      lnSubSectionId      iapiType.Id_Type;
      lnPropertyGroupId   iapiType.Id_Type;
      lnPropertyId        iapiType.Id_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asLevel', asLevel);
      aapiTrace.Param('asSpecHeader', asSpecHeader);
      aapiTrace.Param('asKeyword', asKeyword);
      aapiTrace.Param('anAttachedSpecs', anAttachedSpecs);
      aapiTrace.Param('asSection', asSection);
      aapiTrace.Param('asSubSection', asSubSection);
      aapiTrace.Param('asPropertyGroup', asPropertyGroup);
      aapiTrace.Param('asProperty', asProperty);
      aapiTrace.Param('anFieldType', anFieldType);
      
      iapiGeneral.LogInfo(psSource,
                          csMethod,
                             'Called for <'
                          || asLevel
                          || '><'
                          || asSpecHeader
                          || '><'
                          || asKeyword
                          || '><'
                          || anAttachedSpecs
                          || '><'
                          || asSection
                          || '><'
                          || asSubSection
                          || '><'
                          || asPropertyGroup
                          || '><'
                          || asProperty
                          || '><'
                          || anFieldType
                          || '>');
      
      lnKeywordId := GetIdFromDescription(asKeyword, GLOSS_KEYWORD);
      lnSectionId := GetIdFromDescription(asSection, GLOSS_SECTION);
      lnSubSectionId := GetIdFromDescription(asSubSection, GLOSS_SUBSECTION);
      lnPropertyGroupId := GetIdFromDescription(asPropertyGroup, GLOSS_PROPERTYGROUP);
      lnPropertyId := GetIdFromDescription(asProperty, GLOSS_PROPERTY);
      
      iapiGeneral.LogInfo(psSource,
                          csMethod,
                             'Corresponding IDs <'
                          || lnKeywordId
                          || '><'
                          || lnSectionId
                          || '><'
                          || lnSubSectionId
                          || '><'
                          || lnPropertyGroupId
                          || '><'
                          || lnPropertyId
                          || '>');
      
      lsIntLevel := aapiSpectracBom.GetInternalLevel(asLevel);
      
      iapiGeneral.LogInfo(psSource, csMethod, 'lsIntLevel: <' || lsIntLevel || '>');
      
      lnRetVal :=
         GetValue(asIntLevel             => lsIntLevel,
                  asSpecHeader           => asSpecHeader,
                  anKeywordId            => lnKeywordId,
                  anAttachedSpecs        => anAttachedSpecs,
                  anSectionId            => lnSectionId,
                  anSubSectionId         => lnSubSectionId,
                  anPropertyGroupId      => lnPropertyGroupId,
                  anPropertyId           => lnPropertyId,
                  anFieldType            => anFieldType,
                  asValue                => asValue);

      IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
      THEN
         iapiGeneral.LogError(psSource,
                              csMethod,
                              'Error retrieving data: ' || iapiGeneral.GetLastErrorText);
         aapiTrace.Error(iapiGeneral.GetLastErrorText);
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapiConstantDbError.DBERR_GENFAIL;
      ELSE
         iapiGeneral.LogInfo(psSource,
                             csMethod,
                             'Data retrieval completed, returning <' || asValue || '>');
         aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
         RETURN iapiConstantDbError.DBERR_SUCCESS;
      END IF;
   END GetValue;

   FUNCTION GetValue(
      asIntLevel          IN       iapiType.String_Type,
      asSpecHeader        IN       iapiType.Description_Type,
      anKeywordId         IN       iapiType.Id_Type,
      anAttachedSpecs     IN       iapiType.Boolean_Type,
      anSectionId         IN       iapiType.Id_Type,
      anSubSectionId      IN       iapiType.Id_Type,
      anPropertyGroupId   IN       iapiType.Id_Type,
      anPropertyId        IN       iapiType.Id_Type,
      anFieldType         IN       iapiType.Id_Type,
      asValue             OUT      iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type   := 'GetValue - ID';
      lnRetVal            iapiType.ErrorNum_Type;
      lbMatchFound        iapiType.Boolean_Type;
   BEGIN
      aapiTrace.Param('asIntLevel', asIntLevel);
      aapiTrace.Param('asSpecHeader', asSpecHeader);
      aapiTrace.Param('anKeywordId', anKeywordId);
      aapiTrace.Param('anAttachedSpecs', anAttachedSpecs);
      aapiTrace.Param('anSectionId', anSectionId);
      aapiTrace.Param('anSubSectionId', anSubSectionId);
      aapiTrace.Param('anPropertyGroupId', anPropertyGroupId);
      aapiTrace.Param('anPropertyId', anPropertyId);
      aapiTrace.Param('anFieldType', anFieldType);

      iapiGeneral.LogInfo(psSource,
                          csMethod,
                             'Called for <'
                          || asIntLevel
                          || '><'
                          || asSpecHeader
                          || '><'
                          || anKeywordId
                          || '><'
                          || anAttachedSpecs
                          || '><'
                          || anSectionId
                          || '><'
                          || anSubSectionId
                          || '><'
                          || anPropertyGroupId
                          || '><'
                          || anPropertyId
                          || '><'
                          || anFieldType
                          || '>');
      asValue := NULL;

      --Data retrieval starts at the input level, and continues with a breadth-first search until a match is found
      FOR rSearch IN (SELECT   component_part, component_revision, func_level
                      FROM     atfuncbomworkarea
                      WHERE    user_id = USER AND applic = aapispectrac.psApplic
                      AND      func_level IN
                                  (asIntLevel || '|',   -- the level itself
                                   asIntLevel || '.-',   -- non-functional specs below the level
                                   asIntLevel || '.*'   -- non-marked possible descendants of the level
                                                     )
                      ORDER BY bom_level, sequence_no)
      LOOP
         iapiGeneral.LogInfo(psSource,
                             csMethod,
                                'Searching in: <'
                             || rSearch.component_part
                             || '><'
                             || rSearch.component_revision
                             || '>');

         IF asSpecHeader IS NOT NULL
         THEN
            --Header values can only match against the functional level itself
            IF rSearch.func_level = asIntLevel || '|'
            THEN
               lnRetVal :=
                  GetHeaderValue(rSearch.component_part,
                                 rSearch.component_revision,
                                 asSpecHeader,
                                 asValue);

               IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
               THEN
                  iapiGeneral.LogError(psSource, csMethod, 'Error retrieving header value');
                  aapiTrace.Error('Error retrieving header value');
                  aapiTrace.Exit(lnRetVal);
                  RETURN lnRetVal;
               END IF;
            END IF;

            EXIT;
         ELSIF anKeywordId IS NOT NULL
         THEN
            --Keyword values can only match against the functional level itself
            IF rSearch.func_level = asIntLevel || '|'
            THEN
               asValue := aapiPartKeyword.GetKeywordValue(rSearch.component_part, anKeywordId);
            END IF;

            EXIT;
         ELSIF anAttachedSpecs IS NOT NULL
         THEN
            lnRetVal :=
               GetAttachedSpecsValue(rSearch.component_part,
                                     rSearch.component_revision,
                                     anSectionId,
                                     anSubSectionId,
                                     asValue);

            IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS
            THEN
               IF asValue IS NOT NULL
               THEN
                  EXIT;   --we found our match, so no need to continue looping
               END IF;
            ELSE
               iapiGeneral.LogError(psSource, csMethod, 'Error retrieving attached specifications');
               aapiTrace.Error('Error retrieving attached specifications');
               aapiTrace.Exit(lnRetVal);
               RETURN lnRetVal;
            END IF;
         ELSIF(anPropertyId IS NOT NULL AND anFieldType IS NOT NULL)
         THEN
            lnRetVal :=
               GetPropertyValue(rSearch.component_part,
                                rSearch.component_revision,
                                anSectionId,
                                anSubSectionId,
                                anPropertyGroupId,
                                anPropertyId,
                                anFieldType,
                                lbMatchFound,
                                asValue);

            IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS
            THEN
               IF lbMatchFound = aapiConstant.BOOLEAN_TRUE
               THEN
                  EXIT;
               END IF;
            ELSE
               iapiGeneral.LogError(psSource, csMethod, 'Error retrieving property value');
               aapiTrace.Error('Error retrieving property value');
               aapiTrace.Exit(lnRetVal);
               RETURN lnRetVal;
            END IF;
         ELSE
            -- RS30012008 : changed LogError --> LogInfo
            iapiGeneral.LogInfo(psSource, csMethod, 'Invalid input path');
            aapiTrace.Error('Invalid input path');
            aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
            RETURN iapiConstantDbError.DBERR_GENFAIL;
         END IF;
      END LOOP;

      aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
      RETURN iapiConstantDbError.DBERR_SUCCESS;
   END GetValue;

   FUNCTION GetHeaderValue(
      asPartNo       IN       iapiType.PartNo_Type,
      anRevision     IN       iapiType.Revision_Type,
      asSpecHeader   IN       iapiType.Description_Type,
      asValue        OUT      iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type                 := 'GetHeaderValue';
      lnRetVal            iapiType.ErrorNum_Type;
      lrHeader            iapiType.SpecificationHeaderRec_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asPartNo', asPartNo);
      aapiTrace.Param('anRevision', anRevision);
      aapiTrace.Param('asSpecHeader', asSpecHeader);
      
      iapiGeneral.LogInfo(psSource,
                          csMethod,
                          'Called for <' || asPartNo || '><' || anRevision || '><' || asSpecHeader
                          || '>');
      lnRetVal := aapiSpecification.GetHeader(asPartNo, anRevision, lrHeader);

      IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS
      THEN
         CASE UPPER(asSpecHeader)
            WHEN HDR_STATUS
            THEN
               asValue := f_ss_descr(lrHeader.Status);
            WHEN HDR_PED
            THEN
               asValue := TO_CHAR(lrHeader.PlannedEffectiveDate);
            WHEN HDR_LASTMODIFIEDBY
            THEN
               asValue := lrHeader.LastModifiedBy;
            ELSE
               iapiGeneral.LogError(psSource, csMethod, 'Invalid field');
               RETURN iapiConstantDbError.DBERR_GENFAIL;
         END CASE;
      ELSE
         iapiGeneral.LogError(psSource, csMethod, 'Header doesn''t exist, or no access');
         aapiTrace.Error('Header doesn''t exist, or no access');
         aapiTrace.Exit(lnRetVal);
         RETURN lnRetVal;
      END IF;

      aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
      RETURN iapiConstantDbError.DBERR_SUCCESS;
   END GetHeaderValue;

   FUNCTION GetAttachedSpecsValue(
      asPartNo         IN       iapiType.PartNo_Type,
      anRevision       IN       iapiType.Revision_Type,
      anSectionId      IN       iapiType.Id_Type,
      anSubSectionId   IN       iapiType.Id_Type,
      asValue          OUT      iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod     CONSTANT iapiType.Method_Type                := 'GetAttachedSpecsValue';
--      lnRetVal              iapiType.ErrorNum_Type;
--      lqAttachedSpecItems   iapiType.Ref_Type;
--      ltAttachedSpecItems   iapiType.SpAttachedSpecItemTab_Type;
--      lrAttachedSpecItem    iapiType.SpAttachedSpecItemRec_Type;
--      lqErrors              iapiType.Ref_Type := NULL;

   lnItemId                      iapiType.Id_Type := NULL;
   lqAttachedSpecItems           iapiType.Ref_Type;
   lnRetVal                      iapiType.ErrorNum_Type;     
   lrAttachedSpecItem            iapiType.SpGetAttSpecItemRec_Type;         
   ltAttachedSpecItems           iapiType.SpGetAttSpecItemTab_Type;    
   lqErrors                      iapiType.Ref_Type;
   lrError                       iapitype.ErrorRec_Type;
   ltErrors                      iapitype.ErrorTab_type;

    BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asPartNo', asPartNo);
      aapiTrace.Param('anRevision', anRevision);
      aapiTrace.Param('anSectionId', anSectionId);
      aapiTrace.Param('anSubSectionId', anSubSectionId);

      iapiGeneral.LogInfo(psSource,
                          csMethod,
                             'Called for <'
                          || asPartNo
                          || '><'
                          || anRevision
                          || '><'
                          || anSectionId
                          || '><'
                          || anSubSectionId
                          || '>');
      asValue := NULL;

      --This API is perfectly happy with getting NULL for section/subsection, so no conversion needed
      CASE iapiSpecificationAttachedSpecs.GetAttachedSpecItems(asPartNo,
                                                               anRevision,
                                                               anSectionId,
                                                               anSubSectionId,
                                                               lnItemId,
                                                               lqAttachedSpecItems,
                                                               lqErrors)
         WHEN iapiConstantDbError.DBERR_SUCCESS
         THEN
            FETCH lqAttachedSpecItems
            BULK COLLECT INTO ltAttachedSpecItems;
            
            IF (ltAttachedSpecItems.COUNT > 0)
            THEN
               FOR lnIndex IN ltAttachedSpecItems.FIRST .. ltAttachedSpecItems.LAST
               LOOP
                  lrAttachedSpecItem := ltAttachedSpecItems(lnIndex);

                  IF asValue IS NOT NULL
                  THEN
                     asValue := asValue || ',';
                  END IF;

                  asValue :=
                        asValue
                     || lrAttachedSpecItem.AttachedPartNo
                     || ' ['
                     || lrAttachedSpecItem.AttachedRevision
                     || ']';
               END LOOP;
            END IF;
         ELSE
            iapiGeneral.LogError(psSource,
                                 csMethod,
                                 'Error retrieving attachments: ' || iapiGeneral.GetLastErrorText);
         aapiTrace.Error(iapiGeneral.GetLastErrorText);
      END CASE;

      aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
      RETURN iapiConstantDbError.DBERR_SUCCESS;
   EXCEPTION
   WHEN OTHERS THEN
            iapiGeneral.LogError(psSource,
                                 csMethod,
                                 'Error retrieving attachments: ' || iapiGeneral.GetLastErrorText);
       aapiTrace.Error(iapiGeneral.GetLastErrorText);
       aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
       RETURN iapiConstantDbError.DBERR_SUCCESS;
   END GetAttachedSpecsValue;

   FUNCTION GetPropertyValue(
      asPartNo            IN       iapiType.PartNo_Type,
      anRevision          IN       iapiType.Revision_Type,
      anSectionId         IN       iapiType.Id_Type,
      anSubSectionId      IN       iapiType.Id_Type,
      anPropertyGroupId   IN       iapiType.Id_Type,
      anPropertyId        IN       iapiType.Id_Type,
      anFieldType         IN       iapiType.Id_Type,
      abMatchFound        OUT      iapiType.Boolean_Type,
      asValue             OUT      iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type        := 'GetPropertyValue';
      lnRetVal            iapiType.ErrorNum_Type;
      lqProperties        iapiType.Ref_Type;
      ltProperties        iapiType.SpPropertyTab_Type;
      lrProperty          iapiType.SpPropertyRec_Type;
      lqErrors            iapiType.Ref_Type;
      lnHeaderId          iapiType.Id_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asPartNo', asPartNo);
      aapiTrace.Param('anRevision', anRevision);
      aapiTrace.Param('anSectionId', anSectionId);
      aapiTrace.Param('anSubSectionId', anSubSectionId);
      aapiTrace.Param('anPropertyGroupId', anPropertyGroupId);
      aapiTrace.Param('anPropertyId', anPropertyId);
      aapiTrace.Param('anFieldType', anFieldType);
      
      iapiGeneral.LogInfo(psSource,
                          csMethod,
                             'Called for <'
                          || asPartNo
                          || '><'
                          || anRevision
                          || '><'
                          || anSectionId
                          || '><'
                          || anSubSectionId
                          || '><'
                          || anPropertyGroupId
                          || '><'
                          || anPropertyId
                          || '><'
                          || anFieldType
                          || '>');
      asValue := NULL;
      abMatchFound := aapiConstant.BOOLEAN_FALSE;

      FOR rSearch IN (SELECT section_id, sub_section_id, ref_id property_group, TYPE
                      FROM   specification_section
                      WHERE  part_no = asPartNo
                      AND    revision = anRevision
                      AND    section_id = NVL(anSectionId, section_id)
                      AND    sub_section_id = NVL(anSubSectionId, sub_section_id)
                      AND    ref_id = NVL(anPropertyGroupId, ref_id)
                      AND    TYPE IN
                                (iapiConstant.SECTIONTYPE_PROPERTYGROUP,
                                 iapiConstant.SECTIONTYPE_SINGLEPROPERTY) )
      LOOP
         iapiGeneral.LogInfo(psSource,
                             csMethod,
                                'Searching in: <'
                             || rSearch.section_id
                             || '><'
                             || rSearch.sub_section_id
                             || '><'
                             || rSearch.property_group
                             || '>');
         lnRetVal :=
            aapiDisplayFormat.GetHeaderMatchingField(asPartNo,
                                                     anRevision,
                                                     rSearch.section_id,
                                                     rSearch.sub_section_id,
                                                     rSearch.property_group,
                                                     anFieldType,
                                                     lnHeaderId);

         BEGIN
            SELECT DISTINCT FIRST_VALUE(value_s) OVER(ORDER BY sequence_no),
                            aapiConstant.BOOLEAN_TRUE
            INTO            asValue,
                            abMatchFound
            FROM            specdata
            WHERE           part_no = asPartNo
            AND             revision = anRevision
            AND             section_id = rSearch.section_id
            AND             sub_section_id = rSearch.sub_section_id
            AND             property_group =
                               DECODE(rSearch.TYPE,
                                      iapiConstant.SECTIONTYPE_PROPERTYGROUP, rSearch.property_group,
                                      0)
            AND             property = anPropertyId
            AND             header_id = lnHeaderId
            AND             lang_id = 1;

            EXIT;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               iapiGeneral.LogInfo(psSource, csMethod, 'No match');
         END;
      END LOOP;

      aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
      RETURN iapiConstantDbError.DBERR_SUCCESS;
   END GetPropertyValue;

   FUNCTION ClearDataConfiguration
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type := 'ClearDataConfiguration';
   BEGIN
      aapiTrace.Enter();
      
      iapiGeneral.LogInfo(psSource, csMethod, 'Called');

      DELETE FROM atfuncbomdata
      WHERE       user_id = USER AND applic = aapispectrac.psApplic;

      aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
      RETURN iapiConstantDbError.DBERR_SUCCESS;
   END ClearDataConfiguration;

   FUNCTION AddDataConfiguration(
      anSequenceNo      IN   iapiType.Sequence_Type,
      asLevel           IN   iapiType.String_Type,
      asSpecHeader      IN   iapiType.Description_Type,
      asKeyword         IN   iapiType.Description_Type,
      anAttachedSpecs   IN   iapiType.Boolean_Type,
      asSection         IN   iapiType.Description_Type,
      asSubSection      IN   iapiType.Description_Type,
      asPropertyGroup   IN   iapiType.Description_Type,
      asProperty        IN   iapiType.Description_Type,
      asField           IN   iapiType.Description_Type,
      anFieldType       IN   iapiType.Id_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type   := 'AddDataConfiguration';
      lnRetVal            iapiType.ErrorNum_Type;
      lsIntLevel          iapiType.String_Type;
      lnKeywordId         iapiType.Id_Type;
      lnSectionId         iapiType.Id_Type;
      lnSubSectionId      iapiType.Id_Type;
      lnPropertyGroupId   iapiType.Id_Type;
      lnPropertyId        iapiType.Id_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('anSequenceNo', anSequenceNo);
      aapiTrace.Param('asLevel', asLevel);
      aapiTrace.Param('asSpecHeader', asSpecHeader);
      aapiTrace.Param('asKeyword', asKeyword);
      aapiTrace.Param('anAttachedSpecs', anAttachedSpecs);
      aapiTrace.Param('asSection', asSection);
      aapiTrace.Param('asSubSection', asSubSection);
      aapiTrace.Param('asPropertyGroup', asPropertyGroup);
      aapiTrace.Param('asProperty', asProperty);
      aapiTrace.Param('asField', asField);
      aapiTrace.Param('anFieldType', anFieldType);
      
      iapiGeneral.LogInfo(psSource,
                          csMethod,
                             'Called for <'
                          || anSequenceNo
                          || '><'
                          || asLevel
                          || '><'
                          || asSpecHeader
                          || '><'
                          || asKeyword
                          || '><'
                          || anAttachedSpecs
                          || '><'
                          || asSection
                          || '><'
                          || asSubSection
                          || '><'
                          || asPropertyGroup
                          || '><'
                          || asProperty
                          || '><'
                          || asField
                          || '><'
                          || anFieldType
                          || '>');
      lnKeywordId := GetIdFromDescription(asKeyword, GLOSS_KEYWORD);
      lnSectionId := GetIdFromDescription(asSection, GLOSS_SECTION);
      lnSubSectionId := GetIdFromDescription(asSubSection, GLOSS_SUBSECTION);
      lnPropertyGroupId := GetIdFromDescription(asPropertyGroup, GLOSS_PROPERTYGROUP);
      lnPropertyId := GetIdFromDescription(asProperty, GLOSS_PROPERTY);
      iapiGeneral.LogInfo(psSource,
                          csMethod,
                             'Corresponding IDs <'
                          || lnKeywordId
                          || '><'
                          || lnSectionId
                          || '><'
                          || lnSubSectionId
                          || '><'
                          || lnPropertyGroupId
                          || '><'
                          || lnPropertyId
                          || '>');
      lsIntLevel := aapiSpectracBom.GetInternalLevel(asLevel);
      iapiGeneral.LogInfo(psSource, csMethod, 'lsIntLevel: <' || lsIntLevel || '>');

      BEGIN
         INSERT INTO atfuncbomdata
                     (user_id, applic, sequence_no, func_level, spec_header, keyword, keyword_id,
                      attached_specs, section, section_id, sub_section, sub_section_id,
                      property_group, property_group_id, property, property_id, FIELD,
                      field_type)
         VALUES      (USER, aapispectrac.psApplic, anSequenceNo, lsIntLevel, asSpecHeader, asKeyword, lnKeywordId,
                      anAttachedSpecs, asSection, lnSectionId, asSubSection, lnSubSectionId,
                      asPropertyGroup, lnPropertyGroupId, asProperty, lnPropertyId, asField,
                      anFieldType);
      EXCEPTION
         WHEN OTHERS
         THEN
            iapiGeneral.LogError(psSource,
                                 csMethod,
                                 'Error inserting configuration item (' || anSequenceNo || ' ):' || SQLERRM);
            aapiTrace.Error(SQLERRM);
            aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
            RETURN iapiConstantDbError.DBERR_GENFAIL;
      END;

      aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
      RETURN iapiConstantDbError.DBERR_SUCCESS;
   END;

   FUNCTION BulkExtractData
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type   := 'BulkExtractData';
      lnRetVal            iapiType.ErrorNum_Type;
      lsValue             iapiType.String_Type;
   BEGIN
      aapiTrace.Enter();
      
      iapiGeneral.LogInfo(psSource, csMethod, 'Called');
      iapiGeneral.LogInfo(psSource, csMethod, 'Clearing previous extract');

      BEGIN
        UPDATE atfuncbomdata
           SET VALUE = NULL
         WHERE  user_id = USER AND applic = aapispectrac.psApplic;
      EXCEPTION
      WHEN OTHERS THEN
       iapiGeneral.LogInfo(psSource, csMethod, 'ERROR (1) =>' || SQLERRM);   
      END;
      
      FOR rExtract IN (SELECT sequence_no, func_level, spec_header, keyword_id, attached_specs,
                              section_id, sub_section_id, property_group_id, property_id,
                              field_type
                       FROM   ATFUNCBOMDATA
                       WHERE  user_id = USER AND applic = aapispectrac.psApplic)
      LOOP
         iapiGeneral.LogInfo(psSource,
                             csMethod,
                                'Processing: <'
                             || rExtract.func_level
                             || '><'
                             || rExtract.spec_header
                             || '><'
                             || rExtract.keyword_id
                             || '><'
                             || rExtract.attached_specs
                             || '><'
                             || rExtract.section_id
                             || '><'
                             || rExtract.sub_section_id
                             || '><'
                             || rExtract.property_group_id
                             || '><'
                             || rExtract.property_id
                             || '><'
                             || rExtract.field_type
                             || '>');

         lnRetVal :=
            GetValue(rExtract.func_level,
                     rExtract.spec_header,
                     rExtract.keyword_id,
                     rExtract.attached_specs,
                     rExtract.section_id,
                     rExtract.sub_section_id,
                     rExtract.property_group_id,
                     rExtract.property_id,
                     rExtract.field_type,
                     lsValue);

         IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
         THEN
            lsValue := '<ERROR>';
         END IF;

         iapiGeneral.LogInfo(psSource,
                             csMethod,
                             'Writing <' || lsValue || '> to <' || rExtract.sequence_no || '>');

          BEGIN
             UPDATE atfuncbomdata
             SET VALUE = lsValue
             WHERE  user_id = USER AND applic = aapispectrac.psApplic AND sequence_no = rExtract.sequence_no;
          EXCEPTION
          WHEN OTHERS THEN
           iapiGeneral.LogInfo(psSource, csMethod, 'ERROR (2) =>' || SQLERRM);   
          END;
      END LOOP;

      aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
      RETURN iapiConstantDbError.DBERR_SUCCESS;
   END BulkExtractData;

   /*/////////////////////////////////////
   //                                   //
   // SAVING DATA TO THE FUNCTIONAL BOM //
   //                                   //
   /////////////////////////////////////*/
   FUNCTION SetValue(
      asLevel           IN   iapiType.String_Type,
      asKeyword         IN   iapiType.Description_Type,
      anAttachedSpecs   IN   iapiType.Boolean_Type,
      asSection         IN   iapiType.Description_Type,
      asSubSection      IN   iapiType.Description_Type,
      asPropertyGroup   IN   iapiType.Description_Type,
      asProperty        IN   iapiType.Description_Type,
      anFieldType       IN   iapiType.Id_Type,
      asValue           IN   iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type   := 'SetValue';
      lnRetVal            iapiType.ErrorNum_Type;
      lsIntLevel          iapiType.String_Type;
      lnKeywordId         iapiType.Id_Type;
      lnSectionId         iapiType.Id_Type;
      lnSubSectionId      iapiType.Id_Type;
      lnPropertyGroupId   iapiType.Id_Type;
      lnPropertyId        iapiType.Id_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asLevel', asLevel);
      aapiTrace.Param('asKeyword', asKeyword);
      aapiTrace.Param('anAttachedSpecs', anAttachedSpecs);
      aapiTrace.Param('asSection', asSection);
      aapiTrace.Param('asSubSection', asSubSection);
      aapiTrace.Param('asPropertyGroup', asPropertyGroup);
      aapiTrace.Param('asProperty', asProperty);
      aapiTrace.Param('anFieldType', anFieldType);
      aapiTrace.Param('asValue', asValue);

      iapiGeneral.LogInfo(psSource,
                          csMethod,
                             'Called for <'
                          || asLevel
                          || '><'
                          || asKeyword
                          || '><'
                          || anAttachedSpecs
                          || '><'
                          || asSection
                          || '><'
                          || asSubSection
                          || '><'
                          || asPropertyGroup
                          || '><'
                          || asProperty
                          || '><'
                          || anFieldType
                          || '><'
                          || asValue
                          || '>');
      lnKeywordId := GetIdFromDescription(asKeyword, GLOSS_KEYWORD);
      lnSectionId := GetIdFromDescription(asSection, GLOSS_SECTION);
      lnSubSectionId := GetIdFromDescription(asSubSection, GLOSS_SUBSECTION);
      lnPropertyGroupId := NVL(GetIdFromDescription(asPropertyGroup, GLOSS_PROPERTYGROUP), 0);   --to support single properties
      lnPropertyId := GetIdFromDescription(asProperty, GLOSS_PROPERTY);
      iapiGeneral.LogInfo(psSource,
                          csMethod,
                             'Corresponding IDs <'
                          || lnKeywordId
                          || '><'
                          || lnSectionId
                          || '><'
                          || lnSubSectionId
                          || '><'
                          || lnPropertyGroupId
                          || '><'
                          || lnPropertyId
                          || '>');
      lsIntLevel := aapiSpectracBom.GetInternalLevel(asLevel);
      iapiGeneral.LogInfo(psSource, csMethod, 'lsIntLevel: <' || lsIntLevel || '>');

      --Data save only goes directly to the functional level
      --This cursor should only return one row, but this is (i) easier to write, (ii) faster to change
      FOR rSearch IN (SELECT component_part, component_revision, func_level
                      FROM   atfuncbom
                      WHERE  user_id = USER AND applic = aapispectrac.psApplic AND func_level = lsIntLevel)
      LOOP
         iapiGeneral.LogInfo(psSource,
                             csMethod,
                                'Saving to: <'
                             || rSearch.component_part
                             || '><'
                             || rSearch.component_revision
                             || '>');

         IF asKeyword IS NOT NULL
         THEN
            lnRetVal :=
                      aapiPartKeyword.SetKeywordValue(rSearch.component_part, lnKeywordId, asValue);

            IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
            THEN
               iapiGeneral.LogError(psSource,
                                    csMethod,
                                    'Error saving keyword: ' || iapiGeneral.GetLastErrorText);
               aapiTrace.Error(iapiGeneral.GetLastErrorText);
               aapiTrace.Exit(lnRetVal);
               RETURN lnRetVal;
            END IF;
         ELSIF(anAttachedSpecs IS NOT NULL AND asSection IS NOT NULL AND asSubSection IS NOT NULL)
         THEN
            lnRetVal :=
               SetAttachedSpecsValue(rSearch.component_part,
                                     rSearch.component_revision,
                                     lnSectionId,
                                     lnSubSectionId,
                                     asValue);

            IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
            THEN
               iapiGeneral.LogError(psSource,
                                    csMethod,
                                       'Error saving attached specifications: '
                                    || iapiGeneral.GetLastErrorText);
               aapiTrace.Error(iapiGeneral.GetLastErrorText);
               aapiTrace.Exit(lnRetVal);
               RETURN lnRetVal;
            END IF;
         ELSIF(    lnPropertyId IS NOT NULL
               AND anFieldType IS NOT NULL
               AND lnSectionId IS NOT NULL
               AND lnSubSectionId IS NOT NULL
               AND lnPropertyGroupId IS NOT NULL)
         THEN
            lnRetVal :=
               SetPropertyValue(rSearch.component_part,
                                rSearch.component_revision,
                                lnSectionId,
                                lnSubSectionId,
                                lnPropertyGroupId,
                                lnPropertyId,
                                anFieldType,
                                asValue);

            IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
            THEN
               iapiGeneral.LogError(psSource,
                                    csMethod,
                                    'Error saving property: ' || iapiGeneral.GetLastErrorText);
               aapiTrace.Error(iapiGeneral.GetLastErrorText);
               aapiTrace.Exit(lnRetVal);
               RETURN lnRetVal;
            END IF;
         ELSE
            iapiGeneral.LogError(psSource, csMethod, 'Invalid input path');
            aapiTrace.Error('Invalid input path');
            aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
            RETURN iapiConstantDbError.DBERR_GENFAIL;
         END IF;
      END LOOP;

      iapiGeneral.LogInfo(psSource, csMethod, 'Data save completed');
      aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
      RETURN iapiConstantDbError.DBERR_SUCCESS;
   END SetValue;

   FUNCTION SetAttachedSpecsValue(
      asPartNo         IN   iapiType.PartNo_Type,
      anRevision       IN   iapiType.Revision_Type,
      anSectionId      IN   iapiType.Id_Type,
      anSubSectionId   IN   iapiType.Id_Type,
      asValue          IN   iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod       CONSTANT iapiType.Method_Type                := 'SetAttachedSpecsValue';
      lnRetVal                iapiType.ErrorNum_Type;
      lqErrors                iapiType.Ref_Type;
      lnAttachedSpecAllowed   iapiType.Boolean_Type;
      lnAttachedSpecItemId    iapiType.Id_Type;
      lqAttachedSpecItems     iapiType.Ref_Type;
      --ltAttachedSpecItems     iapiType.SpAttachedSpecItemTab_Type;
      --lrAttachedSpecItem      iapiType.SpAttachedSpecItemRec_Type;
      lqSectionItems          iapiType.Ref_Type;
      ltSectionItems          iapiType.SpSectionItemTab_Type;
      lrSpSectionItem         iapiType.SpSectionItemRec_Type;
      lqInfo                  iapiType.Ref_Type;

   lrAttachedSpecItem            iapiType.SpGetAttSpecItemRec_Type;         
   ltAttachedSpecItems           iapiType.SpGetAttSpecItemTab_Type;    
 
   lfHandle                      iapiType.Float_Type DEFAULT NULL;
   lrError                       iapitype.ErrorRec_Type;
   ltErrors                      iapitype.ErrorTab_type;

   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asPartNo', asPartNo);
      aapiTrace.Param('anRevision', anRevision);
      aapiTrace.Param('anSectionId', anSectionId);
      aapiTrace.Param('anSubSectionId', anSubSectionId);
      aapiTrace.Param('asValue', asValue);
      
      iapiGeneral.LogInfo(psSource,
                          csMethod,
                             'Called for <'
                          || asPartNo
                          || '><'
                          || anRevision
                          || '><'
                          || anSectionId
                          || '><'
                          || anSubSectionId
                          || '><'
                          || asValue
                          || '>');
      iapiGeneral.LogInfo(psSource, csMethod, 'Ensure that the attached specs object is included');
      lnRetVal :=
         iapiSpecificationSection.GetSectionItems(asPartNo            => asPartNo,
                                                  anRevision          => anRevision,
                                                  anSectionId         => anSectionId,
                                                  anSubSectionId      => anSubSectionId,
                                                  anIncludedOnly      => aapiConstant.BOOLEAN_FALSE,
                                                  aqSectionItems      => lqSectionItems,
                                                  aqErrors            => lqErrors);
      lnAttachedSpecAllowed := 0;

      IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS
      THEN
         FETCH lqSectionItems
         BULK COLLECT INTO ltSectionItems;

         IF (ltSectionItems.COUNT > 0)
         THEN
            FOR lnIndex IN ltSectionItems.FIRST .. ltSectionItems.LAST
            LOOP
               lrSpSectionItem := ltSectionItems(lnIndex);

               IF lrSpSectionItem.ItemType = iapiConstant.SECTIONTYPE_ATTACHEDSPEC
               THEN
                  lnAttachedSpecAllowed := 1;

                  IF lrSpSectionItem.Included = 0
                  THEN
                     lnRetVal :=
                        iapiSpecificationAttachedSpecs.AddAttachedSpec
                                                                 (asPartNo            => asPartNo,
                                                                  anRevision          => anRevision,
                                                                  anSectionId         => anSectionId,
                                                                  anSubSectionId      => anSubSectionId,
                                                                  afHandle            => lfHandle,
                                                                  aqInfo              => lqInfo,
                                                                  aqErrors            => lqErrors);

                     IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
                     THEN
                        iapiGeneral.LogError(psSource,
                                             csMethod,
                                                'Error adding attached specification object: '
                                             || iapiGeneral.GetLastErrorText);
                        aapiTrace.Error(iapiGeneral.GetLastErrorText);
                        aapiTrace.Exit(lnRetVal);
                        RETURN lnRetVal;
                     END IF;
                  END IF;

                  EXIT;
               END IF;
            END LOOP;
         END IF;
      ELSE
         iapiGeneral.LogError(psSource,
                              csMethod,
                              'Error retrieving section items: ' || iapiGeneral.GetLastErrorText);
         aapiTrace.Error(iapiGeneral.GetLastErrorText);
         aapiTrace.Exit(lnRetVal);
         RETURN lnRetVal;
      END IF;

      IF lnAttachedSpecAllowed = 0
      THEN
         iapiGeneral.LogError(psSource, csMethod, 'No attached specs possible in this section');
         aapiTrace.Error('No attached specs possible in this section');
         aapiTrace.Exit(lnRetVal);
         RETURN lnRetVal;
      END IF;

      iapiGeneral.LogInfo(psSource, csMethod, 'Loop a second time, to get the actual item id');
      lnRetVal :=
         iapiSpecificationSection.GetSectionItems(asPartNo            => asPartNo,
                                                  anRevision          => anRevision,
                                                  anSectionId         => anSectionId,
                                                  anSubSectionId      => anSubSectionId,
                                                  anIncludedOnly      => aapiConstant.BOOLEAN_TRUE,
                                                  aqSectionItems      => lqSectionItems,
                                                  aqErrors            => lqErrors);

      IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS
      THEN
         FETCH lqSectionItems
         BULK COLLECT INTO ltSectionItems;

         IF (ltSectionItems.COUNT > 0)
         THEN
            FOR lnIndex IN ltSectionItems.FIRST .. ltSectionItems.LAST
            LOOP
               lrSpSectionItem := ltSectionItems(lnIndex);

               IF lrSpSectionItem.ItemType = iapiConstant.SECTIONTYPE_ATTACHEDSPEC
               THEN
                  lnAttachedSpecItemId := lrSpSectionItem.ItemId;
                  EXIT;
               END IF;
            END LOOP;
         END IF;
      ELSE
         iapiGeneral.LogError(psSource,
                              csMethod,
                              'Error retrieving section items: ' || iapiGeneral.GetLastErrorText);
         aapiTrace.Error(iapiGeneral.GetLastErrorText);
         aapiTrace.Exit(lnRetVal);
         RETURN lnRetVal;
      END IF;

      iapiGeneral.LogInfo(psSource, csMethod, 'Removing existing attached specifications first');
      lnRetVal :=
         iapiSpecificationAttachedSpecs.GetAttachedSpecItems
                                                        (asPartNo                 => asPartNo,
                                                         anRevision               => anRevision,
                                                         anSectionId              => anSectionId,
                                                         anSubSectionId           => anSubSectionId,
                                                         anItemId                 => lnAttachedSpecItemId,
                                                         aqAttachedSpecItems      => lqAttachedSpecItems,
                                                         aqErrors                 => lqErrors);

      IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS
      THEN
         FETCH lqAttachedSpecItems
         BULK COLLECT INTO ltAttachedSpecItems;

         IF (ltAttachedSpecItems.COUNT > 0)
         THEN
            FOR lnIndex IN ltAttachedSpecItems.FIRST .. ltAttachedSpecItems.LAST
            LOOP
               lrAttachedSpecItem := ltAttachedSpecItems(lnIndex);
               lnRetVal :=
                  iapiSpecificationAttachedSpecs.RemoveAttachedSpecItem
                                        (asPartNo                => lrAttachedSpecItem.PartNo,
                                         anRevision              => lrAttachedSpecItem.Revision,
                                         anSectionId             => lrAttachedSpecItem.SectionId,
                                         anSubSectionId          => lrAttachedSpecItem.SubSectionId,
                                         anItemId                => lrAttachedSpecItem.ItemId,
                                         asAttachedPartNo        => lrAttachedSpecItem.AttachedPartNo,
                                         anAttachedRevision      => lrAttachedSpecItem.AttachedRevision,
                                         aqInfo                  => lqInfo,
                                         aqErrors                => lqErrors);
            END LOOP;
         END IF;
      ELSE
         iapiGeneral.LogError(psSource,
                              csMethod,
                                 'Error retrieving attached specifications: '
                              || iapiGeneral.GetLastErrorText);
         aapiTrace.Error(iapiGeneral.GetLastErrorText);
         aapiTrace.Exit(lnRetVal);
         RETURN lnRetVal;
      END IF;

      --For attached specs, asValue is a comma-separated list containing "part_no [revision]" tokens
      FOR rAttachedSpec IN

         --in-line sql tokenizer inspired by http://inside-apex.blogspot.com/2007/02/sql-based-string-tokenizer-another.html
         --alternatively, you could e.g. use DBMS_UTILITY.comma_to_table , but that's not as elegant ;)
         (SELECT TRIM(SUBSTR(token, 1, INSTR(token, '[') - 1) ) part_no,
                 TO_NUMBER(TRIM(SUBSTR(token,
                                       INSTR(token, '[') + 1,
                                       LENGTH(token) - INSTR(token, ']') + 1) ) ) revision
          FROM   (SELECT DISTINCT TRIM(SUBSTR(STRING_TO_TOKENIZE,
                                              DECODE(LEVEL,
                                                     1, 1,
                                                       INSTR(STRING_TO_TOKENIZE,
                                                             DELIMITER,
                                                             1,
                                                             LEVEL - 1)
                                                     + 1),
                                                INSTR(STRING_TO_TOKENIZE, DELIMITER, 1, LEVEL)
                                              - DECODE(LEVEL,
                                                       1, 1,
                                                         INSTR(STRING_TO_TOKENIZE,
                                                               DELIMITER,
                                                               1,
                                                               LEVEL - 1)
                                                       + 1) ) ) TOKEN
                  FROM            (SELECT asValue || ',' AS STRING_TO_TOKENIZE, ',' AS DELIMITER
                                   FROM   DUAL)
                  CONNECT BY      INSTR(STRING_TO_TOKENIZE, DELIMITER, 1, LEVEL) > 0) )
      LOOP
         lnRetVal :=
            iapiSpecificationAttachedSpecs.AddAttachedSpecItem
                                                     (asPartNo                => asPartNo,
                                                      anRevision              => anRevision,
                                                      anSectionId             => anSectionId,
                                                      anSubSectionId          => anSubSectionId,
                                                      anItemId                => lnAttachedSpecItemId,
                                                      asAttachedPartNo        => rAttachedSpec.part_no,
                                                      anAttachedRevision      => rAttachedSpec.revision,
                                                      anInternational         => 0,
                                                      aqInfo                  => lqInfo,
                                                      aqErrors                => lqErrors);

         IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
         THEN
            iapiGeneral.LogError(psSource,
                                 csMethod,
                                    'Error adding attached specification: '
                                 || iapiGeneral.GetLastErrorText);
            aapiTrace.Error(iapiGeneral.GetLastErrorText);
            aapiTrace.Exit(lnRetVal);
            RETURN lnRetVal;
         END IF;
      END LOOP;

      aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
      RETURN iapiConstantDbError.DBERR_SUCCESS;
   END SetAttachedSpecsValue;

   FUNCTION SetPropertyValue(
      asPartNo            IN   iapiType.PartNo_Type,
      anRevision          IN   iapiType.Revision_Type,
      anSectionId         IN   iapiType.Id_Type,
      anSubSectionId      IN   iapiType.Id_Type,
      anPropertyGroupId   IN   iapiType.Id_Type,
      anPropertyId        IN   iapiType.Id_Type,
      anFieldType         IN   iapiType.Id_Type,
      asValue             IN   iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type   := 'SetPropertyValue';
      lnRetVal            iapiType.ErrorNum_Type;
      lnAttributeId       iapiType.Id_Type;
      lnHeaderId          iapiType.Id_Type;
      lqInfo              iapiType.Ref_Type;
      lqErrors            iapiType.Ref_Type;
      lrError             iapitype.ErrorRec_type;
BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asPartNo', asPartNo);
      aapiTrace.Param('anRevision', anRevision);
      aapiTrace.Param('anSectionId', anSectionId);
      aapiTrace.Param('anSubSectionId', anSubSectionId);
      aapiTrace.Param('anPropertyGroupId', anPropertyGroupId);
      aapiTrace.Param('anPropertyId', anPropertyId);
      aapiTrace.Param('anFieldType', anFieldType);
      aapiTrace.Param('asValue', asValue);

      IF (lqInfo%ISOPEN) THEN
         CLOSE lqInfo;
      END IF;
      IF (lqErrors%ISOPEN) THEN
         CLOSE lqErrors;
      END IF;
      iapiSpecificationPropertyGroup.gtErrors.Delete;
      
      iapiGeneral.LogInfo(psSource,
                          csMethod,
                             'Called for <'
                          || asPartNo
                          || '><'
                          || anRevision
                          || '><'
                          || anSectionId
                          || '><'
                          || anSubSectionId
                          || '><'
                          || anPropertyGroupId
                          || '><'
                          || anPropertyId
                          || '><'
                          || anFieldType
                          || '><'
                          || asValue
                          || '>');
      iapiGeneral.LogInfo(psSource, csMethod, 'Get attribute to write to');

      BEGIN
         SELECT DISTINCT FIRST_VALUE(ATTRIBUTE) OVER(ORDER BY sequence_no)
         INTO            lnAttributeId
         FROM            specification_prop
         WHERE           part_no = asPartNo
         AND             revision = anRevision
         AND             section_id = anSectionId
         AND             sub_section_id = anSubSectionId
         AND             property_group = anPropertyGroupId
         AND             property = anPropertyId;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            BEGIN
               SELECT DISTINCT FIRST_VALUE(ATTRIBUTE) OVER(ORDER BY sequence_no)
               INTO            lnAttributeId
               FROM            frame_prop fp, specification_header sh
               WHERE           sh.part_no = asPartNo
               AND             sh.revision = anRevision
               AND             sh.frame_id = fp.frame_no
               AND             sh.frame_rev = fp.revision
               AND             fp.section_id = anSectionId
               AND             fp.sub_section_id = anSubSectionId
               AND             fp.property_group = anPropertyGroupId
               AND             fp.property = anPropertyId;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  iapiGeneral.LogError(psSource, csMethod, 'No attribute found to export to for property ' || anPropertyId || ' in property group ' || anPropertyGroupId);
                  aapiTrace.Error('No attribute found to export to for property ' || anPropertyId || ' in property group ' || anPropertyGroupId);
                  aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
                  RETURN iapiConstantDbError.DBERR_GENFAIL;
            END;
      END;

      iapiGeneral.LogInfo(psSource, csMethod, 'Get header to write to');
      lnRetVal :=
         aapiDisplayFormat.GetHeaderMatchingFieldFrame(asPartNo,
                                                       anRevision,
                                                       anSectionId,
                                                       anSubSectionId,
                                                       CASE anPropertyGroupId
                                                          WHEN 0
                                                             THEN anPropertyId
                                                          ELSE anPropertyGroupId
                                                       END,
                                                       anFieldType,
                                                       lnHeaderId);

      IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
      THEN
         iapiGeneral.LogError(psSource, csMethod, 'No header found to export to');
         aapiTrace.Error('No header found to export to');
         aapiTrace.Exit(lnRetVal);
         RETURN lnRetVal;
      END IF;

      iapiGeneral.LogInfo(psSource, csMethod, 'Write property value');
      /*
      --In 6.3, there will be a function iapiSpecificationPropertyGroup.SaveAddProperty that has similar functionality
      lnRetVal :=
         pa_api_specs.f_cr_prop(asPartNo,
                                anRevision,
                                anSectionId,
                                anSubSectionId,
                                anPropertyGroupId,
                                anPropertyId,
                                lnAttributeId,
                                'DT',
                                lnHeaderId,
                                asValue);
      
      --------------------------------------------------
      -- FUNCTION f_cr_prop
      -- RETURNS 1  : if creation of property OK
      -- RETURNS -1 : General error.
      --         -2 : Not in development specification
      --         -3 : Specification does not exist
      --         -4 : Section, subsection not found in frame
      --         -5 : Property group/property not found
      --         -6 : Header not found
      --         -7 : Characteristic not linked to association
      --         -8: Numeric or value error for value
      --------------------------------------------------
      IF lnRetVal != 1
      THEN
         iapiGeneral.LogError(psSource,
                              csMethod,
                              'Saving property failed with error code: ' || lnRetVal);
         RETURN iapiConstantDbError.DBERR_GENFAIL;
      END IF;
      */
      lnRetVal := iapiSpecificationPropertyGroup.SaveAddProperty(asPartNo,
                                                                 anRevision,
                                                                 anSectionId,
                                                                 anSubSectionId,
                                                                 anPropertyGroupId,
                                                                 anPropertyId,
                                                                 lnAttributeId,
                                                                 lnHeaderId,
                                                                 asValue,
                                                                 NULL,
                                                                 lqInfo,
                                                                 lqErrors);                            
      IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
      THEN
          LOOP
              FETCH lqErrors INTO lrError;
              EXIT WHEN lqErrors%NOTFOUND;
              iapiGeneral.LogError(
                  asSource  => psSource,
                  asMethod  => csMethod,
                  asMessage => lrError.ErrorText
              );
              aapiTrace.Error(lrError.ErrorText);
          END LOOP;

         iapiGeneral.LogError(
           psSource, csMethod,
           'E'||TO_CHAR(lnRetVal)||': '||
           asPartNo||'['||TO_CHAR(anRevision)||']-'||
           TO_CHAR(anSectionId)||'-'||TO_CHAR(anSubSectionId)||'-'||TO_CHAR(anPropertyGroupId)||'-'||
           TO_CHAR(anPropertyId)||'-'||TO_CHAR(lnAttributeId)||'-'||TO_CHAR(lnHeaderId)||':='''||asValue||''''
         );
         --iapiGeneral.LogError(psSource,
         --                     csMethod,
         --                     'Saving property ' || anPropertyId || ' in property group ' || anPropertyGroupId ||' failed with error code: ' || lnRetVal);
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapiConstantDbError.DBERR_GENFAIL;
      END IF;
             
      aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
      RETURN iapiConstantDbError.DBERR_SUCCESS;
   END SetPropertyValue;

END aapiSpectracData;
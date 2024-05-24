create or replace PACKAGE BODY          aapiSpectracBom
AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : aapiSpectracBom
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 03/08/2007
--   TARGET : Interspec V6.3 / Oracle 10.2.0
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
-- 27/05/2009 | RS        | Changed CreateSpecification (retrieve base_uom from frame)
-- 10/03/2011 | RS        | Upgrade V6.3
-- 11/03/2011 | RS        | Upgrade V6.3 SP1
-- 11-05-2011 | RS        | Fixed saving problem of properties
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------
TYPE HeaderListRec_Type IS RECORD(
      PARTNO                        iapiType.PartNo_Type,
      REVISION                      iapiType.Revision_Type,
      SPECIFICATIONDESCRIPTION      iapiType.Description_Type,
      PLANTNO                       iapiType.PlantNo_Type,
      ALTERNATIVE                   iapiType.BomAlternative_Type,
      BOMUSAGEID                    iapiType.BomUsageId_Type,
      DESCRIPTION                   iapiType.Description_Type,
      PLANTDESCRIPTION              iapiType.Description_Type,
      BOMUSAGEDESCRIPTION           iapiType.Description_Type,
      BASEQUANTITY                  iapiType.BomQuantity_Type,
      BASEUOM                       iapiType.BaseUom_Type,
      CONVERSIONFACTOR              iapiType.BomConvFactor_Type,
      BASETOUNIT                    iapiType.BaseToUnit_Type,
      CALCULATEDQUANTITY            iapiType.BomQuantity_Type,
      MINIMUMQUANTITY               iapiType.BomQuantity_Type,
      MAXIMUMQUANTITY               iapiType.BomQuantity_Type,
      YIELD                         iapiType.BomYield_Type,
      CALCULATIONMODE               iapiType.BomItemCalcFlag_Type,
      BOMTYPE                       iapiType.BomItemType_Type,
      PLANNEDEFFECTIVEDATE          iapiType.Date_Type,
      PREFERRED                     iapiType.Boolean_Type,
      HASITEMS                      iapiType.Boolean_Type
   );

TYPE HeaderListTab_Type IS TABLE OF HeaderListRec_Type INDEX BY BINARY_INTEGER;

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
   // INFORMATION RETRIEVAL ABOUT SPECIFIC COMPONENTS //
   //                                                 //
   ///////////////////////////////////////////////////*/
   FUNCTION GetFunction(
      asPartNo     IN   iapiType.PartNo_Type,
      asOverride   IN   iapiType.Description_Type DEFAULT NULL)
      RETURN iapiType.Description_Type
   IS
      lsFunction   iapiType.Description_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asPartNo', asPartNo);
      aapiTrace.Param('asOverride', asOverride);
      
      IF asOverride IS NOT NULL
      THEN
         lsFunction := asOverride;
      ELSE
         BEGIN
            SELECT kw_value
            INTO   lsFunction
            FROM   specification_kw
            WHERE  part_no = asPartNo AND kw_id = KW_FUNCTION;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               lsFunction := NULL;
         END;
      END IF;

      aapiTrace.Exit(lsFunction);
      RETURN lsFunction;
   END GetFunction;

   FUNCTION GetStatus(asPartNo IN iapiType.PartNo_Type, anRevision IN iapiType.Revision_Type)
      RETURN iapiType.ShortDescription_Type
   IS
      lsStatus   iapiType.ShortDescription_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asPartNo', asPartNo);
      aapiTrace.Param('anRevision', anRevision);
      
      SELECT ss.sort_desc
      INTO   lsStatus
      FROM   specification_header sh, status ss
      WHERE  sh.part_no = asPartNo AND revision = anRevision AND sh.status = ss.status;

      aapiTrace.Exit(lsStatus);
      RETURN lsStatus;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         aapiTrace.Exit();
         RETURN NULL;
   END GetStatus;

   FUNCTION GetInternalLevel(asLevel IN iapiType.String_Type)
      RETURN iapiType.String_Type
   IS
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asLevel', asLevel);
      aapiTrace.Exit(CASE WHEN asLevel IS NULL THEN '0' ELSE '0.' || asLevel END);
      RETURN CASE
         WHEN asLevel IS NULL
            THEN '0'
         ELSE '0.' || asLevel
      END;
   END GetInternalLevel;

   FUNCTION GetParentLevel(asIntLevel IN iapiType.String_Type)
      RETURN iapiType.String_Type
   IS
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asIntLevel', asIntLevel);
      aapiTrace.Exit(SUBSTR(asIntLevel, 1, INSTR(asIntLevel, '.', -1, 1) - 1));
      
      RETURN SUBSTR(asIntLevel, 1, INSTR(asIntLevel, '.', -1, 1) - 1);
   END GetParentLevel;

   FUNCTION GetChildLevel(asIntLevel IN iapiType.String_Type)
      RETURN iapiType.NumVal_Type
   IS
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asIntLevel', asIntLevel);
      aapiTrace.Exit(TO_NUMBER(REPLACE(REPLACE(REPLACE(SUBSTR(asIntLevel, INSTR(asIntLevel, '.', -1) + 1),'*',''),'|',''),'-','')));
      
      --Take the part behind the last . and strip out * and |
      RETURN TO_NUMBER(REPLACE(REPLACE(REPLACE(SUBSTR(asIntLevel, INSTR(asIntLevel, '.', -1) + 1),
                                               '*',
                                               ''),
                                       '|',
                                       ''),
                               '-',
                               '') );
   END;

   FUNCTION GetDepth(asIntLevel IN iapiType.String_Type)
      RETURN iapiType.NumVal_Type
   IS
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asIntLevel', asIntLevel);
      aapiTrace.Exit(LENGTH(asIntLevel) - LENGTH(REPLACE(asIntLevel, '.', '')));

      --Count the number of . in the level
      RETURN LENGTH(asIntLevel) - LENGTH(REPLACE(asIntLevel, '.', '') );
   END GetDepth;

   /*////////////////////////////////////
   //                                  //
   // EXTRACTION OF THE FUNCTIONAL BOM //
   //                                  //
   ////////////////////////////////////*/

   /*
   // ExtractRow Algorithm
   //
   // Basic assumption: this function has to be called for all ancestors and smaller siblings
   // before it can be called for a particular level. E.g. before level 1.1.2 can be extracted,
   // calls for (empty), 1, 1,1, and 1,1,1 need to be performed.
   //
   // This function uses the function_level column in atfuncbomworkarea to define its search
   // area, and updates values in this column to reflect state changes caused by finding a match.
   //   - Initially (after InitializeExtract), function_level is empty for all rows
   //   - For level 0, the first row in the explosion is returned, this row is marked with
   //     function_level 0| and all other rows are marked with function_level 0.*
   //   - For other levels (e.g. 0.1.1.2), the parent level is extracted (e.g. 0.1.1)
   //     and the subtree rooted by this parent (e.g. 0.1.1.*) is searched for a matching function.
   //     If this match is found, the row is copied to atfuncbom, the row is marked as extracted
   //     (e.g. 0.1.1.2|) and the state of the subtree is updated (e.g. 0.1.1.2.*).
   //
   // State summary
   //   - <nr>| the row was returned as a match for level <nr>
   //   - <nr>.* the row is available for descendants of level <nr>
   //   - <nr>.- row is on the path between two functional levels and therefore unavailable
   //
   */
   FUNCTION ExtractRow(
      asLevel              IN       iapiType.String_Type,
      asFunction           IN       iapiType.Description_Type,
      asPartNo             OUT      iapiType.PartNo_Type,
      anRevision           OUT      iapiType.Revision_Type,
      asDescription        OUT      iapiType.Description_Type,
      asStatus             OUT      iapiType.ShortDescription_Type,
      anQuantity           OUT      iapiType.BomQuantity_Type,
      asPartType           OUT      iapiType.Description_Type,
      anFunctionOverride   OUT      iapiType.Boolean_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type   := 'ExtractRow';
      lsParentLevel       iapiType.String_Type;
      lnParentSeqNo       iapiType.Sequence_Type;
      lnChildSeqNo        iapiType.Sequence_Type;
      lsIntLevel          iapiType.String_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asLevel', asLevel);
      aapiTrace.Param('asFunction', asLevel);
   
      iapiGeneral.LogInfo(psSource,
                          csMethod,
                          'Called for <' || asLevel || '><' || asFunction || '>');
      lsIntLevel := GetInternalLevel(asLevel);
      iapiGeneral.LogInfo(psSource, csMethod, 'lsIntLevel: <' || lsIntLevel || '>');
      iapiGeneral.LogInfo(psSource, csMethod, 'psApplic := ''' || aapiSpectrac.psApplic || '''');


      BEGIN
         SELECT component_part, component_revision, description,
                GetStatus(component_part, component_revision), qty, part_type, func_override
         INTO   asPartNo, anRevision, asDescription,
                asStatus, anQuantity, asPartType, anFunctionOverride
         FROM   atfuncbom
         WHERE  user_id = USER AND applic = aapispectrac.psApplic AND func_level = lsIntLevel AND FUNCTION = asFunction;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            iapiGeneral.LogInfo(psSource, csMethod, 'This level still needs to be extracted');

            IF lsIntLevel = '0'
            THEN
               lsParentLevel := '';
               lnParentSeqNo := 10;
               lnChildSeqNo := 10;
            ELSE
               BEGIN
                  lsParentLevel := GetParentLevel(lsIntLevel);
                  iapiGeneral.LogInfo(psSource,
                                      csMethod,
                                      'lsParentLevel: <' || lsParentLevel || '>');
               EXCEPTION
                  WHEN INVALID_NUMBER OR VALUE_ERROR
                  THEN
                     iapiGeneral.LogError(psSource, csMethod, 'Invalid level');
                     aapiTrace.Error('Invalid level');
                     aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
                     RETURN iapiConstantDbError.DBERR_GENFAIL;
               END;

               BEGIN
                  SELECT sequence_no
                  INTO   lnParentSeqNo
                  FROM   atfuncbomworkarea
                  WHERE  user_id = USER AND applic = aapispectrac.psApplic AND func_level = lsParentLevel || '|';

                  iapiGeneral.LogInfo(psSource, csMethod,
                                      'lnParentSeqNo: <' || lnParentSeqNo || '>');
               EXCEPTION
                  WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
                  THEN
                     BEGIN
                        iapiGeneral.LogInfo
                                  (psSource,
                                   csMethod,
                                   'Parent sequence_no not found, checking if it was a dummy level');

                        SELECT NULL
                        INTO   lnParentSeqNo
                        FROM   atfuncbom
                        WHERE  user_id = USER AND applic = aapispectrac.psApplic
                        AND    func_level = lsParentLevel
                        AND    component_part = PART_NOT_FOUND;
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           iapiGeneral.LogError(psSource,
                                                csMethod,
                                                'Out of sequence call for <' || lsIntLevel || '>');
                                                
                           aapiTrace.Error('Out of sequence call for <' || lsIntLevel || '>');
                           aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
                           RETURN iapiConstantDbError.DBERR_GENFAIL;
                     END;
               END;

               BEGIN
                  SELECT DISTINCT FIRST_VALUE(sequence_no) OVER(ORDER BY bom_level, sequence_no)
                  INTO            lnChildSeqNo
                  FROM            atfuncbomworkarea
                  WHERE           user_id = USER AND applic = aapispectrac.psApplic
                  AND             func_level = lsParentLevel || '.*'
                  AND             FUNCTION = asFunction;

                  iapiGeneral.LogInfo(psSource, csMethod, 'lnChildSeqNo: <' || lnChildSeqNo || '>');
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     iapiGeneral.LogInfo(psSource, csMethod, 'No matching child found');
                     lnChildSeqNo := NULL;
               END;
            END IF;

            IF lnChildSeqNo IS NULL
            THEN
               CreateDummyComponent(lsIntLevel, asFunction);
            ELSE
               MarkComponent(lnChildSeqNo, lsIntLevel, lnParentSeqNo);
               MarkSubTree(lnChildSeqNo);
               MarkAncestralPath(lnChildSeqNo, lnParentSeqNo);
            END IF;

            BEGIN
               SELECT component_part, component_revision, description,
                      GetStatus(component_part, component_revision), qty, part_type, func_override
               INTO   asPartNo, anRevision, asDescription,
                      asStatus, anQuantity, asPartType, anFunctionOverride
               FROM   atfuncbom
               WHERE  user_id = USER AND applic = aapispectrac.psApplic AND func_level = lsIntLevel AND FUNCTION = asFunction;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  iapiGeneral.LogError(psSource, csMethod, 'Extraction failed');
                  
                  aapiTrace.Error('Extraction failed');
                  aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
                  RETURN iapiConstantDbError.DBERR_GENFAIL;
            END;
      END;

      iapiGeneral.LogInfo(psSource,
                          csMethod,
                             'Returning <'
                          || asPartNo
                          || '><'
                          || anRevision
                          || '><'
                          || asDescription
                          || '><'
                          || asStatus
                          || '><'
                          || anQuantity
                          || '><'
                          || asPartType
                          || '><'
                          || anFunctionOverride
                          || '>');
                          
      aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
      RETURN iapiConstantDbError.DBERR_SUCCESS;
   END ExtractRow;

   PROCEDURE ClearResults(
      anStartSeqNo   IN   iapiType.Sequence_Type DEFAULT NULL,
      anStopSeqNo    IN   iapiType.Sequence_Type DEFAULT NULL,
      asIntLevel     IN   iapiType.String_Type DEFAULT NULL)
   IS
      csMethod   CONSTANT iapiType.Method_Type   := 'ClearResults';
      lnStartSeqNo        iapiType.Sequence_Type;
      lnStopSeqNo         iapiType.Sequence_Type;
      lsIntLevel          iapiType.String_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('anStartSeqNo', anStartSeqNo);
      aapiTrace.Param('anStopSeqNo', anStopSeqNo);
      aapiTrace.Param('asIntLevel', asIntLevel);
   
      iapiGeneral.LogInfo(psSource,
                          csMethod,
                          'Called for <' || anStartSeqNo || '><' || anStopSeqNo || '>');

      IF anStartSeqNo IS NULL
      THEN
         SELECT MIN(sequence_no)
         INTO   lnStartSeqNo
         FROM   atfuncbomworkarea
         WHERE  user_id = USER AND applic = aapispectrac.psApplic ;
      ELSE
         lnStartSeqNo := anStartSeqNo;
      END IF;

      IF anStopSeqNo IS NULL
      THEN
         SELECT MAX(sequence_no)
         INTO   lnStopSeqNo
         FROM   atfuncbomworkarea
         WHERE  user_id = USER AND applic = aapispectrac.psApplic ;
      ELSE
         lnStopSeqNo := anStopSeqNo;
      END IF;

      lsIntLevel := NVL(asIntLevel, '0');
      iapiGeneral.LogInfo(psSource,
                          csMethod,
                             'Clearing <'
                          || lnStartSeqNo
                          || '>-<'
                          || lnStopSeqNo
                          || '>, <'
                          || lsIntLevel
                          || '>');

      DELETE FROM atfuncbomworkarea
      WHERE       user_id = USER AND applic = aapispectrac.psApplic AND sequence_no BETWEEN lnStartSeqNo AND lnStopSeqNo;

      DELETE FROM atfuncbom
      WHERE       user_id = USER AND applic = aapispectrac.psApplic AND(   func_level = lsIntLevel
                                     OR func_level LIKE lsIntLevel || '.%');

      aapiTrace.Exit();
   END ClearResults;

   /*
   // InitializeExtract Algorithm
   //   1. perform BOM explosion and copy relevant columns to atfuncbomworkarea
   //   2. retrieve functions for all components
   //   3. save reference to parent against all components for easy querying
   */
   FUNCTION InitializeExtract(
      asPartNo          IN   iapiType.PartNo_Type,
      asPlant           IN   iapiType.PlantNo_Type,
      adExplosionDate   IN   iapiType.Date_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod     CONSTANT iapiType.Method_Type              := 'InitializeExtract';
      lnRetVal              iapiType.ErrorNum_Type;
      lqErrors              iapiType.Ref_Type;
      lnRevision            iapiType.Revision_Type;
      lqHeaders             iapiType.Ref_Type;
      ltHeaders             HeaderListTab_Type;
      lrHeader              HeaderListRec_Type;
      lnBomExpNo            iapiType.Sequence_Type;
      lqBomExplosionItems   iapiType.Ref_Type;
      ltBomExplosionItems   iapiType.BomExplosionListTab_Type;
      lrBomExplosionItem    iapiType.BomExplosionListRec_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asPartNo', asPartNo);
      aapiTrace.Param('asPlant', asPlant);
      aapiTrace.Param('adExplosionDate', adExplosionDate);
      
      iapiGeneral.LogInfo(psSource,
                          csMethod,
                          'Called for <' || asPartNo || '><' || asPlant || '><' || adExplosionDate
                          || '>');
      iapiGeneral.LogInfo(psSource, csMethod, 'Get the revision to explode');
      lnRevision := 0;
      lnRetVal := iapiSpecificationBom.GetExplosionHeaders(asPartNo, adExplosionDate, 1, lqHeaders);

      IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS
      THEN
         FETCH lqHeaders
         BULK COLLECT INTO ltHeaders;

         IF (ltHeaders.COUNT > 0)
         THEN
            FOR lnIndex IN ltHeaders.FIRST .. ltHeaders.LAST
            LOOP
               lrHeader := ltHeaders(lnIndex);

               IF lrHeader.PlantNo = asPlant
               THEN
                  lnRevision := GREATEST(lnRevision, lrHeader.Revision);
               END IF;
            END LOOP;
         END IF;

         iapiGeneral.LogInfo(psSource, csMethod, 'lnRevision: <' || lnRevision || '>');
      ELSE
         iapiGeneral.LogError(psSource,
                              csMethod,
                              'Error getting revision to explode: '
                              || iapiGeneral.GetLastErrorText() );
         aapiTrace.Error(iapiGeneral.GetLastErrorText());
         aapiTrace.Exit(lnRetVal);
         RETURN lnRetVal;
      END IF;

      IF lnRevision = 0
      THEN
          BEGIN
              SELECT MAX(revision)
              INTO lnRevision
              FROM specification_header sh, status ss
              WHERE TRUNC(planned_effective_date) <= adExplosionDate
              AND ss.status_type = 'DEVELOPMENT'
              AND sh.part_no = asPartNo
              AND sh.status = ss.status;
    
              INSERT INTO atfuncbomworkarea
                          (user_id, applic, sequence_no, bom_level,
                           component_part, component_revision,
                           description, plant,
                           alternative, USAGE,
                           qty, uom,
                           explosion_date,
                           func_override,
                           FUNCTION,
                           part_type)
              SELECT       USER, aapispectrac.psApplic, 10, 0,
                           part_no, NVL(revision, 0),
                           sh.description, asPlant,
                           1, 1,
                           1, 'pcs',
                           adExplosionDate,
                           0, GetFunction(part_no, NULL),
                           st.description
              FROM specification_header sh, class3 st
              WHERE part_no = asPartNo
              AND revision = lnRevision
              AND sh.class3_id = st.class;
          EXCEPTION WHEN NO_DATA_FOUND
          THEN
              iapiGeneral.LogError(psSource,
                                   csMethod,
                                   'Error exploding header: ' || iapiGeneral.GetLastErrorText() );
              aapiTrace.Error(iapiGeneral.GetLastErrorText());
              aapiTrace.Exit(lnRetVal);
              RETURN lnRetVal;
          END;
      ELSE
          iapiGeneral.LogInfo(psSource, csMethod, 'Exploding header');
          lnRetVal :=
             ExplodeHeader(asPartNo             => asPartNo,
                           anRevision           => lnRevision,
                           asPlant              => asPlant,
                           adExplosionDate      => adExplosionDate,
                           anBomExpNo           => lnBomExpNo);
    
          IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
          THEN
             iapiGeneral.LogError(psSource,
                                  csMethod,
                                  'Error exploding header: ' || iapiGeneral.GetLastErrorText() );
             aapiTrace.Error(iapiGeneral.GetLastErrorText());
             aapiTrace.Exit(lnRetVal);
             RETURN lnRetVal;
          END IF;
    
          iapiGeneral.LogInfo(psSource,
                              csMethod,
                              'Copy explosion <' || lnBomExpNo || '> to working area');
          lnRetVal := iapiSpecificationBom.GetExplosion(lnBomExpNo, lqBomExplosionItems);
    
          CASE lnRetVal
             WHEN iapiConstantDbError.DBERR_SUCCESS
             THEN
                FETCH lqBomExplosionItems
                BULK COLLECT INTO ltBomExplosionItems;
    
                IF (ltBomExplosionItems.COUNT > 0)
                THEN
                   FOR lnIndex IN ltBomExplosionItems.FIRST .. ltBomExplosionItems.LAST
                   LOOP
                      lrBomExplosionItem := ltBomExplosionItems(lnIndex);
    
                      INSERT INTO atfuncbomworkarea
                                  (user_id, applic, sequence_no, bom_level,
                                   component_part, component_revision,
                                   description, plant,
                                   alternative, USAGE,
                                   qty, uom,
                                   explosion_date,
                                   func_override,
                                   FUNCTION,
                                   part_type)
                      VALUES      (USER, aapispectrac.psApplic, lrBomExplosionItem.SEQUENCE, lrBomExplosionItem.BOMLEVEL,
                                   lrBomExplosionItem.PARTNO, NVL(lrBomExplosionItem.REVISION, 0),
                                   lrBomExplosionItem.DESCRIPTION, lrBomExplosionItem.PLANTNO,
                                   lrBomExplosionItem.ALTERNATIVE, lrBomExplosionItem.BOMUSAGEID,
                                   NVL(lrBomExplosionItem.QUANTITY, 0), lrBomExplosionItem.UOM,
                                   adExplosionDate,
                                   CASE
                                      WHEN lrBomExplosionItem.CharacteristicDescription1 IS NULL
                                         THEN 0
                                      ELSE 1
                                   END,
                                   GetFunction(lrBomExplosionItem.PARTNO,
                                               lrBomExplosionItem.CharacteristicDescription1),
                                   lrBomExplosionItem.PartType);
                   END LOOP;
                END IF;
             ELSE
                iapiGeneral.LogError(psSource,
                                     csMethod,
                                     'Error getting BOM explosion: ' || iapiGeneral.GetLastErrorText() );
                aapiTrace.Error(iapiGeneral.GetLastErrorText());
                aapiTrace.Exit(lnRetVal);
                RETURN lnRetVal;
          END CASE;
    
          iapiGeneral.LogInfo(psSource, csMethod, 'Get parent-child relationships');
          SetParentChildRelationship;
      END IF;
      
      aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
      RETURN iapiConstantDbError.DBERR_SUCCESS;
   END InitializeExtract;

   FUNCTION ExplodeHeader(
      asPartNo          IN       iapiType.PartNo_Type,
      anRevision        IN       iapiType.Revision_Type,
      asPlant           IN       iapiType.PlantNo_Type,
      anAlternative     IN       iapiType.BomAlternative_Type DEFAULT NULL,
      anUsage           IN       iapiType.BomUsage_Type DEFAULT NULL,
      adExplosionDate   IN       iapiType.Date_Type,
      anBomExpNo        OUT      iapiType.Sequence_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type         := 'ExplodeHeader';
      lnRetVal            iapiType.ErrorNum_Type;
      lqErrors            iapiType.Ref_Type;
      lnAlternative       iapiType.BomAlternative_Type;
      lnBomUsage          iapiType.BomUsageId_Type;
      lnExplosionQty      iapiType.BomQuantity_Type;
      lqHeaders           iapiType.Ref_Type;
      ltHeaders           HeaderListTab_Type;
      lrHeader            HeaderListRec_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asPartNo', asPartNo);
      aapiTrace.Param('anRevision', anRevision);
      aapiTrace.Param('asPlant', asPlant);
      aapiTrace.Param('anAlternative', anAlternative);
      aapiTrace.Param('anUsage', anUsage);
      aapiTrace.Param('adExplosionDate', adExplosionDate);
   
      iapiGeneral.LogInfo(psSource, csMethod, 'Get header to explode');
      lnRetVal := iapiSpecificationBom.GetHeaders(asPartNo, anRevision, lqHeaders, lqErrors);

      CASE lnRetVal
         WHEN iapiConstantDbError.DBERR_SUCCESS
         THEN
            FETCH lqHeaders
            BULK COLLECT INTO ltHeaders;

            IF (ltHeaders.COUNT > 0)
            THEN
               FOR lnIndex IN ltHeaders.FIRST .. ltHeaders.LAST
               LOOP
                  lrHeader := ltHeaders(lnIndex);

                  --Each partno/revision/plant has 1 preferred header
                  --use this fact to limit the result set, and use the NVL to switch where needed
                  IF     lrHeader.PlantNo = asPlant
                     AND lrHeader.BomUsageId = NVL(anUsage, 1)
                     AND (   lrHeader.Alternative = anAlternative
                          OR lrHeader.Preferred = 1)
                  THEN
                     lnAlternative := lrHeader.Alternative;
                     lnBomUsage := lrHeader.BomUsageId;
                     lnExplosionQty := lrHeader.BaseQuantity;
                     iapiGeneral.LogInfo(psSource,
                                         csMethod,
                                            'Header found <'
                                         || lnAlternative
                                         || '><'
                                         || lnBomUsage
                                         || '><'
                                         || lnExplosionQty
                                         || '><'
                                         || adExplosionDate
                                         || '>');
                     EXIT;
                  END IF;
               END LOOP;
            ELSE
               lnAlternative := 1;
               lnBomUsage := 1;
               lnExplosionQty := 1;
            END IF;
         WHEN iapiConstantDbError.DBERR_ERRORLIST
         THEN
            iapiGeneral.LogError(psSource,
                                 csMethod,
                                 'Error retrieving headers: ' || iapiGeneral.GetLastErrorText() );
                                 
            aapiTrace.Error(iapiGeneral.GetLastErrorText());
            aapiTrace.Exit();
            RETURN iapiConstantDbError.DBERR_GENFAIL;
         ELSE
            iapiGeneral.LogError(psSource,
                                 csMethod,
                                 'Error retrieving headers: ' || iapiGeneral.GetLastErrorText() );
            aapiTrace.Error(iapiGeneral.GetLastErrorText());
            aapiTrace.Exit();
            RETURN lnRetVal;
      END CASE;

      iapiGeneral.LogInfo(psSource, csMethod, 'Explode header');

      SELECT bom_explosion_seq.NEXTVAL
      INTO   anBomExpNo
      FROM   DUAL;

      lnRetVal :=
         iapiSpecificationBom.Explode(anUniqueId                  => anBomExpNo,
                                      asPartNo                    => asPartNo,
                                      anRevision                  => anRevision,
                                      asPlant                     => asPlant,
                                      anAlternative               => lnAlternative,
                                      anUsage                     => lnBomUsage,
                                      adExplosionDate             => adExplosionDate,
                                      anBatchQuantity             => lnExplosionQty,
                                      anIncludeInDevelopment      => 1,
                                      aqErrors                    => lqErrors);

      IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
      THEN
         iapiGeneral.LogError(psSource,
                              csMethod,
                              'Error exploding BOM: ' || iapiGeneral.GetLastErrorText() );
         aapiTrace.Error(iapiGeneral.GetLastErrorText());
         aapiTrace.Exit();
         RETURN lnRetVal;
      END IF;

      aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
      RETURN iapiConstantDbError.DBERR_SUCCESS;
   END ExplodeHeader;

   PROCEDURE SetParentChildRelationship
   IS
      CURSOR cParentChild
      IS
         SELECT c.sequence_no, p.component_part parent_part, p.component_revision parent_revision,
                p.sequence_no parent_sequence_no
         FROM   atfuncbomworkarea c, atfuncbomworkarea p
         WHERE  c.user_id = USER AND c.applic = aapispectrac.psApplic
         AND    c.user_id = p.user_id AND p.applic = aapispectrac.psApplic
         AND    p.sequence_no =
                   (SELECT MAX(sequence_no)
                    FROM   atfuncbomworkarea
                    WHERE  user_id = c.user_id AND applic = aapispectrac.psApplic
                    AND    sequence_no < c.sequence_no
                    AND    bom_level = c.bom_level - 1);
   BEGIN
      aapiTrace.Enter();
      
      FOR rpc IN cParentChild
      LOOP
         UPDATE atfuncbomworkarea
         SET parent_part = rpc.parent_part,
             parent_revision = rpc.parent_revision,
             parent_sequence_no = rpc.parent_sequence_no
         WHERE  user_id = USER AND applic = aapispectrac.psApplic AND sequence_no = rpc.sequence_no;
      END LOOP;
      
      aapiTrace.Exit();
   END SetParentChildRelationship;

   PROCEDURE MarkComponent(
      anSeqNo           IN   iapiType.Sequence_Type,
      asIntLevel        IN   iapiType.String_Type,
      anAncestorSeqNo   IN   iapiType.Sequence_Type)
   IS
      csMethod   CONSTANT iapiType.Method_Type := 'MarkComponent';
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('anSeqNo', anSeqNo);
      aapiTrace.Param('asIntLevel', asIntLevel);
      aapiTrace.Param('anAncestorSeqNo', anAncestorSeqNo);
      
      iapiGeneral.LogInfo(psSource,
                          csMethod,
                             'Called for: <'
                          || anSeqNo
                          || '><'
                          || asIntLevel
                          || '><'
                          || anAncestorSeqNo
                          || '>');
      CalculateFunctionalQuantity(anSeqNo, anAncestorSeqNo);

      UPDATE atfuncbomworkarea
      SET func_level = asIntLevel || '|'
      WHERE  user_id = USER AND applic = aapispectrac.psApplic AND sequence_no = anSeqNo;

      INSERT INTO atfuncbom
                  (user_id, applic, func_level, component_part, component_revision, description, plant,
                   alternative, USAGE, qty, FUNCTION, part_type, func_override)
         SELECT user_id, applic, asIntLevel, component_part, component_revision, description, plant,
                alternative, USAGE, func_qty, FUNCTION, part_type, func_override
         FROM   atfuncbomworkarea
         WHERE  user_id = USER AND applic = aapispectrac.psApplic AND sequence_no = anSeqNo;

      aapiTrace.Exit();
   END MarkComponent;

   PROCEDURE CalculateFunctionalQuantity(
      anSeqNo           IN   iapiType.Sequence_Type,
      anAncestorSeqNo   IN   iapiType.Sequence_Type)
   IS
      csMethod   CONSTANT iapiType.Method_Type      := 'CalculateFunctionalQuantity';
      lnRetVal            iapiType.ErrorNum_Type;
      lnPathLength        INTEGER;
      lnParentQty         iapiType.BomQuantity_Type;
      lnCalcQty           iapiType.BomQuantity_Type;
      lnBaseQty           iapiType.BomQuantity_Type;

   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('anSeqNo', anSeqNo);
      aapiTrace.Param('anAncestorSeqNo', anAncestorSeqNo);
   
      iapiGeneral.LogInfo(psSource,
                          csMethod,
                          'Called for: <' || anSeqNo || '><' || anAncestorSeqNo || '>');

      SELECT     COUNT(sequence_no)
      INTO       lnPathLength
      FROM       atfuncbomworkarea
      WHERE      user_id = USER AND applic = aapispectrac.psApplic AND sequence_no BETWEEN anAncestorSeqNo AND anSeqNo
      START WITH sequence_no = anSeqNo AND user_id = USER AND applic = aapispectrac.psApplic
      CONNECT BY sequence_no = PRIOR parent_sequence_no AND user_id = USER AND applic = aapispectrac.psApplic ;

      iapiGeneral.LogInfo(psSource, csMethod, 'lnPathLength: <' || lnPathLength || '>');

      IF lnPathLength IN(1, 2)   --1: root node, 2: normal parent/child
      THEN
       iapiGeneral.LogInfo(psSource, csMethod, 'Direct child -> func_qty = qty');

       UPDATE atfuncbomworkarea
         SET func_qty = qty
         WHERE  user_id = USER AND applic = aapispectrac.psApplic AND sequence_no = anSeqNo;
      ELSIF lnPathLength > 2
      THEN
         iapiGeneral.LogInfo(psSource,
                             csMethod,
                             'Path contains dummy levels -> need to calculate func_qty');

         FOR rExpl IN (SELECT     sequence_no, parent_sequence_no, component_part,
                                  component_revision, plant, alternative, USAGE, qty
                       FROM       atfuncbomworkarea
                       WHERE      user_id = USER AND applic = aapispectrac.psApplic AND sequence_no BETWEEN anAncestorSeqNo AND anSeqNo
                       START WITH sequence_no = anSeqNo AND user_id = USER AND applic = aapispectrac.psApplic
                       CONNECT BY sequence_no = PRIOR parent_sequence_no AND user_id = USER AND applic = aapispectrac.psApplic
                       ORDER BY   sequence_no)
         LOOP
            iapiGeneral.LogInfo(psSource,
                                csMethod,
                                   '<'
                                || rExpl.sequence_no
                                || '><'
                                || rExpl.parent_sequence_no
                                || '><'
                                || rExpl.component_part
                                || '><'
                                || rExpl.component_revision
                                || '><'
                                || rExpl.plant
                                || '><'
                                || rExpl.alternative
                                || '><'
                                || rExpl.USAGE
                                || '><'
                                || rExpl.qty
                                || '>');

            IF rExpl.sequence_no = anAncestorSeqNo
            THEN
               SELECT base_quantity
               INTO   lnCalcQty
               FROM   bom_header
               WHERE  (part_no, revision, plant, alternative, bom_usage) IN(
                            SELECT component_part, component_revision, plant, alternative, USAGE
                            FROM   atfuncbomworkarea
                            WHERE  user_id = USER AND applic = aapispectrac.psApplic
                                   AND sequence_no = NVL(rExpl.parent_sequence_no, 10) );
            ELSE
               lnCalcQty := lnParentQty / lnBaseQty * rExpl.qty;
            END IF;

            iapiGeneral.LogInfo(psSource, csMethod, 'lnCalcQty: <' || lnCalcQty || '>');
            lnParentQty := lnCalcQty;
            iapiGeneral.LogInfo(psSource, csMethod, 'lnParentQty: <' || lnParentQty || '>');

            IF rExpl.sequence_no != anSeqNo
            THEN
               SELECT base_quantity
               INTO   lnBaseQty
               FROM   bom_header
               WHERE  part_no = rExpl.component_part
               AND    revision = rExpl.component_revision
               AND    plant = rExpl.plant
               AND    alternative = rExpl.alternative
               AND    bom_usage = rExpl.USAGE;

               iapiGeneral.LogInfo(psSource, csMethod, 'lnBaseQty: <' || lnBaseQty || '>');
            END IF;
         END LOOP;

         iapiGeneral.LogInfo(psSource, csMethod, 'END RESULT: <' || lnCalcQty || '>');

         UPDATE atfuncbomworkarea
         SET func_qty = lnCalcQty
         WHERE  user_id = USER AND applic = aapispectrac.psApplic AND sequence_no = anSeqNo;
      END IF;
      
      aapiTrace.Exit();
   END CalculateFunctionalQuantity;

   PROCEDURE CreateDummyComponent(
      asIntLevel   IN   iapiType.String_Type,
      asFunction   IN   iapiType.Description_Type)
   IS
      csMethod   CONSTANT iapiType.Method_Type := 'CreateDummyComponent';
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asIntLevel', asIntLevel);
      aapiTrace.Param('asFunction', asFunction);
      
      iapiGeneral.LogInfo(psSource,
                          csMethod,
                          'Called for: <' || asIntLevel || '><' || asFunction || '>');

      INSERT INTO atfuncbom
                  (user_id, applic, func_level, component_part, FUNCTION)
      VALUES      (USER, aapispectrac.psApplic, asIntLevel, PART_NOT_FOUND, asFunction);
      
      aapiTrace.Exit();
   END CreateDummyComponent;

   PROCEDURE MarkSubTree(anParentSeqNo IN iapiType.Sequence_Type)
   IS
      csMethod   CONSTANT iapiType.Method_Type      := 'MarkSubTree';
      lsLevel             iapiType.Description_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('anParentSeqNo', anParentSeqNo);
      
      iapiGeneral.LogInfo(psSource, csMethod, 'Called for: <' || anParentSeqNo || '>');

      BEGIN
         SELECT SUBSTR(func_level, 1, INSTR(func_level, '|') - 1) || '.*'
         INTO   lsLevel
         FROM   atfuncbomworkarea
         WHERE  user_id = USER AND applic = aapispectrac.psApplic AND sequence_no = anParentSeqNo;

         iapiGeneral.LogInfo(psSource, csMethod, 'lsLevel: <' || lsLevel || '>');
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            iapiGeneral.LogInfo(psSource, csMethod, 'Sequence number not found in workarea');
            
            aapiTrace.Error('Sequence number not found in workarea');
            aapiTrace.Exit();
            RETURN;
      END;

      UPDATE atfuncbomworkarea
      SET func_level = lsLevel
      WHERE  user_id = USER AND applic = aapispectrac.psApplic
      AND    sequence_no IN(SELECT     sequence_no
                            FROM       atfuncbomworkarea
                            WHERE      user_id = USER AND applic = aapispectrac.psApplic AND sequence_no > anParentSeqNo
                            START WITH sequence_no = anParentSeqNo AND user_id = USER AND applic = aapispectrac.psApplic
                            CONNECT BY parent_sequence_no = PRIOR sequence_no AND user_id = USER AND applic = aapispectrac.psApplic );
      
      aapiTrace.Exit();
   END;

   PROCEDURE MarkAncestralPath(
      anChildSeqNo      IN   iapiType.Sequence_Type,
      anAncestorSeqNo   IN   iapiType.Sequence_Type)
   IS
      csMethod   CONSTANT iapiType.Method_Type := 'MarkAncestralPath';
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('anChildSeqNo', anChildSeqNo);
      aapiTrace.Param('anAncestorSeqNo', anAncestorSeqNo);
      
      iapiGeneral.LogInfo(psSource,
                          csMethod,
                          'Called for: <' || anChildSeqNo || '><' || anAncestorSeqNo || '>');

      UPDATE atfuncbomworkarea
      SET func_level = REPLACE(func_level, '*', '-')
      WHERE  user_id = USER AND applic = aapispectrac.psApplic
      AND    sequence_no IN(
                SELECT     sequence_no
                FROM       atfuncbomworkarea
                WHERE      user_id = USER AND applic = aapispectrac.psApplic
                AND        sequence_no BETWEEN anAncestorSeqNo + 1 AND anChildSeqNo - 1
                START WITH sequence_no = anChildSeqNo AND user_id = USER AND applic = aapispectrac.psApplic
                CONNECT BY sequence_no = PRIOR parent_sequence_no AND user_id = USER AND applic = aapispectrac.psApplic );

      aapiTrace.Exit();
   END MarkAncestralPath;

   /*//////////////////////////////////////////////
   //                                            //
   // REPLACING COMPONENTS IN THE FUNCTIONAL BOM //
   //                                            //
   //////////////////////////////////////////////*/
   FUNCTION ReplaceComponent(
      asLevel    IN   iapiType.String_Type,
      asPartNo   IN   iapiType.PartNo_Type,
      asPlant    IN   iapiType.PlantNo_Type,
      asFunction IN   iapiType.String_Type DEFAULT NULL)
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type   := 'ReplaceComponent';
      lnRetVal            iapiType.ErrorNum_Type;
      lsIntLevel          iapiType.String_Type;
      lsOrigPartNo        iapiType.PartNo_Type;
      lnStartSeqNo        iapiType.Sequence_Type;
      lnStartBomLevel     iapiType.Sequence_Type;
      ldExplosionDate     iapiType.Date_Type;
      lnStopSeqNo         iapiType.Sequence_Type;
      lnNewStopSeqNo      iapiType.Sequence_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asLevel', asLevel);
      aapiTrace.Param('asPartNo', asPartNo);
      aapiTrace.Param('asPlant', asPlant);
      aapiTrace.Param('asFunction', asFunction);
      
      iapiGeneral.LogInfo(psSource,
                          csMethod,
                          'Called for <' || asLevel || '><' || asPartNo || '><' || asPlant || '>');
      lsIntLevel := GetInternalLevel(asLevel);
      iapiGeneral.LogInfo(psSource, csMethod, 'lsIntLevel: <' || lsIntLevel || '>');
--DEBUG
iapiGeneral.LogError(psSource, csMethod, 'Replace called: ' || asLevel || ',' || asPartNo);

      --get information about the start of the replacement
      BEGIN
         SELECT sequence_no, bom_level, explosion_date, component_part
         INTO   lnStartSeqNo, lnStartBomLevel, ldExplosionDate, lsOrigPartNo
         FROM   atfuncbomworkarea
         WHERE  user_id = USER AND applic = aapispectrac.psApplic AND func_level = lsIntLevel || '|';

         iapiGeneral.LogInfo(psSource,
                             csMethod,
                                'lnStartSeqNo: <'
                             || lnStartSeqNo
                             || '>, lnStartBomLevel: <'
                             || lnStartBomLevel
                             || '>, ldExplosionDate: <'
                             || ldExplosionDate
                             || '>, lsOrigPartNo: <'
                             || lsOrigPartNo
                             || '>');
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            iapiGeneral.LogInfo(psSource,
                                csMethod,
                                'Level not found in working area, checking funcbom for NOT_FOUND');

            BEGIN
               SELECT component_part
               INTO   lsOrigPartNo
               FROM   atfuncbom
               WHERE  user_id = USER AND applic = aapispectrac.psApplic AND func_level = lsIntLevel AND component_part = PART_NOT_FOUND;

               iapiGeneral.LogInfo(psSource, csMethod, 'Dummy level found');
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  iapiGeneral.LogError(psSource, csMethod, 'Level <' || lsIntLevel || '> not found');
                  aapiTrace.Error('Level <' || lsIntLevel || '> not found');
                  aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
                  RETURN iapiConstantDbError.DBERR_GENFAIL;
            END;
      END;

      CASE lsOrigPartNo
         WHEN PART_NOT_FOUND
         THEN
            iapiGeneral.LogInfo(psSource, csMethod, 'Replacing dummy component');

            --Insert the new component right after the component on the same functional level,
            --with the highest number lower than my own level (i.e. insert 0.1.2.3 after 0.1.2.2
            --if it exists, else after 0.1.2.1 if it exists, and else as child of 0.1.2)
            BEGIN
               SELECT DISTINCT FIRST_VALUE(sequence_no) OVER(ORDER BY GetChildLevel(func_level) DESC)
               INTO            lnStartSeqNo
               FROM            atfuncbomworkarea
               WHERE           user_id = USER AND applic = aapispectrac.psApplic
               AND             GetParentLevel(func_level) = GetParentLevel(lsIntLevel)
               AND             GetChildLevel(func_level) < GetChildLevel(lsIntLevel);
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  BEGIN
                     iapiGeneral.LogInfo(psSource,
                                         csMethod,
                                         'No prior sibbling found, searching for parent');

                     SELECT sequence_no
                     INTO   lnStartSeqNo
                     FROM   atfuncbomworkarea
                     WHERE  user_id = USER AND applic = aapispectrac.psApplic AND func_level = GetParentLevel(lsIntLevel) || '|';
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        iapiGeneral.LogError(psSource,
                                             csMethod,
                                             'Couldn''t find position to insert replacement');
                        aapiTrace.Error('Couldn''t find position to insert replacement');
                        aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
                        RETURN iapiConstantDbError.DBERR_GENFAIL;
                  END;
            END;

            SELECT bom_level, explosion_date
            INTO   lnStartBomLevel, ldExplosionDate
            FROM   atfuncbomworkarea
            WHERE  user_id = USER AND applic = aapispectrac.psApplic AND sequence_no = lnStartSeqNo;

            iapiGeneral.LogInfo(psSource,
                                csMethod,
                                   'lnStartSeqNo: <'
                                || lnStartSeqNo
                                || '>, lnStartBomLevel: <'
                                || lnStartBomLevel
                                || '>, ldExplosionDate: <'
                                || ldExplosionDate
                                || '>, lsOrigPartNo: <'
                                || lsOrigPartNo
                                || '>');
            iapiGeneral.LogInfo(psSource,
                                csMethod,
                                'Creating space for replacement after <' || lnStartSeqNo || '>');

            UPDATE atfuncbomworkarea
            SET sequence_no = sequence_no + 10
            WHERE  user_id = USER AND applic = aapispectrac.psApplic AND sequence_no > lnStartSeqNo;

            UPDATE atfuncbomworkarea
            SET parent_sequence_no = parent_sequence_no + 10
            WHERE  user_id = USER AND applic = aapispectrac.psApplic AND parent_sequence_no > lnStartSeqNo;

            lnStartSeqNo := lnStartSeqNo + 10;
            lnStopSeqNo := lnStartSeqNo + 10;
         ELSE
            iapiGeneral.LogInfo(psSource, csMethod, 'Replacing real component');

            --get the sequence number where we need to stop replacing
            --(i.e. the next child on the same level, the delete will not include this item)
            SELECT MIN(sequence_no)
            INTO   lnStopSeqNo
            FROM   atfuncbomworkarea
            WHERE  user_id = USER AND applic = aapispectrac.psApplic
            AND    sequence_no > lnStartSeqNo   --don't include myself!
            AND    bom_level = lnStartBomLevel;

            --there is no child on the same level: remove everything below me
            --add an offset because the delete will not include this level
            IF lnStopSeqNo IS NULL
            THEN
               SELECT MAX(sequence_no) + 10
               INTO   lnStopSeqNo
               FROM   atfuncbomworkarea
               WHERE  user_id = USER AND applic = aapispectrac.psApplic AND sequence_no >= lnStartSeqNo;   --this time include myself (in case I'm the last one)
            END IF;
      END CASE;

      --add a small negative offset, because the delete shouldn't include the row on lnStopSeqNo
      iapiGeneral.LogInfo(psSource,
                          csMethod,
                             'Deleting old subtree <'
                          || TO_CHAR(lnStartSeqNo)
                          || '>-<'
                          || TO_CHAR(lnStopSeqNo - 1)
                          || '>, <'
                          || lsIntLevel
                          || '>');
      ClearResults(lnStartSeqNo, lnStopSeqNo - 1, lsIntLevel);
      iapiGeneral.LogInfo(psSource, csMethod, 'Park existing data');

      UPDATE atfuncbomworkarea
      SET sequence_no = sequence_no * -1
      WHERE  user_id = USER AND applic = aapispectrac.psApplic ;

      IF asPartNo != PART_NOT_FOUND
      THEN
         iapiGeneral.LogInfo(psSource, csMethod, 'Get the new subtree');
         lnRetVal := InitializeExtract(asPartNo, asPlant, ldExplosionDate);

         IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
         THEN
            --iapiGeneral.LogError(psSource, csMethod, 'Extraction of new subtree failed');
            --RETURN lnRetVal;

            INSERT INTO atfuncbomworkarea (
              user_id, sequence_no, bom_level, component_part, component_revision, description, part_type, plant,
              alternative, usage, explosion_date, qty, func_qty, uom, function, func_level, func_override,
              parent_part, parent_revision, parent_sequence_no, applic
            )
            SELECT
              USER AS user_id,
              10 AS sequence_no,
              0 AS bom_level,
              part_no AS component_part,
              sh.revision AS component_revision,
              sh.description AS description,
              class3.description AS part_type,
              asPlant AS plant,
              1 AS alternative,
              1 AS usage,
              ldExplosionDate AS explosion_date, --EXPLOSION DATE
              1 AS qty,
              1 AS func_qty,
              part.base_uom AS uom,
              asFunction AS function, --FUNCTION,
              '0|' AS func_level,
              0 AS func_override,
              NULL AS parent_part,
              NULL AS parent_revision,
              NULL AS parent_sequence_no,
              aapispectrac.psApplic AS applic
            FROM specification_header sh
            LEFT JOIN class3 ON (class3.class = sh.class3_id)
            LEFT JOIN part USING (part_no)
            WHERE (part_no, revision) = (
              SELECT part_no, MAX(revision)
              FROM specification_header
              LEFT JOIN part_plant USING (part_no)
              WHERE part_no = asPartNo
              AND plant = asPlant
              AND TRUNC(planned_effective_date) <= ldExplosionDate
              GROUP BY part_no
            );
         END IF;

         IF asFunction IS NOT NULL THEN
           UPDATE atfuncbomworkarea
           SET function = asFunction,
               func_override = 1
           WHERE  user_id = USER AND applic = aapispectrac.psApplic AND sequence_no > 0 AND bom_level = 0;
         END IF;

         iapiGeneral.LogInfo(psSource, csMethod, 'Adapt level and sequence of the new subtree');

         UPDATE atfuncbomworkarea
         SET sequence_no = sequence_no - 10 + lnStartSeqNo,
             bom_level = bom_level + lnStartBomLevel,
             func_level = GetParentLevel(lsIntLevel) || '.*'
         WHERE  user_id = USER AND applic = aapispectrac.psApplic AND sequence_no > 0;
      ELSE
         iapiGeneral.LogInfo(psSource, csMethod, 'Replace by PART_NOT_FOUND = delete subtree');
      END IF;

      iapiGeneral.LogInfo(psSource,
                          csMethod,
                          'Put the part of the explosion before the replacement back');

      UPDATE atfuncbomworkarea
      SET sequence_no = sequence_no * -1
      WHERE  user_id = USER AND applic = aapispectrac.psApplic AND sequence_no BETWEEN -lnStartSeqNo AND 0;

      --change the sequence_no to cater for potential changes in the size of the subtree
      SELECT MAX(sequence_no)
      INTO   lnNewStopSeqNo
      FROM   atfuncbomworkarea
      WHERE  user_id = USER AND applic = aapispectrac.psApplic AND sequence_no > 0;

      iapiGeneral.LogInfo(psSource, csMethod, 'lnNewStopSeqNo: <' || lnNewStopSeqNo || '>');

      UPDATE atfuncbomworkarea
      SET sequence_no = sequence_no * -1 +(lnNewStopSeqNo - lnStopSeqNo) + 10
      WHERE  user_id = USER AND applic = aapispectrac.psApplic AND sequence_no < 0;

      iapiGeneral.LogInfo(psSource,
                          csMethod,
                          'Re-run parent-child relationships extraction for new sequence_no');
      SetParentChildRelationship;
      iapiGeneral.LogInfo(psSource, csMethod, 'Replace completed');

      aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
      RETURN iapiConstantDbError.DBERR_SUCCESS;
   END ReplaceComponent;

   /*/////////////////////////////////////////////////
   //                                               //
   // WRITING FUNCTIONAL BOM BACK TO SPECIFICATIONS //
   //                                               //
   /////////////////////////////////////////////////*/
   FUNCTION UpdateFuncBOMRow(
      asLevel              IN   iapiType.String_Type,
      asAction             IN   iapiType.String_Type,
      asPartNo             IN   iapiType.PartNo_Type,
      anRevision           IN   iapiType.Revision_Type,
      asDescription        IN   iapiType.Description_Type,
      asFrameNo            IN   iapiType.FrameNo_Type,
      asPlant              IN   iapiType.PlantNo_Type,
      anQuantity           IN   iapiType.BomQuantity_Type,
      anFunctionOverride   IN   iapiType.Boolean_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type := 'UpdateFuncBOMRow';
      lsIntLevel          iapiType.String_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asLevel', asLevel);
      aapiTrace.Param('asAction', asAction);
      aapiTrace.Param('asPartNo', asPartNo);
      aapiTrace.Param('anRevision', anRevision);
      aapiTrace.Param('asDescription', asDescription);
      aapiTrace.Param('asFrameNo', asFrameNo);
      aapiTrace.Param('asPlant', asPlant);
      aapiTrace.Param('anQuantity', anQuantity);
      aapiTrace.Param('anFunctionOverride', anFunctionOverride);
      
      iapiGeneral.LogInfo(psSource,
                          csMethod,
                             'Called for <'
                          || asLevel
                          || '><'
                          || asAction
                          || '><'
                          || asPartNo
                          || '><'
                          || anRevision
                          || '><'
                          || asDescription
                          || '><'
                          || asFrameNo
                          || '><'
                          || asPlant
                          || '><'
                          || anQuantity
                          || '><'
                          || anFunctionOverride
                          || '>');

      CASE asAction
         WHEN ACTION_CREATE
         THEN
            IF NOT(    asPartNo IS NOT NULL
                   AND asDescription IS NOT NULL
                   AND asFrameNo IS NOT NULL
                   AND asPlant IS NOT NULL
                   AND anQuantity > 0
                   AND anFunctionOverride IN(0, 1) )
            THEN
               iapiGeneral.LogError(psSource,
                                    csMethod,
                                    'Not all necessary input arguments provided');
               RETURN iapiConstantDbError.DBERR_GENFAIL;
            END IF;

            IF iapiPart.ExistId(asPartNo) = iapiConstantDbError.DBERR_SUCCESS
            THEN
               iapiGeneral.LogError(psSource, csMethod, 'Part already exists');
               aapiTrace.Error('Part already exists');
               aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
               RETURN iapiConstantDbError.DBERR_GENFAIL;
            END IF;
         WHEN ACTION_UPDATE
         THEN
            IF NOT(    asPartNo IS NOT NULL
                   AND anRevision > 0
                   AND anQuantity > 0
                   AND anFunctionOverride IN(0, 1) )
            THEN
               iapiGeneral.LogError(psSource,
                                    csMethod,
                                    'Not all necessary input arguments provided');
               aapiTrace.Error('Not all necessary input arguments provided');
               aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
               RETURN iapiConstantDbError.DBERR_GENFAIL;
            END IF;

            IF NOT iapiSpecification.ExistId(asPartNo, anRevision) =
                                                                   iapiConstantDbError.DBERR_SUCCESS
            THEN
               iapiGeneral.LogError(psSource, csMethod, 'Specification has to exist');
               aapiTrace.Error('Specification has to exist');
               aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
               RETURN iapiConstantDbError.DBERR_GENFAIL;
            END IF;
         ELSE
            IF asAction IS NOT NULL
            THEN
               iapiGeneral.LogError(psSource, csMethod, 'Invalid action');
               aapiTrace.Error('Invalid action');
               aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
               RETURN iapiConstantDbError.DBERR_GENFAIL;
            END IF;
      END CASE;

      lsIntLevel := GetInternalLevel(asLevel);
      iapiGeneral.LogInfo(psSource, csMethod, 'lsIntLevel: <' || lsIntLevel || '>');

      UPDATE atfuncbom
      SET action = asAction,
          component_part = asPartNo,
          component_revision = DECODE(asAction, ACTION_CREATE, 1, anRevision),
          description = asDescription,
          frame_no = asFrameNo,
          plant = asPlant,
          qty = anQuantity,
          func_override = anFunctionOverride
      WHERE  user_id = USER AND applic = aapispectrac.psApplic AND func_level = lsIntLevel;

      IF NOT(SQL%ROWCOUNT = 1)
      THEN
         iapiGeneral.LogError(psSource, csMethod, 'Update failed');
         aapiTrace.Error('Update failed');
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapiConstantDbError.DBERR_GENFAIL;
      ELSE
         iapiGeneral.LogInfo(psSource, csMethod, 'Update completed');
         aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
         RETURN iapiConstantDbError.DBERR_SUCCESS;
      END IF;

   END UpdateFuncBOMRow;

   FUNCTION SaveFuncBom
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type   := 'SaveFuncBom';
      lnRetVal            iapiType.ErrorNum_Type;
   BEGIN
      aapiTrace.Enter();
      
      iapiGeneral.LogInfo(psSource, csMethod, 'Called');
      lnRetVal := ValidateFuncBom;

      IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
      THEN
         iapiGeneral.LogError(psSource, csMethod, 'Validation failed');
         aapiTrace.Error('Validation failed');
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapiConstantDbError.DBERR_GENFAIL;
      END IF;

      iapiGeneral.LogInfo(psSource, csMethod, 'Validation passed - start saving');

      FOR rProcess IN (SELECT   component_part, description, frame_no, plant, action, func_level,
                                FUNCTION
                       FROM     atfuncbom
                       WHERE    user_id = USER AND applic = aapispectrac.psApplic AND action IS NOT NULL
                       ORDER BY GetDepth(func_level) DESC, action, func_level)
      LOOP
         iapiGeneral.LogInfo(psSource,
                             csMethod,
                             'Processing: <' || rProcess.func_level || '><' || rProcess.action
                             || '>');

         CASE rProcess.action
            WHEN ACTION_CREATE
            THEN
               lnRetVal :=
                  CreateSpecification(rProcess.component_part,
                                      rProcess.description,
                                      rProcess.frame_no,
                                      rProcess.plant,
                                      rProcess.FUNCTION);

               IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
               THEN
                  iapiGeneral.LogError(psSource, csMethod, 'Failed to create specification');
                  aapiTrace.Error('Failed to create specification');
                  aapiTrace.Exit(lnRetVal);
                  RETURN lnRetVal;
               END IF;

               lnRetVal := UpdateBOM(rProcess.func_level);

               IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
               THEN
                  iapiGeneral.LogError(psSource, csMethod, 'Failed to update BOM');
                  aapiTrace.Error('Failed to update BOM');
                  aapiTrace.Exit(lnRetVal);
                  RETURN lnRetVal;
               END IF;
            WHEN ACTION_UPDATE
            THEN
               lnRetVal := UpdateBOM(rProcess.func_level);

               IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
               THEN
                  iapiGeneral.LogError(psSource, csMethod, 'Failed to update BOM');
                  aapiTrace.Error('Failed to update BOM');
                  aapiTrace.Exit(lnRetVal);
                  RETURN lnRetVal;
               END IF;
            ELSE
               iapiGeneral.LogError(psSource, csMethod, 'Invalid action');
               aapiTrace.Error('Invalid action');
               aapiTrace.Exit(iapiConstantDbError.DBERR_INVALIDACTION);
               RETURN iapiConstantDbError.DBERR_INVALIDACTION;
         END CASE;
      END LOOP;

      iapiGeneral.LogInfo(psSource, csMethod, 'Save completed');
      aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
      RETURN iapiConstantDbError.DBERR_SUCCESS;
   END SaveFuncBom;

   FUNCTION ValidateFuncBom
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type := 'ValidateFuncBom';
      lnConflicts         INTEGER;
   BEGIN
      aapiTrace.Enter();
      
      iapiGeneral.LogInfo(psSource, csMethod, 'Called');
      iapiGeneral.LogInfo(psSource, csMethod, 'PART_NOT_FOUND not allowed for actions');

      SELECT COUNT(*)
      INTO   lnConflicts
      FROM   atfuncbom
      WHERE  user_id = USER AND applic = aapispectrac.psApplic AND action IS NOT NULL AND component_part = PART_NOT_FOUND;

      IF lnConflicts > 0
      THEN
         iapiGeneral.LogError(psSource, csMethod, 'PART_NOT_FOUND validation failed');
         aapiTrace.Error('PART_NOT_FOUND validation failed');
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapiConstantDbError.DBERR_GENFAIL;
      END IF;

      iapiGeneral.LogInfo(psSource, csMethod, 'CREATE needs certain fields');

      SELECT COUNT(*)
      INTO   lnConflicts
      FROM   atfuncbom
      WHERE  user_id = USER AND applic = aapispectrac.psApplic
      AND action = ACTION_CREATE AND(   description IS NULL OR frame_no IS NULL);

      IF lnConflicts > 0
      THEN
         iapiGeneral.LogError(psSource, csMethod, 'CREATE validation failed');
         RETURN iapiConstantDbError.DBERR_GENFAIL;
      END IF;

      iapiGeneral.LogInfo(psSource, csMethod, 'UPDATE needs certain fields');

      SELECT COUNT(*)
      INTO   lnConflicts
      FROM   atfuncbom
      WHERE  user_id = USER AND applic = aapispectrac.psApplic
      AND    action = ACTION_UPDATE
      AND    (   component_revision IS NULL
              OR component_revision < 1);

      IF lnConflicts > 0
      THEN
         iapiGeneral.LogError(psSource, csMethod, 'UPDATE validation failed');
         aapiTrace.Error('UPDATE validation failed');
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapiConstantDbError.DBERR_GENFAIL;
      END IF;

      iapiGeneral.LogInfo(psSource,
                          csMethod,
                          'CREATE needs to be nested below UPDATE or other CREATE');

      SELECT COUNT(*)
      INTO   lnConflicts
      FROM   (SELECT GetParentLevel(func_level)
              FROM   atfuncbom
              WHERE  user_id = USER AND applic = aapispectrac.psApplic AND action = ACTION_CREATE AND func_level != '0'
              MINUS
              SELECT func_level
              FROM   atfuncbom
              WHERE  user_id = USER AND applic = aapispectrac.psApplic AND action IN(ACTION_UPDATE, ACTION_CREATE) );

      IF lnConflicts > 0
      THEN
         iapiGeneral.LogError(psSource, csMethod, 'NESTING validation failed');
         aapiTrace.Error('NESTING validation failed');
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapiConstantDbError.DBERR_GENFAIL;
      END IF;

      iapiGeneral.LogInfo(psSource, csMethod, 'Validation passed');
      aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);      
      RETURN iapiConstantDbError.DBERR_SUCCESS;
   END ValidateFuncBom;

   FUNCTION CreateSpecification(
      asPartNo        IN   iapiType.PartNo_Type,
      asDescription   IN   iapiType.Description_Type,
      asFrameNo       IN   iapiType.FrameNo_Type,
      asPlant         IN   iapiType.PlantNo_Type,
      asFunction      IN   iapiType.Description_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type           := 'CreateSpecification';
      lnRetVal            iapiType.ErrorNum_Type;
      lqErrors            iapiType.Ref_Type;
      lsPartNo            iapiType.PartNo_Type;
      ldPED               iapiType.Date_Type;
      lnFrameRev          iapiType.FrameRevision_Type;
      lnWorkflowGroupId   iapiType.Id_Type;
      lnAccessGroupId     iapiType.Id_Type;
      lnSpecTypeId        iapiType.Id_Type;
      lnLocal             NUMBER                         := 0;
      lqSectionItems      iapiType.Ref_Type;
      ltSectionItems      iapiType.SpSectionItemTab_Type;
      lrSpSectionItem     iapiType.SpSectionItemRec_Type;
      lsBaseUom           iapitype.BaseUom_Type;
      lqInfo              iapiType.Ref_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asPartNo', asPartNo);
      aapiTrace.Param('asDescription', asDescription);
      aapiTrace.Param('asFrameNo', asFrameNo);
      aapiTrace.Param('asPlant', asPlant);
      aapiTrace.Param('asFunction', asFunction);
      
      iapiGeneral.LogInfo(psSource,
                          csMethod,
                             'Called for <'
                          || asPartNo
                          || '><'
                          || asDescription
                          || '><'
                          || asFrameNo
                          || '><'
                          || asPlant
                          || '>');
      iapiGeneral.LogInfo(psSource, csMethod, 'Find current frame data');
      SP_CHK_FRMDATA(a_part_no                => asPartNo,
                     a_revision               => 1,
                     a_frame_no               => asFrameNo,
                     a_frame_owner            => iapiGeneral.SESSION.DATABASE.Owner,
                     a_new_frame_rev          => lnFrameRev,
                     a_workflow_group_id      => lnWorkflowGroupId,
                     a_access_group           => lnAccessGroupId,
                     a_class3_id              => lnSpecTypeId,
                     a_intl                   => '0',   --local mode
                     a_src_intl               => NULL,   --new specification, so no source
                     a_local                  => lnLocal);

      IF lnFrameRev = 0
      THEN
         iapiGeneral.LogError(psSource,
                              csMethod,
                              'No current revision of frame <' || asFrameNo || '> found');
         aapiTrace.Error('No current revision of frame <' || asFrameNo || '> found');
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapiConstantDbError.DBERR_GENFAIL;
      END IF;

      IF    lnWorkflowGroupId IS NULL
         OR lnAccessGroupId IS NULL
         OR lnSpecTypeId IS NULL
      THEN
         iapiGeneral.LogError(psSource, csMethod, 'Frame doesn''t specify all necessary defaults');
         aapiTrace.Error('Frame doesn''t specify all necessary defaults');
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapiConstantDbError.DBERR_GENFAIL;
      END IF;

      iapiGeneral.LogInfo(psSource, csMethod, 'Creating part');
      lsPartNo := asPartNo;

      /*-------------------------------------------------------------------------------------------------------------------------------------
      // The base unit of measurements can be found in the property Base UoM, if not pcs will be used
      //-------------------------------------------------------------------------------------------------------------------------------------*/
      SELECT NVL(MAX(a.char_1), 'pcs')
        INTO lsBaseUom
        FROM frame_prop a, property b
       WHERE a.frame_no = asFrameNo
         AND revision = lnFrameRev
         AND a.property = b.property
         AND b.description = 'Base UoM';

      lnRetVal :=
         iapiPart.AddPart(asPartNo           => lsPartNo,
                          asDescription      => asDescription,
                          asBaseUom          => lsBaseUom,
                          asPartSource       => iapiConstant.PARTSOURCE_INTERNAL,
                          anPartTypeId       => lnSpecTypeId,
                          aqErrors           => lqErrors);

      IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
      THEN
         iapiGeneral.LogError(psSource,
                              csMethod,
                              'Part creation failed: ' || iapiGeneral.GetLastErrorText);
         aapiTrace.Error(iapiGeneral.GetLastErrorText());
         aapiTrace.Exit(lnRetVal);
         RETURN lnRetVal;
      END IF;

      iapiGeneral.LogInfo(psSource, csMethod, 'Adding plant to part');
      lnRetVal :=
         iapiPartPlant.AddPlant(asPartNo               => lsPartNo,
                                asPlantNo              => asPlant,
                                asIssueLocation        => NULL,
                                asIssueUom             => NULL,
                                anOperationalStep      => NULL,
                                aqErrors               => lqErrors);

      IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
      THEN
         iapiGeneral.LogError(psSource,
                              csMethod,
                              'Adding plant to part failed: ' || iapiGeneral.GetLastErrorText);
         aapiTrace.Error(iapiGeneral.GetLastErrorText());
         aapiTrace.Exit(lnRetVal);
         RETURN lnRetVal;
      END IF;

      iapiGeneral.LogInfo(psSource, csMethod, 'Creating specification');
      ldPED := TO_DATE(f_get_ped2(lsPartNo), 'yyyy-mm-dd');
      lnRetVal :=
         iapiSpecification.CreateSpecification(asPartNo                    => lsPartNo,
                                               anRevision                  => 1,
                                               asDescription               => asDescription,
                                               asCreatedBy                 => USER,
                                               adPlannedEffectiveDate      => ldPED,
                                               asFrameId                   => asFrameNo,
                                               anFrameRevision             => lnFrameRev,
                                               anFrameOwner                => iapiGeneral.SESSION.DATABASE.Owner,
                                               anSpecTypeId                => lnSpecTypeId,
                                               anWorkFlowGroupId           => lnWorkFlowGroupId,
                                               anAccessGroupId             => lnAccessGroupId,
                                               anMultiLanguage             => 0,
                                               anUomType                   => 0,
                                               anMaskId                    => -1,
                                               aqErrors                    => lqErrors);

      IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
      THEN
         iapiGeneral.LogError(psSource,
                              csMethod,
                              'Creating specification part failed: ' || iapiGeneral.GetLastErrorText);
         aapiTrace.Error(iapiGeneral.GetLastErrorText());
         aapiTrace.Exit(lnRetVal);
         RETURN lnRetVal;
      END IF;

      iapiGeneral.LogInfo(psSource, csMethod,
                          'Add a BOM header if the frame contains a BOM section');

      SELECT COUNT(*)
      INTO   lnRetVal
      FROM   frame_section
      WHERE  frame_no = asFrameNo AND revision = lnFrameRev AND TYPE = iapiConstant.SECTIONTYPE_BOM;

      IF lnRetVal > 0
      THEN
         lnRetVal :=
            iapiSpecificationBom.AddHeader(asPartNo                    => lsPartNo,
                                           anRevision                  => 1,
                                           asPlant                     => asPlant,
                                           anAlternative               => 1,
                                           anUsage                     => 1,
                                           asDescription               => NULL,
                                           anQuantity                  => 1,
                                           anConversionFactor          => NULL,
                                           asConvertedUom              => NULL,
                                           anYield                     => NULL,
                                           asCalculationMode           => 'N',
                                           asBomType                   => NULL,
                                           anMinimumQuantity           => NULL,
                                           anMaximumQuantity           => NULL,
                                           adPlannedEffectiveDate      => ldPED,
                                           aqInfo                      => lqInfo,
                                           aqErrors                    => lqErrors);

         IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
         THEN
            iapiGeneral.LogError(psSource,
                                 csMethod,
                                 'Adding BOM part failed: ' || iapiGeneral.GetLastErrorText);
            aapiTrace.Error(iapiGeneral.GetLastErrorText());
            aapiTrace.Exit(lnRetVal);
            RETURN lnRetVal;
         ELSE
            iapiGeneral.LogInfo(psSource, csMethod, 'BOM Header added');
         END IF;
      END IF;

      iapiGeneral.LogInfo(psSource, csMethod, 'Setting function keyword');
      lnRetVal := aapiPartKeyword.SetKeywordValue(lsPartNo, KW_FUNCTION, asFunction);

      IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
      THEN
         iapiGeneral.LogError(psSource,
                              csMethod,
                              'Error setting function keyword: ' || iapiGeneral.GetLastErrorText);
         aapiTrace.Error(iapiGeneral.GetLastErrorText());
         aapiTrace.Exit(lnRetVal);
         RETURN lnRetVal;
      END IF;

      iapiGeneral.LogInfo(psSource, csMethod, 'Creation completed');
      aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
      RETURN iapiConstantDbError.DBERR_SUCCESS;
   END CreateSpecification;

   FUNCTION UpdateBOM(asIntLevel IN iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type           := 'UpdateBOM';
 --     lnRetVal            iapiType.ErrorNum_Type;
 --     lqErrors            iapiType.Ref_Type;
 --     lsPartNo            iapiType.PartNo_Type;
 --     lnRevision          iapiType.Revision_Type;
 --     lsPlant             iapiType.PlantNo_Type;
 --     lnAlternative       iapiType.BomAlternative_Type;
 --     lnUsage             iapiType.BomUsageId_Type;
 --     lqBomItems          iapiType.Ref_Type;
 --     ltBomItems          iapiType.BomItemTab_Type;
 --     lrBomItem           iapiType.BomItemRec_Type;
      lqParts             iapiType.Ref_Type;
      ltParts             iapiType.PartTab_Type;
      lrPart              iapiType.PartRec_Type;
      ltFilters           iapiType.FilterTab_Type;
      lrFilter            iapiType.FilterRec_Type;
      lqPartPlants        iapiType.Ref_Type;
      ltPartPlants        iapiType.PartPlantListTab_Type;
      lrPartPlant         iapiType.PartPlantListRec_Type;
      lqInfo              iapiType.Ref_Type;

   lsPartNo                      iapiType.PartNo_Type;
   lnRevision                    iapiType.Revision_Type;
   lsPlant                       iapiType.Plant_Type;
   lnAlternative                 iapiType.BomAlternative_Type := 1;
   lnUsage                       iapiType.BomUsage_Type := 1;
   lnIncludeAlternatives         iapiType.Boolean_Type;
   lqBomItem                     iapiType.Ref_Type;
   ltBomItem                     iapiType.GetBomItemTab_Type;
   lrBomItem                     iapiType.GetBomItemRec_Type;
   lqErrors                      iapiType.Ref_Type;
   ltErrors                      iapiType.ErrorTab_Type;
   lrErrors                      iapiType.ErrorRec_Type;
   lnRetVal                      iapiType.ErrorNum_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asIntLevel', asIntLevel);
      
      iapiGeneral.LogInfo(psSource, csMethod, 'Called for <' || asIntLevel || '>');
      iapiGeneral.LogInfo(psSource, csMethod, 'Getting bom header to update');

      BEGIN
         SELECT component_part, component_revision, plant, alternative, USAGE
         INTO   lsPartNo, lnRevision, lsPlant, lnAlternative, lnUsage
         FROM   atfuncbom
         WHERE  user_id = USER AND applic = aapispectrac.psApplic AND func_level = asIntLevel;

         iapiGeneral.LogInfo(psSource,
                             csMethod,
                                'Header: <'
                             || lsPartNo
                             || '><'
                             || lnRevision
                             || '><'
                             || lsPlant
                             || '><'
                             || lnAlternative
                             || '><'
                             || lnUsage
                             || '>');
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            iapiGeneral.LogInfo(psSource,
                                csMethod,
                                'No header found matching level <' || asIntLevel || '>');
             aapiTrace.Error('No header found matching level <' || asIntLevel || '>');
             aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
            RETURN iapiConstantDbError.DBERR_GENFAIL;
      END;

      iapiGeneral.LogInfo(psSource, csMethod, 'Removing existing items');
      lnRetVal := iapiSpecificationBom.GetItems( lsPartNo,
                                                 lnRevision,
                                                 lsPlant,
                                                 lnAlternative,
                                                 lnUsage,
                                                 lnIncludeAlternatives,
                                                 lqBomItem,
                                                 lqErrors );

      IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS
      THEN
         FETCH lqBomItem
         BULK COLLECT INTO ltBomItem;

         IF (ltBomItem.COUNT > 0)
         THEN
            FOR lnIndex IN ltBomItem.FIRST .. ltBomItem.LAST
            LOOP
               lrBomItem := ltBomItem(lnIndex);
               lnRetVal :=
                  iapiSpecificationBom.RemoveItem(lrBomItem.PartNo,
                                                  lrBomItem.Revision,
                                                  lrBomItem.Plant,
                                                  lrBomItem.Alternative,
                                                  lrBomItem.BomUsage,
                                                  lrBomItem.ItemNumber,
                                                  lqInfo,
                                                  lqErrors);

               IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
               THEN
                  iapiGeneral.LogError(psSource,
                                       csMethod,
                                       'Error deleting item: ' || iapiGeneral.GetLastErrorText);
                  aapiTrace.Error(iapiGeneral.GetLastErrorText());
                  aapiTrace.Exit(lnRetVal);
                  RETURN lnRetVal;
               END IF;
            END LOOP;
         END IF;
      ELSE
         iapiGeneral.LogError(psSource,
                              csMethod,
                              'Error retrieving header: ' || iapiGeneral.GetLastErrorText);
         aapiTrace.Error(iapiGeneral.GetLastErrorText());
         aapiTrace.Exit(lnRetVal);
         RETURN lnRetVal;
      END IF;

      iapiGeneral.LogInfo(psSource, csMethod, 'Start saving new items');

      FOR rComponent IN (SELECT component_part, qty, FUNCTION, func_override, func_level
                         FROM   atfuncbom
                         WHERE  user_id = USER AND applic = aapispectrac.psApplic
                         AND    GetParentLevel(func_level) = asIntLevel
                         AND    component_part != PART_NOT_FOUND)
      LOOP
         iapiGeneral.LogInfo(psSource,
                             csMethod,
                             'Adding component <' || rComponent.component_part || '>');
         lnRetVal := iapiPart.GetPart(rComponent.component_part, lqParts, lqErrors);

         IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS
         THEN
            FETCH lqParts
            BULK COLLECT INTO ltParts;

            BEGIN
               lrPart := ltParts(1);
            EXCEPTION
               WHEN OTHERS
               THEN
                  iapiGeneral.LogError(psSource, csMethod, 'Error retrieving part');
                  aapiTrace.Error('Error retrieving part');
                  aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
                  RETURN iapiConstantDbError.DBERR_GENFAIL;
            END;
         ELSE
            iapiGeneral.LogError(psSource,
                                 csMethod,
                                 'Error retrieving part: ' || iapiGeneral.GetLastErrorText);
            aapiTrace.Error(iapiGeneral.GetLastErrorText());
            aapiTrace.Exit(lnRetVal);
            RETURN lnRetVal;
         END IF;

/* begin fix
-- THE API DOESN'T WORK PROPERLY, SO DO IT THE OLD-FASHIONED WAY UNTIL WE GET A FIX
         SELECT pl.part_no PARTNO,
                part_b.description DESCRIPTION,
                part_a.part_source PARTSOURCE,
                pl.plant PLANTNO,
                plant.description PLANTDESCRIPTION,
                plant.plant_source PLANTSOURCE,
                pl.component_scrap COMPONENTSCRAP,
                DECODE(relevency_to_costing, 'Y', 1, 0) RELEVANCYTOCOSTING,
                DECODE(pl.bulk_material, 'Y', 1, 0) BULKMATERIAL,
                pl.lead_time_offset LEADTIMEOFFSET,
                pl.item_category ITEMCATEGORY,
                DECODE(pl.obsolete, 'Y', 1, 0) OBSOLETE,
                pl.issue_location ISSUELOCATION,
                pl.issue_uom ISSUEUOM,
                pl.operational_step OPERATIONALSTEP
         INTO   lrPartPlant
         FROM   part_plant pl, part part_a, part part_b, plant
         WHERE  pl.follow_on_material = part_b.part_no(+)
         AND    pl.part_no = part_a.part_no
         AND    pl.plant = plant.plant
         AND    pl.part_no = rComponent.component_part
         AND    pl.plant = lsPlant;
-- end with fix */
-- begin with api
         lrFilter.LeftOperand := iapiConstantColumn.PlantNoCol;
         lrFilter.OPERATOR := iapiConstant.OPERATOR_EQUAL;
         lrFilter.RightOperand := lsPlant;
         ltFilters(0) := lrFilter;
         lnRetVal := iapiPartPlant.GetPlants(rComponent.component_part, ltFilters, lqPartPlants);

         IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS
         THEN
            FETCH lqPartPlants
            BULK COLLECT INTO ltPartPlants;

            BEGIN
               lrPartPlant := ltPartPlants(1);
            EXCEPTION
               WHEN OTHERS
               THEN
                  iapiGeneral.LogError(psSource, csMethod, 'Error retrieving part/plant');
                  aapiTrace.Error('Error retrieving part/plant');
                  aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
                  RETURN iapiConstantDbError.DBERR_GENFAIL;
            END;
         ELSE
            iapiGeneral.LogError(psSource,
                                 csMethod,
                                 'Error retrieving part: ' || iapiGeneral.GetLastErrorText);
            aapiTrace.Error(iapiGeneral.GetLastErrorText());
            aapiTrace.Exit(lnRetVal);
            RETURN lnRetVal;
         END IF;
-- end with api
         lnRetVal :=
            iapiSpecificationBom.AddItem
               (asPartNo                   => lsPartNo,
                anRevision                 => lnRevision,
                asPlant                    => lsPlant,
                anAlternative              => lnAlternative,
                anUsage                    => lnUsage,
                anItemNumber               => GetChildLevel(rComponent.func_level) * 10,
                asAlternativeGroup         => NULL,
                anAlternativePriority      => 1,
                asComponentPartNo          => rComponent.component_part,
                anComponentRevision        => NULL,
                asComponentPlant           => lsPlant,
                anQuantity                 => rComponent.qty,
                asUom                      => lrPart.BaseUom,
                anConversionFactor         => lrPart.BaseConvFactor,
                asConvertedUom             => lrPart.BaseToUnit,
                anYield                    => 100,
                anAssemblyScrap            => NULL,
                anComponentScrap           => lrPartPlant.ComponentScrap,
                anLeadTimeOffset           => lrPartPlant.LeadTimeOffset,
                anRelevancyToCosting       => lrPartPlant.RelevancyToCosting,
                anBulkMaterial             => lrPartPlant.BulkMaterial,
                asItemCategory             => lrPartPlant.ItemCategory,
                asIssueLocation            => lrPartPlant.IssueLocation,
                asCalculationMode          => 'N',
                asBomItemType              => NULL,
                anOperationalStep          => lrPartPlant.OperationalStep,
                anMinimumQuantity          => NULL,
                anMaximumQuantity          => NULL,
                anFixedQuantity            => 0,
                asCode                     => NULL,
                asText1                    => NULL,
                asText2                    => NULL,
                asText3                    => NULL,
                asText4                    => NULL,
                asText5                    => NULL,
                anNumeric1                 => NULL,
                anNumeric2                 => NULL,
                anNumeric3                 => NULL,
                anNumeric4                 => NULL,
                anNumeric5                 => NULL,
                anBoolean1                 => 0,
                anBoolean2                 => 0,
                anBoolean3                 => 0,
                anBoolean4                 => 0,
                adDate1                    => NULL,
                adDate2                    => NULL,
                anCharacteristic1          => CASE rComponent.func_override
                   WHEN 1
                      THEN aapiSpectracData.GetIdFromDescription
                                                              (rComponent.FUNCTION,
                                                               aapiSpectracData.GLOSS_CHARACTERISTIC)
                   ELSE NULL
                END,
                anCharacteristic2          => NULL,
                anCharacteristic3          => NULL,
                anMakeUp                   => 0,
                aqInfo                     => lqInfo,
                aqErrors                   => lqErrors);

         IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
         THEN
            iapiGeneral.LogError(psSource,
                                 csMethod,
                                 'Error saving component: ' || iapiGeneral.GetLastErrorText);
            aapiTrace.Error(iapiGeneral.GetLastErrorText());
            aapiTrace.Exit(lnRetVal);
            RETURN lnRetVal;
         END IF;
      END LOOP;

      iapiGeneral.LogInfo(psSource, csMethod, 'Update completed');
      
      aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
      RETURN iapiConstantDbError.DBERR_SUCCESS;
   END UpdateBOM;
END aapiSpectracBom;
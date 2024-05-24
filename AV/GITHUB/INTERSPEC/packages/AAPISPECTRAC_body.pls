create or replace PACKAGE BODY aapiSpectrac AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : aapiSpectrac
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 03/08/2007
--   TARGET : Interspec V6.3; Oracle 10.2.0
--  VERSION : av 1.1
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 03/08/2007 | RS				| Created
-- 16/01/2008 | RS        | Changed LOGON, Added GetApplic, UpdateBulk, DeleteBulk
-- 06/03/2008 | RS        | Added SetApplic
-- 10/03/2011 | RS		    | Upgrade V6.3 SP0
-- 12/12/2012 | RS        | Added SyncNLS to LOGON
-- 04/03/2014 | MVL       | Removed SyncNLS from LOGON.
--                        | Sessions should use client NLS settings.
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
PROCEDURE SyncNLS
IS
   CURSOR nls_instance_settings
   IS
      SELECT parameter, value
        FROM nls_instance_parameters
       WHERE value IS NOT NULL;

BEGIN
   aapiTrace.Enter();

   FOR setting IN nls_instance_settings
   LOOP
      DBMS_SESSION.set_nls (setting.parameter, '''' || setting.value || '''');
   END LOOP;
   
   aapiTrace.Exit();
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (SQLERRM);
      
      aapiTrace.Error(SQLERRM);
      aapiTrace.Exit();
END SyncNLS;

FUNCTION LOGON(
      asApplic IN VARCHAR2 := 'Spectrac',
      anMode   IN NUMBER := 0
   ) RETURN iapiType.ErrorNum_Type
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      csMethod   CONSTANT iapiType.Method_Type   := 'LOGON';
      lnRetVal            iapiType.ErrorNum_Type;
      asPreferenceValue   iapiType.PreferenceValue_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asApplic', asApplic);
      aapiTrace.Param('anMode', anMode);

      --------------------------------------------------------------------------------
      -- Enable database logging when configured
      --------------------------------------------------------------------------------
      lnRetVal := iapiUserPreferences.GETUSERPREFERENCE('General', 'DatabaseLogging', asPreferenceValue);
      IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS AND asPreferenceValue = '1'
      THEN
         iapiGeneral.EnableLogging;
      END IF;


      --2014-03-04 MVL: TODO: Remove call to SyncNLS. Session should use client NLS
      --                so that the server can properly convert between
      --                client input and server storage.
      SyncNLS;
      lnRetVal := SetApplic(asApplic);
      IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS THEN
         iapiGeneral.LogError(psSource, csMethod, 'Error: ' || TO_CHAR(lnRetVal));
      END IF;
      
      --Initialize Interspec session
      lnRetVal := iapiGeneral.SetConnection(asUserId => USER, asModuleName => asApplic);
      IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS THEN
         iapiGeneral.LogError(psSource, csMethod, 'Error: ' || TO_CHAR(lnRetVal));
      END IF;

      lnRetVal := iapiGeneral.SetMode(anMode);
      IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS THEN
         iapiGeneral.LogError(psSource, csMethod, 'Error: ' || TO_CHAR(lnRetVal));
      END IF;
      --Make sure specification access is up-to-date
      --(mainly important for users that don't frequently use the standard applications)
      sp_set_spec_access;
      
      aapiTrace.Exit(lnRetVal);

      COMMIT;
      RETURN lnRetVal;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         iapiGeneral.LogError(psSource, csMethod, SQLERRM);
         aapiTrace.Error(SQLERRM);
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapiConstantDbError.DBERR_GENFAIL;
   END LOGON;

   FUNCTION GetFuncBOMRow(
      asTyreCode           IN       iapiType.PartNo_Type,
      asPlant              IN       iapiType.PlantNo_Type,
      asLevel              IN       iapiType.String_Type,
      asFunction           IN       iapiType.Description_Type,
      adExplosionDate      IN       iapiType.Date_Type,
      asPartNo             OUT      iapiType.PartNo_Type,
      anRevision           OUT      iapiType.Revision_Type,
      asDescription        OUT      iapiType.Description_Type,
      asStatus             OUT      iapiType.ShortDescription_Type,
      anQuantity           OUT      iapiType.BomQuantity_Type,
      asPartType           OUT      iapiType.Description_Type,
      anFunctionOverride   OUT      iapiType.Boolean_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      csMethod   CONSTANT iapiType.Method_Type   := 'GetFuncBOMRow';
      lnRetVal            iapiType.ErrorNum_Type;
      lsLevel             iapiType.String_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asTyreCode', asTyreCode);
      aapiTrace.Param('asPlant', asPlant);
      aapiTrace.Param('asLevel', asLevel);
      aapiTrace.Param('asFunction', asFunction);
      aapiTrace.Param('adExplosionDate', adExplosionDate);

      iapiGeneral.LogInfo(psSource,
                          csMethod,
                             'Called for <'
                          || asTyreCode
                          || '><'
                          || asPlant
                          || '><'
                          || asLevel
                          || '><'
                          || asFunction
                          || '><'
                          || adExplosionDate
                          || '>');

      IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
      THEN
         iapiGeneral.LogInfo(psSource, csMethod, 'Initializing session');

         IF LOGON != iapiConstantDbError.DBERR_SUCCESS
         THEN
            iapiGeneral.LogError(psSource, csMethod, 'Session could not be initialized');
            ROLLBACK;
            
            aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
            RETURN iapiConstantDbError.DBERR_GENFAIL;
         END IF;
      END IF;

      iapiGeneral.LogInfo(psSource, csMethod, 'Session correctly initialized');
      lsLevel := REPLACE(asLevel, ',', '.');
      iapiGeneral.LogInfo(psSource, csMethod, 'lsLevel: <' || lsLevel || '>');

      IF lsLevel IS NULL
      THEN
         iapiGeneral.LogInfo(psSource, csMethod, 'lsLevel IS NULL -> start a new run');
         iapiGeneral.LogInfo(psSource, csMethod, 'Clear previous results');
         aapiSpectracBom.ClearResults;
         iapiGeneral.LogInfo(psSource, csMethod, 'Initialize working area');
         lnRetVal := aapiSpectracBom.InitializeExtract(asTyreCode, asPlant, adExplosionDate);

         IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
         THEN
            iapiGeneral.LogError(psSource, csMethod, 'Extract could not be initialized');
            ROLLBACK;
            
            aapiTrace.Exit(lnRetVal);
            RETURN lnRetVal;
         END IF;
      END IF;

      iapiGeneral.LogInfo(psSource, csMethod, 'Getting data for level <' || lsLevel || '>');
      lnRetVal :=
         aapiSpectracBom.ExtractRow(lsLevel,
                                    asFunction,
                                    asPartNo,
                                    anRevision,
                                    asDescription,
                                    asStatus,
                                    anQuantity,
                                    asPartType,
                                    anFunctionOverride);

      IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
      THEN
         iapiGeneral.LogError(psSource, csMethod, 'Extract failed');
         ROLLBACK;
         
         aapiTrace.Exit(lnRetVal);
         RETURN lnRetVal;
      ELSE
         iapiGeneral.LogInfo(psSource, csMethod, 'Extract completed');
         COMMIT;
         
         aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
         RETURN iapiConstantDbError.DBERR_SUCCESS;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         iapiGeneral.LogError(psSource, csMethod, SQLERRM);
         
         aapiTrace.Error(SQLERRM);
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapiConstantDbError.DBERR_GENFAIL;
   END GetFuncBOMRow;

   FUNCTION ReplaceComponent(
      asLevel     IN   iapiType.String_Type,
      asNewCode   IN   iapiType.PartNo_Type,
      asPlant     IN   iapiType.PlantNo_Type,
      asFunction  IN   iapiType.String_Type DEFAULT NULL)
      RETURN iapiType.ErrorNum_Type
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      csMethod   CONSTANT iapiType.Method_Type   := 'ReplaceComponent';
      lnRetVal            iapiType.ErrorNum_Type;
      lsLevel             iapiType.String_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asLevel', asLevel);
      aapiTrace.Param('asNewCode', asNewCode);
      aapiTrace.Param('asPlant', asPlant);
      aapiTrace.Param('asFunction', asFunction);

      iapiGeneral.LogInfo(psSource,
                          csMethod,
                          'Called for <' || asLevel || '><' || asNewCode || '><' || asPlant || '>');

      IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
      THEN
         iapiGeneral.LogInfo(psSource, csMethod, 'Initializing session');

         IF LOGON != iapiConstantDbError.DBERR_SUCCESS
         THEN
            iapiGeneral.LogError(psSource, csMethod, 'Session could not be initialized');
            ROLLBACK;
            
            aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
            RETURN iapiConstantDbError.DBERR_GENFAIL;
         END IF;
      END IF;

      iapiGeneral.LogInfo(psSource, csMethod, 'Session correctly initialized, starting replace');
      lsLevel := REPLACE(asLevel, ',', '.');
      iapiGeneral.LogInfo(psSource, csMethod, 'lsLevel: <' || lsLevel || '>');
      lnRetVal := aapiSpectracBom.ReplaceComponent(lsLevel, asNewCode, asPlant, asFunction);

      IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
      THEN
         iapiGeneral.LogError(psSource, csMethod, 'Replace failed');
         ROLLBACK;
         
         aapiTrace.Exit(lnRetVal);
         RETURN lnRetVal;
      ELSE
         iapiGeneral.LogInfo(psSource, csMethod, 'Replace completed');
         COMMIT;
         
         aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
         RETURN iapiConstantDbError.DBERR_SUCCESS;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         iapiGeneral.LogError(psSource, csMethod, SQLERRM);
         
         aapiTrace.Error(SQLERRM);
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapiConstantDbError.DBERR_GENFAIL;
   END ReplaceComponent;

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
      PRAGMA AUTONOMOUS_TRANSACTION;
      csMethod   CONSTANT iapiType.Method_Type   := 'UpdateFuncBOMRow';
      lnRetVal            iapiType.ErrorNum_Type;
      lsLevel             iapiType.String_Type;
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

      IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
      THEN
         iapiGeneral.LogInfo(psSource, csMethod, 'Initializing session');

         IF LOGON != iapiConstantDbError.DBERR_SUCCESS
         THEN
            iapiGeneral.LogError(psSource, csMethod, 'Session could not be initialized');
            ROLLBACK;
            
            aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
            RETURN iapiConstantDbError.DBERR_GENFAIL;
         END IF;
      END IF;

      iapiGeneral.LogInfo(psSource, csMethod, 'Session correctly initialized, starting update');
      lsLevel := REPLACE(asLevel, ',', '.');
      iapiGeneral.LogInfo(psSource, csMethod, 'lsLevel: <' || lsLevel || '>');
      lnRetVal :=
         aapiSpectracBom.UpdateFuncBomRow(lsLevel,
                                          asAction,
                                          asPartNo,
                                          anRevision,
                                          asDescription,
                                          asFrameNo,
                                          asPlant,
                                          anQuantity,
                                          anFunctionOverride);

      IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
      THEN
         iapiGeneral.LogError(psSource, csMethod, 'Update failed');
         ROLLBACK;
         
         aapiTrace.Exit(lnRetVal);
         RETURN lnRetVal;
      ELSE
         iapiGeneral.LogInfo(psSource, csMethod, 'Update completed');
         COMMIT;
         
         aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
         RETURN iapiConstantDbError.DBERR_SUCCESS;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         iapiGeneral.LogError(psSource, csMethod, SQLERRM);
         
         aapiTrace.Error(SQLERRM);
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapiConstantDbError.DBERR_GENFAIL;
   END UpdateFuncBOMRow;

   FUNCTION SaveFuncBom
      RETURN iapiType.ErrorNum_Type
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      csMethod   CONSTANT iapiType.Method_Type   := 'SaveFuncBom';
      lnRetVal            iapiType.ErrorNum_Type;
   BEGIN
      aapiTrace.Enter();
      iapiGeneral.LogInfo(psSource, csMethod, 'Called');

      IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
      THEN
         iapiGeneral.LogInfo(psSource, csMethod, 'Initializing session');

         IF LOGON != iapiConstantDbError.DBERR_SUCCESS
         THEN
            iapiGeneral.LogError(psSource, csMethod, 'Session could not be initialized');
            ROLLBACK;
            
            aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
            RETURN iapiConstantDbError.DBERR_GENFAIL;
         END IF;
      END IF;

      iapiGeneral.LogInfo(psSource, csMethod, 'Session correctly initialized, starting save');
      lnRetVal := aapiSpectracBom.SaveFuncBom;

      IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
      THEN
         iapiGeneral.LogError(psSource, csMethod, 'Save failed');
         ROLLBACK;
         
         aapiTrace.Exit(lnRetVal);
         RETURN lnRetVal;
      ELSE
         iapiGeneral.LogInfo(psSource, csMethod, 'Save completed');
         COMMIT;
         
         aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
         RETURN iapiConstantDbError.DBERR_SUCCESS;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         iapiGeneral.LogError(psSource, csMethod, SQLERRM);
         
         aapiTrace.Error(SQLERRM);
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapiConstantDbError.DBERR_GENFAIL;
   END SaveFuncBom;

   FUNCTION ConvertFieldNameToFieldType(asField IN iapiType.Description_Type)
      RETURN iapiType.Id_Type
   IS
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asField', asField);
      
      RETURN CASE UPPER(asField)
         WHEN 'NUM_1'
            THEN aapiConstant.FIELDTYPE_NUMERIC1
         WHEN 'NUM_2'
            THEN aapiConstant.FIELDTYPE_NUMERIC2
         WHEN 'NUM_3'
            THEN aapiConstant.FIELDTYPE_NUMERIC3
         WHEN 'NUM_4'
            THEN aapiConstant.FIELDTYPE_NUMERIC4
         WHEN 'NUM_5'
            THEN aapiConstant.FIELDTYPE_NUMERIC5
         WHEN 'NUM_6'
            THEN aapiConstant.FIELDTYPE_NUMERIC6
         WHEN 'NUM_7'
            THEN aapiConstant.FIELDTYPE_NUMERIC7
         WHEN 'NUM_8'
            THEN aapiConstant.FIELDTYPE_NUMERIC8
         WHEN 'NUM_9'
            THEN aapiConstant.FIELDTYPE_NUMERIC9
         WHEN 'NUM_10'
            THEN aapiConstant.FIELDTYPE_NUMERIC10
         WHEN 'CHAR_1'
            THEN aapiConstant.FIELDTYPE_CHARACTER1
         WHEN 'CHAR_2'
            THEN aapiConstant.FIELDTYPE_CHARACTER2
         WHEN 'CHAR_3'
            THEN aapiConstant.FIELDTYPE_CHARACTER3
         WHEN 'CHAR_4'
            THEN aapiConstant.FIELDTYPE_CHARACTER4
         WHEN 'CHAR_5'
            THEN aapiConstant.FIELDTYPE_CHARACTER5
         WHEN 'CHAR_6'
            THEN aapiConstant.FIELDTYPE_CHARACTER6
         WHEN 'BOOLEAN_1'
            THEN aapiConstant.FIELDTYPE_BOOLEAN1
         WHEN 'BOOLEAN_2'
            THEN aapiConstant.FIELDTYPE_BOOLEAN2
         WHEN 'BOOLEAN_3'
            THEN aapiConstant.FIELDTYPE_BOOLEAN3
         WHEN 'BOOLEAN_4'
            THEN aapiConstant.FIELDTYPE_BOOLEAN4
         WHEN 'DATE_1'
            THEN aapiConstant.FIELDTYPE_DATE1
         WHEN 'DATE_2'
            THEN aapiConstant.FIELDTYPE_DATE2
         WHEN 'UOM'
            THEN aapiConstant.FIELDTYPE_UOM
         WHEN 'ATTRIBUTE'
            THEN aapiConstant.FIELDTYPE_ATTRIBUTE
         WHEN 'TEST_METHOD'
            THEN aapiConstant.FIELDTYPE_TESTMETHOD
         WHEN 'ASSOCIATION'
            THEN aapiConstant.FIELDTYPE_ASSOCIATION1
         WHEN 'PROPERTY'
            THEN aapiConstant.FIELDTYPE_PROPERTY
         WHEN 'AS_2'
            THEN aapiConstant.FIELDTYPE_ASSOCIATION2
         WHEN 'AS_3'
            THEN aapiConstant.FIELDTYPE_ASSOCIATION3
         WHEN 'TM_DETAIL_1'
            THEN aapiConstant.FIELDTYPE_TESTDETAIL1
         WHEN 'TM_DETAIL_2'
            THEN aapiConstant.FIELDTYPE_TESTDETAIL2
         WHEN 'TM_DETAIL_3'
            THEN aapiConstant.FIELDTYPE_TESTDETAIL3
         WHEN 'TM_DETAIL_4'
            THEN aapiConstant.FIELDTYPE_TESTDETAIL4
         WHEN 'NOTE'
            THEN aapiConstant.FIELDTYPE_NOTE
         WHEN 'TM_DETAILS'
            THEN aapiConstant.FIELDTYPE_TMDETAILS
      END;
      
      aapiTrace.Exit();
   END ConvertFieldNameToFieldType;

   FUNCTION GetValue(
      asLevel           IN       iapiType.String_Type,
      asSpecHeader      IN       iapiType.Description_Type,
      asKeyword         IN       iapiType.Description_Type,
      anAttachedSpecs   IN       iapiType.Boolean_Type,
      asSection         IN       iapiType.Description_Type,
      asSubSection      IN       iapiType.Description_Type,
      asPropertyGroup   IN       iapiType.Description_Type,
      asProperty        IN       iapiType.Description_Type,
      asField           IN       iapiType.Description_Type,
      asValue           OUT      iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      csMethod   CONSTANT iapiType.Method_Type   := 'GetValue';
      lnRetVal            iapiType.ErrorNum_Type;
      lnFieldType         iapiType.Id_Type;
      lsLevel             iapiType.String_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asLevel', asLevel);
      aapiTrace.Param('asSpecHeader', asSpecHeader);
      aapiTrace.Param('anAttachedSpecs', anAttachedSpecs);
      aapiTrace.Param('asSection', asSection);
      aapiTrace.Param('asSubSection', asSubSection);
      aapiTrace.Param('asPropertyGroup', asPropertyGroup);
      aapiTrace.Param('asPropertyId', asProperty);
      aapiTrace.Param('asField', asField);

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
                          || asField
                          || '>');

      IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
      THEN
         iapiGeneral.LogInfo(psSource, csMethod, 'Initializing session');

         IF LOGON != iapiConstantDbError.DBERR_SUCCESS
         THEN
            iapiGeneral.LogError(psSource, csMethod, 'Session could not be initialized');
            ROLLBACK;
            
            aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
            RETURN iapiConstantDbError.DBERR_GENFAIL;
         END IF;
      END IF;

      iapiGeneral.LogInfo(psSource, csMethod, 'Session correctly initialized, starting retrieve');
      lsLevel := REPLACE(asLevel, ',', '.');
      iapiGeneral.LogInfo(psSource, csMethod, 'lsLevel: <' || lsLevel || '>');
      iapiGeneral.LogInfo(psSource, csMethod, 'Converting field name to field type');
      lnFieldType := ConvertFieldNameToFieldType(asField);
      iapiGeneral.LogInfo(psSource, csMethod, 'lnFieldType: <' || lnFieldType || '>');
      iapiGeneral.LogInfo(psSource, csMethod, 'Extracting data');
      lnRetVal :=
         aapiSpectracData.GetValue(lsLevel,
                                   asSpecHeader,
                                   asKeyword,
                                   anAttachedSpecs,
                                   asSection,
                                   asSubSection,
                                   asPropertyGroup,
                                   asProperty,
                                   lnFieldType,
                                   asValue);

      IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
      THEN
         iapiGeneral.LogError(psSource, csMethod, 'Data retrieval failed');
         ROLLBACK;
         
         aapiTrace.Exit(lnRetVal);
         RETURN lnRetVal;
      ELSE
         iapiGeneral.LogInfo(psSource, csMethod, 'Data retrieval completed');
         COMMIT;
         
         aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
         RETURN iapiConstantDbError.DBERR_SUCCESS;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         iapiGeneral.LogError(psSource, csMethod, SQLERRM);
         
         aapiTrace.Error(SQLERRM);
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapiConstantDbError.DBERR_GENFAIL;
   END GetValue;

   FUNCTION ClearDataConfiguration
      RETURN iapiType.ErrorNum_Type
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      csMethod   CONSTANT iapiType.Method_Type   := 'ClearDataConfiguration';
      lnRetVal            iapiType.ErrorNum_Type;
   BEGIN
      aapiTrace.Enter();
   
      iapiGeneral.LogInfo(psSource, csMethod, 'Called');

      IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
      THEN
         iapiGeneral.LogInfo(psSource, csMethod, 'Initializing session');

         IF LOGON != iapiConstantDbError.DBERR_SUCCESS
         THEN
            iapiGeneral.LogError(psSource, csMethod, 'Session could not be initialized');
            ROLLBACK;
            
            aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
            RETURN iapiConstantDbError.DBERR_GENFAIL;
         END IF;
      END IF;

      iapiGeneral.LogInfo(psSource,
                          csMethod,
                          'Session correctly initialized, starting clear operation');
      lnRetVal := aapiSpectracData.ClearDataConfiguration;

      IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
      THEN
         iapiGeneral.LogError(psSource, csMethod, 'Clear failed');
         ROLLBACK;
         
         aapiTrace.Exit(lnRetVal);
         RETURN lnRetVal;
      ELSE
         iapiGeneral.LogInfo(psSource, csMethod, 'Clear completed');
         COMMIT;
         
         aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
         RETURN iapiConstantDbError.DBERR_SUCCESS;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         iapiGeneral.LogError(psSource, csMethod, SQLERRM);
         
         aapiTrace.Error(SQLERRM);
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapiConstantDbError.DBERR_GENFAIL;
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
      asField           IN   iapiType.Description_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      csMethod   CONSTANT iapiType.Method_Type   := 'AddDataConfiguration';
      lnRetVal            iapiType.ErrorNum_Type;
      lnFieldType         iapiType.Id_Type;
      lsLevel             iapiType.String_Type;
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
                          || '>');

      IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
      THEN
         iapiGeneral.LogInfo(psSource, csMethod, 'Initializing session');

         IF LOGON != iapiConstantDbError.DBERR_SUCCESS
         THEN
            iapiGeneral.LogError(psSource, csMethod, 'Session could not be initialized');
            ROLLBACK;
            
            aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
            RETURN iapiConstantDbError.DBERR_GENFAIL;
         END IF;
      END IF;

      iapiGeneral.LogInfo(psSource, csMethod, 'Session correctly initialized, starting update');
      lsLevel := REPLACE(asLevel, ',', '.');
      iapiGeneral.LogInfo(psSource, csMethod, 'lsLevel: <' || lsLevel || '>');
      iapiGeneral.LogInfo(psSource, csMethod, 'Converting field name to field type');
      lnFieldType := ConvertFieldNameToFieldType(asField);
      iapiGeneral.LogInfo(psSource, csMethod, 'lnFieldType: <' || lnFieldType || '>');
      iapiGeneral.LogInfo(psSource, csMethod, 'Updating configuration');
      lnRetVal :=
         aapiSpectracData.AddDataConfiguration(anSequenceNo,
                                               lsLevel,
                                               asSpecHeader,
                                               asKeyword,
                                               anAttachedSpecs,
                                               asSection,
                                               asSubSection,
                                               asPropertyGroup,
                                               asProperty,
                                               asField,
                                               lnFieldType);

      IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
      THEN
         iapiGeneral.LogError(psSource, csMethod, 'Configuration update failed');
         ROLLBACK;
         
         aapiTrace.Exit(lnRetVal);
         RETURN lnRetVal;
      ELSE
         iapiGeneral.LogInfo(psSource, csMethod, 'Configuration update completed');
         COMMIT;
         
         aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
         RETURN iapiConstantDbError.DBERR_SUCCESS;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         iapiGeneral.LogError(psSource, csMethod, SQLERRM);
         
         aapiTrace.Error(SQLERRM);
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapiConstantDbError.DBERR_GENFAIL;
   END AddDataConfiguration;

   FUNCTION BulkExtractData
      RETURN iapiType.ErrorNum_Type
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      csMethod   CONSTANT iapiType.Method_Type   := 'BulkExtractData';
      lnRetVal            iapiType.ErrorNum_Type;
   BEGIN
      aapiTrace.Enter();
    
      iapiGeneral.LogInfo(psSource, csMethod, 'Called');

      IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
      THEN
         iapiGeneral.LogInfo(psSource, csMethod, 'Initializing session');

         IF LOGON != iapiConstantDbError.DBERR_SUCCESS
         THEN
            iapiGeneral.LogError(psSource, csMethod, 'Session could not be initialized');
            ROLLBACK;
            
            aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
            RETURN iapiConstantDbError.DBERR_GENFAIL;
         END IF;
      END IF;

      iapiGeneral.LogInfo(psSource, csMethod, 'Session correctly initialized, starting extraction');
      lnRetVal := aapiSpectracData.BulkExtractData;

      IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
      THEN
         iapiGeneral.LogError(psSource, csMethod, 'Extraction failed');
         ROLLBACK;
         
         aapiTrace.Exit(lnRetVal);
         RETURN lnRetVal;
      ELSE
         iapiGeneral.LogInfo(psSource, csMethod, 'Extraction completed');
         COMMIT;
         
         aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
         RETURN iapiConstantDbError.DBERR_SUCCESS;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         iapiGeneral.LogError(psSource, csMethod, SQLERRM);
         
         aapiTrace.Error(SQLERRM);
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapiConstantDbError.DBERR_GENFAIL;
   END BulkExtractData;

   FUNCTION SetValue(
      asLevel           IN   iapiType.String_Type,
      asKeyword         IN   iapiType.Description_Type,
      anAttachedSpecs   IN   iapiType.Boolean_Type,
      asSection         IN   iapiType.Description_Type,
      asSubSection      IN   iapiType.Description_Type,
      asPropertyGroup   IN   iapiType.Description_Type,
      asProperty        IN   iapiType.Description_Type,
      asField           IN   iapiType.Description_Type,
      asValue           IN   iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      csMethod   CONSTANT iapiType.Method_Type   := 'SetValue';
      lnRetVal            iapiType.ErrorNum_Type;
      lnFieldType         iapiType.Id_Type;
      lsLevel             iapiType.String_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asLevel', asLevel);
      aapiTrace.Param('asKeyword', asKeyword);
      aapiTrace.Param('anAttachedSpecs', anAttachedSpecs);
      aapiTrace.Param('asSection', asSection);
      aapiTrace.Param('asSubSection', asSubSection);
      aapiTrace.Param('asPropertyGroup', asPropertyGroup);
      aapiTrace.Param('asProperty', asProperty);
      aapiTrace.Param('asField', asField);
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
                          || asField
                          || '><'
                          || asValue
                          || '>');

      IF iapiGeneral.SESSION.ApplicationUser.UserId IS NULL
      THEN
         iapiGeneral.LogInfo(psSource, csMethod, 'Initializing session');

         IF LOGON != iapiConstantDbError.DBERR_SUCCESS
         THEN
            iapiGeneral.LogError(psSource, csMethod, 'Session could not be initialized');
            ROLLBACK;
            
            aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
            RETURN iapiConstantDbError.DBERR_GENFAIL;
         END IF;
      END IF;

      iapiGeneral.LogInfo(psSource, csMethod, 'Session correctly initialized, starting replace');
      lsLevel := REPLACE(asLevel, ',', '.');
      iapiGeneral.LogInfo(psSource, csMethod, 'lsLevel: <' || lsLevel || '>');
      iapiGeneral.LogInfo(psSource, csMethod, 'Converting field name to field type');
      lnFieldType := ConvertFieldNameToFieldType(asField);
      iapiGeneral.LogInfo(psSource, csMethod, 'lnFieldType: <' || lnFieldType || '>');
      iapiGeneral.LogInfo(psSource, csMethod, 'Saving data');
      lnRetVal :=
         aapiSpectracData.SetValue(lsLevel,
                                   asKeyword,
                                   anAttachedSpecs,
                                   asSection,
                                   asSubSection,
                                   asPropertyGroup,
                                   asProperty,
                                   lnFieldType,
                                   asValue);

      IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
      THEN
         iapiGeneral.LogError(psSource, csMethod, 'Data save failed for property "' || asProperty || '" in property group "' || asPropertyGroup || '"');
         ROLLBACK;
         
         aapiTrace.Exit(lnRetVal);
         RETURN lnRetVal;
      ELSE
         iapiGeneral.LogInfo(psSource, csMethod, 'Data save completed');
         COMMIT;
         
         aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
         RETURN iapiConstantDbError.DBERR_SUCCESS;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         iapiGeneral.LogError(psSource, csMethod, SQLERRM);
         
         aapiTrace.Error(SQLERRM);
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapiConstantDbError.DBERR_GENFAIL;
   END SetValue;

   /*
   // Returns the applic of current session
   //
   // Returns
   //   - Applic:
   */
   FUNCTION GetApplic
      RETURN VARCHAR2 IS
      csMethod   CONSTANT iapiType.Method_Type   := 'GetApplic';
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Exit(psApplic);
      
      RETURN psApplic;
   EXCEPTION
      WHEN OTHERS
      THEN
         iapiGeneral.LogError(psSource, csMethod, SQLERRM);
         
         aapiTrace.Error(SQLERRM);
         aapiTrace.Exit();
         RETURN NULL;
   END GetApplic;

   FUNCTION SetApplic(asApplic IN VARCHAR2 := 'Spectrac')
      RETURN iapiType.ErrorNum_Type IS
      csMethod   CONSTANT iapiType.Method_Type   := 'SetApplic';
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asApplic', asApplic);

       psApplic := asApplic;
       iapiGeneral.LogInfo(psSource, csMethod, 'psApplic := ''' || psApplic || '''');
       
       aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
       RETURN iapiConstantDbError.DBERR_SUCCESS;

   EXCEPTION
      WHEN OTHERS
      THEN
         iapiGeneral.LogError(psSource, csMethod, SQLERRM);
         aapiTrace.Error(SQLERRM);
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapiConstantDbError.DBERR_GENFAIL;
   END SetApplic;

     /*
   // Forces the bulkextract to be updated for all users
   //
   // Returns
   //   - DBERR_SUCCESS: Normal, successful completion
   //   - DBERR_GENFAIL: Operation could not be completed
   */
/*
   // Forces the bulkextract to be updated for all users
   //
   // Returns
   //   - DBERR_SUCCESS: Normal, successful completion
   //   - DBERR_GENFAIL: Operation could not be completed
   */
    FUNCTION UpdateBulk(asApplic IN VARCHAR2)
    RETURN iapiType.ErrorNum_Type IS
           csMethod   CONSTANT iapiType.Method_Type   := 'UpdateBulk';

    CURSOR lvq_userapp IS
    SELECT DISTINCT user_id, applic
      FROM atfuncbomdata
     WHERE user_id != USER;

    BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asApplic', asApplic);
    
      FOR lvr_userapp IN lvq_userapp LOOP
          DELETE
            FROM atfuncbomdata
           WHERE user_id = lvr_userapp.user_id
             AND applic = asApplic;
          INSERT
            INTO atfuncbomdata
          SELECT lvr_userapp.user_id,
                 SEQUENCE_NO, FUNC_LEVEL, SPEC_HEADER, KEYWORD, KEYWORD_ID, ATTACHED_SPECS, SECTION, SECTION_ID,
                 SUB_SECTION, SUB_SECTION_ID, PROPERTY_GROUP, PROPERTY_GROUP_ID, PROPERTY, PROPERTY_ID, FIELD, FIELD_TYPE, VALUE,
                 asApplic
            FROM ATFUNCBOMDATA
           WHERE user_id = USER
             AND applic = asApplic;
      END LOOP;

        aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
         RETURN iapiConstantDbError.DBERR_SUCCESS;

       EXCEPTION
          WHEN OTHERS
          THEN
             iapiGeneral.LogError(psSource, csMethod, SQLERRM);
             
             aapiTrace.Error(SQLERRM);
             aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
             RETURN iapiConstantDbError.DBERR_GENFAIL;

    END UpdateBulk;

    /*
       // Removes the bulkextract for given applic
       //
       // Returns
       //   - DBERR_SUCCESS: Normal, successful completion
       //   - DBERR_GENFAIL: Operation could not be completed
       */
    FUNCTION DeleteBulk(asApplic IN VARCHAR2)
    RETURN iapiType.ErrorNum_Type IS
           csMethod   CONSTANT iapiType.Method_Type   := 'DeleteBulk';

    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('asApplic', asApplic);
        
        DELETE
          FROM atfuncbomdata
         WHERE applic = asApplic;

        aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
         RETURN iapiConstantDbError.DBERR_SUCCESS;

       EXCEPTION
          WHEN OTHERS
          THEN
             iapiGeneral.LogError(psSource, csMethod, SQLERRM);
             aapiTrace.Error(SQLERRM);
             aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
             RETURN iapiConstantDbError.DBERR_GENFAIL;

    END DeleteBulk;


   FUNCTION GetBomPackagingValue(
      asPartNo    IN  iapiType.PartNo_Type,
      anRevision  IN  iapiType.Revision_Type,
      asBomPartNo IN  iapiType.PartNo_Type,
      asValue     OUT iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod CONSTANT iapiType.Method_Type := 'GetBomPackagingValue';
   BEGIN
      SELECT char_3
      INTO asValue
      FROM bom_item bi, bom_header bh
      WHERE bi.part_no = bh.part_no
      AND bi.revision = bh.revision
      AND bi.plant = bh.plant
      AND bi.alternative = bh.alternative
      AND bh.preferred = 1
      AND bh.part_no = asPartNo
      AND bh.revision = anRevision
      AND bi.component_part = asBomPartNo;
      
      RETURN iapiConstantDbError.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         iapiGeneral.LogError(psSource, csMethod, SQLERRM);
         RETURN iapiConstantDbError.DBERR_GENFAIL;
   END;
      
   FUNCTION SetBomPackagingValue(
      asPartNo    IN iapiType.PartNo_Type,
      anRevision  IN iapiType.Revision_Type,
      asBomPartNo IN iapiType.PartNo_Type,
      asValue     IN iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod CONSTANT iapiType.Method_Type := 'SetBomPackagingValue';
   BEGIN
      UPDATE bom_item
      SET char_3 = asValue
      WHERE (part_no, revision, plant, alternative) = (
          SELECT part_no, revision, plant, alternative
          FROM bom_header
          WHERE part_no = asPartNo
          AND revision = anRevision
          AND preferred = 1
      )
      AND component_part = asBomPartNo;
      
      RETURN iapiConstantDbError.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         iapiGeneral.LogError(psSource, csMethod, SQLERRM);
         RETURN iapiConstantDbError.DBERR_GENFAIL;
   END;

END aapiSpectrac;
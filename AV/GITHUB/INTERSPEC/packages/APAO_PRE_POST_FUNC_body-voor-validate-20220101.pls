CREATE OR REPLACE PACKAGE BODY APAO_PRE_POST_FUNC AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAO_PRE_POST_FUNC
-- ABSTRACT : This package containts the pre and post fuctions which can be
--            used whithin Simatic IT Interspec
--------------------------------------------------------------------------------
--   WRITER : Arie Frans Kok
--     DATE : $Date: 8/23/00 9:04a $
--   TARGET :
--  VERSION : 6.3.0.1.0   $Revision: 0 $
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 24/04/2008 | AF        | Created
-- 25/06/2008 | RS        | Added function CopyFrameData
-- 10/03/2011 | RS        | Upgrade V6.3
-- 23/01/2013 | RS        | Added SetPEDInSync
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
psSource CONSTANT iapiType.Source_Type := 'APAO_PRE_POST_FUNC';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions and/or procedures
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- PROCEDURE : SetMultiLanguage
--  ABSTRACT : This function will set the MultiLanguage for a specification
--             automatically
--------------------------------------------------------------------------------
--    WRITER : Arie Frans Kok
--  REVIEWER :
--      DATE : 24/04/2008
--    TARGET :
--   VERSION : 6.3.0.1.0
--------------------------------------------------------------------------------
--             Errorcode              | Description
--====================================|=========================================
--    ERRORS :                        |
--------------------------------------------------------------------------------
--   REMARKS : -
--------------------------------------------------------------------------------
--   CHANGES :
--
-- When       | Who       | What
--============|===========|=====================================================
-- 24/04/2008 | AF        | Created
-- 10/03/2011 | RS        | Upgrade V6.3
--------------------------------------------------------------------------------
PROCEDURE SetMultiLanguage IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
csMethod CONSTANT iapiType.Method_Type := 'SetMultiLanguage';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lnRetVal            iapiType.ErrorNum_Type;
asPreferenceValue   iapiType.PreferenceValue_Type;
--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------

BEGIN
   -----------------------------------------------------------------------------
   -- Enable database logging when configured
   -----------------------------------------------------------------------------
   lnRetVal := iapiUserPreferences.GETUSERPREFERENCE('General', 'DatabaseLogging', asPreferenceValue);
   IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS AND asPreferenceValue = '1' 
    THEN
     iapiGeneral.EnableLogging;
   END IF;
            
   iapiGeneral.LogInfo(psSource, csMethod, 'Start changing MultiLanguage Setting');

   -----------------------------------------------------------------------------
   -- Change the checkbox for MultiLanguage (always on!) when creating a new
   -- specification
   -----------------------------------------------------------------------------
   iapiSpecification.gtCreateSpec(0).MultiLang := 1;

   -----------------------------------------------------------------------------
   -- Change the checkbox for MultiLanguage (always on!) when copying a
   -- specification
   -----------------------------------------------------------------------------
   iapiSpecification.gtCopySpec(0).MultiLanguage := 1;

   iapiGeneral.LogInfo(psSource, csMethod, 'End changing MultiLanguage Setting');

EXCEPTION
   WHEN OTHERS THEN
      iapiGeneral.LogError(psSource, csMethod, SQLERRM);
END SetMultiLanguage;

--------------------------------------------------------------------------------
-- FUNCTION : LocalizeFrameData
-- ABSTRACT : This function will localize plant-specific Access_Group and
--            Workflow_Group from used frame to current specification
--------------------------------------------------------------------------------
FUNCTION LocalizeFrameData(
    avs_part_no       IN iapiType.PartNo_Type,
    avn_accessgroup   IN OUT iapiType.ID_Type,
    avn_workflowgroup IN OUT iapiType.ID_Type
) RETURN iapiType.ErrorNum_Type AS
    lvs_method        iapiType.String_Type := 'LocalizeFrameData';
    lvs_accessgroup   iapiType.ShortDescription_Type := NULL;
    lvs_workflowgroup iapiType.ShortDescription_Type := NULL;
    lvs_newdesc       iapiType.ShortDescription_Type;
    lvs_localplant    iapiType.Plant_Type := '';
    lvs_replpattern   iapiType.String_Type := '([^_]+)$'; --Capture last part after [underscore]
    
    FUNCTION HasPlantSuffix(
        lvs_shortdesc IN iapiType.ShortDescription_Type
    ) RETURN boolean
    AS
        lvs_pattern iapiType.String_Type := '^A_.+_([^_]+)|.+$'; --"A_" followed by text, followed by [underscore], capturing last part after underscore
        lvn_count   NUMBER := 0;
    BEGIN
        IF lvs_shortdesc IS NOT NULL THEN
            SELECT COUNT(*)
            INTO lvn_count
            FROM plant
            WHERE plant != '0'
            AND plant = REGEXP_REPLACE(lvs_shortdesc, lvs_pattern, '\1');
        END IF;
        
        RETURN lvn_count > 0;
    END;

BEGIN
    IF avn_accessgroup IS NOT NULL THEN
        BEGIN
            SELECT sort_desc
            INTO lvs_accessgroup
            FROM access_group
            WHERE access_group = avn_accessgroup;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN iapiGeneral.SetErrorText(iapiConstantDbError.DBERR_ACCESSGROUPNOTEXIST, avn_accessgroup);
        END;
    END IF;

    IF avn_workflowgroup IS NOT NULL THEN
        BEGIN
            SELECT sort_desc
            INTO lvs_workflowgroup
            FROM workflow_group
            WHERE workflow_group_id = avn_workflowgroup;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN iapiGeneral.SetErrorText(iapiConstantDbError.DBERR_WORKFLOWGROUPNOTEXIST, avn_workflowgroup);
        END;
    END IF;

    IF HasPlantSuffix(lvs_accessgroup) OR HasPlantSuffix(lvs_workflowgroup) THEN
        BEGIN
            /*
            SELECT plant
            INTO lvs_localplant
            FROM part_plant
            WHERE part_no = avs_part_no;
            */

            SELECT pl_id
            INTO lvs_localplant
            FROM itplkw
            WHERE kw_id = 700830 --PartNo Prefix
            AND REGEXP_LIKE(avs_part_no, '^X?' || kw_value || '._.+$')
            AND NOT REGEXP_LIKE(avs_part_no, '^GR_.+$'); --Exception for Raw Materials (GR_XXX)
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            --RETURN iapiGeneral.SetErrorText(iapiConstantDbError.DBERR_NOPARTPLANTFORBOMITEM, avs_part_no);
            NULL; -- Don't perform anything if there are no matches. Keep the default groups.
        WHEN TOO_MANY_ROWS THEN
            RETURN iapiGeneral.SetErrorText(iapiConstantDbError.DBERR_TOOMANYROWSTREETYPE, 'Part Plant relationships for the item', avs_part_no);
        END;
      
        IF lvs_localplant IS NOT NULL THEN
            IF HasPlantSuffix(lvs_accessgroup) THEN
                lvs_newdesc := REGEXP_REPLACE(lvs_accessgroup, lvs_replpattern, lvs_localplant);
                BEGIN
                    SELECT access_group
                    INTO avn_accessgroup
                    FROM access_group
                    WHERE sort_desc = lvs_newdesc;
                EXCEPTION WHEN NO_DATA_FOUND THEN
                    RETURN iapiGeneral.SetErrorText(iapiConstantDbError.DBERR_ACCESSGROUPNOTEXIST, lvs_newdesc);
                END;            
            END IF;
    
            IF HasPlantSuffix(lvs_workflowgroup) THEN
                lvs_newdesc := REGEXP_REPLACE(lvs_workflowgroup, lvs_replpattern, lvs_localplant);
                BEGIN
                    SELECT workflow_group_id
                    INTO avn_workflowgroup
                    FROM workflow_group
                    WHERE sort_desc = lvs_newdesc;
                EXCEPTION WHEN NO_DATA_FOUND THEN
                    RETURN iapiGeneral.SetErrorText(iapiConstantDbError.DBERR_WORKFLOWGROUPNOTEXIST, lvs_newdesc);
                END;            
            END IF;
        END IF;
    END IF;

    RETURN iapiConstantDbError.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
     iapiGeneral.LogError(psSource, lvs_method, SQLERRM);
     RETURN iapiGeneral.SetErrorText(iapiConstantDbError.DBERR_GENFAIL);
END;

--------------------------------------------------------------------------------
-- PROCEDURE : CopyFrameData
--  ABSTRACT : This function will copy the frame data for Access_Group, 
--             Workflow_Group and Specification_type from used frame to current
--             specification
--------------------------------------------------------------------------------
--    WRITER : Arie Frans Kok
--  REVIEWER :
--      DATE : 15/05/2008
--    TARGET :
--   VERSION : 6.3.0.1.0
--------------------------------------------------------------------------------
--            Errorcode                | Description
--=====================================|========================================
--    ERRORS :                         |
--------------------------------------------------------------------------------
--   REMARKS : -
--------------------------------------------------------------------------------
--   CHANGES :
--
--  When       | Who       | What
--=============|===========|====================================================
-- 15/05/2008  | AF        | Created
-- 25/06/2008  | RS        | Added update part table
-- 10/03/2011  | RS        | Upgrade V6.3
--------------------------------------------------------------------------------
PROCEDURE CopyFrameData (avs_frame_id  IN VARCHAR2,
                         avs_frame_rev IN VARCHAR2,
                         avb_create    IN BOOLEAN) IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
csMethod CONSTANT iapiType.Method_Type := 'CopyFrameData';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lnRetVal            iapiType.ErrorNum_Type;

lvn_accessgroup     NUMBER;
lvn_workflowgroup   NUMBER;
lvn_class3id        NUMBER;

asPreferenceValue   iapiType.PreferenceValue_Type;
--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------

BEGIN
   -----------------------------------------------------------------------------
   -- Enable database logging when configured
   -----------------------------------------------------------------------------
   lnRetVal := iapiUserPreferences.GETUSERPREFERENCE('General', 'DatabaseLogging', asPreferenceValue);
   IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS AND asPreferenceValue = '1' 
    THEN
     iapiGeneral.EnableLogging;
   END IF;
   
   iapiGeneral.LogInfo(psSource, csMethod, 'Start getting Frame Data');
 
   -----------------------------------------------------------------------------
   -- Getting the stored frame data
   -----------------------------------------------------------------------------
   lnRetVal := APAO_VALIDATE.GetFrameData(avs_frame_no     =>avs_frame_id,
                                          avn_revision     =>avs_frame_rev,
                                          avn_accessgroup  =>lvn_accessgroup,
                                          avn_workflowgroup=>lvn_workflowgroup,
                                          avn_class3id     =>lvn_class3id);
   
   iapiGeneral.LogInfo(psSource, csMethod, 'End getting Frame Data');
   
   IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS THEN
      IF avb_create THEN
          lnRetVal := LocalizeFrameData(iapiSpecification.gtCreateSpec(0).PartNo, lvn_accessgroup, lvn_workflowgroup);
      ELSE
          lnRetVal := LocalizeFrameData(iapiSpecification.gtCopySpec(0).PartNo, lvn_accessgroup, lvn_workflowgroup);
      END IF;

      IF (lnRetVal <> iapiConstantDbError.DBERR_SUCCESS) THEN
          iapiGeneral.LogError(psSource, csMethod, iapiGeneral.GetLastErrorText());
      END IF;
   END IF;

   -----------------------------------------------------------------------------
   -- Only continue when getting the frame data succeeded
   -----------------------------------------------------------------------------
   IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS THEN
      iapiGeneral.LogInfo(psSource, csMethod, 'Start changing the specification data');
      
      IF avb_create THEN
         -----------------------------------------------------------------------
         -- Change the data upon creation
         -----------------------------------------------------------------------
         iapiSpecification.gtCreateSpec(0).Class3Id        := lvn_class3id;
         iapiSpecification.gtCreateSpec(0).WorkflowGroupId := lvn_workflowgroup;
         iapiSpecification.gtCreateSpec(0).AccessGroup     := lvn_accessgroup;
      ELSE
         -----------------------------------------------------------------------
         -- Change the data upon copying
         -----------------------------------------------------------------------
         iapiSpecification.gtCopySpec(0).SpecTypeId        := lvn_class3id;
         iapiSpecification.gtCopySpec(0).WorkFlowGroupId   := lvn_workflowgroup;
         iapiSpecification.gtCopySpec(0).AccessGroupId     := lvn_accessgroup;
         -----------------------------------------------------------------------
         -- Update part table
         -----------------------------------------------------------------------
         UPDATE part
            SET part_type = lvn_class3id
          WHERE part_no  = iapiSpecification.gtCopySpec(0).PartNo;
         
      END IF;
         
      iapiGeneral.LogInfo(psSource, csMethod, 'End changing the specification data');
   END IF;

EXCEPTION
   WHEN OTHERS THEN
      iapiGeneral.LogError(psSource, csMethod, SQLERRM);
END CopyFrameData;

--------------------------------------------------------------------------------
-- PROCEDURE : CopyFrameData_copy
--  ABSTRACT : This function will copy the frame data for Access_Group, 
--             Workflow_Group and Specification_type from used frame to current
--             specification when copying a specification
--------------------------------------------------------------------------------
--    WRITER : Arie Frans Kok
--  REVIEWER :
--      DATE : 15/05/2008
--    TARGET :
--   VERSION : 6.3.0.1.0
--------------------------------------------------------------------------------
--            Errorcode                | Description
--=====================================|========================================
--    ERRORS :                         |
--------------------------------------------------------------------------------
--   REMARKS : -
--------------------------------------------------------------------------------
--   CHANGES :
--
--  When       | Who       | What
--=============|===========|====================================================
-- 15/05/2008  | AF        | Created
--------------------------------------------------------------------------------
PROCEDURE CopyFrameData_copy IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
csMethod CONSTANT iapiType.Method_Type := 'CopyFrameData_copy';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------
BEGIN
   CopyFrameData(avs_frame_id =>iapiSpecification.gtCopySpec(0).FrameId,
                 avs_frame_rev=>iapiSpecification.gtCopySpec(0).FrameRevision,
                 avb_create   =>FALSE);
END CopyFrameData_copy;

--------------------------------------------------------------------------------
-- PROCEDURE : CopyFrameData_create
--  ABSTRACT : This function will copy the frame data for Access_Group, 
--             Workflow_Group and Specification_type from used frame to current
--             specification when creating a new specification
--------------------------------------------------------------------------------
--    WRITER : Arie Frans Kok
--  REVIEWER :
--      DATE : 15/05/2008
--    TARGET :
--   VERSION : 6.3.0.1.0
--------------------------------------------------------------------------------
--            Errorcode                | Description
--=====================================|========================================
--    ERRORS :                         |
--------------------------------------------------------------------------------
--   REMARKS : -
--------------------------------------------------------------------------------
--   CHANGES :
--
--  When       | Who       | What
--=============|===========|====================================================
-- 15/05/2008  | AF        | Created
--------------------------------------------------------------------------------
PROCEDURE CopyFrameData_create IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
csMethod CONSTANT iapiType.Method_Type := 'CopyFrameData_create';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------
BEGIN
   CopyFrameData(avs_frame_id =>iapiSpecification.gtCreateSpec(0).FrameID,
                 avs_frame_rev=>iapiSpecification.gtCreateSpec(0).FrameRev,
                 avb_create   =>TRUE);
END CopyFrameData_create;

--------------------------------------------------------------------------------
-- PROCEDURE : CopyFrameKeywords
--  ABSTRACT : This function will copy the frame keywords Function and 
--             Spec. Function
--------------------------------------------------------------------------------
--    WRITER : Arie Frans Kok
--  REVIEWER :
--      DATE : 15/05/2008
--    TARGET :
--   VERSION : 6.3.0.1.0
--------------------------------------------------------------------------------
--            Errorcode                | Description
--=====================================|========================================
--    ERRORS :                         |
--------------------------------------------------------------------------------
--   REMARKS : -
--------------------------------------------------------------------------------
--   CHANGES :
--
--  When       | Who       | What
--=============|===========|====================================================
-- 15/05/2008  | AF        | Created
-- 10/03/2011  | RS        | Upgrade V6.3
--------------------------------------------------------------------------------
PROCEDURE CopyFrameKeywords (avs_part_no  IN VARCHAR2,
                             avs_frame_id IN VARCHAR2,
                             avb_create   IN BOOLEAN) IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
csMethod CONSTANT iapiType.Method_Type := 'CopyFrameKeywords';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lnRetVal            iapiType.ErrorNum_Type;
asPreferenceValue   iapiType.PreferenceValue_Type;
--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------

BEGIN
   -----------------------------------------------------------------------------
   -- Enable database logging when configured
   -----------------------------------------------------------------------------
   lnRetVal := iapiUserPreferences.GETUSERPREFERENCE('General', 'DatabaseLogging', asPreferenceValue);
   IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS AND asPreferenceValue = '1' 
    THEN
     iapiGeneral.EnableLogging;
   END IF;
   
   iapiGeneral.LogInfo(psSource, csMethod, 'Start copying the keywords');
   
   -----------------------------------------------------------------------------
   -- Copy the keywords
   -----------------------------------------------------------------------------
   lnRetVal := APAO_VALIDATE.CopyKeywords(avs_part_no =>avs_part_no,
                                          avs_frame_no=>avs_frame_id);
                                               
   iapiGeneral.LogInfo(psSource, csMethod, 'End copying the keywords');

EXCEPTION
   WHEN OTHERS THEN
      iapiGeneral.LogError(psSource, csMethod, SQLERRM);
END CopyFrameKeywords;

--------------------------------------------------------------------------------
-- PROCEDURE : CopyFrameKeywords_copy
--  ABSTRACT : This function will copy the frame keywords Function and 
--             Spec. Function when copying a specification
--------------------------------------------------------------------------------
--    WRITER : Arie Frans Kok
--  REVIEWER :
--      DATE : 15/05/2008
--    TARGET :
--   VERSION : 6.3.0.1.0
--------------------------------------------------------------------------------
--            Errorcode                | Description
--=====================================|========================================
--    ERRORS :                         |
--------------------------------------------------------------------------------
--   REMARKS : -
--------------------------------------------------------------------------------
--   CHANGES :
--
--  When       | Who       | What
--=============|===========|====================================================
-- 15/05/2008  | AF        | Created
--------------------------------------------------------------------------------
PROCEDURE CopyFrameKeywords_copy IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
csMethod CONSTANT iapiType.Method_Type := 'CopyFrameKeywords_copy';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lnRetVal            iapiType.ErrorNum_Type;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------
BEGIN
   CopyFrameKeywords (avs_part_no =>iapiSpecification.gtCopySpec(0).PartNo,
                      avs_frame_id=>iapiSpecification.gtCopySpec(0).FrameId,
                      avb_create  =>FALSE);
                      
EXCEPTION
   WHEN OTHERS THEN
      iapiGeneral.LogError(psSource, csMethod, SQLERRM);
END CopyFrameKeywords_copy;

--------------------------------------------------------------------------------
-- PROCEDURE : CopyFrameKeywords_create
--  ABSTRACT : This function will copy the frame keywords Function and 
--             Spec. Function when create a new specification
--------------------------------------------------------------------------------
--    WRITER : Arie Frans Kok
--  REVIEWER :
--      DATE : 15/05/2008
--    TARGET :
--   VERSION : 6.3.0.1.0
--------------------------------------------------------------------------------
--            Errorcode                | Description
--=====================================|========================================
--    ERRORS :                         |
--------------------------------------------------------------------------------
--   REMARKS : -
--------------------------------------------------------------------------------
--   CHANGES :
--
--  When       | Who       | What
--=============|===========|====================================================
-- 15/05/2008  | AF        | Created
--------------------------------------------------------------------------------
PROCEDURE CopyFrameKeywords_create IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
csMethod CONSTANT iapiType.Method_Type := 'CopyFrameKeywords_create';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lnRetVal            iapiType.ErrorNum_Type;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------
BEGIN
   CopyFrameKeywords (avs_part_no =>iapiSpecification.gtCreateSpec(0).PartNo,
                      avs_frame_id=>iapiSpecification.gtCreateSpec(0).FrameID,
                      avb_create  =>TRUE);

EXCEPTION
   WHEN OTHERS THEN
      iapiGeneral.LogError(psSource, csMethod, SQLERRM);
END CopyFrameKeywords_create;

--------------------------------------------------------------------------------
-- PROCEDURE : SetPEDInSync
--  ABSTRACT : This function will set the PED of the BoM-header in sync with the specification
--             automatically
--------------------------------------------------------------------------------
--    WRITER : Rody Sparenberg
--  REVIEWER :
--      DATE : 23/01/2013
--    TARGET :
--   VERSION : 6.4
--------------------------------------------------------------------------------
--            Errorcode                | Description
--=====================================|========================================
--    ERRORS :                         |
--------------------------------------------------------------------------------
--   REMARKS : -
--------------------------------------------------------------------------------
--   CHANGES :
--
--  When       | Who       | What
--=============|===========|====================================================
-- 23/01/2013  | RS        | Created
--------------------------------------------------------------------------------
PROCEDURE SetPEDInSync IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
csMethod CONSTANT iapiType.Method_Type := 'SetPEDInSync';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lnRetVal            iapiType.ErrorNum_Type;
asPreferenceValue   iapiType.PreferenceValue_Type;
--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------
lqInfo              iapiType.Ref_Type;
lqErrors            iapiType.Ref_Type;
lvd_ped             IAPITYPE.DATE_TYPE;
lvs_plant           IAPITYPE.PLANT_TYPE;

--------------------------------------------------------------------------------
-- Used as workaround for Oracle bug
-- gtBomHeaders(0).PartNo can not be used as argument directly to
-- SavePlannedEffectiveDate because it gets deleted inside the function.
-- It needs to be copied to a local variable which is then used as argument.
--------------------------------------------------------------------------------
lsBomHeaderPartNo   iapiType.PartNo_Type;
lnBomHeaderRevision iapiType.Revision_Type;
BEGIN
   -----------------------------------------------------------------------------
   -- Enable database logging when configured
   -----------------------------------------------------------------------------
   lnRetVal := iapiUserPreferences.GETUSERPREFERENCE('General', 'DatabaseLogging', asPreferenceValue);
   IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS AND asPreferenceValue = '1' 
    THEN
     iapiGeneral.EnableLogging;
   END IF;
            
   iapiGeneral.LogInfo(psSource, csMethod, 'Start changing PED in sync');
   
   iapiGeneral.LogInfo(psSource, csMethod, iapiSpecificationBom.gtBomHeaders(0).PartNo || '[' || iapiSpecificationBom.gtBomHeaders(0).Revision || ']');
   
   SELECT planned_effective_date
     INTO lvd_ped
     FROM specification_header
    WHERE part_no = iapiSpecificationBom.gtBomHeaders(0).PartNo
      AND revision = iapiSpecificationBom.gtBomHeaders(0).Revision;

   lsBomHeaderPartNo   := iapiSpecificationBom.gtBomHeaders(0).PartNo;
   lnBomHeaderRevision := iapiSpecificationBom.gtBomHeaders(0).Revision;
   lnRetVal := iapiSpecificationBom.SavePlannedEffectiveDate(lsBomHeaderPartNo,
                                                             lnBomHeaderRevision,
                                                             'ENS',
                                                             lvd_ped,
                                                             lqInfo,
                                                             lqErrors);

   
   iapiGeneral.LogInfo(psSource, csMethod, lnRetVal || ' for ' || iapiSpecificationBom.gtBomHeaders(0).PartNo || '[' || iapiSpecificationBom.gtBomHeaders(0).Revision || ']');
      
   iapiGeneral.LogInfo(psSource, csMethod, 'End changing PED in sync');
   iapiGeneral.DisableLogging;
   
EXCEPTION
   WHEN OTHERS THEN
      iapiGeneral.LogError(psSource, csMethod, SQLERRM);
END SetPEDInSync;


--PACKAGE BODY APAO_PRE_POST_FUNC

PROCEDURE GenerateConstructionCode IS
    csMethod     CONSTANT iapiType.Method_Type  := 'GenerateConstructionCode';
    
    csFuncTyre   CONSTANT iapiType.KeywordValue_Type := 'Tyre';
    cnKwFunc     CONSTANT iapiType.Id_Type := 700386; --Keyword:  Function
    cnStatusDev  CONSTANT iapiType.Id_Type := 1;      --Status:   In Development
    cnStatusQR3  CONSTANT iapiType.Id_Type := 126;    --Status:   CRRNT QR3
    cnSecGeneral CONSTANT iapiType.Id_Type := 700579; --Section:  General information
    cnPGSidewall CONSTANT iapiType.Id_Type := 701568; --PropGrp:  Sidewall designation
    cnPropSerial CONSTANT iapiType.Id_Type := 705629; --Property: Serial number DOT
    cnPropConstr CONSTANT iapiType.Id_Type := 970;    --Property: Construction code
    cnHeaderVal  CONSTANT iapiType.Id_Type := 700511; --Header:   Value
    cnSerialLen  CONSTANT NUMBER := 4;
    
    lnCount      NUMBER;
    lnResult     iapiType.ErrorNum_Type;
    lnRetVal     iapiType.ErrorNum_Type;
    lrContext    iapiType.StatusChangeRec_Type;
    lqProperties iapiType.Ref_Type;
    lrProperty   iapiType.SpPropertyRec_Type;
    lqInfo       iapiType.Ref_Type;
    lqErrors     iapiType.Ref_Type;
    ltErrors     iapiType.ErrorTab_Type;
    lrError      iapitype.ErrorRec_type;
    
    lsSerialCode       VARCHAR2(40);
    lsConstructionCode VARCHAR2(4);
BEGIN
    lrContext := iapiSpecificationStatus.gtStatusChange(0);
    lnResult  := iapiConstantDBError.DBERR_SUCCESS;
    
    --Only generate a construction code when changing status to Current QR3.
    IF lrContext.NextStatusId IS NULL OR lrContext.NextStatusId <> cnStatusQR3 THEN
        RETURN;
    END IF;

    --Only generate a construction code when the frame is a tyre.
    SELECT COUNT(*)
    INTO  lnCount
    FROM  specification_kw
    WHERE part_no  = lrContext.partNo
      AND kw_id    = cnKwFunc
      AND kw_value = csFuncTyre;
    
    IF lnCount = 0 THEN
        RETURN;
    END IF;


    --Retrieve Serial Number DOT property
    lnRetVal := iapiSpecificationPropertyGroup.GetProperties(
        asPartNo     => lrContext.PartNo,
        anRevision   => lrContext.Revision,
        anItemId     => cnPGSidewall,
        aqProperties => lqProperties,
        aqErrors     => lqErrors
    );
    IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
        lnResult := lnRetVal;
        --Adding error to the list will result in rollback and display the error to the user.
        lnRetVal := iapiGeneral.AddErrorToList(
            asParameterId => csMethod,
            asErrorText   => 'Error while changing status. Retrieving Serial Number returned error code ' || lnResult,
            atErrors      => iapiSpecificationStatus.gtErrors,
            anMessageType => iapiConstant.ERRORMESSAGE_ERROR
        );
        iapiGeneral.LogError(
            asSource  => psSource,
            asMethod  => csMethod,
            asMessage => 'Error while changing status. Retrieving Serial Number returned error code ' || lnResult
        );
    END IF;
    
    IF lnResult = iapiConstantDBError.DBERR_SUCCESS THEN
        LOOP
            --Loop over the properties and try to find the Construction Code property.
            FETCH lqProperties INTO lrProperty;
            EXIT WHEN lqProperties%NOTFOUND;

            IF lrProperty.PropertyId = cnPropSerial THEN
                lsSerialCode := lrProperty.String1;
                
                --Verify that we have a valid length Serial number
                IF LENGTH(lsSerialCode) <> cnSerialLen THEN
                    lnRetVal := iapiGeneral.AddErrorToList(
                        asParameterId => csMethod,
                        asErrorText   => 'Error while changing status. Length of Serial Number must be ' || cnSerialLen,
                        atErrors      => iapiSpecificationStatus.gtErrors,
                        anMessageType => iapiConstant.ERRORMESSAGE_ERROR
                    );
                    iapiGeneral.LogError(
                        asSource  => psSource,
                        asMethod  => csMethod,
                        asMessage => 'Error while changing status. Length of Serial Number must be ' || cnSerialLen
                    );
                    EXIT;
                END IF;
                
                --Generate construction code depending on the serial number.
                lsConstructionCode := F_GEN_CONSTRUCTION_CODE(lsSerialCode);

                --Change the specification status to Development so that we have edit rights.
                UPDATE specification_header
                SET    status   = cnStatusDev
                WHERE  part_no  = lrContext.partNo
                  AND  revision = lrContext.revision;
            
                --Set the construction code to the generated value.
                lnRetVal := iapiSpecificationPropertyGroup.SaveAddProperty(
                    asPartNo          => lrContext.PartNo,
                    anRevision        => lrContext.Revision,
                    anSectionId       => cnSecGeneral,
                    anSubsectionId    => 0,
                    anPropertyGroupId => cnPGSidewall,
                    anPropertyId      => cnPropConstr,
                    anAttributeId     => 0,
                    anHeaderId        => cnHeaderVal,
                    asValue           => lsConstructionCode,
                    aqInfo            => lqInfo,
                    aqErrors          => lqErrors
                );
                --Ignore when we can't find the property. This means the frame does not have a place to store it.
                --New specs will use the current frame, so if the frame *does* have the property, the new spec will be forced to use it.
                IF lnRetVal = iapiConstantDBError.DBERR_FRPROPERTYNOTFOUND THEN
                    lnRetVal := iapiConstantDBError.DBERR_SUCCESS;
                END IF;
                IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
                    lnResult := lnRetVal;
                    --Adding error to the list will result in rollback and display the error to the user.
                    lnRetVal := iapiGeneral.AddErrorToList(
                        asParameterId => csMethod,
                        asErrorText   => 'Error while changing status. Setting Construction Code returned error code ' || lnResult,
                        atErrors      => iapiSpecificationStatus.gtErrors,
                        anMessageType => iapiConstant.ERRORMESSAGE_ERROR
                    );
                    iapiGeneral.LogError(
                        asSource  => psSource,
                        asMethod  => csMethod,
                        asMessage => 'Error while changing status. Setting Construction Code returned error code ' || lnResult
                    );
                END IF;
                
                --Reset the specification status to Current QR3. We know it's QR3, because this section will only be executed when the new status is QR3.
                UPDATE specification_header
                SET    status   = cnStatusQR3
                WHERE  part_no  = lrContext.partNo
                  AND  revision = lrContext.revision;
                
                --We found our property, so we can exit the loop.
                EXIT;
            END IF;
        END LOOP;
    END IF;

    --Log any error messages we have received.
    FETCH lqErrors
    BULK COLLECT INTO ltErrors;

    IF ltErrors.COUNT > 0 THEN
        FOR lnIndex IN ltErrors.FIRST..ltErrors.LAST
        LOOP
            lrError := ltErrors(lnIndex);
            IF lrError.MessageType = iapiConstant.ErrorMessage_Error THEN
                iapiGeneral.LogError(
                    asSource  => psSource,
                    asMethod  => csMethod,
                    asMessage => lrError.ErrorText
                );
            END IF;
        END LOOP;
    END IF;
    
EXCEPTION
WHEN OTHERS THEN
    lnRetVal := iapiGeneral.AddErrorToList(
        asParameterId => csMethod,
        asErrorText   => SQLERRM,
        atErrors      => iapiSpecificationStatus.gtErrors,
        anMessageType => iapiConstant.ERRORMESSAGE_ERROR
    );
    iapiGeneral.LogError(psSource, csMethod, SQLERRM);
END GenerateConstructionCode;

PROCEDURE CleanDSpecObjects IS
    csMethod  CONSTANT iapiType.Method_Type  := 'CleanDSpecObjects';
    csFrameID CONSTANT iapiType.FrameNo_Type := 'E_PCR';
    lnRetVal  iapiType.ErrorNum_Type;
BEGIN
    IF iapiSpecification.gtCopySpec(0).FrameId IN (
        'E_PCR',
        'A_PCR_v1',
        'A_PCR'
    ) AND iapiSpecification.gtCopySpec(0).FromPartNo = iapiSpecification.gtCopySpec(0).PartNo THEN
        lnRetVal := aapiCatia.CleanDSpecObjects(
            iapiSpecification.gtCopySpec(0).PartNo,
            iapiSpecification.gtCopySpec(0).NewRevision
        );
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
            iapiGeneral.LogError(psSource, csMethod, F_GET_MESSAGE(lnRetVal));
            lnRetVal := iapiGeneral.AddErrorToList(
                csMethod,
                F_GET_MESSAGE(lnRetVal),
                iapiSpecification.gtErrors,
                iapiConstant.ERRORMESSAGE_ERROR
            );
        END IF;
    END IF;
EXCEPTION
WHEN OTHERS THEN
    lnRetVal := iapiGeneral.AddErrorToList(
        asParameterId => csMethod,
        asErrorText   => SQLERRM,
        atErrors      => iapiSpecificationStatus.gtErrors,
        anMessageType => iapiConstant.ERRORMESSAGE_ERROR
    );
    iapiGeneral.LogError(psSource, csMethod, SQLERRM);
END;

PROCEDURE CleanHyperMaterialFiles IS
    csMethod  CONSTANT iapiType.Method_Type  := 'CleanHyperMaterialFiles';
    lnRetVal  iapiType.ErrorNum_Type;
BEGIN
    IF iapiSpecification.gtCopySpec(0).FrameId IN (
        'A_Global_Beadwire',
        'A_Global_Fabric',
        'A_Global_Steelcord',
        'E_FM',
        'E_PCR',
        'A_PCR_v1',
        'A_PCR',
        'Global compound'
    ) AND iapiSpecification.gtCopySpec(0).FromPartNo = iapiSpecification.gtCopySpec(0).PartNo THEN
        lnRetVal := aapiFea.CleanObjects(
            iapiSpecification.gtCopySpec(0).PartNo,
            iapiSpecification.gtCopySpec(0).NewRevision
        );
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
            iapiGeneral.LogError(psSource, csMethod, F_GET_MESSAGE(lnRetVal));
            lnRetVal := iapiGeneral.AddErrorToList(
                csMethod,
                F_GET_MESSAGE(lnRetVal),
                iapiSpecification.gtErrors,
                iapiConstant.ERRORMESSAGE_ERROR
            );
        END IF;
    END IF;
EXCEPTION
WHEN OTHERS THEN
    lnRetVal := iapiGeneral.AddErrorToList(
        asParameterId => csMethod,
        asErrorText   => SQLERRM,
        atErrors      => iapiSpecificationStatus.gtErrors,
        anMessageType => iapiConstant.ERRORMESSAGE_ERROR
    );
    iapiGeneral.LogError(psSource, csMethod, SQLERRM);
END;

--------------------------------------------------------------------------------
-- package initialization-code
--------------------------------------------------------------------------------

PROCEDURE MergeAttachedSpecs (
    avs_part_no  IN iapiType.PartNo_Type,
    avn_revision IN iapiType.Revision_Type,
    avt_errors   IN OUT ErrorDataTable_Type,
    avn_msg_type IN iapiType.ErrorMessageType_Type DEFAULT iapiConstant.ErrorMessage_Error
) AS
    csMethod      CONSTANT iapiType.Method_Type := 'MergeAttachedSpecs';
    csTemplPrefix CONSTANT iapiType.String_Type := 'TPL-%';
    lnRetVal      iapiType.ErrorNum_Type;

    lsTplPrefix   iapiType.SqlString_Type;
    lsCopyCond    iapiType.KeywordValue_Type;
    lsSep         iapiType.Clob_Type := ' '; --CHR(13) || CHR(10);
    lsColNames    iapiType.Clob_Type;
    lsUpdCols     iapiType.Clob_Type;
    lsValNames    iapiType.Clob_Type;
    lsColConds    iapiType.Clob_Type;
    lsSqlQuery    iapiType.Clob_Type;
  
    lsASPartNo    iapiType.PartNo_Type;
    lnASMaxRev    iapiType.Revision_Type;
    lnASRevision  iapiType.Revision_Type;
    lsASFrameId   iapiType.PartNo_Type;
    lnASFrameRev  iapiType.Revision_Type;
    lsTplPartNo   iapiType.PartNo_Type;
    lnTplRevision iapiType.Revision_Type;
    
    CURSOR c_att_specs(
      asPartNo   IN iapiType.PartNo_Type,
      anRevision IN iapiType.Revision_Type
    ) IS
      SELECT attached_part_no, attached_revision
      FROM attached_specification
      WHERE part_no = asPartNo
      AND revision = anRevision
      ORDER BY attached_part_no, attached_revision;
  
    CURSOR c_cols
    IS
      SELECT
        col_name,
        cond_name,
        CASE
          WHEN char_length = 1 THEN '''N'''
          WHEN col_name = 'test_method' THEN '0'
        END AS null_val,
        CASE WHEN cond_name != col_name THEN 1 ELSE 0 END AS is_rev
      FROM (
        SELECT
          LOWER(column_name) AS col_name,
          REPLACE(LOWER(column_name), '_rev', '') AS cond_name,
          char_length,
          column_id
        FROM all_tab_cols
        WHERE table_name = 'SPECIFICATION_PROP'
        AND column_name NOT IN ('PART_NO', 'REVISION', 'SEQUENCE_NO', 'INTL')
        AND column_name NOT LIKE 'SECTION%'
        AND column_name NOT LIKE 'SUB_SECTION%'
        AND column_name NOT LIKE 'PROPERTY_GROUP%'
        AND column_name NOT LIKE 'PROPERTY%'
        AND column_name NOT LIKE 'ATTRIBUTE%'
        AND column_name NOT LIKE 'UOM%'
      )
      ORDER BY column_id;
    
    FUNCTION ColCond(
      lsColName IN iapiType.StringVal_Type,
      lsNullVal IN iapiType.StringVal_Type DEFAULT NULL
    ) RETURN iapiType.StringVal_Type
    AS
    BEGIN
      IF lsNullVal IS NULL THEN
        RETURN lsColName;
      ELSE
        RETURN 'NULLIF(' || lsColName || ',' || lsNullVal || ')';
      END IF;
    END;
  BEGIN
    FOR l_row IN c_att_specs(avs_part_no, avn_revision)
    LOOP
      lsASPartNo := l_row.attached_part_no;
      lnASRevision := l_row.attached_revision;
  
      SELECT NVL(UPPER(sckw.kw_value), 'IF FILLED') kw_value
      INTO lsCopyCond
      FROM itkw
      LEFT JOIN specification_kw sckw ON (
        sckw.kw_id = itkw.kw_id
        AND sckw.part_no = lsASPartNo
      )
      WHERE itkw.description = 'Template value overwrite';
      
      IF lnASRevision = 0 THEN
        --Check Max Revision and Max Current Revision.
        --We want to know if it has a Template. Later we will check for Current.
        SELECT MAX(revision),
          MAX(DECODE(status_type, iapiConstant.STATUSTYPE_CURRENT, revision))
        INTO lnASMaxRev, lnASRevision
        FROM specification_header
        LEFT JOIN status USING (status)
        WHERE part_no = lsASPartNo;        
        
        IF lnASMaxRev IS NULL THEN
          lnRetVal := iapiGeneral.SetErrorText(
            iapiConstantDbError.DBERR_SPECSTATUSNOTFOUND,
            lsASPartNo, lnASRevision, iapiConstant.STATUSTYPE_CURRENT
          );
          lnRetVal := iapiGeneral.AddErrorToList(csMethod, iapiGeneral.GetLastErrorText(), avt_errors, avn_msg_type);
          iapiGeneral.LogError(psSource, csMethod, iapiGeneral.GetLastErrorText());
          CONTINUE;
        END IF;
      END IF;
    
      SELECT frame_id, frame_rev
      INTO lsASFrameId, lnASFrameRev
      FROM specification_header
      LEFT JOIN status USING (status)
      WHERE part_no = lsASPartNo
      --Look for frame, even if there is no Current revision.
      AND revision = NVL(lnASRevision, lnASMaxRev);
      
      BEGIN
        SELECT part_no, MAX(revision) AS revision
        INTO lsTplPartNo, lnTplRevision
        FROM specification_header
        LEFT JOIN status USING (status)
        WHERE part_no LIKE csTemplPrefix
        AND frame_id = lsASFrameId
        AND frame_rev <= lnASFrameRev
        AND status_type IN (iapiConstant.STATUSTYPE_CURRENT, iapiConstant.STATUSTYPE_HISTORIC)
        GROUP BY part_no;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
        CONTINUE; --No Template defined. Skip to next Attached Spec.
      WHEN TOO_MANY_ROWS THEN
        lnRetVal := iapiGeneral.SetErrorText(
          iapiConstantDbError.DBERR_TOOMANYROWSTREETYPE,
          lsASFrameId, 'Templates'
        );
        lnRetVal := iapiGeneral.AddErrorToList(csMethod, iapiGeneral.GetLastErrorText(), avt_errors, avn_msg_type);
        iapiGeneral.LogError(psSource, csMethod, iapiGeneral.GetLastErrorText());
        CONTINUE;
      END;
      
      --Give an error if a Spec has a Template but no Current revision.
      IF lnASRevision IS NULL THEN
        lnRetVal := iapiGeneral.SetErrorText(
          iapiConstantDbError.DBERR_SPECSTATUSNOTFOUND,
          lsASPartNo, lnASMaxRev, iapiConstant.STATUSTYPE_CURRENT
        );
        lnRetVal := iapiGeneral.AddErrorToList(csMethod, iapiGeneral.GetLastErrorText(), avt_errors, avn_msg_type);
        iapiGeneral.LogError(psSource, csMethod, iapiGeneral.GetLastErrorText());
        CONTINUE;
      END IF;
        
      lsColNames := '';
      lsValNames := '';
      lsColConds := '';
      lsUpdCols  := '';
      FOR lr IN c_cols
      LOOP
        IF lsColNames IS NOT NULL THEN
          lsColNames := lsColNames || ',';
          lsValNames := lsValNames || ',';
          lsUpdCols  := lsUpdCols  || ',';
        END IF;
        
        lsColNames := lsColNames || '.' || lr.col_name;
        lsUpdCols  := lsUpdCols  || 'sp.' || lr.col_name || '=ap.' || lr.col_name;
        lsValNames := lsValNames || 'CASE WHEN ';
        lsValNames := lsValNames || ColCond('tp.' || lr.cond_name, lr.null_val) || ' IS NOT NULL';
        CASE lsCopyCond
          WHEN 'ALWAYS' THEN
            NULL;
          WHEN 'IF FILLED' THEN
            lsValNames := lsValNames || ' AND ' || ColCond('ap.' || lr.cond_name, lr.null_val) || ' IS NOT NULL';
          WHEN 'NEVER' THEN
            lsValNames := lsValNames || ' AND ' || ColCond('bp.' || lr.cond_name, lr.null_val) || ' IS NULL';
        END CASE;      
        lsValNames := lsValNames || ' THEN ap.' || lr.col_name;
        lsValNames := lsValNames || ' ELSE bp.' || lr.col_name || ' END';
        lsValNames := lsValNames || ' AS ' || lr.col_name;

        IF lr.cond_name = lr.col_name THEN
          IF lsColConds IS NOT NULL THEN
            lsColConds := lsColConds || '||';
          END IF;
          lsColConds := lsColConds || ColCond('.' || lr.col_name, lr.null_val);
        END IF;
      END LOOP;

      lsSqlQuery :=
        'INSERT INTO specification_section (' || lsSep ||
				  'part_no,' || lsSep ||
					'revision,' || lsSep ||
					'section_id,' || lsSep ||
					'section_rev,' || lsSep ||
					'sub_section_id,' || lsSep ||
					'sub_section_rev,' || lsSep ||
					'type,' || lsSep ||
					'ref_id,' || lsSep ||
					'sequence_no,' || lsSep ||
					'header,' || lsSep ||
					'mandatory,' || lsSep ||
					'section_sequence_no,' || lsSep ||
					'ref_ver,' || lsSep ||
					'ref_info,' || lsSep ||
					'display_format,' || lsSep ||
					'display_format_rev,' || lsSep ||
					'association,' || lsSep ||
					'intl,' || lsSep ||
					'ref_owner' || lsSep ||
				')' || lsSep ||
        'SELECT' || lsSep ||
					':lsPartNo,' || lsSep ||
					':lnRevision,' || lsSep ||
					'section_id,' || lsSep ||
					'section_rev,' || lsSep ||
					'sub_section_id,' || lsSep ||
					'sub_section_rev,' || lsSep ||
					'type,' || lsSep ||
					'ref_id,' || lsSep ||
					'sequence_no,' || lsSep ||
					'header,' || lsSep ||
					'mandatory,' || lsSep ||
					'section_sequence_no,' || lsSep ||
					'ref_ver,' || lsSep ||
					'ref_info,' || lsSep ||
					'display_format,' || lsSep ||
					'display_format_rev,' || lsSep ||
					'association,' || lsSep ||
					'intl,' || lsSep ||
					'ref_owner' || lsSep ||
        'FROM frame_section' || lsSep ||
        'WHERE (frame_no, revision) = (' || lsSep ||
          'SELECT frame_id, frame_rev' || lsSep ||
          'FROM specification_header' || lsSep ||
          'WHERE part_no = :lsPartNo' || lsSep ||
          'AND revision = :lnRevision' || lsSep ||
        ')' || lsSep ||
        'AND type IN (1, 4)' || lsSep ||
        'AND mandatory = ''N''' || lsSep ||
        'AND (section_id, sub_section_id, type, ref_id, section_sequence_no) NOT IN (' || lsSep ||
          'SELECT section_id, sub_section_id, type, ref_id, section_sequence_no' || lsSep ||
          'FROM specification_section' || lsSep ||
          'WHERE part_no = :lsPartNo' || lsSep ||
          'AND revision = :lnRevision' || lsSep ||
        ')' || lsSep ||
        'AND (section_id, sub_section_id, DECODE(type, 1, ref_id, 0), DECODE(type, 4, ref_id, 0)) IN (' || lsSep ||
          'SELECT section_id, sub_section_id, property_group, DECODE(property_group, 0, property, 0) AS property' || lsSep ||
          'FROM specification_prop' || lsSep ||
          'WHERE part_no = :lsASPartNo' || lsSep ||
          'AND revision = :lnASRevision' || lsSep ||
          'AND ' || REPLACE(lsColConds, '.', '') || ' IS NOT NULL' || lsSep ||
        ')';

      EXECUTE IMMEDIATE lsSqlQuery
      USING avs_part_no, avn_revision, avs_part_no, avn_revision, avs_part_no, avn_revision, lsASPartNo, lnASRevision;
    
      lsSqlQuery :=
        'MERGE INTO specification_prop sp' || lsSep ||
        'USING (' || lsSep ||
          'SELECT' || lsSep ||
            ':lsPartNo AS part_no,' || lsSep ||
            ':lnRevision AS revision,' || lsSep ||
            'tp.section_id,' || lsSep ||
            'tp.sub_section_id,' || lsSep ||
            'tp.property_group,' || lsSep ||
            'tp.property,' || lsSep ||
            'tp.attribute,' || lsSep ||
            'tp.sequence_no,' || lsSep ||
            lsValNames || lsSep ||
          'FROM specification_prop tp' || lsSep ||
          'LEFT JOIN specification_prop bp ON (' || lsSep ||
            'bp.section_id = tp.section_id' || lsSep ||
            'AND bp.property_group = tp.property_group' || lsSep ||
            'AND bp.property = tp.property' || lsSep ||
            'AND bp.attribute = tp.attribute' || lsSep ||
            'AND bp.part_no = :lsPartNo' || lsSep ||
            'AND bp.revision = :lnRevision' || lsSep ||
          ')' || lsSep ||
          'LEFT JOIN specification_prop ap ON (' || lsSep ||
            'ap.section_id = tp.section_id' || lsSep ||
            'AND ap.property_group = tp.property_group' || lsSep ||
            'AND ap.property = tp.property' || lsSep ||
            'AND ap.attribute = tp.attribute' || lsSep ||
            'AND ap.part_no = :lsASPartNo' || lsSep ||
            'AND ap.revision = :lnASRevision' || lsSep ||
          ')' || lsSep ||
          'WHERE tp.part_no = :lsTplPartNo' || lsSep ||
          'AND tp.revision = :lnTplRevision' || lsSep ||
          'AND ' || REPLACE(lsColConds, '.', 'tp.') || ' IS NOT NULL' || lsSep ||
          CASE WHEN lsCopyCond != 'ALWAYS' THEN 'AND ' || REPLACE(lsColConds, '.', 'ap.') || ' IS NOT NULL' || lsSep END ||
        ') ap' || lsSep ||
        'ON (' || lsSep ||
          'sp.part_no = ap.part_no' || lsSep ||
          'AND sp.revision = ap.revision' || lsSep ||
          'AND sp.section_id = ap.section_id' || lsSep ||
          'AND sp.sub_section_id = ap.sub_section_id' || lsSep ||
          'AND sp.property_group = ap.property_group' || lsSep ||
          'AND sp.property = ap.property' || lsSep ||
          'AND sp.attribute = ap.attribute' || lsSep ||
        ')' || lsSep ||
        'WHEN MATCHED THEN UPDATE SET' || lsSep ||
          lsUpdCols || lsSep ||
        'WHEN NOT MATCHED THEN INSERT (' || lsSep ||
          'part_no,' || lsSep ||
          'revision,' || lsSep ||
          'section_id,' || lsSep ||
          'sub_section_id,' || lsSep ||
          'property_group,' || lsSep ||
          'property,' || lsSep ||
          'attribute,' || lsSep ||
          'sequence_no,' || lsSep ||
          REPLACE(lsColNames, '.', 'sp.') || lsSep ||
        ')' || lsSep ||
        'VALUES (' || lsSep ||
          'ap.part_no,' || lsSep ||
          'ap.revision,' || lsSep ||
          'ap.section_id,' || lsSep ||
          'ap.sub_section_id,' || lsSep ||
          'ap.property_group,' || lsSep ||
          'ap.property,' || lsSep ||
          'ap.attribute,' || lsSep ||
          'ap.sequence_no,' || lsSep ||
          REPLACE(lsColNames, '.', 'ap.') || lsSep ||
        ')';
        
      EXECUTE IMMEDIATE lsSqlQuery
      USING avs_part_no, avn_revision, avs_part_no, avn_revision, lsASPartNo, lnASRevision, lsTplPartNo, lnTplRevision;
    END LOOP;
EXCEPTION
WHEN OTHERS THEN
    lnRetVal := iapiGeneral.AddErrorToList(csMethod, SQLERRM, avt_errors);
    iapiGeneral.LogError(psSource, csMethod, SQLERRM);
END;

PROCEDURE MergeAttachedSpecs_copy
IS
    csMethod CONSTANT iapiType.Method_Type := 'MergeAttachedSpecs_copy';
    lnRetVal iapiType.ErrorNum_Type;
BEGIN
    MergeAttachedSpecs(
      iapiSpecification.gtCopySpec(0).PartNo,
      iapiSpecification.gtCopySpec(0).NewRevision,
      iapiSpecification.gtErrors,
      iapiConstant.ErrorMessage_Warning
    );
EXCEPTION
WHEN OTHERS THEN
    lnRetVal := iapiGeneral.AddErrorToList(csMethod, SQLERRM, iapiSpecification.gtErrors);
    iapiGeneral.LogError(psSource, csMethod, SQLERRM);
END;

PROCEDURE MergeAttachedSpecs_save
IS
    csMethod CONSTANT iapiType.Method_Type := 'MergeAttachedSpecs_save';
    lnRetVal iapiType.ErrorNum_Type;
BEGIN
    MergeAttachedSpecs(
      iapiSpecificationAttachedSpecs.gtAttachedSpecs(0).PartNo,
      iapiSpecificationAttachedSpecs.gtAttachedSpecs(0).Revision,
      iapiSpecificationAttachedSpecs.gtErrors,
      iapiConstant.ErrorMessage_Warning
    );
EXCEPTION
WHEN OTHERS THEN
    lnRetVal := iapiGeneral.AddErrorToList(csMethod, SQLERRM, iapiSpecification.gtErrors);
    iapiGeneral.LogError(psSource, csMethod, SQLERRM);
END;

PROCEDURE MergeAttachedSpecs_status
IS
    csMethod     CONSTANT iapiType.Method_Type := 'MergeAttachedSpecs_status';
    lnRetVal     iapiType.ErrorNum_Type;
    lsStatusType iapiType.StatusType_Type;
BEGIN
    SELECT status_type
    INTO lsStatusType
    FROM status
    WHERE status = iapiSpecificationStatus.gtStatusChange(0).StatusId;
    
    IF lsStatusType = iapiConstant.StatusType_Development THEN
      MergeAttachedSpecs(
        iapiSpecificationStatus.gtStatusChange(0).PartNo,
        iapiSpecificationStatus.gtStatusChange(0).Revision,
        iapiSpecificationStatus.gtErrors,
      iapiConstant.ErrorMessage_Error
      );
    END IF;
EXCEPTION
WHEN OTHERS THEN
    lnRetVal := iapiGeneral.AddErrorToList(csMethod, SQLERRM, iapiSpecificationStatus.gtErrors);
    iapiGeneral.LogError(psSource, csMethod, SQLERRM);
END;


 
PROCEDURE ClearSapCode IS
    csMethod     CONSTANT iapiType.Method_Type  := 'ClearSapCode';
    lnCount      iapiType.NumVal_Type;
    lsOrigPartNo iapiType.PartNo_Type;
    lnOrigRev    iapiType.Revision_Type;
    lsNewPartNo  iapiType.PartNo_Type;
    lnNewRev     iapiType.Revision_Type;
    lnRetVal     iapiType.ErrorNum_Type;
BEGIN
    lsOrigPartNo := iapiSpecification.gtCopySpec(0).FromPartNo;
    lnOrigRev    := iapiSpecification.gtCopySpec(0).FromRevision;
    lsNewPartNo  := iapiSpecification.gtCopySpec(0).PartNo;
    lnNewRev     := iapiSpecification.gtCopySpec(0).NewRevision;
    
    IF iapiSpecification.gtCopySpec(0).SpecTypeId IN (
      --700303, --Spec type AT
      --700394, --Spec type SM
      700309 --Spec type PCT
    ) AND NOT lsNewPartNo LIKE 'X%' --Spec is not Trial
    AND lsNewPartNo != lsOrigPartNo THEN --Part_no is different, i.e. not a new revision of same spec
        /*
        SELECT COUNT(*) AS oem
        INTO lnCount
        FROM specification_prop
        WHERE part_no = lsOrigPartNo
        AND revision = lnOrigRev
        AND section_id = 700579 --General information
        AND sub_section_id = 0 --(none)
        AND property_group = 701568 --Sidewall designation
        AND property = 705219 --OEM approval
        AND attribute = 0
        AND characteristic = 900484 --Yes
        ;*/
        
        --Treat OEM same for now.
        --IF lnCount = 0 THEN
            --Delete 'Commercial article code' and 'Commercial DA article code'
            UPDATE specification_prop
            SET char_1 = NULL
            WHERE part_no = lsNewPartNo
            AND revision = lnNewRev
            AND section_id = 700755 --SAP information
            AND sub_section_id = 0 --(none)
            AND property_group = 704056	--SAP articlecode
            AND property IN (
                --713825, --Commercial DA article code
                713824  --Commercial article code
            ) AND attribute = 0;

            --Delete 'Article group PG'
            UPDATE specification_prop
            SET characteristic = NULL
            WHERE part_no = lsNewPartNo
            AND revision = lnNewRev
            AND section_id = 700755 --SAP information
            AND sub_section_id = 0 --(none)
            AND property_group IN (704540, 0) --SAP information or single property
            AND property = 705428 --Article group PG
            AND attribute = 0;
            
            lnRetVal := iapiGeneral.AddErrorToList(
                asParameterId => csMethod,
                asErrorText   =>
                    'Copying to a new Part no. will clear the SAP code.' || CHR(13) || CHR(10) ||
                    'Please make sure a new SAP code is filled in when submitting the Specification.',
                atErrors      => iapiSpecification.gtErrors,
                anMessageType => iapiConstant.ERRORMESSAGE_WARNING
            );

        --END IF;
    END IF;
EXCEPTION
WHEN OTHERS THEN
    lnRetVal := iapiGeneral.AddErrorToList(
        asParameterId => csMethod,
        asErrorText   => SQLERRM,
        atErrors      => iapiSpecification.gtErrors,
        anMessageType => iapiConstant.ERRORMESSAGE_ERROR
    );
    iapiGeneral.LogError(psSource, csMethod, SQLERRM);
END;


PROCEDURE ValidateBasedUpon(
    avs_part_no     IN iapiType.PartNo_Type,
    avn_revision    IN iapiType.Revision_Type,
    avn_section     IN iapiType.Id_Type,
    avn_sub_section IN iapiType.Id_Type,
    avn_property    IN iapiType.Id_Type,
    avn_attspec_ref IN iapiType.Id_Type,
    avt_errors      IN OUT ErrorDataTable_Type
) IS
    csMethod     CONSTANT iapiType.Method_Type  := 'ValidateBasedUpon';
    lnType       iapiType.Id_Type;
    lsPartNo     iapiType.PartNo_Type;
    lnSection    iapiType.Id_Type;
    lnSubSection iapiType.Id_Type;
    lnAttSpecRef iapiType.Id_Type;
    lnCount      iapiType.NumVal_Type;
    lnRetVal     iapiType.ErrorNum_Type;
BEGIN
    SELECT class3_id
    INTO lnType
    FROM specification_header
    WHERE part_no = avs_part_no
    AND revision = avn_revision;

    IF lnType IN (
      --700303, --Spec type AT
      --700394, --Spec type SM
        700309 --Spec type PCT
    ) AND NOT avs_part_no LIKE 'X%' THEN --Spec is not Trial
        SELECT section_id, sub_section_id, ref_id
        INTO lnSection, lnSubSection, lnAttSpecRef
        FROM specification_section
        WHERE part_no = avs_part_no
        AND revision = avn_revision
        AND section_id = 700975 --Industrialization
        AND sub_section_id = 0 --(none)
        AND type = 8; --Attached Specification

        IF  avn_section = 700975 AND avn_sub_section = 0
        AND (avn_property = 715027 OR avn_attspec_ref = lnAttSpecRef) THEN
            SELECT COUNT(CASE WHEN attached_revision = 0 THEN 1 END)
            INTO lnCount
            FROM attached_specification
            WHERE part_no = avs_part_no
            AND revision = avn_revision
            AND section_id = lnSection
            AND sub_section_id = lnSubSection
            AND ref_id = lnAttSpecRef;
            
            IF lnCount != 0 THEN
                lnRetVal := iapiGeneral.AddErrorToList(
                    asParameterId => csMethod,
                    asErrorText   =>
                        'Attached Specifications require a revision. Phantom is not allowed.' || CHR(13) || CHR(10) ||
                        'Right click on the Attached Specification and choose Use Revision.',
                    atErrors      => avt_errors,
                    anMessageType => iapiConstant.ERRORMESSAGE_WARNING
                );
            END IF;
    
            SELECT char_1
            INTO lsPartNo
            FROM specification_prop
            WHERE part_no = avs_part_no
            AND revision = avn_revision
            AND section_id = lnSection
            AND sub_section_id = lnSubSection
            AND property_group = 0	--default property group
            AND property = 715027 --QR3 release based upon trial
            AND attribute = 0;
        
            IF lnCount != 0 THEN
                SELECT COUNT(*)
                INTO lnCount
                FROM attached_specification
                WHERE part_no = avs_part_no
                AND revision = avn_revision
                AND section_id = lnSection
                AND sub_section_id = lnSubSection
                AND ref_id = lnAttSpecRef
                AND attached_part_no = lsPartNo;
            
                IF lnCount = 0 THEN
                    lnRetVal := iapiGeneral.AddErrorToList(
                        asParameterId => csMethod,
                        asErrorText   => 'Based Upon Spec is not in Attached Specifications.',
                        atErrors      => avt_errors,
                        anMessageType => iapiConstant.ERRORMESSAGE_ERROR
                    );
                END IF;
            END IF;
        END IF;
   
    END IF;

EXCEPTION
WHEN OTHERS THEN
    lnRetVal := iapiGeneral.AddErrorToList(
        asParameterId => csMethod,
        asErrorText   => SQLERRM,
        atErrors      => iapiSpecification.gtErrors,
        anMessageType => iapiConstant.ERRORMESSAGE_ERROR
    );
    iapiGeneral.LogError(psSource, csMethod, SQLERRM);
END;


PROCEDURE ValidateBasedUpon_prop IS
    csMethod CONSTANT iapiType.Method_Type := 'ValidateBasedUpon_prop';
    lnRetVal          iapiType.ErrorNum_Type;
BEGIN
    ValidateBasedUpon(
        iapiSpecificationPropertyGroup.gtProperties(0).PartNo,
        iapiSpecificationPropertyGroup.gtProperties(0).Revision,
        iapiSpecificationPropertyGroup.gtProperties(0).SectionId,
        iapiSpecificationPropertyGroup.gtProperties(0).SubSectionId,
        iapiSpecificationPropertyGroup.gtProperties(0).PropertyId,
        NULL,
        iapiSpecificationPropertyGroup.gtErrors
    );
EXCEPTION
   WHEN OTHERS THEN
      iapiGeneral.LogError(psSource, csMethod, SQLERRM);
END;


PROCEDURE ValidateBasedUpon_attspec IS
    csMethod CONSTANT iapiType.Method_Type := 'ValidateBasedUpon_attspec';
    lnRetVal          iapiType.ErrorNum_Type;
BEGIN
    ValidateBasedUpon(
        iapiSpecificationAttachedSpecs.gtAttachedSpecs(0).PartNo,
        iapiSpecificationAttachedSpecs.gtAttachedSpecs(0).Revision,
        iapiSpecificationAttachedSpecs.gtAttachedSpecs(0).SectionId,
        iapiSpecificationAttachedSpecs.gtAttachedSpecs(0).SubSectionId,
        NULL,
        iapiSpecificationAttachedSpecs.gtAttachedSpecs(0).ItemId,
        iapiSpecificationAttachedSpecs.gtErrors
    );
EXCEPTION
   WHEN OTHERS THEN
      iapiGeneral.LogError(psSource, csMethod, SQLERRM);
END;


PROCEDURE SaveQualityReviewPhase
IS
    csMethod     CONSTANT iapiType.Method_Type := 'SaveQualityReviewPhase';
    lnRetVal     iapiType.ErrorNum_Type;
    lsStatusDesc iapiType.ShortDescription_Type;
    lsStatusType iapiType.StatusType_Type;
    lnValueId    iapiType.Id_Type;
BEGIN
    BEGIN
        SELECT REGEXP_SUBSTR(sort_desc, 'QR\d+') AS sort_desc, status_type
        INTO lsStatusDesc, lsStatusType
        FROM status
        WHERE status = iapiSpecificationStatus.gtStatusChange(0).NextStatusId;
    EXCEPTION
    WHEN no_data_found THEN
        RETURN;
    END;

    IF lsStatusType IN (iapiConstant.StatusType_Approved, iapiConstant.StatusType_Current)
    AND lsStatusDesc IS NOT NULL THEN
        SELECT characteristic_id
        INTO lnValueId
        FROM characteristic
        WHERE characteristic_id IN (
          SELECT characteristic
          FROM characteristic_association
          WHERE association = 141 -- QR phase
        ) AND description LIKE lsStatusDesc || ': %';
        
        UPDATE specification_prop
        SET characteristic = lnValueId
        WHERE part_no = iapiSpecificationStatus.gtStatusChange(0).PartNo
        AND revision = iapiSpecificationStatus.gtStatusChange(0).Revision
        AND section_id = 700755 -- SAP information
        AND sub_section_id = 0 -- (none)
        AND property_group = 704540 -- SAP information
        AND property = 715448; -- QR phase
    END IF;
EXCEPTION
WHEN OTHERS THEN
    lnRetVal := iapiGeneral.AddErrorToList(csMethod, SQLERRM, iapiSpecificationStatus.gtErrors);
    iapiGeneral.LogError(psSource, csMethod, SQLERRM);
END;


END APAO_PRE_POST_FUNC;

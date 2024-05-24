CREATE OR REPLACE PACKAGE APAO_PRE_POST_FUNC AS
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
-- 23/01/2013 | RS        | Added SetPEDInSync
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
-- 24/04/2008  | AF        | Created
--------------------------------------------------------------------------------
PROCEDURE SetMultiLanguage;

--------------------------------------------------------------------------------
-- FUNCTION : LocalizeFrameData
-- ABSTRACT : This function will localize plant-specific Access_Group and
--            Workflow_Group from used frame to current specification
--------------------------------------------------------------------------------
FUNCTION LocalizeFrameData(
    avs_part_no       IN iapiType.PartNo_Type,
    avn_accessgroup   IN OUT iapiType.ID_Type,
    avn_workflowgroup IN OUT iapiType.ID_Type
) RETURN iapiType.ErrorNum_Type;

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
PROCEDURE CopyFrameData_copy;

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
PROCEDURE CopyFrameData_create;

--------------------------------------------------------------------------------
-- PROCEDURE : CopyFrameKeywords_copy
--  ABSTRACT : This function will copy the frame keywords Function and 
--             Spec. Function when copy a specification
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
PROCEDURE CopyFrameKeywords_copy;

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
PROCEDURE CopyFrameKeywords_create;

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
PROCEDURE SetPEDInSync;

PROCEDURE GenerateConstructionCode;

PROCEDURE CleanDSpecObjects;

PROCEDURE CleanHyperMaterialFiles;


PROCEDURE MergeAttachedSpecs (
    avs_part_no  IN iapiType.PartNo_Type,
    avn_revision IN iapiType.Revision_Type,
    avt_errors   IN OUT ErrorDataTable_Type,
    avn_msg_type IN iapiType.ErrorMessageType_Type DEFAULT iapiConstant.ErrorMessage_Error
);

PROCEDURE MergeAttachedSpecs_save;
PROCEDURE MergeAttachedSpecs_status;
PROCEDURE MergeAttachedSpecs_copy;

PROCEDURE ClearSapCode;

PROCEDURE ValidateBasedUpon(
    avs_part_no     IN iapiType.PartNo_Type,
    avn_revision    IN iapiType.Revision_Type,
    avn_section     IN iapiType.Id_Type,
    avn_sub_section IN iapiType.Id_Type,
    avn_property    IN iapiType.Id_Type,
    avn_attspec_ref IN iapiType.Id_Type,
    avt_errors      IN OUT ErrorDataTable_Type
);

PROCEDURE ValidateBasedUpon_prop;
PROCEDURE ValidateBasedUpon_attspec;


END APAO_PRE_POST_FUNC;

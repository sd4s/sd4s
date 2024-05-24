CREATE OR REPLACE PACKAGE BODY APAO_VALIDATE AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAO_VALIDATE
-- ABSTRACT : This package containts validation functions which can be used
--            on statuschanged
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
-- 08/05/2008 | AF        | Added function Specification_Reference
-- 15/05/2008 | AF        | Added function GetFrameData
-- 15/05/2008 | AF        | Added function CopyFrameData
-- 15/05/2008 | AF        | Added function CopyKeywords
-- 15/05/2008 | AF        | Added function CopyFrameKeywords
-- 21/05/2008 | AF        | Altered function GetFrameData
-- 21/05/2008 | AF        | Altered function CopyKeywords
-- 21/05/2008 | AF        | Altered function CopyFrameData
-- 21/05/2008 | AF        | Altered function CopyFrameKeywords
-- 29/05/2008 | AF        | Added function CopyManKeywords
-- 29/05/2008 | AF        | Added function AddStatusKeywords
-- 29/05/2008 | AF        | Added function CodingConvention
-- 19/06/2008 | RS        | Changed function CodingConvention : Bug error message
-- 25/06/2008 | RS        | Changed function CopyFrameData
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
psSource CONSTANT iapiType.Source_Type := 'APAO_VALIDATE';

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
-- FUNCTION  : Supplier_Code
--  ABSTRACT : This function will check if the Supplier Code differs from <any>
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
FUNCTION Supplier_Code
RETURN iapiType.ErrorNum_Type IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
csMethod CONSTANT iapiType.Method_Type := 'Supplier_Code';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lnRetVal            iapiType.ErrorNum_Type;
lviKwValue          PLS_INTEGER;
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
   
   -----------------------------------------------------------------------------
   -- Checking if the keyword Supplier Code is present
   -- This keyword must always be present. If not present then raise an 
   -- exception
   -----------------------------------------------------------------------------
   SELECT COUNT(*)
     INTO lviKwValue
     FROM specification_header a, itkw b, specification_kw c
    WHERE a.part_no         = iapiSpecificationValidation.gsPartNo
      AND c.kw_id           = b.kw_id
      AND a.part_no         = c.part_no
      AND b.description     = 'Supplier code';
      
   IF lviKwValue = 0 THEN
      iapiGeneral.LogInfo(psSource, csMethod, 'Keyword Supplier code not present!');
      RETURN -20365;
   END IF; 
   
   -----------------------------------------------------------------------------
   -- Checking the value of the keyword Supplier Code
   -----------------------------------------------------------------------------
   SELECT COUNT(*)
     INTO lviKwValue
     FROM specification_header a, itkw b, specification_kw c
    WHERE a.part_no         = iapiSpecificationValidation.gsPartNo
      AND c.kw_id           = b.kw_id
      AND a.part_no         = c.part_no
      AND b.description     = 'Supplier code'
      AND UPPER(c.kw_value) = '<ANY>';

   -----------------------------------------------------------------------------
   -- Check if the value differs from <any>
   -----------------------------------------------------------------------------
   IF lviKwValue = 0 THEN
      RETURN iapiConstantDbError.DBERR_SUCCESS;
   ELSE
      iapiGeneral.LogInfo(psSource, csMethod, 'One or more specification keyword value equal to <Any>');
      RETURN -20361;
   END IF;

EXCEPTION
   WHEN OTHERS THEN
      iapiGeneral.LogError(psSource, csMethod, SQLERRM);
END Supplier_Code;

--------------------------------------------------------------------------------
-- FUNCTION  : Spec_Reference
--  ABSTRACT : This function will check if the Specification reference
--             property is filled
--------------------------------------------------------------------------------
--    WRITER : Arie Frans Kok
--  REVIEWER :
--      DATE : 08/05/2008
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
-- 08/05/2008  | AF        | Created
-- 10/03/2011  | RS        | Upgrade V6.3
--------------------------------------------------------------------------------
FUNCTION Spec_Reference
RETURN iapiType.ErrorNum_Type IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
csMethod CONSTANT iapiType.Method_Type := 'Spec_Reference';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lnRetVal            iapiType.ErrorNum_Type;
lviSpecRef          PLS_INTEGER;
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
   
   -----------------------------------------------------------------------------
   -- Checking if the property Specification reference is present
   -- This property must always be present. If not present then raise an 
   -- exception
   -----------------------------------------------------------------------------
   SELECT COUNT(*)
     INTO lviSpecRef
     FROM specification_prop a, property b
    WHERE a.part_no         = iapiSpecificationValidation.gsPartNo
      AND a.revision        = iapiSpecificationValidation.gnRevision
      AND b.description     = 'Specification reference'
      AND a.property        = b.property;
      
   IF lviSpecRef = 0 THEN
      iapiGeneral.LogInfo(psSource, csMethod, 'Specification Reference property not present within part_no <'||iapiSpecificationValidation.gsPartNo||'>. This is not allowed!');
      RETURN -20366;
   END IF; 

   -----------------------------------------------------------------------------
   -- Checking the value of the property Specification reference
   -----------------------------------------------------------------------------
   SELECT COUNT(*)
     INTO lviSpecRef
     FROM specification_prop a, property b
    WHERE a.part_no         = iapiSpecificationValidation.gsPartNo
      and a.revision        = iapiSpecificationValidation.gnRevision
      AND b.description     = 'Specification reference'
      AND a.property        = b.property
      and char_1 IS NULL;

   -----------------------------------------------------------------------------
   -- Check if the value there are no empty properties
   -----------------------------------------------------------------------------
   IF lviSpecRef > 0 THEN
      iapiGeneral.LogInfo(psSource, csMethod, 'One or more Specification Reference properties are empty within part_no <'||iapiSpecificationValidation.gsPartNo||'>! This is not allowed!');
      RETURN -20362;
   ELSE
      iapiGeneral.LogInfo(psSource, csMethod, 'There are no empty Specification References found!');
      RETURN iapiConstantDbError.DBERR_SUCCESS;
   END IF;

EXCEPTION
   WHEN OTHERS THEN
      iapiGeneral.LogError(psSource, csMethod, SQLERRM);

      RETURN iapiConstantDbError.DBERR_GENFAIL;
END Spec_Reference;

--------------------------------------------------------------------------------
-- FUNCTION  : GetFrameData
--  ABSTRACT : This function will get the accessgroup, workflowgroup and
--             specification_type (class3Id) from the frame used to copy or
--             create from
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
-- 21/05/2008  | AF        | Added exception handler to SELECT
--------------------------------------------------------------------------------
FUNCTION GetFrameData (avs_frame_no      IN  VARCHAR2,
                       avn_revision      IN  NUMBER,
                       avn_accessgroup   OUT NUMBER,
                       avn_workflowgroup OUT NUMBER,
                       avn_class3id      OUT NUMBER)
RETURN iapiType.ErrorNum_Type IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
csMethod CONSTANT iapiType.Method_Type := 'GetFrameData';

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
   
   iapiGeneral.LogInfo(psSource, csMethod, 'Used frame number   = <'||avs_frame_no||'>');
   iapiGeneral.LogInfo(psSource, csMethod, 'Used frame revision = <'||avn_revision||'>');

   BEGIN
      SELECT access_group, workflow_group_id, class3_id
        INTO avn_accessgroup, avn_workflowgroup, avn_class3id
        FROM frame_header
       WHERE frame_no = avs_frame_no
         AND revision = avn_revision;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         iapiGeneral.LogError(psSource, csMethod, 'Frame <'||avs_frame_no||'> with revision <'||avn_revision||'> not found in tabel <FRAME_HEADER>');
      WHEN OTHERS THEN
         iapiGeneral.LogError(psSource, csMethod, 'Unknown error while getting info for Frame <'||avs_frame_no||'> with revision <'||avn_revision||'> not found in tabel <FRAME_HEADER>. '||SQLERRM);
   END;

   iapiGeneral.LogInfo(psSource, csMethod, 'Found Access_group = <'     ||avn_accessgroup  ||'>');
   iapiGeneral.LogInfo(psSource, csMethod, 'Found Workflow_group_id = <'||avn_workflowgroup||'>');
   iapiGeneral.LogInfo(psSource, csMethod, 'Found Class3ID = <'         ||avn_class3id     ||'>');

   RETURN iapiConstantDbError.DBERR_SUCCESS;

EXCEPTION
   WHEN OTHERS THEN
      iapiGeneral.LogError(psSource, csMethod, SQLERRM);

   RETURN iapiConstantDbError.DBERR_GENFAIL;
END GetFrameData;

--------------------------------------------------------------------------------
-- FUNCTION  : CopyKeywords
--  ABSTRACT : This function will copy the frame keywords Function and
--             Spec. Function from the frame used to copy or create from
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
-- 21/05/2008  | AF        | Added exception to INSERT/SELECT
--------------------------------------------------------------------------------
FUNCTION CopyKeywords (avs_part_no  IN VARCHAR2,
                       avs_frame_no IN  VARCHAR2)
RETURN iapiType.ErrorNum_Type IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
csMethod CONSTANT iapiType.Method_Type := 'CopyKeywords';

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
   
   iapiGeneral.LogInfo(psSource, csMethod, 'Remove the present keywords');

   -----------------------------------------------------------------------------
   -- Delete the
   -----------------------------------------------------------------------------
   DELETE
     FROM specification_kw
    WHERE part_no = avs_part_no
      AND kw_id in (SELECT kw_id
                      FROM itkw
                     WHERE description IN ('Function','Spec. Function'));
                     
   DELETE
     FROM specification_kw_h
    WHERE part_no = avs_part_no
      AND kw_id in (SELECT kw_id
                      FROM itkw
                     WHERE description IN ('Function','Spec. Function'));

   iapiGeneral.LogInfo(psSource, csMethod, 'Add the copied (present) keywords from frame');

   BEGIN
      INSERT
        INTO specification_kw (PART_NO, KW_ID, KW_VALUE, INTL)
      SELECT avs_part_no, KW_ID, KW_VALUE, INTL
        FROM frame_kw
       WHERE frame_no = avs_frame_no
         AND kw_id in (SELECT kw_id
                         FROM itkw
                        WHERE description IN ('Function','Spec. Function'));
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         iapiGeneral.LogInfo(psSource, csMethod, 'No keywords found to copy for part_no <'||avs_part_no||'>');
      WHEN OTHERS THEN
         iapiGeneral.LogInfo(psSource, csMethod, 'Unknown error while trying to copy keywords for part_no <'||avs_part_no||'>. '||SQLERRM);
   END;

   RETURN iapiConstantDbError.DBERR_SUCCESS;

EXCEPTION
   WHEN OTHERS THEN
      iapiGeneral.LogError(psSource, csMethod, SQLERRM);

   RETURN iapiConstantDbError.DBERR_GENFAIL;
END CopyKeywords;

--------------------------------------------------------------------------------
-- FUNCTION : CopyFrameData
-- ABSTRACT : This function will copy the frame data for Access_Group,
--            Workflow_Group and Specification_type from used frame to current
--            specification
--------------------------------------------------------------------------------
--   WRITER : Arie Frans Kok
-- REVIEWER :
--     DATE : 15/05/2008
--   TARGET :
--  VERSION : 6.3.0.1.0
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
-- 15/05/2008 | AF        | Created
-- 21/05/2008 | AF        | Added exception to SELECT
-- 19/06/2008 | RS        | Return genfail to force a refresh on the client
-- 25/06/2008 | RS        | Do also update the part table
--------------------------------------------------------------------------------
FUNCTION CopyFrameData
RETURN iapiType.ErrorNum_Type IS

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

lvs_frame_no        VARCHAR2(18);
lvn_frame_revision  NUMBER;
lvn_accessgroup     NUMBER;
lvn_workflowgroup   NUMBER;
lvn_class3id        NUMBER;

lvn_accessgroup_edit    NUMBER;
lvn_workflowgroup_edit  NUMBER;
lvn_class3id_edit       NUMBER;
asPreferenceValue       iapiType.PreferenceValue_Type;
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
   
   iapiGeneral.LogInfo(psSource, csMethod, 'Start getting frame number and revision');

   -----------------------------------------------------------------------------
   -- Get the frame_no and revision used to create the specification
   -----------------------------------------------------------------------------
   BEGIN
      SELECT frame_id, frame_rev, 
             access_group, workflow_group_id, class3_id
        INTO lvs_frame_no, lvn_frame_revision, 
             lvn_accessgroup_edit, lvn_workflowgroup_edit, lvn_class3id_edit 
        FROM specification_header
       WHERE part_no  = iapiSpecificationValidation.gsPartNo
         AND revision = iapiSpecificationValidation.gnRevision;
   EXCEPTION
       WHEN NO_DATA_FOUND THEN
          iapiGeneral.LogInfo(psSource, csMethod, 'Specification <'||iapiSpecificationValidation.gsPartNo||'> not found in table <SPECIFICATION_HEADER>');
       WHEN OTHERS THEN
          iapiGeneral.LogInfo(psSource, csMethod, 'Unknown error while getting the frame and revision for specification <'||iapiSpecificationValidation.gsPartNo||'>');
   END;

   iapiGeneral.LogInfo(psSource, csMethod, 'Frame number <'||lvs_frame_no||'> and revision <'||lvn_frame_revision||'');
   iapiGeneral.LogInfo(psSource, csMethod, 'End getting frame number and revision');

   iapiGeneral.LogInfo(psSource, csMethod, 'Start getting Frame Data');

   -----------------------------------------------------------------------------
   -- Getting the stored frame data
   -----------------------------------------------------------------------------
   lnRetVal := APAO_VALIDATE.GetFrameData(avs_frame_no     =>lvs_frame_no,
                                          avn_revision     =>lvn_frame_revision,
                                          avn_accessgroup  =>lvn_accessgroup,
                                          avn_workflowgroup=>lvn_workflowgroup,
                                          avn_class3id     =>lvn_class3id);

   iapiGeneral.LogInfo(psSource, csMethod, 'End getting Frame Data');
 
   IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS THEN
      lnRetVal := apao_pre_post_func.LocalizeFrameData(iapiSpecificationValidation.gsPartNo, lvn_accessgroup, lvn_workflowgroup);

      IF (lnRetVal <> iapiConstantDbError.DBERR_SUCCESS) THEN
          iapiGeneral.LogError(psSource, csMethod, iapiGeneral.GetLastErrorText());
      END IF;
   END IF;
   
   -----------------------------------------------------------------------------
   -- Only continue when function returned a success
   -----------------------------------------------------------------------------
   IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS THEN
      iapiGeneral.LogInfo(psSource, csMethod, 'Start updating the accessgroup, workflowgroup and specification_type');
      
      IF lvn_accessgroup != lvn_accessgroup_edit OR
         lvn_workflowgroup != lvn_workflowgroup_edit OR
         lvn_class3id != lvn_class3id_edit THEN
         
         UPDATE specification_header
            SET access_group      = lvn_accessgroup,
                workflow_group_id = lvn_workflowgroup,
                class3_id         = lvn_class3id
          WHERE part_no  = iapiSpecificationValidation.gsPartNo
            AND revision = iapiSpecificationValidation.gnRevision;
         
         UPDATE part
            SET part_type = lvn_class3id
          WHERE part_no  = iapiSpecificationValidation.gsPartNo;
          
         COMMIT;

         iapiGeneral.LogInfo(psSource, csMethod, 'End updating the accessgroup, workflowgroup and specification_type');
            
         RETURN iapiConstantDbError.DBERR_GENFAIL;-- RS 19062008
      END IF;      
   END IF;

   RETURN iapiConstantDbError.DBERR_SUCCESS;

EXCEPTION
   WHEN OTHERS THEN
      iapiGeneral.LogError(psSource, csMethod, SQLERRM);

      RETURN iapiConstantDbError.DBERR_GENFAIL;
END CopyFrameData;

--------------------------------------------------------------------------------
-- FUNCTION : CopyFrameKeywords
-- ABSTRACT : This function will copy the frame keywords Function and
--            Spec. Function
--------------------------------------------------------------------------------
--   WRITER : Arie Frans Kok
-- REVIEWER :
--     DATE : 15/05/2008
--   TARGET :
--  VERSION : 6.3.0.1.0
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
-- 15/05/2008 | AF        | Created
-- 21/05/2008 | AF        | Added an exception handler around the SELECT
--------------------------------------------------------------------------------
FUNCTION CopyFrameKeywords
RETURN iapiType.ErrorNum_Type IS

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

lvs_frame_no        VARCHAR2(18);
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
   
   iapiGeneral.LogInfo(psSource, csMethod, 'Start getting frame number');

   -----------------------------------------------------------------------------
   -- Get the frame_no and revision used to create the specification
   -----------------------------------------------------------------------------
   BEGIN
      SELECT frame_id
        INTO lvs_frame_no
        FROM specification_header
       WHERE part_no  = iapiSpecificationValidation.gsPartNo
         AND revision = iapiSpecificationValidation.gnRevision;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
        iapiGeneral.LogInfo(psSource, csMethod, 'Specification <'||iapiSpecificationValidation.gsPartNo||'> not found in table <SPECIFICATION_HEADER>');
      WHEN OTHERS THEN
        iapiGeneral.LogInfo(psSource, csMethod, 'Unknown error while getting the frame_id for specification <'||iapiSpecificationValidation.gsPartNo||'>');
   END;

   iapiGeneral.LogInfo(psSource, csMethod, 'Frame number <'||lvs_frame_no||'>');
   iapiGeneral.LogInfo(psSource, csMethod, 'End getting frame number');

   iapiGeneral.LogInfo(psSource, csMethod, 'Start copying frame keywords');

   -----------------------------------------------------------------------------
   -- Getting the stored frame data
   -----------------------------------------------------------------------------
   lnRetVal := APAO_VALIDATE.COPYKEYWORDS(avs_part_no =>iapiSpecificationValidation.gsPartNo,
                                          avs_frame_no=>lvs_frame_no);

   COMMIT;

   iapiGeneral.LogInfo(psSource, csMethod, 'End copying frame keywords');

   RETURN iapiConstantDbError.DBERR_SUCCESS;

EXCEPTION
   WHEN OTHERS THEN
      iapiGeneral.LogError(psSource, csMethod, SQLERRM);

      RETURN iapiConstantDbError.DBERR_GENFAIL;
END CopyFrameKeywords;

--------------------------------------------------------------------------------
-- FUNCTION : CopyManKeywords
-- ABSTRACT : This function will add/overwrite the manufacturer and Manufacturer  
--            site keywords to the specification
--------------------------------------------------------------------------------
--   WRITER : Arie Frans Kok
-- REVIEWER :
--     DATE : 29/05/2008
--   TARGET :
--  VERSION : 6.3.0.1.0
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
-- 29/05/2008 | AF        | Created
--------------------------------------------------------------------------------
FUNCTION CopyManKeywords
RETURN iapiType.ErrorNum_Type IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
csMethod CONSTANT iapiType.Method_Type := 'CopyManKeywords';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------
CURSOR lvq_manufacturers IS
   SELECT part_no, mfc_id, mpl_id
     FROM itprmfc
    WHERE part_no =iapiSpecificationValidation.gsPartNo; 

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lnRetVal              iapiType.ErrorNum_Type;
lvn_kw_id_man         NUMBER;
lvn_kw_id_man_site    NUMBER;
lvs_manufacturer      VARCHAR2(60);
lvs_manufacturer_site VARCHAR2(60);
asPreferenceValue     iapiType.PreferenceValue_Type;
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
   
   iapiGeneral.LogInfo(psSource, csMethod, 'Start removing keywords');

   -----------------------------------------------------------------------------
   -- First remove the keywords Manufacturer and Manufacturer Site
   -----------------------------------------------------------------------------
   DELETE 
     FROM specification_kw 
    WHERE part_no = iapiSpecificationValidation.gsPartNo 
      AND kw_id IN (SELECT kw_id 
                      FROM itkw 
                     WHERE description IN ('Manufacturer','Manufacturer site'));

   
   iapiGeneral.LogInfo(psSource, csMethod, 'Start adding Manufacturer and Manufacturer site keywords');
   
   -----------------------------------------------------------------------------
   -- Second get the values for the Manufacturer and the Manufacturer site
   -----------------------------------------------------------------------------
   FOR lvr_manufacturers in lvq_manufacturers LOOP
      BEGIN
         SELECT description
           INTO lvs_manufacturer
           FROM itmfc
          WHERE mfc_id = lvr_manufacturers.mfc_id;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            iapiGeneral.LogInfo(psSource, csMethod, 'No manufacturer data found for specification <'||iapiSpecificationValidation.gsPartNo||'>');
         WHEN OTHERS THEN
            iapiGeneral.LogInfo(psSource, csMethod, 'Unkown error while trying to get the manufacturer data for specification <'||iapiSpecificationValidation.gsPartNo||'>');
      END;
      
      BEGIN
         SELECT description
           INTO lvs_manufacturer_site
           FROM itmpl
          WHERE mpl_id = lvr_manufacturers.mpl_id;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            iapiGeneral.LogInfo(psSource, csMethod, 'No manufacturer site data found for specification <'||iapiSpecificationValidation.gsPartNo||'>');
         WHEN OTHERS THEN
            iapiGeneral.LogInfo(psSource, csMethod, 'Unkown error while trying to get the manufacturer site data for specification <'||iapiSpecificationValidation.gsPartNo||'>');
      END;
      
      -----------------------------------------------------------------------------
      -- Finally let's insert the keywords
      -----------------------------------------------------------------------------
      IF NVL(lvs_manufacturer,'EMPTY') <> 'EMPTY' THEN
         BEGIN
            INSERT
              INTO specification_kw (PART_NO, KW_ID, KW_VALUE, INTL)
            SELECT iapiSpecificationValidation.gsPartNo, KW_ID, lvs_manufacturer, INTL
              FROM itkw
             WHERE description IN ('Manufacturer');
         EXCEPTION
            WHEN OTHERS THEN
               iapiGeneral.LogInfo(psSource, csMethod, 'Unknown error while trying to insert Manufacturer keyword for specification <'||iapiSpecificationValidation.gsPartNo||'>. '||SQLERRM);
         END;
      END IF;
      
      IF NVL(lvs_manufacturer_site,'EMPTY') <> 'EMPTY' THEN
         BEGIN
            INSERT
              INTO specification_kw (PART_NO, KW_ID, KW_VALUE, INTL)
            SELECT iapiSpecificationValidation.gsPartNo, KW_ID, lvs_manufacturer_site, INTL
              FROM itkw
             WHERE description IN ('Manufacturer site');
         EXCEPTION
            WHEN OTHERS THEN
               iapiGeneral.LogInfo(psSource, csMethod, 'Unknown error while trying to insert Manufacturer site keyword for specification <'||iapiSpecificationValidation.gsPartNo||'>. '||SQLERRM);
         END;
      END IF;
   END LOOP;

   COMMIT;

   iapiGeneral.LogInfo(psSource, csMethod, 'End adding Manufacturer and Manufacturer site keywords');

   RETURN iapiConstantDbError.DBERR_SUCCESS;

EXCEPTION
   WHEN OTHERS THEN
      iapiGeneral.LogError(psSource, csMethod, SQLERRM);

      RETURN iapiConstantDbError.DBERR_GENFAIL;
END CopyManKeywords;

--------------------------------------------------------------------------------
-- FUNCTION : AddStatusKeyword
-- ABSTRACT : This function will add/overwrite the Status keyword. The value
--            will be the last three characters of the status SORT_DESCR from
--            the table status
--------------------------------------------------------------------------------
--   WRITER : Arie Frans Kok
-- REVIEWER :
--     DATE : 29/05/2008
--   TARGET :
--  VERSION : 6.3.0.1.0
--------------------------------------------------------------------------------
--            Errorcode               | Description
-- ===================================|=========================================
--   ERRORS :                         |
--------------------------------------------------------------------------------
--  REMARKS : -
--------------------------------------------------------------------------------
--  CHANGES :
--
-- When       | Who       | What
-- ===========|===========|=====================================================
-- 29/05/2008 | AF        | Created
--------------------------------------------------------------------------------
FUNCTION AddStatusKeyword
RETURN iapiType.ErrorNum_Type IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
csMethod CONSTANT iapiType.Method_Type := 'AddStatusKeyword';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lnRetVal              iapiType.ErrorNum_Type;
lvs_status_descr      VARCHAR2(3);
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
   
   iapiGeneral.LogInfo(psSource, csMethod, 'Start adding Status keyword');
   
   -----------------------------------------------------------------------------
   -- Get the status of the specification
   -----------------------------------------------------------------------------
   BEGIN
      SELECT SUBSTR(b.sort_desc,-3)
        INTO lvs_status_descr
        FROM specification_header a, status b
       WHERE part_no  = iapiSpecificationValidation.gsPartNo
         AND revision = iapiSpecificationValidation.gnRevision
         AND a.status = b.status;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         iapiGeneral.LogInfo(psSource, csMethod, 'Error while getting the status for specification <'||iapiSpecificationValidation.gsPartNo||'>');
      WHEN OTHERS THEN
         iapiGeneral.LogInfo(psSource, csMethod, 'Unkown error while getting the status for specification <'||iapiSpecificationValidation.gsPartNo||'>. '||SQLERRM);
   END;

   IF NVL(lvs_status_descr,'EMPTY') <> 'EMPTY' THEN
      BEGIN
         DELETE
           FROM specification_kw
          WHERE part_no = iapiSpecificationValidation.gsPartNo
            AND kw_id in (SELECT kw_id
                            FROM itkw
                           WHERE description = 'Quality review level');
                           
         DELETE
           FROM specification_kw_h
          WHERE part_no = iapiSpecificationValidation.gsPartNo
            AND kw_id in (SELECT kw_id
                            FROM itkw
                           WHERE description = 'Quality review level');   
      
      
         INSERT
           INTO specification_kw (PART_NO, KW_ID, KW_VALUE, INTL)
         SELECT iapiSpecificationValidation.gsPartNo, KW_ID, lvs_status_descr, INTL
           FROM itkw
          WHERE description IN ('Quality review level');
      EXCEPTION
         WHEN OTHERS THEN
            iapiGeneral.LogInfo(psSource, csMethod, 'Unknown error while trying to insert Status keyword for specification <'||iapiSpecificationValidation.gsPartNo||'>. '||SQLERRM);
      END;
   END IF;

   COMMIT;

   iapiGeneral.LogInfo(psSource, csMethod, 'End adding Status keywords');

   RETURN iapiConstantDbError.DBERR_SUCCESS;

EXCEPTION
   WHEN OTHERS THEN
      iapiGeneral.LogError(psSource, csMethod, SQLERRM);

      RETURN iapiConstantDbError.DBERR_GENFAIL;
END AddStatusKeyword;

--------------------------------------------------------------------------------
-- FUNCTION  : CodingConvention
--  ABSTRACT : This function will if the used part_no agree the allowed spectype
--------------------------------------------------------------------------------
--    WRITER : Arie Frans Kok
--  REVIEWER :
--      DATE : 29/05/2008
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
-- 29/05/2008 | AF        | Created
--------------------------------------------------------------------------------
FUNCTION CodingConvention
RETURN iapiType.ErrorNum_Type IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
csMethod CONSTANT iapiType.Method_Type := 'CodingConvention';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lnRetVal            iapiType.ErrorNum_Type;
lvs_sort_desc       VARCHAR2(60);
lvs_frame_id        iapiType.FrameNo_Type;
lvn_spec_type       iapiType.Id_Type;
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
   
   iapiGeneral.LogInfo(psSource, csMethod, 'Start getting the specification_type');
   
   -----------------------------------------------------------------------------
   -- Getting the Specification_type
   -----------------------------------------------------------------------------
   BEGIN
      SELECT frame_id, sort_desc
        INTO lvs_frame_id, lvs_sort_desc
        FROM class3 a, specification_header b
       WHERE a.class    = lvn_spec_type
         AND b.part_no  = iapiSpecificationValidation.gsPartNo
         AND b.revision = iapiSpecificationValidation.gnRevision;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         iapiGeneral.LogInfo(psSource, csMethod, 'Error getting the specification_type for specification <'||iapiSpecificationValidation.gsPartNo||'>. Specification not found!');
      WHEN OTHERS THEN
         iapiGeneral.LogInfo(psSource, csMethod, 'Unkown error while getting the specification type for specification <'||iapiSpecificationValidation.gsPartNo||'>. '||SQLERRM);      
   END;
   
   iapiGeneral.LogInfo(psSource, csMethod, 'End getting the specification_type');

   -----------------------------------------------------------------------------
   -- Check if the value differs from <any>
   -----------------------------------------------------------------------------
   IF UPPER(SUBSTR(iapiSpecificationValidation.gsPartNo,1,1)) = 'X' AND UPPER(SUBSTR(lvs_sort_desc,1,3)) <> 'TCE' THEN
      --Allow raw materials
      IF lvs_frame_id LIKE 'A_RM_%'
      OR lvs_frame_id LIKE 'A_Man_RM_%' THEN
         RETURN iapiConstantDbError.DBERR_SUCCESS;
      ELSE
         iapiGeneral.LogInfo(psSource, csMethod, 'Trial code is used with production frame');
         RETURN -20364;
      END IF;
   ELSIF UPPER(SUBSTR(iapiSpecificationValidation.gsPartNo,1,1)) <> 'X' AND UPPER(SUBSTR(lvs_sort_desc,1,3)) = 'TCE' THEN
      iapiGeneral.LogInfo(psSource, csMethod, 'Trial frame is used and Partno. does not start with an "X". Please change before submitting.');
      RETURN -20363;
   ELSE
      RETURN iapiConstantDbError.DBERR_SUCCESS;
   END IF;

EXCEPTION
   WHEN OTHERS THEN
      iapiGeneral.LogError(psSource, csMethod, SQLERRM);
END CodingConvention;


FUNCTION ValidateSapCode
RETURN iapiType.ErrorNum_Type
AS
    csMethod CONSTANT iapiType.Method_Type := 'ValidateSapCode';
    
    lnCount  iapiType.NumVal_Type;
    lsValue  iapiType.Description_Type;
    lnType   iapiType.Id_Type;
    lnErrVal iapiType.ErrorNum_Type;
    lsErrMsg iapiType.String_Type;
BEGIN
    SELECT class3_id
    INTO lnType
    FROM specification_header
    WHERE part_no = iapiSpecificationValidation.gsPartNo
    AND revision = iapiSpecificationValidation.gnRevision;

    IF lnType IN (
      --700303, --Spec type AT
      --700394, --Spec type SM
      700309 --Spec type PCT
    ) AND NOT iapiSpecificationValidation.gsPartNo LIKE 'X%' THEN --Spec is not Trial
        lnErrVal := -20922; --Missing property value
        
        SELECT COUNT(char_1)
        INTO lnCount
        FROM specification_prop
        WHERE part_no = iapiSpecificationValidation.gsPartNo
        AND revision = iapiSpecificationValidation.gnRevision
        AND section_id = 700755 --SAP information
        AND sub_section_id = 0 --(none)
        AND property_group = 704056	--SAP articlecode
        AND property = 713824 --Commercial article code
        AND attribute = 0;
    
        IF lnCount = 0 THEN
            SELECT description
            INTO lsValue
            FROM property
            WHERE property = 713824;
            
            RETURN iapiGeneral.SetErrorText(lnErrVal, lsValue);
        END IF;
    
        /*
        SELECT COUNT(char_1)
        INTO lnCount
        FROM specification_prop
        WHERE part_no = iapiSpecificationValidation.gsPartNo
        AND revision = iapiSpecificationValidation.gnRevision
        AND section_id = 700755 --SAP information
        AND sub_section_id = 0 --(none)
        AND property_group = 704056	--SAP articlecode
        AND property = 713825  --Commercial DA article code
        AND attribute = 0;
        
        IF lnCount = 0 THEN
            SELECT description
            INTO lsValue
            FROM property
            WHERE property = 713825;
            
            RETURN iapiGeneral.SetErrorText(lnErrVal, lsValue);
        END IF;
        */
    
        SELECT COUNT(characteristic)
        INTO lnCount
        FROM specification_prop
        WHERE part_no = iapiSpecificationValidation.gsPartNo
        AND revision = iapiSpecificationValidation.gnRevision
        AND section_id = 700755 --SAP information
        AND sub_section_id = 0 --(none)
        AND property_group IN (704540, 0) --SAP information or single property
        AND property = 705428 --Article group PG
        AND attribute = 0;
    
        IF lnCount = 0 THEN
            SELECT description
            INTO lsValue
            FROM property
            WHERE property = 705428;
            
            RETURN iapiGeneral.SetErrorText(lnErrVal, lsValue);
        END IF;
        
    -------------------------------------------------------------------
        lnErrVal := -20928; --Duplicate property value

        SELECT COUNT(*), MAX(part_no)
        INTO lnCount, lsValue
        FROM specification_prop
        LEFT JOIN specification_header USING (part_no, revision)
        WHERE part_no != iapiSpecificationValidation.gsPartNo
        AND UPPER(part_no) NOT LIKE 'X%'
        AND part_no LIKE REGEXP_SUBSTR(iapiSpecificationValidation.gsPartNo, '^[^-_]+[-_]?') || '%'
        AND status NOT IN (SELECT status FROM status WHERE status_type IN ('HISTORIC'))
        AND section_id = 700755 --SAP information
        AND sub_section_id = 0 --(none)
        AND property_group = 704056	--SAP articlecode
        AND property IN (
          713824, --Commercial article code
          713825  --Commercial DA article code
        )
        AND attribute = 0
        AND char_1 = (
          SELECT char_1
          FROM specification_prop
          WHERE part_no = iapiSpecificationValidation.gsPartNo
          AND revision = iapiSpecificationValidation.gnRevision
          AND section_id = 700755 --SAP information
          AND sub_section_id = 0 --(none)
          AND property_group = 704056	--SAP articlecode
          AND property = 713824 --Commercial article code
          AND attribute = 0
        )
        AND ROWNUM = 1;
    
        IF lnCount > 0 THEN
            iapiGeneral.LogError(psSource, csMethod, 'Spec found with duplicate SAP code: ' || lsValue);
            RETURN iapiGeneral.SetErrorText(lnErrVal, lsValue);
        END IF;
         
        SELECT COUNT(*), MAX(part_no)
        INTO lnCount, lsValue
        FROM specification_prop
        LEFT JOIN specification_header USING (part_no, revision)
        WHERE part_no != iapiSpecificationValidation.gsPartNo
        AND UPPER(part_no) NOT LIKE 'X%'
        AND part_no LIKE REGEXP_SUBSTR(iapiSpecificationValidation.gsPartNo, '^[^-_]+[-_]?') || '%'
        AND status NOT IN (SELECT status FROM status WHERE status_type IN ('HISTORIC'))
        AND section_id = 700755 --SAP information
        AND sub_section_id = 0 --(none)
        AND property_group = 704056	--SAP articlecode
        AND property IN (
          713824, --Commercial article code
          713825  --Commercial DA article code
        )
        AND attribute = 0
        AND char_1 = (
          SELECT char_1
          FROM specification_prop
          WHERE part_no = iapiSpecificationValidation.gsPartNo
          AND revision = iapiSpecificationValidation.gnRevision
          AND section_id = 700755 --SAP information
          AND sub_section_id = 0 --(none)
          AND property_group = 704056	--SAP articlecode
          AND property = 713825  --Commercial DA article code
          AND attribute = 0
        )
        AND ROWNUM = 1;
    
        IF lnCount > 0 THEN
            iapiGeneral.LogError(psSource, csMethod, 'Spec found with duplicate SAP code: ' || lsValue);
            RETURN iapiGeneral.SetErrorText(lnErrVal, lsValue);
        END IF;
    END IF;
    
    RETURN iapiConstantDbError.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
    lnErrVal := SQLCODE;
    lsErrMsg := SQLERRM;
    
    iapiGeneral.LogError(psSource, csMethod, lsErrMsg);
    RETURN lnErrVal;
END;

FUNCTION ValidateBasedUpon
RETURN iapiType.ErrorNum_Type
AS
    csMethod CONSTANT iapiType.Method_Type := 'ValidateBasedUpon';
    
    lnCount       iapiType.NumVal_Type;
    lnType        iapiType.Id_Type;
    lsPartNo      iapiType.PartNo_Type;
    lnSection     iapiType.Id_Type;
    lnSubSection  iapiType.Id_Type;
    lnAttSpecRef iapiType.Id_Type;
    lnErrVal     iapiType.ErrorNum_Type;
    lsErrMsg     iapiType.String_Type;
BEGIN
    SELECT class3_id
    INTO lnType
    FROM specification_header
    WHERE part_no = iapiSpecificationValidation.gsPartNo
    AND revision = iapiSpecificationValidation.gnRevision;

    IF lnType IN (
      --700303, --Spec type AT
      --700394, --Spec type SM
      700309 --Spec type PCT
    ) AND NOT iapiSpecificationValidation.gsPartNo LIKE 'X%' THEN --Spec is not Trial
        SELECT section_id, sub_section_id, ref_id
        INTO lnSection, lnSubSection, lnAttSpecRef
        FROM specification_section
        WHERE part_no = iapiSpecificationValidation.gsPartNo
        AND revision = iapiSpecificationValidation.gnRevision
        AND section_id = 700975 --Industrialization
        AND sub_section_id = 0 --(none)
        AND type = 8; --Attached Specification
    
        SELECT COUNT(CASE WHEN attached_revision = 0 THEN 1 END)
        INTO lnCount
        FROM attached_specification
        WHERE part_no = iapiSpecificationValidation.gsPartNo
        AND revision = iapiSpecificationValidation.gnRevision
        AND section_id = lnSection
        AND sub_section_id = lnSubSection
        AND ref_id = lnAttSpecRef;
        
        IF lnCount != 0 THEN
            RAISE_APPLICATION_ERROR(-20923, 'Attached Specifications require a revision. Phantom is not allowed.');
        END IF;

        SELECT char_1
        INTO lsPartNo
        FROM specification_prop
        WHERE part_no = iapiSpecificationValidation.gsPartNo
        AND revision = iapiSpecificationValidation.gnRevision
        AND section_id = lnSection
        AND sub_section_id = lnSubSection
        AND property_group = 0	--default property group
        AND property = 715096 --QR3 release based upon trial
        AND attribute = 0;
    
        IF lnCount != 0 THEN
            SELECT COUNT(*)
            INTO lnCount
            FROM attached_specification
            WHERE part_no = iapiSpecificationValidation.gsPartNo
            AND revision = iapiSpecificationValidation.gnRevision
            AND attached_part_no = lsPartNo
            AND section_id = lnSection
            AND sub_section_id = lnSubSection
            AND ref_id = lnAttSpecRef;
        
            IF lnCount = 0 THEN
                RAISE_APPLICATION_ERROR(-20924, 'Based Upon Spec is not in Attached Specifications.');
            END IF;
        END IF;
    
    END IF;
    
    RETURN iapiConstantDbError.DBERR_SUCCESS;
EXCEPTION
WHEN OTHERS THEN
    lnErrVal := SQLCODE;
    lsErrMsg := SQLERRM;
    
    iapiGeneral.LogError(psSource, csMethod, lsErrMsg);
    RETURN lnErrVal;
END;

--------------------------------------------------------------------------------
-- package initialization-code
--------------------------------------------------------------------------------

END APAO_VALIDATE;

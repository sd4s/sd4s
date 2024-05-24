CREATE OR REPLACE PACKAGE BODY AOPA_VALIDATE_SS AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : AOPA_VALIDATE_SS
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 11/03/2011
--   TARGET : Oracle 10.2.0
--  VERSION : 6.3.0    $Revision: 1 $
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 22/04/2009 | TJR       | Deleted DeletePriceFromBoMHeader;
-- 11/03/2011 | RS        | Upgrade V6.3
-- 07/04/2011 | RS        | Added DeletePriceFromBoMHeader;
-- 29/08-2022 | PS        | Added ValidateThreadlessGreentyre
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
psSource   CONSTANT iapiType.Source_Type := 'AOPA_VALIDATE_SS';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------

FUNCTION SP_COPY_FRAME_DATA
RETURN iapiType.ErrorNum_Type IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
csMethod CONSTANT iapiType.Method_Type   := 'SP_COPY_FRAME_DATA';
lnRetVal iapiType.ErrorNum_Type;
BEGIN

   lnRetVal := APAO_VALIDATE.COPYFRAMEDATA;

   IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS THEN
      RETURN iapiGeneral.SetErrorText( -20367);
   END IF;

   RETURN iapiConstantDbError.DBERR_SUCCESS;

END SP_COPY_FRAME_DATA;

FUNCTION SP_COPY_FRAME_KEYWORDS
RETURN iapiType.ErrorNum_Type IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
csMethod CONSTANT iapiType.Method_Type   := 'SP_COPY_FRAME_KEYWORDS';

BEGIN

   RETURN APAO_VALIDATE.COPYFRAMEKEYWORDS;

END SP_COPY_FRAME_KEYWORDS;

FUNCTION SP_SUPPLIER_CODE
RETURN iapiType.ErrorNum_Type IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
csMethod CONSTANT iapiType.Method_Type   := 'SP_SUPPLIER_CODE';
lnRetVal iapiType.ErrorNum_Type;

BEGIN

   lnRetVal := APAO_VALIDATE.SUPPLIER_CODE;

   IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS THEN
      RETURN iapiGeneral.SetErrorText( -20361);
   END IF;

   RETURN iapiConstantDbError.DBERR_SUCCESS;

END SP_SUPPLIER_CODE;

FUNCTION SP_SPEC_REFERENCE
RETURN iapiType.ErrorNum_Type IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
csMethod CONSTANT iapiType.Method_Type   := 'SP_SPEC_REFERENCE';

BEGIN

   RETURN APAO_VALIDATE.SPEC_REFERENCE;

END SP_SPEC_REFERENCE;

FUNCTION SP_SUPPLIER_REF
RETURN iapiType.ErrorNum_Type IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
csMethod CONSTANT iapiType.Method_Type   := 'SP_SPEC_REFERENCE';
lnRetVal iapiType.ErrorNum_Type;

BEGIN
   lnRetVal := APAO_VALIDATE.SUPPLIER_CODE;

   IF lnRetVal <> iapiConstantDbError.DBERR_SUCCESS THEN
      RETURN iapiGeneral.SetErrorText( lnRetVal);
   ELSE
      lnRetVal := APAO_VALIDATE.SPEC_REFERENCE;

      IF lnRetVal <> iapiConstantDbError.DBERR_SUCCESS THEN
         RETURN iapiGeneral.SetErrorText( lnRetVal);
      END IF;
   END IF;

END SP_SUPPLIER_REF;

FUNCTION SP_MANUFACTURER_KW
RETURN iapiType.ErrorNum_Type IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
csMethod CONSTANT iapiType.Method_Type   := 'SP_MANUFACTURER_KW';

BEGIN

   RETURN APAO_VALIDATE.CopyManKeywords;

END SP_MANUFACTURER_KW;

FUNCTION SP_STATUS_KW
RETURN iapiType.ErrorNum_Type IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
csMethod CONSTANT iapiType.Method_Type   := 'SP_STATUS_KW';

BEGIN

   RETURN APAO_VALIDATE.AddStatusKeyword;

END SP_STATUS_KW;

FUNCTION SP_CODING_CONVENTION
RETURN iapiType.ErrorNum_Type IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
csMethod CONSTANT iapiType.Method_Type   := 'SP_CODING_CONVENTION';
lnRetVal iapiType.ErrorNum_Type;

BEGIN

   lnRetVal := APAO_VALIDATE.CodingConvention;

   IF lnRetVal <> iapiConstantDbError.DBERR_SUCCESS THEN
      IF lnRetVal = -20363 THEN
         RETURN iapiGeneral.SetErrorText( lnRetVal);
      ELSIF lnRetVal = -20364 THEN
         RETURN iapiGeneral.SetErrorText( lnRetVal);
      END IF;
   END IF;

   RETURN iapiConstantDbError.DBERR_SUCCESS;

END SP_CODING_CONVENTION;

FUNCTION DeletePriceFromBoMHeader
RETURN iapiType.ErrorNum_Type IS
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
csMethod CONSTANT iapiType.Method_Type   := 'DeletePriceFromBoMHeader';
lnRetVal iapiType.ErrorNum_Type;

BEGIN
    iapigeneral.loginfo (psSource, csMethod, 'INFO Start of function');

    AOPHR.DeletePriceFromBoMHeader;

    RETURN iapiConstantDbError.DBERR_SUCCESS;

END DeletePriceFromBoMHeader;

FUNCTION CreateFinalizeJob
RETURN iapiType.ErrorNum_Type
AS
    lnRetVal iapiType.ErrorNum_Type;
    lnJobID  iapiType.ID_Type;
BEGIN
    lnRetVal := aapiFea.ValidateValues(
        iapiSpecificationValidation.gsPartNo,
        iapiSpecificationValidation.gnRevision
    );
    
    IF lnRetVal = iapiConstantDBError.DBERR_SUCCESS THEN
        lnRetVal := aapiJob.CreateJob(
            anJobID    => lnJobID,
            asPartNo   => iapiSpecificationValidation.gsPartNo,
            anRevision => iapiSpecificationValidation.gnRevision,
            anJobType  => aapiJobDelegates.JOBTYPE_FINALIZE
        );
    END IF;
    
    RETURN lnRetVal;
END;

FUNCTION ExecuteCustomWarnings
RETURN iapiType.ErrorNum_Type
AS
BEGIN
    RETURN aapiValidation.ExecuteRules(
        iapiSpecificationValidation.gsPartNo,
        iapiSpecificationValidation.gnRevision,
        'W'
    );
END;

FUNCTION ExecuteCustomValidations
RETURN iapiType.ErrorNum_Type
AS
BEGIN
    RETURN aapiValidation.ExecuteRules(
        iapiSpecificationValidation.gsPartNo,
        iapiSpecificationValidation.gnRevision,
        'V'
    );
END;

FUNCTION ExecuteCustomCalculations
RETURN iapiType.ErrorNum_Type
AS
BEGIN
    RETURN aapiValidation.ExecuteRules(
        iapiSpecificationValidation.gsPartNo,
        iapiSpecificationValidation.gnRevision,
        'C'
    );
END;

FUNCTION ClearCustomCalculations
RETURN iapiType.ErrorNum_Type
AS
BEGIN
    RETURN aapiValidation.ClearRules(
        iapiSpecificationValidation.gsPartNo,
        iapiSpecificationValidation.gnRevision
    );
END;


FUNCTION ValidateSapCode
RETURN iapiType.ErrorNum_Type IS
    csMethod CONSTANT iapiType.Method_Type := 'ValidateSapCode';
    lnRetVal iapiType.ErrorNum_Type;
BEGIN
    RETURN APAO_VALIDATE.ValidateSapCode;
END;


FUNCTION ValidateBasedUpon
RETURN iapiType.ErrorNum_Type IS
    csMethod CONSTANT iapiType.Method_Type := 'ValidateBasedUpon';
    lnRetVal iapiType.ErrorNum_Type;
BEGIN
    RETURN APAO_VALIDATE.ValidateBasedUpon;
END;


FUNCTION ValidatePlant
RETURN iapiType.ErrorNum_Type IS
    csMethod  CONSTANT iapiType.Method_Type := 'ValidatePlant';
    lsPartNo  iapiType.PartNo_Type;
    lnPartRev iapiType.Revision_Type;
    lsFrameNo iapiType.FrameNo_Type;
    lnSkip    PLS_INTEGER := 0;
    lnCount   PLS_INTEGER;
    lsPlant   iapiType.Plant_Type;
    
    CURSOR lcPlantPrefix
    IS
        SELECT plant, prefix
        FROM atPlantPrefix
    ;
BEGIN
    lsPartNo  := iapiSpecificationValidation.gsPartNo;
    lnPartRev := iapiSpecificationValidation.gnRevision;
    
    SELECT frame_id
    INTO lsFrameNo
    FROM specification_header
    WHERE part_no = lsPartNo
    AND revision = lnPartRev;
    
    IF lsFrameNo NOT IN (
      'A_PCR',
      'A_PCR_GT_A',
      'A_PCR_GT_B',
      'E_PCR',
      'A_PCR_VULC v1',
      'A_PCR_GT v1',
      'E_PCR_GT_A',
      'E_PCR_GT_B',
      'E_PCR_GT_C',
      'E_PCR_VULC'
    ) THEN
        RETURN iapiConstantDbError.DBERR_SUCCESS;
    END IF;
  
    IF SUBSTR(lsPartNo, 1, 1) = 'X' THEN
        lnSkip := 1;
    END IF;
    
    FOR rec IN lcPlantPrefix
    LOOP
        IF SUBSTR(lsPartNo, 1 + lnSkip, LENGTH(rec.prefix)) = rec.prefix THEN
            lsPlant := rec.plant;
            EXIT;
        END IF;
    END LOOP;
    
    IF lsPlant IS NULL THEN
        RETURN iapiConstantDbError.DBERR_SUCCESS;
    END IF;

    
    SELECT COUNT(*)
    INTO lnCount
    FROM bom_header
    WHERE part_no = lsPartNo
    AND plant != lsPlant;
    
    IF lnCount > 0 THEN
        RETURN iapiGeneral.SetErrorText(-20926); --Invalid Plant in BoM
    END IF;


    SELECT COUNT(*)
    INTO lnCount
    FROM part_plant 
    WHERE part_no = lsPartNo
    AND plant != lsPlant;
    
    IF lnCount > 0 THEN
        RETURN iapiGeneral.SetErrorText(-20925); --Invalid Plant in Spec
    END IF;

    
    RETURN iapiConstantDbError.DBERR_SUCCESS;
END;


FUNCTION ValidateLabelValues
RETURN iapiType.ErrorNum_Type IS
    csMethod    CONSTANT iapiType.Method_Type := 'ValidateLabelValues';
    lsPartNo    iapiType.PartNo_Type;
    lnPartRev   iapiType.Revision_Type;
    lsFrameNo   iapiType.FrameNo_Type;
    lnCount     PLS_INTEGER;
    lnRetVal    iapiType.ErrorNum_Type;
    
    lsArticleCode        iapiType.PropertyShortString_Type;
    lsDAArticleCode      iapiType.PropertyShortString_Type;
    lsPrevArtCode        iapiType.PropertyShortString_Type;
    lsPrevDAArtCode      iapiType.PropertyShortString_Type;

    lsCompFuelEffClass   iapiType.PropertyShortString_Type;
    lsCompWetGripClass   iapiType.PropertyShortString_Type;
    lsCompRollNoiseClass iapiType.PropertyShortString_Type;
    lnCompRollNoiseValue iapiType.Float_Type;
  
    lsSpecFuelEffClass   iapiType.PropertyShortString_Type;
    lsSpecWetGripClass   iapiType.PropertyShortString_Type;
    lsSpecRollNoiseClass iapiType.PropertyShortString_Type;
    lnSpecRollNoiseValue iapiType.Float_Type;

    lqInfo   iapiType.Ref_Type;
    lqErrors iapiType.Ref_Type;
    lrError  iapitype.ErrorRec_type;
BEGIN
    lsPartNo  := iapiSpecificationValidation.gsPartNo;
    lnPartRev := iapiSpecificationValidation.gnRevision;

    IF (lqInfo%ISOPEN) THEN
       CLOSE lqInfo;
    END IF;
    IF (lqErrors%ISOPEN) THEN
       CLOSE lqErrors;
    END IF;

    --RETURN iapiConstantDbError.DBERR_SUCCESS;

    SELECT frame_id
    INTO lsFrameNo
    FROM specification_header
    WHERE part_no = lsPartNo
    AND revision = lnPartRev;
    
    IF lsFrameNo NOT IN (
      'A_PCR',
      'E_PCR'
    ) THEN
        RETURN iapiConstantDbError.DBERR_SUCCESS;
    END IF;

    SELECT char_1
    INTO lsArticleCode
    FROM specification_prop
    WHERE part_no = lsPartNo
    AND revision = lnPartRev
    AND section_id = 700755 --SAP information
    AND sub_section_id = 0 --(none)
    AND property_group = 704056 --SAP articlecode
    AND property = 713824 --Commercial article code
    AND attribute = 0
    ;
    
    SELECT char_1
    INTO lsDAArticleCode
    FROM specification_prop
    WHERE part_no = lsPartNo
    AND revision = lnPartRev
    AND section_id = 700755 --SAP information
    AND sub_section_id = 0 --(none)
    AND property_group = 704056 --SAP articlecode
    AND property = 713825 --Commercial DA article code
    AND attribute = 0
    ;
    
    SELECT
      MAX(CASE WHEN sp.property_group = 704177 THEN ch.description END) AS fuel_eff_class, --Labels Rolling resistance
      MAX(CASE WHEN sp.property_group = 704178 THEN ch.description END) AS wet_grip_class, --Labels Wet grip
      MAX(CASE WHEN sp.property_group = 704176 THEN ch.description END) AS roll_noise_class, --Labels Noise
      MAX(CASE WHEN sp.property_group = 704176 THEN sp.num_2 END) AS roll_noise_value --Labels Noise
    INTO
      lsSpecFuelEffClass,
      lsSpecWetGripClass,
      lsSpecRollNoiseClass,
      lnSpecRollNoiseValue
    FROM specification_prop sp
    LEFT JOIN characteristic ch ON (ch.characteristic_id = sp.characteristic)
    WHERE sp.part_no = lsPartNo
    AND sp.revision = lnPartRev
    AND sp.section_id = 701095	--Labels and certification
    AND sp.sub_section_id = 0 --(none)
    AND sp.property_group IN (
      704176, --Labels Noise
      704177,	--Labels Rolling resistance
      704178	--Labels Wet grip
    )
    AND sp.property = 715868 --EPREL EU Label
    AND sp.attribute = 0
    ;
    
    SELECT
      MAX(fuel_efficiency_class),
      MAX(wet_grip_class),
      MAX(external_rolling_noise_class),
      MAX(external_rolling_noise_value)
    INTO
      lsCompFuelEffClass,
      lsCompWetGripClass,
      lsCompRollNoiseClass,
      lnCompRollNoiseValue
    FROM atLabelValues
    WHERE article_code IN (lsArticleCode, lsDAArticleCode)
    ;
    
    IF (lsSpecFuelEffClass > lsCompFuelEffClass)
    OR (lsSpecWetGripClass > lsCompWetGripClass)
    OR (lsSpecRollNoiseClass > lsCompRollNoiseClass)
    OR (lnSpecRollNoiseValue > lnCompRollNoiseValue)
    THEN
        RETURN iapiGeneral.SetErrorText(-20927); --Label values changed
    ELSE
        BEGIN
            SELECT char_1
            INTO lsPrevArtCode
            FROM specification_prop
            WHERE (part_no, revision) = (
              SELECT part_no, MAX(revision)
              FROM specification_header
              WHERE part_no = lsPartNo
              AND revision < lnPartRev
              GROUP BY part_no
            )
            AND section_id = 700755 --SAP information
            AND sub_section_id = 0 --(none)
            AND property_group = 704056 --SAP articlecode
            AND property = 713824 --Commercial article code
            AND attribute = 0
            ;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            lsPrevArtCode := NULL;
        END;
        
        BEGIN    
            SELECT char_1
            INTO lsPrevDAArtCode
            FROM specification_prop
            WHERE (part_no, revision) = (
              SELECT part_no, MAX(revision)
              FROM specification_header
              WHERE part_no = lsPartNo
              AND revision < lnPartRev
              GROUP BY part_no
            )
            AND section_id = 700755 --SAP information
            AND sub_section_id = 0 --(none)
            AND property_group = 704056 --SAP articlecode
            AND property = 713825 --Commercial DA article code
            AND attribute = 0
            ;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            lsPrevDAArtCode := NULL;
        END;
        
        IF NVL(lsPrevArtCode, 'XXX') != lsArticleCode
        OR NVL(lsPrevDaArtCode, 'XXX') != lsDAArticleCode
        THEN
            SELECT COUNT(*)
            INTO lnCount
            FROM atLabelValues
            WHERE article_code IN (lsPrevArtCode, lsPrevDAArtCode)
            ;
            
            IF lnCount > 0 THEN
                lnRetVal := iapiSpecificationPropertyGroup.SaveAddProperty(
                    lsPartNo,
                    lnPartRev,
                    700755, --SAP information
                    0, --(none)
                    704056, --SAP articlecode
                    716107, --Date of SAP article code
                    0, -- 
                    700511,
                    TO_CHAR(SYSDATE, 'DD/MM/YYYY'),
                    NULL,
                    lqInfo,
                    lqErrors
                );

                IF lnRetVal != iapiConstantDBError.DBERR_SUCCESS
                THEN
                    LOOP
                        FETCH lqErrors INTO lrError;
                        EXIT WHEN lqErrors%NOTFOUND;
                        iapiGeneral.LogError(psSource, csMethod, lrError.ErrorText);
                    END LOOP;
          
                   iapiGeneral.LogError(psSource, csMethod, 'Error setting Date new SAP article code: ' || TO_CHAR(lnRetVal));
                   RETURN lnRetVal;
                END IF;
            END IF;
        END IF;
    END IF;

    
    /*
    dbms_output.put('Spec');
    dbms_output.put(CHR(9));
    dbms_output.put('-');
    dbms_output.put(CHR(9));
    dbms_output.put('Comp');
    dbms_output.new_line();
    
    dbms_output.put(lsSpecFuelEffClass);
    dbms_output.put(CHR(9) || CHR(9));
    dbms_output.put(CASE WHEN lsSpecFuelEffClass > lsCompFuelEffClass THEN '>' ELSE '<' END);
    dbms_output.put(CHR(9) || CHR(9));
    dbms_output.put(lsCompFuelEffClass);
    dbms_output.new_line();
    
    dbms_output.put(lsSpecWetGripClass);
    dbms_output.put(CHR(9) || CHR(9));
    dbms_output.put(CASE WHEN lsSpecWetGripClass > lsCompWetGripClass THEN '>' ELSE '<' END);
    dbms_output.put(CHR(9) || CHR(9));
    dbms_output.put(lsCompWetGripClass);
    dbms_output.new_line();
  
    dbms_output.put(lsSpecRollNoiseClass);
    dbms_output.put(CHR(9) || CHR(9));
    dbms_output.put(CASE WHEN lsSpecRollNoiseClass > lsCompRollNoiseClass THEN '>' ELSE '<' END);
    dbms_output.put(CHR(9) || CHR(9));
    dbms_output.put(lsCompRollNoiseClass);
    dbms_output.new_line();
    
    dbms_output.put(lnSpecRollNoiseValue);
    dbms_output.put(CHR(9) || CHR(9));
    dbms_output.put(CASE WHEN lnSpecRollNoiseValue > lnCompRollNoiseValue THEN '>' ELSE '<' END);
    dbms_output.put(CHR(9) || CHR(9));
    dbms_output.put(lnCompRollNoiseValue);
    dbms_output.new_line();
    */
    
    RETURN iapiConstantDbError.DBERR_SUCCESS;
END;

--
FUNCTION ValidateTreadlessGreentyre
RETURN iapiType.ErrorNum_Type
IS
--Procedure to find out if the PART-NO has a property Threadless-Greentyre filled. 
--Is this is the case then user should get a warning, because if he is changing this number
--then he has to change all the specifications which relates to this GreenTyre !!
--
csMethod  CONSTANT iapiType.Method_Type := 'ValidateTreadlessGreentyre';
lsPartNo  iapiType.PartNo_Type;
lnPartRev iapiType.Revision_Type;
--
l_section            number        := 700755;   --"SAP information"
l_sub_section        number        := 0; 
l_property_group     number        := 704540;   --"SAP information"
l_prop_description   varchar2(100) := 'Treadless Greentyre Code';   
l_property           number;
l_prop_tgt_value     varchar2(100);
--
lsFrameNo iapiType.FrameNo_Type;
lnSkip    PLS_INTEGER := 0;
lnCount   PLS_INTEGER;
lsPlant   iapiType.Plant_Type;
--
BEGIN
    --part_no   := iapiSpecificationStatus.gtStatusChange(0).PartNo;
    --revision  := iapiSpecificationStatus.gtStatusChange(0).Revision;
    lsPartNo  := iapiSpecificationValidation.gsPartNo;
    lnPartRev := iapiSpecificationValidation.gnRevision;
    --log-info in ITERROR...
    iapigeneral.logerror(psSource, csMethod, 'Check Part-no: '||lsPartNo||' for Treadless-Greentyre construction.');
    -- 
    begin   
      --select p.property from property p where p.description like 'Treadless Greentyre Code'||'%' ;
      --PROD:		717451	Treadless Greentyre Code
      --TEST:		715230	Treadless Greentyre Code
      SELECT p.property
      INTO l_property
      FROM property  p
      WHERE p.description like l_prop_description||'%'
      ;
    exception
      when others
      then l_property := null;
    end;
    --Indien property niet bestaat direct stoppen...
    IF l_property IS NULL
    THEN RETURN iapiConstantDbError.DBERR_SUCCESS;
    END IF;
    --get sap-information property-value of "threadless GreenTyre" for the part-no
    begin
      --vind testgeval:
      --select sp.part_no, sp.revision, sp.section_id, sp.property, p.description, sp.value_s from specdata sp, property p where sp.property = p.property and p.description like 'Treadless Greentyre Code'||'%' ;
      --TEST: EF_H165/60R14QT5X	21	700755
      --      GF_2255017AXPXY	   8	700755
      --of: SELECT * FROM SPECIFICATION_PROP SP where sp.part_no='EF_H165/60R14QT5X' and sp.revision = 21 and sp.section_id=700755 and property=715230;
      --
      --Haal value op van property=TreadlessGreenTrye bij part-no
      SELECT sp.char_1
      into   l_prop_tgt_value
      from specification_prop sp
      ,    property           p
      WHERE sp.part_no         = lsPartNo
      and   sp.revision        = lnPartRev
      AND sp.section_id        = l_section      --700755: SAP information
      and sp.sub_section_id    = l_sub_section  --0  none
      AND sp.property_group    in (l_property_group, 0)   --704056 SAP articlecode of 0=none
      and sp.property          = p.property
      and  p.description       like l_prop_description||'%'
      --AND sp.property          = l_property   --715230	Treadless Greentyre Code
      AND sp.attribute         = 0
      ;
    exception
      when others 
      then l_prop_tgt_value := null;
    end;
    --
    IF l_prop_tgt_value IS NOT NULL 
    THEN 
      --IAPIGENERAL.SETERRORTEXTANDLOGINFO( GSSOURCE,LSMETHOD,IAPICONSTANTDBERROR.DBERR_ERRORLIST);
      --IAPIGENERAL.LOGERROR( GSSOURCE,LSMETHOD,IAPIGENERAL.GETLASTERRORTEXT( ) );
      /*   SELECT MESSAGE
           INTO LSERRORTEXT
           FROM ITMESSAGE
           WHERE MSG_ID = TO_CHAR( ANERRORNUMBER )
           AND CULTURE_ID = ( SELECT VALUE
                              FROM ITUSPREF
                              WHERE USER_ID = IAPIGENERAL.SESSION.APPLICATIONUSER.USERID
                              AND SECTION_NAME = 'General'
                              AND PREF = 'ApplicationLanguage' 
                             );
      */  
      --20929 "PartNo is part of Treadless GreenTyre"
      --iapigeneral.logerror(psSource, csMethod, -20929);
      --iapigeneral.seterrortext(-20929);
      iapigeneral.logerror(psSource, csMethod, 'Part-no: '||lsPartNo||' is part of a Treadless-Greentyre construction !!!');
      RETURN iapiGeneral.SetErrorTextAndLogINfo (psSource, csMethod, -20929);
      --RETURN iapiGeneral.SetErrorText(-20926); --Part-no is part of a Treadless-Greentyre construction !!!
    END IF;
    --
    RETURN iapiConstantDbError.DBERR_SUCCESS;
    --
END ValidateTreadlessGreentyre;
--

END AOPA_VALIDATE_SS;
/

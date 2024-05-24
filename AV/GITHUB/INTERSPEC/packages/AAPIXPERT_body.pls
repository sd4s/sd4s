create or replace PACKAGE BODY aapiXpert
AS

    gsSource CONSTANT iapiType.Source_Type := 'aapiXpert';
    gsCheckAccessQuery iapiType.SqlString_Type;

    /*
     * Make sure we have the connection properly initialized.
     * This is needed to define the user's Access Group so that we are allowed to modify specs.
     */
    FUNCTION EnsureConnection
    RETURN iapiType.ErrorNum_Type
    IS
        lsMethod CONSTANT iapiType.Method_Type := 'EnsureConnection';
        lxMethod EXCEPTION; 

        lnRetVal  iapiType.ErrorNum_Type;
        lsPrefVal iapiType.PreferenceValue_Type;
    BEGIN
        aapiTrace.Enter();
        
        --Check if the session has been initialized already, if not, do so now.
        IF iapiGeneral.Session.ApplicationUser.UserId IS NULL THEN
            lnRetVal := iapiGeneral.SetConnection(
                asUserId => USER,
                asModuleName => gsSource
            );
            IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
                RAISE lxMethod;
            END IF;

            --If the connection has been set, enable logging if the user pref says so.
            lnRetVal := iapiUserPreferences.GetUserPreference(
                asSectionName     => 'General',
                asPreferenceName  => 'DatabaseLogging',
                asPreferenceValue => lsPrefVal
            );
            IF  lnRetVal = iapiConstantDBError.DBERR_SUCCESS
            AND lsPrefVal = '1' THEN
                iapiGeneral.EnableLogging;
            END IF;
            IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
                RAISE lxMethod;
            END IF;
        END IF;

        aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
        RETURN iapiConstantDBError.DBERR_SUCCESS;
    EXCEPTION
    WHEN lxMethod THEN
        iapiGeneral.LogError(
            asSource  => gsSource,
            asMethod  => lsMethod,
            asMessage => 'Session could not be initialized'
        );
        aapiTrace.Error('Session could not be initialized');
        aapiTrace.Exit(lnRetVal);
        RETURN lnRetVal;
    WHEN OTHERS THEN
        iapiGeneral.LogError(gsSource, lsMethod, SQLERRM);
        aapiTrace.Error(SQLERRM);
        aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
        RETURN iapiConstantDBError.DBERR_GENFAIL;
    END EnsureConnection;
   
   
   
    FUNCTION GetFrame(
        asPartNo   IN  iapiType.PartNo_Type,
        anRevision IN  iapiType.Revision_Type,
        asFrameNo  OUT iapiType.FrameNo_Type
    )
    RETURN iapiType.ErrorNum_Type
    IS
        lrFrame  iapiType.FrameRec_Type;
        lnResult iapiType.ErrorNum_Type;
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('asPartNo', asPartNo);
        aapiTrace.Param('anRevision', anRevision);

        lnResult  := iapiSpecification.GetFrame(asPartNo, anRevision, lrFrame);
        asFrameNo := lrFrame.frameNo;

        aapiTrace.Exit(lnResult);
        RETURN lnResult;
    END GetFrame;


    /*
     * Create a new specification, either as a copy from a different spec, a previous revision or completely new.
     * The source revision is the latest available revision (including DEV specs)
     * The destination revision is defined as the latest revision + 1, if a previous revision exists, otherwise 1.
     * One of the following combinations must be provided:
     *  - If asPartNo is an existing spec:
     *     - (asPartNo)                 Will create a new revision. Specifying asFrameId or asDescription will override the existing values.
     *     - (asPartNo, asFromPartNo)   asFromPartNo CANNOT be different than asPartNo.
     *  - If asPartNo is NOT an existing spec:
     *     - (asFromPartNo, asPartNo)   Will create a copy from the source spec. Specifying asFrameId or asDescription will override the existing values.
     *     - (asPartNo, asFrameId, asDescription) Will create a completely new spec. asFrameId and asDescription MUST be provided.
     *
     * anNewRevision will be the newly created revision, if successful.
     *
     * Returns DBERR_SUCCESS, otherwise logs errors to ITERROR and returns an error code describing the error that occurred.
     */
    FUNCTION CreateSpecification(
        asFromPartNo  IN  iapiType.PartNo_Type      DEFAULT NULL,
        asPartNo      IN  iapiType.PartNo_Type,
        asDescription IN  iapiType.Description_Type DEFAULT NULL,
        asFrameId     IN  iapiType.FrameNo_Type     DEFAULT NULL,
        asPlant       IN  iapiType.Plant_Type       DEFAULT 'ENS',
        anNewRevision OUT iapiType.Revision_Type
    )
    RETURN iapiType.ErrorNum_Type
    IS
        lsMethod CONSTANT iapiType.Method_Type := 'CreateSpecification';
        lxMethod EXCEPTION;

        --For some function calls we don't want all the data.
        --Dummy objects will retrieve the data but not use it.
        lrDummyPart    iapiType.PartRec_Type;
        lrDummySpec    iapiType.SpecificationHeaderRec_Type;
        lsDummyPrefix  iapiType.Prefix_Type;
        lnDummyRev     iapiType.Revision_Type;
        lnDummyMetric  iapiType.Boolean_Type;
        
        --The data used to create the new spec.
        lrCreatePart   iapiType.PartRec_Type;
        lrCreateSpec   iapiType.SpecificationHeaderRec_Type;
        lrSourceSpec   iapiType.SpecificationHeaderRec_Type;
        lnMetric       iapiType.Boolean_Type;
        lnUomType      iapiType.Boolean_Type;
        lsFromPartNo   iapiType.PartNo_Type;
        lnFromRevision iapiType.Revision_Type;
        lnCreateNewRev iapiType.Revision_Type;
        
        lqInfo         iapiType.Ref_Type;
        lqErrors       iapiType.Ref_Type;
        ltErrors       iapiType.ErrorTab_Type;
        lrError        iapiType.ErrorRec_Type;
        lnRetVal       iapiType.ErrorNum_Type;
        lnCount        NUMBER;
        
        --Will get the latest revision for a certain specification.
        --This includes DEV specs. Returns 0 if no revision was found.
        --Needed because only a 'part_no' is provided.
        FUNCTION GetLatestRevision(
            asPartNo IN iapiType.PartNo_Type
        )
        RETURN iapiType.Revision_Type
        IS
            lnRetVal iapiType.Revision_Type;
        BEGIN
            aapiTrace.Enter();
            aapiTrace.Param('asPartNo', asPartNo);
            
            SELECT MAX(revision)
            INTO   lnRetVal
            FROM   specification_header
            WHERE  part_no = asPartNo;
            
            IF lnRetVal IS NULL THEN
                lnRetVal := 0;
            END IF;
            
            aapiTrace.Exit(lnRetVal);
            RETURN lnRetVal;
        END;
        
        --Get the default spec UoM from the frame property Config, Base UoM
        --Defaults to 'pcs' if the property is not found.
        FUNCTION GetBaseUom(
            asFrameNo  IN iapiType.FrameNo_Type,
            asRevision IN iapiType.FrameRevision_Type,
            asOwner    IN iapiType.Id_Type
        )
        RETURN iapiType.BaseUom_Type
        IS
            lsDefault CONSTANT iapiType.BaseUom_Type := 'pcs';

            lsRetVal  iapiType.BaseUom_Type;
        BEGIN
            aapiTrace.Enter();
            aapiTrace.Param('asFrameNo', asFrameNo);
            aapiTrace.Param('asRevision', asRevision);
            aapiTrace.Param('asOwner', asOwner);
            
            SELECT char_1
            INTO   lsRetVal
            FROM   frame_prop
            WHERE  frame_no   = asFrameNo
              AND  revision   = asRevision
              AND  owner      = asOwner
              AND  section_id = 700915  --Config
              AND  property   = 709128; --Base UoM
            
            aapiTrace.Exit(lsRetVal);
            RETURN lsRetVal;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
        
            aapiTrace.Exit(lsDefault);
            RETURN lsDefault;
        END;
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('asFromPartNo', asFromPartNo);
        aapiTrace.Param('asPartNo', asPartNo);
        aapiTrace.Param('asDescription', asDescription);
        aapiTrace.Param('asFrameId', asFrameId);
        aapiTrace.Param('asPlant', asPlant);
        
        anNewRevision := -1; --Set to default number to avoid returning NULL;
        
        --Make sure our connection is set up properly so that we have the necessary access rights.
        lnRetVal := EnsureConnection;
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
            RAISE lxMethod;
        END IF;

        lsFromPartNo   := asFromPartNo;
        lnFromRevision := NULL;
        lnMetric       := 1;
        lnUomType      := iapiConstant.UOMTYPE_METRIC;

        --Fill in the basic values for the new spec.
        lrCreateSpec.PartNo      := asPartNo;
        lrCreateSpec.Revision    := GetLatestRevision(asPartNo) + 1; -- Find the next revision.
        lrCreateSpec.Description := asDescription;
        lrCreateSpec.FrameNo     := asFrameId;
        lrCreateSpec.FrameOwner  := iapiGeneral.Session.Database.Owner;
        
        --If the next revision is not the first one, copy from the previous revision, instead of from a different spec.
        IF lrCreateSpec.Revision > 1 THEN
            lsFromPartNo := asPartNo;
        END IF;

        --If a frameId was specified, we need to retrieve the necessary info.
        IF asFrameId IS NOT NULL THEN
            BEGIN
                SELECT
                    revision,
                    workflow_group_id,
                    access_group,
                    class3_id
                INTO
                    lrCreateSpec.FrameRevision,
                    lrCreateSpec.WorkflowGroupId,
                    lrCreateSpec.AccessGroupId,
                    lrCreateSpec.SpecificationTypeId
                FROM
                    frame_header
                WHERE
                    frame_no   = lrCreateSpec.FrameNo
                    AND owner  = lrCreateSpec.FrameOwner
                    AND status = 2; --Current, does not match value in Status table, unknown why.

                --Verify a frame was found.
                lnRetVal := iapiFrame.ExistId(
                    asFrameNo  => lrCreateSpec.FrameNo,
                    anRevision => lrCreateSpec.FrameRevision,
                    anOwner    => lrCreateSpec.FrameOwner
                );
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                lnRetVal := iapiGeneral.SetErrorText(
                    anErrorNumber => iapiConstantDBError.DBERR_FRAMENOTFOUND,
                    asParam1      => lrCreateSpec.FrameNo,
                    asParam2      => lrCreateSpec.FrameRevision,
                    asParam3      => lrCreateSpec.FrameOwner
                );
                iapiGeneral.LogError(
                    asSource  => gsSource,
                    asMethod  => lsMethod,
                    asMessage => iapiGeneral.GetLastErrorText
                );
                aapiTrace.Error(iapiGeneral.GetLastErrorText);
            END;
            IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
                iapiGeneral.LogError(
                    asSource  => gsSource,
                    asMethod  => lsMethod,
                    asMessage => 'Error in iapiFrame.FrameExists'
                );
                aapiTrace.Error('Error in iapiFrame.FrameExists');
                RAISE lxMethod;
            END IF;
        END IF;
        
        --Fill in the default values for a corresponding part.
        lrCreatePart.PARTNO         := asPartNo;
        lrCreatePart.DESCRIPTION    := asDescription;
        lrCreatePart.PARTTYPEID     := lrCreateSpec.SpecificationTypeId;
        lrCreatePart.PARTSOURCE     := iapiConstant.PARTSOURCE_INTERNAL;
        lrCreatePart.BASECONVFACTOR := NULL;
        lrCreatePart.BASETOUNIT     := NULL;
        lrCreatePart.BASEUOM        := GetBaseUom(
            asFrameNo  => lrCreateSpec.FrameNo,
            asRevision => lrCreateSpec.FrameRevision,
            asOwner    => lrCreateSpec.FrameOwner
        );
        
        --If we are creating a new spec, fill in the default Planned Effective Date.
        IF lsFromPartNo IS NULL THEN
            lnRetVal := iapiSpecification.InitialiseForCreate(
                asPrefix               => lsDummyPrefix,
                asCode                 => lrDummySpec.PartNo,
                asDescription          => lrDummySpec.Description,
                adPlannedEffectiveDate => lrCreateSpec.PlannedEffectiveDate,
                anMetric               => lnDummyMetric,
                anMultiLanguage        => lrDummySpec.MultiLanguage,
                asFrameNo              => lrDummySpec.FrameNo,
                anFrameRevision        => lrDummySpec.FrameRevision,
                anOwner                => lrDummySpec.Owner,
                anFrameMask            => lrDummySpec.MaskId,
                anWorkflowGroupId      => lrDummySpec.WorkflowGroupId,
                anAccessGroupId        => lrDummySpec.AccessGroupId,
                anSpecTypeId           => lrDummySpec.SpecificationTypeId,
                asUom                  => lrDummyPart.BASEUOM,
                asConversionFactor     => lrDummyPart.BASECONVFACTOR,
                asConversionUom        => lrDummyPart.BASETOUNIT,
                aqErrors               => lqErrors
            );
            IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
                iapiGeneral.LogError(
                    asSource  => gsSource,
                    asMethod  => lsMethod,
                    asMessage => 'Error in iapiSpecification.InitialiseForCreate'
                );
                aapiTrace.Error('Error in iapiSpecification.InitialiseForCreate');
                RAISE lxMethod;
            END IF;
        --If we are copying an existing spec, get the latest revision and fill in values in the new spec.
        ELSE
            lnFromRevision := GetLatestRevision(lsFromPartNo);
            IF lnFromRevision = 0 THEN
                iapiGeneral.LogError(
                    asSource  => gsSource,
                    asMethod  => lsMethod,
                    asMessage => 'Error in GetLatestRevision'
                );
                aapiTrace.Error('Error in GetLatestRevision');
                RAISE lxMethod;
            END IF;
            
            --If the new spec has the same part number, we want to create a new revision.
            lnCreateNewRev := CASE WHEN lsFromPartNo = asPartNo THEN 1 ELSE 0 END;
            --Fill in the necessary values from the source spec.
            lnRetVal := iapiSpecification.InitialiseForCopy(
                asFromPartNo           => lsFromPartNo,
                anFromRevision         => lnFromRevision,
                anCreateNewRevision    => lnCreateNewRev,
                asPrefix               => lsDummyPrefix,
                asCode                 => lrDummySpec.PartNo,
                asDescription          => lrSourceSpec.Description,
                adPlannedEffectiveDate => lrSourceSpec.PlannedEffectiveDate,
                anMetric               => lnMetric,
                anMultiLanguage        => lrSourceSpec.MultiLanguage,
                asFrameNo              => lrSourceSpec.FrameNo,
                anFrameRevision        => lrSourceSpec.FrameRevision,
                anOwner                => lrSourceSpec.FrameOwner,
                anFrameMask            => lrSourceSpec.MaskId,
                anWorkflowGroupId      => lrSourceSpec.WorkflowGroupId,
                anAccessGroupId        => lrSourceSpec.AccessGroupId,
                anSpecTypeId           => lrSourceSpec.SpecificationTypeId,
                asUom                  => lrCreatePart.BASEUOM,
                asConversionFactor     => lrCreatePart.BASECONVFACTOR,
                asConversionUom        => lrCreatePart.BASETOUNIT,
                aqErrors               => lqErrors
            );
            IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
                iapiGeneral.LogError(
                    asSource  => gsSource,
                    asMethod  => lsMethod,
                    asMessage => 'Error in iapiSpecification.InitialiseForCopy'
                );
                aapiTrace.Error('Error in iapiSpecification.InitialiseForCopy');
                RAISE lxMethod;
            END IF;

            --Copy the necessary values from the source spec into the new spec.
            lrCreateSpec.PlannedEffectiveDate := lrSourceSpec.PlannedEffectiveDate;
            lrCreateSpec.MultiLanguage        := lrSourceSpec.MultiLanguage;
            lrCreateSpec.MaskId               := lrSourceSpec.MaskId;
            --Only copy the description if one was not provided as parameter.
            IF asDescription IS NULL THEN
                lrCreateSpec.Description := lrSourceSpec.Description;
            END IF;
            --If no new frameId was provided, copy the original frame data.
            IF asFrameId IS NULL THEN
                lrCreateSpec.FrameNo             := lrSourceSpec.FrameNo;
                lrCreateSpec.FrameRevision       := lrSourceSpec.FrameRevision;
                lrCreateSpec.FrameOwner          := lrSourceSpec.FrameOwner;
                lrCreateSpec.WorkflowGroupId     := lrSourceSpec.WorkflowGroupId;
                lrCreateSpec.AccessGroupId       := lrSourceSpec.AccessGroupId;
                lrCreateSpec.SpecificationTypeId := lrSourceSpec.SpecificationTypeId;
            END IF;
            
        END IF;
        
        --If the corresponding part doesn't exist yet, create one.
        lnRetVal := iapiPart.ExistId(lrCreatePart.PARTNO);
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
            --Make sure all the data necessary is valid.
            lnRetVal := iapiPart.ValidateNewSpec(
                asPartNo         => lrCreatePart.PARTNO,
                asDescription    => lrCreatePart.DESCRIPTION,
                anPartTypeId     => lrCreatePart.PARTTYPEID,
                asBaseUom        => lrCreatePart.BASEUOM,
                anBaseConvFactor => lrCreatePart.BASECONVFACTOR,
                asBaseToUnit     => lrCreatePart.BASETOUNIT,
                asPartSource     => lrCreatePart.PARTSOURCE,
                aqErrors         => lqErrors
            );
            IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
                iapiGeneral.LogError(
                    asSource  => gsSource,
                    asMethod  => lsMethod,
                    asMessage => 'Error in iapiPart.ValidateNewSpec'
                );
                aapiTrace.Error('Error in iapiPart.ValidateNewSpec');
                RAISE lxMethod;
            END IF;
            
            --Create the new part.
            lnRetVal := iapiPart.AddPart(
                asPartNo         => lrCreatePart.PARTNO,
                asDescription    => lrCreatePart.DESCRIPTION,
                asBaseUom        => lrCreatePart.BASEUOM,
                asBaseToUnit     => lrCreatePart.BASETOUNIT,
                anBaseConvFactor => lrCreatePart.BASECONVFACTOR,
                asPartSource     => lrCreatePart.PARTSOURCE,
                anPartTypeId     => lrCreatePart.PARTTYPEID,
                aqErrors         => lqErrors
            );
            IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
                iapiGeneral.LogError(
                    asSource  => gsSource,
                    asMethod  => lsMethod,
                    asMessage => 'Error in AddPart'
                );
                aapiTrace.Error('Error in AddPart');
                RAISE lxMethod;
            END IF;
        END IF;

        IF asPlant IS NOT NULL THEN
            --Check if the part is already available in the plant. If not, add it.
            lnRetVal := iapiPartPlant.ExistId(lrCreatePart.PARTNO, asPlant);
            IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
                lnRetVal := iapiPartPlant.AddPlant(
                    asPartNo               => lrCreatePart.PARTNO,
                    asPlantNo              => asPlant,
                    asIssueLocation        => NULL,
                    asIssueUom             => NULL,
                    anOperationalStep      => NULL,
                    aqErrors               => lqErrors
                );
                IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
                    iapiGeneral.LogError(
                        asSource  => gsSource,
                        asMethod  => lsMethod,
                        asMessage => 'Error in iapiPartPlant.AddPlant'
                    );
                    aapiTrace.Error('Error in iapiPartPlant.AddPlant');
                    RAISE lxMethod;
                END IF;
            END IF;
        END IF;

        --Log all the acquired info thus far.
        iapiGeneral.LogInfo(
            asSource    => gsSource,
            asMethod    => lsMethod,
            asMessage   => 'lsFromPartNo: ' || lsFromPartNo,
            anInfoLevel => iapiConstant.INFOLEVEL_3
        );
        iapiGeneral.LogInfo(
            asSource    => gsSource,
            asMethod    => lsMethod,
            asMessage   => 'lnFromRevision: ' || lnFromRevision,
            anInfoLevel => iapiConstant.INFOLEVEL_3
        );
        iapiGeneral.LogInfo(
            asSource    => gsSource,
            asMethod    => lsMethod,
            asMessage   => 'lrCreateSpec.PartNo: ' || lrCreateSpec.PartNo,
            anInfoLevel => iapiConstant.INFOLEVEL_3
        );
        iapiGeneral.LogInfo(
            asSource    => gsSource,
            asMethod    => lsMethod,
            asMessage   => 'lrCreateSpec.PartNo: ' || lrCreateSpec.PartNo,
            anInfoLevel => iapiConstant.INFOLEVEL_3
        );
        iapiGeneral.LogInfo(
            asSource    => gsSource,
            asMethod    => lsMethod,
            asMessage   => 'lrCreateSpec.Revision: ' || lrCreateSpec.Revision,
            anInfoLevel => iapiConstant.INFOLEVEL_3
        );
        iapiGeneral.LogInfo(
            asSource    => gsSource,
            asMethod    => lsMethod,
            asMessage   => 'lrCreateSpec.Description: ' || lrCreateSpec.Description,
            anInfoLevel => iapiConstant.INFOLEVEL_3
        );
        iapiGeneral.LogInfo(
            asSource    => gsSource,
            asMethod    => lsMethod,
            asMessage   => 'lrCreateSpec.PlannedEffectiveDate: ' || lrCreateSpec.PlannedEffectiveDate,
            anInfoLevel => iapiConstant.INFOLEVEL_3
        );
        iapiGeneral.LogInfo(
            asSource    => gsSource,
            asMethod    => lsMethod,
            asMessage   => 'lrCreateSpec.FrameNo: ' || lrCreateSpec.FrameNo,
            anInfoLevel => iapiConstant.INFOLEVEL_3
        );
        iapiGeneral.LogInfo(
            asSource    => gsSource,
            asMethod    => lsMethod,
            asMessage   => 'lrCreateSpec.FrameRevision: ' || lrCreateSpec.FrameRevision,
            anInfoLevel => iapiConstant.INFOLEVEL_3
        );
        iapiGeneral.LogInfo(
            asSource    => gsSource,
            asMethod    => lsMethod,
            asMessage   => 'lrCreateSpec.FrameOwner: ' || lrCreateSpec.FrameOwner,
            anInfoLevel => iapiConstant.INFOLEVEL_3
        );
        iapiGeneral.LogInfo(
            asSource    => gsSource,
            asMethod    => lsMethod,
            asMessage   => 'lrCreateSpec.SpecificationTypeId: ' || lrCreateSpec.SpecificationTypeId,
            anInfoLevel => iapiConstant.INFOLEVEL_3
        );
        iapiGeneral.LogInfo(
            asSource    => gsSource,
            asMethod    => lsMethod,
            asMessage   => 'lrCreateSpec.WorkflowGroupId: ' || lrCreateSpec.WorkflowGroupId,
            anInfoLevel => iapiConstant.INFOLEVEL_3
        );
        iapiGeneral.LogInfo(
            asSource    => gsSource,
            asMethod    => lsMethod,
            asMessage   => 'lrCreateSpec.AccessGroupId: ' || lrCreateSpec.AccessGroupId,
            anInfoLevel => iapiConstant.INFOLEVEL_3
        );
        iapiGeneral.LogInfo(
            asSource    => gsSource,
            asMethod    => lsMethod,
            asMessage   => 'lrCreateSpec.MultiLanguage: ' || lrCreateSpec.MultiLanguage,
            anInfoLevel => iapiConstant.INFOLEVEL_3
        );
        iapiGeneral.LogInfo(
            asSource    => gsSource,
            asMethod    => lsMethod,
            asMessage   => 'lrCreateSpec.MaskId: ' || lrCreateSpec.MaskId,
            anInfoLevel => iapiConstant.INFOLEVEL_3
        );
        iapiGeneral.LogInfo(
            asSource    => gsSource,
            asMethod    => lsMethod,
            asMessage   => 'lnUomType: ' || lnUomType,
            anInfoLevel => iapiConstant.INFOLEVEL_3
        );
        iapiGeneral.LogInfo(
            asSource    => gsSource,
            asMethod    => lsMethod,
            asMessage   => 'lrCreatePart.BaseUom: ' || lrCreatePart.BASEUOM,
            anInfoLevel => iapiConstant.INFOLEVEL_3
        );

        --Check if the specification already exists.
        lnRetVal := iapiSpecification.ExistId(
            asPartNo   => lrCreateSpec.PartNo,
            anRevision => lrCreateSpec.Revision
        );
        IF lnRetVal = iapiConstantDBError.DBERR_SUCCESS THEN
            lnRetVal := iapiGeneral.SetErrorText(
                anErrorNumber => iapiConstantDBError.DBERR_SPECALREADYEXIST,
                asParam1      => lrCreateSpec.PartNo,
                asParam2      => lrCreateSpec.Revision
            );
            iapiGeneral.LogError(
                asSource  => gsSource,
                asMethod  => lsMethod,
                asMessage => iapiGeneral.GetLastErrorText
            );
            aapiTrace.Error(iapiGeneral.GetLastErrorText);
            RAISE lxMethod;
        END IF;
        
        --Set the UoM type.
        IF lnMetric = 1 THEN
            lnUomType := iapiConstant.UOMTYPE_METRIC;
        ELSE
            lnUomType := iapiConstant.UOMTYPE_NONMETRIC;
        END IF;
        
        --If we have no source spec, nor a previous revision, create the new spec from scratch..
        IF lsFromPartNo IS NULL THEN
            lnRetVal := iapiSpecification.CreateSpecification(
                asPartNo               => lrCreateSpec.PartNo,
                anRevision             => lrCreateSpec.Revision,
                asDescription          => lrCreateSpec.Description,
                asCreatedBy            => iapiGeneral.Session.ApplicationUser.UserID,
                adPlannedEffectiveDate => lrCreateSpec.PlannedEffectiveDate,
                asFrameId              => lrCreateSpec.FrameNo,
                anFrameRevision        => lrCreateSpec.FrameRevision,
                anFrameOwner           => lrCreateSpec.FrameOwner,
                anSpecTypeId           => lrCreateSpec.SpecificationTypeId,
                anWorkFlowGroupId      => lrCreateSpec.WorkflowGroupId,
                anAccessGroupId        => lrCreateSpec.AccessGroupId,
                anMultiLanguage        => lrCreateSpec.MultiLanguage,
                anUomType              => lnUomType,
                anMaskId               => lrCreateSpec.MaskId,
                aqErrors               => lqErrors
            );
            IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
                iapiGeneral.LogError(
                    asSource  => gsSource,
                    asMethod  => lsMethod,
                    asMessage => 'Error in iapiSpecification.CreateSpecification'
                );
                aapiTrace.Error('Error in iapiSpecification.CreateSpecification');
                RAISE lxMethod;
            END IF;
        --If we have a source spec or a previous revision, copy into the new spec.
        ELSE
            lnRetVal := iapiSpecification.CopySpecification(
                asFromPartNo           => lsFromPartNo,
                anFromRevision         => lnFromRevision,
                asPartNo               => lrCreateSpec.PartNo,
                asFrameId              => lrCreateSpec.FrameNo,
                anFrameRevision        => lrCreateSpec.FrameRevision,
                anFrameOwner           => lrCreateSpec.FrameOwner,
                anWorkFlowGroupId      => lrCreateSpec.WorkflowGroupId,
                anAccessGroupId        => lrCreateSpec.AccessGroupId,
                anSpecTypeId           => lrCreateSpec.SpecificationTypeId,
                adPlannedEffectiveDate => lrCreateSpec.PlannedEffectiveDate,
                anNewRevision          => lrCreateSpec.Revision,
                anMultiLanguage        => lrCreateSpec.MultiLanguage,
                anUomType              => lnUomType,
                anMaskId               => lrCreateSpec.MaskId,
                asDescription          => lrCreateSpec.Description,
                aqErrors               => lqErrors
            );
            IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
                iapiGeneral.LogError(
                    asSource  => gsSource,
                    asMethod  => lsMethod,
                    asMessage => 'Error in iapiSpecification.CopySpecification'
                );
                aapiTrace.Error('Error in iapiSpecification.CopySpecification');
                RAISE lxMethod;
            END IF;
        END IF;
        
        IF asPlant IS NOT NULL THEN
            --Check if the frame has a BoM section. If so, we need to add a BoM header.
            SELECT COUNT(*)
            INTO  lnCount
            FROM  frame_section
            WHERE frame_no = lrCreateSpec.FrameNo
              AND revision = lrCreateSpec.FrameRevision
              AND owner    = lrCreateSpec.FrameOwner
              AND type     = iapiConstant.SectionType_Bom;
    
            IF lnCount > 0 THEN
                SELECT COUNT(*)
                INTO lnCount
                FROM bom_header
                WHERE part_no  = lrCreateSpec.PartNo
                  AND revision = lrCreateSpec.Revision
                  AND plant    = asPlant;
                
                IF lnCount = 0 THEN
                    --Add the BoM header with default values.
                    lnRetVal := iapiSpecificationBom.AddHeader(
                        asPartNo               => lrCreateSpec.PartNo,
                        anRevision             => lrCreateSpec.Revision,
                        asPlant                => asPlant,
                        anAlternative          => 1,
                        anUsage                => 1,
                        asDescription          => NULL,
                        anQuantity             => 1,
                        anConversionFactor     => NULL,
                        asConvertedUom         => NULL,
                        anYield                => NULL,
                        asCalculationMode      => 'N',
                        asBomType              => NULL,
                        anMinimumQuantity      => NULL,
                        anMaximumQuantity      => NULL,
                        adPlannedEffectiveDate => lrCreateSpec.PlannedEffectiveDate,
                        aqInfo                 => lqInfo,
                        aqErrors               => lqErrors
                    );
                    IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
                        iapiGeneral.LogError(
                            asSource  => gsSource,
                            asMethod  => lsMethod,
                            asMessage => 'Error in iapiSpecificationBom.AddHeader'
                        );
                        aapiTrace.Error('Error in iapiSpecificationBom.AddHeader');
                        RAISE lxMethod;
                    END IF;
                END IF;
            END IF;
        END IF;
    
        --Return the new revision.
        anNewRevision := lrCreateSpec.Revision;
        
        RETURN lnRetVal;
    EXCEPTION
    WHEN lxMethod THEN
        --Log any errors we find in the error list.
        FETCH lqErrors
        BULK COLLECT INTO ltErrors;

        IF ltErrors.COUNT > 0 THEN
            FOR lnIndex IN ltErrors.FIRST..ltErrors.LAST
            LOOP
                lrError := ltErrors(lnIndex);
                IF lrError.MessageType = iapiConstant.ErrorMessage_Error THEN
                    iapiGeneral.LogError(
                        asSource  => gsSource,
                        asMethod  => lsMethod,
                        asMessage => lrError.ErrorText
                    );
                    aapiTrace.Error(lrError.ErrorText);
                END IF;
            END LOOP;
        END IF;
        
        aapiTrace.Exit(lnRetVal);
        RETURN lnRetVal;
    WHEN OTHERS THEN
        iapiGeneral.LogError(gsSource, lsMethod, SQLERRM);
        aapiTrace.Error(SQLERRM);
        aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
        RETURN iapiConstantDBError.DBERR_GENFAIL;
    END CreateSpecification;
    
    
    
    /*
     * Filter existing specifications on certain property values or ranges, or frame types.
     *  - asFrameId            Restrict results to only certain frames.
     *  - asSection            Defines the section of the property. If NULL, all are searched.
     *  - asSubsection         Defines the subsection of the property. If NULL, all are searched.
     *  - asPropertyGroup      Defines the property group of the property. If NULL, all are searched.
     *  - asProperty           Defines the property. Must be provided.
     *  - asHeader             Defines the header of the property value. Must be provided.
     *  - asTextValue          Searches for the property value_s using the LIKE operator. If NULL, it is not used as a criteria.
     *  - anMinValue           Searches for the property value using the > operator. If NULL, it is not used as a criteria.
     *  - anMaxValue           Searches for the property value using the < operator. If NULL, it is not used as a criteria.
     *  - anChainFilter        Specifies if the provided arSpecRefList should be used to filter instead of the entire specification table.
     *
     *  - arSpecRefList        The result list, if anChainFilter is 1, then the list is used to restrict the search.
     *
     * Returns DBERR_SUCCESS, otherwise logs errors to ITERROR and returns an error code describing the error that occurred.
     */
    FUNCTION FilterSpecByProperty(
        asPlant         IN iapiType.Plant_Type       DEFAULT NULL,
        asFrameId       IN iapiType.FrameNo_Type     DEFAULT NULL,
        asSection       IN iapiType.Description_Type DEFAULT NULL,
        asSubsection    IN iapiType.Description_Type DEFAULT NULL,
        asPropertyGroup IN iapiType.Description_Type DEFAULT NULL,
        asProperty      IN iapiType.Description_Type,
        asHeader        IN iapiType.Description_Type DEFAULT 'Value',
        asTextValue     IN iapiType.PropertyShortString_Type DEFAULT NULL,
        anMinValue      IN iapiType.Float_Type DEFAULT NULL,
        anMaxValue      IN iapiType.Float_Type DEFAULT NULL,
        anChainFilter   IN iapiType.Boolean_Type,
        arSpecRefList   IN OUT SpecRefTable_Type
    )
    RETURN iapiType.ErrorNum_Type
    AS
        lsMethod CONSTANT iapiType.Method_Type := 'FilterSpecByProperty';
        lxMethod EXCEPTION;

        lsSectionId       iapiType.Id_Type;
        lsSubsectionId    iapiType.Id_Type;
        lsPropertyGroupId iapiType.Id_Type;
        lsPropertyId      iapiType.Id_Type;
        lsHeaderId        iapiType.Id_Type;

        lrSpecRefList     SpecRefTable_Type;
        lnRetVal          iapiType.ErrorNum_Type;
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('asPlant', asPlant);
        aapiTrace.Param('asFrameId', asFrameId);
        aapiTrace.Param('asSection', asSection);
        aapiTrace.Param('asSubsection', asSubsection);
        aapiTrace.Param('asPropertyGroup', asPropertyGroup);
        aapiTrace.Param('asProperty', asProperty);
        aapiTrace.Param('asTextValue', asTextValue);
        aapiTrace.Param('anMinValue', anMinValue);
        aapiTrace.Param('anMaxValue', anMaxValue);
        aapiTrace.Param('anChainFilter', anChainFilter);

        --Make sure our connection is set up properly so that we have the necessary access rights.
        lnRetVal := EnsureConnection;
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
            arSpecRefList := NULL;
            RAISE lxMethod;
        END IF;
        
        --If specified, retrieve the section id from the description.
        IF asSection IS NOT NULL THEN
            SELECT section_id
            INTO lsSectionId
            FROM section
            WHERE description = asSection
              AND status = 0;
        END IF;
      
        --If specified, retrieve the subsection id from the description.
        IF asSubsection IS NOT NULL THEN
            SELECT sub_section_id
            INTO lsSubsectionId
            FROM sub_section
            WHERE description = asSubsection
              AND status = 0;
        END IF;
        
        --If specified, retrieve the property group id from the description.
        IF asPropertyGroup IS NOT NULL THEN
            SELECT property_group
            INTO lsPropertyGroupId
            FROM property_group
            WHERE description = asPropertyGroup
              AND status = 0;
        END IF;
      
        --Retrieve the property id from the description.
        SELECT property
        INTO lsPropertyId
        FROM property
        WHERE description = asProperty
          AND status = 0;
      
        --Retrieve the header id from the description.
        SELECT header_id
        INTO lsHeaderId
        FROM header
        WHERE description = asHeader
          AND status = 0;

        --Safe the original result list.
        lrSpecRefList := arSpecRefList;
        
        --Fetch all results into the result list. Apply criteria when they are not NULL.
        SELECT
            SpecRefRecord_Type(
                spec.part_no,
                spec.revision,
                spec.description
            )
        BULK COLLECT INTO
            arSpecRefList
        FROM
            specdata
        INNER JOIN
            specification_header spec
            ON  spec.part_no  = specdata.part_no
            AND spec.revision = specdata.revision
            AND spec.status IN (1, 4, 126, 127, 128) -- DEV, CURRENT, QR3, QR4, QR5
        INNER JOIN
            part_plant
            ON  part_plant.part_no = specdata.part_no
        WHERE (property = lsPropertyId)
          AND (header_id = lsHeaderId)
          AND (asSection IS NULL OR section_id = lsSectionId)
          AND (asSubsection IS NULL OR sub_section_id = lsSubsectionId)
          AND (asPropertyGroup IS NULL OR property_group = lsPropertyGroupId)
          AND (asTextValue IS NULL OR value_s LIKE asTextValue)
          AND (anMinValue IS NULL OR value >= anMinValue)
          AND (anMaxValue IS NULL OR value <= anMaxValue)
          AND (asPlant IS NULL OR part_plant.plant = asPlant)
          AND (asFrameId IS NULL OR spec.frame_id = asFrameId)
          AND (anChainFilter = 0 OR (specdata.part_no, specdata.revision) IN (
              SELECT part_no, revision
              FROM TABLE(lrSpecRefList)
          ))
        GROUP BY
            spec.part_no,
            spec.revision,
            spec.description
        ;
        
        aapiTrace.Exit(iapiConstantDBError.DBERR_SUCCESS);
        RETURN iapiConstantDBError.DBERR_SUCCESS;
    EXCEPTION
    WHEN lxMethod THEN
        arSpecRefList := NULL;
        aapiTrace.Exit(lnRetVal);
        RETURN lnRetVal;
    WHEN OTHERS THEN
        iapiGeneral.LogError(gsSource, lsMethod, SQLERRM);
        arSpecRefList := NULL;
        aapiTrace.Error(SQLERRM);
        aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
        RETURN iapiConstantDBError.DBERR_GENFAIL;
    END FilterSpecByProperty;
    
    /*
     * Filter existing specifications on BoM items and frame types.
     *  - asFrameId            Restrict results to only certain frames.
     *  - arBomItemList        A list of BoM items the specfication needs to contain.
     *  - anChainFilter        Specifies if the provided arSpecRefList should be used to filter instead of the entire specification table.
     *
     *  - arSpecRefList        The result list, if anChainFilter is 1, then the list is used to restrict the search.
     *
     * Returns DBERR_SUCCESS, otherwise logs errors to ITERROR and returns an error code describing the error that occurred.
     */
    FUNCTION FilterSpecByBom(
        asPlant       IN     iapiType.Plant_Type   DEFAULT NULL,
        asFrameId     IN     iapiType.FrameNo_Type DEFAULT NULL,
        arBomItemList IN     SpecRefTable_Type,
        anChainFilter IN     iapiType.Boolean_Type DEFAULT 0,
        arSpecRefList IN OUT SpecRefTable_Type
    )
    RETURN iapiType.ErrorNum_Type
    AS
        lsMethod CONSTANT iapiType.Method_Type := 'FilterSpecByBom';
        lrSpecRefList     SpecRefTable_Type;
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('asPlant', asPlant);
        aapiTrace.Param('asFrameId', asFrameId);
        aapiTrace.Param('anChainFilter', anChainFilter);

        --Safe the original result list.
        lrSpecRefList := arSpecRefList;
        
        --Fetch all results into the result list. Apply criteria when they are not NULL.
        SELECT
            SpecRefRecord_Type(
                spec.part_no,
                spec.revision,
                spec.description
            )
        BULK COLLECT INTO
            arSpecRefList
        FROM  
            bom_item
        INNER JOIN
            specification_header spec
            ON  spec.part_no  = bom_item.part_no
            AND spec.revision = bom_item.revision
        WHERE bom_item.component_part IN (
                SELECT part_no
                FROM TABLE(arBomItemList)
            )
          AND (anChainFilter = 0 OR (spec.part_no, spec.revision) IN (
              SELECT part_no, revision
              FROM TABLE(lrSpecRefList)
          ))
          AND (asPlant IS NULL OR bom_item.plant = asPlant)
          AND (asFrameId IS NULL OR spec.frame_id = asFrameId)
        GROUP BY
            spec.part_no,
            spec.revision,
            spec.description
        ;
        
        aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
        RETURN iapiConstantDBError.DBERR_SUCCESS;
    EXCEPTION
    WHEN OTHERS THEN
        iapiGeneral.LogError(gsSource, lsMethod, SQLERRM);
        arSpecRefList := NULL;
        aapiTrace.Error(SQLERRM);
        aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
        RETURN iapiConstantDBError.DBERR_GENFAIL;
    END FilterSpecByBom;
    
    FUNCTION RefreshFrame(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type DEFAULT NULL
    )
    RETURN iapiType.ErrorNum_Type
    AS
        PRAGMA AUTONOMOUS_TRANSACTION;
        lsMethod   CONSTANT iapiType.Method_Type := 'RefreshFrame';
        lnRevision iapiType.Revision_Type;
        lrFrame    iapiType.FrameRec_Type;
        lnFrameRev iapiType.Revision_Type;
        lnResult   iapiType.ErrorNum_Type := iapiConstantDBError.DBERR_GENFAIL;
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('asPartNo', asPartNo);
        aapiTrace.Param('anRevision', anRevision);
        
        IF anRevision IS NULL THEN
            SELECT revision
            INTO lnRevision
            FROM specification_header sh, status
            WHERE part_no = asPartNo
            AND sh.status = status.status
            AND status.status_type = 'DEVELOPMENT';
        ELSE
            lnRevision := anRevision;
        END IF;
        
        lnResult := iapiSpecification.GetFrame(asPartNo, lnRevision, lrFrame);
        
        IF lnResult = iapiConstantDBError.DBERR_SUCCESS THEN
            SELECT revision
            INTO lnFrameRev
            FROM frame_header
            WHERE frame_no = lrFrame.FrameNo
            AND owner = lrFrame.Owner
            AND status = 2;
        
            IF lnFrameRev <> lrFrame.Revision Then
                lnResult := iapiSpecification.SaveFrame(
                    asPartNo,
                    lnRevision,
                    lrFrame.FrameNo,
                    lnFrameRev,
                    lrFrame.Owner
                    --,lrFrame.MaskId
                );
            
                COMMIT;
            END IF;
        END IF;
        
        RETURN lnResult;
    EXCEPTION
    WHEN OTHERS THEN
        iapiGeneral.LogError(gsSource, lsMethod, SQLERRM);
        aapiTrace.Error(SQLERRM);
        aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
        RETURN iapiConstantDBError.DBERR_GENFAIL;
    END;
    

END AAPIXPERT;
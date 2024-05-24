create or replace PACKAGE BODY            "AAPIJOBDELEGATES" AS

    psSource CONSTANT iapiType.Source_Type := 'aapiJobDelegates';

    FUNCTION ProcessFinalizeJob(
        anJobID    IN iapiType.ID_Type,
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type
    ) RETURN iapiType.ErrorNum_Type
    AS
        lsMethod      iapiType.Method_Type := 'ProcessFinalizeJob';
        lsErrMsg      iapiType.ErrorText_Type;
        lnErrNum      iapiType.ErrorNum_Type;
        lnRetVal      iapiType.ErrorNum_Type;
        lqErrors      iapiType.Ref_Type;
        lrError       iapiType.ErrorRec_Type;
        ltErrors      iapiType.ErrorTab_type;
        lsFrameNo     iapiType.FrameNo_Type;
        lnAccessGroup iapiType.ID_Type;
        lnJobID       iapiType.ID_Type;
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('anJobID', anJobID);
        aapiTrace.Param('asPartNo', asPartNo);
        aapiTrace.Param('anRevision', anRevision);
        
        SELECT frame_id
        INTO lsFrameNo
        FROM specification_header
        WHERE part_no  = asPartNo
          AND revision = anRevision;
        
        SELECT access_group
        INTO lnAccessGroup
        FROM access_group
        WHERE sort_desc = 'Finalize';
    
        lnRetVal := iapiSpecification.SaveHeader(
            asPartNo          => asPartNo,
            anRevision        => anRevision,
            anWorkFlowGroupId => NULL,
            anAccessGroupId   => lnAccessGroup,
            anMultiLanguage   => NULL,
            anSpecTypeId      => NULL,
            anLanguageId      => NULL,
            aqErrors          => lqErrors
        );

        IF lnRetVal = iapiConstantDBError.DBERR_SUCCESS THEN
            lnRetVal := aapiJob.CreateJob(
                anJobID       => lnJobID,
                asPartNo      => asPartNo,
                anRevision    => anRevision,
                anJobType     => JOBTYPE_CLEAN,
                anParentJobID => anJobID
            );
        END IF;
        IF  lnRetVal = iapiConstantDBError.DBERR_SUCCESS
        AND lsFrameNo IN (
            'A_Global_Beadwire',
            'A_Global_Fabric',
            'A_Global_Steelcord',
            'E_FM',
            'E_PCR',
            'A_PCR_v1',
            'A_PCR',
            'A_OHT',
            'Global compound',
            'A_CMPD_FM v1',
            'A_FEA_Materials'
        ) THEN
            lnRetVal := aapiJob.CreateJob(
                anJobID       => lnJobID,
                asPartNo      => asPartNo,
                anRevision    => anRevision,
                anJobType     => JOBTYPE_FEA,
                anParentJobID => anJobID
            );
        END IF;
        IF  lnRetVal = iapiConstantDBError.DBERR_SUCCESS 
        AND lsFrameNo IN (
          'E_PCR',
          'A_PCR_v1',
          'A_PCR'
        ) THEN
            lnRetVal := aapiJob.CreateJob(
                anJobID       => lnJobID,
                asPartNo      => asPartNo,
                anRevision    => anRevision,
                anJobType     => JOBTYPE_CATIA,
                anParentJobID => anJobID
            );
        END IF;
        IF  lnRetVal = iapiConstantDBError.DBERR_SUCCESS 
        AND lsFrameNo IN (
          'A_OHT'
        ) THEN
            lnRetVal := aapiJob.CreateJob(
                anJobID       => lnJobID,
                asPartNo      => asPartNo,
                anRevision    => anRevision,
                anJobType     => JOBTYPE_CATIAJOB,
                anParentJobID => anJobID
            );
        END IF;
        IF  lnRetVal = iapiConstantDBError.DBERR_SUCCESS THEN
            lnRetVal := aapiJob.CreateJob(
                anJobID       => lnJobID,
                asPartNo      => asPartNo,
                anRevision    => anRevision,
                anJobType     => JOBTYPE_TOSUBMIT,
                anParentJobID => anJobID
            );
        END IF;

        IF lnRetVal = iapiConstantDbError.DBERR_ERRORLIST THEN
            FETCH lqErrors
            BULK COLLECT INTO ltErrors;
    
            IF ltErrors.COUNT > 0 THEN
                FOR lnIndex IN ltErrors.FIRST .. ltErrors.LAST LOOP
                    lrError := ltErrors(lnIndex);
                    lsErrMsg := lrError.ErrorText || ' (' || lrError.ErrorParameterId || ')';
                    dbms_output.put_line(lsErrMsg);
                    iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
                    aapiTrace.Error(lsErrMsg);
                END LOOP;
            END IF;
        END IF;
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
            lsErrMsg := iapiGeneral.GetLastErrorText();
            dbms_output.put_line(lsErrMsg);
            iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
            aapiTrace.Error(lsErrMsg);
        END IF;
        
        lnErrNum := aapiJob.SetJobResult(anJobID, lnRetVal);
        aapiTrace.Exit(lnRetVal);
        RETURN lnRetVal;
    EXCEPTION
    WHEN OTHERS THEN
        lsErrMsg := SQLERRM;
        dbms_output.put_line(lsErrMsg);
        iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
        
        aapiTrace.Error(lsErrMsg);
        aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
        RETURN iapiConstantDbError.DBERR_GENFAIL;
    END;
    
    
    FUNCTION ProcessCleanJob(
        anJobID    IN iapiType.ID_Type,
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type
    ) RETURN iapiType.ErrorNum_Type
    AS
        lsMethod  iapiType.Method_Type := 'ProcessCleanJob';
        lnRetVal  iapiType.ErrorNum_Type;
        lsErrMsg  iapiType.ErrorText_Type;
        lnErrNum  iapiType.ErrorNum_Type;
        lsFrameNo iapiType.FrameNo_Type;
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('anJobID', anJobID);
        aapiTrace.Param('asPartNo', asPartNo);
        aapiTrace.Param('anRevision', anRevision);

        lnRetVal := iapiConstantDBError.DBERR_SUCCESS;
        
        SELECT frame_id
        INTO lsFrameNo
        FROM specification_header
        WHERE part_no  = asPartNo
          AND revision = anRevision;
        
        IF lsFrameNo IN (
            'A_Global_Beadwire',
            'A_Global_Fabric',
            'A_Global_Steelcord',
            'A_OHT',
            'E_FM',
            'E_PCR',
            'A_PCR_v1',
            'A_PCR',
            'Global compound',
            'A_CMPD_FM v1',
			'A_FEA_Materials'
        ) THEN
            lnRetVal := aapiFea.CleanObjects(asPartNo, anRevision);
        END IF;
        
        IF lnRetVal = iapiConstantDBError.DBERR_SUCCESS
        AND lsFrameNo IN (
          'E_PCR',
          'A_PCR_v1',
          'A_PCR',
          'A_OHT'
        ) THEN
            lnRetVal := aapiCatia.CleanDSpecObjects(asPartNo, anRevision);
        END IF;
        
        lnErrNum := aapiJob.SetJobResult(anJobID, lnRetVal);
        aapiTrace.Exit(lnRetVal);
        RETURN lnRetVal;
    EXCEPTION
    WHEN OTHERS THEN
        lsErrMsg := SQLERRM;
        dbms_output.put_line(lsErrMsg);
        iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
        
        aapiTrace.Error(lsErrMsg);
        aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
        RETURN iapiConstantDbError.DBERR_GENFAIL;
    END;
    
    
    FUNCTION ChangeStatus(
        anJobID    IN iapiType.ID_Type,
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type,
        anStatusID IN iapiType.StatusID_Type
    ) RETURN iapiType.ErrorNum_Type
    AS
        lsMethod       iapiType.Method_Type := 'ChangeStatus';
        lsErrMsg       iapiType.ErrorText_Type;
        lnErrNum       iapiType.ErrorNum_Type;
        lnRetVal       iapiType.ErrorNum_Type;
        lqErrors       iapiType.Ref_Type;
        lrError        iapiType.ErrorRec_Type;
        ltErrors       iapiType.ErrorTab_type;
        lsFrameNo      iapiType.FrameNo_Type;
        lnFrameRev     iapiType.Revision_Type;
        lnStatusID     iapiType.StatusID_Type;
        lnStatusDesc   iapiType.ShortDescription_Type;
        lnNextStatusID iapiType.StatusID_Type;
        lsUserID       iapiType.UserID_Type;
        lsFirstName    iapiType.ForeName_Type;
        lsLastName     iapiType.LastName_Type;
        lsPhone        iapiType.Telephone_Type;
        lsEmail        iapiType.EmailAddress_Type;
        lnAccessGroup  iapiType.ID_Type;
        lnDummy        iapiType.ID_Type;
        ltRecipients   iapiType.EmailToTab_Type;
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('anJobID', anJobID);
        aapiTrace.Param('asPartNo', asPartNo);
        aapiTrace.Param('anRevision', anRevision);
        aapiTrace.Param('anStatusID', anStatusID);

        SELECT frame_id, frame_rev
        INTO lsFrameNo, lnFrameRev
        FROM specification_header
        WHERE part_no = asPartNo
          AND revision = anRevision;
    
        SELECT access_group
        INTO lnAccessGroup
        FROM frame_header
        WHERE frame_no = lsFrameNo
          AND revision = lnFrameRev;

        lnRetVal := apao_pre_post_func.LocalizeFrameData(asPartNo, lnAccessGroup, lnDummy);
        
        IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS THEN
            lnRetVal := iapiSpecification.SaveHeader(
                asPartNo          => asPartNo,
                anRevision        => anRevision,
                anWorkFlowGroupId => NULL,
                anAccessGroupId   => lnAccessGroup,
                anMultiLanguage   => NULL,
                anSpecTypeId      => NULL,
                anLanguageId      => NULL,
                aqErrors          => lqErrors
            );
            
            SELECT status
            INTO   lnStatusID
            FROM   specification_header
            WHERE  part_no = asPartNo
              AND  revision = anRevision;
            
            IF lnRetVal = iapiConstantDBError.DBERR_SUCCESS THEN
                lnRetVal := iapiSpecificationStatus.StatusChange(
                    anCurrentStatus => lnStatusID,
                    anRevision      => anRevision,
                    asPartNo        => asPartNo,
                    anNextStatus    => anStatusID,
                    asUserId        => 'JOBQUEUE',
                    aqErrors        => lqErrors
                );
            END IF;
            
            IF anStatusID = 1 OR lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
                SELECT user_id
                INTO lsUserID
                FROM atJobQueue
                WHERE job_id = (
                    SELECT parent_job_id
                    FROM atJobQueue
                    WHERE job_id = anJobID
                );
                
                /*
                SELECT MAX(result_code)
                INTO lnErrNum
                FROM atJobQueue
                WHERE (
                    SELECT parent_job_id
                    FROM atJobQueue
                    WHERE job_id = anJobID
                ) IN (job_id, parent_job_id);
    
                SELECT email_address
                BULK COLLECT INTO ltRecipients
                FROM application_user
                WHERE user_id IN ('MVL', 'WAR', lsUserID);
                */

                SELECT email_address
                BULK COLLECT INTO ltRecipients
                FROM application_user
                WHERE user_id = lsUserID
                UNION ALL
                SELECT 'Xpert.System@apollotyres.com'
                FROM dual;
                
                
                SELECT forename, last_name, telephone_no, email_address
                INTO lsFirstName, lsLastName, lsPhone, lsEmail
                FROM application_user
                WHERE user_id = lsUserID;
            
                lnErrNum := iapiEmail.SendEmail(
                    asSender     => NULL,
                    atRecipients => ltRecipients,
                    asSubject    => 'Job ' || TO_CHAR(anJobID) || ' failed: ' || asPartNo || '[' || TO_CHAR(anRevision) || ']',
                    
                    asBody => 'JOB_ID: ' || TO_CHAR(anJobID) || CHR(13) || CHR(10) ||
                              'REQUESTER: ' || lsUserID || CHR(13) || CHR(10) ||
                              'NAME: ' || lsFirstName || ' ' || lsLastName || CHR(13) || CHR(10) ||
                              'EMAIL: ' || lsEmail || CHR(13) || CHR(10) ||
                              'PHONE: ' || lsPhone || CHR(13) || CHR(10) ||
                              --'ERROR: ' || TO_CHAR(lnErrNum) || CHR(13)|| CHR(10) ||
                              CHR(13)|| CHR(10) ||
                              'PART_NO: ' || asPartNo || CHR(13) || CHR(10) ||
                              'REVISION: ' || TO_CHAR(anRevision) || CHR(13) || CHR(10) ||
                              'OUTPUT: \\ensdnas01\xpert_shared$\X_Section\Output\Temp\'
                              || REPLACE(utl_url.escape(asPartNo, TRUE), '%', '$')
                              || '#' || TO_CHAR(anRevision),
                    anNumberRecipients => ltRecipients.COUNT
                );
            END IF;
        END IF;
        
        IF lnRetVal = iapiConstantDbError.DBERR_ERRORLIST THEN
            FETCH lqErrors
            BULK COLLECT INTO ltErrors;
    
            IF ltErrors.COUNT > 0 THEN
                FOR lnIndex IN ltErrors.FIRST .. ltErrors.LAST LOOP
                    lrError := ltErrors(lnIndex);
                    lsErrMsg := lrError.ErrorText || ' (' || lrError.ErrorParameterId || ')';
                    dbms_output.put_line(lsErrMsg);
                    iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
                    aapiTrace.Error(lsErrMsg);
                END LOOP;
            END IF;
        END IF;
        
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
            lsErrMsg := iapiGeneral.GetLastErrorText();
            dbms_output.put_line(lsErrMsg);
            iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
            aapiTrace.Error(lsErrMsg);
        END IF;

        lnErrNum := aapiJob.SetJobResult(anJobID, lnRetVal);
        aapiTrace.Exit(lnRetVal);
        RETURN lnRetVal;
    EXCEPTION
    WHEN OTHERS THEN
        lsErrMsg := SQLERRM || CHR(13) || CHR(10) || dbms_utility.format_error_backtrace();
        dbms_output.put_line(lsErrMsg);
        iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
        
        aapiTrace.Error(lsErrMsg);
        aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
        RETURN iapiConstantDbError.DBERR_GENFAIL;
    END;


    FUNCTION ProcessToSubmitJob(
        anJobID    IN iapiType.ID_Type,
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type
    ) RETURN iapiType.ErrorNum_Type
    AS
        lsMethod       iapiType.Method_Type := 'ProcessToSubmitJob';
        lnStatusID     iapiType.StatusID_Type;
        lnStatusDesc   iapiType.ShortDescription_Type;
        lnNextStatusID iapiType.StatusID_Type := 0;
        lsErrMsg       iapiType.ErrorText_Type;
        lnRetVal       iapiType.ErrorNum_Type := iapiConstantDBError.DBERR_SUCCESS;
        lnParentJobID  iapiType.ID_Type;
        ldCreated      DATE;
        lnCount        NUMBER;
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('anJobID', anJobID);
        aapiTrace.Param('asPartNo', asPartNo);
        aapiTrace.Param('anRevision', anRevision);

        SELECT job_created, parent_job_id
        INTO ldCreated, lnParentJobID
        FROM atJobQueue
        WHERE job_id = anJobID;

        SELECT COUNT(*)
        INTO lnCount
        FROM atJobQueue
        WHERE job_id <> anJobID
          AND part_no = asPartNo
          AND revision = anRevision
          AND parent_job_id = lnParentJobID
          AND result_code IS NULL;
    
        IF lnCount = 0 THEN
            SELECT COUNT(*)
            INTO lnCount
            FROM atJobQueue
            WHERE part_no = asPartNo
            AND revision = anRevision
            AND parent_job_id = lnParentJobID
            AND result_code <> iapiConstantDBError.DBERR_SUCCESS;
        
            IF lnCount = 0 THEN
                SELECT status
                INTO   lnStatusID
                FROM   specification_header
                WHERE  part_no = asPartNo
                  AND  revision = anRevision;
                  
                SELECT sort_desc
                INTO   lnStatusDesc
                FROM   status
                WHERE  status = lnStatusID;
                lnStatusDesc := REPLACE(lnStatusDesc, 'FREEZE', 'SUBMIT');
            
                SELECT status
                INTO   lnNextStatusID
                FROM   status
                WHERE  sort_desc = lnStatusDesc;
            ELSE
                SELECT status
                INTO   lnNextStatusID
                FROM   status
                WHERE  sort_desc = 'DEV';
            END IF;
            
            lnRetVal := ChangeStatus(
                anJobID    => anJobID,
                asPartNo   => asPartNo,
                anRevision => anRevision,
                anStatusID => lnNextStatusID
            );
        ELSIF ldCreated + 15 / 24 / 60 <= SYSDATE THEN
            SELECT status
            INTO   lnNextStatusID
            FROM   status
            WHERE  sort_desc = 'DEV';
            
            lnRetVal := ChangeStatus(
                anJobID    => anJobID,
                asPartNo   => asPartNo,
                anRevision => anRevision,
                anStatusID => lnNextStatusID
            );

            lnRetVal := iapiConstantDBError.DBERR_MANUALCONDNOTSATISFIED;
        ELSE
            UPDATE atJobQueue
            SET    job_started = NULL
            WHERE  job_id = anJobID;
            COMMIT;
            
            lnRetVal := iapiConstantDBError.DBERR_SUCCESS;
        END IF;
        
        aapiTrace.Exit(lnRetVal);
        RETURN lnRetVal;
    EXCEPTION
    WHEN OTHERS THEN
        lsErrMsg := SQLERRM;
        dbms_output.put_line(lsErrMsg);
        iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
        
        aapiTrace.Error(lsErrMsg);
        aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
        RETURN iapiConstantDbError.DBERR_GENFAIL;
    END;

    
    FUNCTION ProcessJob(
        anJobID    IN iapiType.ID_Type,
        anJobType  IN iapiType.ID_Type,
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type
    ) RETURN iapiType.ErrorNum_Type
    AS
        lsMethod   iapiType.Method_Type := 'ProcessJob';
        lnIntl     iapiType.Boolean_Type;
        lsErrMsg   iapiType.ErrorText_Type;
        lnRetVal   iapiType.ErrorNum_Type := iapiConstantDBError.DBERR_JOBNOTFOUND;
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('anJobID', anJobID);
        aapiTrace.Param('anJobType', anJobType);
        aapiTrace.Param('asPartNo', asPartNo);
        aapiTrace.Param('anRevision', anRevision);

        lnRetVal := SetIntlMode(asPartNo, anRevision);

        IF anJobType = JOBTYPE_FINALIZE THEN
            lnRetVal := ProcessFinalizeJob(anJobID, asPartNo, anRevision);
        ELSIF anJobType = JOBTYPE_CLEAN THEN
            lnRetVal := ProcessCleanJob(anJobID, asPartNo, anRevision);
        ELSIF anJobType = JOBTYPE_CATIA THEN
            lnRetVal := aapiCatia.CreateCatiaDatafiles(asPartNo, anRevision);
        ELSIF anJobType = JOBTYPE_CATIAJOB THEN
            lnRetVal := aapiCatia.CreateCatiaJobFile(asPartNo, anRevision);
        ELSIF anJobType = JOBTYPE_MESH THEN
            lnRetVal := iapiConstantDBError.DBERR_JOBNOTFOUND; --TODO
        ELSIF anJobType = JOBTYPE_CCODE THEN
            lnRetVal := iapiConstantDBError.DBERR_JOBNOTFOUND; --TODO
        ELSIF anJobType = JOBTYPE_TOSUBMIT THEN
            lnRetVal := ProcessToSubmitJob(anJobID, asPartNo, anRevision);
        --ELSIF anJobType = JOBTYPE_CANCEL THEN
        --    lnRetVal := ProcessCancelJob(anJobID, asPartNo, anRevision);
        ELSIF anJobType = JOBTYPE_FEA THEN
            lnRetVal := aapiFea.CreateMaterialFiles(asPartNo, anRevision);
        END IF;
        
        aapiTrace.Exit(lnRetVal);
        RETURN lnRetVal;
    EXCEPTION
    WHEN OTHERS THEN
        lsErrMsg := SQLERRM;
        dbms_output.put_line(lsErrMsg);
        iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
        
        aapiTrace.Error(lsErrMsg);
        aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
        RETURN iapiConstantDbError.DBERR_GENFAIL;
    END;
    
    FUNCTION SetIntlMode(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type
    ) RETURN iapiType.ErrorNum_Type
    AS
        lsMethod iapiType.Method_Type := 'SetIntlMode';
        lsErrMsg iapiType.ErrorText_Type;
        lnIntl   iapiType.Boolean_Type;
        lnRetVal iapiType.ErrorNum_Type;
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('asPartNo', asPartNo);
        aapiTrace.Param('anRevision', anRevision);

        SELECT intl
        INTO lnIntl
        FROM specification_header
        WHERE part_no = asPartNo
        AND revision = anRevision;
        
        lnRetVal := iapiGeneral.SetMode(lnIntl);
        
        aapiTrace.Exit(lnRetVal);
        RETURN lnRetVal;
    EXCEPTION
    WHEN OTHERS THEN
        lsErrMsg := SQLERRM;
        dbms_output.put_line(lsErrMsg);
        iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
        
        aapiTrace.Error(lsErrMsg);
        aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
        RETURN iapiConstantDbError.DBERR_GENFAIL;
    END;
    
END AAPIJOBDELEGATES;
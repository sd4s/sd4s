create or replace PACKAGE BODY            "AAPIJOB" AS

    psSource  CONSTANT iapiType.Source_Type := 'aapiJob';
    psJobName CONSTANT VARCHAR2(30 CHAR)    := 'JOBQUEUE';

    FUNCTION CreateJob(
        anJobID       OUT iapiType.ID_Type,
        asPartNo      IN  iapiType.PartNo_Type,
        anRevision    IN  iapiType.Revision_Type,
        anJobType     IN  iapiType.ID_Type,
        anParentJobID IN iapiType.ID_Type DEFAULT NULL
    ) RETURN iapiType.ErrorNum_Type
    AS
        lsMethod iapiType.Method_Type := 'CreateJob';
        lsErrMsg iapiType.ErrorText_Type;
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('asPartNo', asPartNo);
        aapiTrace.Param('anRevision', anRevision);
        aapiTrace.Param('anJobType', anJobType);
        aapiTrace.Param('anParentJobID', anParentJobID);

        INSERT INTO atJobQueue (
            job_id,
            job_type,
            job_created,
            part_no,
            revision,
            user_id,
            parent_job_id
        ) VALUES (
            atJobID_Seq.NEXTVAL,
            anJobType,
            SYSDATE,
            asPartNo,
            anRevision,
            USER,
            anParentJobID
        )
        RETURNING job_id INTO anJobID;
        
        dbms_alert.signal(psJobName, TO_CHAR(anJobID));
        
        COMMIT;

        aapiTrace.Exit(iapiConstantDBError.DBERR_SUCCESS);
        RETURN iapiConstantDBError.DBERR_SUCCESS;
    EXCEPTION
    WHEN OTHERS THEN
        lsErrMsg := SQLERRM;
        dbms_output.put_line(lsErrMsg);
        iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
        
        aapiTrace.Error(lsErrMsg);
        aapiTrace.Exit(iapiConstantDBError.DBERR_GENFAIL);
        RETURN iapiConstantDbError.DBERR_GENFAIL;
    END;
    
    
    PROCEDURE StartJobQueue
    AS
        lsCommand VARCHAR2(256 CHAR) := 'aapiJob.ProcessJobQueue;';
        lnCount   NUMBER;
        lnJob     BINARY_INTEGER;
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        aapiTrace.Enter();
        
        SELECT COUNT(*)
        INTO lnCount
        FROM dba_jobs
        WHERE what = lsCommand;
    
        IF lnCount = 0 THEN
            dbms_job.submit(
                job       => lnJob,
                what      => lsCommand,
                next_date => SYSDATE,
                interval  => 'SYSDATE + 1/24/60'
            );
            COMMIT;
        END IF;
        
        aapiTrace.Exit();
    END;
    
    
    PROCEDURE ProcessJobQueue AS
        CURSOR lqJobs IS
            SELECT job_id
            FROM atJobQueue
            WHERE job_started IS NULL
            ORDER BY job_created, job_id;
            
        lsMethod  iapiType.Method_Type := 'ProcessJobQueue';
        lsErrMsg  iapiType.ErrorText_Type;
        lnRetVal  iapiType.ErrorNum_Type;
    BEGIN
        aapiTrace.Enter();
    
        FOR lrJob IN lqJobs LOOP
            lnRetVal := ProcessJob(lrJob.job_id);
            COMMIT;
        END LOOP;
        
        aapiTrace.Exit();
    EXCEPTION
    WHEN OTHERS THEN
        lsErrMsg := SQLERRM;
        dbms_output.put_line(lsErrMsg);
        iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
        
        lnRetVal := iapiGeneral.SetErrorText(iapiConstantDBError.DBERR_GENFAIL);
        aapiTrace.Error(iapiGeneral.GetLastErrorText());
        aapiTrace.Exit();
        raise_application_error(-20000, iapiGeneral.GetLastErrorText());
    END;
    
    
    PROCEDURE JobQueueAgent AS
        lsMessage VARCHAR2(1800);
        lnStatus  INTEGER;
    BEGIN
        aapiTrace.Enter();
        dbms_alert.register(psJobName);
    
        LOOP
            dbms_alert.WaitOne(psJobName, lsMessage, lnStatus, 30);
            
            IF lsMessage = 'EXIT' THEN
                EXIT;
            ELSE
                ProcessJobQueue;
            END IF;
        END LOOP;
        
        aapiTrace.Exit();
    END;


    PROCEDURE StopJobQueue
    AS
    BEGIN
        aapiTrace.Enter();
        
        dbms_alert.signal(psJobName, 'EXIT');
        COMMIT;
        
        aapiTrace.Exit();
    END;
    
    
    FUNCTION StartJob(
        anJobID    IN  iapiType.ID_Type,
        anJobType  OUT iapiType.ID_Type,
        asPartNo   OUT iapiType.PartNo_Type,
        anRevision OUT iapiType.Revision_Type
    ) RETURN iapiType.ErrorNum_Type
    AS
        lsMethod   iapiType.Method_Type := 'StartJob';
        lsErrMsg   iapiType.ErrorText_Type;
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('anJobID', anJobID);
      
        UPDATE atJobQueue
        SET    job_started = SYSDATE
        WHERE  job_id = anJobID
        RETURNING job_type, part_no, revision
        INTO anJobType, asPartNo, anRevision;
        COMMIT;
        
        aapiTrace.Exit(iapiConstantDBError.DBERR_SUCCESS);
        RETURN iapiConstantDBError.DBERR_SUCCESS;
    EXCEPTION
    WHEN OTHERS THEN
        lsErrMsg := SQLERRM;
        dbms_output.put_line(lsErrMsg);
        iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
        
        aapiTrace.Error(lsErrMsg);
        aapiTrace.Exit(iapiConstantDBError.DBERR_GENFAIL);
        RETURN iapiConstantDBError.DBERR_GENFAIL;
    END;


    FUNCTION ProcessJob(
        anJobID IN iapiType.ID_Type
    ) RETURN iapiType.ErrorNum_Type
    AS
        lsMethod   iapiType.Method_Type := 'ProcessJob';
        lsErrMsg   iapiType.ErrorText_Type;
        lnRetVal   iapiType.ErrorNum_Type;
        lnErrNum   iapiType.ErrorNum_Type;
        lnJobType  iapiType.ID_Type;
        lsPartNo   iapiType.PartNo_Type;
        lnRevision iapiType.Revision_Type;
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('anJobID', anJobID);

        lnRetVal := iapiGeneral.SetConnection(psJobName);

        lnRetVal := StartJob(
            anJobID    => anJobID,
            anJobType  => lnJobType,
            asPartNo   => lsPartNo,
            anRevision => lnRevision
        );
        
        IF lnRetVal = iapiConstantDBError.DBERR_SUCCESS THEN
            lnRetVal := aapiJobDelegates.ProcessJob(
                anJobID    => anJobID,
                anJobType  => lnJobType,
                asPartNo   => lsPartNo,
                anRevision => lnRevision
            );
            COMMIT;
        END IF;
        
        IF lnRetVal <> iapiConstantDBError.DBERR_SUCCESS THEN
            lsErrMsg := iapiGeneral.GetLastErrorText();
            dbms_output.put_line(lsErrMsg);
            iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);

            lnErrNum := SetJobResult(anJobID, lnRetVal);
        END IF;
        
        aapiTrace.Exit(lnRetVal);
        RETURN lnRetVal;
    EXCEPTION
    WHEN OTHERS THEN
        lsErrMsg := SQLERRM;
        dbms_output.put_line(lsErrMsg);
        iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
        
        aapiTrace.Error(lsErrMsg);
        aapiTrace.Exit(iapiConstantDBError.DBERR_GENFAIL);
        RETURN iapiConstantDbError.DBERR_GENFAIL;
    END;

    
    FUNCTION SetJobResult(
        anJobID  IN iapiType.ID_Type,
        anResult IN iapiType.ErrorNum_Type
    ) RETURN iapiType.ErrorNum_Type
    AS
        lsMethod iapiType.Method_Type := 'SetJobResult';
        lsErrMsg iapiType.ErrorText_Type;
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('anJobID', anJobID);
        aapiTrace.Param('anResult', anResult);
    
        UPDATE atJobQueue
        SET job_finished = SYSDATE,
            result_code = anResult
        WHERE job_id = anJobID;
        IF SQL%ROWCOUNT = 0 THEN
            RETURN iapiConstantDBError.DBERR_JOBNOTFOUND;
        END IF;

        dbms_alert.signal(psJobName, anJobID);
        COMMIT;
 
        aapiTrace.Exit(iapiConstantDBError.DBERR_SUCCESS);
        RETURN iapiConstantDBError.DBERR_SUCCESS;
    EXCEPTION
    WHEN OTHERS THEN
        lsErrMsg := SQLERRM;
        dbms_output.put_line(lsErrMsg);
        iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
        
        aapiTrace.Error(lsErrMsg);
        aapiTrace.Exit(iapiConstantDBError.DBERR_GENFAIL);
        RETURN iapiConstantDBError.DBERR_GENFAIL;
    END;


    FUNCTION GetJobID(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type,
        anJobType  IN iapiType.ID_Type
    ) RETURN iapiType.ID_Type
    AS
        lsMethod iapiType.Method_Type := 'GetJobID';
        lsErrMsg iapiType.ErrorText_Type;
        lnJobID  iapiType.ID_Type;
    BEGIN
        aapiTrace.Enter();
        aapiTrace.Param('asPartNo', asPartNo);
        aapiTrace.Param('anRevision', anRevision);
        aapiTrace.Param('anJobType', anJobType);
        
        SELECT MAX(job_id)
        INTO lnJobID
        FROM atJobQueue
        WHERE part_no = asPartNo
          AND revision = anRevision
          AND job_type = anJobType;
          
        aapiTrace.Exit(lnJobID);
        RETURN lnJobID;
    EXCEPTION
    WHEN OTHERS THEN
        lsErrMsg := SQLERRM;
        dbms_output.put_line(lsErrMsg);
        iapiGeneral.LogError(psSource, lsMethod, lsErrMsg);
        
        aapiTrace.Error(lsErrMsg);
        aapiTrace.Exit();
        RETURN NULL;
    END;

END AAPIJOB;
create or replace PACKAGE            "AAPIJOB" AS 

    FUNCTION CreateJob(
        anJobID       OUT iapiType.ID_Type,
        asPartNo      IN  iapiType.PartNo_Type,
        anRevision    IN  iapiType.Revision_Type,
        anJobType     IN  iapiType.ID_Type,
        anParentJobID IN iapiType.ID_Type DEFAULT NULL
    ) RETURN iapiType.ErrorNum_Type;
    
    PROCEDURE StartJobQueue;
    
    PROCEDURE ProcessJobQueue;

    PROCEDURE JobQueueAgent;

    PROCEDURE StopJobQueue;
    
    FUNCTION ProcessJob(
        anJobID IN iapiType.ID_Type
    ) RETURN iapiType.ErrorNum_Type;
    
    FUNCTION SetJobResult(
        anJobID  IN iapiType.ID_Type,
        anResult IN iapiType.ErrorNum_Type
    ) RETURN iapiType.ErrorNum_Type;

    FUNCTION GetJobID(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type,
        anJobType  IN iapiType.ID_Type
    ) RETURN iapiType.ID_Type;

END AAPIJOB;
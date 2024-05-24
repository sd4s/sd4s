create or replace PACKAGE "AAPIJOBDELEGATES" AS 

    JOBTYPE_FINALIZE CONSTANT NUMBER := 0;
    JOBTYPE_CLEAN    CONSTANT NUMBER := 1;
    JOBTYPE_CATIA    CONSTANT NUMBER := 2;
    JOBTYPE_MESH     CONSTANT NUMBER := 3;
    JOBTYPE_CCODE    CONSTANT NUMBER := 4;
    JOBTYPE_TOSUBMIT CONSTANT NUMBER := 5;
    JOBTYPE_CATIAJOB CONSTANT NUMBER := 6;
    JOBTYPE_FEA      CONSTANT NUMBER := 8;

    FUNCTION ProcessJob(
        anJobID    IN iapiType.ID_Type,
        anJobType  IN iapiType.ID_Type,
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type
    ) RETURN iapiType.ErrorNum_Type;
    
    FUNCTION SetIntlMode(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type
    ) RETURN iapiType.ErrorNum_Type;

END AAPIJOBDELEGATES;
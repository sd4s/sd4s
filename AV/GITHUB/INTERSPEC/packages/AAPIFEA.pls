create or replace PACKAGE AAPIFEA AS 

    FUNCTION CleanObjects(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type
    ) RETURN iapiType.ErrorNum_Type;

    FUNCTION CreateMaterialFiles(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type
    ) RETURN iapiType.ErrorNum_Type;

    FUNCTION GetHyperMaterialfile(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type,
        abResult   OUT aapiBlob.t_raw --IN OUT NOCOPY BLOB
    ) RETURN iapiType.ErrorNum_Type;

    FUNCTION GetRRMaterialfile(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type,
        abResult   OUT aapiBlob.t_raw --IN OUT NOCOPY BLOB
    ) RETURN iapiType.ErrorNum_Type;

    FUNCTION GetCatPart(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type,
        abResult   OUT aapiBlob.t_raw --IN OUT NOCOPY BLOB
    ) RETURN iapiType.ErrorNum_Type;

    FUNCTION ValidateValues(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type
    ) RETURN iapiType.ErrorNum_Type;        

END AAPIFEA;
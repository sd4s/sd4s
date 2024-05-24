CREATE OR REPLACE PACKAGE INTERSPC."AAPICATIA" AS 

    FUNCTION CreateCatiaDatafiles(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type
    ) RETURN iapiType.ErrorNum_Type;

    FUNCTION CreateCatiaJobFile(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type
    ) RETURN iapiType.ErrorNum_Type;

    FUNCTION CleanDSpecObjects(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type
    ) RETURN iapiType.ErrorNum_Type;

    FUNCTION AssignObjectToDSpec(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type,
        asFilename IN iapiType.ShortDescription_Type,
        abData     IN iapiType.Blob_Type
    ) RETURN iapiType.ErrorNum_Type;

    FUNCTION SetJobResult(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type,
        anResult   IN iapiType.ErrorNum_Type
    ) RETURN iapiType.ErrorNum_Type;

END AAPICATIA;
/

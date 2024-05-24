create or replace PACKAGE AAPITEMPLATE AS 

    FUNCTION Parse(
        abTemplate IN  CLOB,
        abOutput   OUT CLOB,
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type
    ) RETURN iapiType.ErrorNum_Type;
    
    FUNCTION Bind(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type,
        asProperty IN VARCHAR2,
        asFormat   IN VARCHAR2 DEFAULT NULL,
        asBomItem  IN VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2;

END AAPITEMPLATE;
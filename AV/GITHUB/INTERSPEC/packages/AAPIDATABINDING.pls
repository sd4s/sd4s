create or replace PACKAGE AAPIDATABINDING AS 

    FUNCTION GetPropertyValue(
        asPartNo        IN iapiType.PartNo_Type,
        anRevision      IN iapiType.Revision_Type,
        anSection       IN iapiType.ID_Type,
        anSubSection    IN iapiType.ID_Type,
        anPropertyGroup IN iapiType.ID_Type,
        anProperty      IN iapiType.ID_Type,
        anAttribute     IN iapiType.ID_Type,
        anHeader        IN iapiType.ID_Type,
        anRawValue      IN iapiType.Boolean_Type DEFAULT 0
    ) RETURN iapiType.StringVal_Type;

    FUNCTION PropertyBinding(
        asPartNo   IN  iapiType.PartNo_Type,
        anRevision IN  iapiType.Revision_Type,
        asPath     IN  iapiType.StringVal_Type,
        anRawValue IN iapiType.Boolean_Type DEFAULT 0
    ) RETURN iapiType.StringVal_Type;

END AAPIDATABINDING;
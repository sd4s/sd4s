create or replace PACKAGE
    aapiXpert
AS

    FUNCTION GetFrame(
        asPartNo   IN  iapiType.PartNo_Type,
        anRevision IN  iapiType.Revision_Type,
        asFrameNo  OUT iapiType.FrameNo_Type
    )
    RETURN iapiType.ErrorNum_Type;

    FUNCTION CreateSpecification(
        asFromPartNo  IN  iapiType.PartNo_Type      DEFAULT NULL,
        asPartNo      IN  iapiType.PartNo_Type,
        asDescription IN  iapiType.Description_Type DEFAULT NULL,
        asFrameId     IN  iapiType.FrameNo_Type     DEFAULT NULL,
        asPlant       IN  iapiType.Plant_Type       DEFAULT 'ENS',
        anNewRevision OUT iapiType.Revision_Type
    )
    RETURN iapiType.ErrorNum_Type;

    FUNCTION FilterSpecByProperty(
        asPlant         IN iapiType.Plant_Type       DEFAULT NULL,
        asFrameId       IN iapiType.FrameNo_Type     DEFAULT NULL,
        asSection       IN iapiType.Description_Type DEFAULT NULL,
        asSubsection    IN iapiType.Description_Type DEFAULT NULL,
        asPropertyGroup IN iapiType.Description_Type DEFAULT NULL,
        asProperty      IN iapiType.Description_Type,
        asHeader        IN iapiType.Description_Type DEFAULT 'Value',
        asTextValue     IN iapiType.PropertyShortString_Type DEFAULT NULL,
        anMinValue      IN iapiType.Float_Type       DEFAULT NULL,
        anMaxValue      IN iapiType.Float_Type       DEFAULT NULL,
        anChainFilter   IN iapiType.Boolean_Type     DEFAULT 0,
        arSpecRefList   IN OUT SpecRefTable_Type
    )
    RETURN iapiType.ErrorNum_Type;

    FUNCTION FilterSpecByBom(
        asPlant       IN     iapiType.Plant_Type   DEFAULT NULL,
        asFrameId     IN     iapiType.FrameNo_Type DEFAULT NULL,
        arBomItemList IN     SpecRefTable_Type,
        anChainFilter IN     iapiType.Boolean_Type DEFAULT 0,
        arSpecRefList IN OUT SpecRefTable_Type
    )
    RETURN iapiType.ErrorNum_Type;
    
    FUNCTION RefreshFrame(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type DEFAULT NULL
    )
    RETURN iapiType.ErrorNum_Type;

END aapiXpert;
create or replace PACKAGE AAPIVALIDATION AS 

    gsSource      iapiType.Source_Type  := 'aapiValidation';
    gsTestPattern iapiType.String_Type  := '^T[^_]{0,3}_';
    gsUndefined   iapiType.String_Type  := CHR(0);
    gnCalculating iapiType.Boolean_Type := 0;
    gsWarning     iapiType.String_Type  := 'W';
    gsValidation  iapiType.String_Type  := 'V';
    gsCalculation iapiType.String_Type  := 'C';

    FUNCTION FormatQuery(
        asRule IN iapiType.StringVal_Type
    ) RETURN iapiType.StringVal_Type;
    
    FUNCTION CustomValidation(
        asPartNo        IN iapiType.PartNo_Type,
        anRevision      IN iapiType.Revision_Type,
        anSection       IN iapiType.ID_Type,
        anSubSection    IN iapiType.ID_Type,
        anPropertyGroup IN iapiType.ID_Type,
        anProperty      IN iapiType.ID_Type,
        anAttribute     IN iapiType.ID_Type,
        anHeader        IN iapiType.ID_Type,
        asMandatory     IN iapiType.Mandatory_Type,
        asRule          IN iapiType.StringVal_Type,
        asArg1          IN iapiType.StringVal_Type DEFAULT NULL,
        asArg2          IN iapiType.StringVal_Type DEFAULT NULL
    ) RETURN iapiType.ErrorNum_Type;
    
    FUNCTION CustomCalculation(
        asPartNo        IN iapiType.PartNo_Type,
        anRevision      IN iapiType.Revision_Type,
        anSection       IN iapiType.ID_Type,
        anSubSection    IN iapiType.ID_Type,
        anPropertyGroup IN iapiType.ID_Type,
        anProperty      IN iapiType.ID_Type,
        anAttribute     IN iapiType.ID_Type,
        anHeader        IN iapiType.ID_Type,
        asMandatory     IN iapiType.Mandatory_Type,
        asRule          IN iapiType.StringVal_Type,
        asArg1          IN iapiType.StringVal_Type DEFAULT NULL,
        asArg2          IN iapiType.StringVal_Type DEFAULT NULL
    ) RETURN iapiType.ErrorNum_Type;
    
    PROCEDURE ClearRulesOnCopySpec;

    PROCEDURE ClearRulesOnStatusChange;

    FUNCTION ClearRules(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type
    ) RETURN iapiType.ErrorNum_Type;
        
    PROCEDURE ValidateAccessOnSaveProp;

    PROCEDURE ValidateRulesOnSaveProp;

    FUNCTION ValidateRules(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type,
        asRuleType IN iapiType.StringVal_Type
    ) RETURN iapiType.ErrorNum_Type;
    
    FUNCTION ExecuteRules(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type,
        asRuleType IN iapiType.StringVal_Type DEFAULT NULL
    ) RETURN iapiType.ErrorNum_Type;

    FUNCTION Bind(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type,
        asPath     IN iapiType.StringVal_Type,
        asAlign    IN iapiType.StringVal_Type DEFAULT NULL
    ) RETURN iapiType.StringVal_Type;

    FUNCTION ColumnValue(
        asPartNo        IN iapiType.PartNo_Type,
        anRevision      IN iapiType.Revision_Type,
        anSection       IN iapiType.ID_Type,
        anSubSection    IN iapiType.ID_Type,
        anPropertyGroup IN iapiType.ID_Type,
        anProperty      IN iapiType.ID_Type,
        anAttribute     IN iapiType.ID_Type,
        asHeader        IN iapiType.Description_Type
    ) RETURN iapiType.StringVal_Type;

    /*
    FUNCTION KeyFromValues(
        asVal1 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asVal2 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asVal3 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asVal4 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asVal5 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asVal6 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asVal7 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asVal8 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asVal9 IN iapiType.StringVal_Type DEFAULT gsUndefined
    ) RETURN iapiType.TokensTab_Type;
    
    FUNCTION KeyFromPaths(
        asPartNo   IN iapiType.PartNo_Type,
        anRevision IN iapiType.Revision_Type,
        asPath1 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asPath2 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asPath3 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asPath4 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asPath5 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asPath6 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asPath7 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asPath8 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asPath9 IN iapiType.StringVal_Type DEFAULT gsUndefined
    ) RETURN iapiType.TokensTab_type;

    FUNCTION Lookup(
        atKeyTab   IN iapiType.TokensTab_Type,
        asTable    IN iapiType.StringVal_Type,
        asValueCol IN iapiType.StringVal_Type
    ) RETURN iapiType.StringVal_Type;

    FUNCTION Lookup(
        atKeyVal IN iapiType.StringVal_Type,
        asTable  IN iapiType.StringVal_Type,
        asColumn IN iapiType.StringVal_Type
    ) RETURN iapiType.StringVal_Type;
    */

    FUNCTION Lookup(
        asTable   IN iapiType.StringVal_Type,
        asColumn  IN iapiType.StringVal_Type,
        asKeyVal1 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asKeyVal2 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asKeyVal3 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asKeyVal4 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asKeyVal5 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asKeyVal6 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asKeyVal7 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asKeyVal8 IN iapiType.StringVal_Type DEFAULT gsUndefined,
        asKeyVal9 IN iapiType.StringVal_Type DEFAULT gsUndefined
    ) RETURN iapiType.StringVal_Type;

    FUNCTION MatchRegex(
        asValue   IN iapiType.StringVal_Type,
        asPattern IN iapiType.StringVal_Type,
        asFlags   IN iapiType.StringVal_Type DEFAULT NULL
    ) RETURN iapiType.Boolean_Type;

    FUNCTION Required(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION Range(
        anValue IN iapiType.NumVal_Type,
        anMin   IN iapiType.NumVal_Type,
        anMax   IN iapiType.NumVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION LengthRange(
        asValue IN iapiType.StringVal_Type,
        anMin   IN iapiType.NumVal_Type,
        anMax   IN iapiType.NumVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION Limit(
        asOperator IN iapiType.StringVal_Type,
        anLimit    IN iapiType.NumVal_Type,
        anValue    IN iapiType.NumVal_Type
    ) RETURN iapiType.Boolean_Type;

    FUNCTION IsEqual(
        asValue1 IN iapiType.StringVal_Type,
        asValue2 IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;

    FUNCTION IsAlpha(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsAlphaNumeric(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;

    FUNCTION IsBase64(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsDate(
        asValue  IN iapiType.StringVal_Type,
        asFormat IN iapiType.StringVal_Type DEFAULT NULL
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsNumeric(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsDecimal(
        asValue  IN iapiType.StringVal_Type,
        asFormat IN iapiType.StringVal_Type DEFAULT NULL
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsMultiple(
        anValue    IN iapiType.NumVal_Type,
        anMultiple IN iapiType.NumVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsHexadecimal(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsEmail(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsUrl(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsIpAddress(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsUppercase(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsLowercase(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsUuid(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsObject(
        asValue IN iapiType.StringVal_Type,
        asType  IN iapiType.StringVal_Type,
        anFuzzy IN iapiType.Boolean_Type DEFAULT 0,
        anExt   IN iapiType.Boolean_Type DEFAULT 0
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsAccessGroup(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsAssociation(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsAttribute(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;

    FUNCTION IsCharacteristic(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsSpecType(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsSpecTypeGroup(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsFormat(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsFunction(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsKeyword(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsKeywordCharacteristic(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsFrame(
        asValue IN iapiType.StringVal_Type,
        anRev   IN iapiType.NumVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsHeader(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsBomLayout(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsCustomFunction(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsOwner(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsTestMethodType(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsUserCategory(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsUserLocation(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsLayout(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsLocation(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsManufacturer(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsManufacturerPlant(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsManufacturerType(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsMessage(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;

    FUNCTION IsPart(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsPlant(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsPlantGroup(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsSource(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;

    FUNCTION IsProperty(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsPropertyGroup(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsSection(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsSpecification(
        asValue IN iapiType.StringVal_Type,
        anRev   IN iapiType.NumVal_Type DEFAULT 0
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsStatus(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsStatusType(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;

    FUNCTION IsSubSection(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsTestMethod(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsTextType(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsUom(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsUomGroup(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsUser(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsUserGroup(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsReferenceText(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;

    FUNCTION IsWorkflow(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
    FUNCTION IsWorkflowGroup(
        asValue IN iapiType.StringVal_Type
    ) RETURN iapiType.Boolean_Type;
    
END AAPIVALIDATION;
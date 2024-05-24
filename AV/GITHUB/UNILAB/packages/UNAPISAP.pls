create or replace PACKAGE
-- Unilab 6.7 Package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
unapisap AS

FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION GetUnitForCode
(a_sap_unit_code      IN    VARCHAR2,                      /* VC3_TYPE */
 a_ul_uom             OUT   VARCHAR2)                      /* VC20_TYPE */
RETURN NUMBER;

FUNCTION GetCodeForUnit
(a_ul_uom             IN    VARCHAR2,                      /* VC20_TYPE */
 a_sap_unit_code      OUT   VARCHAR2)                      /* VC3_TYPE */
RETURN NUMBER;

FUNCTION GetPlantForCode
(a_sap_plant_code     IN    VARCHAR2,                      /* VC4_TYPE */
 a_ul_plantname       OUT   VARCHAR2)                      /* VC40_TYPE */
RETURN NUMBER;

FUNCTION GetCodeForPlant
(a_ul_plantname       IN    VARCHAR2,                      /* VC40_TYPE */
 a_sap_plant_code     OUT   VARCHAR2)                      /* VC4_TYPE */
RETURN NUMBER;

FUNCTION GetMethodForCode
(a_sap_method_code    IN    VARCHAR2,                      /* VC8_TYPE */
 a_ul_method          OUT   VARCHAR2)                      /* VC40_TYPE */
RETURN NUMBER;

FUNCTION GetCodeForMethod
(a_ul_method          IN    VARCHAR2,                      /* VC40_TYPE */
 a_sap_method_code    OUT   VARCHAR2)                      /* VC8_TYPE */
RETURN NUMBER;

FUNCTION GetLocationForCode
(a_sap_location_code  IN    VARCHAR2,                      /* VC4_TYPE */
 a_ul_location        OUT   VARCHAR2)                      /* VC40_TYPE */
RETURN NUMBER;

FUNCTION GetCodeForLocation
(a_ul_location        IN    VARCHAR2,                      /* VC40_TYPE */
 a_sap_location_code  OUT   VARCHAR2)                      /* VC4_TYPE */
RETURN NUMBER;

FUNCTION GetOperationForCode
(a_sap_operation_nr   IN    VARCHAR2,                      /* VC4_TYPE */
 a_ul_operation       OUT   VARCHAR2)                      /* VC40_TYPE */
RETURN NUMBER;

FUNCTION GetCodeForOperation
(a_ul_operation       IN    VARCHAR2,                      /* VC40_TYPE */
 a_sap_operation_nr   OUT   VARCHAR2)                      /* VC4_TYPE */
RETURN NUMBER;

FUNCTION GetDescriptionForCodeGroup
(a_sap_code_group     IN    VARCHAR2,                      /* VC8_TYPE */
 a_ul_description     OUT   VARCHAR2)                      /* VC40_TYPE */
RETURN NUMBER;

FUNCTION GetCodeGroupForDescription
(a_ul_description     IN    VARCHAR2,                      /* VC40_TYPE */
 a_sap_code_group     OUT   VARCHAR2)                      /* VC8_TYPE */
RETURN NUMBER;

FUNCTION GetDescriptionForCode
(a_sap_code_group     IN    VARCHAR2,                      /* VC8_TYPE */
 a_sap_code           IN    VARCHAR2,                      /* VC4_TYPE */
 a_ul_description     OUT   VARCHAR2)                      /* VC40_TYPE */
RETURN NUMBER;

FUNCTION GetCodeForDescription
(a_ul_description     IN    VARCHAR2,                      /* VC40_TYPE */
 a_sap_code           OUT   VARCHAR2,                      /* VC4_TYPE */
 a_sap_code_group     OUT   VARCHAR2)                      /* VC8_TYPE */
RETURN NUMBER;

END unapisap;
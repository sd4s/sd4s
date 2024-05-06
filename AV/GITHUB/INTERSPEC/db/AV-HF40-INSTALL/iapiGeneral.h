CREATE OR REPLACE PACKAGE iapiGeneral
IS
   ---------------------------------------------------------------------------
   -- $Workfile: iapiGeneral.h $
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.(06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   --  Abstract:
   --           This package holds all general
   --           functions / procedures.
   --
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   FUNCTION GetPackageVersion
      RETURN iapiType.String_Type;

   ---------------------------------------------------------------------------
   -- $NoKeywords: $
   ---------------------------------------------------------------------------

   ---------------------------------------------------------------------------
   -- Member variables
   ---------------------------------------------------------------------------
   gsSource                      iapiType.Source_Type := 'iapiGeneral';
   LoggingEnabled                BOOLEAN := FALSE;
   LastErrorText                 VARCHAR2( 2048 ) := '';
   SESSION                       iapiType.SessionRec_Type := NULL;
   LoggingCulture                iapiType.ParameterData_Type := 'en';
   LicenseFree                   BOOLEAN := FALSE;
   LicenseGranted                BOOLEAN := FALSE;
   LicenseGrantedRD              BOOLEAN := FALSE;
   SchemaName                    iapiType.UserId_Type := NULL;
   LicenceCustomParam            iapiType.String_Type := NULL;
   gnRetVal                      iapiType.ErrorNum_Type;
   gsAppVersion1                 iapiType.LicenseVersion_Type := '0605';
   gsAppVersion2                 iapiType.LicenseVersion_Type := '0607';
   --Interspec is supporting licenses of version X and version X-1
   --when you are installing/using Interspec version X
   --IS238 --oneLine
   LicenseGrantedGIL              BOOLEAN := FALSE;

   ---------------------------------------------------------------------------
   -- Public procedures and functions
   ---------------------------------------------------------------------------
   ---------------------------------------------------------------------------
   FUNCTION AddErrorToList(
      asParameterId              IN       iapiType.String_Type,
      asErrorText                IN       iapiType.ErrorText_Type,
      atErrors                   IN OUT   ErrorDataTable_Type,
      anMessageType              IN       iapiType.ErrorMessageType_Type DEFAULT iapiConstant.ERRORMESSAGE_ERROR )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION AppendXmlFilter(
      axFilter                   IN       iapiType.XmlType_Type,
      atFilterDataTable          OUT      iapiType.FilterTab_Type )
      RETURN iapiType.ErrorNum_Type;

   --AP00870590 Start
   ---------------------------------------------------------------------------
   FUNCTION AppendXmlPartNo(
      axPartNoList               IN       iapiType.XmlType_Type,
      atPartNoList               OUT      iapiType.PartNoTab_Type )
      RETURN iapiType.ErrorNum_Type;
   --AP00870590 End

   --AP00870590 Start
   ---------------------------------------------------------------------------
   FUNCTION AppendXmlRevision(
      axRevisionList             IN       iapiType.XmlType_Type,
      atRevisionList             OUT      iapiType.RevisionTab_Type )
      RETURN iapiType.ErrorNum_Type;
   --AP00870590 End

   ---------------------------------------------------------------------------
   FUNCTION CheckLicenseRDModules(
      asMachineName              IN       iapiType.MachineName_Type DEFAULT NULL,
      asAppVersion               IN       iapiType.LicenseVersion_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CheckLicensesRD
      RETURN iapiType.Numval_Type;

   --IS238 Start
   ---------------------------------------------------------------------------
   FUNCTION CheckLicensesGIL
      RETURN iapiType.Numval_Type;
   --IS238 End

    --ISQF133 Start
   ---------------------------------------------------------------------------
   FUNCTION CheckLicensesSCCServer
      RETURN iapiType.Numval_Type;
   --ISQF133 End

   ---------------------------------------------------------------------------
    --ISQF133 Start
   ---------------------------------------------------------------------------
   FUNCTION CheckLicensesSCCClient
      RETURN iapiType.Numval_Type;
   --ISQF133 End

   ---------------------------------------------------------------------------
   FUNCTION CompareDate(
      adDate1                    IN       iapiType.Date_Type,
      adDate2                    IN       iapiType.Date_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CompareFloat(
      afFloat1                   IN       iapiType.Float_Type,
      afFloat2                   IN       iapiType.Float_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CompareNumber(
      anNumber1                  IN       iapiType.Numval_Type,
      anNumber2                  IN       iapiType.Numval_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CompareString(
      asString1                  IN       iapiType.StringVal_Type,
      asString2                  IN       iapiType.StringVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   PROCEDURE DisableLogging;

   ---------------------------------------------------------------------------
   PROCEDURE EnableLogging;

   ---------------------------------------------------------------------------
   FUNCTION EncapsulateInXmlKey(
      axText                     IN OUT   iapiType.Clob_Type,
      asKey                      IN       iapiType.OptParam_Type,
      asKeyValue                 IN       iapiType.OptParam_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ErrorListContainsErrors(
      atErrors                   IN       ErrorDataTable_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION EscQuote(
      asInputString              IN       iapiType.Clob_Type )
      RETURN iapiType.Clob_Type;

   ---------------------------------------------------------------------------
   FUNCTION ExecuteCustomFunction(
      asStandardPackage          IN       iapiType.String_Type,
      asStandardFunction         IN       iapiType.String_Type,
      asCustomType               IN       iapiType.String_Type,
      atErrors                   IN OUT NOCOPY ErrorDataTable_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION FreeLicense(
      asMachineName              IN       iapiType.MachineName_Type DEFAULT NULL )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetConfigurationSetting(
      asParameter                IN       iapiType.Parameter_Type,
      asSection                  IN       iapiType.ConfigurationSection_Type DEFAULT iapiConstant.CFG_SECTION_STANDARD,
      asParameterData            OUT      iapiType.ParameterData_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION getDBDecimalSeperator
      RETURN iapiType.DecimalSeperator_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetLastErrorText
      RETURN iapiType.ErrorText_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetRecoveredServer(
      anRecoveredServer          OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetTestServer(
      anTestServer               OUT      iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetVersion
      RETURN iapiType.String_Type;

   ---------------------------------------------------------------------------
   FUNCTION InitialiseSession(
      asUserId                   IN       iapiType.UserId_Type DEFAULT USER )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION isBoolean(
      asValue                    IN       iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION isDate(
      asValue                    IN       iapiType.String_Type,
      asFormat                   IN       iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION isNumeric(
      asValue                    IN       iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION isValidString(
      asValue                    IN       iapiType.Clob_Type,
      anLimit                    IN       iapiType.NumVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   PROCEDURE LogError(
      asSource                   IN       iapiType.Source_Type,
      asMethod                   IN       iapiType.Method_Type,
      asMessage                  IN       iapiType.Clob_Type );

   ---------------------------------------------------------------------------
   PROCEDURE LogErrorList(
      asSource                   IN       iapiType.Source_Type,
      asMethod                   IN       iapiType.Method_Type,
      atErrors                   IN       iapiType.Ref_Type );

   ---------------------------------------------------------------------------
   PROCEDURE LogInfo(
      asSource                   IN       iapiType.Source_Type,
      asMethod                   IN       iapiType.Method_Type,
      asMessage                  IN       iapiType.Clob_Type,
      anInfoLevel                IN       iapiType.InfoLevel_Type DEFAULT 0 );

   ---------------------------------------------------------------------------
   PROCEDURE LogInfoInChunks(
      asSource                   IN       iapiType.Source_Type,
      asMethod                   IN       iapiType.Method_Type,
      asMessage                  IN       iapiType.Clob_Type,
      anInfoLevel                IN       iapiType.InfoLevel_Type DEFAULT 0 );

   ---------------------------------------------------------------------------
   PROCEDURE LogWarning(
      asSource                   IN       iapiType.Source_Type,
      asMethod                   IN       iapiType.Method_Type,
      asMessage                  IN       iapiType.Clob_Type );

   ---------------------------------------------------------------------------
   FUNCTION LPAD(
      asInputString              IN       iapiType.StringVal_Type,
      anSize                     IN       iapiType.NumVal_Type,
      asPadingString             IN       iapiType.StringVal_Type )
      RETURN iapiType.Buffer_Type;

   ---------------------------------------------------------------------------
   FUNCTION RPAD(
      asInputString              IN       iapiType.StringVal_Type,
      anSize                     IN       iapiType.NumVal_Type,
      asPadingString             IN       iapiType.StringVal_Type )
      RETURN iapiType.Buffer_Type;

   ---------------------------------------------------------------------------
   FUNCTION SetAlternativeLanguageId(
      anAlternativeLanguageId    IN       iapiType.LanguageId_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SetConnection(
      asUserId                   IN       iapiType.UserId_Type DEFAULT USER,
      asModuleName               IN       iapiType.String_Type DEFAULT '',
      asDatabaseType             OUT      iapiType.DatabaseType_Type,
      anGlossaryAllowed          OUT      iapiType.Boolean_Type,
      anFda21cfr11Enabled        OUT      iapiType.Boolean_Type,
      anGrantLicense             IN       iapiType.Boolean_Type DEFAULT 0,
      asMachineName              IN       iapiType.MachineName_Type DEFAULT NULL,
      asDecimalSeperator         IN       iapiType.String_Type DEFAULT NULL )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SetConnection(
      asUserId                   IN       iapiType.UserId_Type DEFAULT USER,
      asModuleName               IN       iapiType.String_Type DEFAULT '',
      anGrantLicense             IN       iapiType.Boolean_Type DEFAULT 0,
      asMachineName              IN       iapiType.MachineName_Type DEFAULT NULL )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SetErrorText(
      anErrorNumber              IN       iapiType.ErrorNum_Type,
      asParam1                   IN       iapiType.OptParam_Type DEFAULT NULL,
      asParam2                   IN       iapiType.OptParam_Type DEFAULT NULL,
      asParam3                   IN       iapiType.OptParam_Type DEFAULT NULL,
      asParam4                   IN       iapiType.OptParam_Type DEFAULT NULL,
      asParam5                   IN       iapiType.OptParam_Type DEFAULT NULL,
      asParam6                   IN       iapiType.OptParam_Type DEFAULT NULL,
      asParam7                   IN       iapiType.OptParam_Type DEFAULT NULL,
      asParam8                   IN       iapiType.OptParam_Type DEFAULT NULL,
      asParam9                   IN       iapiType.OptParam_Type DEFAULT NULL,
      asParam0                   IN       iapiType.OptParam_Type DEFAULT NULL )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SetErrorTextAndLogInfo(
      asSource                   IN       iapiType.Source_Type,
      asMethod                   IN       iapiType.Method_Type,
      anErrorNumber              IN       iapiType.ErrorNum_Type,
      asParam1                   IN       iapiType.OptParam_Type DEFAULT NULL,
      asParam2                   IN       iapiType.OptParam_Type DEFAULT NULL,
      asParam3                   IN       iapiType.OptParam_Type DEFAULT NULL,
      asParam4                   IN       iapiType.OptParam_Type DEFAULT NULL,
      asParam5                   IN       iapiType.OptParam_Type DEFAULT NULL,
      asParam6                   IN       iapiType.OptParam_Type DEFAULT NULL,
      asParam7                   IN       iapiType.OptParam_Type DEFAULT NULL,
      asParam8                   IN       iapiType.OptParam_Type DEFAULT NULL,
      asParam9                   IN       iapiType.OptParam_Type DEFAULT NULL,
      asParam0                   IN       iapiType.OptParam_Type DEFAULT NULL,
      anInfoLevel                IN       iapiType.InfoLevel_Type DEFAULT 0 )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SetLanguageId(
      anLanguageId               IN       iapiType.LanguageId_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SetMode(
      anMode                     IN       iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION SetUomType(
      anUomType                  IN       iapiType.Boolean_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION ToChar(
      anNum                      IN       iapiType.Float_Type )
      RETURN iapiType.StringVal_Type;

   ---------------------------------------------------------------------------
   FUNCTION ToUpper(
      asInputString              IN       iapiType.Clob_Type )
      RETURN iapiType.Clob_Type;

   ---------------------------------------------------------------------------
   FUNCTION GetNLSsessionParameter(
      asParameter                IN       NLS_SESSION_PARAMETERS.PARAMETER%TYPE,
      anComposed                 IN       iapiType.Boolean_Type DEFAULT 0 )
      RETURN NLS_SESSION_PARAMETERS.VALUE%TYPE;

   ---------------------------------------------------------------------------
   FUNCTION TransformErrorListToRefCursor(
      atErrors                   IN       ErrorDataTable_Type,
      --AP01100443 --AP01020557 Start
      --aqErrors                   OUT      iapiType.Ref_Type )  --orig
      aqErrors                   IN OUT      iapiType.Ref_Type )
      --AP01100443 --AP01020557 End
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION TransformFilterRecord(
      arFilterRecord             IN       iapiType.FilterRec_Type,
      asOutputString             OUT      iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION TransformStringtoNumArray(
      asString                   IN       iapiType.Clob_type,
      atList                     OUT      SpNumTable_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION TransformToXmlDomDocument(
      atError                    IN       iapiType.ErrorTab_Type,
      axErrorList                OUT      iapiType.XmlDomDocument_Type,
      asKey1                     IN       iapiType.OptParam_Type DEFAULT NULL,
      asKey1Value                IN       iapiType.OptParam_Type DEFAULT NULL,
      asKey2                     IN       iapiType.OptParam_Type DEFAULT NULL,
      asKey2Value                IN       iapiType.OptParam_Type DEFAULT NULL,
      asKey3                     IN       iapiType.OptParam_Type DEFAULT NULL,
      asKey3Value                IN       iapiType.OptParam_Type DEFAULT NULL,
      asKey4                     IN       iapiType.OptParam_Type DEFAULT NULL,
      asKey4Value                IN       iapiType.OptParam_Type DEFAULT NULL,
      asKey5                     IN       iapiType.OptParam_Type DEFAULT NULL,
      asKey5Value                IN       iapiType.OptParam_Type DEFAULT NULL )
      RETURN iapiType.ErrorNum_Type;

  --AP00923107
   ---------------------------------------------------------------------------
   PROCEDURE CloseErrorCursor(
      lnretval                   IN       iapitype.errornum_type,
      aqErrors                   IN       iapiType.Ref_Type );

---------------------------------------------------------------------------
-- Pragmas
---------------------------------------------------------------------------
END iapiGeneral;
/

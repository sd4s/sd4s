create or replace PACKAGE          aapiSpectracData IS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : aapiSpectracData
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 03/08/2007
--   TARGET : Oracle 10.2.0
--  VERSION : 6.3.0    $Revision: 1 $
--------------------------------------------------------------------------------
--  REMARKS : SUPPORT FUNCTIONS FOR SPECTRAC - DATA SPECIFIC
--            None of these functions commit; transaction logic is left to the caller
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 03/08/2007 | RS        | Created
-- 10/03/2011 | RS        | Upgrade V6.3
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------
SUBTYPE GlossaryType_Type IS VARCHAR2(2);

GLOSS_KEYWORD          CONSTANT GlossaryType_Type         := 'KW';
GLOSS_SECTION          CONSTANT GlossaryType_Type         := 'SC';
GLOSS_SUBSECTION       CONSTANT GlossaryType_Type         := 'SB';
GLOSS_PROPERTYGROUP    CONSTANT GlossaryType_Type         := 'PG';
GLOSS_PROPERTY         CONSTANT GlossaryType_Type         := 'SP';
GLOSS_CHARACTERISTIC   CONSTANT GlossaryType_Type         := 'CH';
HDR_STATUS             CONSTANT iapiType.Description_Type := 'STATUS';
HDR_PED                CONSTANT iapiType.Description_Type := 'PLANNED_EFFECTIVE_DATE';
HDR_LASTMODIFIEDBY     CONSTANT iapiType.Description_Type := 'LAST_MODIFIED_BY';

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
psSource               CONSTANT iapiType.Source_Type      := 'aapiSpectracData';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------


   /*///////////////////////////////////////////////////
   //                                                 //
   // INFORMATION RETRIEVAL ABOUT SPECIFIC ELEMENTS   //
   //                                                 //
   ///////////////////////////////////////////////////*/

   /*
   // Gets the internal ID for a glossary element matching the description
   //
   // Input arguments:
   //   - asDescription
   //   - asGlossaryType: indicates what kind of glossary element to match against
   //      (KW, SC, SB, PG, SP, CH)
   //
   // Returns
   //   - The ID matching the description
   */
   FUNCTION GetIdFromDescription(
      asDescription    IN   iapiType.Description_Type,
      asGlossaryType   IN   GlossaryType_Type)
      RETURN iapiType.Id_Type;

   /*///////////////////////////////////////////
   //                                         //
   // RETRIEVING DATA FROM THE FUNCTIONAL BOM //
   //                                         //
   ///////////////////////////////////////////*/

   /*
   // Extracts a value from a specification in the functional BOM
   //
   // Input arguments
   //   - asLevel: level in the functional BOM
   //
   // Optional input arguments: path to the value to retrieve
   //   - asSpecHeader
   //   - asKeyword
   //   - anAttachedSpecs
   //   - asSection
   //   - asSubSection
   //   - asPropertyGroup
   //   - asProperty
   //   - anFieldType (see aapiConstant)
   //
   // Output arguments
   //   - asValue: value found on the level for the path
   //
   // Returns
   //   - DBERR_SUCCESS: Normal, successful completion
   //   - DBERR_NOVIEWACCESS: No view access on specification
   //   - DBERR_GENFAIL: Operation could not be completed
   */
   FUNCTION GetValue(
      asLevel           IN       iapiType.String_Type,
      asSpecHeader      IN       iapiType.Description_Type,
      asKeyword         IN       iapiType.Description_Type,
      anAttachedSpecs   IN       iapiType.Boolean_Type,
      asSection         IN       iapiType.Description_Type,
      asSubSection      IN       iapiType.Description_Type,
      asPropertyGroup   IN       iapiType.Description_Type,
      asProperty        IN       iapiType.Description_Type,
      anFieldType       IN       iapiType.Id_Type,
      asValue           OUT      iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type;

   /*
   // Extracts a value from a specification in the functional BOM
   //
   // Input arguments
   //   - asIntLevel: level in the functional BOM
   //
   // Optional input arguments: path to the value to retrieve
   //   - asSpecHeader
   //   - anKeywordId
   //   - anAttachedSpecs
   //   - anSectionId
   //   - anSubSectionId
   //   - anPropertyGroupId
   //   - anPropertyId
   //   - anFieldType
   //
   // Output arguments
   //   - asValue: value found on the level for the path
   //
   // Returns
   //   - DBERR_SUCCESS: Normal, successful completion
   //   - DBERR_NOVIEWACCESS: No view access on specification
   //   - DBERR_GENFAIL: Operation could not be completed
   */
   FUNCTION GetValue(
      asIntLevel          IN       iapiType.String_Type,
      asSpecHeader        IN       iapiType.Description_Type,
      anKeywordId         IN       iapiType.Id_Type,
      anAttachedSpecs     IN       iapiType.Boolean_Type,
      anSectionId         IN       iapiType.Id_Type,
      anSubSectionId      IN       iapiType.Id_Type,
      anPropertyGroupId   IN       iapiType.Id_Type,
      anPropertyId        IN       iapiType.Id_Type,
      anFieldType         IN       iapiType.Id_Type,
      asValue             OUT      iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type;

   /*
   // Extracts a value from the header of a specification
   //
   // Input arguments
   //   - asPartNo
   //   - anRevision
   //   - asSpecHeader
   //
   // Output arguments
   //   - asValue
   //
   // Returns
   //   - DBERR_SUCCESS: Normal, successful completion
   //   - DBERR_GENFAIL: Operation could not be completed
   */
   FUNCTION GetHeaderValue(
      asPartNo       IN       iapiType.PartNo_Type,
      anRevision     IN       iapiType.Revision_Type,
      asSpecHeader   IN       iapiType.Description_Type,
      asValue        OUT      iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type;

   /*
   // Creates a string containing the part [rev] of all attached specifications
   //
   // Input arguments
   //   - asPartNo
   //   - anRevision
   //   - anSectionId
   //   - anSubSectionId
   //
   // Output arguments
   //   - asValue
   //
   // Returns
   //   - DBERR_SUCCESS: Normal, successful completion
   //   - DBERR_GENFAIL: Operation could not be completed
   */
   FUNCTION GetAttachedSpecsValue(
      asPartNo         IN       iapiType.PartNo_Type,
      anRevision       IN       iapiType.Revision_Type,
      anSectionId      IN       iapiType.Id_Type,
      anSubSectionId   IN       iapiType.Id_Type,
      asValue          OUT      iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type;

   /*
   // Gets a property value from a specification
   //
   // Input arguments
   //   - asPartNo
   //   - anRevision
   //   - anSectionId
   //   - anSubSectionId
   //   - anPropertyGroupId
   //   - anPropertyId
   //   - anFieldType
   //   - abMatchFound: because it's possible that there's no error,
   //      but no value, we use this boolean to indicate that a match was found
   //
   // Output arguments
   //   - asValue
   //
   // Returns
   //   - DBERR_SUCCESS: Normal, successful completion
   //   - DBERR_GENFAIL: Operation could not be completed
   */
   FUNCTION GetPropertyValue(
      asPartNo            IN       iapiType.PartNo_Type,
      anRevision          IN       iapiType.Revision_Type,
      anSectionId         IN       iapiType.Id_Type,
      anSubSectionId      IN       iapiType.Id_Type,
      anPropertyGroupId   IN       iapiType.Id_Type,
      anPropertyId        IN       iapiType.Id_Type,
      anFieldType         IN       iapiType.Id_Type,
      abMatchFound        OUT      iapiType.Boolean_Type,
      asValue             OUT      iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type;

   /*
   // Clears the data extraction configuration
   //
   // Returns
   //   - DBERR_SUCCESS: Normal, successful completion
   //   - DBERR_GENFAIL: Operation could not be completed
   */
   FUNCTION ClearDataConfiguration
      RETURN iapiType.ErrorNum_Type;

   /*
   // Adds a line to the data extraction configuration
   //
   // Input arguments
   //   - anSequenceNo: row reference
   //   - asLevel: level in the functional BOM
   //
   // Optional input arguments: path to the value to retrieve
   //   - asSpecHeader
   //   - asKeyword
   //   - anAttachedSpecs
   //   - asSection
   //   - asSubSection
   //   - asPropertyGroup
   //   - asProperty
   //   - asField
   //   - anFieldType (see aapiConstant)
   //
   // Returns
   //   - DBERR_SUCCESS: Normal, successful completion
   //   - DBERR_GENFAIL: Operation could not be completed
   */
   FUNCTION AddDataConfiguration(
      anSequenceNo      IN   iapiType.Sequence_Type,
      asLevel           IN   iapiType.String_Type,
      asSpecHeader      IN   iapiType.Description_Type,
      asKeyword         IN   iapiType.Description_Type,
      anAttachedSpecs   IN   iapiType.Boolean_Type,
      asSection         IN   iapiType.Description_Type,
      asSubSection      IN   iapiType.Description_Type,
      asPropertyGroup   IN   iapiType.Description_Type,
      asProperty        IN   iapiType.Description_Type,
      asField           IN   iapiType.Description_Type,
      anFieldType       IN   iapiType.Id_Type)
      RETURN iapiType.ErrorNum_Type;

   /*
   // Extracts data from the functional BOM according to the previously written configuration
   // and writes it to avfuncbomdata
   //
   // Returns
   //   - DBERR_SUCCESS: Normal, successful completion
   //   - DBERR_GENFAIL: Operation could not be completed
   */
   FUNCTION BulkExtractData
      RETURN iapiType.ErrorNum_Type;

   /*/////////////////////////////////////
   //                                   //
   // SAVING DATA TO THE FUNCTIONAL BOM //
   //                                   //
   /////////////////////////////////////*/

   /*
   // Writes a value to a specification in the functional BOM
   // THIS ONLY WORKS FOR SPECIFIC DATA
   //
   // Input arguments
   //   - asLevel: level in the functional BOM
   //   - asKeyword
   //   - anAttachedSpecs
   //   - asSection
   //   - asSubSection
   //   - asPropertyGroup
   //   - asProperty
   //   - anFieldType (see aapiConstant)
   //   - asValue
   //
   // Returns
   //   - DBERR_SUCCESS: Normal, successful completion
   //   - DBERR_NOACCESS: No view access on specification
   //   - DBERR_GENFAIL: Operation could not be completed
   */
   FUNCTION SetValue(
      asLevel           IN   iapiType.String_Type,
      asKeyword         IN   iapiType.Description_Type,
      anAttachedSpecs   IN   iapiType.Boolean_Type,
      asSection         IN   iapiType.Description_Type,
      asSubSection      IN   iapiType.Description_Type,
      asPropertyGroup   IN   iapiType.Description_Type,
      asProperty        IN   iapiType.Description_Type,
      anFieldType       IN   iapiType.Id_Type,
      asValue           IN   iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type;

   /*
   // Writes attached specifications
   //
   // Input arguments
   //   - asPartNo
   //   - anRevision
   //   - asSectionId
   //   - asSubSectionId
   //   - asValue
   //
   // Returns
   //   - DBERR_SUCCESS: Normal, successful completion
   //   - DBERR_GENFAIL: Operation could not be completed
   */
   FUNCTION SetAttachedSpecsValue(
      asPartNo         IN   iapiType.PartNo_Type,
      anRevision       IN   iapiType.Revision_Type,
      anSectionId      IN   iapiType.Id_Type,
      anSubSectionId   IN   iapiType.Id_Type,
      asValue          IN   iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type;

   /*
   // Writes a property value to a specification
   //
   // Input arguments
   //   - asPartNo
   //   - anRevision
   //   - anSectionId
   //   - anSubSectionId
   //   - anPropertyGroupId
   //   - anPropertyId
   //   - anFieldType
   //   - asValue
   //
   // Returns
   //   - DBERR_SUCCESS: Normal, successful completion
   //   - DBERR_GENFAIL: Operation could not be completed
   */
   FUNCTION SetPropertyValue(
      asPartNo            IN   iapiType.PartNo_Type,
      anRevision          IN   iapiType.Revision_Type,
      anSectionId         IN   iapiType.Id_Type,
      anSubSectionId      IN   iapiType.Id_Type,
      anPropertyGroupId   IN   iapiType.Id_Type,
      anPropertyId        IN   iapiType.Id_Type,
      anFieldType         IN   iapiType.Id_Type,
      asValue             IN   iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type;

END aapiSpectracData;
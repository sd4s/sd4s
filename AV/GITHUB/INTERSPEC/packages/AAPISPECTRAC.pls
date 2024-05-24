create or replace PACKAGE          aapiSpectrac AS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : aapiSpectrac
-- ABSTRACT : MAIN SPECTRAC INTERFACE
--            These functions implement their own transaction logic
--   WRITER : Rody Sparenberg
--     DATE : 03/08/2007
--   TARGET : Interspec V6.3 SP0; Oracle 10.2.0
--  VERSION : av 1.1
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 03/08/2007 | RS        | Created
-- 16/01/2008 | RS        | Changed LOGON, Added GetApplic, UpdateBulk, DeleteBulk
-- 06/03/2008 | RS        | Added SetApplic
-- 10/03/2011 | RS        | Upgrade V6.3
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
   psSource   CONSTANT iapiType.Source_Type := 'aapiSpectrac';
   psApplic   VARCHAR2(20);
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
   /*
   // Initialize the database session for the logged on database user
   //
   // Returns
   //   - DBERR_SUCCESS: Normal, successful completion
   //   - DBERR_GENFAIL: Session could not be initialized
   */
   FUNCTION LOGON(
      asApplic IN VARCHAR2 := 'Spectrac',
      anMode   IN NUMBER := 0
   ) RETURN iapiType.ErrorNum_Type;

   /*
   // Returns one row from a functional BOM
   //
   // A functional BOM is a subset of a real BOM explosion. This function builds
   // this subset through consecutive calls, and therefore has to be called for all
   // ancestors and smaller siblings before it can be called for a particular level.
   // E.g. before level 1.1.2 can be extracted, calls for (empty), 1, 1,1, and 1,1,1
   // need to be performed.
   //
   // Input arguments
   //   - asTyreCode: PartNo of the tyre that is at the root of the tree
   //   - asPlant: Plant to start the explosion for
   //   - asLevel: level in the functional BOM
   //      * empty: root level
   //      * 1, 2, ...: sequence number on the first functional level
   //      * 1.2, 3.4: sequence number on the second functional level
   //      * ...
   //   - asFunction: function corresponding to the level
   //   - adExplosionDate: the date to perform the explosion on
   //
   // Output arguments: describing the component on the level corresponding to asLevel & asFunction
   //   - asPartNo
   //   - anRevision
   //   - asDescription
   //   - asStatus: short description of the status
   //   - anQuantity: quantity on the functional level (possibly <> exploded quantity)
   //   - asPartType: long description of the specification type
   //   - anFunctionOverride: 0 if the function came from the keyword, 1 if it was overriden in the BOM
   //
   // Returns
   //   - DBERR_SUCCESS: Normal, successful completion
   //   - DBERR_NOVIEWACCESS: No view access on specification
   //   - DBERR_NOVIEWBOMACCESS User has no view bom access.
   //   - DBERR_GENFAIL: Operation could not be completed
   */
   FUNCTION GetFuncBOMRow(
      asTyreCode           IN       iapiType.PartNo_Type,
      asPlant              IN       iapiType.PlantNo_Type,
      asLevel              IN       iapiType.String_Type,
      asFunction           IN       iapiType.Description_Type,
      adExplosionDate      IN       iapiType.Date_Type,
      asPartNo             OUT      iapiType.PartNo_Type,
      anRevision           OUT      iapiType.Revision_Type,
      asDescription        OUT      iapiType.Description_Type,
      asStatus             OUT      iapiType.ShortDescription_Type,
      anQuantity           OUT      iapiType.BomQuantity_Type,
      asPartType           OUT      iapiType.Description_Type,
      anFunctionOverride   OUT      iapiType.Boolean_Type)
      RETURN iapiType.ErrorNum_Type;

   /*
   // Replaces a component in the functional with another one,
   // without being saved in Interspec
   //
   // Input arguments
   //   - asLevel: level in the functional BOM
   //   - asNewCode: PartNo of the new component
   //   - asPlant: Plant to start the explosion for
   //
   // Returns
   //   - DBERR_SUCCESS: Normal, successful completion
   //   - DBERR_NOVIEWACCESS: No view access on specification
   //   - DBERR_NOVIEWBOMACCESS User has no view bom access.
   //   - DBERR_GENFAIL: Operation could not be completed
   */
   FUNCTION ReplaceComponent(
      asLevel     IN   iapiType.String_Type,
      asNewCode   IN   iapiType.PartNo_Type,
      asPlant     IN   iapiType.PlantNo_Type,
      asFunction  IN   iapiType.String_Type DEFAULT NULL)
      RETURN iapiType.ErrorNum_Type;

   /*
   // Writes a row of the functional processing to staging, so that it can be processed later
   //
   // Input arguments
   //   - asLevel: level in the functional BOM
   //   - asAction: CREATE or UPDATE
   //   - asPartNo
   //   - anRevision
   //   - asDescription
   //   - asFrameNo
   //   - asPlant
   //   - anQuantity: quantity on the functional level (possibly <> exploded quantity)
   //   - anFunctionOverride: 0 if the function came from the keyword, 1 if it was overriden in the BOM
   //
   // Returns
   //   - DBERR_SUCCESS: Normal, successful completion
   //   - DBERR_INVALIDACTION: Invalid action
   //   - DBERR_GENFAIL: Operation could not be completed (probably because of invalid arguments)
   */
   FUNCTION UpdateFuncBOMRow(
      asLevel              IN   iapiType.String_Type,
      asAction             IN   iapiType.String_Type,
      asPartNo             IN   iapiType.PartNo_Type,
      anRevision           IN   iapiType.Revision_Type,
      asDescription        IN   iapiType.Description_Type,
      asFrameNo            IN   iapiType.FrameNo_Type,
      asPlant              IN   iapiType.PlantNo_Type,
      anQuantity           IN   iapiType.BomQuantity_Type,
      anFunctionOverride   IN   iapiType.Boolean_Type)
      RETURN iapiType.ErrorNum_Type;

   /*
   // Saves a functional BOM, as stored in the staging area, to Interspec
   //
   // Returns
   //   - DBERR_SUCCESS: Normal, successful completion
   //   - DBERR_GENFAIL: Operation could not be completed
   */
   FUNCTION SaveFuncBom
      RETURN iapiType.ErrorNum_Type;

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
   //   - asField
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
      asField           IN       iapiType.Description_Type,
      asValue           OUT      iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type;

   /*
   // Clears the configuration for data extraction
   //
   // Returns
   //   - DBERR_SUCCESS: Normal, successful completion
   //   - DBERR_GENFAIL: Operation could not be completed
   */
   FUNCTION ClearDataConfiguration
      RETURN iapiType.ErrorNum_Type;

   /*
   // Adds a configuration item for data extraction
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
      asField           IN   iapiType.Description_Type)
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
   //   - asFieldType
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
      asField           IN   iapiType.Description_Type,
      asValue           IN   iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type;

   /*
   // Returns the applic of current session
   //
   // Returns
   //   - Applic:
   */
   FUNCTION GetApplic
      RETURN VARCHAR2;

   /*
   // Returns the applic of current session
   //
   // Returns
   //   - Applic:
   */
   FUNCTION SetApplic(asApplic IN VARCHAR2 := 'Spectrac')
      RETURN iapiType.ErrorNum_Type;
     /*
   // Forces the bulkextract to be updated for all users
   //
   // Returns
   //   - DBERR_SUCCESS: Normal, successful completion
   //   - DBERR_GENFAIL: Operation could not be completed
   */
   FUNCTION UpdateBulk(asApplic IN VARCHAR2)
            RETURN iapiType.ErrorNum_Type;

     /*
   // Removes the bulkextract for given applic
   //
   // Returns
   //   - DBERR_SUCCESS: Normal, successful completion
   //   - DBERR_GENFAIL: Operation could not be completed
   */
    FUNCTION DeleteBulk(asApplic IN VARCHAR2)
        RETURN iapiType.ErrorNum_Type;

      
   FUNCTION GetBomPackagingValue(
      asPartNo    IN  iapiType.PartNo_Type,
      anRevision  IN  iapiType.Revision_Type,
      asBomPartNo IN  iapiType.PartNo_Type,
      asValue     OUT iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type;
      
   FUNCTION SetBomPackagingValue(
      asPartNo    IN iapiType.PartNo_Type,
      anRevision  IN iapiType.Revision_Type,
      asBomPartNo IN iapiType.PartNo_Type,
      asValue     IN iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type;
      
END aapiSpectrac;
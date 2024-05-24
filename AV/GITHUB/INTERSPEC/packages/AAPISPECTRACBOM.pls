create or replace PACKAGE          aapiSpectracBom IS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAO_COND_WF
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 27/09/2007
--   TARGET : Oracle 10.2.0
--  VERSION : 6.3.0    $Revision: 1 $
--------------------------------------------------------------------------------
--  REMARKS : SUPPORT FUNCTIONS FOR SPECTRAC - BOM SPECIFIC
--            None of these functions commit; transaction logic is left to the caller
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 27/09/2007 | RS        | Created
-- 10/03/2011 | RS        | Upgrade V6.3
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
psSource         CONSTANT iapiType.Source_Type := 'aapiSpectracBom';

KW_FUNCTION      CONSTANT iapiType.Id_Type     := 700386;
PART_NOT_FOUND   CONSTANT iapiType.PartNo_Type := 'NOT AVAILABLE';
ACTION_CREATE    CONSTANT iapiType.String_Type := 'CREATE';
ACTION_UPDATE    CONSTANT iapiType.String_Type := 'UPDATE';
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
   // INFORMATION RETRIEVAL ABOUT SPECIFIC COMPONENTS //
   //                                                 //
   ///////////////////////////////////////////////////*/

   /*
   // Returns the 'function' of a component
   // This is normally the value of the keyword Function,
   // but can be overriden in a BOM by assigning a ch_1
   //
   // Input arguments
   //   - asPartNo: component to get the function for
   //
   // Optional input arguments: functional override
   //   - asOverride: override from BOM
   //
   // Returns
   //   - The function of the component
   //   - NULL when nothing found or a unique value couldn't be determined
   */
   FUNCTION GetFunction(
      asPartNo     IN   iapiType.PartNo_Type,
      asOverride   IN   iapiType.Description_Type DEFAULT NULL)
      RETURN iapiType.Description_Type;

   /*
   // Returns the status of a specification
   //
   // Input arguments
   //   - asPartNo
   //   - anRevision
   //
   // Returns
   //   - The short description of the status of the specification
   */
   FUNCTION GetStatus(asPartNo IN iapiType.PartNo_Type, anRevision IN iapiType.Revision_Type)
      RETURN iapiType.ShortDescription_Type;

   /*
   // Returns the internal representation of a functional level
   //
   // Input arguments
   //   - asLevel
   //
   // Returns
   //   - The internal representation of the level
   */
   FUNCTION GetInternalLevel(asLevel IN iapiType.String_Type)
      RETURN iapiType.String_Type;

   /*
   // Returns the parent level for the internal representation of a functional level
   // e.g. for '0.1.2', this return '0.1'
   //
   // Input arguments
   //   - asIntLevel
   //
   // Returns
   //   - The parent level for the level
   */
   FUNCTION GetParentLevel(asIntLevel IN iapiType.String_Type)
      RETURN iapiType.String_Type;

   /*
   // Returns the child level for the internal representation of a functional level
   // e.g. for '0.1.2', this return 2
   //
   // Input arguments
   //   - asIntLevel
   //
   // Returns
   //   - The parent level for the level
   */
   FUNCTION GetChildLevel(asIntLevel IN iapiType.String_Type)
      RETURN iapiType.NumVal_Type;

   /*
   // Returns depth of a level
   // e.g. for '0.1.2', this return 2, for 0.1.2.1 3, ...
   //
   // Input arguments
   //   - asIntLevel
   //
   // Returns
   //   - The depth for the level
   */
   FUNCTION GetDepth(asIntLevel IN iapiType.String_Type)
      RETURN iapiType.NumVal_Type;

   /*////////////////////////////////////
   //                                  //
   // EXTRACTION OF THE FUNCTIONAL BOM //
   //                                  //
   ////////////////////////////////////*/

   /*
   // Extracts one row from the functional BOM
   //
   // Input arguments
   //   - asLevel: level in the functional BOM
   //   - asFunction: function corresponding to the level
   //
   // Output arguments: describing the component on the level corresponding to asLevel & asFunction
   //   - asPartNo
   //   - anRevision
   //   - asDescription
   //   - asStatus: short description of the status
   //   - anQuantity: quantity on the functional level (possibly <> exploded quantity)
   //
   // Returns
   //   - DBERR_SUCCESS: Normal, successful completion
   //   - DBERR_GENFAIL: Operation could not be completed
   */
   FUNCTION ExtractRow(
      asLevel              IN       iapiType.String_Type,
      asFunction           IN       iapiType.Description_Type,
      asPartNo             OUT      iapiType.PartNo_Type,
      anRevision           OUT      iapiType.Revision_Type,
      asDescription        OUT      iapiType.Description_Type,
      asStatus             OUT      iapiType.ShortDescription_Type,
      anQuantity           OUT      iapiType.BomQuantity_Type,
      asPartType           OUT      iapiType.Description_Type,
      anFunctionOverride   OUT      iapiType.Boolean_Type)
      RETURN iapiType.ErrorNum_Type;

   /*
   // Clears temporary data
   //
   // Optional input arguments
   //   - anStartSeqNo: if provided, the starting sequence_no of the subtree to be deleted,
   //         else the deletion starts at the root
   //   - anStopSeqNo: if provided, the last sequence_no to be deleted,
   //         else the deletion runs to the end
   //   - asIntLevel: if provided, the root level in the functional BOM to be deleted,
   //         else the full tree is deleted
   //     NOTE: this is the INTERNAL representation of the level, NOT the input
   //           from the Excel sheet. For consistency, the root tyre gets level 0;
   //           and the internal level is constructed by prefixing '0.' to the
   //           Excel input (1.1 is internally represented by 0.1.1)
   //     NOTE: this level is needed because the functional BOM can contain rows that
   //           don't correspond to rows in the explosion (NOT_FOUND)
   */
   PROCEDURE ClearResults(
      anStartSeqNo   IN   iapiType.Sequence_Type DEFAULT NULL,
      anStopSeqNo    IN   iapiType.Sequence_Type DEFAULT NULL,
      asIntLevel     IN   iapiType.String_Type DEFAULT NULL);

   /*
   // Run a BOM explosion and copy the result into our working area
   //
   // Input arguments
   //   - asPartNo
   //   - asPlant
   //   - adExplosionDate
   //
   // Returns
   //   - DBERR_SUCCESS: Normal, successful completion
   //   - DBERR_NOVIEWACCESS: No view access on specification
   //   - DBERR_NOVIEWBOMACCESS User has no view bom access.
   //   - DBERR_GENFAIL: Operation could not be completed
   */
   FUNCTION InitializeExtract(
      asPartNo          IN   iapiType.PartNo_Type,
      asPlant           IN   iapiType.PlantNo_Type,
      adExplosionDate   IN   iapiType.Date_Type)
      RETURN iapiType.ErrorNum_Type;

   /*
   // Explode a BOM Header using the BOM header qty and including DEV specs
   //
   // Input arguments
   //   - asPartNo
   //   - anRevision
   //   - asPlant
   //
   // Optional input arguments
   //   - anAlternative: if not provided, the preferred alternative will be used
   //   - anUsage: if not provided, usage 1 will be used
   //   - adExplosionDate: if not provided, the header's plant_effective_date will be used
   //   - adExplosionDate: the explosion date
   //
   // Output arguments
   //   - anBomExpNo: the explosion id to retrieve the results with
   //
   // Returns
   //   - DBERR_SUCCESS: Normal, successful completion
   //   - DBERR_NOVIEWACCESS: No view access on specification
   //   - DBERR_NOVIEWBOMACCESS User has no view bom access.
   //   - DBERR_GENFAIL: Operation could not be completed
   */
   FUNCTION ExplodeHeader(
      asPartNo          IN       iapiType.PartNo_Type,
      anRevision        IN       iapiType.Revision_Type,
      asPlant           IN       iapiType.PlantNo_Type,
      anAlternative     IN       iapiType.BomAlternative_Type DEFAULT NULL,
      anUsage           IN       iapiType.BomUsage_Type DEFAULT NULL,
      adExplosionDate   IN       iapiType.Date_Type,
      anBomExpNo        OUT      iapiType.Sequence_Type)
      RETURN iapiType.ErrorNum_Type;

   /*
   // Update the parent/child relationship in the working area
   */
   PROCEDURE SetParentChildRelationship;

   /*
   // Copy a row from the work area to the functional bom
   // and mark the row accordingly
   //
   // Input arguments
   //   - anSeqNo: the sequence_no of the row to be processed
   //   - asIntLevel: level in the functional BOM
   //     NOTE: this is the INTERNAL representation of the level, NOT the input
   //           from the Excel sheet. For consistency, the root tyre gets level 0;
   //           and the internal level is constructed by prefixing '0.' to the
   //           Excel input (1.1 is internally represented by 0.1.1)
   //   - anAncestorSeqNo: the functional ancestor
   */
   PROCEDURE MarkComponent(
      anSeqNo           IN   iapiType.Sequence_Type,
      asIntLevel        IN   iapiType.String_Type,
      anAncestorSeqNo   IN   iapiType.Sequence_Type);

   /*
   // Calculate the functional quantity of a component
   //
   // Input arguments
   //   - anSeqNo: the sequence_no of the row to be processed
   //   - anAncestorSeqNo: the functional ancestor
   */
   PROCEDURE CalculateFunctionalQuantity(
      anSeqNo           IN   iapiType.Sequence_Type,
      anAncestorSeqNo   IN   iapiType.Sequence_Type);

   /*
   // Create a dummy component in the functional BOM (in case no match was founf)
   //
   // Input arguments
   //   - asIntLevel: the level to mark the row with
   //     NOTE: this is the INTERNAL representation of the level, NOT the input
   //           from the Excel sheet. For consistency, the root tyre gets level 0;
   //           and the internal level is constructed by prefixing '0.' to the
   //           Excel input (1.1 is internally represented by 0.1.1)
   //   - asFunction: function corresponding to the level
   */
   PROCEDURE CreateDummyComponent(
      asIntLevel   IN   iapiType.String_Type,
      asFunction   IN   iapiType.Description_Type);

   /*
   // Mark as substree in the workarea as available for a functional level
   //
   // Input arguments
   //   - anParentSeqNo: root of the subtree to mark
   */
   PROCEDURE MarkSubTree(anParentSeqNo IN iapiType.Sequence_Type);

   /*
   // Mark the path between a Child and an ancestor as unavailable
   //
   // Input arguments
   //   - anChildSeqNo: the child that starts the upward path
   //   - anAncestorSeqNo: the ancestor that terminates the path
   */
   PROCEDURE MarkAncestralPath(
      anChildSeqNo      IN   iapiType.Sequence_Type,
      anAncestorSeqNo   IN   iapiType.Sequence_Type);

   /*//////////////////////////////////////////////
   //                                            //
   // REPLACING COMPONENTS IN THE FUNCTIONAL BOM //
   //                                            //
   //////////////////////////////////////////////*/

   /*
   // Replace a subtree in the working area by a new explosion
   //
   // Input arguments
   //   - asLevel: the functional level at the root of the subtree
   //   - asPartNo
   //   - asPlant
   //
   // Returns
   //   - DBERR_SUCCESS: Normal, successful completion
   //   - DBERR_NOVIEWACCESS: No view access on specification
   //   - DBERR_NOVIEWBOMACCESS User has no view bom access.
   //   - DBERR_GENFAIL: Operation could not be completed
   */
   FUNCTION ReplaceComponent(
      asLevel    IN   iapiType.String_Type,
      asPartNo   IN   iapiType.PartNo_Type,
      asPlant    IN   iapiType.PlantNo_Type,
      asFunction IN   iapiType.String_Type DEFAULT NULL)
      RETURN iapiType.ErrorNum_Type;

   /*/////////////////////////////////////////////////
   //                                               //
   // WRITING FUNCTIONAL BOM BACK TO SPECIFICATIONS //
   //                                               //
   /////////////////////////////////////////////////*/

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
   // Validates a functional BOM prior to saving
   //
   // Returns
   //   - DBERR_SUCCESS: BOM will probably save correctly
   //   - DBERR_GENFAIL: BOM can't be saved
   */
   FUNCTION ValidateFuncBom
      RETURN iapiType.ErrorNum_Type;

   /*
   // Creates a specification, and adds a BOM header
   //
   // Input arguments
   //   - asPartNo
   //   - asDescription
   //   - asFrameNo
   //   - asPlant
   //
   // Returns
   //   - DBERR_SUCCESS: BOM will probably save correctly
   //   - DBERR_GENFAIL: BOM can't be saved
   */
   FUNCTION CreateSpecification(
      asPartNo        IN   iapiType.PartNo_Type,
      asDescription   IN   iapiType.Description_Type,
      asFrameNo       IN   iapiType.FrameNo_Type,
      asPlant         IN   iapiType.PlantNo_Type,
      asFunction      IN   iapiType.Description_Type)
      RETURN iapiType.ErrorNum_Type;

   /*
   // Saves a the BOM of a functional level
   //
   // Input arguments
   //   - asIntLevel
   //
   // Returns
   //   - DBERR_SUCCESS: BOM will probably save correctly
   //   - DBERR_GENFAIL: BOM can't be saved
   */
   FUNCTION UpdateBOM(asIntLevel IN iapiType.String_Type)
      RETURN iapiType.ErrorNum_Type;
END aapiSpectracBom;
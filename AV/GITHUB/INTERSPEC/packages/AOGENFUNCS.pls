create or replace PACKAGE          aogenfuncs AS
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
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 23-02-2007 | F.v.d. H. | Created.
-- 10/03/2011 | RS        | Upgrade V6.3
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
   PROCEDURE aoset_connection;

   PROCEDURE aosave_property (
      avs_partno         iapitype.partno_type,
      avs_revision       iapitype.revision_type,
      avs_sectionid      iapitype.id_type,
      avs_subsectionid   iapitype.id_type,
      avs_propgroupid    iapitype.id_type,
      avs_propid         iapitype.id_type,
      avs_fieldname      iapitype.stringval_type,
      avf_value          iapitype.float_type
   );

   PROCEDURE aorun_bomexplosion (
      anexplosionid   OUT   iapitype.sequence_type,
      aspartno              iapitype.partno_type,
      avi_revision          iapitype.revision_type,
      asprice               BOOLEAN
   );

   PROCEDURE aoadd_bomitem (
      avp_partno         iapitype.partno_type,
      avn_revision       iapitype.revision_type,
      avp_comppart       iapitype.partno_type,
      avn_comprevision   iapitype.revision_type,
      avn_alternative    NUMBER,
      avs_plant          iapitype.plantno_type,
      avs_field          VARCHAR2,
      avf_quantity       FLOAT
   );

   PROCEDURE aoremove_bomitem (
      avp_partno          iapitype.partno_type,
      avn_revision        iapitype.revision_type,
      avn_bomitemnumber   iapitype.bomitemnumber_type,
      avs_plant           iapitype.plantno_type,
      avn_alternative     iapitype.numval_type,
      avn_usage           iapitype.bomusage_type
   );

   PROCEDURE aocreate_specification (
      avp_partno          iapitype.partno_type,
      avi_revision        iapitype.numval_type,
      avs_description     iapitype.stringval_type,
      avs_frameno         iapitype.frameno_type,
      avi_framerevision   iapitype.framerevision_type,
      avs_spectype        iapitype.stringval_type,
      avs_accessgroup     iapitype.stringval_type
   );

   PROCEDURE aosplitstring_old (
      avs_stringin           iapitype.stringval_type,
      avs_stringout1   OUT   iapitype.stringval_type,
      avs_stringout2   OUT   iapitype.stringval_type,
      avs_stringout3   OUT   iapitype.stringval_type
   );

   PROCEDURE aostringsplitter (
      avs_stringin          VARCHAR2,                         -- input string
      avi_pos               INTEGER,                          -- token number
      avs_sep               VARCHAR2,                  -- separator character
      avs_stringout   OUT   VARCHAR2
   );

   PROCEDURE aosplitstring (
      avs_stringin           VARCHAR2,
      avs_stringout1   OUT   VARCHAR2,
      avs_stringout2   OUT   VARCHAR2,
      avs_stringout3   OUT   VARCHAR2,
      avs_stringout4   OUT   VARCHAR2
   );
END aogenfuncs; 
 
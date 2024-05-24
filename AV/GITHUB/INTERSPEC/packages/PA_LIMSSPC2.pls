create or replace PACKAGE
----------------------------------------------------------------------------
-- $Revision: 2 $
--  $Modtime: 27/05/10 12:54 $
----------------------------------------------------------------------------
PA_LIMSSPC2 IS

   FUNCTION f_TransferSpcAu(
      a_tp           IN     VARCHAR2,
      a_id           IN     VARCHAR2,
      a_version      IN OUT VARCHAR2,
      a_Au_tab       IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_Value_tab    IN     UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS,
      a_nr_of_rows   IN     NUMBER
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferSpcPpAu(
      a_pp      IN     VARCHAR2,
      a_version IN OUT VARCHAR2,
      a_pp_key1 IN     VARCHAR2,
      a_pp_key2 IN     VARCHAR2,
      a_pp_key3 IN     VARCHAR2,
      a_pp_key4 IN     VARCHAR2,
      a_pp_key5 IN     VARCHAR2,
      a_Au      IN     VARCHAR2,
      a_Value   IN     VARCHAR2
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferSpcAllStAu(
      a_St         IN     VARCHAR2,
      a_version    IN OUT VARCHAR2,
      a_Part_No    IN     specification_header.part_no%TYPE,
      a_Revision   IN     specification_header.revision%TYPE
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferSpcAllStAu_AttachSp(
      a_St                  IN     VARCHAR2,
      a_version             IN OUT VARCHAR2,
      a_sh_revision         IN     NUMBER,
      a_linked_Part_No      IN     specification_header.part_no%TYPE,
      a_linked_Revision     IN     specification_header.revision%TYPE
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferSpcStGk(a_st           IN     VARCHAR2,
                              a_version      IN OUT VARCHAR2,
                              a_gk           IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
                              a_gk_version   IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
                              a_value        IN     UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS,
                              a_nr_of_rows   IN     NUMBER
   )
      RETURN BOOLEAN;

   FUNCTION f_DeleteSpcStGk(
      a_st           IN     VARCHAR2,
      a_version      IN OUT VARCHAR2,
      a_gk           IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_gk_version   IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_value        IN     UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS,
      a_nr_of_rows   IN     NUMBER
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferSpcAllStGk(
      a_st           IN     VARCHAR2,
      a_version      IN OUT VARCHAR2,
      a_Part_No      IN     specification_header.part_no%TYPE,
      a_Revision     IN     specification_header.revision%TYPE
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferSpcUsedAu(
      a_tp             IN     VARCHAR2,
      a_used_tp        IN     VARCHAR2,
      a_id             IN     VARCHAR2,
      a_version        IN OUT VARCHAR2,
      a_used_id        IN     VARCHAR2,
      a_used_version   IN     VARCHAR2,
      a_Au             IN     VARCHAR2,
      a_Value          IN     VARCHAR2
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferSpcStPpAu(
      a_st             IN     VARCHAR2,
      a_version        IN OUT VARCHAR2,
      a_pp             IN     VARCHAR2,
      a_pp_version     IN     VARCHAR2,
      a_pp_key1        IN     VARCHAR2,
      a_pp_key2        IN     VARCHAR2,
      a_pp_key3        IN     VARCHAR2,
      a_pp_key4        IN     VARCHAR2,
      a_pp_key5        IN     VARCHAR2,
      a_Au_tab         IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_Value_tab      IN     UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS,
      a_nr_of_rows     IN     NUMBER
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferSpcPpPrAu(
      a_pp             IN     VARCHAR2,
      a_version        IN OUT VARCHAR2,
      a_pp_key1        IN     VARCHAR2,
      a_pp_key2        IN     VARCHAR2,
      a_pp_key3        IN     VARCHAR2,
      a_pp_key4        IN     VARCHAR2,
      a_pp_key5        IN     VARCHAR2,
      a_pr             IN     VARCHAR2,
      a_pr_version     IN     VARCHAR2,
      a_au_tab         IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_value_tab      IN     UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS,
      a_nr_of_rows     IN     NUMBER
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferSpcAllPpPrAu(
      a_St                 IN     VARCHAR2,
      a_version            IN OUT VARCHAR2,
      a_sh_revision        IN     NUMBER,
      a_Part_No            IN     specification_header.part_no%TYPE,
      a_Revision           IN     specification_header.revision%TYPE
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferSpcAllPpPrAu_AttSp(
      a_Part_No            IN     specification_header.part_no%TYPE,
      a_Revision           IN     specification_header.revision%TYPE,
      a_SectionId_tab      IN     UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS,
      a_SubSectionId_tab   IN     UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS,
      a_nr_of_rows         IN     NUMBER,
      a_PropertyGroup      IN     specification_prop.property_group%TYPE,
      a_PpId               IN     VARCHAR2,
      a_pp_version         IN OUT VARCHAR2,
      a_pp_key1            IN     VARCHAR2,
      a_pp_key2            IN     VARCHAR2,
      a_pp_key3            IN     VARCHAR2,
      a_pp_key4            IN     VARCHAR2,
      a_pp_key5            IN     VARCHAR2
   )
      RETURN BOOLEAN;

   FUNCTION f_GetIUIVersion
      RETURN VARCHAR2;
END PA_LIMSSPC2;
 
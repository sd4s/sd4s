create or replace PACKAGE
----------------------------------------------------------------------------
-- $Revision: 2 $
--  $Modtime: 27/05/10 12:54 $
----------------------------------------------------------------------------
PA_LIMSSPC IS

   -- global variables for the plants that have already been handled
   -- The reason for this way of working is performance. In case a specification has to be transferred
   -- to different plants on the same database and in the same language, the following happened:
   --    for plant 1: the complete transfer process is done
   --    for next plants: only a sampletype groupkey for the plant is appended
   -- To optimise this process, the sampletype groupkeys for all plants are appended when the specification
   -- is transferred for plant 1. In this way, the whole transfer process has not to be looped, only
   -- to append a groupkey.
   g_nr_of_plants       NUMBER                            := 0; -- number of plants that have already been handled
   g_plant_tab          UNAPIGEN.VC8_TABLE_TYPE@LNK_LIMS;       -- plants that have already been handled
   g_connect_string_tab UNAPIGEN.VC40_TABLE_TYPE@LNK_LIMS;      -- connection strings of the plants
   g_lang_id_tab        UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;       -- language id's used for object description
   g_lang_id_4id_tab    UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS;       -- language id's used for object id

   FUNCTION f_TransferSpcSt(
      a_St                IN     VARCHAR2,
      a_version           IN OUT VARCHAR2,
      a_effective_from    IN     DATE,
      a_Description       IN     VARCHAR2,
      a_description2      IN     VARCHAR2,
      a_shelf_life_val    IN     NUMBER,
      a_shelf_life_unit   IN     VARCHAR2,
      a_label_format      IN     VARCHAR2,
      a_default_priority  IN     NUMBER,
      a_Template          IN     VARCHAR2 DEFAULT NULL,
      a_newminor          IN     CHAR
   )
      RETURN BOOLEAN;

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

   FUNCTION f_TransferSpcAllStGk(
      a_st           IN     VARCHAR2,
      a_version      IN OUT VARCHAR2,
      a_Part_No      IN     specification_header.part_no%TYPE,
      a_Revision     IN     specification_header.revision%TYPE
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferSpcPp(
      a_Pp             IN     VARCHAR2,
      a_version        IN OUT VARCHAR2,
      a_pp_key1        IN     VARCHAR2,
      a_pp_key2        IN     VARCHAR2,
      a_pp_key3        IN     VARCHAR2,
      a_pp_key4        IN     VARCHAR2,
      a_pp_key5        IN     VARCHAR2,
      a_effective_from IN     DATE,
      a_Description    IN     VARCHAR2,
      a_Template       IN     VARCHAR2 DEFAULT NULL,
      a_property_group IN     VARCHAR2,
      a_newminor       IN     CHAR
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferSpcStPp(
      a_st          IN     VARCHAR2,
      a_version     IN OUT VARCHAR2,
      a_pp          IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_pp_version  IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_pp_key1     IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_pp_key2     IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_pp_key3     IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_pp_key4     IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_pp_key5     IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_nr_of_rows  IN     NUMBER,
      a_template_st IN     VARCHAR2
   )
      RETURN BOOLEAN;

   FUNCTION f_DeleteAllStPp(
      a_st            IN     VARCHAR2,
      a_version       IN     VARCHAR2
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferSpcAllPpAndStPp(
      a_St                  IN     VARCHAR2,
      a_version             IN OUT VARCHAR2,
      a_sh_revision         IN     NUMBER,
      a_Part_No             IN     specification_header.part_no%TYPE,
      a_Revision            IN     specification_header.revision%TYPE,
      a_effective_from      IN     DATE,
      a_template_st         IN     VARCHAR2
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferSpcPpPr(
      a_pp             IN     VARCHAR2,
      a_version        IN OUT VARCHAR2,
      a_pp_key1        IN     VARCHAR2,
      a_pp_key2        IN     VARCHAR2,
      a_pp_key3        IN     VARCHAR2,
      a_pp_key4        IN     VARCHAR2,
      a_pp_key5        IN     VARCHAR2,
      a_pr_tab         IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_pr_version_tab IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_mt_tab         IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_mt_version_tab IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_nr_of_rows     IN     NUMBER,
      a_template_pp    IN     VARCHAR2
   )
      RETURN BOOLEAN;

   FUNCTION f_DeleteAllPpPr(
      a_pp             IN     VARCHAR2,
      a_version        IN OUT VARCHAR2,
      a_pp_key1        IN     VARCHAR2,
      a_pp_key2        IN     VARCHAR2,
      a_pp_key3        IN     VARCHAR2,
      a_pp_key4        IN     VARCHAR2,
      a_pp_key5        IN     VARCHAR2
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferSpcAllPpPr(
      a_StId                IN     VARCHAR2,
      a_version             IN OUT VARCHAR2,
      a_sh_revision         IN     NUMBER,
      a_Part_No             IN     specification_header.part_no%TYPE,
      a_Revision            IN     specification_header.revision%TYPE
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferSpcPpPrSp(
      a_pp                 IN     VARCHAR2,
      a_version            IN OUT VARCHAR2,
      a_pp_key1            IN     VARCHAR2,
      a_pp_key2            IN     VARCHAR2,
      a_pp_key3            IN     VARCHAR2,
      a_pp_key4            IN     VARCHAR2,
      a_pp_key5            IN     VARCHAR2,
      a_pr_tab             IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_pr_version_tab     IN     UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_Low_Limit_tab      IN     UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS,
      a_High_Limit_tab     IN     UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS,
      a_Low_Spec_tab       IN     UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS,
      a_High_Spec_tab      IN     UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS,
      a_Low_Dev_tab        IN     UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS,
      a_Rel_Low_Dev_tab    IN     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS,
      a_Target_fl_tab      IN     UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS,
      a_High_dev_tab       IN     UNAPIGEN.FLOAT_TABLE_TYPE@LNK_LIMS,
      a_Rel_High_dev_tab   IN     UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS,
      a_nr_of_rows         IN     NUMBER,
      a_specset            IN     CHAR
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferSpcAllPpPrSp(
      a_PpId               IN     VARCHAR2,
      a_version            IN OUT VARCHAR2,
      a_pp_key1            IN     VARCHAR2,
      a_pp_key2            IN     VARCHAR2,
      a_pp_key3            IN     VARCHAR2,
      a_pp_key4            IN     VARCHAR2,
      a_pp_key5            IN     VARCHAR2,
      a_Part_No            IN     specification_prop.part_no%TYPE,
      a_Revision           IN     specification_prop.revision%TYPE,
      a_PropertyGroup      IN     specification_prop.property_group%TYPE,
      a_SectionId_tab      IN     UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS,
      a_SubSectionId_tab   IN     UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS,
      a_Property_tab       IN     UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS,
      a_attribute_tab      IN     UNAPIGEN.NUM_TABLE_TYPE@LNK_LIMS,
      a_nr_of_rows         IN     NUMBER
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

   FUNCTION f_InheritLinkedSpc(
      a_sh_revision             IN     NUMBER,
      a_generic_Part_No         IN     specification_header.part_no%TYPE,   -- generic spec
      a_generic_Revision        IN     specification_header.revision%TYPE,  -- revision of the generic spec
      a_linked_Part_No          IN     specification_header.part_no%TYPE,   -- linked spec
      a_linked_Revision         IN     specification_header.revision%TYPE   -- revision of linked spec
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferSpc(
      a_Part_No    IN specification_header.part_no%TYPE,
      a_Revision   IN specification_header.revision%TYPE,
      a_plant      IN plant.plant%TYPE DEFAULT NULL
   )
      RETURN NUMBER;

   FUNCTION f_TransferASpc(
      a_Part_No    IN specification_header.part_no%TYPE,
      a_Revision   IN specification_header.revision%TYPE
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferAllSpc(
      a_plant               IN VARCHAR2                           DEFAULT NULL,
      a_Part_No             IN specification_header.part_no%TYPE  DEFAULT NULL,
      a_Revision            IN specification_header.revision%TYPE DEFAULT NULL
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferUpdateAllSpc(
      a_plant               IN VARCHAR2                           DEFAULT NULL,
      a_Part_No             IN specification_header.part_no%TYPE  DEFAULT NULL,
      a_Revision            IN specification_header.revision%TYPE DEFAULT NULL
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferUpdateASpc(
      a_Part_No    IN specification_header.part_no%TYPE  DEFAULT NULL,
      a_Revision   IN specification_header.revision%TYPE DEFAULT NULL
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferAHistObs(
      a_Part_No            IN specification_header.part_no%TYPE,
      a_Revision           IN specification_header.revision%TYPE,
      a_obsolescence_date  IN specification_header.obsolescence_date%TYPE
   )
      RETURN BOOLEAN;

   PROCEDURE f_TransferAllHistObs(
      a_plant              IN VARCHAR2                            DEFAULT NULL
   );

   FUNCTION f_GetIUIVersion
      RETURN VARCHAR2;
END PA_LIMSSPC;
 
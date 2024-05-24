create or replace PACKAGE
----------------------------------------------------------------------------
-- $Revision: 2 $
--  $Modtime: 27/05/10 12:57 $
----------------------------------------------------------------------------
PA_SPECXINTERFACE IS

   PROCEDURE p_Create_Gk_table;

   FUNCTION f_StartInterface
   RETURN NUMBER;

   FUNCTION f_StopInterface
   RETURN NUMBER;

   PROCEDURE p_SaveStGkPartially
   (a_st          IN   VARCHAR2,
    a_version     IN   VARCHAR2,
    a_gk          IN   VARCHAR2,
    a_gk_version  IN   VARCHAR2,
    a_value       IN   VARCHAR2);

   PROCEDURE p_SavePpPrProperty
   (a_pp                IN   VARCHAR2,
    a_version           IN   VARCHAR2,
    a_pp_key1           IN   VARCHAR2,
    a_pp_key2           IN   VARCHAR2,
    a_pp_key3           IN   VARCHAR2,
    a_pp_key4           IN   VARCHAR2,
    a_pp_key5           IN   VARCHAR2,
    a_pr                IN   VARCHAR2,
    a_pr_version        IN   VARCHAR2,
    a_display_type_tab  IN   UNAPIGEN.VC20_TABLE_TYPE,
    a_property_tab      IN   UNAPIGEN.VC20_TABLE_TYPE,
    a_value_tab         IN   UNAPIGEN.VC40_TABLE_TYPE,
    a_nr_of_rows        IN   NUMBER);

   PROCEDURE p_NewVersionMgr;

   FUNCTION f_GetIUIVersion
      RETURN VARCHAR2;

   PROCEDURE InhibitStStatusControl
   (a_st                      IN  VARCHAR2,
    a_st_version              IN  VARCHAR2,
    a_orig_version_is_current OUT CHAR,
    a_orig_allow_modify       OUT CHAR,
    a_orig_active             OUT CHAR);

   PROCEDURE RestoreStStatusControl
   (a_st                      IN  VARCHAR2,
    a_st_version              IN  VARCHAR2,
    a_version_is_current      IN  CHAR,
    a_allow_modify            IN  CHAR,
    a_active                  IN  CHAR);

   FUNCTION SetCustomConnectionParameter
   (a_CustomConnectionParameter         IN VARCHAR2)    /* VC2000_TYPE */
   RETURN NUMBER;

   FUNCTION  f_InsertBufferedEvents
   (a_object_tp_tab           IN   UNAPIGEN.VC4_TABLE_TYPE,
    a_object_id_tab           IN   UNAPIGEN.VC20_TABLE_TYPE,
    a_object_ev_details_tab   IN   UNAPIGEN.VC255_TABLE_TYPE,
    a_nr_of_rows              IN   NUMBER)
   RETURN NUMBER;

END PA_SPECXINTERFACE;
 
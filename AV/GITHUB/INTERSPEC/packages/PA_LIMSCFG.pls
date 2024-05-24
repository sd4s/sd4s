create or replace PACKAGE
----------------------------------------------------------------------------
-- $Revision: 2 $
--  $Modtime: 27/05/10 12:54 $
----------------------------------------------------------------------------
PA_LIMSCFG IS

   FUNCTION f_TransferCfgAu(
      a_Au           IN VARCHAR2,
      a_version      IN VARCHAR2
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferCfgPr(
      a_Pr                    IN     VARCHAR2,
      a_version               IN OUT VARCHAR2,
      a_description           IN     VARCHAR2,
      a_template              IN     VARCHAR2 DEFAULT NULL,
      a_property              IN     VARCHAR2,
      a_newminor              IN     CHAR,
      a_property_is_historic  IN     NUMBER
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferCfgAllPr
      RETURN BOOLEAN;

   FUNCTION f_TransferCfgMt(
      a_Mt           IN     VARCHAR2,
      a_version      IN OUT VARCHAR2,
      a_description  IN     VARCHAR2,
      a_template     IN     VARCHAR2 DEFAULT NULL,
      a_test_method  IN     VARCHAR2,
      a_newminor     IN     CHAR
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferCfgAllMt
      RETURN BOOLEAN;

   FUNCTION f_TransferCfgPrMt(
      a_pr          IN      VARCHAR2,
      a_version     IN OUT  VARCHAR2,
      a_mt          IN      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_mt_version  IN      UNAPIGEN.VC20_TABLE_TYPE@LNK_LIMS,
      a_nr_of_rows  IN      NUMBER,
      a_template_pr IN      VARCHAR2
   )
      RETURN BOOLEAN;

   FUNCTION f_DeleteAllPrMt(
      a_pr             IN     VARCHAR2,
      a_version        IN     VARCHAR2
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferCfgAllPrMt(
      a_PrId                  IN VARCHAR2 DEFAULT NULL,
      a_Property              IN property.property%TYPE DEFAULT NULL,
      a_attribute             IN attribute.attribute%TYPE,
      a_template_pr           IN VARCHAR2
   )
      RETURN BOOLEAN;

   FUNCTION f_TransferCfgGkSt(
      a_Gk             IN VARCHAR2,
      a_description    IN VARCHAR2)
      RETURN BOOLEAN;

   FUNCTION f_TransferCfgAllGkSt
      RETURN BOOLEAN;

   FUNCTION f_TransferCfg
      RETURN BOOLEAN;

   FUNCTION f_TransferAllCfg(
      a_plant       IN VARCHAR2 DEFAULT NULL
   )
      RETURN NUMBER;

   FUNCTION f_TransferAllCfgInternal(
      a_plant       IN VARCHAR2 DEFAULT NULL
   )
      RETURN NUMBER;

   FUNCTION f_GetIUIVersion
      RETURN VARCHAR2;
END PA_LIMSCFG;
 
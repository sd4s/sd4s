PACKAGE BODY unapiraco AS






FUNCTION GETVERSION
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
   RETURN (NULL);
END GETVERSION;

PROCEDURE WRITECONFIGURATIONSTRUCTURES IS 
BEGIN
   UNAPIRA3.U4DATAPUTLINE(
      'utwt'                               || UNAPIRA.P_SEP ||
         'wt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'description2'                  || UNAPIRA.P_SEP ||
         'min_rows'                      || UNAPIRA.P_SEP ||
         'max_rows'                      || UNAPIRA.P_SEP ||
         'valid_cf'                      || UNAPIRA.P_SEP ||
         'descr_doc'                     || UNAPIRA.P_SEP ||
         'descr_doc_version'             || UNAPIRA.P_SEP ||
         'ws_ly'                         || UNAPIRA.P_SEP ||
         'ws_uc'                         || UNAPIRA.P_SEP ||
         'ws_uc_version'                 || UNAPIRA.P_SEP ||
         'ws_lc'                         || UNAPIRA.P_SEP ||
         'ws_lc_version'                 || UNAPIRA.P_SEP ||
         'inherit_au'                    || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'wt_class'                      || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'                            || UNAPIRA.P_SEP ||
         'ar1'                           || UNAPIRA.P_SEP ||
         'ar2'                           || UNAPIRA.P_SEP ||
         'ar3'                           || UNAPIRA.P_SEP ||
         'ar4'                           || UNAPIRA.P_SEP ||
         'ar5'                           || UNAPIRA.P_SEP ||
         'ar6'                           || UNAPIRA.P_SEP ||
         'ar7'                           || UNAPIRA.P_SEP ||
         'ar8'                           || UNAPIRA.P_SEP ||
         'ar9'                           || UNAPIRA.P_SEP ||
         'ar10'                          || UNAPIRA.P_SEP ||
         'ar11'                          || UNAPIRA.P_SEP ||
         'ar12'                          || UNAPIRA.P_SEP ||
         'ar13'                          || UNAPIRA.P_SEP ||
         'ar14'                          || UNAPIRA.P_SEP ||
         'ar15'                          || UNAPIRA.P_SEP ||
         'ar16'                          || UNAPIRA.P_SEP ||
         'ar17'                          || UNAPIRA.P_SEP ||
         'ar18'                          || UNAPIRA.P_SEP ||
         'ar19'                          || UNAPIRA.P_SEP ||
         'ar20'                          || UNAPIRA.P_SEP ||
         'ar21'                          || UNAPIRA.P_SEP ||
         'ar22'                          || UNAPIRA.P_SEP ||
         'ar23'                          || UNAPIRA.P_SEP ||
         'ar24'                          || UNAPIRA.P_SEP ||
         'ar25'                          || UNAPIRA.P_SEP ||
         'ar26'                          || UNAPIRA.P_SEP ||
         'ar27'                          || UNAPIRA.P_SEP ||
         'ar28'                          || UNAPIRA.P_SEP ||
         'ar29'                          || UNAPIRA.P_SEP ||
         'ar30'                          || UNAPIRA.P_SEP ||
         'ar31'                          || UNAPIRA.P_SEP ||
         'ar32'                          || UNAPIRA.P_SEP ||
         'ar33'                          || UNAPIRA.P_SEP ||
         'ar34'                          || UNAPIRA.P_SEP ||
         'ar35'                          || UNAPIRA.P_SEP ||
         'ar36'                          || UNAPIRA.P_SEP ||
         'ar37'                          || UNAPIRA.P_SEP ||
         'ar38'                          || UNAPIRA.P_SEP ||
         'ar39'                          || UNAPIRA.P_SEP ||
         'ar40'                          || UNAPIRA.P_SEP ||
         'ar41'                          || UNAPIRA.P_SEP ||
         'ar42'                          || UNAPIRA.P_SEP ||
         'ar43'                          || UNAPIRA.P_SEP ||
         'ar44'                          || UNAPIRA.P_SEP ||
         'ar45'                          || UNAPIRA.P_SEP ||
         'ar46'                          || UNAPIRA.P_SEP ||
         'ar47'                          || UNAPIRA.P_SEP ||
         'ar48'                          || UNAPIRA.P_SEP ||
         'ar49'                          || UNAPIRA.P_SEP ||
         'ar50'                          || UNAPIRA.P_SEP ||
         'ar51'                          || UNAPIRA.P_SEP ||
         'ar52'                          || UNAPIRA.P_SEP ||
         'ar53'                          || UNAPIRA.P_SEP ||
         'ar54'                          || UNAPIRA.P_SEP ||
         'ar55'                          || UNAPIRA.P_SEP ||
         'ar56'                          || UNAPIRA.P_SEP ||
         'ar57'                          || UNAPIRA.P_SEP ||
         'ar58'                          || UNAPIRA.P_SEP ||
         'ar59'                          || UNAPIRA.P_SEP ||
         'ar60'                          || UNAPIRA.P_SEP ||
         'ar61'                          || UNAPIRA.P_SEP ||
         'ar62'                          || UNAPIRA.P_SEP ||
         'ar63'                          || UNAPIRA.P_SEP ||
         'ar64'                          || UNAPIRA.P_SEP ||
         'ar65'                          || UNAPIRA.P_SEP ||
         'ar66'                          || UNAPIRA.P_SEP ||
         'ar67'                          || UNAPIRA.P_SEP ||
         'ar68'                          || UNAPIRA.P_SEP ||
         'ar69'                          || UNAPIRA.P_SEP ||
         'ar70'                          || UNAPIRA.P_SEP ||
         'ar71'                          || UNAPIRA.P_SEP ||
         'ar72'                          || UNAPIRA.P_SEP ||
         'ar73'                          || UNAPIRA.P_SEP ||
         'ar74'                          || UNAPIRA.P_SEP ||
         'ar75'                          || UNAPIRA.P_SEP ||
         'ar76'                          || UNAPIRA.P_SEP ||
         'ar77'                          || UNAPIRA.P_SEP ||
         'ar78'                          || UNAPIRA.P_SEP ||
         'ar79'                          || UNAPIRA.P_SEP ||
         'ar80'                          || UNAPIRA.P_SEP ||
         'ar81'                          || UNAPIRA.P_SEP ||
         'ar82'                          || UNAPIRA.P_SEP ||
         'ar83'                          || UNAPIRA.P_SEP ||
         'ar84'                          || UNAPIRA.P_SEP ||
         'ar85'                          || UNAPIRA.P_SEP ||
         'ar86'                          || UNAPIRA.P_SEP ||
         'ar87'                          || UNAPIRA.P_SEP ||
         'ar88'                          || UNAPIRA.P_SEP ||
         'ar89'                          || UNAPIRA.P_SEP ||
         'ar90'                          || UNAPIRA.P_SEP ||
         'ar91'                          || UNAPIRA.P_SEP ||
         'ar92'                          || UNAPIRA.P_SEP ||
         'ar93'                          || UNAPIRA.P_SEP ||
         'ar94'                          || UNAPIRA.P_SEP ||
         'ar95'                          || UNAPIRA.P_SEP ||
         'ar96'                          || UNAPIRA.P_SEP ||
         'ar97'                          || UNAPIRA.P_SEP ||
         'ar98'                          || UNAPIRA.P_SEP ||
         'ar99'                          || UNAPIRA.P_SEP ||
         'ar100'                         || UNAPIRA.P_SEP ||
         'ar101'                         || UNAPIRA.P_SEP ||
         'ar102'                         || UNAPIRA.P_SEP ||
         'ar103'                         || UNAPIRA.P_SEP ||
         'ar104'                         || UNAPIRA.P_SEP ||
         'ar105'                         || UNAPIRA.P_SEP ||
         'ar106'                         || UNAPIRA.P_SEP ||
         'ar107'                         || UNAPIRA.P_SEP ||
         'ar108'                         || UNAPIRA.P_SEP ||
         'ar109'                         || UNAPIRA.P_SEP ||
         'ar110'                         || UNAPIRA.P_SEP ||
         'ar111'                         || UNAPIRA.P_SEP ||
         'ar112'                         || UNAPIRA.P_SEP ||
         'ar113'                         || UNAPIRA.P_SEP ||
         'ar114'                         || UNAPIRA.P_SEP ||
         'ar115'                         || UNAPIRA.P_SEP ||
         'ar116'                         || UNAPIRA.P_SEP ||
         'ar117'                         || UNAPIRA.P_SEP ||
         'ar118'                         || UNAPIRA.P_SEP ||
         'ar119'                         || UNAPIRA.P_SEP ||
         'ar120'                         || UNAPIRA.P_SEP ||
         'ar121'                         || UNAPIRA.P_SEP ||
         'ar122'                         || UNAPIRA.P_SEP ||
         'ar123'                         || UNAPIRA.P_SEP ||
         'ar124'                         || UNAPIRA.P_SEP ||
         'ar125'                         || UNAPIRA.P_SEP ||
         'ar126'                         || UNAPIRA.P_SEP ||
         'ar127'                         || UNAPIRA.P_SEP ||
         'ar128'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utwtau'                             || UNAPIRA.P_SEP ||
         'wt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utwths'                             || UNAPIRA.P_SEP ||
         'wt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utwtrows'                           || UNAPIRA.P_SEP ||
         'wt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'rownr'                         || UNAPIRA.P_SEP ||
         'st'                            || UNAPIRA.P_SEP ||
         'st_version'                    || UNAPIRA.P_SEP ||
         'sc'                            || UNAPIRA.P_SEP ||
         'sc_create'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utwthsdetails'                      || UNAPIRA.P_SEP ||
         'wt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'uttitlefmt'                         || UNAPIRA.P_SEP ||
         'window'                        || UNAPIRA.P_SEP ||
         'title_format'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utcystyle'                          || UNAPIRA.P_SEP ||
         'visual_cf'                     || UNAPIRA.P_SEP ||
         'cy'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'prop_name'                     || UNAPIRA.P_SEP ||
         'prop_value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utcystylelist'                      || UNAPIRA.P_SEP ||
         'visual_cf'                     || UNAPIRA.P_SEP ||
         'cy'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'prop_name'                     || UNAPIRA.P_SEP ||
         'prop_value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utup'                               || UNAPIRA.P_SEP ||
         'up'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'version_is_current'            || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'dd'                            || UNAPIRA.P_SEP ||
         'descr_doc'                     || UNAPIRA.P_SEP ||
         'descr_doc_version'             || UNAPIRA.P_SEP ||
         'chg_pwd'                       || UNAPIRA.P_SEP ||
         'define_menu'                   || UNAPIRA.P_SEP ||
         'confirm_chg_ss'                || UNAPIRA.P_SEP ||
         'language'                      || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'up_class'                      || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utupau'                             || UNAPIRA.P_SEP ||
         'up'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utupfa'                             || UNAPIRA.P_SEP ||
         'up'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'applic'                        || UNAPIRA.P_SEP ||
         'topic'                         || UNAPIRA.P_SEP ||
         'fa'                            || UNAPIRA.P_SEP ||
         'inherit_fa'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utuphs'                             || UNAPIRA.P_SEP ||
         'up'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utuptk'                             || UNAPIRA.P_SEP ||
         'up'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'tk_tp'                         || UNAPIRA.P_SEP ||
         'tk'                            || UNAPIRA.P_SEP ||
         'is_enabled'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utupus'                             || UNAPIRA.P_SEP ||
         'up'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'us'                            || UNAPIRA.P_SEP ||
         'us_version'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utuppref'                           || UNAPIRA.P_SEP ||
         'up'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'pref_name'                     || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'pref_value'                    || UNAPIRA.P_SEP ||
         'inherit_pref'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utupusel'                           || UNAPIRA.P_SEP ||
         'up'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'us'                            || UNAPIRA.P_SEP ||
         'us_version'                    || UNAPIRA.P_SEP ||
         'el'                            || UNAPIRA.P_SEP ||
         'is_enabled'                    || UNAPIRA.P_SEP ||
         'seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utupusfa'                           || UNAPIRA.P_SEP ||
         'up'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'us'                            || UNAPIRA.P_SEP ||
         'us_version'                    || UNAPIRA.P_SEP ||
         'applic'                        || UNAPIRA.P_SEP ||
         'topic'                         || UNAPIRA.P_SEP ||
         'fa'                            || UNAPIRA.P_SEP ||
         'inherit_fa'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utupustk'                           || UNAPIRA.P_SEP ||
         'up'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'us'                            || UNAPIRA.P_SEP ||
         'us_version'                    || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'tk_tp'                         || UNAPIRA.P_SEP ||
         'tk'                            || UNAPIRA.P_SEP ||
         'is_enabled'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utupuspref'                         || UNAPIRA.P_SEP ||
         'up'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'us'                            || UNAPIRA.P_SEP ||
         'us_version'                    || UNAPIRA.P_SEP ||
         'pref_name'                     || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'pref_value'                    || UNAPIRA.P_SEP ||
         'inherit_pref'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utuphsdetails'                      || UNAPIRA.P_SEP ||
         'up'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utuptkdetails'                      || UNAPIRA.P_SEP ||
         'up'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tk_tp'                         || UNAPIRA.P_SEP ||
         'tk'                            || UNAPIRA.P_SEP ||
         'col_id'                        || UNAPIRA.P_SEP ||
         'col_tp'                        || UNAPIRA.P_SEP ||
         'dsp_title'                     || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'operat'                        || UNAPIRA.P_SEP ||
         'def_val'                       || UNAPIRA.P_SEP ||
         'andor'                         || UNAPIRA.P_SEP ||
         'hidden'                        || UNAPIRA.P_SEP ||
         'is_protected'                  || UNAPIRA.P_SEP ||
         'mandatory'                     || UNAPIRA.P_SEP ||
         'auto_refresh'                  || UNAPIRA.P_SEP ||
         'col_asc'                       || UNAPIRA.P_SEP ||
         'operat_protect'                || UNAPIRA.P_SEP ||
         'andor_protect'                 || UNAPIRA.P_SEP ||
         'dsp_len'                       || UNAPIRA.P_SEP ||
         'inherit_tk'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utupustkdetails'                    || UNAPIRA.P_SEP ||
         'up'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'us'                            || UNAPIRA.P_SEP ||
         'us_version'                    || UNAPIRA.P_SEP ||
         'tk_tp'                         || UNAPIRA.P_SEP ||
         'tk'                            || UNAPIRA.P_SEP ||
         'col_id'                        || UNAPIRA.P_SEP ||
         'col_tp'                        || UNAPIRA.P_SEP ||
         'dsp_title'                     || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'operat'                        || UNAPIRA.P_SEP ||
         'def_val'                       || UNAPIRA.P_SEP ||
         'andor'                         || UNAPIRA.P_SEP ||
         'hidden'                        || UNAPIRA.P_SEP ||
         'is_protected'                  || UNAPIRA.P_SEP ||
         'mandatory'                     || UNAPIRA.P_SEP ||
         'auto_refresh'                  || UNAPIRA.P_SEP ||
         'col_asc'                       || UNAPIRA.P_SEP ||
         'operat_protect'                || UNAPIRA.P_SEP ||
         'andor_protect'                 || UNAPIRA.P_SEP ||
         'dsp_len'                       || UNAPIRA.P_SEP ||
         'inherit_tk'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utupusoutlookpages'                 || UNAPIRA.P_SEP ||
         'up'                            || UNAPIRA.P_SEP ||
         'us'                            || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'page_id'                       || UNAPIRA.P_SEP ||
         'page_description'              || UNAPIRA.P_SEP ||
         'page_tp'                       || UNAPIRA.P_SEP ||
         'active'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utupusoutlooktasks'                 || UNAPIRA.P_SEP ||
         'up'                            || UNAPIRA.P_SEP ||
         'us'                            || UNAPIRA.P_SEP ||
         'page_id'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'tk'                            || UNAPIRA.P_SEP ||
         'tk_tp'                         || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'icon_name'                     || UNAPIRA.P_SEP ||
         'icon_nbr'                      || UNAPIRA.P_SEP ||
         'cmd_line'                      || UNAPIRA.P_SEP ||
         'active'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utunit'                             || UNAPIRA.P_SEP ||
         'unit'                          || UNAPIRA.P_SEP ||
         'unit_tp'                       || UNAPIRA.P_SEP ||
         'conv_factor'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utuc'                               || UNAPIRA.P_SEP ||
         'uc'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'version_is_current'            || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'uc_structure'                  || UNAPIRA.P_SEP ||
         'curr_val'                      || UNAPIRA.P_SEP ||
         'def_mask_for'                  || UNAPIRA.P_SEP ||
         'edit_allowed'                  || UNAPIRA.P_SEP ||
         'valid_cf'                      || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utucau'                             || UNAPIRA.P_SEP ||
         'uc'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utuchs'                             || UNAPIRA.P_SEP ||
         'uc'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utuchsdetails'                      || UNAPIRA.P_SEP ||
         'uc'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utucaudittrail'                     || UNAPIRA.P_SEP ||
         'uc'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'curr_val'                      || UNAPIRA.P_SEP ||
         'ref_date'                      || UNAPIRA.P_SEP ||
         'ref_date_tz'                   || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'us'                            || UNAPIRA.P_SEP ||
         'client_id'                     || UNAPIRA.P_SEP ||
         'applic'                        || UNAPIRA.P_SEP ||
         'sid'                           || UNAPIRA.P_SEP ||
         'serial#'                       || UNAPIRA.P_SEP ||
         'osuser'                        || UNAPIRA.P_SEP ||
         'terminal'                      || UNAPIRA.P_SEP ||
         'program'                       || UNAPIRA.P_SEP ||
         'logon_time'                    || UNAPIRA.P_SEP ||
         'logon_time_tz'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'uttk'                               || UNAPIRA.P_SEP ||
         'tk_tp'                         || UNAPIRA.P_SEP ||
         'tk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'version_is_current'            || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'col_id'                        || UNAPIRA.P_SEP ||
         'col_tp'                        || UNAPIRA.P_SEP ||
         'dsp_title'                     || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'operat'                        || UNAPIRA.P_SEP ||
         'def_val'                       || UNAPIRA.P_SEP ||
         'andor'                         || UNAPIRA.P_SEP ||
         'hidden'                        || UNAPIRA.P_SEP ||
         'is_protected'                  || UNAPIRA.P_SEP ||
         'mandatory'                     || UNAPIRA.P_SEP ||
         'auto_refresh'                  || UNAPIRA.P_SEP ||
         'col_asc'                       || UNAPIRA.P_SEP ||
         'dsp_len'                       || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'tk_class'                      || UNAPIRA.P_SEP ||
         'value_list_tp'                 || UNAPIRA.P_SEP ||
         'operat_protect'                || UNAPIRA.P_SEP ||
         'andor_protect'                 || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'uttkhs'                             || UNAPIRA.P_SEP ||
         'tk_tp'                         || UNAPIRA.P_SEP ||
         'tk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'uttkpref'                           || UNAPIRA.P_SEP ||
         'tk_tp'                         || UNAPIRA.P_SEP ||
         'tk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'pref_name'                     || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'pref_value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'uttkhsdetails'                      || UNAPIRA.P_SEP ||
         'tk_tp'                         || UNAPIRA.P_SEP ||
         'tk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'uttksql'                            || UNAPIRA.P_SEP ||
         'tk'                            || UNAPIRA.P_SEP ||
         'tk_tp'                         || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'col_id'                        || UNAPIRA.P_SEP ||
         'col_tp'                        || UNAPIRA.P_SEP ||
         'sqlseq'                        || UNAPIRA.P_SEP ||
         'sqltext'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utedtblhs'                          || UNAPIRA.P_SEP ||
         'table_name'                    || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utedtblhsdetails'                   || UNAPIRA.P_SEP ||
         'table_name'                    || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utst'                               || UNAPIRA.P_SEP ||
         'st'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'description2'                  || UNAPIRA.P_SEP ||
         'is_template'                   || UNAPIRA.P_SEP ||
         'confirm_userid'                || UNAPIRA.P_SEP ||
         'shelf_life_val'                || UNAPIRA.P_SEP ||
         'shelf_life_unit'               || UNAPIRA.P_SEP ||
         'nr_planned_sc'                 || UNAPIRA.P_SEP ||
         'freq_tp'                       || UNAPIRA.P_SEP ||
         'freq_val'                      || UNAPIRA.P_SEP ||
         'freq_unit'                     || UNAPIRA.P_SEP ||
         'invert_freq'                   || UNAPIRA.P_SEP ||
         'last_sched'                    || UNAPIRA.P_SEP ||
         'last_sched_tz'                 || UNAPIRA.P_SEP ||
         'last_cnt'                      || UNAPIRA.P_SEP ||
         'last_val'                      || UNAPIRA.P_SEP ||
         'priority'                      || UNAPIRA.P_SEP ||
         'label_format'                  || UNAPIRA.P_SEP ||
         'descr_doc'                     || UNAPIRA.P_SEP ||
         'descr_doc_version'             || UNAPIRA.P_SEP ||
         'allow_any_pp'                  || UNAPIRA.P_SEP ||
         'sc_uc'                         || UNAPIRA.P_SEP ||
         'sc_uc_version'                 || UNAPIRA.P_SEP ||
         'sc_lc'                         || UNAPIRA.P_SEP ||
         'sc_lc_version'                 || UNAPIRA.P_SEP ||
         'inherit_au'                    || UNAPIRA.P_SEP ||
         'inherit_gk'                    || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'st_class'                      || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'                            || UNAPIRA.P_SEP ||
         'ar1'                           || UNAPIRA.P_SEP ||
         'ar2'                           || UNAPIRA.P_SEP ||
         'ar3'                           || UNAPIRA.P_SEP ||
         'ar4'                           || UNAPIRA.P_SEP ||
         'ar5'                           || UNAPIRA.P_SEP ||
         'ar6'                           || UNAPIRA.P_SEP ||
         'ar7'                           || UNAPIRA.P_SEP ||
         'ar8'                           || UNAPIRA.P_SEP ||
         'ar9'                           || UNAPIRA.P_SEP ||
         'ar10'                          || UNAPIRA.P_SEP ||
         'ar11'                          || UNAPIRA.P_SEP ||
         'ar12'                          || UNAPIRA.P_SEP ||
         'ar13'                          || UNAPIRA.P_SEP ||
         'ar14'                          || UNAPIRA.P_SEP ||
         'ar15'                          || UNAPIRA.P_SEP ||
         'ar16'                          || UNAPIRA.P_SEP ||
         'ar17'                          || UNAPIRA.P_SEP ||
         'ar18'                          || UNAPIRA.P_SEP ||
         'ar19'                          || UNAPIRA.P_SEP ||
         'ar20'                          || UNAPIRA.P_SEP ||
         'ar21'                          || UNAPIRA.P_SEP ||
         'ar22'                          || UNAPIRA.P_SEP ||
         'ar23'                          || UNAPIRA.P_SEP ||
         'ar24'                          || UNAPIRA.P_SEP ||
         'ar25'                          || UNAPIRA.P_SEP ||
         'ar26'                          || UNAPIRA.P_SEP ||
         'ar27'                          || UNAPIRA.P_SEP ||
         'ar28'                          || UNAPIRA.P_SEP ||
         'ar29'                          || UNAPIRA.P_SEP ||
         'ar30'                          || UNAPIRA.P_SEP ||
         'ar31'                          || UNAPIRA.P_SEP ||
         'ar32'                          || UNAPIRA.P_SEP ||
         'ar33'                          || UNAPIRA.P_SEP ||
         'ar34'                          || UNAPIRA.P_SEP ||
         'ar35'                          || UNAPIRA.P_SEP ||
         'ar36'                          || UNAPIRA.P_SEP ||
         'ar37'                          || UNAPIRA.P_SEP ||
         'ar38'                          || UNAPIRA.P_SEP ||
         'ar39'                          || UNAPIRA.P_SEP ||
         'ar40'                          || UNAPIRA.P_SEP ||
         'ar41'                          || UNAPIRA.P_SEP ||
         'ar42'                          || UNAPIRA.P_SEP ||
         'ar43'                          || UNAPIRA.P_SEP ||
         'ar44'                          || UNAPIRA.P_SEP ||
         'ar45'                          || UNAPIRA.P_SEP ||
         'ar46'                          || UNAPIRA.P_SEP ||
         'ar47'                          || UNAPIRA.P_SEP ||
         'ar48'                          || UNAPIRA.P_SEP ||
         'ar49'                          || UNAPIRA.P_SEP ||
         'ar50'                          || UNAPIRA.P_SEP ||
         'ar51'                          || UNAPIRA.P_SEP ||
         'ar52'                          || UNAPIRA.P_SEP ||
         'ar53'                          || UNAPIRA.P_SEP ||
         'ar54'                          || UNAPIRA.P_SEP ||
         'ar55'                          || UNAPIRA.P_SEP ||
         'ar56'                          || UNAPIRA.P_SEP ||
         'ar57'                          || UNAPIRA.P_SEP ||
         'ar58'                          || UNAPIRA.P_SEP ||
         'ar59'                          || UNAPIRA.P_SEP ||
         'ar60'                          || UNAPIRA.P_SEP ||
         'ar61'                          || UNAPIRA.P_SEP ||
         'ar62'                          || UNAPIRA.P_SEP ||
         'ar63'                          || UNAPIRA.P_SEP ||
         'ar64'                          || UNAPIRA.P_SEP ||
         'ar65'                          || UNAPIRA.P_SEP ||
         'ar66'                          || UNAPIRA.P_SEP ||
         'ar67'                          || UNAPIRA.P_SEP ||
         'ar68'                          || UNAPIRA.P_SEP ||
         'ar69'                          || UNAPIRA.P_SEP ||
         'ar70'                          || UNAPIRA.P_SEP ||
         'ar71'                          || UNAPIRA.P_SEP ||
         'ar72'                          || UNAPIRA.P_SEP ||
         'ar73'                          || UNAPIRA.P_SEP ||
         'ar74'                          || UNAPIRA.P_SEP ||
         'ar75'                          || UNAPIRA.P_SEP ||
         'ar76'                          || UNAPIRA.P_SEP ||
         'ar77'                          || UNAPIRA.P_SEP ||
         'ar78'                          || UNAPIRA.P_SEP ||
         'ar79'                          || UNAPIRA.P_SEP ||
         'ar80'                          || UNAPIRA.P_SEP ||
         'ar81'                          || UNAPIRA.P_SEP ||
         'ar82'                          || UNAPIRA.P_SEP ||
         'ar83'                          || UNAPIRA.P_SEP ||
         'ar84'                          || UNAPIRA.P_SEP ||
         'ar85'                          || UNAPIRA.P_SEP ||
         'ar86'                          || UNAPIRA.P_SEP ||
         'ar87'                          || UNAPIRA.P_SEP ||
         'ar88'                          || UNAPIRA.P_SEP ||
         'ar89'                          || UNAPIRA.P_SEP ||
         'ar90'                          || UNAPIRA.P_SEP ||
         'ar91'                          || UNAPIRA.P_SEP ||
         'ar92'                          || UNAPIRA.P_SEP ||
         'ar93'                          || UNAPIRA.P_SEP ||
         'ar94'                          || UNAPIRA.P_SEP ||
         'ar95'                          || UNAPIRA.P_SEP ||
         'ar96'                          || UNAPIRA.P_SEP ||
         'ar97'                          || UNAPIRA.P_SEP ||
         'ar98'                          || UNAPIRA.P_SEP ||
         'ar99'                          || UNAPIRA.P_SEP ||
         'ar100'                         || UNAPIRA.P_SEP ||
         'ar101'                         || UNAPIRA.P_SEP ||
         'ar102'                         || UNAPIRA.P_SEP ||
         'ar103'                         || UNAPIRA.P_SEP ||
         'ar104'                         || UNAPIRA.P_SEP ||
         'ar105'                         || UNAPIRA.P_SEP ||
         'ar106'                         || UNAPIRA.P_SEP ||
         'ar107'                         || UNAPIRA.P_SEP ||
         'ar108'                         || UNAPIRA.P_SEP ||
         'ar109'                         || UNAPIRA.P_SEP ||
         'ar110'                         || UNAPIRA.P_SEP ||
         'ar111'                         || UNAPIRA.P_SEP ||
         'ar112'                         || UNAPIRA.P_SEP ||
         'ar113'                         || UNAPIRA.P_SEP ||
         'ar114'                         || UNAPIRA.P_SEP ||
         'ar115'                         || UNAPIRA.P_SEP ||
         'ar116'                         || UNAPIRA.P_SEP ||
         'ar117'                         || UNAPIRA.P_SEP ||
         'ar118'                         || UNAPIRA.P_SEP ||
         'ar119'                         || UNAPIRA.P_SEP ||
         'ar120'                         || UNAPIRA.P_SEP ||
         'ar121'                         || UNAPIRA.P_SEP ||
         'ar122'                         || UNAPIRA.P_SEP ||
         'ar123'                         || UNAPIRA.P_SEP ||
         'ar124'                         || UNAPIRA.P_SEP ||
         'ar125'                         || UNAPIRA.P_SEP ||
         'ar126'                         || UNAPIRA.P_SEP ||
         'ar127'                         || UNAPIRA.P_SEP ||
         'ar128'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utstau'                             || UNAPIRA.P_SEP ||
         'st'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utsths'                             || UNAPIRA.P_SEP ||
         'st'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utstip'                             || UNAPIRA.P_SEP ||
         'st'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'ip'                            || UNAPIRA.P_SEP ||
         'ip_version'                    || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'is_protected'                  || UNAPIRA.P_SEP ||
         'hidden'                        || UNAPIRA.P_SEP ||
         'freq_tp'                       || UNAPIRA.P_SEP ||
         'freq_val'                      || UNAPIRA.P_SEP ||
         'freq_unit'                     || UNAPIRA.P_SEP ||
         'invert_freq'                   || UNAPIRA.P_SEP ||
         'last_sched'                    || UNAPIRA.P_SEP ||
         'last_sched_tz'                 || UNAPIRA.P_SEP ||
         'last_cnt'                      || UNAPIRA.P_SEP ||
         'last_val'                      || UNAPIRA.P_SEP ||
         'inherit_au'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utstpp'                             || UNAPIRA.P_SEP ||
         'st'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'pp'                            || UNAPIRA.P_SEP ||
         'pp_version'                    || UNAPIRA.P_SEP ||
         'pp_key1'                       || UNAPIRA.P_SEP ||
         'pp_key2'                       || UNAPIRA.P_SEP ||
         'pp_key3'                       || UNAPIRA.P_SEP ||
         'pp_key4'                       || UNAPIRA.P_SEP ||
         'pp_key5'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'freq_tp'                       || UNAPIRA.P_SEP ||
         'freq_val'                      || UNAPIRA.P_SEP ||
         'freq_unit'                     || UNAPIRA.P_SEP ||
         'invert_freq'                   || UNAPIRA.P_SEP ||
         'last_sched'                    || UNAPIRA.P_SEP ||
         'last_sched_tz'                 || UNAPIRA.P_SEP ||
         'last_cnt'                      || UNAPIRA.P_SEP ||
         'last_val'                      || UNAPIRA.P_SEP ||
         'inherit_au'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utstipau'                           || UNAPIRA.P_SEP ||
         'st'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'ip'                            || UNAPIRA.P_SEP ||
         'ip_version'                    || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utstppau'                           || UNAPIRA.P_SEP ||
         'st'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'pp'                            || UNAPIRA.P_SEP ||
         'pp_version'                    || UNAPIRA.P_SEP ||
         'pp_key1'                       || UNAPIRA.P_SEP ||
         'pp_key2'                       || UNAPIRA.P_SEP ||
         'pp_key3'                       || UNAPIRA.P_SEP ||
         'pp_key4'                       || UNAPIRA.P_SEP ||
         'pp_key5'                       || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utstmtfreq'                         || UNAPIRA.P_SEP ||
         'st'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'pr'                            || UNAPIRA.P_SEP ||
         'pr_version'                    || UNAPIRA.P_SEP ||
         'mt'                            || UNAPIRA.P_SEP ||
         'mt_version'                    || UNAPIRA.P_SEP ||
         'freq_tp'                       || UNAPIRA.P_SEP ||
         'freq_val'                      || UNAPIRA.P_SEP ||
         'freq_unit'                     || UNAPIRA.P_SEP ||
         'invert_freq'                   || UNAPIRA.P_SEP ||
         'last_sched'                    || UNAPIRA.P_SEP ||
         'last_sched_tz'                 || UNAPIRA.P_SEP ||
         'last_cnt'                      || UNAPIRA.P_SEP ||
         'last_val'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utstprfreq'                         || UNAPIRA.P_SEP ||
         'st'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'pp'                            || UNAPIRA.P_SEP ||
         'pp_version'                    || UNAPIRA.P_SEP ||
         'pp_key1'                       || UNAPIRA.P_SEP ||
         'pp_key2'                       || UNAPIRA.P_SEP ||
         'pp_key3'                       || UNAPIRA.P_SEP ||
         'pp_key4'                       || UNAPIRA.P_SEP ||
         'pp_key5'                       || UNAPIRA.P_SEP ||
         'pr'                            || UNAPIRA.P_SEP ||
         'pr_version'                    || UNAPIRA.P_SEP ||
         'freq_tp'                       || UNAPIRA.P_SEP ||
         'freq_val'                      || UNAPIRA.P_SEP ||
         'freq_unit'                     || UNAPIRA.P_SEP ||
         'invert_freq'                   || UNAPIRA.P_SEP ||
         'last_sched'                    || UNAPIRA.P_SEP ||
         'last_sched_tz'                 || UNAPIRA.P_SEP ||
         'last_cnt'                      || UNAPIRA.P_SEP ||
         'last_val'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utsthsdetails'                      || UNAPIRA.P_SEP ||
         'st'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utss'                               || UNAPIRA.P_SEP ||
         'ss'                            || UNAPIRA.P_SEP ||
         'name'                          || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'color'                         || UNAPIRA.P_SEP ||
         'shortcut'                      || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'ss_class'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utsswl'                             || UNAPIRA.P_SEP ||
         'ss'                            || UNAPIRA.P_SEP ||
         'entry_action'                  || UNAPIRA.P_SEP ||
         'gk_entry'                      || UNAPIRA.P_SEP ||
         'gk_version'                    || UNAPIRA.P_SEP ||
         'entry_tp'                      || UNAPIRA.P_SEP ||
         'use_value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utulpeers'                          || UNAPIRA.P_SEP ||
         'sid'                           || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'import_url'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utshortcut'                         || UNAPIRA.P_SEP ||
         'shortcut'                      || UNAPIRA.P_SEP ||
         'key_tp'                        || UNAPIRA.P_SEP ||
         'value_s'                       || UNAPIRA.P_SEP ||
         'value_f'                       || UNAPIRA.P_SEP ||
         'store_db'                      || UNAPIRA.P_SEP ||
         'run_mode'                      || UNAPIRA.P_SEP ||
         'service'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utdba'                              || UNAPIRA.P_SEP ||
         'setting_name'                  || UNAPIRA.P_SEP ||
         'setting_value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utsystem'                           || UNAPIRA.P_SEP ||
         'setting_name'                  || UNAPIRA.P_SEP ||
         'setting_value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utsystemcost'                       || UNAPIRA.P_SEP ||
         'setting_name'                  || UNAPIRA.P_SEP ||
         'setting_value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utsystemlist'                       || UNAPIRA.P_SEP ||
         'setting_name'                  || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'setting_value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utedtbl'                            || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'table_name'                    || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'where_clause'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utkeypp'                            || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'key_tp'                        || UNAPIRA.P_SEP ||
         'key_name'                      || UNAPIRA.P_SEP ||
         'description'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utsapunit'                          || UNAPIRA.P_SEP ||
         'sap_unit_code'                 || UNAPIRA.P_SEP ||
         'ul_uom'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utsapplant'                         || UNAPIRA.P_SEP ||
         'sap_plant_code'                || UNAPIRA.P_SEP ||
         'ul_plantname'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utsapoperation'                     || UNAPIRA.P_SEP ||
         'sap_operation_nr'              || UNAPIRA.P_SEP ||
         'ul_operation'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utsapmethod'                        || UNAPIRA.P_SEP ||
         'sap_method_code'               || UNAPIRA.P_SEP ||
         'ul_method'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utsaplocation'                      || UNAPIRA.P_SEP ||
         'sap_location_code'             || UNAPIRA.P_SEP ||
         'ul_location'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utsapcode'                          || UNAPIRA.P_SEP ||
         'sap_code_group'                || UNAPIRA.P_SEP ||
         'sap_code'                      || UNAPIRA.P_SEP ||
         'ul_description'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utsapcodegroup'                     || UNAPIRA.P_SEP ||
         'sap_code_group'                || UNAPIRA.P_SEP ||
         'ul_description'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utevrules'                          || UNAPIRA.P_SEP ||
         'rule_nr'                       || UNAPIRA.P_SEP ||
         'applic'                        || UNAPIRA.P_SEP ||
         'dbapi_name'                    || UNAPIRA.P_SEP ||
         'object_tp'                     || UNAPIRA.P_SEP ||
         'object_id'                     || UNAPIRA.P_SEP ||
         'object_lc'                     || UNAPIRA.P_SEP ||
         'object_lc_version'             || UNAPIRA.P_SEP ||
         'object_ss'                     || UNAPIRA.P_SEP ||
         'ev_tp'                         || UNAPIRA.P_SEP ||
         'condition'                     || UNAPIRA.P_SEP ||
         'af'                            || UNAPIRA.P_SEP ||
         'af_delay'                      || UNAPIRA.P_SEP ||
         'af_delay_unit'                 || UNAPIRA.P_SEP ||
         'custom'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utrt'                               || UNAPIRA.P_SEP ||
         'rt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'description2'                  || UNAPIRA.P_SEP ||
         'descr_doc'                     || UNAPIRA.P_SEP ||
         'descr_doc_version'             || UNAPIRA.P_SEP ||
         'is_template'                   || UNAPIRA.P_SEP ||
         'confirm_userid'                || UNAPIRA.P_SEP ||
         'nr_planned_rq'                 || UNAPIRA.P_SEP ||
         'freq_tp'                       || UNAPIRA.P_SEP ||
         'freq_val'                      || UNAPIRA.P_SEP ||
         'freq_unit'                     || UNAPIRA.P_SEP ||
         'invert_freq'                   || UNAPIRA.P_SEP ||
         'last_sched'                    || UNAPIRA.P_SEP ||
         'last_sched_tz'                 || UNAPIRA.P_SEP ||
         'last_cnt'                      || UNAPIRA.P_SEP ||
         'last_val'                      || UNAPIRA.P_SEP ||
         'priority'                      || UNAPIRA.P_SEP ||
         'label_format'                  || UNAPIRA.P_SEP ||
         'allow_any_st'                  || UNAPIRA.P_SEP ||
         'allow_new_sc'                  || UNAPIRA.P_SEP ||
         'add_stpp'                      || UNAPIRA.P_SEP ||
         'planned_responsible'           || UNAPIRA.P_SEP ||
         'sc_uc'                         || UNAPIRA.P_SEP ||
         'sc_uc_version'                 || UNAPIRA.P_SEP ||
         'rq_uc'                         || UNAPIRA.P_SEP ||
         'rq_uc_version'                 || UNAPIRA.P_SEP ||
         'rq_lc'                         || UNAPIRA.P_SEP ||
         'rq_lc_version'                 || UNAPIRA.P_SEP ||
         'inherit_au'                    || UNAPIRA.P_SEP ||
         'inherit_gk'                    || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'rt_class'                      || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'                            || UNAPIRA.P_SEP ||
         'ar1'                           || UNAPIRA.P_SEP ||
         'ar2'                           || UNAPIRA.P_SEP ||
         'ar3'                           || UNAPIRA.P_SEP ||
         'ar4'                           || UNAPIRA.P_SEP ||
         'ar5'                           || UNAPIRA.P_SEP ||
         'ar6'                           || UNAPIRA.P_SEP ||
         'ar7'                           || UNAPIRA.P_SEP ||
         'ar8'                           || UNAPIRA.P_SEP ||
         'ar9'                           || UNAPIRA.P_SEP ||
         'ar10'                          || UNAPIRA.P_SEP ||
         'ar11'                          || UNAPIRA.P_SEP ||
         'ar12'                          || UNAPIRA.P_SEP ||
         'ar13'                          || UNAPIRA.P_SEP ||
         'ar14'                          || UNAPIRA.P_SEP ||
         'ar15'                          || UNAPIRA.P_SEP ||
         'ar16'                          || UNAPIRA.P_SEP ||
         'ar17'                          || UNAPIRA.P_SEP ||
         'ar18'                          || UNAPIRA.P_SEP ||
         'ar19'                          || UNAPIRA.P_SEP ||
         'ar20'                          || UNAPIRA.P_SEP ||
         'ar21'                          || UNAPIRA.P_SEP ||
         'ar22'                          || UNAPIRA.P_SEP ||
         'ar23'                          || UNAPIRA.P_SEP ||
         'ar24'                          || UNAPIRA.P_SEP ||
         'ar25'                          || UNAPIRA.P_SEP ||
         'ar26'                          || UNAPIRA.P_SEP ||
         'ar27'                          || UNAPIRA.P_SEP ||
         'ar28'                          || UNAPIRA.P_SEP ||
         'ar29'                          || UNAPIRA.P_SEP ||
         'ar30'                          || UNAPIRA.P_SEP ||
         'ar31'                          || UNAPIRA.P_SEP ||
         'ar32'                          || UNAPIRA.P_SEP ||
         'ar33'                          || UNAPIRA.P_SEP ||
         'ar34'                          || UNAPIRA.P_SEP ||
         'ar35'                          || UNAPIRA.P_SEP ||
         'ar36'                          || UNAPIRA.P_SEP ||
         'ar37'                          || UNAPIRA.P_SEP ||
         'ar38'                          || UNAPIRA.P_SEP ||
         'ar39'                          || UNAPIRA.P_SEP ||
         'ar40'                          || UNAPIRA.P_SEP ||
         'ar41'                          || UNAPIRA.P_SEP ||
         'ar42'                          || UNAPIRA.P_SEP ||
         'ar43'                          || UNAPIRA.P_SEP ||
         'ar44'                          || UNAPIRA.P_SEP ||
         'ar45'                          || UNAPIRA.P_SEP ||
         'ar46'                          || UNAPIRA.P_SEP ||
         'ar47'                          || UNAPIRA.P_SEP ||
         'ar48'                          || UNAPIRA.P_SEP ||
         'ar49'                          || UNAPIRA.P_SEP ||
         'ar50'                          || UNAPIRA.P_SEP ||
         'ar51'                          || UNAPIRA.P_SEP ||
         'ar52'                          || UNAPIRA.P_SEP ||
         'ar53'                          || UNAPIRA.P_SEP ||
         'ar54'                          || UNAPIRA.P_SEP ||
         'ar55'                          || UNAPIRA.P_SEP ||
         'ar56'                          || UNAPIRA.P_SEP ||
         'ar57'                          || UNAPIRA.P_SEP ||
         'ar58'                          || UNAPIRA.P_SEP ||
         'ar59'                          || UNAPIRA.P_SEP ||
         'ar60'                          || UNAPIRA.P_SEP ||
         'ar61'                          || UNAPIRA.P_SEP ||
         'ar62'                          || UNAPIRA.P_SEP ||
         'ar63'                          || UNAPIRA.P_SEP ||
         'ar64'                          || UNAPIRA.P_SEP ||
         'ar65'                          || UNAPIRA.P_SEP ||
         'ar66'                          || UNAPIRA.P_SEP ||
         'ar67'                          || UNAPIRA.P_SEP ||
         'ar68'                          || UNAPIRA.P_SEP ||
         'ar69'                          || UNAPIRA.P_SEP ||
         'ar70'                          || UNAPIRA.P_SEP ||
         'ar71'                          || UNAPIRA.P_SEP ||
         'ar72'                          || UNAPIRA.P_SEP ||
         'ar73'                          || UNAPIRA.P_SEP ||
         'ar74'                          || UNAPIRA.P_SEP ||
         'ar75'                          || UNAPIRA.P_SEP ||
         'ar76'                          || UNAPIRA.P_SEP ||
         'ar77'                          || UNAPIRA.P_SEP ||
         'ar78'                          || UNAPIRA.P_SEP ||
         'ar79'                          || UNAPIRA.P_SEP ||
         'ar80'                          || UNAPIRA.P_SEP ||
         'ar81'                          || UNAPIRA.P_SEP ||
         'ar82'                          || UNAPIRA.P_SEP ||
         'ar83'                          || UNAPIRA.P_SEP ||
         'ar84'                          || UNAPIRA.P_SEP ||
         'ar85'                          || UNAPIRA.P_SEP ||
         'ar86'                          || UNAPIRA.P_SEP ||
         'ar87'                          || UNAPIRA.P_SEP ||
         'ar88'                          || UNAPIRA.P_SEP ||
         'ar89'                          || UNAPIRA.P_SEP ||
         'ar90'                          || UNAPIRA.P_SEP ||
         'ar91'                          || UNAPIRA.P_SEP ||
         'ar92'                          || UNAPIRA.P_SEP ||
         'ar93'                          || UNAPIRA.P_SEP ||
         'ar94'                          || UNAPIRA.P_SEP ||
         'ar95'                          || UNAPIRA.P_SEP ||
         'ar96'                          || UNAPIRA.P_SEP ||
         'ar97'                          || UNAPIRA.P_SEP ||
         'ar98'                          || UNAPIRA.P_SEP ||
         'ar99'                          || UNAPIRA.P_SEP ||
         'ar100'                         || UNAPIRA.P_SEP ||
         'ar101'                         || UNAPIRA.P_SEP ||
         'ar102'                         || UNAPIRA.P_SEP ||
         'ar103'                         || UNAPIRA.P_SEP ||
         'ar104'                         || UNAPIRA.P_SEP ||
         'ar105'                         || UNAPIRA.P_SEP ||
         'ar106'                         || UNAPIRA.P_SEP ||
         'ar107'                         || UNAPIRA.P_SEP ||
         'ar108'                         || UNAPIRA.P_SEP ||
         'ar109'                         || UNAPIRA.P_SEP ||
         'ar110'                         || UNAPIRA.P_SEP ||
         'ar111'                         || UNAPIRA.P_SEP ||
         'ar112'                         || UNAPIRA.P_SEP ||
         'ar113'                         || UNAPIRA.P_SEP ||
         'ar114'                         || UNAPIRA.P_SEP ||
         'ar115'                         || UNAPIRA.P_SEP ||
         'ar116'                         || UNAPIRA.P_SEP ||
         'ar117'                         || UNAPIRA.P_SEP ||
         'ar118'                         || UNAPIRA.P_SEP ||
         'ar119'                         || UNAPIRA.P_SEP ||
         'ar120'                         || UNAPIRA.P_SEP ||
         'ar121'                         || UNAPIRA.P_SEP ||
         'ar122'                         || UNAPIRA.P_SEP ||
         'ar123'                         || UNAPIRA.P_SEP ||
         'ar124'                         || UNAPIRA.P_SEP ||
         'ar125'                         || UNAPIRA.P_SEP ||
         'ar126'                         || UNAPIRA.P_SEP ||
         'ar127'                         || UNAPIRA.P_SEP ||
         'ar128'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utrtau'                             || UNAPIRA.P_SEP ||
         'rt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utrths'                             || UNAPIRA.P_SEP ||
         'rt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utrtip'                             || UNAPIRA.P_SEP ||
         'rt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'ip'                            || UNAPIRA.P_SEP ||
         'ip_version'                    || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'is_protected'                  || UNAPIRA.P_SEP ||
         'hidden'                        || UNAPIRA.P_SEP ||
         'freq_tp'                       || UNAPIRA.P_SEP ||
         'freq_val'                      || UNAPIRA.P_SEP ||
         'freq_unit'                     || UNAPIRA.P_SEP ||
         'invert_freq'                   || UNAPIRA.P_SEP ||
         'last_sched'                    || UNAPIRA.P_SEP ||
         'last_sched_tz'                 || UNAPIRA.P_SEP ||
         'last_cnt'                      || UNAPIRA.P_SEP ||
         'last_val'                      || UNAPIRA.P_SEP ||
         'inherit_au'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utrtpp'                             || UNAPIRA.P_SEP ||
         'rt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'pp'                            || UNAPIRA.P_SEP ||
         'pp_version'                    || UNAPIRA.P_SEP ||
         'pp_key1'                       || UNAPIRA.P_SEP ||
         'pp_key2'                       || UNAPIRA.P_SEP ||
         'pp_key3'                       || UNAPIRA.P_SEP ||
         'pp_key4'                       || UNAPIRA.P_SEP ||
         'pp_key5'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'delay'                         || UNAPIRA.P_SEP ||
         'delay_unit'                    || UNAPIRA.P_SEP ||
         'freq_tp'                       || UNAPIRA.P_SEP ||
         'freq_val'                      || UNAPIRA.P_SEP ||
         'freq_unit'                     || UNAPIRA.P_SEP ||
         'invert_freq'                   || UNAPIRA.P_SEP ||
         'last_sched'                    || UNAPIRA.P_SEP ||
         'last_sched_tz'                 || UNAPIRA.P_SEP ||
         'last_cnt'                      || UNAPIRA.P_SEP ||
         'last_val'                      || UNAPIRA.P_SEP ||
         'inherit_au'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utrtst'                             || UNAPIRA.P_SEP ||
         'rt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'st'                            || UNAPIRA.P_SEP ||
         'st_version'                    || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'nr_planned_sc'                 || UNAPIRA.P_SEP ||
         'delay'                         || UNAPIRA.P_SEP ||
         'delay_unit'                    || UNAPIRA.P_SEP ||
         'freq_tp'                       || UNAPIRA.P_SEP ||
         'freq_val'                      || UNAPIRA.P_SEP ||
         'freq_unit'                     || UNAPIRA.P_SEP ||
         'invert_freq'                   || UNAPIRA.P_SEP ||
         'last_sched'                    || UNAPIRA.P_SEP ||
         'last_sched_tz'                 || UNAPIRA.P_SEP ||
         'last_cnt'                      || UNAPIRA.P_SEP ||
         'last_val'                      || UNAPIRA.P_SEP ||
         'inherit_au'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utrtipau'                           || UNAPIRA.P_SEP ||
         'rt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'ip'                            || UNAPIRA.P_SEP ||
         'ip_version'                    || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utrtppau'                           || UNAPIRA.P_SEP ||
         'rt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'pp'                            || UNAPIRA.P_SEP ||
         'pp_version'                    || UNAPIRA.P_SEP ||
         'pp_key1'                       || UNAPIRA.P_SEP ||
         'pp_key2'                       || UNAPIRA.P_SEP ||
         'pp_key3'                       || UNAPIRA.P_SEP ||
         'pp_key4'                       || UNAPIRA.P_SEP ||
         'pp_key5'                       || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utrtstau'                           || UNAPIRA.P_SEP ||
         'rt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'st'                            || UNAPIRA.P_SEP ||
         'st_version'                    || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utrthsdetails'                      || UNAPIRA.P_SEP ||
         'rt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utvformat'                          || UNAPIRA.P_SEP ||
         'range_name'                    || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'range_min_boundary'            || UNAPIRA.P_SEP ||
         'range_min'                     || UNAPIRA.P_SEP ||
         'range_max'                     || UNAPIRA.P_SEP ||
         'range_max_boundary'            || UNAPIRA.P_SEP ||
         'format'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utqualification'                    || UNAPIRA.P_SEP ||
         'qualification'                 || UNAPIRA.P_SEP ||
         'description'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utpt'                               || UNAPIRA.P_SEP ||
         'pt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'description2'                  || UNAPIRA.P_SEP ||
         'descr_doc'                     || UNAPIRA.P_SEP ||
         'descr_doc_version'             || UNAPIRA.P_SEP ||
         'is_template'                   || UNAPIRA.P_SEP ||
         'confirm_userid'                || UNAPIRA.P_SEP ||
         'nr_planned_sd'                 || UNAPIRA.P_SEP ||
         'freq_tp'                       || UNAPIRA.P_SEP ||
         'freq_val'                      || UNAPIRA.P_SEP ||
         'freq_unit'                     || UNAPIRA.P_SEP ||
         'invert_freq'                   || UNAPIRA.P_SEP ||
         'last_sched'                    || UNAPIRA.P_SEP ||
         'last_sched_tz'                 || UNAPIRA.P_SEP ||
         'last_cnt'                      || UNAPIRA.P_SEP ||
         'last_val'                      || UNAPIRA.P_SEP ||
         'label_format'                  || UNAPIRA.P_SEP ||
         'planned_responsible'           || UNAPIRA.P_SEP ||
         'sd_uc'                         || UNAPIRA.P_SEP ||
         'sd_uc_version'                 || UNAPIRA.P_SEP ||
         'sd_lc'                         || UNAPIRA.P_SEP ||
         'sd_lc_version'                 || UNAPIRA.P_SEP ||
         'inherit_au'                    || UNAPIRA.P_SEP ||
         'inherit_gk'                    || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'pt_class'                      || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'                            || UNAPIRA.P_SEP ||
         'ar1'                           || UNAPIRA.P_SEP ||
         'ar2'                           || UNAPIRA.P_SEP ||
         'ar3'                           || UNAPIRA.P_SEP ||
         'ar4'                           || UNAPIRA.P_SEP ||
         'ar5'                           || UNAPIRA.P_SEP ||
         'ar6'                           || UNAPIRA.P_SEP ||
         'ar7'                           || UNAPIRA.P_SEP ||
         'ar8'                           || UNAPIRA.P_SEP ||
         'ar9'                           || UNAPIRA.P_SEP ||
         'ar10'                          || UNAPIRA.P_SEP ||
         'ar11'                          || UNAPIRA.P_SEP ||
         'ar12'                          || UNAPIRA.P_SEP ||
         'ar13'                          || UNAPIRA.P_SEP ||
         'ar14'                          || UNAPIRA.P_SEP ||
         'ar15'                          || UNAPIRA.P_SEP ||
         'ar16'                          || UNAPIRA.P_SEP ||
         'ar17'                          || UNAPIRA.P_SEP ||
         'ar18'                          || UNAPIRA.P_SEP ||
         'ar19'                          || UNAPIRA.P_SEP ||
         'ar20'                          || UNAPIRA.P_SEP ||
         'ar21'                          || UNAPIRA.P_SEP ||
         'ar22'                          || UNAPIRA.P_SEP ||
         'ar23'                          || UNAPIRA.P_SEP ||
         'ar24'                          || UNAPIRA.P_SEP ||
         'ar25'                          || UNAPIRA.P_SEP ||
         'ar26'                          || UNAPIRA.P_SEP ||
         'ar27'                          || UNAPIRA.P_SEP ||
         'ar28'                          || UNAPIRA.P_SEP ||
         'ar29'                          || UNAPIRA.P_SEP ||
         'ar30'                          || UNAPIRA.P_SEP ||
         'ar31'                          || UNAPIRA.P_SEP ||
         'ar32'                          || UNAPIRA.P_SEP ||
         'ar33'                          || UNAPIRA.P_SEP ||
         'ar34'                          || UNAPIRA.P_SEP ||
         'ar35'                          || UNAPIRA.P_SEP ||
         'ar36'                          || UNAPIRA.P_SEP ||
         'ar37'                          || UNAPIRA.P_SEP ||
         'ar38'                          || UNAPIRA.P_SEP ||
         'ar39'                          || UNAPIRA.P_SEP ||
         'ar40'                          || UNAPIRA.P_SEP ||
         'ar41'                          || UNAPIRA.P_SEP ||
         'ar42'                          || UNAPIRA.P_SEP ||
         'ar43'                          || UNAPIRA.P_SEP ||
         'ar44'                          || UNAPIRA.P_SEP ||
         'ar45'                          || UNAPIRA.P_SEP ||
         'ar46'                          || UNAPIRA.P_SEP ||
         'ar47'                          || UNAPIRA.P_SEP ||
         'ar48'                          || UNAPIRA.P_SEP ||
         'ar49'                          || UNAPIRA.P_SEP ||
         'ar50'                          || UNAPIRA.P_SEP ||
         'ar51'                          || UNAPIRA.P_SEP ||
         'ar52'                          || UNAPIRA.P_SEP ||
         'ar53'                          || UNAPIRA.P_SEP ||
         'ar54'                          || UNAPIRA.P_SEP ||
         'ar55'                          || UNAPIRA.P_SEP ||
         'ar56'                          || UNAPIRA.P_SEP ||
         'ar57'                          || UNAPIRA.P_SEP ||
         'ar58'                          || UNAPIRA.P_SEP ||
         'ar59'                          || UNAPIRA.P_SEP ||
         'ar60'                          || UNAPIRA.P_SEP ||
         'ar61'                          || UNAPIRA.P_SEP ||
         'ar62'                          || UNAPIRA.P_SEP ||
         'ar63'                          || UNAPIRA.P_SEP ||
         'ar64'                          || UNAPIRA.P_SEP ||
         'ar65'                          || UNAPIRA.P_SEP ||
         'ar66'                          || UNAPIRA.P_SEP ||
         'ar67'                          || UNAPIRA.P_SEP ||
         'ar68'                          || UNAPIRA.P_SEP ||
         'ar69'                          || UNAPIRA.P_SEP ||
         'ar70'                          || UNAPIRA.P_SEP ||
         'ar71'                          || UNAPIRA.P_SEP ||
         'ar72'                          || UNAPIRA.P_SEP ||
         'ar73'                          || UNAPIRA.P_SEP ||
         'ar74'                          || UNAPIRA.P_SEP ||
         'ar75'                          || UNAPIRA.P_SEP ||
         'ar76'                          || UNAPIRA.P_SEP ||
         'ar77'                          || UNAPIRA.P_SEP ||
         'ar78'                          || UNAPIRA.P_SEP ||
         'ar79'                          || UNAPIRA.P_SEP ||
         'ar80'                          || UNAPIRA.P_SEP ||
         'ar81'                          || UNAPIRA.P_SEP ||
         'ar82'                          || UNAPIRA.P_SEP ||
         'ar83'                          || UNAPIRA.P_SEP ||
         'ar84'                          || UNAPIRA.P_SEP ||
         'ar85'                          || UNAPIRA.P_SEP ||
         'ar86'                          || UNAPIRA.P_SEP ||
         'ar87'                          || UNAPIRA.P_SEP ||
         'ar88'                          || UNAPIRA.P_SEP ||
         'ar89'                          || UNAPIRA.P_SEP ||
         'ar90'                          || UNAPIRA.P_SEP ||
         'ar91'                          || UNAPIRA.P_SEP ||
         'ar92'                          || UNAPIRA.P_SEP ||
         'ar93'                          || UNAPIRA.P_SEP ||
         'ar94'                          || UNAPIRA.P_SEP ||
         'ar95'                          || UNAPIRA.P_SEP ||
         'ar96'                          || UNAPIRA.P_SEP ||
         'ar97'                          || UNAPIRA.P_SEP ||
         'ar98'                          || UNAPIRA.P_SEP ||
         'ar99'                          || UNAPIRA.P_SEP ||
         'ar100'                         || UNAPIRA.P_SEP ||
         'ar101'                         || UNAPIRA.P_SEP ||
         'ar102'                         || UNAPIRA.P_SEP ||
         'ar103'                         || UNAPIRA.P_SEP ||
         'ar104'                         || UNAPIRA.P_SEP ||
         'ar105'                         || UNAPIRA.P_SEP ||
         'ar106'                         || UNAPIRA.P_SEP ||
         'ar107'                         || UNAPIRA.P_SEP ||
         'ar108'                         || UNAPIRA.P_SEP ||
         'ar109'                         || UNAPIRA.P_SEP ||
         'ar110'                         || UNAPIRA.P_SEP ||
         'ar111'                         || UNAPIRA.P_SEP ||
         'ar112'                         || UNAPIRA.P_SEP ||
         'ar113'                         || UNAPIRA.P_SEP ||
         'ar114'                         || UNAPIRA.P_SEP ||
         'ar115'                         || UNAPIRA.P_SEP ||
         'ar116'                         || UNAPIRA.P_SEP ||
         'ar117'                         || UNAPIRA.P_SEP ||
         'ar118'                         || UNAPIRA.P_SEP ||
         'ar119'                         || UNAPIRA.P_SEP ||
         'ar120'                         || UNAPIRA.P_SEP ||
         'ar121'                         || UNAPIRA.P_SEP ||
         'ar122'                         || UNAPIRA.P_SEP ||
         'ar123'                         || UNAPIRA.P_SEP ||
         'ar124'                         || UNAPIRA.P_SEP ||
         'ar125'                         || UNAPIRA.P_SEP ||
         'ar126'                         || UNAPIRA.P_SEP ||
         'ar127'                         || UNAPIRA.P_SEP ||
         'ar128'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utptau'                             || UNAPIRA.P_SEP ||
         'pt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utptcs'                             || UNAPIRA.P_SEP ||
         'pt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'ptrow'                         || UNAPIRA.P_SEP ||
         'cs'                            || UNAPIRA.P_SEP ||
         'description'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utpths'                             || UNAPIRA.P_SEP ||
         'pt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utptip'                             || UNAPIRA.P_SEP ||
         'pt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'ip'                            || UNAPIRA.P_SEP ||
         'ip_version'                    || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'is_protected'                  || UNAPIRA.P_SEP ||
         'hidden'                        || UNAPIRA.P_SEP ||
         'freq_tp'                       || UNAPIRA.P_SEP ||
         'freq_val'                      || UNAPIRA.P_SEP ||
         'freq_unit'                     || UNAPIRA.P_SEP ||
         'invert_freq'                   || UNAPIRA.P_SEP ||
         'last_sched'                    || UNAPIRA.P_SEP ||
         'last_sched_tz'                 || UNAPIRA.P_SEP ||
         'last_cnt'                      || UNAPIRA.P_SEP ||
         'last_val'                      || UNAPIRA.P_SEP ||
         'inherit_au'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utpttp'                             || UNAPIRA.P_SEP ||
         'pt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'ptcolumn'                      || UNAPIRA.P_SEP ||
         'tp'                            || UNAPIRA.P_SEP ||
         'tp_unit'                       || UNAPIRA.P_SEP ||
         'allow_upfront'                 || UNAPIRA.P_SEP ||
         'allow_upfront_unit'            || UNAPIRA.P_SEP ||
         'allow_overdue'                 || UNAPIRA.P_SEP ||
         'allow_overdue_unit'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utptcscn'                           || UNAPIRA.P_SEP ||
         'pt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'ptrow'                         || UNAPIRA.P_SEP ||
         'cs'                            || UNAPIRA.P_SEP ||
         'cn'                            || UNAPIRA.P_SEP ||
         'cnseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utptipau'                           || UNAPIRA.P_SEP ||
         'pt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'ip'                            || UNAPIRA.P_SEP ||
         'ip_version'                    || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utptcellip'                         || UNAPIRA.P_SEP ||
         'pt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'ptrow'                         || UNAPIRA.P_SEP ||
         'ptcolumn'                      || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'ip'                            || UNAPIRA.P_SEP ||
         'ip_version'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utptcellpp'                         || UNAPIRA.P_SEP ||
         'pt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'ptrow'                         || UNAPIRA.P_SEP ||
         'ptcolumn'                      || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'pp'                            || UNAPIRA.P_SEP ||
         'pp_version'                    || UNAPIRA.P_SEP ||
         'pp_key1'                       || UNAPIRA.P_SEP ||
         'pp_key2'                       || UNAPIRA.P_SEP ||
         'pp_key3'                       || UNAPIRA.P_SEP ||
         'pp_key4'                       || UNAPIRA.P_SEP ||
         'pp_key5'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utptcellst'                         || UNAPIRA.P_SEP ||
         'pt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'ptrow'                         || UNAPIRA.P_SEP ||
         'ptcolumn'                      || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'st'                            || UNAPIRA.P_SEP ||
         'st_version'                    || UNAPIRA.P_SEP ||
         'nr_planned_sc'                 || UNAPIRA.P_SEP ||
         'sc_lc'                         || UNAPIRA.P_SEP ||
         'sc_lc_version'                 || UNAPIRA.P_SEP ||
         'sc_uc'                         || UNAPIRA.P_SEP ||
         'sc_uc_version'                 || UNAPIRA.P_SEP ||
         'add_stpp'                      || UNAPIRA.P_SEP ||
         'add_stip'                      || UNAPIRA.P_SEP ||
         'nr_sc_max'                     || UNAPIRA.P_SEP ||
         'inherit_au'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utptcellstau'                       || UNAPIRA.P_SEP ||
         'pt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'ptrow'                         || UNAPIRA.P_SEP ||
         'ptcolumn'                      || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'st'                            || UNAPIRA.P_SEP ||
         'st_version'                    || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utpthsdetails'                      || UNAPIRA.P_SEP ||
         'pt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utpref'                             || UNAPIRA.P_SEP ||
         'pref_tp'                       || UNAPIRA.P_SEP ||
         'pref_name'                     || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'pref_value'                    || UNAPIRA.P_SEP ||
         'applicable_obj'                || UNAPIRA.P_SEP ||
         'category'                      || UNAPIRA.P_SEP ||
         'description'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utpreflist'                         || UNAPIRA.P_SEP ||
         'pref_tp'                       || UNAPIRA.P_SEP ||
         'pref_name'                     || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'pref_value'                    || UNAPIRA.P_SEP ||
         'is_default'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utpr'                               || UNAPIRA.P_SEP ||
         'pr'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'description2'                  || UNAPIRA.P_SEP ||
         'unit'                          || UNAPIRA.P_SEP ||
         'format'                        || UNAPIRA.P_SEP ||
         'td_info'                       || UNAPIRA.P_SEP ||
         'td_info_unit'                  || UNAPIRA.P_SEP ||
         'confirm_uid'                   || UNAPIRA.P_SEP ||
         'def_val_tp'                    || UNAPIRA.P_SEP ||
         'def_au_level'                  || UNAPIRA.P_SEP ||
         'def_val'                       || UNAPIRA.P_SEP ||
         'allow_any_mt'                  || UNAPIRA.P_SEP ||
         'delay'                         || UNAPIRA.P_SEP ||
         'delay_unit'                    || UNAPIRA.P_SEP ||
         'min_nr_results'                || UNAPIRA.P_SEP ||
         'calc_method'                   || UNAPIRA.P_SEP ||
         'calc_cf'                       || UNAPIRA.P_SEP ||
         'alarm_order'                   || UNAPIRA.P_SEP ||
         'seta_specs'                    || UNAPIRA.P_SEP ||
         'seta_limits'                   || UNAPIRA.P_SEP ||
         'seta_target'                   || UNAPIRA.P_SEP ||
         'setb_specs'                    || UNAPIRA.P_SEP ||
         'setb_limits'                   || UNAPIRA.P_SEP ||
         'setb_target'                   || UNAPIRA.P_SEP ||
         'setc_specs'                    || UNAPIRA.P_SEP ||
         'setc_limits'                   || UNAPIRA.P_SEP ||
         'setc_target'                   || UNAPIRA.P_SEP ||
         'is_template'                   || UNAPIRA.P_SEP ||
         'log_exceptions'                || UNAPIRA.P_SEP ||
         'sc_lc'                         || UNAPIRA.P_SEP ||
         'sc_lc_version'                 || UNAPIRA.P_SEP ||
         'inherit_au'                    || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'pr_class'                      || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'                            || UNAPIRA.P_SEP ||
         'ar1'                           || UNAPIRA.P_SEP ||
         'ar2'                           || UNAPIRA.P_SEP ||
         'ar3'                           || UNAPIRA.P_SEP ||
         'ar4'                           || UNAPIRA.P_SEP ||
         'ar5'                           || UNAPIRA.P_SEP ||
         'ar6'                           || UNAPIRA.P_SEP ||
         'ar7'                           || UNAPIRA.P_SEP ||
         'ar8'                           || UNAPIRA.P_SEP ||
         'ar9'                           || UNAPIRA.P_SEP ||
         'ar10'                          || UNAPIRA.P_SEP ||
         'ar11'                          || UNAPIRA.P_SEP ||
         'ar12'                          || UNAPIRA.P_SEP ||
         'ar13'                          || UNAPIRA.P_SEP ||
         'ar14'                          || UNAPIRA.P_SEP ||
         'ar15'                          || UNAPIRA.P_SEP ||
         'ar16'                          || UNAPIRA.P_SEP ||
         'ar17'                          || UNAPIRA.P_SEP ||
         'ar18'                          || UNAPIRA.P_SEP ||
         'ar19'                          || UNAPIRA.P_SEP ||
         'ar20'                          || UNAPIRA.P_SEP ||
         'ar21'                          || UNAPIRA.P_SEP ||
         'ar22'                          || UNAPIRA.P_SEP ||
         'ar23'                          || UNAPIRA.P_SEP ||
         'ar24'                          || UNAPIRA.P_SEP ||
         'ar25'                          || UNAPIRA.P_SEP ||
         'ar26'                          || UNAPIRA.P_SEP ||
         'ar27'                          || UNAPIRA.P_SEP ||
         'ar28'                          || UNAPIRA.P_SEP ||
         'ar29'                          || UNAPIRA.P_SEP ||
         'ar30'                          || UNAPIRA.P_SEP ||
         'ar31'                          || UNAPIRA.P_SEP ||
         'ar32'                          || UNAPIRA.P_SEP ||
         'ar33'                          || UNAPIRA.P_SEP ||
         'ar34'                          || UNAPIRA.P_SEP ||
         'ar35'                          || UNAPIRA.P_SEP ||
         'ar36'                          || UNAPIRA.P_SEP ||
         'ar37'                          || UNAPIRA.P_SEP ||
         'ar38'                          || UNAPIRA.P_SEP ||
         'ar39'                          || UNAPIRA.P_SEP ||
         'ar40'                          || UNAPIRA.P_SEP ||
         'ar41'                          || UNAPIRA.P_SEP ||
         'ar42'                          || UNAPIRA.P_SEP ||
         'ar43'                          || UNAPIRA.P_SEP ||
         'ar44'                          || UNAPIRA.P_SEP ||
         'ar45'                          || UNAPIRA.P_SEP ||
         'ar46'                          || UNAPIRA.P_SEP ||
         'ar47'                          || UNAPIRA.P_SEP ||
         'ar48'                          || UNAPIRA.P_SEP ||
         'ar49'                          || UNAPIRA.P_SEP ||
         'ar50'                          || UNAPIRA.P_SEP ||
         'ar51'                          || UNAPIRA.P_SEP ||
         'ar52'                          || UNAPIRA.P_SEP ||
         'ar53'                          || UNAPIRA.P_SEP ||
         'ar54'                          || UNAPIRA.P_SEP ||
         'ar55'                          || UNAPIRA.P_SEP ||
         'ar56'                          || UNAPIRA.P_SEP ||
         'ar57'                          || UNAPIRA.P_SEP ||
         'ar58'                          || UNAPIRA.P_SEP ||
         'ar59'                          || UNAPIRA.P_SEP ||
         'ar60'                          || UNAPIRA.P_SEP ||
         'ar61'                          || UNAPIRA.P_SEP ||
         'ar62'                          || UNAPIRA.P_SEP ||
         'ar63'                          || UNAPIRA.P_SEP ||
         'ar64'                          || UNAPIRA.P_SEP ||
         'ar65'                          || UNAPIRA.P_SEP ||
         'ar66'                          || UNAPIRA.P_SEP ||
         'ar67'                          || UNAPIRA.P_SEP ||
         'ar68'                          || UNAPIRA.P_SEP ||
         'ar69'                          || UNAPIRA.P_SEP ||
         'ar70'                          || UNAPIRA.P_SEP ||
         'ar71'                          || UNAPIRA.P_SEP ||
         'ar72'                          || UNAPIRA.P_SEP ||
         'ar73'                          || UNAPIRA.P_SEP ||
         'ar74'                          || UNAPIRA.P_SEP ||
         'ar75'                          || UNAPIRA.P_SEP ||
         'ar76'                          || UNAPIRA.P_SEP ||
         'ar77'                          || UNAPIRA.P_SEP ||
         'ar78'                          || UNAPIRA.P_SEP ||
         'ar79'                          || UNAPIRA.P_SEP ||
         'ar80'                          || UNAPIRA.P_SEP ||
         'ar81'                          || UNAPIRA.P_SEP ||
         'ar82'                          || UNAPIRA.P_SEP ||
         'ar83'                          || UNAPIRA.P_SEP ||
         'ar84'                          || UNAPIRA.P_SEP ||
         'ar85'                          || UNAPIRA.P_SEP ||
         'ar86'                          || UNAPIRA.P_SEP ||
         'ar87'                          || UNAPIRA.P_SEP ||
         'ar88'                          || UNAPIRA.P_SEP ||
         'ar89'                          || UNAPIRA.P_SEP ||
         'ar90'                          || UNAPIRA.P_SEP ||
         'ar91'                          || UNAPIRA.P_SEP ||
         'ar92'                          || UNAPIRA.P_SEP ||
         'ar93'                          || UNAPIRA.P_SEP ||
         'ar94'                          || UNAPIRA.P_SEP ||
         'ar95'                          || UNAPIRA.P_SEP ||
         'ar96'                          || UNAPIRA.P_SEP ||
         'ar97'                          || UNAPIRA.P_SEP ||
         'ar98'                          || UNAPIRA.P_SEP ||
         'ar99'                          || UNAPIRA.P_SEP ||
         'ar100'                         || UNAPIRA.P_SEP ||
         'ar101'                         || UNAPIRA.P_SEP ||
         'ar102'                         || UNAPIRA.P_SEP ||
         'ar103'                         || UNAPIRA.P_SEP ||
         'ar104'                         || UNAPIRA.P_SEP ||
         'ar105'                         || UNAPIRA.P_SEP ||
         'ar106'                         || UNAPIRA.P_SEP ||
         'ar107'                         || UNAPIRA.P_SEP ||
         'ar108'                         || UNAPIRA.P_SEP ||
         'ar109'                         || UNAPIRA.P_SEP ||
         'ar110'                         || UNAPIRA.P_SEP ||
         'ar111'                         || UNAPIRA.P_SEP ||
         'ar112'                         || UNAPIRA.P_SEP ||
         'ar113'                         || UNAPIRA.P_SEP ||
         'ar114'                         || UNAPIRA.P_SEP ||
         'ar115'                         || UNAPIRA.P_SEP ||
         'ar116'                         || UNAPIRA.P_SEP ||
         'ar117'                         || UNAPIRA.P_SEP ||
         'ar118'                         || UNAPIRA.P_SEP ||
         'ar119'                         || UNAPIRA.P_SEP ||
         'ar120'                         || UNAPIRA.P_SEP ||
         'ar121'                         || UNAPIRA.P_SEP ||
         'ar122'                         || UNAPIRA.P_SEP ||
         'ar123'                         || UNAPIRA.P_SEP ||
         'ar124'                         || UNAPIRA.P_SEP ||
         'ar125'                         || UNAPIRA.P_SEP ||
         'ar126'                         || UNAPIRA.P_SEP ||
         'ar127'                         || UNAPIRA.P_SEP ||
         'ar128'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utprau'                             || UNAPIRA.P_SEP ||
         'pr'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utprhs'                             || UNAPIRA.P_SEP ||
         'pr'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utprmt'                             || UNAPIRA.P_SEP ||
         'pr'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'mt'                            || UNAPIRA.P_SEP ||
         'mt_version'                    || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'nr_measur'                     || UNAPIRA.P_SEP ||
         'unit'                          || UNAPIRA.P_SEP ||
         'format'                        || UNAPIRA.P_SEP ||
         'allow_add'                     || UNAPIRA.P_SEP ||
         'ignore_other'                  || UNAPIRA.P_SEP ||
         'accuracy'                      || UNAPIRA.P_SEP ||
         'freq_tp'                       || UNAPIRA.P_SEP ||
         'freq_val'                      || UNAPIRA.P_SEP ||
         'freq_unit'                     || UNAPIRA.P_SEP ||
         'invert_freq'                   || UNAPIRA.P_SEP ||
         'st_based_freq'                 || UNAPIRA.P_SEP ||
         'last_sched'                    || UNAPIRA.P_SEP ||
         'last_sched_tz'                 || UNAPIRA.P_SEP ||
         'last_cnt'                      || UNAPIRA.P_SEP ||
         'last_val'                      || UNAPIRA.P_SEP ||
         'inherit_au'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utprcyst'                           || UNAPIRA.P_SEP ||
         'pr'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'cy'                            || UNAPIRA.P_SEP ||
         'cy_version'                    || UNAPIRA.P_SEP ||
         'st'                            || UNAPIRA.P_SEP ||
         'st_version'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utprmtau'                           || UNAPIRA.P_SEP ||
         'pr'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'mt'                            || UNAPIRA.P_SEP ||
         'mt_version'                    || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utprhsdetails'                      || UNAPIRA.P_SEP ||
         'pr'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utpp'                               || UNAPIRA.P_SEP ||
         'pp'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'pp_key1'                       || UNAPIRA.P_SEP ||
         'pp_key2'                       || UNAPIRA.P_SEP ||
         'pp_key3'                       || UNAPIRA.P_SEP ||
         'pp_key4'                       || UNAPIRA.P_SEP ||
         'pp_key5'                       || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'description2'                  || UNAPIRA.P_SEP ||
         'unit'                          || UNAPIRA.P_SEP ||
         'format'                        || UNAPIRA.P_SEP ||
         'confirm_assign'                || UNAPIRA.P_SEP ||
         'allow_any_pr'                  || UNAPIRA.P_SEP ||
         'never_create_methods'          || UNAPIRA.P_SEP ||
         'delay'                         || UNAPIRA.P_SEP ||
         'delay_unit'                    || UNAPIRA.P_SEP ||
         'is_template'                   || UNAPIRA.P_SEP ||
         'sc_lc'                         || UNAPIRA.P_SEP ||
         'sc_lc_version'                 || UNAPIRA.P_SEP ||
         'inherit_au'                    || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'pp_class'                      || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'                            || UNAPIRA.P_SEP ||
         'ar1'                           || UNAPIRA.P_SEP ||
         'ar2'                           || UNAPIRA.P_SEP ||
         'ar3'                           || UNAPIRA.P_SEP ||
         'ar4'                           || UNAPIRA.P_SEP ||
         'ar5'                           || UNAPIRA.P_SEP ||
         'ar6'                           || UNAPIRA.P_SEP ||
         'ar7'                           || UNAPIRA.P_SEP ||
         'ar8'                           || UNAPIRA.P_SEP ||
         'ar9'                           || UNAPIRA.P_SEP ||
         'ar10'                          || UNAPIRA.P_SEP ||
         'ar11'                          || UNAPIRA.P_SEP ||
         'ar12'                          || UNAPIRA.P_SEP ||
         'ar13'                          || UNAPIRA.P_SEP ||
         'ar14'                          || UNAPIRA.P_SEP ||
         'ar15'                          || UNAPIRA.P_SEP ||
         'ar16'                          || UNAPIRA.P_SEP ||
         'ar17'                          || UNAPIRA.P_SEP ||
         'ar18'                          || UNAPIRA.P_SEP ||
         'ar19'                          || UNAPIRA.P_SEP ||
         'ar20'                          || UNAPIRA.P_SEP ||
         'ar21'                          || UNAPIRA.P_SEP ||
         'ar22'                          || UNAPIRA.P_SEP ||
         'ar23'                          || UNAPIRA.P_SEP ||
         'ar24'                          || UNAPIRA.P_SEP ||
         'ar25'                          || UNAPIRA.P_SEP ||
         'ar26'                          || UNAPIRA.P_SEP ||
         'ar27'                          || UNAPIRA.P_SEP ||
         'ar28'                          || UNAPIRA.P_SEP ||
         'ar29'                          || UNAPIRA.P_SEP ||
         'ar30'                          || UNAPIRA.P_SEP ||
         'ar31'                          || UNAPIRA.P_SEP ||
         'ar32'                          || UNAPIRA.P_SEP ||
         'ar33'                          || UNAPIRA.P_SEP ||
         'ar34'                          || UNAPIRA.P_SEP ||
         'ar35'                          || UNAPIRA.P_SEP ||
         'ar36'                          || UNAPIRA.P_SEP ||
         'ar37'                          || UNAPIRA.P_SEP ||
         'ar38'                          || UNAPIRA.P_SEP ||
         'ar39'                          || UNAPIRA.P_SEP ||
         'ar40'                          || UNAPIRA.P_SEP ||
         'ar41'                          || UNAPIRA.P_SEP ||
         'ar42'                          || UNAPIRA.P_SEP ||
         'ar43'                          || UNAPIRA.P_SEP ||
         'ar44'                          || UNAPIRA.P_SEP ||
         'ar45'                          || UNAPIRA.P_SEP ||
         'ar46'                          || UNAPIRA.P_SEP ||
         'ar47'                          || UNAPIRA.P_SEP ||
         'ar48'                          || UNAPIRA.P_SEP ||
         'ar49'                          || UNAPIRA.P_SEP ||
         'ar50'                          || UNAPIRA.P_SEP ||
         'ar51'                          || UNAPIRA.P_SEP ||
         'ar52'                          || UNAPIRA.P_SEP ||
         'ar53'                          || UNAPIRA.P_SEP ||
         'ar54'                          || UNAPIRA.P_SEP ||
         'ar55'                          || UNAPIRA.P_SEP ||
         'ar56'                          || UNAPIRA.P_SEP ||
         'ar57'                          || UNAPIRA.P_SEP ||
         'ar58'                          || UNAPIRA.P_SEP ||
         'ar59'                          || UNAPIRA.P_SEP ||
         'ar60'                          || UNAPIRA.P_SEP ||
         'ar61'                          || UNAPIRA.P_SEP ||
         'ar62'                          || UNAPIRA.P_SEP ||
         'ar63'                          || UNAPIRA.P_SEP ||
         'ar64'                          || UNAPIRA.P_SEP ||
         'ar65'                          || UNAPIRA.P_SEP ||
         'ar66'                          || UNAPIRA.P_SEP ||
         'ar67'                          || UNAPIRA.P_SEP ||
         'ar68'                          || UNAPIRA.P_SEP ||
         'ar69'                          || UNAPIRA.P_SEP ||
         'ar70'                          || UNAPIRA.P_SEP ||
         'ar71'                          || UNAPIRA.P_SEP ||
         'ar72'                          || UNAPIRA.P_SEP ||
         'ar73'                          || UNAPIRA.P_SEP ||
         'ar74'                          || UNAPIRA.P_SEP ||
         'ar75'                          || UNAPIRA.P_SEP ||
         'ar76'                          || UNAPIRA.P_SEP ||
         'ar77'                          || UNAPIRA.P_SEP ||
         'ar78'                          || UNAPIRA.P_SEP ||
         'ar79'                          || UNAPIRA.P_SEP ||
         'ar80'                          || UNAPIRA.P_SEP ||
         'ar81'                          || UNAPIRA.P_SEP ||
         'ar82'                          || UNAPIRA.P_SEP ||
         'ar83'                          || UNAPIRA.P_SEP ||
         'ar84'                          || UNAPIRA.P_SEP ||
         'ar85'                          || UNAPIRA.P_SEP ||
         'ar86'                          || UNAPIRA.P_SEP ||
         'ar87'                          || UNAPIRA.P_SEP ||
         'ar88'                          || UNAPIRA.P_SEP ||
         'ar89'                          || UNAPIRA.P_SEP ||
         'ar90'                          || UNAPIRA.P_SEP ||
         'ar91'                          || UNAPIRA.P_SEP ||
         'ar92'                          || UNAPIRA.P_SEP ||
         'ar93'                          || UNAPIRA.P_SEP ||
         'ar94'                          || UNAPIRA.P_SEP ||
         'ar95'                          || UNAPIRA.P_SEP ||
         'ar96'                          || UNAPIRA.P_SEP ||
         'ar97'                          || UNAPIRA.P_SEP ||
         'ar98'                          || UNAPIRA.P_SEP ||
         'ar99'                          || UNAPIRA.P_SEP ||
         'ar100'                         || UNAPIRA.P_SEP ||
         'ar101'                         || UNAPIRA.P_SEP ||
         'ar102'                         || UNAPIRA.P_SEP ||
         'ar103'                         || UNAPIRA.P_SEP ||
         'ar104'                         || UNAPIRA.P_SEP ||
         'ar105'                         || UNAPIRA.P_SEP ||
         'ar106'                         || UNAPIRA.P_SEP ||
         'ar107'                         || UNAPIRA.P_SEP ||
         'ar108'                         || UNAPIRA.P_SEP ||
         'ar109'                         || UNAPIRA.P_SEP ||
         'ar110'                         || UNAPIRA.P_SEP ||
         'ar111'                         || UNAPIRA.P_SEP ||
         'ar112'                         || UNAPIRA.P_SEP ||
         'ar113'                         || UNAPIRA.P_SEP ||
         'ar114'                         || UNAPIRA.P_SEP ||
         'ar115'                         || UNAPIRA.P_SEP ||
         'ar116'                         || UNAPIRA.P_SEP ||
         'ar117'                         || UNAPIRA.P_SEP ||
         'ar118'                         || UNAPIRA.P_SEP ||
         'ar119'                         || UNAPIRA.P_SEP ||
         'ar120'                         || UNAPIRA.P_SEP ||
         'ar121'                         || UNAPIRA.P_SEP ||
         'ar122'                         || UNAPIRA.P_SEP ||
         'ar123'                         || UNAPIRA.P_SEP ||
         'ar124'                         || UNAPIRA.P_SEP ||
         'ar125'                         || UNAPIRA.P_SEP ||
         'ar126'                         || UNAPIRA.P_SEP ||
         'ar127'                         || UNAPIRA.P_SEP ||
         'ar128'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utppau'                             || UNAPIRA.P_SEP ||
         'pp'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'pp_key1'                       || UNAPIRA.P_SEP ||
         'pp_key2'                       || UNAPIRA.P_SEP ||
         'pp_key3'                       || UNAPIRA.P_SEP ||
         'pp_key4'                       || UNAPIRA.P_SEP ||
         'pp_key5'                       || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utpphs'                             || UNAPIRA.P_SEP ||
         'pp'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'pp_key1'                       || UNAPIRA.P_SEP ||
         'pp_key2'                       || UNAPIRA.P_SEP ||
         'pp_key3'                       || UNAPIRA.P_SEP ||
         'pp_key4'                       || UNAPIRA.P_SEP ||
         'pp_key5'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utpppr'                             || UNAPIRA.P_SEP ||
         'pp'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'pp_key1'                       || UNAPIRA.P_SEP ||
         'pp_key2'                       || UNAPIRA.P_SEP ||
         'pp_key3'                       || UNAPIRA.P_SEP ||
         'pp_key4'                       || UNAPIRA.P_SEP ||
         'pp_key5'                       || UNAPIRA.P_SEP ||
         'pr'                            || UNAPIRA.P_SEP ||
         'pr_version'                    || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'nr_measur'                     || UNAPIRA.P_SEP ||
         'unit'                          || UNAPIRA.P_SEP ||
         'format'                        || UNAPIRA.P_SEP ||
         'delay'                         || UNAPIRA.P_SEP ||
         'delay_unit'                    || UNAPIRA.P_SEP ||
         'allow_add'                     || UNAPIRA.P_SEP ||
         'is_pp'                         || UNAPIRA.P_SEP ||
         'freq_tp'                       || UNAPIRA.P_SEP ||
         'freq_val'                      || UNAPIRA.P_SEP ||
         'freq_unit'                     || UNAPIRA.P_SEP ||
         'invert_freq'                   || UNAPIRA.P_SEP ||
         'st_based_freq'                 || UNAPIRA.P_SEP ||
         'last_sched'                    || UNAPIRA.P_SEP ||
         'last_sched_tz'                 || UNAPIRA.P_SEP ||
         'last_cnt'                      || UNAPIRA.P_SEP ||
         'last_val'                      || UNAPIRA.P_SEP ||
         'inherit_au'                    || UNAPIRA.P_SEP ||
         'mt'                            || UNAPIRA.P_SEP ||
         'mt_version'                    || UNAPIRA.P_SEP ||
         'mt_nr_measur'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utppspa'                            || UNAPIRA.P_SEP ||
         'pp'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'pp_key1'                       || UNAPIRA.P_SEP ||
         'pp_key2'                       || UNAPIRA.P_SEP ||
         'pp_key3'                       || UNAPIRA.P_SEP ||
         'pp_key4'                       || UNAPIRA.P_SEP ||
         'pp_key5'                       || UNAPIRA.P_SEP ||
         'pr'                            || UNAPIRA.P_SEP ||
         'pr_version'                    || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'low_limit'                     || UNAPIRA.P_SEP ||
         'high_limit'                    || UNAPIRA.P_SEP ||
         'low_spec'                      || UNAPIRA.P_SEP ||
         'high_spec'                     || UNAPIRA.P_SEP ||
         'low_dev'                       || UNAPIRA.P_SEP ||
         'rel_low_dev'                   || UNAPIRA.P_SEP ||
         'target'                        || UNAPIRA.P_SEP ||
         'high_dev'                      || UNAPIRA.P_SEP ||
         'rel_high_dev'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utppspb'                            || UNAPIRA.P_SEP ||
         'pp'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'pp_key1'                       || UNAPIRA.P_SEP ||
         'pp_key2'                       || UNAPIRA.P_SEP ||
         'pp_key3'                       || UNAPIRA.P_SEP ||
         'pp_key4'                       || UNAPIRA.P_SEP ||
         'pp_key5'                       || UNAPIRA.P_SEP ||
         'pr'                            || UNAPIRA.P_SEP ||
         'pr_version'                    || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'low_limit'                     || UNAPIRA.P_SEP ||
         'high_limit'                    || UNAPIRA.P_SEP ||
         'low_spec'                      || UNAPIRA.P_SEP ||
         'high_spec'                     || UNAPIRA.P_SEP ||
         'low_dev'                       || UNAPIRA.P_SEP ||
         'rel_low_dev'                   || UNAPIRA.P_SEP ||
         'target'                        || UNAPIRA.P_SEP ||
         'high_dev'                      || UNAPIRA.P_SEP ||
         'rel_high_dev'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utppspc'                            || UNAPIRA.P_SEP ||
         'pp'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'pp_key1'                       || UNAPIRA.P_SEP ||
         'pp_key2'                       || UNAPIRA.P_SEP ||
         'pp_key3'                       || UNAPIRA.P_SEP ||
         'pp_key4'                       || UNAPIRA.P_SEP ||
         'pp_key5'                       || UNAPIRA.P_SEP ||
         'pr'                            || UNAPIRA.P_SEP ||
         'pr_version'                    || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'low_limit'                     || UNAPIRA.P_SEP ||
         'high_limit'                    || UNAPIRA.P_SEP ||
         'low_spec'                      || UNAPIRA.P_SEP ||
         'high_spec'                     || UNAPIRA.P_SEP ||
         'low_dev'                       || UNAPIRA.P_SEP ||
         'rel_low_dev'                   || UNAPIRA.P_SEP ||
         'target'                        || UNAPIRA.P_SEP ||
         'high_dev'                      || UNAPIRA.P_SEP ||
         'rel_high_dev'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utppprau'                           || UNAPIRA.P_SEP ||
         'pp'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'pp_key1'                       || UNAPIRA.P_SEP ||
         'pp_key2'                       || UNAPIRA.P_SEP ||
         'pp_key3'                       || UNAPIRA.P_SEP ||
         'pp_key4'                       || UNAPIRA.P_SEP ||
         'pp_key5'                       || UNAPIRA.P_SEP ||
         'pr'                            || UNAPIRA.P_SEP ||
         'pr_version'                    || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utpphsdetails'                      || UNAPIRA.P_SEP ||
         'pp'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'pp_key1'                       || UNAPIRA.P_SEP ||
         'pp_key2'                       || UNAPIRA.P_SEP ||
         'pp_key3'                       || UNAPIRA.P_SEP ||
         'pp_key4'                       || UNAPIRA.P_SEP ||
         'pp_key5'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utxslt'                             || UNAPIRA.P_SEP ||
         'obj_id'                        || UNAPIRA.P_SEP ||
         'usage_type'                    || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'line'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utlongtext'                         || UNAPIRA.P_SEP ||
         'obj_id'                        || UNAPIRA.P_SEP ||
         'obj_tp'                        || UNAPIRA.P_SEP ||
         'obj_version'                   || UNAPIRA.P_SEP ||
         'doc_id'                        || UNAPIRA.P_SEP ||
         'doc_tp'                        || UNAPIRA.P_SEP ||
         'doc_name'                      || UNAPIRA.P_SEP ||
         'line_nbr'                      || UNAPIRA.P_SEP ||
         'text_line'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utucobjectcounter'                  || UNAPIRA.P_SEP ||
         'object_tp'                     || UNAPIRA.P_SEP ||
         'object_id'                     || UNAPIRA.P_SEP ||
         'object_counter'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utassignfulltestplan'               || UNAPIRA.P_SEP ||
         'object_tp'                     || UNAPIRA.P_SEP ||
         'object_id'                     || UNAPIRA.P_SEP ||
         'object_version'                || UNAPIRA.P_SEP ||
         'tst_tp'                        || UNAPIRA.P_SEP ||
         'tst_id'                        || UNAPIRA.P_SEP ||
         'tst_id_version'                || UNAPIRA.P_SEP ||
         'tst_description'               || UNAPIRA.P_SEP ||
         'tst_nr_measur'                 || UNAPIRA.P_SEP ||
         'pp'                            || UNAPIRA.P_SEP ||
         'pp_version'                    || UNAPIRA.P_SEP ||
         'pp_key1'                       || UNAPIRA.P_SEP ||
         'pp_key2'                       || UNAPIRA.P_SEP ||
         'pp_key3'                       || UNAPIRA.P_SEP ||
         'pp_key4'                       || UNAPIRA.P_SEP ||
         'pp_key5'                       || UNAPIRA.P_SEP ||
         'pp_seq'                        || UNAPIRA.P_SEP ||
         'pr'                            || UNAPIRA.P_SEP ||
         'pr_version'                    || UNAPIRA.P_SEP ||
         'pr_seq'                        || UNAPIRA.P_SEP ||
         'mt'                            || UNAPIRA.P_SEP ||
         'mt_version'                    || UNAPIRA.P_SEP ||
         'mt_seq'                        || UNAPIRA.P_SEP ||
         'confirm_assign'                || UNAPIRA.P_SEP ||
         'is_pp_in_pp'                   || UNAPIRA.P_SEP ||
         'already_assigned'              || UNAPIRA.P_SEP ||
         'never_create_methods'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utobjects'                          || UNAPIRA.P_SEP ||
         'object'                        || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'def_lc'                        || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'ar'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utmt'                               || UNAPIRA.P_SEP ||
         'mt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'description2'                  || UNAPIRA.P_SEP ||
         'unit'                          || UNAPIRA.P_SEP ||
         'est_cost'                      || UNAPIRA.P_SEP ||
         'est_time'                      || UNAPIRA.P_SEP ||
         'accuracy'                      || UNAPIRA.P_SEP ||
         'is_template'                   || UNAPIRA.P_SEP ||
         'calibration'                   || UNAPIRA.P_SEP ||
         'autorecalc'                    || UNAPIRA.P_SEP ||
         'confirm_complete'              || UNAPIRA.P_SEP ||
         'auto_create_cells'             || UNAPIRA.P_SEP ||
         'me_result_editable'            || UNAPIRA.P_SEP ||
         'executor'                      || UNAPIRA.P_SEP ||
         'eq_tp'                         || UNAPIRA.P_SEP ||
         'sop'                           || UNAPIRA.P_SEP ||
         'sop_version'                   || UNAPIRA.P_SEP ||
         'plaus_low'                     || UNAPIRA.P_SEP ||
         'plaus_high'                    || UNAPIRA.P_SEP ||
         'winsize_x'                     || UNAPIRA.P_SEP ||
         'winsize_y'                     || UNAPIRA.P_SEP ||
         'sc_lc'                         || UNAPIRA.P_SEP ||
         'sc_lc_version'                 || UNAPIRA.P_SEP ||
         'def_val_tp'                    || UNAPIRA.P_SEP ||
         'def_au_level'                  || UNAPIRA.P_SEP ||
         'def_val'                       || UNAPIRA.P_SEP ||
         'format'                        || UNAPIRA.P_SEP ||
         'inherit_au'                    || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'mt_class'                      || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'                            || UNAPIRA.P_SEP ||
         'ar1'                           || UNAPIRA.P_SEP ||
         'ar2'                           || UNAPIRA.P_SEP ||
         'ar3'                           || UNAPIRA.P_SEP ||
         'ar4'                           || UNAPIRA.P_SEP ||
         'ar5'                           || UNAPIRA.P_SEP ||
         'ar6'                           || UNAPIRA.P_SEP ||
         'ar7'                           || UNAPIRA.P_SEP ||
         'ar8'                           || UNAPIRA.P_SEP ||
         'ar9'                           || UNAPIRA.P_SEP ||
         'ar10'                          || UNAPIRA.P_SEP ||
         'ar11'                          || UNAPIRA.P_SEP ||
         'ar12'                          || UNAPIRA.P_SEP ||
         'ar13'                          || UNAPIRA.P_SEP ||
         'ar14'                          || UNAPIRA.P_SEP ||
         'ar15'                          || UNAPIRA.P_SEP ||
         'ar16'                          || UNAPIRA.P_SEP ||
         'ar17'                          || UNAPIRA.P_SEP ||
         'ar18'                          || UNAPIRA.P_SEP ||
         'ar19'                          || UNAPIRA.P_SEP ||
         'ar20'                          || UNAPIRA.P_SEP ||
         'ar21'                          || UNAPIRA.P_SEP ||
         'ar22'                          || UNAPIRA.P_SEP ||
         'ar23'                          || UNAPIRA.P_SEP ||
         'ar24'                          || UNAPIRA.P_SEP ||
         'ar25'                          || UNAPIRA.P_SEP ||
         'ar26'                          || UNAPIRA.P_SEP ||
         'ar27'                          || UNAPIRA.P_SEP ||
         'ar28'                          || UNAPIRA.P_SEP ||
         'ar29'                          || UNAPIRA.P_SEP ||
         'ar30'                          || UNAPIRA.P_SEP ||
         'ar31'                          || UNAPIRA.P_SEP ||
         'ar32'                          || UNAPIRA.P_SEP ||
         'ar33'                          || UNAPIRA.P_SEP ||
         'ar34'                          || UNAPIRA.P_SEP ||
         'ar35'                          || UNAPIRA.P_SEP ||
         'ar36'                          || UNAPIRA.P_SEP ||
         'ar37'                          || UNAPIRA.P_SEP ||
         'ar38'                          || UNAPIRA.P_SEP ||
         'ar39'                          || UNAPIRA.P_SEP ||
         'ar40'                          || UNAPIRA.P_SEP ||
         'ar41'                          || UNAPIRA.P_SEP ||
         'ar42'                          || UNAPIRA.P_SEP ||
         'ar43'                          || UNAPIRA.P_SEP ||
         'ar44'                          || UNAPIRA.P_SEP ||
         'ar45'                          || UNAPIRA.P_SEP ||
         'ar46'                          || UNAPIRA.P_SEP ||
         'ar47'                          || UNAPIRA.P_SEP ||
         'ar48'                          || UNAPIRA.P_SEP ||
         'ar49'                          || UNAPIRA.P_SEP ||
         'ar50'                          || UNAPIRA.P_SEP ||
         'ar51'                          || UNAPIRA.P_SEP ||
         'ar52'                          || UNAPIRA.P_SEP ||
         'ar53'                          || UNAPIRA.P_SEP ||
         'ar54'                          || UNAPIRA.P_SEP ||
         'ar55'                          || UNAPIRA.P_SEP ||
         'ar56'                          || UNAPIRA.P_SEP ||
         'ar57'                          || UNAPIRA.P_SEP ||
         'ar58'                          || UNAPIRA.P_SEP ||
         'ar59'                          || UNAPIRA.P_SEP ||
         'ar60'                          || UNAPIRA.P_SEP ||
         'ar61'                          || UNAPIRA.P_SEP ||
         'ar62'                          || UNAPIRA.P_SEP ||
         'ar63'                          || UNAPIRA.P_SEP ||
         'ar64'                          || UNAPIRA.P_SEP ||
         'ar65'                          || UNAPIRA.P_SEP ||
         'ar66'                          || UNAPIRA.P_SEP ||
         'ar67'                          || UNAPIRA.P_SEP ||
         'ar68'                          || UNAPIRA.P_SEP ||
         'ar69'                          || UNAPIRA.P_SEP ||
         'ar70'                          || UNAPIRA.P_SEP ||
         'ar71'                          || UNAPIRA.P_SEP ||
         'ar72'                          || UNAPIRA.P_SEP ||
         'ar73'                          || UNAPIRA.P_SEP ||
         'ar74'                          || UNAPIRA.P_SEP ||
         'ar75'                          || UNAPIRA.P_SEP ||
         'ar76'                          || UNAPIRA.P_SEP ||
         'ar77'                          || UNAPIRA.P_SEP ||
         'ar78'                          || UNAPIRA.P_SEP ||
         'ar79'                          || UNAPIRA.P_SEP ||
         'ar80'                          || UNAPIRA.P_SEP ||
         'ar81'                          || UNAPIRA.P_SEP ||
         'ar82'                          || UNAPIRA.P_SEP ||
         'ar83'                          || UNAPIRA.P_SEP ||
         'ar84'                          || UNAPIRA.P_SEP ||
         'ar85'                          || UNAPIRA.P_SEP ||
         'ar86'                          || UNAPIRA.P_SEP ||
         'ar87'                          || UNAPIRA.P_SEP ||
         'ar88'                          || UNAPIRA.P_SEP ||
         'ar89'                          || UNAPIRA.P_SEP ||
         'ar90'                          || UNAPIRA.P_SEP ||
         'ar91'                          || UNAPIRA.P_SEP ||
         'ar92'                          || UNAPIRA.P_SEP ||
         'ar93'                          || UNAPIRA.P_SEP ||
         'ar94'                          || UNAPIRA.P_SEP ||
         'ar95'                          || UNAPIRA.P_SEP ||
         'ar96'                          || UNAPIRA.P_SEP ||
         'ar97'                          || UNAPIRA.P_SEP ||
         'ar98'                          || UNAPIRA.P_SEP ||
         'ar99'                          || UNAPIRA.P_SEP ||
         'ar100'                         || UNAPIRA.P_SEP ||
         'ar101'                         || UNAPIRA.P_SEP ||
         'ar102'                         || UNAPIRA.P_SEP ||
         'ar103'                         || UNAPIRA.P_SEP ||
         'ar104'                         || UNAPIRA.P_SEP ||
         'ar105'                         || UNAPIRA.P_SEP ||
         'ar106'                         || UNAPIRA.P_SEP ||
         'ar107'                         || UNAPIRA.P_SEP ||
         'ar108'                         || UNAPIRA.P_SEP ||
         'ar109'                         || UNAPIRA.P_SEP ||
         'ar110'                         || UNAPIRA.P_SEP ||
         'ar111'                         || UNAPIRA.P_SEP ||
         'ar112'                         || UNAPIRA.P_SEP ||
         'ar113'                         || UNAPIRA.P_SEP ||
         'ar114'                         || UNAPIRA.P_SEP ||
         'ar115'                         || UNAPIRA.P_SEP ||
         'ar116'                         || UNAPIRA.P_SEP ||
         'ar117'                         || UNAPIRA.P_SEP ||
         'ar118'                         || UNAPIRA.P_SEP ||
         'ar119'                         || UNAPIRA.P_SEP ||
         'ar120'                         || UNAPIRA.P_SEP ||
         'ar121'                         || UNAPIRA.P_SEP ||
         'ar122'                         || UNAPIRA.P_SEP ||
         'ar123'                         || UNAPIRA.P_SEP ||
         'ar124'                         || UNAPIRA.P_SEP ||
         'ar125'                         || UNAPIRA.P_SEP ||
         'ar126'                         || UNAPIRA.P_SEP ||
         'ar127'                         || UNAPIRA.P_SEP ||
         'ar128'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utmtau'                             || UNAPIRA.P_SEP ||
         'mt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utmtel'                             || UNAPIRA.P_SEP ||
         'mt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'el'                            || UNAPIRA.P_SEP ||
         'seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utmths'                             || UNAPIRA.P_SEP ||
         'mt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utmtmr'                             || UNAPIRA.P_SEP ||
         'mt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'component'                     || UNAPIRA.P_SEP ||
         'l_detection_limit'             || UNAPIRA.P_SEP ||
         'l_determ_limit'                || UNAPIRA.P_SEP ||
         'h_determ_limit'                || UNAPIRA.P_SEP ||
         'h_detection_limit'             || UNAPIRA.P_SEP ||
         'unit'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utmtcell'                           || UNAPIRA.P_SEP ||
         'mt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'cell'                          || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'dsp_title'                     || UNAPIRA.P_SEP ||
         'dsp_title2'                    || UNAPIRA.P_SEP ||
         'value_f'                       || UNAPIRA.P_SEP ||
         'value_s'                       || UNAPIRA.P_SEP ||
         'pos_x'                         || UNAPIRA.P_SEP ||
         'pos_y'                         || UNAPIRA.P_SEP ||
         'align'                         || UNAPIRA.P_SEP ||
         'cell_tp'                       || UNAPIRA.P_SEP ||
         'winsize_x'                     || UNAPIRA.P_SEP ||
         'winsize_y'                     || UNAPIRA.P_SEP ||
         'is_protected'                  || UNAPIRA.P_SEP ||
         'mandatory'                     || UNAPIRA.P_SEP ||
         'hidden'                        || UNAPIRA.P_SEP ||
         'input_tp'                      || UNAPIRA.P_SEP ||
         'input_source'                  || UNAPIRA.P_SEP ||
         'input_source_version'          || UNAPIRA.P_SEP ||
         'input_pp'                      || UNAPIRA.P_SEP ||
         'input_pp_version'              || UNAPIRA.P_SEP ||
         'input_pr'                      || UNAPIRA.P_SEP ||
         'input_pr_version'              || UNAPIRA.P_SEP ||
         'input_mt'                      || UNAPIRA.P_SEP ||
         'input_mt_version'              || UNAPIRA.P_SEP ||
         'def_val_tp'                    || UNAPIRA.P_SEP ||
         'def_au_level'                  || UNAPIRA.P_SEP ||
         'save_tp'                       || UNAPIRA.P_SEP ||
         'save_pp'                       || UNAPIRA.P_SEP ||
         'save_pp_version'               || UNAPIRA.P_SEP ||
         'save_pr'                       || UNAPIRA.P_SEP ||
         'save_pr_version'               || UNAPIRA.P_SEP ||
         'save_mt'                       || UNAPIRA.P_SEP ||
         'save_mt_version'               || UNAPIRA.P_SEP ||
         'save_eq_tp'                    || UNAPIRA.P_SEP ||
         'save_id'                       || UNAPIRA.P_SEP ||
         'save_id_version'               || UNAPIRA.P_SEP ||
         'component'                     || UNAPIRA.P_SEP ||
         'unit'                          || UNAPIRA.P_SEP ||
         'format'                        || UNAPIRA.P_SEP ||
         'calc_tp'                       || UNAPIRA.P_SEP ||
         'calc_formula'                  || UNAPIRA.P_SEP ||
         'valid_cf'                      || UNAPIRA.P_SEP ||
         'max_x'                         || UNAPIRA.P_SEP ||
         'max_y'                         || UNAPIRA.P_SEP ||
         'multi_select'                  || UNAPIRA.P_SEP ||
         'create_new'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utmtcelllist'                       || UNAPIRA.P_SEP ||
         'mt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'cell'                          || UNAPIRA.P_SEP ||
         'index_x'                       || UNAPIRA.P_SEP ||
         'index_y'                       || UNAPIRA.P_SEP ||
         'value_f'                       || UNAPIRA.P_SEP ||
         'value_s'                       || UNAPIRA.P_SEP ||
         'selected'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utmtcellspin'                       || UNAPIRA.P_SEP ||
         'mt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'cell'                          || UNAPIRA.P_SEP ||
         'circular'                      || UNAPIRA.P_SEP ||
         'incr'                          || UNAPIRA.P_SEP ||
         'low_val_tp'                    || UNAPIRA.P_SEP ||
         'low_au_level'                  || UNAPIRA.P_SEP ||
         'low_val'                       || UNAPIRA.P_SEP ||
         'high_val_tp'                   || UNAPIRA.P_SEP ||
         'high_au_level'                 || UNAPIRA.P_SEP ||
         'high_val'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utmthsdetails'                      || UNAPIRA.P_SEP ||
         'mt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utmtcelleqtype'                     || UNAPIRA.P_SEP ||
         'mt'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'cell'                          || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'eq_tp'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utyearnr'                           || UNAPIRA.P_SEP ||
         'month_of_year'                 || UNAPIRA.P_SEP ||
         'month_of_year_tz'              || UNAPIRA.P_SEP ||
         'month_cnt'                     || UNAPIRA.P_SEP ||
         'year_cnt'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utly'                               || UNAPIRA.P_SEP ||
         'ly_tp'                         || UNAPIRA.P_SEP ||
         'ly'                            || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'col_id'                        || UNAPIRA.P_SEP ||
         'col_tp'                        || UNAPIRA.P_SEP ||
         'col_len'                       || UNAPIRA.P_SEP ||
         'disp_title'                    || UNAPIRA.P_SEP ||
         'disp_style'                    || UNAPIRA.P_SEP ||
         'disp_tp'                       || UNAPIRA.P_SEP ||
         'disp_width'                    || UNAPIRA.P_SEP ||
         'disp_format'                   || UNAPIRA.P_SEP ||
         'col_order'                     || UNAPIRA.P_SEP ||
         'col_asc'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utlu'                               || UNAPIRA.P_SEP ||
         'lu'                            || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'string_val'                    || UNAPIRA.P_SEP ||
         'num_val'                       || UNAPIRA.P_SEP ||
         'shortcut'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utlo'                               || UNAPIRA.P_SEP ||
         'lo'                            || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'description2'                  || UNAPIRA.P_SEP ||
         'nr_sc_max'                     || UNAPIRA.P_SEP ||
         'curr_nr_sc'                    || UNAPIRA.P_SEP ||
         'is_template'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utloau'                             || UNAPIRA.P_SEP ||
         'lo'                            || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utlocs'                             || UNAPIRA.P_SEP ||
         'lo'                            || UNAPIRA.P_SEP ||
         'cs'                            || UNAPIRA.P_SEP ||
         'seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utlc'                               || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'version_is_current'            || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'name'                          || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'intended_use'                  || UNAPIRA.P_SEP ||
         'is_template'                   || UNAPIRA.P_SEP ||
         'inherit_au'                    || UNAPIRA.P_SEP ||
         'ss_after_reanalysis'           || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'lc_class'                      || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc_lc'                         || UNAPIRA.P_SEP ||
         'lc_lc_version'                 || UNAPIRA.P_SEP ||
         'ss'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utlcaf'                             || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'ss_from'                       || UNAPIRA.P_SEP ||
         'ss_to'                         || UNAPIRA.P_SEP ||
         'tr_no'                         || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'af'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utlcau'                             || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utlchs'                             || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utlctr'                             || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'ss_from'                       || UNAPIRA.P_SEP ||
         'ss_to'                         || UNAPIRA.P_SEP ||
         'tr_no'                         || UNAPIRA.P_SEP ||
         'condition'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utlcus'                             || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'ss_from'                       || UNAPIRA.P_SEP ||
         'ss_to'                         || UNAPIRA.P_SEP ||
         'tr_no'                         || UNAPIRA.P_SEP ||
         'us'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utlchsdetails'                      || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utlabel'                            || UNAPIRA.P_SEP ||
         'label_format'                  || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utlab'                              || UNAPIRA.P_SEP ||
         'lab'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utjournal'                          || UNAPIRA.P_SEP ||
         'journal_nr'                    || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'currency'                      || UNAPIRA.P_SEP ||
         'currency2'                     || UNAPIRA.P_SEP ||
         'journal_tp'                    || UNAPIRA.P_SEP ||
         'journal_ss'                    || UNAPIRA.P_SEP ||
         'calc_tp'                       || UNAPIRA.P_SEP ||
         'total1'                        || UNAPIRA.P_SEP ||
         'total2'                        || UNAPIRA.P_SEP ||
         'disc_abs1'                     || UNAPIRA.P_SEP ||
         'disc_abs2'                     || UNAPIRA.P_SEP ||
         'disc_rel'                      || UNAPIRA.P_SEP ||
         'grand_total1'                  || UNAPIRA.P_SEP ||
         'grand_total2'                  || UNAPIRA.P_SEP ||
         'tax1'                          || UNAPIRA.P_SEP ||
         'tax2'                          || UNAPIRA.P_SEP ||
         'tax_rel'                       || UNAPIRA.P_SEP ||
         'grand_total_at1'               || UNAPIRA.P_SEP ||
         'grand_total_at2'               || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'invoiced'                      || UNAPIRA.P_SEP ||
         'invoiced_on'                   || UNAPIRA.P_SEP ||
         'invoiced_on_tz'                || UNAPIRA.P_SEP ||
         'date1'                         || UNAPIRA.P_SEP ||
         'date1_tz'                      || UNAPIRA.P_SEP ||
         'date2'                         || UNAPIRA.P_SEP ||
         'date2_tz'                      || UNAPIRA.P_SEP ||
         'date3'                         || UNAPIRA.P_SEP ||
         'date3_tz'                      || UNAPIRA.P_SEP ||
         'last_updated'                  || UNAPIRA.P_SEP ||
         'last_updated_tz'               || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'comments'                      || UNAPIRA.P_SEP ||
         'include_reanal'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utjournalrq'                        || UNAPIRA.P_SEP ||
         'journal_nr'                    || UNAPIRA.P_SEP ||
         'rq'                            || UNAPIRA.P_SEP ||
         'rqseq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utjournaldetails'                   || UNAPIRA.P_SEP ||
         'journal_nr'                    || UNAPIRA.P_SEP ||
         'rqseq'                         || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'object_tp'                     || UNAPIRA.P_SEP ||
         'object_version'                || UNAPIRA.P_SEP ||
         'rq'                            || UNAPIRA.P_SEP ||
         'sc'                            || UNAPIRA.P_SEP ||
         'pg'                            || UNAPIRA.P_SEP ||
         'pgnode'                        || UNAPIRA.P_SEP ||
         'pp_key1'                       || UNAPIRA.P_SEP ||
         'pp_key2'                       || UNAPIRA.P_SEP ||
         'pp_key3'                       || UNAPIRA.P_SEP ||
         'pp_key4'                       || UNAPIRA.P_SEP ||
         'pp_key5'                       || UNAPIRA.P_SEP ||
         'pa'                            || UNAPIRA.P_SEP ||
         'panode'                        || UNAPIRA.P_SEP ||
         'me'                            || UNAPIRA.P_SEP ||
         'menode'                        || UNAPIRA.P_SEP ||
         'reanalysis'                    || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'qtity'                         || UNAPIRA.P_SEP ||
         'price'                         || UNAPIRA.P_SEP ||
         'disc_abs'                      || UNAPIRA.P_SEP ||
         'disc_rel'                      || UNAPIRA.P_SEP ||
         'net_price'                     || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'last_updated'                  || UNAPIRA.P_SEP ||
         'last_updated_tz'               || UNAPIRA.P_SEP ||
         'ac_code'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utip'                               || UNAPIRA.P_SEP ||
         'ip'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'description2'                  || UNAPIRA.P_SEP ||
         'winsize_x'                     || UNAPIRA.P_SEP ||
         'winsize_y'                     || UNAPIRA.P_SEP ||
         'is_protected'                  || UNAPIRA.P_SEP ||
         'hidden'                        || UNAPIRA.P_SEP ||
         'is_template'                   || UNAPIRA.P_SEP ||
         'sc_lc'                         || UNAPIRA.P_SEP ||
         'sc_lc_version'                 || UNAPIRA.P_SEP ||
         'inherit_au'                    || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'ip_class'                      || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'                            || UNAPIRA.P_SEP ||
         'ar1'                           || UNAPIRA.P_SEP ||
         'ar2'                           || UNAPIRA.P_SEP ||
         'ar3'                           || UNAPIRA.P_SEP ||
         'ar4'                           || UNAPIRA.P_SEP ||
         'ar5'                           || UNAPIRA.P_SEP ||
         'ar6'                           || UNAPIRA.P_SEP ||
         'ar7'                           || UNAPIRA.P_SEP ||
         'ar8'                           || UNAPIRA.P_SEP ||
         'ar9'                           || UNAPIRA.P_SEP ||
         'ar10'                          || UNAPIRA.P_SEP ||
         'ar11'                          || UNAPIRA.P_SEP ||
         'ar12'                          || UNAPIRA.P_SEP ||
         'ar13'                          || UNAPIRA.P_SEP ||
         'ar14'                          || UNAPIRA.P_SEP ||
         'ar15'                          || UNAPIRA.P_SEP ||
         'ar16'                          || UNAPIRA.P_SEP ||
         'ar17'                          || UNAPIRA.P_SEP ||
         'ar18'                          || UNAPIRA.P_SEP ||
         'ar19'                          || UNAPIRA.P_SEP ||
         'ar20'                          || UNAPIRA.P_SEP ||
         'ar21'                          || UNAPIRA.P_SEP ||
         'ar22'                          || UNAPIRA.P_SEP ||
         'ar23'                          || UNAPIRA.P_SEP ||
         'ar24'                          || UNAPIRA.P_SEP ||
         'ar25'                          || UNAPIRA.P_SEP ||
         'ar26'                          || UNAPIRA.P_SEP ||
         'ar27'                          || UNAPIRA.P_SEP ||
         'ar28'                          || UNAPIRA.P_SEP ||
         'ar29'                          || UNAPIRA.P_SEP ||
         'ar30'                          || UNAPIRA.P_SEP ||
         'ar31'                          || UNAPIRA.P_SEP ||
         'ar32'                          || UNAPIRA.P_SEP ||
         'ar33'                          || UNAPIRA.P_SEP ||
         'ar34'                          || UNAPIRA.P_SEP ||
         'ar35'                          || UNAPIRA.P_SEP ||
         'ar36'                          || UNAPIRA.P_SEP ||
         'ar37'                          || UNAPIRA.P_SEP ||
         'ar38'                          || UNAPIRA.P_SEP ||
         'ar39'                          || UNAPIRA.P_SEP ||
         'ar40'                          || UNAPIRA.P_SEP ||
         'ar41'                          || UNAPIRA.P_SEP ||
         'ar42'                          || UNAPIRA.P_SEP ||
         'ar43'                          || UNAPIRA.P_SEP ||
         'ar44'                          || UNAPIRA.P_SEP ||
         'ar45'                          || UNAPIRA.P_SEP ||
         'ar46'                          || UNAPIRA.P_SEP ||
         'ar47'                          || UNAPIRA.P_SEP ||
         'ar48'                          || UNAPIRA.P_SEP ||
         'ar49'                          || UNAPIRA.P_SEP ||
         'ar50'                          || UNAPIRA.P_SEP ||
         'ar51'                          || UNAPIRA.P_SEP ||
         'ar52'                          || UNAPIRA.P_SEP ||
         'ar53'                          || UNAPIRA.P_SEP ||
         'ar54'                          || UNAPIRA.P_SEP ||
         'ar55'                          || UNAPIRA.P_SEP ||
         'ar56'                          || UNAPIRA.P_SEP ||
         'ar57'                          || UNAPIRA.P_SEP ||
         'ar58'                          || UNAPIRA.P_SEP ||
         'ar59'                          || UNAPIRA.P_SEP ||
         'ar60'                          || UNAPIRA.P_SEP ||
         'ar61'                          || UNAPIRA.P_SEP ||
         'ar62'                          || UNAPIRA.P_SEP ||
         'ar63'                          || UNAPIRA.P_SEP ||
         'ar64'                          || UNAPIRA.P_SEP ||
         'ar65'                          || UNAPIRA.P_SEP ||
         'ar66'                          || UNAPIRA.P_SEP ||
         'ar67'                          || UNAPIRA.P_SEP ||
         'ar68'                          || UNAPIRA.P_SEP ||
         'ar69'                          || UNAPIRA.P_SEP ||
         'ar70'                          || UNAPIRA.P_SEP ||
         'ar71'                          || UNAPIRA.P_SEP ||
         'ar72'                          || UNAPIRA.P_SEP ||
         'ar73'                          || UNAPIRA.P_SEP ||
         'ar74'                          || UNAPIRA.P_SEP ||
         'ar75'                          || UNAPIRA.P_SEP ||
         'ar76'                          || UNAPIRA.P_SEP ||
         'ar77'                          || UNAPIRA.P_SEP ||
         'ar78'                          || UNAPIRA.P_SEP ||
         'ar79'                          || UNAPIRA.P_SEP ||
         'ar80'                          || UNAPIRA.P_SEP ||
         'ar81'                          || UNAPIRA.P_SEP ||
         'ar82'                          || UNAPIRA.P_SEP ||
         'ar83'                          || UNAPIRA.P_SEP ||
         'ar84'                          || UNAPIRA.P_SEP ||
         'ar85'                          || UNAPIRA.P_SEP ||
         'ar86'                          || UNAPIRA.P_SEP ||
         'ar87'                          || UNAPIRA.P_SEP ||
         'ar88'                          || UNAPIRA.P_SEP ||
         'ar89'                          || UNAPIRA.P_SEP ||
         'ar90'                          || UNAPIRA.P_SEP ||
         'ar91'                          || UNAPIRA.P_SEP ||
         'ar92'                          || UNAPIRA.P_SEP ||
         'ar93'                          || UNAPIRA.P_SEP ||
         'ar94'                          || UNAPIRA.P_SEP ||
         'ar95'                          || UNAPIRA.P_SEP ||
         'ar96'                          || UNAPIRA.P_SEP ||
         'ar97'                          || UNAPIRA.P_SEP ||
         'ar98'                          || UNAPIRA.P_SEP ||
         'ar99'                          || UNAPIRA.P_SEP ||
         'ar100'                         || UNAPIRA.P_SEP ||
         'ar101'                         || UNAPIRA.P_SEP ||
         'ar102'                         || UNAPIRA.P_SEP ||
         'ar103'                         || UNAPIRA.P_SEP ||
         'ar104'                         || UNAPIRA.P_SEP ||
         'ar105'                         || UNAPIRA.P_SEP ||
         'ar106'                         || UNAPIRA.P_SEP ||
         'ar107'                         || UNAPIRA.P_SEP ||
         'ar108'                         || UNAPIRA.P_SEP ||
         'ar109'                         || UNAPIRA.P_SEP ||
         'ar110'                         || UNAPIRA.P_SEP ||
         'ar111'                         || UNAPIRA.P_SEP ||
         'ar112'                         || UNAPIRA.P_SEP ||
         'ar113'                         || UNAPIRA.P_SEP ||
         'ar114'                         || UNAPIRA.P_SEP ||
         'ar115'                         || UNAPIRA.P_SEP ||
         'ar116'                         || UNAPIRA.P_SEP ||
         'ar117'                         || UNAPIRA.P_SEP ||
         'ar118'                         || UNAPIRA.P_SEP ||
         'ar119'                         || UNAPIRA.P_SEP ||
         'ar120'                         || UNAPIRA.P_SEP ||
         'ar121'                         || UNAPIRA.P_SEP ||
         'ar122'                         || UNAPIRA.P_SEP ||
         'ar123'                         || UNAPIRA.P_SEP ||
         'ar124'                         || UNAPIRA.P_SEP ||
         'ar125'                         || UNAPIRA.P_SEP ||
         'ar126'                         || UNAPIRA.P_SEP ||
         'ar127'                         || UNAPIRA.P_SEP ||
         'ar128'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utipau'                             || UNAPIRA.P_SEP ||
         'ip'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utiphs'                             || UNAPIRA.P_SEP ||
         'ip'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utipie'                             || UNAPIRA.P_SEP ||
         'ip'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'ie'                            || UNAPIRA.P_SEP ||
         'ie_version'                    || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'pos_x'                         || UNAPIRA.P_SEP ||
         'pos_y'                         || UNAPIRA.P_SEP ||
         'is_protected'                  || UNAPIRA.P_SEP ||
         'mandatory'                     || UNAPIRA.P_SEP ||
         'hidden'                        || UNAPIRA.P_SEP ||
         'def_val_tp'                    || UNAPIRA.P_SEP ||
         'def_au_level'                  || UNAPIRA.P_SEP ||
         'ievalue'                       || UNAPIRA.P_SEP ||
         'dsp_title'                     || UNAPIRA.P_SEP ||
         'dsp_title2'                    || UNAPIRA.P_SEP ||
         'dsp_len'                       || UNAPIRA.P_SEP ||
         'dsp_tp'                        || UNAPIRA.P_SEP ||
         'dsp_rows'                      || UNAPIRA.P_SEP ||
         'dsp_title_use_ie'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utipieau'                           || UNAPIRA.P_SEP ||
         'ip'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'ie'                            || UNAPIRA.P_SEP ||
         'ie_version'                    || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utiphsdetails'                      || UNAPIRA.P_SEP ||
         'ip'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utie'                               || UNAPIRA.P_SEP ||
         'ie'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'is_protected'                  || UNAPIRA.P_SEP ||
         'mandatory'                     || UNAPIRA.P_SEP ||
         'hidden'                        || UNAPIRA.P_SEP ||
         'data_tp'                       || UNAPIRA.P_SEP ||
         'format'                        || UNAPIRA.P_SEP ||
         'valid_cf'                      || UNAPIRA.P_SEP ||
         'def_val_tp'                    || UNAPIRA.P_SEP ||
         'def_au_level'                  || UNAPIRA.P_SEP ||
         'ievalue'                       || UNAPIRA.P_SEP ||
         'align'                         || UNAPIRA.P_SEP ||
         'dsp_title'                     || UNAPIRA.P_SEP ||
         'dsp_title2'                    || UNAPIRA.P_SEP ||
         'dsp_len'                       || UNAPIRA.P_SEP ||
         'dsp_tp'                        || UNAPIRA.P_SEP ||
         'dsp_rows'                      || UNAPIRA.P_SEP ||
         'look_up_ptr'                   || UNAPIRA.P_SEP ||
         'is_template'                   || UNAPIRA.P_SEP ||
         'multi_select'                  || UNAPIRA.P_SEP ||
         'sc_lc'                         || UNAPIRA.P_SEP ||
         'sc_lc_version'                 || UNAPIRA.P_SEP ||
         'inherit_au'                    || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'ie_class'                      || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'                            || UNAPIRA.P_SEP ||
         'ar1'                           || UNAPIRA.P_SEP ||
         'ar2'                           || UNAPIRA.P_SEP ||
         'ar3'                           || UNAPIRA.P_SEP ||
         'ar4'                           || UNAPIRA.P_SEP ||
         'ar5'                           || UNAPIRA.P_SEP ||
         'ar6'                           || UNAPIRA.P_SEP ||
         'ar7'                           || UNAPIRA.P_SEP ||
         'ar8'                           || UNAPIRA.P_SEP ||
         'ar9'                           || UNAPIRA.P_SEP ||
         'ar10'                          || UNAPIRA.P_SEP ||
         'ar11'                          || UNAPIRA.P_SEP ||
         'ar12'                          || UNAPIRA.P_SEP ||
         'ar13'                          || UNAPIRA.P_SEP ||
         'ar14'                          || UNAPIRA.P_SEP ||
         'ar15'                          || UNAPIRA.P_SEP ||
         'ar16'                          || UNAPIRA.P_SEP ||
         'ar17'                          || UNAPIRA.P_SEP ||
         'ar18'                          || UNAPIRA.P_SEP ||
         'ar19'                          || UNAPIRA.P_SEP ||
         'ar20'                          || UNAPIRA.P_SEP ||
         'ar21'                          || UNAPIRA.P_SEP ||
         'ar22'                          || UNAPIRA.P_SEP ||
         'ar23'                          || UNAPIRA.P_SEP ||
         'ar24'                          || UNAPIRA.P_SEP ||
         'ar25'                          || UNAPIRA.P_SEP ||
         'ar26'                          || UNAPIRA.P_SEP ||
         'ar27'                          || UNAPIRA.P_SEP ||
         'ar28'                          || UNAPIRA.P_SEP ||
         'ar29'                          || UNAPIRA.P_SEP ||
         'ar30'                          || UNAPIRA.P_SEP ||
         'ar31'                          || UNAPIRA.P_SEP ||
         'ar32'                          || UNAPIRA.P_SEP ||
         'ar33'                          || UNAPIRA.P_SEP ||
         'ar34'                          || UNAPIRA.P_SEP ||
         'ar35'                          || UNAPIRA.P_SEP ||
         'ar36'                          || UNAPIRA.P_SEP ||
         'ar37'                          || UNAPIRA.P_SEP ||
         'ar38'                          || UNAPIRA.P_SEP ||
         'ar39'                          || UNAPIRA.P_SEP ||
         'ar40'                          || UNAPIRA.P_SEP ||
         'ar41'                          || UNAPIRA.P_SEP ||
         'ar42'                          || UNAPIRA.P_SEP ||
         'ar43'                          || UNAPIRA.P_SEP ||
         'ar44'                          || UNAPIRA.P_SEP ||
         'ar45'                          || UNAPIRA.P_SEP ||
         'ar46'                          || UNAPIRA.P_SEP ||
         'ar47'                          || UNAPIRA.P_SEP ||
         'ar48'                          || UNAPIRA.P_SEP ||
         'ar49'                          || UNAPIRA.P_SEP ||
         'ar50'                          || UNAPIRA.P_SEP ||
         'ar51'                          || UNAPIRA.P_SEP ||
         'ar52'                          || UNAPIRA.P_SEP ||
         'ar53'                          || UNAPIRA.P_SEP ||
         'ar54'                          || UNAPIRA.P_SEP ||
         'ar55'                          || UNAPIRA.P_SEP ||
         'ar56'                          || UNAPIRA.P_SEP ||
         'ar57'                          || UNAPIRA.P_SEP ||
         'ar58'                          || UNAPIRA.P_SEP ||
         'ar59'                          || UNAPIRA.P_SEP ||
         'ar60'                          || UNAPIRA.P_SEP ||
         'ar61'                          || UNAPIRA.P_SEP ||
         'ar62'                          || UNAPIRA.P_SEP ||
         'ar63'                          || UNAPIRA.P_SEP ||
         'ar64'                          || UNAPIRA.P_SEP ||
         'ar65'                          || UNAPIRA.P_SEP ||
         'ar66'                          || UNAPIRA.P_SEP ||
         'ar67'                          || UNAPIRA.P_SEP ||
         'ar68'                          || UNAPIRA.P_SEP ||
         'ar69'                          || UNAPIRA.P_SEP ||
         'ar70'                          || UNAPIRA.P_SEP ||
         'ar71'                          || UNAPIRA.P_SEP ||
         'ar72'                          || UNAPIRA.P_SEP ||
         'ar73'                          || UNAPIRA.P_SEP ||
         'ar74'                          || UNAPIRA.P_SEP ||
         'ar75'                          || UNAPIRA.P_SEP ||
         'ar76'                          || UNAPIRA.P_SEP ||
         'ar77'                          || UNAPIRA.P_SEP ||
         'ar78'                          || UNAPIRA.P_SEP ||
         'ar79'                          || UNAPIRA.P_SEP ||
         'ar80'                          || UNAPIRA.P_SEP ||
         'ar81'                          || UNAPIRA.P_SEP ||
         'ar82'                          || UNAPIRA.P_SEP ||
         'ar83'                          || UNAPIRA.P_SEP ||
         'ar84'                          || UNAPIRA.P_SEP ||
         'ar85'                          || UNAPIRA.P_SEP ||
         'ar86'                          || UNAPIRA.P_SEP ||
         'ar87'                          || UNAPIRA.P_SEP ||
         'ar88'                          || UNAPIRA.P_SEP ||
         'ar89'                          || UNAPIRA.P_SEP ||
         'ar90'                          || UNAPIRA.P_SEP ||
         'ar91'                          || UNAPIRA.P_SEP ||
         'ar92'                          || UNAPIRA.P_SEP ||
         'ar93'                          || UNAPIRA.P_SEP ||
         'ar94'                          || UNAPIRA.P_SEP ||
         'ar95'                          || UNAPIRA.P_SEP ||
         'ar96'                          || UNAPIRA.P_SEP ||
         'ar97'                          || UNAPIRA.P_SEP ||
         'ar98'                          || UNAPIRA.P_SEP ||
         'ar99'                          || UNAPIRA.P_SEP ||
         'ar100'                         || UNAPIRA.P_SEP ||
         'ar101'                         || UNAPIRA.P_SEP ||
         'ar102'                         || UNAPIRA.P_SEP ||
         'ar103'                         || UNAPIRA.P_SEP ||
         'ar104'                         || UNAPIRA.P_SEP ||
         'ar105'                         || UNAPIRA.P_SEP ||
         'ar106'                         || UNAPIRA.P_SEP ||
         'ar107'                         || UNAPIRA.P_SEP ||
         'ar108'                         || UNAPIRA.P_SEP ||
         'ar109'                         || UNAPIRA.P_SEP ||
         'ar110'                         || UNAPIRA.P_SEP ||
         'ar111'                         || UNAPIRA.P_SEP ||
         'ar112'                         || UNAPIRA.P_SEP ||
         'ar113'                         || UNAPIRA.P_SEP ||
         'ar114'                         || UNAPIRA.P_SEP ||
         'ar115'                         || UNAPIRA.P_SEP ||
         'ar116'                         || UNAPIRA.P_SEP ||
         'ar117'                         || UNAPIRA.P_SEP ||
         'ar118'                         || UNAPIRA.P_SEP ||
         'ar119'                         || UNAPIRA.P_SEP ||
         'ar120'                         || UNAPIRA.P_SEP ||
         'ar121'                         || UNAPIRA.P_SEP ||
         'ar122'                         || UNAPIRA.P_SEP ||
         'ar123'                         || UNAPIRA.P_SEP ||
         'ar124'                         || UNAPIRA.P_SEP ||
         'ar125'                         || UNAPIRA.P_SEP ||
         'ar126'                         || UNAPIRA.P_SEP ||
         'ar127'                         || UNAPIRA.P_SEP ||
         'ar128'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utieau'                             || UNAPIRA.P_SEP ||
         'ie'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utiehs'                             || UNAPIRA.P_SEP ||
         'ie'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utiesql'                            || UNAPIRA.P_SEP ||
         'ie'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'sqltext'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utielist'                           || UNAPIRA.P_SEP ||
         'ie'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utiespin'                           || UNAPIRA.P_SEP ||
         'ie'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'circular'                      || UNAPIRA.P_SEP ||
         'incr'                          || UNAPIRA.P_SEP ||
         'low_val_tp'                    || UNAPIRA.P_SEP ||
         'low_au_level'                  || UNAPIRA.P_SEP ||
         'low_val'                       || UNAPIRA.P_SEP ||
         'high_val_tp'                   || UNAPIRA.P_SEP ||
         'high_au_level'                 || UNAPIRA.P_SEP ||
         'high_val'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utiehsdetails'                      || UNAPIRA.P_SEP ||
         'ie'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkch'                             || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'version_is_current'            || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'is_protected'                  || UNAPIRA.P_SEP ||
         'value_unique'                  || UNAPIRA.P_SEP ||
         'single_valued'                 || UNAPIRA.P_SEP ||
         'new_val_allowed'               || UNAPIRA.P_SEP ||
         'mandatory'                     || UNAPIRA.P_SEP ||
         'struct_created'                || UNAPIRA.P_SEP ||
         'inherit_gk'                    || UNAPIRA.P_SEP ||
         'value_list_tp'                 || UNAPIRA.P_SEP ||
         'default_value'                 || UNAPIRA.P_SEP ||
         'dsp_rows'                      || UNAPIRA.P_SEP ||
         'val_length'                    || UNAPIRA.P_SEP ||
         'val_start'                     || UNAPIRA.P_SEP ||
         'assign_tp'                     || UNAPIRA.P_SEP ||
         'assign_id'                     || UNAPIRA.P_SEP ||
         'q_tp'                          || UNAPIRA.P_SEP ||
         'q_id'                          || UNAPIRA.P_SEP ||
         'q_check_au'                    || UNAPIRA.P_SEP ||
         'q_au'                          || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'gk_class'                      || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkdc'                             || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'version_is_current'            || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'is_protected'                  || UNAPIRA.P_SEP ||
         'value_unique'                  || UNAPIRA.P_SEP ||
         'single_valued'                 || UNAPIRA.P_SEP ||
         'new_val_allowed'               || UNAPIRA.P_SEP ||
         'mandatory'                     || UNAPIRA.P_SEP ||
         'struct_created'                || UNAPIRA.P_SEP ||
         'inherit_gk'                    || UNAPIRA.P_SEP ||
         'value_list_tp'                 || UNAPIRA.P_SEP ||
         'default_value'                 || UNAPIRA.P_SEP ||
         'dsp_rows'                      || UNAPIRA.P_SEP ||
         'val_length'                    || UNAPIRA.P_SEP ||
         'val_start'                     || UNAPIRA.P_SEP ||
         'assign_tp'                     || UNAPIRA.P_SEP ||
         'assign_id'                     || UNAPIRA.P_SEP ||
         'q_tp'                          || UNAPIRA.P_SEP ||
         'q_id'                          || UNAPIRA.P_SEP ||
         'q_check_au'                    || UNAPIRA.P_SEP ||
         'q_au'                          || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'gk_class'                      || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkme'                             || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'version_is_current'            || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'is_protected'                  || UNAPIRA.P_SEP ||
         'value_unique'                  || UNAPIRA.P_SEP ||
         'single_valued'                 || UNAPIRA.P_SEP ||
         'new_val_allowed'               || UNAPIRA.P_SEP ||
         'mandatory'                     || UNAPIRA.P_SEP ||
         'struct_created'                || UNAPIRA.P_SEP ||
         'inherit_gk'                    || UNAPIRA.P_SEP ||
         'value_list_tp'                 || UNAPIRA.P_SEP ||
         'default_value'                 || UNAPIRA.P_SEP ||
         'dsp_rows'                      || UNAPIRA.P_SEP ||
         'val_length'                    || UNAPIRA.P_SEP ||
         'val_start'                     || UNAPIRA.P_SEP ||
         'assign_tp'                     || UNAPIRA.P_SEP ||
         'assign_id'                     || UNAPIRA.P_SEP ||
         'q_tp'                          || UNAPIRA.P_SEP ||
         'q_id'                          || UNAPIRA.P_SEP ||
         'q_check_au'                    || UNAPIRA.P_SEP ||
         'q_au'                          || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'gk_class'                      || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkpt'                             || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'version_is_current'            || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'is_protected'                  || UNAPIRA.P_SEP ||
         'value_unique'                  || UNAPIRA.P_SEP ||
         'single_valued'                 || UNAPIRA.P_SEP ||
         'new_val_allowed'               || UNAPIRA.P_SEP ||
         'mandatory'                     || UNAPIRA.P_SEP ||
         'struct_created'                || UNAPIRA.P_SEP ||
         'inherit_gk'                    || UNAPIRA.P_SEP ||
         'value_list_tp'                 || UNAPIRA.P_SEP ||
         'default_value'                 || UNAPIRA.P_SEP ||
         'dsp_rows'                      || UNAPIRA.P_SEP ||
         'val_length'                    || UNAPIRA.P_SEP ||
         'val_start'                     || UNAPIRA.P_SEP ||
         'assign_tp'                     || UNAPIRA.P_SEP ||
         'assign_id'                     || UNAPIRA.P_SEP ||
         'q_tp'                          || UNAPIRA.P_SEP ||
         'q_id'                          || UNAPIRA.P_SEP ||
         'q_check_au'                    || UNAPIRA.P_SEP ||
         'q_au'                          || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'gk_class'                      || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkrq'                             || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'version_is_current'            || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'is_protected'                  || UNAPIRA.P_SEP ||
         'value_unique'                  || UNAPIRA.P_SEP ||
         'single_valued'                 || UNAPIRA.P_SEP ||
         'new_val_allowed'               || UNAPIRA.P_SEP ||
         'mandatory'                     || UNAPIRA.P_SEP ||
         'struct_created'                || UNAPIRA.P_SEP ||
         'inherit_gk'                    || UNAPIRA.P_SEP ||
         'value_list_tp'                 || UNAPIRA.P_SEP ||
         'default_value'                 || UNAPIRA.P_SEP ||
         'dsp_rows'                      || UNAPIRA.P_SEP ||
         'val_length'                    || UNAPIRA.P_SEP ||
         'val_start'                     || UNAPIRA.P_SEP ||
         'assign_tp'                     || UNAPIRA.P_SEP ||
         'assign_id'                     || UNAPIRA.P_SEP ||
         'q_tp'                          || UNAPIRA.P_SEP ||
         'q_id'                          || UNAPIRA.P_SEP ||
         'q_check_au'                    || UNAPIRA.P_SEP ||
         'q_au'                          || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'gk_class'                      || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkrt'                             || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'version_is_current'            || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'is_protected'                  || UNAPIRA.P_SEP ||
         'value_unique'                  || UNAPIRA.P_SEP ||
         'single_valued'                 || UNAPIRA.P_SEP ||
         'new_val_allowed'               || UNAPIRA.P_SEP ||
         'mandatory'                     || UNAPIRA.P_SEP ||
         'struct_created'                || UNAPIRA.P_SEP ||
         'inherit_gk'                    || UNAPIRA.P_SEP ||
         'value_list_tp'                 || UNAPIRA.P_SEP ||
         'default_value'                 || UNAPIRA.P_SEP ||
         'dsp_rows'                      || UNAPIRA.P_SEP ||
         'val_length'                    || UNAPIRA.P_SEP ||
         'val_start'                     || UNAPIRA.P_SEP ||
         'assign_tp'                     || UNAPIRA.P_SEP ||
         'assign_id'                     || UNAPIRA.P_SEP ||
         'q_tp'                          || UNAPIRA.P_SEP ||
         'q_id'                          || UNAPIRA.P_SEP ||
         'q_check_au'                    || UNAPIRA.P_SEP ||
         'q_au'                          || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'gk_class'                      || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgksc'                             || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'version_is_current'            || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'is_protected'                  || UNAPIRA.P_SEP ||
         'value_unique'                  || UNAPIRA.P_SEP ||
         'single_valued'                 || UNAPIRA.P_SEP ||
         'new_val_allowed'               || UNAPIRA.P_SEP ||
         'mandatory'                     || UNAPIRA.P_SEP ||
         'struct_created'                || UNAPIRA.P_SEP ||
         'inherit_gk'                    || UNAPIRA.P_SEP ||
         'value_list_tp'                 || UNAPIRA.P_SEP ||
         'default_value'                 || UNAPIRA.P_SEP ||
         'dsp_rows'                      || UNAPIRA.P_SEP ||
         'val_length'                    || UNAPIRA.P_SEP ||
         'val_start'                     || UNAPIRA.P_SEP ||
         'assign_tp'                     || UNAPIRA.P_SEP ||
         'assign_id'                     || UNAPIRA.P_SEP ||
         'q_tp'                          || UNAPIRA.P_SEP ||
         'q_id'                          || UNAPIRA.P_SEP ||
         'q_check_au'                    || UNAPIRA.P_SEP ||
         'q_au'                          || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'gk_class'                      || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgksd'                             || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'version_is_current'            || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'is_protected'                  || UNAPIRA.P_SEP ||
         'value_unique'                  || UNAPIRA.P_SEP ||
         'single_valued'                 || UNAPIRA.P_SEP ||
         'new_val_allowed'               || UNAPIRA.P_SEP ||
         'mandatory'                     || UNAPIRA.P_SEP ||
         'struct_created'                || UNAPIRA.P_SEP ||
         'inherit_gk'                    || UNAPIRA.P_SEP ||
         'value_list_tp'                 || UNAPIRA.P_SEP ||
         'default_value'                 || UNAPIRA.P_SEP ||
         'dsp_rows'                      || UNAPIRA.P_SEP ||
         'val_length'                    || UNAPIRA.P_SEP ||
         'val_start'                     || UNAPIRA.P_SEP ||
         'assign_tp'                     || UNAPIRA.P_SEP ||
         'assign_id'                     || UNAPIRA.P_SEP ||
         'q_tp'                          || UNAPIRA.P_SEP ||
         'q_id'                          || UNAPIRA.P_SEP ||
         'q_check_au'                    || UNAPIRA.P_SEP ||
         'q_au'                          || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'gk_class'                      || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkst'                             || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'version_is_current'            || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'is_protected'                  || UNAPIRA.P_SEP ||
         'value_unique'                  || UNAPIRA.P_SEP ||
         'single_valued'                 || UNAPIRA.P_SEP ||
         'new_val_allowed'               || UNAPIRA.P_SEP ||
         'mandatory'                     || UNAPIRA.P_SEP ||
         'struct_created'                || UNAPIRA.P_SEP ||
         'inherit_gk'                    || UNAPIRA.P_SEP ||
         'value_list_tp'                 || UNAPIRA.P_SEP ||
         'default_value'                 || UNAPIRA.P_SEP ||
         'dsp_rows'                      || UNAPIRA.P_SEP ||
         'val_length'                    || UNAPIRA.P_SEP ||
         'val_start'                     || UNAPIRA.P_SEP ||
         'assign_tp'                     || UNAPIRA.P_SEP ||
         'assign_id'                     || UNAPIRA.P_SEP ||
         'q_tp'                          || UNAPIRA.P_SEP ||
         'q_id'                          || UNAPIRA.P_SEP ||
         'q_check_au'                    || UNAPIRA.P_SEP ||
         'q_au'                          || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'gk_class'                      || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkws'                             || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'version_is_current'            || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'is_protected'                  || UNAPIRA.P_SEP ||
         'value_unique'                  || UNAPIRA.P_SEP ||
         'single_valued'                 || UNAPIRA.P_SEP ||
         'new_val_allowed'               || UNAPIRA.P_SEP ||
         'mandatory'                     || UNAPIRA.P_SEP ||
         'struct_created'                || UNAPIRA.P_SEP ||
         'inherit_gk'                    || UNAPIRA.P_SEP ||
         'value_list_tp'                 || UNAPIRA.P_SEP ||
         'default_value'                 || UNAPIRA.P_SEP ||
         'dsp_rows'                      || UNAPIRA.P_SEP ||
         'val_length'                    || UNAPIRA.P_SEP ||
         'val_start'                     || UNAPIRA.P_SEP ||
         'assign_tp'                     || UNAPIRA.P_SEP ||
         'assign_id'                     || UNAPIRA.P_SEP ||
         'q_tp'                          || UNAPIRA.P_SEP ||
         'q_id'                          || UNAPIRA.P_SEP ||
         'q_check_au'                    || UNAPIRA.P_SEP ||
         'q_au'                          || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'gk_class'                      || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkchhs'                           || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkdchs'                           || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkmehs'                           || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkpths'                           || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkrqhs'                           || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkrths'                           || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkschs'                           || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgksdhs'                           || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgksths'                           || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkwshs'                           || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkchsql'                          || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'sqltext'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkdcsql'                          || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'sqltext'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkmesql'                          || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'sqltext'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkptsql'                          || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'sqltext'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkrqsql'                          || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'sqltext'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkrtsql'                          || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'sqltext'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkscsql'                          || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'sqltext'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgksdsql'                          || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'sqltext'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkstsql'                          || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'sqltext'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkwssql'                          || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'sqltext'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkchlist'                         || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkdclist'                         || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkmelist'                         || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkptlist'                         || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkrqlist'                         || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkrtlist'                         || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgksclist'                         || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgksdlist'                         || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkstlist'                         || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkwslist'                         || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkchhsdetails'                    || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkdchsdetails'                    || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkmehsdetails'                    || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkpthsdetails'                    || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkrqhsdetails'                    || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkrthsdetails'                    || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkschsdetails'                    || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgksdhsdetails'                    || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgksthsdetails'                    || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgkwshsdetails'                    || UNAPIRA.P_SEP ||
         'gk'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utfi'                               || UNAPIRA.P_SEP ||
         'fi'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'creation_date'                 || UNAPIRA.P_SEP ||
         'creation_date_tz'              || UNAPIRA.P_SEP ||
         'created_by'                    || UNAPIRA.P_SEP ||
         'dll_id'                        || UNAPIRA.P_SEP ||
         'cpp_id'                        || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utfihs'                             || UNAPIRA.P_SEP ||
         'fi'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utfihsdetails'                      || UNAPIRA.P_SEP ||
         'fi'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utgksupportedev'                    || UNAPIRA.P_SEP ||
         'ev_tp'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'uteq'                               || UNAPIRA.P_SEP ||
         'eq'                            || UNAPIRA.P_SEP ||
         'lab'                           || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'version_is_current'            || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'serial_no'                     || UNAPIRA.P_SEP ||
         'supplier'                      || UNAPIRA.P_SEP ||
         'location'                      || UNAPIRA.P_SEP ||
         'invest_cost'                   || UNAPIRA.P_SEP ||
         'invest_unit'                   || UNAPIRA.P_SEP ||
         'usage_cost'                    || UNAPIRA.P_SEP ||
         'usage_unit'                    || UNAPIRA.P_SEP ||
         'install_date'                  || UNAPIRA.P_SEP ||
         'install_date_tz'               || UNAPIRA.P_SEP ||
         'in_service_date'               || UNAPIRA.P_SEP ||
         'in_service_date_tz'            || UNAPIRA.P_SEP ||
         'accessories'                   || UNAPIRA.P_SEP ||
         'operation'                     || UNAPIRA.P_SEP ||
         'operation_doc'                 || UNAPIRA.P_SEP ||
         'operation_doc_version'         || UNAPIRA.P_SEP ||
         'usage'                         || UNAPIRA.P_SEP ||
         'usage_doc'                     || UNAPIRA.P_SEP ||
         'usage_doc_version'             || UNAPIRA.P_SEP ||
         'eq_class'                      || UNAPIRA.P_SEP ||
         'eq_component'                  || UNAPIRA.P_SEP ||
         'keep_ctold'                    || UNAPIRA.P_SEP ||
         'keep_ctold_unit'               || UNAPIRA.P_SEP ||
         'is_template'                   || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'ca_warn_level'                 || UNAPIRA.P_SEP ||
         'ss'                            || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ar1'                           || UNAPIRA.P_SEP ||
         'ar2'                           || UNAPIRA.P_SEP ||
         'ar3'                           || UNAPIRA.P_SEP ||
         'ar4'                           || UNAPIRA.P_SEP ||
         'ar5'                           || UNAPIRA.P_SEP ||
         'ar6'                           || UNAPIRA.P_SEP ||
         'ar7'                           || UNAPIRA.P_SEP ||
         'ar8'                           || UNAPIRA.P_SEP ||
         'ar9'                           || UNAPIRA.P_SEP ||
         'ar10'                          || UNAPIRA.P_SEP ||
         'ar11'                          || UNAPIRA.P_SEP ||
         'ar12'                          || UNAPIRA.P_SEP ||
         'ar13'                          || UNAPIRA.P_SEP ||
         'ar14'                          || UNAPIRA.P_SEP ||
         'ar15'                          || UNAPIRA.P_SEP ||
         'ar16'                          || UNAPIRA.P_SEP ||
         'ar17'                          || UNAPIRA.P_SEP ||
         'ar18'                          || UNAPIRA.P_SEP ||
         'ar19'                          || UNAPIRA.P_SEP ||
         'ar20'                          || UNAPIRA.P_SEP ||
         'ar21'                          || UNAPIRA.P_SEP ||
         'ar22'                          || UNAPIRA.P_SEP ||
         'ar23'                          || UNAPIRA.P_SEP ||
         'ar24'                          || UNAPIRA.P_SEP ||
         'ar25'                          || UNAPIRA.P_SEP ||
         'ar26'                          || UNAPIRA.P_SEP ||
         'ar27'                          || UNAPIRA.P_SEP ||
         'ar28'                          || UNAPIRA.P_SEP ||
         'ar29'                          || UNAPIRA.P_SEP ||
         'ar30'                          || UNAPIRA.P_SEP ||
         'ar31'                          || UNAPIRA.P_SEP ||
         'ar32'                          || UNAPIRA.P_SEP ||
         'ar33'                          || UNAPIRA.P_SEP ||
         'ar34'                          || UNAPIRA.P_SEP ||
         'ar35'                          || UNAPIRA.P_SEP ||
         'ar36'                          || UNAPIRA.P_SEP ||
         'ar37'                          || UNAPIRA.P_SEP ||
         'ar38'                          || UNAPIRA.P_SEP ||
         'ar39'                          || UNAPIRA.P_SEP ||
         'ar40'                          || UNAPIRA.P_SEP ||
         'ar41'                          || UNAPIRA.P_SEP ||
         'ar42'                          || UNAPIRA.P_SEP ||
         'ar43'                          || UNAPIRA.P_SEP ||
         'ar44'                          || UNAPIRA.P_SEP ||
         'ar45'                          || UNAPIRA.P_SEP ||
         'ar46'                          || UNAPIRA.P_SEP ||
         'ar47'                          || UNAPIRA.P_SEP ||
         'ar48'                          || UNAPIRA.P_SEP ||
         'ar49'                          || UNAPIRA.P_SEP ||
         'ar50'                          || UNAPIRA.P_SEP ||
         'ar51'                          || UNAPIRA.P_SEP ||
         'ar52'                          || UNAPIRA.P_SEP ||
         'ar53'                          || UNAPIRA.P_SEP ||
         'ar54'                          || UNAPIRA.P_SEP ||
         'ar55'                          || UNAPIRA.P_SEP ||
         'ar56'                          || UNAPIRA.P_SEP ||
         'ar57'                          || UNAPIRA.P_SEP ||
         'ar58'                          || UNAPIRA.P_SEP ||
         'ar59'                          || UNAPIRA.P_SEP ||
         'ar60'                          || UNAPIRA.P_SEP ||
         'ar61'                          || UNAPIRA.P_SEP ||
         'ar62'                          || UNAPIRA.P_SEP ||
         'ar63'                          || UNAPIRA.P_SEP ||
         'ar64'                          || UNAPIRA.P_SEP ||
         'ar65'                          || UNAPIRA.P_SEP ||
         'ar66'                          || UNAPIRA.P_SEP ||
         'ar67'                          || UNAPIRA.P_SEP ||
         'ar68'                          || UNAPIRA.P_SEP ||
         'ar69'                          || UNAPIRA.P_SEP ||
         'ar70'                          || UNAPIRA.P_SEP ||
         'ar71'                          || UNAPIRA.P_SEP ||
         'ar72'                          || UNAPIRA.P_SEP ||
         'ar73'                          || UNAPIRA.P_SEP ||
         'ar74'                          || UNAPIRA.P_SEP ||
         'ar75'                          || UNAPIRA.P_SEP ||
         'ar76'                          || UNAPIRA.P_SEP ||
         'ar77'                          || UNAPIRA.P_SEP ||
         'ar78'                          || UNAPIRA.P_SEP ||
         'ar79'                          || UNAPIRA.P_SEP ||
         'ar80'                          || UNAPIRA.P_SEP ||
         'ar81'                          || UNAPIRA.P_SEP ||
         'ar82'                          || UNAPIRA.P_SEP ||
         'ar83'                          || UNAPIRA.P_SEP ||
         'ar84'                          || UNAPIRA.P_SEP ||
         'ar85'                          || UNAPIRA.P_SEP ||
         'ar86'                          || UNAPIRA.P_SEP ||
         'ar87'                          || UNAPIRA.P_SEP ||
         'ar88'                          || UNAPIRA.P_SEP ||
         'ar89'                          || UNAPIRA.P_SEP ||
         'ar90'                          || UNAPIRA.P_SEP ||
         'ar91'                          || UNAPIRA.P_SEP ||
         'ar92'                          || UNAPIRA.P_SEP ||
         'ar93'                          || UNAPIRA.P_SEP ||
         'ar94'                          || UNAPIRA.P_SEP ||
         'ar95'                          || UNAPIRA.P_SEP ||
         'ar96'                          || UNAPIRA.P_SEP ||
         'ar97'                          || UNAPIRA.P_SEP ||
         'ar98'                          || UNAPIRA.P_SEP ||
         'ar99'                          || UNAPIRA.P_SEP ||
         'ar100'                         || UNAPIRA.P_SEP ||
         'ar101'                         || UNAPIRA.P_SEP ||
         'ar102'                         || UNAPIRA.P_SEP ||
         'ar103'                         || UNAPIRA.P_SEP ||
         'ar104'                         || UNAPIRA.P_SEP ||
         'ar105'                         || UNAPIRA.P_SEP ||
         'ar106'                         || UNAPIRA.P_SEP ||
         'ar107'                         || UNAPIRA.P_SEP ||
         'ar108'                         || UNAPIRA.P_SEP ||
         'ar109'                         || UNAPIRA.P_SEP ||
         'ar110'                         || UNAPIRA.P_SEP ||
         'ar111'                         || UNAPIRA.P_SEP ||
         'ar112'                         || UNAPIRA.P_SEP ||
         'ar113'                         || UNAPIRA.P_SEP ||
         'ar114'                         || UNAPIRA.P_SEP ||
         'ar115'                         || UNAPIRA.P_SEP ||
         'ar116'                         || UNAPIRA.P_SEP ||
         'ar117'                         || UNAPIRA.P_SEP ||
         'ar118'                         || UNAPIRA.P_SEP ||
         'ar119'                         || UNAPIRA.P_SEP ||
         'ar120'                         || UNAPIRA.P_SEP ||
         'ar121'                         || UNAPIRA.P_SEP ||
         'ar122'                         || UNAPIRA.P_SEP ||
         'ar123'                         || UNAPIRA.P_SEP ||
         'ar124'                         || UNAPIRA.P_SEP ||
         'ar125'                         || UNAPIRA.P_SEP ||
         'ar126'                         || UNAPIRA.P_SEP ||
         'ar127'                         || UNAPIRA.P_SEP ||
         'ar128'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'uteqau'                             || UNAPIRA.P_SEP ||
         'eq'                            || UNAPIRA.P_SEP ||
         'lab'                           || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'uteqca'                             || UNAPIRA.P_SEP ||
         'eq'                            || UNAPIRA.P_SEP ||
         'lab'                           || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'ca'                            || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'sop'                           || UNAPIRA.P_SEP ||
         'sop_version'                   || UNAPIRA.P_SEP ||
         'st'                            || UNAPIRA.P_SEP ||
         'st_version'                    || UNAPIRA.P_SEP ||
         'mt'                            || UNAPIRA.P_SEP ||
         'mt_version'                    || UNAPIRA.P_SEP ||
         'cal_val'                       || UNAPIRA.P_SEP ||
         'cal_cost'                      || UNAPIRA.P_SEP ||
         'cal_time_val'                  || UNAPIRA.P_SEP ||
         'cal_time_unit'                 || UNAPIRA.P_SEP ||
         'freq_tp'                       || UNAPIRA.P_SEP ||
         'freq_val'                      || UNAPIRA.P_SEP ||
         'freq_unit'                     || UNAPIRA.P_SEP ||
         'invert_freq'                   || UNAPIRA.P_SEP ||
         'last_sched'                    || UNAPIRA.P_SEP ||
         'last_sched_tz'                 || UNAPIRA.P_SEP ||
         'last_val'                      || UNAPIRA.P_SEP ||
         'last_cnt'                      || UNAPIRA.P_SEP ||
         'suspend'                       || UNAPIRA.P_SEP ||
         'grace_val'                     || UNAPIRA.P_SEP ||
         'grace_unit'                    || UNAPIRA.P_SEP ||
         'sc'                            || UNAPIRA.P_SEP ||
         'pg'                            || UNAPIRA.P_SEP ||
         'pgnode'                        || UNAPIRA.P_SEP ||
         'pa'                            || UNAPIRA.P_SEP ||
         'panode'                        || UNAPIRA.P_SEP ||
         'me'                            || UNAPIRA.P_SEP ||
         'menode'                        || UNAPIRA.P_SEP ||
         'ca_warn_level'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'uteqcd'                             || UNAPIRA.P_SEP ||
         'eq'                            || UNAPIRA.P_SEP ||
         'lab'                           || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'cd'                            || UNAPIRA.P_SEP ||
         'setting_name'                  || UNAPIRA.P_SEP ||
         'setting_value'                 || UNAPIRA.P_SEP ||
         'setting_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'uteqct'                             || UNAPIRA.P_SEP ||
         'eq'                            || UNAPIRA.P_SEP ||
         'lab'                           || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'ct_name'                       || UNAPIRA.P_SEP ||
         'ca'                            || UNAPIRA.P_SEP ||
         'value_s'                       || UNAPIRA.P_SEP ||
         'value_f'                       || UNAPIRA.P_SEP ||
         'format'                        || UNAPIRA.P_SEP ||
         'unit'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'uteqhs'                             || UNAPIRA.P_SEP ||
         'eq'                            || UNAPIRA.P_SEP ||
         'lab'                           || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'uteqmr'                             || UNAPIRA.P_SEP ||
         'eq'                            || UNAPIRA.P_SEP ||
         'lab'                           || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'component'                     || UNAPIRA.P_SEP ||
         'l_detection_limit'             || UNAPIRA.P_SEP ||
         'l_determ_limit'                || UNAPIRA.P_SEP ||
         'h_determ_limit'                || UNAPIRA.P_SEP ||
         'h_detection_limit'             || UNAPIRA.P_SEP ||
         'unit'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'uteqcyct'                           || UNAPIRA.P_SEP ||
         'eq'                            || UNAPIRA.P_SEP ||
         'lab'                           || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'cy'                            || UNAPIRA.P_SEP ||
         'cy_version'                    || UNAPIRA.P_SEP ||
         'ct_name'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'uteqtype'                           || UNAPIRA.P_SEP ||
         'eq'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'lab'                           || UNAPIRA.P_SEP ||
         'eq_tp'                         || UNAPIRA.P_SEP ||
         'seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'uteqcalog'                          || UNAPIRA.P_SEP ||
         'eq'                            || UNAPIRA.P_SEP ||
         'lab'                           || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'ca'                            || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'sc'                            || UNAPIRA.P_SEP ||
         'pg'                            || UNAPIRA.P_SEP ||
         'pgnode'                        || UNAPIRA.P_SEP ||
         'pa'                            || UNAPIRA.P_SEP ||
         'panode'                        || UNAPIRA.P_SEP ||
         'me'                            || UNAPIRA.P_SEP ||
         'menode'                        || UNAPIRA.P_SEP ||
         'ca_warn_level'                 || UNAPIRA.P_SEP ||
         'why'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'uteqctold'                          || UNAPIRA.P_SEP ||
         'eq'                            || UNAPIRA.P_SEP ||
         'lab'                           || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'exec_start_date'               || UNAPIRA.P_SEP ||
         'exec_start_date_tz'            || UNAPIRA.P_SEP ||
         'ct_name'                       || UNAPIRA.P_SEP ||
         'ca'                            || UNAPIRA.P_SEP ||
         'value_s'                       || UNAPIRA.P_SEP ||
         'value_f'                       || UNAPIRA.P_SEP ||
         'format'                        || UNAPIRA.P_SEP ||
         'unit'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'uteqhsdetails'                      || UNAPIRA.P_SEP ||
         'eq'                            || UNAPIRA.P_SEP ||
         'lab'                           || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utel'                               || UNAPIRA.P_SEP ||
         'el'                            || UNAPIRA.P_SEP ||
         'descr_doc'                     || UNAPIRA.P_SEP ||
         'descr_doc_version'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utdd'                               || UNAPIRA.P_SEP ||
         'dd'                            || UNAPIRA.P_SEP ||
         'description'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utdc'                               || UNAPIRA.P_SEP ||
         'dc'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'creation_date'                 || UNAPIRA.P_SEP ||
         'creation_date_tz'              || UNAPIRA.P_SEP ||
         'created_by'                    || UNAPIRA.P_SEP ||
         'last_modified'                 || UNAPIRA.P_SEP ||
         'last_modified_tz'              || UNAPIRA.P_SEP ||
         'tooltip'                       || UNAPIRA.P_SEP ||
         'url'                           || UNAPIRA.P_SEP ||
         'data'                          || UNAPIRA.P_SEP ||
         'last_checkout_by'              || UNAPIRA.P_SEP ||
         'last_checkout_url'             || UNAPIRA.P_SEP ||
         'checked_out'                   || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'dc_class'                      || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'                            || UNAPIRA.P_SEP ||
         'ar1'                           || UNAPIRA.P_SEP ||
         'ar2'                           || UNAPIRA.P_SEP ||
         'ar3'                           || UNAPIRA.P_SEP ||
         'ar4'                           || UNAPIRA.P_SEP ||
         'ar5'                           || UNAPIRA.P_SEP ||
         'ar6'                           || UNAPIRA.P_SEP ||
         'ar7'                           || UNAPIRA.P_SEP ||
         'ar8'                           || UNAPIRA.P_SEP ||
         'ar9'                           || UNAPIRA.P_SEP ||
         'ar10'                          || UNAPIRA.P_SEP ||
         'ar11'                          || UNAPIRA.P_SEP ||
         'ar12'                          || UNAPIRA.P_SEP ||
         'ar13'                          || UNAPIRA.P_SEP ||
         'ar14'                          || UNAPIRA.P_SEP ||
         'ar15'                          || UNAPIRA.P_SEP ||
         'ar16'                          || UNAPIRA.P_SEP ||
         'ar17'                          || UNAPIRA.P_SEP ||
         'ar18'                          || UNAPIRA.P_SEP ||
         'ar19'                          || UNAPIRA.P_SEP ||
         'ar20'                          || UNAPIRA.P_SEP ||
         'ar21'                          || UNAPIRA.P_SEP ||
         'ar22'                          || UNAPIRA.P_SEP ||
         'ar23'                          || UNAPIRA.P_SEP ||
         'ar24'                          || UNAPIRA.P_SEP ||
         'ar25'                          || UNAPIRA.P_SEP ||
         'ar26'                          || UNAPIRA.P_SEP ||
         'ar27'                          || UNAPIRA.P_SEP ||
         'ar28'                          || UNAPIRA.P_SEP ||
         'ar29'                          || UNAPIRA.P_SEP ||
         'ar30'                          || UNAPIRA.P_SEP ||
         'ar31'                          || UNAPIRA.P_SEP ||
         'ar32'                          || UNAPIRA.P_SEP ||
         'ar33'                          || UNAPIRA.P_SEP ||
         'ar34'                          || UNAPIRA.P_SEP ||
         'ar35'                          || UNAPIRA.P_SEP ||
         'ar36'                          || UNAPIRA.P_SEP ||
         'ar37'                          || UNAPIRA.P_SEP ||
         'ar38'                          || UNAPIRA.P_SEP ||
         'ar39'                          || UNAPIRA.P_SEP ||
         'ar40'                          || UNAPIRA.P_SEP ||
         'ar41'                          || UNAPIRA.P_SEP ||
         'ar42'                          || UNAPIRA.P_SEP ||
         'ar43'                          || UNAPIRA.P_SEP ||
         'ar44'                          || UNAPIRA.P_SEP ||
         'ar45'                          || UNAPIRA.P_SEP ||
         'ar46'                          || UNAPIRA.P_SEP ||
         'ar47'                          || UNAPIRA.P_SEP ||
         'ar48'                          || UNAPIRA.P_SEP ||
         'ar49'                          || UNAPIRA.P_SEP ||
         'ar50'                          || UNAPIRA.P_SEP ||
         'ar51'                          || UNAPIRA.P_SEP ||
         'ar52'                          || UNAPIRA.P_SEP ||
         'ar53'                          || UNAPIRA.P_SEP ||
         'ar54'                          || UNAPIRA.P_SEP ||
         'ar55'                          || UNAPIRA.P_SEP ||
         'ar56'                          || UNAPIRA.P_SEP ||
         'ar57'                          || UNAPIRA.P_SEP ||
         'ar58'                          || UNAPIRA.P_SEP ||
         'ar59'                          || UNAPIRA.P_SEP ||
         'ar60'                          || UNAPIRA.P_SEP ||
         'ar61'                          || UNAPIRA.P_SEP ||
         'ar62'                          || UNAPIRA.P_SEP ||
         'ar63'                          || UNAPIRA.P_SEP ||
         'ar64'                          || UNAPIRA.P_SEP ||
         'ar65'                          || UNAPIRA.P_SEP ||
         'ar66'                          || UNAPIRA.P_SEP ||
         'ar67'                          || UNAPIRA.P_SEP ||
         'ar68'                          || UNAPIRA.P_SEP ||
         'ar69'                          || UNAPIRA.P_SEP ||
         'ar70'                          || UNAPIRA.P_SEP ||
         'ar71'                          || UNAPIRA.P_SEP ||
         'ar72'                          || UNAPIRA.P_SEP ||
         'ar73'                          || UNAPIRA.P_SEP ||
         'ar74'                          || UNAPIRA.P_SEP ||
         'ar75'                          || UNAPIRA.P_SEP ||
         'ar76'                          || UNAPIRA.P_SEP ||
         'ar77'                          || UNAPIRA.P_SEP ||
         'ar78'                          || UNAPIRA.P_SEP ||
         'ar79'                          || UNAPIRA.P_SEP ||
         'ar80'                          || UNAPIRA.P_SEP ||
         'ar81'                          || UNAPIRA.P_SEP ||
         'ar82'                          || UNAPIRA.P_SEP ||
         'ar83'                          || UNAPIRA.P_SEP ||
         'ar84'                          || UNAPIRA.P_SEP ||
         'ar85'                          || UNAPIRA.P_SEP ||
         'ar86'                          || UNAPIRA.P_SEP ||
         'ar87'                          || UNAPIRA.P_SEP ||
         'ar88'                          || UNAPIRA.P_SEP ||
         'ar89'                          || UNAPIRA.P_SEP ||
         'ar90'                          || UNAPIRA.P_SEP ||
         'ar91'                          || UNAPIRA.P_SEP ||
         'ar92'                          || UNAPIRA.P_SEP ||
         'ar93'                          || UNAPIRA.P_SEP ||
         'ar94'                          || UNAPIRA.P_SEP ||
         'ar95'                          || UNAPIRA.P_SEP ||
         'ar96'                          || UNAPIRA.P_SEP ||
         'ar97'                          || UNAPIRA.P_SEP ||
         'ar98'                          || UNAPIRA.P_SEP ||
         'ar99'                          || UNAPIRA.P_SEP ||
         'ar100'                         || UNAPIRA.P_SEP ||
         'ar101'                         || UNAPIRA.P_SEP ||
         'ar102'                         || UNAPIRA.P_SEP ||
         'ar103'                         || UNAPIRA.P_SEP ||
         'ar104'                         || UNAPIRA.P_SEP ||
         'ar105'                         || UNAPIRA.P_SEP ||
         'ar106'                         || UNAPIRA.P_SEP ||
         'ar107'                         || UNAPIRA.P_SEP ||
         'ar108'                         || UNAPIRA.P_SEP ||
         'ar109'                         || UNAPIRA.P_SEP ||
         'ar110'                         || UNAPIRA.P_SEP ||
         'ar111'                         || UNAPIRA.P_SEP ||
         'ar112'                         || UNAPIRA.P_SEP ||
         'ar113'                         || UNAPIRA.P_SEP ||
         'ar114'                         || UNAPIRA.P_SEP ||
         'ar115'                         || UNAPIRA.P_SEP ||
         'ar116'                         || UNAPIRA.P_SEP ||
         'ar117'                         || UNAPIRA.P_SEP ||
         'ar118'                         || UNAPIRA.P_SEP ||
         'ar119'                         || UNAPIRA.P_SEP ||
         'ar120'                         || UNAPIRA.P_SEP ||
         'ar121'                         || UNAPIRA.P_SEP ||
         'ar122'                         || UNAPIRA.P_SEP ||
         'ar123'                         || UNAPIRA.P_SEP ||
         'ar124'                         || UNAPIRA.P_SEP ||
         'ar125'                         || UNAPIRA.P_SEP ||
         'ar126'                         || UNAPIRA.P_SEP ||
         'ar127'                         || UNAPIRA.P_SEP ||
         'ar128'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utdcau'                             || UNAPIRA.P_SEP ||
         'dc'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utdchs'                             || UNAPIRA.P_SEP ||
         'dc'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utdchsdetails'                      || UNAPIRA.P_SEP ||
         'dc'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utweeknr'                           || UNAPIRA.P_SEP ||
         'day_of_year'                   || UNAPIRA.P_SEP ||
         'day_of_year_tz'                || UNAPIRA.P_SEP ||
         'day_of_week'                   || UNAPIRA.P_SEP ||
         'week_nr'                       || UNAPIRA.P_SEP ||
         'year_nr'                       || UNAPIRA.P_SEP ||
         'day_cnt'                       || UNAPIRA.P_SEP ||
         'week_cnt'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utcy'                               || UNAPIRA.P_SEP ||
         'cy'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'description2'                  || UNAPIRA.P_SEP ||
         'is_template'                   || UNAPIRA.P_SEP ||
         'chart_title'                   || UNAPIRA.P_SEP ||
         'x_axis_title'                  || UNAPIRA.P_SEP ||
         'y_axis_title'                  || UNAPIRA.P_SEP ||
         'y_axis_unit'                   || UNAPIRA.P_SEP ||
         'x_label'                       || UNAPIRA.P_SEP ||
         'datapoint_cnt'                 || UNAPIRA.P_SEP ||
         'datapoint_unit'                || UNAPIRA.P_SEP ||
         'xr_measurements'               || UNAPIRA.P_SEP ||
         'xr_max_charts'                 || UNAPIRA.P_SEP ||
         'assign_cf'                     || UNAPIRA.P_SEP ||
         'cy_calc_cf'                    || UNAPIRA.P_SEP ||
         'visual_cf'                     || UNAPIRA.P_SEP ||
         'valid_sqc_rule1'               || UNAPIRA.P_SEP ||
         'valid_sqc_rule2'               || UNAPIRA.P_SEP ||
         'valid_sqc_rule3'               || UNAPIRA.P_SEP ||
         'valid_sqc_rule4'               || UNAPIRA.P_SEP ||
         'valid_sqc_rule5'               || UNAPIRA.P_SEP ||
         'valid_sqc_rule6'               || UNAPIRA.P_SEP ||
         'valid_sqc_rule7'               || UNAPIRA.P_SEP ||
         'ch_lc'                         || UNAPIRA.P_SEP ||
         'ch_lc_version'                 || UNAPIRA.P_SEP ||
         'inherit_au'                    || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'cy_class'                      || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'                            || UNAPIRA.P_SEP ||
         'ar1'                           || UNAPIRA.P_SEP ||
         'ar2'                           || UNAPIRA.P_SEP ||
         'ar3'                           || UNAPIRA.P_SEP ||
         'ar4'                           || UNAPIRA.P_SEP ||
         'ar5'                           || UNAPIRA.P_SEP ||
         'ar6'                           || UNAPIRA.P_SEP ||
         'ar7'                           || UNAPIRA.P_SEP ||
         'ar8'                           || UNAPIRA.P_SEP ||
         'ar9'                           || UNAPIRA.P_SEP ||
         'ar10'                          || UNAPIRA.P_SEP ||
         'ar11'                          || UNAPIRA.P_SEP ||
         'ar12'                          || UNAPIRA.P_SEP ||
         'ar13'                          || UNAPIRA.P_SEP ||
         'ar14'                          || UNAPIRA.P_SEP ||
         'ar15'                          || UNAPIRA.P_SEP ||
         'ar16'                          || UNAPIRA.P_SEP ||
         'ar17'                          || UNAPIRA.P_SEP ||
         'ar18'                          || UNAPIRA.P_SEP ||
         'ar19'                          || UNAPIRA.P_SEP ||
         'ar20'                          || UNAPIRA.P_SEP ||
         'ar21'                          || UNAPIRA.P_SEP ||
         'ar22'                          || UNAPIRA.P_SEP ||
         'ar23'                          || UNAPIRA.P_SEP ||
         'ar24'                          || UNAPIRA.P_SEP ||
         'ar25'                          || UNAPIRA.P_SEP ||
         'ar26'                          || UNAPIRA.P_SEP ||
         'ar27'                          || UNAPIRA.P_SEP ||
         'ar28'                          || UNAPIRA.P_SEP ||
         'ar29'                          || UNAPIRA.P_SEP ||
         'ar30'                          || UNAPIRA.P_SEP ||
         'ar31'                          || UNAPIRA.P_SEP ||
         'ar32'                          || UNAPIRA.P_SEP ||
         'ar33'                          || UNAPIRA.P_SEP ||
         'ar34'                          || UNAPIRA.P_SEP ||
         'ar35'                          || UNAPIRA.P_SEP ||
         'ar36'                          || UNAPIRA.P_SEP ||
         'ar37'                          || UNAPIRA.P_SEP ||
         'ar38'                          || UNAPIRA.P_SEP ||
         'ar39'                          || UNAPIRA.P_SEP ||
         'ar40'                          || UNAPIRA.P_SEP ||
         'ar41'                          || UNAPIRA.P_SEP ||
         'ar42'                          || UNAPIRA.P_SEP ||
         'ar43'                          || UNAPIRA.P_SEP ||
         'ar44'                          || UNAPIRA.P_SEP ||
         'ar45'                          || UNAPIRA.P_SEP ||
         'ar46'                          || UNAPIRA.P_SEP ||
         'ar47'                          || UNAPIRA.P_SEP ||
         'ar48'                          || UNAPIRA.P_SEP ||
         'ar49'                          || UNAPIRA.P_SEP ||
         'ar50'                          || UNAPIRA.P_SEP ||
         'ar51'                          || UNAPIRA.P_SEP ||
         'ar52'                          || UNAPIRA.P_SEP ||
         'ar53'                          || UNAPIRA.P_SEP ||
         'ar54'                          || UNAPIRA.P_SEP ||
         'ar55'                          || UNAPIRA.P_SEP ||
         'ar56'                          || UNAPIRA.P_SEP ||
         'ar57'                          || UNAPIRA.P_SEP ||
         'ar58'                          || UNAPIRA.P_SEP ||
         'ar59'                          || UNAPIRA.P_SEP ||
         'ar60'                          || UNAPIRA.P_SEP ||
         'ar61'                          || UNAPIRA.P_SEP ||
         'ar62'                          || UNAPIRA.P_SEP ||
         'ar63'                          || UNAPIRA.P_SEP ||
         'ar64'                          || UNAPIRA.P_SEP ||
         'ar65'                          || UNAPIRA.P_SEP ||
         'ar66'                          || UNAPIRA.P_SEP ||
         'ar67'                          || UNAPIRA.P_SEP ||
         'ar68'                          || UNAPIRA.P_SEP ||
         'ar69'                          || UNAPIRA.P_SEP ||
         'ar70'                          || UNAPIRA.P_SEP ||
         'ar71'                          || UNAPIRA.P_SEP ||
         'ar72'                          || UNAPIRA.P_SEP ||
         'ar73'                          || UNAPIRA.P_SEP ||
         'ar74'                          || UNAPIRA.P_SEP ||
         'ar75'                          || UNAPIRA.P_SEP ||
         'ar76'                          || UNAPIRA.P_SEP ||
         'ar77'                          || UNAPIRA.P_SEP ||
         'ar78'                          || UNAPIRA.P_SEP ||
         'ar79'                          || UNAPIRA.P_SEP ||
         'ar80'                          || UNAPIRA.P_SEP ||
         'ar81'                          || UNAPIRA.P_SEP ||
         'ar82'                          || UNAPIRA.P_SEP ||
         'ar83'                          || UNAPIRA.P_SEP ||
         'ar84'                          || UNAPIRA.P_SEP ||
         'ar85'                          || UNAPIRA.P_SEP ||
         'ar86'                          || UNAPIRA.P_SEP ||
         'ar87'                          || UNAPIRA.P_SEP ||
         'ar88'                          || UNAPIRA.P_SEP ||
         'ar89'                          || UNAPIRA.P_SEP ||
         'ar90'                          || UNAPIRA.P_SEP ||
         'ar91'                          || UNAPIRA.P_SEP ||
         'ar92'                          || UNAPIRA.P_SEP ||
         'ar93'                          || UNAPIRA.P_SEP ||
         'ar94'                          || UNAPIRA.P_SEP ||
         'ar95'                          || UNAPIRA.P_SEP ||
         'ar96'                          || UNAPIRA.P_SEP ||
         'ar97'                          || UNAPIRA.P_SEP ||
         'ar98'                          || UNAPIRA.P_SEP ||
         'ar99'                          || UNAPIRA.P_SEP ||
         'ar100'                         || UNAPIRA.P_SEP ||
         'ar101'                         || UNAPIRA.P_SEP ||
         'ar102'                         || UNAPIRA.P_SEP ||
         'ar103'                         || UNAPIRA.P_SEP ||
         'ar104'                         || UNAPIRA.P_SEP ||
         'ar105'                         || UNAPIRA.P_SEP ||
         'ar106'                         || UNAPIRA.P_SEP ||
         'ar107'                         || UNAPIRA.P_SEP ||
         'ar108'                         || UNAPIRA.P_SEP ||
         'ar109'                         || UNAPIRA.P_SEP ||
         'ar110'                         || UNAPIRA.P_SEP ||
         'ar111'                         || UNAPIRA.P_SEP ||
         'ar112'                         || UNAPIRA.P_SEP ||
         'ar113'                         || UNAPIRA.P_SEP ||
         'ar114'                         || UNAPIRA.P_SEP ||
         'ar115'                         || UNAPIRA.P_SEP ||
         'ar116'                         || UNAPIRA.P_SEP ||
         'ar117'                         || UNAPIRA.P_SEP ||
         'ar118'                         || UNAPIRA.P_SEP ||
         'ar119'                         || UNAPIRA.P_SEP ||
         'ar120'                         || UNAPIRA.P_SEP ||
         'ar121'                         || UNAPIRA.P_SEP ||
         'ar122'                         || UNAPIRA.P_SEP ||
         'ar123'                         || UNAPIRA.P_SEP ||
         'ar124'                         || UNAPIRA.P_SEP ||
         'ar125'                         || UNAPIRA.P_SEP ||
         'ar126'                         || UNAPIRA.P_SEP ||
         'ar127'                         || UNAPIRA.P_SEP ||
         'ar128'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utcyau'                             || UNAPIRA.P_SEP ||
         'cy'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utcyhs'                             || UNAPIRA.P_SEP ||
         'cy'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utcyhsdetails'                      || UNAPIRA.P_SEP ||
         'cy'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utcurrency'                         || UNAPIRA.P_SEP ||
         'currency'                      || UNAPIRA.P_SEP ||
         'is_default'                    || UNAPIRA.P_SEP ||
         'rounding'                      || UNAPIRA.P_SEP ||
         'conversion'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utcs'                               || UNAPIRA.P_SEP ||
         'cs'                            || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'description2'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utcsau'                             || UNAPIRA.P_SEP ||
         'cs'                            || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utcscn'                             || UNAPIRA.P_SEP ||
         'cs'                            || UNAPIRA.P_SEP ||
         'cn'                            || UNAPIRA.P_SEP ||
         'cnseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utcounter'                          || UNAPIRA.P_SEP ||
         'counter'                       || UNAPIRA.P_SEP ||
         'curr_cnt'                      || UNAPIRA.P_SEP ||
         'low_cnt'                       || UNAPIRA.P_SEP ||
         'high_cnt'                      || UNAPIRA.P_SEP ||
         'incr_cnt'                      || UNAPIRA.P_SEP ||
         'fixed_length'                  || UNAPIRA.P_SEP ||
         'circular'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utuicomponent'                      || UNAPIRA.P_SEP ||
         'component_tp'                  || UNAPIRA.P_SEP ||
         'component_id'                  || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'col_tp'                        || UNAPIRA.P_SEP ||
         'disp_title'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utcomment'                          || UNAPIRA.P_SEP ||
         'comment_group'                 || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'std_comment'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utotdetails'                        || UNAPIRA.P_SEP ||
         'col_tp'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'col_id'                        || UNAPIRA.P_SEP ||
         'col_len'                       || UNAPIRA.P_SEP ||
         'disp_tp'                       || UNAPIRA.P_SEP ||
         'disp_title'                    || UNAPIRA.P_SEP ||
         'disp_style'                    || UNAPIRA.P_SEP ||
         'disp_width'                    || UNAPIRA.P_SEP ||
         'disp_format'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utdecode'                           || UNAPIRA.P_SEP ||
         'code_tp'                       || UNAPIRA.P_SEP ||
         'code'                          || UNAPIRA.P_SEP ||
         'description1'                  || UNAPIRA.P_SEP ||
         'description2'                  || UNAPIRA.P_SEP ||
         'description3'                  || UNAPIRA.P_SEP ||
         'description4'                  || UNAPIRA.P_SEP ||
         'description5'                  || UNAPIRA.P_SEP ||
         'description6'                  || UNAPIRA.P_SEP ||
         'description7'                  || UNAPIRA.P_SEP ||
         'description8'                  || UNAPIRA.P_SEP ||
         'description9'                  || UNAPIRA.P_SEP ||
         'description10'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utjournallog'                       || UNAPIRA.P_SEP ||
         'client_id'                     || UNAPIRA.P_SEP ||
         'applic'                        || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'journal_nr'                    || UNAPIRA.P_SEP ||
         'error_level'                   || UNAPIRA.P_SEP ||
         'error_msg'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utcd'                               || UNAPIRA.P_SEP ||
         'cd'                            || UNAPIRA.P_SEP ||
         'setting_name'                  || UNAPIRA.P_SEP ||
         'setting_value'                 || UNAPIRA.P_SEP ||
         'setting_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utcatalogueid'                      || UNAPIRA.P_SEP ||
         'catalogue'                     || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'catalogue_type'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utcataloguedetails'                 || UNAPIRA.P_SEP ||
         'catalogue'                     || UNAPIRA.P_SEP ||
         'from_date'                     || UNAPIRA.P_SEP ||
         'from_date_tz'                  || UNAPIRA.P_SEP ||
         'to_date'                       || UNAPIRA.P_SEP ||
         'to_date_tz'                    || UNAPIRA.P_SEP ||
         'seq_nr'                        || UNAPIRA.P_SEP ||
         'object_tp'                     || UNAPIRA.P_SEP ||
         'object_id'                     || UNAPIRA.P_SEP ||
         'object_version'                || UNAPIRA.P_SEP ||
         'pp_key1'                       || UNAPIRA.P_SEP ||
         'pp_key2'                       || UNAPIRA.P_SEP ||
         'pp_key3'                       || UNAPIRA.P_SEP ||
         'pp_key4'                       || UNAPIRA.P_SEP ||
         'pp_key5'                       || UNAPIRA.P_SEP ||
         'criterium1'                    || UNAPIRA.P_SEP ||
         'criterium2'                    || UNAPIRA.P_SEP ||
         'criterium3'                    || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'input_price'                   || UNAPIRA.P_SEP ||
         'input_curr'                    || UNAPIRA.P_SEP ||
         'disc_abs'                      || UNAPIRA.P_SEP ||
         'disc_rel'                      || UNAPIRA.P_SEP ||
         'calc_disc'                     || UNAPIRA.P_SEP ||
         'net_price'                     || UNAPIRA.P_SEP ||
         'ac_code'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utau'                               || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'description2'                  || UNAPIRA.P_SEP ||
         'is_protected'                  || UNAPIRA.P_SEP ||
         'single_valued'                 || UNAPIRA.P_SEP ||
         'new_val_allowed'               || UNAPIRA.P_SEP ||
         'store_db'                      || UNAPIRA.P_SEP ||
         'inherit_au'                    || UNAPIRA.P_SEP ||
         'shortcut'                      || UNAPIRA.P_SEP ||
         'value_list_tp'                 || UNAPIRA.P_SEP ||
         'default_value'                 || UNAPIRA.P_SEP ||
         'run_mode'                      || UNAPIRA.P_SEP ||
         'service'                       || UNAPIRA.P_SEP ||
         'cf_value'                      || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'au_class'                      || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utauhs'                             || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utausql'                            || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'sqltext'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utaulist'                           || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utauhsdetails'                      || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utfa'                               || UNAPIRA.P_SEP ||
         'applic'                        || UNAPIRA.P_SEP ||
         'description'                   || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'topic'                         || UNAPIRA.P_SEP ||
         'topic_description'             || UNAPIRA.P_SEP ||
         'fa'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utapplic'                           || UNAPIRA.P_SEP ||
         'applic'                        || UNAPIRA.P_SEP ||
         'description'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utprintcmds'                        || UNAPIRA.P_SEP ||
         'applic'                        || UNAPIRA.P_SEP ||
         'window'                        || UNAPIRA.P_SEP ||
         'print_curr_layout'             || UNAPIRA.P_SEP ||
         'print_full_details'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utad'                               || UNAPIRA.P_SEP ||
         'ad'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'version_is_current'            || UNAPIRA.P_SEP ||
         'effective_from'                || UNAPIRA.P_SEP ||
         'effective_from_tz'             || UNAPIRA.P_SEP ||
         'effective_till'                || UNAPIRA.P_SEP ||
         'effective_till_tz'             || UNAPIRA.P_SEP ||
         'is_template'                   || UNAPIRA.P_SEP ||
         'is_user'                       || UNAPIRA.P_SEP ||
         'struct_created'                || UNAPIRA.P_SEP ||
         'ad_tp'                         || UNAPIRA.P_SEP ||
         'person'                        || UNAPIRA.P_SEP ||
         'title'                         || UNAPIRA.P_SEP ||
         'function_name'                 || UNAPIRA.P_SEP ||
         'def_up'                        || UNAPIRA.P_SEP ||
         'company'                       || UNAPIRA.P_SEP ||
         'street'                        || UNAPIRA.P_SEP ||
         'city'                          || UNAPIRA.P_SEP ||
         'state'                         || UNAPIRA.P_SEP ||
         'country'                       || UNAPIRA.P_SEP ||
         'ad_nr'                         || UNAPIRA.P_SEP ||
         'po_box'                        || UNAPIRA.P_SEP ||
         'zip_code'                      || UNAPIRA.P_SEP ||
         'phone_nr'                      || UNAPIRA.P_SEP ||
         'ext_nr'                        || UNAPIRA.P_SEP ||
         'fax_nr'                        || UNAPIRA.P_SEP ||
         'email'                         || UNAPIRA.P_SEP ||
         'last_comment'                  || UNAPIRA.P_SEP ||
         'ad_class'                      || UNAPIRA.P_SEP ||
         'log_hs'                        || UNAPIRA.P_SEP ||
         'log_hs_details'                || UNAPIRA.P_SEP ||
         'allow_modify'                  || UNAPIRA.P_SEP ||
         'active'                        || UNAPIRA.P_SEP ||
         'lc'                            || UNAPIRA.P_SEP ||
         'lc_version'                    || UNAPIRA.P_SEP ||
         'ss'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utadau'                             || UNAPIRA.P_SEP ||
         'ad'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'au'                            || UNAPIRA.P_SEP ||
         'au_version'                    || UNAPIRA.P_SEP ||
         'auseq'                         || UNAPIRA.P_SEP ||
         'value'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utadhs'                             || UNAPIRA.P_SEP ||
         'ad'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'who'                           || UNAPIRA.P_SEP ||
         'who_description'               || UNAPIRA.P_SEP ||
         'what'                          || UNAPIRA.P_SEP ||
         'what_description'              || UNAPIRA.P_SEP ||
         'logdate'                       || UNAPIRA.P_SEP ||
         'logdate_tz'                    || UNAPIRA.P_SEP ||
         'why'                           || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'
      ,'0');

   UNAPIRA3.U4DATAPUTLINE(
      'utadhsdetails'                      || UNAPIRA.P_SEP ||
         'ad'                            || UNAPIRA.P_SEP ||
         'version'                       || UNAPIRA.P_SEP ||
         'tr_seq'                        || UNAPIRA.P_SEP ||
         'ev_seq'                        || UNAPIRA.P_SEP ||
         'seq'                           || UNAPIRA.P_SEP ||
         'details'
      ,'0');

END WRITECONFIGURATIONSTRUCTURES;
END UNAPIRACO;
create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.3.0 $
-- $Date: 2007-02-22T14:44:00 $
uncostcalc AS

-- Main procedure
PROCEDURE CalcJournalDetails
(a_nr_of_rq           IN     NUMBER,
 a_rq_in_tab          IN     UNAPIGEN.VC20_TABLE_TYPE,
 a_inv_reanal         IN     CHAR,      -- flag reanalysis should be taken into account
 a_journal_nr         IN     VARCHAR2,
 a_description        IN     VARCHAR2,  -- NOT USED
 a_currency           IN     VARCHAR2,
 a_currency2          IN     VARCHAR2,  -- NOT USED
 a_journal_tp         IN     VARCHAR2,
 a_journal_ss         IN     VARCHAR2,  -- NOT USED
 a_calc_tp            IN     VARCHAR2,
 a_total1             IN OUT FLOAT,
 a_total2             IN OUT FLOAT,
 a_disc_abs1          IN OUT NUMBER,
 a_disc_abs2          IN OUT NUMBER,
 a_disc_rel           IN OUT NUMBER,
 a_grand_total1       IN OUT FLOAT,
 a_grand_total2       IN OUT FLOAT,
 a_tax1               IN OUT NUMBER,
 a_tax2               IN OUT NUMBER,
 a_tax_rel            IN OUT NUMBER,
 a_grand_total_at1    IN OUT FLOAT,
 a_grand_total_at2    IN OUT FLOAT,
 a_active             IN     CHAR,
 a_allow_modify       IN     CHAR,
 a_invoiced           IN     CHAR,  -- NOT USED
 a_invoiced_on        IN     DATE,  -- NOT USED
 a_date1              IN     DATE,  -- NOT USED
 a_date2              IN     DATE,  -- NOT USED
 a_date3              IN     DATE,  -- NOT USED
 a_last_updated       IN OUT DATE,
 a_who                IN OUT VARCHAR2,  -- NOT USED
 a_comments           IN OUT VARCHAR2,  -- NOT USED
 a_nr_of_rows         OUT    NUMBER,
 a_errorcode          OUT    NUMBER)
IS
   -- Standard variables
   b_newline                 BOOLEAN;
   d_date                    TIMESTAMP WITH TIME ZONE;
   d_rq_exec_end_date        TIMESTAMP WITH TIME ZONE;
   vc2_rt                    VARCHAR2(20);
   vc2_rt_version            VARCHAR2(20);
   vc2_st                    VARCHAR2(20);
   vc2_st_version            VARCHAR2(20);
   vc2_rq                    VARCHAR2(20);
   vc2_sc                    VARCHAR2(20);
   vc2_pg                    VARCHAR2(20);
   vc2_pa                    VARCHAR2(20);
   vc2_me                    VARCHAR2(20);
   vc2_pp_version            VARCHAR2(20);
   vc2_pr_version            VARCHAR2(20);
   vc2_mt_version            VARCHAR2(20);
   vc2_pp_key1               VARCHAR2(20);
   vc2_pp_key2               VARCHAR2(20);
   vc2_pp_key3               VARCHAR2(20);
   vc2_pp_key4               VARCHAR2(20);
   vc2_pp_key5               VARCHAR2(20);
   vc2_rt_desc               VARCHAR2(40);
   vc2_crit1                 VARCHAR2(40);
   vc2_crit2                 VARCHAR2(40);
   vc2_crit3                 VARCHAR2(40);
   vc2_sqlerrm               VARCHAR2(255);
   vc2_errormsg              VARCHAR2(255);
   vc2_description           VARCHAR2(255);
   vc2_obj_desc              VARCHAR2(255);
   vc2_currency              VARCHAR2(20);
   vc2_ac_code               VARCHAR2(20);
   vc2_key                   VARCHAR2(255);
   vc2_def_currency          VARCHAR2(20);
   vc2_def_rounding          VARCHAR2(20);
   n_pgnode                  NUMBER;
   n_panode                  NUMBER;
   n_menode                  NUMBER;
   n_reanalysis              NUMBER;
   n_rt_catalogue            NUMBER;
   n_st_catalogue            NUMBER;
   n_pp_catalogue            NUMBER;
   n_pr_catalogue            NUMBER;
   n_mt_catalogue            NUMBER;
   n_disc_abs                NUMBER;
   n_disc_rel                NUMBER;
   n_nr_of_crit              NUMBER;
   tmp_nr_of_rows            NUMBER;
   f_input_price             FLOAT;
   f_calc_disc               FLOAT;
   f_net_price               FLOAT;
   f_def_conversion          FLOAT;
   f_conversion              FLOAT;
   i_row                     INTEGER;
   i_row2                    INTEGER;
   i_row3                    INTEGER;
   vc2_rq_ss                 utsc.ss%TYPE;
   vc2_critval_tab           UNAPIGEN.VC40_TABLE_TYPE;
   n_cat_tab                 UNAPIGEN.NUM_TABLE_TYPE;
   n_crit_tab                UNAPIGEN.NUM_TABLE_TYPE;
   tmp_object_tp_tab         UNAPIGEN.VC20_TABLE_TYPE;
   tmp_object_version_tab    UNAPIGEN.VC20_TABLE_TYPE;
   tmp_pp_key1_tab            UNAPIGEN.VC20_TABLE_TYPE;
   tmp_pp_key2_tab            UNAPIGEN.VC20_TABLE_TYPE;
   tmp_pp_key3_tab            UNAPIGEN.VC20_TABLE_TYPE;
   tmp_pp_key4_tab            UNAPIGEN.VC20_TABLE_TYPE;
   tmp_pp_key5_tab            UNAPIGEN.VC20_TABLE_TYPE;
   tmp_rq_tab                UNAPIGEN.VC20_TABLE_TYPE;
   tmp_sc_tab                UNAPIGEN.VC20_TABLE_TYPE;
   tmp_pg_tab                UNAPIGEN.VC20_TABLE_TYPE;
   tmp_pgnode_tab            UNAPIGEN.LONG_TABLE_TYPE;
   tmp_pa_tab                UNAPIGEN.VC20_TABLE_TYPE;
   tmp_panode_tab            UNAPIGEN.LONG_TABLE_TYPE;
   tmp_me_tab                UNAPIGEN.VC20_TABLE_TYPE;
   tmp_menode_tab            UNAPIGEN.LONG_TABLE_TYPE;
   tmp_reanalysis_tab        UNAPIGEN.NUM_TABLE_TYPE;
   tmp_description_tab       UNAPIGEN.VC255_TABLE_TYPE;
   tmp_qtity_tab             UNAPIGEN.NUM_TABLE_TYPE;
   tmp_price_tab             UNAPIGEN.FLOAT_TABLE_TYPE;
   tmp_disc_abs_tab          UNAPIGEN.NUM_TABLE_TYPE;
   tmp_disc_rel_tab          UNAPIGEN.NUM_TABLE_TYPE;
   tmp_net_price_tab         UNAPIGEN.FLOAT_TABLE_TYPE;
   tmp_ac_code_tab           UNAPIGEN.VC20_TABLE_TYPE;
   tmp_active_tab            UNAPIGEN.CHAR1_TABLE_TYPE;
   tmp_allow_modify_tab      UNAPIGEN.CHAR1_TABLE_TYPE;
   tmp_key_tab               UNAPIGEN.VC255_TABLE_TYPE;
   tmp_done_tab              UNAPIGEN.CHAR1_TABLE_TYPE;

   a_object_tp_tab           UNAPIGEN.VC20_TABLE_TYPE;
   a_object_version_tab      UNAPIGEN.VC20_TABLE_TYPE;
   a_rq_tab                  UNAPIGEN.VC20_TABLE_TYPE;
   a_sc_tab                  UNAPIGEN.VC20_TABLE_TYPE;
   a_pg_tab                  UNAPIGEN.VC20_TABLE_TYPE;
   a_pgnode_tab              UNAPIGEN.LONG_TABLE_TYPE;
   a_pa_tab                  UNAPIGEN.VC20_TABLE_TYPE;
   a_panode_tab              UNAPIGEN.LONG_TABLE_TYPE;
   a_me_tab                  UNAPIGEN.VC20_TABLE_TYPE;
   a_menode_tab              UNAPIGEN.LONG_TABLE_TYPE;
   a_reanalysis_tab          UNAPIGEN.NUM_TABLE_TYPE;
   a_description_tab         UNAPIGEN.VC255_TABLE_TYPE;
   a_qtity_tab               UNAPIGEN.NUM_TABLE_TYPE;
   a_price_tab               UNAPIGEN.FLOAT_TABLE_TYPE;
   a_disc_abs_tab            UNAPIGEN.NUM_TABLE_TYPE;
   a_disc_rel_tab            UNAPIGEN.NUM_TABLE_TYPE;
   a_net_price_tab           UNAPIGEN.FLOAT_TABLE_TYPE;
   a_ac_code_tab             UNAPIGEN.VC20_TABLE_TYPE;
   a_active_tab              UNAPIGEN.CHAR1_TABLE_TYPE;
   a_allow_modify_tab        UNAPIGEN.CHAR1_TABLE_TYPE;
   a_pp_key1_tab                 UNAPIGEN.VC20_TABLE_TYPE;
   a_pp_key2_tab                 UNAPIGEN.VC20_TABLE_TYPE;
   a_pp_key3_tab                 UNAPIGEN.VC20_TABLE_TYPE;
   a_pp_key4_tab                 UNAPIGEN.VC20_TABLE_TYPE;
   a_pp_key5_tab                 UNAPIGEN.VC20_TABLE_TYPE;

   error_found               EXCEPTION;

   -- Standard cursors

   -- Cursor to get the journal details
   CURSOR GetExistingDetails (csr_journal IN VARCHAR2) IS
      SELECT *
      FROM utjournaldetails
      WHERE journal_nr = csr_journal
      ORDER BY seq;

   -- Cursor to get the catalogue details, ordered by configuration catalogue
   CURSOR GetPrice (csr_catalogue       IN NUMBER,
                    csr_object_tp       IN VARCHAR2,
                    csr_object_id       IN VARCHAR2,
                    csr_object_version  IN VARCHAR2,
                    csr_pp_key1         IN VARCHAR2,
                    csr_pp_key2         IN VARCHAR2,
                    csr_pp_key3         IN VARCHAR2,
                    csr_pp_key4         IN VARCHAR2,
                    csr_pp_key5         IN VARCHAR2,
                    csr_criterium1      IN VARCHAR2,
                    csr_criterium2      IN VARCHAR2,
                    csr_criterium3      IN VARCHAR2,
                    csr_date            IN DATE) IS
      SELECT input_price, disc_abs, disc_rel, calc_disc, net_price, input_curr, description, ac_code
      FROM utcataloguedetails
      WHERE object_tp = csr_object_tp
      AND object_id = csr_object_id
      AND NVL(object_version, csr_object_version) = csr_object_version
      AND NVL(criterium1,';-(') IN (csr_criterium1,';-(') -- IN => crit does not HAS TO match:
                                                          -- if catalogue crit left empty and
                                                          -- incoming crit not, it will match
      AND NVL(criterium2,':-o') IN (csr_criterium2,':-o')
      AND NVL(criterium3,'|-)') IN (csr_criterium3,'|-)')
      AND NVL(pp_key1, ' ') IN (csr_pp_key1, ' ')
      AND NVL(pp_key2, ' ') IN (csr_pp_key2, ' ')
      AND NVL(pp_key3, ' ') IN (csr_pp_key3, ' ')
      AND NVL(pp_key4, ' ') IN (csr_pp_key4, ' ')
      AND NVL(pp_key5, ' ') IN (csr_pp_key5, ' ')
      AND csr_date >= NVL(from_date,TRUNC(CURRENT_TIMESTAMP,'DD'))
      AND csr_date <= NVL(to_date,TRUNC(CURRENT_TIMESTAMP,'DD'))
      ORDER BY seq_nr DESC;
   PriceRec             GetPrice%ROWTYPE;

   -- Cursor to get the catalogue nr.
   CURSOR GetCatalogue(csr_catalogue_type IN VARCHAR2) IS
      SELECT catalogue
      FROM utcatalogueid
      WHERE LOWER(catalogue_type) = LOWER(csr_catalogue_type);

   -- Cursor to get the rqsc's
   CURSOR GetRqSc(csr_rq IN VARCHAR2) IS
      SELECT a.sc, b.description, b.exec_end_date
      FROM utrqsc a, utsc b
      WHERE b.sc = a.sc
      AND a.rq = csr_rq
      AND b.ss NOT IN ('@C','@O');
   GetRqScRec                 GetRqSc%ROWTYPE;

   -- Cursor to get the scpg's
   CURSOR GetScPg(csr_sc IN VARCHAR2) IS
      SELECT pg, pp_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5, pgnode,
             reanalysis, description, exec_end_date
      FROM utscpg
      WHERE sc = csr_sc
      AND ss NOT IN ('@C','@O');
   GetScPgRec                 GetScPg%ROWTYPE;

   -- Cursor to get the pgpa's
   CURSOR GetPgPa(csr_sc      IN VARCHAR2,
                  csr_pg      IN VARCHAR2,
                  csr_pgnode  IN NUMBER) IS
      SELECT pa, pr_version, panode, reanalysis, description, exec_end_date
      FROM utscpa
      WHERE sc = csr_sc
      AND pg = csr_pg
      AND pgnode = csr_pgnode
      AND ss NOT IN ('@C','@O');
   GetPgPaRec                 GetPgPa%ROWTYPE;

   -- Cursor to get the pame's
   CURSOR GetPaMe(csr_sc      IN VARCHAR2,
                  csr_pg      IN VARCHAR2,
                  csr_pgnode  IN NUMBER,
                  csr_pa      IN VARCHAR2,
                  csr_panode  IN NUMBER) IS
      SELECT me, mt_version, menode, reanalysis, description, exec_end_date
      FROM utscme
      WHERE sc = csr_sc
      AND pg = csr_pg
      AND pgnode = csr_pgnode
      AND pa = csr_pa
      AND panode = csr_panode
      AND ss NOT IN ('@C','@O');
   GetPaMeRec                 GetPaMe%ROWTYPE;

   -- Cursor to get the currency properties
   CURSOR GetCurrProp(csr_currency IN VARCHAR2) IS
      SELECT currency, rounding, conversion
      FROM utcurrency
      WHERE currency = csr_currency;

   /*
   -- EXAMPLE OF CUSTOM CODE:

   -- Custom variables
   b_sc_found              BOOLEAN;
   n_disc_rel2             NUMBER;
   n_nr_of_sc_with_metals  NUMBER ;
   n_nr_of_klanten         NUMBER ;
   vc2_parametersoort      VARCHAR2(40);
   vc2_klant               VARCHAR2(40);
   temp_klant              VARCHAR2(40);
   vc2_sc_tab              UNAPIGEN.VC20_TABLE_TYPE;
   n_nr_of_metals_tab      UNAPIGEN.NUM_TABLE_TYPE;

   -- Custom cursors

   CURSOR GetExtraKosten(csr_rq IN VARCHAR2) IS
      SELECT b.dsp_title, a.ic, a.icnode, a.ii, a.iinode, a.iivalue
      FROM utrqii a, utie b
      WHERE a.rq = csr_rq
      AND a.ii = b.ie
      AND a.ii IN ('MONSTERNAMEKOST','RUSHKOSTEN','AFHAALKOSTEN','RAPPORTKOSTEN')
      AND a.ie_version = b.version
      ORDER BY a.ii;

   -- Cursor to get the value of rqii 'KLANTROEPNAAM'
   CURSOR GetDistinctKlant(csr_rq IN VARCHAR2) IS
      SELECT iivalue
      FROM utrqii
      WHERE rq = csr_rq
      AND ii = 'KLANTROEPNAAM';
   */
BEGIN
   -- Initialisation of variables
   a_errorcode       := 0;
   vc2_crit1         := NULL;
   vc2_crit2         := NULL;
   vc2_crit3         := NULL;
   n_nr_of_crit      := 0;
   a_nr_of_rows      := 0;
   a_total1          := 0;
   a_total2          := 0;
   a_disc_abs1       := NVL(a_disc_abs1,0);
   a_disc_abs2       := NVL(a_disc_abs2,0);
   a_grand_total1    := 0;
   a_grand_total2    := 0;
   a_tax1            := NVL(a_tax1,0);
   a_tax2            := NVL(a_tax2,0);
   a_grand_total_at1 := 0;
   a_grand_total_at2 := 0;
   a_last_updated    := CURRENT_TIMESTAMP;
   d_date            := TRUNC(CURRENT_TIMESTAMP,'DD'); -- the date taken into account at calculation

   -- Get the catalogue numbers. Each object type has 1 catalogue.
   n_rt_catalogue    := 0;
   n_st_catalogue    := 0;
   n_pp_catalogue    := 0;
   n_pr_catalogue    := 0;
   n_mt_catalogue    := 0;

   OPEN GetCatalogue('rt');
   FETCH GetCatalogue INTO n_rt_catalogue;
   IF GetCatalogue%NOTFOUND THEN
      a_errorcode := 3;
      Logmessage(a_journal_nr, a_errorcode, 'No rt catalogue found.');
   END IF;
   CLOSE GetCatalogue;

   OPEN GetCatalogue('st');
   FETCH GetCatalogue INTO n_st_catalogue;
   IF GetCatalogue%NOTFOUND THEN
      a_errorcode := 3;
      Logmessage(a_journal_nr, a_errorcode, 'No st catalogue found.');
   END IF;
   CLOSE GetCatalogue;

   OPEN GetCatalogue('pp');
   FETCH GetCatalogue INTO n_pp_catalogue;
   IF GetCatalogue%NOTFOUND THEN
      a_errorcode := 3;
      Logmessage(a_journal_nr, a_errorcode, 'No pp catalogue found.');
   END IF;
   CLOSE GetCatalogue;

   OPEN GetCatalogue('pr');
   FETCH GetCatalogue INTO n_pr_catalogue;
   IF GetCatalogue%NOTFOUND THEN
      a_errorcode := 3;
      Logmessage(a_journal_nr, a_errorcode, 'No pr catalogue found.');
   END IF;
   CLOSE GetCatalogue;

   OPEN GetCatalogue('mt');
   FETCH GetCatalogue INTO n_mt_catalogue;
   IF GetCatalogue%NOTFOUND THEN
      a_errorcode := 3;
      Logmessage(a_journal_nr, a_errorcode, 'No mt catalogue found.');
   END IF;
   CLOSE GetCatalogue;

   -- Get the journal currency properties
   OPEN GetCurrProp(a_currency);
   FETCH GetCurrProp INTO vc2_def_currency, vc2_def_rounding, f_def_conversion;
   IF GetCurrProp%NOTFOUND THEN
      vc2_errormsg := 'Properties of default currency '''||a_currency||''' not found.';
      RAISE error_found;
   END IF;
   CLOSE GetCurrProp;

   /*
   -- EXAMPLE OF CUSTOM CODE:

   -- Only 1 customer allowed in a journal
   n_nr_of_klanten := 0;
   FOR i_row IN 1..a_nr_of_rq LOOP
      vc2_rq := a_rq_in_tab(i_row);

      -- Get the value of rqii 'KLANTROEPNAAM'
      OPEN GetDistinctKlant(vc2_rq);
      FETCH GetDistinctKlant INTO vc2_klant;

      -- If the rqii is assigned and has a value
      IF GetDistinctKlant%FOUND AND vc2_klant IS NOT NULL THEN
         -- Check if there was already a customer found
         IF n_nr_of_klanten > 0 THEN
            -- Check if it is a different customer than the one already found
            IF vc2_klant != temp_klant THEN
               vc2_errormsg := 'More than 1 customer in journal '||a_journal_nr;
               RAISE error_found;
            END IF;
         ELSE
            n_nr_of_klanten := 1;
            temp_klant := vc2_klant;
         END IF;
      ELSE
         a_errorcode := 2;
         Logmessage(a_journal_nr, a_errorcode, 'No customer found for order '||vc2_rq);
      END IF;
      CLOSE GetDistinctKlant;
   END LOOP;
   */

   -- Check incoming variables
   IF a_journal_tp NOT IN ('Offer','Credit Note','Invoice') THEN
      vc2_errormsg := a_journal_tp||
         ' is not a valid journal type. Possible types are <Offer>, <Credit Note>, <Invoice>.';
      RAISE error_found;
   END IF;

   IF (NVL(a_disc_abs1,0) > 0 OR NVL(a_disc_abs2,0) > 0) AND NVL(a_disc_rel,0) > 0 THEN
      vc2_errormsg :=
         'Only one type of discount can be filled in. Absolute or relative discount should be set to 0.';
      RAISE error_found;
   END IF;

   IF (NVL(a_tax1,0) > 0 OR NVL(a_tax2,0) > 0) AND NVL(a_tax_rel,0) > 0 THEN
      vc2_errormsg :=
         'Only one type of tax can be filled in. Absolute or relative discount should be set to 0.';
      RAISE error_found;
   END IF;

   -- Necessary ? Has already been checked 20 lines earlier ?!!
   IF a_journal_tp NOT IN ('Offer','Credit Note','Invoice') THEN
      vc2_errormsg := a_journal_tp||
         ' is not a valid journal type. Possible types are <Offer>, <Credit Note>, <Invoice>.';
      RAISE error_found;
   END IF;

   -- Check if the journal can be modified
   IF (a_allow_modify = '1') AND (a_active = '1') THEN
      -- Get the already existing journal details
      tmp_nr_of_rows := 0;
      FOR GetDetails IN GetExistingDetails(a_journal_nr) LOOP
         tmp_nr_of_rows := tmp_nr_of_rows + 1;
         tmp_key_tab(tmp_nr_of_rows)            := GetDetails.rq||'@'||GetDetails.sc||'@'||
                                                   GetDetails.pg||'@'||GetDetails.pgnode||'@'||
                                                   GetDetails.pa||'@'||GetDetails.panode||'@'||
                                                   GetDetails.me||'@'||GetDetails.menode;
         tmp_object_tp_tab(tmp_nr_of_rows)      := GetDetails.object_tp;
         tmp_object_version_tab(tmp_nr_of_rows) := GetDetails.object_version;
         tmp_pp_key1_tab(tmp_nr_of_rows)        := GetDetails.pp_key1;
         tmp_pp_key2_tab(tmp_nr_of_rows)        := GetDetails.pp_key2;
         tmp_pp_key3_tab(tmp_nr_of_rows)        := GetDetails.pp_key3;
         tmp_pp_key4_tab(tmp_nr_of_rows)        := GetDetails.pp_key4;
         tmp_pp_key5_tab(tmp_nr_of_rows)        := GetDetails.pp_key5;
         tmp_rq_tab(tmp_nr_of_rows)             := GetDetails.rq;
         tmp_sc_tab(tmp_nr_of_rows)             := GetDetails.sc;
         tmp_pg_tab(tmp_nr_of_rows)             := GetDetails.pg;
         tmp_pgnode_tab(tmp_nr_of_rows)         := GetDetails.pgnode;
         tmp_pa_tab(tmp_nr_of_rows)             := GetDetails.pa;
         tmp_panode_tab(tmp_nr_of_rows)         := GetDetails.panode;
         tmp_me_tab(tmp_nr_of_rows)             := GetDetails.me;
         tmp_menode_tab(tmp_nr_of_rows)         := GetDetails.menode;
         tmp_reanalysis_tab(tmp_nr_of_rows)     := GetDetails.reanalysis;
         tmp_description_tab(tmp_nr_of_rows)    := GetDetails.description;
         tmp_qtity_tab(tmp_nr_of_rows)          := GetDetails.qtity;
         tmp_price_tab(tmp_nr_of_rows)          := GetDetails.price;
         tmp_disc_abs_tab(tmp_nr_of_rows)       := GetDetails.disc_abs;
         tmp_disc_rel_tab(tmp_nr_of_rows)       := GetDetails.disc_rel;
         tmp_net_price_tab(tmp_nr_of_rows)      := GetDetails.net_price;
         tmp_ac_code_tab(tmp_nr_of_rows)        := GetDetails.ac_code;
         tmp_active_tab(tmp_nr_of_rows)         := GetDetails.active;
         tmp_allow_modify_tab(tmp_nr_of_rows)   := GetDetails.allow_modify;
         tmp_done_tab(tmp_nr_of_rows)           := '0';
      END LOOP ;

      ------------------------------------------------------------------------------
      -- Calculation type 1 = Full Details (The system looks down the tree structure
      --                                    rq-sc-pg-pa-me for prices)
      ------------------------------------------------------------------------------
      IF UPPER(a_calc_tp) = 'FD' THEN
         -- RQ LEVEL --
         -- Loop the rq's
         FOR i_row IN 1..a_nr_of_rq LOOP
            vc2_rq := a_rq_in_tab(i_row);

            SELECT rt, rt_version, ss, exec_end_date, description
            INTO vc2_rt, vc2_rt_version, vc2_rq_ss, d_rq_exec_end_date, vc2_rt_desc
            FROM utrq
            WHERE rq = vc2_rq;

            -- Check if rq not Canceled or Obsolete
            IF vc2_rq_ss NOT IN ('@C','@O') THEN
               -- Get rt criteria for all catalogues
               GetCriteria('_', 'rt', a_journal_nr, vc2_rq, NULL, NULL, NULL, NULL, NULL,
                           NULL, NULL, n_cat_tab, n_crit_tab, vc2_critval_tab, n_nr_of_crit,
                           a_errorcode);

               FOR i_row2 IN 1..n_nr_of_crit LOOP
                  IF (n_cat_tab(i_row2) = n_rt_catalogue) AND (n_crit_tab(i_row2) = 1) THEN
                     vc2_crit1 := vc2_critval_tab(i_row2);
                  END IF;
                  IF (n_cat_tab(i_row2) = n_rt_catalogue) AND (n_crit_tab(i_row2) = 2) THEN
                     vc2_crit2 := vc2_critval_tab(i_row2);
                  END IF;
                  IF (n_cat_tab(i_row2) = n_rt_catalogue) AND (n_crit_tab(i_row2) = 3) THEN
                     vc2_crit3 := vc2_critval_tab(i_row2);
                  END IF;
               END LOOP;

               -- Get the catalogue details, ordered by configuration catalogue.
               -- The fetch also contains the rt price.
               OPEN GetPrice(n_rt_catalogue, 'rt', vc2_rt, vc2_rt_version,
                             ' ', ' ', ' ', ' ', ' ', vc2_crit1, vc2_crit2,
                             vc2_crit3, d_date);
               FETCH GetPrice INTO f_input_price, n_disc_abs, n_disc_rel, f_calc_disc,
                                   f_net_price, vc2_currency, vc2_obj_desc, vc2_ac_code;
               -- If found, then add line in journal details
               IF GetPrice%FOUND THEN
                  CLOSE GetPrice;

                  vc2_key := vc2_rq||'@'||NULL||'@'||NULL||'@'||NULL||
                             '@'||NULL||'@'||NULL||'@'||NULL||'@'||NULL;
                  b_newline := TRUE;
                  -- Loop the already existing journal details
                  FOR i_row3 IN 1..tmp_nr_of_rows LOOP
                     -- Check if the key matches and journal is not modifiable
                     IF (tmp_key_tab(i_row3) = vc2_key) AND (tmp_allow_modify_tab(i_row3) = '0') THEN
                        -- Don't overwrite, copy old line
                        b_newline := FALSE;
                        a_nr_of_rows                          := a_nr_of_rows + 1;
                        a_object_tp_tab (a_nr_of_rows)        := tmp_object_tp_tab(i_row3);
                        a_object_version_tab (a_nr_of_rows)   := tmp_object_version_tab(i_row3);
                        a_pp_key1_tab (a_nr_of_rows)          := tmp_pp_key1_tab(i_row3);
                        a_pp_key2_tab (a_nr_of_rows)          := tmp_pp_key2_tab(i_row3);
                        a_pp_key3_tab (a_nr_of_rows)          := tmp_pp_key3_tab(i_row3);
                        a_pp_key4_tab (a_nr_of_rows)          := tmp_pp_key4_tab(i_row3);
                        a_pp_key5_tab (a_nr_of_rows)          := tmp_pp_key5_tab(i_row3);
                        a_rq_tab (a_nr_of_rows)               := tmp_rq_tab(i_row3);
                        a_sc_tab (a_nr_of_rows)               := tmp_sc_tab(i_row3);
                        a_pg_tab (a_nr_of_rows)               := tmp_pg_tab(i_row3);
                        a_pgnode_tab (a_nr_of_rows)           := tmp_pgnode_tab(i_row3);
                        a_pa_tab (a_nr_of_rows)               := tmp_pa_tab(i_row3);
                        a_panode_tab (a_nr_of_rows)           := tmp_panode_tab(i_row3);
                        a_me_tab (a_nr_of_rows)               := tmp_me_tab(i_row3);
                        a_menode_tab (a_nr_of_rows)           := tmp_menode_tab(i_row3);
                        a_reanalysis_tab (a_nr_of_rows)       := tmp_reanalysis_tab(i_row3);
                        a_description_tab (a_nr_of_rows)      := tmp_description_tab(i_row3);
                        a_qtity_tab (a_nr_of_rows)            := tmp_qtity_tab(i_row3);
                        a_price_tab (a_nr_of_rows)            := tmp_price_tab(i_row3);
                        a_disc_abs_tab (a_nr_of_rows)         := tmp_disc_abs_tab(i_row3);
                        a_disc_rel_tab (a_nr_of_rows)         := tmp_disc_rel_tab(i_row3);
                        a_net_price_tab (a_nr_of_rows)        := tmp_net_price_tab(i_row3);
                        a_ac_code_tab (a_nr_of_rows)          := tmp_ac_code_tab(i_row3);
                        a_active_tab (a_nr_of_rows)           := tmp_active_tab(i_row3);
                        a_allow_modify_tab (a_nr_of_rows)     := tmp_allow_modify_tab(i_row3);
                        tmp_done_tab (i_row3)                 := '1';
                     END IF;
                  END LOOP;

                  -- Check if (rq not ended or journal is 'Offer') and new line to add
                  IF (d_rq_exec_end_date IS NOT NULL OR a_journal_tp = 'Offer') AND b_newline THEN
                     -- If rq not ended, then the price should not yet been taken into account
                     a_nr_of_rows                        := a_nr_of_rows + 1;
                     a_object_tp_tab(a_nr_of_rows)       := 'rt';
                     a_object_version_tab(a_nr_of_rows)  := vc2_rt_version;
                     a_pp_key1_tab(a_nr_of_rows)         := ' ';
                     a_pp_key2_tab(a_nr_of_rows)         := ' ';
                     a_pp_key3_tab(a_nr_of_rows)         := ' ';
                     a_pp_key4_tab(a_nr_of_rows)         := ' ';
                     a_pp_key5_tab(a_nr_of_rows)         := ' ';
                     a_rq_tab(a_nr_of_rows)              := vc2_rq;
                     a_sc_tab(a_nr_of_rows)              := NULL;
                     a_pg_tab(a_nr_of_rows)              := NULL;
                     a_pgnode_tab(a_nr_of_rows)          := NULL;
                     a_pa_tab(a_nr_of_rows)              := NULL;
                     a_panode_tab(a_nr_of_rows)          := NULL;
                     a_me_tab(a_nr_of_rows)              := NULL;
                     a_menode_tab(a_nr_of_rows)          := NULL;
                     a_reanalysis_tab(a_nr_of_rows)      := NULL;
                     a_description_tab(a_nr_of_rows)     := NVL(vc2_obj_desc,vc2_rt_desc);
                     a_qtity_tab(a_nr_of_rows)           := 1;

                     -- Check if rt catalogue currency is default currency
                     IF vc2_currency <> vc2_def_currency THEN
                        -- Get the currency conversion
                        SELECT conversion
                        INTO f_conversion
                        FROM utcurrency
                        WHERE currency = vc2_currency;

                        a_price_tab(a_nr_of_rows)     :=
                           ROUND(f_input_price * f_def_conversion / f_conversion,
                                 TO_NUMBER(vc2_def_rounding));
                        a_disc_abs_tab(a_nr_of_rows)  :=
                           ROUND(n_disc_abs * f_def_conversion / f_conversion,
                                 TO_NUMBER(vc2_def_rounding));
                        a_disc_rel_tab(a_nr_of_rows)  := n_disc_rel;
                        a_net_price_tab(a_nr_of_rows) :=
                           ROUND(a_qtity_tab(a_nr_of_rows)
                                    * (a_price_tab(a_nr_of_rows)
                                          - a_disc_abs_tab(a_nr_of_rows)
                                          - (n_disc_rel * a_price_tab(a_nr_of_rows) / 100)),
                                 TO_NUMBER(vc2_def_rounding));
                     ELSE
                        a_price_tab(a_nr_of_rows)     := f_input_price;
                        a_disc_abs_tab(a_nr_of_rows)  := n_disc_abs;
                        a_disc_rel_tab(a_nr_of_rows)  := n_disc_rel;
                        a_net_price_tab(a_nr_of_rows) :=
                           ROUND(a_qtity_tab(a_nr_of_rows) * f_net_price,
                                 TO_NUMBER(vc2_def_rounding));
                     END IF;

                     -- Check if journal is 'Credit Note'
                     IF a_journal_tp = 'Credit Note' THEN
                        -- All prices negative
                        a_price_tab(a_nr_of_rows)     := - a_price_tab(a_nr_of_rows);
                        a_disc_abs_tab(a_nr_of_rows)  := - a_disc_abs_tab(a_nr_of_rows);
                        a_disc_rel_tab(a_nr_of_rows)  := - a_disc_rel_tab(a_nr_of_rows);
                        a_net_price_tab(a_nr_of_rows) := - a_net_price_tab(a_nr_of_rows);
                     END IF;

                     a_ac_code_tab(a_nr_of_rows)      := vc2_ac_code;
                     a_active_tab(a_nr_of_rows)       := '1';
                     a_allow_modify_tab(a_nr_of_rows) := '1';
                  END IF;
               -- If not found, go searching a level lower
               ELSE
                  CLOSE GetPrice;

                  -- SC LEVEL --
                  -- Loop the rqsc's
                  FOR GetRqScRec IN GetRqSc(vc2_rq) LOOP
                     vc2_sc := GetRqScRec.sc;

                     -- Get st criteria for all catalogues
                     GetCriteria('_', 'st', a_journal_nr, vc2_rq, vc2_sc, NULL, NULL,
                                 NULL, NULL, NULL, NULL, n_cat_tab, n_crit_tab,
                                 vc2_critval_tab, n_nr_of_crit, a_errorcode);

                     FOR i_row2 IN 1..n_nr_of_crit LOOP
                        IF (n_cat_tab(i_row2) = n_st_catalogue) AND (n_crit_tab(i_row2) = 1) THEN
                           vc2_crit1 := vc2_critval_tab(i_row2);
                        END IF;
                        IF (n_cat_tab(i_row2) = n_st_catalogue) AND (n_crit_tab(i_row2) = 2) THEN
                           vc2_crit2 := vc2_critval_tab(i_row2);
                        END IF;
                        IF (n_cat_tab(i_row2) = n_st_catalogue) AND (n_crit_tab(i_row2) = 3) THEN
                           vc2_crit3 := vc2_critval_tab(i_row2);
                        END IF;
                     END LOOP;

                     -- Get st
                     SELECT st, st_version
                     INTO vc2_st, vc2_st_version
                     FROM utsc
                     WHERE sc = vc2_sc;

                     -- Get the catalogue details, ordered by configuration catalogue.
                     -- The fetch also contains the st price.
                     OPEN GetPrice(n_st_catalogue, 'st', vc2_st, vc2_st_version, ' ',
                                   ' ', ' ', ' ', ' ', vc2_crit1, vc2_crit2, vc2_crit3,
                                   d_date);
                     FETCH GetPrice INTO f_input_price, n_disc_abs, n_disc_rel, f_calc_disc,
                                         f_net_price, vc2_currency, vc2_obj_desc, vc2_ac_code;
                     -- If found, then add line in journal details
                     IF GetPrice%FOUND THEN
                        CLOSE GetPrice;

                        vc2_key := vc2_rq||'@'||vc2_sc||'@'||NULL||'@'||NULL||
                                   '@'||NULL||'@'||NULL||'@'||NULL||'@'||NULL;
                        b_newline := TRUE;
                        -- Loop the already existing journal details
                        FOR i_row3 IN 1..tmp_nr_of_rows LOOP
                           -- Check if the key matches and journal is not modifiable
                           IF (tmp_key_tab(i_row3) = vc2_key) AND (tmp_allow_modify_tab(i_row3) = '0') THEN
                              -- Don't overwrite, copy old line
                              b_newline := FALSE;
                              a_nr_of_rows                        := a_nr_of_rows + 1;
                              a_object_tp_tab(a_nr_of_rows)       := tmp_object_tp_tab(i_row3);
                              a_object_version_tab (a_nr_of_rows) := tmp_object_version_tab(i_row3);
                              a_pp_key1_tab(a_nr_of_rows)         := tmp_pp_key1_tab(i_row3);
                              a_pp_key2_tab(a_nr_of_rows)         := tmp_pp_key2_tab(i_row3);
                              a_pp_key3_tab(a_nr_of_rows)         := tmp_pp_key3_tab(i_row3);
                              a_pp_key4_tab(a_nr_of_rows)         := tmp_pp_key4_tab(i_row3);
                              a_pp_key5_tab(a_nr_of_rows)         := tmp_pp_key5_tab(i_row3);
                              a_rq_tab(a_nr_of_rows)              := tmp_rq_tab(i_row3);
                              a_sc_tab(a_nr_of_rows)              := tmp_sc_tab(i_row3);
                              a_pg_tab(a_nr_of_rows)              := tmp_pg_tab(i_row3);
                              a_pgnode_tab(a_nr_of_rows)          := tmp_pgnode_tab(i_row3);
                              a_pa_tab(a_nr_of_rows)              := tmp_pa_tab(i_row3);
                              a_panode_tab(a_nr_of_rows)          := tmp_panode_tab(i_row3);
                              a_me_tab(a_nr_of_rows)              := tmp_me_tab(i_row3);
                              a_menode_tab(a_nr_of_rows)          := tmp_menode_tab(i_row3);
                              a_reanalysis_tab(a_nr_of_rows)      := tmp_reanalysis_tab(i_row3);
                              a_description_tab(a_nr_of_rows)     := tmp_description_tab(i_row3);
                              a_qtity_tab(a_nr_of_rows)           := tmp_qtity_tab(i_row3);
                              a_price_tab(a_nr_of_rows)           := tmp_price_tab(i_row3);
                              a_disc_abs_tab(a_nr_of_rows)        := tmp_disc_abs_tab(i_row3);
                              a_disc_rel_tab(a_nr_of_rows)        := tmp_disc_rel_tab(i_row3);
                              a_net_price_tab(a_nr_of_rows)       := tmp_net_price_tab(i_row3);
                              a_ac_code_tab(a_nr_of_rows)         := tmp_ac_code_tab(i_row3);
                              a_active_tab(a_nr_of_rows)          := tmp_active_tab(i_row3);
                              a_allow_modify_tab(a_nr_of_rows)    := tmp_allow_modify_tab(i_row3);
                              tmp_done_tab(i_row3)                := '1';
                           END IF;
                        END LOOP;

                        -- Check if (sc not ended or journal is 'Offer') and new line to add
                        IF (GetRqScRec.exec_end_date IS NOT NULL OR a_journal_tp = 'Offer')
                           AND b_newline THEN
                           -- If sc not ended, then the price should not yet been taken into account
                           a_nr_of_rows                       := a_nr_of_rows + 1;
                           a_object_tp_tab(a_nr_of_rows)      := 'st';
                           a_object_version_tab(a_nr_of_rows) := vc2_st_version;
                           a_pp_key1_tab(a_nr_of_rows)        := ' ';
                           a_pp_key2_tab(a_nr_of_rows)        := ' ';
                           a_pp_key3_tab(a_nr_of_rows)        := ' ';
                           a_pp_key4_tab(a_nr_of_rows)        := ' ';
                           a_pp_key5_tab(a_nr_of_rows)        := ' ';
                           a_rq_tab(a_nr_of_rows)             := vc2_rq;
                           a_sc_tab(a_nr_of_rows)             := vc2_sc;
                           a_pg_tab(a_nr_of_rows)             := NULL;
                           a_pgnode_tab(a_nr_of_rows)         := NULL;
                           a_pa_tab(a_nr_of_rows)             := NULL;
                           a_panode_tab(a_nr_of_rows)         := NULL;
                           a_me_tab(a_nr_of_rows)             := NULL;
                           a_menode_tab(a_nr_of_rows)         := NULL;
                           a_reanalysis_tab(a_nr_of_rows)     := NULL;
                           a_description_tab(a_nr_of_rows)    := NVL(vc2_obj_desc,
                                                                     GetRqScRec.description);
                           a_qtity_tab(a_nr_of_rows)          := 1;

                           -- Check if st catalogue currency is default currency
                           IF vc2_currency <> vc2_def_currency THEN
                              -- Get the currency conversion
                              SELECT conversion
                              INTO f_conversion
                              FROM utcurrency
                              WHERE currency = vc2_currency;

                              a_price_tab(a_nr_of_rows)     :=
                                 ROUND(f_input_price * f_def_conversion / f_conversion,
                                       TO_NUMBER(vc2_def_rounding));
                              a_disc_abs_tab(a_nr_of_rows)  :=
                                 ROUND(n_disc_abs * f_def_conversion / f_conversion,
                                       TO_NUMBER(vc2_def_rounding));
                              a_disc_rel_tab(a_nr_of_rows)  := n_disc_rel;
                              a_net_price_tab(a_nr_of_rows) :=
                                 ROUND(a_qtity_tab(a_nr_of_rows)
                                          * (a_price_tab(a_nr_of_rows)
                                                - a_disc_abs_tab(a_nr_of_rows)
                                                - (n_disc_rel * a_price_tab(a_nr_of_rows) / 100)),
                                       TO_NUMBER(vc2_def_rounding));
                           ELSE
                              a_price_tab(a_nr_of_rows)     := f_input_price;
                              a_disc_abs_tab(a_nr_of_rows)  := n_disc_abs;
                              a_disc_rel_tab(a_nr_of_rows)  := n_disc_rel;
                              a_net_price_tab(a_nr_of_rows) :=
                                 ROUND(a_qtity_tab(a_nr_of_rows) * f_net_price,
                                       TO_NUMBER(vc2_def_rounding));
                           END IF;

                           -- Check if journal is 'Credit Note'
                           IF a_journal_tp = 'Credit Note' THEN
                              -- All prices negative
                              a_price_tab(a_nr_of_rows)     := - a_price_tab(a_nr_of_rows);
                              a_disc_abs_tab(a_nr_of_rows)  := - a_disc_abs_tab(a_nr_of_rows);
                              a_disc_rel_tab(a_nr_of_rows)  := - a_disc_rel_tab(a_nr_of_rows);
                              a_net_price_tab(a_nr_of_rows) := - a_net_price_tab(a_nr_of_rows);
                           END IF;

                           a_ac_code_tab(a_nr_of_rows)      := vc2_ac_code;
                           a_active_tab(a_nr_of_rows)       := '1';
                           a_allow_modify_tab(a_nr_of_rows) := '1';
                        END IF;
                     -- If not found, go searching a level lower
                     ELSE
                        CLOSE GetPrice;

                        -- PG LEVEL --
                        -- Loop the scpg's
                        FOR GetScPgRec IN GetScPg(vc2_sc) LOOP
                           vc2_pg          := GetScPgRec.pg;
                           vc2_pp_version  := GetScPgRec.pp_version;
                           vc2_pp_key1     := GetScPgRec.pp_key1;
                           vc2_pp_key2     := GetScPgRec.pp_key2;
                           vc2_pp_key3     := GetScPgRec.pp_key3;
                           vc2_pp_key4     := GetScPgRec.pp_key4;
                           vc2_pp_key5     := GetScPgRec.pp_key5;
                           n_pgnode        := GetScPgRec.pgnode;
                           n_reanalysis    := GetScPgRec.reanalysis;
                           vc2_description := GetScPgRec.description;

                           -- Get pp criteria for all catalogues
                           GetCriteria('_', 'pp', a_journal_nr, vc2_rq, vc2_sc, vc2_pg,
                                       n_pgnode, NULL, NULL, NULL, NULL, n_cat_tab,
                                       n_crit_tab, vc2_critval_tab, n_nr_of_crit, a_errorcode);

                           FOR i_row2 IN 1..n_nr_of_crit LOOP
                              IF (n_cat_tab(i_row2) = n_pp_catalogue) AND (n_crit_tab(i_row2) = 1) THEN
                                 vc2_crit1 := vc2_critval_tab(i_row2);
                              END IF;
                              IF (n_cat_tab(i_row2) = n_pp_catalogue) AND (n_crit_tab(i_row2) = 2) THEN
                                 vc2_crit2 := vc2_critval_tab(i_row2);
                              END IF;
                              IF (n_cat_tab(i_row2) = n_pp_catalogue) AND (n_crit_tab(i_row2) = 3) THEN
                                 vc2_crit3 := vc2_critval_tab(i_row2);
                              END IF;
                           END LOOP;

                           -- Get the catalogue details, ordered by configuration catalogue.
                           -- The fetch also contains the pp price.
                           OPEN GetPrice(n_pp_catalogue, 'pp', vc2_pg, vc2_pp_version,
                                         vc2_pp_key1, vc2_pp_key2, vc2_pp_key3, vc2_pp_key4,
                                         vc2_pp_key5, vc2_crit1, vc2_crit2, vc2_crit3, d_date);
                           FETCH GetPrice INTO f_input_price, n_disc_abs, n_disc_rel, f_calc_disc,
                                               f_net_price, vc2_currency, vc2_obj_desc, vc2_ac_code;
                           -- If found, then add line in journal details
                           IF GetPrice%FOUND THEN
                              CLOSE GetPrice;

                              vc2_key := vc2_rq||'@'||vc2_sc||'@'||vc2_pg||'@'||n_pgnode||
                                         '@'||NULL||'@'||NULL||'@'||NULL||'@'||NULL;
                              b_newline := TRUE;
                              -- Loop the already existing journal details
                              FOR i_row3 IN 1..tmp_nr_of_rows LOOP
                                 -- Check if the key matches and journal is not modifiable
                                 IF (tmp_key_tab(i_row3) = vc2_key)
                                    AND (tmp_allow_modify_tab(i_row3) = '0') THEN
                                    -- Don't overwrite, copy old line
                                    b_newline := FALSE;
                                    a_nr_of_rows                       := a_nr_of_rows + 1;
                                    a_object_tp_tab(a_nr_of_rows)      := tmp_object_tp_tab(i_row3);
                                    a_object_version_tab(a_nr_of_rows) := tmp_object_version_tab(i_row3);
                                    a_pp_key1_tab(a_nr_of_rows)        := tmp_pp_key1_tab(i_row3);
                                    a_pp_key2_tab(a_nr_of_rows)        := tmp_pp_key2_tab(i_row3);
                                    a_pp_key3_tab(a_nr_of_rows)        := tmp_pp_key3_tab(i_row3);
                                    a_pp_key4_tab(a_nr_of_rows)        := tmp_pp_key4_tab(i_row3);
                                    a_pp_key5_tab(a_nr_of_rows)        := tmp_pp_key5_tab(i_row3);
                                    a_rq_tab(a_nr_of_rows)             := tmp_rq_tab(i_row3);
                                    a_sc_tab(a_nr_of_rows)             := tmp_sc_tab(i_row3);
                                    a_pg_tab(a_nr_of_rows)             := tmp_pg_tab(i_row3);
                                    a_pgnode_tab(a_nr_of_rows)         := tmp_pgnode_tab(i_row3);
                                    a_pa_tab(a_nr_of_rows)             := tmp_pa_tab(i_row3);
                                    a_panode_tab(a_nr_of_rows)         := tmp_panode_tab(i_row3);
                                    a_me_tab(a_nr_of_rows)             := tmp_me_tab(i_row3);
                                    a_menode_tab(a_nr_of_rows)         := tmp_menode_tab(i_row3);
                                    a_reanalysis_tab(a_nr_of_rows)     := tmp_reanalysis_tab(i_row3);
                                    a_description_tab(a_nr_of_rows)    := tmp_description_tab(i_row3);
                                    a_qtity_tab(a_nr_of_rows)          := tmp_qtity_tab(i_row3);
                                    a_price_tab(a_nr_of_rows)          := tmp_price_tab(i_row3);
                                    a_disc_abs_tab(a_nr_of_rows)       := tmp_disc_abs_tab(i_row3);
                                    a_disc_rel_tab(a_nr_of_rows)       := tmp_disc_rel_tab(i_row3);
                                    a_net_price_tab(a_nr_of_rows)      := tmp_net_price_tab(i_row3);
                                    a_ac_code_tab(a_nr_of_rows)        := tmp_ac_code_tab(i_row3);
                                    a_active_tab(a_nr_of_rows)         := tmp_active_tab(i_row3);
                                    a_allow_modify_tab(a_nr_of_rows)   := tmp_allow_modify_tab(i_row3);
                                    tmp_done_tab(i_row3)               := '1';
                                 END IF;
                              END LOOP;

                              -- Check if (pg not ended or journal is 'Offer') and new line to add
                              IF (GetScPgRec.exec_end_date IS NOT NULL OR a_journal_tp = 'Offer')
                                 AND b_newline THEN
                                 -- If pg not ended,
                                 -- then the price should not yet been taken into account
                                 a_nr_of_rows                       := a_nr_of_rows + 1;
                                 a_object_tp_tab(a_nr_of_rows)      := 'pp';
                                 a_object_version_tab(a_nr_of_rows) := vc2_pp_version;
                                 a_pp_key1_tab(a_nr_of_rows)        := vc2_pp_key1;
                                 a_pp_key2_tab(a_nr_of_rows)        := vc2_pp_key2;
                                 a_pp_key3_tab(a_nr_of_rows)        := vc2_pp_key3;
                                 a_pp_key4_tab(a_nr_of_rows)        := vc2_pp_key4;
                                 a_pp_key5_tab(a_nr_of_rows)        := vc2_pp_key5;
                                 a_rq_tab(a_nr_of_rows)             := vc2_rq;
                                 a_sc_tab(a_nr_of_rows)             := vc2_sc;
                                 a_pg_tab(a_nr_of_rows)             := vc2_pg;
                                 a_pgnode_tab(a_nr_of_rows)         := n_pgnode;
                                 a_pa_tab(a_nr_of_rows)             := NULL;
                                 a_panode_tab(a_nr_of_rows)         := NULL;
                                 a_me_tab(a_nr_of_rows)             := NULL;
                                 a_menode_tab(a_nr_of_rows)         := NULL;
                                 a_reanalysis_tab(a_nr_of_rows)     := n_reanalysis;
                                 a_description_tab(a_nr_of_rows)    := NVL(vc2_obj_desc,
                                                                           vc2_description);

                                 IF a_inv_reanal IN ('Y','1') THEN
                                    a_qtity_tab(a_nr_of_rows) := n_reanalysis + 1;
                                 ELSE
                                    a_qtity_tab(a_nr_of_rows) := 1;
                                 END IF;

                                 -- Check if pp catalogue currency is default currency
                                 IF vc2_currency <> vc2_def_currency THEN
                                    -- Get the currency conversion
                                    SELECT conversion
                                    INTO f_conversion
                                    FROM utcurrency
                                    WHERE currency = vc2_currency;

                                    a_price_tab(a_nr_of_rows)     :=
                                       ROUND(f_input_price * f_def_conversion / f_conversion,
                                             TO_NUMBER(vc2_def_rounding));
                                    a_disc_abs_tab(a_nr_of_rows)  :=
                                       ROUND(n_disc_abs * f_def_conversion / f_conversion,
                                             TO_NUMBER(vc2_def_rounding));
                                    a_disc_rel_tab(a_nr_of_rows)  := n_disc_rel;
                                    a_net_price_tab(a_nr_of_rows) :=
                                       ROUND(a_qtity_tab(a_nr_of_rows)
                                                * (a_price_tab(a_nr_of_rows)
                                                    - a_disc_abs_tab(a_nr_of_rows)
                                                    - (n_disc_rel * a_price_tab(a_nr_of_rows) / 100)),
                                             TO_NUMBER(vc2_def_rounding));
                                 ELSE
                                    a_price_tab(a_nr_of_rows)     := f_input_price;
                                    a_disc_abs_tab(a_nr_of_rows)  := n_disc_abs;
                                    a_disc_rel_tab(a_nr_of_rows)  := n_disc_rel;
                                    a_net_price_tab(a_nr_of_rows) :=
                                       ROUND(a_qtity_tab(a_nr_of_rows) * f_net_price,
                                             TO_NUMBER(vc2_def_rounding));
                                 END IF;

                                 -- Check if journal is 'Credit Note'
                                 IF a_journal_tp = 'Credit Note' THEN
                                    -- All prices negative
                                    a_price_tab(a_nr_of_rows)     := - a_price_tab(a_nr_of_rows);
                                    a_disc_abs_tab(a_nr_of_rows)  := - a_disc_abs_tab(a_nr_of_rows);
                                    a_disc_rel_tab(a_nr_of_rows)  := - a_disc_rel_tab(a_nr_of_rows);
                                    a_net_price_tab(a_nr_of_rows) := - a_net_price_tab(a_nr_of_rows);
                                 END IF;

                                 a_ac_code_tab(a_nr_of_rows)      := vc2_ac_code;
                                 a_active_tab(a_nr_of_rows)       := '1';
                                 a_allow_modify_tab(a_nr_of_rows) := '1';
                              END IF;
                           -- If not found, go searching a level lower
                           ELSE
                              CLOSE GetPrice;

                              -- PA LEVEL --
                              -- Loop the pgpa's
                              FOR GetPgPaRec IN GetPgPa(vc2_sc,vc2_pg,n_pgnode) LOOP
                                 vc2_pa          := GetPgPaRec.pa;
                                 vc2_pr_version  := GetPgPaRec.pr_version;
                                 n_panode        := GetPgPaRec.panode;
                                 n_reanalysis    := GetPgPaRec.reanalysis;
                                 vc2_description := GetPgPaRec.description;

                                 -- Get pr criteria for all catalogues
                                 GetCriteria('_', 'pr', a_journal_nr, vc2_rq, vc2_sc, vc2_pg,
                                             n_pgnode, vc2_pa, n_panode, NULL, NULL, n_cat_tab,
                                             n_crit_tab, vc2_critval_tab, n_nr_of_crit, a_errorcode);

                                 FOR i_row2 IN 1..n_nr_of_crit LOOP
                                    IF (n_cat_tab(i_row2) = n_pr_catalogue)
                                       AND (n_crit_tab(i_row2) = 1) THEN
                                       vc2_crit1 := vc2_critval_tab(i_row2);
                                    END IF;
                                    IF (n_cat_tab(i_row2) = n_pr_catalogue)
                                       AND (n_crit_tab(i_row2) = 2) THEN
                                       vc2_crit2 := vc2_critval_tab(i_row2);
                                    END IF;
                                    IF (n_cat_tab(i_row2) = n_pr_catalogue)
                                       AND (n_crit_tab(i_row2) = 3) THEN
                                       vc2_crit3 := vc2_critval_tab(i_row2);
                                    END IF;
                                 END LOOP;

                                 -- Get the catalogue details, ordered by configuration catalogue.
                                 -- The fetch also contains the pr price.
                                 OPEN GetPrice(n_pr_catalogue, 'pr', vc2_pa, vc2_pr_version,
                                               ' ', ' ', ' ', ' ', ' ', vc2_crit1, vc2_crit2,
                                               vc2_crit3, d_date);
                                 FETCH GetPrice INTO f_input_price, n_disc_abs, n_disc_rel,
                                                     f_calc_disc, f_net_price, vc2_currency,
                                                     vc2_obj_desc, vc2_ac_code;
                                 -- If found, then add line in journal details
                                 IF GetPrice%FOUND THEN
                                    CLOSE GetPrice;

                                    vc2_key := vc2_rq||'@'||vc2_sc||'@'||vc2_pg||'@'||n_pgnode||
                                               '@'||vc2_pa||'@'||n_panode||'@'||NULL||'@'||NULL;
                                    b_newline := TRUE;
                                    -- Loop the already existing journal details
                                    FOR i_row3 IN 1..tmp_nr_of_rows LOOP
                                       -- Check if the key matches and journal is not modifiable
                                       IF (tmp_key_tab(i_row3) = vc2_key)
                                          AND (tmp_allow_modify_tab(i_row3) = '0') THEN
                                          -- Don't overwrite, copy old line
                                          b_newline := FALSE;
                                          a_nr_of_rows                    := a_nr_of_rows + 1;
                                          a_object_tp_tab(a_nr_of_rows)   := tmp_object_tp_tab(i_row3);
                                          a_object_version_tab(a_nr_of_rows) := tmp_object_version_tab(i_row3);
                                          a_pp_key1_tab(a_nr_of_rows)     := tmp_pp_key1_tab(i_row3);
                                          a_pp_key2_tab(a_nr_of_rows)     := tmp_pp_key2_tab(i_row3);
                                          a_pp_key3_tab(a_nr_of_rows)     := tmp_pp_key3_tab(i_row3);
                                          a_pp_key4_tab(a_nr_of_rows)     := tmp_pp_key4_tab(i_row3);
                                          a_pp_key5_tab(a_nr_of_rows)     := tmp_pp_key5_tab(i_row3);
                                          a_rq_tab(a_nr_of_rows)          := tmp_rq_tab(i_row3);
                                          a_sc_tab(a_nr_of_rows)          := tmp_sc_tab(i_row3);
                                          a_pg_tab(a_nr_of_rows)          := tmp_pg_tab(i_row3);
                                          a_pgnode_tab(a_nr_of_rows)      := tmp_pgnode_tab(i_row3);
                                          a_pa_tab(a_nr_of_rows)          := tmp_pa_tab(i_row3);
                                          a_panode_tab(a_nr_of_rows)      := tmp_panode_tab(i_row3);
                                          a_me_tab(a_nr_of_rows)          := tmp_me_tab(i_row3);
                                          a_menode_tab(a_nr_of_rows)      := tmp_menode_tab(i_row3);
                                          a_reanalysis_tab(a_nr_of_rows)  := tmp_reanalysis_tab(i_row3);
                                          a_description_tab(a_nr_of_rows) := tmp_description_tab(i_row3);
                                          a_qtity_tab(a_nr_of_rows)       := tmp_qtity_tab(i_row3);
                                          a_price_tab(a_nr_of_rows)       := tmp_price_tab(i_row3);
                                          a_disc_abs_tab(a_nr_of_rows)    := tmp_disc_abs_tab(i_row3);
                                          a_disc_rel_tab(a_nr_of_rows)    := tmp_disc_rel_tab(i_row3);
                                          a_net_price_tab(a_nr_of_rows)   := tmp_net_price_tab(i_row3);
                                          a_ac_code_tab(a_nr_of_rows)     := tmp_ac_code_tab(i_row3);
                                          a_active_tab(a_nr_of_rows)      := tmp_active_tab(i_row3);
                                          a_allow_modify_tab(a_nr_of_rows):= tmp_allow_modify_tab(i_row3);
                                          tmp_done_tab(i_row3)            := '1';
                                       END IF;
                                    END LOOP;

                                    -- Check if (pa not ended or journal is 'Offer') and new line to add
                                    IF (GetPgPaRec.exec_end_date IS NOT NULL OR a_journal_tp = 'Offer')
                                       AND b_newline THEN
                                       -- If pa not ended,
                                       -- then the price should not yet been taken into account
                                       a_nr_of_rows                       := a_nr_of_rows + 1;
                                       a_object_tp_tab(a_nr_of_rows)      := 'pr';
                                       a_object_version_tab(a_nr_of_rows) := vc2_pr_version;
                                       a_pp_key1_tab(a_nr_of_rows)        := ' ';
                                       a_pp_key2_tab(a_nr_of_rows)        := ' ';
                                       a_pp_key3_tab(a_nr_of_rows)        := ' ';
                                       a_pp_key4_tab(a_nr_of_rows)        := ' ';
                                       a_pp_key5_tab(a_nr_of_rows)        := ' ';
                                       a_rq_tab(a_nr_of_rows)             := vc2_rq;
                                       a_sc_tab(a_nr_of_rows)             := vc2_sc;
                                       a_pg_tab(a_nr_of_rows)             := vc2_pg;
                                       a_pgnode_tab(a_nr_of_rows)         := n_pgnode;
                                       a_pa_tab(a_nr_of_rows)             := vc2_pa;
                                       a_panode_tab(a_nr_of_rows)         := n_panode;
                                       a_me_tab(a_nr_of_rows)             := NULL;
                                       a_menode_tab(a_nr_of_rows)         := NULL;
                                       a_reanalysis_tab(a_nr_of_rows)     := n_reanalysis;
                                       a_description_tab(a_nr_of_rows)    := NVL(vc2_obj_desc,
                                                                                 vc2_description);

                                       IF a_inv_reanal IN ('Y','1') THEN
                                          a_qtity_tab(a_nr_of_rows) := n_reanalysis + 1;
                                       ELSE
                                          a_qtity_tab(a_nr_of_rows) := 1;
                                       END IF;

                                       -- Check if pr catalogue currency is default currency
                                       IF vc2_currency <> vc2_def_currency THEN
                                          -- Get the currency conversion
                                          SELECT conversion
                                          INTO f_conversion
                                          FROM utcurrency
                                          WHERE currency = vc2_currency;

                                          a_price_tab(a_nr_of_rows)     :=
                                             ROUND(f_input_price * f_def_conversion / f_conversion,
                                                   TO_NUMBER(vc2_def_rounding));
                                          a_disc_abs_tab(a_nr_of_rows)  :=
                                             ROUND(n_disc_abs * f_def_conversion / f_conversion,
                                                   TO_NUMBER(vc2_def_rounding));
                                          a_disc_rel_tab(a_nr_of_rows)  := n_disc_rel;
                                          a_net_price_tab(a_nr_of_rows) :=
                                             ROUND(a_qtity_tab(a_nr_of_rows)
                                                     * (a_price_tab(a_nr_of_rows)
                                                          - a_disc_abs_tab(a_nr_of_rows)
                                                          - (n_disc_rel * a_price_tab(a_nr_of_rows) / 100)),
                                                   TO_NUMBER(vc2_def_rounding));
                                       ELSE
                                          a_price_tab(a_nr_of_rows)     := f_input_price;
                                          a_disc_abs_tab(a_nr_of_rows)  := n_disc_abs;
                                          a_disc_rel_tab(a_nr_of_rows)  := n_disc_rel;
                                          a_net_price_tab(a_nr_of_rows) :=
                                             ROUND(a_qtity_tab(a_nr_of_rows) * f_net_price,
                                                   TO_NUMBER(vc2_def_rounding));
                                       END IF;

                                       -- Check if journal is 'Credit Note'
                                       IF a_journal_tp = 'Credit Note' THEN
                                          -- All prices negative
                                          a_price_tab(a_nr_of_rows)     := - a_price_tab(a_nr_of_rows);
                                          a_disc_abs_tab(a_nr_of_rows)  := - a_disc_abs_tab(a_nr_of_rows);
                                          a_disc_rel_tab(a_nr_of_rows)  := - a_disc_rel_tab(a_nr_of_rows);
                                          a_net_price_tab(a_nr_of_rows) := - a_net_price_tab(a_nr_of_rows);
                                       END IF;

                                       a_ac_code_tab(a_nr_of_rows)      := vc2_ac_code;
                                       a_active_tab(a_nr_of_rows)       := '1';
                                       a_allow_modify_tab(a_nr_of_rows) := '1';
                                    END IF;
                                 -- If not found, go searching a level lower
                                 ELSE
                                    CLOSE GetPrice;

                                    -- ME LEVEL --
                                    -- Loop the pame's
                                    FOR GetPaMeRec IN GetPaMe(vc2_sc,vc2_pg,n_pgnode,vc2_pa,n_panode) LOOP
                                       vc2_me          := GetPaMeRec.me;
                                       vc2_mt_version  := GetPaMeRec.mt_version;
                                       n_menode        := GetPaMeRec.menode;
                                       n_reanalysis    := GetPaMeRec.reanalysis;
                                       vc2_description := GetPaMeRec.description;

                                       -- Get mt criteria for all catalogues
                                       GetCriteria('_', 'mt', a_journal_nr, vc2_rq, vc2_sc,
                                                   vc2_pg, n_pgnode, vc2_pa, n_panode, vc2_me,
                                                   n_menode, n_cat_tab, n_crit_tab, vc2_critval_tab,
                                                   n_nr_of_crit, a_errorcode);

                                       FOR i_row2 IN 1..n_nr_of_crit LOOP
                                          IF (n_cat_tab(i_row2) = n_mt_catalogue)
                                             AND (n_crit_tab(i_row2) = 1) THEN
                                             vc2_crit1 := vc2_critval_tab(i_row2);
                                          END IF;
                                          IF (n_cat_tab(i_row2) = n_mt_catalogue)
                                             AND (n_crit_tab(i_row2) = 2) THEN
                                             vc2_crit2 := vc2_critval_tab(i_row2);
                                          END IF;
                                          IF (n_cat_tab(i_row2) = n_mt_catalogue)
                                             AND (n_crit_tab(i_row2) = 3) THEN
                                             vc2_crit3 := vc2_critval_tab(i_row2);
                                          END IF;
                                       END LOOP;

                                       -- Get the catalogue details, ordered by configuration catalogue.
                                       -- The fetch also contains the mt price.
                                       OPEN GetPrice(n_mt_catalogue, 'mt', vc2_me, vc2_mt_version,
                                                     ' ', ' ', ' ', ' ', ' ', vc2_crit1,
                                                     vc2_crit2, vc2_crit3, d_date);
                                       FETCH GetPrice INTO f_input_price, n_disc_abs, n_disc_rel,
                                                           f_calc_disc, f_net_price, vc2_currency,
                                                           vc2_obj_desc, vc2_ac_code;
                                       -- If found, then add line in journal details
                                       IF GetPrice%FOUND THEN
                                          vc2_key := vc2_rq||'@'||vc2_sc||'@'||vc2_pg||'@'||n_pgnode||
                                                     '@'||vc2_pa||'@'||n_panode||'@'||vc2_me||'@'||
                                                     n_menode;
                                          b_newline := TRUE;
                                          -- Loop the already existing journal details
                                          FOR i_row3 IN 1..tmp_nr_of_rows LOOP
                                             -- Check if the key matches and journal is not modifiable
                                             IF (tmp_key_tab(i_row3) = vc2_key)
                                                AND (tmp_allow_modify_tab(i_row3) = '0') THEN
                                                -- Don't overwrite, copy old line
                                                b_newline := FALSE;
                                                a_nr_of_rows                    := a_nr_of_rows + 1;
                                                a_object_tp_tab(a_nr_of_rows)   := tmp_object_tp_tab(i_row3);
                                                a_object_version_tab(a_nr_of_rows) := tmp_object_version_tab(i_row3);
                                                a_pp_key1_tab(a_nr_of_rows)     := tmp_pp_key1_tab(i_row3);
                                                a_pp_key2_tab(a_nr_of_rows)     := tmp_pp_key2_tab(i_row3);
                                                a_pp_key3_tab(a_nr_of_rows)     := tmp_pp_key3_tab(i_row3);
                                                a_pp_key4_tab(a_nr_of_rows)     := tmp_pp_key4_tab(i_row3);
                                                a_pp_key5_tab(a_nr_of_rows)     := tmp_pp_key5_tab(i_row3);
                                                a_rq_tab(a_nr_of_rows)          := tmp_rq_tab(i_row3);
                                                a_sc_tab(a_nr_of_rows)          := tmp_sc_tab(i_row3);
                                                a_pg_tab(a_nr_of_rows)          := tmp_pg_tab(i_row3);
                                                a_pgnode_tab(a_nr_of_rows)      := tmp_pgnode_tab(i_row3);
                                                a_pa_tab(a_nr_of_rows)          := tmp_pa_tab(i_row3);
                                                a_panode_tab(a_nr_of_rows)      := tmp_panode_tab(i_row3);
                                                a_me_tab(a_nr_of_rows)          := tmp_me_tab(i_row3);
                                                a_menode_tab(a_nr_of_rows)      := tmp_menode_tab(i_row3);
                                                a_reanalysis_tab(a_nr_of_rows)  := tmp_reanalysis_tab(i_row3);
                                                a_description_tab(a_nr_of_rows) := tmp_description_tab(i_row3);
                                                a_qtity_tab(a_nr_of_rows)       := tmp_qtity_tab(i_row3);
                                                a_price_tab(a_nr_of_rows)       := tmp_price_tab(i_row3);
                                                a_disc_abs_tab(a_nr_of_rows)    := tmp_disc_abs_tab(i_row3);
                                                a_disc_rel_tab(a_nr_of_rows)    := tmp_disc_rel_tab(i_row3);
                                                a_net_price_tab(a_nr_of_rows)   := tmp_net_price_tab(i_row3);
                                                a_ac_code_tab(a_nr_of_rows)     := tmp_ac_code_tab(i_row3);
                                                a_active_tab(a_nr_of_rows)      := tmp_active_tab(i_row3);
                                                a_allow_modify_tab(a_nr_of_rows):= tmp_allow_modify_tab(i_row3);
                                                tmp_done_tab(i_row3)            := '1';
                                             END IF;
                                          END LOOP;

                                          -- Check if (me not ended or journal is 'Offer') and new line to add
                                          IF (GetPaMeRec.exec_end_date IS NOT NULL OR a_journal_tp = 'Offer')
                                             AND b_newline THEN
                                             -- If me not ended,
                                             -- then the price should not yet been taken into account
                                             a_nr_of_rows                       := a_nr_of_rows + 1;
                                             a_object_tp_tab(a_nr_of_rows)      := 'mt';
                                             a_rq_tab(a_nr_of_rows)             := vc2_rq;
                                             a_sc_tab(a_nr_of_rows)             := vc2_sc;
                                             a_pg_tab(a_nr_of_rows)             := vc2_pg;
                                             a_pgnode_tab(a_nr_of_rows)         := n_pgnode;
                                             a_pa_tab(a_nr_of_rows)             := vc2_pa;
                                             a_panode_tab(a_nr_of_rows)         := n_panode;
                                             a_me_tab(a_nr_of_rows)             := vc2_me;
                                             a_menode_tab(a_nr_of_rows)         := n_menode;
                                             a_reanalysis_tab(a_nr_of_rows)     := n_reanalysis;
                                             a_object_version_tab(a_nr_of_rows) := vc2_mt_version;
                                             a_pp_key1_tab(a_nr_of_rows)        := ' ';
                                             a_pp_key2_tab(a_nr_of_rows)        := ' ';
                                             a_pp_key3_tab(a_nr_of_rows)        := ' ';
                                             a_pp_key4_tab(a_nr_of_rows)        := ' ';
                                             a_pp_key5_tab(a_nr_of_rows)        := ' ';
                                             a_description_tab(a_nr_of_rows)    := NVL(vc2_obj_desc,
                                                                                       vc2_description);

                                             IF a_inv_reanal IN ('Y','1') THEN
                                                a_qtity_tab(a_nr_of_rows) := n_reanalysis + 1;
                                             ELSE
                                                a_qtity_tab(a_nr_of_rows) := 1;
                                             END IF;

                                             -- Check if mt catalogue currency is default currency
                                             IF vc2_currency <> vc2_def_currency THEN
                                                -- Get the currency conversion
                                                SELECT conversion
                                                INTO f_conversion
                                                FROM utcurrency
                                                WHERE currency = vc2_currency;

                                                a_price_tab(a_nr_of_rows)     :=
                                                   ROUND(f_input_price * f_def_conversion / f_conversion,
                                                         TO_NUMBER(vc2_def_rounding));
                                                a_disc_abs_tab(a_nr_of_rows)  :=
                                                   ROUND(n_disc_abs * f_def_conversion / f_conversion,
                                                         TO_NUMBER(vc2_def_rounding));
                                                a_disc_rel_tab(a_nr_of_rows)  := n_disc_rel;
                                                a_net_price_tab(a_nr_of_rows) :=
                                                   ROUND(a_qtity_tab(a_nr_of_rows)
                                                            * (a_price_tab(a_nr_of_rows)
                                                                  - a_disc_abs_tab(a_nr_of_rows)
                                                                  - (n_disc_rel * a_price_tab(a_nr_of_rows) / 100)),
                                                         TO_NUMBER(vc2_def_rounding));
                                             ELSE
                                                a_price_tab(a_nr_of_rows)     := f_input_price;
                                                a_disc_abs_tab(a_nr_of_rows)  := n_disc_abs;
                                                a_disc_rel_tab(a_nr_of_rows)  := n_disc_rel;
                                                a_net_price_tab(a_nr_of_rows) :=
                                                   ROUND(a_qtity_tab(a_nr_of_rows) * f_net_price,
                                                         TO_NUMBER(vc2_def_rounding));
                                             END IF;


                                             -- Check if journal is 'Credit Note'
                                             IF a_journal_tp = 'Credit Note' THEN
                                                -- All prices negative
                                                a_price_tab(a_nr_of_rows)     := - a_price_tab(a_nr_of_rows);
                                                a_disc_abs_tab(a_nr_of_rows)  := - a_disc_abs_tab(a_nr_of_rows);
                                                a_disc_rel_tab(a_nr_of_rows)  := - a_disc_rel_tab(a_nr_of_rows);
                                                a_net_price_tab(a_nr_of_rows) := - a_net_price_tab(a_nr_of_rows);
                                             END IF;

                                             a_ac_code_tab(a_nr_of_rows)      := vc2_ac_code;
                                             a_active_tab(a_nr_of_rows)       := '1';
                                             a_allow_modify_tab(a_nr_of_rows) := '1';
                                          END IF;
                                       -- If not found, error
                                       ELSE
                                          a_errorcode := 2;
                                          Logmessage(a_journal_nr, a_errorcode,
                                             'No price found for me='||vc2_me||
                                                '#catalogue='||n_mt_catalogue||
                                                '#crit1='||vc2_crit1||'#crit2='||vc2_crit2||
                                                '#crit3='||vc2_crit3||
                                                ' for date '||TO_CHAR(d_date,'DD/MM/YYYY'));
                                       END IF;
                                       CLOSE GetPrice;
                                    END LOOP;
                                 END IF;
                              END LOOP;
                           END IF;
                        END LOOP;
                     END IF;
                  END LOOP;
               END IF;
            END IF;
         END LOOP;

      -----------------------------------------------------------
      -- Calculation type 2 = Fixed Price (prices rt's))
      -----------------------------------------------------------
      ELSIF UPPER(a_calc_tp) = 'FP' THEN
         -- Loop the rq's
         FOR i_row IN 1..a_nr_of_rq LOOP
            vc2_rq := a_rq_in_tab(i_row);

            SELECT rt, rt_version, ss, exec_end_date, description
            INTO vc2_rt,vc2_rt_version, vc2_rq_ss, d_rq_exec_end_date, vc2_rt_desc
            FROM utrq
            WHERE rq = vc2_rq;

            -- Check if rq not Canceled or Obsolete
            IF vc2_rq_ss NOT IN ('@C','@O') THEN
               -- Get rt criteria for rt catalogue
               GetCriteria(TO_CHAR(n_rt_catalogue), 'rt', a_journal_nr, vc2_rq,
                           NULL, NULL, NULL, NULL, NULL, NULL, NULL, n_cat_tab,
                           n_crit_tab, vc2_critval_tab, n_nr_of_crit, a_errorcode);

               FOR i_row2 IN 1..n_nr_of_crit LOOP
                  IF (n_cat_tab(i_row2) = n_rt_catalogue) AND (n_crit_tab(i_row2) = 1) THEN
                     vc2_crit1 := vc2_critval_tab(i_row2);
                  END IF;
                  IF (n_cat_tab(i_row2) = n_rt_catalogue) AND (n_crit_tab(i_row2) = 2) THEN
                     vc2_crit2 := vc2_critval_tab(i_row2);
                  END IF;
                  IF (n_cat_tab(i_row2) = n_rt_catalogue) AND (n_crit_tab(i_row2) = 3) THEN
                     vc2_crit3 := vc2_critval_tab(i_row2);
                  END IF;
               END LOOP;

               -- Get the catalogue details, ordered by configuration catalogue.
               -- The fetch also contains the rt price.
               OPEN GetPrice(n_rt_catalogue, 'rt', vc2_rt, vc2_rt_version, ' ', ' ',
                             ' ', ' ', ' ', vc2_crit1, vc2_crit2, vc2_crit3, d_date);
               FETCH GetPrice INTO f_input_price, n_disc_abs, n_disc_rel, f_calc_disc,
                                   f_net_price, vc2_currency, vc2_obj_desc, vc2_ac_code;
               -- If found, then add line in journal details
               IF GetPrice%FOUND THEN
                  vc2_key := vc2_rq||'@'||NULL||'@'||NULL||'@'||NULL||
                             '@'||NULL||'@'||NULL||'@'||NULL||'@'||NULL;
                  b_newline := TRUE;
                  -- Loop the already existing journal details
                  FOR i_row3 IN 1..tmp_nr_of_rows LOOP
                     -- Check if the key matches and journal is not modifiable
                     IF (tmp_key_tab(i_row3) = vc2_key) AND (tmp_allow_modify_tab(i_row3) = '0') THEN
                        -- Don't overwrite, copy old line
                        b_newline := FALSE;
                        a_nr_of_rows                       := a_nr_of_rows + 1;
                        a_object_tp_tab(a_nr_of_rows)      := tmp_object_tp_tab(i_row3);
                        a_object_version_tab(a_nr_of_rows) := tmp_object_version_tab(i_row3);
                        a_pp_key1_tab(a_nr_of_rows)        := tmp_pp_key1_tab(i_row3);
                        a_pp_key2_tab(a_nr_of_rows)        := tmp_pp_key2_tab(i_row3);
                        a_pp_key3_tab(a_nr_of_rows)        := tmp_pp_key3_tab(i_row3);
                        a_pp_key4_tab(a_nr_of_rows)        := tmp_pp_key4_tab(i_row3);
                        a_pp_key5_tab(a_nr_of_rows)        := tmp_pp_key5_tab(i_row3);
                        a_rq_tab(a_nr_of_rows)             := tmp_rq_tab(i_row3);
                        a_sc_tab(a_nr_of_rows)             := tmp_sc_tab(i_row3);
                        a_pg_tab(a_nr_of_rows)             := tmp_pg_tab(i_row3);
                        a_pgnode_tab(a_nr_of_rows)         := tmp_pgnode_tab(i_row3);
                        a_pa_tab(a_nr_of_rows)             := tmp_pa_tab(i_row3);
                        a_panode_tab(a_nr_of_rows)         := tmp_panode_tab(i_row3);
                        a_me_tab(a_nr_of_rows)             := tmp_me_tab(i_row3);
                        a_menode_tab(a_nr_of_rows)         := tmp_menode_tab(i_row3);
                        a_reanalysis_tab(a_nr_of_rows)     := tmp_reanalysis_tab(i_row3);
                        a_description_tab(a_nr_of_rows)    := tmp_description_tab(i_row3);
                        a_qtity_tab(a_nr_of_rows)          := tmp_qtity_tab(i_row3);
                        a_price_tab(a_nr_of_rows)          := tmp_price_tab(i_row3);
                        a_disc_abs_tab(a_nr_of_rows)       := tmp_disc_abs_tab(i_row3);
                        a_disc_rel_tab(a_nr_of_rows)       := tmp_disc_rel_tab(i_row3);
                        a_net_price_tab(a_nr_of_rows)      := tmp_net_price_tab(i_row3);
                        a_ac_code_tab(a_nr_of_rows)        := tmp_ac_code_tab(i_row3);
                        a_active_tab(a_nr_of_rows)         := tmp_active_tab(i_row3);
                        a_allow_modify_tab(a_nr_of_rows)   := tmp_allow_modify_tab(i_row3);
                        tmp_done_tab(i_row3)               := '1';
                     END IF;
                  END LOOP;

                  -- Check if (rq not ended or journal is 'Offer') and new line to add
                  IF (d_rq_exec_end_date IS NOT NULL OR a_journal_tp = 'Offer') AND b_newline THEN
                     -- If rq not ended, then the price should not yet been taken into account
                     a_nr_of_rows                       := a_nr_of_rows + 1;
                     a_object_tp_tab(a_nr_of_rows)      := 'rt';
                     a_object_version_tab(a_nr_of_rows) := vc2_rt_version;
                     a_pp_key1_tab(a_nr_of_rows)        := ' ';
                     a_pp_key2_tab(a_nr_of_rows)        := ' ';
                     a_pp_key3_tab(a_nr_of_rows)        := ' ';
                     a_pp_key4_tab(a_nr_of_rows)        := ' ';
                     a_pp_key5_tab(a_nr_of_rows)        := ' ';
                     a_rq_tab(a_nr_of_rows)             := vc2_rq;
                     a_sc_tab(a_nr_of_rows)             := NULL;
                     a_pg_tab(a_nr_of_rows)             := NULL;
                     a_pgnode_tab(a_nr_of_rows)         := NULL;
                     a_pa_tab(a_nr_of_rows)             := NULL;
                     a_panode_tab(a_nr_of_rows)         := NULL;
                     a_me_tab(a_nr_of_rows)             := NULL;
                     a_menode_tab(a_nr_of_rows)         := NULL;
                     a_reanalysis_tab(a_nr_of_rows)     := NULL;
                     a_description_tab(a_nr_of_rows)    := NVL(vc2_obj_desc,vc2_rt_desc);
                     a_qtity_tab(a_nr_of_rows)          := 1;

                     -- Check if rt catalogue currency is default currency
                     IF vc2_currency <> vc2_def_currency THEN
                        -- Get the currency conversion
                        SELECT conversion
                        INTO f_conversion
                        FROM utcurrency
                        WHERE currency = vc2_currency;

                        a_price_tab(a_nr_of_rows)     :=
                           ROUND(f_input_price * f_def_conversion / f_conversion,
                                 TO_NUMBER(vc2_def_rounding));
                        a_disc_abs_tab(a_nr_of_rows)  :=
                           ROUND(n_disc_abs * f_def_conversion / f_conversion,
                                 TO_NUMBER(vc2_def_rounding));
                        a_disc_rel_tab(a_nr_of_rows)  := n_disc_rel;
                        a_net_price_tab(a_nr_of_rows) :=
                           ROUND(a_qtity_tab(a_nr_of_rows)
                                    * (a_price_tab(a_nr_of_rows)
                                          - a_disc_abs_tab(a_nr_of_rows)
                                          - (n_disc_rel * a_price_tab(a_nr_of_rows) / 100)),
                                 TO_NUMBER(vc2_def_rounding));
                     ELSE
                        a_price_tab(a_nr_of_rows)     := f_input_price;
                        a_disc_abs_tab(a_nr_of_rows)  := n_disc_abs;
                        a_disc_rel_tab(a_nr_of_rows)  := n_disc_rel;
                        a_net_price_tab(a_nr_of_rows) :=
                           ROUND(a_qtity_tab(a_nr_of_rows) * f_net_price,
                                 TO_NUMBER(vc2_def_rounding));
                     END IF;

                     -- Check if journal is 'Credit Note'
                     IF a_journal_tp = 'Credit Note' THEN
                        -- All prices negative
                        a_price_tab(a_nr_of_rows)     := - a_price_tab(a_nr_of_rows);
                        a_disc_abs_tab(a_nr_of_rows)  := - a_disc_abs_tab(a_nr_of_rows);
                        a_disc_rel_tab(a_nr_of_rows)  := - a_disc_rel_tab(a_nr_of_rows);
                        a_net_price_tab(a_nr_of_rows) := - a_net_price_tab(a_nr_of_rows);
                     END IF;

                     a_ac_code_tab(a_nr_of_rows)      := vc2_ac_code;
                     a_active_tab(a_nr_of_rows)       := '1';
                     a_allow_modify_tab(a_nr_of_rows) := '1';
                  END IF;
               -- If not found, error
               ELSE
                  a_errorcode := 2;
                  Logmessage(a_journal_nr, a_errorcode,
                             'No price found for rq='||vc2_rq||'#catalogue='||
                                n_rt_catalogue||'#crit1='||vc2_crit1||'#crit2='||
                                vc2_crit2||'#crit3='||vc2_crit3||' for date '||
                                TO_CHAR(d_date,'DD/MM/YYYY'));
               END IF;
               CLOSE GetPrice;
            END IF;
         END LOOP;
      --------------------------------------------------------------------------------------
      -- Calculation type 3 = Parametergroup Prices (price pg's / analysispackages)
      --------------------------------------------------------------------------------------
      ELSIF UPPER(a_calc_tp) = 'GP' THEN
         -- Loop the rq's
         FOR i_row IN 1..a_nr_of_rq LOOP
            vc2_rq := a_rq_in_tab(i_row);

            SELECT ss, exec_end_date
            INTO vc2_rq_ss, d_rq_exec_end_date
            FROM utrq
            WHERE rq = vc2_rq;

            -- Check if rq not Canceled or Obsolete
            IF vc2_rq_ss NOT IN ('@C','@O') THEN
               -- Get rt criteria for pp catalogue
               GetCriteria(TO_CHAR(n_pp_catalogue), 'rt', a_journal_nr, vc2_rq,
                           NULL, NULL, NULL, NULL, NULL, NULL, NULL, n_cat_tab,
                           n_crit_tab, vc2_critval_tab, n_nr_of_crit, a_errorcode);

               FOR i_row2 IN 1..n_nr_of_crit LOOP
                  IF (n_cat_tab(i_row2) = n_pp_catalogue) AND (n_crit_tab(i_row2) = 1) THEN
                     vc2_crit1 := vc2_critval_tab(i_row2);
                  END IF;
                  IF (n_cat_tab(i_row2) = n_pp_catalogue) AND (n_crit_tab(i_row2) = 2) THEN
                     vc2_crit2 := vc2_critval_tab(i_row2);
                  END IF;
                  IF (n_cat_tab(i_row2) = n_pp_catalogue) AND (n_crit_tab(i_row2) = 3) THEN
                     vc2_crit3 := vc2_critval_tab(i_row2);
                  END IF;
               END LOOP;

               -- Loop the rqsc's
               FOR GetRqScRec IN GetRqSc(vc2_rq) LOOP
                  vc2_sc := GetRqScRec.sc;

                  -- Get st criteria for pp catalogue
                  GetCriteria(TO_CHAR(n_pp_catalogue), 'st', a_journal_nr, vc2_rq, vc2_sc,
                              NULL, NULL, NULL, NULL, NULL, NULL, n_cat_tab, n_crit_tab,
                              vc2_critval_tab, n_nr_of_crit, a_errorcode);

                  FOR i_row2 IN 1..n_nr_of_crit LOOP
                     IF (n_cat_tab(i_row2) = n_pp_catalogue) AND (n_crit_tab(i_row2) = 1) THEN
                        vc2_crit1 := vc2_critval_tab(i_row2);
                     END IF;
                     IF (n_cat_tab(i_row2) = n_pp_catalogue) AND (n_crit_tab(i_row2) = 2) THEN
                        vc2_crit2 := vc2_critval_tab(i_row2);
                     END IF;
                     IF (n_cat_tab(i_row2) = n_pp_catalogue) AND (n_crit_tab(i_row2) = 3) THEN
                        vc2_crit3 := vc2_critval_tab(i_row2);
                     END IF;
                  END LOOP;

                  -- Loop the scpg's
                  FOR GetScPgRec IN GetScPg(vc2_sc) LOOP
                     vc2_pg          := GetScPgRec.pg;
                     vc2_pp_version  := GetScPgRec.pp_version;
                     vc2_pp_key1     := GetScPgRec.pp_key1;
                     vc2_pp_key2     := GetScPgRec.pp_key2;
                     vc2_pp_key3     := GetScPgRec.pp_key3;
                     vc2_pp_key4     := GetScPgRec.pp_key4;
                     vc2_pp_key5     := GetScPgRec.pp_key5;
                     n_pgnode        := GetScPgRec.pgnode;
                     n_reanalysis    := GetScPgRec.reanalysis;
                     vc2_description := GetScPgRec.description;

                     -- Get pp criteria for pp catalogue
                     GetCriteria(TO_CHAR(n_pp_catalogue), 'pp', a_journal_nr, vc2_rq,
                                 vc2_sc, vc2_pg, n_pgnode, NULL, NULL, NULL, NULL,
                                 n_cat_tab, n_crit_tab, vc2_critval_tab, n_nr_of_crit,
                                 a_errorcode);

                     FOR i_row2 IN 1..n_nr_of_crit LOOP
                        IF (n_cat_tab(i_row2) = n_pp_catalogue) AND (n_crit_tab(i_row2) = 1) THEN
                           vc2_crit1 := vc2_critval_tab(i_row2);
                        END IF;
                        IF (n_cat_tab(i_row2) = n_pp_catalogue) AND (n_crit_tab(i_row2) = 2) THEN
                           vc2_crit2 := vc2_critval_tab(i_row2);
                        END IF;
                        IF (n_cat_tab(i_row2) = n_pp_catalogue) AND (n_crit_tab(i_row2) = 3) THEN
                           vc2_crit3 := vc2_critval_tab(i_row2);
                        END IF;
                     END LOOP;

                     -- Get the catalogue details, ordered by configuration catalogue.
                     -- The fetch also contains the pp price.
                     OPEN GetPrice(n_pp_catalogue, 'pp', vc2_pg, vc2_pp_version, vc2_pp_key1,
                                   vc2_pp_key2, vc2_pp_key3, vc2_pp_key4, vc2_pp_key5,
                                   vc2_crit1, vc2_crit2, vc2_crit3, d_date);
                     FETCH GetPrice INTO f_input_price, n_disc_abs, n_disc_rel, f_calc_disc,
                                         f_net_price, vc2_currency, vc2_obj_desc, vc2_ac_code;
                     -- If found, then add line in journal details
                     IF GetPrice%FOUND THEN
                        vc2_key := vc2_rq||'@'||vc2_sc||'@'||vc2_pg||'@'||n_pgnode||
                                   '@'||NULL||'@'||NULL||'@'||NULL||'@'||NULL;
                        b_newline := TRUE;
                        -- Loop the already existing journal details
                        FOR i_row3 IN 1..tmp_nr_of_rows LOOP
                           -- Check if the key matches and journal is not modifiable
                           IF (tmp_key_tab(i_row3) = vc2_key) AND (tmp_allow_modify_tab(i_row3) = '0') THEN
                              -- Don't overwrite, copy old line
                              b_newline := FALSE ;
                              a_nr_of_rows                       := a_nr_of_rows + 1;
                              a_object_tp_tab(a_nr_of_rows)      := tmp_object_tp_tab(i_row3);
                              a_object_version_tab(a_nr_of_rows) := tmp_object_version_tab(i_row3);
                              a_pp_key1_tab(a_nr_of_rows)        := tmp_pp_key1_tab(i_row3);
                              a_pp_key2_tab(a_nr_of_rows)        := tmp_pp_key2_tab(i_row3);
                              a_pp_key3_tab(a_nr_of_rows)        := tmp_pp_key3_tab(i_row3);
                              a_pp_key4_tab(a_nr_of_rows)        := tmp_pp_key4_tab(i_row3);
                              a_pp_key5_tab(a_nr_of_rows)        := tmp_pp_key5_tab(i_row3);
                              a_rq_tab(a_nr_of_rows)             := tmp_rq_tab(i_row3);
                              a_sc_tab(a_nr_of_rows)             := tmp_sc_tab(i_row3);
                              a_pg_tab(a_nr_of_rows)             := tmp_pg_tab(i_row3);
                              a_pgnode_tab(a_nr_of_rows)         := tmp_pgnode_tab(i_row3);
                              a_pa_tab(a_nr_of_rows)             := tmp_pa_tab(i_row3);
                              a_panode_tab(a_nr_of_rows)         := tmp_panode_tab(i_row3);
                              a_me_tab(a_nr_of_rows)             := tmp_me_tab(i_row3);
                              a_menode_tab(a_nr_of_rows)         := tmp_menode_tab(i_row3);
                              a_reanalysis_tab(a_nr_of_rows)     := tmp_reanalysis_tab(i_row3);
                              a_description_tab(a_nr_of_rows)    := tmp_description_tab(i_row3);
                              a_qtity_tab(a_nr_of_rows)          := tmp_qtity_tab(i_row3);
                              a_price_tab(a_nr_of_rows)          := tmp_price_tab(i_row3);
                              a_disc_abs_tab(a_nr_of_rows)       := tmp_disc_abs_tab(i_row3);
                              a_disc_rel_tab(a_nr_of_rows)       := tmp_disc_rel_tab(i_row3);
                              a_net_price_tab(a_nr_of_rows)      := tmp_net_price_tab(i_row3);
                              a_ac_code_tab(a_nr_of_rows)        := tmp_ac_code_tab(i_row3);
                              a_active_tab(a_nr_of_rows)         := tmp_active_tab(i_row3);
                              a_allow_modify_tab(a_nr_of_rows)   := tmp_allow_modify_tab(i_row3);
                              tmp_done_tab(i_row3)               := '1';
                           END IF;
                        END LOOP;

                        -- Check if (pg not ended or journal is 'Offer') and new line to add
                        IF (GetScPgRec.exec_end_date IS NOT NULL OR a_journal_tp = 'Offer')
                           AND b_newline THEN
                           -- If pg not ended, then the price should not yet been taken into account
                           a_nr_of_rows                       := a_nr_of_rows + 1;
                           a_object_tp_tab(a_nr_of_rows)      := 'pp';
                           a_object_version_tab(a_nr_of_rows) := vc2_pp_version;
                           a_pp_key1_tab(a_nr_of_rows)        := vc2_pp_key1;
                           a_pp_key2_tab(a_nr_of_rows)        := vc2_pp_key2;
                           a_pp_key3_tab(a_nr_of_rows)        := vc2_pp_key3;
                           a_pp_key4_tab(a_nr_of_rows)        := vc2_pp_key4;
                           a_pp_key5_tab(a_nr_of_rows)        := vc2_pp_key5;
                           a_rq_tab(a_nr_of_rows)             := vc2_rq;
                           a_sc_tab(a_nr_of_rows)             := vc2_sc;
                           a_pg_tab(a_nr_of_rows)             := vc2_pg;
                           a_pgnode_tab(a_nr_of_rows)         := n_pgnode;
                           a_pa_tab(a_nr_of_rows)             := NULL;
                           a_panode_tab(a_nr_of_rows)         := NULL;
                           a_me_tab(a_nr_of_rows)             := NULL;
                           a_menode_tab(a_nr_of_rows)         := NULL;
                           a_reanalysis_tab(a_nr_of_rows)     := n_reanalysis;
                           a_description_tab(a_nr_of_rows)    := NVL(vc2_obj_desc,vc2_description);

                           IF a_inv_reanal IN ('Y','1') THEN
                              a_qtity_tab(a_nr_of_rows) := n_reanalysis + 1;
                           ELSE
                              a_qtity_tab(a_nr_of_rows) := 1;
                           END IF;

                           -- Check if pp catalogue currency is default currency
                           IF vc2_currency <> vc2_def_currency THEN
                              -- Get the currency conversion
                              SELECT conversion
                              INTO f_conversion
                              FROM utcurrency
                              WHERE currency = vc2_currency;

                              a_price_tab(a_nr_of_rows)     :=
                                 ROUND(f_input_price * f_def_conversion / f_conversion,
                                       TO_NUMBER(vc2_def_rounding));
                              a_disc_abs_tab(a_nr_of_rows)  :=
                                 ROUND(n_disc_abs * f_def_conversion / f_conversion,
                                       TO_NUMBER(vc2_def_rounding));
                              a_disc_rel_tab(a_nr_of_rows)  := n_disc_rel;
                              a_net_price_tab(a_nr_of_rows) :=
                                 ROUND(a_qtity_tab(a_nr_of_rows)
                                          * (a_price_tab(a_nr_of_rows)
                                                - a_disc_abs_tab(a_nr_of_rows)
                                                - (n_disc_rel * a_price_tab(a_nr_of_rows) / 100)),
                                       TO_NUMBER(vc2_def_rounding));
                           ELSE
                              a_price_tab(a_nr_of_rows)     := f_input_price;
                              a_disc_abs_tab(a_nr_of_rows)  := n_disc_abs;
                              a_disc_rel_tab(a_nr_of_rows)  := n_disc_rel;
                              a_net_price_tab(a_nr_of_rows) :=
                                 ROUND(a_qtity_tab(a_nr_of_rows) * f_net_price,
                                       TO_NUMBER(vc2_def_rounding));
                           END IF;

                           -- Check if journal is 'Credit Note'
                           IF a_journal_tp = 'Credit Note' THEN
                              -- All prices negative
                              a_price_tab(a_nr_of_rows)     := - a_price_tab(a_nr_of_rows);
                              a_disc_abs_tab(a_nr_of_rows)  := - a_disc_abs_tab(a_nr_of_rows);
                              a_disc_rel_tab(a_nr_of_rows)  := - a_disc_rel_tab(a_nr_of_rows);
                              a_net_price_tab(a_nr_of_rows) := - a_net_price_tab(a_nr_of_rows);
                           END IF;

                           a_ac_code_tab(a_nr_of_rows)      := vc2_ac_code;
                           a_active_tab(a_nr_of_rows)       := '1';
                           a_allow_modify_tab(a_nr_of_rows) := '1';
                        END IF;
                     -- If not found, error
                     ELSE
                        a_errorcode := 2;
                        Logmessage(a_journal_nr, a_errorcode,
                                   'No price found for pg='||vc2_pg||
                                       '#catalogue='||n_pp_catalogue||
                                       '#crit1='||vc2_crit1||'#crit2='||vc2_crit2||
                                       '#crit3='||vc2_crit3||
                                       ' for date '||TO_CHAR(d_date,'DD/MM/YYYY'));
                     END IF;
                     CLOSE GetPrice;
                  END LOOP;
               END LOOP;
            END IF;
         END LOOP;
      ---------------------------------------------------------
      -- Calculation type 4 = Method Prices (Sum me prices)
      ---------------------------------------------------------
      ELSIF UPPER(a_calc_tp) = 'MT' THEN
         -- Loop the rq's
         FOR i_row IN 1..a_nr_of_rq LOOP
            vc2_rq := a_rq_in_tab(i_row);

            SELECT ss, exec_end_date
            INTO vc2_rq_ss, d_rq_exec_end_date
            FROM utrq
            WHERE rq = vc2_rq;

            -- Check if rq not Canceled or Obsolete
            IF vc2_rq_ss NOT IN ('@C','@O') THEN
               -- Get rt criteria for mt catalogue
               GetCriteria(TO_CHAR(n_mt_catalogue), 'rt', a_journal_nr, vc2_rq,
                           NULL, NULL, NULL, NULL, NULL, NULL, NULL, n_cat_tab,
                           n_crit_tab, vc2_critval_tab, n_nr_of_crit, a_errorcode);

               FOR i_row2 IN 1..n_nr_of_crit LOOP
                  IF (n_cat_tab(i_row2) = n_mt_catalogue) AND (n_crit_tab(i_row2) = 1) THEN
                     vc2_crit1 := vc2_critval_tab(i_row2);
                  END IF;
                  IF (n_cat_tab(i_row2) = n_mt_catalogue) AND (n_crit_tab(i_row2) = 2) THEN
                     vc2_crit2 := vc2_critval_tab(i_row2);
                  END IF;
                  IF (n_cat_tab(i_row2) = n_mt_catalogue) AND (n_crit_tab(i_row2) = 3) THEN
                     vc2_crit3 := vc2_critval_tab(i_row2);
                  END IF;
               END LOOP;

               -- Loop the rqsc's
               FOR GetRqScRec IN GetRqSc(vc2_rq) LOOP
                  vc2_sc := GetRqScRec.sc;

                  -- Get st criteria for mt catalogue
                  GetCriteria(TO_CHAR(n_mt_catalogue), 'st', a_journal_nr, vc2_rq,
                              vc2_sc, NULL, NULL, NULL, NULL, NULL, NULL, n_cat_tab,
                              n_crit_tab, vc2_critval_tab, n_nr_of_crit, a_errorcode);

                  FOR i_row2 IN 1..n_nr_of_crit LOOP
                     IF (n_cat_tab(i_row2) = n_mt_catalogue) AND (n_crit_tab(i_row2) = 1) THEN
                        vc2_crit1 := vc2_critval_tab(i_row2);
                     END IF;
                     IF (n_cat_tab(i_row2) = n_mt_catalogue) AND (n_crit_tab(i_row2) = 2) THEN
                        vc2_crit2 := vc2_critval_tab(i_row2);
                     END IF;
                     IF (n_cat_tab(i_row2) = n_mt_catalogue) AND (n_crit_tab(i_row2) = 3) THEN
                        vc2_crit3 := vc2_critval_tab(i_row2);
                     END IF;
                  END LOOP;

                  -- Loop the scpg's
                  FOR GetScPgRec IN GetScPg(vc2_sc) LOOP
                     vc2_pg          := GetScPgRec.pg;
                     vc2_pp_version  := GetScPgRec.pp_version;
                     vc2_pp_key1     := GetScPgRec.pp_key1;
                     vc2_pp_key2     := GetScPgRec.pp_key2;
                     vc2_pp_key3     := GetScPgRec.pp_key3;
                     vc2_pp_key4     := GetScPgRec.pp_key4;
                     vc2_pp_key5     := GetScPgRec.pp_key5;
                     n_pgnode        := GetScPgRec.pgnode;
                     n_reanalysis    := GetScPgRec.reanalysis;
                     vc2_description := GetScPgRec.description;

                     -- Get pp criteria for mt catalogue
                     GetCriteria(TO_CHAR(n_mt_catalogue), 'pp', a_journal_nr, vc2_rq,
                                 vc2_sc, vc2_pg, n_pgnode, NULL, NULL, NULL, NULL,
                                 n_cat_tab, n_crit_tab, vc2_critval_tab, n_nr_of_crit,
                                 a_errorcode);

                     FOR i_row2 IN 1..n_nr_of_crit LOOP
                        IF (n_cat_tab(i_row2) = n_mt_catalogue) AND (n_crit_tab(i_row2) = 1) THEN
                           vc2_crit1 := vc2_critval_tab(i_row2);
                        END IF;
                        IF (n_cat_tab(i_row2) = n_mt_catalogue) AND (n_crit_tab(i_row2) = 2) THEN
                           vc2_crit2 := vc2_critval_tab(i_row2);
                        END IF;
                        IF (n_cat_tab(i_row2) = n_mt_catalogue) AND (n_crit_tab(i_row2) = 3) THEN
                           vc2_crit3 := vc2_critval_tab(i_row2);
                        END IF;
                     END LOOP;

                     -- Loop the pgpa's
                     FOR GetPgPaRec IN GetPgPa(vc2_sc,vc2_pg,n_pgnode) LOOP
                        vc2_pa          := GetPgPaRec.pa;
                        n_panode        := GetPgPaRec.panode;
                        n_reanalysis    := GetPgPaRec.reanalysis;
                        vc2_description := GetPgPaRec.description;

                        -- Get pr criteria for mt catalogue
                        GetCriteria(TO_CHAR(n_mt_catalogue), 'pr', a_journal_nr,
                                    vc2_rq, vc2_sc, vc2_pg, n_pgnode, vc2_pa, n_panode,
                                    NULL, NULL, n_cat_tab, n_crit_tab, vc2_critval_tab,
                                    n_nr_of_crit, a_errorcode);

                        FOR i_row2 IN 1..n_nr_of_crit LOOP
                           IF (n_cat_tab(i_row2) = n_mt_catalogue) AND (n_crit_tab(i_row2) = 1) THEN
                              vc2_crit1 := vc2_critval_tab(i_row2);
                           END IF;
                           IF (n_cat_tab(i_row2) = n_mt_catalogue) AND (n_crit_tab(i_row2) = 2) THEN
                              vc2_crit2 := vc2_critval_tab(i_row2);
                           END IF;
                           IF (n_cat_tab(i_row2) = n_mt_catalogue) AND (n_crit_tab(i_row2) = 3) THEN
                              vc2_crit3 := vc2_critval_tab(i_row2);
                           END IF;
                        END LOOP;

                        -- Loop the pame's
                        FOR GetPaMeRec IN GetPaMe(vc2_sc,vc2_pg,n_pgnode,vc2_pa,n_panode) LOOP
                           vc2_me          := GetPaMeRec.me;
                           vc2_mt_version  := GetPaMeRec.mt_version;
                           n_menode        := GetPaMeRec.menode;
                           n_reanalysis    := GetPaMeRec.reanalysis;
                           vc2_description := GetPaMeRec.description;

                           -- Get mt criteria for mt catalogue
                           GetCriteria(TO_CHAR(n_mt_catalogue), 'mt', a_journal_nr, vc2_rq,
                                       vc2_sc, vc2_pg, n_pgnode, vc2_pa, n_panode, vc2_me,
                                       n_menode, n_cat_tab, n_crit_tab, vc2_critval_tab,
                                       n_nr_of_crit, a_errorcode);

                           FOR i_row2 IN 1..n_nr_of_crit LOOP
                              IF (n_cat_tab(i_row2) = n_mt_catalogue) AND (n_crit_tab(i_row2) = 1) THEN
                                 vc2_crit1 := vc2_critval_tab(i_row2);
                              END IF;
                              IF (n_cat_tab(i_row2) = n_mt_catalogue) AND (n_crit_tab(i_row2) = 2) THEN
                                 vc2_crit2 := vc2_critval_tab(i_row2);
                              END IF;
                              IF (n_cat_tab(i_row2) = n_mt_catalogue) AND (n_crit_tab(i_row2) = 3) THEN
                                 vc2_crit3 := vc2_critval_tab(i_row2);
                              END IF;
                           END LOOP;

                           -- Get the catalogue details, ordered by configuration catalogue.
                           -- The fetch also contains the mt price.
                           OPEN GetPrice(n_mt_catalogue, 'mt', vc2_me, vc2_mt_version,
                                         ' ', ' ', ' ', ' ', ' ', vc2_crit1, vc2_crit2,
                                         vc2_crit3, d_date);
                           FETCH GetPrice INTO f_input_price, n_disc_abs, n_disc_rel, f_calc_disc,
                                               f_net_price, vc2_currency, vc2_obj_desc, vc2_ac_code;
                           -- If found, then add line in journal details
                           IF GetPrice%FOUND THEN
                              vc2_key := vc2_rq||'@'||vc2_sc||'@'||vc2_pg||'@'||n_pgnode||
                                         '@'||vc2_pa||'@'||n_panode||'@'||vc2_me||'@'||n_menode;
                              b_newline := TRUE;
                              -- Loop the already existing journal details
                              FOR i_row3 IN 1..tmp_nr_of_rows LOOP
                                 -- Check if the key matches and journal is not modifiable
                                 IF (tmp_key_tab(i_row3) = vc2_key)
                                    AND (tmp_allow_modify_tab(i_row3) = '0') THEN
                                    -- Don't overwrite, copy old line
                                    b_newline := FALSE;
                                    a_nr_of_rows                       := a_nr_of_rows + 1;
                                    a_object_tp_tab(a_nr_of_rows)      := tmp_object_tp_tab(i_row3);
                                    a_object_version_tab(a_nr_of_rows) := tmp_object_version_tab(i_row3);
                                    a_pp_key1_tab(a_nr_of_rows)        := tmp_pp_key1_tab(i_row3);
                                    a_pp_key2_tab(a_nr_of_rows)        := tmp_pp_key2_tab(i_row3);
                                    a_pp_key3_tab(a_nr_of_rows)        := tmp_pp_key3_tab(i_row3);
                                    a_pp_key4_tab(a_nr_of_rows)        := tmp_pp_key4_tab(i_row3);
                                    a_pp_key5_tab(a_nr_of_rows)        := tmp_pp_key5_tab(i_row3);
                                    a_rq_tab(a_nr_of_rows)             := tmp_rq_tab(i_row3);
                                    a_sc_tab(a_nr_of_rows)             := tmp_sc_tab(i_row3);
                                    a_pg_tab(a_nr_of_rows)             := tmp_pg_tab(i_row3);
                                    a_pgnode_tab(a_nr_of_rows)         := tmp_pgnode_tab(i_row3);
                                    a_pa_tab(a_nr_of_rows)             := tmp_pa_tab(i_row3);
                                    a_panode_tab(a_nr_of_rows)         := tmp_panode_tab(i_row3);
                                    a_me_tab(a_nr_of_rows)             := tmp_me_tab(i_row3);
                                    a_menode_tab(a_nr_of_rows)         := tmp_menode_tab(i_row3);
                                    a_reanalysis_tab(a_nr_of_rows)     := tmp_reanalysis_tab(i_row3);
                                    a_description_tab(a_nr_of_rows)    := tmp_description_tab(i_row3);
                                    a_qtity_tab(a_nr_of_rows)          := tmp_qtity_tab(i_row3);
                                    a_price_tab(a_nr_of_rows)          := tmp_price_tab(i_row3);
                                    a_disc_abs_tab(a_nr_of_rows)       := tmp_disc_abs_tab(i_row3);
                                    a_disc_rel_tab(a_nr_of_rows)       := tmp_disc_rel_tab(i_row3);
                                    a_net_price_tab(a_nr_of_rows)      := tmp_net_price_tab(i_row3);
                                    a_ac_code_tab(a_nr_of_rows)        := tmp_ac_code_tab(i_row3);
                                    a_active_tab(a_nr_of_rows)         := tmp_active_tab(i_row3);
                                    a_allow_modify_tab(a_nr_of_rows)   := tmp_allow_modify_tab(i_row3);
                                    tmp_done_tab(i_row3)               := '1';
                                 END IF;
                              END LOOP;

                              -- Check if (me not ended or journal is 'Offer') and new line to add
                              IF (GetPaMeRec.exec_end_date IS NOT NULL OR a_journal_tp = 'Offer')
                                 AND b_newline THEN
                                 -- If me not ended, then the price should not yet been taken into account
                                 a_nr_of_rows                       := a_nr_of_rows + 1;
                                 a_object_tp_tab(a_nr_of_rows)      := 'mt';
                                 a_object_version_tab(a_nr_of_rows) := vc2_mt_version;
                                 a_pp_key1_tab(a_nr_of_rows)        := ' ';
                                 a_pp_key2_tab(a_nr_of_rows)        := ' ';
                                 a_pp_key3_tab(a_nr_of_rows)        := ' ';
                                 a_pp_key4_tab(a_nr_of_rows)        := ' ';
                                 a_pp_key5_tab(a_nr_of_rows)        := ' ';
                                 a_rq_tab(a_nr_of_rows)             := vc2_rq;
                                 a_sc_tab(a_nr_of_rows)             := vc2_sc;
                                 a_pg_tab(a_nr_of_rows)             := vc2_pg;
                                 a_pgnode_tab(a_nr_of_rows)         := n_pgnode;
                                 a_pa_tab(a_nr_of_rows)             := vc2_pa;
                                 a_panode_tab(a_nr_of_rows)         := n_panode;
                                 a_me_tab(a_nr_of_rows)             := vc2_me;
                                 a_menode_tab(a_nr_of_rows)         := n_menode;
                                 a_reanalysis_tab(a_nr_of_rows)     := n_reanalysis;
                                 a_description_tab(a_nr_of_rows)    := NVL(vc2_obj_desc,
                                                                           vc2_description);

                                 IF a_inv_reanal IN ('Y','1') THEN
                                    a_qtity_tab(a_nr_of_rows) := n_reanalysis + 1;
                                 ELSE
                                    a_qtity_tab(a_nr_of_rows) := 1;
                                 END IF;

                                 -- Check if mt catalogue currency is default currency
                                 IF vc2_currency <> vc2_def_currency THEN
                                    -- Get the currency conversion
                                    SELECT conversion
                                    INTO f_conversion
                                    FROM utcurrency
                                    WHERE currency = vc2_currency;

                                    a_price_tab(a_nr_of_rows)     :=
                                       ROUND(f_input_price * f_def_conversion / f_conversion,
                                             TO_NUMBER(vc2_def_rounding));
                                    a_disc_abs_tab(a_nr_of_rows)  :=
                                       ROUND(n_disc_abs * f_def_conversion / f_conversion,
                                             TO_NUMBER(vc2_def_rounding));
                                    a_disc_rel_tab(a_nr_of_rows)  := n_disc_rel;
                                    a_net_price_tab(a_nr_of_rows) :=
                                       ROUND(a_qtity_tab(a_nr_of_rows)
                                                * (a_price_tab(a_nr_of_rows)
                                                      - a_disc_abs_tab(a_nr_of_rows)
                                                      - (n_disc_rel * a_price_tab(a_nr_of_rows) / 100)),
                                             TO_NUMBER(vc2_def_rounding));
                                 ELSE
                                    a_price_tab(a_nr_of_rows)     := f_input_price;
                                    a_disc_abs_tab(a_nr_of_rows)  := n_disc_abs;
                                    a_disc_rel_tab(a_nr_of_rows)  := n_disc_rel;
                                    a_net_price_tab(a_nr_of_rows) :=
                                       ROUND(a_qtity_tab(a_nr_of_rows) * f_net_price,
                                             TO_NUMBER(vc2_def_rounding));
                                 END IF;

                                 -- Check if journal is 'Credit Note'
                                 IF a_journal_tp = 'Credit Note' THEN
                                    -- All prices negative
                                    a_price_tab(a_nr_of_rows)     := - a_price_tab(a_nr_of_rows);
                                    a_disc_abs_tab(a_nr_of_rows)  := - a_disc_abs_tab(a_nr_of_rows);
                                    a_disc_rel_tab(a_nr_of_rows)  := - a_disc_rel_tab(a_nr_of_rows);
                                    a_net_price_tab(a_nr_of_rows) := - a_net_price_tab(a_nr_of_rows);
                                 END IF;

                                 a_ac_code_tab(a_nr_of_rows)      := vc2_ac_code;
                                 a_active_tab(a_nr_of_rows)       := '1';
                                 a_allow_modify_tab(a_nr_of_rows) := '1';
                              END IF;
                           -- If not found, error
                           ELSE
                              a_errorcode := 2;
                              Logmessage(a_journal_nr, a_errorcode,
                                         'No price found for me='||vc2_me||
                                            '#catalogue='||n_mt_catalogue||
                                            '#crit1='||vc2_crit1||'#crit2='||vc2_crit2||
                                            '#crit3='||vc2_crit3||
                                            ' for date '||TO_CHAR(d_date,'DD/MM/YYYY'));
                           END IF;
                           CLOSE GetPrice;
                        END LOOP;
                     END LOOP;
                  END LOOP;
               END LOOP;
            END IF;
         END LOOP;
      ELSE
         vc2_errormsg := a_calc_tp||' is no valid calculation type.';
         RAISE error_found;
      END IF;

      -- Loop the already existing and the newly added journal details
      FOR i_row3 IN 1..tmp_nr_of_rows LOOP
         IF (tmp_done_tab(i_row3) = '0') AND (tmp_allow_modify_tab(i_row3) = '0') THEN
            a_nr_of_rows                       := a_nr_of_rows + 1;
            a_object_tp_tab(a_nr_of_rows)      := tmp_object_tp_tab(i_row3);
            a_object_version_tab(a_nr_of_rows) := tmp_object_version_tab(i_row3);
            a_pp_key1_tab(a_nr_of_rows)        := tmp_pp_key1_tab(i_row3);
            a_pp_key2_tab(a_nr_of_rows)        := tmp_pp_key2_tab(i_row3);
            a_pp_key3_tab(a_nr_of_rows)        := tmp_pp_key3_tab(i_row3);
            a_pp_key4_tab(a_nr_of_rows)        := tmp_pp_key4_tab(i_row3);
            a_pp_key5_tab(a_nr_of_rows)        := tmp_pp_key5_tab(i_row3);
            a_rq_tab(a_nr_of_rows)             := tmp_rq_tab(i_row3);
            a_sc_tab(a_nr_of_rows)             := tmp_sc_tab(i_row3);
            a_pg_tab(a_nr_of_rows)             := tmp_pg_tab(i_row3);
            a_pgnode_tab(a_nr_of_rows)         := tmp_pgnode_tab(i_row3);
            a_pa_tab(a_nr_of_rows)             := tmp_pa_tab(i_row3);
            a_panode_tab(a_nr_of_rows)         := tmp_panode_tab(i_row3);
            a_me_tab(a_nr_of_rows)             := tmp_me_tab(i_row3);
            a_menode_tab(a_nr_of_rows)         := tmp_menode_tab(i_row3);
            a_reanalysis_tab(a_nr_of_rows)     := tmp_reanalysis_tab(i_row3);
            a_description_tab(a_nr_of_rows)    := tmp_description_tab(i_row3);
            a_qtity_tab(a_nr_of_rows)          := tmp_qtity_tab(i_row3);
            a_price_tab(a_nr_of_rows)          := tmp_price_tab(i_row3);
            a_disc_abs_tab(a_nr_of_rows)       := tmp_disc_abs_tab(i_row3);
            a_disc_rel_tab(a_nr_of_rows)       := tmp_disc_rel_tab(i_row3);
            a_net_price_tab(a_nr_of_rows)      := tmp_net_price_tab(i_row3);
            a_ac_code_tab(a_nr_of_rows)        := tmp_ac_code_tab(i_row3);
            a_active_tab(a_nr_of_rows)         := tmp_active_tab(i_row3);
            a_allow_modify_tab(a_nr_of_rows)   := tmp_allow_modify_tab(i_row3);
            tmp_done_tab(i_row3)               := '1';
         END IF;
      END LOOP;

      ---------------------------------------------------------------------------------------
      -- Project dependant additional prices (fill the output arrays with additional entries)
      -- e.g.: An infofield "Rush cost" is to be filled in manually by the user. This cost
      --       can be added to the invoice proposal by adding a line in the arrays.
      ---------------------------------------------------------------------------------------
      /*
      -- EXAMPLE OF CUSTOM CODE
      --
      -- Add lines to the invoice journal by adding values to the output arrays of this procedure
      -- !!!    1 should be added to counter a_nr_of_rows for each extra row in the output arrays
      --
      -- Arrays to be filled up :
      --
      -- a_object_tp_tab(a_nr_of_rows)    rt,st,pp,pr,mt or eventually other: ii,au
      -- a_rq_tab(a_nr_of_rows)           }
      -- a_sc_tab(a_nr_of_rows)           }
      -- a_pg_tab(a_nr_of_rows)           }
      -- a_pgnode_tab(a_nr_of_rows)       }
      -- a_pa_tab(a_nr_of_rows)           }  key of the object
      -- a_panode_tab(a_nr_of_rows)       }
      -- a_me_tab(a_nr_of_rows)           }
      -- a_menode_tab(a_nr_of_rows)       }
      -- a_reanalysis_tab(a_nr_of_rows)   nr of reanalysis, important for price calculation
      -- a_description_tab(a_nr_of_rows)  normally it is the description of the object = description of the invoice line
      -- a_qtity_tab(a_nr_of_rows)        should be 1 except when reanalysis is taken into account (reanalysis = 3 => qtity = 4)
      -- a_price_tab(a_nr_of_rows)        the basic price without discounts
      -- a_disc_abs_tab(a_nr_of_rows)     absolute discount
      -- a_disc_rel_tab(a_nr_of_rows)     relative discount (either one of the two should be filled up
      -- a_net_price_tab(a_nr_of_rows)    netto price = basic price with discounts taken into account
      -- a_ac_code_tab(a_nr_of_rows)      a code that can be used as account code, or eventually another purpose
      -- a_active_tab(a_nr_of_rows)       should be put to 1
      -- a_allow_modify_tab(a_nr_of_rows) when the line may not be modified in the price calculation GUI, it should be set to 0

      -- 1) Certain infofields contain extra costs that have to be shown on the invoice
      --    infofields <RAPPORTKOSTEN>, <AFHAALKOSTEN>, <MONSTERNAMEKOST>, <RUSHKOSTEN>
      FOR i_row IN 1..a_nr_of_rq LOOP
         vc2_rq := a_rq_in_tab(i_row);

         SELECT ss
         INTO vc2_rq_ss
         FROM utrq
         WHERE rq = vc2_rq;

         IF vc2_rq_ss NOT IN ('@C','@O') THEN
            FOR KostenRec IN GetExtraKosten(vc2_rq) LOOP
               IF KostenRec.iivalue IS NOT NULL THEN
                  a_nr_of_rows                    := a_nr_of_rows + 1;
                  a_object_tp_tab(a_nr_of_rows)   := 'rqii';
                  a_rq_tab(a_nr_of_rows)          := vc2_rq;
                  a_sc_tab(a_nr_of_rows)          := NULL;             -- if it was the scii, then sc could also be saved
                  a_pg_tab(a_nr_of_rows)          := KostenRec.ic;     -- save ic in field for pg
                  a_pgnode_tab(a_nr_of_rows)      := KostenRec.icnode; -- save icnode in field for pgnode
                  a_pa_tab(a_nr_of_rows)          := KostenRec.ii;     -- save ii in field for pa
                  a_panode_tab(a_nr_of_rows)      := KostenRec.iinode; -- save iinode in field for panode
                  a_me_tab(a_nr_of_rows)          := NULL;
                  a_menode_tab(a_nr_of_rows)      := NULL;
                  a_reanalysis_tab(a_nr_of_rows)  := NULL;
                  a_description_tab(a_nr_of_rows) := KostenRec.dsp_title;
                  a_qtity_tab(a_nr_of_rows)       := 1;
                  a_price_tab(a_nr_of_rows)       := TO_NUMBER(KostenRec.iivalue);
                  a_disc_abs_tab(a_nr_of_rows)    := 0;
                  a_disc_rel_tab(a_nr_of_rows)    := 0;
                  a_net_price_tab(a_nr_of_rows)   := TO_NUMBER(KostenRec.iivalue);
                  a_ac_code_tab(a_nr_of_rows)     := NULL;
                  a_active_tab(a_nr_of_rows)      := '1';
                  a_allow_modify_tab(a_nr_of_rows):= '1';
               END IF;
            END LOOP;
         END IF;
      END LOOP;

      -- 2) The discount for metal determination is depending on the number of metals analysed
      --    When 1 metal is present then 100% of the price of analysis must be paid
      --    When 2 metals have to be determined then a discount of 20% is sustained
      --    When 3 metals have to be determined then a discount of 30% is sustained
      --    When 4 metals have to be determined then a discount of 40% is sustained
      --    When 5 or more metals have to be determined then a discount of 50% is sustained
      n_nr_of_sc_with_metals := 0;

      FOR i_row IN 1..a_nr_of_rows LOOP
         IF a_object_tp_tab (i_row) = 'pr' THEN
            BEGIN
               SELECT description
               INTO vc2_parametersoort
               FROM utpr
               WHERE pr = a_pa_tab (i_row)
               AND version_is_current = '1';
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  vc2_parametersoort := NULL;
            END;

            IF UPPER(SUBSTR(NVL(a_pa_tab(i_row),'noppes'),1,3)) = 'MET'
               AND UPPER(SUBSTR(NVL(vc2_parametersoort,'noppes'),1,3)) <> 'MET' -- Description should not start with MET (else vb also methane taken into account)
               AND UPPER(SUBSTR(NVL(a_pa_tab (i_row),'noppes'),1,3)) <> 'METHG' THEN -- count number of metals (but mercury not taken into account)
               IF n_nr_of_sc_with_metals = 0 THEN -- no entries in temporary tables
                  vc2_sc_tab(1) := a_sc_tab(i_row);
                  n_nr_of_metals_tab(1) := 1;
                  n_nr_of_sc_with_metals := 1;
               ELSE
                  b_sc_found := FALSE;
                  FOR i_row2 IN 1..n_nr_of_sc_with_metals LOOP
                     IF vc2_sc_tab(i_row2) = a_sc_tab(i_row) THEN
                        b_sc_found := TRUE;
                        n_nr_of_metals_tab(i_row2) := n_nr_of_metals_tab(i_row2) + 1;
                     END IF;
                  END LOOP;
                  IF NOT b_sc_found THEN -- new entry with number of metals = 1
                     n_nr_of_sc_with_metals := n_nr_of_sc_with_metals + 1;
                     vc2_sc_tab(n_nr_of_sc_with_metals) := a_sc_tab(i_row);
                     n_nr_of_metals_tab(n_nr_of_sc_with_metals) := 1;
                  END IF;
               END IF;
            END IF;
         END IF;
      END LOOP;

      FOR i_row2 IN 1..n_nr_of_sc_with_metals LOOP
         IF n_nr_of_metals_tab(i_row2) = 2 THEN
            n_disc_rel2 := 20;
         ELSIF n_nr_of_metals_tab(i_row2) = 3 THEN
            n_disc_rel2 := 30;
         ELSIF n_nr_of_metals_tab(i_row2) = 4 THEN
            n_disc_rel2 := 40;
         ELSIF n_nr_of_metals_tab(i_row2) >= 5 THEN
            n_disc_rel2 := 50;
         ELSE
            n_disc_rel2 := 0;
         END IF;

         FOR i_row IN 1..a_nr_of_rows LOOP
            IF a_object_tp_tab(i_row) = 'pr' THEN
               BEGIN
                  SELECT description
                  INTO vc2_parametersoort
                  FROM utpr
                  WHERE pr = a_pa_tab(i_row)
                  AND version_is_current = '1';
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     vc2_parametersoort := NULL;
               END;

               IF UPPER(SUBSTR(NVL(a_pa_tab(i_row),'noppes'),1,3)) = 'MET'
                  AND UPPER(SUBSTR(NVL(vc2_parametersoort,'noppes'),1,3)) <> 'MET'
                  AND vc2_sc_tab(i_row2) = a_sc_tab(i_row) THEN
                  a_disc_rel_tab(i_row)  := a_disc_rel_tab (i_row) + n_disc_rel2;
                  a_net_price_tab(i_row) :=
                     ROUND(a_price_tab(i_row)
                              - a_disc_abs_tab(i_row)
                              - (a_disc_rel_tab(i_row) * a_price_tab(i_row) / 100),
                           TO_NUMBER(vc2_def_rounding));
               END IF;
            END IF;
         END LOOP;
      END LOOP;
      */

      -- Calculate totals
      FOR i_row IN 1..a_nr_of_rows LOOP
         a_total1 := a_total1 + a_net_price_tab(i_row);
         a_total2 := a_total2 + a_net_price_tab(i_row);
      END LOOP;
      a_grand_total1 :=
         ROUND(a_total1 - a_disc_abs1 - (a_disc_rel * a_total1 / 100),
               TO_NUMBER(vc2_def_rounding));
      a_grand_total2 :=
         ROUND(a_total2 - a_disc_abs2 - (a_disc_rel * a_total2 / 100),
               TO_NUMBER(vc2_def_rounding));
      a_grand_total_at1 :=
         ROUND(a_grand_total1 + a_tax1 + (a_tax_rel * a_grand_total1 / 100),
               TO_NUMBER(vc2_def_rounding));
      a_grand_total_at2 :=
         ROUND(a_grand_total2 + a_tax2 + (a_tax_rel * a_grand_total2 / 100),
               TO_NUMBER(vc2_def_rounding));

      -- Instead of passing most of the arrays as out-arguments, these will be inserted in a
      -- table 'utjournaldetails'.
      --
      -- Delete the already existing journal details
      BEGIN
         DELETE
         FROM utjournaldetails
         WHERE journal_nr = a_journal_nr;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      -- Insert the already existing and the newly added journal details
      FOR i_row IN 1..a_nr_of_rows LOOP
         FOR i_row1 IN 1..a_nr_of_rq LOOP -- RQSEQ must be determined
            IF a_rq_in_tab(i_row1) = a_rq_tab(i_row) THEN
               INSERT INTO utjournaldetails(journal_nr, rqseq, seq, object_tp, rq, sc,
                  pg, pgnode, pa, panode, me, menode, reanalysis, description, qtity,
                  price, disc_abs, disc_rel, net_price, active, allow_modify, last_updated, last_updated_tz,
                  ac_code, object_version, pp_key1, pp_key2, pp_key3, pp_key4, pp_key5)
               VALUES(a_journal_nr, i_row1, i_row, a_object_tp_tab(i_row), a_rq_tab(i_row),
                      a_sc_tab(i_row), a_pg_tab(i_row), a_pgnode_tab(i_row), a_pa_tab(i_row),
                      a_panode_tab(i_row), a_me_tab(i_row), a_menode_tab(i_row),
                      a_reanalysis_tab(i_row), a_description_tab(i_row), a_qtity_tab(i_row),
                      a_price_tab(i_row), a_disc_abs_tab(i_row), a_disc_rel_tab(i_row),
                      a_net_price_tab(i_row), a_active_tab(i_row), a_allow_modify_tab(i_row),
                      a_last_updated, a_last_updated, a_ac_code_tab(i_row), a_object_version_tab(i_row),
                      a_pp_key1_tab(i_row), a_pp_key2_tab(i_row), a_pp_key3_tab(i_row),
                      a_pp_key4_tab(i_row), a_pp_key5_tab(i_row));
               EXIT;
            END IF;
         END LOOP;
      END LOOP;
   ELSE
      a_errorcode := 3;
      Logmessage(a_journal_nr, a_errorcode, 'Not allowed to modify journal '||a_journal_nr);
   END IF;

   UNAPIGEN.U4COMMIT;
EXCEPTION
   WHEN error_found THEN
      a_errorcode := 1;
      Logmessage(a_journal_nr, a_errorcode, vc2_errormsg);
   WHEN OTHERS THEN
      vc2_sqlerrm := SQLERRM;
      a_errorcode := 1;
      Logmessage(a_journal_nr, a_errorcode, 'GENERAL ERROR : '||vc2_sqlerrm);
END CalcJournalDetails;

-- The procedure that returns the criteria. This procedure is called in CalcJournalDetails
PROCEDURE GetCriteria
(a_catalogue          IN     VARCHAR2,
 a_object_type        IN     VARCHAR2,
 a_journal_nr         IN     VARCHAR2,
 a_rq                 IN     VARCHAR2,
 a_sc                 IN     VARCHAR2,
 a_pg                 IN     VARCHAR2,
 a_pgnode             IN     NUMBER,
 a_pa                 IN     VARCHAR2,
 a_panode             IN     NUMBER,
 a_me                 IN     VARCHAR2,
 a_menode             IN     NUMBER,
 a_cat_tab            IN OUT UNAPIGEN.NUM_TABLE_TYPE,
 a_crit_tab           IN OUT UNAPIGEN.NUM_TABLE_TYPE,
 a_critval_tab        IN OUT UNAPIGEN.VC40_TABLE_TYPE,
 a_nr_of_crit         IN OUT NUMBER,
 a_errorcode          IN OUT NUMBER)
IS
   -- Standard variables
   vc2_key                 VARCHAR2(255);
   l_au                    VARCHAR2(20);
   l_description           VARCHAR2(40);
   l_sql_string            VARCHAR2(2000);

   -- Standard cursors
   GetCritAu               UNAPIGEN.CURSOR_REF_TYPE;

   ---------------------------------
   -- EXAMPLE OF CUSTOM CODE - START
   ---------------------------------
   -- Custom cursors
   -- NOTE: the input variables should always be the key
   --       vc2_key := a_rq||'@'||a_sc||'@'||a_pg||'@'||TO_CHAR(a_pgnode)||'@'||a_pa||'@'||
   --               TO_CHAR(a_panode)||'@'||a_me||'@'||TO_CHAR(a_menode)||'@'
   --       To create own custom criteria cursors, one should extract the necessary key parts
   --       Respecting this it will not be necessary to adapt the standard calculation logics
   --
   -- rq     : SUBSTR(key, 1, INSTR(key,'@')-1)
   -- sc     : SUBSTR(key, INSTR(key,'@')+1, INSTR(key,'@',1,2)-INSTR(key,'@')-1)
   -- pg     : SUBSTR(key, INSTR(key,'@',1,2)+1, INSTR(key,'@',1,3)-INSTR(key,'@',1,2)-1)
   -- pgnode : TO_NUMBER(SUBSTR(key, INSTR(key,'@',1,3)+1, INSTR(key,'@',1,4)-INSTR(key,'@',1,3)-1))
   -- pa     : SUBSTR(key, INSTR(key,'@',1,4)+1, INSTR(key,'@',1,5)-INSTR(key,'@',1,4)-1)
   -- panode : TO_NUMBER(SUBSTR(key, INSTR(key,'@',1,5)+1, INSTR(key,'@',1,6)-INSTR(key,'@',1,5)-1))
   -- me     : SUBSTR(key, INSTR(key,'@',1,6)+1, INSTR(key,'@',1,7)-INSTR(key,'@',1,6)-1)
   -- menode : TO_NUMBER(SUBSTR(key, INSTR(key,'@',1,7)+1, INSTR(key,'@',1,8)-INSTR(key,'@',1,7)-1))

   -- Criterium 1 of catalogue 1, criterium type = rq
   CURSOR GetCa1Criterium1(key IN VARCHAR2) IS
      SELECT iivalue
      FROM utrqii
      WHERE rq = SUBSTR(key, 1, INSTR(key,'@')-1)
      AND ii   = 'KLANTROEPNAAM';

   -- Criterium 2 of catalogue 1, criterium type = rq
   CURSOR GetCa1Criterium2(key IN VARCHAR2) IS
      SELECT iivalue
      FROM utrqii
      WHERE rq = SUBSTR(key, 1, INSTR(key,'@')-1)
      AND ii   = 'InvoiceType';

   -- Criterium 3 of catalogue 1, criterium type = me
   CURSOR GetCa1Criterium3(key IN VARCHAR2) IS
      SELECT value
      FROM utscmeau
      WHERE sc   = SUBSTR(key, INSTR(key,'@')+1, INSTR(key,'@',1,2)-INSTR(key,'@')-1)
      AND pg     = SUBSTR(key, INSTR(key,'@',1,2)+1, INSTR(key,'@',1,3)-INSTR(key,'@',1,2)-1)
      AND pgnode = TO_NUMBER(SUBSTR(key, INSTR(key,'@',1,3)+1, INSTR(key,'@',1,4)-INSTR(key,'@',1,3)-1))
      AND pa     = SUBSTR(key, INSTR(key,'@',1,4)+1, INSTR(key,'@',1,5)-INSTR(key,'@',1,4)-1)
      AND panode = TO_NUMBER(SUBSTR(key, INSTR(key,'@',1,5)+1, INSTR(key,'@',1,6)-INSTR(key,'@',1,5)-1))
      AND me     = SUBSTR(key, INSTR(key,'@',1,6)+1, INSTR(key,'@',1,7)-INSTR(key,'@',1,6)-1)
      AND menode = TO_NUMBER(SUBSTR(key, INSTR(key,'@',1,7)+1, INSTR(key,'@',1,8)-INSTR(key,'@',1,7)-1))
      AND UPPER(au) = 'ACCREDITATIE';

   -- Criterium 1 of catalogue 2, criterium type = rq
   CURSOR GetCa2Criterium1(key IN VARCHAR2) IS
      SELECT iivalue
      FROM utrqii
      WHERE rq = SUBSTR(key, 1, INSTR(key,'@')-1)
      AND ii   = 'KLANTROEPNAAM';

   -- Criterium 2 of catalogue 2, criterium type = rq
   CURSOR GetCa2Criterium2(key IN VARCHAR2) IS
      SELECT iivalue
      FROM utrqii
      WHERE rq = SUBSTR(key, 1, INSTR(key,'@')-1)
      AND ii   = 'InvoiceType';

   -- Criterium 3 of catalogue 2, criterium type = me
   CURSOR GetCa2Criterium3(key IN VARCHAR2) IS
      SELECT value
      FROM utscmeau
      WHERE sc   = SUBSTR(key, INSTR(key,'@')+1, INSTR(key,'@',1,2)-INSTR(key,'@')-1)
      AND pg     = SUBSTR(key, INSTR(key,'@',1,2)+1, INSTR(key,'@',1,3)-INSTR(key,'@',1,2)-1)
      AND pgnode = TO_NUMBER(SUBSTR(key, INSTR(key,'@',1,3)+1, INSTR(key,'@',1,4)-INSTR(key,'@',1,3)-1))
      AND pa     = SUBSTR(key, INSTR(key,'@',1,4)+1, INSTR(key,'@',1,5)-INSTR(key,'@',1,4)-1)
      AND panode = TO_NUMBER(SUBSTR(key, INSTR(key,'@',1,5)+1, INSTR(key,'@',1,6)-INSTR(key,'@',1,5)-1))
      AND me     = SUBSTR(key, INSTR(key,'@',1,6)+1, INSTR(key,'@',1,7)-INSTR(key,'@',1,6)-1)
      AND menode = TO_NUMBER(SUBSTR(key, INSTR(key,'@',1,7)+1, INSTR(key,'@',1,8)-INSTR(key,'@',1,7)-1))
      AND UPPER(au) = 'ACCREDITATIE';

   -- Criterium 1 of catalogue 3, criterium type = rq
   CURSOR GetCa3Criterium1(key IN VARCHAR2) IS
      SELECT iivalue
      FROM utrqii
      WHERE rq = SUBSTR(key, 1, INSTR(key,'@')-1)
      AND ii   = 'KLANTROEPNAAM';

   -- Criterium 2 of catalogue 3, criterium type = rq
   CURSOR GetCa3Criterium2(key IN VARCHAR2) IS
      SELECT iivalue
      FROM utrqii
      WHERE rq = SUBSTR(key, 1, INSTR(key,'@')-1)
      AND ii   = 'InvoiceType';

   -- Criterium 3 of catalogue 3, criterium type = me
   CURSOR GetCa3Criterium3(key IN VARCHAR2) IS
      SELECT value
      FROM utscmeau
      WHERE sc   = SUBSTR(key, INSTR(key,'@')+1, INSTR(key,'@',1,2)-INSTR(key,'@')-1)
      AND pg     = SUBSTR(key, INSTR(key,'@',1,2)+1, INSTR(key,'@',1,3)-INSTR(key,'@',1,2)-1)
      AND pgnode = TO_NUMBER(SUBSTR(key, INSTR(key,'@',1,3)+1, INSTR(key,'@',1,4)-INSTR(key,'@',1,3)-1))
      AND pa     = SUBSTR(key, INSTR(key,'@',1,4)+1, INSTR(key,'@',1,5)-INSTR(key,'@',1,4)-1)
      AND panode = TO_NUMBER(SUBSTR(key, INSTR(key,'@',1,5)+1, INSTR(key,'@',1,6)-INSTR(key,'@',1,5)-1))
      AND me     = SUBSTR(key, INSTR(key,'@',1,6)+1, INSTR(key,'@',1,7)-INSTR(key,'@',1,6)-1)
      AND menode = TO_NUMBER(SUBSTR(key, INSTR(key,'@',1,7)+1, INSTR(key,'@',1,8)-INSTR(key,'@',1,7)-1))
      AND UPPER(au) = 'ACCREDITATIE';

   -- Criterium 1 of catalogue 4, criterium type = rq
   CURSOR GetCa4Criterium1(key IN VARCHAR2) IS
      SELECT iivalue
      FROM utrqii
      WHERE rq = SUBSTR(key, 1, INSTR(key,'@')-1)
      AND ii   = 'KLANTROEPNAAM';

   -- Criterium 2 of catalogue 4, criterium type = rq
   CURSOR GetCa4Criterium2(key IN VARCHAR2) IS
      SELECT iivalue
      FROM utrqii
      WHERE rq = SUBSTR(key, 1, INSTR(key,'@')-1)
      AND ii   = 'InvoiceType';

   -- Criterium 3 of catalogue 4, criterium type = me
   CURSOR GetCa4Criterium3(key IN VARCHAR2) IS
      SELECT value
      FROM utscmeau
      WHERE sc   = SUBSTR(key, INSTR(key,'@')+1, INSTR(key,'@',1,2)-INSTR(key,'@')-1)
      AND pg     = SUBSTR(key, INSTR(key,'@',1,2)+1, INSTR(key,'@',1,3)-INSTR(key,'@',1,2)-1)
      AND pgnode = TO_NUMBER(SUBSTR(key, INSTR(key,'@',1,3)+1, INSTR(key,'@',1,4)-INSTR(key,'@',1,3)-1))
      AND pa     = SUBSTR(key, INSTR(key,'@',1,4)+1, INSTR(key,'@',1,5)-INSTR(key,'@',1,4)-1)
      AND panode = TO_NUMBER(SUBSTR(key, INSTR(key,'@',1,5)+1, INSTR(key,'@',1,6)-INSTR(key,'@',1,5)-1))
      AND me     = SUBSTR(key, INSTR(key,'@',1,6)+1, INSTR(key,'@',1,7)-INSTR(key,'@',1,6)-1)
      AND menode = TO_NUMBER(SUBSTR(key, INSTR(key,'@',1,7)+1, INSTR(key,'@',1,8)-INSTR(key,'@',1,7)-1))
      AND UPPER(au) = 'ACCREDITATIE';

   -- Criterium 1 of catalogue 5, criterium type = rq
   CURSOR GetCa5Criterium1(key IN VARCHAR2) IS
      SELECT iivalue
      FROM utrqii
      WHERE rq = SUBSTR(key, 1, INSTR(key,'@')-1)
      AND ii   = 'KLANTROEPNAAM';

   -- Criterium 2 of catalogue 5, criterium type = rq
   CURSOR GetCa5Criterium2(key IN VARCHAR2) IS
      SELECT iivalue
      FROM utrqii
      WHERE rq = SUBSTR(key, 1, INSTR(key,'@')-1)
      AND ii   = 'InvoiceType';

   -- Criterium 3 of catalogue 5, criterium type = me
   CURSOR GetCa5Criterium3(key IN VARCHAR2) IS
      SELECT value
      FROM utscmeau
      WHERE sc   = SUBSTR(key, INSTR(key,'@')+1, INSTR(key,'@',1,2)-INSTR(key,'@')-1)
      AND pg     = SUBSTR(key, INSTR(key,'@',1,2)+1, INSTR(key,'@',1,3)-INSTR(key,'@',1,2)-1)
      AND pgnode = TO_NUMBER(SUBSTR(key, INSTR(key,'@',1,3)+1, INSTR(key,'@',1,4)-INSTR(key,'@',1,3)-1))
      AND pa     = SUBSTR(key, INSTR(key,'@',1,4)+1, INSTR(key,'@',1,5)-INSTR(key,'@',1,4)-1)
      AND panode = TO_NUMBER(SUBSTR(key, INSTR(key,'@',1,5)+1, INSTR(key,'@',1,6)-INSTR(key,'@',1,5)-1))
      AND me     = SUBSTR(key, INSTR(key,'@',1,6)+1, INSTR(key,'@',1,7)-INSTR(key,'@',1,6)-1)
      AND menode = TO_NUMBER(SUBSTR(key, INSTR(key,'@',1,7)+1, INSTR(key,'@',1,8)-INSTR(key,'@',1,7)-1))
      AND UPPER(au) = 'ACCREDITATIE';
   -------------------------------
   -- EXAMPLE OF CUSTOM CODE - END
   -------------------------------
BEGIN
   vc2_key := a_rq||'@'||a_sc||'@'||a_pg||'@'||TO_CHAR(a_pgnode)||'@'||a_pa||'@'||
              TO_CHAR(a_panode)||'@'||a_me||'@'||TO_CHAR(a_menode)||'@';

   l_sql_string:=   'SELECT au, description '
                  ||'FROM dd'||UNAPIGEN.P_DD||'.uvau '
                  ||'WHERE UPPER(au) LIKE ''CA''||:a_catalogue||''_CRIT_'' '
                  ||'AND description2 = :a_object_type '
                  ||'AND version_is_current = ''1''';
   OPEN GetCritAu FOR l_sql_string USING a_catalogue, a_object_type;
   LOOP
      FETCH GetCritAu
      INTO l_au, l_description;
      EXIT WHEN (GetCritAu%NOTFOUND);

      a_nr_of_crit             := a_nr_of_crit + 1;
      a_cat_tab(a_nr_of_crit)  := TO_NUMBER(SUBSTR(l_au,3,1)); -- catalogue
      a_crit_tab(a_nr_of_crit) := TO_NUMBER(SUBSTR(l_au,9,1)); -- criterium

      IF UPPER(l_au) = 'CA1_CRIT1' THEN
         OPEN GetCa1Criterium1(vc2_key);
         FETCH GetCa1Criterium1 INTO a_critval_tab(a_nr_of_crit);
         IF GetCa1Criterium1%NOTFOUND THEN
            a_critval_tab(a_nr_of_crit) := NULL;
            a_errorcode := 2;
            Logmessage(a_journal_nr, a_errorcode, 'Criterium 1 ('||l_description||
                         ') of catalogue 1 not found : key = '||vc2_key);
         END IF;
         CLOSE GetCa1Criterium1;
      ELSIF UPPER(l_au) = 'CA2_CRIT1' THEN
         OPEN GetCa2Criterium1(vc2_key);
         FETCH GetCa2Criterium1 INTO a_critval_tab(a_nr_of_crit);
         IF GetCa2Criterium1%NOTFOUND THEN
            a_critval_tab(a_nr_of_crit) := NULL;
            a_errorcode := 2;
            Logmessage(a_journal_nr, a_errorcode, 'Criterium 1 ('||l_description||
                         ') of catalogue 2 not found : key = '||vc2_key);
         END IF;
         CLOSE GetCa2Criterium1;
      ELSIF UPPER(l_au) = 'CA3_CRIT1' THEN
         OPEN GetCa3Criterium1(vc2_key);
         FETCH GetCa3Criterium1 INTO a_critval_tab(a_nr_of_crit);
         IF GetCa3Criterium1%NOTFOUND THEN
            a_critval_tab(a_nr_of_crit) := NULL;
            a_errorcode := 2;
            Logmessage(a_journal_nr, a_errorcode, 'Criterium 1 ('||l_description||
                         ') of catalogue 3 not found : key = '||vc2_key);
         END IF;
         CLOSE GetCa3Criterium1;
      ELSIF UPPER(l_au) = 'CA4_CRIT1' THEN
         OPEN GetCa4Criterium1(vc2_key);
         FETCH GetCa4Criterium1 INTO a_critval_tab(a_nr_of_crit);
         IF GetCa4Criterium1%NOTFOUND THEN
            a_critval_tab(a_nr_of_crit) := NULL;
            a_errorcode := 2;
            Logmessage(a_journal_nr, a_errorcode, 'Criterium 1 ('||l_description||
                         ') of catalogue 4 not found : key = '||vc2_key);
         END IF;
         CLOSE GetCa4Criterium1;
      ELSIF UPPER(l_au) = 'CA5_CRIT1' THEN
         OPEN GetCa5Criterium1(vc2_key);
         FETCH GetCa5Criterium1 INTO a_critval_tab(a_nr_of_crit);
         IF GetCa5Criterium1%NOTFOUND THEN
            a_critval_tab(a_nr_of_crit) := NULL;
            a_errorcode := 2;
            Logmessage(a_journal_nr, a_errorcode, 'Criterium 1 ('||l_description||
                         ') of catalogue 5 not found : key = '||vc2_key);
         END IF;
         CLOSE GetCa5Criterium1;

      ELSIF UPPER(l_au) = 'CA1_CRIT2' THEN
         OPEN GetCa1Criterium2(vc2_key);
         FETCH GetCa1Criterium2 INTO a_critval_tab(a_nr_of_crit);
         IF GetCa1Criterium2%NOTFOUND THEN
            a_critval_tab(a_nr_of_crit) := NULL;
            a_errorcode := 2;
            Logmessage(a_journal_nr, a_errorcode, 'Criterium 2 ('||l_description||
                         ') of catalogue 1 not found : key = '||vc2_key);
         END IF;
         CLOSE GetCa1Criterium2;
      ELSIF UPPER(l_au) = 'CA2_CRIT2' THEN
         OPEN GetCa2Criterium2(vc2_key);
         FETCH GetCa2Criterium2 INTO a_critval_tab(a_nr_of_crit);
         IF GetCa2Criterium2%NOTFOUND THEN
            a_critval_tab(a_nr_of_crit) := NULL;
            a_errorcode := 2;
            Logmessage(a_journal_nr, a_errorcode, 'Criterium 2 ('||l_description||
                         ') of catalogue 2 not found : key = '||vc2_key);
         END IF;
         CLOSE GetCa2Criterium2;
      ELSIF UPPER(l_au) = 'CA3_CRIT2' THEN
         OPEN GetCa3Criterium2(vc2_key);
         FETCH GetCa3Criterium2 INTO a_critval_tab(a_nr_of_crit);
         IF GetCa3Criterium2%NOTFOUND THEN
            a_critval_tab(a_nr_of_crit) := NULL;
            a_errorcode := 2;
            Logmessage(a_journal_nr, a_errorcode, 'Criterium 2 ('||l_description||
                         ') of catalogue 3 not found : key = '||vc2_key);
         END IF;
         CLOSE GetCa3Criterium2;

      ELSIF UPPER(l_au) = 'CA4_CRIT2' THEN
         OPEN GetCa4Criterium2(vc2_key);
         FETCH GetCa4Criterium2 INTO a_critval_tab(a_nr_of_crit);
         IF GetCa4Criterium2%NOTFOUND THEN
            a_critval_tab(a_nr_of_crit) := NULL;
            a_errorcode := 2;
            Logmessage(a_journal_nr, a_errorcode, 'Criterium 2 ('||l_description||
                         ') of catalogue 4 not found : key = '||vc2_key);
         END IF;
         CLOSE GetCa4Criterium2;
      ELSIF UPPER(l_au) = 'CA5_CRIT2' THEN
         OPEN GetCa5Criterium2(vc2_key);
         FETCH GetCa5Criterium2 INTO a_critval_tab(a_nr_of_crit);
         IF GetCa5Criterium2%NOTFOUND THEN
            a_critval_tab(a_nr_of_crit) := NULL;
            a_errorcode := 2;
            Logmessage(a_journal_nr, a_errorcode, 'Criterium 2 ('||l_description||
                         ') of catalogue 5 not found : key = '||vc2_key);
         END IF;
         CLOSE GetCa5Criterium2;
      ELSIF UPPER(l_au) = 'CA1_CRIT3' THEN
         OPEN GetCa1Criterium3(vc2_key);
         FETCH GetCa1Criterium3 INTO a_critval_tab(a_nr_of_crit);
         IF GetCa1Criterium3%NOTFOUND THEN
            a_critval_tab(a_nr_of_crit) := NULL;
            a_errorcode := 2;
            Logmessage(a_journal_nr, a_errorcode, 'Criterium 3 ('||l_description||
                         ') of catalogue 1 not found : key = '||vc2_key);
         END IF;
         CLOSE GetCa1Criterium3;
      ELSIF UPPER(l_au) = 'CA2_CRIT3' THEN
         OPEN GetCa2Criterium3(vc2_key);
         FETCH GetCa2Criterium3 INTO a_critval_tab(a_nr_of_crit);
         IF GetCa2Criterium3%NOTFOUND THEN
            a_critval_tab(a_nr_of_crit) := NULL;
            a_errorcode := 2;
            Logmessage(a_journal_nr, a_errorcode, 'Criterium 3 ('||l_description||
                         ') of catalogue 2 not found : key = '||vc2_key);
         END IF;
         CLOSE GetCa2Criterium3;
      ELSIF UPPER(l_au) = 'CA3_CRIT3' THEN
         OPEN GetCa3Criterium3(vc2_key);
         FETCH GetCa3Criterium3 INTO a_critval_tab(a_nr_of_crit);
         IF GetCa3Criterium3%NOTFOUND THEN
            a_critval_tab(a_nr_of_crit) := NULL;
            a_errorcode := 2;
            Logmessage(a_journal_nr, a_errorcode, 'Criterium 3 ('||l_description||
                         ') of catalogue 3 not found : key = '||vc2_key);
         END IF;
         CLOSE GetCa3Criterium3;
      ELSIF UPPER(l_au) = 'CA4_CRIT3' THEN
         OPEN GetCa4Criterium3(vc2_key);
         FETCH GetCa4Criterium3 INTO a_critval_tab(a_nr_of_crit);
         IF GetCa4Criterium3%NOTFOUND THEN
            a_critval_tab(a_nr_of_crit) := NULL;
            a_errorcode := 2;
            Logmessage(a_journal_nr, a_errorcode, 'Criterium 3 ('||l_description||
                         ') of catalogue 4 not found : key = '||vc2_key);
         END IF;
         CLOSE GetCa4Criterium3;
      ELSIF UPPER(l_au) = 'CA5_CRIT3' THEN
         OPEN GetCa5Criterium3(vc2_key);
         FETCH GetCa5Criterium3 INTO a_critval_tab(a_nr_of_crit);
         IF GetCa5Criterium3%NOTFOUND THEN
            a_critval_tab(a_nr_of_crit) := NULL;
            a_errorcode := 2;
            Logmessage(a_journal_nr, a_errorcode, 'Criterium 3 ('||l_description||
                         ') of catalogue 5 not found : key = '||vc2_key);
         END IF;
         CLOSE GetCa5Criterium3;
      END IF;
   END LOOP;
   CLOSE GetCritAu;
END GetCriteria;

-- This procedure will log an errormessage in table 'utjournallog'.
PROCEDURE LogMessage
(a_journal_nr    IN VARCHAR2,
 a_level         IN NUMBER,
 a_message       IN VARCHAR2)
IS
   vc2_sqlerrm VARCHAR2(255);
BEGIN
   INSERT INTO utjournallog(client_id, applic, who, logdate, logdate_tz, journal_nr, error_level, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, 'prcalc', UNAPIEV.P_EV_REC.USERNAME, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          a_journal_nr, a_level, a_message);
   UNAPIGEN.U4COMMIT;
EXCEPTION
   WHEN OTHERS THEN
      vc2_sqlerrm := SQLERRM;
      INSERT INTO uterror(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
      VALUES(UNAPIGEN.P_CLIENT_ID, 'prcalc', UNAPIEV.P_EV_REC.USERNAME, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'LogMessage:exception', vc2_sqlerrm);
      UNAPIGEN.U4COMMIT;
END LogMessage;

END uncostcalc;
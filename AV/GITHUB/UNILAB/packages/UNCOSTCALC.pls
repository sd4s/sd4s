create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.3.0 $
-- $Date: 2007-02-22T14:44:00 $
uncostcalc AS

TYPE pointer IS REF CURSOR;

PROCEDURE CalcJournalDetails
(a_nr_of_rq           IN     NUMBER,
 a_rq_in_tab          IN     UNAPIGEN.VC20_TABLE_TYPE,
 a_inv_reanal         IN     CHAR, -- flag reanalysis should be taken into account
 a_journal_nr         IN     VARCHAR2,
 a_description        IN     VARCHAR2,
 a_currency           IN     VARCHAR2,
 a_currency2          IN     VARCHAR2,
 a_journal_tp         IN     VARCHAR2,
 a_journal_ss         IN     VARCHAR2,
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
 a_invoiced           IN     CHAR,
 a_invoiced_on        IN     DATE,
 a_date1              IN     DATE,
 a_date2              IN     DATE,
 a_date3              IN     DATE,
 a_last_updated       IN OUT DATE,
 a_who                IN OUT VARCHAR2,
 a_comments           IN OUT VARCHAR2,
 a_nr_of_rows         OUT    NUMBER,
 a_errorcode          OUT    NUMBER);

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
 a_errorcode          IN OUT NUMBER);

PROCEDURE LogMessage
(a_journal_nr     IN VARCHAR2,
 a_level          IN NUMBER,
 a_message        IN VARCHAR2);

END uncostcalc;
 
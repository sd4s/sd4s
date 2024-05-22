--controle db-link vanuit interspec naar unilab 
--(let op: tns-service-names zijn anders dan vanaf een client, uitvoeren vanaf db-server !)

--DB-LINK LNK_LIMS aanmaken onder user INTERSPC:
--Het komt soms na een HERSTART van UNILAB/INTERSPC voor dat er nog JOB-processen van oracle liepen
--die continue error-meldingen wegschrijven in de INTERSPEC.ITERROR-tabel. Dit levert dan weer zoveel mutaties/redo-log-erros/archive-logging
--op waardoor de hele database blijft hangen (oplossing is dan alleen om een FULL-BACKUP te maken, waardoor automatisch door RMAN de archive-log-bestanden 
--worden geschoond.
--(hierna ging JOB-LIMS-proces wel weer lopen richting UNILAB, geen idee nog waar deze vandaan komt...)

CREATE DATABASE LINK "LNK_LIMS"  CONNECT TO UNILAB  IDENTIFIED BY moonflower  USING 'U611';

--db-link zoals deze vanuit de applicatie dynamisch wordt aangemaakt. Let op pw "l1ms" met een "1" !!!

CREATE DATABASE LINK LNK_LIMS  CONNECT TO LIMS  IDENTIFIED BY l1ms  USING 'U611' ;



--
select user from DUAL@LNK_LIMS;
select * from v$instance@LNK_LIMS;
DESCR UNAPIGEN.CHAR1_TABLE_TYPE@LNK_LIMS;


--controle normale DB-LINKS
--INTERSPC:
conn interspc/moonflower@is61
select user from dual@U611.REGRESS.RDBMS.DEV.US.ORACLE.COM;
--
select user from dual@INTERSPEC;
select * from v$instance@INTERSPEC;
--

--UNILAB:
conn unilab/moonflower@u611
select user from dual@INTERSPEC.REGRESS.RDBMS.DEV.US.ORACLE.COM;
select * from v$instance@INTERSPEC.REGRESS.RDBMS.DEV.US.ORACLE.COM;
--






--einde script

 
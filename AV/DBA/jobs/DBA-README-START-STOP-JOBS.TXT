let op:
Jobs van UNILAB moeten eerst gestart worden, en daarna pas die van INTERSPEC.
Dus:
1) @jobs_unilab_start.sql
2) @jobs_interspec_start.sql

Start je INTERSPEC-jobs toch eerder dan UNILAB-jobs dan krijg je volgende ITERROR:
Unable to initialize the DB API for the plant "ENS" SetConnection@LNK_LIMS returned: 42
Foutcode=42 DBERR_EVMGRNOTSTARTED = geeft aan dat de eventmanager in UNILAB niet gestart is.


Indien jobs uitgezet moeten worden, dan omgekeerde volgorde gebruiken:
1) @jobs_interspec_stop.sql
2) @jobs_unilab_stop.sql




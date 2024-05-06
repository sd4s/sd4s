--TABELLEN MET COLUMN-TYPE=BLOB !!
--Kunnen niet naar REDSHIFT gerepliceerd worden !!. Gaan dus naar AURORA.

--INTERSPEC
51	INTERSPC	ITOIRAW	J	ALL	N		 COLUMN=DESKTOP_OBJECT=BLOB

--UNILAB:
35	UNILAB	UTBLOB	J	ALL	N		 COLUMN=DATA=BLOB


Shailender,
In parallel of the reload of the redshift-environment I would like to come back on the BLOB-issue. 
We have 2 tables which have a BLOB-attribute containing files which are being used in some Athena-reports.

Interspec:           ITOIRAW
Unilab:              UTBLOB

In the past you proposed a solution to create a new db in Aurora and replicate those 2 tables to that location, and create another db-connection
from PowerBI or Python to retrieve the necessary files. We think that is a nice solution, and worth testing it with the report we are building now in PowerBI “request-overview-results”.
Can you take care of the initial implementation of such a database, grant the necessary privileges to all of us, and do an initial-load of these tables? 
If we are able to use the files in an correct way, than we can also start the supplemental-logging on these 2 tables in our on-premises-database on the oracle-prod. 




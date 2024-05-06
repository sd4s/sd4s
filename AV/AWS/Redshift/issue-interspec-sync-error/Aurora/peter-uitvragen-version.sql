--********************************************************
--uitvragen version Aurora - Postgres:    (dus niet mysql)
--********************************************************
--Release-notes Aurora-version: 
--https://docs.aws.amazon.com/AmazonRDS/latest/AuroraPostgreSQLReleaseNotes/Welcome.html
--
--**********************************************************

select version();
--PostgreSQL 16.1 on aarch64-unknown-linux-gnu, compiled by aarch64-unknown-linux-gnu-gcc (GCC) 9.5.0, 64-bit

select aurora_version();
--16.1.0
 

--eind
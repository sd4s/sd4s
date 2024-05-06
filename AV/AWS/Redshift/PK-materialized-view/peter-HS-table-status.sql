dd. 15-02-2024

--totals
select count(1) from utrqhs;
select count(1) from utschs;
select count(1) from utscpahs;
select count(1) from utscmehs;
select count(1) from utwshs;



TABLE				UNILAB				REDSHIFT			REMARK
----------------    ---------------     ---------------     -----------------------------------------------------------------------
UTRQHS				10862964            0                   table has no PK, table utRQhs is created in redshift, it does not have data 
UTSCHS				145724548           145722536           table has no PK, table utSChs is created in redshift, it contains data BUT is NOT consistant with UNILAB !!!!
UTSCPAHS            191296973           191292324           table has no PK, table utSChs is created in redshift, it contains data BUT is NOT consistant with UNILAB !!!!
UTSCMEHS            209863636           0					table has no PK, table utRQhs is created in redshift, it does not have data 
UTWSHS              1640686             0					table has no PK, table utRQhs is created in redshift, it does not have data 


--question:
How is it possible that table UTSCHS + UTSCPAHS contains data, while they do not have a UNILAB-PK ?
Are they still making part of the replication-procedure ? They are not completely consistant with unilab-tables.
I would not expect that. 



--We zien "vreemd" gedrag bij uitvagen van TIMESTAMP-attribuut, bijv. SPECIFICATION_HEADER !!!!!!!!!!!

select count(*) from part;
191373

select count(*) from sc_interspec_ens.SPECIFICATION_HEADER SH where created_on > to_date('2024-02-16#16:10:28' ,'yyyy-mm-dd#hh24:mi:ss' ) 
--583
select count(*) from sc_interspec_ens.SPECIFICATION_HEADER SH where created_on > to_timestamp('2024-02-16 16:10:28' ,'yyyy-mm-dd hh24:mi:ss' )
--522
--DIT AANTAL KOMT OVEREEN MET DE TELLING IN INTERSPEC ZELF !!!
--in interspec IS FIELD-TYPE=DATE:
select count(*) from sc_interspec_ens.SPECIFICATION_HEADER SH where created_on > to_date('2024-02-16 16:10:28' ,'yyyy-mm-dd hh24:mi:ss' )
--522


--> CREATED_ON = FIELD-TYPE=TIMESTAMP !!! 
--> Het lijkt er dus op dat we TIMESTAMP alleen met een TIJD kunnen gebruiken, om deze te vergelijken met een andere TIMESTAMP
--> Bij gebruik van de TO_DATE raken we dus de TIJD kwijt !!!!!!!!! 
--> EN mogelijk ook een WISSELING VAN DD/MM !!!!!!!!!! Als alleen de TIME eraf zou vallen dan gaat dat niet verklaren dat er  meer records bijkomen in plaats van minder !!



select count(*) from sc_interspec_ens.SPECIFICATION_HEADER SH where created_on > to_date('2024-02-20 16:10:28' ,'yyyy-mm-dd hh24:mi:ss' )
--357
select count(*) from SPECIFICATION_HEADER SH where created_on > to_date('2024-02-21 16:10:28' ,'yyyy-mm-dd hh24:mi:ss' )
--225
select count(*) from SPECIFICATION_HEADER SH where created_on > to_timestamp('2024-02-22 16:10:28' ,'yyyy-mm-dd hh24:mi:ss' )
--94

select * from SPECIFICATION_HEADER SH where created_on > to_date('2024-02-22 16:10:28' ,'yyyy-mm-dd hh24:mi:ss' )

select to_timestamp('2024-02-22 16:10:28' ,'yyyy-mm-dd hh24:mi:ss' ) 

select to_char(to_date('2024-02-22 16:10:28' ,'yyyy-mm-dd hh24:mi:ss' ) ,'yyyy-mm-dd hh24:mi:ss' )


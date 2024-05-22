prompt aanmaken van datafile bij bestaande tablespace:

--conn system/moonflower@is61

ALTER TABLESPACE SPECI 
ADD DATAFILE 'D:\DATABASE\IS61\DATA\IS61_SPECI4.DBF' 
size 33554416K 
AUTOEXTEND ON 
NEXT 512M 
MAXSIZE UNLIMITED;

prompt 
prompt einde script
prompt


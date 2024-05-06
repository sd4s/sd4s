
BEGIN
 EXECUTE IMMEDIATE 'alter table ITNUTREFTYPE add PERCENT_RDA_CALCULATION number(1) default ''0''';
 EXCEPTION
   WHEN OTHERS
   THEN
      NULL;
END;          
/


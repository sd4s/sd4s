--INTERSPEC
select count(*) from bom_header;
select count(*) from bom_item;
select count(*) from specification_header;
select max(issued_date) from specification_header;

--UNILAB
select count(*) from utrq;
select max(creation_date) from utrq;
select count(*) from utsc;
select max(creation_date) from utsc;


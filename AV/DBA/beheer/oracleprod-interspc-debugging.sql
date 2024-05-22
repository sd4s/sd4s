prompt Tabel IT_DEBUG wordt gevuld met behulp van een trigger vanaf de INTERSP.ITERROR-tabel
prompt ten behoeve van het debuggen van bug-/fout-situaties.
prompt (alleen voor users Patrick, Jacco, Matthias, en INTERSPC)
prompt 

prompt leeggooien van itdebug met truncate (tbv vrijgeven gealloceerde ruimte in SPECI-tablespace):
TRUNCATE TABLE ITDEBUG;

prompt disable van trigger op de ITERROR-tabel zodat IT_DEBUG niet gevuld wordt: 
alter TRIGGER IT_ERROR_BRI disable;
prompt controle status:
select trigger_name, status from all_triggers where table_name = 'ITERROR';


prompt weer enablen van trigger:
alter TRIGGER IT_ERROR_BRI enable;



/*
CREATE OR REPLACE TRIGGER IT_ERROR_BRI
BEFORE INSERT
ON ITERROR 
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN
  add_debug
    (p_table => 'ITERROR'
    ,p_message => :new.error_msg);
END;
/
*/


/*
CREATE TABLE INTERSPC.IT_DEBUG
(
  DBG_SEQ_NO     NUMBER(10)                     NOT NULL,
  DBG_TIMESTAMP  DATE                           NOT NULL,
  DBG_TYPE       VARCHAR2(3 CHAR)               NOT NULL,
  DBG_MESSAGE    CLOB,
  DBG_TABLE      VARCHAR2(30 CHAR),
  DBG_USER       VARCHAR2(30 CHAR)
)
LOB (DBG_MESSAGE) STORE AS BASICFILE (
  TABLESPACE  SPECD
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE SPECI
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE;
*/

prompt 
prompt einde script
prompt



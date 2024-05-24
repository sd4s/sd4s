--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Sequence AS_OUTDOOR_EVENT
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."AS_OUTDOOR_EVENT"  MINVALUE 0 MAXVALUE 99999 INCREMENT BY 1 START WITH 2081 CACHE 20 ORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence AT_DEBUG_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."AT_DEBUG_SEQ"  MINVALUE 0 MAXVALUE 9999999999 INCREMENT BY 1 START WITH 2361051 NOCACHE  NOORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence AT_REPORTBUNDLE_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."AT_REPORTBUNDLE_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 464410 CACHE 20 NOORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence AT_SESSION_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."AT_SESSION_SEQ"  MINVALUE 0 MAXVALUE 9999999999 INCREMENT BY 1 START WITH 344514 NOCACHE  NOORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence ATERROR_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."ATERROR_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 11357343 NOCACHE  ORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence ATMAILID
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."ATMAILID"  MINVALUE 1 MAXVALUE 999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence AVCC
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."AVCC"  MINVALUE 1 MAXVALUE 99 INCREMENT BY 1 START WITH 25 NOCACHE  ORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence AVCCCC
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."AVCCCC"  MINVALUE 0 MAXVALUE 9999 INCREMENT BY 1 START WITH 163 NOCACHE  ORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence AVCCCCC
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."AVCCCCC"  MINVALUE 1 MAXVALUE 99999 INCREMENT BY 1 START WITH 100000 NOCACHE  ORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence AVCCCCCC
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."AVCCCCCC"  MINVALUE 1 MAXVALUE 999999 INCREMENT BY 1 START WITH 1140 NOCACHE  ORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence AVRQCCC
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."AVRQCCC"  MINVALUE 0 MAXVALUE 999 INCREMENT BY 1 START WITH 70 NOCACHE  ORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence AVRQOUTDOORCCC
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."AVRQOUTDOORCCC"  MINVALUE 1 MAXVALUE 999 INCREMENT BY 1 START WITH 685 NOCACHE  ORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence AVRQSCCC
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."AVRQSCCC"  MINVALUE 1 MAXVALUE 99 INCREMENT BY 1 START WITH 1 NOCACHE  ORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence AVRQTRIALCCC
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."AVRQTRIALCCC"  MINVALUE 295 MAXVALUE 999 INCREMENT BY 1 START WITH 378 NOCACHE  ORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence BLOB_CNT
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."BLOB_CNT"  MINVALUE 1 MAXVALUE 9999 INCREMENT BY 1 START WITH 17 NOCACHE  ORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence CREDIT
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."CREDIT"  MINVALUE 1 MAXVALUE 9999 INCREMENT BY 1 START WITH 1 NOCACHE  ORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence DOC_CNT
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."DOC_CNT"  MINVALUE 1 MAXVALUE 9999 INCREMENT BY 1 START WITH 4 NOCACHE  ORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence IMPORTID
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."IMPORTID"  MINVALUE 1 MAXVALUE 9999 INCREMENT BY 1 START WITH 328 NOCACHE  ORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence INVOICE
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."INVOICE"  MINVALUE 1 MAXVALUE 9999 INCREMENT BY 1 START WITH 1 NOCACHE  ORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence LINK_CNT
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."LINK_CNT"  MINVALUE 1 MAXVALUE 9999 INCREMENT BY 1 START WITH 4 NOCACHE  ORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence OFFER
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."OFFER"  MINVALUE 1 MAXVALUE 9999 INCREMENT BY 1 START WITH 1 NOCACHE  ORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence PRINT_CURRENT_LY_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."PRINT_CURRENT_LY_SEQ"  MINVALUE 1 MAXVALUE 999999999 INCREMENT BY 1 START WITH 1 NOCACHE  ORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence SDCOUNTER
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."SDCOUNTER"  MINVALUE 1 MAXVALUE 9999 INCREMENT BY 1 START WITH 1 NOCACHE  ORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_ALERT_NR
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."SEQ_ALERT_NR"  MINVALUE 1 MAXVALUE 1000000 INCREMENT BY 1 START WITH 285259 CACHE 20 NOORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_EVENT_NR
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."SEQ_EVENT_NR"  MINVALUE 1 MAXVALUE 1000000 INCREMENT BY 1 START WITH 674189 CACHE 10000 NOORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence TEST_COUNTER0
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."TEST_COUNTER0"  MINVALUE 1 MAXVALUE 999 INCREMENT BY 1 START WITH 2 NOCACHE  ORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence TEST_COUNTER1
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."TEST_COUNTER1"  MINVALUE 1 MAXVALUE 999 INCREMENT BY 1 START WITH 2 NOCACHE  ORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence TR_SEQ_EVENT_NR
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."TR_SEQ_EVENT_NR"  MINVALUE 1 MAXVALUE 1000000 INCREMENT BY 1 START WITH 170001 CACHE 10000 NOORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence U4SPECX_PPSEQ
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."U4SPECX_PPSEQ"  MINVALUE 0 MAXVALUE 999999999 INCREMENT BY 1 START WITH 0 NOCACHE  ORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence U4SPECX_STSEQ
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."U4SPECX_STSEQ"  MINVALUE 0 MAXVALUE 999999999 INCREMENT BY 1 START WITH 0 NOCACHE  ORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence UTERROR_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."UTERROR_SEQ"  MINVALUE 1 MAXVALUE 9999 INCREMENT BY 1 START WITH 2 CACHE 20 NOORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence WSCOUNTER
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."WSCOUNTER"  MINVALUE 1 MAXVALUE 9999 INCREMENT BY 1 START WITH 52 NOCACHE  ORDER  CYCLE ;
--------------------------------------------------------
--  DDL for Sequence XML
--------------------------------------------------------

   CREATE SEQUENCE  "UNILAB"."XML"  MINVALUE 1 MAXVALUE 9999 INCREMENT BY 1 START WITH 1767 NOCACHE  ORDER  CYCLE ;

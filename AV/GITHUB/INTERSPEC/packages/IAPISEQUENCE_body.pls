CREATE OR REPLACE PACKAGE BODY iapiSequence
AS
   
   
   
   
   
   
   
   
   
   
   

   
   FUNCTION GETPACKAGEVERSION
      RETURN IAPITYPE.STRING_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPackageVersion';
   BEGIN
      
      
      
       RETURN(    IAPIGENERAL.GETVERSION
              || ' ($Revision: 6.7.0.0 (06.07.00.00-01.00) $)' );

   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   END GETPACKAGEVERSION;

   
   
   

   
   
   

   
   
   
   FUNCTION GETNEXTVALUE(
      ASINTERNATIONAL            IN       IAPITYPE.INTL_TYPE,
      ASTYPE                     IN       IAPITYPE.STRING_TYPE,
      ANNEXTSEQUENCE             OUT      IAPITYPE.SEQUENCE_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
       
       
       
       
      
       
       
       
       
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetNextValue';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ASTYPE = 'association'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT ASSOCIATION_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT ASSOCIATION_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      IF ASTYPE = 'condition'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT CONDITION_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT CONDITION_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      IF ASTYPE = 'characteristic'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT CHARACTERISTIC_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT CHARACTERISTIC_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      IF ASTYPE = 'property'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT PROPERTY_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT PROPERTY_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      IF ASTYPE = 'property_group'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT PROPERTY_GROUP_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT PROPERTY_GROUP_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      IF ASTYPE = 'stage'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT STAGE_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT STAGE_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      IF ASTYPE = 'test_method'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT TEST_METHOD_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT TEST_METHOD_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      IF ASTYPE = 'uom'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT UOM_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT UOM_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      IF ASTYPE = 'uom_group'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT UOM_GROUP_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT UOM_GROUP_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      IF ASTYPE = 'attribute'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT ATTRIBUTE_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT ATTRIBUTE_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      IF ASTYPE = 'layout'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT LAYOUT_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT LAYOUT_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      IF ASTYPE = 'bom_layout'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT BOM_LAYOUT_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT BOM_LAYOUT_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      IF ASTYPE = 'nut_layout'
      THEN
         SELECT NUT_LAYOUT_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      IF ASTYPE = 'header'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT HEADER_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT HEADER_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      IF ASTYPE = 'workflow_group'
      THEN
         SELECT WORKFLOW_GROUP_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      IF ASTYPE = 'section'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT SECTION_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT SECTION_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      IF ASTYPE = 'sub_section'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT SUB_SECTION_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT SUB_SECTION_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      IF ASTYPE = 'access_group'
      THEN
         SELECT ACCESS_GROUP_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      IF ASTYPE = 'class3'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT CLASS3_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT CLASS3_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      IF ASTYPE = 'text_type'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT TEXT_TYPE_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT TEXT_TYPE_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      IF ASTYPE = 'user_group'
      THEN
         SELECT USER_GROUP_ID_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      IF ASTYPE = 'work_flow'
      THEN
         SELECT WORK_FLOW_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      IF ASTYPE = 'status'
      THEN
         SELECT STATUS_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      IF ASTYPE = 'rdstatus'
      THEN
         SELECT RDSTATUS_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      IF ASTYPE = 'format'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT FORMAT_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT FORMAT_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      
      IF ASTYPE = 'kw'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT KW_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT KW_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      
      IF ASTYPE = 'kwch'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT KWCH_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT KWCH_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      IF ASTYPE = 'ped_group'
      THEN
         SELECT PED_GROUP_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      IF ASTYPE = 'repg'
      THEN
         SELECT REPG_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      IF ASTYPE = 'repd'
      THEN
         SELECT REPD_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      IF ASTYPE = 'ftgrp'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT FTGRP_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT FTGRP_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      IF ASTYPE = 'ftbase'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT FTBASE_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT FTBASE_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      IF ASTYPE = 'ftsql'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT FTSQL_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT FTSQL_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      IF ASTYPE = 'ftframe'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT FTFRAME_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT FTFRAME_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      
      IF ASTYPE = 'ingredient'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT INGREDIENT_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT INGREDIENT_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      
      IF ASTYPE = 'ingcfg'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT INGCFG_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT INGCFG_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      
      IF ASTYPE = 'mfc_id'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT MFC_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT MFC_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      
      IF ASTYPE = 'user_location'
      THEN
         SELECT USLOC_ID.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      
      IF ASTYPE = 'user_category'
      THEN
         SELECT USCAT_ID.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      
      IF ASTYPE = 'itcf'
      THEN
         SELECT ITCF_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      
      IF ASTYPE = 'mat_class_id'
      THEN
         SELECT MAT_CLASS_ID_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      
      IF ASTYPE = 'mat_class_code'
      THEN
         SELECT MAT_CLASS_CODE_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      
      IF ASTYPE = 'itcld'
      THEN
         SELECT ITCLD_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      
      IF ASTYPE = 'itfrmval'
      THEN
         SELECT ITFRMVAL_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      
      IF ASTYPE = 'itlabelset'
      THEN
         SELECT ITLABELSET_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      
      IF ASTYPE = 'reptempl'
      THEN
         SELECT ITREPTEMPLATE_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      
      IF ASTYPE = 'plantgroup'
      THEN
         SELECT ITPLGRP_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      
      IF ASTYPE = 'mpl'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT MPL_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT MPL_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      
      IF ASTYPE = 'mtp'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT MTP_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT MTP_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      
      IF ASTYPE = 'ingnote'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT INGNOTE_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT INGNOTE_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;

      
      IF ASTYPE = 'event'
      THEN
         SELECT ITEVENT_ID_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      
      IF ASTYPE = 'addon'
      THEN
         SELECT ITADDONS_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      IF ASTYPE = 'foodtype'
      THEN
         SELECT ITFOODTYPE_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      IF ASTYPE = 'foodclaim'
      THEN
         SELECT ITFOODCLAIM_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      IF ASTYPE = 'foodclaimsyn'
      THEN
         SELECT ITFOODCLAIMSYN_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      IF ASTYPE = 'foodclaimcd'
      THEN
         SELECT ITFOODCLAIMCD_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      IF ASTYPE = 'foodclaimcrit'
      THEN
         SELECT ITFOODCLAIMCRIT_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      IF ASTYPE = 'foodclaimcritkey'
      THEN
         SELECT ITFOODCLAIMCRITKEY_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      IF ASTYPE = 'foodclaimcritkeycd'
      THEN
         SELECT ITFOODCLAIMCRITKEYCD_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      IF ASTYPE = 'foodclaimcritrule'
      THEN
         SELECT ITFOODCLAIMCRITRULE_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      IF ASTYPE = 'foodclaimcritrulecd'
      THEN
         SELECT ITFOODCLAIMCRITRULECD_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      IF ASTYPE = 'foodclaimnote'
      THEN
         SELECT ITFOODCLAIMNOTE_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      IF ASTYPE = 'foodclaimalert'
      THEN
         SELECT ITFOODCLAIMALERT_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      IF ASTYPE = 'foodclaimlabel'
      THEN
         SELECT ITFOODCLAIMLABEL_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      IF ASTYPE = 'foodclaimlog'
      THEN
         SELECT ITFOODCLAIMLOG_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      IF ASTYPE = 'nutlygroup'
      THEN
         SELECT ITNUTLYGROUP_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;

      
      IF ASTYPE = 'nutnote'
      THEN
         SELECT ITNUTNOTE_SEQ.NEXTVAL
           INTO ANNEXTSEQUENCE
           FROM DUAL;
      END IF;
      

      
      
      IF LOWER(ASTYPE) = 'reasontext'
      THEN
         IF ASINTERNATIONAL = '1'
         THEN
            SELECT REASONTEXT_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         ELSE
            SELECT REASONTEXT_SEQ.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         END IF;
      END IF;
      
            
      
      
      IF LOWER(ASTYPE) = 'ingdetail'
      THEN
         
         
            SELECT ITINGDETAILCONFIG_SEQ_INTL.NEXTVAL
              INTO ANNEXTSEQUENCE
              FROM DUAL;
         
         
         
         
         
      END IF;
      

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GETNEXTVALUE;
END IAPISEQUENCE;
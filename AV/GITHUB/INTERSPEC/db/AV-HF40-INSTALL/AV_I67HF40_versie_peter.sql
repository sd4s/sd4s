SET DEFINE ON

CONNECT &1/&2

BEGIN
   DBMS_OUTPUT.put_line( 'Database install script: I67HF40' );
END;
/

BEGIN
   DBMS_OUTPUT.put_line( 'Stop All Jobs' );
END;
/

/* 
--HIER GAAN WE ONZE EIGEN PROCEDURES GEBRUIKEN !!!!

@Stop_All_Jobs
/
@Stop_Mail_Server
/
@Stop_Spec_Server_And_Queue
/
*/

--call it before iapiGeneral becomes eventually invalid - trigger triggered
@Add_Interspc_cfg.sql
/

@ITNUTRESULTREMARK.sql


BEGIN
   DBMS_OUTPUT.put_line( 'FUNCTIONS START' );
END;
/

@F_USER_APPROVE.plb
/
@F_GET_ACCESS_MOP_CREATE_REV.plb
/

/*
--DEZE FUNCTIES ZIJN AFKOMSTIG VAN HOTFIXES VAN HF29 EN DAARVOOR...
--HOEVEN WE NIETS MEER MEE TE DOEN !!!

@F_CHH_ID.plb
/
@SYNONYMS_GRANTS_F_CHH_ID.sql
/
@F_GET_FIELD_ID_LAYOUT_PB.plb
/
@SYNONYMS_GRANTS_F_GET_FIELD_ID_LAYOUT_PB.sql
/
@F_GET_COMPARE_ING_DETAIL_PB.plb
/
@SYNONYMS_GRANTS_F_GET_COMPARE_ING_DETAIL_PB.sql
/
@F_GET_COMPARE_ING_DETAIL.plb
/
@SYNONYMS_GRANTS_F_GET_COMPARE_ING_DETAIL.sql
/
@f_check_access.plb
/
@f_check_ext_access.sql
/
@SYNONYM_GRANT_FCHECK_EXT_ACCESS.sql
/
@F_GET_ACCESSGROUP.sql
/
@SYNONYM_GRANT_F_GET_ACCESSGROUP.sql
/
@F_SH_PLANNED_EFF.plb
/
@F_RETURN_REV.plb
/
@F_FIND_PSEUDO_ALL.plb
/
@F_ING_DESCR_LANG.plb
/
@Add_grants_F_ING_DESCR_LANG.sql
/
@F_CONVERT_BASE_UOMDESCRIPTION.plb
/
@Add_grants_F_CONVERT_BASE_UOMDESCRIPTION.sql
/
@F_SAVE_RNDTBOMHEADER.plb
/
@F_DELETE_RNDTBOMHEADER.plb
/
@F_DELBOM_RNDTBOMHEADER.plb
/
@F_COPYBOM_RNDTBOMHEADER.plb
/
@F_GET_SVAL_REP.plb
/
@F_CHECK_BOM_HEADER.plb
/
@F_TRANS_GLOS.plb
/
--@F_GET_ACCESS_MOP_CREATE_REV.plb
--/
*/

BEGIN
   DBMS_OUTPUT.put_line( 'FUNCTIONS END' );
END;
/





/*
--DEZE PROCEDURES ZIJN AFKOMSTIG VAN HOTFIXES VAN HF29 EN DAARVOOR...
--HOEVEN WE NIETS MEER MEE TE DOEN !!!

BEGIN
   DBMS_OUTPUT.put_line( 'PROCEDURE START' );
END;
/
@SP_COMPARE_SPEC.plb
/
@SP_SET_SPEC_CURRENT.plb
/

BEGIN
   DBMS_OUTPUT.put_line( 'PROCEDURES END' );
END;
/

*/



BEGIN
   DBMS_OUTPUT.put_line( 'PACKAGES START' );
END;
/

@iapiGeneral.h

@iapiGeneral.plb


@iapiSpecification.plb

@iapiQueue.plb

@iapiSpecificationIngrdientList.h

@iapiSpecificationIngrdientList.plb

@iapiNutritionalFunctions.plb
/*
show err
Errors for PACKAGE BODY IAPINUTRITIONALFUNCTIONS:

LINE/COL ERROR
-------- -----------------------------------------------------------------
2148/13  PL/SQL: SQL Statement ignored
2148/25  PL/SQL: ORA-00942: table or view does not exist
--
INSERT INTO ITNUTRESULTREMARK VALUES (ANUNIQUEID,ANMOPSEQUENCENO,ANROWID,ANCOLID,'RDAWRN');

*/


@iapiNutritionalCalculation.h

@iapiNutritionalCalculation.plb
/*
Errors for PACKAGE BODY IAPINUTRITIONALCALCULATION:

LINE/COL ERROR
-------- -----------------------------------------------------------------
2012/7   PL/SQL: SQL Statement ignored
2041/14  PL/SQL: ORA-00904: "PERCENT_RDA_CALCULATION": invalid identifier
8530/7   PL/SQL: SQL Statement ignored
8530/19  PL/SQL: ORA-00942: table or view does not exist
--
na AANMAKEN van tabel ITNUTRESULTREMARK kan deze package ook goed compiled worden.
*/

@iapiFrame.plb




/*
--DEZE PACKAGES ZIJN AFKOMSTIG VAN HOTFIXES VAN HF29 EN DAARVOOR...
--HOEVEN WE NIETS MEER MEE TE DOEN !!!

@iapiTextSearch.plb
/
@iapiSpecificationSection.h
/
@iapiType.h
/
@iapiSpecification.h
/
@iapiConstantDbError.h
/
@iapiSpecificationValidation.h
/
@iapiCompare.h
/
@aopaSpecificationBomFWB.h
/
--@iapiGeneral.h
--/
@iapiSpecificationBom.h
/
--@iapiNutritionalCalculation.h
--/

@iapiPlantPart.plb
/
--@iapiNutritionalFunctions.plb
--/
@iapiPartPlant.plb
/
@iapiGeneral.plb
/
@aopaSpecificationBomFWB.plb
/
@iapiCompare.plb
/
--@iapiSpecification.plb
--/
@iapiObject.plb
/
@iapiLabel.plb
/
--@iapiNutritionalCalculation.plb
--/
@iapiClaims.plb
/
@iapiDisplayFormat.plb
/
@iapiEmail.plb
/
@iapiUomGroups.plb
/
@iapiSpecificationSection.plb
/
@iapiSpecificationReferenceText.plb
/
@iapiSpecificationObject.plb
/
--@iapiSpecificationIngrdientList.h
--/
--@iapiSpecificationIngrdientList.plb
--/
@iapiSpecificationStatus.plb
/
@iapiSpecificationProcessData.plb
/
@iapiSpecificationProcessData.plb
/
--@iapiQueue.plb
--/
@iapiReport.plb
/
@iapiSpecificationValidation.plb
/
@iapiSpecificationBom.plb
/
@iapiMigrateData.plb
/
--@iapiFrame.plb
--/
*/

BEGIN
   DBMS_OUTPUT.put_line( 'PACKAGES END' );
END;
/




BEGIN
   DBMS_OUTPUT.put_line( 'OTHER UPDATE SCRIPTS START' );
END;
/


@ITNUTREFTYPE.sql




/*
--DEZE ALTER-SCRIPTS ZIJN AFKOMSTIG VAN HOTFIXES VAN HF29 EN DAARVOOR...
--HOEVEN WE NIETS MEER MEE TE DOEN !!!

@TR_PART_PLANT_AI.sql
/
@UPDATE_PART_PLANT.sql
/
--TFS-8174 - altered in other script
--@SpIngListItemRecord_Type_UPDATE.sql
--/
--@SpIngListItemRecordPb_Type_UPDATE.sql
--/
@ITMESSAGE_UPGRADE.sql
/
@DELETE_HISTORIC_OBSOLETE_ITBOMLYSOURCE.sql
/
@ITBOMLYSOURCE.sql
/
@PROPERTY_LAYOUT.sql
/
@UPDATE_EDITALL_PROP_LAY.sql
/
@TR_LAYOUT_UPDATE.sql
/
@ITRTHS.sql
/
@ITAPI.sql
/
@ITFRMDEL.sql
/
@FT_FRAMES.sql
/
@FT_FRAMES_H.sql
/
@VIEW_ONLY.sql
/
@MRP.sql
/
@FRAME_BUILDER.sql
/
@APPROVER.sql
/
@DEV_MGR.sql
/
@GRANT_EXECUTE.sql
/
@ITINGALLERGENHIGHLIGHTING.sql
/
@ITALLERGENSYNONYMTYPE.sql
/
@ITALLERGENSYNONYMTYPE_H.sql
/
@ITINGCFGSYNONYMTYPE.sql
/
@ITINGCFGSYNONYMTYPE_H.sql
/
@TR_ITINGCFGSYNONYMTYPE_OU.sql
/
@TR_ITINGCFGSYNONYMTYPE_OI.sql
/
@TR_ITINGCFGSYNONYMTYPE_OD.sql
/
@TR_ITALLERGENSYNONYMTYPE_OU.sql
/
@TR_ITALLERGENSYNONYMTYPE_OI.sql
/
@TR_ITALLERGENSYNONYMTYPE_OD.sql
/
@ITINGCFGSYNONYMTYPE_upg.sql
/
@TR_SPPHS_AU.sql
/
@JRNL_SPECIFICATION_HEADER.sql
/
@UPDATE_ASSOCIATION_H.sql
/  
@ITREPTEMPLATE.sql
/
@F_REMINGALL.plb
/
@ITSPECINGDETAIL.sql
/
@ITINGDETAILCONFIG_CHARASSOC.sql
/
@ITINGDETAILCONFIG_CHARASSOC_H.sql
/
@TR_ITINGDETCFG_CHARASSOC_OU.sql
/
@TR_ITINGDETCFG_CHARASSOC_OI.sql
/
@TR_ITINGDETCFG_CHARASSOC_OD.sql
/
@TR_CHARACTERISTIC_STATUS_OU.sql
/
@TR_ITINGDETAILCONFIG_OU.sql
/
@TR_ASSOCIATION_STATUS_OU.sql
/
@ITMESSAGE.sql
/
@ITMESSAGE_API.sql
/
@Update_SPECIFICATION_ING.sql
/
@UPDATE_ProcData_Charact.sql
/
@SPECIFICATION_ING_grant.sql
/
@RNDTFWBBOMEXPLOSION.sql
/
@RNDTFWBINGREDIENTSNEW.sql
/
@IVRNDTFWBBOMEXPLOSION.sql
/
@IVRNDTFWBINGREDIENTSNEW.sql
/
@RNDTFWBINGREDIENTSNEW_OI.sql
/
@aopaSpecificationBomFWB_Syn_Grants.sql
/
@Alter_Locked.sql
/
@UPGRADE_SPECIFICATION_ING.sql
/
@UPGRADE_SPECIFICATION_ING_LANG.sql
/
@Alter_Quantity_Types.sql
/
@Alter_Quantity_Tables.sql
/
@Alter_Quantity_RnDTables.sql
/
--@ITNUTREFTYPE.sql
--/


--deze was dus NIET geinstalleerd !!!! Alsnog in draaiboek opgenomen !!!!
@ITNUTRESULTREMARK.sql
/
*/


BEGIN
   DBMS_OUTPUT.put_line( 'OTHER UPDATE SCRIPTS END' );
END;
/



/*
--DE CXSAPILK-package IS EIGENDOM VAN INTERSPC-USER en niet van RNDLICENCE-user !!!
--PACKAGE IS OOK ONDERDEEL VAN HF27, DUS NIET INTERESSANT VOOR ONS !!!!
--HOEVEN WE NIETS MEER MEE TE DOEN !!!

GRANT CREATE SESSION TO RNDLICENSE;

SET DEFINE ON
CONNECT RNDLICENSE/&3

--@cxsapilk.hlb

@cxsapilk.plb
/

--compile the invalid objects
BEGIN

    DBMS_UTILITY.compile_schema ('RNDLICENSE', FALSE);            
   
EXCEPTION
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE('Exception has occurred: ' || SQLERRM);   
END;
/


SET DEFINE ON
CONNECT &1/&2

REVOKE CREATE SESSION FROM RNDLICENSE;
*/



BEGIN
   DBMS_OUTPUT.put_line( 'Compile And Start Jobs' );
END;
/

--WE GEBRUIKEN NIET DE DEFAULT, MAAR ROEPEN ALLEEN DE COMPILE-ALL DIE IN DIT AAN!!!

@AV_Compile_and_Start_Jobs_versie_peter.sql
/

/*
ORACLEPROD_TEST:
--
CREATE OR REPLACE FORCE VIEW "INTERSPC"."AV_SPECIFICATION_HEADER" 
("PART_NO", "REVISION", "STATUS", "DESCRIPTION", "PLANNED_EFFECTIVE_DATE", "ISSUED_DATE", "OBSOLESCENCE_DATE"
, "STATUS_CHANGE_DATE", "PHASE_IN_TOLERANCE", "CREATED_BY", "CREATED_ON", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON"
, "FRAME_ID", "FRAME_REV", "ACCESS_GROUP", "WORKFLOW_GROUP_ID", "CLASS3_ID", "OWNER", "INT_FRAME_NO", "INT_FRAME_REV"
, "INT_PART_NO", "INT_PART_REV", "FRAME_OWNER", "INTL", "MULTILANG", "UOM_TYPE", "MASK_ID", "PED_IN_SYNC", "LOCKED"
, "LINKED_TO_TC", "LAST_SAVED_TO_TC", "TC_IN_PROGRESS") 
AS 
select "PART_NO","REVISION","STATUS","DESCRIPTION","PLANNED_EFFECTIVE_DATE","ISSUED_DATE","OBSOLESCENCE_DATE"
,"STATUS_CHANGE_DATE","PHASE_IN_TOLERANCE","CREATED_BY","CREATED_ON","LAST_MODIFIED_BY","LAST_MODIFIED_ON"
,"FRAME_ID","FRAME_REV","ACCESS_GROUP","WORKFLOW_GROUP_ID","CLASS3_ID","OWNER","INT_FRAME_NO","INT_FRAME_REV"
,"INT_PART_NO","INT_PART_REV","FRAME_OWNER","INTL","MULTILANG","UOM_TYPE","MASK_ID","PED_IN_SYNC","LOCKED"
,"LINKED_TO_TC","LAST_SAVED_TO_TC","TC_IN_PROGRESS"
from   specification_header
where  f_check_access(part_no, revision) = 1;

ORACLEPROD:
--
CREATE OR REPLACE FORCE VIEW "INTERSPC"."AV_SPECIFICATION_HEADER" 
("PART_NO", "REVISION", "STATUS", "DESCRIPTION", "PLANNED_EFFECTIVE_DATE", "ISSUED_DATE", "OBSOLESCENCE_DATE"
, "STATUS_CHANGE_DATE", "PHASE_IN_TOLERANCE", "CREATED_BY", "CREATED_ON", "LAST_MODIFIED_BY", "LAST_MODIFIED_ON"
, "FRAME_ID", "FRAME_REV", "ACCESS_GROUP", "WORKFLOW_GROUP_ID", "CLASS3_ID", "OWNER", "INT_FRAME_NO", "INT_FRAME_REV"
, "INT_PART_NO", "INT_PART_REV", "FRAME_OWNER", "INTL", "MULTILANG", "UOM_TYPE", "MASK_ID", "PED_IN_SYNC", "LOCKED") 
AS 
select "PART_NO","REVISION","STATUS","DESCRIPTION","PLANNED_EFFECTIVE_DATE","ISSUED_DATE","OBSOLESCENCE_DATE"
,"STATUS_CHANGE_DATE","PHASE_IN_TOLERANCE","CREATED_BY","CREATED_ON","LAST_MODIFIED_BY","LAST_MODIFIED_ON"
,"FRAME_ID","FRAME_REV","ACCESS_GROUP","WORKFLOW_GROUP_ID","CLASS3_ID","OWNER","INT_FRAME_NO","INT_FRAME_REV"
,"INT_PART_NO","INT_PART_REV","FRAME_OWNER","INTL","MULTILANG","UOM_TYPE","MASK_ID","PED_IN_SYNC","LOCKED"
from   specification_header
where  f_check_access(part_no, revision) = 1;




--@Compile_and_Start_Jobs.sql
--/


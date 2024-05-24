create or replace PACKAGE BODY          TeunisUtil IS

  PROCEDURE Logon
  IS
   res         iapiType.ErrorNum_Type;
  BEGIN
    res := iapiGeneral.SetConnection(asUserId => 'TJR', asModuleName => '');
  END;
  
/*
declare
   res         iapiType.ErrorNum_Type;
begin
  res  := iapiGeneral.SetConnection(asUserId => 'TJR', asModuleName => '');
  res := TeunisUtil.copySpec('EV_BH205/55R16SN3', 'EV_TEST_TEUNIS');
end;
*/

  FUNCTION EraseBom(
      asPartNo        IN   iapiType.PartNo_Type)
    RETURN iapiType.ErrorNum_Type
  IS
    lnRetVal    iapiType.ErrorNum_Type;
    lqBomItem   iapiType.Ref_Type;
    lqErrors    iapiType.Ref_Type;
    lqInfo    iapiType.Ref_Type;
    ltBomItem   iapiType.GetBomItemTab_Type;
    lrBomItem   iapiType.GetBomItemRec_Type;
    lnRevision  iapiType.Revision_Type;
  BEGIN
    BEGIN
      SELECT Revision INTO lnRevision
      FROM Specification_header 
      WHERE part_no = asPartno AND Status=1;
    EXCEPTION
      WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
      THEN
        lnRevision := 0;
    END;
    IF lnRevision <> 0
    THEN
      lnRetVal := iapiSpecificationBom.GetItems( asPartNo,
                                                 lnRevision,
                                                 'ENS',
                                                 1,
                                                 1,
                                                 -1,
                                                 lqBomItem,
                                                 lqErrors );
      IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS
      THEN
         FETCH lqBomItem
         BULK COLLECT INTO ltBomItem;
         IF (ltBomItem.COUNT > 0)
         THEN
            FOR lnIndex IN ltBomItem.FIRST .. ltBomItem.LAST
            LOOP
               lrBomItem := ltBomItem(lnIndex);
               lnRetVal :=
                  iapiSpecificationBom.RemoveItem(lrBomItem.PartNo,
                                                  lrBomItem.Revision,
                                                  lrBomItem.Plant,
                                                  lrBomItem.Alternative,
                                                  lrBomItem.BomUsage,
                                                  lrBomItem.ItemNumber,
                                                  lqInfo,
                                                  lqErrors);
               IF lnRetVal != iapiConstantDbError.DBERR_SUCCESS
               THEN
                  dbms_output.put_line('Error deleting item: ' || lrBomItem.PartNo ||' ' || iapiGeneral.GetLastErrorText);
                  RETURN lnRetVal;
               END IF;
            END LOOP;
         ELSE
           dbms_output.put_line('Empty BOM for: ' || asPartNo);
         END IF;
         RETURN iapiConstantDbError.DBERR_SUCCESS;
      ELSE
         dbms_output.put_line('Error retrieving header: ' || lrBomItem.PartNo ||' ' || iapiGeneral.GetLastErrorText);
         RETURN lnRetVal;
      END IF;
    ELSE 
      dbms_output.put_line('No version in DEV: ' || asPartNo);
      RETURN 0;
    END IF;
  END;
  
    FUNCTION AddBewerking(
    aPart_no      iapiType.PartNo_Type,
    aSubSectionId iapiType.Id_Type)
  RETURN iapiType.ErrorNum_Type
  AS
      res         iapiType.ErrorNum_Type;
      aqInfo      iapiType.Ref_Type;
      aqErrors    iapiType.Ref_Type;
      aRev        iapiType.Revision_Type;
  BEGIN
    SELECT revision INTO aRev FROM specification_header 
    WHERE part_no = aPart_no AND Status=1;
    res := iapispecificationSection.AddSectionItem(
      aPart_No,
      aRev,
      700583,
      aSubSectionId,
      4,
      710528,
      NULL,
      NULL,
      NULL);
    IF res <> 0 THEN
      dbms_output.put_line(aPart_no || ' Error in AddSection: ' || res || '  ' ||  iapiGeneral.GetLastErrorText);
      RETURN res;
    ELSE
      res := iapiSpecificationPropertyGroup.AddProperty(
          aPart_no, aRev, 
          700583, aSubSectionId,
          0, 710528, 0,
          NULL, aqInfo, aqErrors);
      IF res <> 0 THEN
        dbms_output.put_line(aPart_no || ' Error in AddProperty: ' || res || '  ' ||  iapiGeneral.GetLastErrorText);
        RETURN res;
      ELSE
        dbms_output.put_line(aPart_no || ' Property created');
        RETURN 0;
      END IF;
    END IF;
  END;

  FUNCTION RemBewerking(
    aPart_no      iapiType.PartNo_Type,
    aRevision     iapiType.Revision_Type,
    aSubSectionId iapiType.Id_Type)
  RETURN iapiType.ErrorNum_Type
  AS
    cErrors  iapiType.Ref_Type;
    res             iapiType.ErrorNum_Type;
    lqSectionItems  iapiType.Ref_Type;
    ltSectionItems  iapiType.SpSectionItemTab_Type;
    sect            iapiType.SpSectionItemRec_Type;
    i NUMBER;
  BEGIN
    res := IApiSpecificationSection.GetSectionItems(
               aPart_no, aRevision,
               700583, aSubSectionId,
               1, lqSectionItems,  cErrors);
    IF res = 0 THEN
      FETCH lqSectionItems BULK COLLECT INTO ltSectionItems;
      IF (ltSectionItems.COUNT > 0) THEN
        FOR i IN ltSectionItems.FIRST .. ltSectionItems.LAST LOOP
          sect := ltSectionItems(i);
          res := iapispecificationSection.RemoveSectionItem(
            aPart_No,
            aRevision,
            700583,
            aSubSectionId,
            sect.ITEMTYPE,
            sect.ITEMID,
            NULL,
            NULL,
            NULL);
          IF res <> 0 THEN
            dbms_output.put_line('Error deleting item for: ' || aPart_no || '.' || aRevision || ':' || aSubSectionId ||
              ' Item: ' || sect.ITEMTYPE || ' ' || sect.ITEMID);
            RETURN res;
          END IF;
        END LOOP;
        dbms_output.put_line('subsection deleted: ' || aPart_no || '.' || aRevision || ':' || aSubSectionId);
        RETURN 0;
      ELSE 
        dbms_output.put_line('No items found for: ' || aPart_no || '.' || aRevision || ':' || aSubSectionId);
        RETURN 0;
      END IF;
    ELSE
      dbms_output.put_line('Error in GetSectionItems: ' || res ||' ' || iapiGeneral.GetLastErrorText);
      RETURN res;
    END IF;
 
  END;
  
    FUNCTION AddTPM(
    aPart_no      iapiType.PartNo_Type,
    aRevision     iapiType.Revision_Type,
    aSubSectionId iapiType.Id_Type)
  RETURN iapiType.ErrorNum_Type
  AS
      res         iapiType.ErrorNum_Type;
      aqInfo      iapiType.Ref_Type;
      aqErrors    iapiType.Ref_Type;
      aRev     iapiType.Revision_Type;
  BEGIN
    SELECT revision INTO aRev FROM specification_header 
    WHERE part_no = aPart_no AND Status=1;
    res := iapispecificationSection.AddSectionItem(
      aPart_No,
      aRev,
      700583,
      aSubSectionId,
      4,
      710914,
      NULL,
      NULL,
      NULL);
    IF res <> 0 THEN
      dbms_output.put_line(aPart_no || ' Error in AddSection: ' || res || '  ' ||  iapiGeneral.GetLastErrorText);
      RETURN res;
    ELSE 
      res := iapiSpecificationPropertyGroup.AddProperty(
          aPart_no, aRev, 
          700583, aSubSectionId,
          0, 710914, 0,
          NULL, aqInfo, aqErrors);
      IF res <> 0 THEN
        dbms_output.put_line(aPart_no || ' Error in AddProperty: ' || res || '  ' ||  iapiGeneral.GetLastErrorText);
        RETURN res;
      ELSE
        dbms_output.put_line(aPart_no || ' Property created');
        RETURN 0;
      END IF;
    END IF;
  END;

  FUNCTION AddWKK(
    aPart_no      iapiType.PartNo_Type,
    aSubSectionId iapiType.Id_Type)
  RETURN iapiType.ErrorNum_Type
  AS
      res         iapiType.ErrorNum_Type;
      aqInfo      iapiType.Ref_Type;
      aqErrors    iapiType.Ref_Type;
      aRev     iapiType.Revision_Type;
  BEGIN
    SELECT revision INTO aRev FROM specification_header 
    WHERE part_no = aPart_no AND Status=1;
      res := iapiSpecificationPropertyGroup.AddProperty(
          aPart_no, aRev, 
          700583, aSubSectionId,
          701556, 703514, 0,
          NULL, aqInfo, aqErrors);
      IF res <> 0 THEN
        dbms_output.put_line(aPart_no || ' Error in AddProperty: ' || res || '  ' ||  iapiGeneral.GetLastErrorText);
        RETURN res;
      ELSE
        dbms_output.put_line(aPart_no || ' Property created');
        RETURN 0;
      END IF;
  END;

  FUNCTION AddZijkant(
    aPart_no      iapiType.PartNo_Type,
    aSubSectionId iapiType.Id_Type)
  RETURN iapiType.ErrorNum_Type
  AS
      res         iapiType.ErrorNum_Type;
      aqInfo      iapiType.Ref_Type;
      aqErrors    iapiType.Ref_Type;
      aRev     iapiType.Revision_Type;
  BEGIN
    SELECT revision INTO aRev FROM specification_header 
    WHERE part_no = aPart_no AND Status=1;
      res := iapiSpecificationPropertyGroup.AddProperty(
          aPart_no, aRev, 
          700584, aSubSectionId,
          701564, 705668, 0,
          NULL, aqInfo, aqErrors);
      IF res <> 0 THEN
        dbms_output.put_line(aPart_no || ' Error in AddProperty: ' || res || '  ' ||  iapiGeneral.GetLastErrorText);
        RETURN res;
      ELSE
        dbms_output.put_line(aPart_no || ' Property created');
        RETURN 0;
      END IF;
  END;

  FUNCTION AddHiel(
    aPart_no      iapiType.PartNo_Type,
    aSubSectionId iapiType.Id_Type)
  RETURN iapiType.ErrorNum_Type
  AS
      res         iapiType.ErrorNum_Type;
      aqInfo      iapiType.Ref_Type;
      aqErrors    iapiType.Ref_Type;
      aRev     iapiType.Revision_Type;
  BEGIN
    SELECT revision INTO aRev FROM specification_header 
    WHERE part_no = aPart_no AND Status=1;
      res := iapiSpecificationPropertyGroup.AddProperty(
          aPart_no, aRev, 
          700583, aSubSectionId,
          701556, 705286, 0,
          NULL, aqInfo, aqErrors);
      IF res <> 0 THEN
        dbms_output.put_line(aPart_no || ' Error in AddProperty: ' || res || '  ' ||  iapiGeneral.GetLastErrorText);
        RETURN res;
      ELSE
        dbms_output.put_line(aPart_no || ' Property created');
        RETURN 0;
      END IF;
  END;

  FUNCTION AddStaalstrook(
    aPart_no      iapiType.PartNo_Type,
    aSubSectionId iapiType.Id_Type)
  RETURN iapiType.ErrorNum_Type
  AS
      res         iapiType.ErrorNum_Type;
      aqInfo      iapiType.Ref_Type;
      aqErrors    iapiType.Ref_Type;
      aRev     iapiType.Revision_Type;
  BEGIN
    SELECT revision INTO aRev FROM specification_header 
    WHERE part_no = aPart_no AND Status=1;
      res := iapiSpecificationPropertyGroup.AddProperty(
          aPart_no, aRev, 
          700583, aSubSectionId,
          701556, 705639, 0,
          NULL, aqInfo, aqErrors);
      IF res <> 0 THEN
        dbms_output.put_line(aPart_no || ' Error in AddProperty: ' || res || '  ' ||  iapiGeneral.GetLastErrorText);
        RETURN res;
      ELSE
        dbms_output.put_line(aPart_no || ' Property created');
        RETURN 0;
      END IF;
  END;

  FUNCTION AddTread(
    aPart_no      iapiType.PartNo_Type,
    aSubSectionId iapiType.Id_Type)
  RETURN iapiType.ErrorNum_Type
  AS
      res         iapiType.ErrorNum_Type;
      aqInfo      iapiType.Ref_Type;
      aqErrors    iapiType.Ref_Type;
      aRev     iapiType.Revision_Type;
  BEGIN
    SELECT revision INTO aRev FROM specification_header 
    WHERE part_no = aPart_no AND Status=1;
      res := iapiSpecificationPropertyGroup.AddProperty(
          aPart_no, aRev, 
          700584, aSubSectionId,
          701564, 705408, 0,
          NULL, aqInfo, aqErrors);
      IF res <> 0 THEN
        dbms_output.put_line(aPart_no || ' Error in AddProperty: ' || res || '  ' ||  iapiGeneral.GetLastErrorText);
        RETURN res;
      ELSE
        dbms_output.put_line(aPart_no || ' Property created');
        RETURN 0;
      END IF;
  END;

  FUNCTION AddPhase(
    aPart_no      iapiType.PartNo_Type,
    aPropertyID iapiType.Id_Type)
  RETURN iapiType.ErrorNum_Type
  AS
      res         iapiType.ErrorNum_Type;
      aqInfo      iapiType.Ref_Type;
      aqErrors    iapiType.Ref_Type;
      aRev     iapiType.Revision_Type;
  BEGIN
    SELECT revision INTO aRev FROM specification_header 
    WHERE part_no = aPart_no AND Status=1;
      res := iapiSpecificationPropertyGroup.AddProperty(
          aPart_no, aRev, 
          700583, 700542,
          701567, aPropertyID, 0,
          NULL, aqInfo, aqErrors);
      IF res <> 0 THEN
        dbms_output.put_line(aPart_no || ' Error in AddProperty: ' || res || '  ' ||  iapiGeneral.GetLastErrorText);
        RETURN res;
      ELSE
        dbms_output.put_line(aPart_no || ' Property created');
        RETURN 0;
      END IF;
  END;

  FUNCTION AddHoogteLVT(
    aPart_no      iapiType.PartNo_Type,
    aSubSectionId iapiType.Id_Type)
  RETURN iapiType.ErrorNum_Type
  AS
      res         iapiType.ErrorNum_Type;
      aqInfo      iapiType.Ref_Type;
      aqErrors    iapiType.Ref_Type;
      aRev     iapiType.Revision_Type;
  BEGIN
    SELECT revision INTO aRev FROM specification_header 
    WHERE part_no = aPart_no AND Status=1;
    res := iapispecificationSection.AddSectionItem(
      aPart_No,
      aRev,
      700583,
      aSubSectionId,
      1,
      701556,
      NULL,
      NULL,
      NULL);
    IF res <> 0 THEN
      dbms_output.put_line(aPart_no || ' Error in AddSection: ' || res || '  ' ||  iapiGeneral.GetLastErrorText);
    ELSE
      dbms_output.put_line(aPart_no || ' Section added ');
    END IF;  
      res := iapiSpecificationPropertyGroup.AddProperty(
          aPart_no, aRev, 
          700583, aSubSectionId,
          701556, 707129, 0,
          NULL, aqInfo, aqErrors);
      IF res <> 0 THEN
        dbms_output.put_line(aPart_no || ' Error in AddProperty: ' || res || '  ' ||  iapiGeneral.GetLastErrorText);
        RETURN res;
      ELSE
        dbms_output.put_line(aPart_no || ' Property created');
        RETURN 0;
      END IF;
  END;

FUNCTION AddCapStripWidth(
    aPart_no      iapiType.PartNo_Type,
    aSubSectionId iapiType.Id_Type)
  RETURN iapiType.ErrorNum_Type
  AS
      res         iapiType.ErrorNum_Type;
      aqInfo      iapiType.Ref_Type;
      aqErrors    iapiType.Ref_Type;
      aRev     iapiType.Revision_Type;
  BEGIN
    SELECT revision INTO aRev FROM specification_header 
    WHERE part_no = aPart_no AND Status=1;
      res := iapiSpecificationPropertyGroup.AddProperty(
          aPart_no, aRev, 
          700584, aSubSectionId,
          701564, 705642, 0,
          NULL, aqInfo, aqErrors);
      IF res <> 0 THEN
        dbms_output.put_line(aPart_no || ' Error in AddProperty: ' || res || '  ' ||  iapiGeneral.GetLastErrorText);
        RETURN res;
      ELSE
        dbms_output.put_line(aPart_no || ' Property created');
        RETURN 0;
      END IF;
  END;

FUNCTION AddCapStripLayer(
    aPart_no      iapiType.PartNo_Type,
    aSubSectionId iapiType.Id_Type)
  RETURN iapiType.ErrorNum_Type
  AS
      res         iapiType.ErrorNum_Type;
      aqInfo      iapiType.Ref_Type;
      aqErrors    iapiType.Ref_Type;
      aRev     iapiType.Revision_Type;
  BEGIN
    SELECT revision INTO aRev FROM specification_header 
    WHERE part_no = aPart_no AND Status=1;
      res := iapiSpecificationPropertyGroup.AddProperty(
          aPart_no, aRev, 
          700584, aSubSectionId,
          701564, 706128, 0,
          NULL, aqInfo, aqErrors);
      IF res <> 0 THEN
        dbms_output.put_line(aPart_no || ' Error in AddProperty: ' || res || '  ' ||  iapiGeneral.GetLastErrorText);
        RETURN res;
      ELSE
        dbms_output.put_line(aPart_no || ' Property created');
        RETURN 0;
      END IF;
  END;

FUNCTION AddRemark(
    aPart_no      iapiType.PartNo_Type,
    aSubSectionId iapiType.Id_Type)
  RETURN iapiType.ErrorNum_Type
  AS
      res         iapiType.ErrorNum_Type;
      lqInfo      iapiType.Ref_Type;
      lqErrors    iapiType.Ref_Type;
      aRev     iapiType.Revision_Type;
  BEGIN
    SELECT revision INTO aRev FROM specification_header 
    WHERE part_no = aPart_no AND Status=1;
     res :=IAPISPECIFICATIONFREETEXT.ADDFREETEXT(
       aPart_no,
       aRev,
       700583,
       aSubSectionId,
       702526,
       1, NULL, NULL, 
       lqInfo, lqErrors); 
      IF res <> 0 THEN
        dbms_output.put_line(aPart_no || ' Error in AddText: ' || res || '  ' ||  iapiGeneral.GetLastErrorText);
        RETURN res;
      ELSE
        dbms_output.put_line(aPart_no || ' Remark created');
        RETURN 0;
      END IF;
  END;

    FUNCTION AddSegmenten(
    aPart_no      iapiType.PartNo_Type,
    aSubSectionId iapiType.Id_Type)
  RETURN iapiType.ErrorNum_Type
  AS
      res         iapiType.ErrorNum_Type;
      aRev     iapiType.Revision_Type;
      aqInfo      iapiType.Ref_Type;
      aqErrors    iapiType.Ref_Type;
  BEGIN
    SELECT revision INTO aRev FROM specification_header 
    WHERE part_no = aPart_no AND Status=1;
    res := 0;  /* iapispecificationSection.AddSectionItem(
      aPart_No,
      aRev,
      700583,
      aSubSectionId,
      1,
      701570,
      NULL,
      NULL,
      NULL); */
    IF res <> 0 THEN
      dbms_output.put_line(aPart_no || ' Error in AddSection: ' || res || '  ' ||  iapiGeneral.GetLastErrorText);
      RETURN res;
    ELSE
      res := iapiSpecificationPropertyGroup.AddProperty(
          aPart_no, aRev, 
          700583, aSubSectionId,
          701570, 703876, 0,
          NULL, aqInfo, aqErrors);
      IF res <> 0 THEN
        dbms_output.put_line(aPart_no || ' Error in AddProperty: ' || res || '  ' ||  iapiGeneral.GetLastErrorText);
        RETURN res;
      ELSE
        dbms_output.put_line(aPart_no || ' Property created');
        RETURN 0;
      END IF;
    END IF;
  END;

FUNCTION AddSectionItem(
    aPart_no      iapiType.PartNo_Type,
    aSectionId iapiType.Id_Type,
    aSubSectionId iapiType.Id_Type,
    aItemType  iapiType.SpecificationSectionType_Type,
    aItemId iapiType.Id_Type)
  RETURN iapiType.ErrorNum_Type
  AS
      res         iapiType.ErrorNum_Type;
      aqInfo      iapiType.Ref_Type;
      aqErrors    iapiType.Ref_Type;
      aRev     iapiType.Revision_Type;
  BEGIN
    SELECT revision INTO aRev FROM specification_header 
    WHERE part_no = aPart_no AND Status=1;
      res := iapiSpecificationSection.AddSectionItem(
          aPart_no, aRev, 
          aSectionId, aSubSectionId,
          aItemType, aItemId, 
          NULL, NULL, NULL);
      IF res <> 0 THEN
        dbms_output.put_line(aPart_no || ' Error in AddSectionItem: ' || res || '  ' ||  iapiGeneral.GetLastErrorText);
        RETURN res;
      ELSE
        dbms_output.put_line(aPart_no || ' SectionItem created');
        RETURN 0;
      END IF;
  END;

FUNCTION AddGroupProperty(
    aPart_no      iapiType.PartNo_Type,
    aSectionId iapiType.Id_Type,
    aSubSectionId iapiType.Id_Type,
    aPropGroupId iapiType.Id_Type,
    aPropertyId iapiType.Id_Type)
  RETURN iapiType.ErrorNum_Type
  AS
      res         iapiType.ErrorNum_Type;
      aqInfo      iapiType.Ref_Type;
      aqErrors    iapiType.Ref_Type;
      aRev     iapiType.Revision_Type;
  BEGIN
    SELECT revision INTO aRev FROM specification_header 
    WHERE part_no = aPart_no AND Status=1;
      res := iapiSpecificationPropertyGroup.AddProperty(
          aPart_no, aRev, 
          aSectionId, aSubSectionId,
          aPropGroupId, aPropertyId, 0,
          NULL, aqInfo, aqErrors);
      IF res <> 0 THEN
        dbms_output.put_line(aPart_no || ' Error in AddProperty: ' || res || '  ' ||  iapiGeneral.GetLastErrorText);
        RETURN res;
      ELSE
        dbms_output.put_line(aPart_no || ' Property created');
        RETURN 0;
      END IF;
  END;

FUNCTION AddTooling(
  aPart_no      iapiType.PartNo_Type,
  aSubSectionId iapiType.Id_Type)
RETURN iapiType.ErrorNum_Type
AS
    res         iapiType.ErrorNum_Type;
    aqInfo      iapiType.Ref_Type;
    aqErrors    iapiType.Ref_Type;
    aRev        iapiType.Revision_Type;
    aFrameId    iapiType.FrameNo_Type; 
    aFrameRev   iapiType.FrameRevision_Type;

    CURSOR cProperties(aFrame iapiType.FrameNo_Type, aFrameRev iapiType.FrameRevision_Type, aSubSection iapiType.Id_Type) IS
      SELECT Property, Attribute
      FROM Frame_Prop
      WHERE Frame_No = aFrame 
        AND Revision = aFrameRev
        AND Section_Id = 700583
        AND Sub_Section_id = aSubSection
        AND Property_Group = 701570
        AND Mandatory = 'Y';

BEGIN
  SELECT revision, Frame_Id, Frame_Rev
  INTO aRev, aFrameId, aFrameRev
  FROM specification_header 
  WHERE part_no = aPart_no AND Status=1;

  res := iapispecificationSection.AddSectionItem(
      aPart_No,
      aRev,
      700583,
      aSubSectionId,
      1,
      701570,
      NULL,
      NULL,
      NULL);
  IF res <> 0 THEN
    dbms_output.put_line(aPart_no || ' Error in AddSection: ' || res || '  ' ||  iapiGeneral.GetLastErrorText);
  ELSE 
    FOR rProperties IN cProperties(aFrameId, aFrameRev, aSubSectionId)
    LOOP
      IF res = 0 THEN
        res := iapiSpecificationPropertyGroup.AddProperty(
          aPart_No
          , aRev
          , 700583                 -- Processing
          , aSubSectionId
          , 701570                 -- Tooling
          , rProperties.Property
          , rProperties.Attribute
          , NULL
          , aqInfo
          , aqErrors
        );
      END IF;
    END LOOP;
    IF res = 0 THEN
      dbms_output.put_line(aPart_no || ' PropertyGroup <Tooling PG> created');
    ELSE
      dbms_output.put_line(aPart_no || ' Error in AddProperties: ' || res || '  ' ||  iapiGeneral.GetLastErrorText);
    END IF;
  END IF;
  RETURN res;
END;

FUNCTION CopySpec(
   aPart_no iapiType.PartNo_Type,
   aNewPart iapiType.PartNo_Type)
  RETURN  iapiType.ErrorNum_Type
AS
    res         iapiType.ErrorNum_Type;
    aqInfo      iapiType.Ref_Type;
    aqErrors    iapiType.Ref_Type;
    aRev        iapiType.Revision_Type;
    aDescr      iapiType.Description_Type;
    aNewpartKode iapiType.PartNo_Type; 
    aPartType   iapiType.Id_Type;
    aIntl    iapiType.Boolean_Type;
    aDate    iapiType.Date_Type;

    asPrefix                         iapiType.Prefix_Type;
    asCode                           iapiType.PartNo_Type;
    asDescription                    iapiType.Description_Type;
    adPlannedEffectiveDate           iapiType.Date_Type;
    anMetric                         iapiType.Boolean_Type;
    anMultiLanguage                  iapiType.Boolean_Type;
    asFrameNo                        iapiType.FrameNo_Type;
    anFrameRevision                  iapiType.FrameRevision_Type;
    anOwner                          iapiType.Owner_Type;
    anFrameMask                      iapiType.Id_Type;
    anWorkflowGroupId                iapiType.WorkFlowGroupId_Type;
    anAccessGroupId                  iapiType.Id_Type;
    anSpecTypeId                     iapiType.Id_Type;
    asUom                            iapiType.BaseUom_Type;
    asConversionFactor               iapiType.NumVal_Type;
    asConversionUom                  iapiType.BaseToUnit_Type;

BEGIN
  SELECT h.Revision, h.Description, h.INTL
  INTO aRev, aDescr, aIntl
  FROM specification_header h, Status s 
  WHERE h.part_no = aPart_no AND s.Status = h.Status and s.Status_Type='CURRENT';
  SELECT Part_TYPE
  INTO aPartType
  FROM PART p
  WHERE p.PART_NO = aPart_no;
  SELECT SYSDATE + 2 INTO aDate FROM dual;
  aNewPartKode := aNewPart;
  res := iapispecification.InitialiseForCopy(
    aPart_No, --      asFromPartNo               IN       iapiType.PartNo_Type,
    aRev, --      anFromRevision             IN       iapiType.Revision_Type,
    1,
    asPrefix,
    asCode,
    asDescription,
    adPlannedEffectiveDate,
    anMetric,
    anMultiLanguage,
    asFrameNo,
    anFrameRevision,
    anOwner,
    anFrameMask,
    anWorkflowGroupId,
    anAccessGroupId,
    anSpecTypeId,
    asUom,
    asConversionFactor,
    asConversionUom,
    aqErrors);--      aqErrors                   IN OUT   iapiType.Ref_Type )
--  dbms_output.put_line('Initialise: ' || res);
  if res <> 0 THEN
    dbms_output.put_line('Error in Initialise: ' || res); 
  ELSE
    res := iApiPart.AddPart(
      aNewPartKode, --  asPartNo                   IN OUT   iapiType.PartNo_Type,
      asDescription, --  asDescription              IN       iapiType.Description_Type,
      asUom, --  asBaseUom                  IN       iapiType.BaseUom_Type,
      NULL, --  asBaseToUnit               IN       iapiType.BaseToUnit_Type DEFAULT NULL,
      NULL, --  anBaseConvFactor           IN       iapiType.NumVal_Type DEFAULT NULL,
      'I-S', --  asPartSource               IN       iapiType.PartSource_Type,
      aPartType, --  anPartTypeId               IN       iapiType.Id_Type DEFAULT NULL,
      NULL, --  asEanUpcBarcode            IN       iapiType.PartNo_Type DEFAULT NULL,
      NULL, --  anObsolete                 IN       iapiType.Boolean_Type DEFAULT NULL,
      aqErrors); --  aqErrors                   OUT      iapiType.Ref_Type ) ;
    IF res <> 0 THEN
      dbms_output.put_line('Error in AddPart: ' || res); 
    ELSE
      res := iapispecification.CopySpecification(
        aPart_No, --      asFromPartNo               IN       iapiType.PartNo_Type,
        aRev, --      anFromRevision             IN       iapiType.Revision_Type,
        aNewPartKode, --      asPartNo                   IN OUT   iapiType.PartNo_Type,
        asFrameNo, --      asFrameId                  IN       iapiType.FrameNo_Type,
        anFrameRevision, --       anFrameRevision            IN       iapiType.FrameRevision_Type,
        anOwner, --       anFrameOwner               IN       iapiType.Owner_Type,
        anWorkflowGroupId, --     anWorkFlowGroupId          IN       iapiType.Id_Type,
        anAccessGroupId, --        anAccessGroupId            IN       iapiType.Id_Type,
        anSpecTypeId, --      anSpecTypeId               IN       iapiType.Id_Type,
        aDate, --      adPlannedEffectiveDate     IN       iapiType.Date_Type,
        1, --      anNewRevision              IN       iapiType.Revision_Type,
        anMultiLanguage, --      anMultiLanguage            IN       iapiType.Boolean_Type,
        anMetric, -- asUom, --      anUomType                  IN       iapiType.Boolean_Type,
        anFrameMask, --      anMaskId                   IN       iapiType.Id_Type,
        asDescription, --      asDescription              IN       iapiType.Description_Type,
        aIntl, --     anInternationalLinked      IN       iapiType.Boolean_Type DEFAULT 0,
        aqErrors);--      aqErrors                   IN OUT   iapiType.Ref_Type )
      dbms_output.put_line('CopySpecification: ' || res); 
    END IF;
  END IF;
--      RETURN iapiType.ErrorNum_Type;
  RETURN res;
END;

END;
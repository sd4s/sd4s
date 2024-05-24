create or replace PACKAGE BODY aapiSpecificationPropertyGroup
AS
   psSource   CONSTANT iapiType.Source_Type := 'aapiSpecificationPropertyGroup';

   FUNCTION GetPropertyValue(
      asPartNo            IN   iapiType.PartNo_Type,
      anRevision          IN   iapiType.Revision_Type,
      anSectionId         IN   iapiType.Id_Type,
      anSubSectionId      IN   iapiType.Id_Type,
      anPropertyGroupId   IN   iapiType.Id_Type,
      anPropertyId        IN   iapiType.Id_Type,
      anAttributeId       IN   iapiType.Id_Type,
      anHeaderId          IN   iapiType.Id_Type,
      anLanguageId        IN   iapiType.LanguageId_Type DEFAULT 1)
      RETURN iapiType.PropertyLongString_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type             := 'GetPropertyValue';
      lqErrors            iapiType.Ref_Type;
      lsPropertyValue     iapiType.PropertyLongString_Type;
      lqProperties        iapiType.Ref_Type;
      ltProperties        iapiType.SpPropertyTab_Type;
      lrProperty          iapiType.SpPropertyRec_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asPartNo', asPartNo);
      aapiTrace.Param('anRevision', anRevision);
      aapiTrace.Param('anSectionId', anSectionId);
      aapiTrace.Param('anSubSectionId', anSubSectionId);
      aapiTrace.Param('anPropertyGroupId', anPropertyGroupId);
      aapiTrace.Param('anPropertyId', anPropertyId);
      aapiTrace.Param('anAttributeId', anAttributeId);
      aapiTrace.Param('anHeaderId', anHeaderId);
      aapiTrace.Param('anLanguageId', anLanguageId);
   
      --In 6.1, this functionality is provided by PA_GET_VAL.F_GET_SVAL
      --Because this legacy API will be removed from 6.3, we already provide an alternative now
      lsPropertyValue := NULL;
      iapiGeneral.LogInfo(psSource,
                          csMethod,
                             'Called for '
                          || 'asPartNo => '
                          || asPartNo
                          || ', anRevision => '
                          || anRevision
                          || ', anSectionId => '
                          || anSectionId
                          || ', anSubSectionId => '
                          || anSubSectionId
                          || ', anPropertyGroupId => '
                          || anPropertyGroupId
                          || ', anPropertyId => '
                          || anPropertyId
                          || ', anAttributeId => '
                          || anAttributeId
                          || ', anHeaderId => '
                          || anHeaderId);
      iapiGeneral.LogInfo(psSource, csMethod, 'Retrieving property values');

      CASE iapiSpecificationPropertyGroup.GetProperties
             (asPartNo                     => asPartNo,
              anRevision                   => anRevision,
              anSectionId                  => anSectionId,
              anSubSectionId               => anSubSectionId,
              anItemId                     => anPropertyGroupId,
              anIncludedOnly               => aapiConstant.BOOLEAN_TRUE,
              anAlternativeLanguageId      => CASE anLanguageId
                 WHEN 1
                    THEN NULL
                 ELSE anLanguageId
              END,   --Reference language is not considered an alternative language
              aqProperties                 => lqProperties,
              aqErrors                     => lqErrors)
         WHEN iapiConstantDbError.DBERR_SUCCESS
         THEN
            FETCH lqProperties
            BULK COLLECT INTO ltProperties;

            IF (ltProperties.COUNT > 0)
            THEN
               FOR lnIndex IN ltProperties.FIRST .. ltProperties.LAST
               LOOP
                  lrProperty := ltProperties(lnIndex);

                  IF lrProperty.PropertyId = anPropertyId
                  THEN
                     iapiGeneral.LogInfo(psSource,
                                         csMethod,
                                         'Property <' || lrProperty.PropertyId || '> matches');
                     lsPropertyValue :=
                        GetPropertyValueByHeader(arProperty      => lrProperty,
                                                 anHeaderId      => anHeaderId);
                     EXIT;   --we found our property match, so no need to continue looping
                  ELSE
                     iapiGeneral.LogInfo(psSource,
                                         csMethod,
                                         'Property <' || lrProperty.PropertyId || '> doesn''t match');
                  END IF;
               END LOOP;
            ELSE
               iapiGeneral.LogInfo(psSource, csMethod, 'No properties returned');
            END IF;
         ELSE
            iapiGeneral.LogError(psSource,
                                 csMethod,
                                    'iapiSpecificationPropertyGroup.GetProperties('
                                 || 'asPartNo => '
                                 || asPartNo
                                 || ', anRevision => '
                                 || anRevision
                                 || ', anSectionId => '
                                 || anSectionId
                                 || ', anSubSectionId => '
                                 || anSubSectionId
                                 || ', anItemId => '
                                 || anPropertyGroupId
                                 || ', anIncludedOnly => '
                                 || aapiConstant.BOOLEAN_TRUE
                                 || ', anAlternativeLanguageId => '
                                 || CASE anLanguageId
                                       WHEN 1
                                          THEN NULL
                                       ELSE anLanguageId
                                    END
                                 || ', aqProperties => lqProperties, aqErrors => lqErrors): '
                                 || iapiGeneral.GetLastErrorText);
          aapiTrace.Error(iapiGeneral.GetLastErrorText());
      END CASE;

      iapiGeneral.LogInfo(psSource, csMethod, 'Returning <' || lsPropertyValue || '>');
      aapiTrace.Exit(lsPropertyValue);
      RETURN lsPropertyValue;
   EXCEPTION
      WHEN OTHERS
      THEN
         iapiGeneral.LogError(psSource, csMethod, SQLERRM);
         aapiTrace.Error(SQLERRM);
         aapiTrace.Exit();
         RETURN NULL;
   END GetPropertyValue;

   FUNCTION GetPropertyValueByHeader(
      arProperty   IN   iapiType.SpPropertyRec_Type,
      anHeaderId   IN   iapiType.Id_Type)
      RETURN iapiType.PropertyLongString_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type             := 'GetPropertyValueByHeader';
      lnFieldId           iapiType.Id_Type;
      lsPropertyValue     iapiType.PropertyLongString_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('anHeaderId', anHeaderId);

      iapiGeneral.LogInfo
                      (psSource,
                       csMethod,
                       'Retrieving field configured for this header in this item''s display format');

      CASE aapiDisplayFormat.GetFieldMatchingHeader(asPartNo            => arProperty.PartNo,
                                                    anRevision          => arProperty.Revision,
                                                    anSectionId         => arProperty.SectionId,
                                                    anSubSectionId      => arProperty.SubSectionId,
                                                    anItemId            => arProperty.PropertyGroupId,
                                                    anHeaderId          => anHeaderId,
                                                    anFieldId           => lnFieldId)
         WHEN iapiConstantDbError.DBERR_SUCCESS
         THEN
            iapiGeneral.LogInfo(psSource,
                                csMethod,
                                   'Retrieving value for header <'
                                || anHeaderId
                                || '>, matching field <'
                                || lnFieldId
                                || '>');
            lsPropertyValue :=
                           GetPropertyValueByField(arProperty      => arProperty,
                                                   anFieldId       => lnFieldId);
         ELSE
            iapiGeneral.LogError(psSource,
                                 csMethod,
                                    'aapiDisplayFormat.GetFieldMatchingHeader('
                                 || 'asPartNo => '
                                 || arProperty.PartNo
                                 || ', anRevision => '
                                 || arProperty.Revision
                                 || ', anSectionId => '
                                 || arProperty.SectionId
                                 || ', anSubSectionId => '
                                 || arProperty.SubSectionId
                                 || ', anItemId => '
                                 || arProperty.PropertyGroupId
                                 || ', anHeaderId => '
                                 || anHeaderId
                                 || ', anFieldId => lnFieldId)');
      END CASE;

      iapiGeneral.LogInfo(psSource, csMethod, 'Returning <' || lsPropertyValue || '>');
      
      aapiTrace.Exit(lsPropertyValue);
      RETURN lsPropertyValue;
   EXCEPTION
      WHEN OTHERS
      THEN
         iapiGeneral.LogError(psSource, csMethod, SQLERRM);
         aapiTrace.Error(SQLERRM);
         aapiTrace.Exit();
         RETURN NULL;
   END GetPropertyValueByHeader;

   FUNCTION GetPropertyValueByField(
      arProperty   IN   iapiType.SpPropertyRec_Type,
      anFieldId    IN   iapiType.Id_Type)
      RETURN iapiType.PropertyLongString_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type             := 'GetPropertyValueByField';
      lsPropertyValue     iapiType.PropertyLongString_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('anFieldId', anFieldId);

      iapiGeneral.LogInfo(psSource, csMethod, 'Extracting field matching id <' || anFieldId || '>');
      lsPropertyValue :=
         CASE anFieldId
            WHEN aapiConstant.FIELDTYPE_NUMERIC1
               THEN TO_CHAR(arProperty.Numeric1)
            WHEN aapiConstant.FIELDTYPE_NUMERIC2
               THEN TO_CHAR(arProperty.Numeric2)
            WHEN aapiConstant.FIELDTYPE_NUMERIC3
               THEN TO_CHAR(arProperty.Numeric3)
            WHEN aapiConstant.FIELDTYPE_NUMERIC4
               THEN TO_CHAR(arProperty.Numeric4)
            WHEN aapiConstant.FIELDTYPE_NUMERIC5
               THEN TO_CHAR(arProperty.Numeric5)
            WHEN aapiConstant.FIELDTYPE_NUMERIC6
               THEN TO_CHAR(arProperty.Numeric6)
            WHEN aapiConstant.FIELDTYPE_NUMERIC7
               THEN TO_CHAR(arProperty.Numeric7)
            WHEN aapiConstant.FIELDTYPE_NUMERIC8
               THEN TO_CHAR(arProperty.Numeric8)
            WHEN aapiConstant.FIELDTYPE_NUMERIC9
               THEN TO_CHAR(arProperty.Numeric9)
            WHEN aapiConstant.FIELDTYPE_NUMERIC10
               THEN TO_CHAR(arProperty.Numeric10)
            --Even though the reference language doesn't count as an alternative language,
            --the corresponding columns always seem to be filled out correctly
         WHEN aapiConstant.FIELDTYPE_CHARACTER1
               THEN arProperty.AlternativeString1
            WHEN aapiConstant.FIELDTYPE_CHARACTER2
               THEN arProperty.AlternativeString2
            WHEN aapiConstant.FIELDTYPE_CHARACTER3
               THEN arProperty.AlternativeString3
            WHEN aapiConstant.FIELDTYPE_CHARACTER4
               THEN arProperty.AlternativeString4
            WHEN aapiConstant.FIELDTYPE_CHARACTER5
               THEN arProperty.AlternativeString5
            WHEN aapiConstant.FIELDTYPE_CHARACTER6
               THEN arProperty.AlternativeString6
            WHEN aapiConstant.FIELDTYPE_BOOLEAN1
               THEN TO_CHAR(arProperty.Boolean1)
            WHEN aapiConstant.FIELDTYPE_BOOLEAN2
               THEN TO_CHAR(arProperty.Boolean2)
            WHEN aapiConstant.FIELDTYPE_BOOLEAN3
               THEN TO_CHAR(arProperty.Boolean3)
            WHEN aapiConstant.FIELDTYPE_BOOLEAN4
               THEN TO_CHAR(arProperty.Boolean4)
            WHEN aapiConstant.FIELDTYPE_DATE1
               THEN TO_CHAR(arProperty.Date1)
            WHEN aapiConstant.FIELDTYPE_DATE2
               THEN TO_CHAR(arProperty.Date2)
            WHEN aapiConstant.FIELDTYPE_UOM
               THEN arProperty.Uom
            WHEN aapiConstant.FIELDTYPE_ATTRIBUTE
               THEN arProperty.ATTRIBUTE
            WHEN aapiConstant.FIELDTYPE_TESTMETHOD
               THEN arProperty.TestMethod
            WHEN aapiConstant.FIELDTYPE_ASSOCIATION1
               THEN arProperty.CharacteristicDescription1
            WHEN aapiConstant.FIELDTYPE_ASSOCIATION2
               THEN arProperty.CharacteristicDescription2
            WHEN aapiConstant.FIELDTYPE_ASSOCIATION3
               THEN arProperty.CharacteristicDescription3
            WHEN aapiConstant.FIELDTYPE_PROPERTY
               THEN arProperty.Property
            WHEN aapiConstant.FIELDTYPE_TESTDETAIL1
               THEN TO_CHAR(arProperty.TestMethodDetails1)
            WHEN aapiConstant.FIELDTYPE_TESTDETAIL2
               THEN TO_CHAR(arProperty.TestMethodDetails2)
            WHEN aapiConstant.FIELDTYPE_TESTDETAIL3
               THEN TO_CHAR(arProperty.TestMethodDetails3)
            WHEN aapiConstant.FIELDTYPE_TESTDETAIL4
               THEN TO_CHAR(arProperty.TestMethodDetails4)
            WHEN aapiConstant.FIELDTYPE_NOTE
               THEN SUBSTR(arProperty.AlternativeInfo, 1, 120)
            ELSE NULL
         END;
      iapiGeneral.LogInfo(psSource, csMethod, 'Returning <' || lsPropertyValue || '>');
      
      aapiTrace.Exit(lsPropertyValue);
      RETURN lsPropertyValue;
   EXCEPTION
      WHEN OTHERS
      THEN
         iapiGeneral.LogError(psSource, csMethod, SQLERRM);
         aapiTrace.Error(SQLERRM);
         aapiTrace.Exit();
         RETURN NULL;
   END GetPropertyValueByField;
END aapiSpecificationPropertyGroup;
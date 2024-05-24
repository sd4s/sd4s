create or replace PACKAGE BODY aapiDisplayFormat
AS
   psSource   CONSTANT iapiType.Source_Type := 'aapiDisplayFormat';

   FUNCTION GetFieldMatchingHeader(
      asPartNo         IN       iapiType.PartNo_Type,
      anRevision       IN       iapiType.Revision_Type,
      anSectionId      IN       iapiType.Id_Type,
      anSubSectionId   IN       iapiType.Id_Type,
      anItemId         IN       iapiType.Id_Type,
      anHeaderId       IN       iapiType.Id_Type,
      anFieldId        OUT      iapiType.Id_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type := 'GetFieldMatchingHeader';
      lqHeaders           iapiType.Ref_Type;
      ltHeaders           iapiType.HdrTab_Type;
      lrHeader            iapiType.HdrRec_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asPartNo', asPartNo);
      aapiTrace.Param('anRevision', anRevision);
      aapiTrace.Param('anSectionId', anSectionId);
      aapiTrace.Param('anSubSectionId', anSubSectionId);
      aapiTrace.Param('anItemId', anItemId);
      aapiTrace.Param('anHeaderId', anHeaderId);
      
      CASE iapiDisplayFormat.GetHeaders(asPartNo            => asPartNo,
                                        anRevision          => anRevision,
                                        anSectionId         => anSectionId,
                                        anSubSectionId      => anSubSectionId,
                                        anItemId            => anItemId,
                                        aqHeaders           => lqHeaders)
         WHEN iapiConstantDbError.DBERR_SUCCESS
         THEN
            FETCH lqHeaders
            BULK COLLECT INTO ltHeaders;

            IF (ltHeaders.COUNT > 0)
            THEN
               FOR lnIndex IN ltHeaders.FIRST .. ltHeaders.LAST
               LOOP
                  lrHeader := ltHeaders(lnIndex);

                  IF lrHeader.HeaderId = anHeaderId
                  THEN
                     iapiGeneral.LogInfo(psSource,
                                         csMethod,
                                         'Header <' || lrHeader.HeaderId || '> matches');
                     anFieldId := lrHeader.FieldId;
                     EXIT;
                  ELSE
                     iapiGeneral.LogInfo(psSource,
                                         csMethod,
                                         'Header <' || lrHeader.HeaderId || '> doesn''t match');
                  END IF;
               END LOOP;
            END IF;
         ELSE
            iapiGeneral.LogError(psSource,
                                 csMethod,
                                    'iapiDisplayFormat.GetHeaders('
                                 || 'asPartNo => '
                                 || asPartNo
                                 || ', anRevision => '
                                 || anRevision
                                 || ', anSectionId => '
                                 || anSectionId
                                 || ', anSubSectionId => '
                                 || anSubSectionId
                                 || ', anItemId => '
                                 || anItemId
                                 || ', aqHeaders => lqHeaders)');
            anFieldId := NULL;
      END CASE;

      IF anFieldId IS NOT NULL
      THEN
         aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
         RETURN iapiConstantDbError.DBERR_SUCCESS;
      ELSE
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapigeneral.SetErrorText(iapiConstantDbError.DBERR_GENFAIL);
      END IF;
   END GetFieldMatchingHeader;

   FUNCTION GetHeaderMatchingField(
      asPartNo         IN       iapiType.PartNo_Type,
      anRevision       IN       iapiType.Revision_Type,
      anSectionId      IN       iapiType.Id_Type,
      anSubSectionId   IN       iapiType.Id_Type,
      anItemId         IN       iapiType.Id_Type,
      anFieldId        IN       iapiType.Id_Type,
      anHeaderId       OUT      iapiType.Id_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type := 'GetHeaderMatchingField';
      lqHeaders           iapiType.Ref_Type;
      ltHeaders           iapiType.HdrTab_Type;
      lrHeader            iapiType.HdrRec_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asPartNo', asPartNo);
      aapiTrace.Param('anRevision', anRevision);
      aapiTrace.Param('anSectionId', anSectionId);
      aapiTrace.Param('anSubSectionId', anSubSectionId);
      aapiTrace.Param('anItemId', anItemId);
      aapiTrace.Param('anFieldId', anFieldId);

      CASE iapiDisplayFormat.GetHeaders(asPartNo            => asPartNo,
                                        anRevision          => anRevision,
                                        anSectionId         => anSectionId,
                                        anSubSectionId      => anSubSectionId,
                                        anItemId            => anItemId,
                                        aqHeaders           => lqHeaders)
         WHEN iapiConstantDbError.DBERR_SUCCESS
         THEN
            FETCH lqHeaders
            BULK COLLECT INTO ltHeaders;

            IF (ltHeaders.COUNT > 0)
            THEN
               FOR lnIndex IN ltHeaders.FIRST .. ltHeaders.LAST
               LOOP
                  lrHeader := ltHeaders(lnIndex);

                  IF lrHeader.FieldId = anFieldId
                  THEN
                     iapiGeneral.LogInfo(psSource,
                                         csMethod,
                                         'Field <' || lrHeader.FieldId || '> matches');
                     anHeaderId := lrHeader.HeaderId;
                     EXIT;
                  ELSE
                     iapiGeneral.LogInfo(psSource,
                                         csMethod,
                                         'Field <' || lrHeader.FieldId || '> doesn''t match');
                  END IF;
               END LOOP;
            END IF;
         ELSE
            iapiGeneral.LogError(psSource,
                                 csMethod,
                                    'iapiDisplayFormat.GetHeaders('
                                 || 'asPartNo => '
                                 || asPartNo
                                 || ', anRevision => '
                                 || anRevision
                                 || ', anSectionId => '
                                 || anSectionId
                                 || ', anSubSectionId => '
                                 || anSubSectionId
                                 || ', anItemId => '
                                 || anItemId
                                 || ', aqHeaders => lqHeaders)');
            anHeaderId := NULL;
      END CASE;

      IF anHeaderId IS NOT NULL
      THEN
         aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
         RETURN iapiConstantDbError.DBERR_SUCCESS;
      ELSE
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapigeneral.SetErrorText(iapiConstantDbError.DBERR_GENFAIL);
      END IF;
   END GetHeaderMatchingField;

   FUNCTION GetHeaderMatchingFieldFrame(
      asPartNo         IN       iapiType.PartNo_Type,
      anRevision       IN       iapiType.Revision_Type,
      anSectionId      IN       iapiType.Id_Type,
      anSubSectionId   IN       iapiType.Id_Type,
      anItemId         IN       iapiType.Id_Type,
      anFieldId        IN       iapiType.Id_Type,
      anHeaderId       OUT      iapiType.Id_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type := 'GetHeaderMatchingFieldFrame';
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asPartNo', asPartNo);
      aapiTrace.Param('anRevision', anRevision);
      aapiTrace.Param('anSectionId', anSectionId);
      aapiTrace.Param('anSubSectionId', anSubSectionId);
      aapiTrace.Param('anItemId', anItemId);
      aapiTrace.Param('anFieldId', anFieldId);

      SELECT pl.header_id
      INTO   anHeaderId
      FROM   specification_header sh, frame_section fs, property_layout pl
      WHERE  sh.part_no = asPartNo
      AND    sh.revision = anRevision
      AND    sh.frame_id = fs.frame_no
      AND    sh.frame_rev = fs.revision
      AND    fs.section_id = anSectionId
      AND    fs.sub_section_id = anSubSectionId
      AND    fs.TYPE IN
                   (iapiConstant.SECTIONTYPE_PROPERTYGROUP, iapiConstant.SECTIONTYPE_SINGLEPROPERTY)
      AND    fs.ref_id = anItemId
      AND    fs.display_format = pl.layout_id
      AND    fs.display_format_rev = pl.revision
      AND    pl.field_id = anFieldId;

      aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
      RETURN iapiConstantDbError.DBERR_SUCCESS;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         anHeaderId := NULL;
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapigeneral.SetErrorText(iapiConstantDbError.DBERR_GENFAIL);
   END GetHeaderMatchingFieldFrame;
END aapiDisplayFormat;
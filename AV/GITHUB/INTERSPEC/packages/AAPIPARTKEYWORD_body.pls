create or replace PACKAGE BODY aapiPartKeyword
AS
   FUNCTION GetKeywordValue(asPartNo IN iapiType.PartNo_Type, anKeywordId IN iapiType.Id_Type)
      RETURN iapiType.Description_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type         := 'GetKeywordValue';
      lsKeywordValue      iapiType.Description_Type;
      lqKeywords          iapiType.Ref_Type;
      ltKeywords          iapiType.SpecKeywordTab_Type;
      lrKeyword           iapiType.SpecKeywordRec_Type;
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asPartNo', asPartNo);
      aapiTrace.Param('anKeywordID', anKeywordID);
   
      lsKeywordValue := NULL;
      iapiGeneral.LogInfo(psSource,
                          csMethod,
                             'Called for '
                          || 'asPartNo => '
                          || asPartNo
                          || ', anKeywordId => '
                          || anKeywordId);
      iapiGeneral.LogInfo(psSource, csMethod, 'Retrieving keyword values');

      CASE iapiPartKeyword.GetKeywords(asPartNo => asPartNo, aqKeywords => lqKeywords)
         WHEN iapiConstantDbError.DBERR_SUCCESS
         THEN
            FETCH lqKeywords
            BULK COLLECT INTO ltKeywords;

            IF (ltKeywords.COUNT > 0)
            THEN
               FOR lnIndex IN ltKeywords.FIRST .. ltKeywords.LAST
               LOOP
                  lrKeyword := ltKeywords(lnIndex);

                  IF lrKeyword.KeywordId = anKeywordId
                  THEN
                     iapiGeneral.LogInfo(psSource,
                                         csMethod,
                                         'Keyword <' || lrKeyword.KeywordId || '> matches');
                     lsKeywordValue := lrKeyword.VALUE;
                     EXIT;   --we found our keyword match, so no need to continue looping
                  ELSE
                     iapiGeneral.LogInfo(psSource,
                                         csMethod,
                                         'Keyword <' || lrKeyword.KeywordId || '> doesn''t match');
                  END IF;
               END LOOP;
            ELSE
               iapiGeneral.LogInfo(psSource, csMethod, 'No keywords returned');
            END IF;
         ELSE
            iapiGeneral.LogError(psSource,
                                 csMethod,
                                    'iapiPartKeyword.GetKeywords('
                                 || 'asPartNo => '
                                 || asPartNo
                                 || ', aqKeywords => lqKeywords): '
                                 || iapiGeneral.GetLastErrorText);
            aapiTrace.Error(iapiGeneral.GetLastErrorText());
      END CASE;

      iapiGeneral.LogInfo(psSource, csMethod, 'Returning <' || lsKeywordValue || '>');
      
      aapiTrace.Exit(lsKeywordValue);
      RETURN lsKeywordValue;
   EXCEPTION
      WHEN OTHERS
      THEN
         iapiGeneral.LogError(psSource, csMethod, SQLERRM);
         aapiTrace.Error(SQLERRM);
         aapiTrace.Exit();
         RETURN NULL;
   END GetKeywordValue;

   FUNCTION SetKeywordValue(
      asPartNo         IN   iapiType.PartNo_Type,
      anKeywordId      IN   iapiType.Id_Type,
      asKeywordValue   IN   iapiType.Description_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type := 'SetKeywordValue';
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asPartNo', asPartNo);
      aapiTrace.Param('anKeywordID', anKeywordID);
      aapiTrace.Param('asKeywordValue', asKeywordValue);
      
      iapiGeneral.LogInfo(psSource,
                          csMethod,
                             'Called for <'
                          || asPartNo
                          || '><'
                          || anKeywordId
                          || '><'
                          || asKeywordValue
                          || '>');
      iapiGeneral.LogInfo(psSource, csMethod, 'Remove existing (conflicting) keywords');

      DELETE FROM specification_kw
      WHERE       part_no = asPartNo AND kw_id = anKeywordId AND kw_value != asKeywordValue;

      BEGIN
         INSERT INTO specification_kw
                     (part_no, kw_id, kw_value, intl)
         VALUES      (asPartNo, anKeywordId, asKeywordValue, '0');
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            iapiGeneral.LogInfo(psSource, csMethod, 'Keyword already exists');
      END;

      iapiGeneral.LogInfo(psSource, csMethod, 'Setting keyword completed');
      
      aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
      RETURN iapiConstantDbError.DBERR_SUCCESS;
   EXCEPTION
      WHEN OTHERS
      THEN
         iapiGeneral.LogError(psSource, csMethod, SQLERRM);
         aapiTrace.Error(SQLERRM);
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapiConstantDbError.DBERR_GENFAIL;
   END SetKeywordValue;
END aapiPartKeyword;
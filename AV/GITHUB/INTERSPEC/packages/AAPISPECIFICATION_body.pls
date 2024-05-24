create or replace PACKAGE BODY aapiSpecification
AS
   psSource   CONSTANT iapiType.Source_Type := 'aapiSpecification';

   FUNCTION GetActiveRevision(
      asPartNo           IN       iapiType.PartNo_Type,
      anRevision         IN       iapiType.Revision_Type DEFAULT NULL,
      adDate             IN       iapiType.Date_Type DEFAULT TRUNC(SYSDATE),
      asInDevelopment    IN       iapiType.Boolean_Type DEFAULT aapiConstant.BOOLEAN_FALSE,
      anActiveRevision   OUT      iapiType.Revision_Type)
      RETURN iapiType.ErrorNum_Type
   --Returns the revision of a specification that's active on a specific date, unless
   --  anRevision IS NOT NULL, in which case it's echoed back (useful if you're using
   --  this on e.g. component_part/component_revision in bom_item)
   --To include DEVELOPMENT and SUBMIT revisions, set asInDevelopment to TRUE
   IS
      csMethod   CONSTANT iapiType.Method_Type := 'GetActiveRevision';
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asPartNo', asPartNo);
      aapiTrace.Param('anRevision', anRevision);
      aapiTrace.Param('adDate', adDate);
      aapiTrace.Param('asInDevelopment', asInDevelopment);
      aapiTrace.Param('anActiveRevision', anActiveRevision);
   
      IF anRevision IS NOT NULL
      THEN
         anActiveRevision := anRevision;
      ELSE
         --f_find_pseudo_all returns a string composed of [Y|N|E]REVISION
         --the first character indicates whether the component has a BOM, and is irrelevant for our purposes
         anActiveRevision :=
            NVL
               (TO_NUMBER
                   (SUBSTR
                       (f_find_pseudo_all
                            (asPartNo             => asPartNo,
                             anRevision           => anRevision,
                             asPlant              => NULL,
                             adDrillDownDate      => adDate,
                             asInDevelopment      => CASE asInDevelopment
                                WHEN aapiConstant.BOOLEAN_TRUE
                                   THEN aapiConstant.YES
                                ELSE aapiConstant.NO
                             END),
                        2) ),
                0);
      END IF;

      aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
      RETURN iapiGeneral.SetErrorText(iapiConstantDbError.DBERR_SUCCESS);
   EXCEPTION
      WHEN OTHERS
      THEN
         iapiGeneral.LogError(psSource, csMethod, SQLERRM);
         aapiTrace.Error(SQLERRM);
         anActiveRevision := 0;
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapiGeneral.SetErrorText(iapiConstantDbError.DBERR_GENFAIL);
   END GetActiveRevision;

   FUNCTION GetHeader(
      asPartNo     IN       iapiType.PartNo_Type,
      anRevision   IN       iapiType.Revision_Type,
      arHeader     OUT      iapiType.SpecificationHeaderRec_Type)
      RETURN iapiType.ErrorNum_Type
   IS
      csMethod   CONSTANT iapiType.Method_Type := 'GetHeader';
   BEGIN
      aapiTrace.Enter();
      aapiTrace.Param('asPartNo', asPartNo);
      aapiTrace.Param('anRevision', anRevision);
      
      CASE iapiSpecification.ExistId(asPartNo, anRevision)
         WHEN iapiConstantDbError.DBERR_SUCCESS
         THEN
            CASE f_check_access(asPartNo, anRevision)
               WHEN 1
               THEN
                  SELECT part_no,
                         revision,
                         status,
                         description,
                         NULL,   --The record calls for a PhaseInDate, but specification_header doesn't have this column
                         planned_effective_date,
                         issued_date,
                         obsolescence_date,
                         NULL,   --The recoded calls for a ChangedDate, but specification_header doesn't have this column
                         status_change_date,
                         phase_in_tolerance,
                         created_by,
                         created_on,
                         last_modified_by,
                         last_modified_on,
                         frame_id,
                         frame_rev,
                         access_group,
                         workflow_group_id,
                         class3_id,
                         owner,
                         int_frame_no,
                         int_frame_rev,
                         int_part_no,
                         int_part_rev,
                         frame_owner,
                         intl,
                         multilang,
                         uom_type,
                         mask_id,
                         DECODE(ped_in_sync,
                                'Y', aapiConstant.BOOLEAN_TRUE,
                                aapiConstant.BOOLEAN_FALSE)   --convert character to boolean
                  INTO   arHeader
                  FROM   specification_header
                  WHERE  part_no = asPartNo AND revision = anRevision;

                  aapiTrace.Exit(iapiConstantDbError.DBERR_SUCCESS);
                  RETURN iapiConstantDbError.DBERR_SUCCESS;
               ELSE
                  aapiTrace.Exit(iapiConstantDbError.DBERR_NOVIEWACCESS);
                  RETURN iapiConstantDbError.DBERR_NOVIEWACCESS;
            END CASE;
         ELSE
            aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
            RETURN iapiGeneral.SetErrorText(iapiConstantDbError.DBERR_GENFAIL);
      END CASE;
   EXCEPTION
      WHEN OTHERS
      THEN
         iapiGeneral.LogError(psSource, csMethod, SQLERRM);
         aapiTrace.Error(SQLERRM);
         aapiTrace.Exit(iapiConstantDbError.DBERR_GENFAIL);
         RETURN iapiGeneral.SetErrorText(iapiConstantDbError.DBERR_GENFAIL);
   END GetHeader;
END aapiSpecification;
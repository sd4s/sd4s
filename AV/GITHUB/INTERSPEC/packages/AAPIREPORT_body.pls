create or replace PACKAGE BODY          aapiReport
AS
   PROCEDURE TyreExplosion(acData IN OUT iapiType.Ref_Type)
   IS
      lnBomExplosionId   iapiType.Sequence_Type;
      lqErrors           iapiType.Ref_Type;
   BEGIN
      CASE iapiGeneral.SetConnection('MVI')
         WHEN iapiConstantDbError.DBERR_SUCCESS
         THEN
            DELETE FROM itshq
            WHERE       user_id = 'MVI';

            INSERT INTO itshq
                        (user_id, part_no, revision)
               SELECT 'MVI', part_no, revision
               FROM   specification_header
               WHERE  class3_id IN(SELECT CLASS
                                   FROM   class3
                                   WHERE  UPPER(description) LIKE '%TYRE%')
               AND    status IN(SELECT status
                                FROM   status
                                WHERE  status_type = iapiConstant.STATUSTYPE_DEVELOPMENT);

            SELECT bom_explosion_seq.NEXTVAL
            INTO   lnBomExplosionId
            FROM   DUAL;

            CASE iapiSpecificationBom.Explode(anUniqueId                  => lnBomExplosionId,
                                              asPartNo                    => NULL,
                                              anRevision                  => NULL,
                                              asPlant                     => NULL,
                                              anAlternative               => NULL,
                                              anUsage                     => NULL,
                                              anUseMop                    => 1,
                                              anMultiLevel                => 1,
                                              anIncludeInDevelopment      => 1,
                                              adExplosionDate             => TRUNC(SYSDATE + 365),
                                              aqErrors                    => lqErrors)
               WHEN iapiConstantDbError.DBERR_SUCCESS
               THEN
                  IF NOT acData%ISOPEN
                  THEN
                     OPEN acData FOR
                        SELECT   e1.component_part, e1.component_revision,
                                 e1.part_type component_part_type, e2.component_part parent_part,
                                 e2.component_revision parent_revision,
                                 e2.part_type parent_part_type,
                                 f_sph_descr(1, sd.property, sd.property_rev) property,
                                 f_hdh_descr(1, sd.header_id, sd.header_rev) header, sd.value_s
                        FROM     itbomexplosion e1,
                                 (SELECT mop_sequence_no, component_part, component_revision,
                                         part_type
                                  FROM   itbomexplosion
                                  WHERE  bom_exp_no = lnBomExplosionId AND bom_level = 0) e2,
                                 specdata sd
                        WHERE    e1.bom_exp_no = lnBomExplosionId
                        AND      e1.mop_sequence_no = e2.mop_sequence_no
                        AND      e1.component_part = sd.part_no
                        AND      e1.component_revision = sd.revision
                        ORDER BY e1.mop_sequence_no, e1.sequence_no;
                  END IF;
               ELSE
                  iapiGeneral.LogError('aapiReport', 'TyreExplosion', iapiGeneral.GetLastErrorText);
            END CASE;
         ELSE
            iapiGeneral.LogError('aapiReport', 'TyreExplosion', iapiGeneral.GetLastErrorText);
      END CASE;
   END TyreExplosion;
END aapiReport; 
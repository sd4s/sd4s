create or replace PACKAGE BODY          aogenfuncs IS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : APAO_COND_WF
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 27/09/2007
--   TARGET : Oracle 10.2.0
--  VERSION : 6.3.1   $Revision: 1 $
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 23-02-2007 | F.v.d. H. | Created.
-- 10/03/2011 | RS        | Upgrade V6.3
-- 11/03/2011 | RS        | Upgrade V6.3 SP1
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
psSource   CONSTANT iapiType.Source_Type := 'AOGENFUNCS';
--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------

   PROCEDURE aoset_connection
   AS
      lsuserid       iapitype.userid_type;
      lsmodulename   iapitype.string_type;
      lnretval       iapitype.errornum_type;
   BEGIN
--   iapigeneral.logInfo('aoSET_CONNECTION',null,'Proberen in te loggen',iapiconstant.INFOLEVEL_3);
      
      lsuserid := USER;
      lsmodulename := 'GENERAL';
      --   example 1
      lnretval := iapigeneral.setconnection (lsuserid, lsmodulename);

      IF (lnretval = iapiconstantdberror.dberr_success)
      THEN
      null;
      ELSE
         lnretval :=
            iapigeneral.adderrortolist ('spec',
                                           'User '
                                        || lsuserid
                                        || ' kan NIET worden ingelogd',
                                        iapispecificationbom.gterrors,
                                        iapiconstant.errormessage_error
                                       );
      END IF;
   END aoset_connection;

   PROCEDURE aosave_property (
      avs_partno         iapitype.partno_type,
      avs_revision       iapitype.revision_type,
      avs_sectionid      iapitype.id_type,
      avs_subsectionid   iapitype.id_type,
      avs_propgroupid    iapitype.id_type,
      avs_propid         iapitype.id_type,
      avs_fieldname      iapitype.stringval_type,
      avf_value          iapitype.float_type
   )
   AS
      lspartno                  iapitype.partno_type            := avs_partno;
      lnrevision                iapitype.revision_type        := avs_revision;
      lnsectionid               iapitype.id_type             := avs_sectionid;
      lnsubsectionid            iapitype.id_type          := avs_subsectionid;
      lnpropertygroupid         iapitype.id_type           := avs_propgroupid;
      lnpropertyid              iapitype.id_type                := avs_propid;
      lnattributeid             iapitype.id_type                  := 0;
      lntestmethodid            iapitype.id_type;
      lnTestMethodSetNo         iapiType.TestMethodSetNo_Type; 
      lfnumeric1                iapitype.float_type;
      lfnumeric2                iapitype.float_type;
      lfnumeric3                iapitype.float_type;
      lfnumeric4                iapitype.float_type;
      lfnumeric5                iapitype.float_type;
      lfnumeric6                iapitype.float_type;
      lfnumeric7                iapitype.float_type;
      lfnumeric8                iapitype.float_type;
      lfnumeric9                iapitype.float_type;
      lfnumeric10               iapitype.float_type;
      lsstring1                 iapitype.propertyshortstring_type;
      lsstring2                 iapitype.propertyshortstring_type;
      lsstring3                 iapitype.propertyshortstring_type;
      lsstring4                 iapitype.propertyshortstring_type;
      lsstring5                 iapitype.propertyshortstring_type;
      lsstring6                 iapitype.propertylongstring_type;
      lsinfo                    iapitype.info_type;
      lsboolean1                iapitype.boolean_type;
      lsboolean2                iapitype.boolean_type;
      lsboolean3                iapitype.boolean_type;
      lsboolean4                iapitype.boolean_type;
      lddate1                   iapitype.date_type;
      lddate2                   iapitype.date_type;
      lncharacteristicid1       iapitype.id_type;
      lncharacteristicid2       iapitype.id_type;
      lncharacteristicid3       iapitype.id_type;
      lstestmethoddetails1      iapitype.boolean_type;
      lstestmethoddetails2      iapitype.boolean_type;
      lstestmethoddetails3      iapitype.boolean_type;
      lstestmethoddetails4      iapitype.boolean_type;
      lnalternativelanguageid   iapitype.languageid_type          := NULL;
      lsalternativestring1      iapitype.propertyshortstring_type := NULL;
      lsalternativestring2      iapitype.propertyshortstring_type := NULL;
      lsalternativestring3      iapitype.propertyshortstring_type := NULL;
      lsalternativestring4      iapitype.propertyshortstring_type := NULL;
      lsalternativestring5      iapitype.propertyshortstring_type := NULL;
      lsalternativestring6      iapitype.propertylongstring_type  := NULL;
      lsalternativeinfo         iapitype.info_type                := NULL;
      lfhandle                  iapitype.float_type               := NULL;
      lqerrors                  iapitype.ref_type;
      lnretval                  iapitype.errornum_type;
      lrerror                   iapitype.errorrec_type;
      lterrors                  iapitype.errortab_type;
      lqinfo                    iapiType.Ref_Type;
   BEGIN
      IF avs_fieldname = 'num_1'
      THEN
         lfnumeric1 := avf_value;
      ELSIF avs_fieldname = 'num_2'
      THEN
         lfnumeric2 := avf_value;
      END IF;

      DBMS_OUTPUT.put_line ('In SaveProperty; sectionID = ' || lnsectionid);
      lnretval :=
         iapispecificationpropertygroup.saveproperty (lspartno,
                                                      lnrevision,
                                                      lnsectionid,
                                                      lnsubsectionid,
                                                      lnpropertygroupid,
                                                      lnpropertyid,
                                                      lnattributeid,
                                                      lntestmethodid,
                                                      lnTestMethodSetNo,
                                                      lfnumeric1,
                                                      lfnumeric2,
                                                      lfnumeric3,
                                                      lfnumeric4,
                                                      lfnumeric5,
                                                      lfnumeric6,
                                                      lfnumeric7,
                                                      lfnumeric8,
                                                      lfnumeric9,
                                                      lfnumeric10,
                                                      lsstring1,
                                                      lsstring2,
                                                      lsstring3,
                                                      lsstring4,
                                                      lsstring5,
                                                      lsstring6,
                                                      lsinfo,
                                                      lsboolean1,
                                                      lsboolean2,
                                                      lsboolean3,
                                                      lsboolean4,
                                                      lddate1,
                                                      lddate2,
                                                      lncharacteristicid1,
                                                      lncharacteristicid2,
                                                      lncharacteristicid3,
                                                      lstestmethoddetails1,
                                                      lstestmethoddetails2,
                                                      lstestmethoddetails3,
                                                      lstestmethoddetails4,
                                                      lnalternativelanguageid,
                                                      lsalternativestring1,
                                                      lsalternativestring2,
                                                      lsalternativestring3,
                                                      lsalternativestring4,
                                                      lsalternativestring5,
                                                      lsalternativestring6,
                                                      lsalternativeinfo,
                                                      lfhandle,
                                                      lqinfo,
                                                      lqerrors
                                                     );

      IF (lnretval = iapiconstantdberror.dberr_success)
      THEN
         DBMS_OUTPUT.put_line (   'Specification property <'
                               || lnpropertyid
                               || '('
                               || lnattributeid
                               || ')'
                               || '> has been saved.'
                              );
      ELSIF (lnretval = iapiconstantdberror.dberr_errorlist)
      THEN
         -- Fetch from cursor variable.
         FETCH lqerrors
         BULK COLLECT INTO lterrors;

         DBMS_OUTPUT.put_line (   'Number of records in error list <'
                               || lterrors.COUNT
                               || '>'
                              );

         IF (lterrors.COUNT > 0)
         THEN
            FOR lnindex IN lterrors.FIRST .. lterrors.LAST
            LOOP
               lrerror := lterrors (lnindex);
               DBMS_OUTPUT.put_line (   lrerror.errortext
                                     || ' ('
                                     || lrerror.errorparameterid
                                     || ')'
                                    );
--                iapigeneral.enablelogging ();
--                iapigeneral.loginfo ('aosave_property',
--                                     lrerror.errortext,
--                                     'id :' || lrerror.errorparameterid,
--                                     iapiconstant.infolevel_3
--                                    );
--                iapigeneral.disablelogging ();
            END LOOP;
         END IF;
      ELSE
         DBMS_OUTPUT.put_line ('Error: ' || iapigeneral.getlasterrortext ());
      END IF;
   END aosave_property;

/*************************************************************

Procedure that runs a bom explosion on a specific part_no

TO BE DONE: Needs checkup:
- needs more input variables for more specific and general use of the bom explosion api
*************************************************************/
   PROCEDURE aorun_bomexplosion (
      anexplosionid   OUT   iapitype.sequence_type,
      aspartno              iapitype.partno_type,
      avi_revision          iapitype.revision_type,
      asprice               BOOLEAN
   )
   IS
      CURSOR lvq_bom_expl
      IS
         SELECT bom_exp_no
           FROM itbomexplosion;

      lnexplosionid   iapitype.sequence_type;
      lnmaxrevision   iapitype.revision_type;
      lqerrors        iapitype.ref_type;
      lterrors        iapitype.errortab_type;
      lrerrors        iapitype.errorrec_type;
      lnretval        iapitype.errornum_type;
      lvi_count       PLS_INTEGER;
      lvb_price       VARCHAR2 (20);
   BEGIN
      IF (avi_revision = 0)
      THEN
         SELECT MAX (revision)
           INTO lnmaxrevision
           FROM specification_header
          WHERE part_no = aspartno;
      ELSE
         lnmaxrevision := avi_revision;
      END IF;

      anexplosionid := NULL;

      -- decide if the price has to be exploded also:
      IF asprice = TRUE
      THEN
         lvb_price := 'IS';
      ELSE
         lvb_price := NULL;
      END IF;

      IF lnmaxrevision IS NOT NULL
      THEN
         SELECT bom_explosion_seq.NEXTVAL
           INTO lnexplosionid
           FROM DUAL;

         anexplosionid := lnexplosionid;

         FOR lrheader IN (SELECT *
                            FROM bom_header
                           WHERE part_no = aspartno
                             AND revision = lnmaxrevision
                             AND ROWNUM = 1)
         LOOP
            lnretval :=
               iapispecificationbom.explode
                                     (lnexplosionid,
                                      lrheader.part_no,
                                      lrheader.revision,
                                      lrheader.plant,
                                      lrheader.alternative,
                                      lrheader.bom_usage,
                                      1,
                                      TRUNC (SYSDATE + 50),             -- + 5
                                      1,
                                      1,          -- 0 = in development status
                                      0,
                                      0,
                                      iapiconstant.explosion_standard,
                                      lvb_price, --'IS', -- hier de price wel!
                                      NULL,
                                      NULL,
                                      NULL,
                                      lqerrors
                                     );

            IF lnretval = iapiconstantdberror.dberr_success
            THEN
               null;
--                DBMS_OUTPUT.put_line (   'bom explosion of part '
--                                      || lrheader.part_no
--                                      || ' successfull'
--                                     );
--                iapigeneral.enablelogging ();
--                iapigeneral.loginfo ('AORUN_BOMEXPLOSION',
--                                     lnmaxrevision,
--                                     'BomExp succesfull for :' || aspartno,
--                                     iapiconstant.infolevel_3
--                                    );
--                iapigeneral.loginfo ('AORUN_BOMEXPLOSION',
--                                     NULL,
--                                     'ExplosionID = ' || lnexplosionid,
--                                     iapiconstant.infolevel_3
--                                    );
--                iapigeneral.disablelogging ();
--             DBMS_OUTPUT.put_line( 'Bom Explosion done successfully for specification '||aspartno|| ' ['||lnmaxrevision||'] ' );
--             DBMS_OUTPUT.PUT_LINE( 'Explosion ID =' || lnexplosionid);
            ELSIF (lnretval = iapiconstantdberror.dberr_errorlist)
            THEN
               -- Fetch from cursos variable:
               FETCH lqerrors
               BULK COLLECT INTO lterrors;

               DBMS_OUTPUT.put_line (   'number of records in error list <'
                                     || lterrors.COUNT
                                     || '>'
                                    );

               IF (lterrors.COUNT > 0)
               THEN
                  iapigeneral.enablelogging ();
                  iapigeneral.loginfo ('aorunbom_explosion',
                                       'errors in explode',
                                       '',
                                       iapiconstant.infolevel_3
                                      );
                  iapigeneral.disablelogging ();

                  FOR lnindex IN lterrors.FIRST .. lterrors.LAST
                  LOOP
                     lrerrors := lterrors (lnindex);
                     DBMS_OUTPUT.put_line (   lrerrors.errortext
                                           || '('
                                           || lrerrors.errorparameterid
                                           || ')'
                                          );
                  END LOOP;
               END IF;
            ELSE
               DBMS_OUTPUT.put_line (   'ERROR: '
                                     || iapigeneral.getlasterrortext ()
                                    );
               DBMS_OUTPUT.put_line ('FOUT In function: apextractdata');
               DBMS_OUTPUT.put_line ('lnretval' || lnretval);
            END IF;
         END LOOP;
      END IF;
   END aorun_bomexplosion;

-----------------------------------------------------------------------------------------------
-- Frank Van den Heuvel
-- 27 march 2007
-- function to add and item to a BoM
--
-- TODO: dynamic sql to convert argument to real column in BOM_ITEM table
-----------------------------------------------------------------------------------------------
   PROCEDURE aoadd_bomitem (
      avp_partno         iapitype.partno_type,
      avn_revision       iapitype.revision_type,
      avp_comppart       iapitype.partno_type,
      avn_comprevision   iapitype.revision_type,
      avn_alternative    NUMBER,
      avs_plant          iapitype.plantno_type,
      avs_field          VARCHAR2,
      avf_quantity       FLOAT
   )
   IS
      lnretval                    iapitype.errornum_type;
      lspartno                    iapitype.partno_type          := avp_partno;
      lnrevision                  iapitype.revision_type      := avn_revision;
      lsplant                     iapitype.plant_type            := avs_plant;
      lnalternative               iapitype.bomalternative_type
                                                           := avn_alternative;
      lnusage                     iapitype.bomusage_type             := 1;
      lnitemnumber                iapitype.bomitemnumber_type        := 0;
      lsalternativegroup          iapitype.bomitemaltgroup_type;
      lnalternativepriority       iapitype.bomitemaltpriority_type;
      lscomponentpartno           iapitype.partno_type        := avp_comppart;
      lncomponentrevision         iapitype.revision_type  := avn_comprevision;
      lscomponentplant            iapitype.plant_type            := avs_plant;
      lnquantity                  iapitype.bomquantity_type   := avf_quantity;
      lsuom                       iapitype.description_type          := 'kg';
      lnconversionfactor          iapitype.bomconvfactor_type;
      lsconverteduom              iapitype.description_type;
      lnyield                     iapitype.bomyield_type             := 1;
      lnassemblyscrap             iapitype.scrap_type;
      lncomponentscrap            iapitype.scrap_type;
      lnleadtimeoffset            iapitype.bomleadtimeoffset_type;
      lnrelevancytocostg          iapitype.boolean_type;
      lnbulkmaterial              iapitype.boolean_type;
      lsitemcategory              iapitype.bomitemcategory_type;
      lsissuelocation             iapitype.bomissuelocation_type;
      lscalculationmode           iapitype.bomitemcalcflag_type;
      lsbomitemtype               iapitype.bomitemtype_type;
      lnoperationalstep           iapitype.bomoperationalstep_type;
      lnmimumquantity             iapitype.bomquantity_type;
      lnmaximumquantity           iapitype.bomquantity_type;
      lnfixedquantity             iapitype.boolean_type;
      lscode                      iapitype.bomitemcode_type;
      lstext1                     iapitype.bomitemlongcharacter_type;
      lstext2                     iapitype.bomitemlongcharacter_type;
      lstext3                     iapitype.bomitemcharacter_type;
      lstext4                     iapitype.bomitemcharacter_type;
      lstext5                     iapitype.bomitemcharacter_type;
      lnnumeric1                  iapitype.bomitemnumeric_type;
      lnnumeric2                  iapitype.bomitemnumeric_type;
      lnnumeric3                  iapitype.bomitemnumeric_type;
      lnnumeric4                  iapitype.bomitemnumeric_type;
      lnnumeric5                  iapitype.bomitemnumeric_type;
      lnboolean1                  iapitype.boolean_type;
      lnboolean2                  iapitype.boolean_type;
      lnboolean3                  iapitype.boolean_type;
      lnboolean4                  iapitype.boolean_type;
      lddate1                     iapitype.date_type;
      lddate2                     iapitype.date_type;
      lncharacteristic1           iapitype.id_type;
      lncharacteristic2           iapitype.id_type;
      lncharacteristic3           iapitype.id_type;
      lnmakeup                    iapitype.boolean_type;
      lsternationalequivalent     iapitype.partno_type           DEFAULT NULL;
      lncallprepost               iapitype.boolean_type             DEFAULT 1;
      lnignorepartplantrelation   iapitype.boolean_type             DEFAULT 0;
      lqerrors                    iapitype.ref_type;
      lrerror                     iapitype.errorrec_type;
      lterrors                    iapitype.errortab_type;
      lqinfo                      iapitype.ref_type;
   BEGIN
      lnretval := iapigeneral.initialisesession ('SIEMENS');
      --DBMS_OUTPUT.put_line ('plant = ' || lsplant);
      lnitemnumber := lnitemnumber + 10;

      IF (lnretval = iapiconstantdberror.dberr_success)
      THEN
         lnretval :=
            iapispecificationbom.additem (asPartNo => lspartno,
                                          anRevision => lnrevision,
                                          asPlant => lsplant,
                                          anAlternative => lnalternative,
                                          anUsage => lnusage,
                                          anItemNumber => lnitemnumber,
                                          asAlternativeGroup => NULL,
                                          anAlternativePriority => 1,
                                          asComponentPartNo => lscomponentpartno,
                                          anComponentRevision => lncomponentrevision,
                                          asComponentPlant =>lscomponentplant,
                                          anQuantity => lnquantity,
                                          asUom => 'kg',
                                          anConversionFactor => NULL,
                                          asConvertedUom => NULL,
                                          anYield => NULL,
                                          anAssemblyScrap => NULL,
                                          anComponentScrap => NULL,
                                          anLeadTimeOffset => NULL,
                                          anRelevancyToCosting => 0,
                                          anBulkMaterial => 0,
                                          asItemCategory => 'L',
                                          asIssueLocation => NULL,
                                          asCalculationMode => NULL,
                                          asBomItemType => NULL,
                                          anOperationalStep => NULL,
                                          anMinimumQuantity => NULL,
                                          anMaximumQuantity => NULL,
                                          anFixedQuantity => 0,
                                          asCode => NULL,
                                          asText1 => NULL,
                                          asText2 => NULL,
                                          asText3 => NULL,
                                          asText4 => NULL,
                                          asText5 => NULL,
                                          anNumeric1 => NULL,
                                          anNumeric2 => NULL,
                                          anNumeric3 => NULL,
                                          anNumeric4 => NULL,
                                          anNumeric5 => NULL,
                                          anBoolean1 => 0,
                                          anBoolean2 => 0,
                                          anBoolean3 => 0,
                                          anBoolean4 => 0,
                                          adDate1 => NULL,
                                          adDate2 => NULL,
                                          anCharacteristic1 => NULL,
                                          anCharacteristic2 => NULL,
                                          anCharacteristic3 => NULL,
                                          anMakeUp => 0,
                                          asInternationalEquivalent => NULL,
                                          anIgnorePartPlantRelation => 0,
                                          anComponentScrapSync => NULL,
                                          aqInfo => lqinfo,
                                          aqErrors => lqerrors
                                         );

         IF (lnretval = iapiconstantdberror.dberr_success)
         THEN
            DBMS_OUTPUT.put_line (   'Item with  PartNo <'
                                  || lspartno
                                  || '['
                                  || lnrevision
                                  || '] and Item Number <'
                                  || lnitemnumber
                                  || '> has been added.'
                                 );
         ELSIF (lnretval = iapiconstantdberror.dberr_errorlist)
         THEN
            -- Fetch from cursor variable.
            FETCH lqerrors
            BULK COLLECT INTO lterrors;

            DBMS_OUTPUT.put_line (   'Number of records in error list <'
                                  || lterrors.COUNT
                                  || '>'
                                 );

            IF (lterrors.COUNT > 0)
            THEN
               FOR lnindex IN lterrors.FIRST .. lterrors.LAST
               LOOP
                  lrerror := lterrors (lnindex);
                  DBMS_OUTPUT.put_line (   lrerror.errortext
                                        || ' ('
                                        || lrerror.errorparameterid
                                        || ')'
                                       );
               END LOOP;
            END IF;
         ELSE
            DBMS_OUTPUT.put_line ('Error: ' || iapigeneral.getlasterrortext
                                                                           ()
                                 );
         END IF;
      ELSE
         DBMS_OUTPUT.put_line ('Error: ' || iapigeneral.getlasterrortext ());
      END IF;
   END aoadd_bomitem;

   PROCEDURE aoremove_bomitem (
      avp_partno          iapitype.partno_type,
      avn_revision        iapitype.revision_type,
      avn_bomitemnumber   iapitype.bomitemnumber_type,
      avs_plant           iapitype.plantno_type,
      avn_alternative     iapitype.numval_type,
      avn_usage           iapitype.bomusage_type
   )
   IS
      lnretval        iapitype.errornum_type;
      lspartno        iapitype.partno_type         := avp_partno;
      lnrevision      iapitype.revision_type       := avn_revision;
      lsplant         iapitype.plant_type          := avs_plant;
      lnalternative   iapitype.bomalternative_type := avn_alternative;
      lnusage         iapitype.bomusage_type       := avn_usage;
      lnitemnumber    iapitype.bomitemnumber_type  := avn_bomitemnumber;
      lqerrors        iapitype.ref_type;
      lrerror         iapitype.errorrec_type;
      lterrors        iapitype.errortab_type;
      lqinfo          iapitype.ref_type;
   BEGIN
      lnretval := iapigeneral.initialisesession ('SIEMENS');

      IF (lnretval = iapiconstantdberror.dberr_success)
      THEN
         lnretval :=
            iapispecificationbom.removeitem (lspartno,
                                             lnrevision,
                                             lsplant,
                                             lnalternative,
                                             lnusage,
                                             lnitemnumber,
                                             lqinfo,
                                             lqerrors
                                            );

         IF (lnretval = iapiconstantdberror.dberr_success)
         THEN
            DBMS_OUTPUT.put_line (   'The Item for PartNo <'
                                  || lspartno
                                  || '['
                                  || lnrevision
                                  || ']> and Plant "'
                                  || lsplant
                                  || '" and Item No <'
                                  || lnitemnumber
                                  || '> has been removed.'
                                 );
         ELSIF (lnretval = iapiconstantdberror.dberr_errorlist)
         THEN
            -- Fetch from cursor variable.
            FETCH lqerrors
            BULK COLLECT INTO lterrors;

            DBMS_OUTPUT.put_line (   'Number of records in error list <'
                                  || lterrors.COUNT
                                  || '>'
                                 );

            IF (lterrors.COUNT > 0)
            THEN
               FOR lnindex IN lterrors.FIRST .. lterrors.LAST
               LOOP
                  lrerror := lterrors (lnindex);
                  DBMS_OUTPUT.put_line (   lrerror.errortext
                                        || ' ('
                                        || lrerror.errorparameterid
                                        || ')'
                                       );
               END LOOP;
            END IF;
         ELSE
            DBMS_OUTPUT.put_line ('Error: ' || iapigeneral.getlasterrortext
                                                                           ()
                                 );
         END IF;
      ELSE
         DBMS_OUTPUT.put_line ('Error: ' || iapigeneral.getlasterrortext ());
      END IF;
   END aoremove_bomitem;

   PROCEDURE aocreate_specification (
      avp_partno          iapitype.partno_type,
      avi_revision        iapitype.numval_type,
      avs_description     iapitype.stringval_type,
      avs_frameno         iapitype.frameno_type,
      avi_framerevision   iapitype.framerevision_type,
      avs_spectype        iapitype.stringval_type,
      avs_accessgroup     iapitype.stringval_type
   )
   IS
      lspartno                 iapitype.partno_type        := avp_partno;
      lnrevision               iapitype.revision_type      := avi_revision;
      lsdescription            iapitype.description_type   := avs_description;
      lscreatedby              iapitype.userid_type        := 'SIEMENS';
      ldplannedeffectivedate   iapitype.date_type      := TRUNC (SYSDATE + 1);
      lsframeid                iapitype.frameno_type       := avs_frameno;
      lnframerevision          iapitype.framerevision_type
                                                         := avi_framerevision;
      lnframeowner             iapitype.owner_type         := 1;
      lnspectypeid             iapitype.id_type;
      lnworkflowgroupid        iapitype.id_type            := 1;
      -- always default
      lnaccessgroupid          iapitype.id_type;
      lnmultilanguage          iapitype.boolean_type       := 1;
      lnuomtype                iapitype.boolean_type       := 0;
      lnmaskid                 iapitype.id_type;
      lqerrors                 iapitype.ref_type;
      lterrors                 iapitype.errortab_type;
      lrerrors                 iapitype.errorrec_type;
      lnretval                 iapitype.errornum_type;
   BEGIN
      lnretval := iapigeneral.initialisesession ('SIEMENS');

      -- get the id of the accessgroup:
      BEGIN
         SELECT access_group
           INTO lnaccessgroupid
           FROM access_group
          WHERE sort_desc = avs_accessgroup;

         SELECT CLASS
           INTO lnspectypeid
           FROM class3
          WHERE sort_desc = avs_spectype;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            iapigeneral.enablelogging ();
            iapigeneral.loginfo ('aocreate_specification',
                                 '',
                                 'acces_group_id or spectype not found',
                                 iapiconstant.infolevel_3
                                );
            iapigeneral.disablelogging ();
      END;

      IF (lnretval = iapiconstantdberror.dberr_success)
      THEN
         -- Get data.
         lnretval :=
            iapispecification.createspecification (lspartno,
                                                   lnrevision,
                                                   lsdescription,
                                                   lscreatedby,
                                                   ldplannedeffectivedate,
                                                   lsframeid,
                                                   lnframerevision,
                                                   lnframeowner,
                                                   lnspectypeid,
                                                   lnworkflowgroupid,
                                                   lnaccessgroupid,
                                                   lnmultilanguage,
                                                   lnuomtype,
                                                   lnmaskid,
                                                   lqerrors
                                                  );

         IF (lnretval = iapiconstantdberror.dberr_success)
         THEN
            DBMS_OUTPUT.put_line (   ' Specification '
                                  || lspartno
                                  || ' ['
                                  || lnrevision
                                  || '] created successfully.'
                                 );
         ELSIF (lnretval = iapiconstantdberror.dberr_errorlist)
         THEN
            -- Fetch data from cursor variable.
            FETCH lqerrors
            BULK COLLECT INTO lterrors;

            -- Number of records in result set.
            DBMS_OUTPUT.put_line (   'Number of records in result set <'
                                  || lterrors.COUNT
                                  || '>'
                                 );
            -- Columns in result set.
            DBMS_OUTPUT.put_line (   'MESSAGETYPE'
                                  || CHR (9)
                                  || iapiconstantcolumn.errorparameteridcol
                                  || CHR (9)
                                  || iapiconstantcolumn.errortextcol
                                 );

            -- Rows in result set.
            IF (lterrors.COUNT > 0)
            THEN
               FOR lnindex IN lterrors.FIRST .. lterrors.LAST
               LOOP
                  lrerrors := lterrors (lnindex);
                  DBMS_OUTPUT.put_line (   lrerrors.messagetype
                                        || CHR (9)
                                        || lrerrors.errorparameterid
                                        || CHR (9)
                                        || lrerrors.errortext
                                       );
               END LOOP;
            END IF;
         ELSE
            DBMS_OUTPUT.put_line ('Error: ' || iapigeneral.getlasterrortext
                                                                           ()
                                 );
         END IF;
      ELSE
         DBMS_OUTPUT.put_line ('Error: ' || iapigeneral.getlasterrortext ());
      END IF;
   END aocreate_specification;

------------------------------------------------------------------------------------------
-- procedure to split the string on a delimiter and return the sub strings

   -- TODO: make more dynamic and work with arrays or vectors
------------------------------------------------------------------------------------------
   PROCEDURE aosplitstring_old (
      avs_stringin           iapitype.stringval_type,
      avs_stringout1   OUT   iapitype.stringval_type,
      avs_stringout2   OUT   iapitype.stringval_type,
      avs_stringout3   OUT   iapitype.stringval_type
   )
   IS
      lvi_level         INTEGER;
      lvi_sublevel      INTEGER;
      lvi_subsublevel   INTEGER;
      lvi_lenstring     INTEGER;
      lvs_charac        VARCHAR2 (10);
      lvi_countdel      INTEGER;
   BEGIN
      -- Split string van bom_item:
      lvi_lenstring := LENGTH (avs_stringin);
      lvi_countdel := 0;
      DBMS_OUTPUT.put_line ('lengte = ' || lvi_lenstring);

      IF lvi_lenstring = 1
      THEN
         lvi_level := avs_stringin;
      ELSIF lvi_lenstring > 1
      THEN
         FOR i IN 1 .. lvi_lenstring
         LOOP
            lvs_charac := SUBSTR (avs_stringin, i, 1);

            IF lvs_charac = '.' OR lvs_charac = ','
            THEN
               lvi_countdel := lvi_countdel + 1;

               IF lvi_countdel = 1
               THEN
                  lvi_level := SUBSTR (avs_stringin, i - (i - 1), i - 1);
                  lvi_sublevel :=
                              SUBSTR (avs_stringin, i + 1, lvi_lenstring - i);
               ELSIF lvi_countdel = 2                                 -- TODO!
               THEN
                  lvi_sublevel := 0;
               END IF;
            END IF;
         END LOOP;
      ELSIF lvi_lenstring = 0 OR lvi_lenstring IS NULL
      THEN
         lvi_level := 0;
      END IF;

      DBMS_OUTPUT.put_line ('lvi_level :' || lvi_level);
      DBMS_OUTPUT.put_line ('lvi_sublevel :' || lvi_sublevel);
      DBMS_OUTPUT.put_line ('lvi_subsublevel :' || lvi_subsublevel);
      avs_stringout1 := lvi_level;
      avs_stringout2 := lvi_sublevel;
      avs_stringout3 := lvi_subsublevel;
   END aosplitstring_old;

   PROCEDURE aostringsplitter (
      avs_stringin    IN       VARCHAR2,                       -- input string
      avi_pos         IN       INTEGER,                        -- token number
      avs_sep         IN       VARCHAR2,                -- separator character
      avs_stringout   OUT      VARCHAR2
   )
   IS
      lc$chaine   VARCHAR2 (32767) := avs_sep || avs_stringin;
      --PC$Sep || PC$Chaine ;
      li$i        PLS_INTEGER;
      li$i2       PLS_INTEGER;
   BEGIN
      li$i := INSTR (lc$chaine, avs_sep, 1, avi_pos);

      IF li$i > 0
      THEN
         li$i2 := INSTR (lc$chaine, avs_sep, 1, avi_pos + 1);

         IF li$i2 = 0
         THEN
            li$i2 := LENGTH (lc$chaine) + 1;
         END IF;

         avs_stringout := SUBSTR (lc$chaine, li$i + 1, li$i2 - li$i - 1);
      ELSE
         avs_stringout := NULL;
      END IF;
   END aostringsplitter;

   PROCEDURE aosplitstring (
      avs_stringin           VARCHAR2,
      avs_stringout1   OUT   VARCHAR2,
      avs_stringout2   OUT   VARCHAR2,
      avs_stringout3   OUT   VARCHAR2,
      avs_stringout4   OUT   VARCHAR2
   )
   IS
      lvi_count   INTEGER;
      lvs_stringout varchar2(100);
   BEGIN
      lvi_count := 1;

      LOOP
         aogenfuncs.aostringsplitter (avs_stringin,
                                      lvi_count,
                                      '.',
                                      lvs_stringout
                                     );
         EXIT WHEN lvs_stringout IS NULL;

         IF lvi_count = 1
         THEN
            avs_stringout1 := lvs_stringout;
         ELSIF lvi_count = 2
         THEN
            avs_stringout2 := lvs_stringout;
         ELSIF lvi_count = 3
         THEN
            avs_stringout3 := lvs_stringout;
         ELSIF lvi_count = 4
         THEN
            avs_stringout4 := lvs_stringout;
         END IF;

         lvi_count := lvi_count + 1;
      END LOOP;
   END aosplitstring;
END aogenfuncs; 
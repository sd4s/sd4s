create or replace PACKAGE BODY          aophr IS
--------------------------------------------------------------------------------
--  PROJECT : Vredestein Enschede
-------------------------------------------------------------------------------
--  PACKAGE : AOPHR
-- ABSTRACT :
--   WRITER : Rody Sparenberg
--     DATE : 20/09/2007
--   TARGET : Oracle 10.2.0 / Interspec 6.3
--  VERSION : av1.0a
--------------------------------------------------------------------------------
--  REMARKS :
--------------------------------------------------------------------------------
--  CHANGES :
--
--  When      | Who       | What
--============|===========|=====================================================
-- 07-02-2007 |F. V. d. H.| Created
-- 10-05-2007 |F. V. d. H.| Finished package
-- 20-09-2007 |RS         | Reviewed package
--            |           | Added aosave_property
--            |           | Added rounding to calculated values
-- 25-09-2007 |TJR        | Rounding to 8 positions
-- 21-05-2008 |RS         | Added 'red' warning for empty density
--                        | Enhanced logging
-- 18-06-2008 | RS        | Enhanced logging & automatic recalculation Mixers
-- 19-06-2008 | RS        | Implemented multi alternatives
--                        | Added DeletePriceFromBoMHeader
-- 10-03-2011 | RS        | Upgrade V6.3
-- 07-04-2011 | RS        | Fixed bug in DeletePriceFromBoMHeader
--------------------------------------------------------------------------------

   --------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

   --------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
psSource   CONSTANT iapiType.Source_Type := 'aophr';   
   --------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

   --------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

   --------------------------------------------------------------------------------
-- functions- and/or procedures-declarations
--------------------------------------------------------------------------------
/* RS20121024 : Obselete, check will be done in aophr.aomixer_calcs
   FUNCTION MoreThanOnePropertyChecked(avp_partno IN VARCHAR2, avn_revision IN NUMBER)
   RETURN BOOLEAN AS
      csMethod     CONSTANT iapiType.Method_Type   := 'MoreThanOnePropertyChecked';
      lnretval              iapitype.errornum_type;
      lvi_records           NUMBER;
      lvp_partno            iapitype.partno_type;
      lvn_revision          iapitype.revision_type;
      lqerrors              iapitype.ref_type;
      gtErrors              ErrorDataTable_Type := ErrorDataTable_Type( );
   
   CURSOR lvq_prop IS
      SELECT *
        FROM avao_phr_calc 
       WHERE part_no = avp_partno 
         AND revision = avn_revision;
   
   BEGIN
      
      iapigeneral.loginfo (psSource, csMethod, 'INFO Start of function');
 
      SELECT COUNT(*)
        INTO lvi_records
        FROM avao_phr_calc 
       WHERE part_no = avp_partno 
         AND revision = avn_revision;
      
      IF lvi_records > 1 THEN
         lnretval := iapigeneral.adderrortolist ('Automatic mixer recalculation',
                                                 'More than 1 property in subsection Mixer checked for <' || avp_partno || '[' || avn_revision || ']>',
                                                 iapispecificationbom.gterrors,
                                                 iapiconstant.errormessage_error
                                                 -- blocks your processing --> roll back
                                                 );
         iapigeneral.loginfo (psSource, csMethod, 'ERROR More than 1 property in subsection Mixer checked for <' || avp_partno || '[' || avn_revision || ']>');
         FOR lvr_prop IN lvq_prop LOOP
            lnretval := iapigeneral.adderrortolist ('Automatic mixer recalculation',
                                                    '      Property ' || lvr_prop.prop_desc || ' in subsection <' || lvr_prop.sub_section || '>',
                                                    iapispecificationbom.gterrors,
                                                    iapiconstant.errormessage_error
                                                    -- blocks your processing --> roll back
                                                    );
             iapigeneral.loginfo (psSource, csMethod, 'ERROR   Property ' || lvr_prop.prop_desc || ' in subsection <' || lvr_prop.sub_section || '>');
          END LOOP;
          iapigeneral.loginfo (psSource, csMethod, 'INFO End of function');
         
          RETURN TRUE;
      END IF;
      
      iapigeneral.loginfo (psSource, csMethod, 'INFO End of function');
      RETURN FALSE;                                
      
   EXCEPTION      
      WHEN OTHERS
      THEN
         iapigeneral.logerror (psSource, csMethod, SQLERRM);
         RETURN FALSE;
   END MoreThanOnePropertyChecked;
*/   
   PROCEDURE aosave_property (
      avs_partno         iapitype.partno_type,
      avs_revision       iapitype.revision_type,
      avs_sectionid      iapitype.id_type,
      avs_subsectionid   iapitype.id_type,
      avs_propgroupid    iapitype.id_type,
      avs_propid         iapitype.id_type,
      avs_fieldname      iapitype.stringval_type,
      avs_value          iapitype.stringval_type
   )
   AS
      csMethod   CONSTANT iapiType.Method_Type   := 'aosave_property';
      lspartno            iapitype.partno_type           := avs_partno;
      lnrevision          iapitype.revision_type         := avs_revision;
      lnsectionid         iapitype.id_type               := avs_sectionid;
      lnsubsectionid      iapitype.id_type               := avs_subsectionid;
      lnpropertygroupid   iapitype.id_type               := avs_propgroupid;
      lnpropertyid        iapitype.id_type               := avs_propid;
      lnattributeid       iapitype.id_type               := 0;
      lntestmethodid      iapitype.id_type;
      lnTestMethodSetNo   iapiType.TestMethodSetNo_Type;
      lvi_itemid          iapitype.id_type;
      lvb_singleprop      iapitype.boolean_type;
      lqproperties        iapitype.ref_type;
      ltproperties        iapitype.sppropertytab_type;
      lrproperty          iapitype.sppropertyrec_type;
      lqerrors            iapitype.ref_type;
      lnretval            iapitype.errornum_type;
      lrerror             iapitype.errorrec_type;
      lterrors            iapitype.errortab_type;
      lqsectionitems      iapitype.ref_type;
      ltsectionitems      iapitype.spsectionitemtab_type;
      lrspsectionitem     iapitype.spsectionitemrec_type;
      lqinfo              iapitype.ref_type;
   BEGIN
      iapigeneral.loginfo (psSource, csMethod, 'INFO Start of function');
      
      iapigeneral.loginfo (psSource, csMethod, 'INFO Save value <' || avs_value || '> to property <' || avs_propid || '> field <' || avs_fieldname || '> on part <' || avs_partno || '[' || avs_revision || ']>');

      IF avs_propgroupid = 0
      THEN
         lvi_itemid := avs_propid;
         lvb_singleprop := 1;
      ELSE
         lvi_itemid := avs_propgroupid;
         lvb_singleprop := 0;
      END IF;

      lnretval :=
         iapispecificationpropertygroup.getproperties
                                          (aspartno                     => avs_partno,
                                           anrevision                   => avs_revision,
                                           ansectionid                  => avs_sectionid,
                                           ansubsectionid               => avs_subsectionid,
                                           anitemid                     => lvi_itemid,
                                           anincludedonly               => 0,
                                           ansingleproperty             => lvb_singleprop,
                                           analternativelanguageid      => NULL,
                                           aqproperties                 => lqproperties,
                                           aqerrors                     => lqerrors
                                          );

      IF (lnretval = iapiconstantdberror.dberr_success)
      THEN
         -- Fetch from cursor variable.
         FETCH lqproperties
         BULK COLLECT INTO ltproperties;

         -- Rows in result set.
         IF (ltproperties.COUNT > 0)
         THEN
            FOR lnindex IN ltproperties.FIRST .. ltproperties.LAST
            LOOP
               lrproperty := ltproperties (lnindex);

               IF     lrproperty.propertyid = avs_propid
                  AND lrproperty.attributeid = 0
               THEN
                  IF lrproperty.included = 0
                  THEN
                     IF lvb_singleprop = 0
                     THEN
                        -- om de property groepen eruit te halen / single properties
                        lnretval :=
                           iapispecificationsection.getsectionitems
                                                           (avs_partno,
                                                            avs_revision,
                                                            avs_sectionid,
                                                            avs_subsectionid,
                                                            0,
                                                            lqsectionitems,
                                                            lqerrors
                                                           );

                        IF (lnretval = iapiconstantdberror.dberr_success)
                        THEN
                           -- Fetch from cursor variable.
                           FETCH lqsectionitems
                           BULK COLLECT INTO ltsectionitems;

                           -- Rows in result set.
                           IF (ltsectionitems.COUNT > 0)
                           THEN
                              FOR lnindex IN
                                 ltsectionitems.FIRST .. ltsectionitems.LAST
                              LOOP
                                 lrspsectionitem := ltsectionitems (lnindex);
                                 
                                 IF     lrspsectionitem.itemtype = 1
                                    AND lrspsectionitem.itemid =
                                                               avs_propgroupid
                                    AND lrspsectionitem.included IN (0, 1)
                                 THEN
                                    lnretval :=
                                       iapispecificationpropertygroup.addpropertygroup
                                                            (avs_partno,
                                                             avs_revision,
                                                             avs_sectionid,
                                                             avs_subsectionid,
                                                             avs_propgroupid,
                                                             0,
                                                             NULL,
                                                             lqinfo,
                                                             lqerrors
                                                            );
                                 END IF;
                              END LOOP;
                           END IF;
                        END IF;

                        lnretval :=
                           iapispecificationpropertygroup.addproperty
                                                            (avs_partno,
                                                             avs_revision,
                                                             avs_sectionid,
                                                             avs_subsectionid,
                                                             avs_propgroupid,
                                                             avs_propid,
                                                             0,
                                                             NULL,
                                                             lqinfo,
                                                             lqerrors
                                                            );
                     END IF;
                  END IF;

                  IF avs_fieldname = 'num_1'
                  THEN
                     lrproperty.numeric1 := avs_value;
                  ELSIF avs_fieldname = 'num_2'
                  THEN
                     lrproperty.numeric2 := avs_value;
                  ELSIF avs_fieldname = 'char_1'
                  THEN
                     lrproperty.string1 := avs_value;
                  ELSIF avs_fieldname = 'char_6'
                  THEN
                     lrproperty.string6 := avs_value;
                  ELSIF avs_fieldname = 'boolean 1'
                  THEN
                     lrproperty.boolean1 := avs_value;
                  ELSIF avs_fieldname = 'association'
                  THEN
                     SELECT characteristic_id
                       INTO lrproperty.characteristicid1
                       FROM characteristic
                      WHERE description = avs_value;
                  ELSIF avs_fieldname = 'association 2'
                  THEN
                     SELECT characteristic_id
                       INTO lrproperty.characteristicid2
                       FROM characteristic
                      WHERE description = avs_value;
                  ELSIF avs_fieldname = 'association 2'
                  THEN
                     SELECT characteristic_id
                       INTO lrproperty.characteristicid3
                       FROM characteristic
                      WHERE description = avs_value;
                  END IF;

                  lnretval :=
                     iapispecificationpropertygroup.saveproperty
                                            (lrproperty.partno,
                                             lrproperty.revision,
                                             lrproperty.sectionid,
                                             lrproperty.subsectionid,
                                             lrproperty.propertygroupid,
                                             lrproperty.propertyid,
                                             lrproperty.attributeid,
                                             lrproperty.testmethodid,
                                             lnTestMethodSetNo,                                             
                                             lrproperty.numeric1,
                                             lrproperty.numeric2,
                                             lrproperty.numeric3,
                                             lrproperty.numeric4,
                                             lrproperty.numeric5,
                                             lrproperty.numeric6,
                                             lrproperty.numeric7,
                                             lrproperty.numeric8,
                                             lrproperty.numeric9,
                                             lrproperty.numeric10,
                                             lrproperty.string1,
                                             lrproperty.string2,
                                             lrproperty.string3,
                                             lrproperty.string4,
                                             lrproperty.string5,
                                             lrproperty.string6,
                                             lrproperty.info,
                                             lrproperty.boolean1,
                                             lrproperty.boolean2,
                                             lrproperty.boolean3,
                                             lrproperty.boolean4,
                                             lrproperty.date1,
                                             lrproperty.date2,
                                             lrproperty.characteristicid1,
                                             lrproperty.characteristicid2,
                                             lrproperty.characteristicid3,
                                             lrproperty.testmethoddetails1,
                                             lrproperty.testmethoddetails2,
                                             lrproperty.testmethoddetails3,
                                             lrproperty.testmethoddetails4,
                                             lrproperty.alternativelanguageid,
                                             lrproperty.alternativestring1,
                                             lrproperty.alternativestring2,
                                             lrproperty.alternativestring3,
                                             lrproperty.alternativestring4,
                                             lrproperty.alternativestring5,
                                             lrproperty.alternativestring6,
                                             lrproperty.alternativeinfo,
                                             NULL,
                                             lqinfo,
                                             lqerrors
                                            );

                  IF (lnretval = iapiconstantdberror.dberr_errorlist)
                  THEN
                     -- Fetch from cursor variable.
                     FETCH lqerrors
                     BULK COLLECT INTO lterrors;

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
                                 iapigeneral.loginfo (psSource, csMethod, lrerror.errortext || 'id :' || lrerror.errorparameterid);
                        END LOOP;
                     END IF;
                  END IF;
               END IF;
            END LOOP;
         END IF;
      ELSIF (lnretval = iapiconstantdberror.dberr_errorlist)
      THEN
         -- Fetch from cursor variable.
         FETCH lqerrors
         BULK COLLECT INTO lterrors;

         IF (lterrors.COUNT > 0)
         THEN
            FOR lnindex IN lterrors.FIRST .. lterrors.LAST
            LOOP
               lrerror := lterrors (lnindex);
            END LOOP;
         END IF;
      END IF;
      
      iapigeneral.loginfo (psSource, csMethod, 'INFO End of function');
      
   END aosave_property;

   PROCEDURE aocheck_type (
      avs_part             iapitype.partno_type,
      avi_revision         iapitype.revision_type,
      flag           OUT   BOOLEAN,
      avs_spectype   OUT   VARCHAR
   )
   IS
      csMethod    CONSTANT iapiType.Method_Type   := 'aocheck_type';
      lvi_spectype       INTEGER;
      lvi_partsourceid   VARCHAR2 (20);
      lvs_part           VARCHAR2 (20);
      lvs_ps_descr       VARCHAR2 (20);             -- partsource description
      lvs_partno         iapitype.partno_type;
      lvb_flag           BOOLEAN;
   BEGIN
      iapigeneral.loginfo (psSource, csMethod, 'INFO Start of function');
      
      lvb_flag := FALSE;

      SELECT class3_id
        INTO lvi_spectype
        FROM specification_header
       WHERE part_no = avs_part AND revision = avi_revision;

      SELECT description
        INTO lvs_ps_descr
        FROM class3
       WHERE CLASS = lvi_spectype;

      IF    lvs_ps_descr = 'XNP compound'
         OR lvs_ps_descr = 'Final mix'
         OR lvs_ps_descr = 'TCE XNP compound'
         OR lvs_ps_descr = 'TCE Final mix'
      THEN
         lvb_flag := TRUE;
      END IF;

      flag := lvb_flag;
      avs_spectype := lvs_ps_descr;
   
      iapigeneral.loginfo (psSource, csMethod, 'INFO End of function');
   
   EXCEPTION
      WHEN OTHERS
      THEN
         iapigeneral.logerror (psSource, csMethod, 'No spectype or description found for <' ||  avs_part || '[' || avi_revision || ']>');        
   END aocheck_type;

   /*
   Procedure that calculates the sum of the entered PHR values
   */
   PROCEDURE aocheck_sum_phr
   IS
      csMethod   CONSTANT iapiType.Method_Type   := 'aocheck_sum_phr';
      lvp_partno         iapitype.partno_type;
      lvs_plant          iapitype.plant_type;
      lvn_revision       iapitype.revision_type;
      lvn_alternative    iapitype.bomalternative_type;
      lvn_bomusagetype   iapitype.bomusage_type;
      lvf_sumphr         FLOAT;
      lvf_delta          FLOAT;
      lvi_itemnumber     INTEGER;

      CURSOR lvq_bomitems
      IS
         SELECT *
           FROM bom_item
          WHERE part_no = lvp_partno
            AND revision = lvn_revision
            AND plant = lvs_plant
            AND alternative = lvn_alternative
            AND bom_usage = lvn_bomusagetype
            AND uom = 'kg';
   BEGIN
   
      iapigeneral.loginfo (psSource, csMethod, 'INFO Start of function');
      
      lvp_partno := iapispecificationbom.gtbomitems (0).partno;
      lvs_plant := iapispecificationbom.gtbomitems (0).plant;
      lvn_revision := iapispecificationbom.gtbomitems (0).revision;
      lvn_alternative := iapispecificationbom.gtbomitems (0).alternative;
      lvn_bomusagetype := iapispecificationbom.gtbomitems (0).bomusage;
      lvf_sumphr := 0;

      iapigeneral.loginfo (psSource, csMethod, 'INFO Part ' || lvp_partno || '[' || lvn_revision || '] Plant ' || lvs_plant || ' Alt. ' || lvn_alternative || ' Usage ' || lvn_bomusagetype);
      
      FOR lvr_bomitem IN lvq_bomitems
      LOOP
         lvf_sumphr := lvf_sumphr + lvr_bomitem.num_5;
      END LOOP;

      /*
      Now placing the sum of the PHR-values into the header of the main bom in the field: MAX_QTY
      */
      UPDATE bom_header
         SET max_qty = ROUND (lvf_sumphr, 3)
       WHERE part_no = lvp_partno
         AND revision = lvn_revision
         AND plant = lvs_plant
         AND alternative = lvn_alternative
         AND bom_usage = lvn_bomusagetype;

   iapigeneral.loginfo (psSource, csMethod, 'INFO End of function');
      
   EXCEPTION
      WHEN OTHERS
      THEN
         iapigeneral.logerror (psSource, csMethod, SQLERRM);                 
   END aocheck_sum_phr;

   PROCEDURE aoaddphrbomitem (avb_runflag OUT BOOLEAN)
   AS
      csMethod   CONSTANT iapiType.Method_Type   := 'aoaddphrbomitem';
      lvp_partno            iapitype.partno_type;
      lvn_revision          iapitype.revision_type;
      lvi_compmaxrevision   iapitype.revision_type;
      lvs_plant             iapitype.plant_type;
      lvn_alternative       iapitype.bomalternative_type;
      lvn_bomusagetype      NUMBER;
      lvi_nrbomitems        iapitype.numval_type;
      lvf_phr               iapitype.float_type;
      lvf_dens              iapitype.float_type;
      lvf_rc                iapitype.float_type;
      lvi_sectionid         iapitype.id_type;
      lvi_pgid              iapitype.id_type;
      lvi_propid            iapitype.id_type;
      lnretval              iapitype.errornum_type;
      lvf_compprice         iapitype.price_type;
      lvi_uomid             iapitype.id_type;
      lvi_itemnumber        INTEGER;
      lqErrors              iapiType.Ref_Type;
      CURSOR lvq_bomitems (
         avs_partno        iapitype.partno_type,
         avn_maxrevision   iapitype.revision_type
      )
      IS
         SELECT *
           FROM bom_item
          WHERE part_no = avs_partno
            AND revision = lvn_revision
            AND plant = lvs_plant
            AND alternative = lvn_alternative
            AND bom_usage = lvn_bomusagetype
            AND uom = 'kg';
   BEGIN
      
      iapigeneral.loginfo (psSource, csMethod, 'INFO Start of function');
      /*
      Now check or next bom levels and corresponding properties:
      */
      lvp_partno := iapispecificationbom.gtbomitems (0).partno;
      lvs_plant := iapispecificationbom.gtbomitems (0).plant;
      lvn_revision := iapispecificationbom.gtbomitems (0).revision;
      lvn_alternative := iapispecificationbom.gtbomitems (0).alternative;
      lvn_bomusagetype := iapispecificationbom.gtbomitems (0).bomusage;
      
      iapigeneral.loginfo (psSource, csMethod, 'INFO Part ' || lvp_partno || '[' || lvn_revision || '] Plant ' || lvs_plant || ' Alt. ' || lvn_alternative || ' Usage ' || lvn_bomusagetype);
      
      BEGIN
         SELECT uom_id
           INTO lvi_uomid
           FROM uom
          WHERE description = 'kg';
      EXCEPTION
         WHEN OTHERS
         THEN
            iapigeneral.logerror (psSource, csMethod, 'ERROR No UoM found with description <kg>');                 
      END;

      SELECT COUNT (*)
        INTO lvi_nrbomitems
        FROM bom_item
       WHERE part_no = lvp_partno
         AND revision = lvn_revision
         AND plant = lvs_plant
         AND alternative = lvn_alternative
         AND bom_usage = lvn_bomusagetype
         AND uom = 'kg';

      avb_runflag := TRUE;

      IF lvi_nrbomitems > 0            -- part does have a number of bom_items
      THEN
         FOR lvr_bomitem IN lvq_bomitems (lvp_partno, lvn_revision)
         LOOP
            BEGIN
               SELECT MAX (revision)
                 INTO lvi_compmaxrevision
                 FROM specification_header
                WHERE part_no = lvr_bomitem.component_part;
            EXCEPTION
               WHEN OTHERS
               THEN
                  iapigeneral.logerror (psSource, csMethod, 'ERROR No revision found for component <' || lvr_bomitem.component_part || '>');                 
            END;

            /*
            Check is sub bom component had a bom of its own:
            */
            SELECT COUNT (*)
              INTO lvi_nrbomitems
              FROM bom_item
             WHERE part_no = lvr_bomitem.component_part
               AND revision = lvi_compmaxrevision
               AND plant = lvs_plant
               AND alternative = lvn_alternative
               AND bom_usage = lvn_bomusagetype
               AND uom = 'kg';

            IF lvi_nrbomitems > 0
            THEN    -- component part has its own bomitems too, use sum of PHR
               /*
                 Update the bom_item table with the header values of the bom item:
               */
               BEGIN
                  SELECT description, to_unit, max_qty
                    INTO lvf_dens, lvf_rc, lvf_phr
                    FROM bom_header
                   WHERE part_no = lvr_bomitem.component_part
                     AND revision = lvi_compmaxrevision
                     AND plant = lvr_bomitem.plant
                     AND alternative = lvr_bomitem.alternative
                     AND bom_usage = lvr_bomitem.bom_usage;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                      iapigeneral.logerror (psSource, csMethod, 'ERROR Dens, rc or PHR not found for <' || lvr_bomitem.component_part || '[' || lvi_compmaxrevision || ']>');                 
               END;

               UPDATE bom_item
                  SET num_4 = ROUND (lvf_rc, 8),
                      num_1 = ROUND (lvf_dens, 8),
                      num_5 = ROUND (lvf_phr, 8)
                WHERE part_no = lvp_partno
                  AND revision = lvn_revision
                  AND plant = lvs_plant
                  AND alternative = lvr_bomitem.alternative
                  AND bom_usage = lvr_bomitem.bom_usage
                  AND item_number = lvr_bomitem.item_number;

               avb_runflag := TRUE;
            ELSIF lvi_nrbomitems = 0
            THEN
               -- Check if PHR is filled in
               IF lvr_bomitem.num_5 IS NULL
               THEN
                  avb_runflag := FALSE;
                  lnretval :=
                     iapigeneral.adderrortolist
                                             ('PHR',
                                              'PHR is not filled in ',
                                              iapispecificationbom.gterrors,
                                              iapiconstant.errormessage_error
                                             );
               END IF;

               -- check if price is filled in
               BEGIN
                  SELECT price
                    INTO lvf_compprice
                    FROM part_cost
                   WHERE part_no = lvr_bomitem.component_part
                     AND plant = lvr_bomitem.plant
                     AND uom = 'kg';
                                          
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                    iapigeneral.loginfo (psSource, csMethod, 'INFO Price not found for <' || lvr_bomitem.component_part || '>');
                  WHEN OTHERS
                  THEN
                     iapigeneral.logerror (psSource, csMethod, 'ERROR Price not found for <' || lvr_bomitem.component_part || '>');                    
               END;

               IF lvf_compprice IS NULL
               THEN
                  NULL;
                  lnretval :=
                     iapigeneral.adderrortolist
                                 ('PHR',
                                     'Price is not filled in for compound :'
                                  || lvr_bomitem.component_part,
                                  iapispecificationbom.gterrors,
                                  iapiconstant.errormessage_info
                                 );
               END IF;

                      /*
                 Now update the properties of the compound:
                */
               /* Update property: Density*/
               BEGIN
                  SELECT property
                    INTO lvi_propid
                    FROM property
                   WHERE description = 'Density';

                  SELECT section_id, property_group, num_1
                    INTO lvi_sectionid, lvi_pgid, lvf_dens
                    FROM specification_prop
                   WHERE part_no = lvr_bomitem.component_part
                     AND revision = lvi_compmaxrevision
                     AND property = lvi_propid;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     iapigeneral.loginfo (psSource, csMethod, 'ERROR Error while retrieving density for <' || lvr_bomitem.component_part || '[' || lvi_compmaxrevision || ']>');
               END;

               IF lvf_dens = 0 OR lvf_dens IS NULL
               THEN
                  avb_runflag := FALSE;
                  lnretval :=
                     iapigeneral.adderrortolist ('PHR', 'Density is 0 or not filled in for compound :' || lvr_bomitem.component_part,
                                                  iapispecificationbom.gterrors,
                                                  iapiconstant.errormessage_error);        

               END IF;
            END IF;
         END LOOP;
      END IF;

      iapigeneral.loginfo (psSource, csMethod, 'INFO End of function');
      
      COMMIT;
   EXCEPTION      
      WHEN OTHERS
      THEN
         iapigeneral.logerror (psSource, csMethod, SQLERRM);
   END aoaddphrbomitem;

/*
Procedure:
-  calculates the conversion factor
-  saves calculated CF in the BOM_header table.
*/
   PROCEDURE aocalc_cf (avn_bomexpno OUT NUMBER)
   IS
      csMethod     CONSTANT iapiType.Method_Type   := 'aocalc_cf';
      lvp_partno            iapitype.partno_type;
      lvp_itemno            iapitype.partno_type;
      lvn_propno            NUMBER;
      lvn_propnotemp        NUMBER;
      lvb_flag              BOOLEAN;
      lvf_density           FLOAT;
      lvf_phr_i             FLOAT;
      lvf_sumphr_dens       FLOAT;
      lvf_sumphr            iapitype.float_type;
      lvf_rubbercontent     FLOAT;
      lvf_sum_i             FLOAT;
      lvf_cf                FLOAT;
      lvi_expid             iapitype.sequence_type;
      lnretval              iapitype.errornum_type;
      lvs_pg                VARCHAR2 (30);
      lvs_pr                VARCHAR2 (30);
      lvi_index             INTEGER;
      lvi_aantal            INTEGER;
      lvi_count             NUMBER;
      lvn_revision          iapitype.revision_type;
      lvi_compmaxrevision   iapitype.revision_type;
      lvs_plant             iapitype.plant_type;
      lvn_alternative       iapitype.bomalternative_type;
      lvn_bomusagetype      NUMBER;
      lvs_spectype          VARCHAR (30);
      lvi_section_id        iapitype.id_type;
      lvi_propertygroupid   iapitype.id_type;
      lvi_uomid             iapitype.id_type;
      lvi_itemnumber        INTEGER;

      CURSOR lvq_bomitems (
         avs_partno        iapitype.partno_type,
         avn_maxrevision   iapitype.revision_type
      )
      IS
         SELECT *
           FROM bom_item
          WHERE part_no = avs_partno
            AND revision = lvn_revision
            AND plant = lvs_plant
            AND alternative = lvn_alternative
            AND bom_usage = lvn_bomusagetype
            AND uom = 'kg';

      CURSOR lvq_bomitemprop (
         part_no    iapitype.partno_type,
         revision   iapitype.revision_type
      )
      IS
         SELECT *
           FROM specification_prop
          WHERE part_no = part_no AND revision = revision;

      CURSOR lvq_properties
      IS
         SELECT description
           FROM property
          WHERE property = lvn_propno;

      no_phr_value          EXCEPTION;
   BEGIN
   
      iapigeneral.loginfo (psSource, csMethod, 'INFO Start of function');

      lvp_partno := iapispecificationbom.gtbomitems (0).partno;
      lvs_plant := iapispecificationbom.gtbomitems (0).plant;
      lvn_revision := iapispecificationbom.gtbomitems (0).revision;
      lvn_alternative := iapispecificationbom.gtbomitems (0).alternative;
      lvn_bomusagetype := iapispecificationbom.gtbomitems (0).bomusage;
      lvf_sumphr_dens := 0;

      iapigeneral.loginfo (psSource, csMethod, 'INFO Part ' || lvp_partno || '[' || lvn_revision || '] Plant ' || lvs_plant || ' Alt. ' || lvn_alternative || ' Usage ' || lvn_bomusagetype);

      BEGIN
         SELECT uom_id
           INTO lvi_uomid
           FROM uom
          WHERE description = 'kg';
      EXCEPTION
         WHEN OTHERS
         THEN
            iapigeneral.logerror (psSource, csMethod, 'ERROR No UoM-id found for <kg>');
      END;

      BEGIN
         SELECT property_group
           INTO lvi_propertygroupid
           FROM property_group
          WHERE description = 'Calculation properties';
      EXCEPTION
         WHEN OTHERS
         THEN
            iapigeneral.logerror (psSource, csMethod, 'ERROR No propertygroup-id found for <Calculation properties>');
      END;

       /*
       Getting the sum of the PHR out of the BoM-header:
      Put there by function: aoCheck_SUM_PHR.
       */
      BEGIN
         SELECT max_qty
           INTO lvf_sumphr
           FROM bom_header
          WHERE part_no = lvp_partno
            AND revision = lvn_revision
            AND plant = lvs_plant
            AND alternative = lvn_alternative
            AND bom_usage = lvn_bomusagetype
            AND plant = lvs_plant;
      EXCEPTION
         WHEN OTHERS
         THEN
            iapigeneral.logerror (psSource, csMethod, 'ERROR Max quantity (=Sum PHR) not found for <' || lvp_partno || '[' || lvn_revision || ']>');
      END;

      -- Calculation of the conversion factor
      lvf_sum_i := 0;
      lvf_cf := 0;
      -- Fist looping over all item in the main BoM:
      lvi_index := 0;

      FOR lvr_bomitem IN lvq_bomitems (lvp_partno, lvn_revision)
      LOOP
         BEGIN
            SELECT MAX (revision)
              INTO lvi_compmaxrevision
              FROM specification_header
             WHERE part_no = lvr_bomitem.component_part;

         EXCEPTION
            WHEN OTHERS
            THEN
               iapigeneral.logerror (psSource, csMethod, 'ERROR Highest revision not found for <' || lvr_bomitem.component_part || '>');               
         END;

         /*
         First getting the PHR of item i
         */
         lvf_phr_i := lvr_bomitem.num_5;
         lvf_rubbercontent := 0;
         lvf_density := 0;
         /*
         Get the correct section_id conform the spectype of the bom_item:
         */        
         aocheck_type (lvr_bomitem.component_part,
                       lvi_compmaxrevision,
                       lvb_flag,
                       lvs_spectype
                      );

        iapigeneral.loginfo (psSource, csMethod, 'INFO BoM-part ' || lvr_bomitem.component_part || '[' || lvi_compmaxrevision || '] has spectype ' || lvs_spectype ); 
        /*
        Getting the fixed values for section and subsection where the RC and dens can be found:
        */
         BEGIN
            IF    lvs_spectype = 'XNP compound'
               OR lvs_spectype = 'Final mix'
               OR lvs_spectype = 'TCE XNP compound'
               OR lvs_spectype = 'TCE Final mix'
            THEN
               SELECT section_id
                 INTO lvi_section_id
                 FROM section
                WHERE description = 'Properties';
            ELSE
               SELECT section_id
                 INTO lvi_section_id
                 FROM section
                WHERE description = 'Chemical and physical properties';
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
              iapigeneral.logerror (psSource, csMethod, 'ERROR No section-id found for <Properties> or <Chemical and physical properties>');
         END;

         --- Check if both (optional) properties are filled:
         BEGIN
            SELECT COUNT (*)
              INTO lvi_count
              FROM specification_prop
             WHERE part_no = lvr_bomitem.component_part
               AND property IN (
                      SELECT property
                        FROM property
                       WHERE description = 'Rubber content'
                          OR description = 'Density')
               AND revision = lvi_compmaxrevision
               AND property_group = lvi_propertygroupid
               AND section_id = lvi_section_id;
               
               iapigeneral.logerror (psSource, csMethod, 'INFO (count = ' || lvi_count || ') Property with description <Rubber content> or <Density> found for part < ' || lvr_bomitem.component_part || '[' || lvi_compmaxrevision || ']>');
         EXCEPTION
            WHEN OTHERS
            THEN
               iapigeneral.logerror (psSource, csMethod, 'ERROR (Optional) Property with description <Rubber content> or <Density> not found for part < ' || lvr_bomitem.component_part || '[' || lvi_compmaxrevision || ']>');
         END;

         IF lvi_count = 2
         THEN
            BEGIN
               SELECT NVL (num_1, 0)
                 INTO lvf_rubbercontent
                 FROM specification_prop
                WHERE part_no = lvr_bomitem.component_part
                  AND property IN (SELECT property
                                     FROM property
                                    WHERE description = 'Rubber content')
                  AND revision = lvi_compmaxrevision
                  AND property_group = lvi_propertygroupid
                  AND section_id = lvi_section_id;

               SELECT NVL (num_1, 0)
                 INTO lvf_density
                 FROM specification_prop
                WHERE part_no = lvr_bomitem.component_part
                  AND property IN (SELECT property
                                     FROM property
                                    WHERE description = 'Density')
                  AND revision = lvi_compmaxrevision
                  AND property_group = lvi_propertygroupid
                  AND section_id = lvi_section_id;
            EXCEPTION
               WHEN OTHERS
               THEN
                  iapigeneral.logerror (psSource, csMethod, 'ERROR Properties with description <Rubber content> and <Density> not found for part < ' || lvr_bomitem.component_part || '[' || lvi_compmaxrevision || ']>');
            END;
         ELSIF lvi_count = 1
         THEN    -- only the density is available; item has no rubber content:
            BEGIN
               SELECT NVL (num_1, 0)
                 INTO lvf_density
                 FROM specification_prop
                WHERE part_no = lvr_bomitem.component_part
                  AND property IN (SELECT property
                                     FROM property
                                    WHERE description = 'Density')
                  AND revision = lvi_compmaxrevision
                  AND property_group = lvi_propertygroupid
                  AND section_id = lvi_section_id;
            EXCEPTION
               WHEN OTHERS
               THEN
                  iapigeneral.logerror (psSource, csMethod, 'ERROR Property with description <Density> not found for part < ' || lvr_bomitem.component_part || '[' || lvi_compmaxrevision || ']>');                  
            END;
         ELSIF lvi_count = 0
         THEN
            NULL;
         END IF;

         -- update bom_item table with the collected rubber content for this BoM-item:
         UPDATE bom_item
            SET num_4 = ROUND (lvf_rubbercontent, 8),
                num_1 = ROUND (lvf_density, 8)
          WHERE part_no = lvp_partno
            AND revision = lvn_revision
            AND plant = lvs_plant
            AND alternative = lvn_alternative
            AND bom_usage = lvn_bomusagetype
            AND item_number = lvr_bomitem.item_number
            AND uom = 'kg';

         lvi_index := lvi_index + 1;
         iapigeneral.loginfo (psSource, csMethod, 'INFO Density ' || lvf_density ); 
         BEGIN
            lvf_sumphr_dens := lvf_sumphr_dens + ((1 / lvf_density) * lvf_phr_i);
         EXCEPTION
         WHEN OTHERS THEN
            iapigeneral.loginfo (psSource, csMethod, 'INFO Division by 0 (Density)' ); 
         END;
      END LOOP;
      iapigeneral.loginfo (psSource, csMethod, 'INFO Sum PHR-Density ' || lvf_sumphr_dens );
      
      BEGIN
         lvf_cf := 1 / (lvf_sumphr_dens);
      EXCEPTION
         WHEN OTHERS THEN
            iapigeneral.loginfo (psSource, csMethod, 'INFO Division by 0 (SumPHR Density)' ); 
      END;
      -- Now saving in the header table:
      UPDATE bom_header
         SET conv_factor = ROUND (lvf_cf, 8)
       WHERE part_no = lvp_partno
         AND revision = lvn_revision
         AND plant = lvs_plant
         AND alternative = lvn_alternative
         AND bom_usage = lvn_bomusagetype;
   EXCEPTION
      WHEN no_phr_value
      THEN
         iapigeneral.loginfo (psSource, csMethod, 'INFO PHR not filled in');

         -- set all quantities to default (1)
         FOR lvr_bomitemup IN lvq_bomitems (lvp_partno, lvn_revision)
         LOOP
            UPDATE bom_item
               SET quantity = 1
             WHERE part_no = lvr_bomitemup.part_no
               AND component_part = lvr_bomitemup.component_part
               AND revision = lvn_revision
               AND plant = lvr_bomitemup.plant
               AND alternative = lvr_bomitemup.alternative
               AND bom_usage = lvr_bomitemup.bom_usage
               AND item_number = lvr_bomitemup.item_number
               AND uom = 'kg';
         END LOOP;
         
         iapigeneral.loginfo (psSource, csMethod, 'INFO End of function');
      
      WHEN OTHERS
      THEN
         iapigeneral.logerror (psSource, csMethod, SQLERRM);
   END aocalc_cf;

/*
Procedure that calculates the sum of the entered PHR values time the Rubber Content

The sum of all PHR*RC should be very close to 100.
When not:  error in table ITERROR
*/
   PROCEDURE aocheck_phr_rc
   IS
      csMethod  CONSTANT iapiType.Method_Type   := 'aocheck_phr_rc';
      lvp_partno         iapitype.partno_type;
      lvs_plant          iapitype.plant_type;
      lvn_revision       iapitype.revision_type;
      lvn_alternative    iapitype.bomalternative_type;
      lvn_bomusagetype   iapitype.bomusage_type;
      lvf_sum_i          FLOAT;
      lvf_delta          FLOAT;
      lvf_phr            iapitype.float_type;
      lvf_rc             iapitype.float_type;
      lnretval           iapitype.errornum_type;
      lvi_itemnumber     INTEGER;

      CURSOR lvq_bomitems
      IS
         SELECT *
           FROM bom_item
          WHERE part_no = lvp_partno
            AND revision = lvn_revision
            AND plant = lvs_plant
            AND alternative = lvn_alternative
            AND bom_usage = lvn_bomusagetype
            AND uom = 'kg';
   BEGIN
      iapigeneral.loginfo (psSource, csMethod, 'INFO Start of function');

      lvp_partno := iapispecificationbom.gtbomitems (0).partno;
      lvs_plant := iapispecificationbom.gtbomitems (0).plant;
      lvn_revision := iapispecificationbom.gtbomitems (0).revision;
      lvn_alternative := iapispecificationbom.gtbomitems (0).alternative;
      lvn_bomusagetype := iapispecificationbom.gtbomitems (0).bomusage;
      lvf_sum_i := 0;

      iapigeneral.loginfo (psSource, csMethod, 'INFO Part ' || lvp_partno || '[' || lvn_revision || '] Plant ' || lvs_plant || ' Alt. ' || lvn_alternative || ' Usage ' || lvn_bomusagetype);

      FOR lvr_bomitem IN lvq_bomitems
      LOOP
         lvf_phr := lvr_bomitem.num_5;
         lvf_rc := lvr_bomitem.num_4 / 100;
         lvf_sum_i := lvf_sum_i + lvf_rc * lvf_phr;
      END LOOP;

      lvf_delta := ABS (100 - lvf_sum_i);

      IF lvf_delta > 0.1
      THEN
         lnretval :=
            iapigeneral.adderrortolist ('PHR',
                                        'Sum (PHR * RC) = ' || lvf_sum_i,
                                        iapispecificationbom.gterrors,
                                        iapiconstant.errormessage_error
                                       -- blocks your processing --> roll back
                                       );
      END IF;
      
      iapigeneral.loginfo (psSource, csMethod, 'INFO End of function');
      
   EXCEPTION
      WHEN OTHERS
      THEN
         iapigeneral.logerror (psSource, csMethod, SQLERRM);
   END aocheck_phr_rc;

   /*
   Stored procedure with which the weighted quantities and prices
   are calculated conform the entered PHR values.
   */
   PROCEDURE aocalc_q_price
   AS
      csMethod     CONSTANT iapiType.Method_Type   := 'aocalc_q_price';
      lvp_partno            iapitype.partno_type;
      lvn_propno            NUMBER;
      lvf_phr               FLOAT;
      lvf_sum_i             FLOAT;
      lvf_delta             FLOAT;
      lvf_cf                FLOAT;
      lvf_qi                FLOAT;
      lvf_basequant         iapitype.float_type;
      lvf_baseqtemp         iapitype.float_type;
      lvf_pricepkg_i        FLOAT;
      lvf_pricepl_i         FLOAT;
      lvn_revision          iapitype.revision_type;
      lvi_compmaxrevision   iapitype.revision_type;
      lvs_plant             iapitype.plant_type;
      lvn_alternative       iapitype.bomalternative_type;
      lvn_bomusagetype      NUMBER;
      lvf_wdtemp            iapitype.float_type;
      lvf_weightdensity     iapitype.float_type;
      lvf_sumphr            iapitype.float_type;
      lvf_weightrc          iapitype.float_type;
      lvf_weightpricekg     iapitype.float_type;
      lvs_currency          iapitype.currency_type;
      lvi_sectionid         iapitype.id_type;
      lvi_pgid              iapitype.id_type;
      lvi_propid            iapitype.id_type;
      lvf_tempquant         iapitype.float_type;
      lvi_uomid             iapitype.id_type;
      lvi_itemnumber        INTEGER;

      CURSOR lvq_bomitems (
         avs_partno        iapitype.partno_type,
         avn_maxrevision   iapitype.revision_type
      )
      IS
         SELECT *
           FROM bom_item
          WHERE part_no = avs_partno
            AND revision = lvn_revision
            AND plant = lvs_plant
            AND alternative = lvn_alternative
            AND bom_usage = lvn_bomusagetype
            AND uom = 'kg';
   BEGIN
      iapigeneral.loginfo (psSource, csMethod, 'INFO Start of function');
      
      -- getting the part_no:
      lvp_partno := iapispecificationbom.gtbomitems (0).partno;
      lvs_plant := iapispecificationbom.gtbomitems (0).plant;
      lvn_revision := iapispecificationbom.gtbomitems (0).revision;
      lvn_alternative := iapispecificationbom.gtbomitems (0).alternative;
      lvn_bomusagetype := iapispecificationbom.gtbomitems (0).bomusage;

      iapigeneral.loginfo (psSource, csMethod, 'INFO Part ' || lvp_partno || '[' || lvn_revision || '] Plant ' || lvs_plant || ' Alt. ' || lvn_alternative || ' Usage ' || lvn_bomusagetype);

      BEGIN
         SELECT uom_id
           INTO lvi_uomid
           FROM uom
          WHERE description = 'kg';
      EXCEPTION
         WHEN OTHERS
         THEN
            iapigeneral.logerror (psSource, csMethod, 'ERROR No UoM-id found for description <kg>');
      END;

      -- First: getting the calculated conversion factor out of the header of the main spec:
      BEGIN
         SELECT conv_factor
           INTO lvf_cf
           FROM bom_header
          WHERE part_no = lvp_partno
            AND revision = lvn_revision
            AND plant = lvs_plant
            AND alternative = lvn_alternative
            AND bom_usage = lvn_bomusagetype;
      EXCEPTION
         WHEN OTHERS
         THEN
            iapigeneral.logerror (psSource, csMethod, 'ERROR No conversion factor found for <' || lvp_partno || '[' || lvn_revision || ']>');
      END;

      /*
      Calculate the weighted density only used for :
      */
      lvf_wdtemp := 0;
      lvf_basequant := 0;
      lvf_baseqtemp := 0;
      lvf_weightrc := 0;
      lvf_weightpricekg := 0;
      --
      -- Weighted density = sum( (1/rho_i *PHR_i) ) / sumPHR
      -- Here is calculated: sum( (1/rho_i *PHR_i) )
     
      iapigeneral.logerror (psSource, csMethod, 'INFO Part ' || lvp_partno || '[' || lvn_revision || ']');

      FOR lvr_bomitem IN lvq_bomitems (lvp_partno, lvn_revision)
      LOOP
        iapigeneral.logerror (psSource, csMethod, 'NUM_1 ' || lvr_bomitem.num_1 || ' NUM_5 ' || lvr_bomitem.num_5 || '.');

        lvf_wdtemp := lvf_wdtemp + ((1 / lvr_bomitem.num_1) * lvr_bomitem.num_5);
        iapigeneral.logerror (psSource, csMethod, 'lvf_wdtemp=' || lvf_wdtemp || '.');
    
      END LOOP;

      /*
       Getting the sum of the entered PHR values from the main header.
       */
      BEGIN
         SELECT max_qty
           INTO lvf_sumphr
           FROM bom_header
          WHERE part_no = lvp_partno
            AND revision = lvn_revision
            AND plant = lvs_plant
            AND alternative = lvn_alternative
            AND bom_usage = lvn_bomusagetype;
      EXCEPTION
         WHEN OTHERS
         THEN
            iapigeneral.logerror (psSource, csMethod, 'ERROR Max quantity (=Sum PHR) not found for <' || lvp_partno || '[' || lvn_revision || ']>');
      END;

      BEGIN
         iapigeneral.logerror (psSource, csMethod, lvp_partno || '[' || lvn_revision || '] ==> ' || lvf_wdtemp || ',' || lvf_sumphr);
   
      -- Here the first factor is divided by the sum of the PHR:
         lvf_weightdensity := 1 / (lvf_wdtemp / lvf_sumphr);
      EXCEPTION
      WHEN OTHERS THEN
            iapigeneral.logerror (psSource, csMethod, 'ERROR Division by 0 (Sum PHR)');     
      END;
      lvf_qi := 0;

      FOR lvr_bomitem IN lvq_bomitems (lvp_partno, lvn_revision)
      LOOP
         BEGIN
            SELECT MAX (revision)
              INTO lvi_compmaxrevision
              FROM specification_header
             WHERE part_no = lvr_bomitem.component_part;
         EXCEPTION
            WHEN OTHERS
            THEN
               iapigeneral.logerror (psSource, csMethod, 'ERROR Highest revision not found for <' || lvr_bomitem.component_part || '>');               
         END;

-------------------------------------------------------
   -- First: Calculate the quantity: Q_i = CF*PHR_i
         lvf_qi := lvf_cf * lvr_bomitem.num_5;
         iapigeneral.loginfo (psSource, csMethod, 'INFO Quantity for part <' || lvr_bomitem.component_part || '> = <' || lvf_qi || '>');
               
---------------------------------------------------------
  -- NOW: calculate the price/liter for this item:
         BEGIN
            SELECT price, currency
              INTO lvf_pricepkg_i, lvs_currency
              FROM part_cost
             WHERE part_no = lvr_bomitem.component_part
               AND price_type = 'IS'
               AND plant = lvs_plant
               AND uom = 'kg';
         
               iapigeneral.loginfo (psSource, csMethod, 'INFO Price and currency found for part <' || lvr_bomitem.component_part || '>');
               lvf_pricepl_i := lvf_pricepkg_i * lvr_bomitem.num_1;
         
         EXCEPTION
            WHEN OTHERS
            THEN
               lvf_pricepkg_i := NULL;
               lvf_pricepl_i  := NULL;
               lvs_currency   := NULL;
               iapigeneral.loginfo (psSource, csMethod, 'INFO No price or currency found for part <' || lvr_bomitem.component_part || '>');               
         END;
                  
         
---------------------------------------------------------
  -- Now calculate the new quantities:

         -- check if quantity is not NULL, otherwise log error
         lvf_tempquant := (lvf_qi * lvr_bomitem.num_1);

         IF lvf_tempquant = NULL
         THEN
            lvf_tempquant := 0;            
         END IF;

         BEGIN
            
            iapigeneral.loginfo (psSource, csMethod, 'INFO <' || lvr_bomitem.part_no || '[' || lvr_bomitem.item_number || ']> Price/kg ' || ROUND (lvf_pricepkg_i, 8) || ' Price/l  ' || ROUND (lvf_pricepl_i, 8));
            iapigeneral.loginfo (psSource, csMethod, 'INFO part  =' || lvr_bomitem.part_no || '[' || lvn_revision || '] Plant=' || lvs_plant || ' Alt.=' || lvn_alternative || ' Usage=' || lvn_bomusagetype);
            
            UPDATE bom_item
               SET num_2 = ROUND (lvf_pricepkg_i, 8),
                   num_3 = ROUND (lvf_pricepl_i, 8),
                   quantity = ROUND (lvf_qi, 8)
             WHERE part_no = lvr_bomitem.part_no
               AND revision = lvn_revision
               AND plant = lvs_plant
               AND alternative = lvn_alternative
               AND bom_usage = lvn_bomusagetype
               AND item_number = lvr_bomitem.item_number
               AND uom = 'kg';
               
            iapigeneral.loginfo (psSource, csMethod, 'INFO Bom item update returned ' || SQL%ROWCOUNT);
               
         EXCEPTION
            WHEN OTHERS
            THEN
               iapigeneral.loginfo (psSource, csMethod, 'ERROR Bomitem not succesfully updated');
         END;

         BEGIN
            -- lvr_bomitem.num_1 = density of bom item:
            iapigeneral.loginfo (psSource, csMethod, 'INFO <' || lvr_bomitem.part_no || '[' || lvr_bomitem.item_number || ']> Base qty <' || lvf_baseqtemp || '>');            
            lvf_baseqtemp := lvf_baseqtemp + (lvf_qi / lvr_bomitem.num_1);
            /*
              Calculate the weighted Rubber Content for this compound itself:
            */
            iapigeneral.loginfo (psSource, csMethod, 'INFO <' || lvr_bomitem.part_no || '[' || lvr_bomitem.item_number || ']> Sum PHR <' || lvf_sumphr || '>');            
            lvf_weightrc := (100 / lvf_sumphr) * 100;
            /*
            Calculate the weighted price/kg and update the part_cost table
            */
            lvf_weightpricekg := lvf_weightpricekg + lvf_pricepkg_i * lvf_qi;
         
         EXCEPTION
            WHEN OTHERS
            THEN
               iapigeneral.logerror (psSource, csMethod, SQLERRM);
         END;

      END LOOP;

      lvf_basequant := lvf_baseqtemp;

      /*
      Performing the updates:
      */
      UPDATE bom_header
         SET description = ROUND (lvf_weightpricekg, 6),
             base_quantity = ROUND (lvf_weightdensity, 8)
       WHERE part_no = lvp_partno
         AND revision = lvn_revision
         AND plant = lvs_plant
         AND alternative = lvn_alternative
         AND bom_usage = lvn_bomusagetype;

      /*
      Update the part_cost table for the price of this compound:
      */
      iapigeneral.loginfo (psSource, csMethod, 'INFO Weight density for <' || lvp_partno || '> = <' || lvf_weightdensity || '>');                     

      UPDATE part_cost
         SET price = ROUND (lvf_weightpricekg / lvf_weightdensity, 8)
       -- price / l parent compound
      WHERE  part_no = lvp_partno
         AND plant = lvs_plant
         AND currency = lvs_currency
         AND uom = 'kg';

        /*
        Now update the properties of the parent compound itself:
       */
      /* Update property: Density*/
      BEGIN
         SELECT property
           INTO lvi_propid
           FROM property
          WHERE description = 'Density';

         SELECT section_id, property_group
           INTO lvi_sectionid, lvi_pgid
           FROM specification_prop
          WHERE part_no = lvp_partno
            AND revision = lvn_revision
            AND property = lvi_propid;

         aosave_property (lvp_partno,
                          lvn_revision,
                          lvi_sectionid,
                          0,
                          lvi_pgid,
                          lvi_propid,
                          'num_1',
                          lvf_weightdensity
                         );
                         
         iapigeneral.loginfo (psSource, csMethod, 'INFO End of function');
      
      EXCEPTION
         WHEN OTHERS
         THEN
            iapigeneral.logerror (psSource, csMethod, 'ERROR Error while retrieving property <density> for <' || lvp_partno || '[' || lvn_revision || ']>');
      END;

      /* Update property: Rubber content*/
      BEGIN
         SELECT property
           INTO lvi_propid
           FROM property
          WHERE description = 'Rubber content';

         SELECT section_id, property_group
           INTO lvi_sectionid, lvi_pgid
           FROM specification_prop
          WHERE part_no = lvp_partno
            AND revision = lvn_revision
            AND property = lvi_propid;
      EXCEPTION
         WHEN OTHERS
         THEN
            iapigeneral.logerror (psSource, csMethod, 'ERROR Error while retrieving property <Rubber content> for <' || lvp_partno || '[' || lvn_revision || ']>');
      END;

      aosave_property (lvp_partno,
                       lvn_revision,
                       lvi_sectionid,
                       0,
                       lvi_pgid,
                       lvi_propid,
                       'num_1',
                       lvf_weightrc
                      );
   EXCEPTION
      WHEN OTHERS
      THEN
         iapigeneral.logerror (psSource, csMethod, SQLERRM);
   END aocalc_q_price;

   PROCEDURE aochange_partsourceoncopy
   IS
      csMethod   CONSTANT iapiType.Method_Type   := 'aochange_partsourceoncopy';
      lvi_spectype        INTEGER;
      lvs_spectypedescr   VARCHAR2 (80);
      lvi_partsourceid    VARCHAR2 (80);
      lvs_part            VARCHAR2 (80);
      lvp_partno          iapitype.partno_type;
      lvn_revision        iapitype.revision_type;
   BEGIN
      iapigeneral.loginfo (psSource, csMethod, 'INFO Start of function');
      
      lvp_partno := iapispecification.gtcopyspec (0).partno;
      lvn_revision := iapispecification.gtcopyspec (0).newrevision;

      SELECT class3_id
        INTO lvi_spectype
        FROM specification_header
       WHERE part_no = lvp_partno AND revision = lvn_revision;

      SELECT description
        INTO lvs_spectypedescr
        FROM class3
       WHERE CLASS = lvi_spectype;

      IF    lvs_spectypedescr = 'XNP compound'
         OR lvs_spectypedescr = 'Final mix'
         OR lvs_spectypedescr = 'TCE XNP compound'
         OR lvs_spectypedescr = 'TCE Final mix'
      THEN
         iapigeneral.loginfo (psSource, csMethod, 'INFO Set part_source to CMD for part =' || lvp_partno );
         
         UPDATE interspc.part
            SET part_source = 'CMD'
          WHERE part_no = lvp_partno;
      END IF;
      
      iapigeneral.loginfo (psSource, csMethod, 'INFO End of function');
 
   EXCEPTION
      WHEN OTHERS
      THEN
         iapigeneral.logerror (psSource, csMethod, SQLERRM);
   END aochange_partsourceoncopy;

   PROCEDURE aochange_partsourceoncreate
   IS
      csMethod   CONSTANT iapiType.Method_Type   := 'aochange_partsourceoncreate';
      lvi_spectype        INTEGER;
      lvs_spectypedescr   VARCHAR2 (80);
      lvi_partsourceid    VARCHAR2 (80);
      lvs_part            VARCHAR2 (80);
      lvp_partno          iapitype.partno_type;
      lvn_revision        iapitype.revision_type;
   BEGIN
      
      iapigeneral.loginfo (psSource, csMethod, 'INFO Start of function');
 
      lvp_partno := iapispecification.gtcreatespec (0).partno;
      lvn_revision := iapispecification.gtcreatespec (0).revision;
      lvs_part := lvp_partno;

      SELECT class3_id
        INTO lvi_spectype
        FROM specification_header
       WHERE part_no = lvp_partno AND revision = lvn_revision;

      SELECT description
        INTO lvs_spectypedescr
        FROM class3
       WHERE CLASS = lvi_spectype;

      IF    lvs_spectypedescr = 'XNP compound'
         OR lvs_spectypedescr = 'Final mix'
         OR lvs_spectypedescr = 'TCE XNP compound'
         OR lvs_spectypedescr = 'TCE Final mix'
      THEN
         
         iapigeneral.loginfo (psSource, csMethod, 'INFO Set part_source to CMD for part =' || lvp_partno );
 
         UPDATE interspc.part
            SET part_source = 'CMD'
          WHERE part_no = lvp_partno;
      ELSE
         NULL;
      END IF;
      
      iapigeneral.loginfo (psSource, csMethod, 'INFO End of function');
 
   EXCEPTION
      WHEN OTHERS
      THEN
         iapigeneral.logerror (psSource, csMethod, 'No spectype or description found for <' ||  lvp_partno || '[' || lvn_revision || ']>');        
   END aochange_partsourceoncreate;

   PROCEDURE aocomp_specs
   AS
   csMethod   CONSTANT iapiType.Method_Type   := 'aocomp_specs';
   BEGIN
   
      NULL;

   EXCEPTION
      WHEN OTHERS
      THEN
          iapigeneral.logerror (psSource, csMethod, SQLERRM);
   END aocomp_specs;

   PROCEDURE aocalcpermixer (
      avp_partno         iapitype.partno_type,
      avn_revision       iapitype.revision_type,
      avi_sectionid      iapitype.id_type,
      avi_subsectionid   iapitype.id_type,
      avf_weighteddens   FLOAT,
      avf_q1             FLOAT
   )
   AS
      csMethod   CONSTANT iapiType.Method_Type   := 'aocalcpermixer';
      lvs_property        iapitype.stringval_type (60);
      lvi_propertyid      iapitype.id_type;
      lvs_propgroup       iapitype.stringval_type (60) := 'Mixerproperties';
      lvi_propgroupid     iapitype.id_type;
      lvf_weightdensity   iapitype.float_type;
      lvf_wdtemp          iapitype.float_type;
      lvf_sumphr          iapitype.float_type;
      lvf_lf              iapitype.float_type;
      lvf_fbw             iapitype.float_type;
      lvf_tbw             iapitype.float_type;
      lvf_tbv             iapitype.float_type;
      lvf_mv              iapitype.float_type;
      lvf_q1              iapitype.float_type;
      lvn_firstindex      iapitype.numval_type;
      lvb_flag            BOOLEAN;
      lvs_spectype        iapitype.stringval_type (60);
      lvs_propmixvol      iapitype.stringval_type (60) := 'Mixervolume';
      lvi_propmixvolid    iapitype.id_type;
      lvs_proplf          iapitype.stringval_type (60) := 'Load factor';
      lvi_proplfid        iapitype.id_type;
      lvs_proptbw         iapitype.stringval_type (60)
                                                      := 'Total batch weight';
      lvi_proptbwid       iapitype.id_type;
      lvs_proptbv         iapitype.stringval_type (60)
                                                      := 'Total batch volume';
      lvi_proptbvid       iapitype.id_type;
      lvs_propfbw         iapitype.stringval_type (60)
                                                  := 'First component weight';
      lvi_propfbwid       iapitype.id_type;
      lvi_uomid           iapitype.id_type;
      lvi_records         NUMBER;
      lnretval            iapitype.errornum_type;
      lqErrors            iapiType.Ref_Type;
      gtErrors            ErrorDataTable_Type := ErrorDataTable_Type( );
  
      
      CURSOR lvq_getprops
      IS
         SELECT *
           FROM specification_prop
          WHERE part_no = avp_partno
            AND revision = avn_revision
            AND sub_section_id = avi_subsectionid                     --700263
            AND boolean_1 = 'Y'
            AND property != lvi_propmixvolid;
   BEGIN
   
      iapigeneral.loginfo (psSource, csMethod, 'INFO Start of function');
 
      BEGIN
         SELECT uom_id
           INTO lvi_uomid
           FROM uom
          WHERE description = 'kg';
      EXCEPTION
         WHEN OTHERS
         THEN
            iapigeneral.logerror (psSource, csMethod, 'ERROR No UoM-id found for description <kg>');
      END;

      -- Get the property ID's of the mixer parameters:
      BEGIN
         SELECT property
           INTO lvi_propmixvolid
           FROM property
          WHERE description = lvs_propmixvol;
      EXCEPTION
         WHEN OTHERS
         THEN
            iapigeneral.logerror (psSource, csMethod, 'ERROR Property not found for description  <' || lvs_propmixvol || '>');
            lvb_flag := FALSE;
      END;

      BEGIN
         SELECT property
           INTO lvi_proplfid
           FROM property
          WHERE description = lvs_proplf;
      EXCEPTION
         WHEN OTHERS
         THEN
            iapigeneral.logerror (psSource, csMethod, 'ERROR Property not found for description  <' || lvs_proplf || '>');
            lvb_flag := FALSE;
      END;

      BEGIN
         SELECT property
           INTO lvi_proptbwid
           FROM property
          WHERE description = lvs_proptbw;
      EXCEPTION
         WHEN OTHERS
         THEN
            iapigeneral.logerror (psSource, csMethod, 'ERROR Property not found for description  <' || lvs_proptbw || '>');
            lvb_flag := FALSE;
      END;

      BEGIN
         SELECT property
           INTO lvi_proptbvid
           FROM property
          WHERE description = lvs_proptbv;
      EXCEPTION
         WHEN OTHERS
         THEN
            iapigeneral.logerror (psSource, csMethod, 'ERROR Property not found for description  <' || lvs_proptbv || '>');
            lvb_flag := FALSE;
      END;

      BEGIN
         SELECT property
           INTO lvi_propfbwid
           FROM property
          WHERE description = lvs_propfbw;
      EXCEPTION
         WHEN OTHERS
         THEN
            iapigeneral.logerror (psSource, csMethod, 'ERROR Property not found for description  <' || lvs_propfbw || '>');
            lvb_flag := FALSE;
      END;

      BEGIN
         SELECT property_group
           INTO lvi_propgroupid
           FROM property_group
          WHERE description = lvs_propgroup;

         lvb_flag := TRUE;
      EXCEPTION
         WHEN OTHERS
         THEN
            iapigeneral.logerror (psSource, csMethod, 'ERROR Propertygroup not found for description  <' || lvs_propgroup || '>');
            lvb_flag := FALSE;
      END;

      BEGIN
         SELECT num_1
           INTO lvf_mv
           FROM specification_prop
          WHERE part_no = avp_partno
            AND revision = avn_revision
            AND sub_section_id = avi_subsectionid
            AND property = lvi_propmixvolid;                         --703240;
      EXCEPTION
         WHEN OTHERS
         THEN
            iapigeneral.logerror (psSource, csMethod, 'ERROR Property <Mixer volume> not found for part <' || avp_partno || '[' || avn_revision || ']>');
            lvb_flag := FALSE;
      END;

      FOR lvr_getprop IN lvq_getprops
      LOOP
         
         IF lvr_getprop.property = lvi_proplfid                      --703224
         THEN                                                  -- load factor
            lvf_lf := lvr_getprop.num_1;
            lvf_tbw := (avf_weighteddens * lvf_mv * lvf_lf) / 100.0;
            lvf_tbv := lvf_tbw / avf_weighteddens;
            lvf_fbw := (avf_q1 * lvf_tbw) / avf_weighteddens;
            /* Total Batch Weight*/
            aosave_property (lvr_getprop.part_no,
                             lvr_getprop.revision,
                             avi_sectionid,
                             lvr_getprop.sub_section_id,
                             lvi_propgroupid,
                             lvi_proptbwid,                          --703320,
                             'num_1',
                             lvf_tbw
                            );
            /*Total Batch Volume*/
            aosave_property (lvr_getprop.part_no,
                             lvr_getprop.revision,
                             avi_sectionid,
                             lvr_getprop.sub_section_id,
                             lvi_propgroupid,
                             lvi_proptbvid,                          --704668,
                             'num_1',
                             lvf_tbv
                            );
            /*First Batch Weight*/
            aosave_property (lvr_getprop.part_no,
                             lvr_getprop.revision,
                             avi_sectionid,
                             lvr_getprop.sub_section_id,
                             lvi_propgroupid,
                             lvi_propfbwid,                          --704669,
                             'num_1',
                             lvf_fbw
                            );
            EXIT;
         ELSIF lvr_getprop.property = lvi_proptbwid                   --703320
         THEN                                            -- total batch weight
            lvf_tbw := lvr_getprop.num_1;
            lvf_lf := (100.0 * lvf_tbw) / (avf_weighteddens * lvf_mv);
            lvf_fbw := (avf_q1 * lvf_tbw) / avf_weighteddens;
            lvf_tbv := lvf_tbw / avf_weighteddens;
            /* Load Factor*/
            aosave_property (lvr_getprop.part_no,
                             lvr_getprop.revision,
                             avi_sectionid,
                             lvr_getprop.sub_section_id,
                             lvi_propgroupid,
                             lvi_proplfid,                           --703224,
                             'num_1',
                             lvf_lf
                            );
            /*Total Batch Volume*/
            aosave_property (lvr_getprop.part_no,
                             lvr_getprop.revision,
                             avi_sectionid,
                             lvr_getprop.sub_section_id,
                             lvi_propgroupid,
                             lvi_proptbvid,                          --704668,
                             'num_1',
                             lvf_tbv
                            );
            /*First Batch Weight*/
            aosave_property (lvr_getprop.part_no,
                             lvr_getprop.revision,
                             avi_sectionid,
                             lvr_getprop.sub_section_id,
                             lvi_propgroupid,
                             lvi_propfbwid,                          --704669,
                             'num_1',
                             lvf_fbw
                            );
            EXIT;
         ELSIF lvr_getprop.property = lvi_proptbvid                   --704668
         THEN                                            -- total batch volume
            lvf_tbv := lvr_getprop.num_1;
            lvf_tbw := lvf_tbv * avf_weighteddens;
            lvf_lf := (100.0 * lvf_tbw) / (avf_weighteddens * lvf_mv);
            lvf_fbw := (avf_q1 * lvf_tbw) / avf_weighteddens;
            /* Load Factor*/
            aosave_property (lvr_getprop.part_no,
                             lvr_getprop.revision,
                             avi_sectionid,
                             lvr_getprop.sub_section_id,
                             lvi_propgroupid,
                             lvi_proplfid,                           --703224,
                             'num_1',
                             lvf_lf
                            );
            /*Total Batch Weight*/
            aosave_property (lvr_getprop.part_no,
                             lvr_getprop.revision,
                             avi_sectionid,
                             lvr_getprop.sub_section_id,
                             lvi_propgroupid,
                             lvi_proptbwid,                          --703320,
                             'num_1',
                             lvf_tbw
                            );
            /*First Batch Weight*/
            aosave_property (lvr_getprop.part_no,
                             lvr_getprop.revision,
                             avi_sectionid,
                             lvr_getprop.sub_section_id,
                             lvi_propgroupid,
                             lvi_propfbwid,                          --704669,
                             'num_1',
                             lvf_fbw
                            );
            EXIT;
         ELSIF lvr_getprop.property = lvi_propfbwid                   --704669
         THEN                                            -- First batch weight
            lvf_fbw := lvr_getprop.num_1;
            lvf_tbw := avf_weighteddens * lvf_fbw / avf_q1;
            lvf_lf := (100.0 * lvf_tbw) / (avf_weighteddens * lvf_mv);
            lvf_tbv := lvf_tbw / avf_weighteddens;
            /* Total Batch Weight*/
            aosave_property (lvr_getprop.part_no,
                             lvr_getprop.revision,
                             avi_sectionid,
                             lvr_getprop.sub_section_id,
                             lvi_propgroupid,
                             lvi_proptbwid,                          --703320,
                             'num_1',
                             lvf_tbw
                            );
            /*Total Batch Volume*/
            aosave_property (lvr_getprop.part_no,
                             lvr_getprop.revision,
                             avi_sectionid,
                             lvr_getprop.sub_section_id,
                             lvi_propgroupid,
                             lvi_proptbvid,                          --704668,
                             'num_1',
                             lvf_tbv
                            );
            /*Load factor*/
            aosave_property (lvr_getprop.part_no,
                             lvr_getprop.revision,
                             avi_sectionid,
                             lvr_getprop.sub_section_id,
                             lvi_propgroupid,
                             lvi_proplfid,                           --703224,
                             'num_1',
                             lvf_lf
                            );
            EXIT;
         END IF;
      END LOOP;
      iapigeneral.loginfo (psSource, csMethod, 'INFO End of function');
 
   END aocalcpermixer;

   PROCEDURE aomixer_calcs(asPartNo       IN iapitype.partno_type := iapispecificationpropertygroup.gtpropertygroups (0).partno,
                           anRevision     IN iapitype.numval_type := iapispecificationpropertygroup.gtpropertygroups (0).revision,
                           anSectionId    IN iapitype.id_type     := iapispecificationpropertygroup.gtpropertygroups (0).sectionid,
                           anSubSectionId IN iapitype.id_type     := iapispecificationpropertygroup.gtpropertygroups (0).subsectionid
)
   AS
      csMethod   CONSTANT iapiType.Method_Type   := 'aomixer_calcs';
      lvn_bomusage         iapitype.bomusage_type;
      lvs_plant            iapitype.plant_type;
      lvn_alternative      NUMBER;
      lvs_mixername        iapitype.stringval_type (60);
      lvs_nameprefix       iapitype.stringval_type (10);
      lvs_property         iapitype.stringval_type (60);
      lvi_propertyid       iapitype.id_type;
      lvs_propgroup        iapitype.stringval_type (60) := 'Mixerproperties';
      lvi_propgroupid      iapitype.id_type;
      lvs_subsection       iapitype.stringval_type (60);
      lvs_section          iapitype.stringval_type (60);
      lvf_weightdensity    iapitype.float_type;
      lvf_wdtemp           iapitype.float_type;
      lvf_sumphr           iapitype.float_type;
      lvf_lf               iapitype.float_type;
      lvf_fbw              iapitype.float_type;
      lvf_tbw              iapitype.float_type;
      lvf_tbv              iapitype.float_type;
      lvf_mv               iapitype.float_type;
      lvf_q1               iapitype.float_type;
      lvn_firstindex       iapitype.numval_type;
      lvb_flag             BOOLEAN;
      lvb_spectypeflag     BOOLEAN;
      lvs_spectype         iapitype.stringval_type (60);
      lvs_propmixvol       iapitype.stringval_type (60) := 'Mixervolume';
      lvi_propmixvolid     iapitype.id_type;
      lvs_proplf           iapitype.stringval_type (60);
      lvi_proplfid         iapitype.id_type;
      lvs_tbw              iapitype.stringval_type (60);
      --:= 'Total batch weight';
      lvi_tbwid            iapitype.id_type;
      lvs_tbv              iapitype.stringval_type (60);
      --:= 'Total batch volume';
      lvi_tbvid            iapitype.id_type;
      lvs_fbw              iapitype.stringval_type (60);
      -- := 'First batch weight';
      lvi_fbwid            iapitype.id_type;
      lvi_uomid            iapitype.id_type;
      lvs_propsec          iapitype.stringval_type (80) := 'Properties';
      lvi_propsecid        iapitype.id_type;
      lvs_pg               iapitype.stringval_type (80)
                                                  := 'Calculation properties';
      lvi_pgid             iapitype.id_type;
      lvs_prop             iapitype.stringval_type (80) := 'Density';
      lvi_propid           iapitype.id_type;
      
      lvn_count            NUMBER;
      lnretval             iapitype.errornum_type;
      
      CURSOR lvq_getprops
      IS
         SELECT *
           FROM specification_prop
          WHERE part_no = asPartNo
            AND revision = anRevision
            AND sub_section_id = anSubSectionId                     --700263
            AND boolean_1 = 'Y'
            AND property != lvi_propmixvolid;

      CURSOR lvq_bomitems
      IS
         SELECT *
           FROM bom_item
          WHERE part_no = asPartNo
            AND revision = anRevision
            AND plant = lvs_plant
            AND alternative = lvn_alternative
            AND bom_usage = lvn_bomusage
            AND uom = 'kg';

      CURSOR lvq_getpropvalue
      IS
         SELECT num_1
           FROM specification_prop
          WHERE part_no = asPartNo
            AND revision = anRevision
            AND property = lvs_property;

lvi_records NUMBER;
BEGIN

      SELECT COUNT(*)
        INTO lvi_records
        FROM avao_phr_calc 
       WHERE part_no = asPartNo 
         AND revision = anRevision
         AND sub_section_id = anSubSectionId;
   

      IF lvi_records > 1 THEN
        lnretval := iapigeneral.adderrortolist ('Automatic mixer recalculation',
                                                'More than 1 property in subsection ' || anSubSectionId || ' checked for <' || asPartNo || '[' || anRevision || ']>',
                                                 iapispecificationpropertygroup.gterrors,
                                                 iapiconstant.errormessage_error
                                                 -- blocks your processing --> roll back
                                                );
        iapigeneral.logerror (psSource, csMethod, 'More than 1 property for ' || asPartNo || '[' || anRevision || '] - ' || anSubSectionId);
      ELSE
          iapigeneral.loginfo (psSource, csMethod, 'INFO Start of function');
          iapigeneral.loginfo (psSource, csMethod, 'INFO PartNo <' || asPartNo || '[' || anRevision || '] Section <' || anSectionId || '> SubSection <' || anSubSectionId || '>.');
          
          aocheck_type (asPartNo, anRevision, lvb_flag, lvs_spectype);

          IF lvb_flag
          THEN
             /*
             BEGIN
                SELECT plant
                  INTO lvs_plant
                  FROM part_plant
                 WHERE part_no = asPartNo;
             EXCEPTION
                WHEN OTHERS
                THEN
                   iapigeneral.logerror (psSource, csMethod, 'ERROR Plant not found for part <' || asPartNo || '>');            
             END;

             BEGIN
                SELECT alternative, bom_usage
                  INTO lvn_alternative, lvn_bomusage
                  FROM bom_header
                 WHERE part_no = asPartNo
                   AND revision = anRevision
                   AND plant = lvs_plant
                   AND alternative = 1 -- alternative = 1
                   AND bom_usage = 1; -- prod 
             EXCEPTION
                WHEN OTHERS
                THEN
                   iapigeneral.logerror (psSource, csMethod, 'ERROR Alternative / Usage not found for part <' || asPartNo || '[' || anRevision || ']> and plant <' || lvs_plant || '>');            
             END;
             */
             SELECT count(*)
               INTO lvn_count
               FROM bom_header
              WHERE part_no = asPartNo
                AND revision = anRevision
                AND alternative = 1 -- alternative = 1
                AND bom_usage = 1; -- prod 

             IF lvn_count > 1 THEN
                iapigeneral.logerror (psSource, csMethod, 'INFO Multiple plants with alternative 1 found for part <' || asPartNo || '[' || anRevision || ']> Calculation impossible');            
                lnretval := iapigeneral.adderrortolist ('Automatic mixer recalculation',
                                                        'Multiple plants with alternative 1 found for part <' || asPartNo || '[' || anRevision || ']> 
    Calculation impossible',
                                                        iapispecificationbom.gterrors,
                                                        iapiconstant.errormessage_error
                                                        -- blocks your processing --> roll back
                                                        );
                lnretval := iapigeneral.adderrortolist ('Automatic mixer recalculation',
                                                        'Multiple plants with alternative 1 found for part <' || asPartNo || '[' || anRevision || ']> 
    Calculation impossible',
                                                        iapispecificationpropertygroup.gterrors,
                                                        iapiconstant.errormessage_error
                                                        -- blocks your processing --> roll back
                                                        );
                ROLLBACK;
             ELSE
                
                BEGIN
                   SELECT alternative, bom_usage, plant
                     INTO lvn_alternative, lvn_bomusage, lvs_plant
                     FROM bom_header
                    WHERE part_no = asPartNo
                      AND revision = anRevision
                      AND alternative = 1 -- alternative = 1
                      AND bom_usage = 1; -- prod 
                                     
                EXCEPTION
                   WHEN OTHERS
                   THEN
                      iapigeneral.logerror (psSource, csMethod, 'ERROR Alternative / Usage / Plant not found for part <' || asPartNo || '[' || anRevision || ']>');
                END;
                
                BEGIN
                   SELECT uom_id
                     INTO lvi_uomid
                     FROM uom
                    WHERE description = 'kg';
                EXCEPTION
                   WHEN OTHERS
                   THEN
                       iapigeneral.logerror (psSource, csMethod, 'ERROR No UoM found with description <kg>');             
                END;
             

           -----------------------------------------------------------------------------------------------------------
          -- If spectype is not ok --> customisation is not allowed to continue
          -----------------------------------------------------------------------------------------------------------
                IF lvb_flag
                THEN
                   BEGIN
                      SELECT NVL (MAX (description), '')
                        INTO lvs_subsection
                        FROM sub_section
                       WHERE sub_section_id = anSubSectionId;
                   EXCEPTION
                      WHEN OTHERS
                      THEN
                          iapigeneral.logerror (psSource, csMethod, 'ERROR No description found for subsection <' || anSubSectionId || '>'); 
                   END;

                   /*
                    Get the quantity of the first BoM-item:
                   */
                   lvn_firstindex := 1;

                   FOR lvr_bomitem IN lvq_bomitems
                   LOOP
                      lvf_q1 := lvr_bomitem.quantity;
                      lvn_firstindex := lvn_firstindex + 1;

                      IF lvn_firstindex > 1
                      THEN
                         iapigeneral.loginfo (psSource, csMethod, 'INFO Exit loop');
                         EXIT;
                      END IF;
                   END LOOP;

                   BEGIN
                      /*
                       Getting the sum of the entered PHR values from the main header.
                      */
                      SELECT max_qty
                        INTO lvf_sumphr
                        FROM bom_header
                       WHERE part_no = asPartNo
                         AND revision = anRevision
                         AND plant = lvs_plant
                         AND alternative = lvn_alternative
                         AND bom_usage = lvn_bomusage;
                         
                   EXCEPTION      
                   WHEN OTHERS THEN
                      iapigeneral.logerror (psSource, csMethod, 'ERROR SumPhr not found');
                   END;
                   /*
                   Get the weighted density out of the header of the main BoM:
                   */
                   lvf_wdtemp := 0;

                   FOR lvr_bomitem IN lvq_bomitems
                   LOOP
                      lvf_wdtemp :=
                             lvf_wdtemp
                             + ((1 / lvr_bomitem.num_1) * lvr_bomitem.num_5);
                   END LOOP;

                   BEGIN
                      lvf_weightdensity := 1.0 / (lvf_wdtemp / lvf_sumphr);
                   EXCEPTION
                      WHEN OTHERS
                      THEN
                          iapigeneral.loginfo (psSource, csMethod, 'ERROR Division by zero : SumPHR = 0');             
                   END;

                   BEGIN
                      SELECT property
                        INTO lvi_propid
                        FROM property
                       WHERE description = lvs_prop;
                   EXCEPTION
                      WHEN OTHERS
                      THEN
                          iapigeneral.logerror (psSource, csMethod, 'ERROR No property found for description <' || lvs_prop || '>');             
                   END;

                   BEGIN
                      SELECT section_id
                        INTO lvi_propsecid
                        FROM section
                       WHERE description = lvs_propsec;
                   EXCEPTION
                      WHEN OTHERS
                      THEN
                          iapigeneral.logerror (psSource, csMethod, 'ERROR No section found for description <' || lvs_propsec || '>'); 
                   END;

                   BEGIN
                      SELECT property_group
                        INTO lvi_pgid
                        FROM property_group
                       WHERE description = lvs_pg;
                   EXCEPTION
                      WHEN OTHERS
                      THEN
                          iapigeneral.logerror (psSource, csMethod, 'ERROR No propertygroup found for description <' || lvs_pg || '>');             
                   END;

                   -- now getting the correcty density with the above collected topography data:
                   BEGIN
                      SELECT num_1
                        INTO lvf_weightdensity
                        FROM specification_prop
                       WHERE part_no = asPartNo
                         AND revision = anRevision
                         AND section_id = lvi_propsecid
                         AND property_group = lvi_pgid
                         AND property = lvi_propid;
                   EXCEPTION
                      WHEN OTHERS
                      THEN
                          iapigeneral.logerror (psSource, csMethod, 'ERROR No weight density found for part <' || asPartNo || '[' || anRevision || ']>');             
                   END;

                    /*
                    Always the same property group:
                   */
                   lvs_propgroup := 'Mixerproperties';

                   BEGIN
                      SELECT property_group
                        INTO lvi_propgroupid
                        FROM property_group
                       WHERE description = lvs_propgroup;
                   EXCEPTION
                      WHEN OTHERS
                      THEN
                          iapigeneral.logerror (psSource, csMethod, 'ERROR No propertygroup found for description <' || lvs_propgroup || '>'); 
                         lvb_flag := FALSE;            
                   END;

          -- Decide here if the mixer is correct:
                   BEGIN
                      SELECT description
                        INTO lvs_mixername
                        FROM sub_section
                       WHERE sub_section_id = anSubSectionId;
                   EXCEPTION
                      WHEN OTHERS
                      THEN
                         iapigeneral.logerror (psSource, csMethod, 'ERROR No section found for description <' || lvs_propsec || '>'); 
                         lvb_flag := FALSE;
                   END;

                   IF lvb_flag = TRUE
                   THEN
          -----------------------------------------------------------------
          -- calculating the mixer properties dynamically for the mixer selected in the specification module:
          -----------------------------------------------------------------
                      IF    SUBSTR (lvs_mixername, 0, 3) = 'Mix'
                         OR SUBSTR (lvs_mixername, 0, 3) = 'MNG'
                         OR SUBSTR (lvs_mixername, 0, 3) = 'MMX'
                      THEN
                         aocalcpermixer (asPartNo,
                                         anRevision,
                                         anSectionId,
                                         anSubSectionId,
                                         lvf_weightdensity,
                                         lvf_q1
                                        );
                      END IF;
                   END IF;
                END IF;
             END IF;
          END IF;
          iapigeneral.loginfo (psSource, csMethod, 'INFO End of function');
      END IF;
      
   EXCEPTION      
      WHEN OTHERS
      THEN
         iapigeneral.logerror (psSource, csMethod, SQLERRM);
   END aomixer_calcs;
/*
FVDH:  08-Feb-2007

Simple procedure that runs the entire customization when the specification is saved.
It runs on the post save function: iapiSpecificationBom.SaveBomItemBulk
*/
   PROCEDURE aorun_phr_cust
   IS
      csMethod   CONSTANT iapiType.Method_Type   := 'aorun_phr_cust';
      lvb_flag              BOOLEAN;
      lvs_spectype          VARCHAR (60);
      lvn_bomexpno          NUMBER;
      lnretval              iapitype.errornum_type;
      lvp_partno            iapitype.partno_type;
      lvs_plant             iapitype.plant_type;
      lvn_revision          iapitype.revision_type;
      lvn_alternative       iapitype.bomalternative_type;
      lvn_bomusage          iapitype.bomusage_type;
      lvb_containsprops     iapitype.boolean_type;
      lvi_nrbomitems        iapitype.numval_type;
      lvi_compmaxrevision   iapitype.revision_type;
      lvi_itemnumber        INTEGER;
      asPreferenceValue     iapiType.PreferenceValue_Type;
 
      CURSOR lvq_bomitems
      IS
         SELECT *
           FROM bom_item
          WHERE part_no = lvp_partno
            AND revision = lvn_revision
            AND plant = lvs_plant
            AND bom_usage = lvn_bomusage
            AND alternative = lvn_alternative
            AND uom = 'kg';
            
      CURSOR lvq_recalc(as_PartNo   IN VARCHAR2,
                        an_Revision IN NUMBER) IS
         SELECT * 
           FROM avao_phr_calc 
          WHERE part_no = as_PartNo
            AND revision = an_Revision;
            
   BEGIN

      --------------------------------------------------------------------------------
      -- Enable database logging when configured
      --------------------------------------------------------------------------------
      lnRetVal := iapiUserPreferences.GETUSERPREFERENCE('General', 'DatabaseLogging', asPreferenceValue);
      IF lnRetVal = iapiConstantDbError.DBERR_SUCCESS AND asPreferenceValue = '1' 
      THEN
         iapiGeneral.EnableLogging;
      END IF;
      
      iapigeneral.loginfo (psSource, csMethod, 'INFO Start of function');
      -- getting the correct partno:
      lvp_partno := iapispecificationbom.gtbomitems (0).partno;
      lvs_plant := iapispecificationbom.gtbomitems (0).plant;
      lvn_revision := iapispecificationbom.gtbomitems (0).revision;
      lvn_bomusage := iapispecificationbom.gtbomitems (0).bomusage;
      lvn_alternative := iapispecificationbom.gtbomitems (0).alternative;

      iapigeneral.loginfo (psSource, csMethod, 'INFO Part ' || lvp_partno || '[' || lvn_revision || '] Plant ' || lvs_plant || ' Alt. ' || lvn_alternative || ' Usage ' || lvn_bomusage);

      -- Only run this customisation for alternative 1
      IF lvn_alternative = 1 THEN
         -- First check if spec is of correct type:
         aocheck_type (lvp_partno, lvn_revision, lvb_flag, lvs_spectype);
         iapigeneral.loginfo (psSource, csMethod, 'INFO spectype=' || lvs_spectype);
         
         IF lvb_flag = TRUE
         THEN
            FOR lvr_bomitem IN lvq_bomitems
            LOOP
               UPDATE bom_item
                  SET quantity = 1
                WHERE part_no = lvp_partno
                  AND revision = lvn_revision
                  AND plant = lvs_plant
                  AND bom_usage = lvn_bomusage
                  AND alternative = lvn_alternative
                  AND item_number = lvr_bomitem.item_number
                  AND uom = 'kg';
            END LOOP;
    
            /*
             Check if the bom_item contains a bom of its own:
             */
            aoaddphrbomitem (lvb_flag);

            IF lvb_flag = TRUE
            THEN
               -- Calculates the sum of the PHR and stores it in the BOM_HEADER:
               aocheck_sum_phr;
               -- Calculating the conversion factor:
               aocalc_cf (lvn_bomexpno);
               -- Calculates the sum of all PHR*RC and checks if ~ 100:
               aocheck_phr_rc;
               -- Calculating the quantities and the new prices / l
               aocalc_q_price;
               
               --RS 24102012 : Will be check during the save of a propertygroup
               --IF NOT MoreThanOnePropertyChecked(lvp_partno, lvn_revision) THEN
               --RS 24102012 : So from here on we will only recalculate all mixer sections
                  FOR lvr_recalc IN lvq_recalc(lvp_partno, lvn_revision) LOOP
                     iapigeneral.loginfo(psSource, csMethod, 'INFO ' || lvr_recalc.part_no || '['|| lvr_recalc.revision || '] (' || lvr_recalc.section || ','|| lvr_recalc.sub_section || ',' || lvr_recalc.pg_desc || ',' || lvr_recalc.prop_desc || ')');
               
                     aomixer_calcs(lvr_recalc.part_no, lvr_recalc.revision, lvr_recalc.section_id, lvr_recalc.sub_section_id);
                  END LOOP;
               --END IF;
            END IF;
         END IF;      
      ELSE
         iapigeneral.loginfo (psSource, csMethod, 'INFO Wrong alternative selected');            
      END IF;
      
      iapigeneral.loginfo (psSource, csMethod, 'INFO End of function');
      
   EXCEPTION
      WHEN OTHERS
      THEN
          iapigeneral.logerror (psSource, csMethod, SQLERRM);
   END aorun_phr_cust;
   
   PROCEDURE aomixer_calcs
   AS
      csMethod   CONSTANT iapiType.Method_Type   := 'aomixer_calcs';
      lnretval              iapitype.errornum_type;
      
   BEGIN
      
      iapigeneral.loginfo (psSource, csMethod, 'INFO Start of function');
 
      aomixer_calcs(iapispecificationpropertygroup.gtpropertygroups (0).partno,
                    iapispecificationpropertygroup.gtpropertygroups (0).revision,
                    iapispecificationpropertygroup.gtpropertygroups (0).sectionid,
                    iapispecificationpropertygroup.gtpropertygroups (0).subsectionid);
      
      iapigeneral.loginfo (psSource, csMethod, 'INFO End of function');
      
   EXCEPTION      
      WHEN OTHERS
      THEN
         iapigeneral.logerror (psSource, csMethod, SQLERRM);
   END;
 --------------------------------------------------------------------------------
-- PROCEDURE : DeletePriceFromBoMHeader
--  ABSTRACT : This function will clear the field base-qty of the BoM-header
--------------------------------------------------------------------------------
--    WRITER : Rody Sparenberg
--  REVIEWER :
--      DATE : 19/06/2008
--    TARGET :
--   VERSION : 6.3.0.1.0
--------------------------------------------------------------------------------
--             Errorcode              | Description
--====================================|=========================================
--    ERRORS :                        |
--------------------------------------------------------------------------------
--   REMARKS : -
--------------------------------------------------------------------------------
--   CHANGES :
--
-- When       | Who       | What
--============|===========|=====================================================
-- 19/06/2008 | RS        | Created
-- 10/03/2011 | RS        | Upgrade V6.3
--------------------------------------------------------------------------------
PROCEDURE DeletePriceFromBoMHeader IS

--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------
csMethod CONSTANT iapiType.Method_Type := 'DeletePriceFromBoMHeader';

--------------------------------------------------------------------------------
-- Cursors
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
lnRetVal            iapiType.ErrorNum_Type;

--------------------------------------------------------------------------------
-- Local functions and/or procedures
--------------------------------------------------------------------------------

BEGIN
   iapiGeneral.LogInfo(psSource, csMethod, 'Start of function');
   iapiGeneral.LogInfo(psSource, csMethod, 'PartNo =' || iapiSpecificationValidation.gsPartNo || ' [' || iapiSpecificationValidation.gnRevision || ']');

   UPDATE bom_header
      SET description = NULL  -- price 
    WHERE part_no = iapiSpecificationValidation.gsPartNo
      AND revision = iapiSpecificationValidation.gnRevision
      AND alternative = 1 -- alternative
      AND bom_usage = 1;  -- prod

   IF SQL%ROWCOUNT > 0 THEN
      iapiGeneral.LogInfo(psSource, csMethod, 'Specification ' || iapiSpecificationValidation.gsPartNo || '[' || iapiSpecificationValidation.gnRevision || '] BoM header updated succesfully' );
   ELSE
      iapiGeneral.LogInfo(psSource, csMethod, 'Specification ' || iapiSpecificationValidation.gsPartNo || '[' || iapiSpecificationValidation.gnRevision || '] BoM header not succesfully updated !' );
   END IF;
   
   UPDATE bom_item
      SET NUM_2 = NULL,  -- price/kg  
          NUM_3 = NULL   -- price/l
    WHERE part_no = iapiSpecificationValidation.gsPartNo
      AND revision = iapiSpecificationValidation.gnRevision
      AND alternative = 1 -- alternative
      AND bom_usage = 1;  -- prod

   IF SQL%ROWCOUNT > 0 THEN
      iapiGeneral.LogInfo(psSource, csMethod, 'Specification ' || iapiSpecificationValidation.gsPartNo || '[' || iapiSpecificationValidation.gnRevision || '] BoM items updated succesfully' );
   ELSE
      iapiGeneral.LogInfo(psSource, csMethod, 'Specification ' || iapiSpecificationValidation.gsPartNo || '[' || iapiSpecificationValidation.gnRevision || '] BoM items not succesfully updated !' );
   END IF;
 
  iapiGeneral.LogInfo(psSource, csMethod, 'End of function');

EXCEPTION
   WHEN OTHERS THEN
      iapiGeneral.LogError(psSource, csMethod, SQLERRM);
END DeletePriceFromBoMHeader;
  
END;